extends Sprite2D
var page = 0
signal book_closed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func on_book_closed():
	emit_signal("book_closed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	$pivot/book/Anim.play("turn_cover" if page == 0 else "turn_page_1" if page == 1 else "end_book")
	page += 1
	pass # Replace with function body.
