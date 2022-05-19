# Chat Commands

The playerbots are programmed to respond to chat commands.  This addon is designed to make issuing those chat commands easier for the player, but you may still find need for these as you go.

I'm not entirely certain we even know what all the available commands are, but these are the ones I've found so far.  You would issue these in the party or raid chat.

### Movement

command | action
:---|:---
``follow`` | follow master
``stay`` | stay in place
``flee`` | flee with master (ignore everything else)
``d attack my target`` | attack my target
``d add all loot`` | check every corpse and game object for loot
``grind`` | attack anything

### Strategies

The bots respond to different scenarios by implementing "strategies" that are activated by default or that you have defined for them.  There are different categories of strategies that can be defined:



category | prefix | strategy | description
:---|:---
formation |
combat | ``co`` | |
|| ``tank`` | bot will use threat-generating abilities. Supported classes: warrior, paladin and druid. For druid it also known as ``bear``
|| ``dps`` |  obvious, less threat, more dps. Supported classes: rogue, hunter, druid, shaman, priest. For druid it also known as cat.
heal - focus on party healing other that damage or tanking. Supported classes: shaman, priest.

Talent-specific
frost - Useful only for frost mages.
fire - Useful only for fire mages.
bear - Feral tanking druid.
cat - Feral dps druid.
caster - Balance dps druid.

Buff stragegies which are intended to be used with the main combat strategy.
bdps - buffs dps of self and other players. Example: paladin will use seal of might.
bspeed - buffs movement speed. Only for hunter - allows him to use aspect of the cheetach/pack when not in combat
bhealth, bmana - buffs health or mana. Example: paladin will use seal of light vs seal of wisdom.

Resistance stragegies are some kind of buff strategies, but affects magic resistance so moved to separate group.
rfire, rfrost, rshadow, rnature - supported only for paladin auras and hunter aspects.

### Items

command | action
:---|:---
``e [item]`` | equip item
``ue [item]`` | unequip item
``u [item]`` | use item
``u [item] [target]`` | use item on target (e.g. use gem on item)
``destroy [item]`` | destroy item
``[item]`` | add to trade window if trading, show if it is useful

### Quests

command | action
:---|:---
``accept [quest]`` | accept quest at the selected quest giver
``accept *`` | accept all quests at the selected quest giver
``drop [quest]`` | abandon quest
``r [item]`` | choose quest reward
``quests`` | show quest summary
``[quest]`` | show quest and objectives status
``talk`` | talk to the selected npc (to complete a quest)
``u [game object]`` | use game object (use los command to obtain the game object link)

### Misc

command | action
:---|:---
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

### Reactions

The bots will automatically do certain things based on what the party leader is doing.

your action | bot reaction
:---|:---
accept a quest | bot will accept it as well
talk to a quest giver | bot will turn in his completed quests
use meeting stone | teleport using the stone
start using game object and interrupt | use the game object
open trade window | show inventory and start trading
invite to a party/raid | accept the invitation
start raid ready check | tell his ready status
mount/unmount | mount/unmount as well
go through a dungeon portal | follow into the dungeon