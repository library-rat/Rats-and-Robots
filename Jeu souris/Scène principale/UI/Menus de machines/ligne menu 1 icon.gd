extends HBoxContainer

export (Array,String) var pointValeur = [null] #type des points
export (Array,int) var ValeurMax = [null] #valeur max des points
var Valeur
signal cout_point (type,index)

func _ready():
	Valeur = ValeurMax.duplicate()
	$Compteur.text = str(Valeur[0])


func _on_icon_physique_pressed():
	emit_signal("cout_point", pointValeur[0],0)
