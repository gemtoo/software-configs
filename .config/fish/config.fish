cd
export GPG_TTY=$(tty)
export TERM="xterm-256color"
export PATH="$HOME/.cargo/bin/:$PATH"
### ALIASES ###

#Basic
alias l='exa -hla --octal-permissions'
alias s='doas -- '
alias q='exit'
alias xi='doas -- emerge -a'
alias xu='doas -- emerge -auvDN @world'
alias xq='eix -R'
alias xa='cat /var/lib/portage/world'
alias xr='doas -- emerge --deselect --depclean'
alias xrr='doas -- emerge --depclean'
alias cff='pushd ~/.config/fish/ && t config.fish && popd'
alias reboot='doas -- reboot'
alias down='doas -- shutdown -h now'
alias rsync='rsync -avhPHAXxog'
alias ip='ip -c'
source "$HOME/.config/fish/aliases.fish"
### ALIASES END ###

### FUNCTIONS ###
# Suppress greeting.
set fish_greeting 
### FUNCTIONS END ###

### PROMPT LEFT BEGIN ###

function fish_prompt
    set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
	set_color blue
	    printf "["
	set_color white
	    printf " "
	set_color cyan
	    printf "$USER"
	    printf "@"
	    printf (hostname)
    set_color white
        printf " "
	set_color magenta
	    printf "{"$git_branch"}" 2>/dev/null && set_color white && printf " "
	set_color green
	    printf "$PWD" | sed "s/\/home\/$USER/~/"
	set_color white
        printf " "
#end
	set_color blue
	    printf "]"
	set_color white
	    printf "\n"
	set_color green
	    printf ">"
	set_color white
	    printf " "
	set_color normal
end
### PROMPT LEFT END ###

### PROMPT RIGHT BEGIN ###
function fish_right_prompt
  set -l exit_code $status
  set -l cmd_duration $CMD_DURATION
  __tmux_prompt
  if test $exit_code -ne 0
    set_color red
  else
    set_color green
  end
  printf '%d' $exit_code
    set_color blue
  printf ' (%s)' (__print_duration $cmd_duration)
  set_color normal
end

function __tmux_prompt
  set multiplexer (_is_multiplexed)

  switch $multiplexer
    case screen
      set pane (_get_screen_window)
    case tmux
      set pane (_get_tmux_window)
   end

  set_color 777777
  if test -z $pane
    echo -n ""
  else
    echo -n $pane' | '
  end
end

function _get_tmux_window
  tmux lsw | grep active | sed 's/\*.*$//g;s/: / /1' | awk '{ print $2 "-" $1 }' -
end

function _get_screen_window
  set initial (screen -Q windows; screen -Q echo "")
  set middle (echo $initial | sed 's/  /\n/g' | grep '\*' | sed 's/\*\$ / /g')
  echo $middle | awk '{ print $2 "-" $1 }' -
end

function _is_multiplexed
  set multiplexer ""
  if test -z $TMUX
  else
    set multiplexer "tmux"
  end
  if test -z $WINDOW
  else
    set multiplexer "screen"
  end
  echo $multiplexer
end

function __print_duration
  set -l duration $argv[1]

  set -l millis  (math $duration % 1000)
  set -l seconds (math -s0 $duration / 1000 % 60)
  set -l minutes (math -s0 $duration / 60000 % 60)
  set -l hours   (math -s0 $duration / 3600000 % 60)

  if test $duration -lt 60000;
    # Below a minute
    printf "%d.%03ds\n" $seconds $millis
  else if test $duration -lt 3600000;
    # Below a hour
    printf "%02d:%02d.%03d\n" $minutes $seconds $millis
  else
    # Everything else
    printf "%02d:%02d:%02d.%03d\n" $hours $minutes $seconds $millis
  end
end
function _convertsecs
  printf "%02d:%02d:%02d\n" (math -s0 $argv[1] / 3600) (math -s0 (math $argv[1] \% 3600) / 60) (math -s0 $argv[1] \% 60)
end
### PROMPT RIGHT END ###

### ASSISTIVE COLORS ###
set -U fish_color_normal normal
set -U fish_color_command green
set -U fish_color_quote cyan
set -U fish_color_redirection green
set -U fish_color_end yellow
set -U fish_color_error red
set -U fish_color_param green
set -U fish_color_comment cyan
set -U fish_color_match --background=blue
set -U fish_color_selection white --bold --background=black
set -U fish_color_search_match yellow --background=black
set -U fish_color_history_current --bold
set -U fish_color_operator blue
set -U fish_color_escape 00a6b2
set -U fish_color_cwd brgreen
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion dddddd
set -U fish_color_user green
set -U fish_color_host normal
set -U fish_color_cancel --reverse
set -U fish_pager_color_prefix normal --bold --underline
set -U fish_pager_color_progress white --background=cyan
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D
set -U fish_pager_color_selected_background --background=brblack
### ASSISTIVE COLORS END ###
