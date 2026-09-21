extends Button
## FishingButton
##
## Attach this script to a Button node in your scene (e.g. a "Cast / Reel In"
## button). When clicked, it "catches" a fish with a random size and reports
## it to the EventBus. It does NOT decide whether the fish is big — that
## job belongs to narrative_manager.gd. This script only knows about fishing,
## nothing about story logic. That separation is the whole point.
##
## SETUP:
## 1. Add a Button node to your scene (e.g. named "FishButton")
## 2. Attach this script to it
## 3. Make sure event_bus.gd and narrative_manager.gd are set up as
##    Autoloads first (see comments in those files)
## 4. Run the scene and click the button — check the Output console


func _ready() -> void:
	# Connect the button's own "pressed" signal to our handler.
	# (You can also do this by hand in the editor via the Node tab,
	# but connecting in code keeps everything in one place.)
	pressed.connect(_on_pressed)


func _process(_delta: float) -> void:
	## Can't catch fish if there's currently storytelling
	if Global.is_narrating == true:
		disabled = true
	else:
		disabled = false


func _on_pressed() -> void:
	Global.times_fished += 1 # Fishing counter
	
	# Triggers one time after fished a certain amount of times
	if Global.times_fished > 2 and Global.first_abomination_caught == false:
		Events.can_get_madness.emit()
		Events.story_event_triggered.emit("first_abomination_caught")
		return

	catch_fish()


## The actual "fishing" logic. Replace the random range / species list
## with your own systems later (rod stats, bait type, location, luck, etc).
func catch_fish() -> void:
	var possible_species := ["trout", "bass", "catfish", "pike", "eel"]

	var fish_data := {
		"species": possible_species.pick_random(),
		"size": randf_range(0.5, 15.0),  # kg -- tune to taste
		"location": "the old dock",       # swap for a real location variable later
	}

	# Round size to 1 decimal just so console output looks tidy.
	fish_data.size = snapped(fish_data.size, 0.1)

	print("You caught a %s weighing %.1f kg." % [fish_data.species, fish_data.size])

	# Hand the fact off to the EventBus. We don't check the size here —
	# narrative_manager.gd is responsible for deciding if it's a big deal.
	Events.fish_caught.emit(fish_data)
