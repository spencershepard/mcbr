scoreboard objectives add pan:quiver dummy
scoreboard players add @a pan:quiver 0
scoreboard objectives add pan:xbarrow dummy
scoreboard players add @a pan:xbarrow 0
scoreboard objectives add pan:miniarrow dummy
scoreboard players add @a pan:miniarrow 0
scoreboard objectives add pan:bonearrow dummy
scoreboard players add @a pan:bonearrow 0
scoreboard objectives add pan:gildarrow dummy
scoreboard players add @a pan:gildarrow 0
scoreboard objectives add pan:ironarrow dummy
scoreboard players add @a pan:ironarrow 0
tag @a add bowdead
tag @e[type=player] remove bowdead
scoreboard players set @a[tag=bowdead,tag=!already_bodead] pan:frostbite2 0
scoreboard players set @a[tag=bowdead,tag=!already_bodead] pan:sticky2 0
tag @a[tag=bowdead,tag=!already_bodead] add already_bodead
tag @a[tag=!bowdead,tag=already_bodead] remove already_bodead
scoreboard objectives add pan:arow_chek dummy
scoreboard players add @a pan:arow_chek 0
execute at @a[m=!c,hasitem={quantity=!0,item=arrow}] run scoreboard players set @e[c=1] pan:arow_chek 1
execute at @a[m=!c,hasitem={quantity=0,item=arrow}] run scoreboard players set @e[c=1] pan:arow_chek 0
execute at @a[m=c] run scoreboard players set @e[c=1] pan:arow_chek 1
scoreboard objectives add pan:frostbite2 dummy
execute as @e[hasitem={item=pan:frostbite_charged,quantity=1,location=slot.weapon.mainhand}] run scoreboard players set @s pan:frostbite2 0
execute as @e[hasitem={item=pan:frostbite_empty,quantity=1,location=slot.weapon.mainhand}] run scoreboard players set @s pan:frostbite2 0
execute at @e[scores={pan:frostbite2=200}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=180}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=160}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=140}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=140}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=100}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=60}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=20}] run damage @e[c=1] 1 freezing entity @p
execute at @e[scores={pan:frostbite2=1..999999}] run effect @e[c=1] slowness 1 0 true
execute at @e[scores={pan:frostbite2=1..999999}] run effect @e[c=1] mining_fatigue 1 0 true
execute at @e[scores={pan:frostbite2=1..999999}] run particle minecraft:snowflake_particle ~-0.5 ~ ~
execute at @e[scores={pan:frostbite2=1..999999}] run scoreboard players remove @e[c=1] pan:frostbite2 1
scoreboard objectives add pan:sticky2 dummy
execute at @e[scores={pan:sticky2=1..2}] run playsound hit.slime @a[r=15] ~ ~ ~
execute at @e[scores={pan:sticky2=99..100}] run playsound land.slime @a[r=15] ~ ~ ~
execute at @e[scores={pan:sticky2=1..100}] run scoreboard players add @e[c=1] pan:sticky2 1
execute at @e[scores={pan:sticky2=1..100}] run tp @e[c=1] ~ ~-0.1 ~ true
execute at @e[scores={pan:sticky2=1..100}] run particle pan:honey ~ ~ ~
execute at @e[scores={pan:sticky2=1..80}] run effect @e[c=1] slowness 1 0 true
execute at @e[scores={pan:sticky2=1..2}] run effect @e[c=1] regeneration 5 1 true
execute at @e[scores={pan:sticky2=400..999999}] run scoreboard players set @e[c=1] pan:sticky2 0
execute at @e[tag=pan:sea_arw] run execute as @e[tag=pan:sea_arw] run tp @e[c=1] ^ ^0.1 ^0.5 facing @e[r=25,type=!arrow,type=!item,type=!xp_orb,type=!pan:sea_arrow,hasitem={quantity=0,item=pan:sea_bow},c=1,family=!inanimate] true