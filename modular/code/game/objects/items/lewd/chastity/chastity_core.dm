GLOBAL_LIST_INIT(chastity_standard_traits, list(
	list(TRAIT_CHASTITY_FULL),
	list(TRAIT_CHASTITY_CAGE),
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_ANAL),
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_SPIKED),
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_ANAL, TRAIT_CHASTITY_SPIKED),
))

/obj/item/chastity
	var/cursed_front_mode = 0 // 0 = block all front access, 1 = penis open, 2 = vagina open, 3 = all front open
	var/cursed_anal_open = FALSE // is our ass shielded by the cursed belt?
	var/cursed_spikes_on = FALSE // are spikes deployed by our cursed belt?
	var/chastity_flat = FALSE // is the cage flat-style (more restrictive) or standard? Generally just for our cursed cage content.
	var/chastity_move_sound = SFX_JINGLE_BELLS // sound played when the chastity device moves
	var/chastity_move_delay = CHASTITY_MOVE_SOUND_DELAY // delay between movement sounds
	var/chastity_move_volume = 55 // how load is our cock cage?
	var/chastity_move_chance = 5 // how often does it trigger on move?
	var/chastity_high_pop_client_cap = CHASTITY_HIGH_POP_THRESHOLD // for jingle throttle. Don't want the server spamming the noise when 120 people potentially cage up. 
	var/chastity_high_pop_move_chance_mult = CHASTITY_HIGH_POP_SOUND_MULT
	var/tmp/chastity_move_counter = 0 // 
// base chastity item and vars
/obj/item/chastity
	name = "chastity belt"
	desc = "A unisex metal device designed to prevent penetrative sex. It has a lock on the front, and encloses the groin area behind robust iron bars. For the devout."
	icon = 'modular/icons/obj/lewd/chastity.dmi'
	icon_state = "cage_belt"
	mob_overlay_icon = "cage_belt"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = INDESTRUCTIBLE
	var/datum/bodypart_feature/chastity/chastity_feature // snowflake slot for chastity items, belt's dont work as clothing equippables
	var/chastity_type = 0 // 0 = full, 1 = cage, 2 = cage with anal, 3 = spiked cage, 4 = spiked cage with anal
	var/chastity_organtype = 0 // 0 = neuter, 1 = penis required, 2 = vagina required, 3 = both required
	var/obj/item/roguekey/chastity/generated_key = null // persistent key object for this device; reused across re-equips
	var/lockable = TRUE // if the device can be traditionally locked with a key or lockpick, should be true for everything but cursed devices which are locked via the collar master menu
	locked = FALSE
	var/chastity_cursed = FALSE // if the device works like a cursed collar
	var/mob/living/carbon/human/chastity_victim = null // variable for anyone currently caged
	var/datum/mind/chastity_master = null // varient of the collar master variable but for specifically cages
	var/obj/item/dildo/attached_toy = null // dildo mounted directly onto this chastity device
	lockid = null
	lockhash = null
	grid_height = 32
	grid_width = 32
	throw_speed = 0.5
	var/sprite_acc = /datum/sprite_accessory/chastity/full // overlay for chastity items on the sprite, function in a similar vein to underwear in that they aren't traditional equipped clothing items, instead going in a snowflake slot
	lefthand_file = 'modular/icons/mob/inhands/lewd/items_lefthand.dmi'
	righthand_file = 'modular/icons/mob/inhands/lewd/items_righthand.dmi'
	// nudist_approved = TRUE // prep for nudist PR being made by another person.

// Ensure each chastity item has a unique lockhash used by matching keys.
/obj/item/chastity/Initialize()
	. = ..()
	if(!lockhash)
		lockhash = rand(100000,999999)
		while(lockhash in GLOB.lockhashes)
			lockhash = rand(100000,999999)
		GLOB.lockhashes += lockhash

/obj/item/chastity/examine()
	. = ..()
	if(attached_toy)
		. += "[span_notice("\An [attached_toy] appears attached to \the [initial(name)]. Alt+RMB to remove it.")]"

/obj/item/chastity/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/dildo))
		return ..()
	var/obj/item/dildo/held_dildo = I
	if(held_dildo.is_attached_to_belt)
		return
	if(attached_toy)
		to_chat(user, span_info("\The [initial(name)] already has a toy attached! Remove it first."))
		return
	if(!user.transferItemToLoc(held_dildo, null))
		to_chat(user, span_warning("\The [held_dildo] is stuck to your hand!"))
		return
	if(attach_toy(held_dildo, user))
		user.visible_message(span_warning("[user] equips \the [held_dildo] onto \the [initial(name)]."))

/obj/item/chastity/AltRightClick(mob/user)
	if(!attached_toy)
		return
	if(!isliving(user) || !user.TurfAdjacent(src))
		return
	if(user.get_active_held_item())
		to_chat(user, span_info("I can't do that with my hand full!"))
		return
	user.visible_message(span_warning("[user] removes \the [attached_toy] from \the [initial(name)]."))
	detach_toy(user)

/obj/item/chastity/update_icon()
	. = ..()
	if(attached_toy)
		var/matrix/M = new
		M.Scale(-0.8, -0.8)
		attached_toy.transform = M
		attached_toy.pixel_y = -6
		attached_toy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE

/obj/item/chastity/proc/attach_toy(obj/item/dildo/new_toy, mob/user)
	if(!new_toy || attached_toy || new_toy.is_attached_to_belt)
		return FALSE
	if(chastity_victim && istype(chastity_victim.belt, /obj/item/storage/belt/rogue))
		var/obj/item/storage/belt/rogue/worn_belt = chastity_victim.belt
		if(worn_belt.attached_toy)
			if(user)
				to_chat(user, span_warning("[chastity_victim] already has a toy attached to [chastity_victim.p_their()] belt."))
			return FALSE
	new_toy.is_attached_to_belt = TRUE
	attached_toy = new_toy
	vis_contents += attached_toy
	playsound(get_turf(user ? user : src), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	update_icon()
	refresh_wearer_overlays()
	return TRUE

/obj/item/chastity/proc/detach_toy(mob/user)
	if(!attached_toy)
		return FALSE
	var/obj/item/dildo/dildo = attached_toy
	vis_contents -= dildo
	dildo.update_icon()
	dildo.is_attached_to_belt = FALSE
	attached_toy = null
	if(user && isliving(user) && !user.get_active_held_item() && user.put_in_hands(dildo))
		// moved to user hand above
	else
		dildo.forceMove(drop_location())
	update_icon()
	refresh_wearer_overlays()
	return TRUE

/obj/item/chastity/proc/refresh_wearer_overlays()
	if(!chastity_victim)
		return
	// Chastity bodypart visuals and belt-layer dildo overlay both need refreshes.
	chastity_victim.update_body_parts(TRUE)
	chastity_victim.update_inv_belt()

// Restricts caging to valid player-controlled humans and disallows transformed werewolves.
/obj/item/chastity/proc/can_cage_target(mob/living/carbon/human/H, mob/user)
	if(!H)
		return FALSE
	if(!H.mind)
		to_chat(user, span_warning("[H] cannot be fitted with a chastity device right now."))
		return FALSE
	if(istype(H, /mob/living/carbon/human/species/werewolf))
		to_chat(user, span_warning("[H]'s transformed body cannot be restrained by [src]."))
		return FALSE
	if(attached_toy && istype(H.belt, /obj/item/storage/belt/rogue))
		var/obj/item/storage/belt/rogue/worn_belt = H.belt
		if(worn_belt.attached_toy)
			to_chat(user, span_warning("[H] is already wearing a belt with an attached toy."))
			return FALSE
	return TRUE

// Verifies that the target has the genital configuration required by this device type.
/obj/item/chastity/proc/chastity_genital_check(mob/living/carbon/human/H) // check to see if cage target has the right genitals to wear the cage, cant wear an inverted dildo belt without a pussy
	if(chastity_organtype == 1 && !H.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(chastity_organtype == 2 && !H.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(chastity_organtype == 3 && (!H.getorganslot(ORGAN_SLOT_PENIS) || !H.getorganslot(ORGAN_SLOT_VAGINA)))
		return FALSE
	return TRUE

// Creates and caches the bodypart feature object used to render/track equipped chastity.
/obj/item/chastity/proc/ensure_chastity_feature(mob/living/carbon/human/H)
	if(chastity_feature)
		return TRUE
	var/datum/bodypart_feature/chastity/chastity_new = new /datum/bodypart_feature/chastity()
	// Use the base accessory setter so we don't spawn a second hidden chastity item.
	call(chastity_new, /datum/bodypart_feature/proc/set_accessory_type)(sprite_acc, null, H)
	chastity_new.chastity_item = src
	chastity_feature = chastity_new
	return TRUE

// Attaches the prepared chastity bodypart feature to the chest bodypart.
/obj/item/chastity/proc/attach_chastity_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return FALSE
	if(!chastity_feature)
		ensure_chastity_feature(H)
	chest.add_bodypart_feature(chastity_feature)
	return TRUE

// Finalizes equip bookkeeping by moving the item, assigning wearer refs, and movement jingle hooks.
/obj/item/chastity/proc/finalize_chastity_equip(mob/living/carbon/human/H)
	forceMove(H)
	H.chastity_device = src
	chastity_victim = H
	register_wearer_jingle(H)
	refresh_chastity_mood_effects(H)
	refresh_wearer_overlays()

/obj/item/chastity/proc/is_hardmode_active()
	return chastity_victim?.client?.prefs?.chastity_hardmode == CHASTITY_HARDMODE_ENABLED

/obj/item/chastity/proc/sync_generated_key_metadata(mob/living/carbon/human/H, mob/user = null)
	if(!H || !generated_key || QDELETED(generated_key))
		return

	var/obj/item/roguekey/chastity/new_key = generated_key
	var/was_hardmode_key = new_key.hardmode_indestructible
	new_key.name = "[H]'s chastity key"
	new_key.desc = "A small key for [H]'s chastity device."
	new_key.hardmode_indestructible = FALSE

	if(is_hardmode_active())
		new_key.hardmode_indestructible = TRUE
		new_key.name = "[H]'s binding key"
		new_key.desc = "A small key bearing the mark of a permanent binding. [H]'s freedom rests in this metal."
		if(user && !was_hardmode_key)
			to_chat(user, span_warning("The key feels heavier than it should. [H]'s fate now rests in your hands."))

// Key generation for non-cursed devices, spawns a matching key on the equipping user's turf if one doesn't already exist. Cursed devices don't get keys since they're meant to be locked via the collar master menu and not interact with traditional locks and keys.
// Spawns a matching physical key for non-cursed devices at the equipping user's turf.
/obj/item/chastity/proc/generate_chastity_key(mob/user, mob/living/carbon/human/H)
	if(!user || !H)
		return
	var/obj/item/roguekey/chastity/new_key = generated_key
	if(!new_key || QDELETED(new_key))
		new_key = new(get_turf(user))
		new_key.lockhash = src.lockhash
		generated_key = new_key
	sync_generated_key_metadata(H, user)

// Applies baseline chastity traits according to configured chastity_type for standard devices.
/obj/item/chastity/proc/apply_standard_chastity_traits(mob/living/carbon/human/H)
	var/list/traits_to_apply = GLOB.chastity_standard_traits[chastity_type + 1]
	if(!islist(traits_to_apply))
		notify_chastity_state_change(H, "standard_traits_invalid")
		return

	for(var/trait_id in traits_to_apply)
		ADD_TRAIT(H, trait_id, TRAIT_SOURCE_CHASTITY)

	notify_chastity_state_change(H, "standard_traits_applied")

// Shared physical lock-state mutation path for keys and lockpicks.
/obj/item/chastity/proc/set_chastity_locked_state(mob/living/carbon/human/H, should_lock, mob/user = null, obj/item/interaction_item = null, interaction_source = "manual", state_change_reason = "")
	if(!H || H.chastity_device != src)
		return FALSE

	var/new_locked_state = !!should_lock
	var/old_locked_state = locked
	locked = new_locked_state

	if(new_locked_state)
		ADD_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
	else
		REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)

	if(old_locked_state == new_locked_state)
		return FALSE

	if(!length(state_change_reason))
		state_change_reason = "lock_changed_[interaction_source]"

	SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_CHANGED, user, interaction_item, new_locked_state, interaction_source)
	notify_chastity_state_change(H, state_change_reason)
	to_chat(H, new_locked_state ? span_warning(pick(GLOB.chastity_lock_click)) : span_notice(pick(GLOB.chastity_unlock_click)))
	return TRUE

// Our checks for whether the wearer has traits that would cause them to have mood effects related to wearing a chastity device, like the devout or masochist traits, are all based on checking for the presence of the relevant chastity traits that should be applied with each device type, so we need to make sure those traits are applied correctly according to the device type. This proc handles applying those traits on equip and removing them on unequip for standard devices, while cursed devices will handle it separately since their traits can change dynamically based on their cursed state.
// Emits a shared state-change signal so mood/visual refresh logic stays in one listener.
/obj/item/chastity/proc/notify_chastity_state_change(mob/living/carbon/human/H, reason = "")
	if(!H)
		return
	if(H.chastity_device == src)
		SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED, src, reason)
		return
	refresh_chastity_mood_effects(H)

/obj/item/chastity/proc/has_devotee_virtue(mob/living/carbon/human/H)
	if(!H?.client?.prefs)
		return FALSE
	if(istype(H.client.prefs.virtue, /datum/virtue/combat/devotee))
		return TRUE
	if(istype(H.client.prefs.virtuetwo, /datum/virtue/combat/devotee))
		return TRUE
	return FALSE

/obj/item/chastity/proc/patron_approves_chastity(mob/living/carbon/human/H)
	if(!H?.patron)
		return FALSE
	if(istype(H.patron, /datum/patron/inhumen))
		return FALSE
	if(istype(H.patron, /datum/patron/divine/eora))
		return FALSE
	return TRUE

/obj/item/chastity/proc/clear_chastity_mood_effects(mob/living/carbon/human/H)
	if(!H)
		return
	H.remove_stress(/datum/stressevent/chastity_devout)
	H.remove_stress(/datum/stressevent/chastity_masochist)
	H.remove_stress(/datum/stressevent/chastity_church)
	H.remove_stress(/datum/stressevent/chastity_frustration)
	H.remove_stress(/datum/stressevent/chastity_flat_cramped)

// controls chastity mood events based on traits, flaws, and other character conditions. Called on equip/unequip and when relevant character conditions change (like patron or virtues).
/obj/item/chastity/proc/refresh_chastity_mood_effects(mob/living/carbon/human/H)
	if(!H)
		return

	clear_chastity_mood_effects(H)

	if(H.chastity_device != src)
		return

	if((H.has_flaw(/datum/charflaw/addiction/godfearing) || has_devotee_virtue(H)) && patron_approves_chastity(H))
		H.add_stress(/datum/stressevent/chastity_devout)

	if(H.has_flaw(/datum/charflaw/addiction/masochist) && HAS_TRAIT(H, TRAIT_CHASTITY_SPIKED))
		H.add_stress(/datum/stressevent/chastity_masochist)

	if(H.mind?.assigned_role in GLOB.church_positions)
		H.add_stress(/datum/stressevent/chastity_church)

	if(H.has_flaw(/datum/charflaw/addiction/lovefiend) || istype(H.patron, /datum/patron/inhumen/baotha))
		H.add_stress(/datum/stressevent/chastity_frustration)

	if(chastity_flat)
		var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
		if(penis?.penis_size >= DEFAULT_PENIS_SIZE)
			H.add_stress(/datum/stressevent/chastity_flat_cramped)
