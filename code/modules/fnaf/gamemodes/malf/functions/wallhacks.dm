/datum/malf_function/wallhacks
	name = "Enhanced Vision"
	desc = "Gain the ability to see through walls."
	cost = 2

/datum/malf_function/wallhacks/bought()
	owner.update_sight()

/mob/living/simple_animal/hostile/animatronic/update_sight()
	if(has_bought_function(/datum/malf_function/wallhacks))
		sight = SEE_TURFS|SEE_MOBS|SEE_OBJS
		see_in_dark = 8
		return
	..()
