/obj/item/stack/spacecash  //Don't use base space cash stacks. Any other space cash stack can merge with them, and could cause potential money duping exploits.
	name = "monopoly money"
	desc = "It's worth nothing."
	singular_name = "bill"
	icon = 'icons/obj/economy.dmi'
	icon_state = "spacecash"
	amount = 1
	max_amount = 20
	throwforce = 0
	throw_speed = 2
	throw_range = 2
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	var/value = 0

/obj/item/stack/spacecash/c1
	icon_state = "spacecash"
	value = 1

/obj/item/stack/spacecash/c10
	icon_state = "spacecash10"
	value = 10

/obj/item/stack/spacecash/c20
	icon_state = "spacecash20"
	value = 20

/obj/item/stack/spacecash/c50
	icon_state = "spacecash50"
	value = 50

/obj/item/stack/spacecash/c100
	icon_state = "spacecash100"
	value = 100

/obj/item/stack/spacecash/c200
	icon_state = "spacecash200"
	value = 200

/obj/item/stack/spacecash/c500
	icon_state = "spacecash500"
	value = 500

/obj/item/stack/spacecash/c1000
	icon_state = "spacecash1000"
	value = 1000
