#!/bin/bash

# Script de utilidades para Odoo 18 Development Environment
# Uso: ./odoo-dev.sh [comando] [opciones]

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar ayuda
show_help() {
    echo -e "${BLUE}Odoo 18 Development Environment - Comandos disponibles:${NC}"
    echo ""
    echo -e "${GREEN}build${NC}        - Construir contenedores Docker"
    echo -e "${GREEN}up${NC}           - Iniciar servicios (modo normal)"
    echo -e "${GREEN}debug${NC}        - Iniciar servicios (modo debug)"
    echo -e "${GREEN}down${NC}         - Detener servicios"
    echo -e "${GREEN}restart${NC}      - Reiniciar servicios"
    echo -e "${GREEN}logs${NC}         - Mostrar logs de Odoo"
    echo -e "${GREEN}db-logs${NC}      - Mostrar logs de PostgreSQL"
    echo -e "${GREEN}shell${NC}        - Acceder al shell de Odoo"
    echo -e "${GREEN}db-shell${NC}     - Acceder al shell de PostgreSQL"
    echo -e "${GREEN}backup${NC}       - Respaldar base de datos"
    echo -e "${GREEN}restore${NC}      - Restaurar base de datos"
    echo -e "${GREEN}update${NC}       - Actualizar módulo específico"
    echo -e "${GREEN}install${NC}      - Instalar módulo específico"
    echo -e "${GREEN}scaffold${NC}     - Crear nuevo módulo"
    echo -e "${GREEN}test${NC}         - Ejecutar tests"
    echo -e "${GREEN}clean${NC}        - Limpiar volúmenes Docker"
    echo -e "${GREEN}status${NC}       - Mostrar estado de servicios"
    echo -e "${GREEN}update-source${NC} - Actualizar código fuente local de Odoo"
    echo ""
}

# Cargar variables de entorno
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | xargs)
fi

case $1 in
    "build")
        echo -e "${YELLOW}Construyendo contenedores Docker...${NC}"
        docker-compose build --no-cache
        ;;
    "up")
        echo -e "${YELLOW}Iniciando servicios Odoo 18...${NC}"
        docker-compose up -d
        echo -e "${GREEN}Servicios iniciados. Odoo disponible en: http://localhost:${ODOO_PORT}${NC}"
        ;;
    "debug")
        echo -e "${YELLOW}Iniciando servicios en modo debug...${NC}"
        docker-compose -f docker-compose.debug.yml up -d
        echo -e "${GREEN}Servicios iniciados en modo debug.${NC}"
        echo -e "${GREEN}Odoo disponible en: http://localhost:${ODOO_PORT}${NC}"
        echo -e "${GREEN}Debug port: ${DEBUGPY_PORT}${NC}"
        ;;
    "down")
        echo -e "${YELLOW}Deteniendo servicios...${NC}"
        docker-compose down
        docker-compose -f docker-compose.debug.yml down 2>/dev/null || true
        ;;
    "restart")
        echo -e "${YELLOW}Reiniciando servicios...${NC}"
        docker-compose restart
        ;;
    "logs")
        docker-compose logs -f web
        ;;
    "db-logs")
        docker-compose logs -f db
        ;;
    "shell")
        echo -e "${YELLOW}Accediendo al shell de Odoo...${NC}"
        docker exec -it ${ODOO_CONTAINER_NAME} /bin/bash
        ;;
    "db-shell")
        echo -e "${YELLOW}Accediendo al shell de PostgreSQL...${NC}"
        docker exec -it ${PG_CONTAINER_NAME} psql -U ${PG_USER} -d postgres
        ;;
    "backup")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Especifica el nombre de la base de datos${NC}"
            echo "Uso: ./odoo-dev.sh backup <database_name>"
            exit 1
        fi
        echo -e "${YELLOW}Respaldando base de datos $2...${NC}"
        docker exec -t ${PG_CONTAINER_NAME} pg_dump -U ${PG_USER} $2 > "backups/$2_$(date +%Y%m%d_%H%M%S).sql"
        echo -e "${GREEN}Backup creado en backups/${NC}"
        ;;
    "restore")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo -e "${RED}Error: Especifica el archivo de backup y el nombre de la base de datos${NC}"
            echo "Uso: ./odoo-dev.sh restore <backup_file> <database_name>"
            exit 1
        fi
        echo -e "${YELLOW}Restaurando base de datos...${NC}"
        cat $2 | docker exec -i ${PG_CONTAINER_NAME} psql -U ${PG_USER} -d $3
        ;;
    "update")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Especifica el nombre del módulo${NC}"
            echo "Uso: ./odoo-dev.sh update <module_name>"
            exit 1
        fi
        echo -e "${YELLOW}Actualizando módulo $2...${NC}"
        docker exec -it ${ODOO_CONTAINER_NAME} python3 odoo-bin -c /etc/odoo/odoo.conf -u $2 --stop-after-init
        ;;
    "install")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Especifica el nombre del módulo${NC}"
            echo "Uso: ./odoo-dev.sh install <module_name>"
            exit 1
        fi
        echo -e "${YELLOW}Instalando módulo $2...${NC}"
        docker exec -it ${ODOO_CONTAINER_NAME} python3 odoo-bin -c /etc/odoo/odoo.conf -i $2 --stop-after-init
        ;;
    "scaffold")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Especifica el nombre del módulo${NC}"
            echo "Uso: ./odoo-dev.sh scaffold <module_name>"
            exit 1
        fi
        echo -e "${YELLOW}Creando módulo $2...${NC}"
        docker exec -it ${ODOO_CONTAINER_NAME} python3 odoo-bin scaffold $2 /var/lib/odoo/custom_addons/
        ;;
    "test")
        if [ -z "$2" ]; then
            echo -e "${RED}Error: Especifica el nombre del módulo${NC}"
            echo "Uso: ./odoo-dev.sh test <module_name>"
            exit 1
        fi
        echo -e "${YELLOW}Ejecutando tests para módulo $2...${NC}"
        docker exec -it ${ODOO_CONTAINER_NAME} python3 odoo-bin -c /etc/odoo/odoo.conf --test-enable --test-tags $2 --stop-after-init
        ;;
    "clean")
        echo -e "${YELLOW}Limpiando volúmenes Docker...${NC}"
        docker-compose down -v
        docker system prune -f
        ;;
    "status")
        echo -e "${YELLOW}Estado de servicios:${NC}"
        docker-compose ps
        ;;
    "update-source")
        echo -e "${YELLOW}Actualizando código fuente local de Odoo...${NC}"
        if [ -d "odoo18-source" ]; then
            cd odoo18-source
            git pull origin 18.0
            cd ..
            echo -e "${GREEN}✓ Código fuente actualizado${NC}"
        else
            echo -e "${YELLOW}Clonando código fuente de Odoo 18...${NC}"
            git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git odoo18-source
            echo -e "${GREEN}✓ Código fuente clonado en ./odoo18-source${NC}"
        fi
        ;;
    *)
        show_help
        ;;
esac
