# fake-ssh-server

![.github/workflows/super-linter.yml](https://github.com/javanile/fake-ssh-server/workflows/.github/workflows/super-linter.yml/badge.svg)
[![Build Status](https://travis-ci.org/javanile/fake-ssh-server.svg?branch=master)](https://travis-ci.org/javanile/fake-ssh-server)

This is used as a dummy SSH server in some of our integration tests.

## Description

This is a lightweight SSH server in a docker container.

This image provides:
 - An Ubuntu LTS base image
 - Standard SSH server 
 - User creation based on env variable
 - Home directory based on env variable
 - Ability to run in chroot
 - Ability to use SSH public key

### Example

Mount contents of `./ssh-data` folder into sftp server inside container.

```yml
version: '2'

services:
  # SSHD Server
  sshtest:
    image: checkoutfinland/dummy-sftp-server
    environment:
      # (mandatory) Username for the login
      USERNAME: sftp
      # (optional) Use dummy ssh key you generated for this test
      PUBLIC_KEY: ssh-rsa AAAA....
      # (optional) Use custom path for AuthorizedKeysFile
      PUBLIC_KEYS_PATH: /etc/ssh/authorized_keys
      # (optional) Use the path of mapped volume, default: /in
      FOLDER: /in
      # (optional) put the $FOLDER inside chroot, default: 1
      CHROOT: 1
      # (optional) use custom port number, default: 22
      PORT: 2238
    cap_add:
      # Required if you want to chroot
      - SYS_ADMIN
    security_opt:
      # Required if you want to chroot
      - apparmor:unconfined
    ports:
      - 2238:2238
    volumes:
      ./ssh-data:/in
```

Verify that it works by opening SSH shell to the docker container:
```
$ ssh -p 2238 ubuntu@localhost echo "Hello World!"
Hello World!
```

### Configuration

Configuration is done through environment variables. 

Required:
- USERNAME: the name for login.
- PUBLIC_KEY: the public ssh key for login. (you need this or password)
- PASSWORD: the password for login. (you need this or public key)
- FOLDER: the home of the user.

Optional:
- CHROOT: if set to 1, enable chroot of user (prevent access to other folders than its home folder). Be aware, that 
currently this feature needs additionnal docker capabilities (see below).
- OWNER_ID: the uid of the user. If not set automatically grabbed from the uid of the owner of the FOLDER.

### Chroot 

If you want to run the SSH server with chroot feature, the docker image has to be run with additional capabilities.

    cap_add:
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined

This is due to the use of `mount --bind` in the init script.

**If someone has a better way to do, feel free to submit a pull request or a hint.**

## License

This software is under [MIT](LICENSE) license.
