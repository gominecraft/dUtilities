clear:
  type: command
  debug: false
  name: clear
  description: Clear your own or another player's inventory
  usage: /clear
  permission: dutilities.clear
  tab complete:
  - if <context.arguments.size||0> == 0:
    - determine <server.list_online_players.parse[name]>
  - else if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
    - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
  script:
  # Check if there's an argument
  - if <context.args.get[1]||null> != null:
    - define target:<context.args.get[1]>
    # Permission check
    - if <player.has_permission[dutilities.clear.other]>:
      # Match online player
      - if <server.match_player[<context.args.get[1]>]>:
        - inventory clear d:<p@[<[target]>].inventory>
        - narrate "<gold>You have cleared <green><[target]><gold>'s inventory.'"
        # Do some logging.
        - if <context.server>
          - "Console user cleared <[target]>'s inventory."
        - else:
          - announce to_console "<player.name> cleared <[target]>'s inventory."
      - else:
        - narrate "<red>Player (<green><[target]><red>) not found. Is the player online?"
    - else:
      - narrate "<red>Hey, <green><player.name><red>, you do not have permission to run that command!"
  # Self-clear
  - else:
    - inventory clear d:<player.inventory>
    - narrate "<gold>Your inventory has been cleared."
