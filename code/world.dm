//This file is just for the necessary /world definition
//Try looking in game/world.dm

/world
	mob = /mob/dead/new_player
	turf = /turf/closed/indestructible/riveted
	area = /area/space
	view = "15x15"
	hub = "Exadv1.spacestation13"
	name = "Five Nights at Freddy's 13"
	fps = 20
#ifdef FIND_REF_NO_CHECK_TICK
	loop_checks = FALSE
#endif
