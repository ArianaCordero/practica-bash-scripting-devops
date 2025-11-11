#!/bin/bash

ALERT_LOG="../logs/alerts.log"
METRICS_LOG="../logs/metrics_$(date +%Y%m%d).log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Umbrales de alerta
CPU_THRESHOLD=80
RAM_THRESHOLD=80
DISK_THRESHOLD=80

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "========================================" >> $METRICS_LOG
echo "[$TIMESTAMP] Reporte de Sistema" >> $METRICS_LOG
echo "========================================" >> $METRICS_LOG

# Funcion para obtener uso de CPU (convertir coma a punto)
get_cpu_usage() {
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | tr ',' '.')
    if [ -z "$CPU" ]; then
        CPU=$(mpstat 1 1 | awk '/Average/ {print 100-$NF}' | tr ',' '.')
    fi
    # Convertir a entero redondeando
    echo $CPU | awk '{printf "%.0f", $1}'
}

# Funcion para obtener uso de RAM
get_ram_usage() {
    RAM=$(free | grep Mem | awk '{printf "%.0f", ($3/$2) * 100}')
    echo $RAM
}

# Funcion para obtener uso de disco
get_disk_usage() {
    DISK=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
    echo $DISK
}

# Obtener metricas
CPU_USAGE=$(get_cpu_usage)
RAM_USAGE=$(get_ram_usage)
DISK_USAGE=$(get_disk_usage)

# Guardar metricas en el log diario
echo "CPU: ${CPU_USAGE}%" >> $METRICS_LOG
echo "RAM: ${RAM_USAGE}%" >> $METRICS_LOG
echo "DISK: ${DISK_USAGE}%" >> $METRICS_LOG
echo "" >> $METRICS_LOG

# Mostrar en pantalla con colores
echo -e "\n${YELLOW}Monitoreo del Sistema - $TIMESTAMP${NC}\n"
echo "========================================"

# Verificar CPU
if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo -e "${RED}[ALERTA] CPU: ${CPU_USAGE}%${NC}"
    echo "[$TIMESTAMP] ALERTA: Uso de CPU alto (${CPU_USAGE}%)" >> $ALERT_LOG
else
    echo -e "${GREEN}[OK] CPU: ${CPU_USAGE}%${NC}"
fi

# Verificar RAM
if [ "$RAM_USAGE" -ge "$RAM_THRESHOLD" ]; then
    echo -e "${RED}[ALERTA] RAM: ${RAM_USAGE}%${NC}"
    echo "[$TIMESTAMP] ALERTA: Uso de RAM alto (${RAM_USAGE}%)" >> $ALERT_LOG
else
    echo -e "${GREEN}[OK] RAM: ${RAM_USAGE}%${NC}"
fi

# Verificar Disco
if [ "$DISK_USAGE" -ge "$DISK_THRESHOLD" ]; then
    echo -e "${RED}[ALERTA] DISCO: ${DISK_USAGE}%${NC}"
    echo "[$TIMESTAMP] ALERTA: Uso de disco alto (${DISK_USAGE}%)" >> $ALERT_LOG
else
    echo -e "${GREEN}[OK] DISCO: ${DISK_USAGE}%${NC}"
fi

echo "========================================"
