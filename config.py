import os

# Define the directories and the content template for config.yaml files
instances = {
    "verifier_instance_1": "0xfa98dC932041755636ED44a4E2455C33B2378Ca9",
    "verifier_instance_2": "0x9302945b5D0a72dB687FDcE9cbFE56Ea4A978969"
}

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

import shutil

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
"Config files created successfully."
