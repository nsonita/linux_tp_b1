# Partie 1 : Partitionnement du serveur de stockage

🌞 **Partitionner le disque à l'aide de LVM**

- créer un *physical volume (PV)* :
  - il contient les 2 nouveaux disques ajoutés à la VM
  - il fait donc 4G
```
[sonita@storage ~]$ sudo pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
[sonita@storage ~]$ sudo pvcreate /dev/sdc
  Physical volume "/dev/sdc" successfully created.
[sonita@storage ~]$ sudo pvdisplay
  "/dev/sdb" is a new physical volume of "2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name
  PV Size               2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               vRDOyQ-Vo10-QwRF-XT9E-c7O7-xgJo-lyUPx3

  "/dev/sdc" is a new physical volume of "2.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdc
  VG Name
  PV Size               2.00 GiB
  Allocatable           NO
  PE Size               0
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               DhWNgB-k9Oc-Qyu3-SU1W-ovJL-TOYR-NbStmU
```


- créer un nouveau *volume group (VG)*
  - il devra s'appeler `storage`
  - il doit contenir le PV créé à l'étape précédente
  ```
  [sonita@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
  [sonita@storage ~]$ sudo vgextend storage /dev/sdc
  Volume group "storage" successfully extended
  [sonita@storage ~]$ sudo vgs
  VG      #PV #LV #SN Attr   VSize VFree
  storage   2   0   0 wz--n- 3.99g 3.99g
  ```


- créer un nouveau *logical volume (LV)* : ce sera la partition utilisable
  - elle doit être dans le VG `storage`
  - elle doit occuper tout l'espace libre
```
[sonita@storage ~]$ sudo lvcreate -L 100%FREE storage -n first_data
  Rounding up size to full physical extent 3.99 GiB
  Logical volume "first_data" created.
```

🌞 **Formater la partition**

- vous formaterez la partition en ext4 (avec une commande `mkfs`)
  - le chemin de la partition, vous pouvez le visualiser avec la commande `lvdisplay`
  - pour rappel un *Logical Volume (LVM)* **C'EST** une partition
```
[sonita@storage ~]$ sudo mkfs -t ext4 /dev/storage/first_data
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 1046528 4k blocks and 261632 inodes
Filesystem UUID: 7111156e-0022-400a-a6d2-9a949d4a555c
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done
```


🌞 **Monter la partition**

- montage de la partition (avec la commande `mount`)
  - la partition doit être montée dans le dossier `/storage`
  - preuve avec une commande `df -h` que la partition est bien montée
    - utilisez un `| grep` pour isoler les lignes intéressantes
  - prouvez que vous pouvez lire et écrire des données sur cette partition
```
[sonita@storage ~]$ sudo mkdir /storage
[sonita@storage ~]$ sudo mount /dev/storage/first_data /storage
[sonita@storage ~]$ df -h | grep data1
/dev/mapper/storage-first_data  3.9G   24K  3.7G   1% /storage
[sonita@storage ~]$ sudo nano /storage/truc.txt
[sonita@storage ~]$ sudo cat /storage/truc.txt
coucouuuuuuuuuuuuuuuu
```

- définir un montage automatique de la partition (fichier `/etc/fstab`)
  - vous vérifierez que votre fichier `/etc/fstab` fonctionne correctement
```
[sonita@storage ~]$ sudo cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Mon Oct 23 13:18:46 2023
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=0bc0520f-169a-4147-a777-c4bd0ad6e32d /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

/dev/storage/first_data /mnt/data1 ext4 defaults 0 0


[sonita@storage ~]$ sudo umount /storage
[sonita@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/data1 does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
/mnt/data1               : successfully mounted
```



# Partie 2 : Serveur de partage de fichiers

🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**

- contenu du fichier `/etc/exports` dans le compte-rendu notamment
```
[sonita@storage ~]$ sudo dnf install nfs-utils
[sonita@storage ~]$ sudo mkdir /storage/site_web_1/ -p
[sonita@storage ~]$ sudo mkdir /storage/site_web_2/ -p
[sonita@storage ~]$ ls -dl /storage/site_web_1 /storage/site_web_2
drwxr-xr-x. 2 root root 4096 Feb 19 22:29 /storage/site_web_1
drwxr-xr-x. 2 root root 4096 Feb 19 22:29 /storage/site_web_2
[sonita@storage ~]$ sudo chown nobody /storage/site_web_1 /storage/site_web_2
[sonita@storage ~]$ sudo cat /etc/exports
/storage/site_web_1    10.5.1.12(rw,sync,no_subtree_check)
/storage/site_web_2    10.5.1.12(rw,sync,no_subtree_check)
/home               10.5.1.12(rw,sync,no_root_squash,no_subtree_check)
[sonita@storage ~]$ sudo systemctl enable nfs-server
[sonita@storage ~]$ sudo systemctl start nfs-server
[sonita@storage ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
     Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; enabled; preset: disabled)
    Drop-In: /run/systemd/generator/nfs-server.service.d
             └─order-with-mounts.conf
     Active: active (exited) since Mon 2024-02-19 22:13:21 CET; 20min ago
   Main PID: 12419 (code=exited, status=0/SUCCESS)
        CPU: 16ms

Feb 19 22:13:21 storage.tp4.linux systemd[1]: Starting NFS server and services...
Feb 19 22:13:21 storage.tp4.linux systemd[1]: Finished NFS server and services.
[sonita@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
[sonita@storage storage]$ sudo systemctl restart nfs-server
```


🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**

- contenu du fichier `/etc/fstab` dans le compte-rendu notamment
```
[sonita@web ~]$ sudo mkdir -p /var/www/site_web_1/
[sonita@web ~]$ sudo mkdir -p /var/www/site_web_2/
[sonita@web ~]$ sudo mount 10.5.1.254:/storage/site_web_1 /var/www/site_web_1
[sonita@web ~]$ sudo mount 10.5.1.254:/storage/site_web_2 /var/www/site_web_2
[sonita@web ~]$ df -h | grep storage
df: /nfs/general: Stale file handle
10.5.1.254:/storage/site_web_1  3.9G     0  3.7G   0% /var/www/site_web_1
10.5.1.254:/storage/site_web_2  3.9G     0  3.7G   0% /var/www/site_web_2

[sonita@web ~]$ sudo cat /etc/fstab
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=0bc0520f-169a-4147-a777-c4bd0ad6e32d /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

host_ip:/storage/site_web_1    /var/www/site_web_1/   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
host_ip:/storage/site_web_2    /var/www/site_web_2/      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```


# Partie 3 : Serveur web

## 1. Intro NGINX

## 2. Install

🖥️ **VM web.tp4.linux**

🌞 **Installez NGINX**

- installez juste NGINX (avec un `dnf install`) et passez à la suite
- référez-vous à des docs en ligne si besoin
```
[sonita@web www]$ sudo dnf install nginx
Last metadata expiration check: 1:10:10 ago on Tue 20 Feb 2024 02:45:11 PM CET.
Dependencies resolved.
=====================================================================================================================
 Package                        Architecture        Version                             Repository              Size
=====================================================================================================================
Installing:
 nginx                          x86_64              1:1.20.1-14.el9_2.1                 appstream               36 k
Installing dependencies:
 nginx-core                     x86_64              1:1.20.1-14.el9_2.1                 appstream              565 k
 nginx-filesystem               noarch              1:1.20.1-14.el9_2.1                 appstream              8.5 k
 rocky-logos-httpd              noarch              90.14-2.el9                         appstream               24 k

Transaction Summary
=====================================================================================================================
Install  4 Packages

Total download size: 634 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-14.el9_2.1.noarch.rpm                                  48 kB/s | 8.5 kB     00:00
(2/4): rocky-logos-httpd-90.14-2.el9.noarch.rpm                                      133 kB/s |  24 kB     00:00
(3/4): nginx-1.20.1-14.el9_2.1.x86_64.rpm                                            193 kB/s |  36 kB     00:00
(4/4): nginx-core-1.20.1-14.el9_2.1.x86_64.rpm                                       4.9 MB/s | 565 kB     00:00
---------------------------------------------------------------------------------------------------------------------
Total                                                                                1.2 MB/s | 634 kB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                             1/1
  Running scriptlet: nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                                                 1/4
  Installing       : nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                                                 1/4
  Installing       : nginx-core-1:1.20.1-14.el9_2.1.x86_64                                                       2/4
  Installing       : rocky-logos-httpd-90.14-2.el9.noarch                                                        3/4
  Installing       : nginx-1:1.20.1-14.el9_2.1.x86_64                                                            4/4
  Running scriptlet: nginx-1:1.20.1-14.el9_2.1.x86_64                                                            4/4
  Verifying        : rocky-logos-httpd-90.14-2.el9.noarch                                                        1/4
  Verifying        : nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                                                 2/4
  Verifying        : nginx-1:1.20.1-14.el9_2.1.x86_64                                                            3/4
  Verifying        : nginx-core-1:1.20.1-14.el9_2.1.x86_64                                                       4/4

Installed:
  nginx-1:1.20.1-14.el9_2.1.x86_64                             nginx-core-1:1.20.1-14.el9_2.1.x86_64
  nginx-filesystem-1:1.20.1-14.el9_2.1.noarch                  rocky-logos-httpd-90.14-2.el9.noarch

Complete!

[sonita@web www]$ sudo systemctl enable --now nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
[sonita@web www]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Tue 2024-02-20 15:59:09 CET; 1min 16s ago
   Main PID: 2345 (nginx)
      Tasks: 2 (limit: 4674)
     Memory: 2.0M
        CPU: 18ms
     CGroup: /system.slice/nginx.service
             ├─2345 "nginx: master process /usr/sbin/nginx"
             └─2346 "nginx: worker process"

Feb 20 15:59:09 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 20 15:59:09 web.tp4.linux nginx[2343]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 20 15:59:09 web.tp4.linux nginx[2343]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 20 15:59:09 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

## 3. Analyse

🌞 **Analysez le service NGINX**

- avec une commande `ps`, déterminer sous quel utilisateur tourne le processus du service NGINX
  - utilisez un `| grep` pour isoler les lignes intéressantes
```
[sonita@web www]$ ps -ef | grep nginx
root        2345       1  0 15:59 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       2346    2345  0 15:59 ?        00:00:00 nginx: worker process
sonita      2410    2009  0 16:01 pts/0    00:00:00 grep --color=auto nginx
```

- avec une commande `ss`, déterminer derrière quel port écoute actuellement le serveur web
  - utilisez un `| grep` pour isoler les lignes intéressantes
```
[sonita@web www]$ sudo ss -alpnt | grep nginx
LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=2463,fd=6),("nginx",pid=2462,fd=6))
LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=2463,fd=7),("nginx",pid=2462,fd=7))
```

- en regardant la conf, déterminer dans quel dossier se trouve la racine web
  - utilisez un `| grep` pour isoler les lignes intéressantes
```
[sonita@web ~]$ sudo cat /etc/nginx/nginx.conf | grep html
        root         /usr/share/nginx/html;
```


- inspectez les fichiers de la racine web, et vérifier qu'ils sont bien accessibles en lecture par l'utilisateur qui lance le processus
  - ça va se faire avec un `ls` et les options appropriées
```
[sonita@web html]$ ls -al
total 12
drwxr-xr-x. 3 root root  143 Feb 20 15:55 .
drwxr-xr-x. 4 root root   33 Feb 20 15:55 ..
-rw-r--r--. 1 root root 3332 Oct 16 19:58 404.html
-rw-r--r--. 1 root root 3404 Oct 16 19:58 50x.html
drwxr-xr-x. 2 root root   27 Feb 20 15:55 icons
lrwxrwxrwx. 1 root root   25 Oct 16 20:00 index.html -> ../../testpage/index.html
```


## 4. Visite du service web

🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

- vous avez reperé avec `ss` dans la partie d'avant le port à ouvrir
```
[sonita@web html]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[sonita@web html]$ sudo firewall-cmd --reload
success
```

🌞 **Accéder au site web**

- avec votre navigateur sur VOTRE PC
  - ouvrez le navigateur vers l'URL : `http://<IP_VM>:<PORT>`
- vous pouvez aussi effectuer des requêtes HTTP depuis le terminal, plutôt qu'avec un navigateur
  - ça se fait avec la commande `curl`
  - et c'est ça que je veux dans le compte-rendu, pas de screen du navigateur :)

> Si le port c'est 80, alors c'est la convention pour HTTP. Ainsi, il est inutile de le préciser dans l'URL, le navigateur le fait de lui-même. On peut juste saisir `http://<IP_VM>`.
```
[sonita@web html]$ curl 10.5.1.12 | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
```

🌞 **Vérifier les logs d'accès**

- trouvez le fichier qui contient les logs d'accès, dans le dossier `/var/log`
```
[sonita@web nginx]$ pwd
/var/log/nginx
[sonita@web nginx]$ sudo ls
access.log  error.log
```
- les logs d'accès, c'est votre serveur web qui enregistre chaque requête qu'il a reçu
- c'est juste un fichier texte
- affichez les 3 dernières lignes des logs d'accès dans le contenu rendu, avec une commande `tail`
```
[sonita@web nginx]$ sudo cat access.log | tail -n 3
10.5.1.12 - - [20/Feb/2024:16:39:19 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.5.1.12 - - [20/Feb/2024:16:39:25 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
10.5.1.12 - - [20/Feb/2024:16:39:28 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.76.1" "-"
```



## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

- une simple ligne à modifier, vous me la montrerez dans le compte rendu
  - faites écouter NGINX sur le port 8080
```
[sonita@web nginx]$ sudo cat nginx.conf | grep 8080
        listen       8080;
        listen       [::]:8080;
```

- redémarrer le service pour que le changement prenne effet
  - `sudo systemctl restart nginx`
  - vérifiez qu'il tourne toujours avec un ptit `systemctl status nginx`
```
[sonita@web nginx]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: disabled)
     Active: active (running) since Tue 2024-02-20 16:50:14 CET; 9s ago
    Process: 2628 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 2629 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 2630 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 2631 (nginx)
      Tasks: 2 (limit: 4674)
     Memory: 1.9M
        CPU: 20ms
     CGroup: /system.slice/nginx.service
             ├─2631 "nginx: master process /usr/sbin/nginx"
             └─2632 "nginx: worker process"

Feb 20 16:50:14 web.tp4.linux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 20 16:50:14 web.tp4.linux nginx[2629]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 20 16:50:14 web.tp4.linux nginx[2629]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 20 16:50:14 web.tp4.linux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

- prouvez-moi que le changement a pris effet avec une commande `ss`
  - utilisez un `| grep` pour isoler les lignes intéressantes
```
[sonita@web nginx]$ sudo ss -alpnt | grep nginx
LISTEN 0      511          0.0.0.0:8080       0.0.0.0:*    users:(("nginx",pid=2632,fd=6),("nginx",pid=2631,fd=6))
LISTEN 0      511             [::]:8080          [::]:*    users:(("nginx",pid=2632,fd=7),("nginx",pid=2631,fd=7))
```

- n'oubliez pas de fermer l'ancien port dans le firewall, et d'ouvrir le nouveau
- prouvez avec une commande `curl` sur votre machine que vous pouvez désormais visiter le port 8080

> Là c'est pas le port par convention, alors obligé de préciser le port quand on fait la requête avec le navigateur ou `curl` : `http://<IP_VM>:8080`.

```
[sonita@web nginx]$ curl http://10.5.1.12:8080 | head -n 10
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/

      html {
```


🌞 **Changer l'utilisateur qui lance le service**

- pour ça, vous créerez vous-même un nouvel utilisateur sur le système : `web`
  - référez-vous au [mémo des commandes](../../cours/memos/commandes.md) pour la création d'utilisateur
  - l'utilisateur devra avoir un mot de passe, et un homedir défini explicitement à `/home/web`
- modifiez la conf de NGINX pour qu'il soit lancé avec votre nouvel utilisateur
  - utilisez `grep` pour me montrer dans le fichier de conf la ligne que vous avez modifié
- n'oubliez pas de redémarrer le service pour que le changement prenne effet
- vous prouverez avec une commande `ps` que le service tourne bien sous ce nouveau utilisateur
  - utilisez un `| grep` pour isoler les lignes intéressantes
```
[sonita@web ~]$ sudo useradd web
[sonita@web ~]$ sudo passwd web
Changing password for user web.

[sonita@web nginx]$ sudo cat nginx.conf | grep web
user web;

[sonita@web nginx]$ ps -ef | grep nginx
root        2853       1  0 17:24 ?        00:00:00 nginx: master process /usr/sbin/nginx
web         2854    2853  0 17:24 ?        00:00:00 nginx: worker process
sonita      2857    2810  0 17:24 pts/0    00:00:00 grep --color=auto nginx
```



**Il est temps d'utiliser ce qu'on a fait à la partie 2 !**

🌞 **Changer l'emplacement de la racine Web**

- configurez NGINX pour qu'il utilise une autre racine web que celle par défaut
  - avec un `nano` ou `vim`, créez un fichiez `/var/www/site_web_1/index.html` avec un contenu texte bidon
  - dans la conf de NGINX, configurez la racine Web sur `/var/www/site_web_1/`
  - vous me montrerez la conf effectuée dans le compte-rendu, avec un `grep`
- n'oubliez pas de redémarrer le service pour que le changement prenne effet
- prouvez avec un `curl` depuis votre hôte que vous accédez bien au nouveau site

> **Normalement le dossier `/var/www/site_web_1/` est un dossier créé à la Partie 2 du TP**, et qui se trouve en réalité sur le serveur `storage.tp4.linux`, notre serveur NFS.
```
[sonita@web ~]$ sudo cat /etc/nginx/nginx.conf | grep site_web
        root         /var/www/site_web_1;

[sonita@web ~]$ sudo systemctl restart nginx

[sonita@web ~]$ curl http://10.5.1.12:8080
<h1> MIAOU <h1>
```




## 6. Deux sites web sur un seul serveur
🌞 **Repérez dans le fichier de conf**

- la ligne qui inclut des fichiers additionels contenus dans un dossier nommé `conf.d`
- vous la mettrez en évidence avec un `grep`

> On trouve souvent ce mécanisme dans la conf sous Linux : un dossier qui porte un nom finissant par `.d` qui contient des fichiers de conf additionnels pour pas foutre le bordel dans le fichier de conf principal. On appelle ce dossier un dossier de *drop-in*.
```
[sonita@web ~]$ sudo cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```


🌞 Créez le fichier de configuration pour le premier site

le bloc server du fichier de conf principal, vous le sortez
et vous le mettez dans un fichier dédié
ce fichier dédié doit se trouver dans le dossier conf.d

ce fichier dédié doit porter un nom adéquat : site_web_1.conf
```
[sonita@web ~]$ sudo cat /etc/nginx/conf.d/server.conf
server {
        listen        8080;
        listen        [::]:8080;

        root          /var/www/site_web_1;
        }
}
```


🌞 **Créez le fichier de configuration pour le premier site**

- le bloc `server` du fichier de conf principal, vous le sortez
- et vous le mettez dans un fichier dédié
- ce fichier dédié doit se trouver dans le dossier `conf.d`
- ce fichier dédié doit porter un nom adéquat : `site_web_1.conf`
```
[sonita@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
server {
        listen        8080;
        listen        [::]:8080;

        root          /var/www/site_web_1;
        }
}
[sonita@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[sonita@web ~]$ sudo firewall-cmd --reload
```

🌞 **Créez le fichier de configuration pour le deuxième site**

- un nouveau fichier dans le dossier `conf.d`
- il doit porter un nom adéquat : `site_web_2.conf`
- copiez-collez le bloc `server { }` de l'autre fichier de conf
- changez la racine web vers `/var/www/site_web_2/`
- et changez le port d'écoute pour 8888

> N'oubliez pas d'ouvrir le port 8888 dans le firewall. Vous pouvez constater si vous le souhaitez avec un `ss` que NGINX écoute bien sur ce nouveau port.
```
[sonita@web ~]$ sudo cat /etc/nginx/conf.d/site_web_1.conf
server {
        listen        8888;
        listen        [::]:8888;

        root          /var/www/site_web_2;
        }
}
[sonita@web ~]$ sudo firewall-cmd --add-port=8080/tcp --permanent
success
[sonita@web ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
success
[sonita@web ~]$ sudo firewall-cmd --reload
```


🌞 **Prouvez que les deux sites sont disponibles**

- depuis votre PC, deux commandes `curl`
- pour choisir quel site visitez, vous choisissez un port spécifique
```
[sonita@web ~]$ curl http://10.5.1.12:8080
<h1> MIAOU <h1>
```