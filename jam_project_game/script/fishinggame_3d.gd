extends Node3D

signal fishing_finished(caught: bool)

@onready var moving_ring: MeshInstance3D = $Ring
@onready var target_ring: MeshInstance3D = $TargetRing

# We start the ring size larger so it can shrink inward
var ring_scale: float = 3.0
var shrink_speed: float = 1.5

# The winning target zone (adjust these if catching feels too hard or easy!)
var target_success_zone_min: float = 0.6
var target_success_zone_max: float = 1.4

func _ready() -> void:
	print("🟢 Mini-game bobber spawned! Moving ring found: ", moving_ring != null)

func _process(delta: float) -> void:
	# 1. Shrink the ring size scale over time
	ring_scale -= shrink_speed * delta
	
	# If the ring shrinks past zero completely and you didn't click, you lose!
	if ring_scale <= 0.1:
		print("⏱️ Time ran out! The ring shrunk away completely.")
		fail_fishing()
		return
		
	# 2. Update the actual 3D scale values on screen
	if moving_ring != null:
		moving_ring.scale = Vector3(ring_scale, ring_scale, ring_scale)
		
	# 3. Listen intently for your second E keypress to register your catch!
	if Input.is_action_just_pressed("interact"):
		print("🎣 E pressed! Checking timing... Current ring size scale is: ", ring_scale)
		check_catch_success()

func check_catch_success() -> void:
	# Check if your timing falls within the green win window limits
	if ring_scale >= target_success_zone_min and ring_scale <= target_success_zone_max:
		win_fishing()
	else:
		print("❌ Wrong timing! Missed the window.")
		fail_fishing()

func win_fishing() -> void:
	print("🏆 WIN: Signal sending out to the UI...")
	fishing_finished.emit(true)
	queue_free() # Deletes rings from water immediately

func fail_fishing() -> void:
	print("💨 LOSE: Signal sending out to the UI...")
	fishing_finished.emit(false)
	queue_free() # Deletes rings from water immediately
