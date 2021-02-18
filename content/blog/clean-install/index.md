---
title: "Linuxとwindowsの環境再構築に係るメモ"
date: 2021-02-17T20:44:45+09:00
draft: false
# categories: ["技術系"]
toc: true
---

## Linux

### gnome keyring

### `.ssh/config`の移行

### ssh 秘密鍵の移行

### gpg 鍵の移行

```bash
gpg --export-secret-keys --armor > gpg-private.keys.backup # 秘密鍵のバックアップ
gpg --export --armor > gpg-public.keys.backup # 公開鍵のバックアップ

# 鍵のインポート
gpg --import gpg-private.keys.backup
gpg --import gpg-public.keys.backup
```

### .config 以下のフルバックアップ

### レポートデータの移行

### Cmake のインストール（build essensial で入るのは古い）

apt で入るのは古かったが pacman で入るのは比較新しいかも？

### xkeysnail の設定

`dotfiles`にある xkeysnail 関係のファイルを `~/.config/xkeysnail/`以下に移植

```bash
ln -s ~/dotfiles/xkeysnail/config.py ~/.config/xkeysnail/config.py
ln -s ~/dotfiles/xkeysnail/start.sh ~/.config/xkeysnail/start.sh
ln -s ~/dotfiles/xkeysnail/README.md ~/.config/xkeysnail/README.md
```

現状の`config.py`の設定

```python
import re
from xkeysnail.transform import *

define_multipurpose_modmap({
    # SandS
    Key.SPACE: [Key.SPACE, Key.LEFT_SHIFT],
    # Capslock is escape when pressed and released. Control when held down.
    Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL],
    Key.LEFT_CTRL: [Key.ESC, Key.LEFT_CTRL]
})

define_modmap({
    Key.MUHENKAN: Key.LEFT_ALT,
    Key.HENKAN: Key.RIGHT_ALT
})
```

### yaskkserv2 の設定

`cargo`をインストール

```bash
git clone https://github.com/wachikun/yaskkserv2.git
cd yaskkserv2
cargo build --release
cp -av target/release/yaskkserv2 /usr/local/sbin/
cp -av target/release/yaskkserv2_make_dictionary /usr/local/bin

yaskkserv2_make_dictionary --dictionary-filename=$HOME/.config/skk/dictionary.yaskkserv2 /usr/share/skk/*
```

[yaskkserv2](https://github.com/wachikun/yaskkserv2)

### Firefox の Alt 無効化設定およびフルスクリーンでのツールバー表示

#### Alt 無効化

`about:config` -> `ui.key.menuAccessKey`を 0 にする。 `ui.key.menuAccessKeyFocuses`を false に。

#### フルスクリーン時のツールバー表示

`browser.fullscreen.autohide` を false に。

### site ディレクトリの引っ越し

### dein vim のインストール

### autorandr のインストール

好みの設定をしたあとに `autorandr -s <save name>`。

設定の適用は`autorandr -l <save name>`

モニタケーブル抜き刺し時に任意スクリプトを実行するなら
`~/.config/autorandr/postswitch.d/`以下にシェルスクリプト配置。

#### メインモニタのみ

`xrandr --output eDP1 --off`

#### デュアルモニタ

`xrandr --output eDP1 --right-of HDMI1 --mode 1600x900`

#### 持ち運び

`xrandr --output eDP1 --mode 1920x1080`

### libskk 絡みの how to

`.config/libskk/rules/RULE_NAME/`以下に libskk の設定ファイルのシンボリックリンクを貼って下さい。

```bash
ln -s {~/dotfiles/libskk/,~/.config/libskk/rules/RULE_NAME/}keymap/
ln -s {~/dotfiles/libskk/,~/.config/libskk/rules/RULE_NAME/}metadata.json
ln -s {~/dotfiles/libskk/,~/.config/libskk/rules/RULE_NAME/}rom-kana
```

### tlpui

実行には tlp が必要。

### fish

現状の`config.fish`

```bash
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
status --is-interactive; and rbenv init - | source
set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin/
set -g theme_display_date no
set -g theme_display_cmd_duration no
set -g theme_color_scheme solarized-light
set -Ux EDITOR (which vim)
if [ -n "$DESKTOP_SESSION" ]
    set -x SSH_AUTH_SOCK /run/user/1000/keyring/ssh
end
```

docker 関係の補完
`https://github.com/barnybug/docker-fish-completion`

#### Powerline フォントのインストール

```bash
cd /tmp
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts/
```

#### fisher のインストール

```bash
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher add oh-my-fish/theme-bobthefish
fisher add edc/bass # bashで書かれたシェルスクリプトを実行
```

### i3

### polybar

現状の`~/.config/polybar/launch.sh`

```bash
#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch bar1 and bar2
# polybar azukibar 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar HDMI1 2>&1 | tee -a /tmp/polybar2.log & disown
counter=1
if which "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1 | sort); do
      MONITOR=$m polybar --reload azukibar 2>&1 |tee -a /tmp/polybar$(( counter )).log &
      (( counter ++ ))
  done
else
  polybar --reload azukibar &
fi
echo "Bars launched..." echo "Polybar launched..."
```

現状の`~/.config/polybar/config`

```toml
;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/polybar/polybar
;
;   The README contains a lot of information
;
;==========================================================

[colors]
;background = ${xrdb:color0:#222}
background = #222
background-alt = #444
;foreground = ${xrdb:color7:#222}
foreground = #dfdfdf
foreground-alt = #555
primary = #ffb52a
secondary = #e60053
alert = #bd2c40

[bar/azukibar]
monitor = ${env:MONITOR:}
width = 100%
height = 27
;offset-x = 1%
;offset-y = 1%
radius = 6.0
fixed-center = true

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3
line-color = #f00

border-size = 4
border-color = #00000000

padding-left = 0
padding-right = 2

module-margin-left = 1
module-margin-right = 2

font-0 = Source Han Code JP H:pixelsize=12;1
font-1 = FontAwesome:pixelsize=12;0
font-2 = Siji:style=Regular

modules-left = i3 wlan eth wlan_bt
modules-center= date
modules-right = backlight-acpi pulseaudio memory battery cpu temperature fanspeed cpu_clock

tray-position = right
tray-padding = 2
;tray-background = #0063ff

;wm-restack = bspwm
;wm-restack = i3

;override-redirect = true

;scroll-up = bspwm-desknext
;scroll-down = bspwm-deskprev

;scroll-up = i3wm-wsnext
;scroll-down = i3wm-wsprev

cursor-click = pointer
cursor-scroll = ns-resize

; for debug
[bar/example]
;monitor = ${env:MONITOR:HDMI-1}
width = 100%
height = 27
;offset-x = 1%
;offset-y = 1%
radius = 6.0
fixed-center = false

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 3
line-color = #f00

border-size = 4
border-color = #00000000

padding-left = 0
padding-right = 2

module-margin-left = 1
module-margin-right = 2

;font-0 = fixed:pixelsize=10;1
;font-1 = unifont:fontformat=truetype:size=8:antialias=false;0
;font-2 = siji:pixelsize=10;1

;font-1 = FontAwesome5Free:style=Solid:size=10;4
;font-2 = FontAwesome5Free:style=Regular:size=10;4
;font-3 = FontAwesome5Brands:style=Regular:size=10;4

;font-0 = DejavuSansMono:size=10;4
;font-1 = NotoSansCJKJP:size=10;4
;font-2 = FontAwesome:size=10;4
;font-2 = Font Awesome 5 Free Regular:size=10;4
;font-3 = Font Awesome 5 Free Solid:size=10;4
;;;font-4 = Font Awesome 5 Brands Regular:size=10;4
font-0 = Source Han Code JP H:pixelsize=12;1
font-1 = FontAwesome:pixelsize=12;0

modules-left = bspwm i3
;modules-center = mpd
modules-center=
modules-right = filesystem backlight-acpi alsa pulseaudio xkeyboard memory cpu wlan eth battery temperature date powermenu

tray-position = right
tray-padding = 2
;tray-background = #0063ff

;wm-restack = bspwm
;wm-restack = i3

;override-redirect = true

;scroll-up = bspwm-desknext
;scroll-down = bspwm-deskprev

;scroll-up = i3wm-wsnext
;scroll-down = i3wm-wsprev

cursor-click = pointer
cursor-scroll = ns-resize

[module/fanspeed]
type = custom/script
exec = $HOME/.config/polybar/modules/fan_speed
interval = 3

format-underline = #f90000
label = %output% RPM

[module/cpu_clock]
type = custom/script
exec = $HOME/.config/polybar/modules/cpu_clock
interval = 3

format-underline = #f90000
label = %output% GHz

[module/xwindow]
type = internal/xwindow
label = %title:0:30:...%

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock

format-prefix = " "
format-prefix-foreground = ${colors.foreground-alt}
format-prefix-underline = ${colors.secondary}

label-layout = %layout%
label-layout-underline = ${colors.secondary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-background = ${colors.secondary}
label-indicator-underline = ${colors.secondary}

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

label-mounted = %{F#0a81f5}%mountpoint%%{F-}: %percentage_used%%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.foreground-alt}

[module/bspwm]
type = internal/bspwm

label-focused = %index%
label-focused-background = ${colors.background-alt}
label-focused-underline= ${colors.primary}
label-focused-padding = 2

label-occupied = %index%
label-occupied-padding = 2

label-urgent = %index%!
label-urgent-background = ${colors.alert}
label-urgent-padding = 2

label-empty = %index%
label-empty-foreground = ${colors.foreground-alt}
label-empty-padding = 2

; Separator in between workspaces
; label-separator = |

[module/i3]
type = internal/i3
format = <label-state> <label-mode>
index-sort = true
wrapping-scroll = false

; Only show workspaces on the same output as the bar
;pin-workspaces = true

label-mode-padding = 2
label-mode-foreground = #000
label-mode-background = ${colors.primary}

; focused = Active workspace on focused monitor
label-focused = %index%
label-focused-background = ${colors.background-alt}
label-focused-underline= ${colors.primary}
label-focused-padding = 2

; unfocused = Inactive workspace on any monitor
label-unfocused = %index%
label-unfocused-padding = 2

; visible = Active workspace on unfocused monitor
label-visible = %index%
label-visible-background = ${self.label-focused-background}
label-visible-underline = ${self.label-focused-underline}
label-visible-padding = ${self.label-focused-padding}

; urgent = Workspace with urgency hint set
label-urgent = %index%
label-urgent-background = ${colors.alert}
label-urgent-padding = 2

; Separator in between workspaces
; label-separator = |


[module/mpd]
type = internal/mpd
format-online = <label-song>  <icon-prev> <icon-stop> <toggle> <icon-next>

icon-prev = 
icon-stop = 
icon-play = 
icon-pause = 
icon-next = 

label-song-maxlen = 25
label-song-ellipsis = true

[module/xbacklight]
type = internal/xbacklight
output = eDP1
format = <label> <bar>
label = BL %percentage%%

bar-width = 5
bar-indicator = |
bar-indicator-foreground = #fff
bar-indicator-font = 2
bar-fill = ─
bar-fill-font = 2
bar-fill-foreground = #9f78e1
bar-empty = ─
bar-empty-font = 2
bar-empty-foreground = ${colors.foreground-alt}

[module/backlight-acpi]
inherit = module/xbacklight
type = internal/backlight
card = intel_backlight

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = " "
format-prefix-foreground = ${colors.foreground-alt}
format-underline = #f90000
label = %percentage%%

[module/memory]
type = internal/memory
interval = 2
fiormat = <label>
format-prefix = " "
format-prefix-foreground = ${colors.foreground-alt}
format-underline = #4bffdc
label = %percentage_used%%

[module/wlan]
type = internal/network
interface = wlp2s0
interval = 3.0

format-connected = <ramp-signal> <label-connected>
format-connected-underline = #9f78e1
label-connected = %upspeed%￪ %essid% ￬%downspeed%

;format-disconnected = <label-disconnected>
;format-disconnected-underline = ${self.format-connected-underline}
;label-disconnected = disconnected
;label-disconnected-foreground = ${colors.foreground-alt}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-foreground = ${colors.foreground-alt}

[module/wlan_bt]
type = internal/network
interface = bnep0
interval = 3.0

format-connected = <ramp-signal> <label-connected>
format-connected-underline = #9f78e1
label-connected = %upspeed%￪ bluetooth essid% ￬%downspeed%

;format-disconnected = <label-disconnected>
;format-disconnected-underline = ${self.format-connected-underline}
;label-disconnected = disconnected
;label-disconnected-foreground = ${colors.foreground-alt}

ramp-signal-0 = 
ramp-signal-1 = 
ramp-signal-2 = 
ramp-signal-3 = 
ramp-signal-4 = 
ramp-signal-foreground = ${colors.foreground-alt}

[module/eth]
type = internal/network
interface = enp1s0
interval = 3.0

format-connected-underline = #55aa55
format-connected-prefix = " "
format-connected-prefix-foreground = ${colors.foreground-alt}
label-connected = %upspeed%￪ %local_ip% ￬%downspeed%
format-disconnected =
;format-disconnected = <label-disconnected>
;format-disconnected-underline = ${self.format-connected-underline}
;label-disconnected = %ifname% disconnected
;label-disconnected-foreground = ${colors.foreground-alt}

[module/date]
type = internal/date
interval = 1

date = " %Y-%m-%d (%a)"

time = %H:%M:%S

format-prefix = 
format-prefix-foreground = ${colors.foreground-alt}
format-underline = #0a6cf5

label = %date% %time%

[module/pulseaudio]
type = internal/pulseaudio

format-volume = <label-volume> <bar-volume>
label-volume = VOL %percentage%%
label-volume-foreground = ${root.foreground}

label-muted = muted
label-muted-foreground = #666

bar-volume-width = 5
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-indicator-font = 2
bar-volume-fill = ─
bar-volume-fill-font = 2
bar-volume-empty = ─
bar-volume-empty-font = 2
bar-volume-empty-foreground = ${colors.foreground-alt}

[module/alsa]
type = internal/alsa

format-volume = <label-volume> <bar-volume>
label-volume = VOL
label-volume-foreground = ${root.foreground}

format-muted-prefix = " "
format-muted-foreground = ${colors.foreground-alt}
label-muted = sound muted

bar-volume-width = 10
bar-volume-foreground-0 = #55aa55
bar-volume-foreground-1 = #55aa55
bar-volume-foreground-2 = #55aa55
bar-volume-foreground-3 = #55aa55
bar-volume-foreground-4 = #55aa55
bar-volume-foreground-5 = #f5a70a
bar-volume-foreground-6 = #ff5555
bar-volume-gradient = false
bar-volume-indicator = |
bar-volume-indicator-font = 2
bar-volume-fill = ─
bar-volume-fill-font = 2
bar-volume-empty = ─
bar-volume-empty-font = 2
bar-volume-empty-foreground = ${colors.foreground-alt}

[module/battery]
type = internal/battery
battery = BAT0
adapter = AC
full-at = 98

format-charging = <animation-charging> <label-charging>
format-charging-underline = #ffb52a

format-discharging = <animation-discharging> <label-discharging>
format-discharging-underline = ${self.format-charging-underline}

format-full-prefix = " "
format-full-prefix-foreground = ${colors.foreground-alt}
format-full-underline = ${self.format-charging-underline}

label-charging = %percentage%%
label-discharging = Discharging %percentage%% %time%

ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-foreground = ${colors.foreground-alt}

animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-foreground = ${colors.foreground-alt}
animation-charging-framerate = 750

animation-discharging-0 = 
animation-discharging-1 = 
animation-discharging-2 = 
animation-discharging-foreground = ${colors.foreground-alt}
animation-discharging-framerate = 750

[module/temperature]
type = internal/temperature
thermal-zone = 0
warn-temperature = 80

format = <ramp> <label>
format-underline = #f50a4d
format-warn = <ramp> <label-warn>
format-warn-underline = ${self.format-underline}

hwmon-path=/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input

label = %temperature-c%
label-warn = %temperature-c%
label-warn-foreground = ${colors.secondary}

ramp-0 = 
ramp-1 = 
ramp-2 = 
ramp-foreground = ${colors.foreground-alt}

[module/powermenu]
type = custom/menu

expand-right = true

format-spacing = 1

label-open = 
label-open-foreground = ${colors.secondary}
label-close =  cancel
label-close-foreground = ${colors.secondary}
label-separator = |
label-separator-foreground = ${colors.foreground-alt}

menu-0-0 = reboot
menu-0-0-exec = menu-open-1
menu-0-1 = power off
menu-0-1-exec = menu-open-2

menu-1-0 = cancel
menu-1-0-exec = menu-open-0
menu-1-1 = reboot
menu-1-1-exec = sudo reboot

menu-2-0 = power off
menu-2-0-exec = sudo poweroff
menu-2-1 = cancel
menu-2-1-exec = menu-open-0

[settings]
screenchange-reload = true
;compositing-background = xor
;compositing-background = screen
;compositing-foreground = source
;compositing-border = over
;pseudo-transparency = false

[global/wm]
margin-top = 5
margin-bottom = 5

; vim:ft=dosini

```

### rofi

インストールするだけ。

### cron の引っ越し

現状予定無し。

### proxy 設定

```fish
alias set-proxy "bass source switch_proxy.sh"
funcsave set-proxy
```

今の`switch_proxy`の中身。

```bash
#!/bin/env bash
file=/etc/apt/apt.conf
proxy_address="http://proxy.uec.ac.jp:8080"
grep -e '^\#' $file >/dev/null
if [ $? -ne 0 ];then
    sudo sed -i -e 's/\(.*\)/\#\1/g' $file
    export -n HTTP_PROXY
    export -n HTTPS_PROXY
    export -n http_proxy
    export -n https_proxy
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    git config --global --unset url."https://github.com/".insteadOf git@github.com:
    git config --global --unset url."https://".insteadOf git://
    echo proxy on to off
else
    sudo sed -i -e 's/^\#\(.*\)/\1/g' $file
    export HTTP_PROXY=$proxy_address
    export HTTPS_PROXY=$proxy_address
    export http_proxy=$proxy_address
    export https_proxy=$proxy_address
    git config --global http.proxy $proxy_address
    git config --global https.proxy $proxy_address
    git config --global url."https://".insteadOf git://
    git config --global url."https://github.com/".insteadOf git@github.com:
    echo proxy off to on
fi

```

### dotfiles のシンボリックリンク作成

### LaTeX 絡み

```perl
#!/usr/bin/perl

$latex     = 'uplatex %O -kanji=utf8 -synctex=1 -interaction=nonstopmode -file-line-error %S';
$xelatex   = 'xelatex %O -no-pdf -synctex=1 -shell-escape -interaction=nonstopmode %S';
$lualatex  = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode';

$bibtex    = 'upbibtex %O %B';
$biber     = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$dvipdf    = 'dvipdfmx %O -o %D %S';
$makeindex = 'upmendex %O -o %D %S';
$pdf_mode  = '3'; # .tex -> .dvi -> .pdf
```

### cups

設定は`http://localhost:631`

### flameshot

インストールするだけ。

### scanner util gscan2pdf

scansnap fi-5110eox2 は linux の汎用ドライバで使える。
書類の終点近くが切れるので A4 の縦幅を 300mm くらいにすると良い。

### avahi

`avahi-daemon`入れればいいと思う。

## Windows

### 写真データのバックアップ

### windows 10 のライセンスキー確認

### Office のライセンス確認
