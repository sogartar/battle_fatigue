::mods_queue("battle_fatigue", "mod_hooks(>=19)", function() {
  ::mods_hookNewObject("entity/tactical/player", function(c) {
    c = ::mods_getClassForOverride(c, "player");
    c.m.Skills.add(this.new("scripts/skills/effects/battle_fatigue_battle_fatigue_effect"));
  });

  ::mods_hookExactClass("entity/tactical/player", function(c) {
    c.onHiredBattleFatigue <- c.onHired;
    c.onHired = function() {
      this.onHiredBattleFatigue();
      this.m.Skills.add(this.new("scripts/skills/effects/battle_fatigue_battle_fatigue_effect"));
    };
  });
});
