## nvim-projectconfig

Load config depend on current directory.

### Sample

current directory is `/home/abcde/projects/awesome/`.
you open vim in **awesome** directory.

It will load a config file from `~/.config/nvim/projects/awesome.lua` or `~/.config/nvim/projects/awesome.vim`

## Install
``` vim
  Plug 'windwp/nvim-projectconfig'
```
then add this in your init.lua

```lua
require('nvim-projectconfig').load_project_config()
```




## FAQ
*  A command to  open project config file

 ``` lua
lua.require("nvim-projectconfig").edit_project_config()

```

 * I want to change projects-config directory

``` lua

require('nvim-projectconfig').load_project_config({
  project_dir = "~/.config/projects-config/",
})

```
 * I have 2 directory have same name.

  Currently the only solution is change your directory name :)

 * I usually change my directory inside neovim

 ``` lua
vim.cmd[[
  autocmd DirChanged * lua require('nvim-projectconfig').load_project_config()
]]

 ```
