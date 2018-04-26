/obj/effect/proc_holder/spell/targeted/touch/teleport_victim
	name = "Teleport Victim"
	desc = "Charges your hand with dark energy that can be used to teleport victims into your realm."
	hand_path = "/obj/item/melee/touch_attack/touchby106"
	cooldown_min = 200
	action_icon_state = "gib"
	clothes_req = 0

/obj/item/melee/touch_attack/touchby106
	name = "\improper teleporting touch"
	desc = "Teleports victim into your realm"
	catchphrase = "ha...ha...hh..."
	on_use_sound = 'sound/magic/disintegrate.ogg'
	icon_state = "disintegrate"
	item_state = "disintegrate"

//TODO: Realm and shit
/obj/item/melee/touch_attack/touchby106/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !ismob(target) || !iscarbon(user) || user.lying || user.handcuffed) //exploding after touching yourself would be bad
		return
	var/mob/M = target
	do_sparks(4, FALSE, M.loc)
	for(var/mob/living/L in view(src, 7))
		if(L != user)
			L.flash_act(affect_silicon = FALSE)
	var/atom/A = M.anti_magic_check()
	if(A)
		if(isitem(A))
			target.visible_message("<span class='warning'>[target]'s [A] glows brightly as it wards off the spell!</span>")
		user.visible_message("<span class='warning'>The feedback blows [user]'s arm off!</span>","<span class='userdanger'>The spell bounces from [M]'s skin back into your arm!</span>")
		user.flash_act()
		var/obj/item/bodypart/part
		var/index = user.get_held_index_of_item(src)
		if(index)
			part = user.hand_bodyparts[index]
		if(part)
			part.dismember()
		..()
		return
	M.gib()
	..()

/obj/effect/proc_holder/spell/targeted/teleport
	name = "To Realm"
	desc = "This spell teleports you to a type of area of your selection."
	nonabstract_req = 1
	clothes_req = 0

	var/randomise_selection = 0 //if it lets the usr choose the teleport loc or picks it from the list
	var/invocation_area = 1 //if the invocation appends the selected area
	var/sound1 = 'sound/weapons/zapbang.ogg'
	var/sound2 = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/targeted/teleport/perform(list/targets, recharge = 1,mob/living/user = usr)
	var/thearea = before_cast(targets)
	if(!thearea || !cast_check(1))
		revert_cast()
		return
	invocation(thearea,user)
	if(charge_type == "recharge" && recharge)
		INVOKE_ASYNC(src, .proc/start_recharge)
	cast(targets,thearea,user)
	after_cast(targets)

/obj/effect/proc_holder/spell/targeted/teleport/before_cast(list/targets)
	var/A = null

	if(!randomise_selection)
		A = input("Area to teleport to", "Teleport", A) as null|anything in GLOB.teleportlocs
	else
		A = pick(GLOB.teleportlocs)
	if(!A)
		return
	var/area/thearea = GLOB.teleportlocs[A]

	return thearea

/obj/effect/proc_holder/spell/targeted/teleport/cast(list/targets,area/thearea,mob/user = usr)
	playsound(get_turf(user), sound1, 50,1)
	for(var/mob/living/target in targets)
		var/list/L = list()
		for(var/turf/T in get_area_turfs(thearea.type))
			if(!T.density)
				var/clear = 1
				for(var/obj/O in T)
					if(O.density)
						clear = 0
						break
				if(clear)
					L+=T

		if(!L.len)
			to_chat(usr, "The spell matrix was unable to locate a suitable teleport destination for an unknown reason. Sorry.")
			return

		if(target && target.buckled)
			target.buckled.unbuckle_mob(target, force=1)

		var/list/tempL = L
		var/attempt = null
		var/success = 0
		while(tempL.len)
			attempt = pick(tempL)
			target.Move(attempt)
			if(get_turf(target) == attempt)
				success = 1
				break
			else
				tempL.Remove(attempt)

		if(!success)
			target.forceMove(L)
			playsound(get_turf(user), sound2, 50,1)

	return

/obj/effect/proc_holder/spell/targeted/teleport/invocation(area/chosenarea = null,mob/user = usr)
	if(!invocation_area || !chosenarea)
		..()
	else
		switch(invocation_type)
			if("shout")
				user.say("[invocation] [uppertext(chosenarea.name)]")
				if(user.gender==MALE)
					playsound(user.loc, pick('sound/misc/null.ogg','sound/misc/null.ogg'), 100, 1)
				else
					playsound(user.loc, pick('sound/misc/null.ogg','sound/misc/null.ogg'), 100, 1)
			if("whisper")
				user.whisper("[invocation] [uppertext(chosenarea.name)]")

	return


/datum/species/shadow/scp106
	name = "SCP-106"
	id = "larry"
	species_traits = list(NOBLOOD,NOEYES,NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_NOBREATH,TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_NOHUNGER,TRAIT_NOSLIPWATER,TRAIT_SHOCKIMMUNE,TRAIT_SLEEPIMMUNE,TRAIT_NOFIRE,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_ANTIMAGIC)
	inherent_biotypes = list(MOB_INORGANIC, MOB_HUMANOID)
	//mutant_organs = list(/obj/item/organ/adamantine_resonator)
	armor = 3000
	siemens_coeff = 0
	punchdamagelow = 5
	punchdamagehigh = 14
	punchstunthreshold = 11 //about 40% chance to stun
	no_equip = list(slot_wear_mask, slot_wear_suit, slot_gloves, slot_shoes, slot_w_uniform, slot_s_store)
	nojumpsuit = 1
	sexes = 0
	damage_overlay_type = ""
	//meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/golem
	blacklisted = TRUE
	dangerous_existence = TRUE
	var/obj/effect/proc_holder/spell/targeted/touch/teleport_victim/touch
	var/obj/effect/proc_holder/spell/targeted/teleport/tele

/datum/species/shadow/scp106/random_name(gender,unique,lastname)
	return "old man"

/datum/species/shadow/scp106/spec_life(mob/living/carbon/human/H)
	if(H.has_trait(TRAIT_NOBREATH))
		H.setOxyLoss(0)
		H.losebreath = 0

		var/takes_crit_damage = (!H.has_trait(TRAIT_NOCRITDAMAGE))
		if((H.health < HEALTH_THRESHOLD_CRIT) && takes_crit_damage)
			H.adjustBruteLoss(1)
/datum/species/shadow/scp106/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	C.AddComponent(/datum/component/pass_through)
	if(ishuman(C))
		touch = new /obj/effect/proc_holder/spell/targeted/touch/teleport_victim
		tele = new /obj/effect/proc_holder/spell/targeted/teleport
		C.mind.AddSpell(touch)
		C.mind.AddSpell(tele)

/datum/species/shadow/scp106/on_species_loss(mob/living/carbon/C)
	if(touch)
		C.mind.RemoveSpell(touch)
	if(tele)
		C.mind.RemoveSpell(tele)
	..()
