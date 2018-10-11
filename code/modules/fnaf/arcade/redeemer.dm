/obj/machinery/fnaf_redeemer
	name = "ticket redeemer"
	desc = "Redeem your tickets for cool prizes"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "protolathe_n"
	resistance_flags = INDESTRUCTIBLE
	density = TRUE

	var/static/list/prizes = list(
		/obj/item/toy/beach_ball/holoball = 5,
		/obj/item/dice/d20 = 5,
		/obj/item/reagent_containers/food/snacks/monkeycube = 15,
		/obj/item/toy/cards/deck = 21,
		/obj/item/melee/baseball_bat = 30,
		/obj/item/storage/fancy/cigarettes = 30,
		/obj/item/lighter = 1,
		/obj/item/toy/cards/deck/syndicate = 30,
		/obj/item/gun/ballistic/automatic/pistol/APS = 45
	)

	var/static/list/prize_names = list()
	var/static/list/prize_by_name = list()

/obj/machinery/fnaf_redeemer/Initialize()
	. = ..()

	if(!prize_names.len)
		var/list/_prize_names = list()

		for(var/type in prizes)
			var/obj/item/thing = new type
			var/name = "[thing.name] - [prizes[type]]"
			_prize_names += name
			prize_by_name[name] = list(type, prizes[type])
		
		prize_names = _prize_names

/obj/machinery/fnaf_redeemer/attack_hand(mob/living/user)
	to_chat(user, "<span class='notice'>You must have tickets to use the redeemer.</span>")

/obj/machinery/fnaf_redeemer/attackby(obj/item/stack/tickets/tickets, mob/living/user, params)
	if(istype(tickets))
		var/prize = input(user, "Choose your prize", "[tickets.amount] Tickets") in prize_names|null
		if(prize)
			choose_prize(user, prize, tickets)
		return

	return ..()

/obj/machinery/fnaf_redeemer/proc/choose_prize(mob/living/user, prize_name, obj/item/stack/tickets/tickets)
	if(!Adjacent(user))
		return
	
	var/prize = prize_by_name[prize_name]

	if(prize)
		if(tickets.use(prize[2]))
			var/type = prize[1]
			user.put_in_hands(new type)
		else
			to_chat(user, "<span class='warning'>You don't have enough tickets!</span>")
