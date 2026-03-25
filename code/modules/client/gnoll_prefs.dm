/datum/gnoll_prefs
	var/gnoll_name = ""
	var/gnoll_pronouns = HE_HIM
	var/pelt_type = "firepelt"
	var/list/genitals = list(
		"penis" = FALSE,
		"vagina" = FALSE,
		"breasts" = FALSE
	)

/datum/gnoll_prefs/New()
	. = ..()
	if(!gnoll_name)
		gnoll_name = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"

/datum/gnoll_prefs/proc/gnoll_show_ui(mob/user)
	if(!user.client)
		return

	var/list/dat = list()
	dat += "<html><head><title>Gnoll Customization</title></head><body>"
	dat += "<center><h2>Choose your form to spread terror in the name of the GORESTAR!!</h2></center><br>"

	// Name section
	dat += "<b>Current Name:</b> [gnoll_name] "
	dat += "<a href='?_src_=gnoll_prefs;action=set_name'>Set Custom Name</a> | "
	dat += "<a href='?_src_=gnoll_prefs;action=random_name'>Random Gnoll Name</a><br><br>"

	// Pronouns section
	dat += "<b>Pronouns:</b> "
	var/list/pronoun_options = list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS)
	var/list/pronoun_display = list(
		HE_HIM = "He/Him",
		SHE_HER = "She/Her",
		THEY_THEM = "They/Them",
		IT_ITS = "It/Its"
	)
	for(var/pronoun in pronoun_options)
		var/display_pronoun = pronoun_display[pronoun] ? pronoun_display[pronoun] : pronoun
		if(gnoll_pronouns == pronoun)
			dat += "<b>[display_pronoun]</b> "
		else
			dat += "<a href='?_src_=gnoll_prefs;action=set_pronouns;pronouns=[pronoun]'>[display_pronoun]</a> "
	dat += "<br><br>"

	// Pelt type section
	dat += "<b>Pelt Pattern:</b> "
	var/list/pelt_options = list(
		"Firepelt" = "firepelt",
		"Rotpelt" = "rotpelt",
		"Whitepelt" = "whitepelt",
		"Bloodpelt" = "bloodpelt",
		"Nightpelt" = "nightpelt",
		"Darkpelt" = "darkpelt"
	)
	for(var/pelt_label in pelt_options)
		var/pelt_id = pelt_options[pelt_label]
		if(pelt_type == pelt_id)
			dat += "<b>[pelt_label]</b> "
		else
			dat += "<a href='?_src_=gnoll_prefs;action=set_pelt;pelt=[pelt_id]'>[pelt_label]</a> "
	dat += "<br><br>"

	// Genitals section
	dat += "<b>Genitals:</b><br>"
	var/list/genital_options = list(
		"Penis" = "penis",
		"Vagina" = "vagina",
		"Breasts" = "breasts"
	)
	for(var/genital_label in genital_options)
		var/genital_id = genital_options[genital_label]
		var/status = genitals[genital_id] ? "Yes" : "No"
		var/toggle_action = genitals[genital_id] ? "disable" : "enable"
		dat += "&nbsp;&nbsp;[genital_label]: [status] "
		dat += "<a href='?_src_=gnoll_prefs;action=toggle_genital;genital=[genital_id];toggle=[toggle_action]'>[toggle_action == "enable" ? "Enable" : "Disable"]</a><br>"
	dat += "<br>"

	dat += "<center><a href='?_src_=gnoll_prefs;action=close'>Close</a></center>"
	dat += "</body></html>"

	var/datum/browser/popup = new(user, "gnoll_prefs", "Gnoll Customization", 500, 600)
	popup.set_content(dat.Join())
	popup.open()

/datum/gnoll_prefs/proc/gnoll_process_link(mob/user, list/href_list)
	if(!user || !user.client)
		return

	var/action = href_list["action"]
	switch(action)
		if("set_name")
			var/new_name = input(user, "Enter a custom name for your gnoll:", "Gnoll Name", gnoll_name) as text|null
			if(new_name)
				gnoll_name = sanitize_name(new_name)
				gnoll_show_ui(user)

		if("random_name")
			gnoll_name = "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
			gnoll_show_ui(user)

		if("set_pronouns")
			var/new_pronouns = href_list["pronouns"]
			if(new_pronouns in list(HE_HIM, SHE_HER, THEY_THEM, IT_ITS))
				gnoll_pronouns = new_pronouns
				gnoll_show_ui(user)

		if("set_pelt")
			var/new_pelt = href_list["pelt"]
			var/list/valid_pelts = list("firepelt", "rotpelt", "whitepelt", "bloodpelt", "nightpelt", "darkpelt")
			if(new_pelt in valid_pelts)
				pelt_type = new_pelt
				gnoll_show_ui(user)

		if("toggle_genital")
			var/genital = href_list["genital"]
			var/toggle = href_list["toggle"]
			if(genital in genitals)
				genitals[genital] = (toggle == "enable")
				gnoll_show_ui(user)

		if("close")
			user << browse(null, "window=gnoll_prefs")

	return TRUE
