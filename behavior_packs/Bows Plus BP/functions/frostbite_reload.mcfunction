execute at @s[hasitem={item=arrow,quantity=0..5}] run title @s actionbar Frostbite requires 6 arrows to reload.
execute at @s[hasitem={item=arrow,quantity=!0..5}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[hasitem={item=arrow,quantity=!0..5}] run replaceitem entity @s slot.weapon.mainhand 0 pan:frostbite_charged
execute at @s[hasitem={item=arrow,quantity=!0..5}] run clear @s arrow 0 6