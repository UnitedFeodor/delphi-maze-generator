unit UnitMazeCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, UnitMaze, TypInfo;
  // standard units
type

  TfrmMazeCfg = class(TForm)
    pnlSize: TPanel;
    txtWidth: TStaticText;
    pnlSeedNumber: TPanel;
    txtSeedNumber: TStaticText;
    pnlGenerated: TPanel;
    cbbGenerated: TComboBox;
    txtGenerated: TStaticText;
    pnlExits: TPanel;
    txtExits: TStaticText;
    edtSeedNumber: TEdit;
    edtAmountOfExits: TEdit;
    edtWidth: TEdit;
    pnlOkCancel: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    btnDeleteOuterWall: TButton;
    txtHeight: TStaticText;
    edtHeight: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtNumKeyPress(Sender: TObject; var Key: Char);
    procedure btnDeleteOuterWallClick(Sender: TObject);
    //procedure btnCenterStartClick(Sender: TObject);
  private
    { Private declarations }
  public

  end;

var
  // boolean determinate whether some controls are visible etc
  isThereMaze,isUserSolve,isVisual: Boolean;
  frmMazeCfg: TfrmMazeCfg;

implementation

uses UnitMain;
// unit with main maze logic
{$R *.dfm}

// confirm generation
// if wrong then error message
procedure TfrmMazeCfg.btnOKClick(Sender: TObject);
var
  isError: Boolean;
  Temp, Code: Integer;
  TempM: TMaze;
  Str: String;
begin
  isError := false;

  // seed check
  val(edtSeedNumber.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение сида.'+#13;
    isError := true;
  end
  else
  begin
    TempM.Seed.Value := Temp;
  end;

  // width check
  val(edtWidth.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение ширины.'+#13;
    isError := true;
  end
  else
  begin
    TempM.Seed.Width := Temp;
  end;
  // height check
  val(edtHeight.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение высоты.'+#13;
    isError := true;
  end
  else
  begin
    TempM.Seed.Height:= Temp;
  end;

  // exits check
  val(edtAmountOfExits.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение количества выходов.'+#13;
    isError := true;
  end
  else
  begin
    TempM.Seed.AmountOfExits := Temp;
  end;

  TempM.Seed.Generated := TGenType(cbbGenerated.ItemIndex);
  try

    if not isError and correctMaze(TempM,Str) then
    begin
      Maze.Seed := TempM.Seed;
      inMazeFromItsSeed(Maze);

      isThereMaze := true;

      // updating edits
      with frmMain do
      begin
        edtGenType.Text := cbbGenerated.Text;
        edtWidth.Text := IntToStr(Maze.Stats.Width);
        edtHeight.Text := IntToStr(Maze.Stats.Height);

        edtX.Text := inttostr(Maze.Seed.Width);
        edtY.Text := inttostr(Maze.Seed.Height);
      end;

      ModalResult := mrOK;
      isVisual := (Maze.Seed.Width<=1581) and (Maze.Seed.Height <= 973) ;
      UpdateStartEnabled;
      // draw
      if isVisual then
      begin
        FillMazeColors(Maze);
      end;
      with frmMain do
      begin
        pbxMazePaint(frmMain.pbxMaze);
        btnInputStartCell.Click;
      end;
    end
    else  // error message
    begin
      ShowMessage(str);
      Str := '';
    end;
  except
    on EOutOfMemory do
      ShowMessage('Ваш компьютер слишком слаб для таких размеров. Попробуйте поменьше!');
  end;  
end;


// showing relevant data
procedure TfrmMazeCfg.FormShow(Sender: TObject);
begin
  if isThereMaze then
  begin
    edtAmountOfExits.Text := inttostr(Maze.Seed.AmountOfExits);
    edtWidth.Text := inttostr(Maze.Seed.Width);
    edtHeight.Text := inttostr(Maze.Seed.Height);
    edtSeedNumber.Text := inttostr(Maze.Seed.Value);
    cbbGenerated.Text := GetEnumName(TypeInfo(TGenType),ord(Maze.Seed.Generated));
  end;
end;

// no wrong input
procedure TfrmMazeCfg.edtNumKeyPress(Sender: TObject; var Key: Char);
begin
  frmMain.edtNumKeyPress(Sender,Key);
end;

// add all exits
procedure TfrmMazeCfg.btnDeleteOuterWallClick(Sender: TObject);
var
  w,h,Code: integer;
begin
  val(edtWidth.Text,w,code);
  if Code = 0 then
    val(edtHeight.Text,h,code);
  if Code = 0 then
    edtAmountOfExits.Text := inttostr((w+h)*2)
end;

end.
