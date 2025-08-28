#!/bin/bash

# Script de instalación rápida para Odoo 18 Development Environment
# Este script configura e inicia el entorno completo

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Odoo 18 Development Environment      ${NC}"
echo -e "${BLUE}  Instalación y Configuración Rápida   ${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker no está instalado. Por favor, instala Docker Desktop primero.${NC}"
    echo "Descarga desde: https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Verificar si Docker Compose está disponible
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose no está disponible.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Docker está instalado y funcionando${NC}"

# Verificar si los servicios están corriendo
if docker ps | grep -q "odoo18-web\|postgres18"; then
    echo -e "${YELLOW}⚠️  Servicios Odoo ya están corriendo. Deteniéndolos...${NC}"
    ./odoo-dev.sh down
fi

echo ""
echo -e "${YELLOW}📦 Paso 1: Clonando Odoo 18 localmente...${NC}"
if [ ! -d "odoo18-source" ]; then
    echo "Descargando código fuente de Odoo 18..."
    git clone --depth 1 --branch 18.0 https://github.com/odoo/odoo.git odoo18-source
    echo -e "${GREEN}✓ Odoo 18 clonado en ./odoo18-source${NC}"
else
    echo -e "${GREEN}✓ Odoo 18 ya existe en ./odoo18-source${NC}"
fi

echo ""
echo -e "${YELLOW}📦 Paso 2: Construyendo contenedores Docker...${NC}"
./odoo-dev.sh build

echo ""
echo -e "${YELLOW}🚀 Paso 3: Iniciando servicios...${NC}"
./odoo-dev.sh up

echo ""
echo -e "${YELLOW}⏳ Esperando a que Odoo esté listo...${NC}"
echo "Esto puede tomar unos minutos la primera vez..."

# Esperar a que Odoo esté disponible
for i in {1..60}; do
    if curl -f http://localhost:8069 >/dev/null 2>&1; then
        break
    fi
    echo -n "."
    sleep 5
done

echo ""
echo ""
echo -e "${GREEN}🎉 ¡Instalación completada exitosamente!${NC}"
echo ""
echo -e "${BLUE}📋 Información del sistema:${NC}"
echo -e "  • Odoo 18:        ${GREEN}http://localhost:8069${NC}"
echo -e "  • Adminer:        ${GREEN}http://localhost:8080${NC}"
echo -e "  • PostgreSQL:     ${GREEN}localhost:5432${NC}"
echo -e "  • Código fuente:  ${GREEN}./odoo18-source/${NC}"
echo ""
echo -e "${BLUE}👤 Credenciales por defecto:${NC}"
echo -e "  • Admin Odoo:     ${YELLOW}admin / admin${NC}"
echo -e "  • DB Usuario:     ${YELLOW}odoo / odoo${NC}"
echo ""
echo -e "${BLUE}🛠️  Comandos útiles:${NC}"
echo -e "  • Ver logs:         ${YELLOW}./odoo-dev.sh logs${NC}"
echo -e "  • Parar servicios:  ${YELLOW}./odoo-dev.sh down${NC}"
echo -e "  • Modo debug:       ${YELLOW}./odoo-dev.sh debug${NC}"
echo -e "  • Crear módulo:     ${YELLOW}./odoo-dev.sh scaffold nombre_modulo${NC}"
echo -e "  • Instalar módulo:  ${YELLOW}./odoo-dev.sh install nombre_modulo${NC}"
echo ""
echo -e "${GREEN}📖 Lee el README.md para más información detallada.${NC}"
echo ""
echo -e "${BLUE}🎯 Próximos pasos:${NC}"
echo "1. Abre VS Code en este directorio"
echo "2. Instala las extensiones recomendadas"
echo "3. Crea tu primera base de datos en Odoo"
echo "4. Instala el módulo demo_module para probar"
echo "5. Explora el código fuente en ./odoo18-source/"
echo ""
echo -e "${GREEN}¡Feliz desarrollo con Odoo 18! 🚀${NC}"
