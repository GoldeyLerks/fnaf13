GLOBAL_LIST_EMPTY(malf_tracker_stats)

/datum/malf_function/malf_tracker
	name = "Corrupted Signal"
	desc = "You will see which other animatronics are/will be malfunctioning."
	cost = 1

/mob/living/simple_animal/hostile/animatronic/Stat()
	..()
	if(has_bought_function(/datum/malf_function/malf_tracker))
		for(var/name in GLOB.malf_tracker_stats)
			stat(name, GLOB.malf_tracker_stats[name])

/datum/antagonist/animatronic
	var/static/list/malfunction_stat_text = list(
		MALFUNCTIONING_NO = "Not Malfunctioning",
		MALFUNCTIONING_SOON = "<span style='color: red'>Starting to Malfunction</span>",
		MALFUNCTIONING_NOW = "<b style='color: red'>Malfunctioning</b>"
	)

/datum/antagonist/animatronic/on_gain()
	..()
	GLOB.malf_tracker_stats[owner.current.real_name] = malfunction_stat_text[malfunctioning]

/datum/antagonist/animatronic/on_removal()
	..()
	GLOB.malf_tracker_stats[owner.current.real_name] = null

/datum/antagonist/animatronic/set_malfunctioning(malfunctioning)
	..()
	GLOB.malf_tracker_stats[owner.current.real_name] = malfunction_stat_text[malfunctioning]
