SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TOKEN=$(${SCRIPT_DIR}/get_admin_token.sh)
export RANCHER_URL="${1:-`${SCRIPT_DIR}/get_rancher_url.sh`}"
echo "RANCHER_URL is: ${RANCHER_URL}"

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
echo "Adding Active Directory Auth"
${SCRIPT_DIR}/active_directory.sh
