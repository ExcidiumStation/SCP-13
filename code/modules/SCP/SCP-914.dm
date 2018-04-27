/obj/structure/scp914
	name = "clockwork machine"
	desc = "Strange machinery with a lot of screw drives, belts, pulleys, gears, springs and other clockwork."
	icon = 'icons/obj/scp914.dmi'
	icon_state = "main"
	anchored = 1
	density = 1
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | ACID_PROOF

/obj/structure/scp914/Initialize()
  . = ..()
  AddComponent(/datum/component/clockwork)

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
	anchored = 1

/obj/structure/closet/scp914/int/Initialize()
	open()

/obj/structure/closet/scp914/out
	name = "output booth"
	desc = "Large copper booth labeled OUTPUT."
	anchored = 1

/obj/structure/closet/scp914/out/Initialize()
	open()
