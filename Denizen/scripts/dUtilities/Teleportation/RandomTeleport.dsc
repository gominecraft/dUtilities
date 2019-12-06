randomTeleport:
  type: command
  debug: false
  name: wild
  usage: /randomtp
  aliases:
  - wild
  permission: randomtp.use
  script:
  # Let ops bypass the command-cooldown
  - if <player.has_flag[wildRecent]> && !<player.is_op>:
    - narrate "<red>You must wait <player.flag[wildRecent].expiration.formatted> before you can use this command again."
    - stop

  # Run /wild or /randomtp [player]
  - if <context.args.get[1]||null> == null:
    - define target:<player>
  - else:
    - if <player.has_permission[randomtp.other]>:
      - if <server.match_player[<context.args.get[1]>]> != null:
        - narrate "Found player ..."
        - define target:<server.match_player[<context.args.get[1]>]>
      - else:
        - narrate "<context.args.get[1]> not found."
    - else:
      - narrate "You do not have permission to use wild on other players."
      - stop

  - if <player.has_permission[wild.use]>:

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
      - define safeTeleportDistPositive:<[maxDistFromSpawn].sub[<[maxDistFromSpawn].as_element.mul[0.10]>]>
      - define safeTeleportDistNegative:<[safeTeleportDistPositive].to_element.mul[-1]>
  - else:
    - narrate "<red>You do not have permission to run that command."
    - stop

  - define randZCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>
  - define randXCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>

  - if <yaml[dUtilitiesConfig].read[use-effects]>:
    - playeffect sneeze <player.location.above.forward> quantity:500 offset:0.6
  - teleport <[target]> l@<[randXCoords]>,255,<[randZCoords]>,<[target].location.world>
  - flag <[target]> freeFalling:true duration:<yaml[dUtilitiesConfig].read[randomtp.immunity-seconds]>
  - if <yaml[dUtilitiesConfig].read[randomtp.command-cooldown]> > 0:
    - flag <[target]> wildRecent:true duration:<yaml[dUtilitiesConfig].read[randomtp.command-cooldown]>
