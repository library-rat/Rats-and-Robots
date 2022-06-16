extends Panel
var Souris 

func afficher_menu(souris) :
	visible = true
	Souris = souris
	$"Panel/Grille de points".rafraichir_affichage(Souris.Points)

func _on_FermeMenu_pressed():
	visible = false

func test_souris_stat (stat) : #permet de tester si une souris a des points
	var sumCalc = Souris.Calcul+Souris.CLock
	var sumEndu = Souris.Endurance + Souris.ELock
	if stat =="Endurance" :
		if Souris.Endurance > 0 : #si la souris a des points en endurance
			Souris.Endurance -= 1
			Souris.ELock += 1#un point est alors transformé en pt bloqué
			Souris.Points[sumCalc+ Souris.Endurance] = Souris.EnduranceLockPt #modifie un point dans la liste de Points de la souris
			$"Panel/Grille de points".rafraichir_affichage(Souris.Points) #update les points dans le menu
			Souris.get_node("PanelContainer/Grille de points").rafraichir_affichage(Souris.Points)
			return (true)
	if stat =="Calcul" :
		if Souris.Calcul > 0 : #si la souris a des points en endurance
			Souris.Calcul -= 1
			Souris.CLock += 1#un point est alors transformé en pt bloqué
			Souris.Points[Souris.Calcul] = Souris.CalculLockPt #modifie un point dans la liste de Points de la souris
			$"Panel/Grille de points".rafraichir_affichage(Souris.Points) #update les points dans le menu
			return (true)
	if stat =="Observation" :
		if Souris.Observation > 0 : #si la souris a des points en endurance
			Souris.Observation -= 1
			Souris.OLock += 1#un point est alors transformé en pt bloqué
			Souris.Points[sumCalc+sumEndu+ Souris.Observation] = Souris.ObservationLockPt #modifie un point dans la liste de Points de la souris
			$"Panel/Grille de points".rafraichir_affichage(Souris.Points) #update les points dans le menu
			return (true)
	
	return (false)

func _on_Marcher_cout_point(type, index):
	if test_souris_stat(type) :
		var marcher = $"Control/VBoxContainer/Marcher"
		marcher.Valeur[index] = marcher.Valeur[index] - 1
		if marcher.Valeur[index] == 0 :
			print('ok')
			marcher.Valeur[index] = marcher.ValeurMax[index]
		$"Control/VBoxContainer/Marcher/Compteur".text = str(marcher.Valeur[index])
	else : print ("Nope")
