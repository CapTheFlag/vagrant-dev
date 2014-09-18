# DEPLOY

## DESCRIPTION

    This is a script to provision a vagrant box with all necessary software for developing a project.

### INSTALLATION

    - Add this to composer.json:
        "repositories": [
            {
                "url": "https://github.com/hgraca/vagrant-dev",
                "type": "git"
            }
        ],
        "require-dev": {
            "hgraca/vagrant-dev": "dev-master"
        },

    - Put the vendor/vagrant-dev/vagrantfile.dist in the project root and rename it to vagrantfile.
        Open the file and change the variables project.XXX, but please note
            that there is no support (yet) for an OS other than Ubuntu
        You should also edit the last inline provisioning command so that it
            corresponds to the project build process
    - Create a folder, in the project root, named 'provisioning' where you will put a settings file
            cp vendor/vagrant-dev/settings.dist.sh to provisioning/settings.sh
        and the DB dumps you want to recover into the DB server, under a folder called:
            provisioning/db/db_name.sql

### USAGE

    - Tested in Linux with VirtualBox 4.3.12 and Vagrant 1.6.3

    - Install virtualbox from https://www.virtualbox.org/wiki/Downloads
    - Install vagrant from https://www.vagrantup.com/downloads.html
    - Install NFS (sudo apt-get install -y nfs-common nfs-kernel-server)

    - to install the application in a vagrant box run: 'vagrant up'
    - to stop the box run: 'vagrant suspend'
    - to resume the box: 'vagrant resume'
    - to destroy the box: 'vagrant destroy'

    Troubleshooting in MAC, try:
        sudo /Library/StartupItems/VirtualBox/VirtualBox restart
        (http://stackoverflow.com/questions/20418895/strange-vagrant-error-message-unable-to-create-a-host-network-interface)
        if still doesn't work, try upgrading to the latest version of virtualbox and vagrant
        You might also need to enable NFS: sudo nfsd enable

### TODO
    -
