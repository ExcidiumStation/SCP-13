/mob/living/simple_animal/scp079
	name = "crying man"
	desc = "It's a long, thin, crying... man, for some reason he's hiding his face."
	real_name = "SCP-079"
	icon = 'icons/mob/penguins.dmi'
	icon_state = "penguin"
	icon_living = "penguin"
	icon_dead = "penguin_dead"
	gender = NEUTER
	mob_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	speak_emote = list("yell")
	response_help  = "pushes"
	response_disarm = "shoves"
	response_harm   = "claws"
	speak_chance = 0
	turns_per_move = 5
	speed = 0
	maxHealth = 1000
	health = 1000
	spacewalk = TRUE

	harm_intent_damage = 5
	obj_damage = 60
	melee_damage_lower = 30
	melee_damage_upper = 30

	var/enrage_speed = -3
	var/enrage_damage = 50
	var/enrage_duration = 200
	var/dormant = TRUE
	var/cannot_be_seen = 1

	attacktext = "slashes"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)

/mob/living/simple_animal/scp079/Initialize(mapload)
	mob_spell_list += new /obj/effect/proc_holder/spell/show_face(src)

/mob/living/simple_animal/scp079/proc/can_be_seen(turf/destination)
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_object)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(M.client && CanAttack(M) && !M.has_unlimited_silicon_privilege)
				if(!M.eye_blind)
					return M
		for(var/obj/mecha/M in view(world.view + 1, check)) //assuming if you can see them they can see you
			if(M.occupant && M.occupant.client)
				if(!M.occupant.eye_blind)
					return M.occupant
	return null

/mob/living/simple_animal/scp079/proc/enrage()
	AddComponent(/datum/component/break_through)
	harm_intent_damage = enrage_damage
	speed = enrage_speed
	status_flags |= GODMODE
	dormant = FALSE
	addtimer(CALLBACK(src, .proc/returndormant), enrage_duration)

/mob/living/simple_animal/scp079/proc/returndormant()
	harm_intent_damage = initial(harm_intent_damage)
	speed = initial(speed)
	status_flags &= ~GODMODE
	dormant = TRUE
	TakeComponent(/datum/component/break_through)
