#define HANGMAN_STARTING_CHANCES 7

/obj/structure/fnafarcade/hangman
	name = "{NAME} Hang Out"
	desc = "A game of hangman plastered with pictures of clip-art pizza. Has a slot for a token."
	icon = 'icons/obj/contraband.dmi'
	icon_state = "poster2"
	var/static/list/hangman_puzzles = world.file2list("strings/fnaf/hangman.txt")
	var/chances
	var/current_puzzle
	var/current_solution
	var/letters_guessed
	var/list/letters

/obj/structure/fnafarcade/hangman/examine(mob/user)
	..()
	if(playing)
		to_chat(user, "It reads <b>[current_puzzle]</b>. There are <b>[chances]</b> chances left. Letters guessed: [letters_guessed].")

/obj/structure/fnafarcade/hangman/arcade_game()
	letters_guessed = ""
	current_solution = pick(hangman_puzzles)
	current_puzzle = ""
	for(var/_ in 1 to length(current_solution))
		current_puzzle += "_"
	say("New game started: [current_puzzle]")
	letters = GLOB.alphabet.Copy()
	chances = HANGMAN_STARTING_CHANCES

/obj/structure/fnafarcade/hangman/attack_hand(mob/living/user)
	. = ..()
	if(.) return
	var/letter = input(user, "Which letter do you want to guess?", current_puzzle) as null|anything in letters
	if(letter in letters)
		letters -= letter
		say("Letter guessed: [uppertext(letter)]")
		if(findtext(current_solution, letter))
			var/puzzle_text = current_solution
			for(var/unguessed_letter in letters)
				puzzle_text = replacetext(puzzle_text, unguessed_letter, "_")
			current_puzzle = puzzle_text
			say("There was a [uppertext(letter)]!")
			if(current_puzzle == current_solution)
				reward_tickets(length(current_solution))
				say("WINNER! The word was [current_solution].")
				playing = FALSE
				return
		else
			say("No [uppertext(letter)]s found...")
			letters_guessed += uppertext(letter)
			if(chances-- == 0) //0 chances left and they blew it
				say("Tough luck...the word was [current_solution].")
				playing = FALSE
				return
		say("Current puzzle: [current_puzzle]. Chances left: [chances]. Letters guessed: [letters_guessed].")
