#
# This is a template vagrant file, you must put it in the project root and
#       change the variables project.XXX, but please note
#       that there is no support (yet) for an OS other than ubuntu
#   You should also edit the last inline provisioning command so that it
#       corresponds to the project build process
#

Vagrant.configure("2") do |config|

    project_slugname   = 'sluged-project-name'
    project_os_name    = 'ubuntu'
    project_os_upgrate = '0' # Change this 0 to 1 to have the OS to upgrade
    # For the dependencies, use the folder names in provisioning/ubuntu/...
    project_os_dependencies = "system apache php-dev mysql-dev mysql-import-dbs"

    config.vm.box      = 'trusty-server-cloudimg-amd64-vagrant-disk1.box'
    config.vm.box_url  = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    config.vm.hostname = "#{project_slugname}.dev"
    config.vm.synced_folder "./", "/vagrant/", id: "vagrant-root", type: "nfs"
    config.vm.synced_folder ".", "/var/www/#{project_slugname}", id: "www", type: "nfs"

    config.vm.provider :virtualbox do |vb|
        # vb.gui = true
        vb.customize ['modifyvm', :id, '--name', "#{config.vm.hostname}", '--memory', '2048', "--cpus", 2]
    end

    config.vm.network :private_network, ip: '193.168.1.10'
    config.vm.network :forwarded_port, guest: 21, host: 51021, auto_correct: true
    config.vm.network :forwarded_port, guest: 22, host: 51022, id: "ssh", auto_correct: true
    config.vm.network :forwarded_port, guest: 80, host: 51080, auto_correct: true
    config.vm.network :forwarded_port, guest: 8080, host: 51088, auto_correct: true
    config.vm.network :forwarded_port, guest: 3306, host: 51333, auto_correct: true

    # To install all necessary software
    config.vm.provision :shell do |s|
        s.path = "./bin/provision"
        s.args = "#{project_os_name} #{project_os_upgrate} #{config.vm.hostname} '#{project_os_dependencies}'" # Change this 0 to 1 to have the OS to upgrade
    end

    # To build the application and create the DB (The cron jobs are not set up in dev!)
    config.vm.provision :shell, :inline => "
        touch inline_provisioning.no-vcs.txt"
end
