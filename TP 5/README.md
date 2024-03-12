# Partie 1 : Script carte d'identité


## Rendu

📁 **Fichier `/srv/idcard/idcard.sh`**

🌞 **Vous fournirez dans le compte-rendu Markdown**, en plus du fichier, **un exemple d'exécution avec une sortie**
```
[sonita@linux ~]$ /srv/idcard/idcard.sh
/srv/idcard/idcard.sh: line 5: hostnamecl: command not found
Machine name :
OS "Rocky Linux" and kernel version is "9.2 (Blue Onyx)"
IP : 10.5.1.254/24
RAM : 272M memory available on 771M total memory
Disk : 795M space left
Top 5 processes by RAM usage : COMMAND
 - python3
 - NetworkManager
 - systemd
 - systemd
 - systemd
Listening ports :
 - 323 udp : chronyd
 - 22 tcp : sshd
PATH directories :
 - /home/sonita/.local/bin
 - /home/sonita/bin
 - /usr/local/bin
 - /usr/bin
 - /usr/local/sbin
 - /usr/sbin
Here is your random cat (jpg file) : https://cdn2.thecatapi.com/images/q8.jpg
```



# II. Script youtube-dl
## 1. Premier script youtube-dl

### A. Le principe

### B. Rendu attendu
🌞 Vous fournirez dans le compte-rendu, en plus du fichier, **un exemple d'exécution avec une sortie**
```
# Exemple d'exécution
[sonita@linux ~]$ /srv/yt/yt.sh https://www.youtube.com/watch?v=cJUIPbiKmh4
Video https://www.youtube.com/watch?v=cJUIPbiKmh4 was downloaded.
File path : /srv/yt/downloads/Gaspard de la nuit, M. 55: I. Ondine/Gaspard de la nuit, M. 55: I. Ondine.mp4
```

```
# Fichier log
[sonita@linux yt]$ cat download.log
[24/03/05 20:42:06] Video https://www.youtube.com/watch?v=cJUIPbiKmh4 was downloaded. File Path : /srv/yt/downloads/Gaspard de la nuit, M. 55: I. Ondine/Gaspard de la nuit, M. 55: I. Ondine
[24/03/05 20:47:11] Video https://www.youtube.com/watch?v=BqQF7axoEHg was downloaded. File Path : /srv/yt/downloads/Miroirs, M. 43: III. Une barque sur l'océan/Miroirs, M. 43: III. Une barque sur l'océan
[24/03/05 21:20:24] Video https://www.youtube.com/watch?v=VJi7VDLhGbw was downloaded. File Path : /srv/yt/downloads/Jeux d'eau, M. 30/Jeux d'eau, M. 30
[24/03/05 21:22:25] Video https://www.youtube.com/watch?v=I4nIlKTkUfc was downloaded. File Path : /srv/yt/downloads/Ravel: Introduction And Allegro For Harp Flute Clarinet And Strings/Ravel: Introduction And Allegro For Harp Flute Clarinet And Strings
```

## 2. MAKE IT A SERVICE

### A. Adaptation du script
### C. Rendu

📁 **Le script `/srv/yt/yt-v2.sh`**

📁 **Fichier `/etc/systemd/system/yt.service`**

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :

- un `systemctl status yt` quand le service est en cours de fonctionnement
```
[sonita@linux ~]$ sudo systemctl start yt
[sonita@linux ~]$ systemctl status yt
● yt.service - "Service pour faire tourner yt-v2.sh"
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; preset: disabled)
     Active: active (running) since Fri 2024-03-08 02:14:58 CET; 4s ago
   Main PID: 62376 (yt-v2.sh)
      Tasks: 2 (limit: 4674)
     Memory: 9.1M
        CPU: 2.565s
     CGroup: /system.slice/yt.service
             ├─62376 /bin/bash /srv/yt/yt-v2.sh
             └─62380 python /usr/local/bin/youtube-dl -o "/srv/yt/downloads/Jeux d'eau, M. 30/Jeux d'e>

Mar 08 02:14:58 linux.tp5.b1 systemd[1]: Started "Service pour faire tourner yt-v2.sh".
```


- un extrait de `journalctl -xe -u yt`
```
[sonita@linux ~]$ journalctl -xe -u yt
░░ The job identifier is 16273.
Mar 08 02:15:09 linux.tp5.b1 yt-v2.sh[62376]: Video https://www.youtube.com/watch?v=VJi7VDLhGbw was do>
Mar 08 02:15:09 linux.tp5.b1 yt-v2.sh[62376]: File path : /srv/yt/downloads/Jeux d'eau, M. 30/Jeux d'e>
Mar 08 02:15:20 linux.tp5.b1 yt-v2.sh[62376]: Video https://www.youtube.com/watch?v=TfF4qywNJUc was do>
Mar 08 02:15:20 linux.tp5.b1 yt-v2.sh[62376]: File path : /srv/yt/downloads/Pavane pour une infante dé>
Mar 08 02:15:31 linux.tp5.b1 yt-v2.sh[62376]: Video https://www.youtube.com/watch?v=f-UNdsolMFQ was do>
Mar 08 02:15:31 linux.tp5.b1 yt-v2.sh[62376]: File path : /srv/yt/downloads/A la manière de... Chabrie>
Mar 08 02:15:42 linux.tp5.b1 yt-v2.sh[62376]: Video https://www.youtube.com/watch?v=kzQEQqQmwIo was do>
Mar 08 02:15:42 linux.tp5.b1 yt-v2.sh[62376]: File path : /srv/yt/downloads/Miroirs, M. 43: I. Noctuel>
Mar 08 02:15:51 linux.tp5.b1 systemd[1]: Stopping "Service pour faire tourner yt-v2.sh"...
```

🌟**BONUS** : get fancy. Livrez moi un gif ou un [asciinema](https://asciinema.org/) (PS : c'est le feu asciinema) de votre service en action, où on voit les URLs de vidéos disparaître, et les fichiers apparaître dans le fichier de destination
```
watch -n0.5 cat /srv/yt/playlist.txt | lolcat
[à regarder jusqu'au bout, il y a un TGV qui passe à la fin ! 👀](https://asciinema.org/a/b8cNpw3FAEUvVSVXz4lYKgy27)
```
