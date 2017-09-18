unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  uLocalizator, uLocalizedStrings, uLocalizationCommon;

type
  TMainForm = class(TForm)
    ChangeLanguageBtn: TButton;
    ChangeLanguageLbl: TLabel;
    ChangeLanguageMemo: TMemo;
    ChangeLangugeEdt: TEdit;
    CloseBtn: TButton;
    MainMenu: TMainMenu;
    PopupMenu: TPopupMenu;
    NApp: TMenuItem;
    NChange: TMenuItem;
    NClose: TMenuItem;
    NPopupChange: TMenuItem;
    NPopupClose: TMenuItem;
    UpdateLocalization: TButton;
    procedure ChangeLanguageBtnClick(Sender: TObject);
    procedure UpdateLocalizationClick(Sender: TObject);
    procedure NPopupChangeClick(Sender: TObject);
    procedure NPopupCloseClick(Sender: TObject);
    procedure NChangeClick(Sender: TObject);
    procedure NCloseClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    FLocalizator: TLocalizator;
    procedure OnLocaleChanged(ASender: TLanguageName);
  public
    procedure Init(ALocalizator: TLocalizator);
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses uLanguageForm;

procedure TMainForm.UpdateLocalizationClick(Sender: TObject);
begin
  // First you need to save your localization. All Your forms will be processed
  with FLocalizator do begin
    UpdateLocalization;
    SaveToFile('Localization.txt');
  end;
end;

procedure TMainForm.ChangeLanguageBtnClick(Sender: TObject);
begin
  LanguageForm.Show;
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := 1 = MessageDlg(TLocalization.Get('AreYouSureWantToExit'), mtError, mbOKCancel, 0);
end;

procedure TMainForm.Init(ALocalizator: TLocalizator);
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
end;

procedure TMainForm.NChangeClick(Sender: TObject);
begin
  LanguageForm.Show;
end;

procedure TMainForm.NCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.NPopupChangeClick(Sender: TObject);
begin
  LanguageForm.Show;
end;

procedure TMainForm.NPopupCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.OnLocaleChanged(ASender: TLanguageName);
begin
  FLocalizator.ChangeLanguage(ASender);
end;

end.
