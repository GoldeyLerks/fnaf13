/datum/hud/dextrous/animatronic/New(mob/living/owner)
	..()
	healths = new /obj/screen/healths/robot()
	infodisplay += healths

	action_intent.icon = 'icons/mob/screen_cyborg.dmi'
	zone_select.icon = 'icons/mob/screen_cyborg.dmi'

/mob/living/simple_animal/hostile/animatronic/update_health_hud()
	if(!client || !hud_used)
		return
	if(hud_used.healths)
		if(stat != DEAD)
			if(health >= maxHealth)
				hud_used.healths.icon_state = "health0"
			else if(health > maxHealth*0.8)
				hud_used.healths.icon_state = "health1"
			else if(health > maxHealth*0.6)
				hud_used.healths.icon_state = "health2"
			else if(health > maxHealth*0.4)
				hud_used.healths.icon_state = "health3"
			else if(health > maxHealth*0.2)
				hud_used.healths.icon_state = "health4"
			else
				hud_used.healths.icon_state = "health5"
		else
			hud_used.healths.icon_state = "health7"

/mob/living/simple_animal/hostile/animatronic/update_stat()
	update_health_hud()
	..()
