## expects RANCHER_URL and TOKEN to be set...see README.md
## you can set kubeconfig via $1, otherwise the default will be used
## Possibly not the safest thing to do, but it's a common cleanup case for me
## Will remove all local users except Default Admin and service accounts (id is longer than 7 characters)

RANCHER_URL="${2:-$RANCHER_URL}"
TOKEN=$TOKEN


USERS=$(KUBECONFIG=$1 kubectl get users --template="{{range .items}}{{if ne .username \"admin\"}}{{.metadata.name}} {{end}}{{end}}")
read -a USERARRAY <<< $USERS

for USERID in "${USERARRAY[@]}"
do
  len=`echo $USERID |awk '{print length}'`
  if [ $len -gt 7 ]; then
    echo "Skipping user:  $USERID"
  else
  echo "Deleting user: $USERID"
  curl "https://$RANCHER_URL/v3/users/$USERID" \
    -H "cookie: R_SESS=$TOKEN" \
    -X 'DELETE' \
    --compressed
  fi
done
