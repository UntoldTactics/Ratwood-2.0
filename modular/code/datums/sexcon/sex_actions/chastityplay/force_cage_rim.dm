/datum/sex_action/chastityplay/force_cage_rim
    name = "Force them to rim your shield"
    require_grab = TRUE
    stamina_cost = 1.0
    user_sex_part = SEX_PART_ANUS
    target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_rim/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!user.sexcon.has_chastity_anal())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_rim/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!user.sexcon.has_chastity_anal())
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_rim/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] forces [target]'s face under [user.p_their()] chastity shield!"))

/datum/sex_action/chastityplay/force_cage_rim/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] makes [target] rim beneath [user.p_their()] anal shield."))
    user.sexcon.oralcourse_noise(target)
    user.sexcon.perform_sex_action(user, 1.3, 0, TRUE)
    user.sexcon.perform_sex_action(target, 0, 2.5, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_rim/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] pushes [target] back from [user.p_their()] anal shield."))

/datum/sex_action/chastityplay/force_cage_rim/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
