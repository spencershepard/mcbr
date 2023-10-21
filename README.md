# Minecraft Bedrock Server

A containterized server with scripts for creating and switching between worlds, and updating worlds with behaviour and resouce packs. 

## Setup 

1) Clone this repo onto host.
2) docker compose up

** server.properties are defaults that are overwritten by new world creation **

### Create New World

Navigate to the repository directory on your host and:

`sh create_world.sh`
(may require sudo)

### Swap between persistant worlds

`sh activate_world.sh`

### Update worlds with packs from repository

`sh update_packs.sh`