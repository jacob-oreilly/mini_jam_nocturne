extends Node2D

const NOTE = preload("res://notes.tscn")
const note_json = "res://assets/game_jam.json"
@onready var note_spawn_left: Marker2D = $NoteSpawnLeft
@onready var note_spawn_right: Marker2D = $NoteSpawnRight
@onready var player: AudioStreamPlayer = $Player
@onready var score: Label = $Score
@onready var note_timer: Timer = $NoteTimer
@onready var delay_at_end: Timer = $DelayAtEnd
@onready var left_hand_hit: AnimatedSprite2D = $LeftHit/left_hand_hit
@onready var right_hand_hit: AnimatedSprite2D = $RightHit/right_hand_hit
@onready var mini_candy: AnimatedSprite2D = $mini_candy
@onready var regular_candy: AnimatedSprite2D = $regular_candy
@onready var mega_candy: AnimatedSprite2D = $mega_candy
@onready var mini_candy_side: AnimatedSprite2D = $mini_candy_side
@onready var regular_candy_side: AnimatedSprite2D = $regular_candy_side
@onready var mega_candy_side: AnimatedSprite2D = $mega_candy_side

var rng = RandomNumberGenerator.new()
var leftHitEntered = false;
var rightHitEntered = false;
var left_note_body: RigidBody2D = null
var right_note_body: RigidBody2D = null
var scoreCount = 0;
var time_begin
var time_delay
var song_has_finished = false;
var songDict = {}
var songDictPos = 1;
var currentMidiNoteTime = 0;
var nextMidiNoteTime = 0;
var time_difference = 0;
var prev_random_number = 0;
var scoreMax = 0;
var mini_candy_recieved = false
var regular_candy_recieved = false
var mega_candy_recieved = false

func _init() -> void:
	songDict = load_json(note_json)
	scoreMax = songDict.size() - 1
	#print(songDict)

func _ready() -> void:
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	player.play()

func _process(delta: float) -> void:
	candyLevel(scoreCount, scoreMax)
	if Input.is_action_just_pressed("hit_left") and leftHitEntered:
		left_hand_hit.play()
		remove_child(left_note_body)
		print("left hit")
		leftHitEntered = false
		scoreCount += 1
		update_score(scoreCount)
	elif not Input.is_action_just_pressed("hit_left") and leftHitEntered:	
		left_note_body.get_node("NoteAnimation").play()

	if Input.is_action_just_pressed("hit_right") and rightHitEntered:
		right_hand_hit.play()
		remove_child(right_note_body)
		print("right hit")
		rightHitEntered = false
		scoreCount += 1
		update_score(scoreCount)
	elif not Input.is_action_just_pressed("hit_right") and rightHitEntered:
		right_note_body.get_node("NoteAnimation").play()

func _on_timer_timeout() -> void:
	note_timer_set()
	var randomNumber = rng.randi_range(1, 2)
	var nextNote = NOTE.instantiate()
	if randomNumber == 1:
		if randomNumber == prev_random_number and time_difference < 0.5:
			nextNote.global_position = note_spawn_right.global_position
			prev_random_number = 2
		else:
			nextNote.global_position = note_spawn_left.global_position
			prev_random_number = randomNumber
	elif randomNumber == 2:
		if randomNumber == prev_random_number and time_difference < 0.5:
			nextNote.global_position = note_spawn_left.global_position
			prev_random_number = 1
		else:
			nextNote.global_position = note_spawn_right.global_position
			prev_random_number = randomNumber
	add_child(nextNote)	


func _on_left_hit_body_entered(body: Node2D) -> void:
	left_note_body = body
	leftHitEntered = true;

func _on_right_hit_body_entered(body: Node2D) -> void:
	right_note_body = body
	rightHitEntered = true;


func _on_left_hit_body_exited(body: Node2D) -> void:
	leftHitEntered = false;

func _on_right_hit_body_exited(body: Node2D) -> void:
	rightHitEntered = false;
	
func update_score(scoreCount: int) -> void:
	score.text = str(scoreCount)

func _on_player_finished() -> void:
	delay_at_end.start()
	#get_tree().change_scene_to_file("res://game_end.tscn")


func _on_delay_at_end_timeout() -> void:
	get_tree().change_scene_to_file("res://game_end.tscn")


func note_timer_set() -> void:
	print(songDict.size())
	print(songDictPos - 2)
	print(songDict.size() > songDictPos - 2)
	if songDict.size() > songDictPos + 2:
		currentMidiNoteTime = float(songDict.get(str(songDictPos)))
		nextMidiNoteTime = float(songDict.get(str(songDictPos + 1)))
		time_difference = nextMidiNoteTime - currentMidiNoteTime - .1
		if time_difference > 0.0:
			note_timer.wait_time = time_difference
		songDictPos += 1
	else:
		note_timer.stop()


func candyLevel(scoreCount: int, scoreMax: int) -> void: 
	var mini_candy_score = float(scoreMax * 0.3)
	var reg_candy_score = float(scoreMax * 0.6)
	var mega_candy_score = float(scoreMax * 0.9)
	if mini_candy_score <= scoreCount and not mini_candy_recieved:
		mini_candy.fade_out_and_in(5.0)
		mini_candy_side.fade_in(1.0)
		mini_candy_recieved = true
	elif reg_candy_score <= scoreCount and not regular_candy_recieved:
		regular_candy.fade_out_and_in(5.0)
		regular_candy_side.fade_in(1.0)
		regular_candy_recieved = true
	elif mega_candy_score <= scoreCount and not mega_candy_recieved:
		mega_candy.fade_out_and_in(5.0)
		mega_candy_side.fade_in(1.0)
		mega_candy_recieved = true
func load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		print("Error: file not found at path: "+path)
		return{}
	
	var file = FileAccess.open(path, FileAccess.READ)
	
	if file == null:
		print("Error opening file: "+str(FileAccess.get_open_error()))
		return{}
	
	var content = file.get_as_text()
	
	var json_result = JSON.parse_string(content)
	
	if json_result is Dictionary:
		return json_result
	else:
		print("Error: Parsing JSON failed")
		return{}
