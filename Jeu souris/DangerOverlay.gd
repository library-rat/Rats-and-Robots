extends UnitOverlay

var board: Resource

func _ready():
	board =  load("res://Scène principale/Gameboard/Board.tres")
	board.connect("update_threat", Callable(self, "_on_update_threat"))
	draw(1, [Vector2i(0,0),Vector2i(1,0)], "rouge")
	

func _on_update_threat():
		clear()
		draw(0,board.threat.keys(),"rouge")
