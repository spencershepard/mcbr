# Minecraft Bedrock Server

A containterized server with scripts for creating and switching between worlds, and updating worlds with behaviour and resouce packs.

## Setup

1) Clone this repo onto host.
2) `docker compose up``

** server.properties are defaults that are overwritten by new world creation **

### Create New World

Navigate to the repository directory on your host and:

`sh create_world.sh`

### Swap between persistant worlds

`sh activate_world.sh`

## Adding New Packs

1) Add files to behavior_packs or resource_packs

2) Run `.\update_packs.ps1` (powershell) to update valid_known_packs.json and world_resource_packs.json

3) Push to repo

4) Pull to your host

5) On your host run `sh update_world.sh` to copy the new files to your world folders