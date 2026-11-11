#!/bin/sh

# Fonction pour afficher la bannière ASCII et le message de bienvenue
print_banner() {
    cat << "EOF"
 _   _ _____ _____ ___    _____ _   _ 
| \ | |  ___|_   _/ _ \  |_   _| \ | |
|  \| | |__   | || | | |   | | |  \| |
| |\  |  __|  | || |_| |   | | | |\  |
|_| \_|_|     |_| \___/    |_| |_| \_|
                                      
EOF
    echo "==============================================================="
    echo " Ce script est fourni gratuitement et SANS AUCUNE GARANTIE ni"
    echo " responsabilité. Fourni par : neto.tn"
    echo "==============================================================="
    echo ""
}

# Fonction pour afficher l'aide / usage
show_help() {
    print_banner
    echo "Usage : $0 [OPTIONS] <nouveau_hostname>"
    echo ""
    echo "Options :"
    echo "  -h, --help    Affiche ce message d'aide et quitte"
    echo ""
    echo "Description :"
    echo "  Ce script modifie le nom d'hôte (hostname) de votre machine"
    echo "  Linux de façon permanente. Il est conçu pour être compatible"
    echo "  avec la majorité des shells et distributions connues."
    echo ""
    echo "Exemple d'utilisation :"
    echo "  sudo $0 MonNouveauServeur"
    echo ""
}

# Vérification des arguments pour l'aide
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Affichage de la bannière au lancement normal
print_banner

# Vérification des privilèges root
if [ "$(id -u)" -ne 0 ]; then
    echo "Erreur : Ce script doit être exécuté en tant que root (utilisez sudo)." >&2
    exit 1
fi

# Vérification du nombre de paramètres
if [ "$#" -ne 1 ]; then
    echo "Erreur : Nombre d'arguments invalide." >&2
    echo "Tapez '$0 --help' pour plus d'informations." >&2
    exit 1
fi

NEW_HOSTNAME=$1
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
    sed -i "s/^HOSTNAME=.*/HOSTNAME=$NEW_HOSTNAME/" /etc/sysconfig/network
fi

# 4. Mise à jour de /etc/hosts pour éviter les problèmes de résolution locale
if [ -f /etc/hosts ] && [ -n "$OLD_HOSTNAME" ] && [ "$OLD_HOSTNAME" != "$NEW_HOSTNAME" ]; then
    sed -i "s/\b$OLD_HOSTNAME\b/$NEW_HOSTNAME/g" /etc/hosts
fi

echo "Le nom d'hôte a été modifié avec succès en '$NEW_HOSTNAME'."
echo "Note : Vous devrez peut-être redémarrer votre session terminal pour voir le changement dans le prompt."
