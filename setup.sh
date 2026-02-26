#!/bin/bash

set -euo pipefail
Red="\033[0;31m"
Bold="\033[1m"
Color_Off="\033[0m"
Cyan="\033[0;36m"
Green="\033[0;32m"
user_name=$(who | cut -d ' ' -f 1 | head -1)
installer_search_path="/home/$user_name"
USAGE_MESSAGE="Usage: $0 [OPTIONS]... [DIRECTORY]...
Install Cisco Packet Tracer latest version on Fedora Linux using
.deb provided by Cisco. To download the installer, access this link:
<https://www.netacad.com/portal/resources/packet-tracer>

 -d, --directory         Directory where is the installer
 -h, --help              Show this help message and exit
 --uninstall             Uninstall Cisco Packet Tracer
"
install () {
  echo "Extracting files"
  echo "Installing dependencies"
  sudo dnf -y install binutils fuse fuse-libs
  mkdir packettracer
  ar -x $selected_installer --output=packettracer
  tar -xvf packettracer/control.tar.xz --directory=packettracer
  tar -xvf packettracer/data.tar.xz --directory=packettracer 
  sudo cp -r packettracer/opt /
  ! test -d /usr/local/bin && sudo mkdir /usr/local/bin
  sudo ln -sf /opt/pt/packettracer.AppImage /usr/local/bin/packettracer
  /usr/local/bin/packettracer --pt-activate
  sudo ./packettracer/postinst
  sudo xdg-desktop-menu uninstall /usr/share/applications/cisco-pt*.desktop
  sudo update-mime-database /usr/share/mime
  sudo gtk-update-icon-cache -t --force /usr/share/icons
  sudo rm -rf packettracer
  exit
}

uninstall () {
    if [ -e /opt/pt ]; then
      echo "Uninstalling Cisco Packet Tracer."
      sudo rm -rf /opt/pt /usr/share/applications/cisco*-pt*.desktop
      sudo xdg-desktop-menu uninstall /usr/share/applications/cisco-pt*.desktop
      sudo update-mime-database /usr/share/mime
      sudo gtk-update-icon-cache -t --force /usr/share/icons

      sudo rm -f /usr/local/bin/packettracer
    fi
    echo "Cisco Packet Tracer was uninstalled."
    sleep 3
}

locate_installers () {
  # Find Cisco Packet Tracer installer
  localized_installers=()
  selected_installer=''

  echo -e "${Green}${Bold}Searching for installers in user home...${Color_Off}\n"
  c=1
  for installer in $(find $installer_search_path -type f -name "Cisco*Packet*.deb" -o -name "Packet*Tracer*.deb" -o -name "CiscoPacketTracer_900_Ubuntu_64bit.deb"); do
    localized_installers[$c]=$installer
    ((c++))
  done

  clear

  if [[ -z "${localized_installers[@]}" ]]; then
    echo -e "\n${Red}${Bold}Packet Tracer installer not found in ${installer_search_path}."
    echo -e "Expected filename pattern: ${Bold}CiscoPacketTracer_<version>_Ubuntu_64bit.deb"
    echo -e "For example: ${Bold}CiscoPacketTracer_900_Ubuntu_64bit.deb${Color_Off}\n"
    echo -e "You can download the installer from ${Cyan}https://www.netacad.com/portal/resources/packet-tracer${Color_Off} \
  or ${Cyan}https://skillsforall.com/resources/lab-downloads${Color_Off} (login required)."
    exit 1
  elif [ "${#localized_installers[@]}" -eq 1 ]; then
    selected_installer="${localized_installers[1]}"
  else

    echo -e "${Red}${Bold}Press CTRL + C to cancel installation.${Color_Off}\n"
    echo -e "${Cyan}${Bold}$((c-1)) installers of Cisco Packet Tracer was founded:${Color_Off}\n"

    PS3="Select a installer to use: "

    select installer in ${localized_installers[@]}
    do
      selected_installer=$installer
      break
    done
  fi

  echo -e "\n${Bold}Selected installer: ${Red}${Bold}$selected_installer ${Color_Off}\n"

  sleep 3
  echo "Removing old version of Packet Tracer from /opt/pt"
  uninstall
  install
}

case "${1:-}" in
    -h | --help)
        echo "$USAGE_MESSAGE"
        exit 0
    ;;

    -d | --directory)
        installer_search_path="$2"
        echo -e "A directory was especified for search the installer: ${Bold}$installer_search_path${Color_Off}"
        sleep 3
        locate_installers
    ;;

    --uninstall)
        uninstall
    ;;

esac

if [ "${1:-}" = "" ]
then locate_installers
fi
