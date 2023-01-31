#usage:  ./set_do_credential.sh <name> <cred file> <rancher url>

#if cred file isn't given, it will default to ~/cred.txt
#if rancher_url isn't given, it will try to use your env var

CRED_NAME=$1
DO_CRED_FILE=${2:-~/cred.txt}
DO_TOKEN=$(< $DO_CRED_FILE)
RANCHER_URL="${3:-$RANCHER_URL}"
TOKEN=$TOKEN

echo "Rancher URL is: $RANCHER_URL"
echo "Creating digital ocean credential: $CRED_NAME"

curl  "https://$RANCHER_URL/v3/cloudcredentials" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"provisioning.cattle.io/cloud-credential","metadata":{"generateName":"cc-","namespace":"fleet-default"},"_name":"'$CRED_NAME'","annotations":{"provisioning.cattle.io/driver":"digitalocean"},"digitaloceancredentialConfig":{"accessToken":"'$DO_TOKEN'"},"_type":"provisioning.cattle.io/cloud-credential","name":"'$CRED_NAME'"}' \
  --compressed | jq
