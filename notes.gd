extends RigidBody2D

@export var speed: float = 150.0

@onready var notifier = $VisibleOnScreenNotifier2D

#func _ready() -> void:

func _process(delta: float) -> void:
	position.y += speed * delta
#
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()








func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
