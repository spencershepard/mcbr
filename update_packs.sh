echo "Choose level to update with packs (or "all"): "
ls mcbs/worlds
read level_name

if [ "$level_name" = "all" ]
then
    for level in mcbs/worlds/*
    do
        if [ -d "$level" ]
        then
            echo "Updating packs for $level"
            cp world_resource_packs.json "$level"
            cp -r behavior_packs "$level/behavior_packs"
            cp -r resource_packs "$level"/resource_packs"
        fi
    done
else
    cp world_resource_packs.json "mcbs/worlds/$level_name"
    cp -r behavior_packs "mcbs/worlds/$level_name/behavior_packs"
    cp -r resource_packs "mcbs/worlds/$level_name/resource_packs"
fi