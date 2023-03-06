# Needs the json file with active directory info in ~/creds/

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
AD_FILE=${1:-~/creds/activedirectory.json}
export RANCHER_URL="${2:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)


AD_SERVER_NAME=`jq -r .server $AD_FILE`
AD_SACCOUNT=`jq -r .saccount $AD_FILE`
AD_SAPASS=`jq -r .sapass $AD_FILE`
AD_SEARCH=`jq -r .search $AD_FILE`
AD_USER=`jq -r .user $AD_FILE`
AD_USERPASS=`jq -r .upass $AD_FILE`

curl "$RANCHER_URL/v3/activeDirectoryConfigs/activedirectory?action=testAndApply" \
  -H 'accept: application/json' \
  -H 'content-type: application/json;charset=UTF-8' \
  -H "cookie: R_SESS=$TOKEN" \
  --data-raw '{"enabled":true,"activeDirectoryConfig":{"actions":{"testAndApply":"'$RANCHER_URL'/v3/activeDirectoryConfigs/activedirectory?action=testAndApply"},"annotations":{"management.cattle.io/auth-provider-cleanup":"rancher-locked"},"baseType":"authConfig","connectionTimeout":5000,"created":"2023-03-06T14:05:24Z","createdTS":1678111524000,"creatorId":null,"enabled":true,"groupDNAttribute":"distinguishedName","groupMemberMappingAttribute":"member","groupMemberUserAttribute":"distinguishedName","groupNameAttribute":"name","groupObjectClass":"group","groupSearchAttribute":"sAMAccountName","id":"activedirectory","labels":{"cattle.io/creator":"norman"},"links":{"self":"'$RANCHER_URL'/v3/activeDirectoryConfigs/activedirectory","update":"'$RANCHER_URL'/v3/activeDirectoryConfigs/activedirectory"},"name":"activedirectory","nestedGroupMembershipEnabled":false,"port":389,"starttls":false,"tls":false,"type":"activeDirectoryConfig","userDisabledBitMask":2,"userEnabledAttribute":"userAccountControl","userLoginAttribute":"sAMAccountName","userNameAttribute":"name","userObjectClass":"person","userSearchAttribute":"sAMAccountName|sn|givenName","uuid":"534b8cb6-9a9f-426c-bbce-8fa1b372f2a7","__clone":true,"servers":["'$AD_SERVER_NAME'"],"accessMode":"unrestricted","disabledStatusBitmask":2,"serviceAccountUsername":"'$AD_SACCOUNT'","serviceAccountPassword":"'$AD_SAPASS'","userSearchBase":"'$AD_SEARCH'"},"username":"'$AD_USER'","password":"'$AD_USERPASS'"}' \
  --compressed
