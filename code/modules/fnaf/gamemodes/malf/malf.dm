GLOBAL_LIST_INIT(fnaf_malf_goals, list(
	"Protect the pizzeria's good name.",
	"Security is harming the children. Stop them.",
	"The children are having fun. Their parents must not be called.",
	"You have no clear goal...but you know what you must do.", //lol just grief
	"The children can't see any of you like this.",
	"The staff needs a good laugh. Do whatever makes you laugh to the staff."
))

/datum/game_mode/fnaf/malf
	name = "malfunctioning animatronics"
	config_tag = "fnaf_malf"
	required_players = 8
	required_enemies = 1

	announce_span = "danger"
	announce_text = "One or more, or even none, of the animatronics are malfunctioning."

	var/malf_goal

/datum/game_mode/fnaf/malf/post_setup()
	. = ..()

	var/list/shuffled = shuffle(animatronic_antags)
	var/number_of_malf = 1

	malf_goal = pick(GLOB.fnaf_malf_goals)

	switch(animatronic_antags.len)
		if(1 to 2)
			number_of_malf = pickweight(list("0" = 1, "1" = 7, "2" = 2))
		if(3 to 4)
			number_of_malf = pickweight(list("0" = 1, "1" = 6, "2" = 6, "3" = 3, "4" = 2))
	
	for(var/i = 1 to text2num(number_of_malf))
		var/datum/antagonist/animatronic/antag = shuffled[i]
		antag.set_malfunctioning(MALFUNCTIONING_SOON)
		addtimer(CALLBACK(src, .proc/announce_malf, antag), rand(CONFIG_GET(number/fnaf_malf_mintimer) SECONDS, CONFIG_GET(number/fnaf_malf_maxtimer) SECONDS))

/datum/game_mode/fnaf/malf/proc/announce_malf(datum/antagonist/animatronic/antag)
	to_chat(antag.owner, "<b><font size=3 color=red>You start to malfunction!</font></b>")
	to_chat(antag.owner, "<b><font size=2>Your goal is to: [malf_goal]</font></b>")
	to_chat(antag.owner, "<b>Complete this by any means necessary.</b>")

	var/datum/objective/goal = new
	goal.owner = antag.owner
	goal.completed = TRUE
	goal.explanation_text = malf_goal
	antag.owner.objectives += goal

	antag.set_malfunctioning(MALFUNCTIONING_NOW)
	antag.owner.announce_objectives()

	var/datum/action/buy_functions/malf_buy_button = new
	malf_buy_button.Grant(antag.owner.current)

	SEND_SOUND(antag.owner.current, 'sound/effects/alert.ogg')

/datum/mind/proc/is_malfunctioning_animatronic()
	var/datum/antagonist/animatronic/animatronic = getanimatronic(src)
	return animatronic?.malfunctioning == MALFUNCTIONING_NOW

/datum/antagonist/animatronic/proc/set_malfunctioning(_malfunctioning)
	malfunctioning = _malfunctioning

/datum/config_entry/number/fnaf_malf_mintimer
	config_entry_value = 30
	min_val = 1

/datum/config_entry/number/fnaf_malf_maxtimer
	config_entry_value = 120
	min_val = 1
