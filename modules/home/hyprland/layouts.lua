-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
  general = {
    layout = "scrolling",
  },
  dwindle = {
    preserve_split = true, -- You probably want this
  },
  master = {
    new_status = "master",
  },
  scrolling = {
    column_width = 0.5,
  },
})
