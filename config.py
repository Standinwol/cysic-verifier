import os
import shutil

# Path to the file containing EVM addresses
evm_file_path = 'evm.txt'

# Initialize an empty dictionary for instances
instances = {}

# Read each line in the file and populate the dictionary
with open(evm_file_path, 'r') as file:
    for i, line in enumerate(file, start=1):
        # Remove any extra whitespace or newline characters
        evm_address = line.strip()
        
        # Define the instance name and add it to the dictionary
        instances[f'verifier_instance_{i}'] = evm_address

# Define the content template for config.yaml files
config_content_template = """# Not Change
chain:
  # Not Change
  endpoint: "node-pre.prover.xyz:80"
  # Not Change
  chain_id: "cysicmint_9001-1"
  # Not Change
  gas_coin: "CYS"
  # Not Change
  gas_price: 10
  # Modify Here: Your Address (EVM) submitted to claim rewards
  claim_reward_address: "{claim_reward_address}"

server:
  # don't modify this
  cysic_endpoint: "https://api-pre.prover.xyz"
"""

# Remove existing directories if they exist
for instance in instances.keys():
    if os.path.isdir(instance):  # Confirm it's a directory before removing
        shutil.rmtree(instance)

# Recreate the directories and config.yaml files
for instance, address in instances.items():
    # Ensure the directory exists
    os.makedirs(instance, exist_ok=True)
    
    # Define path for config.yaml and create the file with the specific address
    config_path = os.path.join(instance, "config.yaml")
    config_content = config_content_template.format(claim_reward_address=address)
    
    with open(config_path, "w") as config_file:
        config_file.write(config_content)

print("Config files created successfully.")
