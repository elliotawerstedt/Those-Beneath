extends Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("narration_done", start_timer)


func start_timer():
	start()


func _on_timeout() -> void:
	Global.is_narrating = false
