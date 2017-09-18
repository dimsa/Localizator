unit uLocalizedStrings;

interface

uses
  uLocalizationCommon, uEvents;

type
  TLocalization = class
  private

    FLocaleSubjectFound: TNotifyEvent<TLocalePair>;
    FLocalizationRequested: TParameteredDelegate<utf8string, TSucceeded<utf8string>>;
    FLocaleChanged: TNotifyEvent<TLanguageName>;
    constructor Create;
    destructor Destroy; override;
    procedure Prepare;
    procedure PrepareRu;
    procedure PrepareEn;
    procedure Add(const AKey, AText: utf8string);

    class var FInstance: TLocalization;
    class var FIsPrepaired: Boolean;

    class procedure SetLocaleSubjectFound(const Value: TNotifyEvent<TLocalePair>); static;
    class procedure SetLocalizationRequested(const Value: TParameteredDelegate<utf8string, TSucceeded<utf8string>>); static;
    class procedure SetLocaleChanged(const Value: TNotifyEvent<TLanguageName>); static;
    class procedure CreateInstance;
  public
    class property LocaleSubjectFound: TNotifyEvent<TLocalePair> write SetLocaleSubjectFound;
    class property LocalizationRequested: TParameteredDelegate<utf8string, TSucceeded<utf8string>> write SetLocalizationRequested;
    class property LocaleChanged: TNotifyEvent<TLanguageName> write SetLocaleChanged;
    class function Get(const AKey: utf8string): string;
    const Prefix = 'Runtime.';
end;

implementation

{ TLocalization }

procedure TLocalization.Add(const AKey, AText: utf8string);
begin
  if Assigned(FInstance.FLocaleSubjectFound) then
    FInstance.FLocaleSubjectFound(TLocalePair.Create(Prefix + AKey, AText))
end;

constructor TLocalization.Create;
begin
  FIsPrepaired := False;
end;

class procedure TLocalization.CreateInstance;
begin
  if FInstance = nil then
    FInstance := TLocalization.Create;

  if not FInstance.FIsPrepaired then
    FInstance.Prepare;
end;

destructor TLocalization.Destroy;
begin
  FInstance.Free;
  inherited;
end;

class function TLocalization.Get(const AKey: utf8string): string;
var
  vRes: TSucceeded<UTF8String>;
begin
  CreateInstance;

  with FInstance do
  begin
    if Assigned(FLocalizationRequested) then
    begin
      vRes := FLocalizationRequested(Prefix + AKey);

      if vRes.IsSucceeded then
        Exit(vRes.Value)
    end;
  end;

  Result := AKey;
end;

procedure TLocalization.Prepare;
begin
  if (not Assigned(FInstance.FLocaleChanged)) or (not Assigned(FInstance.FLocaleSubjectFound)) then
    Exit;

  PrepareEn;
  PrepareRu;

  FIsPrepaired := True;
end;

procedure TLocalization.PrepareEn;
var
  vS: string;
begin
  FLocaleChanged(En);

  Add('AreYouSureWantToExit', 'Are you sure want to quit?');
end;

procedure TLocalization.PrepareRu;
var
  vS: string;
begin
  FLocaleChanged(Ru);

  Add('AreYouSureWantToExit', 'Вы уверены, что хотите выйти?');
end;

class procedure TLocalization.SetLocaleChanged(const Value: TNotifyEvent<TLanguageName>);
begin
  CreateInstance;
  FInstance.FLocaleChanged := Value;
end;

class procedure TLocalization.SetLocaleSubjectFound(const Value: TNotifyEvent<TLocalePair>);
begin
  CreateInstance;
  FInstance.FLocaleSubjectFound := Value;
end;

class procedure TLocalization.SetLocalizationRequested(const Value: TParameteredDelegate<utf8string, TSucceeded<utf8string>>);
begin
  CreateInstance;
  FInstance.FLocalizationRequested := Value;
end;

end.
