extends VBoxContainer

var IconPlus = preload("res://Scène principale/Robot/Queue_action/IconPlus.png") 
var queue = []

func ajoute_action(action : Action) :
	queue.append(action)
	if queue.size() <= 10 :
		update_affichage()

func enleve_action() :
	queue.remove(0)
	if queue.size() <= 10 :
		update_affichage()
	

func update_affichage ():
	for i in range (1,10):
		get_node("Afficheaction" + str(i) + "/TextureRect").texture = null
	for i in range ( min(9,queue.size())):
		get_node("Afficheaction" + str(i + 1)).update_action(queue[i])
	if queue.size() > 9 :
		$Afficheaction9/TextureRect.texture = IconPlus
