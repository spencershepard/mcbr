import os
import json

# add all packs to valid_known_packs.json
# choose which packs to add to each world's world_resource_packs.json

# determine if linux or windows
windows = False
if os.name == 'nt':
    windows = True
    print("Windows detected\n")

class Pack:
    def __init__(self, path, type):
        self.path = path
        self.type = type
        self.abs_path = os.path.abspath(path)
        self.manifest = self.get_manifest()
        self.uuid = self.manifest['header']['uuid']
        self.name = self.manifest['header']['name']
        self.version = self.manifest['header']['version']

    
    def get_manifest(self):
        with open(self.abs_path + '/manifest.json', 'r') as manifest_file:
            manifest = json.load(manifest_file)
        return manifest


resource_packs = []
resource_manifests = [os.path.join(root, file) for root, dirs, files in os.walk('resource_packs') for file in files if file == 'manifest.json']
for manifest_path in resource_manifests:
    resource_packs.append(Pack(os.path.dirname(manifest_path), 'resource'))

behavior_packs = []
behavior_manifests = [os.path.join(root, file) for root, dirs, files in os.walk('behavior_packs') for file in files if file == 'manifest.json']
for manifest_path in behavior_manifests:
    behavior_packs.append(Pack(os.path.dirname(manifest_path), 'behavior'))


input("Add all packs to valid_known_packs.json? (press enter to continue) ")

validPacks = []

validPacks.append({
    "file_version": 2
})

for pack in resource_packs:
    validPacks.append({
        "file_system": "RawPath",
        "path": pack.path,
        "uuid": pack.uuid,
        "version": pack.version
    })

    # copy the pack to the mcbs folder
    if windows:
        os.system(f'xcopy "{pack.path}" "mcbs/resource_packs/{pack.name}" /E /I /Y')
    else:
        os.system(f'cp -r "{pack.path}" "mcbs/resource_packs/{pack.name}"')

for pack in behavior_packs:
    validPacks.append({
        "file_system": "RawPath",
        "path": pack.path,
        "uuid": pack.uuid,
        "version": pack.version
    })

    # copy the pack to the mcbs folder
    if windows:
        os.system(f'xcopy "{pack.path}" "mcbs/behavior_packs/{pack.name}" /E /I /Y')
    else:
        os.system(f'cp -r "{pack.path}" "mcbs/behavior_packs/{pack.name}"')

# Save the valid_known_packs.json in utf-8
with open('mcbs/valid_known_packs.json', 'w', encoding='utf-8') as valid_packs_file:
    json.dump(validPacks, valid_packs_file, ensure_ascii=False, indent=4)

packs_to_add = []

if (input("Would you like to add all packs? (y/n): ")) == 'y':
    packs_to_add = resource_packs + behavior_packs

else:
    for pack in resource_packs + behavior_packs:
        if (input(f"Add {pack.name}? (y/n): ")) == 'y':
            packs_to_add.append(pack)


# choose which packs to add to each world's world_resource_packs.json
world_resource_packs = []

for pack in packs_to_add:
    world_resource_packs.append({
        "pack_id": pack.uuid,
        "version": pack.version
    })


worlds = [name for name in os.listdir('mcbs/worlds') if os.path.isdir(os.path.join('mcbs/worlds', name))]
worlds.sort()

if (input("Would you like to add the packs to all worlds? (y/n): ")) == 'y':
    for world_name in worlds:
        with open(f'mcbs/worlds/{world_name}/world_resource_packs.json', 'w', encoding='utf-8') as world_resource_packs_file:
            json.dump(world_resource_packs, world_resource_packs_file, ensure_ascii=False, indent=4)
    print("Done!")
    exit()



while True:
    # Get user input: which world would you like to add packs to?
    print("Worlds:")
    for i in range(len(worlds)):
        print(f"{i}: {worlds[i]}")
    world_index = int(input("Which world would you like to add packs to? (enter number): "))
    world_name = worlds[world_index]

    # Save the world_resource_packs.json in utf-8
    with open(f'mcbs/worlds/{world_name}/world_resource_packs.json', 'w', encoding='utf-8') as world_resource_packs_file:
        json.dump(world_resource_packs, world_resource_packs_file, ensure_ascii=False, indent=4)

    worlds.remove(world_name)

    if len(worlds) > 0:
        done = input("Add these packs to another world? (y/n): ")
        if done == 'n':
            break
    else:
        break

print("Done!")
