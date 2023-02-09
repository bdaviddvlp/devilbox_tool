#!/bin/bash

function startUpPhp8Config() {

if [[ "$isPhp8" != 'P' && "$isDockerRunning" == 1 ]]; then
        cat << MESSAGE

          ---------------------------
          Stopping php7 containers...
          ---------------------------

MESSAGE
  sleep 1
  docker-compose down
  cp -f .env8 .env
  isDockerRunning=0
fi

if [[ "$isDockerRunning" != 1 ]]; then
  cp docker-compose.yml.up docker-compose.yml
  cat << MESSAGE

          ------------------------------
          Starting php8 configuration...
          ------------------------------

MESSAGE
  sleep 1
  docker-compose up httpd mysql memcd php redis -d
  isDockerRunning=1
fi
  cat << MESSAGE

          --------------------------------------------
          Devilbox with php8 config is up and running!
          --------------------------------------------

MESSAGE
  shift
}

function startUpPhp7Config() {
  if [[ "$isPhp7" != 'P' && "$isDockerRunning" == 1 ]]; then
    cat << MESSAGE

          ---------------------------
          Stopping php8 containers...
          ---------------------------

MESSAGE
    sleep 1
    docker-compose down
    cp -f .env7 .env
    isDockerRunning=0
  fi

  if [[ "$isDockerRunning" != 1 ]]; then
    cp docker-compose.yml.up docker-compose.yml
    cat << MESSAGE

          ------------------------------
          Starting php7 configuration...
          ------------------------------

MESSAGE
    sleep 1
    docker-compose up httpd mysql memcd php -d
    isDockerRunning=1
  fi
  cat << MESSAGE

          --------------------------------------------
          Devilbox with php7 config is up and running!
          --------------------------------------------

MESSAGE
  shift
}

function findWhichConfigIsRunning() {
  if [[ "$isDockerRunning" == 1 ]]; then
    if [[ "$isPhp8" == 'P' ]]; then
      cat << MESSAGE

          --------------------------------
          Devilbox php8 config is running!
          --------------------------------

MESSAGE
    fi

    if [[ "$isPhp7" == 'P' ]]; then
      cat << MESSAGE

          --------------------------------
          Devilbox php7 config is running!
          --------------------------------

MESSAGE
    fi
  else
    cat << MESSAGE

          ----------------------------------
          Devilbox container is not running!
          ----------------------------------

MESSAGE
    fi
}

function shutDevilbox() {
  docker-compose down
  cat << MESSAGE

            --------------------------------------------
            Devilbox containers are stopped and removed!
            --------------------------------------------

MESSAGE
}

function loginToDevilbox() {
  if [[ "$isDockerRunning" == 1 ]]; then
    cat << MESSAGE

          ------------------------------
          Login to devilbox container...
          ------------------------------

MESSAGE
    sleep 1
    docker-compose exec --user devilbox php bash -l
  else
    cat << MESSAGE

          ------------------------------------
          Devilbox containers are not running!
          ------------------------------------

MESSAGE
  fi
}

function printHelpText () {
  cat << HELP

  Usage :

    --php7                -> start php7 config
    --php8                -> start php8 config
    --login               -> login to running devilbox container
    --down                -> stop and remove devilbox containers
    --which               -> shows currently running config
    --restart             -> restart currently running config
    --help, -h, <no arg>  -> this message

HELP
}

function checkDevilboxPathExist () {
  if [[ -z "${DEVILBOX_PATH}" ]]; then
    cat << ERROR
    Your DEVILBOX_PATH is empty, please set it fist before using this tool!
ERROR
  exit
  fi
}

function restartDevilbox () {
  if [[ "$isDockerRunning" == 1 ]]; then
    if [[ "$isPhp8" == 'P' ]]; then
      docker-compose down
      docker-compose up httpd mysql memcd php redis -d
    fi

    if [[ "$isPhp7" == 'P' ]]; then
      docker-compose down
      docker-compose up httpd mysql memcd php -d
    fi
  else
    cat << MESSAGE
    Devilbox is not running, nothing to restart!
MESSAGE
  fi
}

checkDevilboxPathExist

sudo chmod 666 /var/run/docker.sock

cd $DEVILBOX_PATH

if [[ "$1" == '--help' || "$1" == '-h' || "$#" == 0 ]]; then
  printHelpText
fi

isPhp7=$(grep 'PHP_SERVER=7.4' .env | head -n 1 | cut -c 1)
isPhp8=$(grep 'PHP_SERVER=8.1' .env | head -n 1 | cut -c 1)
isDockerRunning=$(docker-compose ls | grep devilbox | wc -l)

if [ ! -f "/tmp/docker_tool" ]; then
  touch /tmp/docker_tool
  docker-compose down
  isDockerRunning=0
fi

if [[ "$1" == '--php7' ]]; then
  startUpPhp7Config
fi

if [[ "$1" == '--php8' ]]; then
  startUpPhp8Config
fi
  
if [[ "$1" == '--login' ]]; then
  loginToDevilbox
fi

if [[ "$1" == '--down' ]]; then
  shutDevilbox
fi

if [[ "$1" == '--which' ]]; then
  findWhichConfigIsRunning
fi

if [[ "$1" == '--restart' ]]; then
  restartDevilbox
fi
