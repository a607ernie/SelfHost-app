#!/bin/bash

set -e # Exit immediately if a command exits with a non-zero status.

###############
# Create directories for Docker apps
###############
docker_apps_dir="../DockerApps"
app_names=( "busyboxtest"
            "metube"
            "s-pdf/trainingData"
            "s-pdf/extraConfigs"
            "openwebui"
            )

# Create the DockerApps directory if it doesn't exist
if [ ! -d "$docker_apps_dir" ]; then
  mkdir -p "$docker_apps_dir"
  echo "Directory '$docker_apps_dir' created."
else
  echo "Directory '$docker_apps_dir' already exists."
fi

# Create the app subdirectories within DockerApps
for app_name in "${app_names[@]}"; do
  app_dir="$docker_apps_dir/$app_name"
  if [ ! -d "$app_dir" ]; then
    mkdir -p "$app_dir"
    echo "Directory '$app_dir' created."
  else
    echo "Directory '$app_dir' already exists. Skipping."
  fi
done

echo "Directory creation complete."

echo "===================="

###############
# Create a Docker network for the webproxy container
###############
network_name="webproxy"

if ! docker network inspect "$network_name" &> /dev/null; then
  echo "Network '$network_name' does not exist. Creating..."
  docker network create "$network_name" || { echo "Error creating network '$network_name'"; exit 1; }
  echo "Network '$network_name' created successfully."
else
  echo "Network '$network_name' already exists."
fi

echo "Ready to run docker-compose up."