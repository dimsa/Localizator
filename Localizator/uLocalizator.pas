unit uLocalizator;

{
  Main class of Localizator. Processes JSON to load from. Also saves JSON with the data from Forms
  Author: Dmitriy Sorokin. MailTo: dimsa@inbox.ru. Twitter: @dimsa87
}

interface

uses
  System.Generics.Collections, Controls, System.JSON, Classes, System.Types,
  uFormLocalizer, System.SysUtils, uLocalizationCommon, uEvents, uLocalizedStrings,
  System.StrUtils;

type
  TLocalizator = class
  private
    FForms: TList<TControl>;
    FFormLocalizer: TFormLocalizer;
    FData: TLocalizationDict;
    FCurrentLang: TLanguageName;
    procedure OnLocaleSubjectFound(ALocalizationPair: TLocalePair);
    procedure OnLocaleChanged(ALanguage: TLanguageName);
    function OnLocalizationRequest(AControlName: utf8string): TSucceeded<utf8string>;
    procedure InitRuntimeLocales;
  public
    function GetLocaleList: TStringList;
    procedure ChangeLanguage(ALanguage: TLanguageName);
    procedure SaveToFile(const AFileName: string);
    procedure LoadFromFile(const AFileName: string);
    procedure LoadFromRes(const AResourceName: string);
    procedure LoadFromStringList(const AList: TStringList);
    procedure AddForm(const AForm: TControl);
    procedure UpdateLocalization;
    constructor Create;
    destructor Destroy; override;
    const CDefaultLang = En;
  end;

implementation

{ TLocalizator }

procedure TLocalizator.AddForm(const AForm: TControl);
var
  vName: string;
begin
  vName := AForm.Name;
  FForms.Add(AForm);
end;

procedure TLocalizator.ChangeLanguage(ALanguage: TLanguageName);
var
  i: Integer;
begin
  FCurrentLang := ALanguage;
  for i := 0 to FForms.Count - 1 do
    FFormLocalizer.LocalizeControl(FForms[i]);
end;

constructor TLocalizator.Create;
begin
  FForms := TList<TControl>.Create;
  FData := TLocalizationDict.Create;
  FFormLocalizer := TFormLocalizer.Create;
  FCurrentLang := CDefaultLang;

  FFormLocalizer.LocaleSubjectFound := OnLocaleSubjectFound;
  FFormLocalizer.LocalizationRequested := OnLocalizationRequest;

  TLocalization.LocaleSubjectFound := OnLocaleSubjectFound;
  TLocalization.LocalizationRequested := OnLocalizationRequest;
  TLocalization.LocaleChanged := OnLocaleChanged;
end;

destructor TLocalizator.Destroy;
begin
  FForms.Free;
  FData.Free;
  FFormLocalizer.Free;
  inherited;
end;

function TLocalizator.GetLocaleList: TStringList;
var
  vLangName: TLanguageName;
begin
  Result := TStringList.Create;

  for vLangName := Low(TLanguageName) to High(TLanguageName) do
    Result.Add(CFullLanguagesNames[vLangName]);
end;

procedure TLocalizator.InitRuntimeLocales;
begin
  TLocalization.Get('');
end;

procedure TLocalizator.LoadFromRes(const AResourceName: string);
var
  vRes: TResourceStream;
  vFile: TStringList;
begin
  vRes := TResourceStream.Create(HInstance,AResourceName, RT_RCDATA);
  vFile := TStringList.Create;
  vFile.LoadFromStream(vRes);
  LoadFromStringList(vFile);
  vFile.Free;

  InitRuntimeLocales;
end;

procedure TLocalizator.LoadFromStringList(const AList: TStringList);
var
  vJSON: TJSONObject;
  vLocaleItem: TJSONObject;
  vText: UTF8String;
  i, j: Integer;
begin
  vJSON := TJSONObject.ParseJSONValue(AList.Text) as TJsonObject;

  for i := 0 to vJSON.Count - 1 do
  begin
    vLocaleItem := TJSONObject(vJSON.Pairs[i].JsonValue);

    for j := 0 to vLocaleItem.Count - 1 do
    begin
      FCurrentLang := StringToLanguageName(vLocaleItem.Pairs[j].JsonString.Value);
      vText := vLocaleItem.Pairs[j].JsonValue.Value;
      vText := ReplaceStr(vText, '<br />', #$D#$A);
      vText := ReplaceStr(vText, '\"', '"');

      OnLocaleSubjectFound(TLocalePair.Create(vJSON.Pairs[i].JsonString.Value, vText));
    end;
  end;

  vJSON.Free;
end;

procedure TLocalizator.LoadFromFile(const AFileName: string);
var
  vFile: TStringList;
begin
  vFile := TStringList.Create;
  vFile.LoadFromFile(AFileName);
  LoadFromStringList(vFile);
  vFile.Free;
end;

procedure TLocalizator.OnLocaleChanged(ALanguage: TLanguageName);
begin
  FCurrentLang := ALanguage;
end;

procedure TLocalizator.OnLocaleSubjectFound(ALocalizationPair: TLocalePair);
var
  vText: string;
begin
  if not FData.ContainsKey(ALocalizationPair.ComponentName) then
    FData.Add(ALocalizationPair.ComponentName, TItemLocalization.Create);

  vText := ALocalizationPair.ComponentText;

  if not FData[ALocalizationPair.ComponentName].ContainsKey(FCurrentLang) then
    FData[ALocalizationPair.ComponentName].Add(FCurrentLang, vText)
  else
    FData[ALocalizationPair.ComponentName][FCurrentLang]  := vText;
end;

function TLocalizator.OnLocalizationRequest(AControlName: utf8string): TSucceeded<utf8string>;
begin
  if FData.ContainsKey(AControlName) then
    if FData[AControlName].ContainsKey(FCurrentLang) then
      Exit(TSucceeded<utf8string>.Create(FData[AControlName][FCurrentLang], True))
    else
      if FData[AControlName].ContainsKey(CDefaultLang) then
        Exit(TSucceeded<utf8string>.Create(FData[AControlName][CDefaultLang], True));


  Result := TSucceeded<utf8string>.Create('', False);
end;

procedure TLocalizator.SaveToFile(const AFileName: string);
var
  vLocalJson: TStringList;
  vLangName: TLanguageName;
  vControlName: string;
  vN: integer;
  vS: string;
  iControl: Integer;
  vText: string;
begin
  vLocalJson := TStringList.Create;
  vLocalJson.Add('{');

  for iControl := 0 to FData.Count - 1 do
  begin
    vControlName := FData.KeyByIndex[IControl];

    if vControlName.Contains(TLocalization.Prefix) then
      Continue;
//    inc(vControlN);
    vLocalJson.Add('  "' + vControlName + '": {');
    vN := 0;
    for vLangName in FData[vControlName].Keys do
    begin
      Inc(vN);
      vText := FData[vControlName][vLangName];
      vText := ReplaceStr(vText, #$D#$A, '<br />');
      vText := ReplaceStr(vText, '"', '\"');

      vS := '    "' + CShortLanguagesNames[vLangName]  + '":"' + vText + '"';
      if vN <> FData[vControlName].Count then
        vS := vS +', ';
      vLocalJson.Add(vS);
    end;
    vS := '  }';
//    if iControl <> FData.Count - 1 then
    vS := vS + ', ';
    vLocalJson.Add(vS);        
  end;
  vLocalJson.Add('}');

  vS := vLocalJson.Text;
  Delete(vS, LastDelimiter(',', vS), 1);
  vLocalJson.Text := vS;

  vLocalJson.SaveToFile(AFileName, TEncoding.UTF8);
end;

procedure TLocalizator.UpdateLocalization;
var
  i: Integer;
begin
  for i := 0 to FForms.Count - 1 do
    FFormLocalizer.GatherLocaleInfo(FForms[i]);
end;

end.
