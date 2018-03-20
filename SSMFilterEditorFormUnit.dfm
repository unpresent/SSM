inherited SSMFilterEditorForm: TSSMFilterEditorForm
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1092#1080#1083#1100#1090#1088#1072
  ClientHeight = 484
  ClientWidth = 743
  Icon.Data = {
    0000010001000E0E1000000000001001000016000000280000000E0000001C00
    00000100040000000000A8000000600000006000000010000000000000000000
    000084868400FCFE0400C4C6C40084020400FFFFFF00796A01005C000100FEE0
    4C00FFFFC200FF701800FF000000C30028003C00C30094001800770000000000
    0000000000000000000000000000000000000044000000000000044400000000
    0000444000000000133104000000000133331000000000033333300000000003
    5233300000000001553310000000000013310000000000000000000000000000
    0000000000000000000000000000FFFC0000FFFC0000FFCC0000FF8C0000FF1C
    0000F03C0000E07C0000E07C0000E07C0000E07C0000F0FC0000FFFC0000FFFC
    0000FFFC0000}
  ExplicitWidth = 759
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TGroupPanel [0]
    Left = 0
    Top = 460
    Width = 743
    Height = 24
    Style = lgsCustomBottom
    TabOrder = 4
    object OkButton: TcxButton
      AlignWithMargins = True
      Left = 663
      Top = 0
      Width = 75
      Height = 24
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alRight
      Action = ActionClose
      Default = True
      LookAndFeel.Kind = lfOffice11
      TabOrder = 0
    end
  end
  object ObjectsSourcesGroupBox: TcxLayoutGroupBox [1]
    Left = 0
    Top = 0
    Align = alClient
    Caption = #1060#1080#1083#1100#1090#1088
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 5
    Height = 460
    Width = 743
    object FolderPanel: TLayoutPanel
      Left = 7
      Top = 16
      Width = 729
      Caption.Text = #1055#1072#1087#1082#1072
      Caption.Width = 140
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -11
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = []
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 0
      object FolderEdit: TcxTextEdit
        Left = 145
        Top = 1
        Align = alClient
        Properties.ReadOnly = True
        Style.Color = clBtnFace
        TabOrder = 0
        Width = 584
      end
    end
    object SQLPanel: TLayoutPanel
      Left = 7
      Top = 39
      Width = 729
      Height = 346
      Caption.Text = 'SQL'
      Caption.Width = 140
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -11
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = []
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 1
      object SQLMemo: TSynEdit
        Left = 145
        Top = 1
        Width = 584
        Height = 344
        Align = alClient
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn
        Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoScrollPastEol, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
        ReadOnly = True
        FontSmoothing = fsmNone
      end
    end
    object WherePanel: TLayoutPanel
      Left = 7
      Top = 388
      Width = 729
      Height = 65
      Align = alClient
      Caption.Text = 'WHERE'
      Caption.Width = 140
      Caption.Font.Charset = DEFAULT_CHARSET
      Caption.Font.Color = clWindowText
      Caption.Font.Height = -11
      Caption.Font.Name = 'Tahoma'
      Caption.Font.Style = []
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      TabOrder = 2
      object WhereMemo: TSynEdit
        Left = 145
        Top = 1
        Width = 584
        Height = 63
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TabOrder = 0
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Courier New'
        Gutter.Font.Style = []
        Highlighter = SynSQLSyn
        Options = [eoAutoIndent, eoDragDropEditing, eoEnhanceEndKey, eoGroupUndo, eoHideShowScrollbars, eoKeepCaretX, eoScrollPastEol, eoTabIndent, eoTabsToSpaces, eoTrimTrailingSpaces]
        WantTabs = True
        OnChange = WhereMemoChange
        FontSmoothing = fsmNone
      end
    end
    object SQLSplitter: TcxSplitter
      Left = 7
      Top = 385
      Width = 729
      Height = 3
      AlignSplitter = salTop
      Control = SQLPanel
    end
  end
  inherited FormBarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      0
      0)
  end
  object SynSQLSyn: TSynSQLSyn
    Left = 271
    Top = 143
  end
end
