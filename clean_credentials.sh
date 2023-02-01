## expects RANCHER_URL and TOKEN to be set...see README.md
## Possibly not the safest thing to do, but it's a common cleanup case for me


RANCHER_URL="${2:-$RANCHER_URL}"
TOKEN=$TOKEN

CCREDS=$(curl "https://$RANCHER_URL/v3/cloudCredentials" \
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
