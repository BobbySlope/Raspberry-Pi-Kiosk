#!/bin/bash

# DO NOT USE THIS SCRIPT - ITS IN TESTING STATE AND MAY CORRUPT YOUR HOOBS DEVICE


# HOW TO RUN THE SCRIPT

# sudo wget -q -O - https://raw.githubusercontent.com/BobbySlope//Raspberry-Pi-Kiosk/main/install.sh | sudo bash -



##################################################################################################
# ext_display_hoobs.                                                                             #
# Copyright (C) 2022 HOOBS                                                                       #
#                                                                                                #
# This program is free software: you can redistribute it and/or modify                           #
# it under the terms of the GNU General Public License as published by                           #
# the Free Software Foundation, either version 3 of the License, or                              #
# (at your option) any later version.                                                            #
#                                                                                                #
# This program is distributed in the hope that it will be useful,                                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                 #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                  #
# GNU General Public License for more details.                                                   #
#                                                                                                #
# You should have received a copy of the GNU General Public License                              #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.                          #
##################################################################################################
# Author: Bobby Slope     






#title           :install.sh
#description     :This script will create a service to open a chromium kiosk window in Raspbian Stretch and will also prevent any further user intervention 
#author		       :me@tonybenoy.com
#date            :26-04-2018
#version         :0.2   
#usage		       :sudo bash install.sh
#==============================================================================

OE_USER="hoobs"
OE_HOME="/home/$OE_USER"
URL="https://www.tonybenoy.com"

echo -e "* Removing Alt-Ctrl-Del"

sudo rm /lib/systemd/system/ctrl-alt-del.target
sudo ln -s /dev/null /lib/systemd/system/ctrl-alt-del.target
sudo systemctl daemon-reload

echo -e "* Removing keybinds"
#Feel free to add any other keybinds that I may have missed
#Refer to http://openbox.org/wiki/Help:Bindings#Key_bindings for more help
sudo rm -rf $OE_HOME/.config/openbox/lxde-rc.xml

cat <<EOF > $OE_HOME/.config/openbox/lxde-rc.xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- Do not edit this file, it will be overwritten on install.
        Copy the file to $HOME/.config/openbox/ instead. -->

<openbox_config xmlns="http://openbox.org/3.4/rc">

<resistance>
  <strength>10</strength>
  <screen_edge_strength>20</screen_edge_strength>
</resistance>

<focus>
  <focusNew>yes</focusNew>
  <!-- always try to focus new windows when they appear. other rules do
       apply -->
  <followMouse>no</followMouse>
  <!-- move focus to a window when you move the mouse into it -->
  <focusLast>yes</focusLast>
  <!-- focus the last used window when changing desktops, instead of the one
       under the mouse pointer. when followMouse is enabled -->
  <underMouse>no</underMouse>
  <!-- move focus under the mouse, even when the mouse is not moving -->
  <focusDelay>200</focusDelay>
  <!-- when followMouse is enabled, the mouse must be inside the window for
       this many milliseconds (1000 = 1 sec) before moving focus to it -->
  <raiseOnFocus>no</raiseOnFocus>
  <!-- when followMouse is enabled, and a window is given focus by moving the
       mouse into it, also raise the window -->
</focus>

<placement>
  <policy>Smart</policy>
  <!-- 'Smart' or 'UnderMouse' -->
  <center>yes</center>
  <!-- whether to place windows in the center of the free area found or
       the top left corner -->
  <monitor>Any</monitor>
  <!-- with Smart placement on a multi-monitor system, try to place new windows
       on: 'Any' - any monitor, 'Mouse' - where the mouse is, 'Active' - where
       the active window is -->
</placement>

<theme>
  <name>Onyx</name>
  <titleLayout>NLIMC</titleLayout>
  <!--
      available characters are NDSLIMC, each can occur at most once.
      N: window icon
      L: window label (AKA title).
      I: iconify
      M: maximize
      C: close
      S: shade (roll up/down)
      D: omnipresent (on all desktops).
  -->
  <keepBorder>yes</keepBorder>
  <animateIconify>yes</animateIconify>
  <font place="ActiveWindow">
    <name>sans</name>
    <size>10</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="InactiveWindow">
    <name>sans</name>
    <size>10</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="MenuHeader">
    <name>sans</name>
    <size>10</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="MenuItem">
    <name>sans</name>
    <size>10</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place="OnScreenDisplay">
    <name>sans</name>
    <size>10</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
</theme>

<desktops>
  <!-- this stuff is only used at startup, pagers allow you to change them
       during a session

       these are default values to use when other ones are not already set
       by other applications, or saved in your session

       use obconf if you want to change these without having to log out
       and back in -->
  <number>2</number>
  <firstdesk>1</firstdesk>
  <names>
    <!-- set names up here if you want to, like this:
    <name>desktop 1</name>
    <name>desktop 2</name>
    -->
  </names>
  <popupTime>875</popupTime>
  <!-- The number of milliseconds to show the popup for when switching
       desktops.  Set this to 0 to disable the popup. -->
</desktops>

<resize>
  <drawContents>yes</drawContents>
  <popupShow>Nonpixel</popupShow>
  <!-- 'Always', 'Never', or 'Nonpixel' (xterms and such) -->
  <popupPosition>Center</popupPosition>
  <!-- 'Center', 'Top', or 'Fixed' -->
  <popupFixedPosition>
    <!-- these are used if popupPosition is set to 'Fixed' -->

    <x>10</x>
    <!-- positive number for distance from left edge, negative number for
         distance from right edge, or 'Center' -->
    <y>10</y>
    <!-- positive number for distance from top edge, negative number for
         distance from bottom edge, or 'Center' -->
  </popupFixedPosition>
</resize>

<!-- You can reserve a portion of your screen where windows will not cover when
     they are maximized, or when they are initially placed.
     Many programs reserve space automatically, but you can use this in other
     cases. -->
<margins>
  <top>0</top>
  <bottom>0</bottom>
  <left>0</left>
  <right>0</right>
</margins>

<dock>
  <position>TopLeft</position>
  <!-- (Top|Bottom)(Left|Right|)|Top|Bottom|Left|Right|Floating -->
  <floatingX>0</floatingX>
  <floatingY>0</floatingY>
  <noStrut>no</noStrut>
  <stacking>Above</stacking>
  <!-- 'Above', 'Normal', or 'Below' -->
  <direction>Vertical</direction>
  <!-- 'Vertical' or 'Horizontal' -->
  <autoHide>no</autoHide>
  <hideDelay>300</hideDelay>
  <!-- in milliseconds (1000 = 1 second) -->
  <showDelay>300</showDelay>
  <!-- in milliseconds (1000 = 1 second) -->
  <moveButton>Middle</moveButton>
  <!-- 'Left', 'Middle', 'Right' -->
</dock>

<keyboard>
  <chainQuitKey>C-g</chainQuitKey>
      <keybind key="C-s">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-S-n">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-n">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-o">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-S-t">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-S">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="C-S-Tab">

      <action name="Execute"><command>false</command></action>

  </keybind>

    <keybind key="S-w">

      <action name="Execute"><command>false</command></action>

  </keybind>

  <keybind key="C-t">
      <action name="Execute"><command>false</command></action>
  </keybind>
    <keybind key="C-Tab">
      <action name="Execute"><command>false</command></action>
  </keybind>
  <keybind key="C-w">
      <action name="Execute"><command>false</command></action>
  </keybind>
  <!-- Keybindings for desktop switching -->
  <keybind key="C-A-Left">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="C-A-Right">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="C-A-Up">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="C-A-Down">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="S-A-Left">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="S-A-Right">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="S-A-Up">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="S-A-Down">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="W-F1">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="W-F2">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="W-F3">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="W-F4">
<action name="Execute"><command>false</command></action>  </keybind>
  <keybind key="W-d">
<action name="Execute"><command>false</command></action>  </keybind>

  <keybind key="C-A-d">
<action name="Execute"><command>false</command></action>  </keybind>

  <!-- Keybindings for windows -->
  <keybind key="A-F4">
    <action name="Execute"><command>false</command></action>
  </keybind>
  <keybind key="A-Escape">
    <action name="Execute"><command>false</command></action>
    <action name="Execute"><command>false</command></action>
    <action name="Execute"><command>false</command></action>
  </keybind>
  <keybind key="A-space">
    <action name="Execute"><command>false</command></action>
  </keybind>

  <!-- Keybindings for window switching -->
  <keybind key="A-Tab">
    <action name="Execute"><command>false</command></action>
  </keybind>
  <keybind key="A-S-Tab">
    <action name="Execute"><command>false</command></action>
  </keybind>
  <keybind key="C-A-Tab">
    <action name="Execute"><command>false</command></action>
      <panels>yes</panels><desktop>yes</desktop>
    </action>
  </keybind>

  <!-- Keybindings for running applications -->
  <keybind key="W-e">
    <action name="Execute"><command>false</command></action>
  </keybind>

  <!-- Keybindings for finding files -->
  <keybind key="W-f">
    <action name="Execute"><command>false</command></action>
  </keybind>

  <!--keybindings for LXPanel -->
  <keybind key="W-r">
      <action name="Execute"><command>false</command></action>
  </keybind>

  <keybind key="A-F2">
      <action name="Execute"><command>false</command></action>
  </keybind>

  <keybind key="C-Escape">
      <action name="Execute"><command>false</command></action>
  </keybind>

  <keybind key="A-F1">
      <action name="Execute"><command>false</command></action>
  </keybind>

  <keybind key="A-F11">
     <action name="Execute"><command>false</command></action>
  </keybind>

  <!-- Launch Task Manager with Ctrl+Alt+Del -->
  <keybind key="A-C-Delete">
      <action name="Execute"><command>false</command></action>
  </keybind>

  <!-- Launch gnome-screenshot when PrintScreen is pressed -->
  <keybind key="Print">
      <action name="Execute"><command>false</command></action>
  </keybind>
  <!-- Launch LXRandR when Fn+Screen is pressed -->
  <keybind key="XF86Display">
      <action name="Execute">"Execute"><command>false</command></action>
  </keybind>

</keyboard>


<mouse>
  <dragThreshold>8</dragThreshold>
  <!-- number of pixels the mouse must move before a drag begins -->
  <doubleClickTime>200</doubleClickTime>
  <!-- in milliseconds (1000 = 1 second) -->
  <screenEdgeWarpTime>400</screenEdgeWarpTime>
  <!-- Time before changing desktops when the pointer touches the edge of the
       screen while moving a window, in milliseconds (1000 = 1 second).
       Set this to 0 to disable warping -->

  <context name="Frame">
    <mousebind button="A-Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="A-Left" action="Click">
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="A-Left" action="Drag">
      <action name="Move"/>
    </mousebind>

    <mousebind button="A-Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="A-Right" action="Drag">
      <action name="Resize"/>
    </mousebind>

    <mousebind button="A-Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="C-A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="C-A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="A-S-Up" action="Click">
      <action name="SendToDesktopPrevious"/>
    </mousebind>
    <mousebind button="A-S-Down" action="Click">
      <action name="SendToDesktopNext"/>
    </mousebind>
  </context>

  <context name="Titlebar">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Move"/>
    </mousebind>
    <mousebind button="Left" action="DoubleClick">
      <action name="ToggleMaximizeFull"/>
    </mousebind>

    <mousebind button="Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="Up" action="Click">
      <action name="Shade"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
      <action name="Lower"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="Unshade"/>
      <action name="Raise"/>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="Top">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>top</edge></action>
    </mousebind>
  </context>

  <context name="Left">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>left</edge></action>
    </mousebind>
  </context>

  <context name="Right">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>right</edge></action>
    </mousebind>
  </context>

  <context name="Bottom">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"><edge>bottom</edge></action>
    </mousebind>

    <mousebind button="Middle" action="Press">
      <action name="Lower"/>
      <action name="FocusToBottom"/>
      <action name="Unfocus"/>
    </mousebind>

    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="BLCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="BRCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="TLCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="TRCorner">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Drag">
      <action name="Resize"/>
    </mousebind>
  </context>

  <context name="Client">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Middle" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
  </context>

  <context name="Icon">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="ShowMenu"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name="AllDesktops">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleOmnipresent"/>
    </mousebind>
  </context>

  <context name="Shade">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleShade"/>
    </mousebind>
  </context>

  <context name="Iconify">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="Iconify"/>
    </mousebind>
  </context>

  <context name="Maximize">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Middle" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="ToggleMaximizeFull"/>
    </mousebind>
    <mousebind button="Middle" action="Click">
      <action name="ToggleMaximizeVert"/>
    </mousebind>
    <mousebind button="Right" action="Click">
      <action name="ToggleMaximizeHorz"/>
    </mousebind>
  </context>

  <context name="Close">
    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
      <action name="Unshade"/>
    </mousebind>
    <mousebind button="Left" action="Click">
      <action name="Close"/>
    </mousebind>
  </context>

  <context name="Desktop">
    <mousebind button="Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>

    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="C-A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="C-A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>

    <mousebind button="Left" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="Focus"/>
      <action name="Raise"/>
    </mousebind>
  </context>

  <context name="Root">
    <!-- Menus -->
    <mousebind button="Middle" action="Press">
      <action name="ShowMenu"><menu>client-list-combined-menu</menu></action>
    </mousebind>
    <mousebind button="Right" action="Press">
      <action name="ShowMenu"><menu>root-menu</menu></action>
    </mousebind>
  </context>

  <context name="MoveResize">
    <mousebind button="Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
    <mousebind button="A-Up" action="Click">
      <action name="DesktopPrevious"/>
    </mousebind>
    <mousebind button="A-Down" action="Click">
      <action name="DesktopNext"/>
    </mousebind>
  </context>
</mouse>

<menu>
  <!-- You can specify more than one menu file in here and they are all loaded,
       just don't make menu ids clash or, well, it'll be kind of pointless -->

  <!-- default menu file (or custom one in $HOME/.config/openbox/) -->
  <file>/usr/share/lxde/openbox/menu.xml</file>
  <hideDelay>200</hideDelay>
  <!-- if a press-release lasts longer than this setting (in milliseconds), the
       menu is hidden again -->
  <middle>no</middle>
  <!-- center submenus vertically about the parent entry -->
  <submenuShowDelay>100</submenuShowDelay>
  <!-- this one is easy, time to delay before showing a submenu after hovering
       over the parent entry -->
  <applicationIcons>yes</applicationIcons>
  <!-- controls if icons appear in the client-list-(combined-)menu -->
  <manageDesktops>yes</manageDesktops>
  <!-- show the manage desktops section in the client-list-(combined-)menu -->
</menu>

<applications>
<!--
  # this is an example with comments through out. use these to make your
  # own rules, but without the comments of course.

  <application name="first element of window's WM_CLASS property (see xprop)"
              class="second element of window's WM_CLASS property (see xprop)"
               role="the window's WM_WINDOW_ROLE property (see xprop)">
  # the name or the class can be set, or both. this is used to match
  # windows when they appear. role can optionally be set as well, to
  # further restrict your matches.

  # the name, class, and role use simple wildcard matching such as those
  # used by a shell. you can use * to match any characters and ? to match
  # any single character.

  # when multiple rules match a window, they will all be applied, in the
  # order that they appear in this list


    # each element can be left out or set to 'default' to specify to not
    # change that attribute of the window

    <decor>yes</decor>
    # enable or disable window decorations

    <shade>no</shade>
    # make the window shaded when it appears, or not

    <position>
      # the position is only used if both an x and y coordinate are provided
      # (and not set to 'default')
      <x>center</x>
      # a number like 50, or 'center' to center on screen. use a negative number
      # to start from the right (or bottom for <y>), ie -50 is 50 pixels from the
      # right edge (or bottom).
      <y>200</y>
      <monitor>1</monitor>
      # specifies the monitor in a xinerama setup.
      # 1 is the first head, or 'mouse' for wherever the mouse is
    </position>

    <focus>yes</focus>
    # if the window should try be given focus when it appears. if this is set
    # to yes it doesn't guarantee the window will be given focus. some
    # restrictions may apply, but Openbox will try to

    <desktop>1</desktop>
    # 1 is the first desktop, 'all' for all desktops

    <layer>normal</layer>
    # 'above', 'normal', or 'below'

    <iconic>no</iconic>
    # make the window iconified when it appears, or not

    <skip_pager>no</skip_pager>
    # asks to not be shown in pagers

    <skip_taskbar>no</skip_taskbar>
    # asks to not be shown in taskbars. window cycling actions will also
    # skip past such windows

    <fullscreen>yes</fullscreen>
    # make the window in fullscreen mode when it appears

    <maximized>true</maximized>
    # 'Horizontal', 'Vertical' or boolean (yes/no)
  </application>

  # end of the example
-->
</applications>

</openbox_config>
EOF

echo -e "* Create startup script file"

cat <<EOF > $OE_HOME/script.sh
#! /bin/bash
rm -rf $OE_HOME/.config/chromium
rm -rf $OE_HOME/.cache/chromium
DISPLAY=:0 chromium-browser -kiosk $URL
EOF

chmod 777 $OE_HOME/script.sh

echo -e "* Removing Lxpanels"

sudo apt remove lxpanel -y
sudo apt autoremove -y

echo -e "* Create service file"

cat <<EOF > $OE_HOME/chromiumkiosk.service
[Unit]
Description=Chromium Onboot
After=graphical-session.target

[Service]
User=$OE_USER
Group=$OE_USER
ExecStart=  $OE_HOME/script.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo -e "* Security Init File"
mv $OE_HOME/chromiumkiosk.service /etc/systemd/system/chromiumkiosk.service

echo -e "* Startup Startup"
sudo systemctl enable chromiumkiosk.service

echo -e "* Starting Service"
sudo systemctl start chromiumkiosk.service

echo -e "* Rebooting in 20 seconds Press Ctrl+c to cancel"
sleep 20
sudo reboot -h now
