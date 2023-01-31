# Optional argument to specify a kubeconfig, otherwise, default is used

KUBECONFIG=$1 kubectl get tokens --template="{{range .items}}{{if eq .userPrincipal.loginName \"admin\"}}{{.metadata.name}}:{{.token}}{{end}}{{end}}"
