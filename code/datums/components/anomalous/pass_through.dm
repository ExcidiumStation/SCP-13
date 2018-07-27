/datum/component/pass_through
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/passing = FALSE

/datum/component/pass_through/Initialize()
	if(!ismob(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Attempt to initialize component on non-movatom, aborting!")
	//var/atom/movable/AM = parent
	//AM.pass_flags = PASSTABLE|PASSGLASS|PASSGRILLE|PASSBLOB|PASSMOB|PASSCLOSEDTURF|LETPASSTHROW PASS FLAGS was a MISTAKE
	RegisterSignal(COMSIG_MOVABLE_BUMP, .proc/passing_through)

/datum/component/pass_through/proc/passing_through(var/atom/A)
	if(passing) //Prevent abuse
		return
	if(!ismob(parent))
		return
	passing = TRUE
	var/mob/M = parent
	var/move_delay = get_move_delay(A)
	if(do_after(M, move_delay, target = A))
		A.acid_act(10,50) //TODO: special acid?
		spawn(2)
		M.forceMove(get_turf(A))
	passing = FALSE

/datum/component/pass_through/proc/get_move_delay(var/atom/A)
	if(isclosedturf(A))//Walls
		return 15
	if(ismachinery(A))//Computers and doors
		return 10
	if(isstructure(A))//grills, windows, tables
		return 10
	if(ismecha(A))//mecha
		return 5
	return 0
