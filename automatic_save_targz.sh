#!/bin/bash

DEST_DIR="$HOME/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
EXCLUDE_LIST=(".git" "node_modules" "*.log")
MAX_BACKUPS=5
LOG_FILE="$DEST_DIR/backup.log"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

function log_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

function check_errors() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERREUR]${NC} Une erreur s'est produite."
        log_message "[ERREUR] Une erreur s'est produite."
        exit 1
    fi
}

function cleanup_old_backups() {
    log_message "Vérification des anciennes sauvegardes..."
    BACKUPS=( $(ls -1t "$DEST_DIR"/backup_*.tar.gz 2>/dev/null) )
    COUNT=${#BACKUPS[@]}

    if [ $COUNT -gt $MAX_BACKUPS ]; then
        TO_DELETE=${BACKUPS[@]:$MAX_BACKUPS}
        for FILE in $TO_DELETE; do
            rm -f "$FILE"
            log_message "Ancienne sauvegarde supprimée : $FILE"
        done
    fi
}

function validate_directory() {
    while true; do
        read -p "👉 Entrez le chemin du dossier à sauvegarder : " SOURCE_DIR
        if [ -d "$SOURCE_DIR" ]; then
            log_message "Dossier à sauvegarder : $SOURCE_DIR"
            break
        else
            echo -e "${RED}[ERREUR]${NC} Le dossier '$SOURCE_DIR' n'existe pas. Veuillez réessayer."
        fi
    done
}

mkdir -p "$DEST_DIR"
log_message "Répertoire de sauvegarde : $DEST_DIR"

validate_directory

ARCHIVE_NAME="backup_$(basename "$SOURCE_DIR")_$TIMESTAMP.tar.gz"

log_message "Espace disque avant sauvegarde :"
df -h "$DEST_DIR"

EXCLUDES=""
for EXCLUDE in "${EXCLUDE_LIST[@]}"; do
    EXCLUDES+=" --exclude=$EXCLUDE"
done

log_message "Début de la sauvegarde..."
tar -czvf "$DEST_DIR/$ARCHIVE_NAME" $EXCLUDES "$SOURCE_DIR"
check_errors

log_message "✅ Sauvegarde terminée : $DEST_DIR/$ARCHIVE_NAME"

cleanup_old_backups

log_message "Espace disque après sauvegarde :"
df -h "$DEST_DIR"

log_message "Script de sauvegarde terminé avec succès !"
echo -e "${GREEN}[SUCCÈS]${NC} Votre sauvegarde est disponible ici : $DEST_DIR/$ARCHIVE_NAME"
