extends ProgressBar


## Flag for enablind/disabling madness gain 
var madness_allowed = false



func _ready() -> void:
	Events.connect("can_get_madness", make_madness_available) # Is emitted when the players can get madness
	visible = false


func make_madness_available():
	fade_in()
	
	visible = true
	madness_allowed = true
	Global.first_abomination_caught = true


func fade_in():
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 10.0)
