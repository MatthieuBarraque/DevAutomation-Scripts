## 📄 **README.md**

Crée un fichier `README.md` dans la racine de ton dépôt avec le contenu suivant :

```markdown
# DevAutomation-Scripts

## Overview

**DevAutomation-Scripts** is a collection of shell scripts designed to streamline and automate essential development tasks. These scripts help in deploying projects, managing backups, and generating SSH keys efficiently.

## Scripts Included

1. **automatic_deploy_project.sh**
   - **Purpose:** Automates the deployment process of your projects.
   - **Features:**
     - Clones or updates the project repository.
     - Installs necessary dependencies.
     - Builds and restarts services as needed.
     - Logs deployment activities.

2. **automatic_save_targz.sh**
   - **Purpose:** Automates the backup of specified directories into compressed `.tar.gz` archives.
   - **Features:**
     - Accepts user input for source directories.
     - Excludes unnecessary files and folders.
     - Maintains a specified number of backup archives.
     - Logs backup activities and errors.

3. **automatic_ssh_key.sh**
   - **Purpose:** Streamlines the SSH key generation and management process.
   - **Features:**
     - Allows selection of encryption algorithms.
     - Prompts for user email, key name, and passphrase.
     - Generates SSH keys and adds them to the SSH agent.
     - Displays the public key for easy copying.
     - Optionally tests SSH connectivity with GitHub.

```

## Usage

### 1. **automatic_deploy_project.sh**

```bash
chmod +x automatic_deploy_project.sh
./automatic_deploy_project.sh
```

### 2. **automatic_save_targz.sh**

```bash
chmod +x automatic_save_targz.sh
./automatic_save_targz.sh
```

### 3. **automatic_ssh_key.sh**

```bash
chmod +x automatic_ssh_key.sh
./automatic_ssh_key.sh
```