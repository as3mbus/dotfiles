-- config
conky.config = {
    out_to_x = false,
    out_to_console = true,
    short_units = true,
    update_interval = 1
}
-- prepare
local dirname  = debug.getinfo(1).source:match("@?(.*/)")
--dofile(dirname .. 'gmc.lua')
dofile(dirname .. 'lemonbar-composer.lua')
-- shortcut
local _h = composer
lf = composer.lemonForeground
lb = composer.lemonBackground
la = composer.lemonBackgroundAlpha
lu = composer.lemonLineColor
lr = composer.lemonReset
-- parts
parts = {}
function parts.uptime(colorBg)
  return _h.compose('', 'Uptime:7', '$uptime', colorBg)
end
function parts.mem(colorBg)
  return _h.compose('', 'RAM:', '$mem/$memmax', colorBg)
end
function parts.ssid(colorBg)
  return _h.compose('', 'SSID:', '$wireless_essid', colorBg)
end
-- assembly
enabled = '' .. _h.craft('hello world', null, '' ,  2, "\\#ffffff")
-- main
conky.text = [[\
%{r}\
]] .. lr() .. lf('\\#ff0000') .. [[  \
%{l}\
]] .. lr() .. lf('\\#ff0000') .. [[  \
%{c}\
]] .. lr() .. lf('\\#ff0000') .. [[\
]] .. enabled
   .. lr() .. lf('\\#00ff00') .. [[\
]]
