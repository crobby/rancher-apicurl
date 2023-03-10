## expects RANCHER_URL and TOKEN to be set...see README.md
# The CRED_FILE is expected to be simple json { "password":"<password>" }
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CRED_FILE=${1:-~/creds/users.json}
export RANCHER_URL="${2:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)
USERPASS=$(jq -r .password $CRED_FILE)

echo "Creating Rancher users, standard, base, admin, restricted admin"

# 2 steps involved:
# Create user
# assign globalrolebinding to the id of the created user
# Before you ask--Yes, this could be way more configurable and turned into a function, but it's enough for me

USERID=$(curl -s "$RANCHER_URL/v3/users" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"user","enabled":true,"mustChangePassword":false,"name":"standard user","password":"'$USERPASS'","username":"suser"}' \
  --compressed | jq -r .id)
curl -s "$RANCHER_URL/v3/globalrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"globalRoleBinding","globalRoleId":"user","userId": "'$USERID'"}' \
  --compressed | jq


USERID=$(curl -s "$RANCHER_URL/v3/users" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"user","enabled":true,"mustChangePassword":false,"name":"restricted admin user","password":"'$USERPASS'","username":"rauser"}' \
  --compressed | jq -r .id)
curl -s "$RANCHER_URL/v3/globalrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"globalRoleBinding","globalRoleId":"restricted-admin","userId": "'$USERID'"}' \
  --compressed | jq


USERID=$(curl -s "$RANCHER_URL/v3/users" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"user","enabled":true,"mustChangePassword":false,"name":"base user","password":"'$USERPASS'","username":"buser"}' \
  --compressed | jq -r .id)
curl -s "$RANCHER_URL/v3/globalrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"globalRoleBinding","globalRoleId":"user-base","userId": "'$USERID'"}' \
  --compressed | jq


USERID=$(curl -s "$RANCHER_URL/v3/users" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"user","enabled":true,"mustChangePassword":false,"name":"admin user","password":"'$USERPASS'","username":"auser"}' \
  --compressed | jq -r .id)
curl -s "$RANCHER_URL/v3/globalrolebindings" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"type":"globalRoleBinding","globalRoleId":"admin","userId": "'$USERID'"}' \
  --compressed | jq
