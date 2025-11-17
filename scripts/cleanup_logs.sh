#!/bin/bash

LOG_DIR="../logs"
BACKUP_DIR="../backup/logs"
CLEANUP_LOG="../logs/cleanup_actions.log"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
DATE_READABLE=$(date '+%Y-%m-%d %H:%M:%S')

# Crear directorio de backup si no existe
mkdir -p $BACKUP_DIR

echo "[$DATE_READABLE] ========== Inicio de limpieza ==========" >> $CLEANUP_LOG

# Buscar archivos de logs con + 7 dias
OLD_FILES=$(find $LOG_DIR -name "*.log" -type f -mtime +7 ! -name "cleanup_actions.log" ! -name "service_status.log")

if [ -z "$OLD_FILES" ]; then
    echo "[$DATE_READABLE] No se encontraron archivos antiguos para limpiar" >> $CLEANUP_LOG
    echo "[OK] No hay archivos antiguos (>7 dias) para limpiar"
    exit 0
fi

# Comprime archivos antiguos
ARCHIVE_NAME="logs_backup_$TIMESTAMP.tar.gz"
echo "[$DATE_READABLE] Comprimiendo archivos antiguos..." >> $CLEANUP_LOG

tar -czf $BACKUP_DIR/$ARCHIVE_NAME -C $LOG_DIR $(basename -a $OLD_FILES) 2>/dev/null

# Verificar que la compresion 
if [ $? -eq 0 ]; then
    echo "[$DATE_READABLE] Archivo comprimido: $ARCHIVE_NAME" >> $CLEANUP_LOG
    echo "[OK] Archivos comprimidos exitosamente: $ARCHIVE_NAME"
    
    # Elimina archivos originales
    echo "$OLD_FILES" | while read file; do
        rm -f "$file"
        echo "[$DATE_READABLE] Eliminado: $(basename $file)" >> $CLEANUP_LOG
    done
    
    echo "[$DATE_READABLE] Limpieza completada exitosamente" >> $CLEANUP_LOG
    echo "[OK] Archivos originales eliminados"
else
    echo "[$DATE_READABLE] ERROR: Fallo la compresion" >> $CLEANUP_LOG
    echo "[ERROR] Error al comprimir archivos"
    exit 1
fi

echo "[$DATE_READABLE] ========== Fin de limpieza ==========" >> $CLEANUP_LOG
