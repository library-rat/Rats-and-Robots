extends Node

signal player_neutre()		#set the player to a neutral state
signal move_player (valeur :int)	#emittend when the actual action is movement (valeur is max_distance)
signal player_moved(move_range_left) #emitted after player movement
signal jump_player()		#emittend when the actual action is jump
signal player_jumped()		#emitted after player movement
signal dash_player()		#emittend when the actual action is dash
signal player_dashed()		#emitted after player movement
signal tir_tendu(ammo :Ammo)		#emittend when the actual action is tir_tendu
signal tir_courbe(ammo : Ammo)		#emittend when the actual action is tir_courbe
signal player_shot()				#emitted after player shooting
signal walk_finished(unit :Unit)
