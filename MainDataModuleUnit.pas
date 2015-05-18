unit MainDataModuleUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.StrUtils,

  Winapi.Windows,

  Vcl.ImgList,
  Vcl.Controls,
  Vcl.Forms,

  cxGraphics,

  VirtualTable,
  Data.DB,
  MemDS,

  Xml.XMLDoc,
  Xml.xmldom,
  Xml.XMLIntf,

  DBAccess,
  UniDacVcl,
  Uni,

  IniFiles;

type
  TSSMNode = class;
  TSSMNodeClass = class of TSSMNode;

  TSSMSolution = class;
  TSSMProject = class;
  TSSMPatch = class;
  TSSMFolder = class;
  TSSMSource = class;
  TSSMFilter = class;

  TSSMScript = class;
  TSSMInput = class;
  TSSMOutput = class;

  TMainDataModule = class(TDataModule)
    MainSmallImages: TcxImageList;
    MainLargeImages: TcxImageList;
    procedure DataModuleDestroy(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FSettings : TIniFile;
    FCurrentSolution  : TSSMSolution;
    function GetSetting(ASetion, ASettingName: String): Variant;
    procedure SetSetting(ASetion, ASettingName: String; const Value: Variant);
  public
    // ARootFolder - путь, относительно которого надо вычислить путь к файлу
    class function GetAliasedPath(APath : String; ARootFolder: String) : String;
    class function GetUnaliasedPath(APath : String; ARootFolder: String) : String;
    property Settings[ASetion: String; ASettingName: String]: Variant read GetSetting write SetSetting;

    function ApplicationFullFileName  : String; // -- Path/Application.exe
    function ApplicationFileName      : String; // -- Application.exe
    function ApplicationFileNameOnly  : String; // -- Application
    function ApplicationFileExt       : String; // -- exe
    
    procedure NewSolution(AWithEmptyProject: Boolean; ASolutionFileName : String = '');
    procedure LoadSolution(ASolutionFileName : String);
    procedure CloseSolution;
    property CurrentSolution: TSSMSolution read FCurrentSolution;

    function ShowComparerForm(ANode: TSSMNode): TForm;
    function ShowFilterForm(ANode: TSSMNode): TForm;

    class procedure PrepareScriptObjectsList(AStrings : TStrings);
    class procedure LoadObjectsList(AConnection: TUniConnection; AWhereFilter : String; AObjectsList, AGeneratedScriptsNames: TStrings);
    class function CheckObjectExists_FromSource(AConnection : TUniConnection; AObjectName: String): Boolean;
    class function LoadDefinition_FromSource(AConnection : TUniConnection; AObjectName: String; AStrings: TStrings): Boolean;
    class function LoadDefinition_FromScript(AFileName : String; out AObjectName: String; AStrings: TStrings): Boolean;
    class function IsStringsEqual(AStrings1, AStrings2 : TStrings): Boolean;
  end;

  ESSMStructureError = class(Exception);
  ESSMFileError = class(Exception);

  TSSMNode = class(TPersistent)
  private
    FParentNode   : TSSMNode;
    FHidden       : Boolean;
    procedure SetHidden(const Value: Boolean);
  protected
    procedure SetParentNode(const Value: TSSMNode); virtual;
    procedure AssignTo(Dest: TPersistent); override;

    procedure SelfRemoveFromList(AList: TList);

    procedure SaveToXml(AXMLNode : IXMLNode); virtual; abstract;
    procedure LoadFromXml(AXMLNode : IXMLNode); virtual; abstract;

    // -- Факт изменения доводим до ближашего узла, умеющего храниться в файле
    procedure DoStoreChanged; virtual;
    // --
    procedure ChildsClear(AChildsList: TList); virtual;
    procedure ChildDelete(AChildList: TList; AChildIndex: Integer); virtual;
    procedure ChildRemove(AChildList: TList; AChild: TSSMNode); virtual;
    function ChildAdd(AChildList: TList; AChild: TSSMNode): Integer; virtual;
    function ChildNew(AChildList: TList; AChildClass : TSSMNodeClass): TSSMNode; virtual;
  public
    constructor Create(AParent: TSSMNode); virtual;
    destructor Destroy; override;
    function GetIconIndex: Integer; virtual;
    // ------------------------------------
    procedure Assign(Source: TPersistent); override;
    // ------------------------------------
    property ParentNode : TSSMNode read FParentNode write SetParentNode;
    function NodeText: String; virtual; abstract;
    property Hidden : Boolean read FHidden write SetHidden;
  end;

  // -- Узел, умеющий храниться в файле (Solution, Project, Patch)
  TSSMNodeStoreInFile = class(TSSMNode)
  private
    FFileName       : String;
    FIsNew          : Boolean;
    FChanged        : Boolean;
    FDestroing      : Boolean;
    FOnChanged      : TNotifyEvent;
    function GetPath: String;
    procedure SetOnChanged(const Value: TNotifyEvent);
  protected
    procedure SetChanged(const Value: Boolean); virtual;
    procedure SetFileName(const Value: String); virtual;
    procedure SaveInternal; virtual; abstract;
    procedure LoadInternal; virtual; abstract;
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
    // --------------
    function PrepareClearedRootNode(ANodeName: String; var AIDoc : IXMLDocument): IXMLNode; virtual;
    function GetRootNode(ANodeName: String): IXMLNode; virtual;
    // --------------
    procedure StartDestroy;
    property Destroing: Boolean read FDestroing;
    // --------------
    procedure DoStoreChanged; override;
  public
    constructor Create(AParent: TSSMNode); override;
    function NodeText: String; override;
    // ------------------------------------
    procedure Load;
    procedure LoadFrom(AFileName : String; ATemplate : Boolean = False);
    procedure Save;
    procedure SaveTo(AFileName: String);
    // ------------------------------------
    property Path: String read GetPath;
    property FileName : String read FFileName write SetFileName;
    property IsNew: Boolean read FIsNew;
    // Признак изменения будет фиксироваться только у узлов, которые умеют храниться в файлах
    property Changed: Boolean read FChanged write SetChanged;
    property OnChanged: TNotifyEvent read FOnChanged write SetOnChanged;
  end;

  TSSMSolution = class(TSSMNodeStoreInFile)
  private
    FProjects : TList;
    FPatches  : TList;

    function GetProject(Index: Integer): TSSMProject;
    function GetProjectsCount: Integer;
    function GetPatch(Index: Integer): TSSMPatch;
    function GetPatchesCount: Integer;
  protected
    procedure SetParentNode(const Value: TSSMNode); override;

    procedure SaveInternal; override;
    procedure LoadInternal; override;

    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode = nil); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    procedure ProjectsClear;
    property ProjectsCount: Integer read GetProjectsCount;
    property Projects[Index: Integer] : TSSMProject read GetProject;
    function ProjectsIndexOf(AProject: TSSMProject): Integer;
    // AWithDeleteFile = True -> тогда удаляется файл с диска
    procedure ProjectDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure ProjectRemove(AProject: TSSMProject; AWithDeleteFile: Boolean = False);
    // Открываем файл-проект, и добавляем объект-дескриптор
    function ProjectAddExisting(AProjectFileName: String): TSSMProject;
    function ProjectAdd(AProject: TSSMProject): Integer;
    function ProjectNew: TSSMProject;
    function ProjectByFileName(AFileName : String): TSSMProject;
    // Сортировка списка проектов по имени
    procedure ProjectsSort;
    // ------------------------------------
    procedure PatchesClear;
    property PatchesCount: Integer read GetPatchesCount;
    property Patches[Index: Integer] : TSSMPatch read GetPatch;
    function PatchesIndexOf(APatch: TSSMPatch): Integer;
    // AWithDeleteFile = True -> тогда удаляется файл с диска
    procedure PatchDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure PatchRemove(APatch: TSSMPatch; AWithDeleteFile: Boolean = False);
    // Открываем файл-патч, и добавляем объект-дескриптор
    function PatchAddExisting(APatchFileName: String): TSSMPatch;
    function PatchAdd(APatch: TSSMPatch): Integer;
    function PatchNew: TSSMPatch;
    function PatchByFileName(AFileName : String): TSSMPatch;
    // Сортировка списка патчей по имени
    procedure PatchesSort;
  end;

  TSSMProject = class(TSSMNodeStoreInFile)
  private
    FFolders : TList;
    FSources : TList;
    function GetSolution: TSSMSolution;
    function GetFolder(Index: Integer): TSSMFolder;
    function GetFoldersCount: Integer;
    function GetSource(Index: Integer): TSSMSource;
    function GetSourcesCount: Integer;
  protected
    procedure SetParentNode(const Value: TSSMNode); override;
    procedure SaveInternal; override;
    procedure LoadInternal; override;
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    property Solution: TSSMSolution read GetSolution;
    // ------------------------------------
    procedure SourcesClear;
    property SourcesCount: Integer read GetSourcesCount;
    property Sources[Index: Integer] : TSSMSource read GetSource;
    function SourcesIndexOf(ASource: TSSMSource): Integer;
    procedure SourceDelete(Index: Integer);
    procedure SourceRemove(ASource: TSSMSource);
    function SourceAdd(ASource: TSSMSource): Integer;
    function SourceNew: TSSMSource; overload;
    function SourceNew(AServer, ADatabase, AUser: String): TSSMSource; overload;
    function SourceByParams(AServer, ADatabase : String): TSSMSource;
    // Сортировка списка источников по имени
    procedure SourcesSort;
    // ------------------------------------
    procedure FoldersClear;
    property FoldersCount: Integer read GetFoldersCount;
    property Folders[Index: Integer] : TSSMFolder read GetFolder;
    function FoldersIndexOf(AFolder: TSSMFolder): Integer;
    // AWithDeleteFile = True -> тогда удаляется папку с диска
    procedure FolderDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure FolderRemove(AFolder: TSSMFolder; AWithDeleteFile: Boolean = False);
    // Открываем существующую папку в проект
    function FolderAddByFullName(AFolderFullName: String): TSSMFolder;
    function FolderAdd(AFolder: TSSMFolder): Integer;
    function FolderNew: TSSMFolder;
    function FolderByFullName(AFolderFullName : String): TSSMFolder;
    // Сортировка списка папок по имени
    procedure FoldersSort;
  end;

  TSSMPatch = class(TSSMNodeStoreInFile)
  private
    FOutputs : TList;
    function GetSolution: TSSMSolution;
    function GetOutput(Index: Integer): TSSMOutput;
    function GetOutputsCount: Integer;
  protected
    procedure SetParentNode(const Value: TSSMNode); override;
    procedure SaveInternal; override;
    procedure LoadInternal; override;
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    property Solution: TSSMSolution read GetSolution;
    // ------------------------------------
    procedure OutputsClear;
    property OutputsCount: Integer read GetOutputsCount;
    property Outputs[Index: Integer] : TSSMOutput read GetOutput;
    function OutputsIndexOf(AOutput: TSSMOutput): Integer;
    // AWithDeleteFile = True -> тогда удаляется скрипт с диска
    procedure OutputDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure OutputRemove(AOutput: TSSMOutput; AWithDeleteFile: Boolean = False);
    // Добалвяем существующий в папку
    function OutputAddByShortName(AOutputShortName: String): TSSMOutput;
    function OutputAdd(AOutput: TSSMOutput): Integer;
    function OutputNew: TSSMOutput;
    function OutputByName(AOutputName : String): TSSMOutput;
    // Сортировка списка скриптов по имени
    procedure OutputsSort;
  end;

  TSSMSource = class(TSSMNode)
  private
    FConnection   : TUniConnection;
    procedure SetDatabase(const Value: String);
    procedure SetServer(const Value: String);
    procedure SetUser(const Value: String);
    procedure SetIsWinAuthentication(const Value: Boolean);
    procedure SetPassword(const Value: String);
    function GetDatabase: String;
    function GetIsWinAuthentication: Boolean;
    function GetPassword: String;
    function GetServer: String;
    function GetUser: String;
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);
    function GetLoginPrompt: Boolean;
    procedure SetLoginPrompt(const Value: Boolean);
    function GetProject: TSSMProject;
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    procedure Delete;
    // ------------------------------------
    property Project : TSSMProject read GetProject;
    // ------------------------------------
    property LoginPrompt : Boolean read GetLoginPrompt write SetLoginPrompt;
    function Connect: Boolean;
    procedure Disconnect;
    property Connected: Boolean read GetConnected write SetConnected;
    property Connection: TUniConnection read FConnection;
    // ------------------------------------
    property Server : String read GetServer write SetServer;
    property Database : String read GetDatabase write SetDatabase;
    property User : String read GetUser write SetUser;
    property Password : String read GetPassword write SetPassword;
    property IsWinAuthentication : Boolean read GetIsWinAuthentication write SetIsWinAuthentication;
  end;

  TSSMFolder = class(TSSMNode)
  private
    FFolders  : TList;
    FScripts  : TList;
    FName     : String;
    FPath     : String;
    FFilter   : TSSMFilter;
    function GetFolder(Index: Integer): TSSMFolder;
    function GetFoldersCount: Integer;
    function GetPath: String;
    function GetFullName: String;
    function GetScript(Index: Integer): TSSMScript;
    function GetScriptsCount: Integer;
    function GetProject: TSSMProject;
    function GetIsEmptyFilter: Boolean;
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    property Name: String read FName;
    property Path: String read GetPath;
    property FullName: String read GetFullName;
    procedure Rename(ANewName: String);
    // ------------------------------------
    property Project : TSSMProject read GetProject;
    // ------------------------------------
    procedure Delete(AWithDeleteFile: Boolean = False);
    // ------------------------------------
    property IsEmptyFilter: Boolean read GetIsEmptyFilter;
    property Filter : TSSMFilter read FFilter;
    procedure FilterCreate;
    procedure FilterDelete;

    // ------------------------------------
    procedure FoldersClear;
    property FoldersCount: Integer read GetFoldersCount;
    property Folders[Index: Integer] : TSSMFolder read GetFolder;
    function FoldersIndexOf(AFolder: TSSMFolder): Integer;
    // AWithDeleteFile = True -> тогда удаляется папку с диска
    procedure FolderDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure FolderRemove(AFolder: TSSMFolder; AWithDeleteFile: Boolean = False);
    // Открываем существующую папку в проект
    function FolderAddByShortName(AFolderShortName: String): TSSMFolder;
    function FolderAdd(AFolder: TSSMFolder): Integer;
    function FolderNew: TSSMFolder;
    function FolderByFullName(AFolderFullName : String): TSSMFolder;
    // Сортировка списка папок по имени
    procedure FoldersSort;

    // ------------------------------------
    procedure ScriptsClear;
    property ScriptsCount: Integer read GetScriptsCount;
    property Scripts[Index: Integer] : TSSMScript read GetScript;
    function ScriptsIndexOf(AScript: TSSMScript): Integer;
    // AWithDeleteFile = True -> тогда удаляется скрипт с диска
    procedure ScriptDelete(Index: Integer; AWithDeleteFile: Boolean = False);
    procedure ScriptRemove(AScript: TSSMScript; AWithDeleteFile: Boolean = False);
    // Добалвяем существующий в папку
    function ScriptAddByShortName(AScriptShortName: String): TSSMScript;
    function ScriptAdd(AScript: TSSMScript): Integer;
    function ScriptNew: TSSMScript;
    function ScriptByName(AScriptName : String): TSSMScript;
    // Сортировка списка скриптов по имени
    procedure ScriptsSort;
  end;

  TSSMFilter = class(TSSMNode)
  private
    FWhereFilter  : String;
    procedure SetWhereFilter(const Value: String);
    function GetFolder: TSSMFolder;
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    // ------------------------------------
    property Folder : TSSMFolder read GetFolder;
    property WhereFilter: String read FWhereFilter write SetWhereFilter;
  end;

  TSSMScript = class(TSSMNode)
  private
    FName : String;
    FSQLObject: String;
    procedure SetName(const Value: String);
    procedure SetSQLObject(const Value: String);
    function GetFullName: String;
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    // ------------------------------------
    procedure Delete(AWithDeleteFile: Boolean = False);
    // ------------------------------------
    property Name : String read FName write SetName;
    property SQLObject : String read FSQLObject write SetSQLObject;
    property FullName : String read GetFullName;
  end;

  TSSMInput = class(TSSMNode)
  private
    FFileName   : String;
    FAliasedName: String;
    function GetOutput: TSSMOutput;
    function GetPatch: TSSMPatch;
    procedure SetFileName(const Value: String);
    procedure SetAliasedName(const Value: String);
    function GetSortOrder: Integer;
    procedure SetSortOrder(const Value: Integer);
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    // ------------------------------------
    procedure Delete;
    // ------------------------------------
    property Patch: TSSMPatch read GetPatch;
    property Output : TSSMOutput read GetOutput;

    property FileName     : String read FFileName write SetFileName;
    property AliasedName  : String read FAliasedName write SetAliasedName;
    property SortOrder    : Integer read GetSortOrder write SetSortOrder;
    procedure MoveUp(ASteps: Integer = 1);
    procedure MoveDown(ASteps: Integer = 1);
    procedure MoveFirst;
    procedure MoveLast;
  end;

  TSSMOutput = class(TSSMNode)
  private
    FName : String;
    FInputs : TList;
    function GetFullName: String;
    procedure SetName(const Value: String);
    function GetPatch: TSSMPatch;
    function GetInput(Index: Integer): TSSMInput;
    function GetInputsCount: Integer;
  protected
    procedure SaveToXml(AXMLNode : IXMLNode); override;
    procedure LoadFromXml(AXMLNode : IXMLNode);  override;
  public
    constructor Create(AParent: TSSMNode); override;
    destructor Destroy; override;
    function GetIconIndex: Integer; override;
    // ------------------------------------
    function NodeText: String; override;
    // ------------------------------------
    procedure Delete(AWithDeleteFile: Boolean = False);
    // ------------------------------------
    property Patch: TSSMPatch read GetPatch;
    property Name : String read FName write SetName;
    property FullName : String read GetFullName;

    // ------------------------------------
    procedure InputsClear;
    property InputsCount: Integer read GetInputsCount;
    property Inputs[Index: Integer] : TSSMInput read GetInput;
    function InputsIndexOf(AInput: TSSMInput): Integer;
    // AWithDeleteFile = True -> тогда удаляется скрипт с диска
    procedure InputDelete(Index: Integer);
    procedure InputRemove(AInput: TSSMInput);
    // Добалвяем существующий в папку
    function InputAddByFullName(AInputFullName: String): TSSMInput;
    function InputAdd(AInput: TSSMInput): Integer;
    function InputNew: TSSMInput;
    function InputByFullName(AInputName : String): TSSMInput;
    function InputByAliasedName(AInputName : String): TSSMInput;
  end;

  function SSMCompareNodes(AItem1, AItem2 : Pointer): Integer;
  function PathCheckDivver(APath: String): String;
  function CreateAndOpenFileStream(AFileName: String): TFileStream;
  function CreateIfNotExistsFile(AFileName: String): Boolean;

var
  MainDataModule            : TMainDataModule;

const
  CIconIndex_Solution               : Integer = 76;
  CIconIndex_Project                : Integer = 68;
  CIconIndex_Patch                  : Integer = 27;
  CIconIndex_Folder                 : Integer = 10;
  CIconIndex_SourceConnected        : Integer = 79;
  CIconIndex_SourceDisConnected     : Integer = 81;
  CIconIndex_Filter                 : Integer = 139;
  CIconIndex_Script                 : Integer = 110;
  CIconIndex_Output                 : Integer = 92;
  CIconIndex_Input                  : Integer = 14;

  CIconIndex_ScriptNew              : Integer = 28;
  CIconIndex_ScriptDel              : Integer = 29;
  CIconIndex_ScriptUpd              : Integer = 16;
  CIconIndex_ScriptAdd              : Integer = 25;
  CIconIndex_ScriptAddUpd           : Integer = 31;

  CFileExt_Solution                 : String = 'ssxsl';
  CFileExt_Project                  : String = 'ssxpj';
  CFileExt_Patch                    : String = 'ssxpt';
  CFileExt_Script                   : String = 'sql';

  CFileFilter_Solution              : String = 'Решение|*.ssxsl';
  CFileFilter_Project               : String = 'Проект|*.ssxpj';
  CFileFilter_Patch                 : String = 'Патч|*.ssxpt';
  CFileFilter_Script                : String = 'Скрипт|*.sql';

  CDefaultName_Solution             : String = 'Solution';
  CDefaultName_Project              : String = 'Project';
  CDefaultName_Patch                : String = 'Patch';

const
  CFileName_EmptySolution           : String = '.BlankSolution.ssxsl';
  CFileName_EmptyProject            : String = '.BlankProject.ssxpj';
  CFileName_EmptyPatch              : String = '.BlankPatch.ssxpt';
  CFileName_Settings                : String = '.Settings.ini';

  CAttribute_Name                   : String = 'Name';
  CAttribute_FullName               : String = 'FullName';
  CAttribute_Value                  : String = 'Value';
  CAttribute_FileName               : String = 'FileName';
  CAttribute_Server                 : String = 'Server';
  CAttribute_Database               : String = 'Database';
  CAttribute_User                   : String = 'User';
  CAttribute_Password               : String = 'Password';
  CAttribute_WinAuthentication      : String = 'WinAuthentication';
  CAttribute_WhereFilter            : String = 'WhereFilter';

  CNode_Solution                    : String = 'Solution';

  CNode_Aliases                     : String = 'Aliases';
  CNode_Alias                       : String = 'Alias';

  CNode_Options                     : String = 'Options';
  CNode_Option                      : String = 'Option';

  CNode_DefPathes                   : String = 'DefaultPathes';
  CNode_DefPath                     : String = 'DefaultPath';

  CNode_Projects                    : String = 'Projects';
  CNode_Project                     : String = 'Project';

  CNode_Patches                     : String = 'Patches';
  CNode_Patch                       : String = 'Patch';

  CNode_Sources                     : String = 'Sources';
  CNode_Source                      : String = 'Source';

  CNode_Folders                     : String = 'Folders';
  CNode_Folder                      : String = 'Folder';

  CNode_Filters                     : String = 'Filters';
  CNode_Filter                      : String = 'Filter';

  CNode_Scripts                     : String = 'Scripts';
  CNode_Script                      : String = 'Script';

  CNode_Outputs                     : String = 'Outputs';
  CNode_Output                      : String = 'Output';

  CNode_Inputs                      : String = 'Inputs';
  CNode_Input                       : String = 'Input';

  CEL                               : String = #13+#10;
  CXML_Header                       : String = '<?xml version="1.0"?>';

const
  CMessage_ConfigmDeleteSource      : String = 'Вы действительно хотите удалить источник?';
  CMessage_DeleteFromDisk           : String = 'Удалить физически с диска?';
  CMessage_SaveChanges              : String = 'Сохранить изменения?';

  CConnection_Provider              : String = 'SQL Server';
  CConnection_MSSQL_Authentication  : String = 'SQL Server.Authentication';
  CConnection_MSSQL_Win             : String = 'auWindows';
  CConnection_MSSQL_Sql             : String = 'auServer';

  CFilter_Emptу                     : String = '(пусто)';
  CFilter_Filled                    : String = '<Фильтр>';

const
  CParam_Project                    : String = 'Project';
  CParam_Folder                     : String = 'Folder';
  CParam_ObjectsSource              : String = 'ObjectsSource';
  CParam_WorkSource                 : String = 'WorkSource';

const
  CSettingGroup_Aliases             : String = 'Aliases';

  CSettingGroup_DefPathes           : String = 'DefaultPathes';
  CSettingValue_ProjectsDefPath     : String = 'Projects';
  CSettingValue_PatchesDefPath      : String = 'Patches';

  CSettingGroup_Comperers           : String = 'Comparers';
  CSettingValue_CompererApp1        : String = 'Compare1';
  CSettingValue_CompererParams1     : String = 'Params1';
  CSettingValue_CompererApp2        : String = 'Comparer2';
  CSettingValue_CompererParams2     : String = 'Params2';

implementation

uses
  System.Variants,
  NamedVariables,
  SBaseVariantFunctions,
  SBaseStringFunctions,

  MainFormUnit,
  SSMSolutionExplorer,

  SSMBaseFormUnit,
  SSMComparerFormUnit,
  SSMFilterEditorFormUnit,
  SSMPatchEditorFormUnit;

{%CLASSGROUP 'Vcl.Controls.TControl'}
function SSMCompareNodes(AItem1, AItem2 : Pointer): Integer;
begin
  Result := System.String.Compare(TSSMNode(AItem1).NodeText, TSSMNode(AItem2).NodeText);
end;

function PathCheckDivver(APath: String): String;
begin
  Result := APath;
  if (not Result.IsEmpty) and (Result.Chars[Result.Length-1] <> PathDelim) then
    Result := Result + PathDelim;
end;

function CreateIfNotExistsFile(AFileName: String): Boolean;
var
  LHandle : THandle;
begin
  if not FileExists(AFileName) then begin
    LHandle := FileCreate(AFileName);
    FileClose(LHandle);
  end;
  Result := FileExists(AFileName);
end;

function CreateAndOpenFileStream(AFileName: String): TFileStream;
begin
  if CreateIfNotExistsFile(AFileName) then
    Result := TFileStream.Create(AFileName, fmOpenReadWrite)
  else
    Result := nil;
end;

function IsNull(ANullAbleVar: Variant; AValueForNull: Variant): Variant;
begin
  if VarIsEmpty(ANullAbleVar) or VarIsNull(ANullAbleVar) then
    Result := AValueForNull
  else
    Result := ANullAbleVar;
end;

{$R *.dfm}

function TMainDataModule.ApplicationFileExt: String;
begin
  Result := ExtractFileExt(Application.ExeName);
end;

function TMainDataModule.ApplicationFileName: String;
begin
  Result := ExtractFileName(Application.ExeName);
end;

function TMainDataModule.ApplicationFileNameOnly: String;
begin
  Result := ApplicationFileName;
  Result := Result.Substring(0, Result.Length - ExtractFileExt(Result).Length);
end;

function TMainDataModule.ApplicationFullFileName: String;
begin
  Result := Application.ExeName;
end;

class function TMainDataModule.CheckObjectExists_FromSource(AConnection: TUniConnection; AObjectName: String): Boolean;
var
  LStrings : TStrings;
begin
  LStrings := TStringList.Create;
  try
    LoadObjectsList(AConnection, '[ObjectFullName] = ''' + AObjectName.Replace('''', '''''') + '''', LStrings, nil);
    Result := LStrings.Count > 0;
  finally
    LStrings.Free;
  end;
end;

procedure TMainDataModule.CloseSolution;
begin
  if Assigned(CurrentSolution) then begin
    FreeAndNil(FCurrentSolution);
  end;
end;

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
var
  LSettingsFileName  : String;
begin
  LSettingsFileName := PathCheckDivver(ExtractFilePath(ApplicationFullFileName))
                     + ApplicationFileNameOnly + CFileName_Settings;
  FSettings := TIniFile.Create(LSettingsFileName);
end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin
  FCurrentSolution := nil;
  MainDataModule := nil;
end;

class function TMainDataModule.GetAliasedPath(APath, ARootFolder: String): String;
begin
  // -- TODO
  Result := APath;
end;

function TMainDataModule.GetSetting(ASetion, ASettingName: String): Variant;
begin
  Result := FSettings.ReadString(ASetion, ASettingName, '');
  if Result = '' then
    Result := Null;
end;

class function TMainDataModule.GetUnaliasedPath(APath, ARootFolder: String): String;
begin
  // -- TODO
  Result := APath;
end;

class function TMainDataModule.IsStringsEqual(AStrings1, AStrings2: TStrings): Boolean;
var
  I : Integer;
begin
  Result := AStrings1.Count = AStrings2.Count;
  if Result then begin
    for I := 0 to Pred(AStrings1.Count) do
      if AStrings1[I] <> AStrings2[I] then begin
        Result := False;
        Exit;
      end;
  end;
end;

{ TSSMNode }

procedure TSSMNode.Assign(Source: TPersistent);
begin
  if Source.InheritsFrom(TSSMNode) then begin
    ParentNode := TSSMNode(TSSMNode).ParentNode;
  end else
    inherited;
end;

procedure TSSMNode.AssignTo(Dest: TPersistent);
begin
  if Dest.InheritsFrom(TSSMNode) then
    Dest.Assign(Self);
end;

function TSSMNode.ChildAdd(AChildList: TList; AChild: TSSMNode): Integer;
begin
  Result := AChildList.IndexOf(AChild);
  if Result < 0 then begin
    Result := AChildList.Add(AChild);
    AChild.ParentNode := Self;
  end;
  DoStoreChanged;
end;

procedure TSSMNode.ChildDelete(AChildList: TList; AChildIndex: Integer);
var
  LChild : TSSMNode;
begin
  LChild := AChildList[AChildIndex];
  AChildList.Delete(AChildIndex);
  LChild.ParentNode := nil;

  DoStoreChanged;
end;

function TSSMNode.ChildNew(AChildList: TList; AChildClass: TSSMNodeClass): TSSMNode;
begin
  Result := AChildClass.Create(Self);
  ChildAdd(AChildList, Result);
  DoStoreChanged;
end;

procedure TSSMNode.ChildRemove(AChildList: TList; AChild: TSSMNode);
begin
  AChildList.Remove(AChild);
  AChild.ParentNode := nil;
  AChild.Free;

  DoStoreChanged;
end;

procedure TSSMNode.ChildsClear(AChildsList: TList);
var
  I       : Integer;
  LNode   : TSSMNode;
  LList   : TList;
begin
  LList := TList.Create;
  try
    LList.Assign(AChildsList, laCopy);
    AChildsList.Clear;
    for I := LList.Count - 1 downto 0 do begin
      LNode := TSSMNode(LList.Items[I]);
      if Assigned(LNode) then begin
        LList.Items[I] := nil;
        LNode.ParentNode := nil;
        LNode.Free;
      end;
    end;
  finally
    DoStoreChanged;
    LList.Free;
  end;
end;

constructor TSSMNode.Create(AParent: TSSMNode);
begin
  inherited Create;
  ParentNode := AParent;
end;

destructor TSSMNode.Destroy;
begin
  if Assigned(SolutionExplorerViewer) then
    SolutionExplorerViewer.BeforeDestroySSMNode(Self);
  inherited;
end;

procedure TSSMNode.DoStoreChanged;
begin
  if Self.InheritsFrom(TSSMNodeStoreInFile) then begin
    if TSSMNodeStoreInFile(Self).Destroing then
      Exit;
    
    TSSMNodeStoreInFile(Self).FChanged := True;
    Exit;
  end;
  
  if Assigned(ParentNode) then
    ParentNode.DoStoreChanged;
end;

function TSSMNode.GetIconIndex: Integer;
begin
  Result := -1;
end;

procedure TSSMNode.SelfRemoveFromList(AList: TList);
begin
  if Assigned(AList) then
    AList.Remove(Self);
end;

procedure TSSMNode.SetHidden(const Value: Boolean);
begin
  if FHidden = Value then
    Exit;

  FHidden := Value;
  DoStoreChanged;
end;

procedure TSSMNode.SetParentNode(const Value: TSSMNode);
begin
  if FParentNode = Value then
    Exit;
  
  FParentNode := Value;
  DoStoreChanged;

  // -- Если меняется место в дереве у Project-а или Patch-а
  // -- то отправляем факт изменения в Solution
  if Self.InheritsFrom(TSSMNodeStoreInFile)
  and Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMNodeStoreInFile) then
    ParentNode.DoStoreChanged;      
end;

{ TSSMSolution }

constructor TSSMSolution.Create(AParent: TSSMNode);
begin
  if Assigned(AParent) then
    raise ESSMStructureError.Create('У решения не может быть родительского узла!');
    
  inherited;

  FProjects := TList.Create;
  FPatches := TList.Create;
end;

destructor TSSMSolution.Destroy;
begin
  StartDestroy;
  // -------------------
  PatchesClear;
  FreeAndNil(FPatches);

  ProjectsClear;
  FreeAndNil(FProjects);
  // -------------------
  inherited;
end;

function TSSMSolution.GetIconIndex: Integer;
begin
  Result := CIconIndex_Solution;
end;

function TSSMSolution.GetPatch(Index: Integer): TSSMPatch;
begin
  Result := TSSMPatch(FPatches.Items[Index]);
end;

function TSSMSolution.GetPatchesCount: Integer;
begin
  Result := FPatches.Count;
end;

function TSSMSolution.GetProject(Index: Integer): TSSMProject;
begin
  Result := TSSMProject(FProjects.Items[Index]);
end;

function TSSMSolution.GetProjectsCount: Integer;
begin
  Result := FProjects.Count;
end;

procedure TSSMSolution.LoadFromXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LProjectName    : Variant;
  LPatchName      : Variant;
  LFileName       : String;
  LINodeProjects  : IXMLNode;
  LIProjects      : IXMLNodeList;
  LINodePatches   : IXMLNode;
  LIPatches       : IXMLNodeList;
  LINode          : IXMLNode;
begin
  ProjectsClear;
  // Загрузка проектов
  LINodeProjects := AXMLNode.ChildNodes[CNode_Projects];
  LIProjects := LINodeProjects.ChildNodes;
  for I := 0 to LIProjects.Count - 1 do begin
    LINode := LIProjects.Nodes[I];
    if LINode.NodeName = CNode_Project then begin
      LProjectName := LINode.Attributes[CAttribute_FileName];
      if (not VarIsEmpty(LProjectName)) and (not VarIsNull(LProjectName)) then begin
        LFileName := TMainDataModule.GetUnaliasedPath(LProjectName, Path);
        ProjectAddExisting(LFileName);
      end;
    end;
  end;

  PatchesClear;
  // Загрузка патчей
  LINodePatches := AXMLNode.ChildNodes[CNode_Patches];
  LIPatches := LINodePatches.ChildNodes;
  for I := 0 to LIPatches.Count - 1 do begin
    LINode := LIPatches.Nodes[I];
    if LINode.NodeName = CNode_Patch then begin
      LPatchName := LINode.Attributes[CAttribute_FileName];
      if (not VarIsEmpty(LPatchName)) and (not VarIsNull(LPatchName)) then begin
        LFileName := TMainDataModule.GetUnaliasedPath(LPatchName, Path);
        PatchAddExisting(LFileName);
      end;
    end;
  end;
end;

procedure TSSMSolution.LoadInternal;
var
  LINode  : IXMLNode;
begin
  SolutionExplorerViewer.BeginUpdate;
  try
    LINode := GetRootNode(CNode_Solution);
    if Assigned(LINode) then
      LoadFromXml(LINode);
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;

function TSSMSolution.PatchAdd(APatch: TSSMPatch): Integer;
begin
  Result := ChildAdd(FPatches, APatch);
end;

function TSSMSolution.PatchAddExisting(APatchFileName: String): TSSMPatch;
begin
  Result := PatchByFileName(APatchFileName);
  if Assigned(Result) then
    raise ESSMFileError.Create('Патч уже открыт!');

  Result := PatchNew;
  Result.LoadFrom(APatchFileName);

  DoStoreChanged;
end;

function TSSMSolution.PatchByFileName(AFileName : String): TSSMPatch;
var
  I : Integer;
begin
  for I := 0 to FPatches.Count - 1 do begin
    Result := Patches[I];
    if Result.FileName = AFileName then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMSolution.PatchDelete(Index: Integer; AWithDeleteFile: Boolean = False);
var
  LPatch  : TSSMPatch;
begin
  if AWithDeleteFile then begin
    LPatch := Patches[Index];
    if FileExists(LPatch.FileName) then
      System.SysUtils.DeleteFile(LPatch.FileName);
  end;
  ChildDelete(FPatches, Index);
end;

procedure TSSMSolution.PatchesClear;
begin
  ChildsClear(FPatches);
end;

function TSSMSolution.PatchesIndexOf(APatch: TSSMPatch): Integer;
begin
  Result := FPatches.IndexOf(APatch);
end;

procedure TSSMSolution.PatchesSort;
begin
  FPatches.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

function TSSMSolution.PatchNew: TSSMPatch;
begin
  Result := TSSMPatch( ChildNew(FPatches, TSSMPatch) );
end;

procedure TSSMSolution.PatchRemove(APatch: TSSMPatch; AWithDeleteFile: Boolean = False);
begin
  if AWithDeleteFile then begin
    if FileExists(APatch.FileName) then
      System.SysUtils.DeleteFile(APatch.FileName);
  end;
  ChildRemove(FPatches, APatch);
end;

function TSSMSolution.ProjectAdd(AProject: TSSMProject): Integer;
begin
  Result := ChildAdd(FProjects, AProject);
end;

function TSSMSolution.ProjectAddExisting(AProjectFileName: String): TSSMProject;
begin
  Result := ProjectByFileName(AProjectFileName);
  if Assigned(Result) then
    raise ESSMFileError.Create('Проект уже открыт!');

  Result := ProjectNew;
  Result.LoadFrom(AProjectFileName);
  
  DoStoreChanged;
end;

function TSSMSolution.ProjectByFileName(AFileName : String): TSSMProject;
var
  I : Integer;
begin
  for I := 0 to FProjects.Count - 1 do begin
    Result := Projects[I];
    if Result.FileName = AFileName then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMSolution.ProjectDelete(Index: Integer; AWithDeleteFile: Boolean = False);
var
  LProject : TSSMProject;
begin
  if AWithDeleteFile then begin
    LProject := Projects[Index];
    if FileExists(LProject.FileName) then
      System.SysUtils.DeleteFile(LProject.FileName);
  end;
  ChildDelete(FProjects, Index);
end;

function TSSMSolution.ProjectNew: TSSMProject;
var
  I         : Integer;
  LFileName : String;
  LPath     : String;
begin
  LPath := PathCheckDivver(ExtractFilePath(FileName));
  I := 1;
  repeat
    LFileName := LPath + CDefaultName_Project + IntToStr(I) + '.' + CFileExt_Project;
    Inc(I);
  until (not FileExists(LFileName)) and (not Assigned(ProjectByFileName(LFileName)));

  Result := TSSMProject( ChildNew(FProjects, TSSMProject) );
  Result.FileName := LFileName;
end;

procedure TSSMSolution.ProjectRemove(AProject: TSSMProject; AWithDeleteFile: Boolean = False);
begin
  if AWithDeleteFile then begin
    if FileExists(AProject.FileName) then
      System.SysUtils.DeleteFile(AProject.FileName);
  end;
  ChildRemove(FProjects, AProject);
end;

procedure TSSMSolution.ProjectsClear;
begin
  ChildsClear(FProjects);
end;

function TSSMSolution.ProjectsIndexOf(AProject: TSSMProject): Integer;
begin
  Result := FProjects.IndexOf(AProject);
end;

procedure TSSMSolution.ProjectsSort;
begin
  FProjects.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

procedure TSSMSolution.SaveInternal;
var
  LIDoc   : IXMLDocument;
  LINode  : IXMLNode;
begin
  LINode := PrepareClearedRootNode(CNode_Solution, LIDoc);
  SaveToXml(LINode);
  LIDoc.SaveToFile(FileName);
end;

procedure TSSMSolution.SaveToXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LProject        : TSSMProject;
  LPatch          : TSSMPatch;
  LINodeProjects  : IXMLNode;
  LINodePatches   : IXMLNode;
  LINode          : IXMLNode;
begin
  LINodeProjects := AXMLNode.AddChild(CNode_Projects);
  for I := 0 to ProjectsCount-1 do begin
    LProject := Projects[I];
    if LProject.Hidden then
      Continue;

    LINode := LINodeProjects.AddChild(CNode_Project);
    LINode.Attributes[CAttribute_FileName] := TMainDataModule.GetAliasedPath(LProject.FileName, Path);
  end;

  LINodePatches := AXMLNode.AddChild(CNode_Patches);
  for I := 0 to PatchesCount-1 do begin
    LPatch := Patches[I];
    if LPatch.Hidden then
      Continue;

    LINode := LINodePatches.AddChild(CNode_Patch);
    LINode.Attributes[CAttribute_FileName] := TMainDataModule.GetAliasedPath(LPatch.FileName, Path);
  end;
end;

procedure TSSMSolution.SetParentNode(const Value: TSSMNode);
begin
  if Assigned(Value) then
    raise ESSMStructureError.Create('У решения не может быть родительского узла!');
end;

{ TSSMProject }

constructor TSSMProject.Create(AParent: TSSMNode);
begin
  inherited;
  FIsNew := True;
  FFolders := TList.Create;
  FSources := TList.Create;
end;

destructor TSSMProject.Destroy;
begin
  StartDestroy;
  // -------------------
  FoldersClear;
  FreeAndNil(FFolders);

  SourcesClear;
  FreeAndNil(FSources);

  if Assigned(Solution) then
    SelfRemoveFromList(Solution.FProjects);
  FParentNode := nil;
  // -------------------
  inherited;
end;

function TSSMProject.FolderAdd(AFolder: TSSMFolder): Integer;
begin
  Result := ChildAdd(FFolders, AFolder);
end;

function TSSMProject.FolderAddByFullName(AFolderFullName: String): TSSMFolder;
var
  LPath   : String;
  LParent : TSSMFolder;
begin
  Result := FolderNew;
  LPath := ExtractFilePath(AFolderFullName);
  LParent := FolderByFullName(LPath);
  if Assigned(LParent) then begin
    Result.ParentNode := LParent
  end else begin
    Result.FPath := LPath;
  end;

  Result.FName := ExtractFileName(AFolderFullName);
end;

function TSSMProject.FolderByFullName(AFolderFullName: String): TSSMFolder;
var
  I : Integer;
begin
  for I := 0 to FoldersCount-1 do begin
    Result := Folders[I];
    if Result.FullName = AFolderFullName then
      Exit;
    Result := Result.FolderByFullName(AFolderFullName);
    if Assigned(Result) then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMProject.FolderDelete(Index: Integer; AWithDeleteFile: Boolean);
var
  LFolder : TSSMFolder;
begin
  if AWithDeleteFile then begin
    LFolder := Folders[Index];
    if DirectoryExists(LFolder.FullName) then
      System.SysUtils.RemoveDir(LFolder.FullName);
  end;
  ChildDelete(FFolders, Index);
end;

function TSSMProject.FolderNew: TSSMFolder;
begin
  Result := TSSMFolder( ChildNew(FFolders, TSSMFolder) );
end;

procedure TSSMProject.FolderRemove(AFolder: TSSMFolder;  AWithDeleteFile: Boolean);
begin
  if AWithDeleteFile then begin
    if DirectoryExists(AFolder.FullName) then
      System.SysUtils.RemoveDir(AFolder.FullName);
  end;
  ChildRemove(FFolders, AFolder);
end;

procedure TSSMProject.FoldersClear;
begin
  ChildsClear(FFolders);
end;

function TSSMProject.FoldersIndexOf(AFolder: TSSMFolder): Integer;
begin
  Result := FFolders.IndexOf(AFolder);
end;

procedure TSSMProject.FoldersSort;
begin
  FFolders.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

function TSSMProject.GetFolder(Index: Integer): TSSMFolder;
begin
  Result := TSSMFolder(FFolders[Index]);
end;

function TSSMProject.GetFoldersCount: Integer;
begin
  Result := FFolders.Count;
end;

function TSSMProject.GetIconIndex: Integer;
begin
  Result := CIconIndex_Project;
end;

function TSSMProject.GetSolution: TSSMSolution;
begin
  Result := TSSMSolution(FParentNode);
end;

function TSSMProject.GetSource(Index: Integer): TSSMSource;
begin
  Result := TSSMSource(FSources[Index]);
end;

function TSSMProject.GetSourcesCount: Integer;
begin
  Result := FSources.Count;
end;

procedure TSSMProject.LoadFromXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LFolder         : TSSMFolder;
  LSource         : TSSMSource;
  LINodeFolders   : IXMLNode;
  LINodeSources   : IXMLNode;
  LINode          : IXMLNode;
begin
  SourcesClear;
  // Загрузка источников
  LINodeSources := AXMLNode.ChildNodes[CNode_Sources];
  if Assigned(LINodeSources) then begin
    for I := 0 to LINodeSources.ChildNodes.Count - 1 do begin
      LINode := LINodeSources.ChildNodes[I];
      if LINode.NodeName = CNode_Source then begin
        LSource := SourceNew;
        LSource.LoadFromXml(LINode);
      end;
    end;
  end;

  FoldersClear;
  // Загрузка папок
  LINodeFolders := AXMLNode.ChildNodes[CNode_Folders];
  if Assigned(LINodeFolders) then begin
    for I := 0 to LINodeFolders.ChildNodes.Count - 1 do begin
      LINode := LINodeFolders.ChildNodes[I];
      if LINode.NodeName = CNode_Folder then begin
        LFolder := FolderNew;
        LFolder.LoadFromXml(LINode);
      end;
    end;
  end;
end;

procedure TSSMProject.LoadInternal;
var
  LINode  : IXMLNode;
begin
  SolutionExplorerViewer.BeginUpdate;
  try
    LINode := GetRootNode(CNode_Project);
    if Assigned(LINode) then
      LoadFromXml(LINode);
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;


procedure TSSMProject.SaveInternal;
var
  LIDoc   : IXMLDocument;
  LINode  : IXMLNode;
begin
  LINode := PrepareClearedRootNode(CNode_Project, LIDoc);
  SaveToXml(LINode);
  LIDoc.SaveToFile(FileName);
end;

procedure TSSMProject.SaveToXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LFolder         : TSSMFolder;
  LSource         : TSSMSource;
  LINodeFolders   : IXMLNode;
  LINodeSources   : IXMLNode;
  LINode          : IXMLNode;
begin
  LINodeFolders := AXMLNode.AddChild(CNode_Folders);
  for I := 0 to FoldersCount-1 do begin
    LFolder := Folders[I];
    if LFolder.Hidden then
      Continue;

    LINode := LINodeFolders.AddChild(CNode_Folder);
    LFolder.SaveToXml(LINode);
  end;

  LINodeSources := AXMLNode.AddChild(CNode_Sources);
  for I := 0 to SourcesCount-1 do begin
    LSource := Sources[I];
    if LSource.Hidden then
      Continue;

    LINode := LINodeSources.AddChild(CNode_Source);
    LINode.Attributes[CAttribute_Server] := LSource.Server;
    LINode.Attributes[CAttribute_Database] := LSource.Database;
  end;
end;

procedure TSSMProject.SetParentNode(const Value: TSSMNode);
begin
  if Value = FParentNode then
    Exit;

  if not Assigned(Value) and Assigned(Solution) then
    SelfRemoveFromList(Solution.FProjects);

  if Assigned(Value) and (not Value.InheritsFrom(TSSMSolution)) then
    raise ESSMStructureError.Create('У проекта родительским узлом должно быть Решение!');

  inherited;

  if Assigned(Solution) and (Solution.FProjects.IndexOf(Self) < 0) then
    Solution.FProjects.Add(Self)
end;

function TSSMProject.SourceAdd(ASource: TSSMSource): Integer;
begin
  Result := ChildAdd(FSources, ASource);
end;

function TSSMProject.SourceByParams(AServer, ADatabase: String): TSSMSource;
var
  I : Integer;
begin
  for I := 0 to SourcesCount-1 do begin
    Result := Sources[I];
    if (Result.Server = AServer) and (Result.Database = ADatabase)then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMProject.SourceDelete(Index: Integer);
begin
  ChildDelete(FSources, Index);
end;

function TSSMProject.SourceNew: TSSMSource;
begin
  Result := TSSMSource( ChildNew(FSources, TSSMSource) );
end;

function TSSMProject.SourceNew(AServer, ADatabase, AUser: String): TSSMSource;
begin
  Result := SourceNew;
  Result.Server := AServer;
  Result.Database := ADatabase;
  Result.User := AUser;
end;

procedure TSSMProject.SourceRemove(ASource: TSSMSource);
begin
  ChildRemove(FSources, ASource);
end;

procedure TSSMProject.SourcesClear;
begin
  ChildsClear(FSources);
end;

function TSSMProject.SourcesIndexOf(ASource: TSSMSource): Integer;
begin
  Result := FSources.IndexOf(ASource);
end;

procedure TSSMProject.SourcesSort;
begin
  FSources.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

{ TSSMPatch }

constructor TSSMPatch.Create(AParent: TSSMNode);
begin
  inherited;
  FIsNew := True;
  FOutputs := TList.Create;
end;

destructor TSSMPatch.Destroy;
begin
  StartDestroy;
  // -------------------
  OutputsClear;
  FreeAndNil(FOutputs);
  // -------------------
  if Assigned(Solution) then
    SelfRemoveFromList(Solution.FPatches);
  FParentNode := nil;
  // -------------------
  inherited;
end;

function TSSMPatch.GetIconIndex: Integer;
begin
  Result := CIconIndex_Patch;
end;

function TSSMPatch.GetOutput(Index: Integer): TSSMOutput;
begin
  Result := TSSMOutput(FOutputs[Index]);
end;

function TSSMPatch.GetOutputsCount: Integer;
begin
  Result := FOutputs.Count;
end;

function TSSMPatch.GetSolution: TSSMSolution;
begin
  Result := TSSMSolution(FParentNode);
end;

procedure TSSMPatch.LoadFromXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LOutput         : TSSMOutput;
  LINodeOutputs   : IXMLNode;
  LINode          : IXMLNode;
begin
  OutputsClear;
  // Загрузка папок
  LINodeOutputs := AXMLNode.ChildNodes[CNode_Outputs];
  if Assigned(LINodeOutputs) then begin
    for I := 0 to LINodeOutputs.ChildNodes.Count - 1 do begin
      LINode := LINodeOutputs.ChildNodes[I];
      if LINode.NodeName = CNode_Output then begin
        LOutput := OutputNew;
        LOutput.LoadFromXml(LINode);
      end;
    end;
  end;
end;

procedure TSSMPatch.LoadInternal;
var
  LINode  : IXMLNode;
begin
  SolutionExplorerViewer.BeginUpdate;
  try
    LINode := GetRootNode(CNode_Patch);
    if Assigned(LINode) then
      LoadFromXml(LINode);
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;

function TSSMPatch.OutputAdd(AOutput: TSSMOutput): Integer;
begin
  Result := ChildAdd(FOutputs, AOutput);
end;

function TSSMPatch.OutputAddByShortName(AOutputShortName: String): TSSMOutput;
begin
  Result := OutputNew;
  Result.FName := AOutputShortName;
end;

function TSSMPatch.OutputByName(AOutputName: String): TSSMOutput;
var
  I : Integer;
begin
  for I := 0 to OutputsCount-1 do begin
    Result := Outputs[I];
    if Result.Name = AOutputName then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMPatch.OutputDelete(Index: Integer; AWithDeleteFile: Boolean);
var
  LOutput : TSSMOutput;
begin
  if AWithDeleteFile then begin
    LOutput := Outputs[Index];
    if FileExists(LOutput.FullName) then
      System.SysUtils.DeleteFile(LOutput.FullName);
  end;
  ChildDelete(FOutputs, Index);
end;

function TSSMPatch.OutputNew: TSSMOutput;
begin
  Result := TSSMOutput( ChildNew(FOutputs, TSSMOutput) );
end;

procedure TSSMPatch.OutputRemove(AOutput: TSSMOutput; AWithDeleteFile: Boolean);
begin
  if AWithDeleteFile then begin
    if FileExists(AOutput.FullName) then
      System.SysUtils.DeleteFile(AOutput.FullName);
  end;
  ChildRemove(FOutputs, AOutput);
end;

procedure TSSMPatch.OutputsClear;
begin
  ChildsClear(FOutputs);
end;

function TSSMPatch.OutputsIndexOf(AOutput: TSSMOutput): Integer;
begin
  Result := FOutputs.IndexOf(AOutput);
end;

procedure TSSMPatch.OutputsSort;
begin
  FOutputs.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

procedure TSSMPatch.SaveInternal;
var
  LIDoc   : IXMLDocument;
  LINode  : IXMLNode;
begin
  LINode := PrepareClearedRootNode(CNode_Patch, LIDoc);
  SaveToXml(LINode);
  LIDoc.SaveToFile(FileName);
end;

procedure TSSMPatch.SaveToXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LOutput         : TSSMOutput;
  LINodeOutputs   : IXMLNode;
  LINode          : IXMLNode;
begin
  LINodeOutputs := AXMLNode.AddChild(CNode_Outputs);
  for I := 0 to OutputsCount-1 do begin
    LOutput := Outputs[I];
    if LOutput.Hidden then
      Continue;

    LINode := LINodeOutputs.AddChild(CNode_Output);
    LOutput.SaveToXml(LINode);
  end;
end;

procedure TSSMPatch.SetParentNode(const Value: TSSMNode);
begin
  if Value = FParentNode then
    Exit;

  if not Assigned(Value) and Assigned(Solution) then
    SelfRemoveFromList(Solution.FProjects);

  if Assigned(Value) and (not Value.InheritsFrom(TSSMSolution)) then
    raise ESSMStructureError.Create('У патча родительским узлом должно быть Решение!');

  inherited;

  if Assigned(Solution) and (Solution.FPatches.IndexOf(Self) < 0) then
    Solution.FPatches.Add(Self)
end;

{ TSSMNodeStoreInFile }

constructor TSSMNodeStoreInFile.Create(AParent: TSSMNode);
begin
  inherited;
  FOnChanged := SolutionExplorerViewer.OnChangedSSNode;
end;

procedure TSSMNodeStoreInFile.DoStoreChanged;
begin
  inherited;
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

function TSSMNodeStoreInFile.GetPath: String;
begin
  Result := ExtractFilePath(FileName);
end;

function TSSMNodeStoreInFile.GetRootNode(ANodeName: String): IXMLNode;
var
  LIDoc   : IXMLDocument;
  LIRoot  : IXMLNode;
begin
  Result := nil;
  if FileExists(FileName) then begin
    LIDoc := LoadXMLDocument(FileName);
    LIRoot := LIDoc.Node;
    if Assigned(LIRoot) then
      Result := LIRoot.ChildNodes.Nodes[ANodeName];
  end;
end;

procedure TSSMNodeStoreInFile.Load;
begin
  LoadInternal;
  FIsNew := False;
  FChanged := False;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TSSMNodeStoreInFile.LoadFrom(AFileName: String; ATemplate : Boolean = False);
begin
  FileName := AFileName;
  LoadInternal;

  FIsNew := ATemplate;
  FChanged := False;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TSSMNodeStoreInFile.LoadFromXml(AXMLNode: IXMLNode);
begin
  FFileName := AXMLNode.Attributes[CAttribute_FileName];
end;

function TSSMNodeStoreInFile.NodeText: String;
begin
  Result := ExtractFileName(FileName);
end;

function TSSMNodeStoreInFile.PrepareClearedRootNode(ANodeName: String; var AIDoc : IXMLDocument): IXMLNode;
var
  LIRoot  : IXMLNode;
begin
  if (not IsNew) and (FileExists(FileName)) then begin
    AIDoc := LoadXMLDocument(FileName);
    LIRoot := AIDoc.Node;
    if Assigned(LIRoot) then begin
      Result := LIRoot.ChildNodes.Nodes[ANodeName];
      Result.ChildNodes.Clear;
      Result.AttributeNodes.Clear;
      if Assigned(Result) then
        LIRoot.ChildNodes.Remove(Result);
      Result := LIRoot.AddChild(ANodeName);
    end;
  end else begin
    AIDoc := LoadXMLData(CXML_Header + '<' + ANodeName + '/>');
    AIDoc.Active := True;
    LIRoot := AIDoc.Node;
    Result := LIRoot.ChildNodes.Nodes[ANodeName];
  end;
end;

procedure TSSMNodeStoreInFile.Save;
begin
  SaveInternal;
  FIsNew := False;
  FChanged := False;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TSSMNodeStoreInFile.SaveTo(AFileName: String);
begin
  FileName := AFileName;
  SaveInternal;
  FIsNew := False;
  FChanged := False;

  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TSSMNodeStoreInFile.SaveToXml(AXMLNode: IXMLNode);
begin
  AXMLNode.Attributes[CAttribute_FileName] := FFileName;
end;

procedure TSSMNodeStoreInFile.SetChanged(const Value: Boolean);
begin
  if FChanged = Value then
    Exit;
    
  FChanged := Value;
  if FChanged then
    DoStoreChanged;
end;

procedure TSSMNodeStoreInFile.SetFileName(const Value: String);
begin
  if FFileName = Value then
    Exit;

  FFileName := Value;
  DoStoreChanged;
end;

procedure TSSMNodeStoreInFile.SetOnChanged(const Value: TNotifyEvent);
begin
  FOnChanged := Value;
end;

procedure TSSMNodeStoreInFile.StartDestroy;
begin
  FDestroing := True;
end;

class function TMainDataModule.LoadDefinition_FromScript(AFileName: String; out AObjectName: String; AStrings: TStrings): Boolean;
const
  ConstBeginClassHeader : string = '-- ';
  ConstEndClassHeader   : string = '.CLASS.sql';
  ConstBeginPos: array[1..3] of string = ('EXEC [SQL].[Object Exists] @Object_Name = ''', 'EXEC [SQL].[Object Exists]' + #13#10 + '  @Object_Name    = ''', 'EXEC [SQL].[Object Exists]' + #13 + '  @Object_Name    = ''');
  ConstEndPos  : array[1..3] of string = (''', @Type = ''', ''',' + #13#10 + '  @Type           = ''TR''', ''',' + #13 + '  @Type           = ''TR''');

var
  X           : Integer;
  LMaskStart  : Integer;
  LMaskEnd    : Integer;
  S           : String;
begin
  Result := False;

  AStrings.Clear;
  AStrings.LoadFromFile(AFileName);
  AObjectName := '';
  S := AStrings.Strings[0];
  if  (S.Length > ConstBeginClassHeader.Length + ConstEndClassHeader.Length)
  and (LeftStr(S, ConstBeginClassHeader.Length) = ConstBeginClassHeader)
  and (RightStr(S, ConstEndClassHeader.Length) = ConstEndClassHeader) then begin
    AObjectName := S.Substring(3, S.Length - ConstEndClassHeader.Length - 3);
    Result := True;
    Exit;
  end;

  S := AStrings.Text;
  //-- Ищем номер пары значений
  for X := 1 to Length(ConstBeginPos) do begin
    LMaskStart := Pos(ConstBeginPos[X], S);
    if LMaskStart > 0 then begin
      LMaskEnd := Pos(ConstEndPos[X], S, LMaskStart);
      if LMaskEnd > 0 then begin
        AObjectName := Copy(S, LMaskStart + Length(ConstBeginPos[X]), LMaskEnd - LMaskStart - Length(ConstBeginPos[X]));
        if Pos(AObjectName, #13) = 0 then begin
          Result := True;
          Exit;
        end else begin
          AObjectName := '';
        end;
      end;
    end;
  end;
end;

class function TMainDataModule.LoadDefinition_FromSource(AConnection: TUniConnection; AObjectName: String; AStrings: TStrings): Boolean;
var
  LQuery : TUniQuery;
begin
  Result := False;

  AStrings.Clear;
  LQuery := TUniQuery.Create(nil);
  try
    if not AConnection.Connected then
      AConnection.Connect;

    LQuery.Connection := AConnection;
    LQuery.SQL.Text := 'DECLARE @ObjectName NVarChar(512) = :SqlObjectName SELECT [Object_Id] = OBJECT_ID(@ObjectName)';
    LQuery.ParamByName('SqlObjectName').Value := AObjectName;
    LQuery.Open;
    LQuery.First;
    if LQuery.Fields[0].IsNull then begin
      LQuery.SQL.Clear;
      LQuery.SQL.Add('DECLARE @ObjectName NVarChar(512) = :SqlObjectName');
      LQuery.SQL.Add('IF OBJECT_ID(''[Delphi].[Classes]'') IS NOT NULL');
      LQuery.SQL.Add('  SELECT [Id] FROM [Delphi].[Classes] WHERE [ClassName] = @ObjectName');
      LQuery.SQL.Add('ELSE');
      LQuery.SQL.Add('  SELECT [Id] = NULL');
      LQuery.ParamByName('SqlObjectName').Value := AObjectName;
      LQuery.Open;
      LQuery.First;
      if LQuery.Fields[0].IsNull then
        Exit;
    end;

    LQuery.Close;
    // ---
    LQuery.SQL.Text := 'EXEC [SQL].[Generate Object Text] @SqlObjectName = :SqlObjectName, @ResMode = ''SELECT''';
    LQuery.ParamByName('SqlObjectName').Value := AObjectName;
    LQuery.Open;

    LQuery.First;
    while not LQuery.Eof do begin
      AStrings.Add(LQuery.Fields[0].AsString);
      LQuery.Next;
    end;
    Result := True;
  finally
    LQuery.Close;
    LQuery.Free;
  end;
end;

class procedure TMainDataModule.LoadObjectsList(AConnection: TUniConnection; AWhereFilter: String; AObjectsList, AGeneratedScriptsNames: TStrings);
var
  LQuery : TUniQuery;
begin
  AObjectsList.Clear;
  if Assigned(AGeneratedScriptsNames) then
    AGeneratedScriptsNames.Clear;

  LQuery := TUniQuery.Create(nil);
  try
    if not AConnection.Connected then
      AConnection.Connect;

    LQuery.Connection := AConnection;
    PrepareScriptObjectsList(LQuery.SQL);
    if AWhereFilter <> '' then begin
      LQuery.SQL.Add('WHERE ' + AWhereFilter);
    end;

    LQuery.Open;
    LQuery.First;
    while (not LQuery.Eof) do begin
      AObjectsList.Add(LQuery.FieldValues['ObjectFullName']);
      if Assigned(AGeneratedScriptsNames) then
        AGeneratedScriptsNames.Add(LQuery.FieldValues['ScriptName']);
      LQuery.Next;
    end;
    LQuery.Close;
  finally
    LQuery.Free;
  end;
end;

procedure TMainDataModule.LoadSolution(ASolutionFileName : String);
begin
  SolutionExplorerViewer.BeginUpdate;
  try
    FCurrentSolution := TSSMSolution.Create(nil);
    FCurrentSolution.LoadFrom(ASolutionFileName);
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;

procedure TMainDataModule.NewSolution(AWithEmptyProject: Boolean; ASolutionFileName : String = '');
var
  I                   : Integer;
  LFileName           : String;
  LProjectDefaultPath : Variant;
begin
  SolutionExplorerViewer.BeginUpdate;
  try
    LProjectDefaultPath := IsNull(Settings[CSettingGroup_DefPathes, CSettingValue_ProjectsDefPath] ,'');
    LProjectDefaultPath := PathCheckDivver(LProjectDefaultPath);

    LoadSolution(ApplicationFileNameOnly + CFileName_EmptySolution);
    if ASolutionFileName = '' then begin
      I := 1;
      repeat
        LFileName := LProjectDefaultPath + CDefaultName_Solution + IntToStr(I) + '.' + CFileExt_Solution;
        Inc(I);
      until (not FileExists(LFileName));
    end else
      LFileName := ASolutionFileName;

    FCurrentSolution.FileName := LFileName;
    FCurrentSolution.FIsNew := True;

    // -- Если в шаблоне будут уже проекты и патчи по умолчанию
    for I := 0 to FCurrentSolution.ProjectsCount - 1 do
      FCurrentSolution.Projects[I].FIsNew := False;
    for I := 0 to FCurrentSolution.PatchesCount - 1 do
      FCurrentSolution.Patches[I].FIsNew := False;

    if AWithEmptyProject and (FCurrentSolution.ProjectsCount <= 0) then begin
      FCurrentSolution.ProjectNew;
    end;
  finally
    SolutionExplorerViewer.EndUpdate;
  end;
end;

class procedure TMainDataModule.PrepareScriptObjectsList(AStrings: TStrings);
begin
  AStrings.Add('SELECT');
  AStrings.Add('  O.*');
  AStrings.Add('FROM');
  AStrings.Add('(');
  AStrings.Add('  SELECT');
  AStrings.Add('    [Object_Id]       = O.[object_id],');
  AStrings.Add('    [ObjectFullName]  = QUOTENAME(S.[name]) + N''.'' + QUOTENAME(O.[name]),');
  AStrings.Add('    [ObjectNamespace] = NULL,');
  AStrings.Add('    [ObjectSchema]    = S.[name],');
  AStrings.Add('    [ObjectName]      = O.[name],');
  AStrings.Add('    [ObjectType]      = O.[type],');
  AStrings.Add('    [ScriptName]      = S.[name] + N''.'' + REPLACE(REPLACE(REPLACE(REPLACE(O.[name], N''::'', N''.''), N'':'', N''.''), N''/'', N''_''), N''?'', N''.'') + N''.sql''');
  AStrings.Add('  FROM [sys].[all_objects] O');
  AStrings.Add('  INNER JOIN [sys].[schemas] S ON S.[schema_id] = O.[schema_id]');
  AStrings.Add('  ------');
  AStrings.Add('  UNION ALL');
  AStrings.Add('  ------');
  AStrings.Add('  SELECT');
  AStrings.Add('    [Object_Id]       = NULL,');
  AStrings.Add('    [ObjectFullName]  = C.[ClassName],');
  AStrings.Add('    [ObjectNamespace] = N.[Name],');
  AStrings.Add('    [ObjectSchema]    = NULL,');
  AStrings.Add('    [ObjectName]      = C.[ClassName],');
  AStrings.Add('    [ObjectType]      = ''CLASS'',');
  AStrings.Add('    [ScriptName]      = C.[ClassName] + N''.CLASS.sql''');
  AStrings.Add('  FROM [Delphi].[Classes] C');
  AStrings.Add('  INNER JOIN [Delphi].[Namespaces] N ON N.[Id] = C.[Namespace_Id]');
  AStrings.Add(') O');
end;

procedure TMainDataModule.SetSetting(ASetion, ASettingName: String; const Value: Variant);
begin
  if VarIsPresent(Value) then
    FSettings.WriteString(ASetion, ASettingName, Value)
  else
    FSettings.DeleteKey(ASetion, ASettingName);
end;

function TMainDataModule.ShowComparerForm(ANode: TSSMNode): TForm;
var
  LParams   : TNamedVariants;
begin
  Result := MainForm.ShowFormByNode(ANode);
  if Assigned(Result) then
    Exit;

  LParams := TNamedVariants.Create(True);
  if ANode.InheritsFrom(TSSMFolder) then begin
    LParams.Values[CParam_WorkSource] := Integer( Pointer(ANode) );
    LParams.Values[CParam_Project] := Integer( Pointer( TSSMFolder(ANode).Project) );
  end else if ANode.InheritsFrom(TSSMSource) then begin
    LParams.Values[CParam_WorkSource] := Integer( Pointer(SolutionExplorerViewer.CurrentNode) );
    LParams.Values[CParam_Project] := Integer( Pointer( TSSMSource(ANode).Project) );
  end else if ANode.InheritsFrom(TSSMProject) then begin
    LParams.Values[CParam_Project] := Integer( Pointer(ANode) );
  end;

  Result := TSSMComparerForm.CreateWithLN(MainForm, ANode, LParams);
end;

function TMainDataModule.ShowFilterForm(ANode: TSSMNode): TForm;
var
  LFilter : TSSMFilter;
begin
  Result := nil;
  if not Assigned(ANode) then
    Exit;
  if ANode.InheritsFrom(TSSMFilter) then begin
    LFilter := TSSMFilter(ANode);
  end else if ANode.InheritsFrom(TSSMFolder) then begin
    TSSMFolder(ANode).FilterCreate;
    LFilter := TSSMFolder(ANode).Filter;
  end else
    LFilter := nil;

  if not Assigned(LFilter) then
    Exit;

  Result := MainForm.ShowFormByNode(ANode);
  if Assigned(Result) then
    Exit;

  Result := TSSMFilterEditorForm.CreateWithLN(MainForm, LFilter, TNamedVariants.Create(Null));
end;

{ TSSMFolder }

constructor TSSMFolder.Create(AParent: TSSMNode);
begin
  inherited;
  FFolders := TList.Create;
  FScripts := TList.Create;
end;

procedure TSSMFolder.Delete(AWithDeleteFile: Boolean);
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMProject) then
    TSSMProject(ParentNode).FolderRemove(Self, AWithDeleteFile)
  else if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMFolder) then
    TSSMFolder(ParentNode).FolderRemove(Self, AWithDeleteFile);
end;

destructor TSSMFolder.Destroy;
begin
  FoldersClear;
  FreeAndNil( FFolders );
  // -------------------------
  ScriptsClear;
  FreeAndNil( FScripts );
  // -------------------------
  FreeAndNil( FFilter );

  inherited;
end;

procedure TSSMFolder.FilterCreate;
begin
  if Assigned(FFilter) then
    Exit;

  FFilter := TSSMFilter.Create(Self);
  DoStoreChanged;
end;

procedure TSSMFolder.FilterDelete;
begin
  if not Assigned(FFilter) then
    Exit;
  
  FreeAndNil(FFilter);
  DoStoreChanged;
end;

function TSSMFolder.FolderAdd(AFolder: TSSMFolder): Integer;
begin
  Result := ChildAdd(FFolders, AFolder);
end;

function TSSMFolder.FolderAddByShortName(AFolderShortName: String): TSSMFolder;
var
  LFullSubFolderName : String;
begin
  LFullSubFolderName := PathCheckDivver(FullName) + AFolderShortName;
  Result := FolderNew;
  Result.FName := AFolderShortName;
end;

function TSSMFolder.FolderByFullName(AFolderFullName: String): TSSMFolder;
var
  I : Integer;
begin
  for I := 0 to FoldersCount-1 do begin
    Result := Folders[I];
    if Result.FullName = AFolderFullName then
      Exit;
    Result := Result.FolderByFullName(AFolderFullName);
    if Assigned(Result) then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMFolder.FolderDelete(Index: Integer; AWithDeleteFile: Boolean);
var
  LFolder : TSSMFolder;
begin
  if AWithDeleteFile then begin
    LFolder := Folders[Index];
    if DirectoryExists(LFolder.FullName) then
      System.SysUtils.RemoveDir(LFolder.FullName);
  end;
  ChildDelete(FFolders, Index);
end;

function TSSMFolder.FolderNew: TSSMFolder;
begin
  Result := TSSMFolder( ChildNew(FFolders, TSSMFolder) );
end;

procedure TSSMFolder.FolderRemove(AFolder: TSSMFolder; AWithDeleteFile: Boolean);
begin
  if AWithDeleteFile then begin
    if DirectoryExists(AFolder.FullName) then
      System.SysUtils.RemoveDir(AFolder.FullName);
  end;
  ChildRemove(FFolders, AFolder);
end;

procedure TSSMFolder.FoldersClear;
begin
  ChildsClear(FFolders);
end;

function TSSMFolder.FoldersIndexOf(AFolder: TSSMFolder): Integer;
begin
  Result := FFolders.IndexOf(AFolder);
end;

procedure TSSMFolder.FoldersSort;
begin
  FFolders.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

function TSSMFolder.GetFolder(Index: Integer): TSSMFolder;
begin
  Result := TSSMFolder(FFolders[Index]);
end;

function TSSMFolder.GetFoldersCount: Integer;
begin
  Result := FFolders.Count;
end;

function TSSMFolder.GetFullName: String;
begin
  Result := PathCheckDivver(Path) + Name;
end;

function TSSMFolder.GetIconIndex: Integer;
begin
  Result := CIconIndex_Folder;
end;

function TSSMFolder.GetIsEmptyFilter: Boolean;
begin
  Result := (not Assigned(FFilter))
         or (FFilter.FWhereFilter.IsEmpty);
end;

function TSSMFolder.GetPath: String;
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMProject) then
    Result := FPath
  else if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMFolder) then
    Result := PathCheckDivver(TSSMFolder(ParentNode).Path) + TSSMFolder(ParentNode).Name
  else
    Result := '';
end;

function TSSMFolder.GetProject: TSSMProject;
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMProject) then
    Result := TSSMProject(ParentNode)
  else if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMFolder) then
    Result := TSSMFolder(ParentNode).Project
  else
    Result := nil;
end;

function TSSMFolder.GetScript(Index: Integer): TSSMScript;
begin
  Result := TSSMScript(FScripts[Index]);
end;

function TSSMFolder.GetScriptsCount: Integer;
begin
  Result := FScripts.Count;
end;

procedure TSSMFolder.LoadFromXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LFolder         : TSSMFolder;
  LScript         : TSSMScript;
  LINodeFilter    : IXMLNode;
  LINodeFolders   : IXMLNode;
  LINodeScripts   : IXMLNode;
  LINode          : IXMLNode;
  LFullName       : Variant;
begin
  if ParentNode.InheritsFrom(TSSMFolder) then
    FName := AXMLNode.Attributes[CAttribute_Name]
  else begin
    LFullName := AXMLNode.Attributes[CAttribute_FullName];
    if VarIsEmpty(LFullName) or VarIsNull(LFullName) then
      raise ESSMStructureError.Create('В файле проекта ошибка. Не указано полное имя папки...');
    FPath := ExtractFilePath(LFullName);
    FName := ExtractFileName(LFullName);
  end;

  // ------------------------------------
  FoldersClear;
  // Загрузка папок
  LINodeFolders := AXMLNode.ChildNodes[CNode_Folders];
  if Assigned(LINodeFolders) then begin
    for I := 0 to LINodeFolders.ChildNodes.Count - 1 do begin
      LINode := LINodeFolders.ChildNodes[I];
      if LINode.NodeName = CNode_Folder then begin
        LFolder := FolderNew;
        LFolder.LoadFromXml(LINode);
      end;
    end;
  end;
  FoldersSort;

  // ------------------------------------
  ScriptsClear;
  // Загрузка скриптов
  LINodeScripts := AXMLNode.ChildNodes[CNode_Scripts];
  if Assigned(LINodeScripts) then begin
    for I := 0 to LINodeScripts.ChildNodes.Count - 1 do begin
      LINode := LINodeScripts.ChildNodes[I];
      if LINode.NodeName = CNode_Script then begin
        LScript := ScriptNew;
        LScript.LoadFromXml(LINode);
      end;
    end;
  end;
  ScriptsSort;

  // ------------------------------------
  // TODO: Понять почему всегда возвращает узел, даже если его нет.
  LINodeFilter := AXMLNode.ChildNodes.FindNode(CNode_Filter);
  if Assigned(LINodeFilter) then begin
    FilterCreate;
    Filter.LoadFromXml(LINodeFilter);
  end;
end;

function TSSMFolder.NodeText: String;
begin
  Result := FName;
end;

procedure TSSMFolder.Rename(ANewName: String);
begin
  if DirectoryExists(FullName) then
    RenameFile(FullName, PathCheckDivver(Path) + ANewName);

  FName := ANewName;
  DoStoreChanged;
end;

procedure TSSMFolder.SaveToXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LFolder         : TSSMFolder;
  LScript         : TSSMScript;
  LINodeFilter    : IXMLNode;
  LINodeFolders   : IXMLNode;
  LINodeScripts   : IXMLNode;
  LINode          : IXMLNode;
begin
  if ParentNode.InheritsFrom(TSSMFolder) then
    AXMLNode.Attributes[CAttribute_Name] := Name
  else
    AXMLNode.Attributes[CAttribute_FullName] := FullName;

  LINodeFolders := AXMLNode.AddChild(CNode_Folders);
  for I := 0 to FoldersCount-1 do begin
    LFolder := Folders[I];
    if LFolder.Hidden then
      Continue;

    LINode := LINodeFolders.AddChild(CNode_Folder);
    LFolder.SaveToXml(LINode);
  end;

  LINodeScripts := AXMLNode.AddChild(CNode_Scripts);
  for I := 0 to ScriptsCount-1 do begin
    LScript := Scripts[I];
    if LScript.Hidden then
      Continue;

    LINode := LINodeScripts.AddChild(CNode_Script);
    LScript.SaveToXml(LINode);
  end;

  if Assigned(Filter) then begin
    if not Filter.Hidden then begin
      LINodeFilter := AXMLNode.AddChild(CNode_Filter);
      Filter.SaveToXml(LINodeFilter);
    end;
  end;
end;

function TSSMFolder.ScriptAdd(AScript: TSSMScript): Integer;
begin
  Result := ChildAdd(FScripts, AScript);
end;

function TSSMFolder.ScriptAddByShortName(AScriptShortName: String): TSSMScript;
begin
  if Assigned(ScriptByName(AScriptShortName)) then
    raise ESSMFileError.Create('Такой скрипт уже есть в папке!');
  
  Result := ScriptNew;
  Result.FName := AScriptShortName;
  Result.DoStoreChanged;
end;

function TSSMFolder.ScriptByName(AScriptName: String): TSSMScript;
var
  I : Integer;
begin
  for I := 0 to ScriptsCount-1 do begin
    Result := Scripts[I];
    if Result.Name = AScriptName then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMFolder.ScriptDelete(Index: Integer; AWithDeleteFile: Boolean);
var
  LScript : TSSMScript;
begin
  if AWithDeleteFile then begin
    LScript := Scripts[Index];
    if FileExists(LScript.FullName) then
      System.SysUtils.DeleteFile(LScript.FullName);
  end;
  ChildDelete(FScripts, Index);
end;

function TSSMFolder.ScriptNew: TSSMScript;
begin
  Result := TSSMScript( ChildNew(FScripts, TSSMScript) );
end;

procedure TSSMFolder.ScriptRemove(AScript: TSSMScript; AWithDeleteFile: Boolean);
begin
  if AWithDeleteFile then begin
    if FileExists(AScript.FullName) then
      System.SysUtils.DeleteFile(AScript.FullName);
  end;
  ChildRemove(FScripts, AScript);
end;

procedure TSSMFolder.ScriptsClear;
begin
  ChildsClear(FScripts);
end;

function TSSMFolder.ScriptsIndexOf(AScript: TSSMScript): Integer;
begin
  Result := FScripts.IndexOf(AScript);
end;

procedure TSSMFolder.ScriptsSort;
begin
  FScripts.Sort(SSMCompareNodes);
  // TODO: Подумать! Sort используется внутри Refresh
  // DoStoreChanged;
end;

{ TSSMSource }

function TSSMSource.Connect: Boolean;
begin
  FConnection.Connect;
  Result := FConnection.Connected;
end;

constructor TSSMSource.Create(AParent: TSSMNode);
begin
  inherited;
  FConnection := TUniConnection.Create(nil);
  FConnection.ProviderName := CConnection_Provider;
  FConnection.LoginPrompt := True;
end;

procedure TSSMSource.Delete;
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMProject) then
    TSSMProject(ParentNode).SourceRemove(Self);
end;

destructor TSSMSource.Destroy;
begin
  FreeAndNil(FConnection);
  inherited;
end;

procedure TSSMSource.Disconnect;
begin
  FConnection.Disconnect;
end;

function TSSMSource.GetConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

function TSSMSource.GetDatabase: String;
begin
  Result := FConnection.Database;
end;

function TSSMSource.GetIconIndex: Integer;
begin
  if Connected then
    Result := CIconIndex_SourceConnected
  else
    Result := CIconIndex_SourceDisConnected;
end;

function TSSMSource.GetIsWinAuthentication: Boolean;
begin
  Result := (FConnection.SpecificOptions.Values[CConnection_MSSQL_Authentication] = CConnection_MSSQL_Win);
end;

function TSSMSource.GetLoginPrompt: Boolean;
begin
  Result := FConnection.LoginPrompt;
end;

function TSSMSource.GetPassword: String;
begin
  Result := FConnection.Password;
end;

function TSSMSource.GetProject: TSSMProject;
begin
  Result := TSSMProject(ParentNode);
end;

function TSSMSource.GetServer: String;
begin
  Result := FConnection.Server;
end;

function TSSMSource.GetUser: String;
begin
  Result := FConnection.Username;
end;

procedure TSSMSource.LoadFromXml(AXMLNode: IXMLNode);
var
  LWinAuth  : String;
begin
  FConnection.LoginPrompt := False;
  try
    Server := IsNull(AXMLNode.Attributes[CAttribute_Server], '');
    Database := IsNull(AXMLNode.Attributes[CAttribute_Database], '');
    LWinAuth := IsNull(AXMLNode.Attributes[CAttribute_WinAuthentication], 'Null');
    if (LWinAuth = 'True') then
      IsWinAuthentication := True
    else begin
      User := IsNull(AXMLNode.Attributes[CAttribute_User], '');
      if (User = '') and (LWinAuth = 'Null') then
        IsWinAuthentication := True
      else begin
        IsWinAuthentication := False;
        Password := IsNull(AXMLNode.Attributes[CAttribute_Password], '');
      end;
    end;
  finally
    try
      FConnection.Connect;
    except
    end;
    FConnection.LoginPrompt := True;
  end;
end;

function TSSMSource.NodeText: String;
begin
  Result := Server + '/' + Database;
end;

procedure TSSMSource.SaveToXml(AXMLNode: IXMLNode);
begin
  AXMLNode.Attributes[CAttribute_Server] := Server;
  AXMLNode.Attributes[CAttribute_Database] := Database;
  AXMLNode.Attributes[CAttribute_WinAuthentication] := IsWinAuthentication;
  if not IsWinAuthentication then begin
    AXMLNode.Attributes[CAttribute_User] := User;
    AXMLNode.Attributes[CAttribute_Password] := Password;
  end;
end;

procedure TSSMSource.SetConnected(const Value: Boolean);
begin

end;

procedure TSSMSource.SetDatabase(const Value: String);
begin
  if FConnection.Database = Value then
    Exit;

  FConnection.Database := Value;
  DoStoreChanged;
end;

procedure TSSMSource.SetIsWinAuthentication(const Value: Boolean);
begin
  if IsWinAuthentication = Value then
    Exit;

  if Value then
    FConnection.SpecificOptions.Values[CConnection_MSSQL_Authentication] := CConnection_MSSQL_Win
  else
    FConnection.SpecificOptions.Values[CConnection_MSSQL_Authentication] := CConnection_MSSQL_Sql;
  DoStoreChanged;
end;

procedure TSSMSource.SetLoginPrompt(const Value: Boolean);
begin
  FConnection.LoginPrompt := Value;
end;

procedure TSSMSource.SetPassword(const Value: String);
begin
  if FConnection.Password = Value then
    Exit;
  
  FConnection.Password := Value;
  DoStoreChanged;
end;

procedure TSSMSource.SetServer(const Value: String);
begin
  if FConnection.Server = Value then
    Exit;

  FConnection.Server := Value;
  DoStoreChanged;
end;

procedure TSSMSource.SetUser(const Value: String);
begin
  if FConnection.Username = Value then
    Exit;

  FConnection.Username := Value;
  DoStoreChanged;
end;

{ TSSMScript }

constructor TSSMScript.Create(AParent: TSSMNode);
begin
  inherited;

end;

procedure TSSMScript.Delete(AWithDeleteFile: Boolean);
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMFolder) then
    TSSMFolder(ParentNode).ScriptRemove(Self, AWithDeleteFile);
end;

destructor TSSMScript.Destroy;
begin
  inherited;
end;

function TSSMScript.GetFullName: String;
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMFolder) then
    Result := PathCheckDivver( TSSMFolder(ParentNode).FullName ) + FName
  else
    Result := FName;
end;

function TSSMScript.GetIconIndex: Integer;
begin
  Result := CIconIndex_Script;
end;

procedure TSSMScript.LoadFromXml(AXMLNode: IXMLNode);
begin
  FName := IsNull(AXMLNode.Attributes[CAttribute_Name], '');
end;

function TSSMScript.NodeText: String;
begin
  Result := FName;
end;

procedure TSSMScript.SaveToXml(AXMLNode: IXMLNode);
begin
  AXMLNode.Attributes[CAttribute_Name] := Name;
end;

procedure TSSMScript.SetName(const Value: String);
begin
  if FName = Value then
    Exit;

  FName := Value;
  DoStoreChanged;
end;

procedure TSSMScript.SetSQLObject(const Value: String);
begin
  if FSQLObject = Value then
    Exit;
  
  FSQLObject := Value;
  DoStoreChanged;
end;

{ TSSMInput }

constructor TSSMInput.Create(AParent: TSSMNode);
begin
  inherited;
end;

procedure TSSMInput.Delete;
begin
  if Assigned(Output) then
    Output.InputRemove(Self);
end;

destructor TSSMInput.Destroy;
begin
  inherited;
end;

function TSSMInput.GetIconIndex: Integer;
begin
  Result := CIconIndex_Input;
end;

function TSSMInput.GetOutput: TSSMOutput;
begin
  Result := TSSMOutput(ParentNode);
end;

function TSSMInput.GetPatch: TSSMPatch;
begin
  if Assigned(Output) and Assigned(Output.Patch) then
    Result := Output.Patch
  else
    Result := nil;
end;

function TSSMInput.GetSortOrder: Integer;
begin
  Result := Output.InputsIndexOf(Self);
end;

procedure TSSMInput.LoadFromXml(AXMLNode: IXMLNode);
begin
  AliasedName := IsNull(AXMLNode.Attributes[CAttribute_FileName], '');
end;

procedure TSSMInput.MoveDown(ASteps: Integer = 1);
var
  LCurrentIndex : Integer;
begin
  LCurrentIndex := SortOrder;
  if ASteps > (Output.InputsCount - LCurrentIndex - 1) then
    ASteps := (Output.InputsCount - LCurrentIndex - 1);

  Output.FInputs.Move(LCurrentIndex, LCurrentIndex + ASteps);
  DoStoreChanged;
end;

procedure TSSMInput.MoveFirst;
begin
  Output.FInputs.Move(SortOrder, 0);
end;

procedure TSSMInput.MoveLast;
begin
  Output.FInputs.Move(SortOrder, Output.InputsCount - 1);
end;

procedure TSSMInput.MoveUp(ASteps: Integer = 1);
var
  LCurrentIndex : Integer;
begin
  LCurrentIndex := SortOrder;
  if ASteps > LCurrentIndex then
    ASteps := LCurrentIndex;

  Output.FInputs.Move(LCurrentIndex, LCurrentIndex - ASteps);
  DoStoreChanged;
end;

function TSSMInput.NodeText: String;
begin
  Result := AliasedName;
end;

procedure TSSMInput.SaveToXml(AXMLNode: IXMLNode);
begin
  AXMLNode.Attributes[CAttribute_FileName] := AliasedName;
end;

procedure TSSMInput.SetAliasedName(const Value: String);
begin
  if FAliasedName = Value then
    Exit;

  FAliasedName := Value;
  if Assigned(Patch) then
    FFileName := TMainDataModule.GetUnaliasedPath(FFileName, Patch.Path);
  DoStoreChanged;
end;

procedure TSSMInput.SetFileName(const Value: String);
begin
  if FFileName = Value then
    Exit;

  FFileName := Value;
  if Assigned(Patch) then
    FAliasedName := TMainDataModule.GetAliasedPath(FFileName, Patch.Path);
  DoStoreChanged;
end;

procedure TSSMInput.SetSortOrder(const Value: Integer);
var
  LOldSortOrder : Integer;
begin
  LOldSortOrder := SortOrder;
  if LOldSortOrder = Value then
    Exit;

  Output.FInputs.Move(LOldSortOrder, Value);

  DoStoreChanged;
end;

{ TSSMOutput }

constructor TSSMOutput.Create(AParent: TSSMNode);
begin
  inherited;
  FInputs := TList.Create;
end;

procedure TSSMOutput.Delete(AWithDeleteFile: Boolean);
begin
  if Assigned(Patch) then
    Patch.OutputRemove(Self, AWithDeleteFile);
end;

destructor TSSMOutput.Destroy;
begin
  InputsClear;
  FreeAndNil(FInputs);
  inherited;
end;

function TSSMOutput.GetFullName: String;
begin
  if Assigned(ParentNode) and ParentNode.InheritsFrom(TSSMPatch) then
    Result := PathCheckDivver( TSSMPatch(ParentNode).Path ) + FName
  else
    Result := FName;
end;

function TSSMOutput.GetIconIndex: Integer;
begin
  Result := CIconIndex_Output;
end;

function TSSMOutput.GetInput(Index: Integer): TSSMInput;
begin
  Result := TSSMInput(FInputs[Index]);
end;

function TSSMOutput.GetInputsCount: Integer;
begin
  Result := FInputs.Count;
end;

function TSSMOutput.GetPatch: TSSMPatch;
begin
  Result := TSSMPatch( ParentNode );
end;

function TSSMOutput.InputAdd(AInput: TSSMInput): Integer;
begin
  Result := ChildAdd(FInputs, AInput);
end;

function TSSMOutput.InputAddByFullName(AInputFullName: String): TSSMInput;
begin
  Result := InputByFullName(AInputFullName);
  if not Assigned(Result) then begin
    SolutionExplorerViewer.BeginUpdate;
    try
      Result := InputNew;
      Result.FileName := AInputFullName;
    finally
      SolutionExplorerViewer.EndUpdate;
    end;
  end;
end;

function TSSMOutput.InputByAliasedName(AInputName: String): TSSMInput;
var
  I : Integer;
begin
  for I := 0 to InputsCount - 1 do begin
    Result := Inputs[I];
    if Result.AliasedName = AInputName then
      Exit;
  end;
  Result := nil;
end;

function TSSMOutput.InputByFullName(AInputName: String): TSSMInput;
var
  I : Integer;
begin
  for I := 0 to InputsCount - 1 do begin
    Result := Inputs[I];
    if Result.FileName = AInputName then
      Exit;
  end;
  Result := nil;
end;

procedure TSSMOutput.InputDelete(Index: Integer);
begin
  ChildDelete(FInputs, Index);
end;

function TSSMOutput.InputNew: TSSMInput;
begin
  Result := TSSMInput( ChildNew(FInputs, TSSMInput) );
end;

procedure TSSMOutput.InputRemove(AInput: TSSMInput);
begin
  ChildRemove(FInputs, AInput);
end;

procedure TSSMOutput.InputsClear;
begin
  ChildsClear(FInputs);
end;

function TSSMOutput.InputsIndexOf(AInput: TSSMInput): Integer;
begin
  Result := FInputs.IndexOf(AInput);
end;

procedure TSSMOutput.LoadFromXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LInput          : TSSMInput;
  LINodeInputs    : IXMLNode;
  LINode          : IXMLNode;
begin
  FName := AXMLNode.Attributes[CAttribute_Name];

  // ------------------------------------
  InputsClear;
  // Загрузка вхоядщих скриптов
  LINodeInputs := AXMLNode.ChildNodes[CNode_Inputs];
  if Assigned(LINodeInputs) then begin
    for I := 0 to LINodeInputs.ChildNodes.Count - 1 do begin
      LINode := LINodeInputs.ChildNodes[I];
      if LINode.NodeName = CNode_Input then begin
        LInput := InputNew;
        LInput.LoadFromXml(LINode);
      end;
    end;
  end;
end;

function TSSMOutput.NodeText: String;
begin
  Result := FName;
end;

procedure TSSMOutput.SaveToXml(AXMLNode: IXMLNode);
var
  I               : Integer;
  LInput          : TSSMInput;
  LINodeInputs    : IXMLNode;
  LINode          : IXMLNode;
begin
  AXMLNode.Attributes[CAttribute_Name] := Name;

  LINodeInputs := AXMLNode.AddChild(CNode_Inputs);
  for I := 0 to InputsCount-1 do begin
    LInput := Inputs[I];
    if LInput.Hidden then
      Continue;

    LINode := LINodeInputs.AddChild(CNode_Input);
    LInput.SaveToXml(LINode);
  end;
end;

procedure TSSMOutput.SetName(const Value: String);
begin
  if FName = Value then
    Exit;

  FName := Value;
  DoStoreChanged;
end;

{ TSSMFilter }

function TSSMFilter.GetFolder: TSSMFolder;
begin
  Result := TSSMFolder(ParentNode);
end;

function TSSMFilter.GetIconIndex: Integer;
begin
  Result := CIconIndex_Filter;
end;

procedure TSSMFilter.LoadFromXml(AXMLNode: IXMLNode);
begin
  FWhereFilter := IsNull(AXMLNode.Attributes[CAttribute_WhereFilter], '');
end;

function TSSMFilter.NodeText: String;
begin
  if FWhereFilter.IsEmpty then
    Result := CFilter_Emptу
  else
    Result := CFilter_Filled;
end;

procedure TSSMFilter.SaveToXml(AXMLNode: IXMLNode);
begin
  if FWhereFilter = '' then
    AXMLNode.Attributes[CAttribute_WhereFilter] := Null
  else
    AXMLNode.Attributes[CAttribute_WhereFilter] := FWhereFilter;
end;

procedure TSSMFilter.SetWhereFilter(const Value: String);
begin
  if FWhereFilter = Value then
    Exit;

  FWhereFilter := Value;
  DoStoreChanged;
end;

end.
