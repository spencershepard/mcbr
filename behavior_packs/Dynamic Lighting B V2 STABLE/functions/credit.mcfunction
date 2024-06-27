##Remove old tags
##tag @a[tag=dl_cred] remove dl_old

##Announce Cred
tellraw @a[tag=!dl_cred] {"rawtext":[{"text":"§l[Dynamic Lights] Visit my official addon page §amcpedl.com/user/amon28 §r§c\nDownloading this elsewhere is breaking the Terms Of Use"}]}

##Add Tag
tag @a[tag=!dl_cred] add dl_cred