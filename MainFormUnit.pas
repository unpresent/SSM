unit MainFormUnit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  System.Types,
  System.UITypes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ActnList,
  Vcl.ActnMan,
  Vcl.ImgList,
  Vcl.Grids,
  Vcl.Samples.DirOutln,

  cxClasses,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxPC,
  dxStatusBar,
  dxMDStatusBar,
  dxBarBuiltInMenu,
  dxBar,
  dxBarApplicationMenu,
  dxRibbon,
  dxTabbedMDI,
  cxTextEdit,

  cxCalc, cxBarEditItem, dxRibbonBackstageView,
  dxGalleryControl, dxRibbonBackstageViewGalleryControl, dxGallery,
  dxRibbonSkins, dxRibbonCustomizationForm, dxRibbonGallery,
  dxSkinChooserGallery, cxShellBrowserDialog, dxDockControl, dxDockPanel,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,

  MainDataModuleUnit,
  SSMSolutionExplorer,
  DBAccess, UniDacVcl, Data.DB, Uni,
  SQLServerUniProvider,

  NamedVariables, cxCheckBox, cxMaskEdit;

type
  TMainForm = class(TForm)
    MainStatusBar           : TdxMDStatusBar;
    MainBarManager          : TdxBarManager;
    MainTabbedMDIManager    : TdxTabbedMDIManager;
    MainBarApplicationMenu  : TdxBarApplicationMenu;
    MainFromPopupMenu       : TdxBarPopupMenu;
    MenuItemFileSave: TdxBarButton;
    MainItemFileSaveAs: TdxBarButton;
    MainItemFileSaveAll: TdxBarButton;
    MainItemHomeOpen: TdxBarSubItem;
    MenuItemSolutionOpen: TdxBarButton;
    MenuItemScriptOpen: TdxBarButton;
    MenuItemHomeNew: TdxBarSubItem;
    MenuItemSolutionNew: TdxBarButton;
    MenuItemFolderNew: TdxBarButton;
    MenuItemScriptNew: TdxBarButton;
    MainItemFileClose: TdxBarButton;
    MainItemFileCloseAll: TdxBarButton;
    MainItemFileExit: TdxBarButton;
    MainItemEditUndo        : TdxBarButton;
    MainItemEditRedo        : TdxBarButton;
    MenuItemProjectAdd: TdxBarButton;
    MenuItemPatchAdd: TdxBarButton;
    MenuItemFolderAdd: TdxBarButton;
    MenuItemPatchNew: TdxBarButton;
    MenuItemScriptAdd: TdxBarButton;
    MainItemHomeDelete: TdxBarSubItem;
    MenuItemProjectDelete: TdxBarButton;
    MenuItemPatchDelete: TdxBarButton;
    MenuItemScriptDelete: TdxBarButton;
    MenuItemFolderDelete: TdxBarButton;
    MainDockTop: TdxBarDockControl;
    MainDockLeft: TdxBarDockControl;
    MainDockRight: TdxBarDockControl;
    MainRibbonHome: TdxRibbonTab;
    MainRibbon: TdxRibbon;
    MainRToolbarHomeFile: TdxBar;
    MainRibbonView: TdxRibbonTab;
    MainRToolbarHomeEdit: TdxBar;
    MenuItemProjectNew: TdxBarButton;
    MainRToolbarProjectEdit: TdxBar;
    ActionSolutionOpen: TAction;
    ActionFileSave: TAction;
    ActionSolutionNew: TAction;
    ActionSolutionClose: TAction;
    ActionProjectNew: TAction;
    ActionProjectDelete: TAction;
    ActionPatchNew: TAction;
    ActionProjectAdd: TAction;
    ActionPatchAdd: TAction;
    ActionPatchDelete: TAction;
    ActionScriptNew: TAction;
    ActionScriptOpen: TAction;
    ActionScriptAdd: TAction;
    ActionScriptDelete: TAction;
    ActionFileOpen: TAction;
    ActionFileSaveAll: TAction;
    ActionFileNew: TAction;
    ActionFolderNew: TAction;
    ActionFolderAdd: TAction;
    ActionFolderDelete: TAction;
    ActionSourceNew: TAction;
    ActionSourceDelete: TAction;
    ActionSourceEdit: TAction;
    MainRToolbarToolsOptions: TdxBar;
    MainItemFileSaveGroup: TdxBarSubItem;
    ActionFileSaveAs: TAction;
    ActionFileClose: TAction;
    ActionFileCloseAll: TAction;
    ActionExit: TAction;
    MainActionList: TActionList;
    MainRibbonProject: TdxRibbonTab;
    MainItemProjectDelete: TdxBarSubItem;
    MainItemProjectNew: TdxBarSubItem;
    MenuItemSourceNew: TdxBarButton;
    MenuItemConnectionDelete: TdxBarButton;
    ActionFilterEdit: TAction;
    MenuItemFilter: TdxBarButton;
    MenuItemSourceEdit: TdxBarButton;
    MainRibbonTools: TdxRibbonTab;
    MainItemSkinChooserGallery: TdxSkinChooserGalleryItem;
    MainRToolbarViewApplication: TdxBar;
    SaveDialogSolution: TSaveDialog;
    OpenDialogSolution: TOpenDialog;
    SaveDialogProject: TSaveDialog;
    OpenDialogProject: TOpenDialog;
    OpenDialogPatch: TOpenDialog;
    SaveDialogPatch: TSaveDialog;
    DockSiteLeft: TdxDockSite;
    DockSiteRight: TdxDockSite;
    DockingManager: TdxDockingManager;
    SolutionExplorerDockPanel: TdxDockPanel;
    dxLayoutDockSite2: TdxLayoutDockSite;
    SolutionExplorer: TcxTreeList;
    SolutionExplorerColumn: TcxTreeListColumn;
    SolutionExplorerPopupMenu: TdxBarPopupMenu;
    ActionFilterClear: TAction;
    OpenDialogFolder: TOpenDialog;
    ShellBrowserDialogFolder: TcxShellBrowserDialog;
    ActionSourceDisconnect: TAction;
    ActionSource—onnect: TAction;
    ManuItemSourceConnect: TdxBarButton;
    MenuItemSourceDisconnect: TdxBarButton;
    ActionFolderRename: TAction;
    MainItemFolderRename: TdxBarButton;
    OpenDialogScript: TOpenDialog;
    ActionOutputNew: TAction;
    ActionOutputDelete: TAction;
    ActionOutputRename: TAction;
    ActionPatchRename: TAction;
    ActionProjectRename: TAction;
    ActionScriptRename: TAction;
    ActionSolutionRename: TAction;
    ActionInputAdd: TAction;
    ActionInputDelete: TAction;
    ActionInputUp: TAction;
    ActionInputDown: TAction;
    ActionInputFirst: TAction;
    ActionInputLast: TAction;
    MainItemOutputNew: TdxBarButton;
    MainItemOutputDelete: TdxBarButton;
    MainItemOutputRename: TdxBarButton;
    MainItemProjectRename: TdxBarButton;
    MainItemPatchRename: TdxBarButton;
    MainItemScriptRename: TdxBarButton;
    MainItemFileRename: TdxBarSubItem;
    SaveDialogOutput: TSaveDialog;
    MainItemInputAdd: TdxBarButton;
    ActionItemInputDelete: TdxBarButton;
    ActionDoCompare: TAction;
    MainRToolbarProjectActions: TdxBar;
    MainItemDoCompare: TdxBarButton;
    MainItemFilterClear: TdxBarButton;
    procedure MainItemFileExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActionFileSaveAllExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SolutionExplorerFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure ActionProjectNewExecute(Sender: TObject);
    procedure ActionProjectAddExecute(Sender: TObject);
    procedure ActionProjectDeleteExecute(Sender: TObject);
    procedure ActionPatchNewExecute(Sender: TObject);
    procedure ActionPatchAddExecute(Sender: TObject);
    procedure ActionPatchDeleteExecute(Sender: TObject);
    procedure ActionFolderNewExecute(Sender: TObject);
    procedure ActionFolderAddExecute(Sender: TObject);
    procedure ActionFolderDeleteExecute(Sender: TObject);
    procedure ActionFileCloseAllExecute(Sender: TObject);
    procedure ActionSolutionOpenExecute(Sender: TObject);
    procedure ActionSolutionCloseExecute(Sender: TObject);
    procedure ActionSolutionNewExecute(Sender: TObject);
    procedure ActionSourceNewExecute(Sender: TObject);
    procedure ActionSourceDeleteExecute(Sender: TObject);
    procedure ActionSourceEditExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SolutionExplorerResize(Sender: TObject);
    procedure SolutionExplorerCustomDrawDataCell(Sender: TcxCustomTreeList;
      ACanvas: TcxCanvas; AViewInfo: TcxTreeListEditCellViewInfo;
      var ADone: Boolean);
    procedure ActionSourceDisconnectExecute(Sender: TObject);
    procedure ActionSource—onnectExecute(Sender: TObject);
    procedure ActionFolderRenameExecute(Sender: TObject);
    procedure SolutionExplorerEditValueChanged(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure ActionScriptNewExecute(Sender: TObject);
    procedure ActionScriptAddExecute(Sender: TObject);
    procedure ActionScriptDeleteExecute(Sender: TObject);
    procedure ActionOutputNewExecute(Sender: TObject);
    procedure ActionOutputDeleteExecute(Sender: TObject);
    procedure ActionInputAddExecute(Sender: TObject);
    procedure ActionInputDeleteExecute(Sender: TObject);
    procedure MainItemEditUndoClick(Sender: TObject);
    procedure SolutionExplorerEdited(Sender: TcxCustomTreeList;
      AColumn: TcxTreeListColumn);
    procedure MenuItemFileSaveClick(Sender: TObject);
    procedure ActionFileSaveAsExecute(Sender: TObject);
    procedure ActionDoCompareExecute(Sender: TObject);
    procedure ActionFileCloseExecute(Sender: TObject);
    procedure ActionFilterEditExecute(Sender: TObject);
    procedure ActionFilterClearExecute(Sender: TObject);
  private
    FClosing                : Boolean;
    function GetCurrentSolution: TSSMSolution;
  protected
    procedure CheckSaveProject(AProject: TSSMProject);
    procedure CheckSaveProjects;
    procedure CheckSavePatch(APatch: TSSMPatch);
    procedure CheckSavePatches;
  public
    property CurrentSolution: TSSMSolution read GetCurrentSolution;

    procedure SaveAsCurrentSolution;
    procedure SaveAsProject(AProject: TSSMProject);
    procedure SaveAsPatch(APatch: TSSMPatch);

    procedure CheckSaveCurrentSolution;

    procedure RefreshSolutionExplorer;
    procedure RefreshSolutionActions;

    function ShowFormByNode(ANode : TSSMNode): TForm;
  end;

var
  MainForm: TMainForm;

implementation

uses
  SSMBaseFormUnit,
  SSMComparerFormUnit;

{$R *.dfm}

procedure TMainForm.ActionDoCompareExecute(Sender: TObject);
begin
  // ¬˚Á˚‚‡ÂÏ Ã‡ÒÚÂ Ò‡‚ÌÂÌËˇ
  MainDataModule.ShowComparerForm(SolutionExplorerViewer.CurrentNode);
end;

procedure TMainForm.ActionFileCloseAllExecute(Sender: TObject);
var
  LForm       : TForm;
  LOldCount   : Integer;
begin
  while MDIChildCount > 0 do begin
    LOldCount := MDIChildCount;
    LForm := MDIChildren[MDIChildCount - 1];
    LForm.Close;
    Application.HandleMessage;
    if LOldCount >= MDIChildCount then
      Break;
  end;
  ActionSolutionClose.Execute;
end;

procedure TMainForm.ActionFileCloseExecute(Sender: TObject);
var
  LForm : TForm;
begin
  LForm := ActiveMDIChild;
  if Assigned(LForm) then begin
    LForm.Close;
  end else if SolutionExplorer.Focused then begin
    if SolutionExplorerViewer.CurrentNode_IsSolution then
      ActionSolutionClose.Execute;
  end;
end;

procedure TMainForm.ActionFileSaveAllExecute(Sender: TObject);
begin
  CheckSavePatches;
  CheckSaveProjects;
  CheckSaveCurrentSolution;

  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionFileSaveAsExecute(Sender: TObject);
begin
  if SolutionExplorerViewer.CurrentNode_IsProject then
    SaveAsProject( TSSMProject(SolutionExplorerViewer.CurrentNode) );

  if SolutionExplorerViewer.CurrentNode_IsPatch then
    SaveAsPatch( TSSMPatch(SolutionExplorerViewer.CurrentNode) );

  if SolutionExplorerViewer.CurrentNode_IsSolution then
    SaveAsCurrentSolution;
end;

procedure TMainForm.ActionFilterClearExecute(Sender: TObject);
begin
  if SolutionExplorerViewer.CurrentNode_IsFilter then begin
    TSSMFilter(SolutionExplorerViewer.CurrentNode).Folder.FilterDelete;
  end else if SolutionExplorerViewer.CurrentNode_IsFolder then begin
    TSSMFolder(SolutionExplorerViewer.CurrentNode).FilterDelete;
  end;
  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionFilterEditExecute(Sender: TObject);
begin
  MainDataModule.ShowFilterForm(SolutionExplorerViewer.CurrentNode);
end;

procedure TMainForm.ActionFolderAddExecute(Sender: TObject);
var
  LPath       : String;
  LFolderName : String;
  LProject    : TSSMProject;
  LFolder     : TSSMFolder;
begin
  if SolutionExplorerViewer.CurrentNode_IsProject then begin
    LProject := TSSMProject(SolutionExplorerViewer.CurrentNode);
    LFolder := nil;
    LPath := LProject.Path;
  end else if SolutionExplorerViewer.CurrentNode_IsFolder then begin
    LFolder := TSSMFolder(SolutionExplorerViewer.CurrentNode);
    LProject := nil;
    LPath := LFolder.FullName
  end else
    Exit;

  ShellBrowserDialogFolder.Root.CustomPath := LPath;
  ShellBrowserDialogFolder.FolderLabelCaption := LPath;
  if ShellBrowserDialogFolder.Execute then begin
    LPath := ShellBrowserDialogFolder.Path;
    if not DirectoryExists(LPath) then
      System.SysUtils.CreateDir(LPath);

    if Assigned(LProject) then begin
      LProject.FolderAddByFullName(LPath);
    end else if Assigned(LFolder) then begin
      // TODO - ÂÒÎË ‚˚·‡ÎË ÒÛ·ÔÛÚ¸...
      LFolderName := ExtractFileName(LPath);
      LFolder.FolderAddByShortName(LFolderName);
    end;

    RefreshSolutionExplorer;
  end;

end;

procedure TMainForm.ActionFolderDeleteExecute(Sender: TObject);
var
  LMResult    : Integer;
  LFolder     : TSSMFolder;
begin
  if not SolutionExplorerViewer.CurrentNode_IsFolder then
    Exit;

  LMResult := MessageDlg(CMessage_DeleteFromDisk, mtConfirmation, mbYesNoCancel, 0);
  if LMResult = mrCancel then
    Exit;

  LFolder := TSSMFolder(SolutionExplorerViewer.CurrentNode);
  try
    SolutionExplorerViewer.CurrentTreeListNode.Delete;
    LFolder.Delete(LMResult = mrYes);
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionFolderNewExecute(Sender: TObject);
var
  LPath       : String;
  LFolderName : String;
  LProject    : TSSMProject;
  LFolder     : TSSMFolder;
begin
  if SolutionExplorerViewer.CurrentNode_IsProject then begin
    LProject := TSSMProject(SolutionExplorerViewer.CurrentNode);
    LFolder := nil;
    LPath := LProject.Path;
  end else if SolutionExplorerViewer.CurrentNode_IsFolder then begin
    LFolder := TSSMFolder(SolutionExplorerViewer.CurrentNode);
    LProject := nil;
    LPath := LFolder.FullName
  end else
    Exit;

  OpenDialogFolder.InitialDir := LPath;
  if OpenDialogFolder.Execute then begin
    LPath := OpenDialogFolder.FileName;
    if not DirectoryExists(LPath) then
      System.SysUtils.CreateDir(LPath);

    if Assigned(LProject) then begin
      LProject.FolderAddByFullName(LPath);
    end else if Assigned(LFolder) then begin
      LFolderName := ExtractFileName(LPath);
      LFolder.FolderAddByShortName(LFolderName);
    end;

    RefreshSolutionExplorer;
  end;

end;

procedure TMainForm.ActionFolderRenameExecute(Sender: TObject);
begin
  SolutionExplorer.OptionsData.Editing := True;
  // SolutionExplorer.DataController.Edit;
  SolutionExplorer.ShowEdit;
end;

procedure TMainForm.ActionInputAddExecute(Sender: TObject);
var
  LInputName  : String;
  LOutput     : TSSMOutput;
begin
  if not SolutionExplorerViewer.CurrentNode_IsOutput then
    Exit;

  LOutput := TSSMOutput(SolutionExplorerViewer.CurrentNode);
  if OpenDialogScript.Execute then begin
    LInputName := OpenDialogScript.FileName;
    LOutput.InputAddByFullName(LInputName);

    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionInputDeleteExecute(Sender: TObject);
var
  LInput      : TSSMInput;
begin
  if not SolutionExplorerViewer.CurrentNode_IsInput then
    Exit;

  LInput := TSSMInput(SolutionExplorerViewer.CurrentNode);
  try
    SolutionExplorerViewer.CurrentTreeListNode.Delete;
    LInput.Delete;
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionOutputDeleteExecute(Sender: TObject);
var
  LMResult    : Integer;
  LOutput     : TSSMOutput;
begin
  if not SolutionExplorerViewer.CurrentNode_IsOutput then
    Exit;

  LMResult := MessageDlg(CMessage_DeleteFromDisk, mtConfirmation, mbYesNoCancel, 0);
  if LMResult = mrCancel then
    Exit;

  LOutput := TSSMOutput(SolutionExplorerViewer.CurrentNode);
  try
    SolutionExplorerViewer.CurrentTreeListNode.Delete;
    LOutput.Delete(LMResult = mrYes);
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionOutputNewExecute(Sender: TObject);
var
  LPath       : String;
  LOutputName : String;
  LPatch      : TSSMPatch;
begin
  if not SolutionExplorerViewer.CurrentNode_IsPatch then
    Exit;

  LPatch := TSSMPatch(SolutionExplorerViewer.CurrentNode);
  LPath := LPatch.Path;

  SaveDialogOutput.InitialDir := LPath;
  if SaveDialogOutput.Execute then begin
    LOutputName := SaveDialogOutput.FileName;
    LOutputName := ExtractFileName(LOutputName);
    LPatch.OutputAddByShortName(LOutputName);

    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionPatchAddExecute(Sender: TObject);
var
  LPatchName : String;
begin
  if OpenDialogPatch.Execute then begin
    LPatchName := OpenDialogPatch.FileName;
    if not Assigned(CurrentSolution.PatchByFileName(LPatchName)) then begin
      CurrentSolution.PatchAddExisting(LPatchName);
      RefreshSolutionExplorer;
    end;
  end;
end;

procedure TMainForm.ActionPatchDeleteExecute(Sender: TObject);
begin
  if SolutionExplorerViewer.CurrentNode_IsPatch then
    CurrentSolution.PatchRemove( TSSMPatch(SolutionExplorerViewer.CurrentNode), True);
  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionPatchNewExecute(Sender: TObject);
var
  LPatch : TSSMPatch;
begin
  LPatch := CurrentSolution.PatchNew;
  SaveDialogPatch.FileName := LPatch.FileName;
  SaveDialogPatch.InitialDir := LPatch.Path;
  if SaveDialogPatch.Execute then begin
    LPatch.FileName := SaveDialogPatch.FileName;
    LPatch.Save;
  end;
  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionProjectAddExecute(Sender: TObject);
var
  LProjectName : String;
begin
  if OpenDialogProject.Execute then begin
    LProjectName := OpenDialogProject.FileName;
    if not Assigned(CurrentSolution.ProjectByFileName(LProjectName)) then begin
      CurrentSolution.ProjectAddExisting(LProjectName);
      RefreshSolutionExplorer;
    end;
  end;
end;

procedure TMainForm.ActionProjectDeleteExecute(Sender: TObject);
begin
  if SolutionExplorerViewer.CurrentNode_IsProject then
    CurrentSolution.ProjectRemove( TSSMProject(SolutionExplorerViewer.CurrentNode), True);
  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionProjectNewExecute(Sender: TObject);
var
  LProject : TSSMProject;
begin
  LProject := CurrentSolution.ProjectNew;
  SaveDialogProject.FileName := LProject.FileName;
  SaveDialogProject.InitialDir := LProject.Path;
  if SaveDialogProject.Execute then begin
    LProject.FileName := SaveDialogProject.FileName;
    LProject.Save;
  end;
  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionScriptAddExecute(Sender: TObject);
var
  I           : Integer;
  LPath       : String;
  LScriptName : String;
  LFolder     : TSSMFolder;
begin
  if (not SolutionExplorerViewer.CurrentNode_IsFolder) then
    Exit;

  LFolder := TSSMFolder(SolutionExplorerViewer.CurrentNode);
  LPath := LFolder.FullName;

  OpenDialogScript.InitialDir := LPath;
  OpenDialogScript.Options := OpenDialogScript.Options + [ofAllowMultiSelect];
  if OpenDialogScript.Execute then begin
    for I := 0 to OpenDialogScript.Files.Count-1 do begin
      LScriptName := OpenDialogScript.Files[I];
      if FileExists(LScriptName) then begin
        LScriptName := ExtractFileName(LScriptName);
        if not Assigned(LFolder.ScriptByName(LScriptName)) then
          LFolder.ScriptAddByShortName(LScriptName);
      end;
    end;

    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionScriptDeleteExecute(Sender: TObject);
var
  LMResult    : Integer;
  LScript     : TSSMScript;
begin
  if not SolutionExplorerViewer.CurrentNode_IsScript then
    Exit;

  LMResult := MessageDlg(CMessage_DeleteFromDisk, mtConfirmation, mbYesNoCancel, 0);
  if LMResult = mrCancel then
    Exit;

  LScript := TSSMScript(SolutionExplorerViewer.CurrentNode);
  try
    SolutionExplorerViewer.CurrentTreeListNode.Delete;
    LScript.Delete(LMResult = mrYes);
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionScriptNewExecute(Sender: TObject);
var
  LPath       : String;
  LScriptName : String;
  LFolder     : TSSMFolder;
begin
  if (not SolutionExplorerViewer.CurrentNode_IsFolder) then
    Exit;

  LFolder := TSSMFolder(SolutionExplorerViewer.CurrentNode);
  LPath := LFolder.FullName;

  OpenDialogScript.InitialDir := LPath;
  OpenDialogScript.Options := OpenDialogScript.Options - [ofAllowMultiSelect];
  if OpenDialogScript.Execute then begin
    LPath := OpenDialogScript.FileName;
    CreateIfNotExistsFile(LPath);

    LScriptName := ExtractFileName(LPath);
    LFolder.ScriptAddByShortName(LScriptName);

    RefreshSolutionExplorer;
  end;

end;

procedure TMainForm.ActionSolutionCloseExecute(Sender: TObject);
var
  LResult : TModalResult;
begin
  if SolutionExplorerViewer.DataChangedList.Count > 0 then begin
    LResult := MessageDlg(CMessage_SaveChanges, mtConfirmation, mbYesNoCancel, 0);
    if LResult = mrCancel then
      Abort;
    if LResult = mrYes then
      if (not ActionFileSaveAll.Execute) then
        Abort;
  end;
  MainDataModule.CloseSolution;

  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionSolutionNewExecute(Sender: TObject);
begin
  if Assigned(CurrentSolution) then
    ActionSolutionClose.Execute;

  if SaveDialogSolution.Execute then
    MainDataModule.NewSolution(False, SaveDialogSolution.FileName);

  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionSolutionOpenExecute(Sender: TObject);
begin
  if Assigned(CurrentSolution) then
    ActionSolutionClose.Execute;

  if OpenDialogSolution.Execute then
    MainDataModule.LoadSolution(OpenDialogSolution.FileName);

  RefreshSolutionExplorer;
end;

procedure TMainForm.ActionSourceDeleteExecute(Sender: TObject);
var
  LMResult    : Integer;
  LSource     : TSSMSource;
begin
  if not SolutionExplorerViewer.CurrentNode_IsSource then
    Exit;

  LMResult := MessageDlg(CMessage_ConfigmDeleteSource, mtConfirmation, mbYesNoCancel, 0);
  if LMResult in [mrCancel, mrNo] then begin
    RefreshSolutionExplorer;
    Exit;
  end;

  LSource := TSSMSource(SolutionExplorerViewer.CurrentNode);
  try
    SolutionExplorerViewer.CurrentTreeListNode.Delete;
    LSource.Delete;
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionSourceDisconnectExecute(Sender: TObject);
var
  LSource     : TSSMSource;
begin
  if not SolutionExplorerViewer.CurrentNode_IsSource then
    Exit;

  LSource := TSSMSource(SolutionExplorerViewer.CurrentNode);
  try
    LSource.Disconnect;
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionSourceEditExecute(Sender: TObject);
var
  LSource     : TSSMSource;
begin
  if not SolutionExplorerViewer.CurrentNode_IsSource then
    Exit;

  LSource := TSSMSource(SolutionExplorerViewer.CurrentNode);
  try
    LSource.Disconnect;
    LSource.LoginPrompt := True;
    LSource.Connect;
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionSourceNewExecute(Sender: TObject);
var
  LConnection       : TUniConnection;
  LProject          : TSSMProject;
  LSource           : TSSMSource;
  LLoginPrompt      : Boolean;

  LServer           : String;
  LDatabase         : String;
  LUser             : String;
  LPassword         : String;
  LAuthentication   : String;
begin
  if not SolutionExplorerViewer.CurrentNode_IsProject then
    Exit;
  LProject := TSSMProject(SolutionExplorerViewer.CurrentNode);

  LConnection := TUniConnection.Create(nil);
  try
    LConnection.ProviderName := CConnection_Provider;
    LConnection.SpecificOptions.Values[CConnection_MSSQL_Authentication] := CConnection_MSSQL_Win;
    LConnection.Connect;
    if LConnection.Connected then begin
      LServer := LConnection.Server;
      LDatabase := LConnection.Database;
      LAuthentication := LConnection.SpecificOptions.Values[CConnection_MSSQL_Authentication];
      if LAuthentication = CConnection_MSSQL_Win then
        LUser := ''
      else begin
        LUser := LConnection.Username;
        LPassword := LConnection.Password;
      end;

      if not Assigned(LProject.SourceByParams(LServer, LDatabase)) then begin
        LSource := LProject.SourceNew;
        LSource.Connected := False;
        LLoginPrompt := LSource.LoginPrompt;
        try
          LSource.LoginPrompt := False;
          LSource.Server := LServer;
          LSource.Database := LDatabase;
          LSource.User := LUser;
          LSource.Password := LPassword;
          LSource.IsWinAuthentication := (LAuthentication = CConnection_MSSQL_Win);
          LSource.Connect;
        finally
          LSource.LoginPrompt := LLoginPrompt;
        end;
      end else
        MessageDlg('“‡ÍÓÈ ËÒÚÓ˜ÌËÍ ÛÊÂ ÂÒÚ¸!', mtError, [mbOK], 0);
    end;

  finally
    LConnection.Free;
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.ActionSource—onnectExecute(Sender: TObject);
var
  LSource     : TSSMSource;
begin
  if not SolutionExplorerViewer.CurrentNode_IsSource then
    Exit;

  LSource := TSSMSource(SolutionExplorerViewer.CurrentNode);
  try
    LSource.LoginPrompt := True;
    LSource.Connect;
  finally
    RefreshSolutionExplorer;
  end;
end;

procedure TMainForm.CheckSaveCurrentSolution;
begin
  if not CurrentSolution.Changed then
    Exit;

  if CurrentSolution.IsNew then
    SaveAsCurrentSolution
  else
    CurrentSolution.Save;

  RefreshSolutionExplorer;
end;

procedure TMainForm.CheckSavePatch(APatch: TSSMPatch);
begin
  if not APatch.Changed then
    Exit;

  if APatch.IsNew then
    SaveAsPatch(APatch)
  else
    APatch.Save;
end;

procedure TMainForm.CheckSavePatches;
var
  N, I : Integer;
begin
  N := CurrentSolution.PatchesCount - 1;
  for I := 0 to N do
    CheckSavePatch(CurrentSolution.Patches[I]);
end;

procedure TMainForm.CheckSaveProject(AProject: TSSMProject);
begin
  if not AProject.Changed then
    Exit;

  if AProject.IsNew then
    SaveAsProject(AProject)
  else
    AProject.Save;
end;

procedure TMainForm.CheckSaveProjects;
var
  N, I : Integer;
begin
  N := CurrentSolution.ProjectsCount - 1;
  for I := 0 to N do
    CheckSaveProject(CurrentSolution.Projects[I]);
end;

procedure TMainForm.SaveAsCurrentSolution;
begin
  SaveDialogSolution.InitialDir := CurrentSolution.Path;
  SaveDialogSolution.FileName := CurrentSolution.FileName;
  if SaveDialogSolution.Execute then begin
    CurrentSolution.SaveTo(SaveDialogSolution.FileName);
  end;
end;

procedure TMainForm.SaveAsPatch(APatch: TSSMPatch);
begin
  SaveDialogPatch.InitialDir := APatch.Path;
  SaveDialogPatch.FileName := APatch.FileName;
  if SaveDialogPatch.Execute then begin
    APatch.SaveTo(SaveDialogPatch.FileName);
  end;
end;

procedure TMainForm.SaveAsProject(AProject: TSSMProject);
begin
  SaveDialogProject.InitialDir := AProject.Path;
  SaveDialogProject.FileName := AProject.FileName;
  if SaveDialogProject.Execute then begin
    AProject.SaveTo(SaveDialogProject.FileName);
  end;
end;

function TMainForm.ShowFormByNode(ANode: TSSMNode): TForm;
begin
  Result := TSSMBaseForm(Self.ActiveMDIChild);
  if  Assigned(Result) and Result.InheritsFrom(TSSMBaseForm)
  and (TSSMBaseForm(Result).LinkedNode = ANode) then begin
    Result.BringToFront;
  end else
    Result := nil;
end;

procedure TMainForm.SolutionExplorerCustomDrawDataCell(
  Sender: TcxCustomTreeList; ACanvas: TcxCanvas;
  AViewInfo: TcxTreeListEditCellViewInfo; var ADone: Boolean);
var
  LSSMNode : TSSMNode;
  LForm    : TSSMBaseForm;
begin
  LSSMNode := AViewInfo.Node.Data;
  LForm := TSSMBaseForm(Self.ActiveMDIChild);
  if AViewInfo.Focused then begin
    // -- ËÌ‚ÂÚËÛÂÏ
    ACanvas.Font.Color := clWindow;
    ACanvas.Brush.Color := clWindowText;
  end else if Assigned(LSSMNode) and LSSMNode.InheritsFrom(TSSMNode) then begin
    if Assigned(LForm) and LSSMNode.InheritsFrom(TSSMBaseForm) then begin
      if (LForm.LinkedNode = LSSMNode) then begin
        // -- ÔÓ‰Ò‚ÂÚÍ‡
        ACanvas.Font.Color := clHighlightText;
      end;
    end;
  end;
end;

procedure TMainForm.SolutionExplorerEdited(Sender: TcxCustomTreeList;
  AColumn: TcxTreeListColumn);
begin
  SolutionExplorer.OptionsData.Editing := False;
end;

procedure TMainForm.SolutionExplorerEditValueChanged(Sender: TcxCustomTreeList; AColumn: TcxTreeListColumn);
begin
  //
end;

procedure TMainForm.SolutionExplorerFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  RefreshSolutionActions;
end;

procedure TMainForm.SolutionExplorerResize(Sender: TObject);
begin
  SolutionExplorer.Columns[0].Width := SolutionExplorer.Width - 4;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FClosing := True;
  SolutionExplorer.Clear;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  SaveDialogSolution.DefaultExt := CFileExt_Solution;
  OpenDialogSolution.DefaultExt := CFileExt_Solution;
  SaveDialogSolution.Filter := CFileFilter_Solution;
  OpenDialogSolution.Filter := CFileFilter_Solution;

  SaveDialogProject.DefaultExt := CFileExt_Project;
  OpenDialogProject.DefaultExt := CFileExt_Project;
  SaveDialogProject.Filter := CFileFilter_Project;
  OpenDialogProject.Filter := CFileFilter_Project;

  SaveDialogPatch.DefaultExt := CFileExt_Patch;
  OpenDialogPatch.DefaultExt := CFileExt_Patch;
  SaveDialogPatch.Filter := CFileFilter_Patch;
  OpenDialogPatch.Filter := CFileFilter_Patch;

  OpenDialogScript.DefaultExt := CFileExt_Script;
  SaveDialogOutput.Filter := CFileFilter_Script;

  SaveDialogOutput.DefaultExt := CFileExt_Script;
  SaveDialogOutput.Filter := CFileFilter_Script;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
{
  if not Assigned(CurrentSolution) then
    ActionSolutionNew.Execute;
}
  RefreshSolutionExplorer;
end;

function TMainForm.GetCurrentSolution: TSSMSolution;
begin
  Result := MainDataModule.CurrentSolution;
end;

procedure TMainForm.RefreshSolutionActions;

  procedure _ActionsVisibleByEnabled(Actions: Array of TAction);
  var
    LAction : TAction;
  begin
    for LAction in Actions do
      LAction.Visible := LAction.Enabled;
  end;

var
  LIsSolution : Boolean;
  LIsProject  : Boolean;
  LIsPatch    : Boolean;
  LIsFolder   : Boolean;
  LIsFilter   : Boolean;
  LIsSource   : Boolean;
  LIsScript   : Boolean;
  LIsInput    : Boolean;
  LIsOutput   : Boolean;
begin
  if FClosing then
    Exit;

  LIsSolution := SolutionExplorerViewer.CurrentNode_IsSolution;
  LIsProject := SolutionExplorerViewer.CurrentNode_IsProject;
  LIsPatch := SolutionExplorerViewer.CurrentNode_IsPatch;
  LIsFolder := SolutionExplorerViewer.CurrentNode_IsFolder;
  LIsFilter := SolutionExplorerViewer.CurrentNode_IsFilter;
  LIsSource := SolutionExplorerViewer.CurrentNode_IsSource;
  LIsScript := SolutionExplorerViewer.CurrentNode_IsScript;
  LIsInput := SolutionExplorerViewer.CurrentNode_IsInput;
  LIsOutput := SolutionExplorerViewer.CurrentNode_IsOutput;

  ActionFileSaveAll.Enabled := Assigned(SolutionExplorerViewer.DataChangedList)
                           and (SolutionExplorerViewer.DataChangedList.Count > 0);

  ActionFileSave.Enabled := Assigned(SolutionExplorerViewer.CurrentNode)
                        and SolutionExplorerViewer.CurrentNode.InheritsFrom(TSSMNodeStoreInFile)
                        and TSSMNodeStoreInFile(SolutionExplorerViewer.CurrentNode).Changed;

  ActionFileSaveAs.Enabled := Assigned(SolutionExplorerViewer.CurrentNode)
                          and SolutionExplorerViewer.CurrentNode.InheritsFrom(TSSMNodeStoreInFile);

  ActionSolutionRename.Enabled := LIsSolution;

  ActionProjectNew.Enabled := LIsSolution;
  ActionProjectAdd.Enabled := LIsSolution;
  ActionProjectDelete.Enabled := LIsProject;
  ActionProjectRename.Enabled := LIsProject;

  ActionPatchNew.Enabled := LIsSolution;
  ActionPatchAdd.Enabled := LIsSolution;
  ActionPatchDelete.Enabled := LIsPatch;
  ActionPatchRename.Enabled := LIsPatch;

  ActionFolderNew.Enabled := LIsProject or LIsFolder;
  ActionFolderAdd.Enabled := LIsProject or LIsFolder;
  ActionFolderDelete.Enabled := LIsFolder;
  ActionFolderRename.Enabled := LIsFolder;

  ActionScriptNew.Enabled := LIsFolder;
  ActionScriptAdd.Enabled := LIsFolder;
  ActionScriptDelete.Enabled := LIsScript;
  ActionScriptRename.Enabled := LIsScript;

  ActionSourceNew.Enabled := LIsProject;
  ActionSourceEdit.Enabled := LIsSource;
  ActionSourceDelete.Enabled := LIsSource;

  if LIsSource then begin
    ActionSource—onnect.Enabled := not TSSMSource(SolutionExplorerViewer.CurrentNode).Connected;
    ActionSourceDisconnect.Enabled := not ActionSource—onnect.Enabled;
  end else begin
    ActionSource—onnect.Enabled := False;
    ActionSourceDisconnect.Enabled := False;
  end;

  ActionFilterEdit.Enabled := LIsFilter or LIsFolder;
  ActionFilterClear.Enabled := LIsFilter or (LIsFolder and Assigned(TSSMFolder(SolutionExplorerViewer.CurrentNode).Filter));

  ActionFileCloseAll.Enabled := Assigned(CurrentSolution);
  ActionFileClose.Enabled := Assigned(SolutionExplorerViewer.CurrentNode);

  ActionOutputNew.Enabled := LIsPatch;
  ActionOutputDelete.Enabled := LIsOutput;
  ActionOutputRename.Enabled := LIsOutput;

  ActionInputAdd.Enabled := LIsOutput;
  ActionInputDelete.Enabled := LIsInput;
  ActionInputUp.Enabled := LIsInput;
  ActionInputDown.Enabled := LIsInput;
  ActionInputFirst.Enabled := LIsInput;
  ActionInputLast.Enabled := LIsInput;

  _ActionsVisibleByEnabled
  (
    [
      ActionSolutionRename,
      ActionProjectNew, ActionProjectAdd, ActionProjectDelete, ActionProjectRename,
      ActionPatchNew, ActionPatchAdd, ActionPatchDelete, ActionPatchRename,
      ActionFolderNew, ActionFolderAdd, ActionFolderDelete, ActionFolderRename,
      ActionScriptNew, ActionScriptAdd, ActionScriptDelete, ActionScriptRename,
      ActionSourceNew, ActionSourceEdit, ActionSourceDelete,
      ActionSource—onnect, ActionSourceDisconnect,
      ActionFilterEdit, ActionFilterClear,

      ActionOutputNew, ActionOutputDelete, ActionOutputRename,
      ActionInputAdd, ActionInputDelete,
        ActionInputUp, ActionInputDown, ActionInputFirst, ActionInputLast
    ]
  );
end;

procedure TMainForm.RefreshSolutionExplorer;
begin
  if FClosing then
    Exit;

  SolutionExplorerViewer.Refresh;
  RefreshSolutionActions;
end;

procedure TMainForm.MainItemEditUndoClick(Sender: TObject);
var
  LForm       : TSSMBaseForm;
  LVariants   : TNamedVariants;
begin
  LVariants := TNamedVariants.Create([]);
  LForm := TSSMBaseForm.Create(Self, LVariants);
  LForm.Show;
end;

procedure TMainForm.MainItemFileExitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TMainForm.MenuItemFileSaveClick(Sender: TObject);
begin
  if SolutionExplorerViewer.CurrentNode_IsProject then
    CheckSaveProject( TSSMProject(SolutionExplorerViewer.CurrentNode) );

  if SolutionExplorerViewer.CurrentNode_IsPatch then
    CheckSavePatch( TSSMPatch(SolutionExplorerViewer.CurrentNode) );

  if SolutionExplorerViewer.CurrentNode_IsSolution then
    CheckSaveCurrentSolution;
end;

end.

