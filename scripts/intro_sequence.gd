extends Control
## IntroSequence
##
## Shows a series of text passages one at a time. Clicking anywhere
## advances to the next line. When the last line has been shown and
## the player clicks once more, this emits a signal so the rest of
## the game knows to switch from the intro to the main UI.
##
## SETUP:
## 1. Attach this script to your IntroScreen Control node
## 2. Make sure IntroScreen fills the whole viewport (Layout -> Full Rect)
## 3. Give it a child RichTextLabel named "IntroLabel" (also Full Rect),
##    white text color, "Autowrap Mode" set to Word, and probably some
##    margin/padding so text isn't touching the screen edges
## 4. Give it a child ColorRect named "Background" (Full Rect, black)
##    -- make sure Background is ABOVE IntroLabel in the tree order
##    so the label draws on top of it, not behind it
## 5. Fill in the `intro_lines` array below (or set it in the Inspector,
##    since it's an @export) with your actual story text
## 6. Set Mouse Filter on IntroScreen to "Stop" so clicks are caught here
##    instead of passing through to whatever's underneath


## The passages of intro text, shown one at a time in order.
## Edit these directly, or set them in the Inspector instead.
@export var intro_lines: Array[String] = [
	"The dock creaks beneath your boots.",
	"Grey water stretches out to a greyer horizon.",
	"You don't remember how long you've been coming here.",
	"Click to begin.",
]

## Reference to the RichTextLabel child that displays the current line.
## Adjust the path below if your node is named differently.
@onready var label: RichTextLabel = $IntroLabel


var _current_index: int = 0
var _is_animating: bool = false


func _ready() -> void:
	# Show the first line immediately when the game starts.
	# No fade-out needed since there's no previous text to fade away.
	label.text = intro_lines[_current_index]
	label.modulate.a = 1.0


## Godot calls this automatically for any input event that happens
## over this Control, as long as Mouse Filter isn't set to "Ignore".
func _gui_input(event: InputEvent) -> void:
	if _is_animating:
		return  # ignore clicks while a fade is already playing

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_advance()


func _advance() -> void:
	_current_index += 1

	if _current_index >= intro_lines.size():
		_finish_intro()
	else:
		_display_current_line()


func _display_current_line() -> void:
	_is_animating = true

	# Fade the current text out (alpha 1 -> 0).
	var fade_out := get_tree().create_tween()
	fade_out.tween_property(label, "modulate:a", 0.0, 0.3)
	await fade_out.finished

	# Swap the text while it's invisible, then fade it back in (0 -> 1).
	label.text = intro_lines[_current_index]

	var fade_in := get_tree().create_tween()
	fade_in.tween_property(label, "modulate:a", 1.0, 0.3)
	await fade_in.finished

	_is_animating = false


func _finish_intro() -> void:
	# Fade the current text out (alpha 1 -> 0).
	var fade_out := get_tree().create_tween()
	fade_out.tween_property(label, "modulate:a", 0.0, 1.5)
	await fade_out.finished
	
	await get_tree().create_timer(2).timeout
	
	# Tell the rest of the game the intro is done. main.gd listens for
	# this and swaps the visible screen -- this script doesn't need to
	# know anything about the main game UI to do that.
	Events.intro_finished.emit()

	# Remove the intro screen entirely so it stops catching clicks.
	# (main.gd will also hide it, but queueing it free is a clean way
	# to make sure it never lingers or accidentally reappears.)
	queue_free()
