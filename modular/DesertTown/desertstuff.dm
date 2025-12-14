//drape
/obj/structure/drape/desert
	name = "desert drape"
	desc = "Made from durable fabric."
	icon = 'icons/desert_town/drapes.dmi'
	icon_state = "desertdrape"

/obj/structure/drape/zybantine
	name = "zybantine drape"
	desc = "Made from prestigious fabric."
	icon = 'icons/desert_town/drapes.dmi'
	icon_state = "zybantinedrape1"

/obj/structure/drape/zybantine/Initialize()
	. = ..()
	icon_state = "zybantinedrape[rand(1, 2)]"

//cushion
/obj/item/cushion/desert1
	name = "desert cushion"
	icon = 'icons/desert_town/cushions.dmi'
	icon_state = "desertcushion1"

/obj/item/cushion/desert2
	name = "desert cushion"
	icon = 'icons/desert_town/cushions.dmi'
	icon_state = "desertcushion2"

/obj/item/cushion/zybantine
	name = "zybantine cushion"
	icon = 'icons/desert_town/cushions.dmi'
	icon_state = "zybantinecushion"

//kegs

/// The original hierarchy for barrels and buckets is kind of messy, and I didn't want to refactor it all to have sane subtypes.


/obj/structure/fermentation_keg/sandpot
	name = "sand pot"
	desc = ""
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "sandpot1"

/obj/structure/fermentation_keg/fancypot
	name = "fancy pot"
	desc = ""
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "fancypot1"


/obj/item/reagent_containers/glass/bucket/wooden/tinypot
	name = "tiny pot"
	icon = 'icons/desert_town/pots.dmi'
	icon_state = "tinypot1"



/obj/structure/fermentation_keg/sandpot/Initialize()
	. = ..()
	icon_state = "sandpot[rand(1, 4)]"

/obj/structure/fermentation_keg/fancypot/Initialize()
	. = ..()
	icon_state = "fancypot[rand(1, 4)]"


// Subtypes for sandpots
/obj/structure/fermentation_keg/sandpot/random/water/Initialize()
	. = ..()
	icon_state = "barrel3"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/beer/Initialize()
	. = ..()
	icon_state = "barrel2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/sandpot/random/wine/Initialize()
	. = ..()
	icon_state = "barrel1"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/sandpot/water/Initialize()
	. = ..()
	icon_state = "barrel3"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/sandpot/beer/Initialize()
	. = ..()
	icon_state = "barrel2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/sandpot/wine/Initialize()
	. = ..()
	icon_state = "barrel1"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)


// Subtypes for fancypots
/obj/structure/fermentation_keg/fancypot/random/water/Initialize()
	. = ..()
	icon_state = "barrel3"
	reagents.add_reagent(/datum/reagent/water, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/beer/Initialize()
	. = ..()
	icon_state = "barrel2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer, rand(0,900))

/obj/structure/fermentation_keg/fancypot/random/wine/Initialize()
	. = ..()
	icon_state = "barrel1"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine, rand(0,900))

/obj/structure/fermentation_keg/fancypot/water/Initialize()
	. = ..()
	icon_state = "barrel3"
	reagents.add_reagent(/datum/reagent/water,900)

/obj/structure/fermentation_keg/fancypot/beer/Initialize()
	. = ..()
	icon_state = "barrel2"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/beer,900)

/obj/structure/fermentation_keg/fancypot/wine/Initialize()
	. = ..()
	icon_state = "barrel1"
	reagents.add_reagent(/datum/reagent/consumable/ethanol/wine,900)

///
/obj/machinery/light/rogue/wallfire/desert
	name = "desert fireplace"
	icon = 'icons/desert_town/fireplace.dmi'
	icon_state = "fireplace1"
	base_state = "fireplace"
	fueluse = 0
	density = FALSE
	anchored = TRUE
	cookonme = FALSE

///////////

/obj/structure/pillar
	name = "pillar"
	desc = ""
	icon = 'icons/desert_town/sandpillar.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	layer = 4.82
	pixel_x = -16
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/pillar

/obj/structure/pillar/sand1
	icon_state = "sandpillar1"


////chairs

/obj/item/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'icons/desert_town/chairs.dmi'
	icon_state = "zybantinechair"
	origin_type = /obj/structure/chair/wood/zybantine

/obj/structure/chair/wood/zybantine
	name = "zybantine chair"
	icon = 'icons/desert_town/chairs.dmi'
	icon_state = "zybantinechair"

/obj/structure/chair/wood/rogue/throne/zybantine
	name = "zybantine throne"
	icon_state = "zybantinethrone"
	icon = 'icons/desert_town/throne.dmi'
	pixel_x = -16


/obj/structure/chair/sofa
	name = "old ratty sofa"
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/chair/sofa/corner
	icon_state = "sofacorner"


/obj/structure/chair/zybantine_sofa/right
	name = "zybantine sofa"
	icon_state = "zybantinesofa_right"
	icon = 'icons/desert_town/chairs.dmi'
	buildstackamount = 1
	item_chair = null

/obj/structure/chair/zybantine_sofa/left
	name = "zybantine sofa"
	icon_state = "zybantinesofa_left"
	icon = 'icons/desert_town/chairs.dmi'
	buildstackamount = 1
	item_chair = null

//Sandrocks

/obj/structure/sandrock
	name = "sandrock"
	desc = "A large desert rock protuding from the ground."
	icon_state = "rock1"
	icon = 'icons/desert_town/sandrock.dmi'
	opacity = 0
	max_integrity = 1000
	density = TRUE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	alpha = 255
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 10)
	pixel_x = -48
	layer = 4.81
	plane = GAME_PLANE_UPPER

	abstract_type = /obj/structure/sandrock

/obj/structure/sandrock/sandrock1
	icon_state = "sandrock1"

/obj/structure/sandrock/sandrock2
	icon_state = "sandrock2"

/obj/structure/sandrock/sandrock3
	icon_state = "sandrock3"

/obj/structure/sandrock/sandrock4
	icon_state = "sandrock4"

/obj/item/natural/rock/desert
	name = "sand rock"
	icon = 'icons/desert_town/small_sandrock.dmi'
	icon_state = "sandrock1"

/obj/item/natural/rock/desert/Initialize()
	. = ..()
	icon_state = "sandrock[rand(1,2)]"


//bush

/obj/structure/flora/roguegrass/bush/desert
	name = "saigahorn"
	desc = ""
	icon = 'icons/desert_town/flora.dmi'
	icon_state = "saigahorn1"

/obj/structure/flora/roguegrass/bush/desert/Initialize()
	. = ..()
	icon_state = "saigahorn[rand(1, 3)]"

/obj/structure/flora/roguegrass/bush/desertshrub
	name = "treelet"
	desc = ""
	icon = 'icons/desert_town/flora.dmi'
	icon_state = "bushshrub"
	max_integrity = 100
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/grown/log/tree/small = 1)


/obj/structure/flora/roguetree/palm
	name = "palm tree"
	desc = "Scant, precious shade."
	icon = 'icons/desert_town/bigpalm.dmi'
	icon_state = "palm"
	stump_type = /obj/structure/flora/roguetree/stump/burnt
	pixel_x = -32

// /obj/structure/flora/roguetree/palm/Initialize() //no alt sprites done yet
// 	. = ..()
// 	icon_state = "t[rand(1,4)]"

/obj/structure/flora/roguetree/stump/palm
	name = "tree stump"
	desc = "Shade no more."
	icon_state = "palmstump"
	icon = 'icons/desert_town/bigpalm.dmi'
	stump_type = null
	pixel_x = -32

// /obj/structure/flora/roguetree/palm/burnt/Initialize()
// 	. = ..()
// 	icon_state = "st[rand(1,2)]"

//Stairs

/obj/structure/stairs/desert
	name = "sand stairs"
	icon = 'icons/desert_town/sandstairs.dmi'
	icon_state = "sandstairs"
	max_integrity = 600



// custom map generation?

// \code\modules\roguetown\mapgen

/obj/effect/landmark/mapGenerator/rogue/desert
	mapGeneratorType = /datum/mapGenerator/desert
	endTurfX = 400
	endTurfY = 300
	startTurfX = 1
	startTurfY = 1


/datum/mapGenerator/desert
	modules = list(/datum/mapGeneratorModule/desertsand, /datum/mapGeneratorModule/desertgrass,/datum/mapGeneratorModule/desertroad, /datum/mapGeneratorModule/desertwater)


/datum/mapGeneratorModule/desertsand
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dunes)
	// excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 0.5,
							/obj/structure/flora/roguegrass/bush/desertshrub = 0.5,
							/obj/structure/flora/roguegrass = 0.5,
							/obj/structure/flora/roguetree/stump/log = 0.3,
							/obj/structure/flora/ausbushes/ppflowers = 0.1,
							/obj/structure/flora/ausbushes/ywflowers = 0.1,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.1,
							/obj/structure/leyline = 0.05,
							/obj/structure/voidstoneobelisk = 0.05,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.05,
							/obj/item/magic/manacrystal = 0.05,
							/obj/structure/flora/roguegrass/herb/random = 0.5,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)


/datum/mapGeneratorModule/desertgrass
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/floor/rogue/dirt, /turf/open/floor/rogue/desert_grass)
	excluded_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/structure/flora/roguetree/palm = 2,
							/obj/structure/flora/roguegrass/bush/desertshrub = 2,
							/obj/structure/flora/roguegrass = 3,
							/obj/structure/flora/roguetree/stump/log = 0.5,
							/obj/structure/flora/ausbushes/ppflowers = 0.1,
							/obj/structure/flora/ausbushes/ywflowers = 0.1,
							/obj/structure/flora/roguegrass/maneater = 0.5,
							/obj/structure/flora/roguegrass/maneater/real/juvenile = 0.5,
							/obj/item/natural/stone = 1,
							/obj/item/natural/rock = 1,
							/obj/item/magic/artifact = 0.2,
							/obj/structure/leyline = 0.1,
							/obj/structure/voidstoneobelisk = 0.1,
							/obj/structure/flora/roguegrass/herb/manabloom = 0.1,
							/obj/item/magic/manacrystal = 0.1,
							/obj/structure/closet/dirthole/closed/loot = 0.5,
							/obj/structure/flora/roguegrass/swampweed = 0.5,
							/obj/structure/flora/roguegrass/herb/random = 2,
							/obj/effect/decal/remains/bear = 0.5,
							/obj/effect/decal/remains/human = 0.3,
							/obj/structure/zizo_bane = 0.5,)
	// spawnableTurfs = list(/turf/open/floor/rogue/dirt/road=2,
	// 					/turf/open/water/swamp=2,)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertroad
	clusterCheckFlags = CLUSTER_CHECK_DIFFERENT_ATOMS
	allowed_turfs = list(/turf/open/floor/rogue/dirt/road)
	spawnableAtoms = list(/obj/item/natural/stone = 2,/obj/item/grown/log/tree/stick = 1)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)

/datum/mapGeneratorModule/desertwater
	clusterCheckFlags = CLUSTER_CHECK_ALL
	allowed_turfs = list(/turf/open/water/cleanshallow)
	allowed_areas = list(/area/rogue/outdoors/desert, /area/rogue/outdoors/desertdeep)
	spawnableAtoms = list(	/obj/structure/flora/roguetree/stump/log = 1,
							/obj/structure/flora/ausbushes/reedbush = 1,
							/obj/structure/flora/roguegrass/water/reeds = 1,)
