extends Control

# Replace "res://Level1.tscn" with the exact path to your game level scene!
@export_file("game.tscn") var level_scene_path: String = "res://game.tscn"

func _ready() -> void:
	# Make sure the engine is unpaused when entering the main menu
	get_tree().paused = false

# This function will run when the Start Button is clicked
func _on_start_button_pressed() -> void:
	print("Start button clicked! Loading level...")
	
	# Change the scene to your level file
	var error = get_tree().change_scene_to_file('res://scene/game.tscn')
	
	# If something goes wrong, this will print an error code in the console
	if error != OK:
		print("Error: Could not load the scene. Check your file path! Error code: ", error)


func _on_pressed() -> void:
	get_tree().change_scene_to_file('res://scene/game.tscn')
	pass # Replace with function body.
