# Configure VMSS with the following settings, because Azure Pipelines manages the scale set:
#
# --disable-overprovision - required
# --upgrade-policy-mode manual - required
# --load-balancer "" - Azure Pipelines doesn't require a load balancer to route jobs 
#                      to the agents in the scale set agent pool, but configuring 
#                      a load balancer is one way to get an IP address for your scale 
#                      set agents that you could use for firewall rules.
#                      Another option for getting an IP address for your scale set agents 
#                      is to create your scale set using the --public-ip-address options.
# --instance-count 2 - this setting is not required, but it will give you an opportunity 
#                      to verify that the scale set is fully functional before you create 
#                      an agent pool. Creation of the two VMs can take several minutes. 
#                      Later, when you create the agent pool, Azure Pipelines will delete
#                      these two VMs and create new ones.


az vmss create \
--name vmssagentspool-linux \
--resource-group RG_DevOpsConf \
--location westeurope \
--image UbuntuLTS \
--vm-sku Standard_DS2_v2 \
--storage-sku StandardSSD_LRS \
--authentication-type password \
--instance-count 1 \
--disable-overprovision \
--upgrade-policy-mode manual \
--single-placement-group false \
--platform-fault-domain-count 1 \
--load-balancer "" \
--vnet-name vmssagentspool-winVNET \
--subnet vmssagentspool-linuxSubnet
--ephemeral-os-disk true \
--os-disk-caching readonly

# Windows (Desktop Experience)
az vmss create \
--name vmssagentspool-win \
--resource-group RG_DevOpsConf \
--location westeurope \
--image Win2016Datacenter \
--vm-sku Standard_D2_v3 \
--storage-sku Standard_LRS \
--instance-count 1 \
--disable-overprovision \
--upgrade-policy-mode manual \
--single-placement-group false \
--platform-fault-domain-count 1 \
--load-balancer "" 


