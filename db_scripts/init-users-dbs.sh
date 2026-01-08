#!/bin/bash
set -e

# Create users and databases, handling cases where they might already exist
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	-- Create bonitauser if it doesn't exist, otherwise update password
	DO \$\$
	BEGIN
		IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'bonitauser') THEN
			CREATE USER bonitauser WITH PASSWORD 'myDbSecret';
		ELSE
			ALTER USER bonitauser WITH PASSWORD 'myDbSecret';
		END IF;
	END
	\$\$;
	
	-- Create bonita database if it doesn't exist
	SELECT 'CREATE DATABASE bonita OWNER "bonitauser"'
	WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'bonita')\gexec
	
	-- Ensure ownership
	ALTER DATABASE bonita OWNER TO "bonitauser";
	GRANT ALL PRIVILEGES ON DATABASE bonita TO bonitauser;
	
	-- Create bizuser if it doesn't exist, otherwise update password
	DO \$\$
	BEGIN
		IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'bizuser') THEN
			CREATE USER bizuser WITH PASSWORD 'myBdmSecret';
		ELSE
			ALTER USER bizuser WITH PASSWORD 'myBdmSecret';
		END IF;
	END
	\$\$;
	
	-- Create bizdata database if it doesn't exist
	SELECT 'CREATE DATABASE bizdata OWNER "bizuser"'
	WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'bizdata')\gexec
	
	-- Ensure ownership
	ALTER DATABASE bizdata OWNER TO "bizuser";
	GRANT ALL PRIVILEGES ON DATABASE bizdata TO bizuser;
EOSQL