# vagrant-sf2
Simple virtual machine for Symfony2 projects with Vagrant. This machine is built with :
- A box under Ubuntu 12.04 LTS
- Apache 2.4.12
- PHP 5.5.23
- MySQL 5.5

## Prerequisites

You have to install :
- vagrant
- VirtualBox

## Start machine

Clone this repository.

### Configuration

```yaml
private_network: '192.168.56.4' # IP for network
ports:
    ssh: '2200' # Port SSH to access virtual machine
    http: '8080' # Port HTTP to access websites
database:
    pwd: 'root' # Password for MySQL root user

# Config for your websites
websites:
    site_1:
        name: 'name_1' # Name of website
        sync_folder: 'C:/path/site_1' # Folder to sync with NFS
        url: 'site_1.dev' # URL to access
    site_2:
        name: 'name_2'
        sync_folder: 'C:/path/site_2'
        url: 'site_2.dev'
```

### Install plugin winnfsd (for Windows users)

To enable to synchronize folders with NFS, you have to install a vagrant plugin with following command:

```
vagrant plugin install vagrant-winnfsd
```

### Vagrant up

Go to your clone of this repository and do following command:

```
vagrant up
```

After 5 minutes, you're machine is up !

### Add declarations in hosts

Find your hosts file and declare this line at the end for each website:

```
{ip_private} {url}
```

For example you can do this:

```
192.168.56.4 www.site_1.dev site_1.dev
192.168.56.4 www.site_2.dev site_2.dev
```

## Go to work !

And it's all, you can now developp on your machine and get result directly in your web navigator. With plugin winnfsd, websites respond between 1 and 3 seconds (after a firts initialization to create cache files).

To go faster, you can also change cache and log folders in your AppKernel.php.

Enjoy !