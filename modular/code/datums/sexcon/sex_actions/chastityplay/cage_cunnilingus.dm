/datum/sex_action/chastityplay/cage_cunnilingus
    name = "Lick through their belt"
    user_sex_part = SEX_PART_JAWS
    category = SEX_CATEGORY_PENETRATE

/datum/sex_action/chastityplay/cage_cunnilingus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_cunnilingus/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] lowers [user.p_their()] face to [target]'s chastity belt."))

/datum/sex_action/chastityplay/cage_cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] laps at [target]'s belt through the front slits..."))
    user.sexcon.oralcourse_noise(target)

    user.sexcon.perform_sex_action(target, 1.8, 0, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] lifts [user.p_their()] head from [target]'s belt."))

/datum/sex_action/chastityplay/cage_cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
