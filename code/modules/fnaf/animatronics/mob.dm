#define NUMBER_OF_TOOLBOX_HITS_OPTIMUMTACT_I_MEAN_ME_SAID_ANIMATRONICS_SHOULD_SURVIVE 15
#define ANIMATRONIC_HEALTH (12 * NUMBER_OF_TOOLBOX_HITS_OPTIMUMTACT_I_MEAN_ME_SAID_ANIMATRONICS_SHOULD_SURVIVE)

/mob/living/simple_animal/hostile/animatronic
	name = "animatronic"
	desc = "A large animatronic used to entertain guests."
	icon = 'icons/fnaf/mob/animatronics.dmi'
	icon_state = "robot"
	bubble_icon = "machine"
	gender = NEUTER
	mob_biotypes = list(MOB_ROBOTIC)
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	del_on_death = FALSE

	dextrous = TRUE
	dextrous_hud_type = /datum/hud/dextrous/animatronic
	held_items = list(null, null)
	speak_emote = list("states")
	verb_say = "states"
	mob_size = MOB_SIZE_LARGE

	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	status_flags = CANSTUN|CANKNOCKDOWN

	attacktext = "beats"
	melee_damage_lower = 18
	melee_damage_upper = 18

	health = ANIMATRONIC_HEALTH
	maxHealth = ANIMATRONIC_HEALTH

	var/static/list/possible_icons = list()
	var/eyes

/mob/living/simple_animal/hostile/animatronic/New()
	. = ..()
	
	if(!possible_icons.len)
		for(var/state in icon_states(icon, 1))
			if(!findtext(state, "eyes-") && !findtext(state, "-shield") && !findtext(state, "-roll"))
				possible_icons += state

	icon_state = pick(possible_icons)
	icon_dead = icon_state
	possible_icons -= icon_state
	eyes = "eyes-[icon_state]"
	add_overlay(eyes)

	access_card = new
	access_card.access = get_all_accesses() - ACCESS_SEC_DOORS - ACCESS_WEAPONS - ACCESS_SECURITY - ACCESS_BRIG - ACCESS_HEADS - ACCESS_HOS

	var/area/crew_quarters/theatre/theatre = get_area(src)
	if(theatre)
		theatre.Entered(src)

/mob/living/simple_animal/hostile/animatronic/death()
	..()
	cut_overlay(eyes)

/mob/living/simple_animal/hostile/animatronic/MiddleClickOn()
	swap_hand()

/mob/living/simple_animal/hostile/animatronic/binarycheck()
	return TRUE

/mob/living/simple_animal/hostile/animatronic/AttackingTarget()
	if(target == src)
		healthscan(src, src)
		return TRUE
	if(a_intent == INTENT_HELP)
		visible_message("[name] waves at [target].", "<span class='notice'>You wave at [target].</span>")
		return TRUE
	return ..()

/mob/living/simple_animal/hostile/animatronic/key_down(_key)
	switch(_key)
		if("1")
			a_intent_change(INTENT_HELP)
		if("4")
			a_intent_change(INTENT_HARM)
	return ..()

/datum/saymode/animatronic
	key = "a"
	mode = MODE_ALIEN

/datum/saymode/animatronic/handle_message(mob/living/simple_animal/hostile/animatronic/user, message, datum/language/language)
	if(istype(user))
		user.robot_talk(message)
	return FALSE

/obj/item/stack/medical/attack(mob/living/simple_animal/hostile/animatronic/M, mob/living/user)
	if(istype(M))
		if(istype(user))
			to_chat(user, "<span class='warning'>You realize that you're trying to apply \a [src] to an animatronic.</span>")
			user.adjustBrainLoss(5, 60)
		return
	return ..()
