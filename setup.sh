#!/bin/bash

set -e; 

get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     $( cd -P "$( dirname "$SOURCE" )" )
     pwd
}
# first see if they passed in an argument as directory
_CODECOMP_DIR="";

_DEFAULT_COMPOSE_DIR="$(get_script_dir)"
_COMPOSE_DIR=${COMPOSE_DIR:-$_DEFAULT_COMPOSE_DIR}

if [ -f "${_COMPOSE_DIR}/setup.env" ]; then
    echo "Sourcing: ${_COMPOSE_DIR}/setup.env";
    source ${_COMPOSE_DIR}/setup.env;
fi

if [ ${#1} -gt 0 ]; then
    _CODECOMP_DIR="$1";
elif [ ${#CODECOMP_DIR} -lt 0 ]; then 
    _CODECOMP_DIR="$CODECOMP_DIR";
else
    _CODECOMP_DIR="$(dirname ${_COMPOSE_DIR})"
fi

echo "Codecomp Directory: $_CODECOMP_DIR";

if [ ! -d "$_CODECOMP_DIR" ]; then 
    echo "Making $_CODECOMP_DIR";
    mkdir -p $_CODECOMP_DIR;
fi

function setup_repo () {
    repo="$1";
    echo "Setting Up Repo: $repo";
    _default_repo_owner="white105"

    # remove if codecomp-compose merged to white105
    if [[ "$repo" == "codecomp-compose" ]]; then 
        _default_repo_owner="3lpsy"
    fi
    
    _repo_owner=${REPO_OWNER:-$_default_repo_owner}
    _repo_prefix="${REPO_PREFIX}";
    _repo_branch="${REPO_BRANCH:-master}";
    _repo_proto="${REPO_PROTO:-git}"
    _repo_provider=${REPO_PROVIDER:-github.com}
    if [ "git" = "$_repo_proto" ]; then
        _proto_prefix="git@"
        _user_delim=":"
    else
        # https://
        _proto_prefix="${_repo_proto}://"
        _user_delim="/"
    fi
    _repo_base_url="${REPO_BASE_URL:-${_proto_prefix}${_repo_provider}${_user_delim}${_repo_owner}}";

    repo_source="${_repo_base_url}/${_repo_prefix}${repo}";
    repo_dest="${_CODECOMP_DIR}/$repo";

    echo "Repo Source: $repo_source"
    echo "Repo Destination: $repo_dest";
    echo "Repo Branch: ${_repo_branch}";
    if [ ! -d "${repo_dest}/.git" ]; then 
        echo "Cloning Repo...";
        git clone -b "$_repo_branch" "$repo_source" "$repo_dest";
    else
        echo "Destination already exists. Skipping..";
    fi
}

echo "";
echo "Setting Up Repos...";
echo "";
for repo in codecomp codecomp-backend codecomp-compose; do
    setup_repo ${repo}
    echo "";
done

echo "Repo cloning complete..."
echo ""

echo "Creating source target at: ${_COMPOSE_DIR}/compose.env";
echo "export CODECOMP_DIR=\"${_CODECOMP_DIR}\"" > "${_COMPOSE_DIR}/compose.env";
echo "export COMPOSE_DIR=\"${_COMPOSE_DIR}\"" >> "${_COMPOSE_DIR}/compose.env";

echo "You can now run docker composer with: compose.sh [env] [compose options]";
