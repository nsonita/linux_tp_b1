# Partie : Files and users

- [Partie : Files and users](#partie--files-and-users)
- [I. Fichiers](#i-fichiers)
  - [1. Find me](#1-find-me)
- [II. Users](#ii-users)
  - [1. Nouveau user](#1-nouveau-user)
  - [2. Infos enregistrées par le système](#2-infos-enregistrées-par-le-système)
  - [3. Hint sur la ligne de commande](#3-hint-sur-la-ligne-de-commande)
  - [3. Connexion sur le nouvel utilisateur](#3-connexion-sur-le-nouvel-utilisateur)

# I. Fichiers

## 1. Find me

🌞 **Trouver le chemin vers le répertoire personnel de votre utilisateur**

- si tu te connectes en tant que l'utilisateur `toto`, il y a un dossier qui est réservé à `toto`
- sur un OS pour un PC de bureau, c'est dans ce dossier qu'on trouve `Mes Documents/`, `Mes Images/` etc.

> N'hésitez pas à le chercher d'abord avec un explorateur de fichier, en utilisant l'interface graphique si vous en avez une. Si ça vous aide au début !

```
[sonita@linux ~]$ cd /home
[sonita@linux home]$ ls
sonita
[sonita@linux home]$

```


🌞 **Trouver le chemin du fichier de logs SSH**

- il existe un fichier texte, un fichier de log, qui enregistre toutes les tentatives de connexion en SSH (réussies ou échouées)
- on peut donc facilement voir dans ce fichier qui a essayé de se connecter à notre machine
- la plupart des programmes (y compris le serveur SSH) font ça : écrire dans un fichier txt tout ce qui est effectué
  - permet de garder une trace, de comprendre ce qu'il se passe quand ça va mal, toussa
- dans les OS Linux, il existe un dossier dédié qui contient tous les fichiers de logs

```
[sonita@linux log]$ cd /var/log
[sonita@linux log]$ sudo cat secure
Jan 22 15:04:19 router sshd[703]: Server listening on 0.0.0.0 port 22.
Jan 22 15:04:19 router sshd[703]: Server listening on :: port 22.
Jan 22 15:04:31 router systemd[1296]: pam_unix(systemd-user:session): session opened for user sonita(uid=1001) by (uid=0)
Jan 22 15:04:31 router login[711]: pam_unix(login:session): session opened for user sonita(uid=1001) by LOGIN(uid=0)
Jan 22 15:04:31 router login[711]: LOGIN ON tty1 BY sonita
Jan 22 15:14:39 router sshd[1337]: Accepted password for sonita from 10.5.1.1 port 57458 ssh2
Jan 22 15:14:39 router sshd[1337]: pam_unix(sshd:session): session opened for user sonita(uid=1001) by (uid=0)
Jan 22 15:19:29 router sudo[1378]:  sonita : TTY=pts/0 ; PWD=/ ; USER=root ; COMMAND=/bin/hostname linux
Jan 22 15:19:29 router sudo[1378]: pam_unix(sudo:session): session opened for user root(uid=0) by sonita(uid=1001)
Jan 22 15:19:29 router sudo[1378]: pam_unix(sudo:session): session closed for user root
Jan 22 15:20:03 router sudo[1385]:  sonita : TTY=pts/0 ; PWD=/ ; USER=root ; COMMAND=/bin/tee /etc/hostname
Jan 22 15:20:03 router sudo[1385]: pam_unix(sudo:session): session opened for user root(uid=0) by sonita(uid=1001)
Jan 22 15:20:03 router sudo[1385]: pam_unix(sudo:session): session closed for user root
Jan 22 15:20:07 router sshd[1341]: Received disconnect from 10.5.1.1 port 57458:11: disconnected by user
Jan 22 15:20:07 router sshd[1341]: Disconnected from user sonita 10.5.1.1 port 57458
Jan 22 15:20:07 router sshd[1337]: pam_unix(sshd:session): session closed for user sonita
Jan 22 15:20:10 router sshd[1388]: Accepted password for sonita from 10.5.1.1 port 57729 ssh2
Jan 22 15:20:10 router sshd[1388]: pam_unix(sshd:session): session opened for user sonita(uid=1001) by (uid=0)
Jan 22 15:23:17 router sudo[1433]:  sonita : TTY=pts/0 ; PWD=/home ; USER=root ; COMMAND=/bin/cat sonita
Jan 22 15:23:17 router sudo[1433]: pam_unix(sudo:session): session opened for user root(uid=0) by sonita(uid=1001)
Jan 22 15:23:17 router sudo[1433]: pam_unix(sudo:session): session closed for user root
Jan 22 15:28:15 router sudo[1444]:  sonita : TTY=pts/0 ; PWD=/ ; USER=root ; COMMAND=/bin/cat /var/log/messages
Jan 22 15:28:15 router sudo[1444]: pam_unix(sudo:session): session opened for user root(uid=0) by sonita(uid=1001)
Jan 22 15:28:15 router sudo[1444]: pam_unix(sudo:session): session closed for user root
Jan 22 15:29:54 router sudo[1451]:  sonita : TTY=pts/0 ; PWD=/var/log ; USER=root ; COMMAND=/bin/cat /secure
Jan 22 15:29:54 router sudo[1451]: pam_unix(sudo:session): session opened for user root(uid=0) by sonita(uid=1001)
Jan 22 15:29:54 router sudo[1451]: pam_unix(sudo:session): session closed for user root
```


🌞 **Trouver le chemin du fichier de configuration du serveur SSH**

- idem ici, sous Linux, il existe un dossier qui est dédié à stocker tous les fichiers de configuration

```
[sonita@linux etc]$ cd /etc/ssh
[sonita@linux ssh]$ sudo cat sshd_config
#       $OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# To modify the system-wide sshd configuration, create a  *.conf  file under
#  /etc/ssh/sshd_config.d/  which will be automatically included below
Include /etc/ssh/sshd_config.d/*.conf

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile      .ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to no to disable s/key passwords
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in RHEL and may cause several
# problems.
#UsePAM no

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem       sftp    /usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
```

# II. Users

## 1. Nouveau user

🌞 **Créer un nouvel utilisateur**

- il doit s'appeler `marmotte`
- son password doit être `chocolat`
- son répertoire personnel doit être le dossier `/home/papier_alu/`

```
[sonita@linux /]$ sudo useradd marmotte -d /home/papier_alu/
[sonita@linux home]$ sudo passwd marmotte
Changing password for user marmotte.
New password: [chocolat]
BAD PASSWORD: The password fails the dictionary check - it is based on a dictionary word
Retype new password: [chocolat]
passwd: all authentication tokens updated successfully.
```

## 2. Infos enregistrées par le système

➜ **Pour le compte-rendu**, et pour vous habituer à **utiliser le terminal de façon pratique**, petit hint :

```bash
# supposons un fichier "nul.txt", on peut afficher son contenu avec la commande :
$ cat /chemin/vers/nul.txt
salut
à
toi

# il est possible en une seule ligne de commande d'afficher uniquement une ligne qui contient un mot donné :
$ cat /chemin/vers/nul.txt | grep salut
salut

# à l'aide de `| grep xxx`, on a filtré la sortie de la commande cat
# ça n'affiche donc que la ligne qui contient le mot demandé : "salut"
```


🌞 **Prouver que cet utilisateur a été créé**

- en affichant le contenu d'un fichier
- sous Linux, il existe un fichier qui contient la liste des utilisateurs ainsi que des infos sur eux (comme le chemin vers le répertoire personnel)
- utilisez une syntaxe `cat fichier | grep marmotte` pour n'afficher que la ligne qui concerne notre utilisateur `marmotte`

```
[sonita@linux etc]$ sudo cat passwd | grep marmotte
marmotte:x:1002:1002::/home/papier_alu/:/bin/bash
```


🌞 **Déterminer le *hash* du password de l'utilisateur `marmotte`**

- là encore, sous Linux, il existe un fichier qui liste les hashes des mots de passe de tous les utilisateurs
- encore une syntaxe `cat fichier | grep xxx` pour le compte-rendu

> **On ne stocke JAMAIS le mot de passe des utilisateurs** (sous Linux, ou ailleurs) mais **on stocke les *hash* des mots de passe des users.** Un *hash* c'est un dérivé d'un mot de passe utilisateur : il permet de vérifier à l'avenir que le user tape le bon password, mais sans l'avoir stocké ! On verra ça une autre fois en détails.

![File ?](./img/file.jpg)

```
[sonita@linux etc]$ sudo cat shadow | grep marmotte
marmotte:$6$F.LXWUtA7/hqqoZr$MI9J3IsAOUd..RcSzyFaY1OPVMSTO4y4FU/AZ1bnvtNgHGrj9Mm0eFJG/WL//z0La2QBeecWzUN87iGFkKGHc1:19744:0:99999:7:::
```


## 3. Hint sur la ligne de commande

> *Ce qui est dit dans cette partie est valable pour tous les OS.*

**Quand on donne le chemin d'un fichier à une commande, on peut utiliser soit un *chemin relatif*, soit un *chemin absolu* :**

➜ **chemin absolu**

- c'est le chemin complet vers le fichier
  - il commence forcément par `/` sous Linux ou MacOS
  - il commence forcément par `C:/` (ou une autre lettre) sous Windows
- peu importe où on l'utilise, ça marche tout le temps
- par exemple :
  - `/etc/ssh/sshd_config` est un chemin absolu
  - *et c'est le chemin vers le fichier de conf du serveur SSH sous Linux en l'occurrence*
- mais parfois c'est super long et chiant à taper/utiliser donc on peut utiliser...

➜ ... un **chemin relatif**

- on écrit pas le chemin en entier, mais uniquement le chemin depuis le dossier où se trouve
- par exemple :
  - si on se trouve dans le dossier `/etc/ssh/`
  - on peut utiliser `./sshd_config` : c'est le chemin relatif de `sshd_config` quand on se trouve dans `/etc/ssh/`
  - un chemin relatif commence toujours par un `.`
  - `.` c'est "le dossier actuel"

➜ **Exemples :**

```bash
# on se déplace dans un répertoire spécifique, ici le répertoire personnel du user it4
$ cd /home/it4

# on affiche (parce que pourquoi pas) le fichier de conf du serveur SSH
# en utilisant le chemin absolu du fichier
$ cat /etc/ssh/sshd_config
[...] # ça fonctionne

# cette fois chemin relatif ???
$ cat ./sshd_config
cat: sshd_config: No such file or directory
# on a une erreur car le fichier "sshd_config" n'existe pas dans "/home/it4"

# on se déplace dans le bon dossier
$ cd /etc/ssh

# et là
$ cat ./sshd_config
[...] # ça fonctionne

# en vrai pour permettre d'aller plus vite, ça marche aussi si on met pas le ./ au début
$ cat sshd_config
[...] # ça fonctionne
```

## 3. Connexion sur le nouvel utilisateur

🌞 **Tapez une commande pour vous déconnecter : fermer votre session utilisateur**

- pas de shutdown ou reboot hein, juste fermer la session
- attention, cette commande peut varier suivant l'OS utilisé, ou la façon dont vous vous connectez à la machine (SSH ou non)

```
[sonita@linux ~]$ exit
logout
Connection to 10.5.1.254 closed.
```

🌞 **Assurez-vous que vous pouvez vous connecter en tant que l'utilisateur `marmotte`**

- une fois connecté sur l'utilisateur `marmotte`, essayez de faire un `ls` dans le répertoire personnel de votre premier utilisateur
- assurez-vous que vous mangez un beau `Permission denied` : vous avez pas le droit de regarder dans les répertoires qui vous concernent pas

> **On verra en détails la gestion des droits très vite.**
```
[marmotte@linux home]$ ls
papier_alu  sonita
[marmotte@linux home]$ cd sonita
-bash: cd: sonita: Permission denied
```






# Partie 2 : Programmes et paquets

- [Partie 2 : Programmes et paquets](#partie-2--programmes-et-paquets)
- [I. Programmes et processus](#i-programmes-et-processus)
  - [1. Run then kill](#1-run-then-kill)
  - [2. Tâche de fond](#2-tâche-de-fond)
  - [3. Find paths](#3-find-paths)
  - [4. La variable PATH](#4-la-variable-path)
- [II. Paquets](#ii-paquets)

# I. Programmes et processus

➜ Dans cette partie, afin d'avoir quelque chose à étudier, on va utiliser le programme `sleep`

- c'est une commande (= un programme) dispo sur tous les OS
- ça permet de... ne rien faire pendant X secondes
- la syntaxe c'est `sleep 90` pour attendre 90 secondes
- on s'en fout de `sleep` en doit, c'est une commande utile parmi plein d'autres, elle est pratique pour étudier les trucs que j'veux vous montrer

## 1. Run then kill

🌞 **Lancer un processus `sleep`**

- il doit dormir 1000 secondes
- ouvrez un deuxième terminal, pendant que le premier est occupé par le `sleep`
- dans ce deuxième terminal, déterminer le PID du processus `sleep`
- il existe une commande qui permet de lister les processus en cours d'exécution (un gestionnaire des tâches quoi)
- syntaxe `commande | grep xxx` pour afficher uniquement la ligne du `sleep`

> Le *PID* pour *Process IDentifier* c'est un ID unique attribué à chaque process lancé. Chaque processus, on lui attribue un numéro quoi.

```
[sonita@linux ~]$ sleep 1000
[sonita@linux ~]$ ps -fu sonita | grep sleep
sonita      1821    1737  0 17:13 pts/0    00:00:00 sleep 1000
sonita      1829    1783  0 17:15 pts/1    00:00:00 grep --color=auto sleep
```


🌞 **Terminez le processus `sleep` depuis le deuxième terminal**

- utilisez la commande `kill` pour arrêter le processus `sleep`

> Utiliser la commande `kill` revient à appuyer sur la croix rouge en haut d'une fenêtre pour fermer un programme.

![Kill it](./img/killit.jpg)

```
// Sur le terminal 2 :
[sonita@linux ~]$ kill 1737
```
```
// Sur le terminal 1 :
[sonita@linux ~]$ sleep 1000
Terminated
```


🌞 **Lancer un nouveau processus `sleep`, mais en tâche de fond**

- il doit dormir 1000 secondes
- pour lancer une commande en tâche de fond, il faut ajouter `&` à la fin de la commande
- ainsi, on garde notre terminal actif pendant que le programme s'exécute
```
[sonita@linux ~]$ sleep 1000 &
[1] 2064
[sonita@linux ~]$ jobs
[1]+  Running                 sleep 1000 &
```

🌞 **Visualisez la commande en tâche de fond**

- il existe une commande pour lister les processus qu'on a lancé en tâche de fond
- en utilisant cette commande, récupérez le PID du processus sleep
```
[sonita@linux ~]$ jobs
[1]+  Running                 sleep 1000 &
```



## 3. Find paths

➜ La commande `sleep`, comme toutes les commandes, c'est un programme

- sous Linux, on met pas l'extension `.exe`, s'il y a pas d'extensions, c'est que c'est un exécutable généralement

🌞 **Trouver le chemin où est stocké le programme `sleep`**

- je veux voir un `ls -al /chemin | grep sleep` dans le rendu
```
[sonita@linux ~]$ ls -al /etc/systemd/ | grep sleep
-rw-r--r--. 1 root root 953 May  9  2023 /etc/systemd/sleep.conf
```


🌞 Tant qu'on est à chercher des chemins : **trouver les chemins vers tous les fichiers qui s'appellent `.bashrc`**

- utilisez la commande `find`
- `find` s'utilise comme suit : `find CHEMIN -name NAME`
  - `CHEMIN` c'est un chemin vers un dossier : `find` va chercher des fichiers qui sont contenus dans ce dossier
  - `NAME` est le nom du fichier qu'on cherche

  ```
[sonita@linux ~]$ sudo find / -name "*.bashrc"
/etc/skel/.bashrc
/root/.bashrc
  ```

## 4. La variable PATH

🌞 **Vérifier que**

- les commandes `sleep`, `ssh`, et `ping` sont bien des programmes stockés dans l'un des dossiers listés dans votre `PATH`
```
[sonita@linux ~]$ echo $PATH
/home/sonita/.local/bin:/home/sonita/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
[sonita@linux ~]$ which sleep
/usr/bin/sleep
[sonita@linux ~]$ which ssh
/usr/bin/ssh
[sonita@linux ~]$ which ping
/usr/bin/ping
```



# II. Paquets
🌞 **Installer le paquet `firefox`**

- c'est uste pour faire pratiquer
- si vous avez choisi un OS sans interface graphique, inutile de télécharger Firefox
  - sans interface graphique, vous pouvez installer le paquet `git` pour remplacer
```
[sonita@linux ~]$ sudo dnf install git
```


🌞 **Utiliser une commande pour lancer Firefox**

- comme d'hab, une commande, c'est un programme hein
- déterminer le chemin vers le programme `firefox`
- sans interface graphique, même exercice avec `git` : trouvez le chemin où est stocké la commande
```
[sonita@linux ~]$ which git
/usr/bin/git
```


🌞 **Installer le paquet `nginx`**

- il faut utiliser le gestionnaire de paquet natif à l'OS que tu as choisi
- si c'est un système...
  - basé sur Debian, comme Debian lui-même, ou Ubuntu, ou Kali, ou d'autres, c'est `apt` qui est fourni
  - basé sur RedHat, comme Rocky, Fedora, ou autres, c'est `dnf` qui est fourni
  ```
  [sonita@linux ~]$ sudo dnf install nginx
  ```


🌞 **Déterminer**

- le chemin vers le dossier de logs de NGINX
- le chemin vers le dossier qui contient la configuration de NGINX
  ```
[sonita@linux ~]$ which nginx
/usr/sbin/nginx
  ```


🌞 **Mais aussi déterminer...**

- l'adresse `http` ou `https` du serveur où vous avez téléchargé le paquet
- une commande `apt install` ou `dnf install` permet juste de faire un téléchargement HTTP
- ma question c'est donc : sur quel URL tu t'es connecté pour télécharger ce paquet
- il existe un dossier qui contient la liste des URLs consultées quand vous demandez un téléchargement de paquets
```
[sonita@linux yum.repos.d]$ grep -rn -E "mirrorlist"
rocky-addons.repo:3:# The mirrorlist system uses the connecting IP address of the client and the
rocky-addons.repo:8:# If the mirrorlist does not work for you, you can try the commented out
rocky-addons.repo:13:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever$rltype
rocky-addons.repo:23:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=HighAvailability-$releasever-debug$rltype
rocky-addons.repo:32:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=HighAvailability-$releasever-source$rltype
rocky-addons.repo:41:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever$rltype
rocky-addons.repo:51:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=ResilientStorage-$releasever-debug$rltype
rocky-addons.repo:60:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=ResilientStorage-$releasever-source$rltype
rocky-addons.repo:69:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=NFV-$releasever$rltype
rocky-addons.repo:79:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
rocky-addons.repo:88:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
rocky-addons.repo:97:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever$rltype
rocky-addons.repo:107:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-debug$rltype
rocky-addons.repo:116:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=RT-$releasever-source$rltype
rocky-addons.repo:125:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever$rltype
rocky-addons.repo:135:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-debug$rltype
rocky-addons.repo:144:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAP-$releasever-source$rltype
rocky-addons.repo:153:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever$rltype
rocky-addons.repo:163:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-debug$rltype
rocky-addons.repo:172:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=SAPHANA-$releasever-source$rltype
rocky-devel.repo:7:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever$rltype
rocky-devel.repo:16:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever-debug$rltype
rocky-devel.repo:25:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=devel-$releasever-source$rltype
rocky-extras.repo:3:# The mirrorlist system uses the connecting IP address of the client and the
rocky-extras.repo:8:# If the mirrorlist does not work for you, you can try the commented out
rocky-extras.repo:13:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever$rltype
rocky-extras.repo:23:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-debug$rltype
rocky-extras.repo:32:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=extras-$releasever-source$rltype
rocky-extras.repo:41:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=plus-$releasever$rltype
rocky-extras.repo:51:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=plus-$releasever-debug$rltype
rocky-extras.repo:60:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=plus-$releasever-source$rltype
rocky.repo:3:# The mirrorlist system uses the connecting IP address of the client and the
rocky.repo:8:# If the mirrorlist does not work for you, you can try the commented out
rocky.repo:13:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever$rltype
rocky.repo:23:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=BaseOS-$releasever-debug$rltype
rocky.repo:32:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=BaseOS-$releasever-source$rltype
rocky.repo:41:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever$rltype
rocky.repo:51:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=AppStream-$releasever-debug$rltype
rocky.repo:60:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=AppStream-$releasever-source$rltype
rocky.repo:69:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever$rltype
rocky.repo:79:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=$basearch&repo=CRB-$releasever-debug$rltype
rocky.repo:88:mirrorlist=https://mirrors.rockylinux.org/mirrorlist?arch=source&repo=CRB-$releasever-source$rltype
```




# Partie 3 : Poupée russe
🌞 **Récupérer le fichier `meow`**

- [il est dispo là](./meow) (juste à côté de ce README.md)
- téléchargez-le à l'aide d'une commande

```
[sonita@linux yum.repos.d]$ sudo dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
[sonita@linux yum.repos.d]$ sudo dnf install wget
[sonita@linux yum.repos.d]$ wget https://gitlab.com/it4lik/b1-linux-2023/-/raw/master/tp/2/meow?inline=false
```


🌞 **Trouver le dossier `dawa/`**

- le fichier `meow` récupéré est une archive compressée
- utilisez la commande `file /path/vers/le/fichier` pour déterminer le type du fichier
- renommez-le fichier correctement (si c'est une archive compressée ZIP, il faut ajouter `.zip` à son nom)
- extraire l'archive avec une commande
- répétez ces opérations jusqu'à trouver le dossier `dawa/`

> *Dans les OS Linux, le format d'archivage/compression qu'on voit le plus c'est `.tar.gz` (archivage tar avec une compression gz) et moins de `.zip`.*
```
[sonita@linux ~]$ unzip meow.zip
Archive:  meow.zip
  inflating: meow
[sonita@linux ~]$ ls
meow  meow.zip
[sonita@linux ~]$ file meow
meow: XZ compressed data
[sonita@linux ~]$ mv meow meow.xz
[sonita@linux ~]$ unxz meow.xz
[sonita@linux ~]$ file meow
meow: bzip2 compressed data, block size = 900k
[sonita@linux ~]$ mv meow meow.bz2
[sonita@linux ~]$ sudo dnf install bzip2
[sonita@linux ~]$ file meow
meow: RAR archive data, v5
[sonita@linux ~]$ mv meow meow.rar
[sonita@linux ~]$ sudo dnf install unrar
[sonita@linux ~]$ unrar e meow.rar
[sonita@linux ~]$ file meow
meow: gzip compressed data, from Unix, original size modulo 2^32 145049600
[sonita@linux ~]$ mv meow meow.gz
[sonita@linux ~]$ sudo gunzip meow.gz
[sonita@linux ~]$ file meow
meow: POSIX tar archive (GNU)
[sonita@linux ~]$ mv meow meow.tar
[sonita@linux ~]$ sudo dnf install tar
tar -xf meow.tar
```


🌞 **Dans le dossier `dawa/`, déterminer le chemin vers**

- le seul fichier de 15Mo
```
[sonita@linux ~]$ find dawa -type f -size 15M -print
dawa/folder31/19/file39
```

- le seul fichier qui ne contient que des `7`
```
[sonita@linux ~]$ find dawa -type f -exec grep -q '^[7]*$' {} \; -print
dawa/folder43/38/file41
```

- le seul fichier qui est nommé `cookie`
```
[sonita@linux ~]$ find dawa -type f -name "cookie" -print
dawa/folder14/25/cookie
```

- le seul fichier caché (un fichier caché c'est juste un fichier dont le nom commence par un `.`)
```
[sonita@linux ~]$ find dawa -type f -name '.*' -print
dawa/folder32/14/.hidden_file
```

- le seul fichier qui date de 2014
```
[sonita@linux ~]$ find dawa -type f -newermt 2014-01-01 ! -newermt 2015-01-01 -print
dawa/folder36/40/file43
```

- le seul fichier qui a 5 dossiers-parents
  - je pense que vous avez vu que la structure c'est 50 `folderX`, chacun contient 50 dossiers `X`, et chacun contient 50 `fileX`
  - bon bah là y'a un fichier qui est contenu dans `folderX/X/X/X/X/` et c'est le seul qui 5 dossiers parents comme ça