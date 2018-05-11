/datum/species/scp049
	name = "SCP-049"
	id = "shadow"
	species_traits = list(NOBLOOD,NOEYES,NO_UNDERWEAR,NO_DNA_COPY)
	inherent_traits = list(TRAIT_STUNIMMUNE, TRAIT_RADIMMUNE,TRAIT_VIRUSIMMUNE,TRAIT_NOBREATH,TRAIT_RESISTHEAT,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOHUNGER,TRAIT_NOSLIPALL,TRAIT_SHOCKIMMUNE,TRAIT_NOCRITDAMAGE,TRAIT_SLEEPIMMUNE,TRAIT_NOFIRE,TRAIT_NOGUNS,TRAIT_PIERCEIMMUNE,TRAIT_NODISMEMBER,TRAIT_ANTIMAGIC)
	inherent_biotypes = list(MOB_ORGANIC, MOB_HUMANOID)
	use_skintones = FALSE
	armor = 3000
	siemens_coeff = 0
	punchdamagelow = 5
	punchdamagehigh = 14
	punchstunthreshold = 11 //about 40% chance to stun
	sexes = 0
	blacklisted = TRUE
	dangerous_existence = TRUE
	var/obj/effect/proc_holder/spell/targeted/touch/kill/touch
	var/obj/effect/proc_holder/spell/targeted/cure/raise

/datum/species/scp106/random_name(gender,unique,lastname)
	return "plague doctor"

/datum/species/scp049/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	if(ishuman(C))
		touch = new /obj/effect/proc_holder/spell/targeted/touch/kill
		raise = new /obj/effect/proc_holder/spell/targeted/cure
		C.mind.AddSpell(touch)
		C.mind.AddSpell(raise)
		C.equipOutfit(/datum/outfit/plaguedoctor)

/datum/species/scp049/on_species_loss(mob/living/carbon/C)
	if(touch)
		C.mind.RemoveSpell(touch)
	if(raise)
		C.mind.RemoveSpell(raise)
	..()
