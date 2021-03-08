this.end_of_battle_monitor <- this.inherit("scripts/skills/skill", {
  m = {
    IsApplied = false
  },
  function create() {
    this.m.ID = "special.end_of_battle_monitor";
    this.m.Name = "";
    this.m.Icon = "";
    this.m.Type = this.Const.SkillType.Special;
    this.m.Order = this.Const.SkillOrder.Last;
    this.m.IsActive = false;
    this.m.IsHidden = true;
    this.m.IsSerialized = false;
  }

  function onCombatStarted() {
    this.m.IsApplied = false;
  }

  function onCombatFinished() {
    if (!this.m.IsApplied) {
      this.getContainer().add(this.new("scripts/!mods_preload/battle_fatigue/battle_fatigue_effect"));
      this.m.IsApplied = true;
    }
  }
});
