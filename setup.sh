#!/bin/bash

# Define the working directory explicitly
WORK_DIR="/home/ubuntu/cysic-verifier"

# Remove existing directory
rm -rf "$WORK_DIR"
cd /home/ubuntu || exit 1

# Clone the repository
git clone https://github.com/ReJumpLabs/cysic-verifier.git "$WORK_DIR"

# Download binaries
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/verifier_linux > "$WORK_DIR/verifier"
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/libdarwin_verifier.so > "$WORK_DIR/libdarwin_verifier.so"
curl -L https://github.com/cysic-labs/cysic-phase3/releases/download/v1.0.0/librsp.so > "$WORK_DIR/librsp.so"

# Navigate to the working directory
cd "$WORK_DIR" || { echo "Failed to change to $WORK_DIR"; exit 1; }

# Prompt for EVM wallet addresses
echo 'Type EVM wallet addresses (one per line, save and exit with Ctrl+O, Enter, Ctrl+X)'
mkdir -p data
nano evm.txt

# Check if evm.txt was created and is not empty
if [ ! -s evm.txt ]; then
  echo "Error: evm.txt is empty or was not created. Please add EVM addresses."
  exit 1
fi

# Check if config.py exists
if [ ! -f config.py ]; then
  echo "Error: config.py not found in $WORK_DIR. Please check the repository or documentation."
  exit 1
fi

echo 'Starting config file instance docker'
sleep 3

# Run config.py
python3 config.py || { echo "Error: Failed to run config.py"; exit 1; }

echo 'Starting config docker-compose'

# Generate docker-compose.yaml
rm -rf docker-compose.yaml
output_file="docker-compose.yaml"

echo "services:" > "$output_file"

i=1
while IFS= read -r evm_address || [ -n "$evm_address" ]; do
  cat <<EOL >> "$output_file"
  verifier_instance_$i:
    build: .
    environment:
      - CHAIN_ID=534352
    volumes:
      - ./data/cysic/keys:/root/.cysic/keys
      - ./data/scroll_prover:/root/.scroll_prover
    network_mode: "host"
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
    command: ["$evm_address"]
EOL
  i=$((i + 1))
done < evm.txt

echo "docker-compose.yaml generated with $((i - 1)) instances."

# Check if Dockerfile exists
if [ ! -f Dockerfile ]; then
  echo "Error: Dockerfile not found in $WORK_DIR. Please check the repository or documentation."
  exit 1
fi

echo "Docker building & start"

# Run Docker Compose with sudo
sudo docker compose up --build -d || { echo "Error: Failed to start Docker Compose"; exit 1; }

# Stream logs with sudo
sudo docker compose logs -f
