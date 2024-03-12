#!/bin/bash
#sonita
#04/03/2024

url_file='/srv/yt/playlist.txt'
_youtube_dl='/usr/local/bin/youtube-dl'
while :
do

  url="$(head -n 1 ${url_file})"
  title=$("${_youtube_dl}" -e "${url}")
  date=$(date '+[%y/%m/%d %H:%M:%S]')
  path="/srv/yt/downloads/${title}"

  if [[ ! -d "${path}" ]] ; then
    mkdir "${path}"
  fi
  "${_youtube_dl}" -o "${path}/${title}.mp4" --format mp4 "${url}" > /dev/null

  "${_youtube_dl}" --get-description "${url}" > "${path}/description"


  echo "Video ${url} was downloaded."
  echo "File path : ${path}/${title}.mp4"

  echo "${date} Video ${url} was downloaded. File Path : ${path}/${title}" >> /var/log/yt/download.log
  sed -i '1d' "${url_file}"
  sleep 1
done
