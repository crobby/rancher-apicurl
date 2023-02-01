#usage:  ./set_gcloud_credential.sh <name> <cred file> <rancher url>

#Expects your Rancher bearer token to be set...see README.md
#if cred file isn't given, it will default to ~/creds/google.json
#if rancher_url isn't given, it will try to use your env var

CRED_NAME=$1
GOOGLE_CRED_FILE=${2:-~/creds/google.json}
RANCHER_URL="${3:-$RANCHER_URL}"
TOKEN=$TOKEN

CLIENT_EMAIL=$(jq -r .client_email $GOOGLE_CRED_FILE)
CLIENT_ID=$(jq -r .client_id $GOOGLE_CRED_FILE)
AUTH_URI=$(jq -r .auth_uri $GOOGLE_CRED_FILE)
TOKEN_URI=$(jq -r .token_uri $GOOGLE_CRED_FILE)
AUTH_CERT_URL=$(jq -r .auth_provider_x509_cert_url $GOOGLE_CRED_FILE)
CLIENT_CERT_URL=$(jq -r .client_x509_cert_url $GOOGLE_CRED_FILE)
PROJECTID=$(jq -r .project_id $GOOGLE_CRED_FILE)
TYPE=$(jq -r .type $GOOGLE_CRED_FILE)

#Lots of, possibly unnecessary or inefficient, manipulation of the private key part of the credential
#I had trouble with bash adding extra single quotes and such...this is my series of bizarre workarounds
PRIVATE_KEY_ID=$(jq -r .private_key_id $GOOGLE_CRED_FILE)
PRIVATE_KEY=$(jq .private_key $GOOGLE_CRED_FILE)
P_KEY=$(echo $PRIVATE_KEY | jq @json)
P_KEY=$(echo $P_KEY | tr -d [:space:])
P_KEY=$(echo ${P_KEY:1:-3})
DATA='{"type":"provisioning.cattle.io/cloud-credential","metadata":{"generateName":"cc-","namespace":"fleet-default"},"_name":"'$CRED_NAME'","annotations":{"provisioning.cattle.io/driver":"gcp"},"googlecredentialConfig":{"authEncodedJson":"{\n  \"type\": \"'$TYPE'\",\n  \"project_id\": \"'$PROJECTID'\",\n  \"private_key_id\": \"'$PRIVATE_KEY_ID'\",\n  \"private_key\": '$P_KEY'\",\n  \"client_email\": \"'$CLIENT_EMAIL'\",\n  \"client_id\": \"'$CLIENT_ID'\",\n  \"auth_uri\": \"'$AUTH_URI'\",\n  \"token_uri\": \"'$TOKEN_URI'\",\n  \"auth_provider_x509_cert_url\": \"'$AUTH_CERT_URL'\",\n  \"client_x509_cert_url\": \"'$CLIENT_CERT_URL'\"\n}\n"},"_type":"provisioning.cattle.io/cloud-credential","name":"'$CRED_NAME'"}'
DATA=$(echo $DATA | sed -r 's/BEGINPRIVATEKEY/BEGIN PRIVATE KEY/g')
DATA=$(echo $DATA | sed -r 's/ENDPRIVATEKEY/END PRIVATE KEY/g')

echo "Rancher URL is: $RANCHER_URL"
echo "Creating Google Cloud credential: $CRED_NAME"

curl  "https://$RANCHER_URL/v3/cloudcredentials" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw "$DATA" \
  --compressed | jq
