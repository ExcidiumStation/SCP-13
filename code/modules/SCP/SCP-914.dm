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

/obj/structure/scp914
  name = "clockwork machine"
  desc = "Strange machinery with a lot of screw drives, belts, pulleys, gears, springs and other clockwork."
  icon = 'icons/obj/scp914.dmi'
  icon_state = "main"
  var/switch_state = "switch-1"
  var/process_time = 50
  anchored = 1
  density = 1
  resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF
  var/obj/structure/closet/scp914/int/intake
  var/obj/structure/closet/scp914/out/outputter
  var/mode = CLOCKMODE_ROUGH
  var/processing = FALSE

/obj/structure/scp914/New()
  var/intake_loc = locate(x-1,y,z)
  var/output_loc = locate(x+1,y,z)
  intake = new /obj/structure/closet/scp914/int(intake_loc)
  outputter = new /obj/structure/closet/scp914/out(output_loc)
  change_switch_icon()

/obj/structure/scp914/proc/switch_mode(var/switching_mode) //0 is counter-clockwise, 1 is clockwise
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
  change_switch_icon()

/obj/structure/scp914/proc/change_switch_icon()
  var/switch_state = "switch-[mode]"
  overlays.Cut()
  var/I = image(icon, switch_state)
  overlays += I

/obj/structure/scp914/verb/turn_clockwise()
	set category = "Object"
	set name = "Turn Switch (Clockwise)"
	set src in view(1)

	if (usr.incapacitated() || usr.restrained())
		return
  increase_mode(usr)

/obj/structure/scp914/verb/turn_cclockwise()
	set category = "Object"
	set name = "Turn Switch (Counter - clockwise)"
	set src in view(1)

	if (usr.incapacitated() || usr.restrained())
		return
  decrease_mode(usr)

/obj/structure/scp914/CtrlClick(mob/user)
  . = ..()
  if(.)
    return
  increase_mode(user)

/obj/structure/scp914/AltClick(mob/user)
  . = ..()
  if(.)
    return
  decrease_mode(user)

/obj/structure/scp914/proc/increase_mode(var/mob/user)
  switch_mode(TRUE)
  user.visible_message("[user] turned knob clockwise, switching mode to [get_mode()]", "You switched mode to [get_mode()]")

/obj/structure/scp914/proc/decrease_mode(var/mob/user)
  switch_mode(FALSE)
  user.visible_message("[user] turned knob counter-clockwise, switching mode to [get_mode()]", "You switched mode to [get_mode()]")

/obj/structure/scp914/proc/get_mode()
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

/obj/structure/scp914/proc/get_timer()
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

/obj/structure/scp914/attack_hand(mob/user)
  . = ..()
  if(.)
    return
  if(processing)
    to_chat(user, "It's no use - machine is processing right now!")
    return
  start_process()

/obj/structure/scp914/proc/start_process()
  intake.close()
  outputter.close()
  var/time = get_timer()
  addtimer(CALLBACK(src, .proc/finish_processing), time)

/obj/structure/scp914/proc/finish_processing()
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

/obj/structure/scp914/ex_act(severity)
  return

/obj/structure/scp914/emp_act(severity)
  return

/obj/structure/scp914/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
  return

/obj/structure/scp914/bullet_act(var/obj/item/projectile/Proj)
  return

//Copper booth - functionally similar to lockers
//You can't interact with them directly - only via panel

/obj/structure/closet/scp914/ex_act(severity)
  return

/obj/structure/closet/scp914/emp_act(severity)
  return

/obj/structure/closet/scp914/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
  return

/obj/structure/closet/scp914/bullet_act(var/obj/item/projectile/Proj)
  return

/obj/structure/closet/scp914/attackby(obj/item/weapon/W as obj, mob/user as mob)
  return

/obj/structure/closet/scp914/toggle(mob/user as mob)
  return

/obj/structure/closet/scp914/attack_ai(mob/user)
	return

/obj/structure/closet/scp914/relaymove(mob/user as mob)
	return

/obj/structure/closet/scp914/attack_hand(mob/user as mob)
	return

/obj/structure/closet/scp914/attack_self_tk(mob/user as mob)
	return

/obj/structure/closet/scp914/attack_ghost(mob/ghost)
	return

/obj/structure/closet/scp914/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys", var/wallbreaker)
  return

/obj/structure/closet/scp914/int
  name = "intake booth"
  desc = "Large copper booth labeled INTAKE."
  //icon = 'icons/obj/scp914booth.dmi'
  //icon_state = "intakeopen"
  //icon_closed = "intake"
  //icon_opened = "intakeopen"
  anchored = 1

/obj/structure/closet/scp914/int/Initialize()
  open()

/obj/structure/closet/scp914/out
  name = "output booth"
  desc = "Large copper booth labeled OUTPUT."
  //icon = 'icons/obj/scp914booth.dmi'
  //icon_state = "outputopen"
  //icon_closed = "output"
  //icon_opened = "outputopen"
  anchored = 1

/obj/structure/closet/scp914/out/Initialize()
  open()

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
