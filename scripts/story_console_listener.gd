extends Node
## StoryConsoleListener (temporary/demo script)
##
## This is NOT meant to be your final text UI -- it's a minimal example
## so you can see the whole chain working end to end right now:
##   button click -> fish_caught -> narrative_manager decides -> story_event_triggered
##   -> THIS script prints the result to the console.
##
## Once you build your real black-background/white-text UI, replace this
## script's "print" calls with whatever prints text to your on-screen
## text box / label / RichTextLabel instead.
##
## SETUP:
## 1. Add an empty Node to your main scene (e.g. named "StoryConsoleListener")
## 2. Attach this script to it
## 3. Run the scene, click your fishing button, watch the Output console



func _ready() -> void:
	Events.story_event_triggered.connect(_on_story_event_triggered)


func _on_story_event_triggered(event_id: String) -> void:
	# A simple lookup table mapping event_id -> narrative text.
	# In your real game this will probably live in its own resource/file
	# per event, but this shows the idea for now.
	var passages := {
		"normal_fish_catch": "A decent catch. Nothing to write home about.",
		"big_fish_catch": "The line strains -- this one's bigger than usual. Your heart pounds as you haul it in.",
		"massive_fish_catch": "The rod nearly bends double. Whatever's on the other end, it's enormous -- maybe the biggest thing you've ever pulled from this water.",
		"merchant_approaches": "A weathered figure trudges down the dock toward you, eyeing your catch. \n Selling today?",
		"first_abomination_caught": "\".....what.....what the hell is that?\" \n At the end of the line is some kind of disfigured fish. Nothing like anything you've seen before. \n You are disgusted by this cursed creature. \n As you touch the slimy creature you feel a small rush go up your spine and into your head. \n You throw it back into the black water. \n ....a small part of you wants to catch another one.",
	}

	var text: String = passages.get(event_id, "Something happens, but you're not sure what.")
	Events.print_text.emit("[STORY EVENT: %s] %s" % [event_id, text])
	print("[STORY EVENT: %s] %s" % [event_id, text])
