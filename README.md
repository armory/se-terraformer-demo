terraform test cluster has access to s3:* on buckets called terraformer-*

Notes for Remote Backend:

~/.terraformrc contains the token

main.tf 
added section to include remote backend

and backend.hcl