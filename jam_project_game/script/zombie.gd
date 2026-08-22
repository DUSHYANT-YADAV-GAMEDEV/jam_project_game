extends CharacterBody3D

@export var speed: float = 3.0
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var player: CharacterBody3D = null

func _ready():
	# Find the player in the scene tree (assuming your player node is named "Player")
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float):
	if player:
		# Tell the navigation agent to target the player's position
		nav_agent.target_position = player.global_transform.origin
		
		if not nav_agent.is_navigation_finished():
			var next_position = nav_agent.get_next_path_position()
			var direction = (next_position - global_transform.origin).normalized()
			
			# Move towards the next path point
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			
			# Face the direction of movement (optional but looks better)
			if direction.length() > 0.1:
				look_at(Vector3(player.global_transform.origin.x, global_transform.origin.y, player.global_transform.origin.z), Vector3.UP)
		else:
			velocity.x = 0
			velocity.z = 0
			
	move_and_slide()
