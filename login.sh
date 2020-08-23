#!/bin/bash

read -p 'Enter EMAIL ADDRESS: ' EMAIL
read -p 'Enter API KEY: ' KEY
read -p 'Enter ID: ' ID
read -p 'Point to what IP?: ' IP

export EMAIL="$EMAIL"
export KEY="$KEY"
export ID="$ID"
export IP="$IP"

sleep 3 & PID=$! #simulate a long process

echo "Adding domain names on cloudflare from text file"
printf "["
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 1
done
printf "] done! \n \n \n"

bash add_domain.sh
