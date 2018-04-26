GLOBAL_LIST_EMPTY(larryrealm)

/obj/effect/landmark/scp106_realm
	name = "realm teleport destination"
	icon = 'icons/effects/landmarks_static.dmi'

/obj/effect/landmark/scp106_realm/Initialize()
	..()
	GLOB.larryrealm += loc
	return INITIALIZE_HINT_QDEL
