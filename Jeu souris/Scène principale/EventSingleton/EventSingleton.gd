extends Node

signal player_neutre()		#set the player to a neutral state
signal move_player (valeur)	#emittend when the actual action is movement (valeur is max_distance)
signal jump_player()		#emittend when the actual action is jump
signal dash_player()		#emittend when the actual action is dash
signal tir_tendu(ammo)		#emittend when the actual action is tir_tendu
signal tir_courbe(ammo)		#emittend when the actual action is tir_courbe
signal walk_finished()
