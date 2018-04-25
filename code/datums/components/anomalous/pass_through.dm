/datum/component/pass_through
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/oldpassflags

/datum/component/pass_through/Initialize()
	if(!ismovableatom(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Attempt to initialize component on non-movatom, aborting!")
	var/atom/movable/AM = parent
	oldpassflags = AM.pass_flags
	//AM.pass_flags = PASSTABLE|PASSGLASS|PASSGRILLE|PASSBLOB|PASSMOB|PASSCLOSEDTURF|LETPASSTHROW PASS FLAGS was a MISTAKE
	RegisterSignal(COMSIG_MOVABLE_COLLIDE, .proc/passing_through)

/datum/component/pass_through/Destroy()
	var/atom/movable/AM = parent
	AM.pass_flags = oldpassflags

/datum/component/pass_through/proc/passing_through(var/atom/A)
	//try something with step() or forcemove()
	A.acid_act(5,10)
	if(!ishuman(parent))
		return
	var/mob/living/carbon/human/H = parent
	var/datum/species/S = H.dna.species
	if(ismecha(A))
		S.speedmod += 10
	if(isstructure(A))
		S.speedmod += 20
	if(ismachinery(A))
		S.speedmod += 30
	spawn(5)
		S.speedmod = 0
