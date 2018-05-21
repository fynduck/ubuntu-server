# Ubuntu Dev Env

## Description

- Nginx
- PHP7.1-fpm + MongoDB Extension + Imap + others
- MongoDB
- Ufw for 22, 80, 443
- Composer
- Image libs

Deprecated
- Redis (from source)
- NPM & Node
- Laravel

## Installation Digital Ocean
Run this on fresh Ubuntu 16.04 Droplet
```
bash <(curl -f -L -sS https://raw.githubusercontent.com/pashakopot/ubuntu-dev-env/master/run.sh)
```

## Installation Vagrant
Copy Vagrantfile to your project directory and run
```
vagrant up
```
