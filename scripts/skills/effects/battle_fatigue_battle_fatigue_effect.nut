this.battle_fatigue_battle_fatigue_effect <- this.inherit("scripts/skills/injury/injury", {
  m = {
    FreeRounds = 2,
    StaminaModifierPerRound = -2,
    StaminaModifierPerBattleMin = -5,
    StaminaModifierDecayPerDayMin = 4,
    StaminaModifierDecayRatePerDay = 0.5,
    StaminaModifier = 0,
    BraveryModifierPerRound = -1,
    BraveryModifierPerBattleMin = -2.5,
    BraveryModifierDecayPerDayMin = 2,
    BraveryModifierDecayRatePerDay = 0.25,
    BraveryModifier = 0,
    IsAppliedInCurrentBattle = false,
    IconModerateStaminaThreshold = -8,
    IconStrongStaminaThreshold = -15,
    IconModerateBraveryThreshold = -5,
    IconStrongBraveryThreshold = -10,
    TreatmentPrice = 70,
    OnTreatmentBraveryModifierMult = 0.33,
    Round = 0
  },
  function create() {
    this.injury.create();
    this.m.ID = "effects.battle_fatigue.battle_fatigue";
    this.m.Name = "Battle Fatigue";
    this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury;
    this.m.IsHealingMentioned = false;
    this.m.IsTreatable = false;
    this.m.HealingTimeMin = 0;
    this.m.HealingTimeMax = 0;
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
          (this.Math.round(this.m.StaminaModifier * 10) / 10.0) + "[/color]. Resolve [color=" +
          this.Const.UI.Color.NegativeValue + "]" +
          (this.Math.round(this.m.BraveryModifier * 10) / 10.0) + "[/color]."
      },
      {
        id = 14,
        type = "text",
        text = "Will recover [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.Math.round(this.m.StaminaModifierDecayRatePerDay * 100) +
        "%[/color] per day of the penalty to maximum fatigue to a minimum of [color=" +
        this.Const.UI.Color.PositiveValue + "]" +
        this.m.StaminaModifierDecayPerDayMin + "[/color] per day."
      },
      {
        id = 15,
        type = "text",
        text = "Will recover [color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.Math.round(this.m.BraveryModifierDecayRatePerDay * 100) +
        "%[/color] per day of the penalty to resolve to a minimum of [color=" +
        this.Const.UI.Color.PositiveValue + "]" +
        this.m.BraveryModifierDecayPerDayMin + "[/color] per day." +
        " The resolve penalty can be treated in a temple. It will reduce the penalty by " + 
        "[color=" + this.Const.UI.Color.PositiveValue + "]" +
        this.Math.round((1 - this.m.OnTreatmentBraveryModifierMult) * 100) +
        "%[/color]."
      },
      {
        id = 16,
        type = "text",
        text = "Taking part of a battle will accumulate a penalty to maximum fatigue and resolve." + 
        " For each battle round after the first " + this.m.FreeRounds +
        ", accumulate [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifierPerRound +
        "[/color] maximum fatigue and [color=" + this.Const.UI.Color.NegativeValue + "]" +
        this.m.BraveryModifierPerRound + "[/color] resolve per round. The maximum penalty per battle is " +
        "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifierPerBattleMin +
        "[/color] to maximum fatigue and [color=" + this.Const.UI.Color.NegativeValue + "]" +
        this.m.BraveryModifierPerBattleMin + "[/color] to resolve." +
        " The effect is applied after the battle."
      },
    ];
    if (this.m.IsContentWithReserve)
    {
        ret.push({
            id = 17,
            type = "text",
            icon = "ui/icons/special.png",
            text = "Is content for now with being in reserve"
        });
    }
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

    this.updateHidden();
  }

  function decay() {
    local StaminaChange = this.Math.maxf(this.m.StaminaModifierDecayPerDayMin,
      -this.m.StaminaModifier * this.m.StaminaModifierDecayRatePerDay);
    this.m.StaminaModifier = this.Math.minf(0, this.m.StaminaModifier + StaminaChange);

    local BraveryChange = this.Math.maxf(this.m.BraveryModifierDecayPerDayMin,
      -this.m.BraveryModifier * this.m.BraveryModifierDecayRatePerDay);
    this.m.BraveryModifier = this.Math.minf(0, this.m.BraveryModifier + BraveryChange);

    this.updateHidden();
  }

  function onNewDay() {
    decay();
  }

  function onCombatStarted() {
    this.m.IsAppliedInCurrentBattle = false;
    this.m.Round = 0;
  }

  function onCombatFinished() {
    this.skill.onCombatFinished();
    if (!this.m.IsAppliedInCurrentBattle && this.isTakingPartInBattle()) {
      local rounds = this.Math.max(0, this.m.Round - this.m.FreeRounds);
      this.m.StaminaModifier += this.Math.maxf(this.m.StaminaModifierPerBattleMin,
        this.m.StaminaModifierPerRound * rounds);
      this.m.BraveryModifier += this.Math.maxf(this.m.BraveryModifierPerBattleMin,
        this.m.BraveryModifierPerRound * rounds);
      this.m.IsAppliedInCurrentBattle = true;
      this.updateHidden();
    }
  }

  function isTakingPartInBattle() {
    return this.getContainer().getActor().getPlaceInFormation() <= 17;
  }

  function onNewRound() {
    this.m.Round += 1;
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
  }

  function isTreatable() {
      return this.m.BraveryModifier != 0;
  }

  function getPrice() {
    return this.Const.Difficulty.BuyPriceMult[this.World.Assets.getEconomicDifficulty()] * this.m.TreatmentPrice;
  }

  function setTreated(_f) {
    if (_f == true) {
      this.m.BraveryModifier *= this.m.OnTreatmentBraveryModifierMult;
    }
  }
});
