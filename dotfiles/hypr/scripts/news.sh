#!/usr/bin/env bash

# === Extraction functions ===

extract_generic_feed() {
  local url="$1"
  local content
  content=$(curl -s "$url")

  # Skip if content is empty or doesn't start with < (likely not XML)
  [[ -z "$content" || "$content" != \<* ]] && return

  xmlstarlet sel -t -m '//item' \
    -v 'concat(title, "|||", pubDate)' -n <<< "$content" | \
    while IFS= read -r line; do
      xmlstarlet unesc <<< "$line"
    done
}

extract_bbc_feed() {
  local url="$1"
  local content
  content=$(curl -s "$url")

  # Skip if content is empty or doesn't start with < (likely not XML)
  [[ -z "$content" || "$content" != \<* ]] && return

  xmlstarlet sel -t -m '//item' \
    -v 'concat(title, "|||", pubDate)' -n <<< "$content" | \
    while IFS= read -r line; do
      xmlstarlet unesc <<< "$line"
    done
}

extract_google_news_feed() {
  local url="$1"
  curl -s "$url" | \
  local content
  content=$(curl -s "$url")

  # Skip if content is empty or doesn't start with < (likely not XML)
  [[ -z "$content" || "$content" != \<* ]] && return

  xmlstarlet sel \
    -N ns="http://www.sitemaps.org/schemas/sitemap/0.9" \
    -N news="http://www.google.com/schemas/sitemap-news/0.9" \
    -t -m '//ns:url' \
    -v 'concat(news:news/news:title, "|||", news:news/news:publication_date)' -n | \
  while IFS= read -r line; do
    xmlstarlet unesc <<< "$line"
  done
}

# === Feeds: URL|TYPE|SOURCE ===
# TYPE: generic, bbc, google_news

declare -a feeds=(
  "https://feeds.skynews.com/feeds/rss/uk.xml|generic|Sky News"
  "https://feeds.bbci.co.uk/news/rss.xml?edition=uk|bbc|BBC News"
  "https://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml?edition=uk|bbc|BBC News · Entertainment"
  "https://feeds.bbci.co.uk/news/world/rss.xml?edition=uk|bbc|BBC News · World"
  "https://novacapsfans.com/feed/|generic|NoVa Caps"
  #"https://www.theguardian.com/sitemaps/news.xml|google_news|The Guardian"
  "https://rss.nytimes.com/services/xml/rss/nyt/World.xml|generic|NY Times"
)

# === Cache Settings ===
CACHE_FILE="/tmp/news_cache.json"
CACHE_TTL=1200  # seconds (20 minutes)

load_cache() {
  [[ -f "$CACHE_FILE" ]] || return 1
  local cache_age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") ))
  (( cache_age < CACHE_TTL )) || return 1

  mapfile -t titles < <(jq -r '.titles[]' "$CACHE_FILE")
  mapfile -t pubdates < <(jq -r '.pubdates[]' "$CACHE_FILE")
  mapfile -t sources < <(jq -r '.sources[]' "$CACHE_FILE")
  return 0
}

save_cache() {
  # Prevent saving if arrays are empty or mismatched
  if (( ${#titles[@]} == 0 || ${#pubdates[@]} == 0 || ${#sources[@]} == 0 )); then
    return
  fi

  if (( ${#titles[@]} != ${#pubdates[@]} || ${#titles[@]} != ${#sources[@]} )); then
    return
  fi

  jq -n \
    --argjson titles "$(printf '%s\n' "${titles[@]}" | jq -R . | jq -s .)" \
    --argjson pubdates "$(printf '%s\n' "${pubdates[@]}" | jq -R . | jq -s .)" \
    --argjson sources "$(printf '%s\n' "${sources[@]}" | jq -R . | jq -s .)" \
    '{titles: $titles, pubdates: $pubdates, sources: $sources}' \
    > "$CACHE_FILE"
}

# === Main ===

declare -a titles=()
declare -a pubdates=()
declare -a sources=()

if ! load_cache; then
  titles=()
  pubdates=()
  sources=()

  for feed in "${feeds[@]}"; do
    IFS='|' read -r url type source <<< "$feed"

    case "$type" in
      bbc)
        mapfile -t feed_lines < <(extract_bbc_feed "$url")
        ;;
      google_news)
        mapfile -t feed_lines < <(extract_google_news_feed "$url")
        ;;
      *)
        mapfile -t feed_lines < <(extract_generic_feed "$url")
        ;;
    esac

    for line in "${feed_lines[@]}"; do
      [[ -z "$line" ]] && continue
      title="${line%%|||*}"
      pubdate="${line#*|||}"

      # Skip titles longer than 16 words
      word_count=$(wc -w <<< "$title")
      (( word_count > 16 )) && continue

      # Validate date parsing
      if ! pubdate_epoch=$(date -d "$pubdate" +%s 2>/dev/null); then
        continue
      fi

      one_day_ago=$(( $(date +%s) - 86400 ))
      (( pubdate_epoch >= one_day_ago )) || continue

      titles+=("$title")
      pubdates+=("$pubdate")
      sources+=("$source")
    done
  done
  save_cache
fi

# Select a random article
select_random_title_info() {
  if [[ ${#titles[@]} -eq 0 ]]; then
    return 1
  fi

  local idx=$((RANDOM % ${#titles[@]}))

  selected_raw_title="${titles[idx]}"
  selected_raw_pubdate="${pubdates[idx]}"
  selected_raw_source="${sources[idx]}"
}

select_random_title_info

print_selected_info() {
  if [[ -z "$selected_raw_title" || -z "$selected_raw_pubdate" || -z "$selected_raw_source" ]]; then
    echo "<b><big>No recent articles available.</big></b>"
    echo "<small><span color='gray'>Retrying on next cycle.</span></small>"
    return 1
  fi

  # Wrap title every 8 words
  local word
  local word_count=0
  local line=""
  wrapped_title=""

  for word in $selected_raw_title; do
    line+="$word "
    ((word_count++))
    if (( word_count == 8 )); then
      wrapped_title+="$line"$'\n'
      line=""
      word_count=0
    fi
  done
  [[ -n "$line" ]] && wrapped_title+="$line"$'\n'

  wrapped_title=$(echo "$wrapped_title" | sed '/^[[:space:]]*$/d')

  # Format time to e.g. "3:11 PM"
  local time
  time=$(date -d "$selected_raw_pubdate" "+%l:%M %p" 2>/dev/null | sed 's/^ *//' | tr '[:lower:]' '[:upper:]')

  echo "<b><big>$wrapped_title</big></b>"
  echo "<small><span color='gray'>$time · $selected_raw_source</span></small>"
}

print_selected_info
