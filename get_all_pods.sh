#If RANCHER_URL is set, use it, otherwise use $1
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export RANCHER_URL="${1:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)
curl -s "https://$RANCHER_URL/v1/pods" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: R_SESS=$TOKEN' \
  --compressed | jq
