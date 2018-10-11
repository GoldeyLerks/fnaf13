/datum/game_mode/fnaf
	name = "normal day"
	config_tag = "fnaf_extended"
	required_players = 0

	announce_span = "notice"
	announce_text = "Just have fun and enjoy the game!"

	var/players_per_animatronic = 4
	var/max_animatronics = 4
	var/list/datum/mind/animatronics = list()
	var/list/datum/antagonist/animatronic_antags = list()
	var/mob/living/carbon/human/deadkid/deadkid

/datum/game_mode/fnaf/pre_setup()
	antag_candidates = get_players_for_role(ROLE_FNAF_ANIMATRONIC)

	if(!antag_candidates.len)
		setup_error = "No animatronic candidates"
		return FALSE
	
	var/animatronics_needed = max(round(num_players() / players_per_animatronic, 1), max_animatronics)
	
	for(var/i = 1 to animatronics_needed)
		if(!antag_candidates.len) break

		var/datum/mind/animatronic = pick(antag_candidates)
		animatronic.assigned_role = ROLE_FNAF_ANIMATRONIC
		animatronic.special_role = "Animatronic"
		animatronic.restricted_roles = get_all_jobs() - SSjob.overflow_role // Only child THEN turn into an animatronic
		log_game("[key_name(animatronic)] has been selected as an animatronic")
		antag_candidates -= animatronic
		animatronics += animatronic

	return TRUE

/datum/game_mode/fnaf/post_setup()
	for(var/datum/mind/animatronic in animatronics)
		var/datum/antagonist/animatronic/antag = animatronic.add_antag_datum(/datum/antagonist/animatronic)
		animatronic_antags += antag
		new_animatronic(antag, animatronic)
	
	var/list/turfs = get_area_turfs(/area/maintenance, subtypes=TRUE)
	var/turf
	while((turf = pick_n_take(turfs)) && is_blocked_turf(turf) || is_station_level(turf))
	deadkid = new(turf)

	for(var/mob/living/carbon/human/human in GLOB.alive_mob_list)
		if(human.job == "Manager" || human.job == "Security Officer")
			to_chat(human, "<b><h4>You've heard reports that the birthday child, [deadkid.real_name], has gone missing. Figure out what happened to [deadkid.p_them()].</h4></b>")
		else if(human.job == "Child")
			to_chat(human, "<b><h4>You're here for [deadkid.real_name]'s awesome birthday party, but you haven't seen [deadkid.p_them()] all day, even though [deadkid.p_they()] said [deadkid.p_they()]'d show up early.</h4></b>")
			var/tokens = CONFIG_GET(number/fnaf_child_start_tokens)
			if(tokens)
				to_chat(human, "<b><h4>Your mom put [tokens] token\s in your wallet, and there are so many cool games here! Maybe you can earn enough tickets for something cool at the ticket redeemer.</h4></b>")

	return ..()

/datum/game_mode/fnaf/proc/new_animatronic(/datum/antagonist/animatronic/animatronic, /datum/mind/mind)
	return

/datum/antagonist/animatronic
	name = "Animatronic"
	job_rank = ROLE_FNAF_ANIMATRONIC
	roundend_category = "animatronics"
	antagpanel_category = "Animatronic"

	var/animatronic_name
	var/malfunctioning = MALFUNCTIONING_NO
	var/static/list/initial_animatronic_spawns = list()
	var/static/list/animatronic_spawns = list()

/datum/antagonist/animatronic/greet()
	to_chat(owner, "<b>You are an animatronic!</b>")
	to_chat(owner, "<b>You can use :a to talk to other animatronics.</b>")
	to_chat(owner, "<b>You are not allowed to hurt others unless your life is seriously threatened. You are too expensive to replace.</b>")
	to_chat(owner, "<b>Above all, your goal is to entertain children in any way you can. You are not just locked to the theatre.</b>")

GLOBAL_VAR(titular_animatronic)

/datum/antagonist/animatronic/on_gain()
	. = ..()

	if(!animatronic_spawns.len)
		if(!initial_animatronic_spawns.len)
			for(var/obj/effect/landmark/start/animatronic/start in GLOB.start_landmarks_list)
				initial_animatronic_spawns += start.loc
		animatronic_spawns = initial_animatronic_spawns.Copy()

	var/mob/living/simple_animal/hostile/animatronic/animatronic = new(pick_n_take(animatronic_spawns))
	var/mob/old_mob = owner.current
	owner.transfer_to(animatronic)
	QDEL_NULL(old_mob)

	if(!animatronic.apply_pref_name("animatronic", owner.current.client))
		animatronic.name = pick(GLOB.fnaf_animatronic_names)

	if(!GLOB.titular_animatronic)
		GLOB.titular_animatronic = animatronic.name
		set_station_name("[animatronic.name]'s Pizzeria")
		SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NEW_STATION_NAME, animatronic.name)
	
	SEND_SOUND(animatronic, 'sound/effects/pai_boot.ogg')
