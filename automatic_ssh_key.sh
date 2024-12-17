#!/bin/bash

function display_menu() {
    echo "-------------------------------"
    echo "Choisissez l'algorithme de chiffrement :"
    echo "1) rsa      (2048/4096 bits)"
    echo "2) ed25519  (recommandé pour sa sécurité et performance)"
    echo "3) ecdsa    (224/256/384/521 bits)"
    echo "4) dsa      (moins sécurisé)"
    echo "-------------------------------"
}

display_menu
read -p "Entrez le numéro correspondant à l'algorithme : " algo_choice

case $algo_choice in
    1)
        ALGO="rsa"
        read -p "Entrez la taille de la clé (2048/4096) : " KEY_SIZE
        OPTIONS="-t rsa -b ${KEY_SIZE}"
        ;;
    2)
        ALGO="ed25519"
        OPTIONS="-t ed25519"
        ;;
    3)
        ALGO="ecdsa"
        read -p "Entrez la taille de la clé (224/256/384/521) : " KEY_SIZE
        OPTIONS="-t ecdsa -b ${KEY_SIZE}"
        ;;
    4)
        ALGO="dsa"
        OPTIONS="-t dsa"
        ;;
    *)
        echo "Choix invalide. Utilisation par défaut de ed25519."
        ALGO="ed25519"
        OPTIONS="-t ed25519"
        ;;
esac

read -p "Entrez votre adresse email : " EMAIL

read -p "Entrez le nom de la clé (par défaut : id_${ALGO}) : " KEY_NAME
KEY_NAME=${KEY_NAME:-id_${ALGO}}

read -sp "Entrez une passphrase (laissez vide pour aucune passphrase) : " PASSPHRASE
echo ""

echo "Génération de la clé SSH..."
ssh-keygen ${OPTIONS} -C "${EMAIL}" -f ~/.ssh/${KEY_NAME} -N "${PASSPHRASE}"

echo "Démarrage de ssh-agent..."
eval "$(ssh-agent -s)"

echo "Ajout de la clé au ssh-agent..."
ssh-add ~/.ssh/${KEY_NAME}

echo "Voici votre clé publique :"
echo "----------------------------------"
cat ~/.ssh/${KEY_NAME}.pub
echo "----------------------------------"

read -p "Voulez-vous tester la connexion SSH avec GitHub ? (y/n) : " TEST_GITHUB
if [[ "${TEST_GITHUB}" == "y" || "${TEST_GITHUB}" == "Y" ]]; then
    ssh -T git@github.com
fi

echo "Script terminé. N'oubliez pas d'ajouter votre clé publique à votre compte GitHub !"
