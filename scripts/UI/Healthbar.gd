extends Control

@onready var healthbar = $Control/Health
@onready var magicbar = $Control/Magic
	
func _on_house_health_changed(curr_health, max_health):
	healthbar.value = curr_health / max_health * 100	

func _on_magic_changed(curr_magic, max_magic):
	magicbar.value = curr_magic / max_magic * 100	
	
func _on_day_passed(days_count):
	$DaysLabel.text = "Day " + str(days_count)
