/mob/living/simple_animal/larry
	name = "old strange creature"
	real_name = "SCP-106"
	desc = "Disgusting rotting creature, covered in a strange black goo. It... smiles?"
	gender = MALE
	icon = 'icons/mob/mob.dmi'
	icon_state = "larry"
	icon_living = "larry"
	mob_biotypes = list(MOB_INORGANIC, MOB_HUMANOID)
	maxHealth = 1000
	health = 1000
	spacewalk = TRUE
	healable = 0
	speed = 2
	speak_emote = list("whispers")
	emote_hear = list("wails.","laughs.")
	response_help  = "tries to touch"
	response_disarm = "tries to disarm"
	response_harm   = "tries to punch"
	speak_chance = 1
	melee_damage_lower = 5
	melee_damage_upper = 12
	melee_damage_type = TOX
	damage_coeff = list(BRUTE = 0, BURN = 1, TOX = -1, CLONE = 0, STAMINA = 1, OXY = 0) // 1 for full damage , 0 for none , -1 for 1:1 heal from that source
	attacktext = "touches"
	minbodytemp = 0
	maxbodytemp = INFINITY
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	stop_automated_movement = 1
	pressure_resistance = 100
	AIStatus = AI_OFF
	status_flags = 0
	faction = list("scp")
	status_flags = CANPUSH
	deathmessage = "slowly vanishes."
	gold_core_spawnable = NO_SPAWN
	var/touch_cooldown = 0
	var/scp106_spells_list = list(/obj/effect/proc_holder/spell/teleport)

/mob/living/simple_animal/larry/Initialize()
	. = ..()
	update_health_hud()
	AddComponent(/datum/component/pass_through)
	var/spellnum = 1
	for(var/spell in scp106_spells_list)
		var/the_spell = new spell(null)
		AddSpell(the_spell)
		var/obj/effect/proc_holder/spell/S = mob_spell_list[spellnum]
		var/pos = 2+spellnum*31
		if(scp106_spells_list.len >= 4)
			pos -= 31*(scp106_spells_list.len - 4)
		S.action.button.screen_loc = "6:[pos],4:-2"
		S.action.button.moved = "6:[pos],4:-2"
		spellnum++

/mob/living/simple_animal/larry/AltClickOn(atom/movable/A)
	if(!istype(A))
		return
	if(ismovableatom(A) && Adjacent(A))
		if(touch_cooldown <= world.time && !stat)
			do_sparks(4, FALSE, A.loc)
			A.forceMove(pick(GLOB.larryrealm))
			to_chat(src, "<span class='danger'><B>You teleport [A] into your realm.</span></B>")
			touch_cooldown = world.time + 50
		else
			to_chat(src, "<span class='danger'><B>Your powers are on cooldown! You must wait 5 seconds between teleports.</span></B>")
