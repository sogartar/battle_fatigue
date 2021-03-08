this.battle_fatigue_effect <- this.inherit("scripts/skills/injury/injury", {
  m = {
    StaminaModifier = -6,
    BraveryModifier = -3
  },
  function create()
  {
    this.injury.create();
    this.m.ID = "effects.battle_fatigue";
    this.m.Name = "Battle Fatigue";
    this.m.Description = "A recent battle has fatigued phisicaly and mentaly this character.";
    this.m.Icon = "skills/status_effect_53.png";
    this.m.IconMini = "status_effect_53_mini";
    this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.SemiInjury;
    this.m.IsHealingMentioned = false;
    this.m.IsTreatable = false;
    this.m.HealingTimeMin = 1;
    this.m.HealingTimeMax = 2;
    this.m.IsStacking = true;
  }

  function getTooltip()
  {
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
        icon = "ui/icons/fatigue.png",
        text = "Maximum Fatigue [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.StaminaModifier + "[/color]. Resolve [color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.BraveryModifier + "[/color]."
      }
    ];
    this.addTooltipHint(ret);
    return ret;
  }

  function onUpdate( _properties )
  {
    this.injury.onUpdate(_properties);
    _properties.Stamina += this.m.StaminaModifier;
    _properties.Bravery += this.m.BraveryModifier;
  }

});
