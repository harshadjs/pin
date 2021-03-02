_pin_complete()
{
    COMPREPLY=($(pin list-all))
    return 0
}

complete -F _pin_complete pin
