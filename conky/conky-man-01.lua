--this is a lua script for use in conky
require 'cairo'

--conky_ are identifier for hook command
function conky_main()
--main component
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)
--End of Main Component
--[[
    font="Mono"
    font_size=12
    text="hello world"
    xpos,ypos=100,100
    red,green,blue,alpha=1,1,1,1
    font_slant=CAIRO_FONT_SLANT_NORMAL
    font_face=CAIRO_FONT_WEIGHT_NORMAL
    ----------------------------------
    cairo_select_font_face (cr, font, font_slant, font_face);
    cairo_set_font_size (cr, font_size)
    cairo_set_source_rgba (cr,red,green,blue,alpha)
    cairo_move_to (cr,xpos,ypos)
    cairo_show_text (cr,text)
    cairo_stroke (cr)
]]
--cleaning memory leak from conky
    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end
