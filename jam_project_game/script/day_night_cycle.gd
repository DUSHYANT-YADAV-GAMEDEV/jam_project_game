extends Node3D

@onready var sun: DirectionalLight3D = $"../Sun"

# --- AUTOMATIC DAY TIMER SETTINGS ---
@export var day_duration_seconds: float = 40.0 # How long a single day lasts before forcing the next day
var current_timer: float = 0.0
var has_triggered_transition: bool = false

# --- UI PATHS ---

# --- UI PATHS ---
# Absolute paths looking straight into your nested canvas setup
@onready var transition_ui: ColorRect = $"/root/game/CanvasLayer2/DayTransitionUI"
@onready var day_text_label: Label = $"/root/game/CanvasLayer2/DayTransitionUI/DayText"

func _ready() -> void:
	if sun != null:
		# Safer method: reset rotation and point it diagonally downward
		sun.rotation = Vector3.ZERO
		sun.rotate_x(deg_to_rad(-55)) # Angle down toward the village
		sun.rotate_y(deg_to_rad(45))  # Diagonally cross-lighting
		
		sun.visible = true
		print("☀️ Sun initialized safely!")
	else:
		print("Warning: Could not find the 'Sun' node in the scene tree path!")
	print("⏳ Day Timer Started! You have ", day_duration_seconds, " seconds before the day ends.")

func _process(delta: float) -> void:
	# If we already triggered the end of the day, stop counting down so it doesn't run twice
	if has_triggered_transition:
		return
		
	# Count up the active gameplay time
	current_timer += delta
	
	# Once the time limit is reached, automatically force the next day!
	if current_timer >= day_duration_seconds:
		has_triggered_transition = true
		auto_advance_day()

func auto_advance_day() -> void:
	print("⏰ Time's up! Automatically transitioning to the next day...")
	
	if transition_ui != null and day_text_label != null:
		# Pass the UI elements directly to your global manager to handle the scene swap
		GlobalTimeManager.advance_to_next_day(transition_ui, day_text_label)
	else:
		print("Error: Could not find DayTransitionUI or DayText nodes! Check your @onready paths at the top.")
