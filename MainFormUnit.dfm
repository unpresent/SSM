object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'SQL Script Maker'
  ClientHeight = 632
  ClientWidth = 949
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainStatusBar: TdxMDStatusBar
    Left = 0
    Top = 612
    Width = 949
    Height = 20
    Panels = <>
  end
  object MainDockTop: TdxBarDockControl
    Left = 0
    Top = 126
    Width = 949
    Align = dalTop
    BarManager = MainBarManager
  end
  object MainDockLeft: TdxBarDockControl
    Left = 0
    Top = 129
    Height = 483
    Align = dalLeft
    BarManager = MainBarManager
  end
  object MainDockRight: TdxBarDockControl
    Left = 943
    Top = 129
    Height = 483
    Align = dalRight
    BarManager = MainBarManager
  end
  object MainRibbon: TdxRibbon
    Left = 0
    Top = 0
    Width = 949
    Height = 126
    BarManager = MainBarManager
    ColorSchemeName = 'Blue'
    Contexts = <>
    TabOrder = 0
    TabStop = False
    object MainRibbonHome: TdxRibbonTab
      Active = True
      Caption = #1054#1089#1085#1086#1074#1085#1086#1077
      Groups = <
        item
          Caption = #1060#1072#1081#1083
          ToolbarName = 'MainRToolbarHomeFile'
        end
        item
          Caption = #1056#1077#1076#1072#1082#1090#1086#1088
          ToolbarName = 'MainRToolbarHomeEdit'
        end>
      Index = 0
    end
    object MainRibbonView: TdxRibbonTab
      Caption = #1042#1080#1076
      Groups = <
        item
          Caption = #1057#1093#1077#1084#1072
          ToolbarName = 'MainRToolbarViewApplication'
        end>
      Index = 1
    end
    object MainRibbonProject: TdxRibbonTab
      Caption = #1055#1088#1086#1077#1082#1090
      Groups = <
        item
          Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1088#1086#1077#1082#1090#1072
          ToolbarName = 'MainRToolbarProjectEdit'
        end
        item
          ToolbarName = 'MainRToolbarProjectActions'
        end>
      Index = 2
    end
    object MainRibbonTools: TdxRibbonTab
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
      Groups = <
        item
          Caption = #1054#1087#1094#1080#1080
          ToolbarName = 'MainRToolbarToolsOptions'
        end>
      Index = 3
    end
  end
  object DockSiteRight: TdxDockSite
    Left = 946
    Top = 129
    Width = 3
    Height = 483
    Align = alRight
    AutoSize = True
    DockingType = 5
    OriginalWidth = 3
    OriginalHeight = 483
  end
  object DockSiteLeft: TdxDockSite
    Left = 3
    Top = 129
    Width = 185
    Height = 483
    Align = alLeft
    AutoSize = True
    DockingType = 5
    OriginalWidth = 3
    OriginalHeight = 483
    object dxLayoutDockSite2: TdxLayoutDockSite
      Left = 0
      Top = 0
      Width = 185
      Height = 483
      DockingType = 0
      OriginalWidth = 185
      OriginalHeight = 200
    end
    object SolutionExplorerDockPanel: TdxDockPanel
      Left = 0
      Top = 0
      Width = 185
      Height = 483
      AllowFloating = True
      AutoHide = False
      Caption = #1044#1077#1088#1077#1074#1086' '#1088#1077#1096#1077#1085#1080#1103
      CustomCaptionButtons.Buttons = <>
      TabsProperties.CustomButtons.Buttons = <>
      DockingType = 0
      OriginalWidth = 185
      OriginalHeight = 140
      object SolutionExplorer: TcxTreeList
        Left = 0
        Top = 0
        Width = 181
        Height = 459
        Align = alClient
        Bands = <
          item
          end>
        Images = MainDataModule.MainSmallImages
        Navigator.Buttons.CustomButtons = <>
        OptionsCustomizing.BandCustomizing = False
        OptionsCustomizing.BandMoving = False
        OptionsCustomizing.BandVertSizing = False
        OptionsCustomizing.ColumnCustomizing = False
        OptionsCustomizing.ColumnMoving = False
        OptionsData.CancelOnExit = False
        OptionsData.Editing = False
        OptionsData.Deleting = False
        OptionsSelection.HideFocusRect = False
        OptionsView.Headers = False
        OptionsView.ShowRoot = False
        PopupMenu = SolutionExplorerPopupMenu
        TabOrder = 0
        OnCustomDrawDataCell = SolutionExplorerCustomDrawDataCell
        OnEdited = SolutionExplorerEdited
        OnEditValueChanged = SolutionExplorerEditValueChanged
        OnFocusedNodeChanged = SolutionExplorerFocusedNodeChanged
        OnResize = SolutionExplorerResize
        object SolutionExplorerColumn: TcxTreeListColumn
          DataBinding.ValueType = 'String'
          Options.Sorting = False
          Width = 175
          Position.ColIndex = 0
          Position.RowIndex = 0
          Position.BandIndex = 0
          Summary.FooterSummaryItems = <>
          Summary.GroupFooterSummaryItems = <>
        end
      end
    end
  end
  object MainActionList: TActionList
    Images = MainDataModule.MainSmallImages
    Left = 472
    Top = 168
    object ActionFilterClear: TAction
      Category = 'Filter'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
      ImageIndex = 138
      OnExecute = ActionFilterClearExecute
    end
    object ActionSolutionOpen: TAction
      Category = 'Solution'
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1088#1077#1096#1077#1085#1080#1077
      ImageIndex = 77
      OnExecute = ActionSolutionOpenExecute
    end
    object ActionSolutionNew: TAction
      Category = 'Solution'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1088#1077#1096#1077#1085#1080#1077
      ImageIndex = 78
      OnExecute = ActionSolutionNewExecute
    end
    object ActionSolutionClose: TAction
      Category = 'Solution'
      Caption = 'ActionSolutionClose'
      ImageIndex = 22
      OnExecute = ActionSolutionCloseExecute
    end
    object ActionProjectNew: TAction
      Category = 'Project'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1077#1082#1090
      ImageIndex = 68
      ShortCut = 16462
      OnExecute = ActionProjectNewExecute
    end
    object ActionProjectAdd: TAction
      Category = 'Project'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1077#1082#1090
      ImageIndex = 10
      ShortCut = 16463
      OnExecute = ActionProjectAddExecute
    end
    object ActionProjectDelete: TAction
      Category = 'Project'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1086#1077#1082#1090
      ImageIndex = 20
      OnExecute = ActionProjectDeleteExecute
    end
    object ActionPatchNew: TAction
      Category = 'Patch'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1072#1090#1095
      ImageIndex = 15
      OnExecute = ActionPatchNewExecute
    end
    object ActionPatchAdd: TAction
      Category = 'Patch'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1090#1095
      ImageIndex = 11
      OnExecute = ActionPatchAddExecute
    end
    object ActionPatchDelete: TAction
      Category = 'Patch'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1090#1095
      ImageIndex = 16
      OnExecute = ActionPatchDeleteExecute
    end
    object ActionScriptNew: TAction
      Category = 'Script'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1089#1082#1088#1080#1087#1090
      ImageIndex = 12
      ShortCut = 16462
      OnExecute = ActionScriptNewExecute
    end
    object ActionScriptOpen: TAction
      Category = 'Script'
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1089#1082#1088#1080#1087#1090
      ImageIndex = 10
    end
    object ActionScriptAdd: TAction
      Category = 'Script'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1082#1088#1080#1087#1090
      ImageIndex = 25
      ShortCut = 16463
      OnExecute = ActionScriptAddExecute
    end
    object ActionScriptDelete: TAction
      Category = 'Script'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1082#1088#1080#1087#1090
      ImageIndex = 26
      ShortCut = 16452
      OnExecute = ActionScriptDeleteExecute
    end
    object ActionFileSave: TAction
      Category = 'File'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 0
      ShortCut = 16467
    end
    object ActionFileSaveAs: TAction
      Category = 'File'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
      ImageIndex = 4
      ShortCut = 32851
      OnExecute = ActionFileSaveAsExecute
    end
    object ActionFileSaveAll: TAction
      Category = 'File'
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1077
      ImageIndex = 1
      ShortCut = 24659
      OnExecute = ActionFileSaveAllExecute
    end
    object ActionFileOpen: TAction
      Category = 'File'
      Caption = #1054#1090#1082#1088#1099#1090#1100'...'
      ImageIndex = 10
      ShortCut = 16463
    end
    object ActionFileNew: TAction
      Category = 'File'
      Caption = #1057#1086#1079#1076#1072#1090#1100'...'
      ImageIndex = 117
    end
    object ActionFolderNew: TAction
      Category = 'Folder'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1072#1087#1082#1091
      ImageIndex = 103
      OnExecute = ActionFolderNewExecute
    end
    object ActionFolderAdd: TAction
      Category = 'Folder'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1072#1087#1082#1091
      ImageIndex = 17
      OnExecute = ActionFolderAddExecute
    end
    object ActionFolderDelete: TAction
      Category = 'Folder'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1072#1087#1082#1091
      ImageIndex = 18
      OnExecute = ActionFolderDeleteExecute
    end
    object ActionSourceNew: TAction
      Category = 'Source'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082
      ImageIndex = 80
      OnExecute = ActionSourceNewExecute
    end
    object ActionSourceDelete: TAction
      Category = 'Source'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082
      ImageIndex = 81
      OnExecute = ActionSourceDeleteExecute
    end
    object ActionSourceEdit: TAction
      Category = 'Source'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1080#1089#1090#1086#1095#1085#1080#1082
      ImageIndex = 82
      ShortCut = 113
      OnExecute = ActionSourceEditExecute
    end
    object ActionFileClose: TAction
      Category = 'File'
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ImageIndex = 29
      ShortCut = 16499
      OnExecute = ActionFileCloseExecute
    end
    object ActionFileCloseAll: TAction
      Category = 'File'
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077
      ImageIndex = 22
      ShortCut = 24691
      OnExecute = ActionFileCloseAllExecute
    end
    object ActionExit: TAction
      Category = 'File'
      Caption = #1042#1099#1081#1090#1080
      ImageIndex = 150
      ShortCut = 115
    end
    object ActionFilterEdit: TAction
      Category = 'Filter'
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1092#1080#1083#1100#1090#1088'...'
      ImageIndex = 137
      ShortCut = 16497
      OnExecute = ActionFilterEditExecute
    end
    object ActionSourceDisconnect: TAction
      Category = 'Source'
      Caption = #1056#1072#1079#1086#1088#1074#1072#1090#1100' '#1089#1086#1076#1080#1085#1077#1085#1080#1077
      OnExecute = ActionSourceDisconnectExecute
    end
    object ActionSourceСonnect: TAction
      Category = 'Source'
      Caption = #1057#1086#1077#1076#1080#1085#1080#1090#1100#1089#1103
      ImageIndex = 79
      ShortCut = 116
      OnExecute = ActionSourceСonnectExecute
    end
    object ActionFolderRename: TAction
      Category = 'Folder'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1087#1072#1087#1082#1091
      ImageIndex = 115
      ShortCut = 113
      OnExecute = ActionFolderRenameExecute
    end
    object ActionOutputNew: TAction
      Category = 'Output'
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      ImageIndex = 28
      ShortCut = 24621
      OnExecute = ActionOutputNewExecute
    end
    object ActionOutputDelete: TAction
      Category = 'Output'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      ImageIndex = 29
      ShortCut = 24622
      OnExecute = ActionOutputDeleteExecute
    end
    object ActionOutputRename: TAction
      Category = 'Output'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090
      ImageIndex = 115
      ShortCut = 113
    end
    object ActionPatchRename: TAction
      Category = 'Patch'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1087#1072#1090#1095
      ImageIndex = 115
      ShortCut = 113
    end
    object ActionProjectRename: TAction
      Category = 'Project'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1087#1088#1086#1077#1082#1090
      ImageIndex = 115
      ShortCut = 113
    end
    object ActionScriptRename: TAction
      Category = 'Script'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1089#1082#1088#1080#1087#1090
      ImageIndex = 115
      ShortCut = 113
    end
    object ActionSolutionRename: TAction
      Category = 'Solution'
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100' '#1088#1077#1096#1077#1085#1080#1077
      ImageIndex = 115
      ShortCut = 113
    end
    object ActionInputAdd: TAction
      Category = 'Input'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      ImageIndex = 35
      ShortCut = 16462
      OnExecute = ActionInputAddExecute
    end
    object ActionInputDelete: TAction
      Category = 'Input'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1084#1087#1086#1085#1077#1085#1090
      ImageIndex = 36
      ShortCut = 16452
      OnExecute = ActionInputDeleteExecute
    end
    object ActionInputUp: TAction
      Category = 'Input'
      Caption = #1056#1072#1085#1100#1096#1077
      ImageIndex = 50
      ShortCut = 38
    end
    object ActionInputDown: TAction
      Category = 'Input'
      Caption = #1055#1086#1079#1078#1077
      ImageIndex = 51
      ShortCut = 40
    end
    object ActionInputFirst: TAction
      Category = 'Input'
      Caption = #1042' '#1085#1072#1095#1072#1083#1086
      ImageIndex = 52
    end
    object ActionInputLast: TAction
      Category = 'Input'
      Caption = #1042' '#1082#1086#1085#1077#1094
      ImageIndex = 53
    end
    object ActionDoCompare: TAction
      Category = '!Run'
      Caption = #1057#1088#1072#1074#1085#1077#1085#1080#1077'...'
      ImageIndex = 149
      ShortCut = 16503
      OnExecute = ActionDoCompareExecute
    end
  end
  object MainBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'FILE'
      'ADD'
      'DEL'
      'EDIT'
      'View'
      'Project'
      'Optoins')
    Categories.ItemsVisibles = (
      3
      3
      3
      3
      3
      3
      3)
    Categories.Visibles = (
      True
      True
      True
      True
      True
      True
      True)
    ImageOptions.Images = MainDataModule.MainSmallImages
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 472
    Top = 248
    DockControlHeights = (
      0
      0
      0
      0)
    object MainRToolbarHomeFile: TdxBar
      Caption = 'Home File'
      CaptionButtons = <
        item
          Hint = #1058#1045#1057#1058
        end>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 980
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          ItemName = 'MainItemHomeOpen'
        end
        item
          ItemName = 'MenuItemHomeNew'
        end
        item
          ItemName = 'MainItemHomeDelete'
        end
        item
          BeginGroup = True
          ItemName = 'MainItemFileSaveGroup'
        end
        item
          BeginGroup = True
          ItemName = 'MainItemFileClose'
        end
        item
          Position = ipBeginsNewRow
          ItemName = 'MainItemFileCloseAll'
        end
        item
          Position = ipBeginsNewRow
          ItemName = 'MainItemFileExit'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainRToolbarHomeEdit: TdxBar
      Caption = 'Home Edit'
      CaptionButtons = <>
      DockedLeft = 420
      DockedTop = 0
      FloatLeft = 980
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          ItemName = 'MainItemFileRename'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemFilter'
        end
        item
          Position = ipBeginsNewRow
          ItemName = 'MainItemFilterClear'
        end
        item
          Position = ipBeginsNewRow
          ItemName = 'MenuItemSourceEdit'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainRToolbarProjectEdit: TdxBar
      Caption = 'Project Edit'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 2100
      FloatTop = 415
      FloatClientWidth = 51
      FloatClientHeight = 22
      ItemLinks = <
        item
          ItemName = 'MainItemProjectNew'
        end
        item
          ItemName = 'MainItemProjectDelete'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemFilter'
        end
        item
          Position = ipBeginsNewRow
          ItemName = 'MenuItemSourceEdit'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainRToolbarToolsOptions: TdxBar
      Caption = 'Tools Options'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 980
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainRToolbarViewApplication: TdxBar
      Caption = 'View Skin'
      CaptionButtons = <>
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 987
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          ItemName = 'MainItemSkinChooserGallery'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainRToolbarProjectActions: TdxBar
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      CaptionButtons = <>
      DockedLeft = 274
      DockedTop = 0
      FloatLeft = 983
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          ItemName = 'MainItemDoCompare'
        end>
      OneOnRow = False
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object MainItemFileSaveGroup: TdxBarSubItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 5
      LargeImageIndex = 5
      ItemLinks = <
        item
          ItemName = 'MenuItemFileSave'
        end
        item
          ItemName = 'MainItemFileSaveAs'
        end
        item
          ItemName = 'MainItemFileSaveAll'
        end>
      ItemOptions.Size = misNormal
    end
    object MenuItemFileSave: TdxBarButton
      Action = ActionFileSave
      Category = 0
    end
    object MainItemFileSaveAs: TdxBarButton
      Action = ActionFileSaveAs
      Category = 0
    end
    object MainItemFileSaveAll: TdxBarButton
      Action = ActionFileSaveAll
      Category = 0
    end
    object MainItemFileExit: TdxBarButton
      Action = ActionExit
      Category = 0
    end
    object MainItemFileClose: TdxBarButton
      Action = ActionFileClose
      Category = 0
    end
    object MainItemFileCloseAll: TdxBarButton
      Action = ActionFileCloseAll
      Category = 0
    end
    object MenuItemHomeNew: TdxBarSubItem
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Category = 1
      Visible = ivAlways
      ImageIndex = 117
      ItemLinks = <
        item
          ItemName = 'MenuItemSolutionNew'
        end
        item
          ItemName = 'MenuItemProjectNew'
        end
        item
          ItemName = 'MenuItemProjectAdd'
        end
        item
          ItemName = 'MenuItemPatchNew'
        end
        item
          ItemName = 'MenuItemPatchAdd'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemFolderNew'
        end
        item
          ItemName = 'MenuItemFolderAdd'
        end
        item
          ItemName = 'MenuItemScriptNew'
        end
        item
          ItemName = 'MenuItemScriptAdd'
        end
        item
          ItemName = 'MenuItemSourceNew'
        end
        item
          ItemName = 'MainItemOutputNew'
        end
        item
          ItemName = 'MainItemInputAdd'
        end>
    end
    object MenuItemSolutionNew: TdxBarButton
      Action = ActionSolutionNew
      Category = 1
    end
    object MenuItemProjectNew: TdxBarButton
      Action = ActionProjectNew
      Category = 1
    end
    object MenuItemPatchNew: TdxBarButton
      Action = ActionPatchNew
      Category = 1
    end
    object MainItemHomeOpen: TdxBarSubItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 1
      Visible = ivAlways
      ImageIndex = 10
      ItemLinks = <
        item
          ItemName = 'MenuItemSolutionOpen'
        end
        item
          ItemName = 'MenuItemScriptOpen'
        end>
    end
    object MenuItemScriptOpen: TdxBarButton
      Action = ActionScriptOpen
      Category = 1
    end
    object MenuItemSolutionOpen: TdxBarButton
      Action = ActionSolutionOpen
      Category = 1
    end
    object MenuItemProjectAdd: TdxBarButton
      Action = ActionProjectAdd
      Category = 1
    end
    object MenuItemPatchAdd: TdxBarButton
      Action = ActionPatchAdd
      Category = 1
    end
    object MenuItemSourceNew: TdxBarButton
      Action = ActionSourceNew
      Category = 1
    end
    object MenuItemFolderNew: TdxBarButton
      Action = ActionFolderNew
      Category = 1
    end
    object MenuItemScriptNew: TdxBarButton
      Action = ActionScriptNew
      Category = 1
    end
    object MenuItemFolderAdd: TdxBarButton
      Action = ActionFolderAdd
      Category = 1
    end
    object MenuItemScriptAdd: TdxBarButton
      Action = ActionScriptAdd
      Category = 1
    end
    object MainItemOutputNew: TdxBarButton
      Action = ActionOutputNew
      Category = 1
    end
    object MainItemInputAdd: TdxBarButton
      Action = ActionInputAdd
      Category = 1
    end
    object MainItemHomeDelete: TdxBarSubItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 2
      Visible = ivAlways
      ImageIndex = 23
      ItemLinks = <
        item
          ItemName = 'MenuItemProjectDelete'
        end
        item
          ItemName = 'MenuItemPatchDelete'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemFolderDelete'
        end
        item
          ItemName = 'MenuItemScriptDelete'
        end
        item
          ItemName = 'MenuItemConnectionDelete'
        end
        item
          ItemName = 'MainItemOutputDelete'
        end
        item
          ItemName = 'ActionItemInputDelete'
        end>
    end
    object MenuItemProjectDelete: TdxBarButton
      Action = ActionProjectDelete
      Category = 2
    end
    object MenuItemPatchDelete: TdxBarButton
      Action = ActionPatchDelete
      Category = 2
    end
    object ActionItemInputDelete: TdxBarButton
      Action = ActionInputDelete
      Category = 2
    end
    object MainItemOutputDelete: TdxBarButton
      Action = ActionOutputDelete
      Category = 2
    end
    object MenuItemScriptDelete: TdxBarButton
      Action = ActionScriptDelete
      Category = 2
    end
    object MenuItemFolderDelete: TdxBarButton
      Action = ActionFolderDelete
      Category = 2
    end
    object MenuItemConnectionDelete: TdxBarButton
      Action = ActionSourceDelete
      Category = 2
    end
    object MainItemEditUndo: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1074#1074#1086#1076
      Category = 3
      Visible = ivAlways
      ImageIndex = 118
      ShortCut = 16474
      OnClick = MainItemEditUndoClick
    end
    object MainItemEditRedo: TdxBarButton
      Caption = #1042#1077#1088#1085#1091#1090#1100' '#1074#1074#1086#1076
      Category = 3
      Visible = ivAlways
      ImageIndex = 119
      ShortCut = 24666
    end
    object MainItemFileRename: TdxBarSubItem
      Caption = #1055#1077#1088#1077#1080#1084#1077#1085#1086#1074#1072#1090#1100
      Category = 3
      Visible = ivAlways
      ImageIndex = 115
      ItemLinks = <
        item
          ItemName = 'MainItemProjectRename'
        end
        item
          ItemName = 'MainItemPatchRename'
        end
        item
          ItemName = 'MainItemFolderRename'
        end
        item
          ItemName = 'MainItemScriptRename'
        end
        item
          ItemName = 'MainItemOutputRename'
        end>
    end
    object MainItemScriptRename: TdxBarButton
      Action = ActionScriptRename
      Category = 3
    end
    object MainItemPatchRename: TdxBarButton
      Action = ActionPatchRename
      Category = 3
    end
    object MainItemProjectRename: TdxBarButton
      Action = ActionProjectRename
      Category = 3
    end
    object MainItemFolderRename: TdxBarButton
      Action = ActionFolderRename
      Category = 3
    end
    object MainItemOutputRename: TdxBarButton
      Action = ActionOutputRename
      Category = 3
    end
    object MainItemSkinChooserGallery: TdxSkinChooserGalleryItem
      Caption = #1057#1090#1080#1083#1100
      Category = 4
      Visible = ivAlways
      ItemLinks = <>
    end
    object MainItemProjectNew: TdxBarSubItem
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Category = 5
      Visible = ivAlways
      ImageIndex = 28
      ItemLinks = <
        item
          ItemName = 'MenuItemFolderNew'
        end
        item
          ItemName = 'MenuItemScriptNew'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemSourceNew'
        end>
    end
    object MainItemProjectDelete: TdxBarSubItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Category = 5
      Visible = ivAlways
      ImageIndex = 23
      ItemLinks = <
        item
          ItemName = 'MenuItemFolderDelete'
        end
        item
          ItemName = 'MenuItemScriptDelete'
        end
        item
          BeginGroup = True
          ItemName = 'MenuItemConnectionDelete'
        end>
    end
    object MenuItemSourceEdit: TdxBarButton
      Action = ActionSourceEdit
      Category = 5
    end
    object ManuItemSourceConnect: TdxBarButton
      Action = ActionSourceСonnect
      Category = 5
    end
    object MenuItemSourceDisconnect: TdxBarButton
      Action = ActionSourceDisconnect
      Category = 5
    end
    object MenuItemFilter: TdxBarButton
      Action = ActionFilterEdit
      Category = 5
    end
    object MainItemFilterClear: TdxBarButton
      Action = ActionFilterClear
      Category = 5
    end
    object MainItemDoCompare: TdxBarButton
      Action = ActionDoCompare
      Category = 5
    end
  end
  object MainTabbedMDIManager: TdxTabbedMDIManager
    Active = True
    TabProperties.CloseButtonMode = cbmActiveTab
    TabProperties.CustomButtons.Buttons = <>
    TabProperties.HotTrack = True
    TabProperties.ShowTabHints = True
    Left = 848
    Top = 168
  end
  object MainBarApplicationMenu: TdxBarApplicationMenu
    BarManager = MainBarManager
    Buttons = <>
    ExtraPane.Items = <>
    ItemLinks = <>
    UseOwnFont = False
    Left = 704
    Top = 168
  end
  object MainFromPopupMenu: TdxBarPopupMenu
    BarManager = MainBarManager
    Images = MainDataModule.MainSmallImages
    ItemLinks = <>
    UseOwnFont = False
    Left = 96
    Top = 560
  end
  object SaveDialogSolution: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 224
    Top = 144
  end
  object OpenDialogSolution: TOpenDialog
    Left = 32
    Top = 144
  end
  object SaveDialogProject: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 224
    Top = 200
  end
  object OpenDialogProject: TOpenDialog
    Left = 32
    Top = 200
  end
  object OpenDialogPatch: TOpenDialog
    Left = 32
    Top = 264
  end
  object SaveDialogPatch: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 224
    Top = 264
  end
  object DockingManager: TdxDockingManager
    Color = clBtnFace
    DefaultHorizContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultHorizContainerSiteProperties.Dockable = True
    DefaultHorizContainerSiteProperties.ImageIndex = -1
    DefaultVertContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultVertContainerSiteProperties.Dockable = True
    DefaultVertContainerSiteProperties.ImageIndex = -1
    DefaultTabContainerSiteProperties.CustomCaptionButtons.Buttons = <>
    DefaultTabContainerSiteProperties.Dockable = True
    DefaultTabContainerSiteProperties.ImageIndex = -1
    DefaultTabContainerSiteProperties.TabsProperties.CustomButtons.Buttons = <>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [doActivateAfterDocking, doDblClickDocking, doFloatingOnTop, doTabContainerHasCaption, doTabContainerCanAutoHide, doSideContainerCanClose, doSideContainerCanAutoHide, doTabContainerCanInSideContainer, doHideAutoHideIfActive, doRedrawOnResize]
    Left = 392
    Top = 328
    PixelsPerInch = 96
  end
  object SolutionExplorerPopupMenu: TdxBarPopupMenu
    BarManager = MainBarManager
    Images = MainDataModule.MainSmallImages
    ItemLinks = <
      item
        ItemName = 'MenuItemSolutionOpen'
      end
      item
        ItemName = 'MainItemFileCloseAll'
      end
      item
        BeginGroup = True
        ItemName = 'MenuItemProjectNew'
      end
      item
        ItemName = 'MenuItemPatchNew'
      end
      item
        ItemName = 'MenuItemSourceNew'
      end
      item
        ItemName = 'MenuItemFolderNew'
      end
      item
        ItemName = 'MainItemOutputNew'
      end
      item
        ItemName = 'MainItemInputAdd'
      end
      item
        BeginGroup = True
        ItemName = 'MenuItemProjectAdd'
      end
      item
        ItemName = 'MenuItemPatchAdd'
      end
      item
        ItemName = 'MenuItemFolderAdd'
      end
      item
        ItemName = 'MenuItemFilter'
      end
      item
        ItemName = 'MenuItemScriptAdd'
      end
      item
        BeginGroup = True
        ItemName = 'MenuItemProjectDelete'
      end
      item
        ItemName = 'MenuItemPatchDelete'
      end
      item
        ItemName = 'MenuItemConnectionDelete'
      end
      item
        ItemName = 'MenuItemFolderDelete'
      end
      item
        ItemName = 'MainItemFilterClear'
      end
      item
        ItemName = 'MenuItemScriptDelete'
      end
      item
        ItemName = 'MainItemOutputDelete'
      end
      item
        ItemName = 'ActionItemInputDelete'
      end
      item
        BeginGroup = True
        ItemName = 'MainItemProjectRename'
      end
      item
        ItemName = 'MainItemPatchRename'
      end
      item
        ItemName = 'MainItemFolderRename'
      end
      item
        ItemName = 'MainItemScriptRename'
      end
      item
        ItemName = 'MenuItemSourceEdit'
      end
      item
        ItemName = 'MainItemOutputRename'
      end
      item
        ItemName = 'ManuItemSourceConnect'
      end
      item
        ItemName = 'MenuItemSourceDisconnect'
      end>
    UseOwnFont = False
    Left = 96
    Top = 496
  end
  object OpenDialogFolder: TOpenDialog
    Options = [ofNoChangeDir, ofPathMustExist, ofEnableSizing]
    Left = 48
    Top = 328
  end
  object ShellBrowserDialogFolder: TcxShellBrowserDialog
    Root.BrowseFolder = bfCustomPath
    Left = 179
    Top = 345
  end
  object OpenDialogScript: TOpenDialog
    Options = [ofNoChangeDir, ofAllowMultiSelect, ofPathMustExist, ofEnableSizing]
    Left = 48
    Top = 384
  end
  object SaveDialogOutput: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 232
    Top = 416
  end
end
