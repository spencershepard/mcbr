execute at @s[hasitem={item=arrow,quantity=0..15}] run title @s actionbar Sunbeam requires 16 arrows to reload.
execute at @s[hasitem={item=arrow,quantity=!0..15}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[hasitem={item=arrow,quantity=!0..15}] run replaceitem entity @s slot.weapon.mainhand 0 pan:sunbeam_charged
execute at @s[hasitem={item=arrow,quantity=!0..15}] run clear @s arrow 0 16