extends Control

@onready var final_score: Label = $FinalScore
@onready var mini_candy: Sprite2D = $MiniCandy
@onready var regular_candy: Sprite2D = $RegularCandy
@onready var mega_candy: Sprite2D = $MegaCandy



func _ready() -> void:
	final_score.text = str(Global.finalScore) + " / " + str(Global.scoreMax)
	if Global.hasMiniCandy:
		mini_candy.visible = true
	if Global.hasRegularCandy:
		regular_candy.visible = true
	if Global.hasMegaCandy:
		mega_candy.visible = true
	

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
