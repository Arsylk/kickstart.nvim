-- init module
local _M = {}

--- @param winnr integer | nil
--- @return true | false | nil
function _M.get_oil_nnn(winnr)
  winnr = winnr or 0
  local ok, value = pcall(vim.api.nvim_win_get_var, winnr, 'nnn')
  if not ok then
    return nil
  end
  if value then
    return true
  end
  return false
end


--- @param val boolean
--- @param winnr integer | nil
function _M.set_oil_nnn(val, winnr)
  winnr = winnr or 0
  vim.api.nvim_win_set_var(winnr, 'nnn', val)
end

function _M.palette()
  return require('catppuccin.palettes').get_palette 'mocha'
end

--- @param hex: string
--- @return { r: number, g: number, b: number }
function _M.color(hex)
  local color = { r = 0, g = 0, b = 0 }
  if hex:sub(1, 1) == '#' then
    color.r = tonumber(hex:sub(2, 3), 16)
    color.g = tonumber(hex:sub(4, 5), 16)
    color.b = tonumber(hex:sub(6, 7), 16)
  end
  return color
end

function _M.mix(base, other, strength)
  local c1 = _M.color(base)
  local c2 = _M.color(other)
  if strength == nil then
    strength = 0.5
  end
  local r = c1.r * (1 - strength) + c2.r * strength
  local g = c1.g * (1 - strength) + c2.g * strength
  local b = c1.b * (1 - strength) + c2.b * strength
  return string.format('#%02x%02x%02x', r, g, b)
end

return _M
