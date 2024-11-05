#!/bin/bash

# Set the EVM address and Chain ID from environment variables or arguments
EVM_ADDRESS=${1:-"default_ethereum_address"}
CHAIN_ID=${CHAIN_ID:-"534352"}

# Update config.yaml with the provided EVM address
sed -i "s/claim_reward_address:.*/claim_reward_address: \"$EVM_ADDRESS\"/" /app/config.yaml

# Set LD_LIBRARY_PATH and run verifier
export LD_LIBRARY_PATH=/app
./verifier
