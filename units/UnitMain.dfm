object frmMain: TfrmMain
  Left = 372
  Top = 235
  BorderStyle = bsSingle
  Caption = 'FLAMINGO'
  ClientHeight = 586
  ClientWidth = 1059
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mmnAll
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 16
  object pbxMaze: TPaintBox
    Left = 0
    Top = 0
    Width = 738
    Height = 586
    Align = alClient
    OnPaint = pbxMazePaint
  end
  object pnlRigth: TPanel
    Left = 738
    Top = 0
    Width = 321
    Height = 586
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object pnlStats: TPanel
      Left = 0
      Top = 0
      Width = 321
      Height = 344
      Align = alTop
      BevelOuter = bvLowered
      BiDiMode = bdLeftToRight
      ParentBiDiMode = False
      TabOrder = 0
      object lblStats: TLabel
        Left = 97
        Top = 3
        Width = 111
        Height = 25
        Align = alCustom
        Alignment = taCenter
        Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object lblSeconds: TLabel
        Left = 292
        Top = 35
        Width = 10
        Height = 20
        Caption = #1089
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edtTime: TEdit
        Left = 168
        Top = 32
        Width = 121
        Height = 28
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object edtWayOutLength: TEdit
        Left = 168
        Top = 96
        Width = 121
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
      object edtExitX: TEdit
        Left = 160
        Top = 128
        Width = 65
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
      object edtExitY: TEdit
        Left = 248
        Top = 128
        Width = 65
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
      object txtExitY: TStaticText
        Left = 232
        Top = 128
        Width = 15
        Height = 24
        Caption = 'Y'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object txtExitX: TStaticText
        Left = 144
        Top = 128
        Width = 15
        Height = 24
        Caption = 'X'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object txtExitPoint: TStaticText
        Left = 10
        Top = 127
        Width = 108
        Height = 24
        Caption = #1058#1086#1095#1082#1072' '#1074#1099#1093#1086#1076#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
      end
      object txtWayOutLength: TStaticText
        Left = 9
        Top = 95
        Width = 133
        Height = 24
        Caption = #1044#1083#1080#1085#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object txtTime: TStaticText
        Left = 8
        Top = 32
        Width = 53
        Height = 24
        Caption = #1042#1088#1077#1084#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object edtWidth: TEdit
        Left = 160
        Top = 247
        Width = 150
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
      object edtHeight: TEdit
        Left = 160
        Top = 279
        Width = 150
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
      object txtWidth: TStaticText
        Left = 8
        Top = 247
        Width = 62
        Height = 24
        Caption = #1064#1080#1088#1080#1085#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
      end
      object txtHeight: TStaticText
        Left = 8
        Top = 279
        Width = 61
        Height = 24
        Caption = #1042#1099#1089#1086#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 12
      end
      object edtGenType: TEdit
        Left = 160
        Top = 311
        Width = 150
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
      object txtGenerated: TStaticText
        Left = 8
        Top = 311
        Width = 118
        Height = 24
        Caption = #1042#1080#1076' '#1075#1077#1085#1077#1088#1072#1094#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 14
      end
      object edtAmountOfVisited: TEdit
        Left = 168
        Top = 64
        Width = 121
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
      object txtAmountOfVisited: TStaticText
        Left = 9
        Top = 65
        Width = 159
        Height = 24
        Caption = #1055#1086#1089#1077#1097#1077#1085#1085#1099#1077' '#1082#1083#1077#1090#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 16
      end
    end
    object pnlInput: TPanel
      Left = 0
      Top = 344
      Width = 321
      Height = 242
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      TabOrder = 1
      object txtSolveType: TStaticText
        Left = 8
        Top = 87
        Width = 106
        Height = 24
        Caption = #1042#1080#1076' '#1088#1077#1096#1077#1085#1080#1103
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object cbbSolve: TComboBox
        Left = 166
        Top = 87
        Width = 145
        Height = 28
        Style = csDropDownList
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 20
        ItemIndex = 0
        ParentFont = False
        TabOrder = 1
        Text = 'BFS'
        Items.Strings = (
          'BFS'
          'DFS'
          #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100)
      end
      object btnStart: TButton
        Left = 8
        Top = 134
        Width = 145
        Height = 65
        Caption = #1057#1090#1072#1088#1090
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnStartClick
      end
      object btnClearMaze: TButton
        Left = 166
        Top = 134
        Width = 145
        Height = 65
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnClearMazeClick
      end
      object btnGiveUp: TButton
        Left = 8
        Top = 207
        Width = 145
        Height = 25
        Caption = #1057#1076#1072#1090#1100#1089#1103
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clRed
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        Visible = False
        OnClick = btnGiveUpClick
      end
      object txtX: TStaticText
        Left = 144
        Top = 14
        Width = 15
        Height = 24
        Caption = 'X'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object edtX: TEdit
        Left = 159
        Top = 13
        Width = 67
        Height = 28
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        Text = '1'
        OnKeyPress = edtNumKeyPress
      end
      object edtY: TEdit
        Left = 246
        Top = 13
        Width = 67
        Height = 28
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
        Text = '1'
        OnKeyPress = edtNumKeyPress
      end
      object txtY: TStaticText
        Left = 232
        Top = 14
        Width = 15
        Height = 24
        Caption = 'Y'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
      object txtStartPoint: TStaticText
        Left = 5
        Top = 13
        Width = 135
        Height = 24
        Caption = #1057#1090#1072#1088#1090#1086#1074#1072#1103' '#1090#1086#1095#1082#1072
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 9
      end
      object btnInputStartCell: TButton
        Left = 8
        Top = 48
        Width = 305
        Height = 25
        Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 10
        OnClick = btnInputStartCellClick
      end
    end
  end
  object mmnAll: TMainMenu
    object nFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object nSaveAs: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082
        Enabled = False
        OnClick = nSaveAsClick
      end
      object nOpenSeed: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1080#1076
        OnClick = nOpenSeedClick
      end
      object nOpenText: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1090#1077#1082#1089#1090
        OnClick = nOpenTextClick
      end
    end
    object nGenerateMaze: TMenuItem
      Caption = #1051#1072#1073#1080#1088#1080#1085#1090
      OnClick = nGenerateMazeClick
    end
    object nAvgStats: TMenuItem
      Caption = #1057#1088#1077#1076#1085#1103#1103' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072
      OnClick = nAvgStatsClick
    end
    object nInfo: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      OnClick = nInfoClick
    end
  end
  object dlgOpenText: TOpenDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1081'|*.txt'
    InitialDir = 'D:\Delphi tasks etc\semester 2\KursachGUI\TextMazes'
    Left = 88
  end
  object dlgSaveTypedMaze: TSaveDialog
    DefaultExt = 'maze'
    Filter = #1051#1072#1073#1080#1088#1080#1085#1090#1086#1074#1099#1081'|*.maze'
    InitialDir = 'D:\Delphi tasks etc\semester 2\KursachGUI\TypedMazes'
    Left = 120
  end
  object dlgOpenTyped: TOpenDialog
    DefaultExt = 'maze'
    Filter = #1051#1072#1073#1080#1088#1080#1085#1090#1086#1074#1099#1081'|*.maze'
    InitialDir = 'D:\Delphi tasks etc\semester 2\KursachGUI\TypedMazes'
    Left = 152
  end
end
