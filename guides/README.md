# Chat Commands

## Movement

``follow`` | follow master
``stay`` | stay in place
``flee`` | flee with master (ignore everything else)
``d attack my target`` | attack my target
``d add all loot`` | check every corpse and game object for loot
``grind`` | attack anything

## Strategies

``co +s1,-s2,~s3,?`` | add, remove, toggle and show combat strategies
``nc +s1,-s2,~s3,?`` | add, remove, toggle and show non-combat strategies
``ds +s1,-s2,~s3,?`` | add, remove, toggle and show dead strategies

## Items

``e [item]`` | equip item
``ue [item]`` | unequip item
``u [item]`` | use item
``u [item] [target]`` | use item on target (e.g. use gem on item)
``destroy [item]`` | destroy item
``[item]`` | add to trade window if trading, show if it is useful

## Quests

``accept [quest]`` | accept quest at the selected quest giver
``accept *`` | accept all quests at the selected quest giver
``drop [quest]`` | abandon quest
``r [item]`` | choose quest reward
``quests`` | show quest summary
``[quest]`` | show quest and objectives status
``talk`` | talk to the selected npc (to complete a quest)
``u [game object]`` | use game object (use los command to obtain the game object link)

## Misc

``los`` | enlist game objects, items, creatures and npcs bot can see
``stats`` | show stat summary (inventory, gold, xp, etc.)
``leave`` | leave party
``trainer`` | show what bot can learn from the selected trainer
``trainer learn`` | learn from the selected trainer
``spells`` | show bot's spells
``cast [spell]`` | cast the spell
``home`` | set home at the selected innkeeper
``summon`` | summon bot at the inn
``release`` | release spirit when dead
``revive`` | revive when near a spirit healer

## Reactions

your action | bot reaction
accept a quest | bot will accept it as well
talk to a quest giver | bot will turn in his completed quests
use meeting stone | teleport using the stone
start using game object and interrupt | use the game object
open trade window | show inventory and start trading
invite to a party/raid | accept the invitation
start raid ready check | tell his ready status
mount/unmount | mount/unmount as well
go through a dungeon portal | follow into the dungeon