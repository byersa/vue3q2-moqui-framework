#!/bin/bash
export default_time_zone=America/Denver
export database_time_zone=America/Denver

# Load environment configuration if available
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Reflection flags are required for internal module access
java --add-opens java.base/java.lang=ALL-UNNAMED \
 --add-opens java.base/java.util=ALL-UNNAMED \
 --add-opens java.base/java.time=ALL-UNNAMED \
 --add-opens java.base/java.nio=ALL-UNNAMED \
 -server \
 -Dentity_ds_host="${ENTITY_DS_HOST:-localhost}" \
 -Dentity_ds_port="${ENTITY_DS_PORT:-5434}" \
 -Dentity_ds_database="${ENTITY_DS_DATABASE:-nursinghome}" \
 -Dentity_ds_user="${ENTITY_DS_USER:-ofbiz}" \
 -Dentity_ds_password="${ENTITY_DS_PASSWORD:-heber}" \
 -Dmoqui.conf="conf/MoquiDevConf.xml" \
 -Dmoqui.runtime="runtime" \
 -Xmx4096m \
 -Duser.timezone="America/Denver" \
 -Ddefault_time_zone="America/Denver" \
 -Dmoqui.logger.level.xml_action="info" \
 -jar moqui.war
