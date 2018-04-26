/datum/species/shadow/scp106
	name = "SCP-106"
	id = "larry"
	species_traits = list(NOBLOOD,NOEYES,NO_UNDERWEAR,NO_DNA_COPY)
	inherent_traits = list(TRAIT_STUNIMMUNE, TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_NOBREATH,TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_NOHUNGER,TRAIT_NOSLIPALL,TRAIT_SHOCKIMMUNE,TRAIT_NOCRITDAMAGE,TRAIT_SLEEPIMMUNE,TRAIT_NOFIRE,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_ANTIMAGIC)
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
	var/turf/open/indestructible/necropolis/air/realm/casino/bingo = pick(GLOB.larrykillplates)
	bingo.lucky = TRUE
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
