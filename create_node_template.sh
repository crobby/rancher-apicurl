# ./create_node_template.sh <cc id> <name>
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CC_ID=$1
NT_NAME=$2
export RANCHER_URL="${3:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)

echo "Creating node template for digital ocean rke1"

curl -s "$RANCHER_URL/v3/nodetemplate" \
  -H "cookie: R_SESS=$TOKEN" \
  -H 'content-type: application/json' \
  --data-raw '{"useInternalIpAddress":true,"type":"nodeTemplate","engineInstallURL":"https://releases.rancher.com/install-docker/20.10.sh","engineRegistryMirror":[],"amazonec2Config":null,"namespaceId":"fixme","cloudCredentialId":"'$CC_ID'","labels":{},"digitaloceanConfig":{"accessToken":"","backups":false,"image":"ubuntu-18-04-x64","ipv6":false,"monitoring":false,"privateNetworking":false,"region":"nyc3","size":"s-2vcpu-4gb","sshKeyContents":"","sshKeyFingerprint":"","sshPort":"22","sshUser":"root","tags":"","userdata":"","type":"digitaloceanConfig"},"name":"'$NT_NAME'"}' \
  --compressed | jq
