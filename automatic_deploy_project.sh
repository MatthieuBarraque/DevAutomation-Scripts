#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_TYPES=("Web" "CLI" "Library" "Mobile" "Data Science" "Embedded" "Other")

declare -A LANGUAGE_OPTIONS
LANGUAGE_OPTIONS["Web"]="Python JavaScript TypeScript Ruby PHP Java C# Go Rust"
LANGUAGE_OPTIONS["CLI"]="Python JavaScript Rust Go C++ Java"
LANGUAGE_OPTIONS["Library"]="Python JavaScript Rust C++ Go"
LANGUAGE_OPTIONS["Mobile"]="Java Kotlin Swift Dart"
LANGUAGE_OPTIONS["Data Science"]="Python R Julia"
LANGUAGE_OPTIONS["Embedded"]="C C++ Rust"
LANGUAGE_OPTIONS["Other"]=""

declare -A PROJECT_STRUCTURES

# Web - Python (Django)
PROJECT_STRUCTURES["Web_Python_Django"]="
project_name/
├── manage.py
├── requirements.txt
├── README.md
├── .gitignore
├── myproject/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── app/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
"

# Web - JavaScript (Node.js avec Express)
PROJECT_STRUCTURES["Web_JavaScript_Node.js"]="
project_name/
├── package.json
├── package-lock.json
├── README.md
├── .gitignore
├── src/
│   ├── app.js
│   ├── routes/
│   │   └── index.js
│   └── controllers/
│       └── mainController.js
├── config/
│   └── default.json
└── public/
    ├── css/
    ├── js/
    └── images/
"

# CLI - Python
PROJECT_STRUCTURES["CLI_Python"]="
project_name/
├── bin/
│   └── project_name
├── project_name/
│   ├── __init__.py
│   └── main.py
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── requirements.txt
├── setup.py
├── README.md
└── .gitignore
"

# CLI - Rust
PROJECT_STRUCTURES["CLI_Rust"]="
project_name/
├── Cargo.toml
├── Cargo.lock
├── src/
│   └── main.rs
├── tests/
│   └── integration_test.rs
├── README.md
└── .gitignore
"

# Library - Rust
PROJECT_STRUCTURES["Library_Rust"]="
project_name/
├── Cargo.toml
├── Cargo.lock
├── src/
│   ├── lib.rs
│   └── types.rs
├── examples/
│   └── example.rs
├── tests/
│   └── integration_test.rs
├── README.md
└── .gitignore
"

function display_menu() {
    echo -e "${BLUE}===== Créateur de Projet Automatisé =====${NC}"
}

function choose_project_type() {
    echo -e "${YELLOW}Choisissez le type de projet :${NC}"
    select type in "${PROJECT_TYPES[@]}"; do
        if [[ -n "$type" ]]; then
            PROJECT_TYPE=$type
            echo -e "${GREEN}Type de projet sélectionné : $PROJECT_TYPE${NC}"
            break
        else
            echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
        fi
    done
}

function choose_language() {
    AVAILABLE_LANGUAGES=${LANGUAGE_OPTIONS[$PROJECT_TYPE]}
    if [[ -z "$AVAILABLE_LANGUAGES" ]]; then
        echo -e "${RED}Aucun langage défini pour le type de projet sélectionné.${NC}"
        read -p "Entrez le langage de programmation souhaité : " LANGUAGE
    else
        echo -e "${YELLOW}Choisissez le langage de programmation :${NC}"
        select lang in $AVAILABLE_LANGUAGES; do
            if [[ -n "$lang" ]]; then
                LANGUAGE=$lang
                echo -e "${GREEN}Langage sélectionné : $LANGUAGE${NC}"
                break
            else
                echo -e "${RED}Choix invalide. Veuillez réessayer.${NC}"
            fi
        done
    fi
}

function get_project_name() {
    while true; do
        read -p "👉 Entrez le nom du projet : " PROJECT_NAME
        if [[ -d "$PROJECT_NAME" ]]; then
            echo -e "${RED}Un dossier avec ce nom existe déjà. Veuillez choisir un autre nom.${NC}"
        elif [[ -z "$PROJECT_NAME" ]]; then
            echo -e "${RED}Le nom du projet ne peut pas être vide.${NC}"
        else
            break
        fi
    done
    echo -e "${GREEN}Nom du projet défini : $PROJECT_NAME${NC}"
}

function create_project_structure() {
    KEY="${PROJECT_TYPE}_${LANGUAGE}"
    STRUCTURE=${PROJECT_STRUCTURES[$KEY]}

    if [[ -z "$STRUCTURE" ]]; then
        echo -e "${YELLOW}Aucune structure prédéfinie pour $PROJECT_TYPE avec $LANGUAGE.${NC}"
        read -p "Voulez-vous créer une structure vide ? (y/n) : " CREATE_EMPTY
        if [[ "$CREATE_EMPTY" =~ ^[Yy]$ ]]; then
            mkdir -p "$PROJECT_NAME/src"
            echo -e "${GREEN}Structure de base créée.${NC}"
        else
            echo -e "${RED}Création du projet annulée.${NC}"
            exit 1
        fi
    else
        STRUCTURE=${STRUCTURE//project_name/$PROJECT_NAME}
        echo -e "${BLUE}Création de la structure du projet...${NC}"
        mkdir -p "$PROJECT_NAME"
        echo "$STRUCTURE" | while IFS= read -r line; do
            if [[ "$line" =~ /$ ]]; then
                mkdir -p "$PROJECT_NAME/$line"
            else
                FILE_PATH="$PROJECT_NAME/$line"
                mkdir -p "$(dirname "$FILE_PATH")"
                touch "$FILE_PATH"
                case "$(basename "$FILE_PATH")" in
                    README.md)
                        echo "# $PROJECT_NAME" > "$FILE_PATH"
                        ;;
                    .gitignore)
                        echo "node_modules/\n*.log" > "$FILE_PATH"
                        ;;
                    requirements.txt)
                        echo "" > "$FILE_PATH"
                        ;;
                    package.json)
                        echo "{}" > "$FILE_PATH"
                        ;;
                    Cargo.toml)
                        echo "[package]\nname = \"$PROJECT_NAME\"\nversion = \"0.1.0\"\nedition = \"2021\"" > "$FILE_PATH"
                        ;;
                    Makefile)
                        echo "all:\n\t@echo \"Hello, World!\"" > "$FILE_PATH"
                        ;;
                    *)
                        ;;
                esac
            fi
        done
        echo -e "${GREEN}Structure du projet créée avec succès.${NC}"
    fi
}

function initialize_git() {
    read -p "Voulez-vous initialiser un dépôt Git ? (y/n) : " INIT_GIT
    if [[ "$INIT_GIT" =~ ^[Yy]$ ]]; then
        cd "$PROJECT_NAME"
        git init
        echo -e "${GREEN}Dépôt Git initialisé.${NC}"
        # Optionnel : Ajouter un remote
        read -p "Voulez-vous ajouter un remote GitHub ? (y/n) : " ADD_REMOTE
        if [[ "$ADD_REMOTE" =~ ^[Yy]$ ]]; then
            read -p "👉 Entrez l'URL du dépôt GitHub : " REMOTE_URL
            git remote add origin "$REMOTE_URL"
            echo -e "${GREEN}Remote Git ajouté : $REMOTE_URL${NC}"
        fi
        cd ..
    fi
}

function install_dependencies() {
    case "$LANGUAGE" in
        Python)
            if [[ "$PROJECT_TYPE" == "Web" ]]; then
                pip install django
                echo "django" > "$PROJECT_NAME/requirements.txt"
                cd "$PROJECT_NAME"
                django-admin startproject myproject .
                cd ..
                echo -e "${GREEN}Dépendances Python installées.${NC}"
            elif [[ "$PROJECT_TYPE" == "CLI" ]]; then
                pip install click
                echo "click" > "$PROJECT_NAME/requirements.txt"
                cd "$PROJECT_NAME"
                cat <<EOL > "$PROJECT_NAME/project_name/main.py"
import click

@click.command()
def main():
    click.echo('Hello, World!')

if __name__ == '__main__':
    main()
EOL
                cd ..
                echo -e "${GREEN}Dépendances Python installées et script CLI créé.${NC}"
            fi
            ;;
        JavaScript)
            cd "$PROJECT_NAME"
            npm init -y
            if [[ "$PROJECT_TYPE" == "Web" ]]; then
                npm install express
                mkdir src
                cat <<EOL > src/app.js
const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

app.listen(port, () => {
    console.log(\`Server running on port \${port}\`);
});
EOL
            elif [[ "$PROJECT_TYPE" == "CLI" ]]; then
                npm install commander
                mkdir src
                cat <<EOL > src/index.js
#!/usr/bin/env node

const { program } = require('commander');

program
  .version('1.0.0')
  .description('A simple CLI tool');

program
  .command('greet <name>')
  .description('Greet a person')
  .action((name) => {
    console.log(\`Hello, \${name}!\`);
  });

program.parse(process.argv);
EOL
                chmod +x src/index.js
                # Ajouter le bin dans package.json
                sed -i 's/"main": "index.js"/"main": "src\/index.js", "bin": { "project_name": "src\/index.js" },/' package.json
            fi
            cd ..
            echo -e "${GREEN}Dépendances JavaScript installées.${NC}"
            ;;
        Rust)
            cd "$PROJECT_NAME"
            cargo init
            if [[ "$PROJECT_TYPE" == "CLI" ]]; then
                cat <<EOL > src/main.rs
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    println!("Hello, {}!", if args.len() > 1 { &args[1] } else { "World" });
}
EOL
            fi
            cd ..
            echo -e "${GREEN}Dépendances Rust installées.${NC}"
            ;;
        Go)
            mkdir -p "$PROJECT_NAME/src"
            cd "$PROJECT_NAME"
            go mod init "$PROJECT_NAME"
            if [[ "$PROJECT_TYPE" == "Web" ]]; then
                go get -u github.com/gin-gonic/gin
                cat <<EOL > src/main.go
package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    r.GET("/", func(c *gin.Context) {
        c.JSON(200, gin.H{
            "message": "Hello, World!",
        })
    })
    r.Run() // listen and serve on 0.0.0.0:8080
}
EOL
            elif [[ "$PROJECT_TYPE" == "CLI" ]]; then
                cat <<EOL > src/main.go
package main

import (
    "fmt"
    "os"
)

func main() {
    if len(os.Args) > 1 {
        fmt.Printf("Hello, %s!\n", os.Args[1])
    } else {
        fmt.Println("Hello, World!")
    }
}
EOL
            fi
            cd ..
            echo -e "${GREEN}Dépendances Go installées.${NC}"
            ;;
        Java)
            mkdir -p "$PROJECT_NAME/src/main/java"
            mkdir -p "$PROJECT_NAME/src/test/java"
            cat <<EOL > "$PROJECT_NAME/build.gradle"
plugins {
    id 'java'
}

group 'com.example'
version '1.0-SNAPSHOT'

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'junit:junit:4.12'
}

EOL
            cat <<EOL > "$PROJECT_NAME/src/main/java/Main.java"
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
EOL
            echo -e "${GREEN}Dépendances Java installées et structure créée.${NC}"
            ;;
        C++)
            mkdir -p "$PROJECT_NAME/src"
            cat <<EOL > "$PROJECT_NAME/Makefile"
CXX = g++
CXXFLAGS = -Wall -g
TARGET = main
SRCS = src/main.cpp
OBJS = \$(SRCS:.cpp=.o)

all: \$(TARGET)

\$(TARGET): \$(OBJS)
	\$(CXX) \$(CXXFLAGS) -o \$@ \$^

%.o: %.cpp
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

clean:
	rm -f \$(TARGET) \$(OBJS)
EOL
            cat <<EOL > "$PROJECT_NAME/src/main.cpp"
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
EOL
            echo -e "${GREEN}Makefile et fichier C++ créés.${NC}"
            ;;
        PHP)
            mkdir -p "$PROJECT_NAME/src"
            cat <<EOL > "$PROJECT_NAME/composer.json"
{
    "name": "$PROJECT_NAME/package",
    "description": "A PHP project",
    "require": {}
}
EOL
            cat <<EOL > "$PROJECT_NAME/src/index.php"
<?php
echo "Hello, World!";
?>
EOL
            echo -e "${GREEN}Dépendances PHP installées et structure créée.${NC}"
            ;;
        *)
            echo -e "${YELLOW}Aucune installation de dépendances définie pour ce langage.${NC}"
            ;;
    esac
}

display_menu
get_project_name
choose_project_type
choose_language
create_project_structure
initialize_git
install_dependencies

echo -e "${GREEN}✅ Projet '$PROJECT_NAME' créé avec succès !${NC}"
echo -e "${GREEN}📂 Naviguez dans le dossier : cd $PROJECT_NAME${NC}"
