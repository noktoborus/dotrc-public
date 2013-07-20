#!/bin/sh

syndaemon -i 1 -d -K &&\
	(
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Device Enabled" 8 1
		# Set multi-touch emulation parameters
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Pressure" 32 10
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Width" 32 6
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Two-Finger Scrolling" 8 1
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Two-Finger Scrolling" 8 1 1
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Tap Action" 8 2 3 0 0 1 3 2
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Circular Scrolling" 8 0

		# Disable edge scrolling
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Edge Scrolling" 8 0 0 0

		# This will make cursor not to jump if you have two fingers on the touchpad and you list one
		# (which you usually do after two-finger scrolling)
		xinput set-int-prop "SynPS/2 Synaptics TouchPad" "Synaptics Jumpy Cursor Threshold" 32 110
	)

