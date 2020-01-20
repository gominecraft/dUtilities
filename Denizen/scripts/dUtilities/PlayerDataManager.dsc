setPlayerData:
  type: task
  debug: true
  definitions: dataName|dataValue
  script:
    - if <player.is_online>:
      - yaml id:dutilities.p.<player.uuid> set <[dataName]>:<[dataValue]>
    - else:
      - ~yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>
      - yaml id:dutilities.p.<player.uuid> set <[dataName]>:<[dataValue]>
      - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>

playerDataEvents:
  type: world
  debug: true
  events:
    on player logs in:
      - if <server.has_file[../dUtilities/PlayerData/<player.uuid>.yml]>:
        - yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>
      - else:
        - yaml create id:dutilities.p.<player.uuid>
        - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>

    on player quit priority:LOWEST:
      - if <yaml.list.contains[dutilities.p.<player.uuid>]>:
        - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>
        - yaml unload id:dutilities.p.<player.uuid>

    on shutdown:
      - foreach <yaml.list>:
        - if <[value].substring[1,6]> == player:
          - ~yaml savefile:../dUtilities/PlayerData/<[value].substring[8]>.yml id:<[value]>
