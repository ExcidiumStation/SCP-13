/datum/component/gender_swap
	dupe_mode = COMPONENT_DUPE_UNIQUE
  var/list/victims = list()
  var/old_wclass

/datum/component/gender_swap/Initialize(_victims = list())
  victims = _victims
  if(!isatom(parent))
    . = COMPONENT_INCOMPATIBLE
    CRASH("Someone put a gender_swap component on a non-item, aborting!")
  RegisterSignal(COMSIG_ITEM_PICKUP, .proc/start_swap)
  var/atom/A = parent
  old_wclass = A.w_class

/datum/component/gernder_swap/proc/start_swap(mob/victim)
  if(!isatom(parent) || !isliving(user))
    return FALSE
  var/atom/A = parent
  A.flags_1 |= NODROP
  A.w_class = WEIGHT_CLASS_BULKY
  var/which_hand = BODY_ZONE_PRECISE_L_HAND
  if(!(victim.active_hand_index % 2))
    which_hand = BODY_ZONE_PRECISE_R_HAND
    to_chat(victim, "<span class='warning'>The [I.name] begins to sear your hand, burning the skin on contact, and you feel yourself unable to drop it.</span>")
	var/damage_coeff = 1
	if(victim in victims)
		damage_coeff = CLAMP((5000-(world.time - victims[victim]))/1000,1,5)
	victim.apply_damage(10*damage_coeff, BURN, which_hand, 0) //administer damage
	victim.apply_damage(30*damage_coeff, TOX, which_hand, 0)
  addtimer(CALLBACK(.proc/phase_one, victim), 200)
  "<span class='notice'>\The [user] starts to scream and writhe in pain as their bone structure reforms.</span>"), 410)

/datum/component/gernder_swap/proc/phase_one(mob/victim)
  to_chat(victim, "<span class='warning'>Bones begin to shift and grind inside of you, and every single one of your nerves seems like it's on fire.</span>")
  addtimer(CALLBACK(.proc/phase_two, victim), 210)

/datum/component/gernder_swap/proc/phase_two(mob/victim)
  to_chat(victim, "<span class='notice'>\The [user] starts to scream and writhe in pain as their bone structure reforms.</span>")
  addtimer(CALLBACK(.proc/phase_three, victim), 300)

/datum/component/gernder_swap/proc/phase_three(mob/victim)
  if(victim.gender == FEMALE) //swap genders
    victim.gender = MALE
  else
    victim.gender = FEMALE
  if(ishuman(user))
    var/mob/living/carbon/human/H = victim
    H.update_hair()
    H.update_body()
  addtimer(CALLBACK(.proc/swap_finish, victim), 300)

/datum/component/gernder_swap/proc/swap_finish(mob/victim)
  to_chat(victim, "<span class='warning'>The burning begins to fade, and you feel your hand relax it's grip on the [I.name].</span>")
	victims[victim] = world.time
  var/atom/A = parent
  A.flags_1 &= ~NODROP
  A.w_class = old_wclass
