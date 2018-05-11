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
		var/mob/new_mob = new spawn_mob(loc)
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
	to_chat(owner, "<span class='notice'>You are a [scp_team ? scp_team.syndicate_name : "scp"] entity!</span>")
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

/datum/antagonist/scp/leader/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.scp_leader_start))

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

/datum/antagonist/scp/statue/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0)
	to_chat(owner, "<B>You are the Syndicate [title] for this mission. You are responsible for the distribution of telecrystals and your ID is the only one who can open the launch bay doors.</B>")
	to_chat(owner, "<B>If you feel you are not up to this task, give your ID to another operative.</B>")
	to_chat(owner, "<B>In your hand you will find a special item capable of triggering a greater challenge for your team. Examine it carefully and consult with your fellow operatives before activating it.</B>")
	owner.announce_objectives()
	addtimer(CALLBACK(src, .proc/nuketeam_name_assign), 1)

/datum/antagonist/scp/larry
	name = "SCP-106"
	scp_species = /datum/species/scp106

/datum/team/scp
	var/scp_name = "Escapees"
	var/core_objective = /datum/objective/escape


/datum/team/scp/proc/update_objectives()
	if(core_objective)
		var/datum/objective/O = new core_objective
		O.team = src
		objectives += O

/datum/team/scp/proc/scps_dead()
	for(var/I in members)
		var/datum/mind/operative_mind = I
		if(ishuman(operative_mind.current) && (operative_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/team/scp/proc/scps_escaped()
	var/obj/docking_port/mobile/S = SSshuttle.getShuttle("syndicate") //uh oh what to do
	return S && (is_centcom_level(S.z) || is_transit_level(S.z))

/datum/team/scp/proc/get_result()
	var/evacuation = SSshuttle.emergency.mode == SHUTTLE_ENDGAME
	var/disk_rescued = disk_rescued()
	var/syndies_didnt_escape = !syndies_escaped()
	var/station_was_nuked = SSticker.mode.station_was_nuked
	var/nuke_off_station = SSticker.mode.nuke_off_station

	if(nuke_off_station == NUKE_SYNDICATE_BASE)
		return NUKE_RESULT_FLUKE
	else if(!disk_rescued && station_was_nuked && !syndies_didnt_escape)
		return NUKE_RESULT_NUKE_WIN
	else if (!disk_rescued &&  station_was_nuked && syndies_didnt_escape)
		return NUKE_RESULT_NOSURVIVORS
	else if (!disk_rescued && !station_was_nuked && nuke_off_station && !syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION
	else if (!disk_rescued && !station_was_nuked && nuke_off_station && syndies_didnt_escape)
		return NUKE_RESULT_WRONG_STATION_DEAD
	else if ((disk_rescued || evacuation) && operatives_dead())
		return NUKE_RESULT_CREW_WIN_SYNDIES_DEAD
	else if (disk_rescued)
		return NUKE_RESULT_CREW_WIN
	else if (!disk_rescued && operatives_dead())
		return NUKE_RESULT_DISK_LOST
	else if (!disk_rescued &&  evacuation)
		return NUKE_RESULT_DISK_STOLEN
	else
		return	//Undefined result

/datum/team/scp/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>[syndicate_name] Operatives:</span>"

	switch(get_result())
		if(NUKE_RESULT_FLUKE)
			parts += "<span class='redtext big'>Humiliating Syndicate Defeat</span>"
			parts += "<B>The crew of [station_name()] gave [syndicate_name] operatives back their bomb! The syndicate base was destroyed!</B> Next time, don't lose the nuke!"
		if(NUKE_RESULT_NUKE_WIN)
			parts += "<span class='greentext big'>Syndicate Major Victory!</span>"
			parts += "<B>[syndicate_name] operatives have destroyed [station_name()]!</B>"
		if(NUKE_RESULT_NOSURVIVORS)
			parts += "<span class='neutraltext big'>Total Annihilation</span>"
			parts +=  "<B>[syndicate_name] operatives destroyed [station_name()] but did not leave the area in time and got caught in the explosion.</B> Next time, don't lose the disk!"
		if(NUKE_RESULT_WRONG_STATION)
			parts += "<span class='redtext big'>Crew Minor Victory</span>"
			parts += "<B>[syndicate_name] operatives secured the authentication disk but blew up something that wasn't [station_name()].</B> Next time, don't do that!"
		if(NUKE_RESULT_WRONG_STATION_DEAD)
			parts += "<span class='redtext big'>[syndicate_name] operatives have earned Darwin Award!</span>"
			parts += "<B>[syndicate_name] operatives blew up something that wasn't [station_name()] and got caught in the explosion.</B> Next time, don't do that!"
		if(NUKE_RESULT_CREW_WIN_SYNDIES_DEAD)
			parts += "<span class='redtext big'>Crew Major Victory!</span>"
			parts += "<B>The Research Staff has saved the disk and killed the [syndicate_name] Operatives</B>"
		if(NUKE_RESULT_CREW_WIN)
			parts += "<span class='redtext big'>Crew Major Victory</span>"
			parts += "<B>The Research Staff has saved the disk and stopped the [syndicate_name] Operatives!</B>"
		if(NUKE_RESULT_DISK_LOST)
			parts += "<span class='neutraltext big'>Neutral Victory!</span>"
			parts += "<B>The Research Staff failed to secure the authentication disk but did manage to kill most of the [syndicate_name] Operatives!</B>"
		if(NUKE_RESULT_DISK_STOLEN)
			parts += "<span class='greentext big'>Syndicate Minor Victory!</span>"
			parts += "<B>[syndicate_name] operatives survived the assault but did not achieve the destruction of [station_name()].</B> Next time, don't lose the disk!"
		else
			parts += "<span class='neutraltext big'>Neutral Victory</span>"
			parts += "<B>Mission aborted!</B>"

	var/text = "<br><span class='header'>The syndicate operatives were:</span>"

	text += printplayerlist(members)
	text += "<br>"
	parts += text

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"

/datum/team/scp/antag_listing_name()
	if(syndicate_name)
		return "[scp_name]"
	else
		return "anomalous object"

/datum/team/scp/is_gamemode_hero()
	return SSticker.mode.name == "containment breach"
