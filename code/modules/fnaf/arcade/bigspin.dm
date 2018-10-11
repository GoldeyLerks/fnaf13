#define BIGSPIN_CHANCE_1 10
#define BIGSPIN_CHANCE_5 5
#define BIGSPIN_CHANCE_10 3
#define BIGSPIN_CHANCE_50 1
#define BIGSPIN_TOTAL (BIGSPIN_CHANCE_1 + BIGSPIN_CHANCE_5 + BIGSPIN_CHANCE_10 + BIGSPIN_CHANCE_50)

/obj/structure/fnafarcade/bigspin
	name = "{NAME} Big Spin"
	desc = "A large wheel with point values. The larger values are smaller on the wheel. There's a slot for a token."
	icon = 'icons/obj/economy.dmi'
	icon_state = "slots1"

	var/static/list/prizes = list(
		"1" = BIGSPIN_CHANCE_1,
		"5" = BIGSPIN_CHANCE_5,
		"10" = BIGSPIN_CHANCE_10,
		"50" = BIGSPIN_CHANCE_50
	)

/obj/structure/fnafarcade/bigspin/examine(mob/user)
	..()
	to_chat(user, "<span class='notice'><b>Prizes:</b></span>")
	for(var/value in prizes)
		to_chat(user, "<span class='notice'>[FLOOR((prizes[value] / BIGSPIN_TOTAL) * 100, 1)]% - [value] tickets</span>")

/obj/structure/fnafarcade/bigspin/arcade_game()
	visible_message("\the [src] starts to spin...")
	flick("slots2", src)
	var/prize = pickweight(prizes)
	reward_tickets(text2num(prizes))
	say("[prize == "50" ? "JACKPOT!!! " : ""]You win [prize] ticket\s.")
	playing = FALSE
