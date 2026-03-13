// Self-equip flow: validates wearer state, then applies standard chastity setup.
/obj/item/chastity/attack_self(mob/user) // self equipping chastity device
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.client?.prefs && !H.client.prefs.chastenable)
		to_chat(user, span_warning("I have chastity content disabled."))
		return
	if(!can_cage_target(H, user))
		return
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("My groin is not accessible!"))
		return
	if(H.chastity_device)
		to_chat(user, span_warning("I am already wearing a chastity device!"))
		return
	if(!chastity_genital_check(H))
		to_chat(user, span_warning("I don't have the required genitalia for the [src]."))
		return
	ensure_chastity_feature(H)
	user.visible_message(span_notice("I attempt to chasten my genitals with the [src]..."))
	if(do_after(user, 50, needhand = 1, target = H))
		equip_standard_chastity(H, user)
	..()

// Equip-other flow: handles normal devices and cursed devices with master-binding logic.
/obj/item/chastity/attack(mob/M, mob/user, def_zone) // equipping others with chastity device
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.client?.prefs && !H.client.prefs.chastenable)
		to_chat(user, span_warning("[H] has chastity content disabled."))
		return
	if(user?.client?.prefs && !user.client.prefs.chastenable)
		to_chat(user, span_warning("I have chastity content disabled."))
		return
	if(!can_cage_target(H, user))
		return
	if(H.chastity_device == src)
		attack_self(user)
		return
	if(H.chastity_device)
		to_chat(user, span_warning("[H] is already wearing a chastity device!"))
		return
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("The groin area is not accessible!"))
		return
	if(!chastity_genital_check(H))
		to_chat(user, span_warning("[H] does not have the required genitalia for the [src]."))
		return
	user.visible_message(span_notice("[user] tries to put the [src] on [H]..."))
	if(chastity_cursed)
		if(H == user)
			to_chat(user, span_warning("I cannot fasten a cursed chastity device on myself."))
			return
		if(!chastity_master)
			to_chat(user, span_warning("The cursed device rejects binding without an imprinted master."))
			return

		var/equip_time = 50
		if(H.surrendering || H.has_status_effect(/datum/status_effect/surrender/collar))
			equip_time = 25
		if(!do_after(user, equip_time, needhand = 1, target = H))
			return

		ensure_chastity_feature(H)
		attach_chastity_feature(H)

		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
		finalize_chastity_equip(H)
		// Handle cursed binding
		if(chastity_master)
			var/datum/component/collar_master/CM = chastity_master.GetComponent(/datum/component/collar_master)
			if(!CM)
				CM = chastity_master.AddComponent(/datum/component/collar_master)
			CM.add_pet(H)
			SEND_SIGNAL(H, COMSIG_CARBON_GAIN_CHASTITY, src)
		locked = TRUE
		if(cursed_front_mode < 0 || cursed_front_mode > 3)
			cursed_front_mode = 0
		apply_cursed_state(H)
	else
		ensure_chastity_feature(H)
		user.visible_message(span_notice("I attempt to chasten my genitals with the [src]..."))
		if(do_after(user, 50, needhand = 1, target = H))
			equip_standard_chastity(H, user)
	..()

// Shared helper for standard equip path: visual attach, ownership setup, key spawn, and traits.
/obj/item/chastity/proc/equip_standard_chastity(mob/living/carbon/human/H, mob/user)
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
	if(!attach_chastity_feature(H))
		return FALSE
	finalize_chastity_equip(H)
	generate_chastity_key(user, H)
	apply_standard_chastity_traits(H)
	return TRUE

// Unequips the device and removes all chastity-related state/traits from the wearer.
/obj/item/chastity/proc/remove_chastity(mob/living/carbon/human/H)
	if(H.chastity_device != src)
		return
	var/mob/living/carbon/human/old_wearer = H
	clear_chastity_mood_effects(H)
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED)
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)
	chastity_move_counter = 0
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(chest && chastity_feature)
		chest.remove_bodypart_feature(chastity_feature)
	H.chastity_device = null
	chastity_feature = null
	chastity_victim = null
	REMOVE_TRAIT(H, TRAIT_CHASTITY_FULL, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_CAGE, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_PENIS_BLOCKED, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_VAGINA_BLOCKED, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_ANAL, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_SPIKED, TRAIT_SOURCE_CHASTITY)
	if(locked)
		REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
		locked = FALSE
	// Handle cursed unbinding
	if(chastity_cursed && chastity_master)
		SEND_SIGNAL(H, COMSIG_CARBON_LOSE_CHASTITY)
		// Find and remove from master's pet list
		for(var/datum/mind/M in GLOB.collar_masters)
			var/datum/component/collar_master/CM = M.GetComponent(/datum/component/collar_master)
			if(CM && (H in CM.my_pets))
				CM.remove_pet(H)
				break
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	old_wearer.update_body_parts(TRUE)
	old_wearer.update_inv_belt()

// Emergency physical removal for non-cursed locked devices. Requires tools and risks groin injury.
/obj/item/chastity/proc/attempt_forced_removal(mob/living/carbon/human/H, mob/user)
	if(!H || !user)
		return FALSE
	if(H.chastity_device != src)
		return FALSE
	if(!locked)
		to_chat(user, span_notice("The device is already unlocked."))
		return FALSE
	if(!lockable)
		to_chat(user, span_warning("This chastity device cannot be forced open this way."))
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("I can't reach the lock while [H]'s groin is covered."))
		return FALSE

	var/success_chance = 25
	if(ishuman(user))
		var/mob/living/carbon/human/U = user
		success_chance += (U.STALUC - 10) * 4
	success_chance = clamp(success_chance, 5, 80)

	user.visible_message(span_warning("[user] braces a chisel against [H]'s chastity lock and starts hammering!"), span_warning("I brace a chisel against [H]'s chastity lock and start hammering!"))
	while(H.chastity_device == src && locked)
		if(!do_after(user, 60, needhand = 1, target = H))
			return TRUE
		if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			to_chat(user, span_warning("I lose access to the lock and have to stop."))
			return TRUE

		playsound(get_turf(H), 'sound/combat/hits/bladed/genstab (1).ogg', 45, TRUE)
		H.apply_damage(rand(8,16), BRUTE, BODY_ZONE_PRECISE_GROIN)

		if(prob(35) && ishuman(user))
			var/mob/living/carbon/human/U = user
			U.apply_damage(rand(2,6), BRUTE, pick(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND))
			to_chat(user, span_warning("The chisel slips and nicks my hand."))

		if(prob(success_chance))
			user.visible_message(span_notice("[user] finally pries [H]'s chastity device open."), span_notice("I finally pry the chastity device open."))
			locked = FALSE
			REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
			remove_chastity(H)
			if(!user.put_in_hands(src))
				forceMove(get_turf(H))
			return TRUE
		else
			to_chat(user, span_warning("The lock holds. I need another strike."))

	return TRUE

// Emergency break path used by werewolf transformation to destroy incompatible devices.
/obj/item/chastity/proc/break_on_werewolf_transform(mob/living/carbon/human/H)
	if(!H)
		return
	if(H.chastity_device != src)
		return

	if(HAS_TRAIT(H, TRAIT_CHASTITY_SPIKED))
		H.visible_message(span_userdanger("[H]'s swelling werewolf form violently bursts through [H.p_their()] spiked chastity device, sending shards flying!"))
	else
		H.visible_message(span_userdanger("[H]'s swelling werewolf form snaps [H.p_their()] chastity device apart with a sharp metallic crack!"))

	playsound(get_turf(H), 'sound/combat/gib (1).ogg', 70, FALSE, 2)
	remove_chastity(H)
	qdel(src)

// Hooks wearer movement signal so worn device can occasionally play movement jingle audio.
/obj/item/chastity/proc/register_wearer_jingle(mob/living/carbon/human/H)
	if(!H)
		return
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED)
	RegisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED, PROC_REF(on_chastity_state_changed))
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)
	if(!chastity_move_sound)
		return
	chastity_move_counter = 0
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(on_wearer_moved))

// Movement callback that rate-limits and probabilistically plays chastity movement sound.
/obj/item/chastity/proc/on_wearer_moved(datum/source)
	SIGNAL_HANDLER
	if(!chastity_victim || source != chastity_victim)
		return
	chastity_move_counter++
	if(chastity_move_counter < chastity_move_delay)
		return
	chastity_move_counter = 0
	var/effective_move_chance = chastity_move_chance
	if(GLOB.clients?.len >= chastity_high_pop_client_cap)
		effective_move_chance = max(1, round(chastity_move_chance * chastity_high_pop_move_chance_mult))
	if(!prob(effective_move_chance))
		return
	playsound(chastity_victim, chastity_move_sound, chastity_move_volume, TRUE)

// Shared state-change signal callback for all chastity trait toggles and mode switches.
/obj/item/chastity/proc/on_chastity_state_changed(datum/source, obj/item/chastity/device, reason)
	SIGNAL_HANDLER
	if(device != src || source != chastity_victim)
		return
	refresh_chastity_mood_effects(chastity_victim)
	if(chastity_cursed)
		update_cursed_visual(chastity_victim)

// Failsafe cleanup: if item is deleted while worn, forcibly unapply all wearer state.
/obj/item/chastity/Destroy() // failsafe to remove chastity traits if the belt get's Qdel'd or something
	detach_toy()
	if(chastity_victim)
		remove_chastity(chastity_victim)
	return ..()
