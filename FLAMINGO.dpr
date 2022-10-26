program FLAMINGO;

uses
  Forms,
  UnitMain in 'units\UnitMain.pas' {frmMain},
  UnitMaze in 'units\UnitMaze.pas',
  UnitMazeCfg in 'units\UnitMazeCfg.pas' {frmMazeCfg},
  UnitAvgStats in 'units\UnitAvgStats.pas' {frmAvgStats};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FLAMINGO';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmMazeCfg, frmMazeCfg);
  Application.CreateForm(TfrmAvgStats, frmAvgStats);
  Application.Run;
end.
