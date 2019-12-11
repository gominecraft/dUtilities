setWarp:
  type: command
  debug: true
  name: setwarp
  description: Allows an admin to set a named warp.
  usage: /setwarp (name)
  permission: dutilities.setwarp
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if !<context.args.get[1].matches[[A-Za-z0-9]+]>:
    - narrate "<gold>You may only use <blue>A-Z, a-z, 0-9 <gold>and <blue>_<gold> in warp names."
    - stop
  - note <player.location> as:warp_<context.args.get[1]>

delWarp:
  type: command
  debug: true
  name: delwarp
  description: Delete a warp.
  usage: /delwarp [name]
  Aliases:
  - sdwarp
  permission: dutilities.delwarp
  tab complete:
  - if <context.args.is_empty>:
    - determine <server.list_notables[location].filter[starts_with[warp_]]>
  - if <context.args.size> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <server.list_notables[location].filter[starts_with[warp_<context.args.get[1]>]].after[_]>
  script:
  - if <context.args.get[1].matches[[A-Za-z0-9]+]> && <server.list_notables[location].filter[starts_with[warp_]]>:
    - note remove as:warp_<context.args.get[1]>
    - narrate "<gold>Removed warp '<blue><context.args.get[1]><gold>'."
  - else:
    - narrate "<gold> No such warp (<blue><context.args.get[1]><gold>) found."
    - stop

warp:
  type: command
  debug: true
  name: warp
  description: Sends a player to the chosen warp.
  usage: /warp
  permission: dutilities.warp
  tab complete:
  - if <context.args.is_empty>:
    - determine <server.list_notables[location].filter[starts_with[warp_]]>
  - if <context.args.size> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <server.list_notables[location].filter[starts_with[warp_<context.args.get[1]>]].after[_]>
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  # Empty args? Default warp.
  - if <context.args.is_empty>:
    - narrate "<gold>You must specify a warp name!"
    - stop
  - if <player.has_permission[dutilities.warp.<context.args.get[1]>]>:
    - if <server.list_notables[location].filter[warp_<context.args.get[1]>]||null> != null:
      - teleport <server.list_notables[location].filter[warp_<context.args.get[1]>]>
    - else:
      - narrate "<gold>No such warp (<blue><context.args.get[1]><gold>) found."
      - stop
  - else:
    - narrate "<gold>You do not have permission to access '<blue><context.args.get[1]><gold>'."
