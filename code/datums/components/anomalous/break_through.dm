/datum/component/break_through
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/passing = FALSE

/datum/component/break_through/Initialize()
	if(!ismob(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Attempt to initialize component on non-movatom, aborting!")
	RegisterSignal(COMSIG_MOVABLE_BUMP, .proc/breaking_through)

/datum/component/break_through/proc/breaking_through(var/atom/A)
	if(passing) //Prevent abuse
		return
	if(!ismob(parent))
		return
	passing = TRUE
	var/mob/M = parent
	var/move_delay = get_move_delay(A)
	if(do_after(M, move_delay, target = A))
		if(isclosedturf(A))
			var/turf/T = A
			T.ScrapeAway()
		if(isobj(A))
			var/obj/O = A
			qdel(O)
	passing = FALSE

/datum/component/break_through/proc/get_move_delay(var/atom/A)
	if(isclosedturf(A))//Walls
		return 15
	if(ismachinery(A))//Computers and doors
		return 10
	if(isstructure(A))//grills, windows, tables
		return 10
	if(ismecha(A))//mecha
		return 5
	return 0
