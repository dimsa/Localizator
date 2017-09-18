object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 206
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PopupMenu = PopupMenu
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    377
    206)
  PixelsPerInch = 96
  TextHeight = 13
  object ChangeLanguageLbl: TLabel
    Left = 8
    Top = 13
    Width = 139
    Height = 13
    Caption = 'Change Language Demo App'
  end
  object ChangeLanguageBtn: TButton
    Left = 8
    Top = 32
    Width = 121
    Height = 40
    Caption = 'Change Language'
    TabOrder = 0
    OnClick = ChangeLanguageBtnClick
  end
  object ChangeLanguageMemo: TMemo
    Left = 135
    Top = 32
    Width = 234
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Try popup and main menu. They also localized '
      'by VCLLocalization')
    PopupMenu = PopupMenu
    TabOrder = 1
  end
  object ChangeLangugeEdt: TEdit
    Left = 135
    Top = 144
    Width = 234
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    PopupMenu = PopupMenu
    TabOrder = 2
    Text = 'Now you work with English Version'
  end
  object CloseBtn: TButton
    Left = 8
    Top = 125
    Width = 121
    Height = 40
    Caption = 'Close App'
    TabOrder = 3
    OnClick = CloseBtnClick
  end
  object UpdateLocalization: TButton
    Left = 8
    Top = 79
    Width = 121
    Height = 40
    Caption = 'Update Localization File'
    TabOrder = 4
    OnClick = UpdateLocalizationClick
  end
  object MainMenu: TMainMenu
    Left = 8
    Top = 171
    object NApp: TMenuItem
      Caption = 'Application'
      object NChange: TMenuItem
        Caption = 'Change Language'
        OnClick = NChangeClick
      end
      object NClose: TMenuItem
        Caption = 'Close'
        OnClick = NCloseClick
      end
    end
  end
  object PopupMenu: TPopupMenu
    Left = 40
    Top = 171
    object NPopupChange: TMenuItem
      Caption = 'Change Language'
      OnClick = NPopupChangeClick
    end
    object NPopupClose: TMenuItem
      Caption = 'Close'
      OnClick = NPopupCloseClick
    end
  end
end
