execute at @s[scores={pan:xbarrow=0},hasitem={item=arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 arrows to reload.
execute at @s[scores={pan:xbarrow=0},hasitem={item=arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=0},hasitem={item=arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_arrow
execute at @s[scores={pan:xbarrow=0},hasitem={item=arrow,quantity=!0..7}] run clear @s arrow 0 8
execute at @s[scores={pan:xbarrow=2},hasitem={item=pan:flame_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 flame arrows to reload.
execute at @s[scores={pan:xbarrow=2},hasitem={item=pan:flame_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=2},hasitem={item=pan:flame_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_flame_arrow
execute at @s[scores={pan:xbarrow=2},hasitem={item=pan:flame_arrow,quantity=!0..7}] run clear @s pan:flame_arrow 0 8
execute at @s[scores={pan:xbarrow=4},hasitem={item=pan:crystal_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 crystal arrows to reload.
execute at @s[scores={pan:xbarrow=4},hasitem={item=pan:crystal_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=4},hasitem={item=pan:crystal_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_crystal_arrow
execute at @s[scores={pan:xbarrow=4},hasitem={item=pan:crystal_arrow,quantity=!0..7}] run clear @s pan:crystal_arrow 0 8
execute at @s[scores={pan:xbarrow=6},hasitem={item=pan:copper_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 copper arrows to reload.
execute at @s[scores={pan:xbarrow=6},hasitem={item=pan:copper_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=6},hasitem={item=pan:copper_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_copper_arrow
execute at @s[scores={pan:xbarrow=6},hasitem={item=pan:copper_arrow,quantity=!0..7}] run clear @s pan:copper_arrow 0 8
execute at @s[scores={pan:xbarrow=8},hasitem={item=pan:obsidian_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 obsidian arrows to reload.
execute at @s[scores={pan:xbarrow=8},hasitem={item=pan:obsidian_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=8},hasitem={item=pan:obsidian_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_obsidian_arrow
execute at @s[scores={pan:xbarrow=8},hasitem={item=pan:obsidian_arrow,quantity=!0..7}] run clear @s pan:obsidian_arrow 0 8
execute at @s[scores={pan:xbarrow=10},hasitem={item=pan:magma_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 magma arrows to reload.
execute at @s[scores={pan:xbarrow=10},hasitem={item=pan:magma_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=10},hasitem={item=pan:magma_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_magma_arrow
execute at @s[scores={pan:xbarrow=10},hasitem={item=pan:magma_arrow,quantity=!0..7}] run clear @s pan:magma_arrow 0 8
execute at @s[scores={pan:xbarrow=12},hasitem={item=pan:prismarine_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 prismarine arrows to reload.
execute at @s[scores={pan:xbarrow=12},hasitem={item=pan:prismarine_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=12},hasitem={item=pan:prismarine_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_prismarine_arrow
execute at @s[scores={pan:xbarrow=12},hasitem={item=pan:prismarine_arrow,quantity=!0..7}] run clear @s pan:prismarine_arrow 0 8
execute at @s[scores={pan:xbarrow=14},hasitem={item=pan:explosive_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 explosive arrows to reload.
execute at @s[scores={pan:xbarrow=14},hasitem={item=pan:explosive_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=14},hasitem={item=pan:explosive_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_explosive_arrow
execute at @s[scores={pan:xbarrow=14},hasitem={item=pan:explosive_arrow,quantity=!0..7}] run clear @s pan:explosive_arrow 0 8
execute at @s[scores={pan:xbarrow=16},hasitem={item=pan:gravity_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 gravity arrows to reload.
execute at @s[scores={pan:xbarrow=16},hasitem={item=pan:gravity_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=16},hasitem={item=pan:gravity_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_gravity_arrow
execute at @s[scores={pan:xbarrow=16},hasitem={item=pan:gravity_arrow,quantity=!0..7}] run clear @s pan:gravity_arrow 0 8
execute at @s[scores={pan:xbarrow=18..999999},hasitem={item=pan:dragon_arrow,quantity=0..7}] run title @s actionbar Xbow requires 8 dragon arrows to reload.
execute at @s[scores={pan:xbarrow=18..999999},hasitem={item=pan:dragon_arrow,quantity=!0..7}] run playsound crossbow.quick_charge.end @a[r=10] ~ ~ ~
execute at @s[scores={pan:xbarrow=18..999999},hasitem={item=pan:dragon_arrow,quantity=!0..7}] run replaceitem entity @s slot.weapon.mainhand 0 pan:xbow_dragon_arrow
execute at @s[scores={pan:xbarrow=18..999999},hasitem={item=pan:dragon_arrow,quantity=!0..7}] run clear @s pan:dragon_arrow 0 8