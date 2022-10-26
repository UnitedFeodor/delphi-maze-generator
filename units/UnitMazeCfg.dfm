object frmMazeCfg: TfrmMazeCfg
  Left = 370
  Top = 189
  BorderStyle = bsDialog
  Caption = #1043#1045#1053#1045#1056#1040#1062#1048#1071
  ClientHeight = 315
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object pnlSize: TPanel
    Left = 0
    Top = 90
    Width = 346
    Height = 79
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    object txtWidth: TStaticText
      Left = 24
      Top = 11
      Width = 62
      Height = 24
      Caption = #1064#1080#1088#1080#1085#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtWidth: TEdit
      Left = 198
      Top = 11
      Width = 121
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '3'
      OnKeyPress = edtNumKeyPress
    end
    object txtHeight: TStaticText
      Left = 24
      Top = 42
      Width = 61
      Height = 24
      Caption = #1042#1099#1089#1086#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtHeight: TEdit
      Left = 198
      Top = 42
      Width = 121
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '3'
      OnKeyPress = edtNumKeyPress
    end
  end
  object pnlSeedNumber: TPanel
    Left = 0
    Top = 49
    Width = 346
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object txtSeedNumber: TStaticText
      Left = 24
      Top = 7
      Width = 35
      Height = 24
      Caption = #1057#1080#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtSeedNumber: TEdit
      Left = 198
      Top = 7
      Width = 121
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '0'
      OnKeyPress = edtNumKeyPress
    end
  end
  object pnlGenerated: TPanel
    Left = 0
    Top = 0
    Width = 346
    Height = 49
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvNone
    TabOrder = 2
    object cbbGenerated: TComboBox
      Left = 158
      Top = 13
      Width = 161
      Height = 28
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 20
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'Sidewinder'
      Items.Strings = (
        'Sidewinder'
        #1054#1083#1076#1086#1089#1072'-'#1041#1088#1086#1076#1077#1088#1072
        #1069#1083#1083#1077#1088#1072)
    end
    object txtGenerated: TStaticText
      Left = 24
      Top = 16
      Width = 118
      Height = 24
      Caption = #1042#1080#1076' '#1075#1077#1085#1077#1088#1072#1094#1080#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object pnlExits: TPanel
    Left = 0
    Top = 169
    Width = 346
    Height = 87
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 3
    object txtExits: TStaticText
      Left = 24
      Top = 48
      Width = 164
      Height = 24
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074#1099#1093#1086#1076#1086#1074
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtAmountOfExits: TEdit
      Left = 198
      Top = 45
      Width = 121
      Height = 28
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '1'
      OnKeyPress = edtNumKeyPress
    end
    object btnDeleteOuterWall: TButton
      Left = 24
      Top = 8
      Width = 297
      Height = 25
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1085#1077#1096#1085#1102#1102' '#1089#1090#1077#1085#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnDeleteOuterWallClick
    end
  end
  object pnlOkCancel: TPanel
    Left = 0
    Top = 256
    Width = 346
    Height = 59
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 4
    object btnOK: TButton
      Left = 72
      Top = 16
      Width = 81
      Height = 33
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 200
      Top = 16
      Width = 81
      Height = 33
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
