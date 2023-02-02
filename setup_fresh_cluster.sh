export RANCHER_URL="${1:-$RANCHER_URL}"
export TOKEN=$(./get_admin_token.sh)

if [ -z ${RANCHER_URL+x} ];
then
    echo "You must set or specify the RANCHER_URL to use this utility"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Setting up AWS cloud credential"
${SCRIPT_DIR}/set_aws_credential.sh awscred
echo "Setting up Digital Ocean cloud credential"
DO_CC_ID=`${SCRIPT_DIR}/set_do_credential.sh docred`
echo "Setting up Google cloud credential"
${SCRIPT_DIR}/set_gcloud_credential.sh googcred
echo "Adding users, standard, restricted admin, base"
${SCRIPT_DIR}/add_users.sh
echo "Adding Digital Ocean node template"
${SCRIPT_DIR}/create_node_template.sh $DO_CC_ID cernt
