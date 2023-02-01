# Optional argument to specify a kubeconfig, otherwise, default is used

MY_USER_ID=$1
GRB=$(KUBECONFIG=$2 kubectl get globalrolebindings --template="{{range .items}}{{if eq .userName \"$MY_USER_ID\"}}{{println .globalRoleName}}{{end}}{{end}}")
echo $GRB
