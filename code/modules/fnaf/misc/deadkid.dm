GLOBAL_LIST_INIT(deadkid_detachable_body_parts, typecacheof(list(
	/obj/item/bodypart/r_arm,
	/obj/item/bodypart/l_arm,
	/obj/item/bodypart/r_leg,
	/obj/item/bodypart/l_leg
)))

/mob/living/carbon/human/deadkid
	var/static/datum/component/redirect/pull

/mob/living/carbon/human/proc/turn_into_dead_kid()
	become_husk("born")

	var/num = 0

	for(var/obj/item/bodypart/BP in shuffle(bodyparts))
		if(is_type_in_typecache(BP, GLOB.deadkid_detachable_body_parts))
			if(prob(100 - num * 30))
				BP.dismember()
			num++

/mob/living/carbon/human/deadkid/New(var/new_kid = TRUE)
	. = ..()
	real_name = pick(gender == MALE ? GLOB.first_names_male : GLOB.first_names_female) //first name only
	name = real_name
	equipOutfit(/datum/outfit/job/assistant)
	death(TRUE) //avoid message
	turn_into_dead_kid()
	pull = AddComponent(/datum/component/redirect, list(COMSIG_MOVABLE_PULL = CALLBACK(src, .proc/pull_start)))

/mob/living/carbon/human/deadkid/proc/pull_start()
	QDEL_NULL(pull)

	var/old_layer = src.layer
	var/old_plane = src.plane
	src.layer = FLOAT_LAYER
	src.plane = FLOAT_PLANE

	//for(var/mob/dead/observer/ghost in GLOB.player_list)
	for(var/mob/dead/observer/ghost in GLOB.player_list)
		var/obj/screen/alert/deadkidfound/A = ghost.throw_alert("dead_kid_found", /obj/screen/alert/deadkidfound)
		if(!A) continue
		if(ghost.client && ghost.client.prefs && ghost.client.prefs.UI_style)
			A.icon = ui_style2icon(ghost.client.prefs.UI_style)
		A.add_overlay(src)
		A.kid = src
	
	src.layer = old_layer
	src.plane = old_plane

/obj/screen/alert/deadkidfound
	name = "Birthday Kid Found"
	desc = "The good news is we found the birthday kid. The bad news is..."
	icon_state = "template"
	timeout = 30 SECONDS
	var/mob/living/carbon/human/deadkid/kid

/obj/screen/alert/deadkidfound/Click()
	if(!usr || !usr.client || !kid) return
	var/mob/dead/observer/ghost = usr
	if(!istype(ghost)) return
	ghost.ManualFollow(kid)

/mob/dead/observer/verb/dead_kid()
	set category = "Ghost"
	set name = "Follow Dead Kid"

	var/datum/game_mode/fnaf/fnaf_gm = SSticker.mode
	if(istype(fnaf_gm) && !QDELETED(fnaf_gm.deadkid))
		ManualFollow(fnaf_gm.deadkid)
	else
		to_chat(src, "<span class='warning'>There is no dead kid.</span>")
