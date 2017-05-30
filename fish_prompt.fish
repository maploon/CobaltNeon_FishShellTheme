# name: CoffeeAndCode
# Theme colors
set fish_color_cwd 00875f

set fish_color_host cyan
set fish_color_user cyan

# Git prompt setup
set __fish_git_prompt_char_untrackedfiles '*'
set __fish_git_prompt_color yellow
set __fish_git_prompt_color_stashstate red --bold
set __fish_git_prompt_showdirtystate true
set __fish_git_prompt_showstashstate true
set __fish_git_prompt_showuntrackedfiles true


function fish_prompt --description 'Write out the prompt'

    set -g last_status $status

    function _status_indicator
        if test $last_status -eq 0
            set_color green
            echo "->"
        else
            set_color red
            echo "-x"
        end
    end

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
  end

  # function prompt_pwd
  #   echo $PWD | sed -e "s|^$HOME|~|"
  # end

  switch $USER

  case root

    if not set -q __fish_prompt_cwd
      if set -q fish_color_cwd_root
        set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
      else
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
      end
    end

  case '*'

    if not set -q __fish_prompt_cwd
      set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

  end

  if not set -q __fish_prompt_user
    set -g __fish_prompt_user (set_color $fish_color_user)
  end
  if not set -q __fish_prompt_host
    set -g __fish_prompt_host (set_color $fish_color_host)
  end

  function _git_branch_name
    echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
  end

  function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty ^/dev/null)
  end

  function _git_info
      if [ (_git_branch_name) ]
        set -l git_branch (_git_branch_name)
        if [ (_is_git_dirty) ]
          echo (set_color normal)" @ "(set_color red)$git_branch
        else
          echo (set_color normal)" @ "(set_color yellow)$git_branch
        end
      end
  end

  echo -s (set_color yellow) "(" (date "+$c2%H$c0:$c2%M$c0:$c2%S") ") "\u2022 " " (set_color normal) "$__fish_prompt_user" "[$USER" @ "$__fish_prompt_host" "$__fish_prompt_hostname]" "$__fish_prompt_normal" ' ' "$__fish_prompt_cwd" (set_color green) (prompt_pwd) (_git_info)
  echo -s (_status_indicator) ' '
end
