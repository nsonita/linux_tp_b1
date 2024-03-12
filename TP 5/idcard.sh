#!/bin/bash
#sonita
#23/02/2024

machine_name=$(hostnamecl | grep Static | cut -d' ' -f4)
echo "Machine name : ${machine_name}"

os_name=$(cat /etc/os-release | head -n 1 | cut -d'=' -f2)
u_name=$(cat /etc/os-release | sed -n 2p | cut -d'=' -f2)
echo "OS ${os_name} and kernel version is ${u_name}"

ip_name=$(ip a | grep inet | grep -v inet6 | sed -n 2p | tr -s " " | cut -d " " -f3)
echo "IP : ${ip_name}"

ram_free=$(free -h --mega | sed -n 2p | tr -s " " | cut -d " " -f4)
ram_total=$(free -h --mega | sed -n 2p | tr -s " " | cut -d " " -f2)
echo "RAM : ${ram_free} memory available on ${ram_total} total memory"

disk_free=$(df -h | grep sda1 | tr -s " " | cut -d " " -f4)
echo "Disk : ${disk_free} space left"

top_process=$(ps aux --sort -%mem | head -6 | tr -s " " | cut -d " " -f11 | rev | cut -d "/" -f1 | rev)
echo "Top 5 processes by RAM usage : ${top_process}"


echo "Listening ports :"
while read sonita
do
        port="$(echo $sonita | cut -d ' ' -f5 | cut -d ':' -f2)"
        proto="$(echo $sonita | tr -s ' ' | cut -d ' ' -f1)"
        prog="$(echo $sonita | tr -s ' ' | cut -d '"' -f2)"

        echo " - ${port} ${proto} : ${prog}"
done <<< "$(sudo ss -lntu4Hp)"


echo "PATH directories :"
while read sonita
do
        path1="$(echo $sonita | cut -d ':' -f1)"
        path2="$(echo $sonita | cut -d ':' -f2)"
        path3="$(echo $sonita | cut -d ':' -f3)"
        path4="$(echo $sonita | cut -d ':' -f4)"
        path5="$(echo $sonita | cut -d ':' -f5)"
        path6="$(echo $sonita | cut -d ':' -f6)"

        echo " - ${path1}"
        echo " - ${path2}"
        echo " - ${path3}"
        echo " - ${path4}"
        echo " - ${path5}"
        echo " - ${path6}"
done <<< "$(echo $PATH)"


path_img=$(curl https://api.thecatapi.com/v1/images/search -s | cut -d '"' -f8)
echo "Here is your random cat (jpg file) : $path_img"
