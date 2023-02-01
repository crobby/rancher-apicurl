# Required cluster display name as an argument, optionally can supply Rancher URL

CLUSTER_NAME=$1
RANCHER_URL="${2:-$RANCHER_URL}"
TOKEN=$TOKEN

curl  -s "https://$RANCHER_URL/v1/management.cattle.io.cluster" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --compressed | jq -r '.data[] | select(.spec.displayName == "'$CLUSTER_NAME'") | .id'
