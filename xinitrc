xset b 0
xrdb -merge ~/.Xresources
xset m 3 1
xset fp+ /usr/X11R6/lib/X11/fonts/misc
xset fp+ /usr/X11R6/lib/X11/fonts/local/suxus
xset fp rehash

#xscreensaver -no-splash &
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "remove Lock = Control_L"
xmodmap -e "keycode 66 = Control_L Control_R"
xmodmap -e "add Control = Control_R Control_R"

# Map F1 to Escape
xmodmap -e "keycode 67 = Escape"

# I accidentally hit F12 all the time when I'm really aiming for insert, so
# let's disable F12
xmodmap -e "keysym F12 = "

xsetroot -solid black

keynav&

#WM=compiz
#WM=gnome-session
WM=/usr/local/bin/ion3
if [ "$DISPLAY" = ":0" -o "$DISPLAY" = ":0.0" ] ; then
  ssh-agent $WM
else
  STY= run-xterm
fi

