extends HBoxContainer

@export var pointValeur : Array[String] = ["",""] #type des points
@export var ValeurMax : Array[int] = [0,0] #valeur max des points
var Valeur
signal cout_point (type,index)

func _ready():
	Valeur = ValeurMax.duplicate()
	$"cout 1".text = str(Valeur[0])
	$"cout 2".text = str(Valeur[1])

func update_affichage ():
	$"cout 1".text = str(Valeur[0])
	$"cout 2".text = str(Valeur[1])
	
func _on_icon_1_pressed():
	emit_signal("cout_point", pointValeur[0], 0)


func _on_icon_2_pressed():
	emit_signal("cout_point",pointValeur[1],1)
