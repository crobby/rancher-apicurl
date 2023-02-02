## expects RANCHER_URL and TOKEN to be set...see README.md
## you can set kubeconfig via $1, otherwise the default will be used
## Possibly not the safest thing to do, but it's a common cleanup case for me
## Will remove all local users except Default Admin and service accounts (id is longer than 7 characters)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export RANCHER_URL="${2:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)


USERS=$(KUBECONFIG=$1 kubectl get users --template="{{range .items}}{{if ne .username \"admin\"}}{{.metadata.name}} {{end}}{{end}}")
read -a USERARRAY <<< $USERS

for USERID in "${USERARRAY[@]}"
do
  len=`echo $USERID |awk '{print length}'`
  if [ $len -gt 7 ]; then
    echo "Skipping user:  $USERID"
  else
  echo "Deleting user: $USERID"
  curl "$RANCHER_URL/v3/users/$USERID" \
    -H "cookie: R_SESS=$TOKEN" \
    -X 'DELETE' \
    --compressed
  fi
done
