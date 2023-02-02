#If RANCHER_URL is set, use it, otherwise use $1
RANCHER_URL="${1:-$RANCHER_URL}"
TOKEN="${2:-$TOKEN}"
curl -s "https://$RANCHER_URL/v1/pods" \
  -H 'accept: application/json' \
  -H 'accept-language: en-US,en;q=0.9' \
  -H 'cookie: R_SESS=$TOKEN' \
  --compressed | jq
