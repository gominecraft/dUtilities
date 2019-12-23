InventoryPeek:
  type: command
  debug: false
  name: invpeek
  description: Open (and modify) a player's inventory
  usage: /invpeek
  aliases:
  - openinv
  permission: dutilities.invpeek
  tab complete:
  - if <player.has_permission[dutilities.invpeek]>:
    - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
  script:
  - inventory open d:<server.match_player[<context.args.get[1]>]>
