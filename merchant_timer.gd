extends Timer
## MerchantEncounterTimer
##
## A time-based trigger. After `wait_time` seconds of play, this fires
## a story event through the EventBus, exactly like fishing events do --
## the only difference is WHAT triggers it (a clock, not a fish catch).
##
## SETUP:
## 1. Add a Timer node to your main scene (e.g. named "MerchantEncounterTimer")
## 2. Attach this script to it
## 3. That's it -- wait_time, one_shot and autostart are all set in code
##    below so you don't have to configure them in the editor. If you'd
##    rather set them in the Inspector instead, just delete the three
##    lines in _ready() and set the matching properties on the node.
## 4. Run the scene, wait 15 seconds, check the Output console (assuming
##    story_console_listener.gd is still in the scene)


## How many seconds of play before the merchant shows up.
## Change this to tune pacing.
const TIME_UNTIL_MERCHANT: float = 15.0


func _ready() -> void:
	wait_time = TIME_UNTIL_MERCHANT
	one_shot = true      # fires once, not on a repeating loop
	autostart = true      # starts counting the moment the scene loads

	timeout.connect(_on_timeout)


func _on_timeout() -> void:
	# Just like fishing_button.gd, this script doesn't decide what the
	# story TEXT says -- it only reports that the moment has arrived.
	# Your UI/listener script decides what to actually print.
	Events.story_event_triggered.emit("merchant_approaches")

	# --- Optional extras once you build this out further ---
	#
	# If you want the merchant to only show up under certain conditions
	# (e.g. only if the player has caught at least one fish), you could
	# check a flag here before emitting, e.g.:
	#
	# if GameState.flags.get("has_caught_a_fish", false):
	#     Events.story_event_triggered.emit("merchant_approaches")
	# else:
	#     start()  # restart the timer and check again later
