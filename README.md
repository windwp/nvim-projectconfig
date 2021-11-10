## nvim-projectconfig

Load config depend on current directory.

### Sample

current directory is `/home/abcde/projects/awesome/`.
you open vim in **awesome** directory.

It will load a config file from `~/.config/nvim/projects/awesome.lua` or `~/.config/nvim/projects/awesome.vim`

this config save outside of your git repo and you don't need to check security on that file.
It work perfect if you are working on monorepo.


## Install
``` vim
  Plug 'windwp/nvim-projectconfig'
```
then add this in your init.lua

```lua
require('nvim-projectconfig').setup()
```

## FAQ
*  A command to  open project config file

Command: **EditProjectConfig**

 * I want to change projects-config directory

``` lua

require('nvim-projectconfig').setup({
  project_dir = "~/.config/projects-config/",
})

```

 * I have 2 directory have same name.
 
``` lua
require('nvim-projectconfig').setup({
  project_dir = "~/.config/projects-config/",
  project_config={
    {
      -- full path of your project or a lua regex string
        path = "projectconfig", 
        -- use a function or a path to config file 
        config = function ()
            print("abcde")
        end
    },
  },
  silent = false,-- display message after load config file
})
```


 * I want to change my directory inside neovim and load project config.

 ``` lua
require('nvim-projectconfig').setup({autocmd=true})

 ```


## Bonus
a function to load and save json file and do whatever you want.
```lua
require('nvim-projectconfig').load_json()
require('nvim-projectconfig').save_json(data)
```

