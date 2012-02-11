keynav daemonize

# remap capslock to control.
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "remove Lock = Control_L"
xmodmap -e "keycode 66 = Control_L Control_R"
xmodmap -e "add Control = Control_R Control_R"
# make F1 escape, too.
xmodmap -e "keycode 67 = Escape"
#xmodmap -e "keysym F12 = "

# Make middle-click-hold scroll with the trackpoint
# from http://forums.fedoraforum.org/showthread.php?t=245729
xinput list | sed -ne 's/^[^ ][^V].*id=\([0-9]*\).*/\1/p' | while read id
do
        case `xinput list-props $id` in
        *"Middle Button Emulation"*)
                xinput set-int-prop $id "Evdev Wheel Emulation" 8 1
                xinput set-int-prop $id "Evdev Wheel Emulation Button" 8 2
                xinput set-int-prop $id "Evdev Wheel Emulation Timeout" 8 200
                xinput set-int-prop $id "Evdev Wheel Emulation Axes" 8 6 7 4 5
                xinput set-int-prop $id "Evdev Middle Button Emulation" 8 0
                ;;
        esac
done
