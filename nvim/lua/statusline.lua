local api = vim.api
local fn = vim.fn
local home = vim.env.HOME

local circleL = ""
local circleR = ""
local circleLEmpty = ""
local circleREmpty = ""
local spacer = "%="

local palette = require("catppuccin.palettes").get_palette()

local setColor = function(fg, bg, name)
    api.nvim_set_hl(0, name, { fg = fg, bg = bg })
    return string.format("%%#%s#", name)
end

local sections = {
    default = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = "",
        sepR = " ",
    },
    mode = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = " ",
        sepR = circleR,
    },
    branch = {
        fg = palette.text,
        bg = palette.surface0,
        sepL = " ",
        sepR = circleR,
    },
    icon = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = " ",
        sepR = circleREmpty,
    },
    filePath = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = " ",
        sepR = " ",
    },
    flags = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = "",
        sepR = " ",
    },
    diagnostics = {
        fg = palette.text,
        bg = palette.mantle,
        sepL = circleLEmpty,
        sepR = "",
    },
    servers = {
        fg = palette.crust,
        bg = palette.blue,
        sepL = circleL,
        sepR = " ",
    },
    line = {
        fg = palette.crust,
        bg = palette.mauve,
        sepL = circleL,
        sepR = " ",
    },
}

local modes = setmetatable({
    ["n"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["no"] = {
        text = "O⋅PENDING",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["nov"] = {
        text = "O⋅PENDING",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["noV"] = {
        text = "O⋅PENDING",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["no\22"] = {
        text = "O⋅PENDING",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["niI"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["niR"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["niV"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["nt"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["ntT"] = {
        text = "NORMAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
    ["v"] = {
        text = "VISUAL",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["vs"] = {
        text = "VISUAL",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["V"] = {
        text = "V⋅LINE",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["Vs"] = {
        text = "V⋅LINE",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["\22"] = {
        text = "V⋅BLOCK",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["\22s"] = {
        text = "V⋅BLOCK",
        fg = palette.crust,
        bg = palette.sapphire,
    },
    ["s"] = {
        text = "SELECT",
        fg = palette.crust,
        bg = palette.blue,
    },
    ["S"] = {
        text = "S⋅LINE",
        fg = palette.crust,
        bg = palette.blue,
    },
    ["\19"] = {
        text = "S⋅BLOCK",
        fg = palette.crust,
        bg = palette.blue,
    },
    ["i"] = {
        text = "INSERT",
        fg = palette.crust,
        bg = palette.peach,
    },
    ["ic"] = {
        text = "INSERT",
        fg = palette.crust,
        bg = palette.peach,
    },
    ["ix"] = {
        text = "INSERT",
        fg = palette.crust,
        bg = palette.peach,
    },
    ["R"] = {
        text = "REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["Rc"] = {
        text = "REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["Rx"] = {
        text = "REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["Rv"] = {
        text = "V⋅REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["Rvc"] = {
        text = "V⸳REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["Rvx"] = {
        text = "V⸳REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["c"] = {
        text = "COMMAND",
        fg = palette.crust,
        bg = palette.mauve,
    },
    ["cv"] = {
        text = "EX",
        fg = palette.crust,
        bg = palette.yellow,
    },
    ["ce"] = {
        text = "EX",
        fg = palette.crust,
        bg = palette.subtext0,
    },
    ["r"] = {
        text = "REPLACE",
        fg = palette.crust,
        bg = palette.pink,
    },
    ["rm"] = {
        text = "MORE",
        fg = palette.text,
        bg = palette.surface2,
    },
    ["r?"] = {
        text = "CONFIRM",
        fg = palette.text,
        bg = palette.surface2,
    },
    ["!"] = {
        text = "SHELL",
        fg = palette.crust,
        bg = palette.teal,
    },
    ["t"] = {
        text = "TERMINAL",
        fg = palette.crust,
        bg = palette.lavender,
    },
}, {
    __index = function(modes, key)
        if modes[key] then
            return modes[key]
        else
            return key
        end
    end,
})

local genSection = function(name, text, colorLeft, colorRight)
    local section = sections[name]
    local color = setColor(section.fg, section.bg, "statusline_" .. name)
    local colorSepL = colorLeft or ""
    local colorSepR = colorRight or ""

    local sectionTbl = {
        color,
        colorSepL,
        section.sepL,
        color,
        text,
        colorSepR,
        section.sepR,
    }
    return table.concat(sectionTbl)
end

local getMode = function()
    local mode = api.nvim_get_mode().mode
    mode = modes[mode]

    sections["mode"].fg = mode.fg
    sections["mode"].bg = mode.bg
    local colorSepR = setColor(mode.bg, sections["default"].bg, "statusline_mode_sepR")
    return genSection("mode", mode.text, nil, colorSepR)
end

local getBranch = function()
    if vim.fn.isdirectory(".git") ~= 0 then
        local cwd = fn.getcwd()
        local branch = fn.system(string.format("git -C %s branch --show-current", cwd))

        local colorSepR = setColor(sections["branch"].bg, sections["default"].bg, "statusline_branch_sepR")
        setColor(sections["mode"].bg, sections["branch"].bg, "statusline_mode_sepR")
        return genSection("branch", string.format(" %s", branch:gsub("%W", "")), nil, colorSepR)
    else
        return ""
    end
end

local getFilePath = function()
    local cwd = fn.getcwd()
    local filePath = api.nvim_buf_get_name(0)

    if vim.bo.filetype == "help" then
        filePath = "Help"
    elseif string.find(filePath, cwd) then
        filePath = filePath:gsub(cwd .. "/", "")
    elseif string.find(filePath, home) then
        filePath = filePath:gsub(home, "~")
    end

    local icon, color = require("nvim-web-devicons").get_icon_color(filePath, nil, { default = true })
    sections["icon"].fg = color
    local colorSepR = setColor(sections["branch"].bg, sections["default"].bg, "statusline_filePath_sepR")

    icon = genSection("icon", icon .. " ", nil, colorSepR)
    filePath = genSection("filePath", filePath)
    return icon .. filePath
end

local getFlags = function()
    local flags = {}
    if vim.bo.modified then
        local color = setColor(palette.blue, sections["flags"].bg, "statusline_flags_modified")
        table.insert(flags, color .. " ")
    elseif vim.bo.readonly then
        local color = setColor(palette.red, sections["flags"].bg, "statusline_flags_readonly")
        table.insert(flags, color .. " ")
    end

    return genSection("flags", table.concat(flags, " "))
end

local getDiagnostics = function()
    local levels = {
        {
            severity = 1,
            icon = "DiagnosticSignError",
            color = setColor(palette.red, sections["default"].bg, "statusline_diagnostics_error")
        },
        {
            severity = 2,
            icon = "DiagnosticSignWarn",
            color = setColor(palette.yellow, sections["default"].bg, "statusline_diagnostics_warn")
        },
        {
            severity = 3,
            icon = "DiagnosticSignHint",
            color = setColor(palette.blue, sections["default"].bg, "statusline_diagnostics_hint")
        },
        {
            severity = 4,
            icon = "DiagnosticSignInfo",
            color = setColor(palette.blue, sections["default"].bg, "statusline_diagnostics_info")
        },
    }
    local results = " "
    for _, level in ipairs(levels) do
        local diagnostics = vim.diagnostic.get(0, { severity = level.severity })
        local icon = vim.fn.sign_getdefined(level.icon)[1].text
        if #diagnostics > 0 then
            results = string.format("%s%s%s%d ", results, level.color, icon, #diagnostics)
        end
    end
    local colorSepL = setColor(sections["branch"].bg, sections["default"].bg, "statusline_diagnostics_sepL")
    return genSection("diagnostics", results, colorSepL)
end

local getServers = function()
    local servers = {}
    if vim.lsp.buf.server_ready() then
        for _, client in pairs(vim.lsp.buf_get_clients(0)) do
            table.insert(servers, client.name)
        end

        local colorSepL = setColor(sections["servers"].bg, sections["default"].bg, "statusline_servers_sepL")
        setColor(sections["line"].bg, sections["servers"].bg, "statusline_line_sepL")
        return genSection("servers", string.format(" %s", table.concat(servers, ", ")), colorSepL)
    else
        setColor(sections["line"].bg, sections["default"].bg, "statusline_line_sepL")
        return ""
    end
end

local getLine = function()
    local line = api.nvim_win_get_cursor(0)[1]
    local lines = api.nvim_buf_line_count(0)
    local percentage = line / lines * 100
    if lines >= 1000 then
        lines = string.gsub(string.reverse(tostring(lines)), "(%d%d%d)", "%1,")
        lines = string.reverse(string.gsub(lines, ",$", ""))
    end
    local colorSepL = "%#statusline_line_sepL#"
    return genSection("line", string.format("%d%%%% %s", percentage, lines), colorSepL)
end

SetStatusline = function()
    return table.concat {
        getMode(),
        getBranch(),
        getFilePath(),
        getFlags(),
        spacer,
        getDiagnostics(),
        getServers(),
        getLine(),
    }
end

api.nvim_create_augroup("Statusline", { clear = true })
api.nvim_create_autocmd({ "Winenter", "Bufenter" }, {
    pattern = { "*" },
    callback = function()
        -- vim.o.statusline = api.nvim_eval_statusline(SetStatusline(), {})
        vim.o.statusline = "%!luaeval('SetStatusline()')"
    end,
    group = "Statusline",
})
