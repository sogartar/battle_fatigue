::mods_queue("battle_fatigue", "mod_hooks(>=19)", function() {
  ::mods_hookClass("ui/screens/world/modules/world_town_screen/town_temple_dialog_module", function(c) {
    c = ::mods_getClassForOverride(c, "town_temple_dialog_module");
    c.queryRosterInformation = function() {
      local brothers = this.World.getPlayerRoster().getAll();
      local roster = [];

      foreach( b in brothers )
      {
          local injuries = [];
          local allInjuries = b.getSkills().query(this.Const.SkillType.TemporaryInjury | this.Const.SkillType.SemiInjury);

          for( local i = 0; i != allInjuries.len(); i = ++i )
          {
              local inj = allInjuries[i];

              if (!inj.isTreated() && inj.isTreatable())
              {
                  injuries.push({
                      id = inj.getID(),
                      icon = inj.getIconColored(),
                      name = inj.getNameOnly(),
                      price = inj.getPrice()
                  });
              }
          }

          if (injuries.len() == 0)
          {
              continue;
          }

          local background = b.getBackground();
          local e = {
              ID = b.getID(),
              Name = b.getName(),
              ImagePath = b.getImagePath(),
              ImageOffsetX = b.getImageOffsetX(),
              ImageOffsetY = b.getImageOffsetY(),
              BackgroundImagePath = background.getIconColored(),
              BackgroundText = background.getDescription(),
              Injuries = injuries
          };
          roster.push(e);
      }

      return {
          Title = "Temple",
          SubTitle = "Have your wounded treated and prayed for by priests",
          Roster = roster,
          Assets = this.m.Parent.queryAssetsInformation()
      };
    };

    c.onTreatInjury = function( _data ) {
      local entityID = _data[0];
      local injuryID = _data[1];
      local entity = this.Tactical.getEntityByID(entityID);
      local injury = entity.getSkills().getSkillByID(injuryID);
      injury.setTreated(true);
      this.World.Assets.addMoney(-injury.getPrice());
      entity.updateInjuryVisuals();
      local injuries = [];
      local allInjuries = entity.getSkills().query(this.Const.SkillType.TemporaryInjury | this.Const.SkillType.SemiInjury);

      foreach( inj in allInjuries )
      {
          if (!inj.isTreated())
          {
              injuries.push({
                  id = inj.getID(),
                  icon = inj.getIconColored(),
                  name = inj.getNameOnly(),
                  price = inj.getPrice()
              });
          }
      }

      local background = entity.getBackground();
      local e = {
          ID = entity.getID(),
          Name = entity.getName(),
          ImagePath = entity.getImagePath(),
          ImageOffsetX = entity.getImageOffsetX(),
          ImageOffsetY = entity.getImageOffsetY(),
          BackgroundImagePath = background.getIconColored(),
          BackgroundText = background.getDescription(),
          Injuries = injuries
      };
      local r = {
          Entity = e,
          Assets = this.m.Parent.queryAssetsInformation()
      };
      this.World.Statistics.getFlags().increment("InjuriesTreatedAtTemple");
      this.updateAchievement("PatchedUp", 1, 1);
      return r;
    };
  });
});
