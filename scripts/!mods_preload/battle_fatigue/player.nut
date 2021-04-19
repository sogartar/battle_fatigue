::mods_queue("battle_fatigue", "mod_hooks(>=20)", function() {
  ::mods_hookExactClass("entity/tactical/player", function(c) {
    c.onInitOriginalBattleFatigue <- c.onInit;
    c.onInit = function() {
      this.onInitOriginalBattleFatigue();
      this.m.Skills.add(this.new("scripts/skills/effects/battle_fatigue_battle_fatigue_effect"));
    };
  });
});
