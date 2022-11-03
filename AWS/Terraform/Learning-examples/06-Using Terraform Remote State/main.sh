S3NAME="terraformstate-$(date | md5sum | head -c 8)"

aws s3api create-bucket \
    --bucket $S3NAME \
    --region us-west-2 \
    --create-bucket-configuration \
    LocationConstraint=us-west-2

aws s3api put-bucket-encryption \
    --bucket $S3NAME \
    --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}

aws s3api put-bucket-versioning --bucket $S3NAME --versioning-configuration Status=Enabled

aws dynamodb create-table \
    --table-name terraform-state-lock \
    --attribute-definitions \
        AttributeName=LockID,AttributeType=S \
    --key-schema \
        AttributeName=LockID,KeyType=HASH \
    --region us-west-2 \
    --provisioned-throughput \
        ReadCapacityUnits=20,WriteCapacityUnits=20

aws s3 ls s3://$S3NAME/samunas/us-west-2/lab/