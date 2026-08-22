extends Area3D

var boxes_delivered: int = 0
@export var total_boxes_needed: int = 3

# Oxygen game variables
var oxygen_left: float = 10.0
var is_underwater: bool = false
var player_node: Node3D = null

var ui_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	is_underwater = false
	oxygen_left = 10.0
	
	# Spawn a text label inside CanvasLayer2 dynamically
	var canvas = get_node_or_null("/root/game/CanvasLayer2")
	if canvas:
		ui_label = Label.new()
		canvas.add_child(ui_label)
		ui_label.position = Vector2(50, 50) 
		ui_label.add_theme_font_size_override("font_size", 28)
		
	update_ui_display()

func _process(delta: float) -> void:
	if is_underwater:
		oxygen_left -= delta
		update_ui_display()
		
		if oxygen_left <= 0:
			trigger_drown_respawn()

func _on_body_entered(body: Node3D) -> void:
	if body.name.begins_with("CargoBox"):
		boxes_delivered += 1
		update_ui_display()
		check_win_condition()

func _on_body_exited(body: Node3D) -> void:
	if body.name.begins_with("CargoBox"):
		boxes_delivered -= 1
		update_ui_display()

func start_oxygen_meter(incoming_player: Node3D) -> void:
	player_node = incoming_player
	is_underwater = true

func stop_oxygen_meter() -> void:
	is_underwater = false
	oxygen_left = 10.0 
	update_ui_display()
func update_ui_display() -> void:
	if ui_label:
		if is_underwater:
			# Only show oxygen line if we are actively swimming!
			ui_label.text = "📦 Cargo: " + str(boxes_delivered) + " / " + str(total_boxes_needed) + \
			"\n🫁 OXYGEN: " + str(ceili(oxygen_left)) + "s"
		else:
			# On land, this completely erases line 2 so oxygen disappears!
			ui_label.text = "📦 Cargo: " + str(boxes_delivered) + " / " + str(total_boxes_needed)
func check_win_condition() -> void:
	if boxes_delivered >= total_boxes_needed:
		if ui_label:
			ui_label.text = "🎉 MINI-GAME COMPLETE! +100 Gold"
			ui_label.add_theme_color_override("font_color", Color.GOLD)

func trigger_drown_respawn() -> void:
	is_underwater = false
	oxygen_left = 10.0
	print("💀 Out of air! Teleporting...")
	
	# If we don't have a player saved, let's find it in your scene tree automatically!
	if player_node == null:
		player_node = get_node_or_null("/root/game/proto_controller")
	
	# If your player has a different path, this looks for any node with 'controller' in its name
	if player_node == null:
		for child in get_node("/root/game").get_children():
			if "controller" in child.name.to_lower() or "player" in child.name.to_lower():
				player_node = child
				break

	# NOW move the player back onto the dock safely
	if player_node:
		# Pushes the character to these exact X, Y, Z coordinates
		player_node.global_position = Vector3(0, 5, 0) 
		
		# Reset their falling velocity so they don't keep sinking through the floor
		if "velocity" in player_node:
			player_node.velocity = Vector3.ZERO
		if "linear_velocity" in player_node:
			player_node.linear_velocity = Vector3.ZERO
			
	update_ui_display()
