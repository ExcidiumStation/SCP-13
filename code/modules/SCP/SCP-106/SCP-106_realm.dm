GLOBAL_LIST_EMPTY(larryrealm)
GLOBAL_LIST_EMPTY(larrykillplates)

/obj/effect/landmark/scp106_realm
	name = "realm teleport destination"
	icon = 'icons/effects/landmarks_static.dmi'

/obj/effect/landmark/scp106_realm/Initialize()
	..()
	GLOB.larryrealm += loc
	return INITIALIZE_HINT_QDEL

/turf/open/indestructible/necropolis/air/realm/Entered(var/mob/AM)
	AM.acid_act(1,1)

/turf/open/indestructible/necropolis/air/realm/casino
	var/lucky = FALSE

/turf/open/indestructible/necropolis/air/realm/casino/Initialize()
	. = ..()
	GLOB.larryrealm += src

/turf/open/indestructible/necropolis/air/realm/casino/Entered(var/mob/AM)
	..()
	if(!lucky)
		AM.gib()
	else
		wow_you_lucky(AM)

/turf/open/indestructible/necropolis/air/realm/casino/proc/wow_you_lucky(var/mob/user)
	var/return_area = null
	return_area = input("Area to land", "Select a Zone to return", return_area) in GLOB.teleportlocs
	var/area/picked_area = GLOB.teleportlocs[return_area]
	if(!user || QDELETED(user))
		return

	var/list/L = list()
	for(var/turf/T in get_area_turfs(picked_area.type))
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L.len)
		to_chat(user, "Can't find a nice place to teleport.")
		return

	var/list/tempL = L
	var/attempt = null
	var/success = 0
	while(tempL.len)
		attempt = pick(tempL)
		user.Move(attempt)
		if(get_turf(user) == attempt)
			success = 1
			break
		else
			tempL.Remove(attempt)

	if(!success)
		user.forceMove(L)
	return
