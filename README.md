# Guía de Ejecución del Proyecto Bonita con Docker Compose

Este proyecto configura un entorno completo de Bonita BPM utilizando Docker Compose, incluyendo PostgreSQL, Bonita Engine, UI Builder y un proxy Nginx.

## Prerrequisitos

- Docker instalado en tu sistema.
- Docker Compose instalado.
- Al menos 4 GB de RAM disponible para los contenedores.
- Archivo de licencia de Bonita en `bonita-license/license.lic`.

## Estructura del Proyecto

- `docker-compose.yml`: Configuración de los servicios Docker.
- `create-databases.sql`: Script SQL para crear usuarios y bases de datos en PostgreSQL.
- `db_scripts/`: Scripts de inicialización para PostgreSQL.
- `bonita-license/`: Directorio con la licencia de Bonita.

## Ejecutar con Docker Compose

1. Asegúrate de estar en el directorio raíz del proyecto.

2. Ejecuta el siguiente comando para iniciar todos los servicios:

   ```bash
   docker-compose up -d
   ```

   Este comando iniciará los siguientes servicios:
   - PostgreSQL (puerto 5432)
   - Bonita Engine (puerto 8080)
   - Bonita UI Builder (puerto 8081)
   - Bonita UI Proxy (puerto 80)

3. Los servicios pueden tardar varios minutos en iniciarse completamente, especialmente Bonita Engine (hasta 5 minutos).

4. Verifica que los contenedores estén ejecutándose:

   ```bash
   docker-compose ps
   ```

## Acceder a la Aplicación

- **Bonita Portal**: http://localhost (puerto 80, a través del proxy)
- **Bonita Engine API**: http://localhost:8080/bonita
- **UI Builder**: http://localhost:8081
- **PostgreSQL**: localhost:5432 (usuario: postgres, contraseña: testpassword)

Credenciales de Bonita:
- Usuario administrador: admin
- Contraseña: myAdminSecret
- Usuario de monitoreo: monitoring
- Contraseña: myMonitoringSecret

## Detener los Servicios

Para detener todos los servicios:

```bash
docker-compose down
```

Para detener y eliminar volúmenes (datos persistentes):

```bash
docker-compose down -v
```

## Logs

Para ver los logs de un servicio específico:

```bash
docker-compose logs [nombre-del-servicio]
```

Por ejemplo:

```bash
docker-compose logs bonita-engine
```

## Ejecutar Manualmente el Script `create-databases.sql`

Si deseas ejecutar el script SQL manualmente (por ejemplo, en una instancia de PostgreSQL externa o para depuración), sigue estos pasos:

### Opción 1: Usando psql en el contenedor de PostgreSQL

1. Asegúrate de que el contenedor de PostgreSQL esté ejecutándose:

   ```bash
   docker-compose up -d postgres
   ```

2. Ejecuta el script dentro del contenedor:

   ```bash
   docker-compose exec postgres psql -U postgres -f /docker-entrypoint-initdb.d/create-databases.sql
   ```
3. Reinicie el contenedor: 
   ```bash
   docker restart bonita-engine
   ```

### Opción 2: Usando psql localmente (si PostgreSQL está instalado localmente)

1. Asegúrate de que PostgreSQL esté ejecutándose localmente en el puerto 5432.

2. Ejecuta el script:

   ```bash
   psql -U postgres -h localhost -f create-databases.sql
   ```

   Se te pedirá la contraseña (testpassword por defecto).

### Opción 3: Usando Docker para ejecutar psql

Si tienes Docker instalado pero no PostgreSQL localmente:

```bash
docker run --rm -v $(pwd)/create-databases.sql:/create-databases.sql --network bonita-network postgres:16.4 psql -h postgres-db -U postgres -f /create-databases.sql
```

Nota: El script crea los usuarios `bonitauser` y `bizuser`, y las bases de datos `bonita` y `bizdata`.

## Solución de Problemas

- **Puerto ocupado**: Si los puertos 80, 8080, 8081 o 5432 están ocupados, modifica el archivo `docker-compose.yml` para cambiar los puertos mapeados.

- **Licencia de Bonita**: Asegúrate de que el archivo `bonita-license/license.lic` esté presente y sea válido.

- **Memoria insuficiente**: Si encuentras errores de memoria, aumenta la RAM asignada a los contenedores en el archivo `docker-compose.yml`.

- **Healthchecks fallando**: Los healthchecks pueden fallar inicialmente. Espera a que los servicios se inicien completamente.

Para más información, consulta la documentación oficial de Bonita: https://documentation.bonitasoft.com/</content>
<parameter name="filePath">c:\Users\GERARDO\Documents\pruebaTrycore\07012025_casoUso\README.md