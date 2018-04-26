/datum/component/paranoid
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/paranoid/Initialize()
	if(!isatom(parent))
		. = COMPONENT_INCOMPATIBLE
		CRASH("Attempt to initialize component on non-atom, aborting!")
	RegisterSignal(COMSIG_PARENT_EXAMINE, .proc/give_paranoia)

/datum/component/paranoid/proc/give_paranoia(var/mob/M)
	if(!iscarbon(C))
		to_chat(M, "You see nothing strange about that thing.")
		return
	var/mob/living/carbon/C = M
	to_chat(C, "This thing... is disturbing.")
	C.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_LOBOTOMY)
