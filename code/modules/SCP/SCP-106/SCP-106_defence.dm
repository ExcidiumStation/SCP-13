/mob/living/simple_animal/larry/attack_hand(mob/living/carbon/human/M)
	..()
	switch(M.a_intent)
		if("help")
			if (health > 0)
				visible_message("<span class='notice'>[M] [response_help] [src].</span>")
				M.acid_act(10,10)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

		if("grab")
			to_chat(M, "<span class='notice'>Your hands went deep into [src], like it's body is a liquid!</span>")
			to_chat(M, "<span class='danger'>IT BURNS!</span>")
			M.acid_act(15,50)

		if("harm", "disarm")
			if(M.has_trait(TRAIT_PACIFISM))
				to_chat(M, "<span class='notice'>You don't want to hurt [src]!</span>")
				return
			M.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
			visible_message("<span class='danger'>[M] [response_harm] [src]!</span>",\
			"<span class='userdanger'>[M] [response_harm] [src]!</span>", null, COMBAT_MESSAGE_RANGE)
			to_chat(M, "<span class='danger'>IT BURNS!</span>")
			playsound(loc, attacked_sound, 25, 1, -1)
			M.acid_act(10,50)
			return TRUE

/mob/living/simple_animal/larry/attack_hulk(mob/living/carbon/human/user, does_attack_animation = 0)
	if(user.a_intent == INTENT_HARM)
		if(user.has_trait(TRAIT_PACIFISM))
			to_chat(user, "<span class='notice'>You don't want to hurt [src]!</span>")
			return FALSE
		..(user, 1)
		playsound(loc, "punch", 25, 1, -1)
		visible_message("<span class='danger'>[user] has tried to punch [src]!</span>", \
			"<span class='userdanger'>[user] has tried to punch [src]!</span>", null, COMBAT_MESSAGE_RANGE)
		user.acid_act(10,50)
		to_chat(user, "<span class='danger'>IT BURNS!</span>")
		return TRUE

/mob/living/simple_animal/larry/attack_paw(mob/living/carbon/monkey/M)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			M.acid_act(10,50)
			to_chat(M, "<span class='danger'>IT BURNS!</span>")
			return 1
	if (M.a_intent == INTENT_HELP)
		if (health > 0)
			visible_message("<span class='notice'>[M.name] [response_help] [src].</span>")
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			M.acid_act(10,50)
			to_chat(M, "<span class='danger'>IT BURNS!</span>")

/mob/living/simple_animal/larry/attack_animal(mob/living/simple_animal/M)
	. = ..()
	if(.)
		M.acid_act(10,50)
		to_chat(M, "<span class='danger'>IT BURNS!</span>")
		return 0

/mob/living/simple_animal/larry/attack_slime(mob/living/simple_animal/slime/M)
	if(..()) //successful slime attack
		M.acid_act(10,50)
		to_chat(M, "<span class='danger'>IT BURNS!</span>")
		return 0

/mob/living/simple_animal/larry/attack_drone(mob/living/simple_animal/drone/M)
	if(M.a_intent == INTENT_HARM) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/simple_animal/larry/attack_threshold_check(damage, damagetype = BRUTE, armorcheck = "melee")
	var/temp_damage = damage
	if(!damage_coeff[damagetype])
		temp_damage = 0
	else
		temp_damage *= damage_coeff[damagetype]

	if(temp_damage >= 0 && temp_damage <= force_threshold)
		visible_message("<span class='warning'>[src] looks unharmed.</span>")
		return FALSE
	else
		apply_damage(damage, damagetype, null, getarmor(null, armorcheck))
		return TRUE

/mob/living/simple_animal/larry/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	if(Proj.damage_type == BURN)
		apply_damage(Proj.damage, Proj.damage_type)
		Proj.on_hit(src)
		if(speed < 3)
			speed = 3
			addtimer(VARSET_CALLBACK(src, speed, 2), 10)
	return 0

/mob/living/simple_animal/larry/ex_act(severity, target, origin)
	return 0

/mob/living/simple_animal/larry/blob_act(obj/structure/blob/B)
	return 0

/mob/living/simple_animal/larry/attackby(obj/item/O, mob/user, params)
	O.acid_act(10,50)


/mob/living/simple_animal/larry/do_attack_animation(atom/A, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()
