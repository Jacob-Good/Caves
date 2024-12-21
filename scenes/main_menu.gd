extends CanvasLayer

@onready var flashing_label = $Control/Label

var flashing : bool = true

func _on_timer_timeout():
	if flashing_label.visible == true:
		flashing_label.visible = false
	else:
		flashing_label.visible = true


func start_flashing():
	$FlashingTimer.start()
	
func stop_flashing():
	$FlashingTimer.stop()
	flashing_label.visible = false
	flashing = false
