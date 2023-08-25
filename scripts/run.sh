#!/bin/bash

env_file=".env.app"
dest_file=".env"
tag=`date +%Y%m%d-%M%S`

if [ ! -f $dest_file ]
then
  echo "Creating .env -- update it with your API key!"
  cp $env_file $dest_file
else
  # mv $dest_file "$dest_file$tag"
  echo "Exists - updated file"
  cp $env_file $dest_file
fi
