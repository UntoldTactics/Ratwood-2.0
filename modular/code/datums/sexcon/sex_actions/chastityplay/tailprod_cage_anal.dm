/datum/sex_action/chastityplay/tailprod_cage_anal
    name = "Tailprod their anal shield"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/tailprod_cage_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_TAIL))
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/tailprod_cage_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_TAIL))
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/tailprod_cage_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] snakes [user.p_their()] tail under [target]'s rear shield."))

/datum/sex_action/chastityplay/tailprod_cage_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] prods [target]'s anal shield with [user.p_their()] tail."))
    user.sexcon.perform_sex_action(target, 1.1, 3, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/tailprod_cage_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] slips [user.p_their()] tail out from under [target]'s anal shield."))

/datum/sex_action/chastityplay/tailprod_cage_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
