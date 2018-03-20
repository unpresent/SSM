unit SSMFilterEditorFormUnit;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,

  Vcl.Menus,
  Vcl.ActnList,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.Forms,
  Vcl.Dialogs,

  NamedVariables,
  LayoutPanel,
  MainDataModuleUnit,
  SSMBaseFormUnit,

  dxBar,
  cxClasses,

  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxControls, cxContainer,
  cxEdit, cxGroupBox, cxButtons, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxMemo,
  cxSplitter, SynEdit, SynEditHighlighter, SynHighlighterSQL, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinsdxBarPainter;

type
  TSSMFilterEditorForm = class(TSSMBaseForm)
    PanelButtons: TGroupPanel;
    OkButton: TcxButton;
    ObjectsSourcesGroupBox: TcxLayoutGroupBox;
    FolderPanel: TLayoutPanel;
    FolderEdit: TcxTextEdit;
    SQLPanel: TLayoutPanel;
    WherePanel: TLayoutPanel;
    SQLSplitter: TcxSplitter;
    SQLMemo: TSynEdit;
    WhereMemo: TSynEdit;
    SynSQLSyn: TSynSQLSyn;
    procedure WhereMemoChange(Sender: TObject);
  private
    function GetFilter: TSSMFilter;
  protected
    property Filter : TSSMFilter read GetFilter;
  public
    constructor Create(AOwner : TComponent; AParams : TNamedVariants); override;
  end;

implementation

{$R *.dfm}

{ TSSMFilterEditorForm }

constructor TSSMFilterEditorForm.Create(AOwner: TComponent; AParams: TNamedVariants);
begin
  inherited;
  FolderEdit.EditValue := Filter.Folder.FullName;
  TMainDataModule.PrepareScriptObjectsList(SQLMemo.Lines);
  WhereMemo.Lines.Text := Filter.WhereFilter;
end;

function TSSMFilterEditorForm.GetFilter: TSSMFilter;
begin
  Result := TSSMFilter(LinkedNode);
end;

procedure TSSMFilterEditorForm.WhereMemoChange(Sender: TObject);
begin
  inherited;
  Filter.WhereFilter := WhereMemo.Lines.Text;
end;

end.
