// Chastity key logic split into modular file so core keys.dm only keeps broad lock override behavior.

/obj/item/roguekey/chastity
	name = "chastity key"
	desc = "Default chastity cage desc before changed upon generation"
	icon_state = "mazekey" // Puritanical type key, Astrata smiles on the abstinent.

/obj/item/roguekey/chastity/attack_self(mob/user)
	if(!ishuman(user))
		return ..()
	return attack(user, user, user.zone_selected)

/obj/item/roguekey/chastity/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(target == user && ishuman(user))
		attack(user, user, user.zone_selected)
		return
	return ..()

/obj/item/roguekey/chastity/attack(mob/M, mob/user, def_zone)
	if(!ishuman(M))
		return ..()

	var/mob/living/carbon/human/H = M
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("[H]'s groin is covered. I can't see a cage let alone unlock one!"))
		return
	if(!H.chastity_device)
		to_chat(user, span_warning("[H] isn't wearing a chastity device. Against Astrata's Will their genitals are free ranged."))
		return TRUE

	var/obj/item/chastity/device = H.chastity_device
	if(!device.lockable)
		to_chat(user, span_warning(device.chastity_cursed ? pick(GLOB.chastity_cursed_lock) : pick(GLOB.chastity_lock_denial)))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	if(device.lockhash != src.lockhash)
		var/found_key = FALSE
		for(var/obj/item/storage/keyring/K in user.held_items)
			if(!K.contents.Find(/obj/item/roguekey/chastity))
				continue
			for(var/obj/item/roguekey/chastity/KE in K.contents)
				if(KE.lockhash == device.lockhash)
					found_key = TRUE
					break
			if(found_key)
				break
		if(!found_key)
			to_chat(user, span_warning("This key doesn't fit [H]'s chastity device."))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			return TRUE

	if(device.locked)
		// Optional fumble: low luck users can snap the key in the lock.
		var/break_chance = 0
		if(ishuman(user))
			var/mob/living/carbon/human/U = user
			if(U.STALUC <= 9)
				// 9 luck = 5%, 8 luck = 10%, down to 0 luck = 50%.
				break_chance = (10 - U.STALUC) * 5
		if(break_chance && prob(break_chance))
			user.visible_message(span_warning("[user]'s [src] snaps off inside [H]'s chastity lock!"), span_warning("My [src] snaps off inside the lock!"))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			qdel(src)
			return TRUE

		user.visible_message(span_notice("[user] unlocks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, FALSE, user, src, "key")
	else
		user.visible_message(span_notice("[user] locks [H]'s chastity device with [src]."))
		playsound(src, 'sound/foley/doors/lock.ogg', 100)
		device.set_chastity_locked_state(H, TRUE, user, src, "key")

	return TRUE
