/datum/antagonist/scp
	name = "anomalous threat"
	roundend_category = "SCPs" //just in case
	antagpanel_category = "SCP"
	job_rank = ROLE_SCP
	antag_moodlet = /datum/mood_event/focused
	var/datum/team/scp/scp_team
	var/always_new_team = FALSE //If not assigned a team by default ops will try to join existing ones, set this to TRUE to always create new team.
	var/send_to_spawnpoint = TRUE //Should the user be moved to default spawnpoint.
	var/datum/species/scp_species = /datum/species/krokodil_addict
	var/mob/spawn_mob

/datum/antagonist/scp/proc/equip_op()
	if(!ishuman(owner.current) && scp_species)
		if(!spawn_mob)
			return
		var/mob/new_mob = new spawn_mob(owner.loc)
		new_mob.key = owner.current.key
		var/mob/old_mob = owner
		owner = new_mob
		qdel(old_mob)
		return TRUE
	var/mob/living/carbon/human/H = owner.current
	H.set_species(scp_species)
	return TRUE

/datum/antagonist/scp/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0)
	to_chat(owner, "<span class='notice'>You are a [scp_team ? scp_team.scp_name : "scp"] entity!</span>")
	owner.announce_objectives()
	return

/datum/antagonist/scp/on_gain()
	forge_objectives()
	. = ..()
	equip_op()
	if(send_to_spawnpoint)
		move_to_spawnpoint()

/datum/antagonist/scp/get_team()
	return scp_team

/datum/antagonist/scp/proc/forge_objectives()
	if(scp_team)
		owner.objectives |= scp_team.objectives

/datum/antagonist/scp/proc/move_to_spawnpoint()
	var/team_number = 1
	if(scp_team)
		team_number = scp_team.members.Find(owner)
	owner.current.forceMove(GLOB.scp_start[((team_number - 1) % GLOB.scp_start.len) + 1])

/datum/antagonist/scp/create_team(datum/team/scp/new_team)
	if(!new_team)
		if(!always_new_team)
			for(var/datum/antagonist/scp/N in GLOB.antagonists)
				if(!N.owner)
					continue
				if(N.scp_team)
					scp_team = N.scp_team
					return
		scp_team = new /datum/team/scp
		scp_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	scp_team = new_team

/datum/antagonist/scp/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.assigned_role = ROLE_SCP
	new_owner.add_antag_datum(src)
	message_admins("[key_name_admin(admin)] has scp'ed [new_owner.current].")
	log_admin("[key_name(admin)] has nuke scp'ed [new_owner.current].")

/datum/antagonist/scp/get_admin_commands()
	. = ..()

/datum/antagonist/scp/proc/admin_send_to_base(mob/admin)
	owner.current.forceMove(pick(GLOB.scp_start))

/datum/antagonist/scp/proc/admin_tell_code(mob/admin)
	var/code
	for (var/obj/machinery/nuclearbomb/bombue in GLOB.machines)
		if (length(bombue.r_code) <= 5 && bombue.r_code != initial(bombue.r_code))
			code = bombue.r_code
			break
	if (code)
		antag_memory += "<B>Syndicate Nuclear Bomb Code</B>: [code]<br>"
		to_chat(owner.current, "The nuclear authorization code is: <B>[code]</B>")
	else
		to_chat(admin, "<span class='danger'>No valid nuke found!</span>")

/datum/antagonist/scp/statue
	name = "SCP-173"
	spawn_mob = /mob/living/simple_animal/hostile/statue/scp173

/datum/antagonist/scp/larry
	name = "SCP-106"
	scp_species = /datum/species/scp106

/datum/antagonist/scp/doctor
	name = "SCP-049"
	scp_species = /datum/species/scp049

/datum/team/scp
	var/scp_name = "SCP objects"
	var/core_objective = /datum/objective/hijack


/datum/team/scp/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O

/datum/team/scp/proc/scps_dead()
	for(var/I in members)
		var/datum/mind/scp_mind = I
		if(ishuman(scp_mind.current) && (scp_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/team/scp/proc/scps_escaped()
	var/obj/docking_port/mobile/S = SSshuttle.getShuttle("syndicate") //uh oh what to do
	return S && (is_centcom_level(S.z) || is_transit_level(S.z))

/datum/team/scp/antag_listing_name()
	if(scp_name)
		return "[scp_name]"
	else
		return "anomalous object"

/datum/team/scp/is_gamemode_hero()
	return SSticker.mode.name == "containment breach"
