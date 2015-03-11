#!/bin/sh
username=username
password=password
networkname=ssid
authhost=1.1.1.1

if [[ $1 = "off" ]]; then
  if [[ `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep ${networkname}| wc -l` -ge 1 ]]; then
    route=`netstat -rn | grep default | awk {'print $2'}`
    echo "logging off..."
    sudo route add ${authhost}/32 $route > /dev/null 2>/dev/null
    curl -o /dev/null -s -k "https://${authhost}/logout.html?Logout=Logout&buttonClicked=4" > /dev/null
  exit 0
  fi
fi

if [[ `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep ${networkname}| wc -l` -ge 1 ]]; then
  route=`netstat -rn | grep default | awk {'print $2'}`
  echo "Connected to ${networkname} wireless network, enabling Cisco network"
  sudo route add ${authhost}/32 $route > /dev/null 2>/dev/null
  echo "Enabling the Cisco network"
  curl -o /dev/null -s -k "https://${authhost}/logout.html?Logout=Logout&buttonClicked=4" > /dev/null
  sleep 3
  curl -o /dev/null -s -k "https://${authhost}/login.html?username=${username}&password=${password}&buttonClicked=4" > /dev/null
  ping -c 1 -t 5 ${authhost} > /dev/null 2>/dev/null
  if [[ $? -eq 0 ]]; then
    echo "Cisco network enabled"
  else
    echo "Could not enable Cisco network"
    exit 1
  fi
else
  echo "Not connected to ${networkname} wireless network"
fi

exit 0
