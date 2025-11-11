# Práctica de Bash Scripting para Automatización de Sistemas

**Universidad Privada Boliviana**  
**Carrera:** Ingeniería de Sistemas / Informática  
**Materia:** Administración de Sistemas Operativos / DevOps  
**Estudiante:** Ariana Cordero  
**Correo Institucional:** arianacorderom1@upb.edu  
**Fecha:** Noviembre 2025  

---

## Índice

1. [Introducción](#introducción)
2. [Objetivos](#objetivos)
3. [Marco Teórico](#marco-teórico)
4. [Desarrollo de la Práctica](#desarrollo-de-la-práctica)
5. [Implementación](#implementación)
6. [Resultados](#resultados)
7. [Conclusiones](#conclusiones)
8. [Referencias](#referencias)

---

## Introducción

El presente trabajo tiene como finalidad demostrar el dominio de técnicas de automatización mediante scripting en Bash, aplicadas a tareas comunes de administración de sistemas Linux. Se han desarrollado cuatro scripts que cubren aspectos fundamentales de DevOps: monitoreo de servicios, gestión de logs, despliegue continuo y monitoreo de recursos del sistema.

La automatización de tareas administrativas es esencial en entornos empresariales modernos, donde la eficiencia operacional y la reducción de errores humanos son prioridades. Los scripts desarrollados en esta práctica representan soluciones reales a problemas cotidianos en la administración de servidores.

---

## Objetivos

### Objetivo General

Desarrollar e implementar un conjunto de scripts en Bash que automaticen tareas críticas de administración de sistemas Linux, aplicando principios de DevOps y mejores prácticas de programación.

### Objetivos Específicos

1. Implementar un sistema de monitoreo automatizado de servicios del sistema operativo con notificaciones de alertas.

2. Crear un mecanismo de gestión automática de logs que incluya compresión, respaldo y limpieza programada.

3. Desarrollar un sistema de despliegue continuo (CI/CD) que integre control de versiones con Git y reinicio automatizado de servicios.

4. Diseñar un script de monitoreo de recursos del sistema (CPU, RAM, disco) con sistema de alertas basado en umbrales configurables.

5. Documentar adecuadamente el código y los procesos implementados siguiendo estándares profesionales.

---

## Marco Teórico

### Bash Scripting

Bash (Bourne Again Shell) es el intérprete de comandos predeterminado en la mayoría de distribuciones Linux. Permite la automatización de tareas mediante la escritura de scripts que combinan comandos del sistema operativo con estructuras de control de flujo.

### Componentes Clave Utilizados

**Systemd:** Sistema de inicialización y gestor de servicios en Linux moderno. Utilizado para verificar y controlar el estado de servicios del sistema.

**Cron:** Demonio de Linux que ejecuta comandos programados a intervalos específicos. Fundamental para la automatización de tareas repetitivas.

**Git:** Sistema de control de versiones distribuido utilizado para gestionar el código fuente y facilitar el despliegue continuo.

**Bash Functions:** Funciones reutilizables que encapsulan lógica específica, mejorando la modularidad y mantenibilidad del código.

### Principios de DevOps Aplicados

- **Automatización:** Eliminación de procesos manuales repetitivos
- **Monitoreo Continuo:** Supervisión constante del estado del sistema
- **Infraestructura como Código:** Gestión de configuraciones mediante scripts
- **Integración Continua:** Automatización del proceso de despliegue

---

## Desarrollo de la Práctica

### Nivel 1: Monitoreo de Servicios (check_service.sh)

**Descripción Técnica:**

Script que verifica el estado de servicios del sistema mediante systemctl, registra el resultado en logs con timestamp y envía notificaciones por correo electrónico cuando un servicio está inactivo.

**Funcionalidades Implementadas:**

- Validación de parámetros de entrada
- Verificación de estado de servicio usando systemctl
- Generación de logs con formato estándar
- Sistema de alertas mediante correo electrónico local
- Manejo de errores y códigos de salida apropiados

**Uso:**
```bash
./check_service.sh <nombre_servicio>
```

**Ejemplo:**
```bash
./check_service.sh nginx
```

**Salida Esperada:**
```
[2025-11-11 10:30:15] nginx está ACTIVO
El servicio nginx está funcionando correctamente
```

**Código Clave:**
- Uso de condicionales para evaluar estado del servicio
- Redirección de salida con `tee` para logs simultáneos
- Variables para gestión de rutas y timestamps

---

### Nivel 2: Gestión Automática de Logs (cleanup_logs.sh)

**Descripción Técnica:**

Script que automatiza la gestión del ciclo de vida de archivos de log, implementando una política de retención que comprime y archiva logs antiguos para optimizar el uso de espacio en disco.

**Funcionalidades Implementadas:**

- Búsqueda de archivos mediante `find` con criterios de antigüedad
- Compresión de archivos usando `tar` con formato gzip
- Verificación de integridad de backups antes de eliminar originales
- Exclusión de logs críticos del sistema
- Registro detallado de todas las operaciones realizadas
- Integración con cron para ejecución programada

**Uso:**
```bash
./cleanup_logs.sh
```

**Política de Retención:**
- Archivos mayores a 7 días son comprimidos
- Los backups se almacenan en directorio separado
- Se genera un log de auditoría de todas las acciones

**Configuración Cron:**
```bash
0 2 * * * /home/ari/bash-practice/scripts/cleanup_logs.sh
```

**Proceso de Ejecución:**
1. Identificación de archivos antiguos
2. Compresión en formato tar.gz
3. Verificación de éxito de compresión
4. Eliminación de archivos originales
5. Registro de acciones en log de auditoría

---

### Nivel 3: Despliegue Automatizado (deploy_app.sh)

**Descripción Técnica:**

Implementación de un pipeline de despliegue continuo (CI/CD) que automatiza la actualización de aplicaciones desde un repositorio Git remoto, incluyendo reinicio de servicios y control de errores robusto.

**Funcionalidades Implementadas:**

- Clonación automática de repositorio en primer despliegue
- Actualización mediante `git pull` en despliegues subsecuentes
- Validación de éxito de operaciones Git
- Reinicio automatizado de servicios web (Nginx)
- Rollback automático en caso de fallo
- Logging detallado de cada etapa del despliegue

**Uso:**
```bash
./deploy_app.sh
```

**Flujo de Despliegue:**
```
┌─────────────────┐
│ Inicio Deploy   │
└────────┬────────┘
         │
    ┌────▼─────┐
    │ ¿Existe  │ NO
    │ repo?    ├────► git clone
    └────┬─────┘
         │ SI
         │
    ┌────▼─────┐
    │git pull  │
    └────┬─────┘
         │
    ┌────▼─────┐
    │ ¿Éxito?  │ NO ──► Abortar
    └────┬─────┘
         │ SI
         │
    ┌────▼─────┐
    │ Restart  │
    │ Nginx    │
    └────┬─────┘
         │
    ┌────▼─────┐
    │   Log    │
    └──────────┘
```

**Repositorio Configurado:**
```
https://github.com/ArianaCordero/test-webapp.git
```

**Manejo de Errores:**
- Validación de éxito de operaciones Git
- Códigos de salida apropiados
- Mensajes descriptivos de error
- Registro de fallos en log de deploy

---

### Nivel 4: Monitoreo de Recursos (monitor_system.sh)

**Descripción Técnica:**

Sistema de monitoreo en tiempo real de recursos críticos del sistema (CPU, RAM, disco) con generación de alertas basadas en umbrales configurables y almacenamiento de métricas históricas.

**Funcionalidades Implementadas:**

- Medición de uso de CPU mediante `top`
- Cálculo de uso de RAM con `free`
- Verificación de espacio en disco con `df`
- Sistema de umbrales configurables (default: 80%)
- Salida coloreada en terminal (verde=OK, rojo=alerta)
- Generación de logs diarios de métricas
- Registro separado de alertas para análisis
- Conversión de formatos numéricos (coma a punto)

**Uso:**
```bash
./monitor_system.sh
```

**Salida Ejemplo:**
```
Monitoreo del Sistema - 2025-11-11 10:45:30

========================================
[OK] CPU: 15%
[OK] RAM: 59%
[OK] DISCO: 24%
========================================
```

**Métricas Monitoreadas:**

| Recurso | Comando Utilizado | Umbral | Acción en Alerta |
|---------|-------------------|--------|------------------|
| CPU     | `top -bn1`        | 80%    | Log + Color rojo |
| RAM     | `free`            | 80%    | Log + Color rojo |
| DISCO   | `df -h /`         | 80%    | Log + Color rojo |

**Archivos Generados:**
- `metrics_YYYYMMDD.log`: Historial diario de todas las mediciones
- `alerts.log`: Registro exclusivo de alertas generadas

---

## Implementación

### Estructura del Proyecto
```
bash-practice/
├── scripts/
│   ├── check_service.sh       # 983 bytes  - Nivel 1
│   ├── cleanup_logs.sh        # 1.7 KB     - Nivel 2
│   ├── deploy_app.sh          # 1.9 KB     - Nivel 3
│   └── monitor_system.sh      # 2.3 KB     - Nivel 4
├── logs/
│   ├── service_status.log     # Verificaciones de servicios
│   ├── cleanup_actions.log    # Historial de limpiezas
│   ├── deploy.log             # Registro de despliegues
│   ├── alerts.log             # Alertas del sistema
│   └── metrics_YYYYMMDD.log   # Métricas diarias
├── backup/
│   └── logs/                  # Backups comprimidos (tar.gz)
├── webapp/                    # Aplicación desplegada desde Git
├── .gitignore                 # Exclusiones de Git
└── README.md                  # Documentación del proyecto
```

### Requisitos del Sistema

**Sistema Operativo:**
- Ubuntu 20.04 LTS o superior
- Kernel Linux 5.4+

**Herramientas Requeridas:**
```bash
# Verificar instalación
bash --version      # Bash 4.0+
git --version       # Git 2.25+
nginx -v            # Nginx 1.18+
crontab -l          # Cron daemon
```

**Instalación de Dependencias:**
```bash
sudo apt update
sudo apt install -y bash git nginx mailutils cron
```

**Permisos Necesarios:**
- Ejecución de scripts: `chmod +x scripts/*.sh`
- Acceso sudo para reinicio de servicios
- Acceso de escritura en directorios de logs y backup

### Instalación del Proyecto
```bash
# 1. Clonar repositorio
git clone https://github.com/ArianaCordero/bash-scripting-devops
cd bash-scripting-practice

# 2. Asignar permisos de ejecución
chmod +x scripts/*.sh

# 3. Verificar estructura
ls -lh scripts/

# 4. Crear directorios necesarios (si no existen)
mkdir -p logs backup/logs

# 5. Configurar cron para limpieza automática
crontab -e
# Agregar: 0 2 * * * /ruta/completa/scripts/cleanup_logs.sh
```

### Configuración Inicial

**1. Configurar repositorio para deploy:**

Editar `scripts/deploy_app.sh`:
```bash
REPO_URL="https://github.com/TU_USUARIO/TU_REPOSITORIO.git"
```

**2. Configurar umbrales de monitoreo:**

Editar `scripts/monitor_system.sh`:
```bash
CPU_THRESHOLD=80    # Porcentaje de CPU
RAM_THRESHOLD=80    # Porcentaje de RAM
DISK_THRESHOLD=80   # Porcentaje de disco
```

**3. Configurar notificaciones por correo:**

Verificar configuración de mailutils:
```bash
sudo dpkg-reconfigure postfix
# Seleccionar: "Local only"
```

---

## Resultados

### Pruebas Realizadas

#### Test 1: Verificación de Servicios

**Comando:**
```bash
./scripts/check_service.sh nginx
```

**Resultado Obtenido:**
```
[2025-11-11 00:14:04] nginx está ACTIVO
El servicio nginx está funcionando correctamente
```

**Análisis:** El script correctamente identifica el estado del servicio y genera el log con timestamp apropiado.

---

#### Test 2: Limpieza de Logs

**Escenario de Prueba:**
- 7 archivos de log creados
- 2 archivos con antigüedad > 7 días
- 5 archivos recientes

**Comando:**
```bash
./scripts/cleanup_logs.sh
```

**Resultado:**
```
[OK] Archivos comprimidos exitosamente: logs_backup_20251110_234921.tar.gz
[OK] Archivos originales eliminados
```

**Verificación:**
```bash
ls -lh backup/logs/
# -rw-rw-r-- 1 ari ari 170 nov 10 23:49 logs_backup_20251110_234921.tar.gz

tar -tzf backup/logs/logs_backup_*.tar.gz
# old_error.log
# old_app.log
```

**Análisis:** El script identificó correctamente los 2 archivos antiguos, los comprimió y eliminó los originales. Los 5 archivos recientes permanecieron intactos.

---

#### Test 3: Despliegue Automatizado

**Primer Deploy (Clonación):**
```bash
./scripts/deploy_app.sh
```

**Resultado:**
```
[INFO] Descargando codigo desde GitHub...
[OK] Codigo descargado correctamente
[INFO] Reiniciando servicio web...
[OK] Despliegue completado exitosamente
```

**Segundo Deploy (Actualización):**
```bash
# Después de hacer cambios en el repositorio remoto
./scripts/deploy_app.sh
```

**Resultado:**
```
[INFO] Actualizando codigo...
[OK] Codigo actualizado correctamente
[INFO] Reiniciando servicio web...
[OK] Despliegue completado exitosamente
```

**Análisis:** El script detecta automáticamente si es la primera vez (clona) o una actualización (pull). En ambos casos reinicia el servicio correctamente.

---

#### Test 4: Monitoreo del Sistema

**Comando:**
```bash
./scripts/monitor_system.sh
```

**Resultados de 5 ejecuciones consecutivas:**
```
Ejecución 1:
[OK] CPU: 4%
[OK] RAM: 59%
[OK] DISCO: 24%

Ejecución 2:
[OK] CPU: 7%
[OK] RAM: 59%
[OK] DISCO: 24%

Ejecución 3:
[OK] CPU: 0%
[OK] RAM: 59%
[OK] DISCO: 24%

Ejecución 4:
[OK] CPU: 4%
[OK] RAM: 59%
[OK] DISCO: 24%

Ejecución 5:
[OK] CPU: 4%
[OK] RAM: 59%
[OK] DISCO: 24%
```

**Historial de Métricas Generado:**
```bash
cat logs/metrics_20251111.log
```
```
========================================
[2025-11-11 00:17:03] Reporte de Sistema
========================================
CPU: 4%
RAM: 59%
DISK: 24%
```

**Análisis:** El script monitorea correctamente los recursos, genera logs históricos y no generó alertas porque ningún recurso superó el umbral del 80%.

---

### Validación de Integración con Cron

**Configuración Aplicada:**
```bash
crontab -l
# 0 2 * * * /home/ari/bash-practice/scripts/cleanup_logs.sh
```

**Verificación:**
La tarea está programada para ejecutarse diariamente a las 2:00 AM, automatizando completamente la gestión de logs sin intervención manual.

---

### Métricas de Rendimiento

| Script             | Tiempo Ejecución | Uso CPU | Uso RAM |
|--------------------|------------------|---------|---------|
| check_service.sh   | ~0.05s          | <1%     | <5MB    |
| cleanup_logs.sh    | ~0.2s           | <2%     | <10MB   |
| deploy_app.sh      | ~2-5s           | <5%     | <20MB   |
| monitor_system.sh  | ~0.1s           | <1%     | <5MB    |

**Conclusión de Rendimiento:** Todos los scripts tienen un impacto mínimo en los recursos del sistema, siendo aptos para ejecución frecuente sin afectar el rendimiento general.

---

## Conclusiones

### Logros Alcanzados

1. **Automatización Exitosa:** Se logró automatizar cuatro procesos críticos de administración de sistemas, reduciendo significativamente la intervención manual y el riesgo de errores humanos.

2. **Aplicación de Principios DevOps:** Los scripts desarrollados implementan prácticas modernas de DevOps incluyendo integración continua, monitoreo constante y automatización de infraestructura.

3. **Código Mantenible y Documentado:** Cada script incluye comentarios explicativos, manejo de errores robusto y sigue convenciones estándar de programación en Bash.

4. **Sistema de Logging Completo:** Se implementó un sistema integral de logs que permite auditoría, debugging y análisis histórico de todas las operaciones automatizadas.

5. **Escalabilidad:** La arquitectura modular de los scripts permite fácil extensión y adaptación a otros servicios o métricas adicionales.

### Aprendizajes Técnicos

- Dominio de estructuras de control en Bash (condicionales, loops, funciones)
- Integración con herramientas del sistema (systemctl, cron, git)
- Manejo de archivos y directorios en Linux
- Gestión de procesos y servicios
- Técnicas de logging y auditoría
- Control de versiones con Git
- Automatización mediante cron

### Aplicaciones Prácticas

Los scripts desarrollados son directamente aplicables en:
- Entornos de servidores de producción
- Infraestructuras de desarrollo
- Laboratorios de testing
- Ambientes académicos de práctica

---

## Anexos

### Anexo A: Códigos de Salida

| Código | Significado |
|--------|-------------|
| 0      | Ejecución exitosa |
| 1      | Error general |
| 2      | Uso incorrecto del comando |
| 127    | Comando no encontrado |

### Anexo B: Variables de Entorno Utilizadas

- `$USER`: Usuario actual del sistema
- `$HOME`: Directorio home del usuario
- `$PATH`: Rutas de búsqueda de comandos

### Anexo C: Comandos Principales Utilizados

- `systemctl`: Control de servicios systemd
- `find`: Búsqueda de archivos
- `tar`: Compresión de archivos
- `git`: Control de versiones
- `top`: Monitoreo de procesos
- `free`: Información de memoria
- `df`: Espacio en disco

---

**Repositorio del Proyecto:**  
https://github.com/ArianaCordero/practica-bash-scripting-devops

**Repositorio de Pruebas (Deploy):**  
https://github.com/ArianaCordero/test-webapp
---

