/obj/effect/proc_holder/spell/teleport
	name = "Plane Shift"
	desc = "Changes current plane of existance."
	nonabstract_req = 1
	clothes_req = 0

	var/returning = FALSE
	var/turf/return_loc
	var/sound1 = 'sound/weapons/zapbang.ogg'
	var/sound2 = 'sound/weapons/zapbang.ogg'

/obj/effect/proc_holder/spell/teleport/perform(recharge = 1,mob/living/user = usr)
	if(!cast_check(1))
		revert_cast()
		return
	if(charge_type == "recharge" && recharge)
		INVOKE_ASYNC(src, .proc/start_recharge)
	playsound(get_turf(user), sound1, 50,1)
	if(!returning)
		return_loc = get_turf(user)
	cast(user)

/obj/effect/proc_holder/spell/teleport/cast(mob/user = usr)
	if(returning)
		user.forceMove(get_turf(return_loc))
		returning = FALSE
		playsound(get_turf(user), sound2, 50,1)
		return
	user.forceMove(pick(GLOB.larryrealm))
	returning = TRUE
	playsound(get_turf(user), sound2, 50,1)
	return
