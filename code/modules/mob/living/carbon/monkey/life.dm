

/mob/living/carbon/monkey


/mob/living/carbon/monkey/Life()
	set invisibility = 0

	if (notransform)
		return

	if(..())

		if(!client)
			if(stat == CONSCIOUS)
				if(on_fire || buckled || restrained())
					if(!resisting && prob(MONKEY_RESIST_PROB))
						resisting = TRUE
						walk_to(src,0)
						resist()
				else if(resisting)
					resisting = FALSE
				else if((mode == MONKEY_IDLE && !pickupTarget && !prob(MONKEY_SHENANIGAN_PROB)) || !handle_combat())
					if(prob(25) && canmove && isturf(loc) && !pulledby)
						step(src, pick(GLOB.cardinals))
					else if(prob(1))
						emote(pick("scratch","jump","roll","tail"))
			else
				walk_to(src,0)

/mob/living/carbon/monkey/handle_mutations_and_radiation()
	if(radiation)
		if(radiation > RAD_MOB_KNOCKDOWN && prob(RAD_MOB_KNOCKDOWN_PROB))
			if(!IsKnockdown())
				emote("collapse")
			Knockdown(RAD_MOB_KNOCKDOWN_AMOUNT)
			to_chat(src, "<span class='danger'>You feel weak.</span>")
		if(radiation > RAD_MOB_MUTATE)
			if(prob(1))
				to_chat(src, "<span class='danger'>You mutate!</span>")
				randmutb()
				emote("gasp")
				domutcheck()

				if(radiation > RAD_MOB_MUTATE * 2 && prob(50))
					gorillize()
					return
		if(radiation > RAD_MOB_VOMIT && prob(RAD_MOB_VOMIT_PROB))
			vomit(10, TRUE)
	return ..()

/mob/living/carbon/monkey/handle_random_events()
	if (prob(1) && prob(2))
		emote("scratch")

/mob/living/carbon/monkey/has_smoke_protection()
	if(wear_mask)
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return 1

/mob/living/carbon/monkey/handle_fire()
	. = ..()
	if(on_fire)

		//the fire tries to damage the exposed clothes and items
		var/list/burning_items = list()
		//HEAD//
		var/obj/item/clothing/head_clothes = null
		if(wear_mask)
			head_clothes = wear_mask
		if(wear_neck)
			head_clothes = wear_neck
		if(head)
			head_clothes = head
		if(head_clothes)
			burning_items += head_clothes

		if(back)
			burning_items += back

		for(var/X in burning_items)
			var/obj/item/I = X
			if(!(I.resistance_flags & FIRE_PROOF))
				I.take_damage(fire_stacks, BURN, "fire", 0)

		adjust_bodytemperature(BODYTEMP_HEATING_MAX)
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "on_fire", /datum/mood_event/on_fire)
