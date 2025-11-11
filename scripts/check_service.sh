#!/bin/bash

# Verificar que se pasó un parámetro
if [ -z "$1" ]; then
    echo "Error: Debes proporcionar el nombre del servicio"
    echo "Uso: ./check_service.sh <nombre_servicio>"
    exit 1
fi

SERVICE=$1
LOG_FILE="../logs/service_status.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
EMAIL_TO="$USER@localhost"  

if systemctl is-active --quiet $SERVICE; then
    STATUS="ACTIVO ✓"
    echo "[$TIMESTAMP] $SERVICE está $STATUS" | tee -a $LOG_FILE
    echo "✅ El servicio $SERVICE está funcionando correctamente"
else
    STATUS="INACTIVO ✗"
    MESSAGE="🚨 ALERTA: El servicio $SERVICE NO está activo en $(hostname)"
    
    echo "[$TIMESTAMP] $SERVICE está $STATUS" | tee -a $LOG_FILE
    echo "$MESSAGE"
    echo "Intenta iniciarlo con: sudo systemctl start $SERVICE"
    
    echo "El servicio $SERVICE está INACTIVO desde $TIMESTAMP" | \
    mail -s "⚠️ ALERTA: Servicio $SERVICE caído" $EMAIL_TO
    
    echo "📧 Notificación enviada a $EMAIL_TO"
fi
