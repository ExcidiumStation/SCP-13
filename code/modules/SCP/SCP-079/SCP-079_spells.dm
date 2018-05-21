/obj/effect/proc_holder/spell/show_face
	name = "Show your face"
	desc = "Show you face to anyone around."
	nonabstract_req = 1
	clothes_req = 0

/obj/effect/proc_holder/spell/show_face/perform(recharge = 1,mob/living/user = usr)
	if(!cast_check(1))
		revert_cast()
		return
	if(istype(user,/mob/living/simple_animal/scp079))
		var/mob/living/simple_animal/scp079/lanky = user
		if(!lanky.can_be_seen())
			to_chat(user, "No one's looking at you!")
			revert_cast()
			return
		if(!lanky.dormant)
			to_chat(user, "You need to chill first.")
			revert_cast()
			return
	if(charge_type == "recharge" && recharge)
		INVOKE_ASYNC(src, .proc/start_recharge)
	cast(user)

/obj/effect/proc_holder/spell/show_face/cast(mob/user = usr)
	if(istype(user,/mob/living/simple_animal/scp079))
		var/mob/living/simple_animal/scp079/lanky = user
		lanky.enrage()
	return
