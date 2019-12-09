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
  - if <context.args.is_empty>:
    - run setPlayerData homes.default|<player.location>
    - if <proc[getPlayerData].context[DefaultHome]||null> == null:
      - run setPlayerData DefaultHome|default
  - else:
    - define HomeName:<context.args.get[1]>
    - run setPlayerData homes.<[HomeName]>|<player.location>

setDefaultHome:
  type: command
  debug: false
  name: setdefaulthome
  description: Set a player home.
  usage: /setdefaulthome [name]
  Aliases:
  - sdhome
  permission: dutilities.sethome
  tab completion:
  - if <context.args.is_empty>:
    - determine <yaml[player.<player.uuid>].list_keys[homes]>
  - if <context.args.get> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <yaml[player.<player.uuid>].read[homes].filter[starts_with[<context.args.get[1]>]]>
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <context.args.is_empty>:
    - narrate "<gold>You must specify an existing home name."
  - else:
    - if <proc[getPlayerData].context[homes.<context.args.get[1]>]>:
      - run setPlayerData DefaultHome|<context.args.get[1]>
      - narrate "<gold>Default home set to <green><context.args.get[1]><gold>."
    - else:
      - narrate "<gold>Home name not found: <red><context.args.get[1]><gold>."

home:
  type: command
  debug: false
  name: home
  description: Sends a player to their home, if they have one.
  usage: /home
  permission: dutilities.home
  tab completion:
  - if <context.args.is_empty>:
    - determine <yaml[player.<player.uuid>].list_keys[homes]>
  - if <context.args.get> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <yaml[player.<player.uuid>].read[homes].filter[starts_with[<context.args.get[1]>]]>
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  # Empty args? Default home.
  - if <context.args.is_empty>
    - if <yaml[player.<player.uuid>].read[DefaultHome]||null> == null:
      # No default home? Lets see if they have a "default" home.
      - if <yaml[player.<player.uuid>].read[homes.default]||null> == null:
        - narrate "<red>You do not have a home set. Use <blue>/sethome<red> to set your default home location."
      - else:
        - teleport <player> <yaml[player.<player.uuid>].read[homes.default]>
        # Fix the missing DefaultHome value.
        - run setPlayerData DefaultHome|default
    - else:
      - define defaultHome:<yaml[player.<player.uuid>].read[DefaultHome]>
      - teleport <player> <yaml[player.<player.uuid>].read[homes.<[defaultHome]>]>
  - else:
    - define <[argHome]>:<context.args.get[1]>
    - if <yaml[player.<player.uuid>].read[homes.<[argHome]>]||null> == null:
      - narrate "<red>Specified home (<blue><[argHome]><red>) not found."
    - else:
      - define argHome:<context.args.get[1]>
      - teleport <player> <yaml[player.<player.uuid>].read[homes.<[argHome]>]>
