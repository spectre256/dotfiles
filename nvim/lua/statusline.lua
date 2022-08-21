local opt = vim.opt
-- ·
local modes = {
    ['n'] = 'NORMAL',
    ['no'] = 'NORMAL',
    -- ['nov'] = 'NORMAL',
    -- ['noV'] = 'NORMAL',
    -- ['no'] = 'NORMAL',
    -- ['niI'] = 'NORMAL',
    -- ['niR'] = 'NORMAL',
    -- ['niV'] = 'NORMAL',
    -- ['nt'] = 'NORMAL',
    ['v'] = 'VISUAL',
    -- ['vs'] = 'VISUAL',
    ['V'] = 'VISUAL',
    -- ['Vs'] = 'VISUAL',
    ['0'] = 'VISUAL',
    -- ['s'] = 'VISUAL',
    ['s'] = 'SELECT',
    ['S'] = 'SELECT',
    [''] = 'SELECT',
    ['i'] = 'INSERT',
    ['ic'] = 'INSERT',
    -- ['ix'] = 'INSERT',
    ['R'] = 'REPLACE',
    -- ['Rc'] = 'REPLACE',
    -- ['Rx'] = 'REPLACE',
    ['Rv'] = 'REPLACE',
    -- ['Rvc'] = 'REPLACE',
    -- ['Rvx'] = 'REPLACE',
    ['c'] = 'COMMAND',
    ['cv'] = 'COMMAND',
    ['ce'] = 'COMMAND',
    ['r'] = 'PROMPT',
    ['rm'] = 'PROMPT',
    ['r?'] = 'PROMPT',
    ['!'] = 'COMMAND',
    ['t'] = 'TERMINAL',
    -- ['null'] = 'NONE',
}

--vim.api.nvim_exec(
--[[
  --hi Primary ctermfg=06 ctermbg=00
  --hi Secondary ctermfg=08 ctermbg=00
  --hi Blank   ctermfg=07 ctermbg=00
--]]
--)

local function current_mode()
	return modes[vim.api.nvim_get_mode().mode]
end

local function statusline()
	return table.concat({
		--"%#Primary#",
		current_mode(),
		--"%#Secondary#",
		--"%#Blank#",
		" %f ",
		"%m",
		"%=",
		--"%#Secondary#",
		"%l, %c ",
		--"%#Primary#",
		--"%{&filetype}",
	})
end

vim.o.statusline = '%!luaeval("statusline()")'
