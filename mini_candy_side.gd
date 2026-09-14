extends AnimatedSprite2D


func fade_in(duration: float = 1.0) -> void:
	var tween = create_tween()
	
	tween.tween_interval(5)
	
	# Fade in (alpha goes back to 1.0)
	tween.tween_property(self, "modulate:a", 1.0, duration / 2.0)
	
