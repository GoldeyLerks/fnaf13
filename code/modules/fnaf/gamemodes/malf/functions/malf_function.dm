//get it
/datum/malf_function
	var/name = "ERROR"
	var/desc = "ERROR!"
	var/cost = 0
	var/mob/living/simple_animal/hostile/animatronic/owner

/datum/malf_function/proc/bought()

/datum/action/buy_functions
	name = "Buy Functions"
	desc = "While in the theatre, you can buy malicious functions. Gain points by gathering the souls of kids."
	icon_icon = 'icons/mob/clockwork_mobs.dmi'
	button_icon_state = "bg_gear"
	var/static/list/functions_by_name = list()

/datum/action/buy_functions/New(Target)
	. = ..()
	if(!functions_by_name.len)
		for(var/path in subtypesof(/datum/malf_function))
			var/datum/malf_function/function = new path
			functions_by_name[initial(function.name)] = path

/datum/action/buy_functions/IsAvailable()
	. = ..() && owner?.mind.is_malfunctioning_animatronic() && istype(get_area(owner?.mind.current), /area/crew_quarters/theatre)
	if(!.)
		var/datum/browser/popup = get_popup()
		popup.close()

/datum/action/buy_functions/Topic(href, href_list)
	..()
	if(!IsAvailable())
		return

	var/func_name = href_list["function"]
	var/datum/malf_function/func_path = functions_by_name[func_name]
	if(!func_path) return
	var/datum/antagonist/animatronic/animatronic = getanimatronic(owner.mind)
	if(animatronic.bought_functions[func_path]) return
	if(animatronic.malf_points < initial(func_path.cost)) return
	var/datum/malf_function/func = new func_path
	func.owner = owner
	animatronic.bought_functions[func_path] = func
	func.bought()
	animatronic.malf_points -= func.cost
	Trigger()

/datum/action/buy_functions/Trigger()
	. = ..()
	if(!.) return
	var/datum/antagonist/animatronic/animatronic = getanimatronic(owner?.mind)
	var/dat = "<h3><center>Buy Functions<br>[animatronic.malf_points] point\s available</center></h3><hr>"
	dat += "<table width=100% style='text-align: center'>"

	for(var/func_name in functions_by_name)
		var/datum/malf_function/function_path = functions_by_name[func_name]
		dat += "<tr>"
		dat += "<td><b>[initial(func_name)]</b></td>"
		dat += "<td>[initial(function_path.desc)]</td>"
		dat += "<td>"
		if(animatronic.bought_functions[function_path])
			dat += "Bought"
		else
			var/enough = animatronic.malf_points >= initial(function_path.cost)
			if(enough)
				dat += "<a href='?src=[REF(src)];function=[func_name]'>"
			dat += "Buy for [initial(function_path.cost)] point\s[enough ? "</a>" : ""]"
		dat += "</tr>"

	dat += "</table>"

	var/datum/browser/popup = get_popup()
	popup.set_content(dat)
	popup.width = 1000
	popup.open()

/datum/action/buy_functions/proc/get_popup()
	return new /datum/browser(owner, "buy_functions", "Buy Functions", 800, 600)

/datum/antagonist/animatronic
	var/list/datum/malf_function/bought_functions = list()
	var/malf_points = 3

/mob/living/simple_animal/hostile/animatronic/proc/has_bought_function(type_path)
	var/datum/antagonist/animatronic/animatronic = getanimatronic(mind)
	return (animatronic.malfunctioning == MALFUNCTIONING_NOW) && animatronic.bought_functions[type_path]

/mob/living/carbon/human
	var/child_has_soul = TRUE

/mob/living/carbon/human/deadkid
	child_has_soul = FALSE

/mob/living/simple_animal/hostile/animatronic/UnarmedAttack(atom/A)
	var/datum/antagonist/animatronic/animatronic = getanimatronic(mind)
	if(animatronic?.malfunctioning == MALFUNCTIONING_NOW)
		var/mob/living/carbon/human/kid = A
		if(istype(kid) && kid.dna.check_mutation(DWARFISM) && kid.stat == DEAD)
			to_chat(src, "You start to collect this child's soul...")
			if(!kid.child_has_soul)
				to_chat(src, "<span class='warning'>This child has already had its soul taken.</span>")
			else if(do_mob(src, kid, 5 SECONDS))
				if(!kid.child_has_soul)
					to_chat(src, "<span class='warning'>This child had its soul taken as you were collecting it.</span>")
				else
					kid.child_has_soul = FALSE
					kid.turn_into_dead_kid()
					var/points = CONFIG_GET(number/fnaf_soul_points)
					animatronic.malf_points += points
					to_chat(src, "<span class='notice'>You collect the child's soul. <i>You have gained [points] point\s, and are now at [animatronic.malf_points].</i></span>")
			return
	..()

/datum/config_entry/number/fnaf_soul_points
	min_val = 0
	config_entry_value = 2

/datum/action/malf_function
	var/cooldown = 0
	var/last_used = -1000

/datum/action/malf_function/IsAvailable()
	return ..() && owner?.mind.is_malfunctioning_animatronic() && world.time - last_used >= cooldown

/datum/action/malf_function/Trigger()
	. = ..()
	if(!.) return
	last_used = world.time
	owner.update_action_buttons()
