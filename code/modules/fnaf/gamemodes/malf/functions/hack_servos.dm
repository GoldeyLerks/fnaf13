/datum/malf_function/hack_servos
	name = "Hack Servos"
	desc = "Gain invincibility and speed for a limited time, but everyone who sees you will know you're malfunctioning."
	cost = 3

/datum/malf_function/hack_servos/bought()
	var/datum/action/malf_function/hack_servos/hack_servos = new
	hack_servos.Grant(owner)

/datum/action/malf_function/hack_servos
	name = "Hack Servos"
	desc = "Gain invincibility and speed for a limited time, but everyone who sees you will know you're malfunctioning."
	icon_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "emp"
	cooldown = 90 SECONDS

/datum/action/malf_function/hack_servos/Trigger()
	. = ..()
	if(!.) return
	var/mob/living/L = owner
	if(!istype(L)) return
	L.visible_message("<span class='danger'>[L] sparks wildly!</span>", "<span class='danger'>You spark wildly!</span>")
	L.add_overlay(/obj/effect/temp_visual/gravpush)
	L.status_flags |= GODMODE
	L.add_trait(TRAIT_IGNORESLOWDOWN, "hack_servos")
	L.add_stun_absorption("hack_servos", INFINITY, 2, "seems to absorb the shock!", "You absorb the shock!")
	L.add_movespeed_modifier("hack_servos", TRUE, 100, multiplicative_slowdown=-3)
	addtimer(CALLBACK(src, .proc/stop_invincibility, L), 30 SECONDS)

/datum/action/malf_function/hack_servos/proc/stop_invincibility(mob/living/L)
	L.visible_message("<span class='warning'>[owner] stops sparking!</span>", "<span class='warning'>The sparking stops!</span>")
	L.cut_overlay(/obj/effect/temp_visual/gravpush)
	L.status_flags &= ~GODMODE
	L.remove_trait(TRAIT_IGNORESLOWDOWN, "hack_servos")
	L.stun_absorption["hack_servos"] = null
	L.remove_movespeed_modifier("hack_servos")
