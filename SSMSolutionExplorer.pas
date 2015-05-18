unit SSMSolutionExplorer;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  System.Types,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,

  cxTL,

  MainDataModuleUnit;

type
  ESSMSolutionError = class(Exception);

  TSSMSolutionExplorerViewer = class(TComponent)
  private
    FDestoing               : Boolean;
    FDataChangedList        : TList;
    FNeedRefresh            : Boolean;
    FUpdateLocks            : Integer;
    function GetTreeList: TcxTreeList;
    function GetSolution: TSSMSolution;
    function GetCurrentTreeListNode: TcxTreeListNode;
    function GetCurrentNode: TSSMNode;
    function GetCurrentNode_IsSource: Boolean;
    function GetCurrentNode_IsFilter: Boolean;
    function GetCurrentNode_IsFolder: Boolean;
    function GetCurrentNode_IsPatch: Boolean;
    function GetCurrentNode_IsProject: Boolean;
    function GetCurrentNode_IsSolution: Boolean;
    function GetCurrentNode_IsInput: Boolean;
    function GetCurrentNode_IsOutput: Boolean;
    function GetCurrentNode_IsScript: Boolean;
  protected
    procedure ClearNode(AParentNode : TcxTreeListNode; ADeleteClass: TSSMNodeClass);
    function FindFirstNode(AParentNode : TcxTreeListNode; ADataClass: TSSMNodeClass): TcxTreeListNode;
    function SeekNode(AStartNode : TcxTreeListNode; ASSMNode: TSSMNode; AWithDeleteClass: TSSMNodeClass): TcxTreeListNode;
    procedure RefreshStandartNode(ATreeListNode : TcxTreeListNode; ASSMNode : TSSMNode);
    function GetCurrentNodeIsClass(ASSMClass: TSSMNodeClass): Boolean; virtual;

    // -----------------
    procedure RefreshInputs(ASSMOutput: TSSMOutput; AParentNode : TcxTreeListNode);
    procedure RefreshInput(AInput: TSSMInput; ANode: TcxTreeListNode);
    //--
    procedure RefreshOutputs(ASSMPatch: TSSMPatch; AParentNode : TcxTreeListNode);
    procedure RefreshOutput(AOutput: TSSMOutput; ANode: TcxTreeListNode);
    //--
    procedure RefreshScripts(ASSMFolder: TSSMFolder; AParentNode : TcxTreeListNode);
    procedure RefreshScript(AScript: TSSMScript; ANode: TcxTreeListNode);
    //--
    procedure RefreshSources(ASSMProject: TSSMProject; AParentNode : TcxTreeListNode);
    procedure RefreshSource(ASouce: TSSMSource; ANode: TcxTreeListNode);
    //--
    procedure RefreshFilters(ASSMFolder: TSSMFolder; AParentNode : TcxTreeListNode);
    procedure RefreshFilter(AFilter: TSSMFilter; ANode: TcxTreeListNode);
    //--
    procedure RefreshFolders(ASSMParent: TSSMNode; AParentNode : TcxTreeListNode);
    procedure RefreshFolder(AFolder: TSSMFolder; ANode: TcxTreeListNode);
    //--
    procedure RefreshPatches(AParentNode : TcxTreeListNode);
    procedure RefreshPatch(APatch: TSSMPatch; ANode: TcxTreeListNode);
    procedure RefreshProjects(AParentNode : TcxTreeListNode);
    procedure RefreshProject(AProject: TSSMProject; ANode: TcxTreeListNode);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    // -----------------
    procedure OnChangedSSNode(Sender: TObject);
    // -----------------
    property DataChangedList : TList read FDataChangedList;
    procedure BeginUpdate;
    procedure EndUpdate;
    // -----------------
    property TreeList : TcxTreeList read GetTreeList;
    property Solution : TSSMSolution read GetSolution;
    procedure BeforeDestroySSMNode(ASSMNode: TSSMNode);
    // -----------------
    procedure Refresh;
    // -----------------
    property CurrentTreeListNode: TcxTreeListNode read GetCurrentTreeListNode;
    property CurrentNode: TSSMNode read GetCurrentNode;
    property CurrentNode_IsSolution   : Boolean read GetCurrentNode_IsSolution;
    property CurrentNode_IsProject    : Boolean read GetCurrentNode_IsProject;
    property CurrentNode_IsPatch      : Boolean read GetCurrentNode_IsPatch;
    property CurrentNode_IsFolder     : Boolean read GetCurrentNode_IsFolder;
    property CurrentNode_IsSource     : Boolean read GetCurrentNode_IsSource;
    property CurrentNode_IsFilter     : Boolean read GetCurrentNode_IsFilter;
    property CurrentNode_IsScript     : Boolean read GetCurrentNode_IsScript;
    property CurrentNode_IsInput      : Boolean read GetCurrentNode_IsInput;
    property CurrentNode_IsOutput     : Boolean read GetCurrentNode_IsOutput;
  end;

var
  SolutionExplorerViewer : TSSMSolutionExplorerViewer;

implementation

{ TSSMSolutionExplorerViewer }

procedure TSSMSolutionExplorerViewer.BeforeDestroySSMNode(ASSMNode: TSSMNode);

  function _CheckDelete(ANode : TcxTreeListNode): Boolean;
  var
    I     : Integer;
  begin
    if ANode.Data = ASSMNode then begin
      ANode.Delete;
      Result := True;
      Exit;
    end;

    for I := ANode.Count-1 downto 0 do begin
      Result := _CheckDelete(ANode.Items[I]);
      if Result then
        Exit;
    end;

    Result := False;
  end;

begin
  if Assigned(TreeList) then
    _CheckDelete(TreeList.Root);
end;

procedure TSSMSolutionExplorerViewer.BeginUpdate;
begin
  Inc(FUpdateLocks);
end;

procedure TSSMSolutionExplorerViewer.ClearNode(AParentNode: TcxTreeListNode; ADeleteClass: TSSMNodeClass);
var
  I         : Integer;
  LDelNode  : TcxTreeListNode;
begin
  if not Assigned(AParentNode) then
    raise ESSMSolutionError.Create('ClearNode: Параметр AParentNode должен иметь значение!');

  for I := AParentNode.Count-1 downto 0 do begin
    LDelNode := AParentNode.Items[I];
    if  Assigned(ADeleteClass) and Assigned(LDelNode.Data)
    and TSSMNode(LDelNode.Data).InheritsFrom(ADeleteClass) then
      LDelNode.Delete;
  end;
end;

constructor TSSMSolutionExplorerViewer.Create(AOwner: TComponent);
begin
  if Assigned(SolutionExplorerViewer) then
    raise ESSMSolutionError.Create('Можно создавать только один экземпляр SolutionExplorerViewer!');

  if (not Assigned(AOwner)) or (not AOwner.InheritsFrom(TcxTreeList)) then
    raise ESSMSolutionError.Create('Owner для класса TSSMSolutionExplorerViewer должен быть TcxTreeList!');

  FDataChangedList := TList.Create;
  inherited;

  SolutionExplorerViewer := Self;
end;

destructor TSSMSolutionExplorerViewer.Destroy;
begin
  SolutionExplorerViewer := nil;
  FDestoing := True;
  FreeAndNil(FDataChangedList);
  inherited;
end;

procedure TSSMSolutionExplorerViewer.EndUpdate;
begin
  Dec(FUpdateLocks);
  if FUpdateLocks = 0 then begin
    if FNeedRefresh then
      Refresh;
  end else if FUpdateLocks < 0 then begin
    ESSMSolutionError.Create('Количество вызовов EndUpdate больше вызовов BeginUpdate!');
  end;
end;

function TSSMSolutionExplorerViewer.FindFirstNode(AParentNode: TcxTreeListNode; ADataClass: TSSMNodeClass): TcxTreeListNode;
begin
  Result := AParentNode.getFirstChild;
  while Assigned(Result) and (Assigned(Result.Data))
    and (not TSSMNode(Result.Data).InheritsFrom(ADataClass)) do begin
    Result := Result.GetNext;
  end;
end;

function TSSMSolutionExplorerViewer.GetCurrentNode: TSSMNode;
var
  LTreeListNode : TcxTreeListNode;
begin
  LTreeListNode := CurrentTreeListNode;
  if Assigned(LTreeListNode) and TObject(LTreeListNode.Data).InheritsFrom(TSSMNode) then
    Result := TSSMNode(LTreeListNode.Data)
  else
    Result := nil;
end;

function TSSMSolutionExplorerViewer.GetCurrentNodeIsClass(ASSMClass: TSSMNodeClass): Boolean;
var
  LCurNode : TSSMNode;
begin
  LCurNode := CurrentNode;
  Result := Assigned(LCurNode) and LCurNode.InheritsFrom(ASSMClass);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsSource: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMSource);
end;

function TSSMSolutionExplorerViewer.GetCurrentTreeListNode: TcxTreeListNode;
begin
  Result := TreeList.FocusedNode;
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsFilter: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMFilter);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsFolder: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMFolder);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsInput: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMInput);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsOutput: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMOutput);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsPatch: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMPatch);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsProject: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMProject);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsScript: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMScript);
end;

function TSSMSolutionExplorerViewer.GetCurrentNode_IsSolution: Boolean;
begin
  Result := GetCurrentNodeIsClass(TSSMSolution);
end;

function TSSMSolutionExplorerViewer.GetSolution: TSSMSolution;
begin
  Result := MainDataModule.CurrentSolution;
end;

function TSSMSolutionExplorerViewer.GetTreeList: TcxTreeList;
begin
  Result := TcxTreeList(Owner);
end;

procedure TSSMSolutionExplorerViewer.OnChangedSSNode(Sender: TObject);
begin
  if not Assigned(FDataChangedList) then
    Exit;
  if not Assigned(Sender) then
    Exit;

  if Sender.InheritsFrom(TSSMNodeStoreInFile) then begin
    if not TSSMNodeStoreInFile(Sender).Changed then
      FDataChangedList.Remove(Sender)
    else if FDataChangedList.IndexOf(Sender) < 0 then
      FDataChangedList.Add(Sender);
  end;

  if FUpdateLocks > 0 then
    FNeedRefresh := True
  else
    Refresh;
end;

procedure TSSMSolutionExplorerViewer.Refresh;
var
  I         : Integer;
  LRoot     : TcxTreeListNode;
  LNode     : TcxTreeListNode;
begin
  TreeList.BeginUpdate;
  try
    LRoot := TreeList.Root;
    if Assigned(Solution) then begin
      LNode := LRoot.getFirstChild;
      if not Assigned(LNode) then
        LNode := LRoot.AddChild;

      RefreshStandartNode(LNode, Solution);
      RefreshProjects(LNode);
      RefreshPatches(LNode);
      LNode.Expanded := True;
    end else begin
      for I := LRoot.Count-1 downto 0 do
        LRoot.Items[I].Delete;
    end;
  finally
    FNeedRefresh := False;
    TreeList.EndUpdate;
  end;
end;

procedure TSSMSolutionExplorerViewer.RefreshFilter(AFilter: TSSMFilter;
  ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AFilter);
end;

procedure TSSMSolutionExplorerViewer.RefreshFilters(ASSMFolder: TSSMFolder; AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LFilter         : TSSMFilter;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if Assigned(ASSMFolder.Filter) then begin
    LParentExpanded := AParentNode.Expanded;
    try
      LFilter := ASSMFolder.Filter;
      if not LFilter.Hidden then begin
        LNode := SeekNode(LNode, LFilter, TSSMFilter);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChildFirst;

        RefreshFilter(LFilter, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMFilter);
end;

procedure TSSMSolutionExplorerViewer.RefreshFolder(AFolder: TSSMFolder; ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AFolder);
  RefreshFilters(AFolder, ANode);
  RefreshFolders(AFolder, ANode);
  RefreshScripts(AFolder, ANode);
end;

procedure TSSMSolutionExplorerViewer.RefreshFolders(ASSMParent: TSSMNode; AParentNode: TcxTreeListNode);
var
  I, N            : Integer;
  LNode           : TcxTreeListNode;
  LFolder         : TSSMFolder;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if (Assigned(ASSMParent) and ASSMParent.InheritsFrom(TSSMProject) and (TSSMProject(ASSMParent).FoldersCount > 0))
  or (Assigned(ASSMParent) and ASSMParent.InheritsFrom(TSSMFolder) and (TSSMFolder(ASSMParent).FoldersCount > 0)) then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Folders
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      if ASSMParent.InheritsFrom(TSSMProject) then begin
        TSSMProject(ASSMParent).FoldersSort;
        N := TSSMProject(ASSMParent).FoldersCount - 1;
      end else begin
        TSSMFolder(ASSMParent).FoldersSort;
        N := TSSMFolder(ASSMParent).FoldersCount - 1;
      end;

      for I := 0 to N do begin
        if ASSMParent.InheritsFrom(TSSMProject) then
          LFolder := TSSMProject(ASSMParent).Folders[I]
        else
          LFolder := TSSMFolder(ASSMParent).Folders[I];
        if LFolder.Hidden then
          Continue;

        LNode := SeekNode(LNode, LFolder, TSSMFolder);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChild;

        RefreshFolder(LFolder, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMFolder);
end;

procedure TSSMSolutionExplorerViewer.RefreshInput(AInput: TSSMInput; ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AInput);
end;

procedure TSSMSolutionExplorerViewer.RefreshInputs(ASSMOutput: TSSMOutput; AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LInput          : TSSMInput;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if ASSMOutput.InputsCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Output.Inputs
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      for I := 0 to ASSMOutput.InputsCount - 1 do begin
        LInput := ASSMOutput.Inputs[I];
        if LInput.Hidden then
          Continue;

        LNode := SeekNode(LNode, LInput, TSSMInput);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChild;

        RefreshInput(LInput, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMInput);
end;

procedure TSSMSolutionExplorerViewer.RefreshOutput(AOutput: TSSMOutput; ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AOutput);
  RefreshInputs(AOutput, ANode);
end;

procedure TSSMSolutionExplorerViewer.RefreshOutputs(ASSMPatch: TSSMPatch; AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LOutput         : TSSMOutput;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if ASSMPatch.OutputsCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Patch.Outputs
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      ASSMPatch.OutputsSort;
      for I := 0 to ASSMPatch.OutputsCount - 1 do begin
        LOutput := ASSMPatch.Outputs[I];
        if LOutput.Hidden then
          Continue;

        LNode := SeekNode(LNode, LOutput, TSSMOutput);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChild;

        RefreshOutput(LOutput, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMOutput);
end;

procedure TSSMSolutionExplorerViewer.RefreshPatches(AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LPatch          : TSSMPatch;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if Solution.PatchesCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Solition.Patches
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      Solution.PatchesSort;
      for I := 0 to Solution.PatchesCount - 1 do begin
        LPatch := Solution.Patches[I];
        if LPatch.Hidden then
          Continue;

        LNode := SeekNode(LNode, LPatch, TSSMPatch);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChild;

        RefreshPatch(LPatch, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMPatch);
end;

procedure TSSMSolutionExplorerViewer.RefreshPatch(APatch: TSSMPatch;  ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, APatch);
  RefreshOutputs(APatch, ANode);
end;

procedure TSSMSolutionExplorerViewer.RefreshProject(AProject: TSSMProject; ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AProject);
  RefreshSources(AProject, ANode);
  RefreshFolders(AProject, ANode);
end;

procedure TSSMSolutionExplorerViewer.RefreshProjects(AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LBeforeNode     : TcxTreeListNode;
  LProject        : TSSMProject;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if Solution.ProjectsCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Solition.Projects
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      Solution.ProjectsSort;
      for I := 0 to Solution.ProjectsCount - 1 do begin
        LProject := Solution.Projects[I];
        if LProject.Hidden then
          Continue;

        LNode := SeekNode(LNode, LProject, TSSMProject);
        if not Assigned(LNode) then begin
          LBeforeNode := FindFirstNode(AParentNode, TSSMPatch);
          if Assigned(LBeforeNode) then
            LNode := AParentNode.InsertChild(LBeforeNode)
          else
            LNode := AParentNode.AddChild;
        end;

        RefreshProject(LProject, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMProject);
end;

procedure TSSMSolutionExplorerViewer.RefreshScript(AScript: TSSMScript; ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, AScript);
end;

procedure TSSMSolutionExplorerViewer.RefreshScripts(ASSMFolder: TSSMFolder; AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LScript         : TSSMScript;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if ASSMFolder.ScriptsCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Folder.Scripts
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      ASSMFolder.ScriptsSort;
      for I := 0 to ASSMFolder.ScriptsCount - 1 do begin
        LScript := ASSMFolder.Scripts[I];
        if LScript.Hidden then
          Continue;

        LNode := SeekNode(LNode, LScript, TSSMScript);
        if not Assigned(LNode) then
          LNode := AParentNode.AddChild;

        RefreshScript(LScript, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMScript);
end;

procedure TSSMSolutionExplorerViewer.RefreshSource(ASouce: TSSMSource;
  ANode: TcxTreeListNode);
begin
  RefreshStandartNode(ANode, ASouce);
end;

procedure TSSMSolutionExplorerViewer.RefreshSources(ASSMProject: TSSMProject; AParentNode: TcxTreeListNode);
var
  I               : Integer;
  LNode           : TcxTreeListNode;
  LBeforeNode     : TcxTreeListNode;
  LSource         : TSSMSource;
  LParentExpanded : Boolean;
begin
  LNode := AParentNode.getFirstChild;

  if ASSMProject.SourcesCount > 0 then begin
    LParentExpanded := AParentNode.Expanded;
    try
      // Проходимся в порядке Project.Sources
      // Те TreeListNode, которые не по порядку - удаляем (см. SeekNode)
      ASSMProject.SourcesSort;
      for I := 0 to ASSMProject.SourcesCount - 1 do begin
        LSource := ASSMProject.Sources[I];
        if LSource.Hidden then
          Continue;

        LNode := SeekNode(LNode, LSource, TSSMSource);
        if not Assigned(LNode) then begin
          LBeforeNode := FindFirstNode(AParentNode, TSSMFolder);
          if Assigned(LBeforeNode) then
            LNode := AParentNode.InsertChild(LBeforeNode)
          else
            LNode := AParentNode.AddChild;
        end;

        RefreshSource(LSource, LNode);
      end;
    finally
      AParentNode.Expanded := LParentExpanded;
    end;

  end else
    ClearNode(AParentNode, TSSMSource);
end;

procedure TSSMSolutionExplorerViewer.RefreshStandartNode(ATreeListNode: TcxTreeListNode; ASSMNode: TSSMNode);
begin
  ATreeListNode.Texts[0] := ASSMNode.NodeText;
  ATreeListNode.ImageIndex := ASSMNode.GetIconIndex;
  ATreeListNode.Data := ASSMNode;
end;

function TSSMSolutionExplorerViewer.SeekNode(AStartNode: TcxTreeListNode; ASSMNode: TSSMNode; AWithDeleteClass: TSSMNodeClass): TcxTreeListNode;
var
  LParentNode : TcxTreeListNode;
  LNode       : TcxTreeListNode;
  I           : Integer;
begin
  Result := nil;

  if not Assigned(ASSMNode) then
    raise ESSMSolutionError.Create('SeekNode: Параметр ASSMNode должен иметь значение!');

  if not Assigned(AStartNode) then
    Exit;

  LParentNode := AStartNode.Parent;
  if not Assigned(LParentNode) then
    Exit;

  I := LParentNode.IndexOf(AStartNode);
  if I < 0 then
    Exit;
  
  while I < LParentNode.Count do begin
    LNode := LParentNode.Items[I];
    if Assigned(LNode) and (LNode.Data = ASSMNode) then begin
      Result := LNode;
      Exit;
    end;

    if  Assigned(AWithDeleteClass) and Assigned(LNode.Data)
    and TSSMNode(LNode.Data).InheritsFrom(AWithDeleteClass)
    and (SSMCompareNodes(LNode.Data, ASSMNode) > 0) then
      LNode.Delete
    else
      Inc(I);
  end;
end;

end.
