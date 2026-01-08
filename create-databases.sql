-- Crear usuarios si no existen
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'bonitauser') THEN
        CREATE USER bonitauser WITH PASSWORD 'myDbSecret';
    END IF;
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'bizuser') THEN
        CREATE USER bizuser WITH PASSWORD 'myBdmSecret';
    END IF;
END
$$;

-- Crear bases de datos para Bonita
CREATE DATABASE bonita OWNER bonitauser;
CREATE DATABASE bizdata OWNER bizuser;

-- Otorgar privilegios
GRANT ALL PRIVILEGES ON DATABASE bonita TO bonitauser;
GRANT ALL PRIVILEGES ON DATABASE bizdata TO bizuser;
