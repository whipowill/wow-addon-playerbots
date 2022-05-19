# Operator's Manual

The bots are programmed to respond to chat commands.  The game addon is designed to make issuing those chat commands easier for the player, and though the desire is to make the addon a comprehensive solution, you may still have need for manual chat commands as you play.

## Party

command | action
:---|:---
``.playerbots bot add name1,name2,name3`` | login alts
``.playerbots bot remove name1,name2,name3`` | logout alts
``.playerbots bot add *`` |  login all alts
``.playerbots bot remove *`` | logout all alts
``.playerbots bot init=rare name1,name2,name3`` | respawn @ your level w/ max talents & rare gear (random bots only)

## Behavior

The bots are programmed to respond to triggers by listing possible actions and choosing one based on a strategy:

- triggers - what is happening
- actions - what can the bot do
- stragegy - what is the best action

Strategies can be combined, so they merge their effects to produce desired choices.  Bots use two strategy categories: combat and non-combat, depending on combat status.  You can add, subtract, or toggle strategies using the combat and non-combat prefixes in your commands:

```
co +strategy1,-strategy2,~strategy3
nc +strategy1,-strategy2,~strategy3
```

You can query the bot to report what strategies are currently being used:

```
co ?
nc ?
```

You can issue orders and query the bot to report back the orders it received:

```
co +strategy1,-strategy2,~strategy3,?
nc +strategy1,-strategy2,~strategy3,?
```

### Non-Combat Orders

strategy | description
:---|:---|
``tank assist`` | assist party players (including other bots in party) by attacking the most threating target. This is single tanking stategy.
``tank aoe`` | Frequently switch target between targets. This is AOE tanking strategy. Note: some classes (paladin) will use aoe tanking abilities in combat so tank assist can have the same effect as tank aoe.
``dps assist`` | Assist party players by attacking more threated target. This is single dps stategy.
``dps aoe`` | Frequently switch target between less threated targets. This is AOE dps strategy. Note: some classes will use aoe dps abilities in combat so dps assist will do the same as dps aoe.
``attack weak`` | Always attack the weakest target (target having the least health points) and switch to other one if it is weaker than the current target.
``grind`` | Attack any visible target, then switch to another one and so on.

### Combat Orders

strategy | description
:---|:---|
``tank`` | bot will use threat-generating abilities. (warrior, paladin, and druid only)
``dps`` |  obvious, less threat, more dps. supported classes: rogue, hunter, druid, shaman, priest. for druid it also known as cat.
``heal`` | focus on party healing (shaman, druid, and priest only)
``frost``, ``fire`` | mage only
``bear``, ``cat``, ``caster`` | druid only
``bdps`` | buff dps (paladin will use seal of might)
``bspeed`` | buff movement speed (hunter only)
``bhealth``, ``bmana`` | buff health or mana (paladin will use seal of light vs seal of wisdom)
``rfire``, ``rfrost``, ``rshadow``, ``rnature`` | resistance stragegies (paladin auras and hunter aspects)

### Defaults

- Tank classes default w/ ``tank aoe``
- Non-tank classes default w/ ``attack weak``
- Strategies that are incompatible, such as ``stay`` and ``follow``, are ignored

## Movement

command | action
:---|:---
``follow`` | follow master
``stay`` | stay in place
``flee`` | flee with master (ignore everything else)
``d attack my target`` | attack my target
``d add all loot`` | check every corpse and game object for loot
``grind`` | attack anything

## Loot

You can control which items to loot (``ll`` stands for loot list):

command | action
:---|:---
``nc +loot`` | activate looting (note ``grind`` strategy activates looting as well)
``ll all`` | loot everything
``ll normal`` | loot anything except BOP (bind-on-pickup) items
``ll gray`` | loot only gray items
``ll quest`` |  loot only quest items
``ll skill`` | loot only items based on their skills (herbalism, mining, or skinning)
``ll [item]`` | add specific item to loot list
``ll -[item]`` | remove specific item from loot list

## Items

command | action
:---|:---
``e [item]`` | equip item
``ue [item]`` | unequip item
``u [item]`` | use item
``u [item] [target]`` | use item on target (use gem on item)
``destroy [item]`` | destroy item
``[item]`` | add to trade window if trading, show if it is useful
``2g 3s 5c`` | give you gold

## Quests

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

## Misc

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

## Reactions

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