# PlayerBot Addon

In the private server world there was a guy named [Ike3](http://ike3.github.io/mangosbot-docs/) who wrote a bot script that would create robot players in the game.  You could have hundreds of them, and they would run around and fight and do quests and they would even use the Auction House.  You could party with them, and even better you could bring in your alts and play with them too.  It was amazing.

- The Ike module was originally written for Mangos
- He wrote an [addon](https://github.com/ike3/mangosbot-addon/tree/3.3.5a) package to help the player manage the bots ingame
- Efforts are underway to bring this module to AzerothCore, which is being called the [PlayerBot](https://github.com/ZhengPeiRu21/mod-playerbots) module
- I'm porting Ike's original addon package to make it functional w/ PlayerBot

This addon begins as a fork of Ike's original addon package.

## Status

It's kinda working, but not 100% yet.

## Install

Download this [zip](https://github.com/whipowill/wow-addon-playerbot/archive/master.zip) into your ``C:\\Games\WoW\Interface\Addons`` directory.

## Usage

Type `/bot` into the WoW chat bar to bring up the roster window.

![Screenshot](screenshots/bot_roster.png)

Click the icon next to the bot's name to bring up the control window.

![Screenshot](screenshots/bot_controls.png)

## Issues

- I am brand new to Lua coding and addon development, so with that said...

- The addon seems to be unable to use the ``SendAddonMessage()`` method, which is the method for the hidden addons channel for communications.  Maybe the bots on the server side aren't programmed to watch this channel?  I could only get this addon to work by sending bot commands over the party chat.

- The original addon code tries to combine multiple commands into a single line, but that wouldn't work for me.  I had to split up all the commands into individual lines and broadcast them one at a time.

## Bugs

- Team button "reduce Mana at expense of DPS" button to toggle off sends the right command, but visually doesn't toggle off.
- Loot strategies seem to have no effect.