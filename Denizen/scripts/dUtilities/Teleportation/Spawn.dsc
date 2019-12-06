setSpawn:
  type: command
  debug: false
  name: setspawn
  description: Set the world spawn to your location.
  usage: /setspawn
  permission: dutilities.setspawn
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <player.has_permission[dutilities.setspawn]> || <player.is_op>:
    - note <player.location> as:spawn_<player.location.world.name>
    - narrate "<green>Spawn has been set for <blue><player.location.world.name><green> ..."
    - announce to_console "[dUtilities] World spawn has been set by <player.name>."

spawnCommand:
  type: command
  debug: true
  name: spawn
  description: Teleport to the world spawn.
  usage: /spawn
  permission: dutilities.spawn
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <player.has_permission[dutilities.spawn]> || <player.is_op>:
    - teleport <player> <location[spawn_<player.world.name>].simple>
  - else:
    - narrate "<red>Hey, <player.name>, you do not have permission to run that command!"
