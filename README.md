# PlayerBots Addon

In the WoW private server community there was a guy named [ike3](http://ike3.github.io/mangosbot-docs/) who wrote a bot script that would create robot players in the game.  You could have hundreds of them, and they would run around and fight and do quests, you could party w/ them, and even better you could bring your alts and play with them too.

### Features

- Finest bot control using chat commands
- Hundreds of bots spread around the world at any time waiting for your invitation or dungeon finder
- More than 100 chat commands to interact with the bots
- More than 30 strategies to choose from
- Improved auction house bot with bots as bidders and market price calculations
- Structured and simple source code.

### Possibilities

- Inviting bots to party (or using the Dungeon Finder) and playing dungeon, raid or doing some PvP
- Summoning your alts as bots to quick item exchange, casting some spells, buffing, leveling, crafting, etc.
- Random PVP with bots of opposite faction or dueling with bots from your faction
- Trading and auctioning
- Making World of Warcraft even a completely single-player game!

Efforts are underway to port this bot code to [AzerothCore](http://www.azerothcore.org) via the [PlayerBots](https://github.com/ZhengPeiRu21/mod-playerbots) module.  This repository is an addon project that will facilitate managing the bots by the player ingame.  It begins as a fork of ike3's [original](https://github.com/ike3/mangosbot-addon) addon package which he developed for the Mangos project.

## Install

Download this [zip](https://github.com/whipowill/wow-addon-playerbot/archive/master.zip) into your ``C:\\Games\WoW\Interface\Addons\PlayerBots`` directory.

## Usage

Type `/bot` into the WoW chat bar to bring up the roster window.

![Screenshot](screenshots/bot_roster.png)

Click on the bot character, making him your target, to bring up the control window.

![Screenshot](screenshots/bot_controls.png)

## Changelog

- Minor edits to original code to work w/ PlayerBots.
- SelectedBotPanel only shows if RosterPanel is already open.

## References

- [ike3's Initial Announcement](https://www.getmangos.eu/forums/topic/5401-ai-playerbot/)