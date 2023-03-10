#usage:  ./set_do_credential.sh <name> <cred file> <rancher url>

#if cred file isn't given, it will default to ~/cred.txt
#if rancher_url isn't given, it will try to use your env var
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CRED_NAME=$1
DO_CRED_FILE=${2:-~/cred.txt}
DO_TOKEN=$(< $DO_CRED_FILE)
export RANCHER_URL="${3:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

curl  "$RANCHER_URL/v3/cloudcredentials" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"provisioning.cattle.io/cloud-credential","metadata":{"generateName":"cc-","namespace":"fleet-default"},"_name":"'$CRED_NAME'","annotations":{"provisioning.cattle.io/driver":"digitalocean"},"digitaloceancredentialConfig":{"accessToken":"'$DO_TOKEN'"},"_type":"provisioning.cattle.io/cloud-credential","name":"'$CRED_NAME'"}' \
  --compressed | jq -r '.id'
