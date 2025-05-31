# evaluate-commands %{
#     rename-client main
#     new rename-client docs
#     new rename-client tools
#     set global docsclient docs
#     set global toolsclient tools
#     set global jumpclient main
# }

# nop %sh{
#     if [[ -n $TMUX ]]; then
#         tmux select-layout tiled
#         tmux resize-pane -t 0 -y 90
#         tmux resize-pane -t 1 -x 140
#         tmux select-pane -t 0
#     fi
# }

# def ide-place-tmux-shell-pane %{ %sh{
#     tmux move-pane -s 3 -t 1
#     tmux resize-pane -t 2 -y 20
#     tmux select-pane -t 0
# } }

define-command ide -params 0..1 %{
    try %{ rename-session %arg{1} }

    rename-client main
    set-option global jumpclient main

    new rename-client tools
    set-option global toolsclient tools

    new rename-client docs
    set-option global docsclient docs

    nop %sh{
         if [ -n "$ZELLIJ" ]; then
            zellij action focus-next-pane
            zellij action rename-pane main
            zellij action resize Increase
            zellij action resize Increase

            zellij action focus-next-pane
            zellij action rename-pane tools
            zellij action resize Increase Down
            zellij action resize Increase Down

            zellij action focus-next-pane
            zellij action rename-pane docs
            # make docs a hidden floating pane
            zellij action toggle-pane-embed-or-floating
            zellij action toggle-floating-panes

            zellij action focus-next-pane # back to main
        fi
    }
}

hook global ClientClose %opt{jumpclient} %{
    try %{ evaluate-commands -try-client %opt{toolsclient} %{
        quit!
    }}
    try %{ evaluate-commands -try-client %opt{docsclient} %{
        quit!
    }}
    quit!  # Exit the server itself
}

hook global BufCreate .* %{
    evaluate-commands %sh{
         # if [ -n "$ZELLIJ" ]; then
        if [ "$kak_client" = "docsclient" ]; then
            # Call zellij to unhide or focus
            zellij action toggle-floating-panes
        fi
    }
}

define-command ide-tmux -params 0..1 %{
    try %{ rename-session %arg{1} }

    rename-client main
    set-option global jumpclient main

    new rename-client tools
    set-option global toolsclient tools

    new rename-client docs
    set-option global docsclient docs

    nop %sh{
        if [[ -n $TMUX ]]; then
            tmux select-layout tiled
            tmux resize-pane -t 0 -y 90
            tmux resize-pane -t 1 -x 140
            tmux select-pane -t 0

            tmux move-pane -s 3 -t 1
            tmux resize-pane -t 2 -y 20
            tmux select-pane -t 0
        fi
    }
}
