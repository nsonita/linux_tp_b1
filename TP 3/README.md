# I. Service SSH

## 1. Analyse du service

On va, dans cette première partie, analyser le service SSH qui est en cours d'exécution.

🌞 **S'assurer que le service `sshd` est démarré**

- avec une commande `systemctl status`
```
[sonita@supermachine ~]$ systemctl status
● supermachine
    State: running
    Units: 279 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Mon 2024-01-29 14:21:26 CET; 8min ago
  systemd: 252-13.el9_2
             │ ├─sshd.service
           │ │ └─704 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"
               │ ├─1424 "sshd: sonita [priv]"
               │ ├─1431 "sshd: sonita@pts/0"
               │ └─1486 grep --color=auto sshd
  sshd.service                           loaded    active   running OpenSSH server daemon
```


🌞 **Analyser les processus liés au service SSH**

- afficher les processus liés au service `sshd`
  - vous pouvez afficher la liste des processus en cours d'exécution avec une commande `ps`
  - pour rappel "un processus" c'est juste un programme qu'on a "lancé", qui a donc été déplacé en RAM et qui est en cours d'exécution
  - pour le compte-rendu, vous devez filtrer la sortie de la commande en ajoutant `| grep <TEXTE_RECHERCHE>` après une commande
    - au cas où un ptit rappel de l'utilisation de `| grep` :
```
[sonita@supermachine ~]$ ps -ef | grep sshd
root         704       1  0 14:21 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1424     704  0 14:26 ?        00:00:00 sshd: sonita [priv]
sonita      1431    1424  0 14:27 ?        00:00:00 sshd: sonita@pts/0
sonita      1481    1432  0 14:38 pts/0    00:00:00 grep --color=auto sshd
```


🌞 **Déterminer le port sur lequel écoute le service SSH**

- avec une commande `ss`
  - il faudra ajouter des options à la commandes `ss` pour que ce soit des infos plus lisibles (encore une fois, [voir le mémoooooo y'a des exemples de commandes](../../cours/memo/shell.md).
- isolez les lignes intéressantes avec un `| grep <TEXTE>`
```
[sonita@supermachine ~]$ sudo ss -alnpt | grep sshd
LISTEN 0      128          0.0.0.0:22        0.0.0.0:*    users:(("sshd",pid=704,fd=3))
LISTEN 0      128             [::]:22           [::]:*    users:(("sshd",pid=704,fd=4))
```


🌞 **Consulter les logs du service SSH**

- les logs du service sont consultables avec une commande `journalctl`
  - donnez une commande `journalctl` qui permet de consulter les logs du service SSH
```
[sonita@node1 ~]$ journalctl | grep sshd
Jan 29 15:06:54 router.tp5.b1 systemd[1]: Created slice Slice /system/sshd-keygen.
Jan 29 15:06:57 router.tp5.b1 systemd[1]: Reached target sshd-keygen.target.
Jan 29 15:07:00 router.tp5.b1 sshd[703]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 15:07:00 router.tp5.b1 sshd[703]: Server listening on 0.0.0.0 port 22.
Jan 29 15:07:00 router.tp5.b1 sshd[703]: Server listening on :: port 22.
Jan 29 15:07:15 router.tp5.b1 sshd[1329]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 15:07:17 router.tp5.b1 sshd[1329]: Accepted password for sonita from 10.5.1.1 port 61680 ssh2
Jan 29 15:07:17 router.tp5.b1 sshd[1329]: pam_unix(sshd:session): session opened for user sonita(uid=1001) by (uid=0)
Jan 29 15:07:57 node1.tp3.b1 sshd[1333]: Received disconnect from 10.5.1.1 port 61680:11: disconnected by user
Jan 29 15:07:57 node1.tp3.b1 sshd[1333]: Disconnected from user sonita 10.5.1.1 port 61680
Jan 29 15:07:57 node1.tp3.b1 sshd[1329]: pam_unix(sshd:session): session closed for user sonita
Jan 29 15:07:59 node1.tp3.b1 sshd[1363]: main: sshd: ssh-rsa algorithm is disabled
Jan 29 15:08:00 node1.tp3.b1 sshd[1363]: Accepted password for sonita from 10.5.1.1 port 61737 ssh2
Jan 29 15:08:00 node1.tp3.b1 sshd[1363]: pam_unix(sshd:session): session opened for user sonita(uid=1001) by (uid=0)
```

- AUSSI, il existe un fichier de log, dans lequel le service SSH enregistre toutes les tentatives de connexion
  - il est dans le dossier `/var/log`
  - utilisez une commande `tail` pour visualiser les 10 dernière lignes de ce fichier
```
[sonita@node1 log]$ tail dnf.log
2023-11-21T10:43:01+0100 DEBUG reviving: 'appstream' can be revived - repomd matches.
2023-11-21T10:43:01+0100 DEBUG appstream: using metadata from Thu 16 Nov 2023 11:54:50 PM CET.
2023-11-21T10:43:01+0100 DEBUG countme: no event for extras: budget to spend: 1
2023-11-21T10:43:02+0100 DEBUG reviving: 'extras' can be revived - repomd matches.
2023-11-21T10:43:02+0100 DEBUG extras: using metadata from Thu 16 Nov 2023 11:55:32 PM CET.
2023-11-21T10:43:02+0100 DEBUG User-Agent: constructed: 'libdnf (Rocky Linux 9.2; generic; Linux.x86_64)'
2023-11-21T10:43:02+0100 DDEBUG timer: sack setup: 1527 ms
2023-11-21T10:43:02+0100 INFO Metadata cache created.
2023-11-21T10:43:02+0100 DDEBUG Cleaning up.
2023-11-21T10:43:02+0100 DDEBUG Plugins were unloaded.
```


## 2. Modification du service

Dans cette section, on va aller visiter et modifier le fichier de configuration du serveur SSH.

Comme tout fichier de configuration, celui de SSH se trouve dans le dossier `/etc/`.

Plus précisément, il existe un sous-dossier `/etc/ssh/` qui contient toute la configuration relative à SSH

🌞 **Identifier le fichier de configuration du serveur SSH**
```
[sonita@node1 ssh]$ sudo cat sshd_config
```


🌞 **Modifier le fichier de conf**

- exécutez un `echo $RANDOM` pour **demander à votre shell de vous fournir un nombre aléatoire**
  - simplement pour vous montrer la petite astuce et vous faire manipuler le shell :)
  - pour un numéro de port valide, c'est entre 1 et 65535 ! 
```
[sonita@node1 ssh]$ echo $RANDOM
10055
```

- **changez le port d'écoute du serveur SSH** pour qu'il écoute sur ce numéro de port
  - il faut modifier le fichier avec `nano` ou `vim` par exemple
  - dans le compte-rendu je veux un `cat` du fichier de conf
  - filtré par un `| grep` pour mettre en évidence la ligne que vous avez modifié
```
[sonita@node1 ssh]$ sudo cat sshd_config | grep Port
Port 10055
```

- **gérer le firewall**
  - fermer l'ancien port
  - ouvrir le nouveau port
  - vérifier avec un `firewall-cmd --list-all` que le port est bien ouvert
    - vous filtrerez la sortie de la commande avec un `| grep TEXTE`


🌞 **Redémarrer le service**

- avec une commande `systemctl restart`
```
[sonita@node1 ssh]$ sudo firewall-cmd --add-port=10055/tcp --permanent
success
[sonita@node1 ssh]$ sudo firewall-cmd --reload
success
```


🌞 **Effectuer une connexion SSH sur le nouveau port**

- depuis votre PC
- il faudra utiliser une option à la commande `ssh` pour vous connecter à la VM
```
PS C:\Users\Sonita Nou> ssh sonita@10.5.1.254 -p 10055
sonita@10.5.1.254's password:
Last login: Mon Jan 29 15:59:05 2024 from 10.5.1.1
[sonita@node1 ~]$ sudo firewall-cmd --list-all
[sudo] password for sonita:
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 10055/tcp
  protocols:
  forward: yes
  masquerade: yes
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```







# II. Service HTTP

## 1. Mise en place

🌞 **Installer le serveur NGINX**

- il faut faire une commande `dnf install`
- pour trouver le paquet à installer :
  - `dnf search <VOTRE RECHERCHE>`
  - ou une recherche Google (mais si `dnf search` suffit, c'est useless de faire une recherche pour ça)
```
[sonita@node1 ~]$ sudo dnf install nginx
```


🌞 **Démarrer le service NGINX**
```
[sonita@node1 ~]$ sudo systemctl enable --now nginx
[sudo] password for sonita:
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
```


🌞 **Déterminer sur quel port tourne NGINX**

- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées
- ouvrez le port concerné dans le firewall
```
[sonita@node1 ~]$ ss -alntp | grep 80
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*
LISTEN 0      511             [::]:80            [::]:*
[sonita@node1 ~]$ ss -al | grep http
tcp   LISTEN 0      511                                       0.0.0.0:http                    0.0.0.0:*
tcp   LISTEN 0      511                                          [::]:http                       [::]:*

[sonita@node1 ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[sonita@node1 ~]$ sudo firewall-cmd --reload
success
[sonita@node1 ~]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 10055/tcp 80/tcp
  protocols:
  forward: yes
  masquerade: yes
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```


🌞 **Déterminer les processus liés au service NGINX**

- vous devez filtrer la sortie de la commande utilisée pour n'afficher que les lignes demandées
```
[sonita@node1 ~]$ ps -ef | grep nginx
root       11295       1  0 16:36 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      11296   11295  0 16:36 ?        00:00:00 nginx: worker process
sonita     11348    1319  0 16:48 pts/0    00:00:00 grep --color=auto nginx
```


🌞 **Déterminer le nom de l'utilisateur qui lance NGINX**

- vous devriez le voir dans la commande `ps` précédente
- si l'utilisateur existe, alors il est listé dans le fichier `/etc/passwd`
  - je veux un `cat /etc/passwd | grep <USER>` pour mettre en évidence l'utilisateur qui lance NGINX

```
[sonita@node1 ~]$ cat /etc/passwd | grep nginx
nginx:x:991:991:Nginx web server:/var/lib/nginx:/sbin/nologin
```


🌞 **Test !**

- visitez le site web
  - ouvrez votre navigateur (sur votre PC) et visitez `http://<IP_VM>:<PORT>`
  - vous pouvez aussi (toujours sur votre PC) utiliser la commande `curl` depuis un terminal pour faire une requête HTTP et visiter le site
- dans le compte-rendu, je veux le `curl` (pas un screen de navigateur)
  - utilisez Git Bash si vous êtes sous Windows (obligatoire parce que le `curl` de Powershell il fait des dingueries)
  - vous utiliserez `| head` après le `curl` pour afficher que les 7 premières lignes
  ```
  http://10.5.1.254:80
Sonita Nou@DESKTOP-EKV04VJ MINGW64 ~
$ curl 10.5.1.254 | head -n 7
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  6360k      0 --:--:-- --:--:-- --:--:-- 7441k
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">

  ```



## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**

- faites un `ls -al <PATH_VERS_LE_FICHIER>` pour le compte-rendu
- la conf c'est dans `/etc/` normalement, comme toujours !
```
[sonita@node1 /]$ ls -al etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2347 Jan 29 18:08 etc/nginx/nginx.conf
```


🌞 **Trouver dans le fichier de conf**

- les lignes qui permettent de faire tourner un site web d'accueil (la page moche que vous avez vu avec votre navigateur)
  - ce que vous cherchez, c'est un bloc `server { }` dans le fichier de conf
  - vous ferez un `cat <FICHIER> | grep <TEXTE> -A X` pour me montrer les lignes concernées dans le compte-rendu
    - l'option `-A X` permet d'afficher aussi les `X` lignes après chaque ligne trouvée par `grep`
- une ligne qui commence par `include`
  - cette ligne permet d'inclure d'autres fichiers
  - bah ouais, on stocke pas toute la conf dans un seul fichier, sinon ça serait le bordel
  - encore un `cat <FICHIER> | grep <TEXTE>` pour ne montrer que cette ligne
  ```
[sonita@node1 nginx]$ cat nginx.conf | grep include -A 10
    server {
        include /etc/nginx/default.d/*.conf;
    }
  ```


## 3. Déployer un nouveau site web

🌞 **Créer un site web**

- bon on est pas en cours de design ici, alors on va faire simplissime
- créer un sous-dossier dans `/var/www/`
  - par convention, on stocke les sites web dans `/var/www/`
  - votre dossier doit porter le nom `tp2_linux`
- dans ce dossier `/var/www/tp2_linux`, créez un fichier `index.html`
  - il doit contenir `<h1>MEOW mon premier serveur web</h1>`
```
[sonita@node1 var]$ sudo mkdir www
[sonita@node1 var]$ cd www
[sonita@node1 www]$ sudo mkdir tp3_linux
[sonita@node1 www]$ sudo nano index.html
<h1>MEOW mon premier serveur web</h1>
```


🌞 **Gérer les permissions**

- tout le contenu du dossier  `/var/www/tp2_linux` doit appartenir à l'utilisateur qui lance NGINX
```
[sonita@node1 www]$  sudo chown nginx /var/www/tp3_linux/
[sonita@node1 www]$ ll
drw-r--r--. 2 nginx root  6 Jan 29 18:00 tp3_linux
```


🌞 **Adapter la conf NGINX**

- dans le fichier de conf principal
  - vous supprimerez le bloc `server {}` repéré plus tôt pour que NGINX ne serve plus le site par défaut
  - redémarrez NGINX pour que les changements prennent effet
- créez un nouveau fichier de conf
  - il doit être nommé correctement
  - il doit être placé dans le bon dossier
  - c'est quoi un "nom correct" et "le bon dossier" ?
    - bah vous avez repéré dans la partie d'avant les fichiers qui sont inclus par le fichier de conf principal non ?
    - créez votre fichier en conséquence
  - redémarrez NGINX pour que les changements prennent effet
  - le contenu doit être le suivant :
```
[sonita@node1 nginx]$ echo $RANDOM
2320
[sonita@node1 conf.d]$ sudo nano nginx.conf
server {
        listen 2320;

        root /var/www/tp3_linux;
}
[sonita@node1 ~]$ sudo systemctl restart nginx

[sonita@node1 conf.d]$ sudo firewall-cmd --add-port=2320/tcp --permanent
success
[sonita@node1 conf.d]$ sudo firewall-cmd --reload
success
[sonita@node1 conf.d]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: cockpit dhcpv6-client ssh
  ports: 10055/tcp 80/tcp 2320/tcp
  protocols:
  forward: yes
  masquerade: yes
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
[sonita@node1 conf.d]$
```


🌞 **Visitez votre super site web**

- toujours avec une commande `curl` depuis votre PC (ou un navigateur)






# III. Your own services
## 1. Au cas où vous l'auriez oublié

## 2. Analyse des services existants
🌞 **Afficher le fichier de service SSH**

- vous pouvez obtenir son chemin avec un `systemctl status <SERVICE>`
- mettez en évidence la ligne qui commence par `ExecStart=`
  - encore un `cat <FICHIER> | grep <TEXTE>`
  - c'est la ligne qui définit la commande lancée lorsqu'on "start" le service
  
> *Taper `systemctl start <SERVICE>` ou exécuter la commande indiquée après `ExecStart=` à la main, c'est (presque) pareil.*

```
[sonita@node1 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
[sonita@node1 ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart
ExecStart=/usr/sbin/sshd -D $OPTIONS
```

🌞 **Afficher le fichier de service NGINX**
- mettez en évidence la ligne qui commence par `ExecStart=`
```
[sonita@node1 ~]$ sudo cat /usr/lib/systemd/system/nginx.service | grep ExecStart
ExecStartPre=/usr/bin/rm -f /run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
```


## 3. Création de service
🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

- vous remplacerez `<PORT>` par un numéro de port random obtenu avec la même méthode que précédemment
- son contenu doit être le suivant (nice & easy)
```
[sonita@node1 ~]$ sudo nano /etc/systemd/system/tp3_nc.service

[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 20325 -k
```


🌞 **Indiquer au système qu'on a modifié les fichiers de service**

- la commande c'est `sudo systemctl daemon-reload`


🌞 **Démarrer notre service de ouf**
- avec une commande `systemctl start`
```
[sonita@node1 ~]$ sudo systemctl start tp3_nc.service
```


🌞 **Vérifier que ça fonctionne**

- vérifier que le service tourne avec un `systemctl status <SERVICE>`
- vérifier que `nc` écoute bien derrière un port avec un `ss`
  - vous filtrerez avec un `| grep` la sortie de la commande pour n'afficher que les lignes intéressantes
- vérifer que juste ça fonctionne en vous connectant au service depuis une autre VM ou votre PC
```
[sonita@node1 ~]$ systemctl status tp3_nc.service
● tp3_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp3_nc.service; static)
     Active: active (running) since Mon 2024-01-29 23:23:09 CET; 59s ago
   Main PID: 12131 (nc)
      Tasks: 1 (limit: 4674)
     Memory: 796.0K
        CPU: 2ms
     CGroup: /system.slice/tp3_nc.service
             └─12131 /usr/bin/nc -l 20325 -k

Jan 29 23:23:09 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.

[sonita@node1 ~]$ sudo ss -alnpt | grep 20325
LISTEN 0      10           0.0.0.0:20325      0.0.0.0:*    users:(("nc",pid=12131,fd=4))
LISTEN 0      10              [::]:20325         [::]:*    users:(("nc",pid=12131,fd=3))


[sonita@router ~]$ nc 10.5.1.254 20325
hello
```


🌞 **Les logs de votre service**

- mais euh, ça s'affiche où les messages envoyés par le client ? Dans les logs !
- `sudo journalctl -xe -u tp2_nc` pour visualiser les logs de votre service
- `sudo journalctl -xe -u tp2_nc -f` pour visualiser **en temps réel** les logs de votre service
  - `-f` comme follow (on "suit" l'arrivée des logs en temps réel)
- dans le compte-rendu je veux


```

[sonita@node1 ~]$ sudo journalctl -xe -u tp3_nc -f
Jan 29 23:23:09 node1.tp3.b1 systemd[1]: Started Super netcat tout fou.
░░ Subject: A start job for unit tp3_nc.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit tp3_nc.service has finished successfully.
░░
░░ The job identifier is 2688.
Jan 30 00:16:14 node1.tp3.b1 nc[12131]: hello
```

  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique le démarrage du service
```
[sonita@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep A start job
░░ Subject: A start job for unit tp3_nc.service has finished successfully
```

  - une commande `journalctl` filtrée avec `grep` qui affiche un message reçu qui a été envoyé par le client
```
[sonita@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep hello
Jan 30 00:16:14 node1.tp3.b1 nc[12131]: hello
```

  - une commande `journalctl` filtrée avec `grep` qui affiche la ligne qui indique l'arrêt du service
```
[sonita@node1 ~]$ sudo journalctl -xe -u tp3_nc | grep A stop job
░░ Subject: A stop job for unit tp3_nc.service has finished
```

🌞 **S'amuser à `kill` le processus**

- repérez le PID du processus `nc` lancé par votre *service*
```
[sonita@node1 ~]$ ps -ef | grep nc
dbus         688       1  0 Jan29 ?        00:00:00 /usr/bin/dbus-broker-launch --scope system --audit
root       12327       1  0 00:37 ?        00:00:00 /usr/bin/nc -l 20325 -k
```

- utilisez la commande `kill` pour mettre fin à ce processus `nc`
```
[sonita@node1 ~]$ sudo kill 12327
```


🌞 **Affiner la définition du service**

- faire en sorte que le service redémarre automatiquement s'il se termine
  - comme ça, quand un client se co, puis se tire, le service se relancera tout seul
  - ajoutez `Restart=always` dans la section `[Service]` de votre service
  - n'oubliez pas d'indiquer au système que vous avez modifié les fichiers de service :)

```
[sonita@node1 ~]$ sudo nano /etc/systemd/system/tp3_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 20325 -k
Restart=always

[sonita@node1 ~]$ sudo systemctl daemon-reload
[sonita@node1 ~]$ sudo systemctl restart tp3_nc
[sonita@node1 ~]$ ps -ef | grep nc
root       12376       1  0 00:46 ?        00:00:00 /usr/bin/nc -l 20325 -k

[sonita@node1 ~]$ sudo kill 12376

```