# Required cluster display name as an argument, optionally can supply Rancher URL
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CLUSTER_NAME=$1
export RANCHER_URL="${2:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

curl  -s "$RANCHER_URL/v1/management.cattle.io.cluster" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --compressed | jq -r '.data[] | select(.spec.displayName == "'$CLUSTER_NAME'") | .id'
