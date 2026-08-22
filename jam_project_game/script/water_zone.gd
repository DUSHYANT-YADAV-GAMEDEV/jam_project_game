extends Area3D

@onready var main_game_manager = get_node_or_null("/root/game/DeliveryZone") 

func _ready() -> void:
	body_entered.connect(_on_water_entered)
	body_exited.connect(_on_water_exited)

func _on_water_entered(body: Node3D) -> void:
	# Checks if the body name contains "player" or "proto_controller"
	if "player" in body.name.to_lower() or "controller" in body.name.to_lower():
		if main_game_manager:
			main_game_manager.start_oxygen_meter(body)

func _on_water_exited(body: Node3D) -> void:
	if "player" in body.name.to_lower() or "controller" in body.name.to_lower():
		if main_game_manager:
			main_game_manager.stop_oxygen_meter()
