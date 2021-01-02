# This script is in two parts. First we declare the variables to be applied.

$vm = "my_new_vm" # name of VM, this just applies in Windows, it isn't applied to the OS guest itself.
$image = "path\to\vm\iso\file.iso"
$vmswitch = "vswitch1" # name of your local vswitch
$port = "port1" # port on the VM
$vlan = 199 # VLAN that VM traffic will be send in
$cpu =  2 # Number of CPUs
$ram = 8GB # RAM of VM. Note this is not a string, not in quotation marks
$path_to_disk = "path\to\disk" # Where you want the VM's virtual disk to reside
$disk_size = 20GB # VM storage, again, not a string

# The following are the powershell commands

# Create a new VM
New-VM  $vm
# Set the CPU and start-up RAM
Set-VM $vm -ProcessorCount $cpu -MemoryStartupBytes $ram 
# Create the new VHDX disk - the path and size.
New-VHD -Path $path_to_disk$vm-disk1.vhdx -SizeBytes $disk_size
# Add the new disk to the VM
Add-VMHardDiskDrive -VMName $vm -Path $path_to_disk$vm-disk1.vhdx
# Assign the OS ISO file to the VM
Set-VMDvdDrive -VMName $vm -Path $image
# Remove the default VM NIC named 'Network Adapter'
Remove-VMNetworkAdapter -VMName $vm 
# Add a new NIC to the VM and set its name
Add-VMNetworkAdapter -VMName $vm -Name $port
# Configure the NIC as access and assign VLAN
Set-VMNetworkAdapterVlan -VMName $vm -VMNetworkAdapterName $port -Access -AccessVlanId $vlan
# Connect the NIC to the vswitch
Connect-VMNetworkAdapter -VMName $vm -Name $port -SwitchName $vmswitch
# Fire it up 🔥
Start-VM $vm