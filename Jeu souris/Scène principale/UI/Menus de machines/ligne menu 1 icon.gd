extends HBoxContainer

@export var pointValeur : Array[String] = [""]#type des points (array de String)
@export var ValeurMax : Array[int] = [0]#valeur max des points (array de Int)
var Valeur
signal cout_point (type,index)

func _ready():
	Valeur = ValeurMax.duplicate()
	$Compteur.text = str(Valeur[0])


func _on_icon_pressed():
	emit_signal("cout_point", pointValeur[0],0)
