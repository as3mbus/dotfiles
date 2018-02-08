composer ={}
composer.alphaValue = 'aa'
colorPreset = {
  icon       = '\\#333333',
  label      = '\\#33aa33',  
  value      = '\\#3333aa',
  lineColor  = '\\#ff0000',
  background = '\\#ffffff',
  foreground = '\\#000000'
}
-- lemonade
function composer.decToHex(value)
    return string.format("%x",value)
end
function composer.colorMaker(red,green,blue)
    return string.format("#ff%x%x%x",red,green,blue)
end
function composer.applyAlpha(color,alpha)
  alphaValue = alpha
  color = string.sub(color, 4)
  color = '\\#' .. alphaValue .. color
  return color
end
function composer.lemonForeground(color)
  return '%{F' .. color .. '}'
end
function composer.lemonBackground(color)
  return '%{B' .. color .. '}'
end
function composer.lemonBackgroundAlpha(color)
  return '%{B' .. composer.alpha(color) .. '}'
end
function composer.lemonLineColor(color)
  return '%{U' .. color .. '}'
end
function composer.lemonLines(lineCode)
    local lineTbl =
    {
        [1] = composer.lemonUnderline,
        [2] = composer.lemonOverline,
        [3] = composer.lemonBothline,
    }
    local line = lineTbl[lineCode]
    if (line) then
        return line()
    else 
        return composer.lemonNoLine()
    end
end
function composer.lemonOverline()
    return '%{+o}'
end
function composer.lemonUnderline()
    return '%{+u}'
end
function composer.lemonBothline()
    return composer.lemonOverline .. composer.lemonUnderline
end
function composer.lemonNoLine()
    return '%{-o}%{-u}'
end
function composer.lemonReset()
  return '%{B-}%{F-}' .. composer.lemonNoLine()
end
-- 
function composer.craft(label, bg, fg, lineCode, lineColor)
    bg = bg or colorPreset.background
    fgColor = fg or colorPreset.foreground
    lineColor = lineColor or colorPreset.lineColor
    text    = '' ..
              composer.lemonBackground(bg) .. 
              composer.lemonForeground(fgColor) ..
              composer.lemonLines(lineCode)     ..
              composer.lemonLineColor(lineColor)..
              label                             ..
              composer.lemonReset()
    return text
end
function composer.compose(icon, label, value, colorBg)
  colorBg = colorBg or colorPreset.background
  text = composer.lemonBackgroundAlpha(colorBg)
  text = text .. composer.lemonLineColor(colorPreset.underline)   
  if icon  then 
    color = color or colorPreset.icon
    text = text .. ' ' .. composer.lemonForeground(color) .. icon .. ' '
  end  
  if label then 
    color = color or colorPreset.label    
    text = text .. ' ' .. composer.lemonForeground(color) .. label      
  end  
  if value then 
    color = color or colorPreset.value
    text = text .. ' ' .. composer.lemonForeground(color) .. value .. ' ' 
  end
  text ='%{+u}' ..  text .. '%{-u}' .. composer.lemonReset()
  return text
end
