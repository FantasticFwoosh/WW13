#define SECONDS *10
var/movementMachine/movementMachine = null

/movementMachine
	var/interval = 0.015 SECONDS // half as long as the fastest ghost movement delay, so ghost movement is smoother
	var/ticks = 0
	var/last_run = -1

/movementMachine/New()
	..()
	if (movementMachine && movementMachine != src)
		del(src)
		return FALSE
	return TRUE

/movementMachine/proc/start()
	spawn (0)
		process()

/movementMachine/proc/process()

	while (TRUE)

		for (var/client in movementMachine_clients)

			if (client && !isDeleted(client))

				var/mob/M = client:mob

				if (!isDeleted(M))
					try
						if (M.client.canmove && !M.client.moving && world.time >= M.client.move_delay && (M.movement_eastwest || M.movement_northsouth))
							var/diag = FALSE
							var/movedir = M.movement_northsouth ? M.movement_northsouth : M.movement_eastwest
							if ((M.movement_eastwest && M.movement_northsouth) && !istank(M.loc))
								if (M.movement_northsouth == NORTH && M.movement_eastwest == WEST)
									movedir = NORTHWEST
									diag = TRUE
								else if (M.movement_northsouth == NORTH && M.movement_eastwest == EAST)
									movedir = NORTHEAST
									diag = TRUE
								else if (M.movement_northsouth == SOUTH && M.movement_eastwest == WEST)
									movedir = SOUTHWEST
									diag = TRUE
								else if (M.movement_northsouth == SOUTH && M.movement_eastwest == EAST)
									movedir = SOUTHEAST
									diag = TRUE
							M.client.Move(get_step(M, movedir), movedir, diag)
					catch(var/exception/e)
						pass(e)
				else
					mob_list -= M

		++ticks
		last_run = world.time
		sleep(interval)
#undef SECONDS