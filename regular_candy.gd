extends AnimatedSprite2D



func fade_out_and_in(duration: float = 1.0) -> void:
	var tween = create_tween()
	
	# Fade in (alpha goes back to 1.0)
	tween.tween_property(self, "modulate:a", 1.0, duration / 2.0)
	
	# Fade out (alpha goes to 0.0)
	tween.tween_property(self, "modulate:a", 0.0, duration / 2.0)
	
