unit SSMBaseFormUnit;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,

  Winapi.Windows,
  Winapi.Messages,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ActnList,

  cxClasses,
  dxBar,

  NamedVariables,
  MainDataModuleUnit;

type
  TSSMBaseForm = class(TForm)
    FormActionList  : TActionList;
    ActionClose     : TAction;
    FromPopupMenu: TdxBarPopupMenu;
    FormBarManager: TdxBarManager;
    FormItemClose: TdxBarButton;
    procedure ActionCloseExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FLinkedNode : TSSMNode;
  protected
    procedure SetLinkedNode(const Value: TSSMNode); virtual;
  public
    constructor Create(AOwner : TComponent; AParams : TNamedVariants); reintroduce; virtual;
    constructor CreateWithLN(AOwner : TComponent; ALinkedNode : TSSMNode; AParams : TNamedVariants);
    property LinkedNode : TSSMNode read FLinkedNode write SetLinkedNode;
  end;

implementation

{$R *.dfm}

procedure TSSMBaseForm.ActionCloseExecute(Sender: TObject);
begin
  Close;
end;

constructor TSSMBaseForm.Create(AOwner: TComponent; AParams: TNamedVariants);
begin
  inherited Create(AOwner);
end;

constructor TSSMBaseForm.CreateWithLN(AOwner: TComponent; ALinkedNode: TSSMNode;  AParams: TNamedVariants);
begin
  FLinkedNode := ALinkedNode;
  Create(AOwner, AParams);
end;

procedure TSSMBaseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TSSMBaseForm.SetLinkedNode(const Value: TSSMNode);
begin
  FLinkedNode := Value;
end;

end.
