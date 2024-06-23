#!/bin/bash
#creates a new world directory and copies server.properties to it

echo "Enter level name: "
read level_name

#check to make sure level name is not already in use
if [ -d "mcbs/worlds/$level_name" ]
then
    echo "Level name already in use. Please choose another:"
    goto level_name
fi

mkdir mcbs/worlds/$level_name

#if not successful, exit
if [ $? -ne 0 ]
then
    echo "Error creating level directory."
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

echo "Enter server name (leave blank for default): "
read server_name

cp server.properties mcbs/worlds/$level_name

#modify the server.properties file

#temporarily replace "force-gamemode=" with "frcgmmode=" to avoid sed confusing with "gamemode=" KEEP the value after the "="
sed -i "s/force-gamemode=/frcgmmode=/g" mcbs/worlds/$level_name/server.properties
sed -i "s/gamemode=.*/gamemode=$game_mode/g" mcbs/worlds/$level_name/server.properties
#change back
sed -i "s/frcgmmode=/force-gamemode=/g" mcbs/worlds/$level_name/server.properties

#continue normally with othe properties
sed -i "s/level-name=.*/level-name=$level_name/g" mcbs/worlds/$level_name/server.properties
sed -i "s/level-seed=.*/level-seed=$level_seed/g" mcbs/worlds/$level_name/server.properties
sed -i "s/difficulty=.*/difficulty=$difficulty/g" mcbs/worlds/$level_name/server.properties

if [ "$server_name" != "" ]
then
    sed -i "s/server-name=.*/server-name=$server_name/g" mcbs/worlds/$level_name/server.properties
fi

if [ "$allow_cheats" = "y" ]
then
    sed -i "s/allow-cheats=.*/allow-cheats=true/g" mcbs/worlds/$level_name/server.properties
fi

echo "Level created. Would you like to activate it? (y/n)"
read activate_level

if [ "$activate_level" = "y" ]
then
    cp mcbs/worlds/$level_name/server.properties mcbs/server.properties
    echo "Level activated. Please restart server."
else
    echo "Level created. Activate it with activate_world.sh."
fi

exit 0


