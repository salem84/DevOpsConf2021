az devops login

# List all agent pools
az pipelines pool list --org https://dev.azure.com/giorgiolasala 

# Get agent pool ID by name
az pipelines pool list --org https://dev.azure.com/giorgiolasala --pool-name "AKS"

# Run pipeline
az pipelines run --org https://dev.azure.com/giorgiolasala --name "DevOpsConf AKS" --project DevOpsConf