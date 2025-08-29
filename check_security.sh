#!/bin/bash

# ===============================================
# VERIFICADOR DE SEGURIDAD REPOSITORIO
# Base Desarrollo Docker ODOO18
# ===============================================

echo "🔍 VERIFICANDO SEGURIDAD DEL REPOSITORIO..."
echo "============================================="
echo ""

# Verificar hooks de bloqueo
echo "🛡️ Hooks de seguridad:"
HOOKS_DIR=".git/hooks"
if [ -f "$HOOKS_DIR/pre-receive" ] && [ -x "$HOOKS_DIR/pre-receive" ]; then
    echo "   ✅ pre-receive: ACTIVO"
else
    echo "   ❌ pre-receive: INACTIVO"
fi

if [ -f "$HOOKS_DIR/update" ] && [ -x "$HOOKS_DIR/update" ]; then
    echo "   ✅ update: ACTIVO"
else
    echo "   ❌ update: INACTIVO"
fi

if [ -f "$HOOKS_DIR/post-receive" ] && [ -x "$HOOKS_DIR/post-receive" ]; then
    echo "   ✅ post-receive: ACTIVO"
else
    echo "   ❌ post-receive: INACTIVO"
fi

echo ""

# Verificar configuración de bloqueo
echo "🔒 Configuración de acceso:"
if [ -f ".git/config.blocked" ]; then
    echo "   ✅ config.blocked: PRESENTE"
else
    echo "   ❌ config.blocked: AUSENTE"
fi

# Verificar remotes
REMOTES=$(git remote -v | wc -l)
echo "   🔗 Remotes configurados: $REMOTES"
if [ "$REMOTES" -eq 0 ]; then
    echo "   ✅ Sin remotes (SEGURO)"
else
    echo "   ⚠️  Con remotes (REVISAR)"
fi

echo ""

# Verificar archivos de documentación
echo "📖 Documentación de bloqueo:"
if [ -f "README.md" ]; then
    if grep -q "REPOSITORIO PROTEGIDO" README.md; then
        echo "   ✅ README.md: CONTIENE AVISO"
    else
        echo "   ⚠️  README.md: SIN AVISO"
    fi
else
    echo "   ❌ README.md: AUSENTE"
fi

if [ -f "GIT_NOTICE.md" ]; then
    echo "   ✅ GIT_NOTICE.md: PRESENTE"
else
    echo "   ❌ GIT_NOTICE.md: AUSENTE"
fi

echo ""
echo "🎯 ESTADO GENERAL:"

# Contar medidas activas
SECURITY_COUNT=0
[ -f "$HOOKS_DIR/pre-receive" ] && [ -x "$HOOKS_DIR/pre-receive" ] && ((SECURITY_COUNT++))
[ -f "$HOOKS_DIR/update" ] && [ -x "$HOOKS_DIR/update" ] && ((SECURITY_COUNT++))
[ -f "$HOOKS_DIR/post-receive" ] && [ -x "$HOOKS_DIR/post-receive" ] && ((SECURITY_COUNT++))
[ -f ".git/config.blocked" ] && ((SECURITY_COUNT++))
[ "$REMOTES" -eq 0 ] && ((SECURITY_COUNT++))

if [ "$SECURITY_COUNT" -ge 4 ]; then
    echo "   ✅ REPOSITORIO SEGURO ($SECURITY_COUNT/5 medidas activas)"
    echo "   🔒 Clonación Git BLOQUEADA"
    echo "   📦 Solo descarga ZIP disponible"
else
    echo "   ⚠️  SEGURIDAD INCOMPLETA ($SECURITY_COUNT/5 medidas activas)"
    echo "   🔧 Ejecuta este script para ver qué falta"
fi

echo ""
