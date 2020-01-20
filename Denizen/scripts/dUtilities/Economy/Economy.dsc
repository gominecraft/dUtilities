dEconomy:
  type: economy
  priority: normal
  name single: Dollar
  name plural: Dollars
  digits: 2
  format: $<amount>
  balance: <yaml[dutilities.<player.uuid>].read[balance]>
  has: <proc[dEconomyPlayerBalance]>
  withdraw:
  deposit:


dEconomyBalanceCommand:
  type: command
  name: balance
  description: Show player balance
  usage: /balance (playerName)
  aliases:
  - money
  permission: deconomy.use
  tab complete:
  - if <context.server>:
    - stop
  - if <player.has_permission[deconomy.balance.other]> || <player.is_op>:
    - if <context.args.size> == 1 && <context.raw_args.ends_with[<&sp>].not>:
      - determine <server.list_online_players.parse[name].filter[starts_with[<context.args.get[1]>]]>
  script:
  - if <context.args.get[1]||null> == null:
    - narrate "<gold>You have <green><amount> <gold>in your account."



dEconomyPlayerBalance:
  type: procedure
  definitions: balance
  script:
  - determine <yaml[dutilities.p.<player.uuid>].read[balance]
