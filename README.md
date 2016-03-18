vagrant-scaleio
---------------

# Description

Vagrantfile to create a three-VM EMC ScaleIO lab setup using ScaleIO 2.0
This is based on the work done by Jonas Rosland, @virtualswede & Matt Cowger, @mcowger
Modified for ScaleIO 2.0 and simplified/ dummed-down to allow for different setups and tweaking for now :)

# Usage

This Vagrant setup will automatically deploy three CentOS 6.5 nodes

To use this, you'll need to complete a few steps:

1. `git clone https://github.com/timeisanillusion/vagrant-scaleio-simple`
2. Download the ScaleIO 2.0 RHEL package, and make sure the required rpm packages are under /scaleio
and referenced correctly in the vagrant file
packagetb,packagemdm,sds,and packagesdc (Default there for 2.0-5014.0.el6.x86_64.rpm)
3. Run `vagrant up` (if you have more than one Vagrant Provider on your machine run `vagrant up --provider virtualbox` instead)


Note, the cluster will come up with the default unlimited license for dev and test use.

### SSH
To login to the ScaleIO nodes, use the following commands: ```vagrant ssh mdm1```, ```vagrant ssh mdm2```, or ```vagrant ssh tb```.

### Complete Setup
To complete the MDM setup, just ssh into mdm1 and run the 2 scripts
/scripts/mdmsetup.sh : This will complete the 3 node cluster
/scripts/sdssetup.sh : This will add the 3 sds devices specified in the vagrant file

# Troubleshooting

If anything goes wrong during the deployment, run `vagrant destroy -f` to remove all the VMs and then `vagrant up` again to restart the deployment.
