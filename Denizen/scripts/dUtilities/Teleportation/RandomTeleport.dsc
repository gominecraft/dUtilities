# +--------------------
# |
# | dutilities
# |
# | Allows players to be teleported to a random
# | location, a maximum distance from the
# | world spawn.
# |
# +----------------------
#
# @author GoMinecraft ( Discord: GoMinecraft#1421 )
# @date 2019/12/03
# @denizen-build DEV-4511+
# @script-version 1.1.0
#
# Usage - Alias: /wild, /rtp:
# /dutilities [player]
# /dutilities version - Shows the version
# /dutilities reload - Reloads the config.yml
#
# Permissions:
# dutilities.wild - Lets a player use /wild
# dutilities.wild.other # Lets a player use /wild on other players
# dutilities.version - Shows the dutilities version number
#
# Recommended usage:
#  * Setup zone-based permissions and only allow /wild to be
# used in spawn or set a high command-cooldown

# ---- Don't edit below here unless you know what you're doing.
# ---- I definitely don't know what I'm doing.

dUtilsVersion:
  type: yaml data
  version: 1.1.0

dUtilsRTPCommand:
  type: command
  debug: false
  name: randomtp
  usage: /randomtp (player)
  aliases:
  - rtp
  permission: dutilities.rtp
  script:

  # Sling an error if the config didn't load.
  - if !<server.flag[dutilitiesLoaded]>:
    - narrate "An error has occured in dutilities."
    - stop

  # If you have the permission.. version!
  - if <context.args.get[1]||null> == version && ( <player.has_permission[dutilities.version]> || <context.server> ):
    - narrate "<red>dutilities <green>v<script[dutilitiesVersion].yaml_key[version]>"
    - stop
  - if <context.args.get[1]> == reload && ( <player.has_permission[dutilities.reload]> || <context.server> )
    - inject dutilities_init
    - narrate "<green>dutilities has been reloaded."
    - stop

  # Let ops bypass the command-cooldown
  - if <player.has_flag[dutilitiesRecent]> && !<player.is_op>:
    - narrate "<red>You must wait <player.flag[dutilitiesRecent].expiration.formatted> before you can use this command again."
    - stop

  # Run dutilities or dutilities [player]
  - if <context.args.get[1]||null> == null:
    - define target:<player>
  - else:
    - if <player.has_permission[dutilities.other]>:
      - if <server.match_player[<context.args.get[1]>]> != null:
        - narrate "Found player ..."
        - define target:<server.match_player[<context.args.get[1]>]>
      - else:
        - narrate "<context.args.get[1]> not found."
    - else:
      - narrate "You do not have permission to use wild on other players."
      - stop

  - define maxDistFromSpawn:<yaml[dutilitiesConfig].read[max-teleport-distance]>
  - define disallowedChunks:<yaml[dutilitiesConfig].read[disallowed-biomes]>

  - if <yaml[dutilitiesConfig].read[use-worldborder]>:
    - define border:<player.location.world.border_size.div[2]>
    - if <[border]> > 10000:
      - define safeTeleportDistPositive:<[border].sub[1000]>
      - define safeTeleportDistNegative:<[safeTeleportDistPositive].mul[-1]>
    - else:
      - define safeTeleportDistPositive:<[border].sub[<[border].mul[0.10]>]>
      - define safeTeleportDistNegative:<[safeTeleportDistPositive].mul[-1]>
  - else:
    - define safeTeleportDistPositive:<[maxDistFromSpawn].sub[<[maxDistFromSpawn].as_element.mul[0.10]>]>
    - define safeTeleportDistNegative:<[safeTeleportDistPositive].to_element.mul[-1]>

  - define foundChunk:false
  - define loops:0

  - while !<[foundChunk]> && ( <[loops]> <= 5 ):
    - define loops:++
    - define randXCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>
    - define randZCoords:<util.random.int[<[safeTeleportDistNegative]>].to[<[safeTeleportDistPositive]>]>
    - if <yaml[dutilitiesConfig].read[blacklist-biomes].size> > 0:
      - define loc:<location[<[randXCoords]>,1,<[randZCoords]>,<player.location.world>]>
      - chunkload add <[loc].chunk> duration:1t
      - if !<[loc].biome.contains_any[<[disallowedChunks]>]>:
        - define foundChunk:true
    - else:
      - define foundChunk:true
    - wait 5t

  - if !<[foundChunk]> || <[loops]> >= 5:
    - narrate "<gold>Failed to find a safe place to send you. Try again!"
    - stop

  - if <yaml[dutilitiesConfig].read[use-effects]>:
    - playeffect sneeze <player.location.above.forward> quantity:25 offset:0.6
  - teleport <[target]> <[randXCoords]>,255,<[randZCoords]>,<[target].location.world>
  - flag <[target]> dutilitiesFreeFalling:true duration:<yaml[dutilitiesConfig].read[immunity-seconds]>
  - flag <[target]> dutilitiesRecent:true duration:<yaml[dutilitiesConfig].read[command-cooldown]>

dUtilsRTPEvents:
  type: world
  debug: false
  events:
    on reload scripts:
      - inject dutilitiesInit
    on server start:
      - inject dutilitiesInit

    on player damaged by FALL bukkit_priority:LOWEST:
      - if <player.has_flag[dutilitiesFreeFalling]>:
        - flag <player> dutilitiesFreeFalling:!
        - determine cancelled

    on entity starts gliding:
      - if <player.has_flag[dutilitiesFreeFalling]>:
        - flag <player> dutilitiesFreeFalling:!
