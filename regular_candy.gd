extends AnimatedSprite2D



func fade_out_and_in(duration: float = 1.0) -> void:
	var tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 1.0, duration / 2.0)
	
	tween.tween_property(self, "modulate:a", 0.0, duration / 2.0)
	
