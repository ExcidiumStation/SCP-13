/datum/component/gender_swap
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/list/victims = list()
	var/old_wclass

/datum/component/gender_swap/Initialize(_victims = list())
	victims = _victims
	if(!isitem(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Someone put a gender_swap component on a non-item, aborting!")
	RegisterSignal(COMSIG_ITEM_PICKUP, .proc/start_swap)
	var/obj/item/A = parent
	old_wclass = A.w_class

/datum/component/gender_swap/proc/start_swap(mob/victim)
	if(!isitem(parent) || !isliving(victim))
		return FALSE
	var/mob/living/ML = victim
	var/obj/item/A = parent
	A.item_flags |= NODROP
	A.w_class = WEIGHT_CLASS_BULKY
	var/which_hand = BODY_ZONE_PRECISE_L_HAND
	if(!(ML.active_hand_index % 2))
		which_hand = BODY_ZONE_PRECISE_R_HAND
	to_chat(ML, "<span class='warning'>The [A] begins to sear your hand, burning the skin on contact, and you feel yourself unable to drop it.</span>")
	var/damage_coeff = 1
	if(ML in victims)
		damage_coeff = CLAMP((5000-(world.time - victims[ML]))/1000,1,5)
	ML.apply_damage(10*damage_coeff, BURN, which_hand) //administer damage
	ML.apply_damage(30*damage_coeff, TOX, which_hand)
	addtimer(CALLBACK(src, .proc/phase_one, ML), 200)

/datum/component/gender_swap/proc/phase_one(mob/living/victim)
	to_chat(victim, "<span class='warning'>Bones begin to shift and grind inside of you, and every single one of your nerves seems like it's on fire.</span>")
	addtimer(CALLBACK(src, .proc/phase_two, victim), 210)

/datum/component/gender_swap/proc/phase_two(mob/living/victim)
	to_chat(victim, "<span class='notice'>\The [victim] starts to scream and writhe in pain as their bone structure reforms.</span>")
	addtimer(CALLBACK(src, .proc/phase_three, victim), 300)

/datum/component/gender_swap/proc/phase_three(mob/living/victim)
	if(victim.gender == FEMALE) //swap genders
		victim.gender = MALE
	else
		victim.gender = FEMALE
	if(ishuman(victim))
		var/mob/living/carbon/human/H = victim
		H.hair_style = random_hair_style(H.gender)
		H.facial_hair_style = random_facial_hair_style(H.gender)
		H.update_body()
		H.update_hair()
	addtimer(CALLBACK(src, .proc/swap_finish, victim), 300)

/datum/component/gender_swap/proc/swap_finish(mob/living/victim)
	var/obj/item/A = parent
	to_chat(victim, "<span class='warning'>The burning begins to fade, and you feel your hand relax it's grip on the [A].</span>")
	A.flags_1 &= ~NODROP_1
	A.w_class = old_wclass
	victims[victim] = world.time
