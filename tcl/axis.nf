# -*- coding: utf-8 -*-
#    This is a component of AXIS, a front-end for emc
#    Copyright 2004, 2005, 2006 Jeff Epler <jepler@unpythonic.net> and
#    Chris Radek <chris@timeguy.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

namespace eval ::nf {}
set ::nf::saveroot .
set ::nf::procs {}
set ::nf::vars {task_state_text tool offset ngcfile position}
set task_state_text {ESTOP RESET}
set tool {Tool 0, offset 0.250, radius 0.03125}
set offset {Work offset 0.000 0.000 0.000}
set position {Position: Commanded}

. configure \
	-menu .menu

menu .menu \
	-cursor {}

menu .menu.file \
	-tearoff 0

.menu.file add command \
	-accelerator O \
	-command open_file \
	-label Open \
	-underline 0

setup_menu_accel .menu.file end [_ _Open]

.menu.file add command \
	-accelerator Ctrl-R \
	-command reload_file \
	-label Reload \
	-underline 0

setup_menu_accel .menu.file end [_ _Reload]

.menu.file add separator


.menu.file add command \
	-accelerator F1 \
	-command estop_clicked \
	-label {Toggle Emergency Stop} \
	-underline 7

setup_menu_accel .menu.file end [_ {Toggle _Emergency Stop}]

.menu.file add command \
	-accelerator F2 \
	-command onoff_clicked \
	-label {Toggle Machine Power} \
	-underline 7

setup_menu_accel .menu.file end [_ {Toggle _Machine Power}]

.menu.file add separator


.menu.file add command \
	-command {destroy .} \
	-label Quit \
	-underline 0

setup_menu_accel .menu.file end [_ _Quit]

# Configure widget .menu.file
wm title .menu.file file
wm iconname .menu.file {}
wm resiz .menu.file 1 1
wm minsize .menu.file 1 1

menu .menu.edit \
	-tearoff 0

.menu.edit add command \
	-accelerator Ctrl-C \
	-command copy_line \
	-label Copy \
	-underline 0

setup_menu_accel .menu.edit end [_ _Copy]

.menu.edit add separator


.menu.edit add command \
	-command set_view_z \
	-label {Top view} \
	-underline 0 \
	-accelerator V

setup_menu_accel .menu.edit end [_ {_Top view}]

.menu.edit add command \
	-command set_view_z2 \
	-label {Rotated Top view} \
	-underline 0 \
	-accelerator V

setup_menu_accel .menu.edit end [_ {_Rotated Top view}]

.menu.edit add command \
	-command set_view_x \
	-label {Side view} \
	-underline 0 \
	-accelerator V

setup_menu_accel .menu.edit end [_ {_Side view}]

.menu.edit add command \
	-command set_view_y \
	-label {Front view} \
	-underline 0 \
	-accelerator V

setup_menu_accel .menu.edit end [_ {_Front view}]

.menu.edit add command \
	-command set_view_p \
	-label {Perspective view} \
	-underline 0 \
	-accelerator V

setup_menu_accel .menu.edit end [_ {_Perspective view}]

.menu.edit add separator


.menu.edit add radiobutton \
	-value 0 \
	-variable metric \
	-command redraw \
	-label {Display Inches} \
	-underline 8

setup_menu_accel .menu.edit end [_ {Display _Inches}]

.menu.edit add radiobutton \
	-value 1 \
	-variable metric \
	-command redraw \
	-label {Display MM} \
	-underline 8

setup_menu_accel .menu.edit end [_ {Display _MM}]

.menu.edit add separator


.menu.edit add checkbutton \
	-variable show_program \
	-command redraw \
	-label {Show program} \
	-underline 1

setup_menu_accel .menu.edit end [_ {S_how program}]

.menu.edit add checkbutton \
	-variable show_live_plot \
	-command redraw \
	-label {Show live plot} \
	-underline 3

setup_menu_accel .menu.edit end [_ {Sho_w live plot}]

.menu.edit add checkbutton \
	-variable show_tool \
	-command redraw \
	-label {Show tool} \
	-underline 8

setup_menu_accel .menu.edit end [_ {Show too_l}]

.menu.edit add checkbutton \
	-variable show_extents \
	-command redraw \
	-label {Show extents} \
	-underline 6

setup_menu_accel .menu.edit end [_ {Show e_xtents}]

.menu.edit add command \
	-accelerator Ctrl-K \
	-command clear_live_plot \
	-label {Clear live plot} \
	-underline 1

setup_menu_accel .menu.edit end [_ {C_lear live plot}]

# Configure widget .menu.edit
wm title .menu.edit edit
wm iconname .menu.edit {}
wm resiz .menu.edit 1 1
wm minsize .menu.edit 1 1

menu .menu.program \
	-tearoff 0

.menu.program add command \
	-command set_next_line \
	-label {Set next line} \
	-underline 4

setup_menu_accel .menu.program end [_ {Set _next line}]

.menu.program add command \
	-accelerator R \
	-command task_run \
	-label {Run program} \
	-underline 0

setup_menu_accel .menu.program end [_ {_Run program}]

.menu.program add command \
	-accelerator T \
	-command task_step \
	-label Step \
	-underline 0

setup_menu_accel .menu.program end [_ _Step]

.menu.program add command \
	-accelerator P \
	-command task_pause \
	-label Pause \
	-underline 0

setup_menu_accel .menu.program end [_ _Pause]

.menu.program add command \
	-accelerator S \
	-command task_resume \
	-label Resume \
	-underline 2

setup_menu_accel .menu.program end [_ Re_sume]

.menu.program add command \
	-accelerator ESC \
	-command task_stop \
	-label Stop \
	-underline 1

setup_menu_accel .menu.program end [_ S_top]

# Configure widget .menu.program
wm title .menu.program program
wm iconname .menu.program {}
wm resiz .menu.program 1 1
wm minsize .menu.program 1 1

menu .menu.help \
	-tearoff 0

.menu.help add command \
	-command {wm transient .about .;wm deiconify .about; focus .about.ok} \
	-label {About AXIS} \
	-underline 0

setup_menu_accel .menu.help end [_ {_About AXIS}]

.menu.help add command \
	-command {wm transient .keys .;wm deiconify .keys; focus .keys.ok} \
	-label {Quick Reference} \
	-underline 6

setup_menu_accel .menu.help end [_ {Quick _Reference}]

# Configure widget .menu.help
wm title .menu.help help
wm iconname .menu.help {}
wm resiz .menu.help 1 1
wm minsize .menu.help 1 1

menu .menu.view \
	-tearoff 0

.menu.view add radiobutton \
	-value 1 \
	-variable display_type \
	-accelerator @ \
	-label {Show commanded position} \
	-command redraw

setup_menu_accel .menu.view end [_ {Show commanded position}]

.menu.view add radiobutton \
	-value 0 \
	-variable display_type \
	-accelerator @ \
	-label {Show actual position} \
	-command redraw

setup_menu_accel .menu.view end [_ {Show actual position}]

.menu.view add separator


.menu.view add radiobutton \
	-value 0 \
	-variable coord_type \
	-accelerator # \
	-label {Show machine position} \
	-command redraw

setup_menu_accel .menu.view end [_ {Show machine position}]

.menu.view add radiobutton \
	-value 1 \
	-variable coord_type \
	-accelerator # \
	-label {Show relative position} \
	-command redraw

setup_menu_accel .menu.view end [_ {Show relative position}]

.menu.view add separator

.menu.view add command \
	-label {Show EMC Status} \
	-command {exec $emctop_command -ini $emcini &}

# Configure widget .menu.view
wm title .menu.view view
wm iconname .menu.view {}
wm resiz .menu.view 1 1
wm minsize .menu.view 1 1

.menu add cascade \
	-menu .menu.file \
	-label File \
	-underline 0

setup_menu_accel .menu end [_ _File]

.menu add cascade \
	-menu .menu.edit \
	-label Edit \
	-underline 0

setup_menu_accel .menu end [_ _Edit]

.menu add cascade \
	-menu .menu.program \
	-label Program \
	-underline 0

setup_menu_accel .menu end [_ _Program]

.menu add cascade \
	-menu .menu.view \
	-label View \
	-underline 0

setup_menu_accel .menu end [_ _View]

.menu add cascade \
	-menu .menu.help \
	-label Help \
	-underline 0

setup_menu_accel .menu end [_ _Help]

# Configure widget .menu
wm title .menu menu
wm iconname .menu {}
wm resiz .menu 1 1
wm minsize .menu 1 1

frame .toolbar \
	-borderwidth 1 \
	-relief raised

vrule .toolbar.rule16

Button .toolbar.machine_estop \
	-helptext {Toggle Emergency Stop [F1]} \
	-image [load_image tool_estop] \
	-relief sunken \
	-takefocus 0
bind .toolbar.machine_estop <Button-1> { estop_clicked }
setup_widget_accel .toolbar.machine_estop {}

Button .toolbar.machine_power \
	-command onoff_clicked \
	-helptext {Toggle machine power [F2]} \
	-image [load_image tool_power] \
	-relief link \
	-state disabled \
	-takefocus 0
setup_widget_accel .toolbar.machine_power {}

vrule .toolbar.rule0

Button .toolbar.file_open \
	-command { open_file } \
	-helptext {Open G-Code file [O]} \
	-image [load_image tool_open] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.file_open {}

Button .toolbar.reload \
	-command { reload_file } \
	-helptext {Reopen current file [Control-R]} \
	-image [load_image tool_reload] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.reload {}

vrule .toolbar.rule4

Button .toolbar.program_run \
	-command task_run \
	-helptext {Begin executing current file} \
	-image [load_image tool_run] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.program_run {}

Button .toolbar.program_step \
	-command task_step \
	-helptext {Execute next line [T]} \
	-image [load_image tool_step] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.program_step {}

Button .toolbar.program_pause \
	-command task_pauseresume \
	-helptext {Pause [P] / resume [S] execution} \
	-image [load_image tool_pause] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.program_pause {}

Button .toolbar.program_stop \
	-command task_stop \
	-helptext {Stop program execution [ESC]} \
	-image [load_image tool_stop] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.program_stop {}

vrule .toolbar.rule8

Button .toolbar.view_zoomin \
	-command zoomin \
	-helptext {Zoom in [+]} \
	-image [load_image tool_zoomin] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_zoomin {}

Button .toolbar.view_zoomout \
	-command zoomout \
	-helptext {Zoom out [-]} \
	-image [load_image tool_zoomout] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_zoomout {}

Button .toolbar.view_z \
	-command set_view_z \
	-helptext {Top view} \
	-image [load_image tool_axis_z] \
	-relief sunken \
	-takefocus 0
setup_widget_accel .toolbar.view_z {}

Button .toolbar.view_z2 \
	-command set_view_z2 \
	-helptext {Rotated top view} \
	-image [load_image tool_axis_z2] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_z2 {}

Button .toolbar.view_x \
	-command set_view_x \
	-helptext {Side view} \
	-image [load_image tool_axis_x] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_x {}

Button .toolbar.view_y \
	-command set_view_y \
	-helptext {Front view} \
	-image [load_image tool_axis_y] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_y {}

Button .toolbar.view_p \
	-command set_view_p \
	-helptext {Perspective view} \
	-image [load_image tool_axis_p] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.view_p {}

vrule .toolbar.rule12

Button .toolbar.clear_plot \
	-command clear_live_plot \
	-helptext {Clear live plot [Ctrl-K]} \
	-image [load_image tool_clear] \
	-relief link \
	-takefocus 0
setup_widget_accel .toolbar.clear_plot {}

# Pack widget .toolbar.machine_estop
pack .toolbar.machine_estop \
	-side left

# Pack widget .toolbar.machine_power
pack .toolbar.machine_power \
	-side left

# Pack widget .toolbar.rule0
pack .toolbar.rule0 \
	-fill y \
	-padx 4 \
	-pady 4 \
	-side left

# Pack widget .toolbar.file_open
pack .toolbar.file_open \
	-side left

# Pack widget .toolbar.reload
pack .toolbar.reload \
	-side left

# Pack widget .toolbar.rule4
pack .toolbar.rule4 \
	-fill y \
	-padx 4 \
	-pady 4 \
	-side left

# Pack widget .toolbar.program_run
pack .toolbar.program_run \
	-side left

# Pack widget .toolbar.program_step
pack .toolbar.program_step \
	-side left

# Pack widget .toolbar.program_pause
pack .toolbar.program_pause \
	-side left

# Pack widget .toolbar.program_stop
pack .toolbar.program_stop \
	-side left

# Pack widget .toolbar.rule8
pack .toolbar.rule8 \
	-fill y \
	-padx 4 \
	-pady 4 \
	-side left

# Pack widget .toolbar.view_zoomin
pack .toolbar.view_zoomin \
	-side left

# Pack widget .toolbar.view_zoomout
pack .toolbar.view_zoomout \
	-side left

# Pack widget .toolbar.view_z
pack .toolbar.view_z \
	-side left

# Pack widget .toolbar.view_z2
pack .toolbar.view_z2 \
	-side left

# Pack widget .toolbar.view_x
pack .toolbar.view_x \
	-side left

# Pack widget .toolbar.view_y
pack .toolbar.view_y \
	-side left

# Pack widget .toolbar.view_p
pack .toolbar.view_p \
	-side left

# Pack widget .toolbar.rule12
pack .toolbar.rule12 \
	-fill y \
	-padx 4 \
	-pady 4 \
	-side left

# Pack widget .toolbar.clear_plot
pack .toolbar.clear_plot \
	-side left

NoteBook .tabs \
	-borderwidth 2 \
	-arcradius 3

set _tabs_manual [.tabs insert end manual -text {Manual Control [F3]} -raisecmd {focus .}]
set _tabs_mdi [.tabs insert end mdi -text {Code Entry [F5]}]
$_tabs_manual configure -borderwidth 2
$_tabs_mdi configure -borderwidth 2

.tabs itemconfigure mdi -raisecmd [list focus ${_tabs_mdi}.command]
.tabs raise manual
after idle .tabs compute_size

label $_tabs_manual.axis
setup_widget_accel $_tabs_manual.axis [_ Axis:]

frame $_tabs_manual.axes

radiobutton $_tabs_manual.axes.axisx \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value x \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisx [_ _X]

radiobutton $_tabs_manual.axes.axisy \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value y \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisy [_ _Y]

radiobutton $_tabs_manual.axes.axisz \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value z \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisz [_ _Z]

radiobutton $_tabs_manual.axes.axisa \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value a \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisa [_ _A]

radiobutton $_tabs_manual.axes.axisb \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value b \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisb [_ _B]

radiobutton $_tabs_manual.axes.axisc \
	-anchor w \
	-padx 0 \
	-selectcolor #4864ab \
	-value c \
	-variable current_axis \
	-width 2
setup_widget_accel $_tabs_manual.axes.axisc [_ _C]

# Grid widget $_tabs_manual.axes.axisa
grid $_tabs_manual.axes.axisa \
	-column 0 \
	-row 1 \
	-padx 4

# Grid widget $_tabs_manual.axes.axisb
grid $_tabs_manual.axes.axisb \
	-column 1 \
	-row 1 \
	-padx 4

# Grid widget $_tabs_manual.axes.axisc
grid $_tabs_manual.axes.axisc \
	-column 2 \
	-row 1 \
	-padx 4

# Grid widget $_tabs_manual.axes.axisx
grid $_tabs_manual.axes.axisx \
	-column 0 \
	-row 0 \
	-padx 4

# Grid widget $_tabs_manual.axes.axisy
grid $_tabs_manual.axes.axisy \
	-column 1 \
	-row 0 \
	-padx 4

# Grid widget $_tabs_manual.axes.axisz
grid $_tabs_manual.axes.axisz \
	-column 2 \
	-row 0 \
	-padx 4

frame $_tabs_manual.jogf

button $_tabs_manual.jogf.jogminus \
	-command {if {![is_continuous]} {jog_minus}} \
	-padx 0 \
	-pady 0 \
	-width 2
bind $_tabs_manual.jogf.jogminus <Button-1> {
    if {[is_continuous]} { jog_minus }
}
bind $_tabs_manual.jogf.jogminus <ButtonRelease-1> {
    if {[is_continuous]} { jog_stop }
}
setup_widget_accel $_tabs_manual.jogf.jogminus [_ -]

button $_tabs_manual.jogf.jogplus \
	-command {if {![is_continuous]} {jog_plus}} \
	-padx 0 \
	-pady 0 \
	-width 2
bind $_tabs_manual.jogf.jogplus <Button-1> {
    if {[is_continuous]} { jog_plus }
}
bind $_tabs_manual.jogf.jogplus <ButtonRelease-1> {
    if {[is_continuous]} { jog_stop }
}
setup_widget_accel $_tabs_manual.jogf.jogplus [_ +]

combobox $_tabs_manual.jogf.jogspeed \
	-editable 0 \
	-textvariable jogincrement \
	-value Continuous \
	-width 10
$_tabs_manual.jogf.jogspeed list insert end Continuous 0.1000 0.0100 0.0010 0.0001

frame $_tabs_manual.jogf.zerohome

button $_tabs_manual.jogf.zerohome.home \
	-command home_axis \
	-padx 2m \
	-pady 0
setup_widget_accel $_tabs_manual.jogf.zerohome.home [_ Home]

button $_tabs_manual.jogf.zerohome.zero \
	-command set_axis_offset \
	-padx 2m \
	-pady 0
setup_widget_accel $_tabs_manual.jogf.zerohome.zero {Offset}

checkbutton $_tabs_manual.jogf.override \
	-command toggle_override_limits \
	-variable override_limits
setup_widget_accel $_tabs_manual.jogf.override {Override Limits}

grid $_tabs_manual.jogf.zerohome \
	-column 0 \
	-row 1 \
	-columnspan 3 \
	-sticky w

# Grid widget $_tabs_manual.jogf.zerohome.home
grid $_tabs_manual.jogf.zerohome.home \
	-column 0 \
	-row 0 \
	-ipadx 2 \
	-pady 2 \
	-sticky w

# Grid widget $_tabs_manual.jogf.zerohome.zero
grid $_tabs_manual.jogf.zerohome.zero \
	-column 1 \
	-row 0 \
	-ipadx 2 \
	-pady 2 \
	-sticky w

# Grid widget $_tabs_manual.jogf.override
grid $_tabs_manual.jogf.override \
	-column 0 \
	-row 3 \
	-columnspan 3 \
	-pady 2 \
	-sticky w

# Grid widget $_tabs_manual.jogf.jogminus
grid $_tabs_manual.jogf.jogminus \
	-column 0 \
	-row 0 \
	-pady 2 \
	-sticky ns

# Grid widget $_tabs_manual.jogf.jogplus
grid $_tabs_manual.jogf.jogplus \
	-column 1 \
	-row 0 \
	-pady 2 \
	-sticky ns

# Grid widget $_tabs_manual.jogf.jogspeed
grid $_tabs_manual.jogf.jogspeed \
	-column 2 \
	-row 0 \
	-pady 2

vspace $_tabs_manual.space1 \
	-height 12

label $_tabs_manual.spindlel
setup_widget_accel $_tabs_manual.spindlel [_ Spindle:]

frame $_tabs_manual.spindlef

radiobutton $_tabs_manual.spindlef.ccw \
	-borderwidth 2 \
	-command spindle \
	-image [load_image spindle_ccw] \
	-indicatoron 0 \
	-selectcolor [systembuttonface] \
	-value -1 \
	-variable spindledir
setup_widget_accel $_tabs_manual.spindlef.ccw {}

radiobutton $_tabs_manual.spindlef.stop \
	-borderwidth 2 \
	-command spindle \
	-indicatoron 0 \
	-selectcolor [systembuttonface] \
	-value 0 \
	-variable spindledir
setup_widget_accel $_tabs_manual.spindlef.stop [_ Stop]

radiobutton $_tabs_manual.spindlef.cw \
	-borderwidth 2 \
	-command spindle \
	-image [load_image spindle_cw] \
	-indicatoron 0 \
	-selectcolor [systembuttonface] \
	-value 1 \
	-variable spindledir
setup_widget_accel $_tabs_manual.spindlef.cw {}

button $_tabs_manual.spindlef.spindleminus \
	-padx 0 \
	-pady 0 \
	-width 2
bind $_tabs_manual.spindlef.spindleminus <Button-1> {
	if {[%W cget -state] == "disabled"} { continue }
	spindle_decrease
}
bind $_tabs_manual.spindlef.spindleminus <ButtonRelease-1> {
	if {[%W cget -state] == "disabled"} { continue }
	spindle_constant
}
setup_widget_accel $_tabs_manual.spindlef.spindleminus [_ -]

button $_tabs_manual.spindlef.spindleplus \
	-padx 0 \
	-pady 0 \
	-width 2
bind $_tabs_manual.spindlef.spindleplus <Button-1> {
	if {[%W cget -state] == "disabled"} { continue }
	spindle_increase
}
bind $_tabs_manual.spindlef.spindleplus <ButtonRelease-1> {
	if {[%W cget -state] == "disabled"} { continue }
	spindle_constant
}
setup_widget_accel $_tabs_manual.spindlef.spindleplus [_ +]

checkbutton $_tabs_manual.spindlef.brake \
	-command brake \
	-variable brake
setup_widget_accel $_tabs_manual.spindlef.brake [_ Brake]

# Grid widget $_tabs_manual.spindlef.brake
grid $_tabs_manual.spindlef.brake \
	-column 0 \
	-row 2 \
	-columnspan 3 \
	-pady 2 \
	-sticky w

# Grid widget $_tabs_manual.spindlef.ccw
grid $_tabs_manual.spindlef.ccw \
	-column 0 \
	-row 0 \
	-pady 2

# Grid widget $_tabs_manual.spindlef.cw
grid $_tabs_manual.spindlef.cw \
	-column 2 \
	-row 0 \
	-sticky w

# Grid widget $_tabs_manual.spindlef.spindleminus
grid $_tabs_manual.spindlef.spindleminus \
	-column 0 \
	-row 1 \
	-pady 2 \
	-sticky ns

# Grid widget $_tabs_manual.spindlef.spindleplus
grid $_tabs_manual.spindlef.spindleplus \
	-column 1 \
	-row 1 \
	-columnspan 2 \
	-pady 2 \
	-sticky nsw

# Grid widget $_tabs_manual.spindlef.stop
grid $_tabs_manual.spindlef.stop \
	-column 1 \
	-row 0 \
	-ipadx 8

vspace $_tabs_manual.space2 \
	-height 12

label $_tabs_manual.coolant
setup_widget_accel $_tabs_manual.coolant [_ Coolant:]

checkbutton $_tabs_manual.mist \
	-command mist \
	-variable mist
setup_widget_accel $_tabs_manual.mist [_ Mist]

checkbutton $_tabs_manual.flood \
	-command flood \
	-variable flood
setup_widget_accel $_tabs_manual.flood [_ Flood]

grid rowconfigure $_tabs_manual 99 -weight 1
grid columnconfigure $_tabs_manual 99 -weight 1
# Grid widget $_tabs_manual.axes
grid $_tabs_manual.axes \
	-column 1 \
	-row 0 \
	-padx 0 \
	-sticky w

# Grid widget $_tabs_manual.axis
grid $_tabs_manual.axis \
	-column 0 \
	-row 0 \
	-pady 1 \
	-sticky nw

# Grid widget $_tabs_manual.coolant
grid $_tabs_manual.coolant \
	-column 0 \
	-row 5 \
	-sticky w

# Grid widget $_tabs_manual.flood
grid $_tabs_manual.flood \
	-column 1 \
	-row 6 \
	-columnspan 2 \
	-padx 4 \
	-sticky w

# Grid widget $_tabs_manual.jogf
grid $_tabs_manual.jogf \
	-column 1 \
	-row 1 \
	-padx 4 \
	-sticky w

# Grid widget $_tabs_manual.mist
grid $_tabs_manual.mist \
	-column 1 \
	-row 5 \
	-columnspan 2 \
	-padx 4 \
	-sticky w

# Grid widget $_tabs_manual.space1
grid $_tabs_manual.space1 \
	-column 0 \
	-row 2

# Grid widget $_tabs_manual.space2
grid $_tabs_manual.space2 \
	-column 0 \
	-row 4

# Grid widget $_tabs_manual.spindlef
grid $_tabs_manual.spindlef \
	-column 1 \
	-row 3 \
	-padx 4 \
	-sticky w

# Grid widget $_tabs_manual.spindlel
grid $_tabs_manual.spindlel \
	-column 0 \
	-row 3 \
	-pady 2 \
	-sticky nw

label $_tabs_mdi.historyl
setup_widget_accel $_tabs_mdi.historyl [_ History:]

text $_tabs_mdi.history \
	-height 8 \
	-takefocus 0 \
	-width 40
$_tabs_mdi.history insert end {}
$_tabs_mdi.history configure -state disabled
grid rowconfigure $_tabs_mdi.history 0 -weight 1

vspace $_tabs_mdi.vs1 \
	-height 12

label $_tabs_mdi.commandl
setup_widget_accel $_tabs_mdi.commandl [_ {MDI Command:}]

entry $_tabs_mdi.command \
	-textvariable mdi_command
bind $_tabs_mdi.command <Key-Return> send_mdi

button $_tabs_mdi.go \
	-command send_mdi \
	-padx 1m \
	-pady 0
setup_widget_accel $_tabs_mdi.go [_ Go]

vspace $_tabs_mdi.vs2 \
	-height 12

label $_tabs_mdi.gcodel
setup_widget_accel $_tabs_mdi.gcodel [_ {Active G-Codes:}]

text $_tabs_mdi.gcodes \
	-height 2 \
	-width 20
$_tabs_mdi.gcodes insert end {}
$_tabs_mdi.gcodes configure -state disabled

vspace $_tabs_mdi.vs3 \
	-height 12

# Grid widget $_tabs_mdi.command
grid $_tabs_mdi.command \
	-column 0 \
	-row 4 \
	-sticky ew

# Grid widget $_tabs_mdi.commandl
grid $_tabs_mdi.commandl \
	-column 0 \
	-row 3 \
	-sticky w

# Grid widget $_tabs_mdi.gcodel
grid $_tabs_mdi.gcodel \
	-column 0 \
	-row 6 \
	-sticky w

# Grid widget $_tabs_mdi.gcodes
grid $_tabs_mdi.gcodes \
	-column 0 \
	-row 7 \
	-columnspan 2 \
	-sticky new

# Grid widget $_tabs_mdi.go
grid $_tabs_mdi.go \
	-column 1 \
	-row 4

# Grid widget $_tabs_mdi.history
grid $_tabs_mdi.history \
	-column 0 \
	-row 1 \
	-columnspan 2 \
	-sticky nesw

# Grid widget $_tabs_mdi.historyl
grid $_tabs_mdi.historyl \
	-column 0 \
	-row 0 \
	-sticky w

# Grid widget $_tabs_mdi.vs1
grid $_tabs_mdi.vs1 \
	-column 0 \
	-row 2

# Grid widget $_tabs_mdi.vs2
grid $_tabs_mdi.vs2 \
	-column 0 \
	-row 5

# Grid widget $_tabs_mdi.vs3
grid $_tabs_mdi.vs3 \
	-column 0 \
	-row 8
grid columnconfigure $_tabs_mdi 0 -weight 1
grid rowconfigure $_tabs_mdi 1 -weight 1

frame .preview \
	-background black \
	-height 300 \
	-width 400

frame .info

label .info.task_state \
	-anchor w \
	-borderwidth 2 \
	-relief sunken \
	-textvariable task_state_string \
	-width 14
setup_widget_accel .info.task_state {}

label .info.tool \
	-anchor w \
	-borderwidth 2 \
	-relief sunken \
	-textvariable tool \
	-width 30
setup_widget_accel .info.tool [_ {Tool 0, offset 0.250, radius 0.03125}]

label .info.offset \
	-anchor w \
	-borderwidth 2 \
	-relief sunken \
	-textvariable offset \
	-width 25
setup_widget_accel .info.offset [_ {Work offset 0.000 0.000 0.000}]

label .info.position \
	-anchor w \
	-borderwidth 2 \
	-relief sunken \
	-textvariable position \
	-width 25
setup_widget_accel .info.position [_ {Position: Commanded}]

# Pack widget .info.task_state
pack .info.task_state \
	-side left

# Pack widget .info.tool
pack .info.tool \
	-side left

# Pack widget .info.position
pack .info.position \
	-side left

frame .t \
	-borderwidth 2 \
	-relief sunken \
	-highlightthickness 1

text .t.text \
	-borderwidth 0 \
	-exportselection 0 \
	-height 9 \
	-highlightthickness 0 \
	-relief flat \
	-takefocus 0 \
	-yscrollcommand {.t.sb set}
.t.text insert end {}

scrollbar .t.sb \
	-borderwidth 0 \
	-command {.t.text yview} \
	-highlightthickness 0

# Pack widget .t.text
pack .t.text \
	-expand 1 \
	-fill both \
	-side left

# Pack widget .t.sb
pack .t.sb \
	-fill y \
	-side left

frame .feedoverride

label .feedoverride.foentry \
	-textvariable feedrate \
	-width 3
setup_widget_accel .feedoverride.foentry [_ 0]

scale .feedoverride.foscale \
	-command set_feedrate \
	-orient horizontal \
	-resolution 5.0 \
	-showvalue 0 \
	-takefocus 0 \
	-to 120.0 \
	-variable feedrate

label .feedoverride.l
setup_widget_accel .feedoverride.l [_ {Feed Override (%):}]

# Pack widget .feedoverride.l
pack .feedoverride.l \
	-side left

# Pack widget .feedoverride.foentry
pack .feedoverride.foentry \
	-side left

# Pack widget .feedoverride.foscale
pack .feedoverride.foscale \
	-expand 1 \
	-fill x \
	-side left

toplevel .about
bind .about <Key-Return> { wm wi .about }
bind .about <Key-Escape> { wm wi .about }

text .about.message \
	-background [systembuttonface] \
	-borderwidth 0 \
	-font {Helvetica -12} \
	-relief flat \
	-width 40 \
	-height 11 \
	-wrap word \
	-cursor {}

.about.message tag configure link \
	-underline 1 -foreground blue
.about.message tag bind link <Leave> {
	.about.message configure -cursor {}
	.about.message tag configure link -foreground blue}
.about.message tag bind link <Enter> {
	.about.message configure -cursor hand2
	.about.message tag configure link -foreground red}
.about.message tag bind link <ButtonPress-1><ButtonRelease-1> {launch_website}
.about.message insert end {AXIS version 1.1.1rc1

Copyright (C) 2004, 2005, 2006 Jeff Epler and Chris Radek.

This is free software, and you are welcome to redistribute it under certain conditions.  See the file COPYING, included with AXIS.

Visit the AXIS web site at } {} {http://axis.unpy.net} link
.about.message configure -state disabled

button .about.ok \
	-command {wm wi .about} \
	-default active \
	-padx 0 \
	-pady 0 \
	-width 10
setup_widget_accel .about.ok [_ OK]

label .about.image \
	-borderwidth 0 \
	-image [load_image banner]
setup_widget_accel .about.image {}

# Pack widget .about.image
pack .about.image

# Pack widget .about.message
pack .about.message \
	-expand 1 \
	-fill both

# Pack widget .about.ok
pack .about.ok

# Configure widget .about
wm title .about {About AXIS}
wm iconname .about {}
wm resiz .about 0 0
wm minsize .about 1 1
wm protocol .about WM_DELETE_WINDOW {wm wi .about}

toplevel .keys
bind .keys <Key-Return> { wm withdraw .keys }
bind .keys <Key-Escape> { wm withdraw .keys }

text .keys.text \
	-background [systembuttonface] \
	-font {Helvetica -12} \
	-height 22 \
	-relief flat \
	-tabs {100 300 400} \
	-width 88 \
	-cursor {}

.keys.text tag configure key \
	-borderwidth {} \
	-elide {} \
	-font fixed

.keys.text configure -state disabled

button .keys.ok \
	-command {wm wi .keys} \
	-default active \
	-padx 0 \
	-pady 0 \
	-width 10
setup_widget_accel .keys.ok [_ OK]

# Pack widget .keys.text
pack .keys.text \
	-expand 1 \
	-fill y

# Pack widget .keys.ok
pack .keys.ok

# Configure widget .keys
wm title .keys {AXIS Quick Reference}
wm iconname .keys {}
wm resiz .keys 0 0
wm minsize .keys 1 1
wm protocol .keys WM_DELETE_WINDOW {wm wi .keys}

# Grid widget .feedoverride
grid .feedoverride \
	-column 0 \
	-row 2 \
	-sticky nw

# Grid widget .info
grid .info \
	-column 0 \
	-row 4 \
	-columnspan 2 \
	-sticky ew

# Grid widget .preview
grid .preview \
	-column 1 \
	-row 1 \
	-columnspan 2 \
	-rowspan 2 \
	-sticky nesw

# Grid widget .t
grid .t \
	-column 0 \
	-row 3 \
	-columnspan 2 \
	-sticky nesw

# Grid widget .tabs
grid .tabs \
	-column 0 \
	-row 1 \
	-sticky nesw \
	-padx 2 \
	-pady 2

# Grid widget .toolbar
grid .toolbar \
	-column 0 \
	-row 0 \
	-columnspan 3 \
	-sticky nesw
grid columnconfigure . 1 -weight 1
grid rowconfigure . 1 -weight 1

# Configure widget .
wm title . {AXIS (no file)}
wm iconname . {}
wm resiz . 1 1

# vim:ts=8:sts=8:noet:sw=8
