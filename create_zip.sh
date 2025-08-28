#!/bin/bash

# ==============================================
# SCRIPT PARA CREAR ZIP DE DISTRIBUCIÓN
# Base Desarrollo Docker ODOO18
# ==============================================

echo "🗜️  Creando archivo ZIP de distribución..."

# Nombre del archivo ZIP
ZIP_NAME="base_desarrollo_docker_ODOO18_v1.0.zip"

# Crear directorio temporal con el nombre del proyecto
TEMP_DIR="base_desarrollo_docker_ODOO18"
mkdir -p "../${TEMP_DIR}"

# Copiar archivos (excluyendo .git)
rsync -av --exclude='.git' --exclude='*.zip' --exclude='logs/*' --exclude='filestore/*' --exclude='.DS_Store' . "../${TEMP_DIR}/"

# Crear ZIP
cd ..
zip -r "${ZIP_NAME}" "${TEMP_DIR}"

# Limpiar directorio temporal
rm -rf "${TEMP_DIR}"

echo "✅ ZIP creado: ${ZIP_NAME}"
echo "📦 Tamaño: $(ls -lh ${ZIP_NAME} | awk '{print $5}')"
echo ""
echo "🎯 Para usar el proyecto:"
echo "   1. Extraer el ZIP"
echo "   2. cd base_desarrollo_docker_ODOO18"
echo "   3. chmod +x install.sh && ./install.sh"
