#!/bin/bash

set -e

PREFIX=${PREFIX:-dump}
PGUSER=${PGUSER:-postgres}
PGDB=${PGDB:-postgres}
PGHOST=${PGHOST:-db}
PGPORT=${PGPORT:-5432}

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/dump/$PREFIX-$DATE.sql"

echo "Job started: $(date). Dumping to ${FILE}"

pg_dump -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -f "$FILE" -d "$PGDB" 
gzip "$FILE"

if [[ ! -z "${DELETE_OLDER_THAN}" ]]; then
	echo "Deleting old backups: ${DELETE_OLDER_THAN}"
	find /dump/* -mmin "+${DELETE_OLDER_THAN}" -exec rm {} \;
fi

echo "Job finished: $(date)"
