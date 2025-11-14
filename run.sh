#!/bin/bash

source ./pre_env.sh
docker-compose up -d --build
source ./post_start.sh

