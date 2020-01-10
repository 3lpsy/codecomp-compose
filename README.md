# Super Quick Getting Started

Setting up and dev environment. Assumes that ~/codecomp is where you want all repos and that docker/docker-compose are ready.

```
$ mkdir ~/codecomp
$ cd ~/codecomp
$ git clone https://github.com/3lpsy/codecomp-compose.git
$ cd codecomp-compose
$ REPO_PROTO=https REPO_OWNER=white105 ./setup.sh ~/codecomp
$ ./compose dev4 build
$ ./compose dev4 fresh
```

# Details

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
# basic example
$ REPO_OWNER=white105 ./setup.sh /path/to/meta/directory;
# unauthenticated example
# use REPO_PROTO=https if you don't own repos / not authenticated
$ REPO_PROTO=https REPO_OWNER=3lpsy ./setup.sh;
```

This is what I run (I use my forks, you may just want to use white105):

```
$ mkdir ~/codecomp;
$ cd codecomp;
# clone compose under the meta CODECOMP_DIR, you don't have to
$ git clone https://github.com/3lpsy/codecomp-compose.git
$ cd codecomp-compose
$ REPO_OWNER=3lpsy ./setup.sh ~/codecomp
## but if i'm unauthenticated, i run
$ REPO_PROTO=https REPO_OWNER=3lpsy ./setup.sh ~/codecomp
```

You can read setup.env.example for additional information about options.

## Running

The compose.sh script will pass all options after the env to the docker-compose command. The env corresponds to the docker-compose file where each compose file is 'docker-compose.ENV.yml'

Getting started:

```
# dev4 has no nginx proxy (uses npm)
# so backend must be exposed to host
$ ./compose.sh dev4 build
$ ./compose.sh dev4 fresh

# dev5 proxies backend but syncs "build" for frontend
$ cd /path/to/frontend/compose
$ export REACT_APP_API_URL=http://127.0.0.1:9090
$ npm run watch
# in a separate terminal
$ ./compose dev5 build
$ ./compose dev5 fresh
```

Usage:

```
CodeCompCompose: A Compose Project for CodeComp
Usage:
    $ ./compose.sh [env] [compose options]

Examples:
    $ ./compose.sh dev5 build --no-cache
    $ ./compose.sh dev5 down -v
    $ ./compose.sh dev5 up
    $ ./compose.sh dev5 fresh
```

There is a special command called fresh which is the equivalent of running:

```
$ ./compose.sh dev5 down -v && ./compose.sh dev5 up
```

### Firewalld

Probably not necessary for you.

```
$ firewall-cmd --permanent --zone=trusted --add-interface=codecomppub0
# probably optional
$ firewall-cmd --permanent --zone=trusted --add-interface=docker0
```
