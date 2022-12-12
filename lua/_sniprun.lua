local ok, sniprun = pcall(require, "sniprun")
if not ok then
	return
end

sniprun.setup({
	live_mode_toggle = "enable",
})
