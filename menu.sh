#!/bin/bash

varMenuSelection=1

check_wifi() {
  echo -n wifi radio: 
  nmcli radio wifi
  echo ""
  nmcli dev status
  echo ""
  nmcli dev wifi list
}

while [ $varMenuSelection -gt 0 ]
do
  clear
  echo -n "acpi: "
  acpi
  echo -n "date: "
  date
  echo ""
  ncal -C
  curl wttr.in/muurame?format="%l,+%t+%C,+UV:%u\nSunrise:%S,+Sunset:%s\nTemp:%t(%f),+Wind:%w\nHumidity:%h,+Rain:%p\nPressure:%P\n"
  echo -e "\n--------- MENU ----------"
  echo "10 Connection Status"
  echo "11 Connect to Wifi"
  echo "12 Monitor Connection (wavemon)"
  echo "13 Monitor CPU and Memory (htop)"
  echo "14 Monitor PC Temp (lm-sensors)"
  echo "15 Settings Console"
  echo "20 Read News (newsboat)"
  echo "21 Search Wikipedia (wikit)"
  echo "22 Google Search (lynx)"
  echo "23 Google Translate (trans)"
  echo "24 Weather Forecast"
  echo "30 > Documents"
  echo "31 > irssi"
  echo "32 > Midnight Commander"
  echo "33 > nmap (network scanning)"
  echo "34 > cmatrix (screen saver)"
  echo "35 > cowsay (for kids)"
  echo "0 Exit"
  echo -n -e "\nEnter Number: "
  read varMenuSelection

  if [ -z $varMenuSelection ]
  then
    varMenuSelection=999
  fi
  
  if [ $varMenuSelection -eq 10 ]
  then
    echo ""
    check_wifi
    echo -e "\nPress any key to continue..."
    read
  fi

  if [ $varMenuSelection -eq 11 ]
  then
    clear
    echo "/* NETWORK CONNECTION STATUS */"
    echo ""
    check_wifi
    echo -n -e "\nEnter SSID: "
    read varSSID
    echo -n "Connect to "
    echo -n $varSSID
    echo -n "? [y/n]: "
    read varConnect
    if [varConnect -eq "y"]
    then
      nmcli dev wifi connect Lankaton password "turp0s44p1" > /dev/null
      nmcli dev status
    fi
  fi

  if [ $varMenuSelection -eq 12 ]
  then
    wavemon
  fi

  if [ $varMenuSelection -eq 13 ]
  then
    htop
  fi

  if [ $varMenuSelection -eq 14 ]
  then
    watch sensors
  fi

  if [ $varMenuSelection -eq 15 ]
  then
    echo -e "\ndpkg-reconfigure console-setup\n"  
    echo "Press any key to continue..."
    sudo dpkg-reconfigure console-setup
    read
  fi

  if [ $varMenuSelection -eq 20 ]
  then
    newsboat
  fi

  if [ $varMenuSelection -eq 21 ]
  then
    clear
    varTmp="empty"  
    while [ $varTmp != "q" ]
    do
      echo -n "Query: "
      read varTmp
      if [ $varTmp != "q" ]
      then
        echo ""
        wikit $varTmp --all |less
        echo ""
        varTmp="empty"
      fi
    done
  fi

  if [ $varMenuSelection -eq 22 ]
  then
    lynx www.google.com
  fi

  if [ $varMenuSelection -eq 23 ]
  then
    clear
    echo -e "\nSyntax: trans lang1:lang2 'string'\n"
    echo -n "Press any key to continue..."
    read
  fi

  if [ $varMenuSelection -eq 24 ]
  then
    clear
    curl wttr.in/muurame?F
    read
  fi
  
  if [ $varMenuSelection -eq 30 ]
  then
    clear
    echo "List of documents:"
    echo -e "\n1 Renshinkan Shorinji Ryu Karatedo"
    echo -n -e "\nEnter number: "
    read varTmp
    if [ $varTmp -eq 1 ]
    then
      sudo emacs -nw Documents/karate.txt
    fi
  fi

  if [ $varMenuSelection -eq 31 ]
  then
    clear
    echo "GUIDE:"
    echo "/network = lists common servers"
    echo "/connect <server from network list> = connects to server, e.g. QuakeNet"
    echo "/join #channel = join channel"
    echo "/disconnect = disconnect from server"
    echo "/names = list channel users"
    echo "/SERVER MODIFY -auto irc.quakenet.org = use server auto-connect"
    echo "/CHANNEL ADD -auto #mmp QuakeNet = use channel auto-connect"
    echo "/CHANNEL LIST = list auto configured channels"
    echo "ALT+1,2,3... = Switch between windows"
    echo "CTLR+X = Switch between servers"
    echo -e "CTRL+N = Switch between windows\n"
    echo "Press ENTER to start irssi!"
    read 
    irssi
  fi

  if [ $varMenuSelection -eq 32 ]
  then
    mc
  fi

  if [ $varMenuSelection -eq 33 ]
  then
    varTmp="empty"
    while [ $varTmp != "q" ]
    do
      clear
      echo -e "Your internet access point IP is... \n"
      ip route | grep default
      echo -n -e "\nComplete 192.168.0.X, enter X: "
      varIP="192.168.0."
      read varIPLast
      echo -n -e "\nEnter gateway mask for scanning (/8/16/24): "
      read varGateway
      varIP+=$varIPLast
      varIP+=$varGateway
      echo -n -e "\nScanning for: "
      echo -n $varIP
      echo -e " initiating...\n"
      echo "> Press ENTER to start! <"
      read 
      sudo netdiscover -r $varIP
      echo -e "\nType >sudo nmap -sV xxx.xxx.xxx.xxx< to see details from device"
      echo -e "\nPorts:"
      echo " SSH = Indicates SSH support"
      echo " HTTP = Indicates server running"
      echo -e "\nDo not scan websites with nmap, it can be illegal!"
      echo -e "\nPress ENTER to exit to console..."
      read
      exit
    done
  fi

  if [ $varMenuSelection -eq 34 ]
  then
    cmatrix
  fi

  if [ $varMenuSelection -eq 35 ]
  then
    clear
    varMsg="Hello"
    while [ $varMsg != "q" ]
    do
      echo -n "What do you want to say?: "
      read varMsg
      if [ $varMsg != "q" ]
      then
        cowsay -t $varMsg
      fi
      if [ $varMsg == "q" ]
      then
        cowsay -t "Bye Bye!"
      fi
      echo ""
      read -p "Press ENTER..."
    done
  fi

done

echo ""
