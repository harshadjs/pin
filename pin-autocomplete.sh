_pin_complete_cmds()
{
    local i
    CMDS_DIR=$(pin show-config | grep CMDS_DIR | cut -d "=" -f2)
    i=0
    for file in $(ls $CMDS_DIR -tr | grep -v .git); do
	. $CMDS_DIR/$file
	if [ "$TYPE" = "cmd" ]; then
	    COMPREPLY+=("$(echo "$i ## $(echo $CMD | base64 -d -)")")
	elif [ "$TYPE" = "script" ]; then
	    COMPREPLY+=("$(echo "$i ## $(cat $CMDS_DIR/$file | grep DESC | cut -d "=" -f 2)")")
	elif [ "$1" = "dump" ]; then
	    COMPREPLY+=("$(echo "$i ## $(cat $CMDS_DIR/$file | grep DESC | cut -d "=" -f 2)")")
	fi
	i=$((i+1))
    done
}

_pin_complete()
{
    local prev
    local cur
    COMPREPLY=()
    if [ "$COMP_CWORD" = "1" ]; then
	COMPREPLY=($(pin list-all))
	return 0
    fi
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case $prev in
	"ls")
	    COMPREPLY=($(compgen -W "$(pin categories)" -- "$cur"))
	    ;;
	"grep")
	    COMPREPLY=($(compgen -W "$(pin tags)" -- "$cur"))
	    ;;
	"run" | "watch" | "desc" | "describe" | "export" | "e" | "export-b64" | "eb64" | "dump")
	    _pin_complete_cmds $prev
	    ;;
	*)
	    ;;
    esac
    return 0
}

complete -F _pin_complete pin
