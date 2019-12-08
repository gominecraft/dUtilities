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
  - if <context.args.size> == 0:
    - run setPlayerData homes.default|<player.location>
  - else:
    - define HomeName:<context.args.get[1]>
    - run setPlayerData homes.<[HomeName]>|<player.location>
    
  - ~yaml savefile:../dUtilities/PlayerData
    

home:
  type: command
  debug: false
  name: home
  description: Sends a player to their home, if they have one.
  usage: /home
  permission: dutilities.home
  script:
  - if <context.server>:
    - announce to_console "[dUtilities] This command must be issued in-game."
    - stop
