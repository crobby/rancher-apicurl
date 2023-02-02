# Spits out the public url of the ngrok tunnel named rancher
curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.name == "rancher") | .public_url' || echo "ngrok is not running"
