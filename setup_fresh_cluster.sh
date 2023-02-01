export RANCHER_URL="${1:-$RANCHER_URL}"
export TOKEN=$(./get_admin_token.sh)

if [ -z ${RANCHER_URL+x} ];
then
    echo "You must set or specify the RANCHER_URL to use this utility"
    exit 1
fi

./set_aws_credential.sh awscred
./set_do_credential.sh docred
./set_gcloud_credential.sh googcred
