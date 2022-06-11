givCommand:
  type: command
  debug: false
  name: give
  description: Give a player an item.
  usage: /give [player] [item] (amount)
  permission: dutilities.give
  tab complete:
  - if <player.has_permission[dutilities.give]>:
    - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
    - if <context.args.get[2]||false> && <context.raw_args.ends_with[&sp].not>:
      - determine <server.materials.filter[is_item].include[<server.scripts.filter[container_type.is[==].to[item]]>].alphabetic.filter[starts_with[<context.args.get[2]>]]>
  script:
  - if <context.args.get[2]||null> == null:
    - narrate "<red>You did not specify an item."
    - stop
  - if <server.match_player[<context.args.get[1]>]||null> != null:
    - define player <server.match_player[<context.args.get[1]>]>
  - else:
    - narrate "<red>Player not found."
    - stop
  - define item <script[item_shorthands].data_key[<context.args.get[2]>]||<context.args.get[2]>>
  - if <context.args.get[3]||null> != null && <context.args.get[3]> != 0:
    - define amount:<context.args.get[3]>
  - else:
    - define amount:1
  - if <item[<[item]>]||null> != null:
    - give <[player]> <[item]> <[amount]>
    - narrate "<gold>You have recieved <green><[amount]> <gold>of <blue><[item].as_item.display||<[item].as_item.material.name.replace[_].with[ ].to_titlecase>>." targets:<[player]>
    - narrate "<gold>You have given <green><[amount]> <gold>of <blue><[item].as_item.display||<[item].as_item.material.name.replace[_].with[ ].to_titlecase>><gold> to <&b><[player].name><&6>."
  - else:
    - narrate "<red>Item not found / not valid."
    - stop

iCommand:
  type: command
  debug: false
  name: i
  description: Give yourself an item.
  usage: /i [item] (amount)
  permission: dutilities.give
  tab complete:
  - if <context.args.get[1]||false> && <context.raw_args.ends_with[&sp].not>:
    - determine <server.list_materials.filter[is_item].include[<server.scripts.filter[container_type.is[==].to[item]]>].alphabetic.filter[starts_with[<context.args.get[2]>]]>
  script:
  - if <context.args.get[1]||null> == null:
    - narrate "<red>You did not specify an item."
    - stop
  - else:
    - define amount:<context.args.get[2]||1>
    - define item:<script[item_shorthands].data_key[<context.args.get[1]>]||<context.args.get[1]>>
    - if <item[<[item]>]||true>:
      - narrate "<red>Item not found / not valid."
      - stop
    - else:
      - narrate "<gold>You have recieved <green><[amount]> <gold>of <blue><[item].as_item.display||<[item].as_item.material.name.replace[_].with[ ].to_titlecase>>."
      - give to:<player> <[item]> <[amount]>
