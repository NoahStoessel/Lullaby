function fish_prompt

  # Set color for variables in prompt
  set -l normal (set_color normal)
  set -l white (set_color FFFFFF)
  set -l turquoise (set_color 74c7ec) # done
  set -l orange (set_color fab387) # done
  set -l hotpink (set_color f5c2e7) # dobe
  set -l blue (set_color 89b4fa) # done
  set -l limegreen (set_color a6e3a1) #done
  set -l purple (set_color cba6f7)
  set -l red (set_color f38ba8) # done


  # Cache exit status
  set -l last_status $status


  # Configure __fish_git_prompt
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color a6e3a1
  set -g __fish_git_prompt_color_flags fab387
  set -g __fish_git_prompt_color_prefix 89dceb
  set -g __fish_git_prompt_color_suffix 89dceb
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true

  # FIXME: below var causes rendering issues with fish v3.2.0
  set -g __fish_git_prompt_show_informative_status true
  # Only calculate once, to save a few CPU cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    # set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    set -g __fish_prompt_hostname $purple(prompt_hostname)(set_color normal)
  end
  if not set -q __fish_prompt_char
    if [ (id -u) -eq 0 ]
      set -g __fish_prompt_char (set_color red)'➤'(set_color normal)
    else
      set -g __fish_prompt_char '➤'
    end
  end

  # change `at` to `ssh` when an interactive ssh session is present
  if [ "$SSH_TTY" = "" ]
    set -g location $limegreen@$normal
    # set -g __fish_prompt_hostname (set_color orange)(hostname|cut -d . -f 1)
  else # connected via ssh
    if [ "$TERM" = "xterm-256color-italic" -o "$TERM" = "tmux-256color" ]
      set -g location (echo -e "\e[3mssh\e[23m")
      # set -g ssh_hostname (echo -e $blue$__fish_prompt_hostname)
      set -g __fish_prompt_hostname $blue(prompt_hostname)(set_color normal)
    else
      set -g location ssh
      # set -g ssh_hostname (echo -e $blue$__fish_prompt_hostname)
      set -g __fish_prompt_hostname $blue(prompt_hostname)(set_color normal)
    end
  end

  if [ (id -u) -eq 0 ]
    # top line > Superuser
    echo -n $red'╭─'$blue$USER $white$location $__fish_prompt_hostname$white' in '$red(pwd)$turquoise
    __fish_git_prompt " (%s)"
    echo
    # bottom line > Superuser
    echo -n $red'╰'
    echo -n $red'──'$__fish_prompt_char $normal
  else # top line > non superuser's
    echo -n $white'╭─'$blue$USER $white$location $__fish_prompt_hostname$white' → '$red(pwd)$turquoise
    __fish_git_prompt " (%s)"
    echo
    # bottom line > non superuser's
    echo -n $white'╰'
    echo -n $white'──'$__fish_prompt_char $normal
  end

  # NOTE: disable `VIRTUAL_ENV_DISABLE_PROMPT` in `config.fish`
  # see:  https://virtualenv.pypa.io/en/latest/reference/#envvar-VIRTUAL_ENV_DISABLE_PROMPT
  # support for virtual env name
  if set -q VIRTUAL_ENV
      echo -n "($turquoise"(basename "$VIRTUAL_ENV")"$white)"
  end
end
