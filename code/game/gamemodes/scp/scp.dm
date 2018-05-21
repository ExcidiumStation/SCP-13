/datum/game_mode/scp
	name = "containment breach"
	config_tag = "breach"
	false_report_weight = 10
	required_players = 10 // 10 players - 2 players to be the scps = 8 players remaining
	required_enemies = 2
	recommended_enemies = 5
	antag_flag = ROLE_SCP
	enemy_minimum_age = 2

	var/list/pre_scps
	var/scp_antag_type = /datum/antagonist/scp
	var/datum/team/scp/scp_team

	announce_span = "danger"
	announce_text = "SCP facility compomised - containment breach detected, all personnel must evacuate ASAP!\n\
	<span class='danger'>SCPs</span>: Bring havoc to mankind and escape facility.\n\
	<span class='notice'>Crew</span>: Don't let SCP objects escape and survive at all costs!"

/datum/game_mode/scp/pre_setup()
	var/n_scp = min(round(num_players() / 5), antag_candidates.len, recommended_enemies)
	if(n_scp >= required_enemies)
		for(var/i = 0, i < n_scp, ++i)
			var/datum/mind/new_scp = pick_n_take(antag_candidates)
			pre_scps += new_scp
			new_scp.assigned_role = "SCP"
			new_scp.special_role = "SCP"
			log_game("[new_scp.key] (ckey) has been selected as an SCP")
		return TRUE
	else
		return FALSE
////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////

/datum/game_mode/scp/post_setup()
	//Assign the remaining operatives
	SSshuttle.emergencyCallTime = 20000 //have fun
	for(var/i = 1 to pre_scps.len)
		var/datum/mind/scp_mind = pre_scps[i]
		var/list/antagos = subtypesof(scp_antag_type)
		var/datum/antagonist/scp/antag = pick(antagos)
		scp_mind.add_antag_datum(antag)
		antagos -= antag
	return ..()

/datum/game_mode/scp/OnNukeExplosion(off_station)
	..()

/datum/game_mode/proc/are_scp_dead()
	for(var/datum/mind/scp_mind in get_antag_minds(/datum/antagonist/scp))
		if(ismob(scp_mind.current) && (scp_mind.current.stat != DEAD))
			return FALSE
	return TRUE

/datum/game_mode/scp/check_finished() //to be called by SSticker
	if(replacementmode && round_converted == 2)
		return replacementmode.check_finished()
	if((SSshuttle.emergency.mode == SHUTTLE_ENDGAME) || station_was_nuked)
		return TRUE
	..()

/datum/game_mode/scp/set_round_result()
	..()
	var result = check_win()
	if(result)
		SSticker.mode_result = "loss - scp escaped"
		SSticker.news_report = "SCP objects made it through our defenses and escaped facility!"
	else
		SSticker.mode_result = "win - crew prevented SCP from escape"
		SSticker.news_report = "SCP objects neutralized, facility secured!"

/datum/game_mode/scp/generate_report()
	return "Power shortage in local area seems to affect some of containment chambers. \
			Backup power generator appears to be inactive, despite being inspected at \[DATA EXPUNGED\] \
			Facility personnel should immediately inspect all chambers and prevent containment breach!"
