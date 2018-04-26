/obj/effect/proc_holder/spell/targeted/touch/teleport_victim
	name = "Teleport Victim"
	desc = "Charges your hand with dark energy that can be used to teleport victims into your realm."
	hand_path = "/obj/item/melee/touch_attack/touchby106"
	cooldown_min = 20
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
	var/atom/movable/AM = target
	do_sparks(4, FALSE, AM.loc)
	AM.forceMove(pick(GLOB.larryrealm))


/obj/effect/proc_holder/spell/targeted/teleport
	name = "Plane Shift"
	desc = "Changes current plane of existance."
	nonabstract_req = 1
	clothes_req = 0

	var/returning = FALSE
	var/turf/return_loc
	var/sound1 = 'sound/weapons/zapbang.ogg'
	var/sound2 = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/targeted/teleport/perform(recharge = 1,mob/living/user = usr)
	if(!cast_check(1))
		revert_cast()
		return
	if(charge_type == "recharge" && recharge)
		INVOKE_ASYNC(src, .proc/start_recharge)
	playsound(get_turf(user), sound1, 50,1)
	if(!returning)
		return_loc = get_turf(user)
	cast(user)

/obj/effect/proc_holder/spell/targeted/teleport/cast(mob/user = usr)
	if(returning)
		user.forceMove(get_turf(return_loc))
		returning = FALSE
		playsound(get_turf(user), sound2, 50,1)
		return
	user.forceMove(pick(GLOB.larryrealm))
	returning = TRUE
	playsound(get_turf(user), sound2, 50,1)
	return
