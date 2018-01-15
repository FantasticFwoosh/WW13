var/list/alive_germans = list()
var/list/alive_russians = list()
var/list/alive_civilians = list()
var/list/alive_partisans = list()

var/list/heavily_injured_germans = list()
var/list/heavily_injured_russians = list()
var/list/heavily_injured_civilians = list()
var/list/heavily_injured_partisans = list()

var/dead_germans = 0
var/dead_russians = 0
var/dead_civilians = 0
var/dead_partisans = 0

var/list/recently_died = list()

/mob/living/carbon/human/proc/get_battle_report_lists()

	var/list/alive = list()
	var/list/injured = list()
	var/dead = 0

	switch (original_job.base_type_flag())
		if (GERMAN)
			dead = dead_germans
			injured = heavily_injured_germans
			alive = alive_germans
		if (SOVIET)
			dead = dead_russians
			injured = heavily_injured_russians
			alive = alive_russians
		if (CIVILIAN)
			dead = dead_civilians
			injured = heavily_injured_civilians
			alive = alive_civilians
		if (PARTISAN)
			dead = dead_partisans
			injured = heavily_injured_partisans
			alive = alive_partisans

	return list(alive, dead, injured)

/mob/living/carbon/human/death()

	var/list/lists = get_battle_report_lists()
	var/list/alive = lists[1]
	var/list/injured = lists[3]

	alive -= src
	injured -= src
	recently_died += src

	++lists[2]

	// prevent one last Life() from potentially undoing this
	spawn (200)
		recently_died -= src

	..()


/mob/living/carbon/human/Life()

	var/list/lists = get_battle_report_lists()
	var/list/alive = lists[1]
	var/list/injured = lists[3]

	..()

	if (recently_died.Find(src))
		return

	if (istype(original_job, /datum/job/german/trainsystem))
		return

	alive -= src
	injured -= src

	// give these lists starting values to prevent runtimes.
	if (stat == CONSCIOUS)
		alive |= src
	else if (stat == UNCONSCIOUS || (health <= FALSE && stat != DEAD))
		injured |= src