# Plugin: zsh-just-let-me-edit-my-files
# Behavior:
# - detects non-writable target
# - ENTER => reopen with sudo
# - ESC => open normally

_let_me_edit() {
    local editor="$1"
    shift

    if (( ! ${+commands[$editor]} )); then
        print -u2 -- "zsh: command not found: $editor"
        return 127
    fi

    local arg dir sudo_needed=0

    for arg in "$@"; do
        [[ "$arg" == -* ]] && continue
        [[ "$arg" == "/dev/stdin" ]] && continue

        if [[ -e "$arg" && ! -w "$arg" ]]; then
            sudo_needed=1
        fi

        if [[ ! -e "$arg" ]]; then
            dir="$(dirname "$arg")"
            if [[ ! -d "$dir" || ! -w "$dir" ]]; then
                sudo_needed=1
            fi
        fi
    done

    if (( sudo_needed )); then
        echo "No write permission for target."
        echo "ENTER = reopen with sudo"
        echo "ESC   = open normally (no sudo)"

        local key
        read -rsk1 key

        if [[ "$key" == $'\e' ]]; then
            command "$editor" "$@"
            return $?
        fi

        # ENTER or anything else -> sudo path
        sudo "$editor" "$@"
        return $?
    fi

    command "$editor" "$@"
}

local -a _let_me_editors=(
    vim vi nano nvim
    emacs emacsclient
    helix hx
    kak kakoune
    micro pico joe jed mg ne
    vis zile ed ex
    textadept ee acme sam
)
local _let_me_editor

for _let_me_editor in "${_let_me_editors[@]}"; do
    eval "
${_let_me_editor}() {
    _let_me_edit ${_let_me_editor:q} \"\$@\"
}
"
done

unset _let_me_editor _let_me_editors
