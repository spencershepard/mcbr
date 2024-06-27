import { BlockPermutation, ItemStack, system, world } from '@minecraft/server';
import { ActionFormData, MessageFormData, ModalFormData } from '@minecraft/server-ui';

const lockableBlocks = [
    'minecraft:barrel',
    'minecraft:chest',
    'minecraft:trapped_chest',
]

world.beforeEvents.playerInteractWithBlock.subscribe((data) => {
    const {itemStack: item, block, player} = data;

    if(!lockableBlocks.includes(block.typeId)) return;
    const {x, y, z} = block.location;
    const dimensionName = block.dimension.id.replace('minecraft:', '');
    const lockedBlockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
    const blockName = block.typeId.replace('minecraft:', '').split('_').map(name => name.charAt(0).toUpperCase() + name.slice(1)).join(' ');
    const blockData = world.getDynamicProperty(lockedBlockId);

    if(blockData) {
        if(player.getDynamicProperty(lockedBlockId + ':isUnlock')) return;
        const lockBlockData = JSON.parse(blockData);
        const {password, attemptNotification, restrictEditing, owner} = lockBlockData;

        data.cancel = true;
        system.run(() => {
            switch(tripwireName()) {
                case 'editor':
                    if(restrictEditing && player.id !== owner) {
                        player.sendMessage('§cYou don\'t have permission to edit it.');
                        if(!attemptNotification) return;
                        notifyOwner(player.id, owner, blockName, 'edit');
                    }
                    else {
                        enterPasswordUi('Edit').then(isUnlocked => {
                            if(isUnlocked) {
                                editingUi(lockBlockData);
                            }
                            else {
                                player.sendMessage('§cIncorrect password, cannot proceed to edit.');
                                if(!attemptNotification) return;
                                notifyOwner(player.id, owner, blockName, 'edit');
                            }
                        });
                    }
                break;
                case 'retriever':
                    if(player.id === owner || player.isOp() || player.hasTag('operator')) {
                        player.sendMessage(`The Password of this ${blockName} is §a\"${password}\"`);
                        decrementItem();
                    }
                    else {
                        player.sendMessage('§cYou don\'t have permission to retrieve its password');
                        if(!attemptNotification) return;
                        notifyOwner(player.id, owner, blockName, 'retrieve the password of');
                    }
                break;
                default:
                    enterPasswordUi('Unlock').then(isUnlocked => {
                        if(isUnlocked) {
                            const connectedChestLoc = findConnectedChest(block)?.location;
                            player.sendMessage(`§aYou unlocked the ${blockName}`);
                            unlockLockBlock(lockedBlockId, true);

                            if(connectedChestLoc) {
                                const {x: cx, y: cy, z: cz} = connectedChestLoc;
                                const connectedChestLockId = `${dimensionName}:${cx}:${cy}:${cz}:lockBlock`;
                                unlockLockBlock(connectedChestLockId, false);
                            }
                        }
                        else {
                            player.sendMessage('§cIncorrect Password!');
                            if(attemptNotification) {
                                notifyOwner(player.id, owner, blockName, 'unlock');
                            }
                        }
                    });
                break;
            }
        });
    }
    else if(tripwireName() === 'locker') {
        data.cancel = true;
        const lockUi = new ModalFormData()
            .title(`Lock ${blockName}`)
            .textField('Password:', 'Create Password')
            .textField('Confirm Password:', 'Retype Password')
            .toggle('Attempt Notification', false)
            .toggle('Restrict Editing', false)
            .submitButton(`Lock ${blockName}`)

        system.run(() => {
            lockUi.show(player).then(result => {
                if(result.canceled) return;
                const [password, confirmPass, attemptNotification, restrictEditing] = result.formValues;
                const isPassCreated = createPassword(password, confirmPass);

                if(isPassCreated === true) {
                    const lockBlockData = JSON.stringify({
                        password: password,
                        attemptNotification: attemptNotification,
                        restrictEditing: restrictEditing,
                        owner: player.id
                    });

                    decrementItem();
                    updateLockBlock(block, lockedBlockId, lockBlockData)
                    player.sendMessage(`§a${blockName} has been locked successfully`);
                }
                else {
                    player.sendMessage(isPassCreated);
                }
            });
        });
    }

    function tripwireName() {
        if(item?.typeId === 'minecraft:tripwire_hook') {
            return item?.nameTag?.toLowerCase();
        }
        return;
    }

    function unlockLockBlock(lockId, shouldSendMessage) {
        player.setDynamicProperty(lockId + ':isUnlock', true);
        system.runTimeout(() => {
            const shouldLockAgain = player.isValid() && player.getDynamicProperty(lockId + ':isUnlock');
            if(shouldLockAgain) {
                player.setDynamicProperty(lockId + ':isUnlock', undefined);
                if(shouldSendMessage) {
                    player.sendMessage(`§b${blockName} has been locked!`);
                }
            }
        }, 100);
    }

    function decrementItem() {
        if(player.getGameMode() === 'creative') return;
        const decrementedItem = item.amount == 1 ? undefined : (item.amount--, item);
        player.getComponent('inventory').container.setItem(player.selectedSlotIndex, decrementedItem);
    }

    function enterPasswordUi(actionType) {
        const enterPass = new ModalFormData()
            .title(`${actionType} ${blockName}`)
            .textField('Password:', 'Enter Password')
            .submitButton(`${actionType} ${blockName}`)

        return new Promise(resolve => {
            enterPass.show(player).then(result => {
                if(result.canceled) return;
                const [inputtedPassword] = result.formValues;
                const {password} = JSON.parse(blockData);

                resolve(inputtedPassword === password);
            });
        });
    }

    function editingUi(lockBlockData) {
        const editUi = new ActionFormData()
            .title(`Edit ${blockName}`)
            .body('Select Action:')
            .button('Change Password', 'textures/ui/pencil_edit_icon')
            .button('Edit Settings', 'textures/ui/icon_setting')
            .button('Delete Password', 'textures/ui/icon_trash')

        editUi.show(player).then(result => {
            if(result.canceled) return;
            const {password, attemptNotification, restrictEditing} = lockBlockData;

            switch(result.selection) {
                case 0:
                    const changePass = new ModalFormData()
                        .title('Change Password')
                        .textField('Create New Password:', 'Type New Password')
                        .textField('Confirm New Password:', 'Retype New Password')
                        .submitButton('Save New Password')

                    changePass.show(player).then(result => {
                        if(result.canceled) {
                            editingUi(lockBlockData);
                        }
                        else {
                            const [newPassword, confirmPassword] = result.formValues;
                            if(newPassword === password) {
                                player.sendMessage('§cThe new password cannot be the same as the old password. Please enter a different password.');
                            }
                            else {
                                const isPassCreated = createPassword(newPassword, confirmPassword);
                                if(isPassCreated === true) {
                                    const newBlockData = {
                                        ...lockBlockData,
                                        password: newPassword
                                    }

                                    player.sendMessage('§aNew password has been set.');
                                    updateLockBlock(block, lockedBlockId, JSON.stringify(newBlockData));
                                }
                                else {
                                    player.sendMessage(isPassCreated);
                                }
                            }
                        }
                    });
                break;
                case 1:
                    const editSettings = new ModalFormData()
                        .title('Edit Settings')
                        .toggle('Attempt Notification', attemptNotification)
                        .toggle('Restrict Editing', restrictEditing)
                        .submitButton('Save Settings')

                    editSettings.show(player).then(result => {
                        if(result.canceled) {
                            editingUi(lockBlockData);
                        }
                        else {
                            const [newAttemptNotif, newRestrictEdit] = result.formValues;
                            const newBlockData = {
                                ...lockBlockData,
                                attemptNotification: newAttemptNotif,
                                restrictEditing: newRestrictEdit
                            }

                            player.sendMessage(`§a${blockName}'s settings has been updated.`);
                            updateLockBlock(block, lockedBlockId, JSON.stringify(newBlockData));
                        }
                    });
                break;
                case 2:
                    const confirmUi = new MessageFormData()
                        .title('Delete Password?')
                        .body('You have initiated to delete your password. This action is irreversible and will result in the permanent loss of its data. Do you wish to proceed?')
                        .button1('Cancel')
                        .button2('Confirm Delete')

                    confirmUi.show(player).then(result => {
                        if(result.selection) {
                            player.sendMessage('§bPassword has been deleted');
                            updateLockBlock(block, lockedBlockId, undefined)
                        }
                        else {
                            editingUi(lockBlockData);
                        }
                    });
                break;
            }
        })
    }
});

world.beforeEvents.playerBreakBlock.subscribe((data) => {
    const {block, player} = data;
    const {x, y, z} = block.location;
    const dimensionName = block.dimension.id.replace('minecraft:', '');
    const lockedBlockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
    const isLockable = lockableBlocks.includes(block.typeId);
    const blockData = world.getDynamicProperty(lockedBlockId);
    const {attemptNotification, restrictEditing, owner: ownerId} = JSON.parse(blockData ?? '{}');
    const blockName = block.typeId.replace('minecraft:', '').split('_').map(name => name.charAt(0) + name.slice(1)).join(' ');

    if(isLockable && blockData && !player.getDynamicProperty(lockedBlockId + ':isUnlock') && (!player.isOp() && !player.hasTag('operator'))) {
        data.cancel = true;
        player.sendMessage(`§cYou can\'t destroy locked ${blockName}!`);

        if(!attemptNotification) return;
        notifyOwner(player.id, ownerId, blockName, 'destroy');
    }
    else {
        if(player.id !== ownerId && restrictEditing) {
            data.cancel = true;
            player.sendMessage(`§cYou don't have permission to destroy this ${blockName}`)
        }
        else {
            player.setDynamicProperty(lockedBlockId + ':isUnlock', undefined);
            world.setDynamicProperty(lockedBlockId, undefined);
        }
    }
});

world.beforeEvents.explosion.subscribe((data) => {
    const affectedBlocks = data.getImpactedBlocks().filter((block) => {
        const {x, y, z} = block.location;
        const dimensionName = block.dimension.id.replace('minecraft:', '');
        const lockedBlockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
        return !world.getDynamicProperty(lockedBlockId);
    });
    data.setImpactedBlocks(affectedBlocks);
});

world.afterEvents.playerPlaceBlock.subscribe(({block}) => {
    if(block.getComponent('inventory')?.container.size !== 54) return;
    const connectedChest = findConnectedChest(block);

    if(connectedChest) {
        const {x: cx, y: cy, z: cz} = connectedChest.location;
        const dimensionName = block.dimension.id.replace('minecraft:', '');
        const connectedChestLockId = `${dimensionName}:${cx}:${cy}:${cz}:lockBlock`;
        const connectedChestData = world.getDynamicProperty(connectedChestLockId);

        if(connectedChestData) {
            const {x, y, z} = block.location;
            const lockedBlockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
            world.setDynamicProperty(lockedBlockId, connectedChestData);
        }
    }
});

world.afterEvents.pistonActivate.subscribe((data) => {
    const {piston, dimension, isExpanding} = data;
    const dimensionName = dimension.id.replace('minecraft:', '');
    const pistonDirection = piston.block.permutation.getState('facing_direction');
    const attachBlocksLoc = piston.getAttachedBlocksLocations();

    attachBlocksLoc.forEach((location) => {
        const {x, y, z} = location;
        const lockedBlockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
        const blockData = world.getDynamicProperty(lockedBlockId);
        const newLoc = getVectorOnMove(location);

        system.runTimeout(() => {
            if(blockData) {
                const newLockedBlockId = `${dimensionName}:${newLoc.x}:${newLoc.y}:${newLoc.z}:lockBlock`;
                world.setDynamicProperty(newLockedBlockId, blockData);
                world.setDynamicProperty(lockedBlockId, undefined);
            }
        }, 2);
    });

    function getVectorOnMove(vector) {
        const {x, y, z} = vector;
        const subtractThenAdd = isExpanding ? -1 : 1;
        const addThenSubtract = isExpanding ? 1 : -1;

        switch(pistonDirection) {
            case 0:
                return {x: x, y: y + subtractThenAdd, z: z }
            case 1:
                return {x: x, y: y + addThenSubtract, z: z}
            case 2:
                return {x: x, y: y, z: z + addThenSubtract}
            case 3:
                return {x: x, y: y, z: z + subtractThenAdd}
            case 4:
                return {x: x + addThenSubtract, y: y, z: z}
            case 5:
                return {x: x + subtractThenAdd, y: y, z: z}
        }
    }
});

world.afterEvents.playerSpawn.subscribe(({player}) => {
    const unlockStateIds = player.getDynamicPropertyIds().filter(property => property.endsWith(':isUnlock'));
    for(const id of unlockStateIds) {
        player.setDynamicProperty(id, undefined);
    }
});

system.runInterval(() => {
    const lockedBlockIds = world.getDynamicPropertyIds().filter(ids => /:lockBlock$/.test(ids));

    for(const id of lockedBlockIds) {
        const idData = id.split(':');
        const dimensionName = idData[0];
        const blockLocation = {x: parseInt(idData[1]), y: parseInt(idData[2]), z: parseInt(idData[3])};
        const dimension = world.getDimension(dimensionName)
        const bottomBlock = dimension.getBlock(blockLocation)?.below();

        if(bottomBlock?.typeId === 'minecraft:hopper') {
            const direction = bottomBlock.permutation.getState('facing_direction');
            bottomBlock.setPermutation(BlockPermutation.resolve('minecraft:hopper', {
                'toggle_bit': true, 'facing_direction': direction
            }));
        }
        const bottomLoc = {
            x: blockLocation.x,
            y: blockLocation.y - 1,
            z: blockLocation.z,
        }
        const minecartHopper = dimension.getEntitiesAtBlockLocation(bottomLoc).filter(entity => entity.typeId === 'minecraft:hopper_minecart');
        minecartHopper.forEach(hopper => {
            hopper.kill();
        });
    }
});

function createPassword(password, confirmPassword) {
    if(password.length >= 5 && password.length <= 30) {
        if(password === confirmPassword.trim()) {
            return true;
        }
        else if(!confirmPassword.trim()){
            return '§ePlease also confirm the password';
        }
        else {
            return '§cPassword do not match';
        }
    }
    else if(password.length > 30) {
        return '§cPassword cannot exceed 30 characters';
    }
    else {
        return password.trim() ? '§cPassword is too short, must have at least 5 characters!' : '§cNo password is inputted';
    }
}

function notifyOwner(interactorId, ownerId, blockName, actionMessage) {
    world.getAllPlayers().forEach(player => {
        if(player.id === ownerId && interactorId !== ownerId) {
            player.sendMessage(`§cWarning: ${player.name} tried to ${actionMessage} your ${blockName.toLowerCase()}!`);
        }
    });
}

function updateLockBlock(block, lockedBlockId, blockData) {
    const connectedChest = findConnectedChest(block);
    world.setDynamicProperty(lockedBlockId, blockData);
    if(connectedChest) {
        const {x, y, z} = connectedChest.location;
        const dimensionName = connectedChest.dimension.id.replace('minecraft:', '');
        const connectedChestLockId = `${dimensionName}:${x}:${y}:${z}:lockBlock`;
        world.setDynamicProperty(connectedChestLockId, blockData);
    }
}

function findConnectedChest(block) {
    const inventory = block.getComponent('inventory').container;
    const cachedItem = inventory.getItem(0);

    if(inventory.size === 54) {
        const directions = ['north', 'south', 'west', 'east'];
        const itemTester = new ItemStack('minecraft:barrier', 1);

        itemTester.nameTag = 'vech:itemTester';
        inventory.setItem(0, itemTester);
        for(const direction of directions) {
            const adjacentBlock = block[direction]();
            if(adjacentBlock.permutation.matches(block.typeId, block.permutation.getAllStates())) {
                const firstSlot = adjacentBlock.getComponent('inventory').container.getItem(0);

                if(inventory.getItem(0)?.nameTag === firstSlot?.nameTag) {
                    inventory.setItem(0, cachedItem);
                    return adjacentBlock;
                }
                else {
                    inventory.setItem(0, cachedItem);
                }
            }
        }
    }
    return;
}