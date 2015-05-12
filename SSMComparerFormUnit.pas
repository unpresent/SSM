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
    function AddScriptRow(AParentRowId: Variant; AScript, AScriptFulLName, AScriptInSource, AObjectName, AAсtion: String; ASourceNode, AWorkNode: TSSMNode): Integer;
    function AddErrorRow(AScript, AObjectName, AErrorCode, AMessage: String; ANode : TSSMNode): Integer;

    procedure Compare_Nodes(AParentRowId: Variant; ASourceNode, AWorkNode: TSSMNode);
    procedure Compare_SourceToSource(AParentRowId: Variant; AObjectsSource : TSSMSource; AWorkSource : TSSMSource);
    procedure Compare_SourceToFodler(AParentRowId: Variant; ASource : TSSMSource; AFolder : TSSMFolder);
    procedure Compare_FolderToFodler(AParentRowId: Variant; AObjectsFolder : TSSMFolder; AFolder : TSSMFolder);

    procedure ExecuteComparer(AAppSettingName : String; AParamsSettingName: String);
    function GetRowId : Integer;

    procedure CheckShowErrors;
  public
    constructor Create(AOwner : TComponent; AParams : TNamedVariants); override;
    procedure RefreshActions;
  end;

implementation

uses
  SBaseFileUtils;

const
  CTreeNodeType_Directory       : String = 'D';
  CTreeNodeType_Script          : String = 'S';

  CNodeAction_UpdateScript      : String = 'UPDATE';
  CNodeAction_DeleteScript      : String = 'DELETE';
  CNodeAction_NewScript         : String = 'NEW';

  CError_NotParsedObjectName    : String = 'Нет определено имя SQL-объекта';
  CError_NotFoundObjectInSource : String = 'Нет в эталоне';
  CError_NotFoundObjectInWork   : String = 'Нет в рабочей папке';


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
  UpdateAllDataSet(ErrorsDataSet, 'Selected', True);
end;

procedure TSSMComparerForm.ActionErrorsUnSelectAllExecute(Sender: TObject);
begin
  inherited;
  UpdateAllDataSet(ErrorsDataSet, 'Selected', False);
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

      LNodeSource := ParamToSSNNode('Source_Ptr');
      LNodeWork := ParamToSSNNode('Work_Ptr');
      Compare_Nodes(Null, LNodeSource, LNodeWork);

    finally
      ScriptsDataSet.EnableControls;
      ErrorsDataSet.EnableControls;
    end;
  finally
    CheckShowErrors;
  end;
end;

procedure TSSMComparerForm.ActionScriptsUpdateExecute(Sender: TObject);
var
  LNodeSource     : TSSMNode;
  LDefinition     : TStrings;
  LObjectName     : String;
  LSourceScript   : String;
  LBookmark       : TBookmark;
  LScriptFullName : String;
begin
  LNodeSource := ParamToSSNNode('Source_Ptr');

  ScriptsDataSet.DisableControls;
  LDefinition := TStringList.Create;
  try
    LBookmark := ScriptsDataSet.GetBookmark;
    try
      ScriptsDataSet.First;
      while (not ScriptsDataSet.Eof) do begin
        if  VarIsEqual(ScriptsDataSet.FieldValues['Selected'], True)
        and VarIsEqual(ScriptsDataSet.FieldValues['NodeType'], CTreeNodeType_Script) then begin

          if LNodeSource.InheritsFrom(TSSMSource) then begin
            // Из БД надо вытащить обновление
            LObjectName := ScriptsDataSet.FieldValues['ObjectName'];
            LScriptFullName := ScriptsDataSet.FieldValues['ScriptFullName'];
            LDefinition.Clear;
            TMainDataModule.LoadDefinition_FromSource(TSSMSource(LNodeSource).Connection, LObjectName, LDefinition);
            LDefinition.SaveToFile(LScriptFullName);
          end else if LNodeSource.InheritsFrom(TSSMFolder) then begin
            // Имя файла-назначения
            LSourceScript := ScriptsDataSet.FieldValues['ScriptInSource'];
            LScriptFullName := ScriptsDataSet.FieldValues['ScriptFullName'];
            if FileExists(LSourceScript) then
              CopyFile(PWideChar(LSourceScript), PWideChar(LScriptFullName), False);
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
  end;
end;

procedure TSSMComparerForm.ActionSelectAllExecute(Sender: TObject);
begin
  UpdateAllDataSet(ScriptsDataSet, 'Selected', True);
end;

procedure TSSMComparerForm.ActionUnSelectAllExecute(Sender: TObject);
begin
  UpdateAllDataSet(ScriptsDataSet, 'Selected', False);
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

    ErrorsDataSet.FieldValues['Selected'] := False;

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
    ScriptsDataSet.FieldValues['NodeType'] := CTreeNodeType_Directory;
    ScriptsDataSet.FieldValues['Selected'] := False;

    ScriptsDataSet.Post;
  finally
    ScriptsDataSet.EnableControls;
  end;
end;

function TSSMComparerForm.AddScriptRow
(
  AParentRowId: Variant; AScript, AScriptFulLName, AScriptInSource, AObjectName, AAсtion: String;
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

    if AAсtion = CNodeAction_NewScript then
      LIconIndex := CIconIndex_ScriptNew
    else if AAсtion = CNodeAction_DeleteScript then
      LIconIndex := CIconIndex_ScriptDel
    else
      LIconIndex := CIconIndex_ScriptUpd;

    ScriptsDataSet.FieldValues['IconIndex'] := LIconIndex;

    Result := GetRowId;
    ScriptsDataSet.FieldValues['RowId'] := Result;

    ScriptsDataSet.FieldValues['ParentRowId'] := AParentRowId;
    ScriptsDataSet.FieldValues['NodeName'] := AScript;
    ScriptsDataSet.FieldValues['NodeType'] := CTreeNodeType_Script;
    ScriptsDataSet.FieldValues['Script'] := AScript;
    ScriptsDataSet.FieldValues['ScriptFullName'] := AScriptFullName;
    ScriptsDataSet.FieldValues['ScriptInSource'] := AScriptInSource;

    ScriptsDataSet.FieldValues['ObjectName'] := AObjectName;

    ScriptsDataSet.FieldValues['Action'] := AAсtion;
    ScriptsDataSet.FieldValues['Selected'] := False;

    ScriptsDataSet.FieldValues['SourceNode_Ptr'] := Integer( Pointer(ASourceNode) );
    ScriptsDataSet.FieldValues['WorkSourceNode_Ptr'] := Integer( Pointer(AWorkNode) );

    ScriptsDataSet.Post;
  finally
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
begin
  if ASourceNode.InheritsFrom(TSSMSource) and AWorkNode.InheritsFrom(TSSMSource) then
    Compare_SourceToSource(AParentRowId, TSSMSource(ASourceNode), TSSMSource(AWorkNode))
  else if ASourceNode.InheritsFrom(TSSMSource) and AWorkNode.InheritsFrom(TSSMFolder) then
    Compare_SourceToFodler(AParentRowId, TSSMSource(ASourceNode), TSSMFolder(AWorkNode))
  else if ASourceNode.InheritsFrom(TSSMFolder) and AWorkNode.InheritsFrom(TSSMFolder) then
    Compare_FolderToFodler(AParentRowId, TSSMFolder(ASourceNode), TSSMFolder(AWorkNode))
  else
    raise ESSMStructureError.Create('Недопустимые типы узлов для мастера сравнения!');
end;

procedure TSSMComparerForm.Compare_SourceToFodler(AParentRowId: Variant; ASource: TSSMSource; AFolder: TSSMFolder);
var
  I                 : Integer;
  LParentRowId      : Variant;
  LIsSourceFilter   : Boolean;
  LSourceObjects    : TStringList;
  LSourceGenScripts : TStringList;

  LScript           : TSSMScript;
  LObjectName       : String;
  LObjectIndex      : Integer;

  LIsAddedFolder    : Boolean;
  LFolderName       : String;

  LDefinitionSource : TStringList;
  LDefinitionWork   : TStringList;

  procedure _CheckAddedFolder;
  begin
    if not LIsAddedFolder then begin
      // Если еще не добавили папку, то добавляем
      if VarIsPresent(LParentRowId) then
        LFolderName := AFolder.Name
      else
        LFolderName := AFolder.FullName;
      LParentRowId := AddFolderRow(LParentRowId, LFolderName);
      LIsAddedFolder := True;
    end;
  end;

  procedure _LoadAndCompare();
  begin
    if TMainDataModule.LoadDefinition_FromSource(ASource.Connection, LObjectName, LDefinitionSource) then begin
      // Прочитали Definition, теперь сравниваем
      if not TMainDataModule.IsStringsEqual(LDefinitionSource, LDefinitionWork) then begin
        // Есть различия. Перед добавленем скрипта надо добавить папку, в которую пизать скрипты будем
        _CheckAddedFolder;
        // Добавляем в список различий собственно скрипт
        AddScriptRow(LParentRowId, LScript.Name, LScript.FullName, '', LObjectName, CNodeAction_UpdateScript, ASource, AFolder);
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
        // Работа с источником, в котором есть фильтр -> Значит и есть LSourceObjects
        LObjectIndex := LSourceObjects.IndexOf(LObjectName);
        if LObjectIndex < 0 then begin
          // Объект не найден в списке по Фильтру; файл - кандидат на удаление
          AddErrorRow(LScript.FullName, LObjectName, 'NOT:FOUND', CError_NotFoundObjectInSource, LScript);
        end else begin
          _LoadAndCompare;
          LSourceObjects.Delete(LObjectIndex);
          LSourceGenScripts.Delete(LObjectIndex);
        end;
      end else begin
        // Если нет фильтра, то работаем по фактическим скриптам
        if TMainDataModule.CheckObjectExists_FromSource(ASource.Connection, LObjectName) then begin
          // Объект есть в БД
          _LoadAndCompare;
        end else begin
          // Объект не найден в БД; файл - кандидат на удаление
          AddErrorRow(LScript.FullName, LObjectName, 'NOT:FOUND', CError_NotFoundObjectInSource, LScript)
        end;
      end;
    end;

    if LIsSourceFilter and (LSourceObjects.Count > 0) then begin
      // Теперь надо пройтись по оставшимся SQL-объектам в списке LSourceObjects
      // т.к. мы удаяляли из него то, что находили, то осталось то, для чего нет скриптов на диске
      _CheckAddedFolder;

      for I := 0 to LSourceObjects.Count - 1 do begin
        AddScriptRow(LParentRowId, LSourceGenScripts[I], PathCheckDivver(AFolder.FullName) + LSourceGenScripts[I], '',  LSourceObjects[I], CNodeAction_NewScript, ASource, AFolder);
      end;
    end;

    // Если установлена опция скнировать и подпапки, то
    if VarIsEqual(ParamsDataSet.FieldValues['ScanSubFolders'], True) then begin
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
      ObjectsSourcesDataSet.FieldValues['Name'] := ANode.NodeText;
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
    Caption := 'Сравнение :: ' + LinkedNode.NodeText;

  LProject := TSSMProject(_ParamToSSNNode(CParam_Project));
  LObjectsSource := TSSMProject(_ParamToSSNNode(CParam_ObjectsSource));
  LWorkSource := TSSMProject(_ParamToSSNNode(CParam_WorkSource));

  ParamsDataSet.DisableControls;
  ObjectsSourcesDataSet.DisableControls;
  try
    ParamsDataSet.Open;
    ParamsDataSet.Clear;
    ParamsDataSet.Append;
    ParamsDataSet.FieldValues['ScanSubFolders'] := IsNull(AParams.Values['ScanSubFolders'], True);
    ParamsDataSet.FieldValues['IgnoreNonParsedScripts'] := IsNull(AParams.Values['IgnoreNonParsedScripts'], True);

    ObjectsSourcesDataSet.Open;
    ObjectsSourcesDataSet.Clear;

    if Assigned(LObjectsSource) then begin
      _ObjectsSourcesAdd(LObjectsSource);
      ParamsDataSet.FieldValues['Source_Ptr'] := Integer(Pointer(LObjectsSource));
    end;
    if Assigned(LWorkSource) then begin
      _ObjectsSourcesAdd(LWorkSource);
      ParamsDataSet.FieldValues['Work_Ptr'] := Integer(Pointer(LWorkSource));
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
      for I := 0 to LProject.SourcesCount-1 do
        _ObjectsSourcesAdd(LProject.Sources[I]);
    end;

    if not Assigned(LObjectsSource) and Assigned(LProject) and (LProject.SourcesCount = 1) then
      ParamsDataSet.FieldValues['Source_Ptr'] := Integer(Pointer(LProject.Sources[0]));

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
      Result := Result.Replace('%title' + Integer.ToString(ANumber) + '%', 'Объект ' + AObjectName + ' в источнике (' + ASource.NodeText + ') - ' + LTempFileName + ')');
    finally
      LDefinition.Free;
    end;
  end;

  function _UpdatesParamsFromScript(ASParams : String; ANumber: Integer; AScript: TSSMScript; AObjectName : String): String;
  begin
    Result := ASParams;
    Result := Result.Replace('%file' + Integer.ToString(ANumber) + '%', AScript.FullName);
    Result := Result.Replace('%title' + Integer.ToString(ANumber) + '%', AScript.Name + '; Объект ' + AObjectName);
  end;

var
  LComparerApp    : Variant;
  LSComparer      : String;
  LComparerParams : Variant;
  LSParams        : String;
  LScript         : Variant;

  LNode1          : TSSMNode;
  LNode2          : TSSMNode;

  LObjectName     : String;
  LPath           : String;
begin
  inherited;
  LScript := ScriptsDataSet.FieldValues['Script'];
  if not VarIsPresent(LScript) then
    Exit;

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

  if not Assigned(LNode1) then
    Exit;
  if not Assigned(LNode2) then
    Exit;

  LPath := ExtractFilePath(ApplicationExeName);

  if LNode1.InheritsFrom(TSSMSource) then begin
    LSParams := _UpdatesParamsFromSource(LSParams, 1, TSSMSource(LNode1), LObjectName);
  end else if LNode1.InheritsFrom(TSSMScript) then begin
    LSParams := _UpdatesParamsFromScript(LSParams, 1, TSSMScript(LNode1), LObjectName);
    LPath := ExtractFilePath(TSSMScript(LNode1).FullName);
  end;

  if LNode2.InheritsFrom(TSSMSource) then begin
    LSParams := _UpdatesParamsFromSource(LSParams, 2, TSSMSource(LNode2), LObjectName);
  end else if LNode2.InheritsFrom(TSSMScript) then begin
    LSParams := _UpdatesParamsFromScript(LSParams, 2, TSSMScript(LNode2), LObjectName);
    LPath := ExtractFilePath(TSSMScript(LNode2).FullName);
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
          ScriptsDataSet.FieldValues['Selected'] := ASelected;
          if VarIsEqual(ScriptsDataSet.FieldValues['NodeType'], CTreeNodeType_Directory) then
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
    if VarIsequal(ScriptsDataSet.FieldValues['NodeType'], CTreeNodeType_Directory) then
      _SetChildrenSelected(ScriptsDataSet.FieldValues['RowId'], IsNull(ScriptsDataSet.FieldValues['Selected'], False));
  finally
    FIgnoreSelectFieldChanged := False;
  end;
end;

procedure TSSMComparerForm.ScriptsTreeFocusedNodeChanged(
  Sender: TcxCustomTreeList; APrevFocusedNode, AFocusedNode: TcxTreeListNode);
begin
  inherited;
  RefreshActions;
end;

end.

