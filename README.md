# vagrant-sf2
Simple virtual machine for Symfony2 projects with Vagrant. This machine is built with :
- A box under Ubuntu 12.04 LTS
- Apache 2.4.12
- PHP 5.5.23
- MySQL 5.5

It respects all requirements and recommandations of Symfony project.

## Prerequisites

You have to install :
- Vagrant (it works with version 1.7.2) : [Download Vagrant](http://www.vagrantup.com/downloads)
- VirtualBox (it works with version 4.3.26) : [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

## Start machine

Clone this repository.

### Configuration

```yaml
vm_name: 'vm_name'                  # Machine's name
private_network: '192.168.56.4'     # Network's IP
ports:
    ssh: '2200'   # Port SSH to access virtual machine
    http: '8080'  # Port HTTP to access websites
database:
    pwd: 'root'   # Password for MySQL root user

# Config for your websites
websites:
    site_1:
        name: 'name_1'                # Name of website
        sync_folder: 'C:/path/site_1' # Folder to sync with NFS
        url: 'site_1.dev'             # URL to access
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

## Configure your Symfony project

### Composer install / update

You have to launch following command from your computer, because there is an error when cloning / installing some dependencies due to synchronisation :

```
composer install
```

### Launch doctrine commands

From guest machine (after log in with vagrant ssh for example), you can launch doctrine commands :

```
php app/console doctrine:schema:create
php app/console doctrine:fixtures:load
```

### Add network IP

To access to app_dev.php and config.php, you have to put network IP (with 1 at end) in these files like this :

```php
# web/app_dev.php
...
// This check prevents access to debug front controllers that are deployed by accident to production servers.
// Feel free to remove this, extend it, or make something more sophisticated.
if (isset($_SERVER['HTTP_CLIENT_IP'])
    || isset($_SERVER['HTTP_X_FORWARDED_FOR'])
    || !(in_array(@$_SERVER['REMOTE_ADDR'], array('127.0.0.1', 'fe80::1', '::1', '192.168.56.1')) || php_sapi_name() === 'cli-server')
) {
    header('HTTP/1.0 403 Forbidden');
    exit('You are not allowed to access this file. Check '.basename(__FILE__).' for more information.');
}
...
```

```php
# web/config.php
...
if (!in_array(@$_SERVER['REMOTE_ADDR'], array(
    '127.0.0.1',
    '::1',
    '192.168.56.1',
))) {
    header('HTTP/1.0 403 Forbidden');
    exit('This script is only accessible from localhost.');
}
...
```

## Go to work !

And it's alright, you can now developp on your machine and get result directly in your web navigator. With plugin winnfsd, websites respond between 1 and 3 seconds (after a firts initialization to create cache files).

To go faster, you can also change cache and log folders in your AppKernel.php.

```php
...
public function getCacheDir()
{
    if (in_array($this->environment, array('dev', 'test'))) {
        return '/var/cache/website/cache/' . $this->environment;
    }
    return parent::getCacheDir();
}

public function getLogDir()
{
    if (in_array($this->environment, array('dev', 'test'))) {
        return '/var/log/website/';
    }
    return parent::getLogDir();
}
...
```

Enjoy !