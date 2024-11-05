#!/bin/bash

rm -rf ~/cysic-verifier
cd ~

git clone https://github.com/ReJumpLabs/cysic-verifier.git

curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/verifier_linux > ~/cysic-verifier/verifier
curl -L https://github.com/cysic-labs/phase2_libs/releases/download/v1.0.0/libdarwin_verifier.so > ~/cysic-verifier/libdarwin_verifier.so

cd /root/cysic-verifier/

echo 'Type evm wallet addresses'
mkdir data
nano evm.txt

echo 'Start config file instance docker'
sleep 3

python3 config.py

echo 'Start config docker-compose'

output_file="docker-compose.yml"

echo "version: '3'" > $output_file
echo "services:" >> $output_file

i=1
while IFS= read -r evm_address || [ -n "$evm_address" ]; do
  cat <<EOL >> $output_file
  verifier_instance_$i:
    build: .
    environment:
      - CHAIN_ID=534352
    volumes:
      - ./data/cysic/keys:/root/.cysic/keys
      - ./data/scroll_prover:/root/.scroll_prover
    network_mode: "host"
    restart: unless-stopped
    command: ["$evm_address"]

EOL
  i=$((i + 1))
done < evm.txt

echo "docker-compose.yml generated with $((i - 1)) instances."