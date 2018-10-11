
/datum/antagonist/mom
	name = "Mom"
	roundend_category = "moms"
	antagpanel_category = "Mom"

	var/mob/living/carbon/human/child

/datum/antagonist/mom/greet()
	to_chat(owner, "<b>You are [child.real_name]'s Mom!</b>")
	to_chat(owner, "<b>You dropped your kid off at [station_name()] after [child.p_they()] told you all the other kids would make fun of [child.p_them()] if they saw you.</b>")
	to_chat(owner, "<b>...but you just heard the word that the birthday child has gone missing.</b>")
	to_chat(owner, "<b>You and the other moms got to [station_name()] as fast as you could, but the other moms have been annoying you to no end, they only talk about THEIR kids.</b>")
	to_chat(owner, "<b>If they do one more damn thing, you'll lose it.</b>")

/datum/antagonist/mom/proc/add_objectives()
	var/datum/objective/mom_protect/protect = new
	protect.owner = owner
	protect.target = child.mind
	protect.explanation_text = "Protect your child, [child.real_name], and make sure [child.p_they()] get home safely in the car."
	objectives += protect

	var/datum/objective/commotion = new
	commotion.owner = owner
	commotion.completed = TRUE
	commotion.explanation_text = "OOC: Cause as large of a commotion in the restaurant as you can."
	objectives += commotion

	owner.objectives |= objectives

/datum/antagonist/mom/on_gain()
	add_objectives()
	. = ..()
	owner.announce_objectives()
	owner.current.real_name = "[child.real_name]'s Mom"
	owner.current.name = owner.current.real_name

/datum/objective/mom_protect/check_completion()
	return !target || considered_alive(target, enforce_human = TRUE) && target.current.onCentCom()

/datum/outfit/mom
	name = "Mom"
	var/static/list/types_uniforms = subtypesof(/obj/item/clothing/under/skirt)
	var/static/list/types_shoes = subtypesof(/obj/item/clothing/shoes/sneakers) - /obj/item/clothing/shoes/sneakers/orange

/datum/outfit/mom/pre_equip(mob/living/carbon/human/H)
	uniform = pick(types_uniforms)
	back = /obj/item/storage/backpack/satchel
	shoes = pick(types_shoes)
	H.gender = FEMALE
	H.facial_hair_style = "Shaved"
	H.dna.update_ui_block(DNA_GENDER_BLOCK)
	H.update_body()
	H.update_hair()

/proc/summon_the_moms()
	set category = "FNAF"
	set name = "Summon the Moms"

	if(alert("Are you SURE you want to summon the moms?",,"Yes","No") != "Yes")
		return

	to_chat(world, "<span class='cultlarge'>A chill runs downs your spine...you sense...motherly rage...</span>")
	var/list/candidates = pollGhostCandidates("Would you like to become a mom?", poll_time = CONFIG_GET(number/fnaf_mom_timer))
	if(candidates.len)
		SSshuttle.emergency.request()
		sleep(5)

		var/list/mob/living/carbon/human/kids = list()
		for(var/mob/living/carbon/human/kid in GLOB.alive_mob_list)
			if(kid.job == "Child")
				kids += kid
		
		while(kids.len && candidates.len)
			var/mob/dead/observer/ghost = pick_n_take(candidates)
			var/mob/living/carbon/human/kid = pick_n_take(kids)

			var/mob/living/carbon/human/momb = new //get it :D like mom mob :D
			momb.equipOutfit(/datum/outfit/mom)
			var/list/arrival_turfs = get_area_turfs(/area/shuttle/escape)
			var/end_turf
			while((end_turf = pick_n_take(arrival_turfs)) && is_blocked_turf(end_turf))
			momb.forceMove(end_turf)
			momb.key = ghost.key

			var/datum/antagonist/mom/mom = new
			mom.child = kid
			momb.mind.add_antag_datum(mom)

/datum/config_entry/number/fnaf_mom_timer
	config_entry_value = 30 SECONDS
	min_val = 0
