extends "res://Scène principale/Gameboard/UnitOverlay.gd"

var board: Resource

func _ready():
	board =  load("res://Scène principale/Gameboard/Board.tres")
	board.connect("update_threat", Callable(self, "_on_update_threat"))


func _on_update_threat():
		clear()
		draw(board.threat.keys(),"rouge")
