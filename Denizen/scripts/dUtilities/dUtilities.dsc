
# +--------------------
# |
# | dUtilities
# |
# | A light weight *actual* essential toolset, minus the junk
# |
# +----------------------
#
# @author GoMinecraft ( Discord: GoMinecraft#1421 )
# @date 2020/1/22
# @denizen-build DEV-4550+
# @script-version 0.0.1
#

# ---- Don't edit below here unless you know what you're doing.
# ---- I definitely don't know what I'm doing.

dUtilities:
  type: world
  version: 0.0.1
  events:
    on version command:
      - if <context.args.get[1]||null> == dUtilities:
        - narrate <script.data_key[version]>
        - determine fulfilled

    on reload scripts:
      - inject dUtilitiesInit

    on server start:
      - inject dUtilitiesInit

dUtilitiesInit:
  type: task
  debug: true
  script:
  - if <server.has_file[../dUtilities/config.yml]>:
    - ~yaml load:../dUtilities/config.yml id:dUtilitiesConfig
    - announce to_console "[dUtilities] Loaded config"
  - else:
    - announce to_console "[dUtilities] Failed to load config.yml!"
    - stop

dUtilitiesSetPlayerData:
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

dUtilitiesPlayerDataEvents:
  type: world
  debug: true
  events:
    on player logs in:
    - if <server.has_file[../dUtilities/PlayerData/<player.uuid>.yml]>:
      - yaml load:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>
    - else:
      - yaml create id:dutilities.p.<player.uuid>
      - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>

    on player quit priority:10:
    - if <yaml.list.contains[dutilities.p.<player.uuid>]>:
      - ~yaml savefile:../dUtilities/PlayerData/<player.uuid>.yml id:dutilities.p.<player.uuid>
      - yaml unload id:dutilities.p.<player.uuid>

    on shutdown:
    - foreach <yaml.list>:
      - if <[value].substring[1,6]> == player:
        - ~yaml savefile:../dUtilities/PlayerData/<[value].substring[8]>.yml id:<[value]>
