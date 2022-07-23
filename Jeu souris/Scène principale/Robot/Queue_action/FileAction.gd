extends VBoxContainer

var IconPlus = preload("res://Scène principale/Robot/Queue_action/IconPlus.png") 
var queue = []

func ajoute_action(action : Action) :
	queue.append(action)
	update_affichage()

signal change_action (action, valeur)

func enleve_action() :		#enlève l'action en tete de file et la met dans affiche action active
	if queue == [] :
		emit_signal("change_action", null, 0)
	else :
		var action = queue[0]
		var count = 0
		while (not queue == []) and queue[0] == action:
			count += 1
			queue.pop_front()
		emit_signal("change_action", action, count)
		update_affichage()

func update_affichage ():		#permet de mettre a jour la file graphique
	for i in range (1,10):		#en supprimant tout les objets présents initialement
		get_node("Afficheaction" + str(i) + "/TextureRect").texture = null
		get_node("Afficheaction" + str(i) + "/Label").text = ""
	var count = 1	#count représente à quel afficheur on est
	for num in range (queue.size()) :	#ajoute les objets dans la file graphique
		if count < 10 :		
			if num == 0 :	#pour le premier element on l'ajoute directement
				get_node("Afficheaction1/TextureRect").texture = (queue[0]).texture
			elif queue[num - 1] == queue[num] :	#pour les autres elements on voit si on a la meme action que avant
				var value = max(int(get_node("Afficheaction" + str(count) + "/Label").text),1)  #si oui on ajoute +1 au compteur
				get_node("Afficheaction" + str(count) + "/Label").text = str(value + 1)
			else :
				count += 1		#sinon on passe à l'afficheur d'après
				if count < 10 :#si on ne dépasse pas le cnombre d'afficheur on affiche l'action
					get_node("Afficheaction" + str(count) + "/TextureRect").texture = queue[num].texture
	if count == 10 : #si on a plus d'actions à afficher que d'afficheur on met le +
		$Afficheaction9/Label.text = ""
		$Afficheaction9/TextureRect.texture = IconPlus
