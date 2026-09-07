extends Node
## EventBus (Autoload / Singleton)
##
## This is a global "message board" for the whole game.
## Any script can EMIT a signal here (e.g. "a fish was caught")
## and any other script can LISTEN for it, without the two scripts
## needing to know about each other directly.
##
## SETUP:
## 1. Save this file as res://autoload/event_bus.gd (or wherever you keep it)
## 2. Project -> Project Settings -> Autoload tab
## 3. Add this script, make sure the "Node Name" is exactly: Events
## 4. Now from ANY script in your game you can call things like:
##      Events.fish_caught.emit(fish_data)
##    or connect to it like:
##      Events.fish_caught.connect(_on_fish_caught)


## Fired the moment a fish is reeled in, before any story logic runs.
## fish_data is a Dictionary, see fishing_button.gd for its shape.
signal fish_caught(fish_data: Dictionary)

## Fired whenever a narrative/story beat should play.
## event_id is just a string key like "big_fish_catch" that your
## text/UI script will use to look up which passage to print.
signal story_event_triggered(event_id: String)

## Fired once, the moment the player finishes clicking through the
## opening intro text. main.gd listens for this to swap from the
## intro screen to the main game UI.
signal intro_finished

## Optional generic signal for numeric stats changing (rod skill, money,
## number of fish caught today, etc). Handy to have from the start even
## if you don't use it yet.
signal stat_changed(stat_name: String, new_value)
