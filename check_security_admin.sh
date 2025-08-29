#!/bin/bash

# ===============================================
# VERIFICADOR DE SEGURIDAD REPOSITORIO
# Base Desarrollo Docker ODOO18 - Modo Administrador
# ===============================================

echo "🔍 VERIFICANDO SEGURIDAD DEL REPOSITORIO..."
echo "============================================="

# Variables de conteo
security_count=0
total_checks=6

# 1. Verificar hooks de seguridad
echo ""
echo "🛡️ Hooks de seguridad:"

hooks=("pre-receive" "update" "post-receive")
for hook in "${hooks[@]}"; do
    if [[ -f ".git/hooks/$hook" ]] && [[ -x ".git/hooks/$hook" ]]; then
        echo "   ✅ $hook: ACTIVO (modo selectivo)"
        ((security_count++))
    else
        echo "   ❌ $hook: INACTIVO"
    fi
done

# 2. Verificar configuración bloqueada
echo ""
echo "🔒 Configuración de acceso:"

if [[ -f ".git/config.blocked" ]]; then
    echo "   ✅ config.blocked: PRESENTE"
    ((security_count++))
else
    echo "   ❌ config.blocked: AUSENTE"
fi

# 3. Verificar remotes
remote_count=$(git remote | wc -l | tr -d ' ')
echo "   🔗 Remotes configurados:        $remote_count"

if [[ $remote_count -eq 0 ]]; then
    echo "   ✅ Sin remotes (MODO LOCAL)"
    ((security_count++))
else
    echo "   ⚠️ Con remotes (ADMINISTRADOR)"
fi

# 4. Verificar documentación
echo ""
echo "📖 Documentación de seguridad:"

if grep -q "REPOSITORIO PROTEGIDO\|CLONACIÓN.*DESHABILITADA\|ACCESO.*BLOQUEADO" README.md 2>/dev/null; then
    echo "   ✅ README.md: CONTIENE AVISO"
    ((security_count++))
else
    echo "   ❌ README.md: SIN AVISO"
fi

if [[ -f "GIT_NOTICE.md" ]]; then
    echo "   ✅ GIT_NOTICE.md: PRESENTE"
else
    echo "   ❌ GIT_NOTICE.md: AUSENTE"
fi

# 5. Verificar script de administrador
if [[ -f ".git/hooks/admin_check.sh" ]] && [[ -x ".git/hooks/admin_check.sh" ]]; then
    echo "   ✅ admin_check.sh: CONFIGURADO"
    ((security_count++))
else
    echo "   ❌ admin_check.sh: NO CONFIGURADO"
fi

# Resultado final
echo ""
echo "🎯 ESTADO GENERAL:"

current_user=$(whoami)
echo "   👤 Usuario actual: $current_user"

if [[ $security_count -ge 5 ]]; then
    echo "   ✅ REPOSITORIO SEGURO ($security_count/$total_checks medidas activas)"
    echo "   🔒 Acceso Git solo para administradores"
    echo "   📦 Usuarios estándar: solo descarga ZIP"
    
    # Verificar si el usuario actual es administrador
    if [[ "$current_user" == "mac" ]] || [[ "$current_user" == "capirellib" ]] || [[ "$current_user" == "admin" ]] || [[ "$current_user" == "root" ]]; then
        echo "   👑 PERMISOS: ADMINISTRADOR (Git permitido)"
    else
        echo "   👤 PERMISOS: USUARIO ESTÁNDAR (solo ZIP)"
    fi
else
    echo "   ⚠️ SEGURIDAD INSUFICIENTE ($security_count/$total_checks medidas activas)"
    echo "   🔧 Se requieren configuraciones adicionales"
fi
