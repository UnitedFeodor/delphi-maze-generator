object frmAvgStats: TfrmAvgStats
  Left = 288
  Top = 179
  BorderStyle = bsDialog
  Caption = #1057#1056#1045#1044#1053#1071#1071' '#1057#1058#1040#1058#1048#1057#1058#1048#1050#1040
  ClientHeight = 355
  ClientWidth = 884
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 209
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 0
    object lblBFS: TLabel
      Left = 194
      Top = 3
      Width = 203
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1055#1086#1080#1089#1082' '#1074' '#1096#1080#1088#1080#1085#1091' (BFS)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblDFS: TLabel
      Left = 421
      Top = 3
      Width = 204
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1055#1086#1080#1089#1082' '#1074' '#1096#1080#1088#1080#1085#1091' (DFS)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblUserSolve: TLabel
      Left = 682
      Top = 3
      Width = 134
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object txtTime: TStaticText
      Left = 8
      Top = 40
      Width = 53
      Height = 24
      Caption = #1042#1088#1077#1084#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object txtWayOutLength: TStaticText
      Left = 9
      Top = 103
      Width = 133
      Height = 24
      Caption = #1044#1083#1080#1085#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtAmountOfVisited: TStaticText
      Left = 9
      Top = 73
      Width = 159
      Height = 24
      Caption = #1055#1086#1089#1077#1097#1077#1085#1085#1099#1077' '#1082#1083#1077#1090#1082#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtTimeBFS: TEdit
      Left = 195
      Top = 40
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object edtAmountOfVisitedBFS: TEdit
      Left = 195
      Top = 72
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object edtWayOutLengthBFS: TEdit
      Left = 195
      Top = 103
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object txtSize: TStaticText
      Left = 9
      Top = 132
      Width = 60
      Height = 24
      Caption = #1056#1072#1079#1084#1077#1088
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object edtSizeBFS: TEdit
      Left = 195
      Top = 134
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
    end
    object edtTimeDFS: TEdit
      Left = 420
      Top = 40
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
    end
    object edtAmountOfVisitedDFS: TEdit
      Left = 420
      Top = 72
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
    object edtWayOutLengthDFS: TEdit
      Left = 420
      Top = 103
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
    end
    object edtSizeDFS: TEdit
      Left = 420
      Top = 134
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
    end
    object edtTimeUser: TEdit
      Left = 651
      Top = 40
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
    end
    object edtAmountOfVisitedUser: TEdit
      Left = 651
      Top = 72
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
    end
    object edtWayOutLengthUser: TEdit
      Left = 651
      Top = 103
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
    end
    object edtSizeUser: TEdit
      Left = 651
      Top = 134
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
    end
    object txtSolves: TStaticText
      Left = 9
      Top = 163
      Width = 95
      Height = 24
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
    end
    object edtSolvesBFS: TEdit
      Left = 195
      Top = 165
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
    end
    object edtSolvesDFS: TEdit
      Left = 420
      Top = 165
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 18
    end
    object edtSolvesUser: TEdit
      Left = 651
      Top = 165
      Width = 193
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 19
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 209
    Width = 884
    Height = 146
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object lblText: TLabel
      Left = 247
      Top = 11
      Width = 101
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblSidewinder: TLabel
      Left = 425
      Top = 11
      Width = 97
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = 'Sidewinder'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblAlduosBroder: TLabel
      Left = 559
      Top = 11
      Width = 155
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1054#1083#1076#1086#1089#1072'-'#1041#1088#1086#1076#1077#1088#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblEller: TLabel
      Left = 756
      Top = 12
      Width = 70
      Height = 25
      Align = alCustom
      Alignment = taCenter
      Caption = #1069#1083#1083#1077#1088#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object txtSolvesGen: TStaticText
      Left = 9
      Top = 43
      Width = 166
      Height = 24
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1077#1096#1077#1085#1080#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtNumText: TEdit
      Left = 240
      Top = 42
      Width = 129
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object edtNumSidewinder: TEdit
      Left = 412
      Top = 42
      Width = 129
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object edtNumAlduosBroder: TEdit
      Left = 570
      Top = 42
      Width = 129
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object edtNumEller: TEdit
      Left = 731
      Top = 42
      Width = 129
      Height = 28
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object btnDeleteAvgStats: TButton
      Left = 733
      Top = 77
      Width = 129
      Height = 60
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1088#1077#1076#1085#1102#1102' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      WordWrap = True
      OnClick = btnDeleteAvgStatsClick
    end
  end
end
