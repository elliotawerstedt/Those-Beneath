extends Node
## NarrativeManager (Autoload / Singleton)
##
## This script listens for gameplay facts (like "a fish was caught")
## and decides whether those facts mean something narratively.
## It does NOT print any text itself — it just decides WHAT happened
## and tells the EventBus. Your UI/text script (not included here)
## should listen to Events.story_event_triggered and print the actual
## story text for each event_id.
##
## Keeping "decide what happened" (this script) separate from
## "display it as text" (your UI script) means you can change your
## text presentation later without touching this logic at all.
##
## SETUP:
## 1. Save this file as res://autoload/narrative_manager.gd
## 2. Project -> Project Settings -> Autoload tab
## 3. Add this script (any Node Name is fine, e.g. "Narrative")
## 4. IMPORTANT: this script must be added to Autoload AFTER event_bus.gd,
##    since it needs "Events" to already exist. Autoloads load top to
##    bottom in the list, so make sure Events is above Narrative.


# --- Tunable thresholds -----------------------------------------------
# Adjust these numbers to fit your game's fish sizes / units.
const BIG_FISH_THRESHOLD: float = 8.0
const MASSIVE_FISH_THRESHOLD: float = 13.0


func _ready() -> void:
	# Hook ourselves up to the EventBus as soon as the game starts.
	Events.fish_caught.connect(_on_fish_caught)


## Called automatically whenever Events.fish_caught is emitted anywhere
## in the game (e.g. from fishing_button.gd).
func _on_fish_caught(fish_data: Dictionary) -> void:
	var size: float = fish_data.get("size", 0.0)

	# Check the biggest/most specific condition first, so a massive fish
	# doesn't ALSO trigger the "just big" event on the same catch.
	if size >= MASSIVE_FISH_THRESHOLD:
		Events.story_event_triggered.emit("massive_fish_catch")
	elif size >= BIG_FISH_THRESHOLD:
		Events.story_event_triggered.emit("big_fish_catch")
	else:
		Events.story_event_triggered.emit("normal_fish_catch")

	# You can add more checks here as your game grows, e.g.:
	# if fish_data.get("species", "") == "golden_carp":
	#     Events.story_event_triggered.emit("rare_species_catch")
	#
	# if fish_data.get("location", "") == "haunted_lake" and size >= BIG_FISH_THRESHOLD:
	#     Events.story_event_triggered.emit("haunted_lake_big_catch")
