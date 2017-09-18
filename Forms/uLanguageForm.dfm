object LanguageForm: TLanguageForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1103#1079#1099#1082' (Choose Language)'
  ClientHeight = 202
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    331
    202)
  PixelsPerInch = 96
  TextHeight = 13
  object LanguageLbl: TLabel
    Left = 8
    Top = 8
    Width = 261
    Height = 19
    Caption = #1071#1079#1099#1082' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072' (Select language):'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object InfoLbl: TLabel
    Left = 9
    Top = 112
    Width = 293
    Height = 76
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 
      #1041#1091#1076#1100#1090#1077' '#1074#1085#1080#1084#1072#1090#1077#1083#1100#1085#1099', '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1103#1079#1099#1082#1072' '#1080#1085#1090#1077#1088#1092#1077#1081#1089#1072' '#1084#1086#1078#1077#1090' '#1087#1086#1074#1083#1077#1095#1100' '#1079#1072' ' +
      #1089#1086#1073#1086#1081' '#1087#1086#1090#1077#1088#1102' '#1074#1074#1077#1076#1077#1085#1085#1099#1093', '#1085#1086' '#1085#1077' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1093' '#1076#1072#1085#1085#1099#1093' '#1074' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1080
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object LangCmb: TComboBox
    Left = 8
    Top = 40
    Width = 313
    Height = 27
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 239
    Top = 73
    Width = 82
    Height = 30
    Anchors = [akTop, akRight]
    Caption = #1054#1090#1084#1077#1085#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object ApplyBtn: TButton
    Left = 112
    Top = 73
    Width = 118
    Height = 30
    Anchors = [akTop, akRight]
    Caption = #1054#1082
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = ApplyBtnClick
  end
end
