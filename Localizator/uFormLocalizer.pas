unit uFormLocalizer;

interface

uses
  Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, System.Generics.Collections, Classes, Vcl.Forms,
  System.SysUtils, System.StrUtils, System.JSON, uComponentWrapper, uLocalizationCommon,
  uEvents;

type
  TControlFriend = class(TWinControl);

  TLocalizeAct = procedure(const AComp: ICaptionChangeable; const APrefix: string) of object;

  TFormLocalizer = class
  private
    FLocaleSubjectFound: TNotifyEvent<TLocalePair>;
    FLocalizationRequested: TParameteredDelegate<UTF8String, TSucceeded<utf8string>>;

    procedure ProcessComponentChild(const AComponent: TComponent; const ALocalizeAct: TLocalizeAct; const APrefix: string = '');

    procedure Gather(const AComp: ICaptionChangeable; const APrefix: string);
    procedure Localize(const AComp: ICaptionChangeable; const APrefix: string);
  public
    property LocaleSubjectFound: TNotifyEvent<TLocalePair> write FLocaleSubjectFound;
    property LocalizationRequested: TParameteredDelegate<utf8string, TSucceeded<utf8string>> write FLocalizationRequested;

    procedure GatherLocaleInfo(const AControl: TControl);
    procedure LocalizeControl(const AControl: TControl);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TLocalizableBehavior }

constructor TFormLocalizer.Create;
begin

end;

destructor TFormLocalizer.Destroy;
begin

  inherited;
end;

procedure TFormLocalizer.ProcessComponentChild(const AComponent: TComponent; const ALocalizeAct: TLocalizeAct; const APrefix: string);
var
  i: integer;
  vComp: ICaptionChangeable;
  vPrefix: string;
begin
  vComp := TComponentWrapper.Create(AComponent);
  if not vComp.IsActive then
    Exit;

  ALocalizeAct(vComp, APrefix);
  vPrefix := APrefix + vComp.Name + '.';

  for i := 0 to vComp.ChildCount - 1 do
    ProcessComponentChild(vComp.Children[i], ALocalizeAct, vPrefix)
end;

procedure TFormLocalizer.Gather(const AComp: ICaptionChangeable; const APrefix: string);
var
  vName, vText, vHint: utf8string;
begin
  if not Assigned(FLocaleSubjectFound) then
    exit;

  vName := '';
  vText := '';

  vName := APrefix + AComp.Name;
  vText := AComp.Caption;

  if vText <> '' then
    FLocaleSubjectFound(TLocalePair.Create(vName, vText));

  vHint := AComp.Hint;
  if vHint <> '' then
    FLocaleSubjectFound(TLocalePair.Create(vName + '.Hint', vHint));

end;

procedure TFormLocalizer.GatherLocaleInfo(const AControl: TControl);
begin
  ProcessComponentChild(AControl, Gather);
end;

procedure TFormLocalizer.Localize(const AComp: ICaptionChangeable; const APrefix: string);
var
  vName: string;
  vRes: TSucceeded<utf8string>;
begin
  if not Assigned(FLocalizationRequested) then
    Exit;

  if not AComp.IsActive then
    Exit;

  vName := APrefix + AComp.Name;

  vRes := FLocalizationRequested(vName);
  if vRes.IsSucceeded then
    AComp.Caption := vRes.Value;

  vRes := FLocalizationRequested(vName + '.Hint');
  if vRes.IsSucceeded then
    AComp.Hint := vRes.Value;
end;

procedure TFormLocalizer.LocalizeControl(const AControl: TControl);
begin
  ProcessComponentChild(AControl, Localize);
end;

end.
