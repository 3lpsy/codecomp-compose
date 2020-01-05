# About

This is a simple Compose project for managing and starting CodeComp services. It's currently aimed at development and not production. The setup.sh script can be used for easy cloning and setting up new environments for testing. The compose.sh is a simple wrapper to allow for customized file locations. If you want to skip the setup and already have the repos cloned you can just do the following to get started manually:

```
$ cp compose.env.example compose.env
# configure the values appropriately
# don't run setup.sh if doing this
```

## Developing

The goal of this project is to create a seamless development environment where changes to files on hosts are automatically propagated to running services inside the container.

For this reason, the dev compose project makes heavy use of volumes. You will want to familiarze yourself with what volumes are being used and the related Dockerfiles.

## Setup

**Please run from inside the Compose directory**

If you want to customize your setup without specifying the options on the CLI, you can do the following:

```
$ cp setup.env.example setup.env
```

If you have all the branches forked, you can clone them with setup:

```
$ REPO_OWNER=white105 ./setup.sh;
$ REPO_BRANCH=master REPO_PREFIX=Special REPO_OWNER=white105 ./setup.sh;
```

You can read env.source.example for additional information about options.

## Running

The compose.sh script will pass all options after the env to the docker-compose command.

```
BucanCompose: A Compose Project for Boucan
Usage:
    $ ./compose.sh [env] [compose options]

Examples:
    $ ./compose.sh dev build --no-cache
    $ ./compose.sh dev down -v
    $ ./compose.sh dev up
    $ ./compose.sh dev fresh
```

There is a special command called fresh which is the equivalent of running:

```
$ ./compose.sh dev down -v && ./compose.sh dev up
```

### Firewalld

Probably not necessary for you.

```
$ firewall-cmd --permanent --zone=trusted --add-interface=codecomppub0
# probably optional
$ firewall-cmd --permanent --zone=trusted --add-interface=docker0
```
