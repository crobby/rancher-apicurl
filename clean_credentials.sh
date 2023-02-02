## expects RANCHER_URL and TOKEN to be set...see README.md
## Possibly not the safest thing to do, but it's a common cleanup case for me
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export RANCHER_URL="${1:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

CCREDS=$(curl "$RANCHER_URL/v3/cloudCredentials" \
  -H "cookie: R_SESS=$TOKEN" \
  --compressed | jq -r '.data[] | .links.remove')

CREDARRAY=(`echo $CCREDS`)

#  Will remove all cloud credentials that are NOT referenced by a node template (API will fail on removing those)
for CREDREMLINK in "${CREDARRAY[@]}"
do
  echo "Removing $CREDREMLINK"
  curl "$CREDREMLINK" \
    -H "cookie: R_SESS=$TOKEN" \
    -X 'DELETE' \
    --compressed
done
