# 👑 GUÍA DE ADMINISTRADOR - Base Desarrollo Docker ODOO18

## 🔐 **CONTROL DE ACCESO IMPLEMENTADO**

### ✅ **FUNCIONALIDADES PARA ADMINISTRADORES:**

Como administrador autorizado, tienes **acceso completo** a todas las operaciones Git:

```bash
# ✅ PERMITIDO para administradores
git clone [url]
git pull origin master
git push origin master
git fetch --all
git remote add origin [url]
```

### 🛡️ **USUARIOS ADMINISTRADORES AUTORIZADOS:**

- `mac` (usuario local principal)
- `capirellib` (usuario GitHub)
- `admin` (usuario genérico de administración)
- `root` (superusuario del sistema)

## 🔧 **GESTIÓN DEL SISTEMA DE SEGURIDAD**

### 📋 **Verificar Estado de Seguridad:**

```bash
# Verificación completa del sistema
./check_security_admin.sh
```

### 🔨 **Modificar Usuarios Administradores:**

Para agregar o quitar administradores, edita el archivo:

```bash
nano .git/hooks/admin_check.sh
```

Modifica la línea:

```bash
ADMIN_USERS=("mac" "capirellib" "admin" "root" "nuevo_admin")
```

### 🚀 **Reconfigurar Remote (Solo Administradores):**

```bash
# Agregar remote para sincronización
git remote add origin https://github.com/capirellib/ODOO18_Desarrollo_base.git

# Verificar configuración
git remote -v

# Sincronizar cambios
git push origin master
```

## ⚠️ **RESPONSABILIDADES DEL ADMINISTRADOR**

### 🔒 **Mantener Seguridad:**

1. **No compartir** credenciales de administrador
2. **Verificar** regularmente el estado de seguridad
3. **Documentar** cambios importantes
4. **Actualizar** lista de administradores según necesidad

### 📦 **Distribución ZIP:**

Después de cambios importantes, regenerar el ZIP de distribución:

```bash
cd ..
rm -f base_desarrollo_docker_ODOO18.zip
zip -r "base_desarrollo_docker_ODOO18.zip" "ODOO18_Desarrollo" -x "*.git*" "*/logs/*" "*/filestore/*" "*/postgresql_data/*" "*/__pycache__/*" "*.pyc" "*.log"
```

## 🎯 **VERIFICACIÓN DE PERMISOS**

### Para verificar si un usuario es administrador:

```bash
# Verificar usuario actual
whoami

# Ejecutar verificación
./check_security_admin.sh
```

**Resultado esperado para administradores:**

```
👑 PERMISOS: ADMINISTRADOR (Git permitido)
```

**Resultado para usuarios estándar:**

```
👤 PERMISOS: USUARIO ESTÁNDAR (solo ZIP)
```

## 🆘 **RESOLUCIÓN DE PROBLEMAS**

### Si los hooks no funcionan correctamente:

```bash
# Restaurar permisos
chmod +x .git/hooks/*
chmod +x check_security_admin.sh

# Verificar configuración
./check_security_admin.sh
```

### En caso de emergencia (deshabilitar seguridad temporalmente):

```bash
# SOLO EN EMERGENCIA - Renombrar hooks temporalmente
mv .git/hooks/pre-receive .git/hooks/pre-receive.disabled
mv .git/hooks/update .git/hooks/update.disabled
mv .git/hooks/post-receive .git/hooks/post-receive.disabled
```

**⚠️ RECUERDA REACTIVAR DESPUÉS:**

```bash
# Restaurar hooks
mv .git/hooks/pre-receive.disabled .git/hooks/pre-receive
mv .git/hooks/update.disabled .git/hooks/update
mv .git/hooks/post-receive.disabled .git/hooks/post-receive
```
