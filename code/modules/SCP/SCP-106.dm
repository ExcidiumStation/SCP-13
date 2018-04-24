/datum/species/scp106
	name = "106"
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
	fixed_mut_color = "000"
	var/datum/action/cooldown/touchby106/touch
	var/datum/action/cooldown/teleport106/teleport

/datum/species/scp106/random_name(gender,unique,lastname)
	return "old man"

/datum/species/scp106/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	C.AddComponent(/datum/component/pass_through)
	if(ishuman(C))
		touch = new
		teleport = new
		touch.Grant(C)
		teleport.Grant(C)

/datum/species/scp106/on_species_loss(mob/living/carbon/C)
	if(touch)
		touch.Remove(C)
	if(teleport)
		teleport.Remove(C)
	..()

/datum/action/cooldown/touchby106 //TODO

/datum/action/cooldown/teleport106 //TODO
