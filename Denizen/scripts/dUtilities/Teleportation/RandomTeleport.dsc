randomTeleport:
  type: command
  debug: false
  name: randomtp
  usage: /randomtp
  aliases:
  - wild
  permission: randomtp.use
  script:
  # Let ops bypass the command-cooldown
  - if <player.has_flag[rtpRecent]> && !<player.is_op>:
    - narrate "<red>You must wait <player.flag[rtpRecent].expiration.formatted> before you can use this command again."
    - stop

  # Run /wild or /randomtp [player]
  - if <context.args.get[1]||null> == null:
    - define target:<player>
  - else:
    - if <server.match_player[<context.args.get[1]>]||null> != null:
      - narrate "Found player ..."
      - define target:<server.match_player[<context.args.get[1]>]>
    - else:
      - narrate "<context.args.get[1]> not found."
      - stop
  - else:

  - define maxDistFromSpawn:<yaml[dUtilitiesConfig].read[randomtp.max-distance]>

  - if <yaml[dUtilitiesConfig].read[randomtp.use-worldborder]>:
    - define border:<player.location.world.border_size.div[2]>
    - if <[border]> > 10000:
      - define safeTeleportDistPositive:<[border].sub[1000]>
      - define safeTeleportDistNegative:<[safeTeleportDistPositive].mul[-1]>
    - else:
      - define safeTeleportDistPositive:<[border].sub[<[border].mul[0.10]>]>
      - define safeTeleportDistNegative:<[safeTeleportDistPositive].mul[-1]>
  - else:
    - define safeTeleportDistPositive:<[maxDistFromSpawn].sub[<[maxDistFromSpawn].mul[0.10]>]>
    - define safeTeleportDistNegative:<[safeTeleportDistPositive].mul[-1]>

  - define randZCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>
  - define randXCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>

  - teleport <[target]> <[randXCoords]>,255,<[randZCoords]>,<[target].location.world>
  - flag <[target]> freeFalling:true duration:<yaml[dUtilitiesConfig].read[randomtp.immunity-seconds]>
  - if <yaml[dUtilitiesConfig].read[randomtp.command-cooldown]> > 0:
    - flag <[target]> rtpRecent:true duration:<yaml[dUtilitiesConfig].read[randomtp.command-cooldown]>

RandomTPEvents:
  type: world
  debug: false
  events:
    on player damaged by FALL bukkit_priority:LOWEST:
      - if <player.has_flag[freeFalling]>:
        - flag <player> freeFalling:!
        - determine cancelled

    on entity starts gliding:
      - if <player.has_flag[freeFalling]>:
        - flag <player> freeFalling:!
