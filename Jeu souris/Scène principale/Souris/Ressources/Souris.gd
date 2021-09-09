extends Node2D

export(String) var nomSouris = ""

export (int) var Endurance =0
export (int) var ELock = 0
export (int) var Mecanique = 0
export (int) var MLock = 0
export (int) var Diplomatie = 0
export (int) var DLock = 0
export(Array, Resource) var Points = [ null, null, 
null, null, null, null, null, null, null, null]

#on importe les differents types de points
var EndurancePt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Endurance.tres")
var EnduranceLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Endurancelock.tres")
var DiplomatiePt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Diplomatie.tres")
var DiplomacieLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/DiplomatieLock.tres")
var MecaniquePt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Mecanique.tres")
var MecaniqueLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/MecaniqueLock.tres")
#Variables liées au drag and dropping de la souris
var selectionnee = false
var rest_point
var rest_nodes = []


func _ready(): 
	#met à jour l'affichage des points
	$"PanelContainer/Grille de points".rafraichir_affichage(Points)
	
	rest_nodes = get_tree().get_nodes_in_group("DropzoneMachine")
	rest_point = rest_nodes[0]
	rest_nodes[0].select() #permet le changement de couleur des dropout zone
	
func _physics_process(delta):
	if selectionnee :
		$"PanelContainer".visible = false
		global_position = lerp(global_position, get_global_mouse_position(),25 *delta)
	else :
		global_position =lerp(global_position, rest_point.global_position,15*delta)
		
#fonction permettant de changer un point dans la liste
func change_point (point_index, point):
	Points[point_index] = point
	$"PanelContainer/Grille de points".point_changee([point_index],Points)

func reset_stat () :
	var sumEndu = Endurance + ELock
	var sumDiplo = Diplomatie +DLock
	var sumMeca = Mecanique + MLock
	for i in range (sumMeca):
		change_point([i],MecaniquePt)
	for j in range (sumMeca,sumEndu):
		change_point([j],EndurancePt)
	for k in range (sumMeca+sumEndu,sumDiplo):
		change_point([k],DiplomatiePt)


#affiche les points quand la souris passe dessus
func _on_Area2D_mouse_entered():
	$"PanelContainer".visible = true

#enleve le menu des points quand la souris n'est plus dessus
func _on_Area2D_mouse_exited():
	$"PanelContainer".visible = false
#la souris est selectionnée si la souris clique dessus
func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("left click") :
		selectionnee = true

func _input(event):
	if event is InputEventMouseButton :
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selectionnee = false
			#rayon de la dropzone des machines
			var distancemin = 75
			#pour chacunes des dropzones
			for child in rest_nodes :
				var distance= global_position.distance_to(child.global_position)
				if distance < distancemin :
					if child.libre :#si aucune souris n'est dedans
						rest_point.deselect()
						child.select()# change la couleur des dropout zones
						rest_point= child
						distancemin = distance
