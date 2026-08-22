extends Area3D

@export var fishing_3d_scene: PackedScene 
@onready var water_spawn_spot: Marker3D = $WaterSpawnPoint

@onready var result_box: PanelContainer = $"../CanvasLayer/ResultBox"
@onready var result_label: Label = $"../CanvasLayer/ResultBox/ResultLabel"

var currently_fishing: bool = false
var player_node: Node3D = null

func _ready() -> void:
	player_node = get_tree().root.find_child("proto_controller", true, false)
	if result_box:
		result_box.visible = false

func _process(_delta: float) -> void:
	if player_node == null:
		player_node = get_tree().root.find_child("proto_controller", true, false)
		return
		
	if currently_fishing:
		return

	var distance = global_position.distance_to(player_node.global_position)
	
	if distance < 4.0:
		if Input.is_action_just_pressed("interact"):
			cast_line()

func cast_line() -> void:
	currently_fishing = true
	print("E pressed! Spawning the bobber game...")
	
	var fishing_instance = fishing_3d_scene.instantiate()
	get_parent().add_child(fishing_instance) 
	fishing_instance.global_position = water_spawn_spot.global_position
	
	# Connect the signal from the mini-game
	fishing_instance.fishing_finished.connect(_on_fish_attempt_done)

func _on_fish_attempt_done(caught: bool) -> void:
	currently_fishing = false
	
	if caught:
		result_label.text = "🏆 FISH CAUGHT! 🐟"
		result_label.add_theme_color_override("font_color", Color.GREEN)
		result_box.visible = true
		await get_tree().create_timer(2.5).timeout
		result_box.visible = false
	else:
		result_label.text = "❌ THE FISH ESCAPED... 💨"
		result_label.add_theme_color_override("font_color", Color.RED)
		result_box.visible = true
		await get_tree().create_timer(2.5).timeout
		result_box.visible = false
