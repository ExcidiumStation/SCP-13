/obj/item/scp113
	name = "jasper rock"
	desc = "The red piece of quartz gleams with unnatural smoothness."
	icon_state = "scp113"
	force = 10.0
	throwforce = 10.0
	throw_range = 15
	throw_speed = 3

/obj/item/scp113/Initialize()
  . = ..()
  AddComponent(/datum/component/gender_swap)
