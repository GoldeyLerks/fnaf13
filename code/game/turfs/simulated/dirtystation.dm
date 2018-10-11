//Janitors!  Janitors, janitors, janitors!  -Sayu


//Conspicuously not-recent versions of suspicious cleanables

//This file was made not awful by Xhuis on September 13, 2016

//Making the station dirty, one tile at a time. Called by master controller's setup_objects

/turf/open/floor/proc/MakeDirty()
	if(prob(66))	//fastest possible exit 2/3 of the time
		return

	if(!(flags_1 & CAN_BE_DIRTY_1))
		return

	if(locate(/obj/structure/grille) in contents)
		return

	var/area/A = get_area(src)

	if(A && !(A.flags_1 & CAN_BE_DIRTY_1))
		return

	//The code below here isn't exactly optimal, but because of the individual decals that each area uses it's still applicable.

				//high dirt - 1/3 chance.
	var/static/list/high_dirt_areas = typecacheof(list(/area/science/test_area,
														/area/mine/production,
														/area/mine/living_quarters,
														/area/ruin/space))
	if(is_type_in_typecache(A, high_dirt_areas))
		new /obj/effect/decal/cleanable/dirt(src)	//vanilla, but it works
		return


	if(prob(80))	//mid dirt  - 1/15
		return

		//Construction zones. Blood, sweat, and oil.  Oh, and dirt.
	var/static/list/engine_dirt_areas = typecacheof(list(/area/engine,			
														/area/crew_quarters/heads/chief,
														/area/ruin/space/derelict/assembly_line,
														/area/science/robotics,
														/area/maintenance,
														/area/construction,
														/area/survivalpod))
	if(is_type_in_typecache(A, engine_dirt_areas))
		if(prob(35))
			if(prob(4))
				new /obj/effect/decal/cleanable/robot_debris/old(src)
			else
				new /obj/effect/decal/cleanable/oil(src)
		else
			new /obj/effect/decal/cleanable/dirt(src)
		return

		//Bathrooms. Blood, vomit, and shavings in the sinks.
	var/static/list/bathroom_dirt_areas = typecacheof(list(	/area/crew_quarters/toilet,
															/area/awaymission/research/interior/bathroom))
	if(is_type_in_typecache(A, bathroom_dirt_areas))
		if(prob(40))
			new /obj/effect/decal/cleanable/vomit/old(src)
		return

		//Hangars and pods covered in oil.
	var/static/list/oily_areas = typecacheof(/area/quartermaster)
	if(is_type_in_typecache(A, oily_areas))
		if(prob(25))
			new /obj/effect/decal/cleanable/oil(src)
		return


	if(prob(75))	//low dirt  - 1/60
		return

		//Kitchen areas. Broken eggs, flour, spilled milk (no crying allowed.)
	var/static/list/kitchen_dirt_areas = typecacheof(list(/area/crew_quarters/kitchen,
														/area/crew_quarters/cafeteria))
	if(is_type_in_typecache(A, kitchen_dirt_areas))
		if(prob(60))
			if(prob(50))
				new /obj/effect/decal/cleanable/egg_smudge(src)
			else
				new /obj/effect/decal/cleanable/flour(src)
		return

	return TRUE
