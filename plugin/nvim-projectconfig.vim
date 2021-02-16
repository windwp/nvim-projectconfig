command! -nargs=* EditProjectConfig call v:lua.require("nvim-projectconfig").edit_project_config()
