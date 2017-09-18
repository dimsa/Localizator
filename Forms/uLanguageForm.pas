unit uLanguageForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uEvents, uLocalizationCommon, uLocalizedStrings;

type
  TLanguageForm = class(TForm)
    LangCmb: TComboBox;
    LanguageLbl: TLabel;
    CancelBtn: TButton;
    ApplyBtn: TButton;
    InfoLbl: TLabel;
    procedure ApplyBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FLocaleChanged: TNotifyEvent<TLanguageName>;
  public
    procedure Init(const ALangList: TStringList);
    property LocaleChanged: TNotifyEvent<TLanguageName> write FLocaleChanged;
  end;

var
  LanguageForm: TLanguageForm;

implementation

{$R *.dfm}

{ TLanguageForm }

procedure TLanguageForm.ApplyBtnClick(Sender: TObject);
begin
  if LangCmb.ItemIndex < 0 then
  begin
    ShowMessage(TLocalization.Get('LanguageNotSelected'));
    Exit;
  end;

  if Assigned(FLocaleChanged) then
  begin
    FLocaleChanged(StringToLanguageName(LangCmb.Items[LangCmb.ItemIndex]));
    Close;
  end;
end;

procedure TLanguageForm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TLanguageForm.FormShow(Sender: TObject);
begin
  Left := (monitor.Width div 2)-(Width div 2);
  Top := (monitor.Height div 2)-(Height div 2);
end;

procedure TLanguageForm.Init(const ALangList: TStringList);
var
  i: Integer;
begin
  LangCmb.Clear;
  for i := 0 to ALangList.Count - 1 do
    LangCmb.AddItem(ALangList[i], nil);

  if ALangList.Count >= 0 then
    LangCmb.ItemIndex := ALangList.Count - 1;
  ALangList.Free;
end;

end.
