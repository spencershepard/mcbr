echo "Choose level to activate: "
ls mcbs/worlds
read level_name

#check to make sure level directory has server.properties file
if [ ! -f "mcbs/worlds/$level_name/server.properties" ]
then
    echo "Level directory does not have server.properties file."
    exit 1
fi

cp mcbs/worlds/$level_name/server.properties mcbs/server.properties

#if not successful, exit
if [ $? -ne 0 ]
then
    echo "Error copying server.properties file."
    exit 1
fi

echo "$level_name server.properties file copied to main directory. Please restart server to activate level."

exit 0