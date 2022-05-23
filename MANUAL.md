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
- strategy - what is the best action

Strategies can be combined, so they merge their effects to produce desired choices.  Bots use two categories of strategies: combat and non-combat.  You can add, subtract, or toggle strategies using the combat and non-combat prefixes in your commands:

```
co +strategy1,-strategy2,~strategy3
nc +strategy1,-strategy2,~strategy3
```

You can query the bot to report what strategies are currently being used:

```
co ?
nc ?
```

You can issue orders and query the bot to report back at the same time:

```
co +strategy1,-strategy2,~strategy3,?
nc +strategy1,-strategy2,~strategy3,?
```

### Combat Strategies

strategy | description
:---|:---|
``tank`` | use threat-generating abilities (warrior, paladin, druid will use ``bear``)
``dps`` |  use dps abilities (rogue, hunter, shaman, priest, druid will use ``cat``)
``caster`` | wasn't in docs but is in game
``assist`` | target one mob at a time
``aoe`` | target many mobs at a time
``grind`` | attack any visible target, then switch to another one and so on.
``heal`` | focus on party healing (shaman, priest, druid)
``frost``, ``fire`` | mage only
``bear``, ``cat``, ``caster`` | druid only
``bdps`` | buff dps (paladin will use seal of might)
``bspeed`` | buff movement speed (hunter only)
``bhealth``, ``bmana`` | buff health or mana (paladin will use seal of light vs seal of wisdom)
``rfire``, ``rfrost``, ``rshadow``, ``rnature`` | resistance stragegies (paladin auras and hunter aspects)

### Non-Combat Strategies

strategy | description
:---|:---

### Defaults

- Tank classes default w/ ``tank aoe``
- Non-tank classes default w/ ``attack weak``
- Strategies that are incompatible, such as ``stay`` and ``follow``, are ignored

## Movement

I think these commands can be used indepedently or as of ``co`` and ``nc`` strategies:

command | action
:---|:---
``grind`` | attack anything
``follow`` | follow master
``stay`` | stay in place
``flee`` | flee with master (ignore everything else)
``runaway`` | kite mob

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
``[item]`` | bot will tell you how many it has, and quest status
``e [item]`` | equip item
``ue [item]`` | unequip item
``u [item]`` | use item
``u [item] [target]`` | use item on target (use gem on item)
``destroy [item]`` | destroy item
``s [item]`` | sell item
``s *`` | sell all grey items
``b [item]`` | buy item
``2g 3s 5c`` | give you gold
``bank [item]`` | deposit item in bank
``bank -[item]`` | withdraw item from back
``gb [item]`` | deposit item in guild bank
``gb -[item]`` | withdraw item from guild bank

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

## Overrides

You can override everything and instruct the bot to do something specific:

command | description
:---|:---|
``do attack`` | attack target
``do loot`` | loot target
``do attack my target`` | attack my target
``do add all loot`` | check every corpse and game object for loot

## Example Macros

To make bots flee with you from the danger:

```
/p reset
/p nc -stay,+follow,+passive
/p co +passive
/p do follow
```

To make bots follow you and assist you in attack:

```
/p nc -stay,+follow,-passive
/p co -passive
/p do follow
```

To make bots stay in place and assist you in attack:

```
/p nc -follow,+stay,+passive
/p co +passive
/p do stay
```

## Help

The bot can tell you all available commands it will accept:

```
/w help
```

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