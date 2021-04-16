this.battle_fatigue_end_of_battle_monitor <- this.inherit("scripts/skills/skill", {
  m = {
    IsApplied = false,
    ProbabilityOfGettingBattleFatigue = 0.6
  },
  function create() {
    this.m.ID = "special.battle_fatigue.end_of_battle_monitor";
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
      if (this.Math.rand(1, 1000) <= 1000 * this.m.ProbabilityOfGettingBattleFatigue) {
        this.getContainer().add(this.new("scripts/skills/effects/battle_fatigue_battle_fatigue_effect"));
      }
      this.m.IsApplied = true;
    }
  }
});
