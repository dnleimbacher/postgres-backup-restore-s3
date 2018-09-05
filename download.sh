#! /bin/sh
set -e


# name of the backup file requested for restore
backup_name=${2-latest}

# env vars needed for aws tools
export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION

echo "Downloading dump $backup_name.sql.gz from $S3_BUCKET"

aws s3 cp s3://$S3_BUCKET/$S3_PREFIX/$backup_name.sql.gz dump.sql.gz || exit 2

gunzip -c dump.sql.gz > $DOWNLOAD_PATH/$backup_name.sql

echo "Dump was downloaded to $DOWNLOAD_PATH/$backup_name.sql"