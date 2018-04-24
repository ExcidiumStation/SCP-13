#define CLOCKMODE_ROUGH 1
#define CLOCKMODE_COARSE 2
#define CLOCKMODE_ONEONE 3
#define CLOCKMODE_FINE 4
#define CLOCKMODE_VERYFINE 5

/* SCP 914 - Clockwork mechanism
Put things into INTAKE booth, click on panel in the middle - take resulting product from OUTPUT booth
TO ADD RECIPES:
1. find an item you want to use.
2. override proc for the mode(s) you want to used:
/atom/movable/proc/scp914_rough()

/atom/movable/proc/scp914_coarse()

/atom/movable/proc/scp914_one()

/atom/movable/proc/scp914_fine()

/atom/movable/proc/scp914_vfine()

You may use only one proc, but then selected item would be transformed on other modes by default.
By default Rough/Very Fine will process item on Coarse/Fine twice, define coarse/veryfine lists to specify any desired transformation
*/

/datum/component/clockwork
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mode = CLOCKMODE_ROUGH
	var/switch_state = "switch-1"
	var/process_time = 50
	var/icon = 'icons/obj/scp914.dmi'
	var/obj/structure/closet/scp914/int/intake
	var/obj/structure/closet/scp914/out/outputter
	var/processing = FALSE

/datum/component/clockwork/Initialize()
	if(!ismovableatom(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Someone put a clockwork component on a non-movatom, aborting!")
	RegisterSignal(COMSIG_ATOM_ATTACK_HAND, .proc/start_clock)
	RegisterSignal(COMSIG_CLICK_CTRL, .proc/turn_clockwise)
	RegisterSignal(COMSIG_CLICK_ALT, .proc/turn_cclockwise)
	var/atom/movable/A = parent
	A.anchored = 1
	A.density = 1
	var/intake_loc = locate(A.x-1,A.y,A.z)
	var/output_loc = locate(A.x+1,A.y,A.z)
	intake = new /obj/structure/closet/scp914/int(intake_loc)
	outputter = new /obj/structure/closet/scp914/out(output_loc)
	change_switch_icon(parent)

/datum/component/clockwork/proc/change_switch_icon(datum/parent)
	if(!ismovableatom(parent))
		return FALSE
	var/atom/movable/A = parent
	var/switch_state = "switch-[mode]"
	A.overlays.Cut()
	var/I = image(icon, switch_state)
	A.overlays += I

/datum/component/clockwork/proc/switch_mode(var/switching_mode) //0 is counter-clockwise, 1 is clockwise
	if(!switching_mode)
		if(mode <= CLOCKMODE_ROUGH)
			mode = CLOCKMODE_VERYFINE
		else
			mode--
	else
		if(mode >= CLOCKMODE_VERYFINE)
			mode = CLOCKMODE_ROUGH
		else
			mode++
	change_switch_icon(parent)

/datum/component/clockwork/proc/start_clock()
	intake.close()
	outputter.close()
	var/time = get_timer()
	addtimer(CALLBACK(src, .proc/finish_processing), time)

/datum/component/clockwork/proc/finish_processing()
	for(var/atom/movable/AM in intake)
		if(istype(AM, /obj/structure/closet/scp914/int))
			continue
		AM.forceMove(outputter.loc)
		var/atom/movable/product = AM.scp914_act(mode)
		if(product)
			product.forceMove(outputter.loc)
			qdel(AM)
	intake.open()
	outputter.open()

/datum/component/clockwork/proc/turn_clockwise(var/mob/user)
	increase_mode(user)

/datum/component/clockwork/proc/turn_cclockwise(var/mob/user)
	decrease_mode(user)

/datum/component/clockwork/proc/increase_mode(var/mob/user)
	switch_mode(TRUE)
	user.visible_message("[user] turned knob clockwise, switching mode to [get_mode()]", "You switched mode to [get_mode()]")

/datum/component/clockwork/proc/decrease_mode(var/mob/user)
	switch_mode(FALSE)
	user.visible_message("[user] turned knob counter-clockwise, switching mode to [get_mode()]", "You switched mode to [get_mode()]")

/datum/component/clockwork/proc/get_mode()
	var/text = "NONE"
	switch(mode)
		if(CLOCKMODE_ROUGH)
			text = "Rough"
		if(CLOCKMODE_COARSE)
			text = "Coarse"
		if(CLOCKMODE_ONEONE)
			text = "1:1"
		if(CLOCKMODE_FINE)
			text = "Fine"
		if(CLOCKMODE_VERYFINE)
			text = "Very Fine"
	return text

/datum/component/clockwork/proc/get_timer()
	var/timer = 0
	switch(mode)
		if(CLOCKMODE_VERYFINE)
			timer = process_time*3
		if(CLOCKMODE_FINE)
			timer = process_time*2
		if(CLOCKMODE_ONEONE)
			timer = process_time
		if(CLOCKMODE_COARSE)
			timer = process_time
		if(CLOCKMODE_ROUGH)
			timer = process_time
	return timer

/atom/movable/proc/scp914_act(var/mode) //DON'T OVERRIDE, override scp914_act_on_type instead
	if(!mode)
		return src

	switch(mode)
		if(1)
			var/atom/movable/special = scp914_rough()
			if(special)
				return special
			else
				var/atom/movable/choice = new parent_type
				if(choice)
					var/atom/movable/second_choice = choice.parent_type
					if(second_choice)
						var/atom/movable/atombychoice = new second_choice(loc)
						qdel(choice)
						if(atombychoice)
							return atombychoice
		if(2)
			var/atom/movable/special = scp914_coarse()
			if(special)
				return special
			else
				var/choice = parent_type
				if(choice)
					var/atom/movable/atombychoice = new choice(loc)
					if(atombychoice)
						return atombychoice
		if(3)
			var/atom/movable/special = scp914_one()
			if(special)
				return special
			else
				var/list/choices = subtypesof(parent_type)
				if(choices && choices.len > 0)
					for(var/atom/movable/typo in choices)
						var/atom/movable/choico = new typo
						if("[choico.parent_type]" != "[parent_type]")
							choices -= typo
						qdel(choico)
					if(choices.len > 0)
						var/choice = pick(choices)
						if(choice)
							var/atom/movable/atombychoice = new choice(loc)
							if(atombychoice)
								return atombychoice
		if(4)
			var/atom/movable/special = scp914_fine()
			if(special)
				return special
			else
				var/list/choices = subtypesof(src)
				if(choices && choices.len > 0)
					for(var/atom/movable/typo in choices)
						var/atom/movable/choico = new typo
						if("[choico.parent_type]" != "[type]")
							choices -= typo
						qdel(choico)
					if(choices.len > 0)
						var/choice = pick(choices)
						if(choice)
							var/atom/movable/atombychoice = new choice(loc)
							if(atombychoice)
								return atombychoice
		if(5) //TODO: Very Fine should give one SCP component to an output object
			var/atom/movable/special = scp914_vfine()
			if(special)
				return special
			else
				var/choice = pick(subtypesof(src))
				if(choice)
					var/atom/movable/atombychoice = new choice(loc)
					if(atombychoice)
						return atombychoice
	return
