extends Node2D

const NOTE = preload("res://notes.tscn")
const note_json = "res://assets/game_jam.json"
@onready var note_spawn_left: Marker2D = $NoteSpawnLeft
@onready var note_spawn_right: Marker2D = $NoteSpawnRight
@onready var player: AudioStreamPlayer = $Player
@onready var score: Label = $Score
@onready var note_timer: Timer = $NoteTimer
@onready var delay_at_end: Timer = $DelayAtEnd

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

func _init() -> void:
	songDict = load_json(note_json)
	scoreMax = songDict.size() - 1
	#print(songDict)

func _ready() -> void:
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	player.play()

func _process(delta: float) -> void:
	# Obtain from ticks.
	var time = (Time.get_ticks_usec() - time_begin) / 1000000.0
	#print(time)
	# Compensate for latency.
	time -= time_delay
	# May be below 0 (did not begin yet).
	time = max(0, time)
	#print("Time is: ", time)
	if Input.is_action_just_pressed("hit_left"):
		if leftHitEntered:
			remove_child(left_note_body)
			print("left hit")
			leftHitEntered = false
			scoreCount += 1
			update_score(scoreCount)
		else:
			print("left miss")
	if Input.is_action_just_pressed("hit_right"):
		if rightHitEntered:
			remove_child(right_note_body)
			print("right hit")
			rightHitEntered = false
			scoreCount += 1
			update_score(scoreCount)
		else:
			print("right miss")
		

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
