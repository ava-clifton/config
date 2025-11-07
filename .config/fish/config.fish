if status is-interactive
    # Commands to run in interactive sessions can go here
    bind \t complete

    alias nvim=~/nvim.appimage
    alias lua-language-server=~/ava/lua_language_server/lua-language-server-3.15.0-linux-x64/bin/lua-language-server
    alias nvimnote='nvim ~/data/notes/note__$(date +%Y_%m_%d__%H_%M_%S).md'
    source ~/.venv/bin/activate.fish
    mount /mnt/orgmode/ 2&> /dev/null
    alias org='cd /mnt/orgmode/orgfiles && ls'
    alias s='git status'
    alias d='git diff'
end


function cd
	builtin cd $argv && ls
end

set -U fish_greeting
