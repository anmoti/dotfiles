{ lib }:

let
  # Pinned by npins (`hm skills` updates ../npins/sources.json).
  pins = import ../npins;

  # Each direct subdirectory of dir is one skill: name -> path.
  skillsIn =
    dir:
    lib.mapAttrs (name: _: "${dir}/${name}") (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
    );
in
skillsIn ./local
// skillsIn "${pins.yomiyasu}/skills" # not "${pins.yomiyasu}" itself: tests/ etc. also contain SKILL.md
