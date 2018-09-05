#! /bin/sh
set -e


# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

export PGPASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST_OPTS="-h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER"

echo "Creating dump of ${POSTGRES_DATABASE} database from ${POSTGRES_HOST}..."

pg_dump $POSTGRES_HOST_OPTS $POSTGRES_DATABASE | gzip > dump.sql.gz

echo "Uploading dumps to $S3_BUCKET"

cat dump.sql.gz | aws s3 cp - s3://$S3_BUCKET/$S3_PREFIX/latest.sql.gz || exit 2
cat dump.sql.gz | aws s3 cp - s3://$S3_BUCKET/$S3_PREFIX/$(date +"%Y-%m-%dT%H:%M:%SZ").sql.gz || exit 2

echo "SQL backup uploaded successfully"