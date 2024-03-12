#!/bin/bash
#sonita
#04/03/2024

url="$1"
title=$(youtube-dl -e "${url}")
date=$(date '+[%y/%m/%d %H:%M:%S]')
path="/srv/yt/downloads/${title}"


mkdir "${path}"
youtube-dl -o "${path}/${title}.mp4" --format mp4 "${url}" > /dev/null
youtube-dl --get-description "${url}" > "${path}/description"


echo "Video ${url} was downloaded."
echo "File path : ${path}/${title}.mp4"
echo "${date} Video ${url} was downloaded. File Path : ${path}/${title}" >> /var/log/yt/download.log

/srv/yt/yt-v2.sh