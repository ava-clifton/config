ACTIVE_START=#[bg=grey]#[fg=black]
ACTIVE_STOP=#[bg=black]#[fg=white]

tmux ls -F "#{session_created}\#{?session_attached,$ACTIVE_START,} #{session_name} #{?session_attached,$ACTIVE_STOP,}|"     | sort | cut -c12- | tr -d "\n"
#tmux ls -F "\#{?session_attached,$ACTIVE_START,} #{session_name} #{?session_attached,$ACTIVE_STOP,}|" | sort | cut -c2- | tr -d "\n"
