//fnaf ambience subsystem
//the old system is area specific and thats dumb

#define INIT_ORDER_FNAF_AMBIENCE -30
#define FIRE_PRIORITY_FNAF_AMBIENCE 10

//OnRoundstart
SUBSYSTEM_DEF(fnaf_ambience)
	name = "FNAF Ambience"
	init_order = INIT_ORDER_FNAF_AMBIENCE
	priority = FIRE_PRIORITY_FNAF_AMBIENCE
	flags = SS_BACKGROUND
	wait = 5 SECONDS
	runlevels = RUNLEVEL_GAME

	var/static/list/normal_ambience = list(
		//list('song file', length)
		list('sound/ambience/fnaf/pizzeria1.ogg', 130 SECONDS),
		list('sound/ambience/fnaf/pizzeria2.ogg', 90 SECONDS),
		list('sound/ambience/fnaf/pizzeria3.ogg', 140 SECONDS),
		list('sound/ambience/fnaf/pizzeria4.ogg', 110 SECONDS)
	)
	var/ambience_len

/datum/controller/subsystem/fnaf_ambience/Initialize()
	ambience_len = normal_ambience.len
	..()

/datum/controller/subsystem/fnaf_ambience/fire(resumed = FALSE)
	for(var/client/C in GLOB.clients)
		if(!(C.prefs.toggles & SOUND_AMBIENCE))
			continue
		if(C.can_listen_to_ambience)
			if(!C.ambience)
				C.ambience = normal_ambience.Copy()
			C.can_listen_to_ambience = FALSE
			var/ambience_index = rand(1, ambience_len - C.can_play_last_sound)
			var/ambience = C.ambience[ambience_index]
			C.ambience[ambience_index] = C.ambience[ambience_len]
			C.ambience[ambience_len] = ambience
			SEND_SOUND(C, sound(ambience[1], repeat = 0, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
			C.can_play_last_sound = 0
			addtimer(CALLBACK(src, .proc/free_ambience, C), ambience[2] + rand(45, 90) SECONDS)

/datum/controller/subsystem/fnaf_ambience/proc/free_ambience(client/C)
	C.can_listen_to_ambience = TRUE

/client
	var/can_listen_to_ambience = TRUE
	var/can_play_last_sound = 1
	var/list/ambience
