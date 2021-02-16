local M = {}


local project_dir="~/.config/nvim/projects/"

function M.load_project_config(opts)
  opts = opts or{}
  local silent = true

  project_dir = opts.project_dir or project_dir
  if opts.silent ~= nil then silent = opts.silent end
  project_dir=vim.fn.expand(project_dir)
  if vim.fn.isdirectory(project_dir) == 0 then
    vim.fn.mkdir(project_dir, 'p')
  end

  local rootFolder = string.match(vim.loop.cwd(),"[^%/]+$")

  if rootFolder then
    local projectfile =project_dir .. rootFolder .. ".lua"
    if  vim.fn.filereadable(projectfile) == 1 then
      if silent == false then
        print("load " .. vim.inspect(projectfile))
      end
      vim.cmd("luafile " .. projectfile)
      return
    end
    projectfile = project_dir .. rootFolder .. ".vim"
    if  vim.fn.filereadable(projectfile) == 1 then
      if silent == false then
        print("load " .. vim.inspect(projectfile))
      end
      vim.cmd("source " .. projectfile)
      return
    end
  end
end

function M.edit_project_config()
  local rootFolder = string.match(vim.loop.cwd(), "[^%/]+$")
  if rootFolder then
    local projectfile = project_dir .. rootFolder .. ".vim"
    if vim.fn.filereadable(projectfile) ~= 1 then
      projectfile = project_dir .. rootFolder .. ".lua"
    end
    vim.cmd("edit " .. projectfile)
  end
end

return M
