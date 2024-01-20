if [ $# -eq 0 ]; then
    # no arguments given
    doas pacman -Syu
    if [ $? != 0 ]; then
        echo "System update failed"
        exit 0
    fi
    $HOME/IT/scripts/aur_updater.sh
elif [ "$1" == "--aur" ]; then
    # Only update AUR packages
    $HOME/IT/scripts/aur_updater.sh
else
    # arguments given, install selected programs while updating system
    doas pacman -Syu $@
fi