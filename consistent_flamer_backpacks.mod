return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`consistent_flamer_backpacks` encountered an error loading the Darktide Mod Framework.")

		new_mod("consistent_flamer_backpacks", {
			mod_script       = "consistent_flamer_backpacks/scripts/mods/consistent_flamer_backpacks/consistent_flamer_backpacks",
			mod_data         = "consistent_flamer_backpacks/scripts/mods/consistent_flamer_backpacks/consistent_flamer_backpacks_data",
			mod_localization = "consistent_flamer_backpacks/scripts/mods/consistent_flamer_backpacks/consistent_flamer_backpacks_localization",
		})
	end,
	packages = {},
}
