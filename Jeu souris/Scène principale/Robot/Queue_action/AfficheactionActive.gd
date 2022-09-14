extends Control

signal player_neutre()
signal move_player (valeur)
signal jump_player()
signal dash_player()
signal tir_tendu(ammo)
signal tir_courbe(ammo)
var balle_S = preload("res://Scène principale/Robot/Machines/Munitions/Balle_simple.tres")
var balle_L = preload("res://Scène principale/Robot/Machines/Munitions/Balle_lourde.tres")
var balle_P = preload("res://Scène principale/Robot/Machines/Munitions/Balle_paralysante.tres")
var action_active = null #variable en cours
var action_retenue = null #sert à stocker l'action retenue

func _on_FileAction_change_action(action, valeur): #quand on appuye sur la barre espace
	change_action(action, valeur)	#FileAction envoie le signal de changer l'action en une nouvelle action


func change_action (action : Resource,valeur :int): #fonction qui s'occupe du changement d'action principale
	emit_signal("player_neutre")	#reset l'état (envoyé à gameboard et à l'unit player
	
	if action == null :			#si action est nulle on nettoie l'affichage
		action_active = null
		$TextureRect.texture = null
		$Label.text = ""
	else :				#sinon on met à jour l'affichage
		action_active = action
		$TextureRect.texture = action.texture
		$Label.text = str(valeur)
		match action.name :
			"Mouvement" :	#selon l'action on envoie le signal adapté
				emit_signal("move_player", valeur)
			'Saut':
				emit_signal("jump_player")
			"Charge":
				emit_signal("dash_player")
			"Tir_tendu_simple":
				emit_signal("tir_tendu",balle_S)
			"Tir_tendu_lourd":
				emit_signal("tir_tendu",balle_L)
			"Tir_tendu_paralysant":
				emit_signal("tir_tendu",balle_P)
			"Tir_courbe_simple":
				emit_signal("tir_courbe",balle_S)
			"Tir_courbe_lourd":
				emit_signal("tir_courbe",balle_L)
			"Tir_courbe_paralysant":
				emit_signal("tir_tendu",balle_P)
				

func _on_GameBoard_player_moved(move_range_left): #met à jour l'affichage si le Player bouge
	$Label.text = str(move_range_left)
	if move_range_left == 0 :
		change_action(null,0)

func _on_GameBoard_player_jumped():			#met à jour l'affichage si le Player saute
	if $"Label".text == "1" :
		change_action(null,0)
		emit_signal("player_neutre")
	else :
		var valeur = int($"Label".text)
		$"Label".text = str(valeur -1)

func _on_GameBoard_player_dashed():
	if $"Label".text == "1" :
		change_action(null,0)
		emit_signal("player_neutre")
	else :
		var valeur = int($"Label".text)
		$"Label".text = str(valeur -1)

func _input(event):
	if event.is_action_pressed("maintenir action") :	#si on appuye sur la touche maintenir l'action
		var valeur_active = max(int($"Label".text),1)	#on récupère chaques valeurs associées aux actions
		var valeur_retenue = max(int($"Action_Retenue/Label".text),1)
		if not action_active == null :	#on met à jour l'affichage de l'action retenue
			$"Action_Retenue/Label".text = str(valeur_active)
			$"Action_Retenue/TextureRect".texture = action_active.texture
		else :
			$"Action_Retenue/Label".text = ""
			$"Action_Retenue/TextureRect".texture = null
		var stockage = action_retenue
		action_retenue = action_active		#on met à jour la variable adaptée
		change_action(stockage,valeur_retenue)# on change l'action pricipale

