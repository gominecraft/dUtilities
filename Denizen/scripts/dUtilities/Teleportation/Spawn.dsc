setSpawnCommand:
  type: command
  debug: true
  name: setspawn
  description: Set the world spawn to your location.
  usage: /setspawn
  permission: dutilities.setspawn
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <player.has_permission[dutilities.setspawn]>:
    - note <player.location> as:spawn_<player.location.world.name>
    - narrate "<gold>Spawn has been set for '<green><player.location.world.name><gold>'."
    - announce to_console "[dUtilities] World spawn has been set by <player.name>."
  - else:
    - narrate "<red>You do not have permission to use the setspawn command."

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
  - if <player.has_permission[dutilities.spawn]>:
    - teleport <location[spawn_<player.world.name>]>
  - else:
    - narrate "<red>You do not have permission to use the spawn command."
