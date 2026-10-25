extends ScrollContainer
## StoryLog
##
## A scrollable text log for narrative/story content. New lines get
## appended to the bottom and the view auto-scrolls to follow them,
## but the player can freely scroll up at any time to reread earlier
## text -- scrolling up doesn't get fought or reset by new lines.
##
## Built as a VBoxContainer of individual line nodes (rather than one
## giant RichTextLabel with all the text in it) specifically so that
## later you can mix in other node types -- like a Button -- as just
## another child in the same list, without changing this script.
##
## SETUP:
## 1. Add a ScrollContainer node to GameScreen, name it "StoryLog"
##    (or whatever you like), size/anchor it wherever you want the
##    textbox to sit on screen
## 2. Attach this script to it
## 3. Add a VBoxContainer as its child, named "LogContainer"
##    -- Layout -> Container Sizing -> Horizontal: check "Expand"
##       so lines wrap to the box width instead of overflowing
## 4. From anywhere else in your code, call:
##      $StoryLog.add_line("Some narrative text.")
##    (adjust the path to wherever your StoryLog node actually is)


@onready var log_container: VBoxContainer = $LogContainer


## Drag a font file (.ttf/.otf) or FontFile/FontVariation resource into
## this slot in the Inspector. Every new line will use it automatically.
## Leave empty to just use Godot's default font.
@export var story_font: Font

## Font size in pixels for each line. Adjust to taste.
@export var story_font_size: int = 16

## Delay between each character appearing, in seconds. Smaller = faster.
## Tune this in the Inspector until it feels right -- try 0.01-0.05.
@export var typing_speed: float = 0.01



func _ready() -> void:
	Events.print_text.connect(add_line)


## Appends one new line of text to the bottom of the log, typed out
## character by character, and keeps the view scrolled to follow it.
## Call this every time you want to add narrative text -- fishing
## results, story events, merchant dialogue, etc.
func add_line(text: String) -> void:
	## Flag to tell that something is currently being written here
	Global.is_narrating = true
	
	var line := RichTextLabel.new()
	line.text = text
	line.bbcode_enabled = true          # lets you use [i]...[/i] etc. later
	line.fit_content = true              # label grows to fit its text, no fixed height
	line.scroll_active = false           # this label itself shouldn't scroll -- the ScrollContainer handles that
	line.autowrap_mode = TextServer.AUTOWRAP_WORD
	line.visible_characters = 0           # start fully hidden, typewriter reveals it below

	if story_font:
		# "normal_font" covers plain text. RichTextLabel also has
		# "bold_font", "italic_font", "bold_italic_font", and "mono_font"
		# if you use those BBCode tags later and want them styled too.
		line.add_theme_font_override("normal_font", story_font)

	line.add_theme_font_size_override("normal_font_size", story_font_size)

	log_container.add_child(line)

	# Wait one frame so the new line's full size is calculated before we
	# scroll to it -- scrolling immediately would use the OLD (too-short)
	# content height and land in the wrong spot.
	await get_tree().process_frame
	_scroll_to_bottom()

	await _type_out_line(line)
	
	Events.narration_done.emit()

## Reveals a line's text one character at a time. Also nudges the scroll
## position down each character in case a long, wrapping line pushes
## content further than the initial scroll (e.g. a 4-line paragraph).
func _type_out_line(line: RichTextLabel) -> void:
	var total_chars := line.get_total_character_count()

	for i in range(total_chars + 1):
		line.visible_characters = i
		_scroll_to_bottom()
		await get_tree().create_timer(typing_speed).timeout


func _scroll_to_bottom() -> void:
	scroll_vertical = int(get_v_scroll_bar().max_value)
