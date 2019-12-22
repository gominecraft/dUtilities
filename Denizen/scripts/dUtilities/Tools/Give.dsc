give:
  type: command
  debug: false
  usage: /give [player] [item] (amount)
  aliases:
  permission: dutilities.give
  tab complete:
  - if <player.has_permission[dutilities.give]>:
    - if <context.arguments.size||0> == 0:
      - determine <server.list_online_players.parse[name]>
    - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
    - if <context.args.get[2]||false> && <context.raw_args.end_with[&sp].not>:
      - determine <server.list_materials.filter[is_item].include[<server.list_scripts.filter[container_type.is[==].to[item]]>].alphabetic.filter[starts_with[<context.args.get[2]>]]>
  script:
  - if <context.args.get[2]||null> == null:
    - narrate "<red>You did not specify an item."
    - stop
  - if <server.list_online_players.match[<context.args.get[1]>]>:
    - define player:<server.list_online_players.match[<context.args.get[1]>]>
  - else:
    - narrate "<red>Player not found."
    - stop
  - define item:<context.args.get[2]>
  - if <context.args.get[3]||null> != null && <context.args.get[3]> != 0:
    - define amount:<context.args.get[3]>
  - else:
    - define amount:1

  - if <item[<[item]>]||null> != null:
    - give <[player]> <[item]> <[amount]>
  - else:
    - narrate "<red>Item not found / not valid."
    - stop
