setPlayerData:
  type: task
  debug: false
  definitions: dataName|dataValue
  script:
    - if <player.is_online>:
      - yaml id:player.<player.uuid> set <[dataName]>:<[dataValue]>
    - else:
      - ~yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>
      - yaml id:player.<player.uuid> set <[dataName]>:<[dataValue]>
      - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>

getPlayerData:
  type: procedure
  debug: false
  definitions: dataName
  script:
    - if <player.is_online>:
      - determine <yaml[<player.uuid>].read[<[dataName]>]||null>
    - else:
      - ~yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>
      - define result <yaml[<player.uuid>].read[<[dataName]>]>
      - determine <result||null>

playerData_events:
  type: world 
  debug: false
  events:
    on player logs in priority:-2000:
      - if <server.has_file[../dUtilities/PlayerData/<player.uuid>.yml]>:
        - ~yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>
      - else:
        - yaml create id:player.<player.uuid>
        - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>

    on player quit priority:2000:
      - if <yaml.list.contains[player.<player.uuid>]>:
        - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:player.<player.uuid>
        - yaml unload id:player.<player.uuid>

    on shutdown:
      - foreach <yaml.list>:
        - if <[value].substring[1,6]> == player:
          - ~yaml savefile:../dUtilities/PlayerData/<[value].substring[8]>.yml id:<[value]>
