#!/bin/bash

REPO_URL="https://github.com/ArianaCordero/test-webapp.git"
APP_DIR="../webapp"
DEPLOY_LOG="../logs/deploy.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] ========== Inicio de despliegue ==========" >> $DEPLOY_LOG

# Verifica si el directorio ya existe y tiene git
if [ -d "$APP_DIR/.git" ]; then
    echo "[$TIMESTAMP] Actualizando repositorio existente..." >> $DEPLOY_LOG
    echo "[INFO] Actualizando codigo..."
    
    cd $APP_DIR
    git pull origin main >> $DEPLOY_LOG 2>&1
    
    if [ $? -ne 0 ]; then
        echo "[$TIMESTAMP] ERROR: Fallo git pull - Despliegue abortado" >> $DEPLOY_LOG
        echo "[ERROR] Error al actualizar el repositorio"
        exit 1
    fi
    
    echo "[$TIMESTAMP] Repositorio actualizado exitosamente" >> $DEPLOY_LOG
    echo "[OK] Codigo actualizado correctamente"
else
    echo "[$TIMESTAMP] Clonando repositorio nuevo..." >> $DEPLOY_LOG
    echo "[INFO] Descargando codigo desde GitHub..."
    
    git clone $REPO_URL $APP_DIR >> $DEPLOY_LOG 2>&1
    
    if [ $? -ne 0 ]; then
        echo "[$TIMESTAMP] ERROR: Fallo git clone - Despliegue abortado" >> $DEPLOY_LOG
        echo "[ERROR] Error al clonar el repositorio"
        exit 1
    fi
    
    echo "[$TIMESTAMP] Repositorio clonado exitosamente" >> $DEPLOY_LOG
    echo "[OK] Codigo descargado correctamente"
fi

# Reinicia Nginx
echo "[$TIMESTAMP] Reiniciando Nginx..." >> $DEPLOY_LOG
echo "[INFO] Reiniciando servicio web..."

sudo systemctl restart nginx

if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Nginx reiniciado exitosamente" >> $DEPLOY_LOG
    echo "[OK] Despliegue completado exitosamente"
else
    echo "[$TIMESTAMP] ERROR: Fallo el reinicio de Nginx" >> $DEPLOY_LOG
    echo "[ERROR] Error al reiniciar Nginx"
    exit 1
fi

echo "[$TIMESTAMP] ========== Despliegue finalizado ==========" >> $DEPLOY_LOG

