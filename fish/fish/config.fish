if status --is-interactive
    if set -q SSH_CONNECTION[1]; and set -q SSH_CLIENT[1]; and set -q SSH_TTY[1]; or pstree -p | grep "sshd.*\($fish_pid\)"; and not set -q TMUX
        tmux new -AD -t remote -s remote
    end
end
function fish_title
    # `prompt_pwd` shortens the title. This helps prevent tabs from becoming very wide.
    echo $argv[1] (prompt_pwd)
end
