::mods_hookNewObject("entity/tactical/player", function(c) {
  c.getSkills().add(this.new("scripts/!mods_preload/battle_fatigue/end_of_battle_monitor"));
});
