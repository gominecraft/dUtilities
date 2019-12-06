setHome:
  type: command
  debug: false
  name: sethome
  description: Set a player home.
  usage: /sethome
  permission: dutilities.sethome
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <player.has_permission[dutilities.sethome]> || <player.is_op>:
    - note <player.location> as:<player.uuid>_<player.location.world.name>
    - narrate "<gold>Your home has been set, <green><player.name><gold>!"
    - announce to_console "[dUtilities] Home set by <player.name> @ <player.location.simple>"
  - else:
    - narrate "<red>Hey, <green><player.name><red>, you do not have permission to run that command!"
    - stop

home:
  type: command
  debug: false
  name: home
  description: Sends a player to their home, if they have one.
  usage: /home
  permission: dutilities.home
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <player.has_permission[dutilities.home]>
    - if <location[<player.uuid>_<player.location.world.name>]||false>:
      - teleport <player> <location[<player.uuid>_<player.location.world.name>]>
    - else:
      - narrate "<red>You do not have a home set, <green><player.name><red>."
  - else:
    - narrate "<red>Hey, <green><player.name><red>, you do not have permission to run that command!"
    - stop
