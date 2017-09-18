unit uComponentWrapper;

{
  Wrapper for components to incapsulate Captions, Text and etc from controls.
  Author: Dmitriy Sorokin. MailTo: dimsa@inbox.ru. Twitter: @dimsa87
}

interface

uses
  Vcl.Controls, Vcl.Menus, system.Classes;

type

TControlFriend = class(TControl);

  ICaptionChangeable = interface
    function GetCaption: UTF8String;
    function GetName: UTF8String;
    function GetHint: UTF8String;
    procedure SetHint(const Value: UTF8String);
    procedure SetCaption(const Value: UTF8String);
    function GetIsActive: Boolean;
    function GetChild(AIndex: Integer): TComponent;
    function GetChildCount: Integer;
    function GetParent: TComponent;
    function GetParentName: string;
    function GetInnerComponent: TComponent;

    property Parent: TComponent read GetParent;
    property Hint: utf8string read GetHint write SetHint;
    property ParentName: string read GetParentName;
    property IsActive: Boolean read GetIsActive;
    property Caption:  UTF8String read GetCaption write SetCaption;
    property InnerComponent: TComponent read GetInnerComponent;
    property Name:  UTF8String read GetName;
    property ChildCount: Integer read GetChildCount;
    property Children[AIndex: Integer]: TComponent read GetChild; default;
  end;

  TComponentWrapper = class(TInterfacedObject, ICaptionChangeable)
  private
    FComponent: TComponent;
    FIsActive: Boolean;
    function GetCaption:  UTF8String;
    function GetName:  UTF8String;
    procedure SetCaption(const Value: UTF8String);
    function GetIsActive: Boolean;
    function GetChild(AIndex: Integer): TComponent;
    function GetChildCount: Integer;
    function GetParent: TComponent;
    function GetInnerComponent: TComponent;
    function GetHint: UTF8String;
    procedure SetHint(const Value: UTF8String);
  public
    property IsActive: Boolean read GetIsActive;
    property Caption:  UTF8String read GetCaption write SetCaption;

    property Name:  UTF8String read GetName;
    function GetParentName: string;
    property Parent: TComponent read GetParent;
    property ChildCount: Integer read GetChildCount;
    property Children[AIndex: Integer]: TComponent read GetChild; default;
    constructor Create(const AComponent: TComponent);
    destructor Destroy; override;
  end;

implementation

{ TComponentWrapper }

constructor TComponentWrapper.Create(const AComponent: TComponent);
begin
  FComponent := AComponent;

  FIsActive := (FComponent is TControl) or (FComponent is TMenu) or (FComponent is TMenuItem);
end;

destructor TComponentWrapper.Destroy;
begin
  FComponent := nil;
  inherited;
end;

function TComponentWrapper.GetCaption: UTF8String;
begin
  if not IsActive then
    Exit('');

  if FComponent is TControl then
  try
    Result := TControlFriend(FComponent).Caption;
  except
    Exit('');
  end;

  if FComponent is TMenu then
    Exit('');

  if FComponent is TMenuItem then
    Exit(TMenuItem(FComponent).Caption);
end;

function TComponentWrapper.GetChild(AIndex: Integer): TComponent;
begin
  if (not IsActive) then
    Exit(Nil);

  if FComponent is TControl then
    if FComponent is TWinControl then
      Exit(TWinControl(FComponent).Components[AIndex]);

  if FComponent is TMenu then
    Exit(TMenu(FComponent).Items[AIndex]);

  if FComponent is TMenuItem then
    Exit(TMenuItem(FComponent).Items[AIndex]);

  Result := nil;
end;

function TComponentWrapper.GetChildCount: Integer;
begin
  if (not IsActive) then
    Exit(0);

  if FComponent is TControl then
    if FComponent is TWinControl then
      Exit(TWinControl(FComponent).ComponentCount);

  if FComponent is TMenu then
    Exit(0);

  if FComponent is TMenuItem then
    Exit(0);

  Result := 0;
end;

function TComponentWrapper.GetHint: UTF8String;
begin
 if not IsActive then
    Exit('');

  if FComponent is TControl then
    try
      Result := TControl(FComponent).Hint
    except
      Exit('');
    end;

  if FComponent is TMenuItem then
    Exit(TMenuItem(FComponent).Hint);
end;

function TComponentWrapper.GetInnerComponent: TComponent;
begin
  Result := FComponent;
end;

function TComponentWrapper.GetIsActive: Boolean;
begin
  Result := FIsActive;
end;

function TComponentWrapper.GetName: UTF8String;
begin
  if not IsActive then
    Exit('');

  if FComponent is TControl then
    try
      Result := TControl(FComponent).Name;
    except
      Exit('');
    end;

  if FComponent is TMenu then
    Exit(TMenu(FComponent).Name);

  if FComponent is TMenuItem then
    Exit(TMenuItem(FComponent).Name);
end;

function TComponentWrapper.GetParent: TComponent;
begin
  Result := FComponent.Owner;
end;

function TComponentWrapper.GetParentName: string;
begin
  Result := FComponent.Owner.Name;
end;

procedure TComponentWrapper.SetCaption(const Value: UTF8String);
begin
  if not IsActive then
    Exit;

  if FComponent is TControl then
    try
      TControlFriend(FComponent).Caption := Value;
    except
      Exit;
    end;

  if FComponent is TMenuItem then
    TMenuItem(FComponent).Caption := Value;
end;

procedure TComponentWrapper.SetHint(const Value: UTF8String);
begin
if not IsActive then
    Exit;

  if FComponent is TControl then
    try
      TControlFriend(FComponent).Hint := Value;
    except
      Exit;
    end;

  if FComponent is TMenuItem then
    TMenuItem(FComponent).Hint := Value;
end;

end.
