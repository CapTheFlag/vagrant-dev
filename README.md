# DEPLOY

## DESCRIPTION

    This is a script to provision a vagrant box with all necessary software for developing
        a project.

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

    - Copy the folder ./vendor/hgraca/vagrant-dev/dist to ./provisioning
    - Create a link from ./vagrantfile to ./provisioning/vagrantfile
    - Adjust all config options in ./provisioning:
        - Replace all occurrences of sluged-project-name for the actual project name
        - vagrantfile:
            Open the file and change the variables project_XXX, but please note
                that there is no support (yet) for an OS other than Ubuntu
            You should also edit the last inline provisioning command so that it
                corresponds to the project build process
        - provisioning/settings.sh
            Adjust all settings
        - provisioning/apache/sluged-project-name.dev.conf
            Replace sluged-project-name in the filename for the actual project name
        - provisioning/db/:
            Put here the dump files for the DBs, with the DB name as the
                filename and the extension '.sql'
        - provisioning/git-server/pub_ssh_keys:
            If you need a git server, put here the pub ssh keys that will need access to it
        - provisioning/system/scripts/:
            Put here custom scripts that you want to have available inside the VM
            (they will be linked with lowarcased name and no extension)
        - provisioning/system/scripts/tailLogs.sh:
            Edit to add the logs paths relevant to the main project
        - provisioning/system/ssh-no-vcs/:
            Put here the private ssh keys that you want to have available in the VM
            (you should add *no-vcs* to the main project .gitignore)

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
