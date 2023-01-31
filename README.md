# rancher-apicurl -- A set of scripts I find useful for common Rancher dev setup, ymmv
As a Rancher dev, I often find myself starting from scratch with a blank Rancher
environment. I constantly have to create my cloud credentials, users, node templates,
etc.  This set of crude scripts is my way of making that task a lot easier and faster.
Some of the scripts rely a bit on how I have my stuff set up, so you might need to
tweak a few things to match your environment/taste.


# Getting started

* This will set your RANCHER_URL env var which is used by all of these scripts.

`export RANCHER_URL=<yourhost>.ngrok.io` #No https:// or trailing slash

* This will set your env var TOKEN to the bearer token for the admin account.
It is used by the other scripts.

`export TOKEN=$(./get_admin_token.sh)`
