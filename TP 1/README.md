# TP1 : Casser avant de construire

# I. Setup

➜ **Machine virtuelle avec un OS Linux**

- l'OS de votre choix (Rocky Linux ou autre chose)

➜ **Accès à un terminal sur la machine**

- avec une session SSH
- ou directement l'interface de la VM si ça vous convient

➜ **Effectuer un snapshot**

- c'est une fonctionnalité de VirtualBox (ou de n'importe quel autre hyperviseur)
- ça permet de faire un "instantané" d'une VM à un instant T
- on peut, plus tard, restaurer la VM dans cet état
- je vous recommande donc de faire un snapshot de votre VM avant de la détruire
- comme ça, vous pouvez revenir en arrière, avant qu'elle soit cassée pour continuer à bosser


# II. Casser

## 1. Objectif

➜ **Vous devez rendre la VM inutilisable. Par inutilisable on entend :**

- elle ne démarre (boot) même plus
- ça boot, mais on ne peut plus se connecter de aucune façon
- ça boot, on peut se co, mais on arrive sur un environnement tellement dégradé qu'il est pas utilisable

➜ **Tout doit être fait depuis le terminal de la VM**

> Si vous avez des doutes sur la validité de votre cassage, demandez-moi !


## 2. Fichier

🌞 **Supprimer des fichiers**
- rendre la machine complètement foutue en supprimant des fichiers
- y'a moyen de la rendre inopérante en supprimant juste un seul fichier ou deux
- y'en a plein qui sont super critiques, faites-vos recherches !

```
[root@localhost] cd boot
[root@localhost boot] rm vmlinuz-0-rescue-b776ac2c9fba43dfaa3b99640445457e vmlinuz-5.14.0-284.11.1.el9_2.x86_64
```


## 3. Utilisateurs

🌞 **Mots de passe**

- changez le mot de passe de tous les utilisateurs qui en ont déjà un
```
[sonita@localhost ~] sudo passwd
```

- trouvez donc un moyen de lister les utilisateurs, et trouver ceux qui ont déjà un mot de passe

> *On peut parfaitement avoir un utilisateur sans mot de passe dans un système Linux : il ne peut pas se connecter du tout. On verra en quoi c'est utile plus tard dans les cours.*

```
[sonita@localhost ~] sudo cat /etc/shadow
root:$6$4ku5czLApV2BVoY0$vKY/4.SvYyFhCX8KwEDReFQN33QRFO6mcbRESZgAy8Xetool1lzMWCNSVoIHZbhAiLW3XoJ5K2bxMcXYlG1JG/:19709:0:99999:7:::
bin:*:19469:0:99999:7:::
daemon:*:19469:0:99999:7:::
adm:*:19469:0:99999:7:::
lp:*:19469:0:99999:7:::
sync:*:19469:0:99999:7:::
shutdown:*:19469:0:99999:7:::
halt:*:19469:0:99999:7:::
mail:*:19469:0:99999:7:::
operator:*:19469:0:99999:7:::
games:*:19469:0:99999:7:::
ftp:*:19469:0:99999:7:::
nobody:*:19469:0:99999:7:::
systemd-coredump:!!:19653::::::
dbus:!!:19653::::::
tss:!!:19653::::::
sssd:!!:19653::::::
sshd:!!:19653::::::
chrony:!!:19653::::::
systemd-oom:!*:19653::::::
sonita:$6$/w5oqUONPcZ9LZ4B$7aXSxRfHfLOoH5D8fCwz0Mm1Y1/K37.UxIlciXZoYgQdgmOy72lM2xOmqmaM240p6UyO/VxhkXtT8SnmF1ecc0:19709:0:99999:7:::
```

🌞 **Another way ?**

- sans toucher aux mots de passe, faites en sorte qu'aucun utilisateur ne soit utilisable
- trouver un autre moyen donc, en restant sur les utilisateurs !
```
[sonita@linux ~]$ sudo chmod a-x /bin/bash
PS C:\Users\Sonita Nou> ssh sonita@10.5.1.254
sonita@10.5.1.254's password:
Permission denied, please try again.
```


## 4. Disques

🌞 **Effacer le contenu du disque dur**

- ici on parle pas de toucher aux fichiers et dossiers qui existent au sein du disque dur de la VM
- mais de toucher directement au disque dur
- essayez de remplir le disque de zéros

```
[sonita@linux bin]$ df -h //pour vérifier le disque dur
Filesystem           Size  Used Avail Use% Mounted on
devtmpfs             4.0M     0  4.0M   0% /dev
tmpfs                386M     0  386M   0% /dev/shm
tmpfs                155M  3.7M  151M   3% /run
/dev/mapper/rl-root  6.2G  1.2G  5.0G  20% /
/dev/sda1           1014M  220M  795M  22% /boot
tmpfs                 78M     0   78M   0% /run/user/1001
```

```
[sonita@linux /]$ sudo dd if=/dev/zero of=/dev/mapper/rl-root status=progress //remplir de zéros le plus gros espace de stockage, "status=progress" sert à voir le statut de l'éxécution
6484299776 bytes (6.5 GB, 6.0 GiB) copied, 61 s, 106 MB/s
dd: writing to '/dev/mapper/rl-root': No space left on device
12992513+0 records in
12992512+0 records out
6652166144 bytes (6.7 GB, 6.2 GiB) copied, 61.8497 s, 108 MB/s
[sonita@linux /]$ ls
Segmentation fault
```


## 5. Malware

🌞 **Reboot automatique**

- faites en sorte que si un utilisateur se connecte, ça déclenche un reboot automatique de la machine
```
[sonita@linux ~]$ sudo nano rebootautomatic.sh
reboot
[sonita@linux ~]$ chmod +x /home/sonita/rebootautomatic.sh //pour donner les droits
[sonita@linux ~]$ echo "/home/sonita/rebootautomatic.sh">>/home/sonita/.bash_profile
//Si on tente de se reconnecter, il se reboot automatiquement encore et encore
```


## 6. You own way

🌞 **Trouvez 4 autres façons de détuire la machine**

- tout doit être fait depuis le terminal de la machine
- pensez à ce qui constitue un ordi/un OS
- l'idée c'est de supprimer des trucs importants, modifier le comportement de trucs existants, surcharger tel ou tel truc...

```
// Technique n°1 :
[sonita@linux ~]$ sudo rm /etc/shadow
// Sans aucun mot de passe, aucun utilisateur peut se connecter.
```

```
// Technique n°2 :
[sonita@linux ~]$ sudo rm /bin/bash
// Sans shell, la machine ne peut pas fonctionner.
```

