#!/bin/sh

LOG_PIPE=log.pipe
rm -f LOG_PIPE
mkfifo ${LOG_PIPE}
LOG_FILE=log.file
rm -f LOG_FILE
tee < ${LOG_PIPE} ${LOG_FILE} &

exec  > ${LOG_PIPE}
exec  2> ${LOG_PIPE}

# Авто установщик Firewall ScladTeam.ru
# Update установщик от 12.12.2021 года

Infon() {
	printf "\033[1;32m$@\033[0m"
}
Info()
{
	Infon "$@\n"
}
Error()
{
	printf "\033[1;31m$@\033[0m\n"
}
Error_n()
{
	Error "- - - $@"
}
Error_s()
{
	Error "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_s()
{
	Info "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - "
}
log_n()
{
	Info "- - - $@"
}
log_t()
{
	log_s
	Info "- - - $@"
	log_s
}
infomenu()
{
	Info "${yellow}♥ • • • • • • | ${red}Добро пожаловать в установочное меню ${green}Firewall${BLUE} ScladTeam.ru ${yellow} | • • • • • • ♥"
}
log_tt()
{
	Info "• —————————————————————————— ${red}$@${green} ——————————————————————————— • "
}
log_tt1()
{
	Info "• ——————————————— ${red}$@${green} ————————————————— •"
}
RED=$(tput setaf 1)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
white=$(tput setaf 7)
reset=$(tput sgr0)
toend=$(tput hpa $(tput cols))$(tput cub 6)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
LIME_YELLOW=$(tput setaf 190)
CYAN=$(tput setaf 6)

firewall_ScladTeam.ru_lite()
{
echo "${green}Loading Firewall Lite v1.0, by ScladTeam.ru ${reset}"
apt update
apt upgrade
apt install iptables
apt install ipset
iptables -N TCP
iptables -N UDP
iptables -N SYN_FLOOD
iptables -N block-scan
iptables -P INPUT ACCEPT
iptables -F
iptables -t mangle -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t mangle -A PREROUTING -p icmp -j DROP
iptables -t mangle -A PREROUTING -m state --state INVALID -j DROP
iptables -t mangle -A PREROUTING -p tcp ! --syn -m state --state NEW -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -p icmp -j DROP --icmp-type 8
iptables -I INPUT -p udp --dport 53 -j DROP -m iplimit --iplimit-above 1
iptables -A INPUT -p tcp --syn --dport 22 -m connlimit --connlimit-above 3 -j REJECT
iptables -p tcp --syn --dport 80 -m connlimit --connlimit-above 40 --connlimit-mask 24 -j DROP
iptables -A SYN_FLOOD -m limit --limit 50/sec --limit-burst 500 -j RETURN
iptables -A block-scan -p tcp —tcp-flags SYN,ACK,FIN,RST -m limit —limit 1/s -j RETURN
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 5 -j DROP
iptables -A block-scan -j DROP
iptables -A SYN_FLOOD -j DROP
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 5432 -j ACCEPT
iptables -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -A INPUT -p tcp --dport 993 -j ACCEPT
iptables -A INPUT -p tcp --dport 25 -j ACCEPT
iptables-save > /etc/iptables.rules
    clear
	Info
	log_t "• Установка ${red}Firewall${BLUE} ScladTeam.ru Lite v1.0 ${green}завершена ✔"
	Info "• - ${red}Внимания!${green} Доступные по стандарту порты TCP: 21, 22, 80, 8080, 443, 53, 3306, 5432, 110, 143, 993, 25"
	Info "• - ${red}1${green}  -  Разблокировать все порты TCP/UDP"
	Info "• - ${red}2${green}  -  Главное Меню"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	    1) allport_firewall;;
	    2) menu;;
		0) exit;;
	esac
}
badzone()
{
echo '${green}Loading the database of bad IP from Bad Zone (Github GNU v3) ${reset}'
apt update
apt upgrade
apt install wget
apt install curl
apt install ipset
https://github.com/Rezanans-wow/BZ-antiddos/releases/download/Stable/script_antistresser.sh
chmod +x script_antistresser.sh
./script_antistresser.sh
    clear
	Info
	log_t "• Установка ${red}BadZone${BLUE} (Github GNU v3) ${green}завершена ✔"
	Info "• - ${red}1${green}  -  Главное Меню"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	    1) menu;;
		0) exit;;
	esac
}
allport_firewall()
{
iptables -A INPUT -p tcp --dport 0:65535 -j ACCEPT
iptables -A INPUT -p udp --dport 0:65535 -j ACCEPT
iptables-save
clear
	Info
	log_t "• ${red}Разблокирован${BLUE} диапазон портов TCP/UDP ${green}0-65535 ✔"
	Info "• - ${red}1${green}  -  Главное Меню"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	    1) menu;;
		0) exit;;
	esac
}
contacts()
{
    clear
	Info
	log_t "• Контакты ${red}Firewall${BLUE} ScladTeam.ru ${green} ✔"
	Info "• Наш сайт ${BLUE}www.ScladTeam.ru"
	Info "• Группа VK ${BLUE}www.vk.com/scladovh"
	Info "• Наша почта ${BLUE}contact@ScladTeam.ru"
	Info "• - ${red}1${green}  -  Главное Меню"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	    1) menu;;
		0) exit;;
	esac
}
info_firewall()
{
clear
	Info
	log_t "• SSH Команды ${red}Firewall${green} ✔"
	Info "• ${BLUE}Помощь по iptables ${red}-> ${green}https://www.opennet.ru/docs/RUS/iptables/"
	Info "• - ${red}1${green}  -  Главное Меню"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
		1) menu;;
		0) exit;;
	esac
}
menu()
{
	clear
	Info
	log_t "• Добро пожаловать в установочное меню ${red}Firewall${BLUE} ScladTeam.ru ${green}✔"
	Info "- - - • Поддерживаемые ${red}OS:${BLUE} Debian 9/10, Ubuntu 18.04/20.04${green}✔"
	Info "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	Info "• - ${red}1${green}  -  Установить ${red}Firewall${BLUE} ScladTeam.ru Lite (v1.0)${green} -> Базовая защита сервера"
	Info "• - ${red}2${green}  -  Установить/Обновить ${red}BadZone${BLUE} Github GNU v3 ${green}-> База «плохих» IP"
	Info "• - ${red}3${green}  -  Команды ${red}Firewall"
	Info "• - ${red}4${green}  -  Контакты"
	Info "• - ${red}0${green}  -  Выход"
	log_s
	Info
	read -p "Пожалуйста, введите пункт меню: " case
	case $case in
	    1) firewall_ScladTeam.ru_lite;;
		2) badzone;;
		3) info_firewall;;
		4) contacts;;
		0) exit;;
	esac
}
menu
