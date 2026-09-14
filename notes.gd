extends RigidBody2D

@onready var notifier = $VisibleOnScreenNotifier2D
@export var distance = 190
@export var bpm = 140.0
var speed: float = 150.0

func _init() -> void:
	speed = distance / (60.0 / bpm)
	#print(distance / speed)
#func _ready() -> void:
	
func _process(delta: float) -> void:
	
	position.y += speed * delta
#
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
