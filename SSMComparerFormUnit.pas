unit SSMComparerFormUnit;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,

  Winapi.Windows,
  Winapi.ShellAPI,
  Winapi.Messages,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Menus,
  Vcl.ActnList,

  Data.DB,
  MemDS,
  VirtualTable,

  LayoutPanel,

  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxGroupBox, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxCheckBox,
  cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu, cxInplaceContainer,
  cxTLData, cxButtons, cxFilter, cxData, cxGrid, cxDataStorage,
  cxNavigator, cxDBData, cxGridLevel, cxClasses, cxDBTL, cxSplitter,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,

  SSMBaseFormUnit,
  MainDataModuleUnit,
  NamedVariables,
  SBaseVariantFunctions, dxBar, DBAccess, Uni, cxUserCheckBox, FieldDataLink;

type
  TSSMComparerForm = class(TSSMBaseForm)
    ObjectsSourcesPanel: TGroupPanel;
    ObjectsSourcesGroupBox: TcxLayoutGroupBox;
    ParamsDataSet: TVirtualTable;
    ObjectsSourcesDataSet: TVirtualTable;
    ParamsDataSource: TDataSource;
    ObjectsSourcesDataSource: TDataSource;
    ScriptsPanel: TGroupPanel;
    PanelButtons: TGroupPanel;
    OkButton: TcxButton;
    ScriptsGroupBox: TcxLayoutGroupBox;
    ScriptsTree: TcxDBTreeList;
    ErrorsPanel: TGroupPanel;
    ErrosSplitter: TcxSplitter;
    ErrorsGroupBox: TcxLayoutGroupBox;
    ScriptsDataSet: TVirtualTable;
    ErrorsGridDBTableView: TcxGridDBTableView;
    ErrorsGridLevel: TcxGridLevel;
    ErrorsGrid: TcxGrid;
    ErrorsDataSet: TVirtualTable;
    ScriptsDataSource: TDataSource;
    ErrorsDataSource: TDataSource;
    ErrorsColumnScript: TcxGridDBColumn;
    ErrorsColumnMessage: TcxGridDBColumn;
    ErrorsColumnSelected: TcxGridDBColumn;
    ActionRun: TAction;
    RunButton: TcxButton;
    FormItemRun: TdxBarButton;
    WorkSourcePanel: TLayoutPanel;
    WorkSourceCombo: TcxDBLookupComboBox;
    ObjectsSourcePanel: TLayoutPanel;
    ObjectsSourceCombo: TcxDBLookupComboBox;
    OptoinsSplitter: TcxSplitter;
    OptionsGroupBox: TcxLayoutGroupBox;
    OptionScanSubFoldersPanel: TLayoutPanel;
    OptionScanSubFoldersCheckBox: TcxDBUserCheckBox;
    ScriptsTreeSelectedColumn: TcxDBTreeListColumn;
    ScriptsTreeNodeNameColumn: TcxDBTreeListColumn;
    ScriptsTreeActionColumn: TcxDBTreeListColumn;
    ScriptsSelectController: TFieldDataLinkController;
    ScriptsTreeNodeTypeColumn: TcxDBTreeListColumn;
    OptionIgnoreNonParsedScriptsPanel: TLayoutPanel;
    OptionIgnoreNonParsedScriptsCheckBox: TcxDBUserCheckBox;
    FormBarManagerBar1: TdxBar;
    FormItemScriptsSelectAll: TdxBarButton;
    ActionSelectAll: TAction;
    ActionUnSelectAll: TAction;
    FormItemScriptsUnSelectAll: TdxBarButton;
    ActionCompare1: TAction;
    ActionCompare2: TAction;
    ActionDeleteFromError: TAction;
    ActionErrorsSelectAll: TAction;
    ActionErrorsUnSelectAll: TAction;
    FormItemCompare1: TdxBarButton;
    FormItemComapre2: TdxBarButton;
    FormItemErrorsSelectAll: TdxBarButton;
    FormItemErrorUnSelectAll: TdxBarButton;
    ActionDeleteAllFromErrors: TAction;
    FormItemDeleteFromError: TdxBarButton;
    FormItemDeleteAllFromErrors: TdxBarButton;
    ActionScriptsUpdate: TAction;
    FormItemScriptsUpdate: TdxBarButton;
    procedure ActionRunExecute(Sender: TObject);
    procedure ScriptsSelectControllerFieldChanged(Sender: TObject);
    procedure ActionSelectAllExecute(Sender: TObject);
    procedure ActionUnSelectAllExecute(Sender: TObject);
    procedure ActionCompare1Execute(Sender: TObject);
    procedure ActionCompare2Execute(Sender: TObject);
    procedure ScriptsTreeFocusedNodeChanged(Sender: TcxCustomTreeList;
      APrevFocusedNode, AFocusedNode: TcxTreeListNode);
    procedure ErrorsGridDBTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure FormShow(Sender: TObject);
    procedure ActionErrorsSelectAllExecute(Sender: TObject);
    procedure ActionErrorsUnSelectAllExecute(Sender: TObject);
    procedure ActionDeleteFromErrorExecute(Sender: TObject);
    procedure ActionDeleteAllFromErrorsExecute(Sender: TObject);
    procedure ActionScriptsUpdateExecute(Sender: TObject);
  private
    FLastRowId                : Integer;
    FIgnoreSelectFieldChanged : Boolean;

  protected
    function ParamToSSNNode(AParamName : String): TSSMNode;

    function AddFolderRow(AParentRowId: Variant; AFolderName : String): Integer;
    function AddScriptRow(AParentRowId: Variant; AScript, AScriptFulLName, AScriptInSource, AObjectName, AA�tion: String; ASourceNode, AWorkNode: TSSMNode): Integer;
    function AddErrorRow(AScript, AObjectName, AErrorCode, AMessage: String; ANode : TSSMNode): Integer;

    procedure Compare_Nodes(AParentRowId: Variant; ASourceNode, AWorkNode: TSSMNode);
    procedure Compare_SourceToSource(AParentRowId: Variant; AObjectsSource : TSSMSource; AWorkSource : TSSMSource);
    procedure Compare_SourceToFodler(AParentRowId: Variant; ASource : TSSMSource; AFolder : TSSMFolder);
    procedure Compare_FolderToFodler(AParentRowId: Variant; AObjectsFolder : TSSMFolder; AFolder : TSSMFolder);

    procedure ExecuteComparer(AAppSettingName : String; AParamsSettingName: String);
    function GetRowId : Integer;

    procedure CheckShowErrors;
    procedure CheckActionUpdate;
  public
    constructor Create(AOwner : TComponent; AParams : TNamedVariants); override;
    procedure RefreshActions;
  end;

implementation

uses
  SBaseFileUtils,
  SSMSolutionExplorer;

const
  CTreeNodeType_Directory       : String = 'D';
  CTreeNodeType_Script          : String = 'S';

  CSourceType_Project           : String = '<P>';  // Project
  CSourceType_Source            : String = '<S>';  // Source
  CSourceType_Folder            : String = '<F>';  // Folder

  CNodeAction_UpdateScript      : String = 'UPDATE';
  CNodeAction_DeleteScript      : String = 'DELETE';
  CNodeAction_NewScript         : String = 'NEW';
  CNodeAction_AddScript         : String = 'ADD';
  CNodeAction_AddUpdateScript   : String = 'ADD+UPDATE';

  CError_NotParsedObjectName    : String = '��� ���������� ��� SQL-�������';
  CError_NotFoundObjectInSource : String = '��� � �������';
  CError_NotFoundObjectInWork   : String = '��� � ������� �����';


  CField_Selected               : String = 'Selected';
  CField_Source_Ptr             : String = 'Source_Ptr';
  CField_Work_Ptr               : String = 'Work_Ptr';
  CField_ScanSubFolders         : String = 'ScanSubFolders';

  CField_NodeType               : String = 'NodeType';


procedure UpdateAllDataSet(ADataSet : TDataSet; AFieldName: String; AValue : Variant);
var
  LBookmark : TBookmark;
begin
  ADataSet.DisableControls;
  try
    LBookmark := ADataSet.GetBookmark;
    try
      ADataSet.First;
      while (not ADataSet.Eof) do begin
        ADataSet.Edit;
        ADataSet.FieldValues[AFieldName] := AValue;
        ADataSet.Next;
      end;
    finally
      ADataSet.GotoBookmark(LBookmark);
    end;
  finally
    ADataSet.EnableControls;
  end;
end;

{$R *.dfm}

{ TSSMComparerForm }

procedure TSSMComparerForm.ActionCompare1Execute(Sender: TObject);
begin
  inherited;
  ExecuteComparer(CSettingValue_CompererApp1, CSettingValue_CompererParams1);
end;

procedure TSSMComparerForm.ActionCompare2Execute(Sender: TObject);
begin
  inherited;
  ExecuteComparer(CSettingValue_CompererApp2, CSettingValue_CompererParams2);
end;

procedure TSSMComparerForm.ActionDeleteAllFromErrorsExecute(Sender: TObject);
begin
  inherited;
  //
end;

procedure TSSMComparerForm.ActionDeleteFromErrorExecute(Sender: TObject);
begin
  inherited;
  //
end;

procedure TSSMComparerForm.ActionErrorsSelectAllExecute(Sender: TObject);
begin
  inherited;
  UpdateAllDataSet(ErrorsDataSet, CField_Selected, True);
end;

procedure TSSMComparerForm.ActionErrorsUnSelectAllExecute(Sender: TObject);
begin
  inherited;
  UpdateAllDataSet(ErrorsDataSet, CField_Selected, False);
end;

procedure TSSMComparerForm.ActionRunExecute(Sender: TObject);
var
  LNodeSource : TSSMNode;
  LNodeWork   : TSSMNode;
begin
  try
    ScriptsDataSet.DisableControls;
    ErrorsDataSet.DisableControls;
    try
      ScriptsDataSet.Clear;
      ErrorsDataSet.Clear;

      LNodeSource := ParamToSSNNode(CField_Source_Ptr);
      LNodeWork := ParamToSSNNode(CField_Work_Ptr);
      Compare_Nodes(Null, LNodeSource, LNodeWork);

    finally
      ScriptsDataSet.EnableControls;
      ErrorsDataSet.EnableControls;
    end;
  finally
    CheckShowErrors;
    CheckActionUpdate;
  end;
end;

procedure TSSMComparerForm.ActionScriptsUpdateExecute(Sender: TObject);
var
  LNodeSource     : TSSMNode;
  LNodeWork       : TSSMNode;
  LDefinition     : TStrings;
  LObjectName     : String;
  LSourceScript   : String;
  LBookmark       : TBookmark;
  LScriptName     : String;
  LScriptFullName : String;

  LAction         : String;

  procedure _AddScriptToWorkNode;
  begin
    LNodeWork :=  TSSMNode(Pointer( Integer(IsNull(ScriptsDataSet.FieldValues['WorkSourceNode_Ptr'], 0))));
    if Assigned(LNodeWork) and (LNodeWork.InheritsFrom(TSSMFolder)) then begin
      LScriptName := ScriptsDataSet.FieldValues['Script'];
      if not Assigned(TSSMFolder(LNodeWork).ScriptByName(LScriptName)) then
        TSSMFolder(LNodeWork).ScriptAddByShortName(LScriptName);
    end;
  end;

begin
  LNodeSource := ParamToSSNNode(CField_Source_Ptr);

  SolutionExplorerViewer.BeginUpdate;
  try
    ScriptsDataSet.DisableControls;
    LDefinition := TStringList.Create;
    try
      LBookmark := ScriptsDataSet.GetBookmark;
      try
        ScriptsDataSet.First;
        while (not ScriptsDataSet.Eof) do begin
          if  VarIsEqual(ScriptsDataSet.FieldValues[CField_Selected], True)
          and VarIsEqual(ScriptsDataSet.FieldValues[CField_NodeType], CTreeNodeType_Script) then begin
            LAction := ScriptsDataSet.FieldValues['Action'];
            if (LAction = CNodeAction_UpdateScript)
            or (LAction = CNodeAction_AddUpdateScript)
            or (LAction = CNodeAction_NewScript) then begin
              if LNodeSource.InheritsFrom(TSSMSource) then begin
                // �� �� ���� �������� ����������
                LObjectName := ScriptsDataSet.FieldValues['ObjectName'];
                LScriptFullName := ScriptsDataSet.FieldValues['ScriptFullName'];
                LDefinition.Clear;
                TMainDataModule.LoadDefinition_FromSource(TSSMSource(LNodeSource).Connection, LObjectName, LDefinition);
                LDefinition.SaveToFile(LScriptFullName);
                if (LAction = CNodeAction_NewScript) then
                  _AddScriptToWorkNode;
              end else if LNodeSource.InheritsFrom(TSSMFolder) then begin
                // ��� �����-����������
                LSourceScript := ScriptsDataSet.FieldValues['ScriptInSource'];
                LScriptFullName := ScriptsDataSet.FieldValues['ScriptFullName'];
                if FileExists(LSourceScript) then
                  CopyFile(PWideChar(LSourceScript), PWideChar(LScriptFullName), False);
              end;
            end else if (LAction = CNodeAction_AddScript) then begin
              _AddScriptToWorkNode;
            end;

            ScriptsDataSet.Delete;
          end else
            ScriptsDataSet.Next;
        end;
      finally
        ScriptsDataSet.GotoBookmark(LBookmark);
      end;
    finally
      LDefinition.Free;
      ScriptsDataSet.EnableControls;
      CheckActionUpdate;
    end;
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;

procedure TSSMComparerForm.ActionSelectAllExecute(Sender: TObject);
begin
  UpdateAllDataSet(ScriptsDataSet, CField_Selected, True);
  CheckActionUpdate;
end;

procedure TSSMComparerForm.ActionUnSelectAllExecute(Sender: TObject);
begin
  UpdateAllDataSet(ScriptsDataSet, CField_Selected, False);
  CheckActionUpdate;
end;

function TSSMComparerForm.AddErrorRow(AScript, AObjectName, AErrorCode, AMessage: String; ANode : TSSMNode): Integer;
begin
  ErrorsDataSet.DisableControls;
  try
    if not ErrorsDataSet.Active then
      ErrorsDataSet.Open;

    ErrorsDataSet.Append;

    Result := GetRowId;
    ErrorsDataSet.FieldValues['RowId'] := Result;

    ErrorsDataSet.FieldValues['Script'] := AScript;
    ErrorsDataSet.FieldValues['ObjectName'] := AObjectName;
    ErrorsDataSet.FieldValues['ErrorCode'] := AErrorCode;
    ErrorsDataSet.FieldValues['Message'] := AMessage;

    ErrorsDataSet.FieldValues[CField_Selected] := False;

    ErrorsDataSet.FieldValues['Node_Ptr'] := Integer(Pointer( ANode ));

    ErrorsDataSet.Post;
  finally
    ErrorsDataSet.EnableControls;
  end;
end;

function TSSMComparerForm.AddFolderRow(AParentRowId: Variant; AFolderName: String): Integer;
begin
  ScriptsDataSet.DisableControls;
  try

    if not ScriptsDataSet.Active then
      ScriptsDataSet.Open;

    ScriptsDataSet.Append;
    ScriptsDataSet.FieldValues['IconIndex'] := CIconIndex_Folder;

    Result := GetRowId;
    ScriptsDataSet.FieldValues['RowId'] := Result;

    ScriptsDataSet.FieldValues['ParentRowId'] := AParentRowId;
    ScriptsDataSet.FieldValues['NodeName'] := AFolderName;
    ScriptsDataSet.FieldValues[CField_NodeType] := CTreeNodeType_Directory;
    ScriptsDataSet.FieldValues[CField_Selected] := False;

    ScriptsDataSet.Post;
  finally
    ScriptsDataSet.EnableControls;
  end;
end;

function TSSMComparerForm.AddScriptRow
(
  AParentRowId: Variant; AScript, AScriptFulLName, AScriptInSource, AObjectName, AA�tion: String;
  ASourceNode, AWorkNode: TSSMNode
): Integer;
var
  LIconIndex : Integer;
begin
  ScriptsDataSet.DisableControls;
  try
    if not ScriptsDataSet.Active then
      ScriptsDataSet.Open;

    ScriptsDataSet.Append;

    if AA�tion = CNodeAction_NewScript then
      LIconIndex := CIconIndex_ScriptNew
    else if AA�tion = CNodeAction_AddScript then
      LIconIndex := CIconIndex_ScriptAdd
    else if AA�tion = CNodeAction_AddUpdateScript then
      LIconIndex := CIconIndex_ScriptAddUpd
    else if AA�tion = CNodeAction_DeleteScript then
      LIconIndex := CIconIndex_ScriptDel
    else
      LIconIndex := CIconIndex_ScriptUpd;

    ScriptsDataSet.FieldValues['IconIndex'] := LIconIndex;

    Result := GetRowId;
    ScriptsDataSet.FieldValues['RowId'] := Result;

    ScriptsDataSet.FieldValues['ParentRowId'] := AParentRowId;
    ScriptsDataSet.FieldValues['NodeName'] := AScript;
    ScriptsDataSet.FieldValues[CField_NodeType] := CTreeNodeType_Script;
    ScriptsDataSet.FieldValues['Script'] := AScript;
    ScriptsDataSet.FieldValues['ScriptFullName'] := AScriptFullName;
    ScriptsDataSet.FieldValues['ScriptInSource'] := AScriptInSource;

    ScriptsDataSet.FieldValues['ObjectName'] := AObjectName;

    ScriptsDataSet.FieldValues['Action'] := AA�tion;
    ScriptsDataSet.FieldValues[CField_Selected] := False;

    ScriptsDataSet.FieldValues['SourceNode_Ptr'] := Integer( Pointer(ASourceNode) );
    ScriptsDataSet.FieldValues['WorkSourceNode_Ptr'] := Integer( Pointer(AWorkNode) );

    ScriptsDataSet.Post;
  finally
    ScriptsDataSet.EnableControls;
  end;
end;

procedure TSSMComparerForm.CheckActionUpdate;
var
  LBmk      : TBookmark;
begin
  ScriptsDataSet.DisableControls;
  LBmk := ScriptsDataSet.Bookmark;
  try
    ScriptsDataSet.First;
    while not ScriptsDataSet.Eof do begin
      if  VarIsEqual(ScriptsDataSet.FieldValues[CField_NodeType], CTreeNodeType_Script)
      and VarIsEqual(ScriptsDataSet.FieldValues[CField_Selected], True) then begin
        ActionScriptsUpdate.Enabled := True;
        Exit;
      end;
      ScriptsDataSet.Next;
    end;
    ActionScriptsUpdate.Enabled := False;
  finally
    if ScriptsDataSet.BookmarkValid(LBmk) then
      ScriptsDataSet.GotoBookmark(LBmk);
    ScriptsDataSet.EnableControls;
  end;
end;

procedure TSSMComparerForm.CheckShowErrors;
begin
  if ErrorsDataSet.RecordCount > 0 then begin
    ErrorsPanel.Show;
    ErrosSplitter.Show;
    ErrosSplitter.Top := ErrorsPanel.Top - ErrosSplitter.Height;
    PanelButtons.Top := ErrorsPanel.Top + ErrorsPanel.Height;
  end else begin
    ErrorsPanel.Hide;
    ErrosSplitter.Hide;
  end;
end;

procedure TSSMComparerForm.Compare_FolderToFodler(AParentRowId: Variant; AObjectsFolder, AFolder: TSSMFolder);
begin

end;

procedure TSSMComparerForm.Compare_Nodes(AParentRowId: Variant; ASourceNode, AWorkNode: TSSMNode);
var
  I         : Integer;
  LProject  : TSSMProject;
begin
  if ASourceNode.InheritsFrom(TSSMSource) and AWorkNode.InheritsFrom(TSSMSource) then
    Compare_SourceToSource(AParentRowId, TSSMSource(ASourceNode), TSSMSource(AWorkNode))
  else if ASourceNode.InheritsFrom(TSSMSource) and AWorkNode.InheritsFrom(TSSMFolder) then
    Compare_SourceToFodler(AParentRowId, TSSMSource(ASourceNode), TSSMFolder(AWorkNode))
  else if ASourceNode.InheritsFrom(TSSMFolder) and AWorkNode.InheritsFrom(TSSMFolder) then
    Compare_FolderToFodler(AParentRowId, TSSMFolder(ASourceNode), TSSMFolder(AWorkNode))
  else if ASourceNode.InheritsFrom(TSSMSource) and AWorkNode.InheritsFrom(TSSMProject) then begin
    LProject := TSSMProject(AWorkNode);
    for I := 0 to LProject.FoldersCount - 1 do
      Compare_SourceToFodler(AParentRowId, TSSMSource(ASourceNode), LProject.Folders[I]);
  end else
    raise ESSMStructureError.Create('������������ ���� ����� ��� ������� ���������!');
end;

procedure TSSMComparerForm.Compare_SourceToFodler(AParentRowId: Variant; ASource: TSSMSource; AFolder: TSSMFolder);
var
  I                 : Integer;
  LParentRowId      : Variant;
  LIsSourceFilter   : Boolean;
  LSourceObjects    : TStringList;
  LSourceGenScripts : TStringList;

  LScript           : TSSMScript;
  LScriptFullName   : String;
  LObjectName       : String;
  LObjectIndex      : Integer;

  LIsAddedFolder    : Boolean;
  LFolderName       : String;

  LDefinitionSource : TStringList;
  LDefinitionWork   : TStringList;

  procedure _CheckAddedFolder;
  begin
    if not LIsAddedFolder then begin
      // ���� ��� �� �������� �����, �� ���������
      if VarIsPresent(LParentRowId) then
        LFolderName := AFolder.Name
      else
        LFolderName := AFolder.FullName;
      LParentRowId := AddFolderRow(LParentRowId, LFolderName);
      LIsAddedFolder := True;
    end;
  end;

  function _LoadAndCompare(AScriptFullName : String; AAction : String): Boolean;
  begin
    Result := False;
    if TMainDataModule.LoadDefinition_FromSource(ASource.Connection, LObjectName, LDefinitionSource) then begin
      // ��������� Definition, ������ ����������
      if not TMainDataModule.IsStringsEqual(LDefinitionSource, LDefinitionWork) then begin
        // ���� ��������. ����� ���������� ������� ���� �������� �����, � ������� ������ ������� �����
        _CheckAddedFolder;
        // ��������� � ������ �������� ���������� ������
        AddScriptRow(LParentRowId, ExtractFileName(AScriptFullName), AScriptFullName, '', LObjectName, AAction, ASource, AFolder);
        Result := True;
      end;
    end;
  end;

begin
  LIsAddedFolder := False;
  LParentRowId := AParentRowId;

  LSourceObjects := TStringList.Create;
  LSourceGenScripts := TStringList.Create;
  LDefinitionSource := TStringList.Create;
  LDefinitionWork := TStringList.Create;
  try
    if not AFolder.IsEmptyFilter then begin
      LIsSourceFilter := True;
      TMainDataModule.LoadObjectsList(ASource.Connection, AFolder.Filter.WhereFilter, LSourceObjects, LSourceGenScripts);
    end else
      LIsSourceFilter := False;

    for I := 0 to AFolder.ScriptsCount - 1 do begin
      LScript := AFolder.Scripts[I];

      LDefinitionWork.Clear;
      if not FileExists(LScript.FullName) then begin
        AddErrorRow(LScript.FullName, LObjectName, 'NOT:FOUND', CError_NotFoundObjectInWork, LScript);
        Continue;
      end else if not TMainDataModule.LoadDefinition_FromScript(LScript.FullName, LObjectName, LDefinitionWork) then begin
        if not VarIsEqual(ParamsDataSet.FieldValues['IgnoreNonParsedScripts'], True) then
          AddErrorRow(LScript.FullName, LObjectName, 'NOT:PARSED', CError_NotParsedObjectName, LScript);
        Continue;
      end;

      if LIsSourceFilter then begin
        // ������ � ����������, � ������� ���� ������ -> ������ � ���� LSourceObjects
        LObjectIndex := LSourceObjects.IndexOf(LObjectName);
        if LObjectIndex < 0 then begin
          // ������ �� ������ � ������ �� �������; ���� - �������� �� ��������
          AddErrorRow(LScript.FullName, LObjectName, 'NOT:FOUND', CError_NotFoundObjectInSource, LScript);
        end else begin
          _LoadAndCompare(LScript.FullName, CNodeAction_UpdateScript);
          LSourceObjects.Delete(LObjectIndex);
          LSourceGenScripts.Delete(LObjectIndex);
        end;
      end else begin
        // ���� ��� �������, �� �������� �� ����������� ��������
        if TMainDataModule.CheckObjectExists_FromSource(ASource.Connection, LObjectName) then begin
          // ������ ���� � ��
          _LoadAndCompare(LScript.FullName, CNodeAction_UpdateScript);
        end else begin
          // ������ �� ������ � ��; ���� - �������� �� ��������
          AddErrorRow(LScript.FullName, LObjectName, 'NOT:FOUND', CError_NotFoundObjectInSource, LScript)
        end;
      end;
    end;

    if LIsSourceFilter and (LSourceObjects.Count > 0) then begin
      // ������ ���� �������� �� ���������� SQL-�������� � ������ LSourceObjects
      // �.�. �� �������� �� ���� ��, ��� ��������, �� �������� ��, ��� ���� ��� �������� �� �����
      _CheckAddedFolder;

      for I := 0 to LSourceObjects.Count - 1 do begin
        LScriptFullName := PathCheckDivver(AFolder.FullName) + LSourceGenScripts[I];
        if not FileExists(LScriptFullName) then begin
          // � �������� ������ �������
          AddScriptRow(LParentRowId, LSourceGenScripts[I], LScriptFullName, '',  LSourceObjects[I], CNodeAction_NewScript, ASource, AFolder);
        end else begin
          LDefinitionWork.Clear;
          if TMainDataModule.LoadDefinition_FromScript(LScriptFullName, LObjectName, LDefinitionWork) then begin
            // ���� ����� ����������
            if not _LoadAndCompare(LScriptFullName, CNodeAction_AddUpdateScript) then
              // � ���������� � ������ �������� ������������
              AddScriptRow(LParentRowId, LSourceGenScripts[I], LScriptFullName, '',  LSourceObjects[I], CNodeAction_AddScript, ASource, AFolder);
          end;
        end;
      end;
    end;

    // ���� ����������� ����� ���������� � ��������, ��
    if VarIsEqual(ParamsDataSet.FieldValues[CField_ScanSubFolders], True) then begin
      _CheckAddedFolder;
      for I := 0 to AFolder.FoldersCount-1 do begin
        if AFolder.Folders[I].ScriptsCount > 0 then
          Compare_SourceToFodler(LParentRowId, ASource, AFolder.Folders[I]);
      end;
    end;

  finally
    LSourceGenScripts.Free;
    LSourceObjects.Free;
    LDefinitionWork.Free;
    LDefinitionSource.Free;
  end;
end;

procedure TSSMComparerForm.Compare_SourceToSource(AParentRowId: Variant; AObjectsSource: TSSMSource; AWorkSource: TSSMSource);
begin

end;

constructor TSSMComparerForm.Create(AOwner: TComponent; AParams: TNamedVariants);

  function _ParamToSSNNode(AParamName : String): TSSMNode;
  var
    AVar : Variant;
  begin
    AVar := AParams.Values[AParamName];
    if VarIsPresent(AVar) then
      Result := TSSMNode( Pointer(Integer(AVar)) )
    else
      Result := nil;
  end;

  function _ObjectsSourcesAdd(ANode : TSSMNode): Boolean;
  begin
    if not VarIsPresent(ObjectsSourcesDataSet.Lookup('ObjectPtr', Integer(Pointer(ANode)), 'ObjectPtr')) then begin
      ObjectsSourcesDataSet.Append;
      ObjectsSourcesDataSet.FieldValues['ObjectPtr'] := Integer(Pointer(ANode));
      if ANode.InheritsFrom(TSSMFolder) then
        ObjectsSourcesDataSet.FieldValues['Name'] := TSSMFolder(ANode).FullName
      else
        ObjectsSourcesDataSet.FieldValues['Name'] := ANode.NodeText;

      if ANode.InheritsFrom(TSSMProject) then
        ObjectsSourcesDataSet.FieldValues['Type'] := CSourceType_Project
      else if ANode.InheritsFrom(TSSMSource) then
        ObjectsSourcesDataSet.FieldValues['Type'] := CSourceType_Source
      else if ANode.InheritsFrom(TSSMFolder) then
        ObjectsSourcesDataSet.FieldValues['Type'] := CSourceType_Folder;
      ObjectsSourcesDataSet.Post;
      Result := True;
    end else begin
      Result := False;
    end;
  end;

var
  LProject        : TSSMProject;

  LObjectsSource  : TSSMNode;
  LWorkSource     : TSSMNode;

  I               : Integer;
begin
  inherited Create(AOwner, AParams);

  FLastRowId := 0;

  if Assigned(LinkedNode) then
    Caption := '��������� :: ' + LinkedNode.NodeText;

  LProject := TSSMProject(_ParamToSSNNode(CParam_Project));
  LObjectsSource := TSSMProject(_ParamToSSNNode(CParam_ObjectsSource));
  LWorkSource := TSSMProject(_ParamToSSNNode(CParam_WorkSource));

  ParamsDataSet.DisableControls;
  ObjectsSourcesDataSet.DisableControls;
  try
    ParamsDataSet.Open;
    ParamsDataSet.Clear;
    ParamsDataSet.Append;
    ParamsDataSet.FieldValues[CField_ScanSubFolders] := IsNull(AParams.Values[CField_ScanSubFolders], True);
    ParamsDataSet.FieldValues['IgnoreNonParsedScripts'] := IsNull(AParams.Values['IgnoreNonParsedScripts'], True);

    ObjectsSourcesDataSet.Open;
    ObjectsSourcesDataSet.Clear;

    if Assigned(LObjectsSource) then begin
      _ObjectsSourcesAdd(LObjectsSource);
      ParamsDataSet.FieldValues[CField_Source_Ptr] := Integer(Pointer(LObjectsSource));
    end;
    if Assigned(LWorkSource) then begin
      _ObjectsSourcesAdd(LWorkSource);
      ParamsDataSet.FieldValues[CField_Work_Ptr] := Integer(Pointer(LWorkSource));
    end;

    if not Assigned(LProject) and Assigned(LObjectsSource) and LObjectsSource.InheritsFrom(TSSMSource) then
      LProject := TSSMSource(LObjectsSource).Project;
    if not Assigned(LProject) and Assigned(LObjectsSource) and LObjectsSource.InheritsFrom(TSSMFolder) then
      LProject := TSSMFolder(LObjectsSource).Project;

    if not Assigned(LProject) and Assigned(LWorkSource) and LWorkSource.InheritsFrom(TSSMSource) then
      LProject := TSSMSource(LWorkSource).Project;
    if not Assigned(LProject) and Assigned(LWorkSource) and LWorkSource.InheritsFrom(TSSMFolder) then
      LProject := TSSMFolder(LWorkSource).Project;

    if Assigned(LProject) then begin
      _ObjectsSourcesAdd(LProject);

      for I := 0 to LProject.SourcesCount-1 do
        _ObjectsSourcesAdd(LProject.Sources[I]);

      for I := 0 to LProject.FoldersCount-1 do
        _ObjectsSourcesAdd(LProject.Folders[I]);
    end;

    if not Assigned(LObjectsSource) and Assigned(LProject) and (LProject.SourcesCount = 1) then
      ParamsDataSet.FieldValues[CField_Source_Ptr] := Integer(Pointer(LProject.Sources[0]));

  finally
    ObjectsSourcesDataSet.EnableControls;
    ParamsDataSet.EnableControls;
  end;
end;

procedure TSSMComparerForm.ErrorsGridDBTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord; ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;
  RefreshActions;
end;

procedure TSSMComparerForm.ExecuteComparer(AAppSettingName, AParamsSettingName: String);

  function _UpdatesParamsFromSource(ASParams : String; ANumber: Integer; ASource: TSSMSource; AObjectName : String): String;
  var
    LDefinition     : TStrings;
    LTempFileName   : String;
  begin
    Result := ASParams;
    LDefinition := TStringList.Create;
    try
      TMainDataModule.LoadDefinition_FromSource(ASource.Connection, AObjectName,  LDefinition);
      LTempFileName := GetTempFile('sql');
      LDefinition.SaveToFile(LTempFileName);

      Result := Result.Replace('%file' + Integer.ToString(ANumber) + '%', LTempFileName);
      Result := Result.Replace('%title' + Integer.ToString(ANumber) + '%', '������ ' + AObjectName + ' � ��������� (' + ASource.NodeText + ') - ' + LTempFileName + ')');
    finally
      LDefinition.Free;
    end;
  end;

  function _UpdatesParamsFromScript(ASParams : String; ANumber: Integer; AScript: TSSMScript; AObjectName : String): String;
  begin
    Result := ASParams;
    Result := Result.Replace('%file' + Integer.ToString(ANumber) + '%', AScript.FullName);
    Result := Result.Replace('%title' + Integer.ToString(ANumber) + '%', AScript.Name + '; ������ ' + AObjectName);
  end;

  function _UpdatesParams(ASParams : String; ANumber: Integer; AScriptFullName: String; AObjectName : String): String;
  begin
    Result := ASParams;
    Result := Result.Replace('%file' + Integer.ToString(ANumber) + '%', AScriptFullName);
    Result := Result.Replace('%title' + Integer.ToString(ANumber) + '%', ExtractFileName(AScriptFullName) + '; ������ ' + AObjectName);
  end;

var
  LComparerApp    : Variant;
  LSComparer      : String;
  LComparerParams : Variant;
  LSParams        : String;
  LScriptFullName : Variant;
  LScriptInSource : Variant;

  LNode1          : TSSMNode;
  LNode2          : TSSMNode;

  LObjectName     : String;
  LPath           : String;
begin
  inherited;
  LScriptFullName := ScriptsDataSet.FieldValues['ScriptFullName'];
  LScriptInSource := ScriptsDataSet.FieldValues['ScriptInSource'];

  LComparerApp := MainDataModule.Settings[CSettingGroup_Comperers, AAppSettingName];
  if not VarIsPresent(LComparerApp) then
    Exit;
  LSComparer := LComparerApp;

  LComparerParams := MainDataModule.Settings[CSettingGroup_Comperers, AParamsSettingName];
  if not VarIsPresent(LComparerParams) then
    Exit;

  LSParams := LComparerParams;
  LObjectName := IsNull( ScriptsDataSet.FieldValues['ObjectName'], '');
  if LObjectName.IsEmpty then
    Exit;

  LNode1 := TSSMNode( Pointer(Integer( IsNull(ScriptsDataSet.FieldValues['SourceNode_Ptr'], 0) )) );
  LNode2 := TSSMNode( Pointer(Integer( IsNull(ScriptsDataSet.FieldValues['WorkSourceNode_Ptr'], 0) )) );

  LPath := ExtractFilePath(ApplicationExeName);

  if LNode1.InheritsFrom(TSSMSource) then begin
    LSParams := _UpdatesParamsFromSource(LSParams, 1, TSSMSource(LNode1), LObjectName);
  end else begin
    if not VarIsPresent(LScriptInSource) then
      Exit;
    LSParams := _UpdatesParams(LSParams, 1, LScriptInSource, LObjectName);
    LPath := ExtractFilePath(LScriptInSource);
  end;

  if LNode2.InheritsFrom(TSSMSource) then begin
    LSParams := _UpdatesParamsFromSource(LSParams, 2, TSSMSource(LNode2), LObjectName);
  end else begin
    if not VarIsPresent(LScriptFullName) then
      Exit;
    LSParams := _UpdatesParams(LSParams, 2, LScriptFullName, LObjectName);
    LPath := ExtractFilePath(LScriptFullName);
  end;

  Winapi.ShellAPI.ShellExecute
  (
    0,
    nil,
    PWideChar(LSComparer),
    PWideChar(LSParams),
    PWideChar(LPath),
    SW_SHOWNORMAL
  );
end;

procedure TSSMComparerForm.FormShow(Sender: TObject);
begin
  inherited;
  RefreshActions;
end;

function TSSMComparerForm.GetRowId: Integer;
begin
  Inc(FLastRowId);
  Result := FLastRowId;
end;

function TSSMComparerForm.ParamToSSNNode(AParamName: String): TSSMNode;
var
  AVar : Variant;
begin
  AVar := ParamsDataSet.FieldValues[AParamName];
  if VarIsPresent(AVar) then
    Result := TSSMNode( Pointer(Integer(AVar)) )
  else
    Result := nil;
end;

procedure TSSMComparerForm.RefreshActions;
var
  LNodeType : Variant;
begin
  if ScriptsTree.Root.Count > 0 then begin
    if not Assigned(ScriptsTree.FocusedNode) then begin
      LNodeType := Null;
    end else begin
      LNodeType := ScriptsTree.FocusedNode.Values[ScriptsTreeNodeTypeColumn.ItemIndex];
    end;

    ActionSelectAll.Enabled := True;
    ActionUnSelectAll.Enabled := True;

    ActionCompare1.Enabled := VarIsEqual(LNodeType, 'S');
    ActionCompare2.Enabled := ActionCompare1.Enabled;
  end else begin
    ActionSelectAll.Enabled := False;
    ActionUnSelectAll.Enabled := False;
    ActionCompare1.Enabled := False;
    ActionCompare2.Enabled := False;
  end;

  if ErrorsGridDBTableView.ViewData.RecordCount > 0 then begin
    ActionErrorsSelectAll.Enabled := True;
    ActionErrorsUnSelectAll.Enabled := True;

    ActionDeleteFromError.Enabled := True;
    ActionDeleteAllFromErrors.Enabled := True;
  end else begin
    ActionErrorsSelectAll.Enabled := False;
    ActionErrorsUnSelectAll.Enabled := False;

    ActionDeleteFromError.Enabled := False;
    ActionDeleteAllFromErrors.Enabled := False;
  end;
end;

procedure TSSMComparerForm.ScriptsSelectControllerFieldChanged(Sender: TObject);

  procedure _SetChildrenSelected(AParentRowId : Integer; ASelected: Boolean);
  var
    LBookmark : TBookmark;
  begin
    ScriptsDataSet.DisableControls;
    try
      LBookmark := ScriptsDataSet.GetBookmark;
      ScriptsDataSet.First;
      while not ScriptsDataSet.Eof do begin
        if VarIsEqual(AParentRowId, ScriptsDataSet.FieldValues['ParentRowId']) then begin
          ScriptsDataSet.Edit;
          ScriptsDataSet.FieldValues[CField_Selected] := ASelected;
          if VarIsEqual(ScriptsDataSet.FieldValues[CField_NodeType], CTreeNodeType_Directory) then
            _SetChildrenSelected(ScriptsDataSet.FieldValues['RowId'], ASelected);
        end;
        ScriptsDataSet.Next;
      end;
    finally
      ScriptsDataSet.GotoBookmark(LBookmark);
      ScriptsDataSet.EnableControls;
    end;
  end;

begin
  if FIgnoreSelectFieldChanged then
    Exit;
  FIgnoreSelectFieldChanged := True;
  try
    if VarIsequal(ScriptsDataSet.FieldValues[CField_NodeType], CTreeNodeType_Directory) then
      _SetChildrenSelected(ScriptsDataSet.FieldValues['RowId'], IsNull(ScriptsDataSet.FieldValues[CField_Selected], False));
  finally
    FIgnoreSelectFieldChanged := False;
    CheckActionUpdate;
  end;
end;

procedure TSSMComparerForm.ScriptsTreeFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;
  RefreshActions;
end;

end.

