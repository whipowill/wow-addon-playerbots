# Operator's Manual

The bots are programmed to respond to chat commands.  The game addon is designed to make issuing those chat commands easier for the player, and though the desire is to make the addon a comprehensive solution, you may still have need for manual chat commands as you play.

## Intro

Understand that there are two different types of bots available in the PlayerBots module.  There are alt bots, which are your characters from your account, and there are random bots, which are fake accounts created only to populate the world with random characters.  These two different types of bots have different rules for how they can be manipulated by you in the game.

## Commands

The following commands are meant to be put into the chat in either the party or raid channels.

### Party

command | action
:---|:---
``.playerbots bot add name1,name2,name3`` | login these alts
``.playerbots bot remove name1,name2,name3`` | logout these alts
``.playerbots bot add *`` |  login all alts
``.playerbots bot remove *`` | logout all alts
``.playerbots bot init=rare name1,name2,name3`` | respawn w/ your level, max talents, and rare gear (random bots only)

### Behavior

The bots are programmed to respond to triggers by listing possible actions and choosing one based on a strategy:

- trigger - something has occured
- action - something the bot can do
- stragegy - which action is the best action

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

Some strategies are incompatible with the others, such as ``stay`` and ``follow``.  If used, all other incompatible strategies will be deactivated.


category | prefix | strategy | description
:---|:---|:---|:---
non-combat | ``nc`` | ``tank assist`` | assist party players (including other bots in party) by attacking the most threating target. This is single tanking stategy.
|| ``tank aoe`` | Frequently switch target between targets. This is AOE tanking strategy. Note: some classes (paladin) will use aoe tanking abilities in combat so tank assist can have the same effect as tank aoe.
|| ``dps assist`` | Assist party players by attacking more threated target. This is single dps stategy.
|| ``dps aoe`` | Frequently switch target between less threated targets. This is AOE dps strategy. Note: some classes will use aoe dps abilities in combat so dps assist will do the same as dps aoe.
|| ``attack weak`` | Always attack the weakest target (target having the least health points) and switch to other one if it is weaker than the current target.
|| ``grind`` | Attack any visible target, then switch to another one and so on.
combat | ``co`` | ``tank`` | bot will use threat-generating abilities. supported classes: warrior, paladin and druid. for druid it also known as ``bear``
||``dps`` |  obvious, less threat, more dps. supported classes: rogue, hunter, druid, shaman, priest. for druid it also known as cat.
||``heal`` | focus on party healing other that damage or tanking. supported classes: shaman, priest.
||``frost``, ``fire`` | only for mages
|| ``bear``, ``cat``, ``caster`` | only for druids
|| ``bdps`` | buffs dps of self and other players. example: paladin will use seal of might.
|| ``bspeed`` | buffs movement speed. only for hunter - allows him to use aspect of the cheetach/pack when not in combat
|| ``bhealth``, ``bmana`` | buffs health or mana. example: paladin will use seal of light vs seal of wisdom.

resistance stragegies are some kind of buff strategies, but affects magic resistance so moved to separate group.
rfire, rfrost, rshadow, rnature - supported only for paladin auras and hunter aspects.

By default tank classes have tank aoe strategy, others have attack weak. This will result in tank holding the threat and dps damaging it, so the combat should be balanced. Anyway do attack action with a target selected will change bot mind and they switch to this target immediately. Althought with tank aoe and dps aoe strategies the bot will switch the target after some time.

### Movement

command | action
:---|:---
``follow`` | follow master
``stay`` | stay in place
``flee`` | flee with master (ignore everything else)
``d attack my target`` | attack my target
``d add all loot`` | check every corpse and game object for loot
``grind`` | attack anything

### Items

command | action
:---|:---
``e [item]`` | equip item
``ue [item]`` | unequip item
``u [item]`` | use item
``u [item] [target]`` | use item on target (use gem on item)
``destroy [item]`` | destroy item
``[item]`` | add to trade window if trading, show if it is useful
``2g 3s 5c`` | give you gold

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