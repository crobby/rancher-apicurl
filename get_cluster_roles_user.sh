## expects RANCHER_URL and TOKEN to be set...see README.md
## Possibly not the safest thing to do, but it's a common cleanup case for me

## ./get_cluster_roles_user.sh <cluster_id> <user_id>
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CLUSTER_ID=$1
USER_ID=$2
export RANCHER_URL="${3:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

GREEN='\033[0;32m'
NC='\033[0m'

CRBS=$(curl -s "$RANCHER_URL/k8s/clusters/$CLUSTER_ID/v1/rbac.authorization.k8s.io.clusterrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  --compressed | jq -r '.data[] | select(.subjects[].name == "'$USER_ID'") | .roleRef.name')

##  --compressed | jq -r '.data[] | {subjects: .subjects, roleRef: .roleRef} | select(.subjects[].name == "'$USER_ID'") | .roleRef.name')

CRBARRAY=(`echo $CRBS`)
echo -e "\nThe CRBS for user ${GREEN}$USER_ID${NC} on cluster ${GREEN}$CLUSTER_ID${NC} are:"
for CRB in "${CRBARRAY[@]}"
do
  echo -e "${GREEN}$CRB${NC}: https://$RANCHER_URL/k8s/clusters/$CLUSTER_ID/apis/rbac.authorization.k8s.io/v1/clusterroles/$CRB"
done
