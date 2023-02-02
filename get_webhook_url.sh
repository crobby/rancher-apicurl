# Spits out the public url of the ngrok tunnel named webhook
curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[] | select(.name == "webhook") | .public_url'
