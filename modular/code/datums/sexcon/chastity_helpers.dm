/datum/sex_controller/proc/modular_chastitycourse_noise(mob/living/carbon/human/action_target)
	if(!user || QDELETED(user) || !istype(user))
		return TRUE
	if(force < SEX_FORCE_MID)
		return TRUE

	var/obj/item/chastity/chastity_item = null
	var/mob/living/carbon/human/sound_target = action_target

	if(action_target?.chastity_device)
		chastity_item = action_target.chastity_device
	else if(user?.chastity_device)
		chastity_item = user.chastity_device
		sound_target = user

	if(!chastity_item)
		return TRUE

	if(!prob(20 + (speed * 10)))
		return TRUE

	var/chastity_volume = 25
	switch(force)
		if(SEX_FORCE_MID)
			chastity_volume = 30
		if(SEX_FORCE_HIGH)
			chastity_volume = 40
		if(SEX_FORCE_EXTREME)
			chastity_volume = 50

	playsound(sound_target, chastity_item.chastity_move_sound ? chastity_item.chastity_move_sound : SFX_JINGLE_BELLS, chastity_volume, TRUE, -2, ignore_walls = FALSE)
	return TRUE

/datum/sex_controller/proc/modular_is_masochist_in_spiked_chastity()
	if(!HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		return FALSE
	if(!user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/datum/sex_controller/proc/modular_chastity_content_enabled_for(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(!H.client?.prefs)
		return TRUE
	return !!H.client.prefs.chastenable

/datum/sex_controller/proc/modular_chastity_content_enabled_for_pair()
	if(!modular_chastity_content_enabled_for(user))
		return FALSE
	if(target && target != user && !modular_chastity_content_enabled_for(target))
		return FALSE
	return TRUE

/datum/sex_controller/proc/modular_try_do_chastity_pain_effect(pain_amt, giving, masochist_spiked)
	if(!HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		return FALSE

	if(pain_amt >= PAIN_HIGH_EFFECT)
		if(masochist_spiked)
			to_chat(user, span_love(pick(GLOB.chastity_pain_high_masochist)))
		else
			to_chat(user, span_boldwarning(pick(GLOB.chastity_pain_high)))
		user.flash_fullscreen("redflash3")
		if(prob(70) && user.stat == CONSCIOUS)
			if(masochist_spiked)
				user.visible_message(span_warning("[user] shudders and whimpers as the chastity spikes bite in, seeming to savor the punishment."))
			else
				user.visible_message(span_warning("[user] writhes in pain as the chastity spikes dig bloody into their tortured flesh!"))
		return TRUE

	if(pain_amt >= PAIN_MED_EFFECT)
		if(masochist_spiked)
			to_chat(user, span_love(pick(GLOB.chastity_pain_medium_masochist)))
		else
			to_chat(user, span_boldwarning(pick(GLOB.chastity_pain_medium)))
		user.flash_fullscreen("redflash2")
		if(prob(50) && user.stat == CONSCIOUS)
			if(masochist_spiked)
				user.visible_message(span_warning("[user] trembles as the chastity spikes grind in, breathing out an eager, pained moan."))
			else
				user.visible_message(span_warning("[user] shudders in pain as the chastity spikes dig into their flesh!"))
		return TRUE

	if(pain_amt >= PAIN_MILD_EFFECT)
		if(masochist_spiked)
			to_chat(user, span_love(pick(GLOB.chastity_pain_low)))
		else
			to_chat(user, span_boldwarning(pick(GLOB.chastity_pain_low)))
		user.flash_fullscreen("redflash1")
		if(prob(30) && user.stat == CONSCIOUS)
			if(masochist_spiked)
				user.visible_message(span_warning("[user] shivers as the chastity spikes tease their flesh, eyes half-lidded."))
			else
				user.visible_message(span_warning("[user] groans as the chastity spikes prod their flesh..."))
		return TRUE

	return FALSE

/datum/sex_controller/proc/modular_has_chastity_penis()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		var/has_penis = !!user.getorganslot(ORGAN_SLOT_PENIS)
		if(!has_penis)
			return FALSE
		// Cursed mode 1 and 3 expose penis access.
		return !(device.cursed_front_mode == 1 || device.cursed_front_mode == 3)
	if(HAS_TRAIT(user, TRAIT_CHASTITY_FULL) || HAS_TRAIT(user, TRAIT_CHASTITY_CAGE) || HAS_TRAIT(user, TRAIT_CHASTITY_PENIS_BLOCKED))
		return TRUE
	return FALSE

/datum/sex_controller/proc/modular_has_chastity_vagina()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		var/has_vagina = !!user.getorganslot(ORGAN_SLOT_VAGINA)
		if(!has_vagina)
			return FALSE
		// Cursed mode 2 and 3 expose vagina access.
		return !(device.cursed_front_mode == 2 || device.cursed_front_mode == 3)
	if(HAS_TRAIT(user, TRAIT_CHASTITY_FULL) || HAS_TRAIT(user, TRAIT_CHASTITY_VAGINA_BLOCKED))
		return TRUE
	return FALSE

/datum/sex_controller/proc/modular_has_chastity_cage()
	return modular_has_chastity_penis() || modular_has_chastity_vagina()

/datum/sex_controller/proc/modular_has_chastity_flat()
	var/obj/item/chastity/device = user?.chastity_device
	if(!istype(device, /obj/item/chastity/chastity_cage/flat))
		return FALSE
	return TRUE

/datum/sex_controller/proc/modular_has_chastity_anal()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		return !device.cursed_anal_open
	if(HAS_TRAIT(user, TRAIT_CHASTITY_ANAL) || HAS_TRAIT(user, TRAIT_CHASTITY_FULL))
		return TRUE
	return FALSE

/datum/sex_controller/proc/modular_can_use_penis()
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	if(modular_has_chastity_penis())
		return FALSE
	var/obj/item/organ/penis/penor = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	if(!penor.functional)
		return FALSE
	return TRUE

/datum/sex_controller/proc/modular_can_use_vagina()
	if(modular_has_chastity_vagina())
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_controller/proc/modular_try_handle_chastity_ejaculation()
	if(!(modular_has_chastity_cage() || modular_has_chastity_anal()))
		return FALSE
	if(!prob(50))
		return FALSE

	var/self_mess_msg = "[user] spills over [user.p_their()] own chastity!"
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		self_mess_msg = "[user] spurts over [user.p_their()] own spiked chastity!"

	user.visible_message(span_love(self_mess_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	cum_onto(user)
	return TRUE

/datum/sex_controller/proc/modular_get_chastity_climax_message(default_msg)
	var/climax_msg = default_msg
	if(modular_has_chastity_cage() || modular_has_chastity_anal())
		climax_msg = "[user] climaxes and makes a mess in their chastity device!"
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		climax_msg = "[user] climaxes and makes a messy release in their spiked chastity!"
	return climax_msg

/datum/sex_controller/proc/modular_adjust_action_for_target_chastity(mob/living/carbon/human/action_target, arousal_amt, pain_amt)
	if(HAS_TRAIT(action_target, TRAIT_CHASTITY_SPIKED))
		arousal_amt *= 0.75
		pain_amt *= 1.25
	return list(arousal_amt, pain_amt)

/datum/sex_controller/proc/modular_should_play_chastitycourse_noise(mob/living/carbon/human/action_target)
	if(user?.chastity_device || action_target?.chastity_device)
		return TRUE
	return FALSE
