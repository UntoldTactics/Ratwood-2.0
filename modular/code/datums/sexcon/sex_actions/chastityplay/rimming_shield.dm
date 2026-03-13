/datum/sex_action/chastityplay/rimming_shield
	name = "Rim them behind their chastity shield"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/rimming_shield/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target.sexcon.has_chastity_anal())
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/rimming_shield/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target.sexcon.has_chastity_anal())
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/rimming_shield/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] begins to worm their tongue up and under [target]'s  anal shield..."))

/datum/sex_action/chastityplay/rimming_shield/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] wriggles their tongue under [target]'s anal shield..."))
	user.sexcon.oralcourse_noise(user)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	if(target.sexcon.check_active_ejaculation())
		target.sexcon.ejaculate()

/datum/sex_action/chastityplay/rimming_shield/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] frees their tongue from under [target]'s anal shield..."))

/datum/sex_action/chastityplay/rimming_shield/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE	
	return FALSE
