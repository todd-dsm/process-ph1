# process-ph1

This is the first step in a description of a process to:

1. Distribute the DEV environment for software engineers to build and test services.
2. Build an AMI to support that service.
3. Deploy the service:
  1. Based on the AMI build in step2
  2. With the code developed in step1


## Problem
The most costly operations in AWS are builds; i.e.: resource acquisition and deployments (assembly of cpu , memory, storage, etc). While in development, these operations could potentially be done multiple times:
 * while testing an idea, which ultimately
 * does not work out
 * resulting in burnt project dollars.

Resources burnt:
 * time for admins to deploy with
  * security considerations
 * time while devs are waiting for deployments
  * and potential securiy hangups, i.e.: devs do not have enough rights to build on the target machine.
 * All while cpu cycles, memory, and storage are in-play.

## Solution
If the most costly operations are server builds, then remove DEV builds from AWS and distribute them to developer laptops.

### Requirements
* A system that supports [virtualization] and these programs: (all Macs since 2011 I believe)
 * Vagrant
 * VirtualBox
 * VirtualBox Extension pack
 * This directory structure must exist:
```bash
$ tree -d -L 2 ~/vms/
~/vms/
├── packer
│   ├── builds
│   ├── iso-cache
│   └── vms
├── vagrant
│   ├── boxes
...
├── vbox
...
└── vmware
...
```

## Expected Result
1. Time Savings:
 1. There are no security considerations. Devs are free to access the system at will.
 2. Devs can easily rebuild a contaminated work-spaces in minutes without waiting for Admins.
 3. Admins are free to do other work.
2. Money Savings:
 1. Environments are not being built, destroyed and rebuilt in AWS.
 2. Dev/Admin time is not burned waiting on one another.

# The Setup
It takes time to configure developer laptops. However: 
 * Configuration time has been reduced - as much as possible - with [mac-ops] automation.
  * Build time: approximately 33-49 minutes, based on hardware build of the target machine.
 * This can be done safely with structured user data [backups] and restoration.
  * Data restoration: fluctuates based on the type and quantity of data being restored; i.e.:
   * VMs take longer to restore than ASCII text files.
   * A median recovery can take approximately a little over 1 hour.

Training time: (Devs)
 * Learn [Vagrant]: approximately 1-2 hours
 * Learn system administration: 1-2 hours
  * This time is reduced by devs leveraging automation (Puppet/Ansible) pre-built by admins.
  * Showing Devs where to get it (git clone repoName), and
  * Demonstrating which automation to run under a few but varied scenarios.


# View from the Dev Cockpit
As a developer, we would first need to pull the code:
```bash
cd ~/code
git clone git@github.com:todd-dsm/process-ph1.git
cd process-ph1/
```

Build the system:
`./test-build.sh`

*NOTE: this script will source-in variables that are required to build within the context of this scenario. Ultimately, they should become part of `~/.bashrc`*.


The packer portion of this script is complete when you see these lines output:
```bash
==> virtualbox-iso (vagrant): Creating Vagrant box for 'virtualbox' provider
    virtualbox-iso (vagrant): Copying from artifact: $HOME/vms/packer/builds/debian/debian-8.6-amd64-disk1.vmdk
    virtualbox-iso (vagrant): Copying from artifact: $HOME/vms/packer/builds/debian/debian-8.6-amd64.ovf
    virtualbox-iso (vagrant): Renaming the OVF to box.ovf...
    virtualbox-iso (vagrant): Compressing: Vagrantfile
    virtualbox-iso (vagrant): Compressing: box.ovf
    virtualbox-iso (vagrant): Compressing: debian-8.6-amd64-disk1.vmdk
    virtualbox-iso (vagrant): Compressing: metadata.json
Build 'virtualbox-iso' finished.

==> Builds finished. The artifacts of successful builds are:
--> virtualbox-iso: 'virtualbox' provider box: $HOME/vms/vagrant/boxes/debian/jessie-virtualbox.box
Sat Feb 11 10:25:28 CST 2017
```

To make the process faster, the Vagrant portion starts right after when you see:
```bash
Adding Debian/Jessie to the local registry...
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'jessie' (v0) for provider: 
    box: Unpacking necessary files from: file:///$HOME/vms/vagrant/boxes/debian/jessie-virtualbox.box
==> box: Successfully added box 'jessie' (v0) for 'virtualbox'!

jessie (virtualbox, 0)

Bringing machine 'default' up with 'virtualbox' provider...
```

The system is ready to inspect when the **Ready for Testing!** message is displayed. Normally you would bring up the VM. At this point a `vagrant up` has already been done by the script. 

1. ssh into the VM: `vagrant ssh`. You are now logged in to the guest machine.
2. List the contents of the home directory
 * Create a file in the home directory: `touch myfile`
 * Move into the mobydock directory: `cd mobydock/`
 * List the contents of the home directory
3. Inspect the Dockerfile and docker-compose.yml if you're curious.
4. Build the container: `docker-compose up --build`
 * Safely ignore any `debconf` messages in the output.
5. The app is ready to start a round of building/testing when you see `postgres_1  | LOG:  autovacuum launcher started`
 * Visit [localhost:8000] to see the app.
 * Click the button to feed MobyDock
  * Go back to the terminal and view the output.

This demonstrates a possible development environment where Devs are free to code at will. 

Now, let's say we've trashed the environment and we need to start fresh.

1. Hit CTRL+c to stop the docker processes.
2. Any code written/modified during this cycle should be committed back to the repo.
3. Log out of the VM: `exit`. You have been returned to your Host machine.
4. Type `vagrant destroy -f`. The VM has been removed from the system.
5. To begin again with fresh/consistent OS build, type: `vagrant up`.
 * A new VM has been built
 * The same automation steps applied
 * The latest code has been pulled down
 * A fresh dev cycle can begin again.
6. Login again with `vagrant ssh`
 * Verify that `myfile` no longer exists in the home directory.
7. Log out of the VM: `exit`. You have been returned to your Host machine.
8. Type `vagrant destroy -f`. The VM has been removed from the system.


## Clear the build 

Artifacts from both Vagrant and Packer are still lingering on the system; dump them:

`./test-reset.sh`


# Conclusion
This system has the attributes:

1. 1-time OS development in `bootstrap.sh` that can be reused over and over. 
2. The dev environment supports the language (python) in which the service built - but can be easily adjusted to support another language.
3. No inter-team delays have been incurred.
4. Nor have any non-setup related costs been incurred.
5. No Host machines were harmed in the making of this VM.

[virtualization]:http://www.intel.com/content/www/us/en/virtualization/virtualization-technology/intel-virtualization-technology.html
[mac-ops]:https://github.com/todd-dsm/mac-ops
[backups]:https://github.com/todd-dsm/rsync-backups
[Vagrant]:https://www.vagrantup.com
[localhost:8000]:http://localhost:8000/seed
