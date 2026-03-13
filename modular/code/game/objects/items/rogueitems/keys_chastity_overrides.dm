// Modular override handlers for core key item attack procs.

/obj/item/roguekey/lord/proc/modular_chastity_attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return null

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]'s groin is covered. I can't see a cage let alone unlock one!"))
		return TRUE
	if(!H.chastity_device)
		to_chat(user, span_warning("[H] isn't wearing a chastity device. Against Astrata's Will their genitals are free ranged."))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.chastity_cursed ? pick(GLOB.chastity_cursed_lock) : pick(GLOB.chastity_lock_denial)))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	var/new_locked_state = !device.locked
	if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, new_locked_state, "key") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
		to_chat(user, span_warning(device.chastity_cursed ? pick(GLOB.chastity_cursed_lock) : pick(GLOB.chastity_lock_denial)))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	if(device.locked)
		user.visible_message(span_notice("[user] unlocks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, FALSE, user, src, "key")
	else
		user.visible_message(span_notice("[user] locks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, TRUE, user, src, "key")

	return TRUE

/obj/item/lockpick/proc/modular_chastity_attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return null
	if(!ishuman(user))
		to_chat(user, span_warning("I can't get enough control to pick this lock."))
		return TRUE

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]'s groin is covered. I can't reach the lock."))
		return TRUE
	if(!H.chastity_device)
		to_chat(user, span_warning("[H] isn't wearing a chastity device."))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.chastity_cursed ? pick(GLOB.chastity_cursed_lock) : pick(GLOB.chastity_lock_denial)))
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		return TRUE
	if(!device.locked)
		to_chat(user, span_notice("[H]'s chastity device is already unlocked."))
		return TRUE

	var/mob/living/carbon/human/U = user
	var/pickskill = U.get_skill_level(/datum/skill/misc/lockpicking)
	var/perbonus = U.STAPER / 5
	var/picktime = clamp(60 - (pickskill * 8), 15, 60)
	var/pickchance = 25 + (pickskill * 10) + perbonus
	pickchance *= picklvl
	pickchance = clamp(pickchance, 5, 95)

	user.visible_message(span_notice("[user] starts picking the lock on [H]'s chastity device..."), span_notice("I start picking the lock on [H]'s chastity device..."))
	if(!do_after(user, picktime, target = H))
		return TRUE

	// Re-validate after the timed action in case state changed mid-pick.
	var/obj/item/chastity/current_device = H.chastity_device
	if(!current_device || !current_device.lockable)
		to_chat(user, span_warning("The lock is no longer there."))
		return TRUE
	if(!current_device.locked)
		to_chat(user, span_notice("[H]'s chastity device is already unlocked."))
		return TRUE

	if(prob(pickchance))
		if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, src, FALSE, "lockpick") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
			playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
			to_chat(user, span_warning(current_device.chastity_cursed ? pick(GLOB.chastity_cursed_lock) : pick(GLOB.chastity_lock_denial)))
			return TRUE

		playsound(src, pick('sound/items/pickgood1.ogg', 'sound/items/pickgood2.ogg'), 30, TRUE)
		to_chat(user, span_green("The lock gives way."))
		current_device.set_chastity_locked_state(H, FALSE, user, src, "lockpick")
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 2)
	else
		playsound(src, 'sound/items/pickbad.ogg', 40, TRUE)
		take_damage(1, BRUTE, "blunt")
		to_chat(user, span_warning("Clack."))
		if(U.mind)
			add_sleep_experience(U, /datum/skill/misc/lockpicking, U.STAINT / 4)

	return TRUE
