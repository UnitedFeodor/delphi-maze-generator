unit UnitAvgStats;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;
  // standard units
  
type
  TfrmAvgStats = class(TForm)
    pnlTop: TPanel;
    lblBFS: TLabel;
    txtTime: TStaticText;
    txtWayOutLength: TStaticText;
    txtAmountOfVisited: TStaticText;
    edtTimeBFS: TEdit;
    edtAmountOfVisitedBFS: TEdit;
    edtWayOutLengthBFS: TEdit;
    txtSize: TStaticText;
    edtSizeBFS: TEdit;
    lblDFS: TLabel;
    edtTimeDFS: TEdit;
    edtAmountOfVisitedDFS: TEdit;
    edtWayOutLengthDFS: TEdit;
    edtSizeDFS: TEdit;
    lblUserSolve: TLabel;
    edtTimeUser: TEdit;
    edtAmountOfVisitedUser: TEdit;
    edtWayOutLengthUser: TEdit;
    edtSizeUser: TEdit;
    pnlBottom: TPanel;
    lblText: TLabel;
    txtSolvesGen: TStaticText;
    edtNumText: TEdit;
    lblSidewinder: TLabel;
    edtNumSidewinder: TEdit;
    lblAlduosBroder: TLabel;
    edtNumAlduosBroder: TEdit;
    lblEller: TLabel;
    edtNumEller: TEdit;
    txtSolves: TStaticText;
    edtSolvesBFS: TEdit;
    edtSolvesDFS: TEdit;
    edtSolvesUser: TEdit;
    btnDeleteAvgStats: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnDeleteAvgStatsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAvgStats: TfrmAvgStats;

implementation
uses
  UnitMaze;
  // main maze logic and file work

{$R *.dfm}

// write proper data to all edits
procedure TfrmAvgStats.FormShow(Sender: TObject);
var
  AvgFileName: String;
  AvgFile: TFileOfAverageStats;
  NewStats: TAverageStats;
begin
  AvgFileName := ExtractFilePath(Application.ExeName)+'Stats\AverageStats.stats';
  AssignFile(AvgFile,AvgFileName);

  // if there are old stats
  if FileExists(AvgFileName) then
  begin
    Reset(AvgFile);
    Read(AvgFile,NewStats);

    edtTimeBFS.Text := FloatToStrF(NewStats.Time[BFS],ffFixed,9,7);
    edtTimeDFS.Text := FloatToStrF(NewStats.Time[DFS],ffFixed,9,7);
    edtTimeUser.Text := FloatToStrF(NewStats.Time[UserWalk],ffFixed,9,5);

    edtAmountOfVisitedBFS.Text := FloatToStrF(NewStats.AmountOfVis[BFS],ffFixed,9,2);
    edtAmountOfVisitedDFS.Text := FloatToStrF(NewStats.AmountOfVis[DFS],ffFixed,9,2);
    edtAmountOfVisitedUser.Text := FloatToStrF(NewStats.AmountOfVis[UserWalk],ffFixed,9,2);

    edtWayOutLengthBFS.Text := FloatToStrF(NewStats.WayOutLength[BFS],ffFixed,9,2);
    edtWayOutLengthDFS.Text := FloatToStrF(NewStats.WayOutLength[DFS],ffFixed,9,2);
    edtWayOutLengthUser.Text := FloatToStrF(NewStats.WayOutLength[UserWalk],ffFixed,9,2);

    edtSizeBFS.Text := FloatToStrF(NewStats.Size[BFS],ffFixed,9,2);
    edtSizeDFS.Text := FloatToStrF(NewStats.Size[DFS],ffFixed,9,2);
    edtSizeUser.Text := FloatToStrF(NewStats.Size[UserWalk],ffFixed,9,2);

    edtSolvesBFS.Text := inttostr(NewStats.FilledTypes[BFS]);
    edtSolvesDFS.Text := inttostr(NewStats.FilledTypes[DFS]);
    edtSolvesUser.Text := inttostr(NewStats.FilledTypes[UserWalk]);

    edtNumText.Text := inttostr(NewStats.NumSolved[UserText]);
    edtNumSidewinder.Text := inttostr(NewStats.NumSolved[Sidewinder]);
    edtNumAlduosBroder.Text := inttostr(NewStats.NumSolved[AlduosBroder]);
    edtNumEller.Text := inttostr(NewStats.NumSolved[Eller]);

    CloseFile(AvgFile);
  end
  else  // if no old stats file exists
  begin
    edtTimeBFS.Text := '';
    edtTimeDFS.Text := '';
    edtTimeUser.Text := '';

    edtAmountOfVisitedBFS.Text := '';
    edtAmountOfVisitedDFS.Text := '';
    edtAmountOfVisitedUser.Text := '';

    edtWayOutLengthBFS.Text := '';
    edtWayOutLengthDFS.Text := '';
    edtWayOutLengthUser.Text := '';

    edtSizeBFS.Text := '';
    edtSizeDFS.Text := '';
    edtSizeUser.Text := '';

    edtSolvesBFS.Text := '';
    edtSolvesDFS.Text := '';
    edtSolvesUser.Text := '';

    edtNumText.Text := '';
    edtNumSidewinder.Text := '';
    edtNumAlduosBroder.Text := '';
    edtNumEller.Text := '';
  end;
end;

// clearing avg stats
procedure TfrmAvgStats.btnDeleteAvgStatsClick(Sender: TObject);
var
  Selected: integer;
begin
  Selected := MessageDlg('Вы уверены, что хотите очистить среднюю статистику?',mtWarning,mbOKCancel,0);
  if Selected = mrOK then
  begin
    if DirectoryExists(ExtractFilePath(Application.ExeName)+'Stats') then
      if FileExists(ExtractFilePath(Application.ExeName)+'Stats\AverageStats.stats') then

        if not DeleteFile(ExtractFilePath(Application.ExeName)+'Stats\AverageStats.stats') then
          ShowMessage('Произошла ошибка с номером '+IntToStr(GetLastError));
  FormShow(self);  // updating edits
  end
  else if Selected = mrCancel then
  begin

  end;
end;

end.
