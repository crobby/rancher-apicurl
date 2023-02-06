# Optional argument to specify a kubeconfig, otherwise, default is used

KUBECONFIG=$1 kubectl get tokens --template="{{range .items}}{{if and (eq .userPrincipal.loginName \"admin\") (ne .description \"Kubeconfig token\")}}{{.metadata.name}}:{{.token}} {{end}}{{end}}" | cut -d ' ' -f1
