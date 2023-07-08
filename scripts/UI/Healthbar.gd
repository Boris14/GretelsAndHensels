extends Control

@onready var progress_bar = $TextureProgressBar
	
func _on_house_health_changed(curr_health, max_health):
	progress_bar.value = curr_health / max_health * 100	
