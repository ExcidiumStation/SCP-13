/obj/effect/proc_holder/spell/targeted/touch/kill
	name = "killing touch"
	desc = "Takes life away from the victim"
	hand_path = "/obj/item/melee/touch_attack/touchby106"
	cooldown_min = 20
	action_icon_state = "gib"
	nonabstract_req = 1
	clothes_req = 0

/obj/item/melee/touch_attack/kill
	name = "\improper killing touch"
	desc = "One touch - one kill"
	catchphrase = "Let me cure you."
	on_use_sound = 'sound/magic/fleshtostone.ogg'
	icon_state = "fleshtostone"
	item_state = "fleshtostone"

/obj/item/melee/touch_attack/kill/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user) || user.lying || user.handcuffed) //getting hard after touching yourself would also be bad
		return
	if(user.lying || user.handcuffed)
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	var/mob/living/M = target
	if(M.stat == DEAD)
		to_chat(user, "<span class='warning'>[M] is dead already.</span>")
		return
	M.cured = TRUE //Mark them so they can be raised as zombie
	M.death()
	..()

/obj/effect/proc_holder/spell/targeted/cure
	name = "cure for plague"
	desc = "Raises cured individual at your command"
	var/raise_delay = 60
	range = 1
	nonabstract_req = 1
	clothes_req = 0

/obj/effect/proc_holder/spell/targeted/cure/can_target(mob/living/target)
	if(!ishuman(target))
		return FALSE
	var/mob/living/carbon/human/H = target
	if(!H.cured) //Should be killed by 049
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/cure/cast(list/targets, mob/living/user)
	for(target in targets)
		if(!ishuman(target))
			continue
		var/mob/living/carbon/human/H = target
		if(do_after(user, raise_delay, target = H))
		H.set_species(/datum/species/zombie/scp049_2)
		H.revive(TRUE)
