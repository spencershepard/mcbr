!/bin/sh

#check for sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#User input: level name
echo "Enter level name: "
read level_name

#check to make sure level name is not already in use
if [ -d "mcbs/worlds/$level_name" ]
then
    echo "Level name already in use. Please choose another."
    exit 1
fi

echo "Enter level seed (optional): "
read level_seed

echo "Enter game mode (survival/creative): "
read game_mode

echo "Enter difficulty (peaceful/easy/normal/hard): "
read difficulty

echo "Allow cheats? (y/n)"
read allow_cheats

#Create level directory
mkdir mcbs/worlds/$level_name

echo "Use repository packs? (y/n)"
read use_repo_packs


if [ $use_repo_packs == "y" ]
then
    cp world_resource_packs.json mcbs/worlds/$level_name
    cp -r behavior_packs mcbs/worlds/$level_name/behavior_packs
    cp -r resource_packs mcbs/worlds/$level_name/resource_packs
fi

#modify server.properties with user provided attributes
cp server.properties mcbs/worlds/$level_name
sed -i "s/level-name=.*/level-name=$level_name/g" mcbs/worlds/$level_name/server.properties
sed -i "s/level-seed=.*/level-seed=$level_seed/g" mcbs/worlds/$level_name/server.properties
sed -i "s/gamemode=.*/gamemode=$game_mode/g" mcbs/worlds/$level_name/server.properties
sed -i "s/difficulty=.*/difficulty=$difficulty/g" mcbs/worlds/$level_name/server.properties
sed -i "s/allow-cheats=.*/allow-cheats=$allow_cheats/g" mcbs/worlds/$level_name/server.properties



