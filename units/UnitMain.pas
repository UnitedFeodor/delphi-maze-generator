unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus,
  // standard units

  UnitMazeCfg, UnitMaze,UnitAvgStats,ShellAPI;
  // additional units

type

  // main form
  TfrmMain = class(TForm)
    pnlRigth: TPanel;
    mmnAll: TMainMenu;
    nFile: TMenuItem;
    nSaveAs: TMenuItem;
    nOpenSeed: TMenuItem;
    nOpenText: TMenuItem;
    nGenerateMaze: TMenuItem;
    pnlStats: TPanel;
    lblStats: TLabel;
    pbxMaze: TPaintBox;
    dlgOpenText: TOpenDialog;
    dlgSaveTypedMaze: TSaveDialog;
    dlgOpenTyped: TOpenDialog;
    edtTime: TEdit;
    edtWayOutLength: TEdit;
    edtExitX: TEdit;
    edtExitY: TEdit;
    txtExitY: TStaticText;
    txtExitX: TStaticText;
    txtExitPoint: TStaticText;
    txtWayOutLength: TStaticText;
    txtTime: TStaticText;
    edtWidth: TEdit;
    edtHeight: TEdit;
    txtWidth: TStaticText;
    txtHeight: TStaticText;
    edtGenType: TEdit;
    txtGenerated: TStaticText;
    edtAmountOfVisited: TEdit;
    txtAmountOfVisited: TStaticText;
    lblSeconds: TLabel;
    nAvgStats: TMenuItem;
    nInfo: TMenuItem;
    pnlInput: TPanel;
    txtSolveType: TStaticText;
    cbbSolve: TComboBox;
    btnStart: TButton;
    btnClearMaze: TButton;
    btnGiveUp: TButton;
    txtX: TStaticText;
    edtX: TEdit;
    edtY: TEdit;
    txtY: TStaticText;
    txtStartPoint: TStaticText;
    btnInputStartCell: TButton;
    procedure nGenerateMazeClick(Sender: TObject);
    procedure pbxMazePaint(Sender: TObject);
    procedure edtNumKeyPress(Sender: TObject; var Key: Char);
    procedure btnStartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnInputStartCellClick(Sender: TObject);
    procedure btnClearMazeClick(Sender: TObject);
    procedure nOpenTextClick(Sender: TObject);
    procedure nSaveAsClick(Sender: TObject);
    procedure nOpenSeedClick(Sender: TObject);
    procedure btnGiveUpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure nAvgStatsClick(Sender: TObject);
    procedure btnUpdateStatsClick(Sender: TObject);
    procedure nInfoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure CMDialogKey(var Key:TWMKey); message CM_DIALOGKEY;
  public
    { Public declarations }
  end;
  procedure UpdateStartEnabled;
  procedure pbxMazeSquareDraw(const Lab:TMaze;CellColor: TColor; SquareSide: Integer;i,j: Integer);
  function SquareSize (const Lab: TMaze): integer;
  procedure BitMapDraw(const Lab: TMaze);
var
  frmMain: TfrmMain;
  BitMaze: TBitMap;
  // frmMain - main form of the app
  // BitMaze - picture for quicker visualising

implementation

{$R *.dfm}
type
  TUserSolve = record
    T1,T2,CounterPerSec: TLargeInteger;
    Exit: TPointArray;
    Current: TPointArray;
  end;
  // T1,T2,CounterPerSec - for time stats
  // Exit - exit coordinates
  // Current last visited cell
  
  TTempSquares = array of array of TColor;
var
  UserStuff: TUserSolve;
  // temp stuff for user solve

// enabling or disabling buttons etc
// depending on the state of the program
procedure UpdateStartEnabled;
var
  Temp: Boolean;
begin
  Temp := isThereMaze and not isUserSolve;
  with frmMain do
  begin
    btnStart.Enabled := Temp;
    edtX.Enabled := Temp;
    txtX.Enabled := Temp;
    edtY.Enabled := Temp;
    txtY.Enabled := Temp;
    txtStartPoint.Enabled := Temp;
    cbbSolve.Enabled := Temp;
    txtSolveType.Enabled := Temp;
    btnInputStartCell.Enabled := Temp;
    btnClearMaze.Enabled := Temp and isVisual;

    btnGiveUp.Visible := isUserSolve;
    nFile.Enabled := not isUserSolve;
    nGenerateMaze.Enabled := not isUserSolve;
    nAvgStats.Enabled := not isUserSolve;
    nSaveAs.Enabled := Temp and (Maze.Seed.Generated<>UserText);
  end;

end;

// calculating proper draw size
function SquareSize (const Lab: TMaze): integer;
var
  i,j: integer;
begin
  with frmMain.pbxMaze do
  begin
    i := Height div (Lab.Seed.Height+2);
    j := Width div (Lab.Seed.Width+2);
    if i>=j then
      Result := j
    else
      Result := i;

    // in case it's too small draw it anyway  
    if Result = 0 then
      Result := 1;  
  end;
end;

// drawing on a bitmap to make it faster
procedure BitMapDraw(const Lab: TMaze);
var
  i,j: Integer;
  SquareSide: Integer;
  Square: TRect;
begin
  BitMaze.Width := frmMain.pbxMaze.Width;
  BitMaze.Height := frmMain.pbxMaze.Height;

  SquareSide := SquareSize(Lab);
  with BitMaze do
    with Canvas do
    begin
      Brush.Color := clBack;
      FillRect(Rect(0,0,BitMaze.Width,BitMaze.Height));
      for i := 0 to Lab.Seed.Height+1 do
      begin
        Square := Rect(Point(0,i*SquareSide),Point(SquareSide,SquareSide*(i+1)));
        for j := 0 to Lab.Seed.Width+1 do
        begin
          Brush.Color := Lab.CellColors[i,j];
          FillRect(Square);
          OffsetRect(Square,SquareSide,0);
          //FillRect(Rect(SquareSide*j,SquareSide*i,SquareSide*(j+1),SquareSide*(i+1)));
        end;
      end;
    end;

  // redrawing on actual paintbox on form
  frmMain.pbxMaze.Canvas.Draw(0,0,BitMaze);
end;

// open frmMazeCfg
procedure TfrmMain.nGenerateMazeClick(Sender: TObject);
begin
  frmMazeCfg.ShowModal;
end;

// no wrong input allowed
procedure TfrmMain.edtNumKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
  '0'..'9','-',#8: ;
  else
    Key := #0;
  end;
end;

// start walkthrough of maze
// if correct input
// else print error message
procedure TfrmMain.btnStartClick(Sender: TObject);
var
  i,j: integer;
  Str: String;
  k: TSolveType;
begin
  isSolved := false;
  if correctSolve(Maze,Maze.Stats.StartP,Str)  then
  begin
    MazeSolver := TSolveType(cbbSolve.ItemIndex);

    // algorithm solves
    if (MazeSolver <> UserWalk) then
    begin
      solveGeneric(Maze,MazeSolver);

      // draw if proper size
      if isVisual then
      begin
        solveGeneric_Draw(Maze,MazeSolver)
      end;
      if (Maze.Stats.EndP[MazeSolver][y] <> 0) or (Maze.Stats.EndP[MazeSolver][x] <> 0) then
      begin
        isSolved := true;
      end;

      // solve stats
      for k:= Low(TSolveType) to High(TSolveType) do
      begin
        if (k <> MazeSolver) or (not isSolved) then
          Maze.Stats.Solved[k] := false;
      end;
      if isSolved then
      begin
        // update stats
        addToList(StatsHead,Maze.Stats);
        
        // write stats to edits
        edtWayOutLength.Text := inttostr(Maze.Stats.WayOutLength[MazeSolver]);
        edtAmountOfVisited.Text := inttostr(Maze.Stats.AmountOfVis[MazeSolver]);
        edtTime.Text := FloatToStrF(Maze.Stats.Time[MazeSolver],ffFixed,9,7);
        edtExitX.Text := IntToStr(Maze.Stats.EndP[MazeSolver][X]);
        edtExitY.Text := IntToStr(Maze.Stats.EndP[MazeSolver][Y]);
      end
      else
      begin
        edtWayOutLength.Text := ' ';
        edtAmountOfVisited.Text := ' ';
        edtTime.Text := ' ';
        edtExitX.Text := ' ';
        edtExitY.Text := ' ';
      end;
    end
    else   // user solve
    begin
      if isVisual then
      begin
        edtWayOutLength.Text := ' ';
        edtAmountOfVisited.Text := ' ';
        edtTime.Text := ' ';
        edtExitX.Text := ' ';
        edtExitY.Text := ' ';

        // start reading keys
        isUserSolve := true;

        UpdateStartEnabled;

        // preparing stuff because it will be lost otherwise
        setlength(Maze.Visited,0,0);
        setlength(Maze.Visited,Maze.Seed.Height+2,Maze.Seed.Width+2);
        for i:=1 to Maze.Seed.Height do
          for j:=1 to Maze.Seed.Width do
          begin
            Maze.Visited[i][j] := false;
          end;
        UserStuff.Current := Maze.Stats.StartP;
        pbxMazeSquareDraw(Maze,clPlayer,SquareSize(Maze),UserStuff.Current[Y],UserStuff.Current[X]);
        Maze.Visited[Maze.Stats.StartP[y],Maze.Stats.StartP[x]] := true; // starting point is visited

        // start time count
        QueryPerformanceFrequency(UserStuff.CounterPerSec);
        QueryPerformanceCounter(UserStuff.T1);
      end
      else
        ShowMessage('Данный режим недоступен для лабиринтов без визуального представления');
    end;
  end

  // error message
  else
  begin
    ShowMessage(Str);
    str := '';
  end;
end;

// about program
procedure writeToInfo;
var
  InfoFile: TextFile;
begin
  AssignFile(InfoFile,'Справка.txt');
  Rewrite(InfoFile);
  Writeln(InfoFile,
  'КАК ПОЛЬЗОВАТЬСЯ'+#13+#13+
  'Для генерации лабиринта выберите пункт "Лабиринт" или "Файл" в меню сверху.'+#13+
  'Для прохождения заполните поля справа и нажмите "Старт".'+#13+
  'Лабиринты, не помещающиеся на дисплей в полноэкранном режиме, не имеют визуального представления.'+#13+
  'Для них также недоступно пользовательское прохождение.'+#13+
  'После нахождения выхода последняя статистика записывается в поля на панели справа.'+#13+
  'При пользовательском прохождении управление осуществляется стрелками.'+#13+
  'Для просмотра средней статистики выберите пункт "Средняя статистика". Она формируется и сохраняется автоматически.'+#13+#13+
  'ЛАБИРИНТ ИЗ ТЕКСТОВОГО ФАЙЛА'+#13+#13+
  'Для генерации лабиринта таким образом введите прямоугольную матрицу чисел 0,1,2, где:'+#13+
  '0 – проход;'+#13+
  '1 – стена;'+#13+
  '2 – выход;'+#13+
  'Проходов не должно быть на границе.'+#13+
  'Минимальный допустимый размер - 3х3, максимальный - 6499х6499.'+#13+
  'Выходов может быть любое количество.'+#13+#13+
  'ОБ АВТОРЕ'+#13+#13+
  'Разработал студент 0510003 ПОИТ ФКСиС БГУИР Иванов Фёдор. Лучше бы он этого не делал...'
  );

  CloseFile(InfoFile);
end;

// initialize all important stuff in the beginning
procedure TfrmMain.FormCreate(Sender: TObject);
begin

  // create folders
  if not DirectoryExists('Stats') then
    CreateDir('Stats');
  if not DirectoryExists('TextMazes') then
    CreateDir('TextMazes');
  if not DirectoryExists('TypedMazes') then
    CreateDir('TypedMazes');

  // about app  
  writeToInfo;

  // enabled controls
  isThereMaze := false;
  isUserSolve := false;

  // picture of maze
  BitMaze := TBitMap.Create;

  // list of stats
  makeList(StatsHead);
end;

// draw a cell of needed color on paintbox
procedure pbxMazeSquareDraw(const Lab:TMaze;CellColor: TColor; SquareSide: Integer;i,j: Integer);
begin
  with frmMain.pbxMaze do
  begin
    with Canvas do
    begin
      Brush.Color := CellColor;
      FillRect(Rect(SquareSide*j,SquareSide*i,SquareSide*(j+1),SquareSide*(i+1)));
    end;
  end;
end;

// confirm start point
// error message if incorrect
procedure TfrmMain.btnInputStartCellClick(Sender: TObject);
var
  isError: Boolean;
  Temp, Code: Integer;
  TempStart: TPointArray;
  Str: String;
begin
  isError := false;
  // start x check
  val(edtX.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение координаты X.'+#13;
    isError := true;
  end
  else
  begin
    TempStart[X] := Temp;
  end;

  // start y check
  val(edtY.Text,Temp,Code);
  if Code <> 0 then
  begin
    Str := Str+'Недопустимое значение координаты Y.'+#13;
    isError := true;
  end
  else
  begin
    TempStart[Y] := Temp;
  end;
  
  if not isError and correctSolve(Maze,TempStart,Str)  then
  begin
    if correctSolve(Maze,Maze.Stats.StartP,Str) and isVisual then
      pbxMazeSquareDraw(Maze,Maze.CellColors[Maze.Stats.StartP[Y],Maze.Stats.StartP[X]],SquareSize(Maze),Maze.Stats.StartP[Y],Maze.Stats.StartP[X]);

    Maze.Stats.StartP := TempStart;
    // draw new start point
    if isVisual then
      pbxMazeSquareDraw(Maze,clStart,SquareSize(Maze),Maze.Stats.StartP[Y],Maze.Stats.StartP[X]);
  end
  else
  begin
    ShowMessage(str);
    str := '';
  end;
end;

// if it's too big then no drawing is made
procedure pbxMazeTextWrite;
begin
  with frmMain.pbxMaze do
    with Canvas do
    begin
      Brush.Color := clBtnFace;
      FillRect(ClientRect);

      Font.Color := clRed;
      Font.Size := 10;
      TextOut(0,0,'Для лабиринтов данного размера визуальное отображение не поддерживается');
    end;
end;

// drawing maze and startpoint every time we need it
procedure TfrmMain.pbxMazePaint(Sender: TObject);
var
  Str: String;
begin
  if isThereMaze then
  begin
    if isVisual then
    begin
      BitMapDraw(Maze);
      if isUserSolve then
      begin
        pbxMazeSquareDraw(Maze,clPlayer,SquareSize(Maze),UserStuff.Current[Y],UserStuff.Current[X]);
      end
      else if correctSolve(Maze,Maze.Stats.StartP,Str) and isVisual then
      begin
        pbxMazeSquareDraw(Maze,clStart,SquareSize(Maze),Maze.Stats.StartP[Y],Maze.Stats.StartP[X]);
      end;
    end
    else
    begin
      pbxMazeTextWrite;
    end;
  end;
end;

// user solve step
procedure solveUser(var Lab: TMaze; const Key: Word;var PlayerStuff: TUserSolve);
var
  Point: TPointArray;
  i,j,TempSize: Integer;
  ExitFound: Boolean;
  k: TSolveType;
begin
  ExitFound:=false;

  // remembering where we came from for every position
  // and which ones we've visited
  if(not ExitFound) then
  begin
    case ord(Key) of
    VK_LEFT:
      begin
        if (Lab.Maze[PlayerStuff.Current[y]][PlayerStuff.Current[x]-1]<>1) then
        begin
          Point[x]:=PlayerStuff.Current[x]-1;
          Point[y]:=PlayerStuff.Current[y];
          pbxMazeSquareDraw(Lab,Lab.CellColors[PlayerStuff.Current[y],PlayerStuff.Current[x]],SquareSize(Lab),PlayerStuff.Current[Y],PlayerStuff.Current[X]);
          PlayerStuff.Current := Point;
          Lab.Visited[Point[y]][Point[x]]:=true;
          pbxMazeSquareDraw(Lab,clPlayer,SquareSize(Lab),Point[Y],Point[X]);
        end;
      end;
      VK_RIGHT:
      begin
        if (Lab.Maze[PlayerStuff.Current[y]][PlayerStuff.Current[x]+1]<>1) then
        begin
          Point[x]:=PlayerStuff.Current[x]+1;
          Point[y]:=PlayerStuff.Current[y];
          pbxMazeSquareDraw(Lab,Lab.CellColors[PlayerStuff.Current[y],PlayerStuff.Current[x]],SquareSize(Lab),PlayerStuff.Current[Y],PlayerStuff.Current[X]);
          PlayerStuff.Current := Point;
          Lab.Visited[Point[y]][Point[x]]:=true;
          pbxMazeSquareDraw(Lab,clPlayer,SquareSize(Lab),Point[Y],Point[X]);
        end;
      end;
      VK_UP:
      begin
        if (Lab.Maze[PlayerStuff.Current[y]-1][PlayerStuff.Current[x]]<>1) then
        begin
          Point[x]:=PlayerStuff.Current[x];
          Point[y]:=PlayerStuff.Current[y]-1;
          pbxMazeSquareDraw(Lab,Lab.CellColors[PlayerStuff.Current[y],PlayerStuff.Current[x]],SquareSize(Lab),PlayerStuff.Current[Y],PlayerStuff.Current[X]);
          PlayerStuff.Current := Point;
          Lab.Visited[Point[y]][Point[x]]:=true;
          pbxMazeSquareDraw(Lab,clPlayer,SquareSize(Lab),Point[Y],Point[X]);
        end;
      end;
      VK_DOWN:
      begin
        if (Lab.Maze[PlayerStuff.Current[y]+1][PlayerStuff.Current[x]]<>1) then
        begin
          Point[x]:=PlayerStuff.Current[x];
          Point[y]:=PlayerStuff.Current[y]+1;
          pbxMazeSquareDraw(Lab,Lab.CellColors[PlayerStuff.Current[y],PlayerStuff.Current[x]],SquareSize(Lab),PlayerStuff.Current[Y],PlayerStuff.Current[X]);
          PlayerStuff.Current := Point;
          Lab.Visited[Point[y]][Point[x]]:=true;
          pbxMazeSquareDraw(Lab,clPlayer,SquareSize(Lab),Point[Y],Point[X]);
        end;
      end;
    end;
  end;


  // if an exit is found
  if (Lab.Maze[PlayerStuff.Current[y]][PlayerStuff.Current[x]]=2) then
  begin
    // stop time count
    with UserStuff do
    begin
      QueryPerformanceCounter(T2);
      Lab.Stats.Time[UserWalk] := (T2-T1)/CounterPerSec;
    end;

    ExitFound:=true;
    PlayerStuff.Exit[x]:=PlayerStuff.Current[x];
    PlayerStuff.Exit[y]:=PlayerStuff.Current[y];
  end;

  // update stats
  if ExitFound then
  begin
    Lab.Stats.Solved[UserWalk] := true;
    isUserSolve := false;

    PlayerStuff.Current := PlayerStuff.Exit;
    Lab.Stats.EndP[UserWalk] := PlayerStuff.Exit;

    // draw visited cells
    Lab.Stats.AmountOfVis[UserWalk] := 0;
    TempSize := SquareSize(Lab);
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[UserWalk]);
          Lab.CellColors[i,j] := clVisited;
          pbxMazeSquareDraw(Lab,clVisited,TempSize,i,j)
        end;
      end;
    Lab.Stats.WayOutLength[UserWalk] := Lab.Stats.AmountOfVis[UserWalk];

    for k:= Low(TSolveType) to High(TSolveType) do
      begin
        if k <> UserWalk then
          Lab.Stats.Solved[k] := false;
      end;
    addToList(StatsHead,Lab.Stats);

    // update last solve stats
    with frmMain do
    begin
      edtWayOutLength.Text := inttostr(Lab.Stats.WayOutLength[UserWalk]);
      edtAmountOfVisited.Text := inttostr(Lab.Stats.AmountOfVis[UserWalk]);
      edtTime.Text := FloatToStrF(Lab.Stats.Time[UserWalk],ffFixed,9,5);
      edtExitX.Text := IntToStr(Lab.Stats.EndP[UserWalk][X]);
      edtExitY.Text := IntToStr(Lab.Stats.EndP[UserWalk][Y]);
    end;
    UpdateStartEnabled;
  end

end;


// clever key read to fix some issues
procedure TfrmMain.CMDialogKey(var Key:TWMKey);
begin
  case Key.CharCode of
  VK_DOWN,VK_UP,VK_LEFT,VK_RIGHT:
    if Assigned(OnKeyDown) then
    begin
      OnKeyDown(Self,Key.CharCode, KeyDataToShiftState(Key.KeyData));
      Key.Result := 1;
    end;
  else
    inherited;
  end;
end;

// clearing visited and path cells 
procedure TfrmMain.btnClearMazeClick(Sender: TObject);
var
  i,j,TempSize: integer;
  Str: String;
begin
  if correctMaze(Maze,Str)  then
  begin
    TempSize := SquareSize(Maze);
    for i:= 0 to Maze.Seed.Height+1 do
      for j:=0 to Maze.Seed.Width+1 do
      begin
        if Maze.CellColors[i,j] <> ColorArr[Maze.Maze[i,j]] then
        begin
          Maze.CellColors[i,j] := ColorArr[Maze.Maze[i,j]];
          pbxMazeSquareDraw(Maze,ColorArr[Maze.Maze[i,j]],TempSize,i,j);
        end;
      end;

   if correctSolve(Maze,Maze.Stats.StartP,Str) then
   begin
     pbxMazeSquareDraw(Maze,clStart,TempSize,Maze.Stats.StartP[Y],Maze.Stats.StartP[X]);
   end;
  end;
end;

// text maze from file
procedure TfrmMain.nOpenTextClick(Sender: TObject);
var
    Str: String;
begin
  if dlgOpenText.Execute then
  begin
    inMazeFromTextFile(Maze,dlgOpenText.FileName,Str);
    if (Str = '') and correctMaze(Maze,Str)  then
    begin
      isThereMaze := true;
      // updating stats in edits
      edtGenType.Text := 'Текстовый';
      edtWidth.Text := IntToStr(Maze.Stats.Width);
      edtHeight.Text := IntToStr(Maze.Stats.Height);

      isVisual := (Maze.Seed.Width<=1581) and (Maze.Seed.Height <= 973) ;
      if isVisual then
        FillMazeColors(maze);
      pbxMazePaint(pbxMaze);

      UpdateStartEnabled;
    end
    else
    begin
      ShowMessage(Str);
      str := '';
    end;
  end;
end;

// save to typed file
procedure TfrmMain.nSaveAsClick(Sender: TObject);
begin
  if dlgSaveTypedMaze.Execute then
  begin
    writeMazeToTypedFile(Maze,dlgSaveTypedMaze.FileName);
  end;
end;

// open from typed file
procedure TfrmMain.nOpenSeedClick(Sender: TObject);
begin
  if dlgOpenTyped.Execute then
  begin
    inMazeFromTypedFile(Maze,dlgOpenTyped.FileName);
    isThereMaze := true;

    // updating stats
    edtGenType.Text := frmMazeCfg.cbbGenerated.Items[Ord(Maze.Seed.Generated)];
    edtWidth.Text := IntToStr(Maze.Stats.Width);
    edtHeight.Text := IntToStr(Maze.Stats.Height);
    edtX.Text := inttostr(Maze.Seed.Width);
    edtY.Text := inttostr(Maze.Seed.Height);
    Maze.Stats.StartP[X] := Maze.Seed.Width;
    Maze.Stats.StartP[Y] := Maze.Seed.Height;

    // if visual then paint it
    isVisual := (Maze.Seed.Width<=1581) and (Maze.Seed.Height <= 973) ;
    if isVisual then
      FillMazeColors(maze);
    pbxMazePaint(pbxMaze);
    btnInputStartCell.Click;
    UpdateStartEnabled;
  end;
end;

// if it's too hard to solve by user
procedure TfrmMain.btnGiveUpClick(Sender: TObject);
var
  i,j,TempSize: integer;
begin
  isUserSolve := false;
  TempSize := SquareSize(Maze);
  // draw only viisted cause no exit
  pbxMazeSquareDraw(Maze,clStart,TempSize ,Maze.Stats.StartP[Y],Maze.Stats.StartP[X]);
  pbxMazeSquareDraw(Maze,Maze.CellColors[UserStuff.Current[y],UserStuff.Current[x]],TempSize ,UserStuff.Current[Y],UserStuff.Current[X]);
  for i:=0 to Maze.Seed.Height+1 do
    for j:=0 to Maze.Seed.Width+1 do
    begin
      if Maze.Visited[i][j] then
      begin
        Inc(Maze.Stats.AmountOfVis[UserWalk]);
        Maze.CellColors[i,j] := clVisited;
        pbxMazeSquareDraw(Maze,clVisited,TempSize,i,j)
      end;
    end;
  UpdateStartEnabled;
end;

// saving avg stats to file when form is closed
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  writeAverageStatsToFile(ExtractFilePath(Application.ExeName)+'Stats\AverageStats.stats',StatsHead);
  BitMaze.Free;
end;

// open frmAvgStats
// and update avg stats
procedure TfrmMain.nAvgStatsClick(Sender: TObject);
begin
  writeAverageStatsToFile(ExtractFilePath(Application.ExeName)+'Stats\AverageStats.stats',StatsHead);
  frmAvgStats.ShowModal;
end;

// update stats list
procedure TfrmMain.btnUpdateStatsClick(Sender: TObject);
begin
  addToList(StatsHead,Maze.Stats);
end;

// open about app thingy
procedure TfrmMain.nInfoClick(Sender: TObject);
begin
  ShellExecute(Handle,'open','Notepad',PAnsiChar(ExtractFilePath(Application.ExeName)+'Справка.txt'),nil,SW_SHOWNORMAL);
  writeToInfo;
end;

// no buttons chosen
procedure TfrmMain.FormActivate(Sender: TObject);
begin
  SetFocus;
end;

// key input for user solve
procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if isUserSolve then
  begin
    solveUser(Maze,Key,UserStuff);
  end;
end;

end.
