/obj/item/stack/tickets
	name = "tickets"
	singular_name = "ticket"
	icon = 'icons/obj/economy.dmi'
	icon_state = "spacecash"
	amount = 1
	max_amount = 100
	throwforce = 0
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE

//test
/obj/item/stack/tickets/max
	amount = 100

/obj/item/coin/token
	name = "token"
	cmineral = "silver"
	icon_state = "coin_silver_heads"
	value = 0

/obj/item/coin/token/examine(mob/user)
	to_chat(user, "A token from [station_name()].")
	..()
