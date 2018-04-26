/obj/structure/sign/scp099
	name = "portrait"
	icon = 'icons/obj/contraband.dmi'
	icon_state = "poster2"

/obj/structure/sign/scp099/Initialize()
	. = ..()
	AddComponent(/datum/component/paranoid)
