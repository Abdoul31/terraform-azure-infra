#!/bin/bash
#====Script build test====
# ==== CONFIGURATION ====
APP_NAME="hello-app"
APP_DIR="$HOME/$APP_NAME"
JAR_NAME="hello-0.0.1-SNAPSHOT.jar"
SPRING_PORT=8081

echo "Déploiement de $APP_NAME sur la VM..."

# ==== 1. Mettre à jour les paquets ====
echo "🔧 Mise à jour des paquets..."
sudo apt update

# ==== 2. Installer Maven si non présent ====
if ! command -v mvn &> /dev/null; then
    echo "Maven non trouvé. Installation..."
    sudo apt install -y maven
else
    echo "Maven est déjà installé"
fi

# ==== 3. Vérifier le dossier de l'app ====
if [ ! -d "$APP_DIR" ]; then
    echo "Le dossier $APP_DIR n'existe pas. Veuillez copier le projet dessus."
    exit 1
fi

# ==== 4. Aller dans le dossier ====
cd "$APP_DIR" || exit

# ==== 5. Build du projet ====
echo "Compilation du projet..."
mvn clean package

# Vérification du succès
if [ ! -f "target/$JAR_NAME" ]; then
    echo "Build échoué. Fichier JAR introuvable."
    exit 1
fi

# ==== 6. Lancer l’application ====
echo "Lancement de l'application..."
nohup java -jar target/$JAR_NAME > app.log 2>&1 &

echo "Application lancée sur le port $SPRING_PORT"
echo "Logs disponibles dans $APP_DIR/app.log"
