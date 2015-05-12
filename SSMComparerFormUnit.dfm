inherited SSMComparerForm: TSSMComparerForm
  Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077' SQL-'#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 623
  ClientWidth = 844
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000BBB0000E0000000BBBBB0000E00E000BBBBB00000EEE000BB
    BBB00000EEE000BBBBB0000EEEE000B000B00000000000033300000000000003
    330077000000000000007EEEEE00000000000EEEEE00000000000E000E000000
    00000E0E0E00000000000E0E0E0000000000000000000000000000000000E38E
    0000818400008080000080C0000080E0000080C000008080000080FF0000C101
    0000E3010000FF010000FF010000FF010000FF010000FF010000FFFF0000}
  OnShow = FormShow
  ExplicitWidth = 860
  ExplicitHeight = 661
  PixelsPerInch = 96
  TextHeight = 13
  object ObjectsSourcesPanel: TGroupPanel [0]
    Left = 0
    Top = 26
    Width = 844
    Height = 81
    TabOrder = 0
    object ObjectsSourcesGroupBox: TcxLayoutGroupBox
      Left = 0
      Top = 0
      Align = alClient
      Padding.Left = 5
      Padding.Right = 5
      Padding.Bottom = 5
      Caption = #1048#1089#1090#1086#1095#1085#1080#1082#1080
      AutoSize = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 0
      Height = 81
      Width = 487
      object WorkSourcePanel: TLayoutPanel
        Left = 7
        Top = 39
        Width = 473
        Caption.Text = #1056#1072#1073#1086#1095#1072#1103' '#1087#1072#1087#1082#1072'/'#1041#1044
        Caption.Width = 140
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clWindowText
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Padding.Top = 1
        Padding.Bottom = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 0
        object WorkSourceCombo: TcxDBLookupComboBox
          Left = 145
          Top = 1
          Align = alClient
          DataBinding.DataField = 'Work_Ptr'
          DataBinding.DataSource = ParamsDataSource
          Properties.KeyFieldNames = 'ObjectPtr'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = ObjectsSourcesDataSource
          TabOrder = 0
          Width = 328
        end
      end
      object ObjectsSourcePanel: TLayoutPanel
        Left = 7
        Top = 16
        Width = 473
        Caption.Text = #1069#1090#1072#1083#1086#1085
        Caption.Width = 140
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clWindowText
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Padding.Top = 1
        Padding.Bottom = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 1
        object ObjectsSourceCombo: TcxDBLookupComboBox
          Left = 145
          Top = 1
          Align = alClient
          DataBinding.DataField = 'Source_Ptr'
          DataBinding.DataSource = ParamsDataSource
          Properties.KeyFieldNames = 'ObjectPtr'
          Properties.ListColumns = <
            item
              FieldName = 'Name'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = ObjectsSourcesDataSource
          TabOrder = 0
          Width = 328
        end
      end
    end
    object OptoinsSplitter: TcxSplitter
      Left = 487
      Top = 0
      Width = 4
      Height = 81
      AlignSplitter = salRight
      Control = OptionsGroupBox
    end
    object OptionsGroupBox: TcxLayoutGroupBox
      Left = 491
      Top = 0
      Align = alRight
      Padding.Left = 5
      Padding.Right = 5
      Padding.Bottom = 5
      Caption = #1054#1087#1094#1080#1080
      AutoSize = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 2
      Height = 81
      Width = 353
      object OptionScanSubFoldersPanel: TLayoutPanel
        Left = 7
        Top = 16
        Width = 339
        Caption.Text = #1042#1083#1102#1095#1072#1103' '#1087#1086#1076#1087#1072#1087#1082#1080
        Caption.Width = 240
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clWindowText
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Padding.Top = 1
        Padding.Bottom = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 0
        object OptionScanSubFoldersCheckBox: TcxDBUserCheckBox
          Left = 245
          Top = 1
          Align = alClient
          DataBinding.DataField = 'ScanSubFolders'
          DataBinding.DataSource = ParamsDataSource
          TabOrder = 0
          ExplicitWidth = 25
          Width = 94
        end
      end
      object OptionIgnoreNonParsedScriptsPanel: TLayoutPanel
        Left = 7
        Top = 39
        Width = 339
        Caption.Text = #1048#1075#1085#1086#1088#1080#1088#1086#1074#1072#1090#1100' '#1085#1077#1086#1087#1088#1077#1076#1077#1083#1077#1085#1085#1099#1077#1099' '#1089#1082#1088#1080#1087#1090#1099
        Caption.Width = 240
        Caption.Font.Charset = DEFAULT_CHARSET
        Caption.Font.Color = clWindowText
        Caption.Font.Height = -11
        Caption.Font.Name = 'Tahoma'
        Caption.Font.Style = []
        Padding.Top = 1
        Padding.Bottom = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        TabOrder = 1
        object OptionIgnoreNonParsedScriptsCheckBox: TcxDBUserCheckBox
          Left = 245
          Top = 1
          Align = alClient
          DataBinding.DataField = 'IgnoreNonParsedScripts'
          DataBinding.DataSource = ParamsDataSource
          TabOrder = 0
          ExplicitWidth = 25
          Width = 94
        end
      end
    end
  end
  object ScriptsPanel: TGroupPanel [1]
    Left = 0
    Top = 107
    Width = 844
    Height = 333
    Style = lgsCustomClient
    TabOrder = 1
    object ScriptsGroupBox: TcxLayoutGroupBox
      Left = 0
      Top = 0
      Align = alClient
      Padding.Left = 5
      Padding.Right = 5
      Padding.Bottom = 5
      Caption = #1057#1082#1088#1080#1087#1090#1099
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 0
      Height = 333
      Width = 844
      object ScriptsTree: TcxDBTreeList
        Left = 7
        Top = 16
        Width = 830
        Height = 310
        Align = alClient
        Bands = <
          item
          end>
        DataController.DataSource = ScriptsDataSource
        DataController.ImageIndexField = 'IconIndex'
        DataController.ParentField = 'ParentRowId'
        DataController.KeyField = 'RowId'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Images = MainDataModule.MainSmallImages
        Navigator.Buttons.CustomButtons = <>
        OptionsSelection.HideFocusRect = False
        OptionsSelection.InvertSelect = False
        OptionsView.ColumnAutoWidth = True
        ParentFont = False
        PopupMenu = FromPopupMenu
        RootValue = -1
        TabOrder = 0
        OnFocusedNodeChanged = ScriptsTreeFocusedNodeChanged
        object ScriptsTreeSelectedColumn: TcxDBTreeListColumn
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.ImmediatePost = True
          Properties.NullStyle = nssUnchecked
          Caption.Text = ' '
          DataBinding.FieldName = 'Selected'
          Options.AutoWidthSizable = False
          Width = 40
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ScriptsTreeNodeNameColumn: TcxDBTreeListColumn
          Caption.Text = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'NodeName'
          Options.Editing = False
          Width = 320
          Position.ColIndex = 1
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ScriptsTreeActionColumn: TcxDBTreeListColumn
          Caption.Text = #1044#1077#1081#1089#1090#1074#1080#1077
          DataBinding.FieldName = 'Action'
          Options.AutoWidthSizable = False
          Options.Editing = False
          Width = 120
          Position.ColIndex = 2
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
        object ScriptsTreeNodeTypeColumn: TcxDBTreeListColumn
          Visible = False
          DataBinding.FieldName = 'NodeType'
          Options.Hidden = True
          Position.ColIndex = 3
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
    end
  end
  object PanelButtons: TGroupPanel [2]
    Left = 0
    Top = 599
    Width = 844
    Height = 24
    Style = lgsCustomBottom
    TabOrder = 2
    object OkButton: TcxButton
      AlignWithMargins = True
      Left = 764
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
    object RunButton: TcxButton
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 75
      Height = 24
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 5
      Margins.Bottom = 0
      Align = alLeft
      Action = ActionRun
      Default = True
      LookAndFeel.Kind = lfOffice11
      TabOrder = 1
    end
  end
  object ErrorsPanel: TGroupPanel [3]
    Left = 0
    Top = 443
    Width = 844
    Height = 156
    Style = lgsCustomBottom
    TabOrder = 3
    Visible = False
    object ErrorsGroupBox: TcxLayoutGroupBox
      Left = 0
      Top = 0
      Align = alClient
      Padding.Left = 5
      Padding.Right = 5
      Padding.Bottom = 5
      Caption = #1054#1096#1080#1073#1082#1080
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 0
      Height = 156
      Width = 844
      object ErrorsGrid: TcxGrid
        Left = 7
        Top = 16
        Width = 830
        Height = 133
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object ErrorsGridDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          OnFocusedRecordChanged = ErrorsGridDBTableViewFocusedRecordChanged
          DataController.DataSource = ErrorsDataSource
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnGrouping = False
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          OptionsView.GroupRowShowColumnHeaders = False
          object ErrorsColumnSelected: TcxGridDBColumn
            DataBinding.FieldName = 'Selected'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Options.AutoWidthSizable = False
            Width = 20
            IsCaptionAssigned = True
          end
          object ErrorsColumnScript: TcxGridDBColumn
            Caption = #1057#1082#1088#1080#1087#1090
            DataBinding.FieldName = 'Script'
            Options.Editing = False
            Options.AutoWidthSizable = False
            Width = 540
          end
          object ErrorsColumnMessage: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'Message'
            Options.Editing = False
            Width = 269
          end
        end
        object ErrorsGridLevel: TcxGridLevel
          GridView = ErrorsGridDBTableView
        end
      end
    end
  end
  object ErrosSplitter: TcxSplitter [4]
    Left = 0
    Top = 440
    Width = 844
    Height = 3
    AlignSplitter = salBottom
    Control = ErrorsPanel
    Visible = False
  end
  inherited FormActionList: TActionList
    Left = 768
    Top = 160
    object ActionRun: TAction
      Caption = #1055#1091#1089#1082
      ImageIndex = 95
      ShortCut = 116
      OnExecute = ActionRunExecute
    end
    object ActionSelectAll: TAction
      Category = 'Scripts'
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 19
      OnExecute = ActionSelectAllExecute
    end
    object ActionUnSelectAll: TAction
      Category = 'Scripts'
      Caption = #1057#1085#1103#1090#1100' '#1074#1099#1073#1086#1088
      ImageIndex = 20
      OnExecute = ActionUnSelectAllExecute
    end
    object ActionCompare1: TAction
      Category = 'Scripts'
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100' (1)'
      ImageIndex = 93
      ShortCut = 119
      OnExecute = ActionCompare1Execute
    end
    object ActionCompare2: TAction
      Category = 'Scripts'
      Caption = #1057#1088#1072#1074#1085#1080#1090#1100' (2)'
      ShortCut = 16503
      OnExecute = ActionCompare2Execute
    end
    object ActionDeleteFromError: TAction
      Category = 'Errors'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1072#1081#1083' c '#1086#1096#1080#1073#1082#1086#1081
      ImageIndex = 29
      OnExecute = ActionDeleteFromErrorExecute
    end
    object ActionDeleteAllFromErrors: TAction
      Category = 'Errors'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1086#1096#1080#1073#1082#1080
      ImageIndex = 30
      OnExecute = ActionDeleteAllFromErrorsExecute
    end
    object ActionErrorsSelectAll: TAction
      Category = 'Errors'
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077' '#1086#1096#1080#1073#1082#1080
      OnExecute = ActionErrorsSelectAllExecute
    end
    object ActionErrorsUnSelectAll: TAction
      Category = 'Errors'
      Caption = #1057#1085#1103#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077' '#1086#1096#1080#1073#1086#1082
      OnExecute = ActionErrorsUnSelectAllExecute
    end
    object ActionScriptsUpdate: TAction
      Category = 'Scripts'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      ImageIndex = 5
      OnExecute = ActionScriptsUpdateExecute
    end
  end
  inherited FromPopupMenu: TdxBarPopupMenu
    ItemLinks = <
      item
        ItemName = 'FormItemRun'
      end
      item
        BeginGroup = True
        ItemName = 'FormItemScriptsSelectAll'
      end
      item
        ItemName = 'FormItemScriptsUnSelectAll'
      end
      item
        BeginGroup = True
        ItemName = 'FormItemCompare1'
      end
      item
        ItemName = 'FormItemComapre2'
      end
      item
        BeginGroup = True
        ItemName = 'FormItemScriptsUpdate'
      end
      item
        BeginGroup = True
        ItemName = 'FormItemErrorsSelectAll'
      end
      item
        ItemName = 'FormItemErrorUnSelectAll'
      end
      item
        ItemName = 'FormItemDeleteFromError'
      end
      item
        ItemName = 'FormItemDeleteAllFromErrors'
      end
      item
        BeginGroup = True
        ItemName = 'FormItemClose'
      end>
    Left = 560
    Top = 171
  end
  inherited FormBarManager: TdxBarManager
    Left = 688
    Top = 160
    DockControlHeights = (
      0
      0
      26
      0)
    object FormBarManagerBar1: TdxBar [0]
      Caption = #1055#1072#1085#1077#1083#1100' '#1080#1085#1089#1090#1088#1091#1084#1077#1085#1090#1086#1074' '#1092#1086#1088#1084#1099
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 2081
      FloatTop = 192
      FloatClientWidth = 51
      FloatClientHeight = 22
      Images = MainDataModule.MainSmallImages
      ItemLinks = <
        item
          ItemName = 'FormItemRun'
        end
        item
          BeginGroup = True
          ItemName = 'FormItemScriptsSelectAll'
        end
        item
          ItemName = 'FormItemScriptsUnSelectAll'
        end
        item
          BeginGroup = True
          ItemName = 'FormItemCompare1'
        end
        item
          BeginGroup = True
          ItemName = 'FormItemScriptsUpdate'
        end
        item
          BeginGroup = True
          ItemName = 'FormItemErrorsSelectAll'
        end
        item
          ItemName = 'FormItemErrorUnSelectAll'
        end
        item
          ItemName = 'FormItemDeleteFromError'
        end
        item
          ItemName = 'FormItemDeleteAllFromErrors'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object FormItemRun: TdxBarButton
      Action = ActionRun
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object FormItemScriptsSelectAll: TdxBarButton
      Action = ActionSelectAll
      Category = 0
    end
    object FormItemScriptsUnSelectAll: TdxBarButton
      Action = ActionUnSelectAll
      Category = 0
    end
    object FormItemCompare1: TdxBarButton
      Action = ActionCompare1
      Category = 0
    end
    object FormItemComapre2: TdxBarButton
      Action = ActionCompare2
      Category = 0
    end
    object FormItemErrorsSelectAll: TdxBarButton
      Action = ActionErrorsSelectAll
      Category = 0
    end
    object FormItemErrorUnSelectAll: TdxBarButton
      Action = ActionErrorsUnSelectAll
      Category = 0
    end
    object FormItemDeleteFromError: TdxBarButton
      Action = ActionDeleteFromError
      Category = 0
    end
    object FormItemDeleteAllFromErrors: TdxBarButton
      Action = ActionDeleteAllFromErrors
      Category = 0
    end
    object FormItemScriptsUpdate: TdxBarButton
      Action = ActionScriptsUpdate
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  object ErrorsDataSource: TDataSource
    DataSet = ErrorsDataSet
    Left = 232
    Top = 344
  end
  object ScriptsDataSet: TVirtualTable
    Options = [voStored, voSkipUnSupportedFieldTypes]
    FieldDefs = <
      item
        Name = 'RowId'
        DataType = ftInteger
      end
      item
        Name = 'ParentRowId'
        DataType = ftInteger
      end
      item
        Name = 'NodeName'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'NodeType'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'Script'
        DataType = ftString
        Size = 1024
      end
      item
        Name = 'ScriptFullName'
        DataType = ftString
        Size = 1024
      end
      item
        Name = 'ScriptInSource'
        DataType = ftString
        Size = 1024
      end
      item
        Name = 'ObjectName'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'Action'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'Selected'
        DataType = ftBoolean
      end
      item
        Name = 'IconIndex'
        DataType = ftInteger
      end
      item
        Name = 'SourceNode_Ptr'
        DataType = ftInteger
      end
      item
        Name = 'WorkSourceNode_Ptr'
        DataType = ftInteger
      end>
    Left = 128
    Top = 216
    Data = {
      03000D000500526F77496403000000000000000B00506172656E74526F774964
      030000000000000008004E6F64654E616D65010000020000000008004E6F6465
      547970650100010000000000060053637269707401000004000000000E005363
      7269707446756C6C4E616D6501000004000000000E00536372697074496E536F
      7572636501000004000000000A004F626A6563744E616D650100000200000000
      0600416374696F6E0100200000000000080053656C6563746564050000000000
      0000090049636F6E496E64657803000000000000000E00536F757263654E6F64
      655F50747203000000000000001200576F726B536F757263654E6F64655F5074
      720300000000000000000000000000}
  end
  object ErrorsDataSet: TVirtualTable
    Options = [voStored, voSkipUnSupportedFieldTypes]
    Active = True
    FieldDefs = <
      item
        Name = 'RowId'
        DataType = ftInteger
      end
      item
        Name = 'Selected'
        DataType = ftBoolean
      end
      item
        Name = 'Script'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'ErrorCode'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Message'
        DataType = ftString
        Size = 32
      end
      item
        Name = 'ObjectName'
        DataType = ftString
        Size = 256
      end
      item
        Name = 'Node_Ptr'
        DataType = ftInteger
      end>
    Left = 128
    Top = 328
    Data = {
      030007000500526F7749640300000000000000080053656C6563746564050000
      00000000000600536372697074010000020000000009004572726F72436F6465
      010014000000000007004D65737361676501002000000000000A004F626A6563
      744E616D65010000010000000008004E6F64655F507472030000000000000000
      0000000000}
  end
  object ScriptsDataSource: TDataSource
    DataSet = ScriptsDataSet
    Left = 224
    Top = 232
  end
  object ParamsDataSet: TVirtualTable
    Options = [voStored, voSkipUnSupportedFieldTypes]
    Active = True
    FieldDefs = <
      item
        Name = 'Source_Ptr'
        DataType = ftInteger
      end
      item
        Name = 'Work_Ptr'
        DataType = ftInteger
      end
      item
        Name = 'ScanSubFolders'
        DataType = ftBoolean
      end
      item
        Name = 'IgnoreNonParsedScripts'
        DataType = ftBoolean
      end>
    Left = 312
    Top = 24
    Data = {
      030004000A00536F757263655F50747203000000000000000800576F726B5F50
      747203000000000000000E005363616E537562466F6C64657273050000000000
      0000160049676E6F72654E6F6E50617273656453637269707473050000000000
      0000000000000000}
  end
  object ObjectsSourcesDataSet: TVirtualTable
    Options = [voStored, voSkipUnSupportedFieldTypes]
    Active = True
    IndexFieldNames = 'ObjectPtr'
    FieldDefs = <
      item
        Name = 'ObjectPtr'
        DataType = ftInteger
      end
      item
        Name = 'Name'
        DataType = ftString
        Size = 512
      end>
    Left = 448
    Top = 24
    Data = {
      0300020009004F626A656374507472030000000000000004004E616D65010000
      0200000000000000000000}
  end
  object ParamsDataSource: TDataSource
    DataSet = ParamsDataSet
    Left = 312
    Top = 72
  end
  object ObjectsSourcesDataSource: TDataSource
    DataSet = ObjectsSourcesDataSet
    Left = 480
    Top = 72
  end
  object ScriptsSelectController: TFieldDataLinkController
    DataSource = ScriptsDataSource
    FieldNames = 'Selected'
    OnFieldChanged = ScriptsSelectControllerFieldChanged
    Left = 64
    Top = 145
  end
end
