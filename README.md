# Base Desarrollo Docker ODOO18

Este proyecto proporciona un entorno de desarrollo completo para Odoo 18 usando Docker y Docker Compose.

## 🏗️ Estado del Proyecto

**✅ ESTRUCTURA BASE CONFIGURADA**

El proyecto está listo para ser utilizado. Solo necesitas ejecutar la instalación para comenzar a desarrollar.

## 📦 Instalación

1. **Descargar el proyecto como ZIP**
2. **Extraer en tu directorio de desarrollo**
3. **Ejecutar instalación automática:**

```bash
cd base_desarrollo_docker_ODOO18
chmod +x install.sh
./install.sh
```

## 🚀 Características

- **Odoo 18**: Última versión estable
- **PostgreSQL 15**: Base de datos optimizada para desarrollo
- **Debugging**: Soporte completo para debugging con debugpy
- **Hot Reload**: Cambios en tiempo real durante el desarrollo
- **Adminer**: Interfaz web para gestión de base de datos
- **VS Code**: Configuración completa para desarrollo
- **Scripts de utilidades**: Comandos simplificados para desarrollo

## 📋 Requisitos Previos

- Docker Desktop
- Docker Compose
- Git

## 🛠️ Instalación Rápida

### Instalación automática

Ejecuta el script de instalación para configurar todo automáticamente:

```bash
chmod +x install.sh
./install.sh
```

El script hará:

- ✅ Verificar Docker
- ⬇️ Descargar código fuente de Odoo 18
- 🏗️ Construir contenedores Docker
- 🚀 Iniciar servicios
- 🎯 Configurar debugging

### Instalación manual (opcional)

Si prefieres configurar paso a paso:

```bash
# 1. Configurar variables de entorno (opcional)
cp .env.example .env
# Edita .env si necesitas cambiar puertos o configuraciones

# 2. Construir e iniciar servicios
docker-compose up -d --build
```

./odoo-dev.sh build

````

## 🎯 Uso del Sistema

### Comandos Principales

El script `odoo-dev.sh` proporciona comandos simplificados:

```bash
# Iniciar servicios
./odoo-dev.sh up

# Iniciar en modo debug
./odoo-dev.sh debug

# Detener servicios
./odoo-dev.sh down

# Ver logs
./odoo-dev.sh logs

# Acceder al shell de Odoo
./odoo-dev.sh shell

# Ver todos los comandos disponibles
./odoo-dev.sh
````

### Desarrollo de Módulos

#### Crear un nuevo módulo

```bash
./odoo-dev.sh scaffold mi_modulo
```

#### Instalar un módulo

```bash
./odoo-dev.sh install mi_modulo
```

#### Actualizar un módulo

```bash
./odoo-dev.sh update mi_modulo
```

#### Ejecutar tests

```bash
./odoo-dev.sh test mi_modulo
```

### Código Fuente Local

El script de instalación clona automáticamente Odoo 18 en `./odoo18-source/` para:

- **Consultar código fuente**: Explorar la implementación de Odoo
- **Debugging avanzado**: Navegar por el código durante el debug
- **Desarrollo de referencia**: Estudiar patrones y estructuras

#### Actualizar código fuente

```bash
./odoo-dev.sh update-source
```

## 🐛 Debugging

### Configuración en VS Code

1. Instalar la extensión "Python"
2. Crear configuración de debug en `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Odoo 18 Debug",
      "type": "python",
      "request": "attach",
      "host": "localhost",
      "port": 8888,
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}/extra-addons",
          "remoteRoot": "/var/lib/odoo/custom_addons"
        }
      ]
    }
  ]
}
```

3. Iniciar servicios en modo debug:

```bash
./odoo-dev.sh debug
```

4. Conectar el debugger desde VS Code

## 📊 Gestión de Base de Datos

### Adminer (Interfaz Web)

- URL: http://localhost:8080
- Sistema: PostgreSQL
- Servidor: db
- Usuario: odoo
- Contraseña: odoo

### Backup y Restore

```bash
# Crear backup
./odoo-dev.sh backup nombre_db

# Restaurar backup
./odoo-dev.sh restore backup_file.sql nombre_db
```

## 📁 Estructura del Proyecto

```
ODOO18_Desarrollo/
├── conf/
│   └── odoo.conf              # Configuración de Odoo
├── extra-addons/              # Módulos personalizados
├── logs/                      # Logs de Odoo
├── filestore/                 # Archivos de Odoo
├── backups/                   # Backups de base de datos
├── docker-compose.yml         # Configuración Docker normal
├── docker-compose.debug.yml   # Configuración Docker debug
├── Dockerfile-odoo18          # Dockerfile para Odoo 18
├── postgresql.conf            # Configuración PostgreSQL
├── odoo-dev.sh               # Script de utilidades
├── .env                      # Variables de entorno
└── README.md                 # Este archivo
```

## 🔧 Configuración Avanzada

### Variables de Entorno (.env)

```bash
# Base de datos
DB_NAME=odoo18_dev
PG_USER=odoo
PG_PASSWORD=odoo
PG_PORT=5432

# Odoo
ODOO_VERSION=18.0
ODOO_PORT=8069
DEBUGPY_PORT=8888

# Contenedores
ODOO_CONTAINER_NAME=odoo18-web
PG_CONTAINER_NAME=postgres18
```

### Configuración de Odoo (conf/odoo.conf)

Las principales configuraciones están optimizadas para desarrollo:

- Modo desarrollo activado
- Logs detallados
- Auto-reload habilitado
- Sin workers (ideal para debugging)

## 🚨 Solución de Problemas

### Puerto ya en uso

```bash
# Verificar puertos en uso
lsof -i :8069
lsof -i :5432

# Cambiar puertos en .env si es necesario
```

### Problemas de permisos

```bash
# Limpiar volúmenes y reiniciar
./odoo-dev.sh clean
./odoo-dev.sh build
./odoo-dev.sh up
```

### Logs de debugging

```bash
# Ver logs de Odoo
./odoo-dev.sh logs

# Ver logs de PostgreSQL
./odoo-dev.sh db-logs
```

## 📚 Recursos Adicionales

- [Documentación Oficial Odoo 18](https://www.odoo.com/documentation/18.0/)
- [Guías de Desarrollo](https://www.odoo.com/documentation/18.0/developer.html)
- [API Reference](https://www.odoo.com/documentation/18.0/reference.html)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la licencia MIT. 7. Configurar el debug en vscode
