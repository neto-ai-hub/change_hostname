#!/bin/sh

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo "Erreur : Ce script doit être exécuté en tant que root (utilisez sudo)." >&2
    exit 1
fi

# Vérification du paramètre (le nouveau hostname)
if [ "$#" -ne 1 ]; then
    echo "Usage : $0 <nouveau_hostname>" >&2
    exit 1
fi

NEW_HOSTNAME=$1
# Récupération de l'ancien hostname pour le remplacer dans /etc/hosts
OLD_HOSTNAME=$(hostname)

echo "Changement du nom d'hôte de '$OLD_HOSTNAME' vers '$NEW_HOSTNAME'..."

# 1. Utilisation de hostnamectl pour les distributions modernes (Systemd)
if command -v hostnamectl >/dev/null 2>&1; then
    hostnamectl set-hostname "$NEW_HOSTNAME"
else
    # Application immédiate en mémoire pour les systèmes sans Systemd
    hostname "$NEW_HOSTNAME"
fi

# 2. Mise à jour de /etc/hostname (Debian, Ubuntu, Arch, Fedora, etc.)
if [ -f /etc/hostname ]; then
    echo "$NEW_HOSTNAME" > /etc/hostname
fi

# 3. Mise à jour de /etc/sysconfig/network (Anciennes distros RedHat / CentOS)
if [ -f /etc/sysconfig/network ]; then
    # Remplace la ligne HOSTNAME=... si elle existe
    sed -i "s/^HOSTNAME=.*/HOSTNAME=$NEW_HOSTNAME/" /etc/sysconfig/network
fi

# 4. Mise à jour de /etc/hosts pour éviter les problèmes de résolution locale
if [ -f /etc/hosts ] && [ -n "$OLD_HOSTNAME" ] && [ "$OLD_HOSTNAME" != "$NEW_HOSTNAME" ]; then
    # Remplacement de l'ancien nom par le nouveau
    sed -i "s/\b$OLD_HOSTNAME\b/$NEW_HOSTNAME/g" /etc/hosts
fi

echo "Le nom d'hôte a été modifié avec succès en '$NEW_HOSTNAME'."
echo "Note : Vous devrez peut-être redémarrer votre session terminal pour voir le changement dans le prompt."
