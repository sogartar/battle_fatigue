::mods_queue("battle_fatigue", "mod_hooks(>=20),libreuse(>=0.1)", function() {
  ::mods_hookExactClass("entity/tactical/player", function(c) {
    c.onInitOriginalBattleFatigue <- c.onInit;
    c.onInit = function() {
      this.onInitOriginalBattleFatigue();
      this.m.Skills.add(this.new("scripts/skills/special/battle_fatigue_end_of_battle_monitor"));
    };
  });
});
