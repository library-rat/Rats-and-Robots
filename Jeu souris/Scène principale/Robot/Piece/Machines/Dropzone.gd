extends Position2D
var libre = true
export (int) var numero_de_machine
signal ouvrir_menu (numero,souris)

func _draw ():
	draw_circle(Vector2.ZERO, 75, Color.blanchedalmond)
	
func select(souris): #quand une souris arrive dans une nouvelle dropzone ouvre le menu
	emit_signal("ouvrir_menu",numero_de_machine,souris)
	libre = false
	modulate = Color.webmaroon

func deselect(): #deselection la souris quitte la dropzone
	libre= true
	modulate = Color.white
