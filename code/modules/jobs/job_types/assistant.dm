/*
Child
*/
/datum/job/assistant
	title = "Child"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "FNAF"
	total_positions = 5
	spawn_positions = 5
	supervisors = "your parents"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/assistant
	antag_rep = 7


/datum/job/assistant/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/outfit/job/assistant
	name = "Child"
	jobtype = /datum/job/assistant
	ears = null
	belt = null
	id = null

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		uniform = /obj/item/clothing/under/color/grey
	else
		uniform = /obj/item/clothing/under/color/random
	
	if(!l_pocket)
		l_pocket = /obj/item/storage/wallet/kids
	else if(!r_pocket)
		r_pocket = /obj/item/storage/wallet/kids
	else
		backpack_contents += /obj/item/storage/wallet/kids

/datum/outfit/job/assistant/post_equip(mob/living/carbon/human/H)
	H.dna.add_mutation(DWARFISM)

/obj/item/storage/wallet/kids/PopulateContents()
	for(var/i in 1 to CONFIG_GET(number/fnaf_child_start_tokens))
		new /obj/item/coin/token(src)

/datum/config_entry/number/fnaf_child_start_tokens
	config_entry_value = 3
	min_val = 0
