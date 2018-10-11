/obj/structure/fnafarcade
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE
	var/playing = FALSE

/obj/structure/fnafarcade/New()
	..()
	if(findtext(initial(name), "{NAME}"))
		AddComponent(/datum/component/redirect, list(COMSIG_GLOB_NEW_STATION_NAME = .proc/update_name))
		update_name()

/obj/structure/fnafarcade/attack_hand(mob/living/user)
	if(!playing)
		to_chat(user, "<span class='notice'>You need to insert a token to play.</span>")
		return TRUE

/obj/structure/fnafarcade/attackby(obj/item/I, mob/living/user, params)
	if(default_unfasten_wrench(user, I)) return
	if(istype(I, /obj/item/coin/token))
		if(playing)
			to_chat(user, "<span class='notice'>\the [src] already has a token inside.</span>")
		else
			visible_message("[user] inserts \a [I] into \the [src].", "You insert \a [I] into \the [src].")
			playing = TRUE
			qdel(I)
			arcade_game()
		return TRUE //we got it
	return ..()

/obj/structure/fnafarcade/examine(mob/user)
	..()
	to_chat(user, "It is currently <b>[playing ? "on" : "off"]</b>")

/obj/structure/fnafarcade/proc/arcade_game()
	return

/obj/structure/fnafarcade/proc/update_name(animatronic)
	animatronic = animatronic || GLOB.titular_animatronic
	var/new_name = animatronic ? "[animatronic]'s" : "The"
	name = replacetext(initial(name), "{NAME}", new_name)

/obj/structure/fnafarcade/proc/reward_tickets(num)
	var/obj/item/stack/tickets/tickets = new(loc, num)
	tickets.layer += 0.01
