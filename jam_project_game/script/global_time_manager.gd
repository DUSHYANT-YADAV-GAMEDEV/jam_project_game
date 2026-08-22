extends Node

@export var day_duration_seconds: float = 40.0
var current_timer: float = 0.0
var is_transitioning: bool = false
var current_day: int = 1

func _ready() -> void:
	print("☀️ Global Time Manager Active! Starting on Day: ", current_day)

func _process(delta: float) -> void:
	if not is_transitioning:
		current_timer += delta
		
		# Trigger the transition cycle every 10 seconds
		if current_timer >= day_duration_seconds:
			is_transitioning = true
			advance_day()

func advance_day() -> void:
	current_day += 1
	current_timer = 0.0
	print("📅 Advancing to Day: ", current_day)
	
	# Locate your transition UI nodes automatically
	var transition_ui = get_node_or_null("/root/game/CanvasLayer2/DayTransitionUI")
	var day_label = get_node_or_null("/root/game/CanvasLayer2/DayTransitionUI/DayText")
	
	# Show the black transition screen and update the day text layout
	if transition_ui != null:
		transition_ui.visible = true
		if day_label != null:
			day_label.text = "DAY " + str(current_day)
	
	# 🚨 IF IT IS DAY 7: Load your Day 7 scene file directly!
	if current_day == 7:
		print("🎬 Day 7 reached! Loading Day 7 .tscn scene layout...")
		await get_tree().create_timer(1.5).timeout # Wait briefly for the black screen to mask the load
		
		# 💡 CRITICAL: Change "res://day7.tscn" to match your exact file path and name!
		var day7_scene_path = "res://scene/credits_final.tscn" 
		
		if ResourceLoader.exists(day7_scene_path):
			get_tree().change_scene_to_file(day7_scene_path)
		else:
			print("❌ Error: Cannot find your Day 7 scene file at: ", day7_scene_path)
			
	else:
		# Standard day cycle loop (Day 2, Day 3, Day 4, Day 5, Day 6)
		await get_tree().create_timer(3.5).timeout
		if transition_ui != null:
			transition_ui.visible = false
		is_transitioning = false
