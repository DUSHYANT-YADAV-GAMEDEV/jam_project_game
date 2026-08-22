extends Area3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Make sure it's the player touching the coin
	if body.name == "proto_controller":
		print("⭐ Pearl Collected!")
		
		# 1. Look for your DeliveryZone script where the UI text logic lives
		var delivery_manager = get_node_or_null("/root/game/DeliveryZone")
		
		if delivery_manager:
			# Increment your game score
			delivery_manager.boxes_delivered += 1
			
			# Force the UI on screen to refresh immediately so the player sees it!
			if delivery_manager.has_method("update_ui_display"):
				delivery_manager.update_ui_display()
		
		# 2. NOW it is safe to delete the coin from the world
		queue_free()
