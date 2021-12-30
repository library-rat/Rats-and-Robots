extends Position2D
var libre = true
export(String) var salle #sallle dans laquelle la machine est située
export (int) var numero_de_machine #numéro de la machine utilisé dans la liste du robot
signal assign_souris (numero,souris)
signal ouvrir_menu (numero)


func _draw ():
	draw_circle(Vector2.ZERO, 75, Color.blanchedalmond)
	
func select(souris): #quand une souris arrive dans une nouvelle dropzone ouvre le menu
	emit_signal("assign_souris",numero_de_machine,souris)
	libre = false
	modulate = Color.webmaroon

func deselect(): #deselection la souris quitte la dropzone
	libre= true
	if salle == "epauleg":
		modulate = Color.yellow
	if salle == "epauled" :
		modulate = Color.blue

func _on_Texture_gui_input(event):
	if Input.is_action_just_pressed("left click") :
		emit_signal("ouvrir_menu", numero_de_machine)
