program SQLScriptMaker;

uses
  Vcl.Forms,
  System.SysUtils,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  MainDataModuleUnit in 'MainDataModuleUnit.pas' {MainDataModule: TDataModule},
  SSMSolutionExplorer in 'SSMSolutionExplorer.pas',
  SSMBaseFormUnit in 'SSMBaseFormUnit.pas' {SSMBaseForm},
  SSMComparerFormUnit in 'SSMComparerFormUnit.pas' {SSMComparerForm},
  SSMPatchEditorFormUnit in 'SSMPatchEditorFormUnit.pas' {SSMPatchEditorForm},
  SSMFilterEditorFormUnit in 'SSMFilterEditorFormUnit.pas' {SSMFilterEditorForm};

{$R *.res}

var
  LFileName : String;
  LExt      : String;
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.CreateForm(TMainForm, MainForm);
  TSSMSolutionExplorerViewer.Create(MainForm.SolutionExplorer);

  if ParamCount <= 0 then begin
    // MainDataModule.NewSolution(True);
  end else begin
    LFileName := ParamStr(1);
    LExt := ExtractFileExt(LFileName);
    if LExt = '.' + CFileExt_Solution then begin
      MainDataModule.LoadSolution(LFileName);
      MainForm.RefreshSolutionExplorer;
    end else if LExt = '.' + CFileExt_Project then begin
      MainDataModule.NewSolution(False);
      MainDataModule.CurrentSolution.ProjectAddExisting(LFileName);
      MainForm.RefreshSolutionExplorer;
    end else if LExt = '.' + CFileExt_Patch then begin
      MainDataModule.NewSolution(False);
      MainDataModule.CurrentSolution.PatchAddExisting(LFileName);
      MainForm.RefreshSolutionExplorer;
    end;
  end;

  Application.Run;
end.
