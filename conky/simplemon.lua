-- vim: ts=4 sw=4 noet ai cindent syntax=lua
--[[
Conky, a system monitor, based on torsmo

Any original torsmo code is licensed under the BSD license

All code written since the fork of torsmo is licensed under the GPL

Please see COPYING for details

Copyright (c) 2004, Hannu Saransaari and Lauri Hakkarainen
Copyright (c) 2005-2012 Brenden Matthews, Philip Kovacs, et. al. (see AUTHORS)
All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

conky.config = {
    alignment = 'top_right',
    background = false,
	border_inner_margin = 20,
    border_width = 1,
    cpu_avg_samples = 2,
	default_color = 'white',
    default_outline_color = 'white',
    default_shade_color = 'white',
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    use_xft = true,
    font = 'peep:size=14',
    gap_x = 30,
    gap_y = 30,
	maximum_width = 1366,
    net_avg_samples = 2,
    no_buffers = true,
    out_to_console = false,
    out_to_stderr = false,
    extra_newline = false,
    own_window = true,
    own_window_class = 'Conky',
    own_window_type = 'override',
	own_window_argb_visual = true,
	own_window_argb_value = 200,
	own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager',
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    show_graph_scale = false,
    show_graph_range = false,
	--lua_load = '/home/as3mbus/dotfiles/conky/conky-man-01.lua',
	--lua_draw_hook_post = 'main'
}
conky.text = [[\
${alignr}${font sans serif:style=Medium:pixelsize=84}${time %H : %M}${font}
${voffset 5}${alignr}${font hermit:style=Medium:pixelsize=24}${time %A, %d %B %Y}${font}
]] 
..
--${voffset 20}$alignr${color}Welcome ${execi 216000 whoami}
[[\
${voffset 20}\
${color gray}System		${hr 2}
${voffset 20}\
${color grey}\
${offset 30}CPU\
${alignc}Memory\
${alignr 30}Swap$color
${font hermit:pixelsize=24}\
${offset 30}${cpu cpu0}%\
${alignc}$memperc%\
${alignr 30}$swapperc%\
$font\
${voffset 20}
${color grey}Network	${hr 2}\
${voffset 20}
${color grey}\
${offset 60}UP\
${alignr 70}DOWN$color
${font hermit:pixelsize=24}\
${offset 30}${upspeed wlp3s0}\
${alignr 30}${downspeed wlp3s0}\
$font\
]]
