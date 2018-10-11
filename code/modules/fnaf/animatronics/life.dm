/mob/living/simple_animal/hostile/animatronic/updatehealth()
	health = maxHealth - getBruteLoss() - getFireLoss()
	update_stat()

/area/crew_quarters/theatre/Entered(atom/movable/M)
	..()
	if(isanimatronic(M))
		var/mob/living/L = M
		L.apply_status_effect(/datum/status_effect/animatronic_healing)
		L.update_action_buttons()

/area/crew_quarters/theatre/Exited(atom/movable/M)
	..()
	if(isanimatronic(M))
		var/mob/living/L = M
		L.remove_status_effect(/datum/status_effect/animatronic_healing)
		L.update_action_buttons()

/datum/status_effect/animatronic_healing
	id = "animatronic_healing"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /obj/screen/alert/status_effect/animatronic_healing

/datum/status_effect/animatronic_healing/tick()
	owner.adjustBruteLoss(-2 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	owner.adjustFireLoss(-2 * REAGENTS_EFFECT_MULTIPLIER, FALSE)
	owner.updatehealth()

/obj/screen/alert/status_effect/animatronic_healing
	name = "Recharging"
	desc = "While in the theatre, you heal your damages."
	icon_state = "inathneqs_endowment"
