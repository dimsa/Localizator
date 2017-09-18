unit uLocalizationCommon;

{
  Common classes and types for VCLlocalizator
  Author: Dmitriy Sorokin. MailTo: dimsa@inbox.ru. Twitter: @dimsa87
}


interface

uses
  System.Generics.Collections, System.SysUtils,
  uOrderedDict;

type
  TLocalePair = record
    ComponentName: utf8string;
    ComponentText: utf8string;
    constructor Create(AName, AText: utf8string);
  end;

  TLanguageName = (En, Ru);
  TControlName = utf8string;
  TTranslation = utf8string;
  TTranslationKey = utf8string;

  TLanguageDict = TDictionary<TTranslationKey, TTranslation>;
  TLocaleDict =  TDictionary<TLanguageName, TLanguageDict>;

  TItemLocalization = TDictionary<TLanguageName, TTranslation>;
  TLocalizationDict = TOrderedDict<TControlName, TItemLocalization>;


const
  CFullLanguagesNames: array[TLanguageName] of string = ('English', 'Русский');
  CShortLanguagesNames: array[TLanguageName] of string = ('En', 'Ru');
  CDefaultLanguage = Ru;

  function StringToLanguageName(const AString: string): TLanguageName;


implementation

function StringToLanguageName(const AString: string): TLanguageName;
var
  i: TLanguageName;
begin
  for i := Low(TLanguageName) to High(TLanguageName) do
  begin
    if WideLowerCase(AString) = WideLowerCase(CFullLanguagesNames[i]) then
      Exit(i);

    if WideLowerCase(AString) = WideLowerCase(CShortLanguagesNames[i]) then
      Exit(i);
  end;

  Result := CDefaultLanguage;
end;

{ TLocalePair }

constructor TLocalePair.Create(AName, AText: utf8string);
begin
  ComponentName := AName;
  ComponentText := AText;
end;

end.
