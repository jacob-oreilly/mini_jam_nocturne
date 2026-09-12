extends Node2D


func _ready() -> void:
	var timer = Timer.new()
	
	timer.wait_time = 2.0 
	timer.one_shot = true 
	timer.autostart = false 
	
	add_child(timer)
	
	timer.timeout.connect(_on_timer_timeout)
	
	# 5. Start the timer
	timer.start()

func _on_timer_timeout() -> void:
	print("Timer finished!")
	get_tree().change_scene_to_file("res://game_end.tscn")
	
