## expects RANCHER_URL and TOKEN to be set...see README.md
## Possibly not the safest thing to do, but it's a common cleanup case for me

## ./get_cluster_roles_user.sh <cluster_id> <user_id>

CLUSTER_ID=$1
USER_ID=$2
RANCHER_URL="${3:-$RANCHER_URL}"
TOKEN=$TOKEN

GREEN='\033[0;32m'
NC='\033[0m'

CRBS=$(curl -s "https://$RANCHER_URL/k8s/clusters/$CLUSTER_ID/v1/rbac.authorization.k8s.io.clusterrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  --compressed | jq -r '.data[] | select(.subjects[].name == "'$USER_ID'") | .roleRef.name')

##  --compressed | jq -r '.data[] | {subjects: .subjects, roleRef: .roleRef} | select(.subjects[].name == "'$USER_ID'") | .roleRef.name')

CRBARRAY=(`echo $CRBS`)
echo -e "\nThe CRBS for user ${GREEN}$USER_ID${NC} on cluster ${GREEN}$CLUSTER_ID${NC} are:"
for CRB in "${CRBARRAY[@]}"
do
  echo -e "${GREEN}$CRB${NC}: https://$RANCHER_URL/k8s/clusters/$CLUSTER_ID/apis/rbac.authorization.k8s.io/v1/clusterroles/$CRB"
done
