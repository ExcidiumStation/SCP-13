/datum/component/pass_through
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/oldpassflags

/datum/component/pass_through/Initialize()
	if(!ismovableatom(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Attempt to initialize component on non-movatom, aborting!")
	var/atom/movable/AM = parent
	oldpassflags = AM.passflags
	AM.passflags = PASSTABLE|PASSGLASS|PASSGRILLE|PASSBLOB|PASSMOB|PASSCLOSEDTURF|LETPASSTHROW
	RegisterSignal(COMSIG_MOVABLE_COLLIDE, .proc/pass_through)

/datum/component/pass_through/Destroy()
	var/atom/movable/AM = parent
	AM.passflags = oldpassflags

/datum/component/pass_through/pass_through(var/atom/A)
	A.acid_act(5,10)
