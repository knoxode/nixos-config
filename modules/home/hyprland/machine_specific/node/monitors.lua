-- Static monitor rules for node.
--
-- Declarative rules are part of the configuration itself: they are
-- re-evaluated on every load and reload, and re-matched against
-- hotplugged outputs, unlike runtime hl.monitor() calls that depend on
-- hl.get_monitors() state and enumeration order.
--
-- The Acer is matched by description prefix (stable across ports),
-- not by serial number or connector name.

hl.monitor({
  output = "desc:Acer Technologies XB273U GX",
  mode = "highrr",
  position = "auto",
  scale = 1,
  bitdepth = 10,
  cm = "hdr",
  supports_hdr = true,
  sdrbrightness = 2,
  sdrsaturation = 0.98,
  sdr_min_luminance = 0,
  sdr_max_luminance = 400,
})

-- Documented fallback rule: applies to any output not matched above.
-- auto-left places it to the left of the Acer regardless of which
-- output is enumerated first (a leading auto-left would be ignored).
hl.monitor({
  output = "",
  mode = "highrr",
  position = "auto-left",
  scale = 1,
})
