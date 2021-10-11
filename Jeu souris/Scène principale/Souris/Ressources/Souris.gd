extends Node2D

export(String) var nomSouris = ""
#Stat dans les deifférentes stats
export (int) var Calcul = 0
export (int) var CLock = 0
export (int) var Endurance =0
export (int) var ELock = 0
export (int) var Observation = 0
export (int) var OLock = 0
export(Array, Resource) var Points = [ null, null, 
null, null, null, null, null, null, null, null]

#on importe les differents types de points
var CalculPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Calcul.tres")
var CalculLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/CalculLock.tres")
var EndurancePt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Endurance.tres")
var EnduranceLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Endurancelock.tres")
var ObservationPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/Observation.tres")
var ObservationLockPt = preload("res://Scène principale/Souris/Ressources/Afficheur de points/ObservationLock.tres")
#Variables liées au drag and dropping de la souris
var selectionnee = false
export (int) var rest_point
var rest_nodes = []


func _ready(): 
	#met à jour la liste et l'affichage des points
	reset_stat()
	$"PanelContainer/Grille de points".rafraichir_affichage(Points)
	#calcul tout les points de repos en parcourant toutes les dropzones
	rest_nodes = get_tree().get_nodes_in_group("DropzoneMachine")
	rest_nodes[rest_point].select(self) #permet le changement de couleur des dropout zone
	
	print(Observation)
	print(Points)
	
func _physics_process(delta):
	if selectionnee :
		$"PanelContainer".visible = false #evite d'avoir l'affichage des points pendant le drag & drop
		global_position = lerp(global_position, get_global_mouse_position(),25 *delta)#suis la souris
	else :
		global_position =lerp(global_position, rest_nodes[rest_point].global_position,15*delta) #retourne au point de
		
#fonction permettant de changer un point dans la liste
func change_point (point_index, point):
	Points[point_index] = point
	$"PanelContainer/Grille de points".point_changee([point_index],Points)

func reset_stat () :
	Points = [ null, null, 
null, null, null, null, null, null, null, null]
	var sumEndu = Endurance + ELock
	var sumObs = Observation + OLock
	var sumCalc = Calcul + CLock
	for i in range (sumCalc):#reset les points de calcul
		change_point(i,CalculPt)
	for j in range (sumCalc,sumCalc+sumEndu):#reset les points d'endu
		change_point(j,EndurancePt)
	for k in range (sumCalc+sumEndu,sumCalc+sumEndu+sumObs):#reset les points d'observation
		change_point(k,ObservationPt)


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
		if event.button_index == BUTTON_LEFT and not event.pressed: # quand le cilck est laché
			selectionnee = false
			#rayon de la dropzone des machines
			var distancemin = 75
			#pour chacunes des dropzones
			for i in rest_nodes.size() :#parmi les points de repos
				var distance= global_position.distance_to(rest_nodes[i].global_position)
				if distance < distancemin :
					if rest_nodes[i].libre :#si aucune souris n'est dedans
						rest_nodes[rest_point].deselect()
						rest_nodes[i].select(self)# change la couleur des dropout zones
						rest_point= i
						distancemin = distance
