local M = {}

local config = {
  silent = true,
  autocmd = true,
  project_dir = vim.fn.stdpath("config") .. "/projects/",
  project_config = {},
}

M.setup = function(opts)
  config = vim.tbl_extend("force", config, opts or {})
  if not config.project_dir:match("/$") then
    config.project_dir = config.project_dir .. "/"
  end
  if config.autocmd then
    vim.api.nvim_create_autocmd("DirChanged", {
      group = vim.api.nvim_create_augroup("NvimProjectConfig", { clear = true }),
      pattern = "*",
      callback = function()
        M.load_project_config()
      end,
    })
  end
  M.load_project_config()
end

local function execute(file_path)
  file_path = vim.fn.expand(file_path)
  if vim.fn.filereadable(file_path) == 1 then
    if config.silent == false then
      vim.defer_fn(function()
        vim.notify("[project-config] - " .. vim.fn.fnamemodify(file_path, ":t:r"))
      end, 100)
    end
    if file_path:match("%.vim$") then
      vim.cmd("source " .. file_path)
      return true
    elseif file_path:match("%.lua$") then
      vim.cmd("luafile " .. file_path)
      return true
    end
  end
  return false
end

local function load_from_directory()
  config.project_dir = vim.fn.expand(config.project_dir)
  if vim.fn.isdirectory(config.project_dir) == 0 then
    vim.fn.mkdir(config.project_dir, "p")
  end
  if execute(M.get_config_by_ext("lua")) then
    return true
  end
  if execute(M.get_config_by_ext("vim")) then
    return true
  end
  return false
end

local function load_from_config()
  local uv = vim.uv or vim.loop
  local cwd = uv.cwd() or ""
  for _, item in pairs(config.project_config) do
    local match = string.match(cwd, item.path)
    if cwd == item.path or match ~= nil and #match > 1 then
      if type(item.config) == "function" then
        item.config()
        return true
      end
      if type(item.config) == "string" then
        execute(item.config)
        return true
      end
    end
  end
  return false
end

function M.load_project_config(opts)
  if opts then
    config = vim.tbl_extend("force", config, opts or {})
  end
  if load_from_directory() then
    return
  end
  if load_from_config() then
    return
  end
end

function M.edit_project_config()
  local conf = M.get_config_by_ext("vim")
  if vim.fn.filereadable(conf) == 1 then
    vim.cmd("edit " .. conf)
  else
    vim.cmd("edit " .. (M.get_config_by_ext("lua") or ""))
  end
end

---get any config file with extension
---@return string|nil
function M.get_config_by_ext(ext)
  local rootFolder = vim.fn.fnamemodify(vim.loop.cwd(), ":p:h:t")
  return config.project_dir .. rootFolder .. "." .. ext
end

---comment
---@return table json setting
function M.load_json()
  local json_decode = vim.json and vim.json.decode or vim.fn.json_decode
  local jsonfile = M.get_config_by_ext("json")
  if vim.fn.filereadable(jsonfile) == 1 then
    local f = io.open(jsonfile, "r")
    local data = f:read("*a")
    f:close()
    if data then
      local check, jdata = pcall(json_decode, data)
      if check then
        return jdata
      end
    end
  end
end

function M.save_json(json_table)
  local jsonfile = M.get_config_by_ext("json")
  local json_encode = vim.json and vim.json.encode or vim.fn.json_encode
  local fp = assert(io.open(jsonfile, "w"))
  fp:write(json_encode(json_table))
  fp:close()
end

return M
