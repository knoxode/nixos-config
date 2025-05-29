#!/usr/bin/env bash

tmpfile=$(mktemp)

# BBC UK
w3m "http://feeds.bbci.co.uk/news/world/us_and_canada/rss.xml?edition=int" -dump |
  grep "<title><!" | cut -c 29- | rev | cut -c 12- | rev | sed -n 2,11p >> "$tmpfile"

# NY Post General
w3m "https://nypost.com/news/feed/" -dump |
  sed 1,24d | grep "<title>" | cut -c 11- | rev | cut -c 9- | rev | sed -n 1,10p >> "$tmpfile"

# The Onion
w3m "https://www.theonion.com/c/news-in-brief" -dump > onion.txt
sed 1,24d onion.txt > onion2.txt
grep -n "News in Brief" onion2.txt | cut -f1 -d: | head -n 10 | while read i; do
  sed -n "$((i+2))p" onion2.txt >> "$tmpfile"
done
rm onion.txt onion2.txt

# BBC Tech
w3m "http://feeds.bbci.co.uk/news/technology/rss.xml" -dump |
  grep "<title><!" | cut -c 29- | rev | cut -c 12- | rev | sed -n 2,11p >> "$tmpfile"

# NY Post Business
w3m "https://nypost.com/business/feed/" -dump |
  sed 1,24d | grep "<title>" | cut -c 11- | rev | cut -c 9- | rev | sed -n 1,10p >> "$tmpfile"

# Output one random headline, split into two lines after 7 words
headline=$(shuf -n 1 "$tmpfile")
words=($headline)

# Split into chunks of 7 words per line
for ((i = 0; i < ${#words[@]}; i += 7)); do
  echo "${words[@]:i:7}"
done

rm "$tmpfile"
