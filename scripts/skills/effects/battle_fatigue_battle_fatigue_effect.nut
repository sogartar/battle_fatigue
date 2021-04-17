this.battle_fatigue_battle_fatigue_effect <- this.inherit("scripts/skills/injury/injury", {
  m = {
    StaminaModifierPerBattle = -2,
    StaminaModifierDecayPerDayMin = 2,
    StaminaModifierDecayRatePerDay = 0.2,
    StaminaModifier = 0,
    BraveryModifierPerBattle = -1,
    BraveryModifierDecayPerDayMin = 1,
    BraveryModifierDecayRatePerDay = 0.1,
    BraveryModifier = 0,
    IsAppliedInCurrentBattle = false,
    IconModerateStaminaThreshold = -7,
    IconStrongStaminaThreshold = -14,
    IconModerateBraveryThreshold = -5,
    IconStrongBraveryThreshold = -10
  },
  function create() {
    this.injury.create();
    this.m.ID = "effects.battle_fatigue.battle_fatigue";
    this.m.Name = "Battle Fatigue";
    this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury;
    this.m.IsHealingMentioned = false;
    this.m.IsTreatable = false;
    this.m.HealingTimeMin = 999;
    this.m.HealingTimeMax = 999;
    this.m.IsHidden = true;
    this.m.IsContentWithReserve = false;
    this.m.IsStacking = true;
  }

  function onAdded() {
    local container = this.getContainer();
    local battleFatigueSkills = container.getAllSkillsByID(this.m.ID);
    foreach (s in battleFatigueSkills) {
      if (s != this) {
        container.remove(s);
      }
    }
  }

  function getIcon() {
    return this.getIconColored();
  }

  function getIconColored() {
    if (this.m.StaminaModifier > this.m.IconModerateStaminaThreshold &&
      this.m.BraveryModifier > this.m.IconModerateBraveryThreshold) {
      return "skills/battle_fatigue_weak.png";
    } else if (this.m.StaminaModifier > this.m.IconStrongStaminaThreshold &&
      this.m.BraveryModifier > this.m.IconStrongBraveryThreshold) {
      return "skills/battle_fatigue_moderate.png";
    } else {
      return "skills/battle_fatigue_strong.png";
    }
  }

  function getDescription() {
    return "Recent battles has fatigued phisicaly and mentaly this character.";
  }

  function getTooltip() {
    local ret = [
      {
        id = 1,
        type = "title",
        text = this.getName()
      },
      {
        id = 2,
        type = "description",
        text = this.getDescription()
      },
      {
        id = 13,
        type = "text",
        text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" +
          this.m.StaminaModifier + "[/color]. Resolve [color=" + this.Const.UI.Color.NegativeValue + "]" +
          this.m.BraveryModifier + "[/color]."
      },
      {
        id = 14,
        type = "text",
        text = "Will recover [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.Math.round(this.m.StaminaModifierDecayRatePerDay * 100) +
        "%[/color] maximum fatigue per day to a minimum of [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.m.StaminaModifierDecayPerDayMin + "[/color]."
      },
      {
        id = 15,
        type = "text",
        text = "Will recover [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.Math.round(this.m.BraveryModifierDecayRatePerDay * 100) +
        "%[/color] resolve per day to a minimum of [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.m.BraveryModifierDecayPerDayMin + "[/color]."
      },
      {
        id = 16,
        type = "text",
        text = "Taking part of a battle will accumulate additional [color=" + this.Const.UI.Color.NegativeValue + "]" +
        this.m.StaminaModifierPerBattle + "[/color] maximum fatigue and [color=" + this.Const.UI.Color.NegativeValue + "]" +
        this.m.BraveryModifierPerBattle + "[/color] resolve."
      },
    ];
    this.addTooltipHint(ret);
    return ret;
  }

  function updateHidden() {
    this.m.IsHidden = (this.m.StaminaModifier == 0 && this.m.BraveryModifier == 0);
    this.m.IsContentWithReserve = !this.m.IsHidden;
  }

  function onUpdate(_properties) {
    this.injury.onUpdate(_properties);
    _properties.Stamina += this.Math.round(this.m.StaminaModifier);
    _properties.Bravery += this.Math.round(this.m.BraveryModifier);

    #this.logInfo("battle_fatigue_battle_fatigue_effect.onUpdate: this.m.StaminaModifier = " + this.m.StaminaModifier);
    #this.logInfo("battle_fatigue_battle_fatigue_effect.onUpdate: this.m.BraveryModifier = " + this.m.BraveryModifier);
    this.updateHidden();
    #this.logInfo("battle_fatigue_battle_fatigue_effect.onUpdate: " + this.getContainer().getActor().getName() + ": this.m.IsHidden = " + this.m.IsHidden);
  }

  function decay() {
    #this.logInfo("battle_fatigue_battle_fatigue_effect.decay called.");
    local StaminaChange = this.Math.maxf(this.m.StaminaModifierDecayPerDayMin,
      -this.m.StaminaModifier * this.m.StaminaModifierDecayRatePerDay);
    #this.logInfo("StaminaChange = " + StaminaChange);
    this.m.StaminaModifier = this.Math.minf(0, this.m.StaminaModifier + StaminaChange);

    local BraveryChange = this.Math.maxf(this.m.BraveryModifierDecayPerDayMin,
      -this.m.BraveryModifier * this.m.BraveryModifierDecayRatePerDay);
    #this.logInfo("BraveryChange = " + BraveryChange);
    this.m.BraveryModifier = this.Math.minf(0, this.m.BraveryModifier + BraveryChange);

    this.updateHidden();
  }

  function onNewDay() {
    decay();
  }

  function onCombatStarted() {
    this.m.IsAppliedInCurrentBattle = false;
  }

  function onCombatFinished() {
    if (!this.m.IsAppliedInCurrentBattle) {
      this.m.StaminaModifier += this.m.StaminaModifierPerBattle;
      this.m.BraveryModifier += this.m.BraveryModifierPerBattle;
      this.m.IsAppliedInCurrentBattle = true;
      this.m.IsHidden = false;
      this.m.IsContentWithReserve = true;
    }
  }

  function onSerialize(_out) {
    this.injury.onSerialize(_out);
    _out.writeF32(this.m.StaminaModifier);
    _out.writeF32(this.m.BraveryModifier);
  }

  function onDeserialize(_in) {
    this.injury.onDeserialize(_in);
    this.m.StaminaModifier = _in.readF32();
    this.m.BraveryModifier = _in.readF32();
    #this.logInfo("battle_fatigue_battle_fatigue_effect.onDeserialize: this.m.StaminaModifier = " + this.m.StaminaModifier);
    #this.logInfo("battle_fatigue_battle_fatigue_effect.onDeserialize: this.m.BraveryModifier = " + this.m.BraveryModifier);
  }
});
