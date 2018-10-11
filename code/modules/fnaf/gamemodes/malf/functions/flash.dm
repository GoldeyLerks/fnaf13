/datum/malf_function/flash
	name = "Flash"
	desc = "Flash all non-animatronics, even those with protection, in a large area around you."
	cost = 3

/datum/malf_function/flash/bought()
	var/datum/action/malf_function/flash/flash = new
	flash.Grant(owner)

/datum/action/malf_function/flash
	name = "Flash"
	desc = "Flash all non-animatronics, even those with protection, in a large area around you."
	icon_icon = 'icons/obj/assemblies/new_assemblies.dmi'
	button_icon_state = "flash"
	cooldown = 60 SECONDS

/datum/action/malf_function/flash/Trigger()
	. = ..()
	if(!.) return
	playsound(owner.loc, 'sound/weapons/flash.ogg', 100, 1)
	for(var/mob/living/L in viewers(owner, null))
		if(!isanimatronic(L.mind))
			L.blind_eyes(5)
			L.blur_eyes(5)
			L.Knockdown(100)
