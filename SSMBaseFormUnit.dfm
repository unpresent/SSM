object SSMBaseForm: TSSMBaseForm
  Left = 0
  Top = 0
  Caption = 'SSMBaseForm'
  ClientHeight = 487
  ClientWidth = 734
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object FormActionList: TActionList
    Images = MainDataModule.MainSmallImages
    Left = 688
    Top = 8
    object ActionClose: TAction
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnExecute = ActionCloseExecute
    end
  end
  object FromPopupMenu: TdxBarPopupMenu
    BarManager = FormBarManager
    Images = MainDataModule.MainSmallImages
    ItemLinks = <
      item
        ItemName = 'FormItemClose'
      end>
    UseOwnFont = False
    Left = 520
    Top = 43
  end
  object FormBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      3)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 608
    Top = 8
    DockControlHeights = (
      0
      0
      0
      0)
    object FormItemClose: TdxBarButton
      Action = ActionClose
      Category = 0
    end
  end
end
