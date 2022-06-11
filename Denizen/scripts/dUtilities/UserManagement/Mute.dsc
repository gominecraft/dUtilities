muteChatEvents:
  type: world
  debug: false
  events:
    on player chats flagged:muted:
      - narrate "<red>You have been muted."
      - determine cancelled

mute:
  type: command
  debug: false
  name: mute
  description: Mute a player. Seee documentation for timeformat (Temporary mute)
  usage: /mute [player] (timeFormat)
  permission: dutilities.mute
  tab complete:
  - if <player.has_permission[dutilities.mute]>:
    - if <context.arguments.size||0> == 0:
      - determine <server.online_players.parse[name]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
  script:
  - if <context.args.get[1]||null> != null:
    - if <server.match_offline_player[<context.args.get[1]>]||false>:
      - if <context.args.get[2].regex_matches[([0-9]{1,3}(|m|h|d))]>:
        - define duration:<context.args.get[2]>
      - else:
        - narrate "<red>Time format not recognized or empty."
        - run showUsage
      - flag <server.match_offline_player[<context.args.get[1]>]> muted:1 duration:<[duration]>
      - narrate "<blue><context.args.get[1]><blue> has been muted for <red><[duration]>."
    - else:
      - narrate "<red>No player found by that name."
  - else:
    - run showMuteUsage

showMuteUsage:
  type: task
  debug: false
  script:
  - narrate "<gold>Usage: <blue>/mute <red>[player] <green>[time]"
  - narrate "  <gold>Example: <blue>/mute <red><player.name> <green>5m"
  - narrate "  <gold>Time Formats: #m, #h, #d"
  - narrate "  <gold>Max value: <red>999"
