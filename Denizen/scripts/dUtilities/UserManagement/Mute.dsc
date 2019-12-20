mute:
  type: command
  debug: false
  name:
  description: Mute a player. Seee documentation for timeformat (Temporary mute)
  usage: /ban [player] (timeFormat)
  permission: dutilities.mute
  tab complete:
  - if <player.has_permission[dutilities.mute]>:
    - if <context.arguments.size||0> == 0:
      - determine <server.list_online_players.parse[name]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
  script:
  -if <context.args.get[1] >
  - flag <server.list_online_players[]>


muteChatEvents:
  type: world
  debug: false
  events:
    on player chats flagged:muted:
      - narrate "<red>You have been muted. "
      - determine cancelled
