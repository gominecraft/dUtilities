
# +--------------------
# |
# | dUtilities
# |
# | A light weight *actual* essential toolset, minus the junk
# |
# +----------------------
#
# @author GoMinecraft ( Discord: GoMinecraft#1421 )
# @date 2019/12/6
# @denizen-build REL-1696
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
        - narrate <script.yaml_key[version]>
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
