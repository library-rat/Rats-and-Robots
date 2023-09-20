extends Resource

class_name Crew

var Liste : Dictionary  #Liste des souris de l'équipage

signal update_crew()

func register_mouse(mouse : Souris,machine) :
	Liste[machine] = mouse
	emit_signal("update_crew")

func swap_mouse (numero_machine, other_num):
	var mouse1 : Souris = Liste.get(numero_machine)
	var mouse2 : Souris = Liste.get(other_num)
	Liste.erase(numero_machine)
	Liste.erase(other_num)
	if mouse1 != null :
		mouse1.rest_point = other_num - 1
		Liste[other_num] = mouse1	
	if mouse2 != null :
		mouse2.rest_point = numero_machine -1
		Liste[numero_machine] = mouse2
	emit_signal("update_crew")

func change_mouse(mouse : Souris, new_machine : int) :
	Liste.erase(mouse.rest_point +1)
	Liste[new_machine] = mouse
	emit_signal("update_crew")

func get_mouse(machine : int):
		return Liste.get(machine)
