/obj/structure/fnafarcade/punchingbag
	name = "{NAME} Fun Punch"
	desc = "A punching bag that gives you more tickets the harder you punch it. Has a slot for a token."
	icon = 'goon/icons/obj/fitness.dmi'
	icon_state = "punchingbag"
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

/obj/structure/fnafarcade/punchingbag/attack_hand(mob/user)
	. = ..()
	if(.) return

	playing = FALSE

	flick("punchingbag2", src)

	if(user.a_intent == INTENT_HELP)
		visible_message("[user] meekly punches \the [src].", "You meekly punch \the [src].")
		say("Man, you stink kid...you don't get ANY tickets.")
	else
		playsound(loc, pick(hit_sounds), 25, 1, -1)

		var/tickets = 0
		//todo these chances suck
		switch(rand(1, 100))
			if(1 to 10)
				visible_message("[user] meekly punches \the [src].", "You meekly punch \the [src].")
				say("Man, you stink kid...you don't get ANY tickets.")
				return
			if(11 to 30)
				tickets = 2
				visible_message("[user] pushes \the [src].", "You push \the [src].")
				say("You're not great, but you're not bad either.")
			if(31 to 70)
				tickets = 3
				visible_message("[user] lands a punch on \the [src].", "You land a punch on \the [src].")
				say("You're not bad.")
			if(71 to 85)
				tickets = 6
				visible_message("[user] punches \the [src] like Dragon Ball Z.", "You punch \the [src] like Dragon Ball Z.")
				say("That reminds me of Dragon Ball Z.")
			if(86 to 100)
				tickets = 15
				visible_message("[user] cheats by kicking \the [src].", "You cheat by kicking \the [src]. You feel awful.")
				say("That was a fantastic punch! You got real potential.")
		
		reward_tickets(tickets)

/obj/structure/fnafarcade/punchingbag/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/melee/baseball_bat))
		new /obj/effect/particle_effect/sparks(loc)
		playsound(src, "sparks", 100, 1)

		for(var/i in 0 to 3)
			var/obj/item/stack/tickets/tickets = new(loc, 6)
			var/turf/throw_at = get_ranged_target_turf(tickets, (1 << i), 1)
			tickets.throw_speed = EXPLOSION_THROW_SPEED //Temporarily change their throw_speed for embedding purposes (Reset when it finishes throwing, regardless of hitting anything)
			tickets.throw_at(throw_at, 2, EXPLOSION_THROW_SPEED)

		visible_message("\the [src] explodes into a pile of tickets!")
		to_chat(user, "<span class='danger'>You got tickets, but at what cost...</span>")

		for(var/datum/data/record/R in GLOB.data_core.security)
			to_chat(world, "[R.fields["name"]] [user.real_name] [R.fields["name"] == user.real_name]")
			if(R.fields["name"] == user.real_name)
				R.fields["criminal"] = "*Arrest*"
				var/crime = GLOB.data_core.createCrimeEntry("Vandlism", "Destroyed \the [src] with \a [I].", "System", station_time_timestamp())
				GLOB.data_core.addMajorCrime(R.fields["id"], crime)
				for(var/mob/living/carbon/human/H in GLOB.carbon_list)
					H.sec_hud_set_security_status()
				break

		qdel(src)
		return TRUE
	return ..()

/obj/structure/fnafarcade/punchingbag/arcade_game()
	say("Go ahead kid...give it your best punch!")
