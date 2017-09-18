program VCLLocalizatorDemo;

{$R *.dres}

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {MainForm},
  uLanguageForm in 'Forms\uLanguageForm.pas' {LanguageForm},
  uComponentWrapper in 'Localizator\uComponentWrapper.pas',
  uFormLocalizer in 'Localizator\uFormLocalizer.pas',
  uLocalizationCommon in 'Localizator\uLocalizationCommon.pas',
  uLocalizator in 'Localizator\uLocalizator.pas',
  uLocalizedStrings in 'Localizator\uLocalizedStrings.pas',
  uEvents in 'Common\uEvents.pas',
  uOrderedDict in 'Common\uOrderedDict.pas';

{$R *.res}

var
  Localizator: TLocalizator;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TLanguageForm, LanguageForm);
  Localizator := TLocalizator.Create;
  with Localizator do begin
    AddForm(MainForm);
    AddForm(LanguageForm);
  end;
  MainForm.Init(Localizator);

  Application.Run;
end.
