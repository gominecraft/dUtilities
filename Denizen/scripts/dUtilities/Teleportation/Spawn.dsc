setSpawn:
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
  - note <player.location> as:spawn_<player.location.world.name>
  - narrate "<gold>Spawn has been set for '<green><player.location.world.name><gold>'."
  - announce to_console "[dUtilities] World spawn has been set by <player.name>."

spawn:
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
  - teleport <location[spawn_<player.world.name>]>
