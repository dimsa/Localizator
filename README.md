# VCLLocalizator
## Delphi VCL(It can be easy changed for FMX) Localizator, by Dmitriy Sorokin.

###Check Project file:
```Localizator := TLocalizator.Create;
  with Localizator do begin
    AddForm(MainForm);
    AddForm(LanguageForm);
  end;
  MainForm.Init(Localizator);

  Application.Run;```
  
 
###Then check Init method in MainForm

```procedure TMainForm.Init(ALocalizator: TLocalizator);
begin
  // Loading from json text file
  FLocalizator := ALocalizator;
  LanguageForm.Init(FLocalizator.GetLocaleList);
  LanguageForm.LocaleChanged := OnLocaleChanged;
  // ALocalizator.LoadFromFile('Localization.txt');
  // You can also load from resource
  ALocalizator.LoadFromRes('Localization');

  ALocalizator.ChangeLanguage(En);

  // Please check uLocalizedString. It has runtime localization ability
end;```

By Dmitriy Sorokin