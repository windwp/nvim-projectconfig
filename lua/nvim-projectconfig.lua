local M = {}
local project_dir = "~/.config/nvim/projects/"
local project_config = {}
local silent = true

local function execute(file_path)
    file_path = vim.fn.expand(file_path)
    if  vim.fn.filereadable(file_path) == 1 then
        if silent == false then
            print("load " .. vim.inspect(file_path))
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
    project_dir = vim.fn.expand(project_dir)
    if vim.fn.isdirectory(project_dir) == 0 then
        vim.fn.mkdir(project_dir, 'p')
    end

    local rootFolder = string.match(vim.loop.cwd(),"[^%/]+$")

    if rootFolder then
        local projectfile = project_dir .. rootFolder .. ".lua"
        if execute(projectfile) then return true  end
        projectfile = project_dir .. rootFolder .. ".vim"
        if execute(projectfile) then return true  end
    end
    return false
end


local function load_from_config()
    local cwd = vim.loop.cwd()
    for _, item in pairs(project_config) do
        local match = string.match(cwd, item.path)
        if cwd == item.path or match ~= nil and #match > 1 then
            if type(item.config) == 'function' then
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
    opts = opts or{}
    project_dir = opts.project_dir or project_dir
    project_config = opts.project_config or project_config
    if opts.silent ~= nil then silent = opts.silent end
    if load_from_directory() then return end
    if load_from_config() then return end

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
