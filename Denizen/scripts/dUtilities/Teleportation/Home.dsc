setHome:
  type: command
  debug: true
  name: sethome
  description: Allows a player to set a (named) home.
  usage: /sethome (name)
  permission: dutilities.sethome
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if !<yaml[dUtilitiesConfig].read[homes.worlds].contains[<player.location.world.name>]> && !<player.is_op>:
    - narrate "<gold>You may not set a home in this world."
    - stop
  - if <context.args.is_empty>:
    - run setPlayerData def:homes.default|<player.location>
    - if <yaml[player.<player.uuid>].read[DefaultHome]||null> == null:
      - run setPlayerData def:DefaultHome|default
      - narrate "<green>Default home set."
      - stop
  - else:
    - if !<context.args.get[1].matches[[A-Za-z0-9]+]>:
      - narrate "<gold>You may only use <blue>A-Z, a-z, 0-9 <gold>and <blue>_<gold> in home names."
      - stop
    # No, you may not name your home default.
    - if <context.args.get[1]||null> == default:
      - narrate "<gold>You cannot set <blue>default<gold> as a home name."
      - stop
    # Only look at the first group. The logic to bounce through all the groups is above me.
    - if <yaml[dUtilitiesConfig].read[homes.groups.<player.groups.get[1]>]||null> == null && !<player.is_op>:
      - narrate "<gold>The group you are a member of (<blue><player.groups.get[1]><gold>) cannot set a named home."
      - stop
    - else:
      # Player is an Op? Give them 500 homes.
      - if <player.is_op>:
        - define maxHomes:500
      - else:
        - define maxHomes:<yaml[dUtilitiesConfig].read[homes.groups.<player.groups.get[1]>]||1>
      - define playerHomeCount:<yaml[player.<player.uuid>].list_keys[homes].size>
      - if <[playerHomeCount]> >= <[maxHomes]>:
        - narrate "<gold>You have <blue><[playerHomeCount]> <gold>/ <blue><[maxHomes]><gold>. You cannot create another until you delete one."
        - stop
      - else:
        - run setPlayerData def:homes.<context.args.get[1]>|<player.location>
        - narrate "<gold>Your named home (<blue><context.args.get[1]><gold>) has been set!"
        - stop

delHome:
  type: command
  debug: true
  name: delhome
  description: Let the player delete a home they own.
  usage: /delhome [name]
  Aliases:
  - sdhome
  permission: dutilities.delhome
  tab complete:
  - if <context.args.is_empty>:
    - determine <yaml[player.<player.uuid>].list_keys[homes]||null>
  - if <context.args.size> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <yaml[player.<player.uuid>].read[homes].filter[starts_with[<context.args.get[1]>]]||null>
  script:
  - if <yaml[player.<player.uuid>].read[homes.<context.args.get[1]>]||null> == null:
    - narrate "<gold>No home found by that name."
    - stop
  - else:
    - yaml id:player.<player.uuid> set homes.<context.args.get[1]>:!
    - narrate "<gold>Your home (<blue><context.args.get[1]><gold>) has been removed."

setDefaultHome:
  type: command
  debug: true
  name: setdefaulthome
  description: Let the player set their default home.
  usage: /setdefaulthome [name]
  Aliases:
  - sdhome
  permission: dutilities.sethome
  tab complete:
  - if <context.args.is_empty>:
    - determine <yaml[player.<player.uuid>].list_keys[homes]||null>
  - if <context.args.size> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <yaml[player.<player.uuid>].read[homes].filter[starts_with[<context.args.get[1]>]]||null>
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  - if <context.args.is_empty>:
    - narrate "<gold>You must specify an existing home name."
    - stop
  - else:
    - if <yaml[player.<player.uuid>].read[homes.<context.args.get[1]>]||null> ==null null:
      - narrate "<gold>Home '<blue><context.args.get[1]><gold>' not found."
      - stop
    - else:
      - run setPlayerData def:DefaultHome|<context.args.get[1]>
      - narrate "<gold>Default home set to '<green><context.args.get[1]><gold>'."

home:
  type: command
  debug: true
  name: home
  description: Sends a player to their chosen home, if they have one.
  usage: /home
  permission: dutilities.home
  tab complete:
  - if <context.args.is_empty>:
    - determine <yaml[player.<player.uuid>].list_keys[homes]||null>
  - if <context.args.size> == 1 && !<context.raw_args.ends_with[&sp]>:
    - determine <yaml[player.<player.uuid>].read[homes].filter[starts_with[<context.args.get[1]>]]||null>
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
  # Empty args? Default home.
  - if <context.args.is_empty>:
    - if <yaml[player.<player.uuid>].read[DefaultHome]||null> == null:
      # No default home? Lets see if they have a "default" home.
      - if <yaml[player.<player.uuid>].read[homes.default]||null> == null:
        - narrate "<>You do not have a home set. Use <blue>/sethome<gold> to set your default home location."
        - stop
      - else:
        - teleport <yaml[player.<player.uuid>].read[homes.default]>
        # Fix the missing DefaultHome value.
        - run setPlayerData def:DefaultHome|default
    - else:
      - define defaultHome:<yaml[player.<player.uuid>].read[DefaultHome]>
      - teleport <yaml[player.<player.uuid>].read[homes.<[defaultHome]>]>
  - else:
    - define homeName:<context.args.get[1]>
    - if <yaml[player.<player.uuid>].read[homes.<[homeName]>]||null> == null:
      - narrate "<gold>Specified home (<blue><[homeName]><gold>) not found."
    - else:
      - define homeName:<context.args.get[1]>
      - teleport <yaml[player.<player.uuid>].read[homes.<[homeName]>]>
