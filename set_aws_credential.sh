#usage:  ./set_do_credential.sh <name> <cred file> <rancher url>
#if cred file isn't given, it will default to ~/.aws/credentials
#if rancher_url isn't given, it will try to use your env var

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CRED_NAME=$1
AWSFILE=${2:-~/.aws/credentials}
AWS_KEY=$(grep -i "aws_access_key_id" $AWSFILE | cut -d = -f 2 | tr -d '[:space:]')
AWS_SECRET=$(grep -i "aws_secret_access_key" $AWSFILE | cut -d = -f 2 | tr -d '[:space:]')
export RANCHER_URL="${3:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

curl  "$RANCHER_URL/v3/cloudcredentials" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"provisioning.cattle.io/cloud-credential","metadata":{"generateName":"cc-","namespace":"fleet-default"},"_name":"'$CRED_NAME'","annotations":{"provisioning.cattle.io/driver":"aws"},"amazonec2credentialConfig":{"defaultRegion":"us-east-2","accessKey":"'$AWS_KEY'","secretKey":"'$AWS_SECRET'"},"_type":"provisioning.cattle.io/cloud-credential","name":"'$CRED_NAME'"}' \
  --compressed | jq -r '.id'
