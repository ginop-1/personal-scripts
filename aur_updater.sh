aur_dir="$HOME/Programs"

green="\e[32m"
red="\e[31m"
reset="\e[0m"

# figlet -f standard "AUR Updater"

# get list of installed AUR packages
aur_pkgs="$(pacman -Qqm)"
# transform to array
aur_pkgs=($aur_pkgs)

echo "Checking for AUR updates..."
# create array for packages that need updating
aur_updates=()

for i in $(ls $aur_dir); do

    # checks if package i is not in aur_pkgs
    if ! [[ " ${aur_pkgs[*]} " == *" $i "* ]]; then
        # echo -e "${red}$i${reset} is not an AUR package"
        continue
    fi

    cd $aur_dir/$i

    # check if there are any updates
    git fetch --quiet
    if [ $(git rev-parse HEAD) == $(git rev-parse @{u}) ] ; then
        # up to date
        continue
    else
        # not up to date
        aur_updates+=($i)
    fi
done

if [ ${#aur_updates[@]} -eq 0 ]; then
    echo "No updates for AUR packages"
else
    echo "Those packages needs to be updated:"
    for i in ${aur_updates[@]}; do
        echo $i
    done
    echo "Do you want to update them? [y/n]"
    read -r answer
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ] || [ "$answer" == "" ] ; then
        for i in ${aur_updates[@]}; do
            cd $aur_dir/$i
            git pull --quiet
            makepkg -sir --noconfirm
        done
    fi
fi

exit 0
