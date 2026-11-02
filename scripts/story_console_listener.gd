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
	#BBCODE: [i][/i] [b][/b] [color=red][/color]
	var passages := {
		"normal_fish_catch": "A decent catch. Nothing to write home about.",
		"big_fish_catch": "The line strains -- this one's bigger than usual. Your heart pounds as you haul it in.",
		"massive_fish_catch": "The rod nearly bends double. Whatever's on the other end, it's enormous -- maybe the biggest thing you've ever pulled from this water.",
		
		"intro_line": "Same spot, same hour. Some things you can count on. [THOUGHT] A fisherman who does not fish is only a man standing near water.",
		"a_normal_start": "A small perch on the very first cast. \nYou turn it over in your hand, grey-green and striped and perfectly ordinary, and drop it back. \nYour thermos is still warm. A good start. \n[THOUGHT] Slow morning. \nJust how you like them.",
		#"filler": "FILLER"
		"first_abomination_caught": "\nThe line goes heavy, then strangely light. \nWhat comes up is a fish, mostly. Pale as candle wax, ribs showing through its skin like the hull of a boat. Too many teeth, and they are in the wrong places.\nIt is still breathing. Slowly, as if it is thinking about it.\n[THOUGHT] A deformity. Pollution, maybe. You have read about this.\nYou put it in the bucket. You are not sure why you did not throw it back.\n",
		"the_bucket": "The abomination lies in the bucket, and you keep glancing at it. It has not moved, but you have the impression that it is watching the lid. The next catch is a perfectly normal roach. You are absurdly pleased by it. [THOUGHT] See? Normal. It was a fluke.",
		}


	var text: String = passages.get(event_id, "Something happens, but you're not sure what.")
	Events.print_text.emit("[STORY EVENT: %s] %s" % [event_id, text])
	print("[STORY EVENT: %s] %s" % [event_id, text])
