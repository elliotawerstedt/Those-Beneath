extends Node
## Main
##
## The root of your game. Its only job right now is deciding which
## full-screen "screen" is visible: the intro, or the actual game UI.
## As your game grows, this is a natural place to add more screens
## (e.g. a title menu, a pause screen) using the same show/hide pattern.
##
## SETUP:
## 1. Attach this script to your root "Main" node
## 2. Make sure the node names below (IntroScreen, GameScreen) match
##    your actual child node names -- adjust the @onready paths if not
## 3. Set this scene as your Main Scene in Project Settings -> Application -> Run


@onready var intro_screen: Control = $IntroScreen
@onready var game_screen: Control = $GameScreen


func _ready() -> void:
	game_screen.visible = false
	intro_screen.visible = true

	Events.intro_finished.connect(_on_intro_finished)


func _on_intro_finished() -> void:
	# intro_sequence.gd already queue_frees itself, so we don't strictly
	# need to hide intro_screen too -- but setting this explicitly avoids
	# any single-frame flash where both screens might briefly overlap.
	intro_screen.visible = false
	game_screen.modulate.a = 0.0
	game_screen.visible = true
	
	#Fade in the game
	var fade_in := get_tree().create_tween()
	fade_in.tween_property(game_screen, "modulate:a", 1.0, 2)


	# This is a good place to kick off anything that should only start
	# once the player has actually entered the game, e.g. starting the
	# merchant encounter timer if you'd rather it not run during the intro:
	#
	# $GameScreen/MerchantEncounterTimer.start()
