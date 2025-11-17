#!/bin/bash
if [ "$#" -eq  "0" ]
 then
    echo "No arguments supplied"
    exit 1
else
    echo "Run started"
fi

run_type=$(basename "$1")
echo "run type"
echo $run_type
if [[ "$run_type" == "init" ]]; then
  echo "Performing initialization job..."
  source ./pre_env.sh
  docker compose down -v
  docker compose up -d --build
  source ./post_start.sh

elif [[ "$run_type" == "update" ]]; then
  echo "Performing ejabberd.yml update job..."
  docker cp ejabberd.yml ejabberd:/opt/ejabberd/build/etc/ejabberd/ejabberd.yml
  docker container restart ejabberd 
  echo "Ejabberd container restarted"
else
  echo "No specific job defined for '$run_type'."
  echo "Usage: Rename this script to 'init' or 'update' to perform specific tasks."
fi 

