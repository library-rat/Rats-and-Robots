extends HBoxContainer

@export (Array,String) var pointValeur = [null,null] #type des points
@export (Array,int) var ValeurMax = [null,null] #valeur max des points
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
