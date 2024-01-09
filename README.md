# Minecraft Bedrock Server

A containterized server with scripts for creating and switching between worlds, and updating worlds with behaviour and resouce packs.

## Setup

1) Clone this repo onto host.
2) `docker compose up``

** server.properties are defaults that are used/overwritten by new world creation **

### Create New World

Navigate to the repository directory on your host and:

`sh create_world.sh`

### Swap between persistant worlds

`sh activate_world.sh`

## Adding New Packs

1) Add files to behavior_packs or resource_packs (mcbr repository directory)

2) Push to repo

3) Pull to your host

4) Run `python add_packs.py` to update valid_known_packs.json and world_resource_packs.json