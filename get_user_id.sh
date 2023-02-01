# Optional argument to specify a kubeconfig, otherwise, default is used

USER_NAME=$1
MY_USER_ID=$(KUBECONFIG=$2 kubectl get users --template="{{range .items}}{{if eq .username \"$USER_NAME\"}}{{.metadata.name}}{{end}}{{end}}")
echo $MY_USER_ID
