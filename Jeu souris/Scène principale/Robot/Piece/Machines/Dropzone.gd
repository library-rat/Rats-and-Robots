extends Position2D
var libre = true
export (int) var numero_de_machine = 0
signal ouvrir_menu (numero)

func _draw ():
	draw_circle(Vector2.ZERO, 75, Color.blanchedalmond)
	
func select():
	emit_signal("ouvrir_menu",numero_de_machine)
	libre = false
	modulate = Color.webmaroon

func deselect():
	libre= true
	modulate = Color.white
