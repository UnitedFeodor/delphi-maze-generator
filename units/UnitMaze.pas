unit UnitMaze;

interface
uses
  SysUtils,Windows,Graphics;
  // standard units

type
  TSolveType = (BFS,DFS,UserWalk);
  TGenType = (Sidewinder,AlduosBroder,Eller,UserText);
  TPoint = (x,y);
  TPointArray = array[TPoint] of Integer;
  TPArAr = array of TPointArray;

  TStats = packed record
    Solved: array [TSolveType] of boolean;
    Time: array[TSolveType] of Real;
    AmountOfVis: array[TSolveType] of Integer;
    WayOutLength: array[TSolveType] of Integer;
    Generated: TGenType;
    StartP: TPointArray;
    EndP: array[TSolveType] of TPointArray;
    Width, Height: Integer;
  end;
  // Solved - whether it was solved
  // Time - time took to solve
  // AmountOfVis - how many visited
  // WayOutLength - length of path
  // Generated - type of generation
  // StartP - start point
  // EndP - end point
  // Width, Height - size of maze

  TElPointer = ^TStatEl;
  TStatEl = packed record
    StatEl: TStats;
    Next: TElPointer;
  end;
  // Next - next element
  // StatEl - last solve stats

  TAverageStats = packed record
    FilledTypes: array[TSolveType] of integer;
    Time: array[TSolveType] of Real;
    AmountOfVis: array[TSolveType] of Real;
    WayOutLength: array[TSolveType] of Real;
    NumSolved: array[TGenType] of Integer;
    Size: array[TSolveType] of Real;
  end;
  // FilledTypes - already used solves
  // Time - time to solve
  // AmountOfVis - how many visited
  // WayOutLength - average length of path
  // NumSolved - how many solved by generation

  TSeed = packed record
    Value: Cardinal;     // seed itself
    Generated: TGenType;
    Width, Height: Integer;
    AmountOfExits: Integer;
  end;
  // Generated - type of generation
  // Width,Height - size

  TMaze = packed record
    Maze: array of array of Byte;
    WayOut: array of TPointArray;
    CellColors: array of array of TColor;
    Visited: array of array of Boolean;
    Seed: TSeed;
    Stats: TStats;
  end;
  // Maze - the layout itself
  // WayOut - path to exit
  // CellColors - colors to paint by cell
  // Visited - visited cells

  TFileOfAverageStats = File of TAverageStats;
  TFileOfSeed = File of TSeed;



procedure solveGeneric(var Lab: TMaze; Solver: TSolveType);   
procedure inMazeSize(var Lab:TMaze);
procedure genSidewinder(var Lab:TMaze);
procedure genAlduosBroder(var Lab:TMaze);
procedure genEller(var Lab:TMaze);
procedure addExits(var Lab:TMaze);
procedure inStart(var Lab: TMaze; px,py: Integer);
procedure solveBFS(var Lab: TMaze);
procedure solveDFS(var Lab: TMaze);
procedure inMazeFromTextFile(var Lab: TMaze; const LayoutFileName: string;var ErrorStr: String);
procedure writeMazeToTypedFile(const Lab: TMaze; const SeedFileName: string);
procedure inMazeFromItsSeed(var Lab: TMaze);
procedure inMazeFromTypedFile(var Lab: TMaze; const SeedFileName: string);
procedure writeAverageStatsToFile(const AvgFileName: String;var ListHead: TElPointer);
function correctMaze(const Lab:TMaze;var S: String): Boolean;
function correctSolve(const Lab:TMaze; Start:TPointArray;var S: String): Boolean;
procedure fillMazeColors(var Lab: TMaze);

procedure solveGeneric_Draw(var Lab: TMaze; Solver: TSolveType);
procedure solveBFS_Draw(var Lab: TMaze);
procedure solveDFS_Draw(var Lab: TMaze);

procedure addToList(Ptr: TElPointer; Info: TStats);
procedure makeList(var Ptr: TElPointer);
procedure destroyList(var Ptr: TElPointer);
const
  ColorArr: array[0..2] of TColor = (clWhite,clBlack,clSilver);
  //clWall = ColorArr[0];
  //clSpace = ColorArr[1];
  //clExit =  ColorArr[2];

  clVisited = clFuchsia;
  clStart = clBlue;
  clPath = clYellow;
  clPlayer = clRed;
  clBack = clBtnFace;
  // colors of all things drawn
var
  MazeSolver: TSolveType;
  Maze: TMaze;
  isSolved: boolean;
  StatsHead:TElPointer;
  // MazeSolve - temporary variable
  // Maze - main maze
  // isSolved - was it solved or not
  // StatsHead - pointer to start of list

implementation
uses
  UnitMain,UnitMazeCfg;
  // other program units

// fill the colors of each cell  
procedure fillMazeColors(var Lab: TMaze);
var
  i,j: integer;
begin
  for i:=0 to Lab.Seed.Height+1 do
  begin
    for j:=0 to Lab.Seed.Width+1 do
    begin
      Lab.CellColors[i,j] := ColorArr[Lab.Maze[i,j]];
    end;
  end;
end;

// true if correct input of maze
// S contains error message
function correctMaze(const Lab:TMaze;var S: String): Boolean;
var
  isError: Boolean;
begin
  isError := false;
  if (Lab.Seed.Width and 1 = 0) or (Lab.Seed.Height and 1 = 0) then
  begin
    S:= S+'Ширина и длина должны быть нечетными числами.'+#13;
    isError := true;
  end;
  if (Lab.Seed.Width > 6499) or (Lab.Seed.Width < 3) then
  begin
    S:= S+'Ширина вне допустимого диапазона (от 3 до 6499).'+#13;
    isError := true;
  end;
  if (Lab.Seed.Height > 6499) or (Lab.Seed.Height < 3) then
  begin
    S:= S+'Высота вне допустимого диапазона (от 3 до 6499).'+#13;
    isError := true;
  end;
  Result := not isError;
end;

// true if correct input
// S contains error message
function correctSolve(const Lab:TMaze; Start:TPointArray;var S: String): Boolean;
var
  isError: Boolean;
begin
  isError := false;
  if Length(Lab.Maze) <> 0 then
  begin
    if (Start[Y] <= 0) or (Start[Y] >= Lab.Stats.Height+1) then
    begin
      S := S+'Координата Y не может быть вне лабиринта.'+#13;
      isError := true;
    end;
    if (Start[X] <= 0) or (Start[X] >= Lab.Stats.Width+1) then
    begin
      S := S+'Координата X не может быть вне лабиринта.'+#13;
      isError := true;
    end;
    if (not isError) then
    begin
      if (Lab.Maze[Start[Y],Start[X]] = 1) then
      begin
        S := S+'Стартовая точка не может быть стеной.'+#13;
        isError := true;
      end;
    end;
  end
  else
  begin
    S := S+'Нельзя пройти несуществующий лабиринт.'+#13;
    isError := true;
  end;
  Result := not isError;
end;

// choose solve type
// user solve not included
procedure solveGeneric(var Lab: TMaze; Solver: TSolveType);
begin
  case Solver of
    BFS: solveBFS(Lab);
    DFS: solveDFS(Lab);
  end;
end;

// choose solve type with visual representation
procedure solveGeneric_Draw(var Lab: TMaze; Solver: TSolveType);
begin
  case Solver of
    BFS: solveBFS_Draw(Lab);
    DFS: solveDFS_Draw(Lab);
  end;
end;

// create new list
procedure makeList(var Ptr: TElPointer);
begin
  New(Ptr);
  Ptr.Next := nil;
end;

// add new element to list after Ptr element
procedure addToList(Ptr: TElPointer; Info: TStats);
var
  Temp: TElPointer;
begin
  Temp := Ptr.Next;
  New(Ptr.Next);
  Ptr.Next.StatEl := Info;
  Ptr.Next.Next := Temp;
end;

// get rid of all memory for this list
procedure destroyList(var Ptr: TElPointer);
var
  CurrPtr,PtrDel: TElPointer;
begin
  CurrPtr := Ptr.Next;
  while CurrPtr <> nil do
  begin
    PtrDel := CurrPtr;
    CurrPtr := CurrPtr.Next;
    Dispose(PtrDel);
  end;
  Dispose(CurrPtr);
  Dispose(Ptr);
end;

// converting the existing list of stats into one piece of data
// and saving it in a file
// also destroying the list and creating a new one
procedure writeAverageStatsToFile(const AvgFileName: String; var ListHead: TElPointer);
var
  NewStats: TAverageStats;
  AvgFile: TFileOfAverageStats;
  CurrPtr: TElPointer;
  FileIsOpen: boolean;
  i: TSolveType;
  j: TGenType;
begin
  // open file of stats
  // read all the stats and convert them
  // write the avg to a different file
  // close files
  FileIsOpen := false;
  AssignFile(AvgFile,AvgFileName);

  CurrPtr := ListHead.Next;

  // updating old file
  if FileExists(AvgFileName) then
  begin
    Reset(AvgFile);
    Read(AvgFile,NewStats);
    FileIsOpen := true;
  end

  // creating new file
  else
  begin
    with CurrPtr.StatEl do
    begin
      if CurrPtr <> nil then
      begin
        Rewrite(AvgFile);
        FileIsOpen := true;

        // all zeroes at the beginning
        for j:= Low(TGenType) to High(TGenType) do
        begin
          NewStats.NumSolved[j] := 0;
        end;

        // inititalising not solved types with zeroes
        // and soled types with proper values
        for i:=Low(Solved) to High(Solved) do
        begin
          if Solved[i] then
          begin
            NewStats.Time[i] := Time[i];
            NewStats.AmountOfVis[i] := AmountOfVis[i];
            NewStats.WayOutLength[i] := WayOutLength[i];
            NewStats.Size[i] := Width*Height;
            NewStats.FilledTypes[i] := 1;
            NewStats.NumSolved[Generated] := NewStats.NumSolved[Generated] + 1;
          end
          else
          begin
            NewStats.Time[i] := 0;
            NewStats.AmountOfVis[i] := 0;
            NewStats.WayOutLength[i] := 0;
            NewStats.Size[i] := 0;
            NewStats.FilledTypes[i] := 0;
          end;

        end;
        CurrPtr := CurrPtr.Next;
      end;

    end;
  end;

  // finding the average of old ones and the new one
  // if there is no old one then writing proper values
  while CurrPtr <> nil do
  begin
    with CurrPtr.StatEl do
    begin
      for i:=Low(Solved) to High(Solved) do
      begin
        if NewStats.FilledTypes[i]>0 then
        begin
          if Solved[i] then
          begin
            NewStats.Time[i] := (NewStats.Time[i]*NewStats.FilledTypes[i] + Time[i])/(NewStats.FilledTypes[i]+1);
            NewStats.AmountOfVis[i] := (NewStats.AmountOfVis[i]*NewStats.FilledTypes[i] + AmountOfVis[i])/(NewStats.FilledTypes[i]+1);
            NewStats.WayOutLength[i] := (NewStats.WayOutLength[i]*NewStats.FilledTypes[i] + WayOutLength[i])/(NewStats.FilledTypes[i]+1);
            NewStats.Size[i] := (NewStats.Size[i]*NewStats.FilledTypes[i] + Width*Height)/(NewStats.FilledTypes[i]+1);
            NewStats.NumSolved[Generated] := NewStats.NumSolved[Generated] + 1;
            NewStats.FilledTypes[i] := NewStats.FilledTypes[i] + 1;
          end;
        end
        else
        begin
          if Solved[i] then
          begin
            NewStats.Time[i] := Time[i];
            NewStats.AmountOfVis[i] := AmountOfVis[i];
            NewStats.WayOutLength[i] := WayOutLength[i];
            NewStats.Size[i] := Width*Height;
            NewStats.FilledTypes[i] := 1;
            NewStats.NumSolved[Generated] := NewStats.NumSolved[Generated] + 1;
          end;
        end;

      end;

    end;
    CurrPtr := CurrPtr.Next;
  end;

  // saving to the file
  // deleting the list and making new one
  if FileIsOpen then
  begin
    Seek(AvgFile,0);
    Write(AvgFile,NewStats);
    CloseFile(AvgFile);
    destroyList(ListHead);
    makeList(ListHead);
  end;
end;

// input of maze size by its seed
procedure inMazeSize(var Lab:TMaze);
begin
  Lab.Stats.Height := Lab.Seed.Height;
  Lab.Stats.Width := Lab.Seed.Width;
  setlength(Lab.Maze,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(Lab.CellColors,Lab.Seed.Height+2,Lab.Seed.Width+2);
end;

// sidewinder maze by its seed
procedure genSidewinder(var Lab:TMaze);
var
  i,j,RunStart,CellX: Integer;
begin
  for i:=0 to Lab.Seed.Height+1 do
  begin
    for j:=0 to Lab.Seed.Width+1 do
    begin
      Lab.Maze[i,j] := 1;
    end;
  end;

  // sidewinder to stats
  Lab.Stats.Generated := Sidewinder;

  i := 1;
  while i <= Lab.Seed.Height do
  begin
    RunStart := 1;
    j := 1;
    while j <= Lab.Seed.Width do
    begin
      Lab.Maze[i][j] := 0;
      // forming sets and combining them if lucky
      if (i>1) and ((j=Lab.Seed.Width) or (Random(3)=0)) then
      begin
        repeat
          CellX := RunStart+Random(j - RunStart+1+1);
        until (CellX mod 2) <> 0;
        Lab.Maze[i][CellX] := 0;
        Lab.Maze[i-1][CellX] := 0;
        Lab.Maze[i-2][CellX] := 0;
        RunStart := j+2;
      end
      else
      if (j+2) <= Lab.Seed.Width then
      begin
        Lab.Maze[i][j+1] := 0;
        Lab.Maze[i][j+2] := 0;
      end;
      j := j + 2;
    end;
    i := i + 2;
  end;

end;

// alduosbroder maze by its seed
procedure genAlduosBroder(var Lab:TMaze);
var
  i,j,Remaining: Integer;
  Visited: array of array of boolean;
begin
  


  setlength(Visited,Lab.Seed.Height+2,Lab.Seed.Width+2);
   for i:=0 to Lab.Seed.Height+1 do
  begin
    for j:=0 to Lab.Seed.Width+1 do
    begin
      Lab.Maze[i,j] := 1;
    end;
  end;

  // alduosbroder start
  Lab.Stats.Generated := AlduosBroder;
  
  repeat
    i := Random(Lab.Seed.Height)+1;
  until (i and 1) <> 0;
  repeat
    j := Random(Lab.Seed.Width)+1;
  until (j and 1) <> 0;
  Lab.Maze[i,j] := 0;
  Visited[i,j] := true;

  // checking all directions
  Remaining := ((Lab.Seed.Height div 2) + 1)*((Lab.Seed.Width div 2) + 1) - 1;
  while Remaining > 0 do
  begin
    case Random(4) of
      0:
        if (i+2)<=Lab.Seed.Height then
        begin
          if Visited[i+2,j] = true then
          begin
            i := i+2;
          end
          else
          begin
            Lab.Maze[i+1][j] := 0;
            Lab.Maze[i+2][j] := 0;
            i := i+2;
            Visited[i,j] := true;
            Dec(Remaining);
          end;
        end;
      1:
        if (i-2)>=1 then
        begin
          if Visited[i-2,j] = true then
          begin
            i := i-2;
          end
          else
          begin
            Lab.Maze[i-1][j] := 0;
            Lab.Maze[i-2][j] := 0;
            i := i-2;
            Visited[i,j] := true;
            Dec(Remaining);
          end;
        end;
      2:
        if (j-2)>=1 then
        begin
          if Visited[i,j-2] = true then
          begin
            j := j-2;
          end
          else
          begin
            Lab.Maze[i][j-1] := 0;
            Lab.Maze[i][j-2] := 0;
            j := j-2;
            Visited[i,j] := true;
            Dec(Remaining);
          end;
        end;
      3:
        if (j+2)<=Lab.Seed.Width then
        begin
          if Visited[i,j+2] = true then
          begin
            j := j+2;
          end
          else
          begin
            Lab.Maze[i][j+1] := 0;
            Lab.Maze[i][j+2] := 0;
            j := j+2;
            Visited[i,j] := true;
            Dec(Remaining);
          end;
        end;
    end;

  end;

end;

// eller maze by its seed
procedure genEller(var Lab:TMaze);
var
  i,k,j,Temp,BIas: Integer;
  IndStart, IndEnd: Integer;
  Sets: array of Integer;
begin

  for i:=0 to Lab.Seed.Height+1 do
  begin
    for j:=0 to Lab.Seed.Width+1 do
    begin
      Lab.Maze[i,j] := 1;
    end;
  end;

  // eller
  Lab.Stats.Generated := Eller;

  // sets are used for generation
  setlength(Sets,(Lab.Seed.Width div 2)+1);
  
  Bias := 0; // for different numbers in sets
  i := 1;
  while i <= Lab.Seed.Height-2 do
  begin

    // initialising new sets
    // if we didn't cut previously
    // j=2k+1 because cells are only odd
    for k:=0 to (Length(Sets)-1) do
    begin
      if Lab.Maze[i-1][2*k+1] <> 0 then
        Sets[k] := k + Bias;
    end;
    Bias := Bias + Lab.Seed.Width + 1;
    // passing through a line and combining sets
    j := 1;
    while j <= Lab.Seed.Width do
    begin
      Lab.Maze[i][j] := 0;

      // random join if sets are different
      // Randomize;
      if (Random(10) > 3) and (j+2<=Lab.Seed.Width) and (Sets[(j-1)div 2]<>Sets[(j+2-1)div 2]) then
      begin
        Lab.Maze[i][j+1] := 0;
        Lab.Maze[i][j+2] := 0;
        Temp := Sets[(j+2-1)div 2];

        // properly updating sets
        k := 1;                // fix
        while (k <= Lab.Seed.Width)  do
        begin
          if (Sets[(k-1)div 2] = Temp) then
            Sets[(k-1)div 2] := Sets[(j-1)div 2];
          k := k + 2;
        end;
      end;
      j := j + 2;
    end;

    // cutting downwards in the current set
    // at least once
    // if it's not the last row
    if i < Lab.Seed.Height then
    begin

      j := 0;
      while j <= Length(Sets)-1 do
      begin

        // finding the borders of the current set
        IndStart := j;
        IndEnd := IndStart;
        while (Sets[IndEnd]= Sets[IndEnd+1]) and (IndEnd <= High(Sets)-1) do
        begin
          IndEnd := IndEnd + 1;
        end;

        // choosing first column to cut
        // in the coordinates of the set
        Temp := Random((2*IndEnd+1)-(2*IndStart+1)+1) + 2*IndStart+1;
        if (Temp and 1 = 0) then
          Temp := 2*IndEnd+1;
        Lab.Maze[i+1][Temp] := 0;
        Lab.Maze[i+2][Temp] := 0;
        // other attempts to cut
        k := Random((2*IndEnd+1)-(2*IndStart+1))div 2 + 1;
        while k > 0 do
        begin
          if Random(10)>5 then
          begin
            Temp := Random((2*IndEnd+1)-(2*IndStart+1)+1) + 2*IndStart+1;
            if (Temp and 1 = 0) then
              Temp := 2*IndEnd+1;
            Lab.Maze[i+1][Temp] := 0;
            Lab.Maze[i+2][Temp] := 0;
          end;
          k := k - 1;
        end;

        j := IndEnd + 1;
      end;
    end;

    i := i + 2;
  end;
  
  // last row
  for k:=0 to (Length(Sets)-1) do
    begin
      if Lab.Maze[i-1][2*k+1] <> 0 then
        Sets[k] := k + Bias;
    end;
    begin
      // passing through a line and combining sets
      j := 1;
      while j <= Lab.Seed.Width do
      begin
        Lab.Maze[i][j] := 0;

        // join if sets are different
        if (j+2<=Lab.Seed.Width) and (Sets[(j-1)div 2]<>Sets[(j+2-1)div 2]) then
        begin
          Lab.Maze[i][j+1] := 0;
          Lab.Maze[i][j+2] := 0;
          Temp := Sets[(j+2-1)div 2];

          // properly updating sets
          k := j+2;
          while (k <= Lab.Seed.Width)  do
          begin
            if (Sets[(k-1)div 2] = Temp) then
              Sets[(k-1)div 2] := Sets[(j-1)div 2];
            k := k + 2;
          end;
        end;
        j := j + 2;
      end;
    end;

end;


// adding extis near the border
procedure addExits(var Lab:TMaze);
var
  i,j: Integer;
  Exits: Integer;
begin
  // if more than half
  if Lab.Seed.AmountOfExits >= (Lab.Seed.Width+Lab.Seed.Height) then
  begin
    // filling the border
    for i:=0 to Lab.Seed.Width+1 do
    begin
      Lab.Maze[0][i]:=2;
      Lab.Maze[Lab.Seed.Height+1][i]:=2;
    end;

    for j:=1 to Lab.Seed.Height do
    begin
      Lab.Maze[j][0]:=2;
      Lab.Maze[j][Lab.Seed.Width+1]:=2;
    end;

    Exits := (Lab.Seed.Width+Lab.Seed.Height)*2;
    while Exits > Lab.Seed.AmountOfExits  do
    begin
      i := Random(Lab.Seed.Width)+1;
      if (Lab.Maze[0][i] = 2)  then
      begin
        Lab.Maze[0][i] := 1;
        Dec(Exits);
      end;
      i := Random(Lab.Seed.Height)+1;
      if (Exits <> Lab.Seed.AmountOfExits )  and (Lab.Maze[i][0] = 2) then
      begin
        Lab.Maze[i][0] := 1;
        Dec(Exits);
      end;

      i := Random(Lab.Seed.Width)+1;
      if (Exits <> Lab.Seed.AmountOfExits ) and (Lab.Maze[Lab.Seed.Height+1][i] = 2) then
      begin
        Lab.Maze[Lab.Seed.Height+1][i] := 1;
        Dec(Exits);
      end;

      i := Random(Lab.Seed.Height)+1;
      if (Exits <> Lab.Seed.AmountOfExits )  and (Lab.Maze[i][Lab.Seed.Width+1] = 2) then
      begin
        Lab.Maze[i][Lab.Seed.Width+1] := 1;
        Dec(Exits);
      end;
    end;
  end

  // if less than half then we do backwards
  else
  begin
    Exits := 0;
    while Exits < Lab.Seed.AmountOfExits  do
    begin
      i := Random(Lab.Seed.Width)+1;
      if (Lab.Maze[1][i] = 0) and (Lab.Maze[0][i] = 1)  then
      begin
        Lab.Maze[0][i] := 2;
        Inc(Exits);
      end;
      i := Random(Lab.Seed.Height)+1;
      if (Exits <> Lab.Seed.AmountOfExits ) and (Lab.Maze[i][1] = 0) and (Lab.Maze[i][0] = 1) then
      begin
        Lab.Maze[i][0] := 2;
        Inc(Exits);
      end;

      i := Random(Lab.Seed.Width)+1;
      if (Exits <> Lab.Seed.AmountOfExits ) and (Lab.Maze[Lab.Seed.Height][i] = 0) and (Lab.Maze[Lab.Seed.Height+1][i] = 1) then
      begin
        Lab.Maze[Lab.Seed.Height+1][i] := 2;
        Inc(Exits);
      end;

      i := Random(Lab.Seed.Height)+1;
      if (Exits <> Lab.Seed.AmountOfExits ) and (Lab.Maze[i][Lab.Seed.Width] = 0) and (Lab.Maze[i][Lab.Seed.Width+1] = 1) then
      begin
        Lab.Maze[i][Lab.Seed.Width+1] := 2;
        Inc(Exits);
      end;

    end;
  end;
end;

// starting point input
procedure inStart(var Lab: TMaze; px,py: Integer);
begin
  Lab.Stats.StartP[x] := px;
  Lab.Stats.StartP[y] := py;
end;

// draw while solving
procedure solveBFS_Draw(var Lab: TMaze);
var
  Exit: TPointArray; // exit coordinates
  CameFrom: array of array of TPointArray;
  Current,Point: TPointArray;
  St1,St2: array of TPointArray;
  St1P,St2P: Integer;
  i,j,TempSize: Integer;
  ExitFound: Boolean;
begin
  setlength(Lab.Visited,0,0);
  setlength(CameFrom,0,0);

  // setting sizes of associated variables
  setlength(Lab.Visited,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(CameFrom,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(St1,Lab.Seed.Height*Lab.Seed.Width);
  setlength(St2,Lab.Seed.Height*Lab.Seed.Width);


  for i:=1 to Lab.Seed.Height do
    for j:=1 to Lab.Seed.Width do
    begin
      Lab.Visited[i][j] := false;
    end;


  // starting point is visited
  Lab.Visited[Lab.Stats.StartP[y],Lab.Stats.StartP[x]] := true;

  St1P := 0;                          // all stacks
  St2P := 0;                          // are empty
  ExitFound:=false;

  TempSize := SquareSize(Lab);
  pbxMazeSquareDraw(Lab,clVisited,TempSize,Lab.Stats.StartP[Y],Lab.Stats.StartP[X]);

  // start of main cycle
  St2[St2P]:=Lab.Stats.StartP;
  inc(St2P);
  while ((St2P>0) or (St1P>0)) and (not ExitFound) do
  begin
    if St1P=0 then                  // updating the queue
    begin

      // popping from St2, pushing to St1
      while (St2P<>0) do
      begin
        dec(St2P);
        St1[St1P]:=St2[St2P];
        inc(St1P);
      end;

    end;

    // popping from St1
    if St1P<>0 then
    begin
      dec(St1P);
      Current:=St1[St1P];
    end;

    // if an exit is found
    if (Lab.Maze[Current[y]][Current[x]]=2) then
    begin
      ExitFound:=true;
      Exit[x]:=Current[x];
      Exit[y]:=Current[y];
    end;

    // checking all neighbour positions
    // if they make sense
    // pushing to St2
    // remembering where we came from for every position
    // and which ones we've visited
    // also drawing each time
    if(not ExitFound) then
    begin
      if (Lab.Maze[Current[y]+1][Current[x]]<>1) and (not Lab.Visited[Current[y]+1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]+1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]][Current[x]-1]<>1) and (not Lab.Visited[Current[y]][Current[x]-1]) then
      begin
        Point[x]:=Current[x]-1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]-1][Current[x]]<>1) and (not Lab.Visited[Current[y]-1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]-1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]][Current[x]+1]<>1) and (not Lab.Visited[Current[y]][Current[x]+1]) then
      begin
        Point[x]:=Current[x]+1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
    end;

  end;
  // end of main cycle

  // all exit paths output
  if ExitFound then
  begin
    St1P:=0;
    Current := Exit;
    Lab.Stats.EndP[BFS] := Exit;

    // calculating length of path
    St1[St1P]:=Current;
    inc(St1P);
    while (Current[y] <> Lab.Stats.StartP[y]) or (Current[x] <> Lab.Stats.StartP[x]) do
    begin
      Current := CameFrom[Current[y]][Current[x]];
      St1[St1P] := Current;
      inc(St1P);
    end;
    Lab.Stats.WayOutLength[BFS] := St1P;

    // saving path
    j := 0;
    setlength(Lab.WayOut,St1P+1);
    for St1P := St1P-1 downto 0 do
    begin
      Lab.WayOut[j] := St1[St1P];
      inc(j);
    end;

    // visited stats
    Lab.Stats.AmountOfVis[BFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[BFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // drawing path
    for j := 0 to High(lab.WayOut)-1 do
    begin
      pbxMazeSquareDraw(Lab,clPath,TempSize,Lab.WayOut[j][Y],Lab.WayOut[j][X]);
      Lab.CellColors[Lab.WayOut[j][Y],Lab.WayOut[j][X]] := clPath;
    end;

  end
  else
  begin
    // only visited cells if no exits
    Lab.Stats.AmountOfVis[BFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[BFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // no proper endpoint
    // this one is impossible to reach 
    Lab.Stats.EndP[BFS][y] := 0;
    Lab.Stats.EndP[BFS][x] := 0;
  end;
end;

// normal BFS
procedure solveBFS(var Lab: TMaze);
var
  T1,T2,CounterPerSec: TLargeInteger;
  Exit: TPointArray; // exit coordinates
  CameFrom: array of array of TPointArray;
  Current,Point: TPointArray;
  St1,St2: array of TPointArray;
  St1P,St2P: Integer;
  i,j: Integer;
  ExitFound: Boolean;
begin
  // setting sizes of associated variables
  setlength(Lab.Visited,0,0);
  setlength(CameFrom,0,0);
  setlength(Lab.Visited,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(CameFrom,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(St1,Lab.Seed.Height*Lab.Seed.Width);
  setlength(St2,Lab.Seed.Height*Lab.Seed.Width);


  for i:=1 to Lab.Seed.Height do
    for j:=1 to Lab.Seed.Width do
    begin
      Lab.Visited[i][j] := false;
    end;

  // time stats
  QueryPerformanceFrequency(CounterPerSec);
  QueryPerformanceCounter(T1);

  // starting point is visited
  Lab.Visited[Lab.Stats.StartP[y],Lab.Stats.StartP[x]] := true;
  St1P := 0;                          // all stacks
  St2P := 0;                          // are empty
  ExitFound:=false;

  St2[St2P]:=Lab.Stats.StartP;
  inc(St2P);

  // main cycle start
  while ((St2P>0) or (St1P>0)) and (not ExitFound) do
  begin

    // updating the queue
    if St1P=0 then
    begin

      // popping from St2, pushing to St1
      while (St2P<>0) do
      begin
        dec(St2P);
        St1[St1P]:=St2[St2P];
        inc(St1P);
      end;
      // end of A2 cycle

    end;

    // popping from St1
    if St1P<>0 then
    begin
      dec(St1P);
      Current:=St1[St1P];
    end;

    // if an exit is found
    if (Lab.Maze[Current[y]][Current[x]]=2) then
    begin
      ExitFound:=true;
      Exit[x]:=Current[x];
      Exit[y]:=Current[y];
    end;

    // checking all neighbour positions
    // if they make sense
    // pushing to St2
    // remembering where we came from for every position
    // and which ones we've visited
    if(not ExitFound) then
    begin
      if (Lab.Maze[Current[y]+1][Current[x]]<>1) and (not Lab.Visited[Current[y]+1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]+1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]][Current[x]-1]<>1) and (not Lab.Visited[Current[y]][Current[x]-1]) then
      begin
        Point[x]:=Current[x]-1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]-1][Current[x]]<>1) and (not Lab.Visited[Current[y]-1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]-1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]][Current[x]+1]<>1) and (not Lab.Visited[Current[y]][Current[x]+1]) then
      begin
        Point[x]:=Current[x]+1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;

    end;

  end;
  // end main cycle

  // time stats stop
  QueryPerformanceCounter(T2);
  Lab.Stats.Time[BFS] := (T2-T1)/CounterPerSec;
  Lab.Stats.Solved[BFS] := true;

  // all exit paths output
  if ExitFound then
  begin
    St1P:=0;
    Current := Exit;
    Lab.Stats.EndP[BFS] := Exit;

    // path length
    St1[St1P]:=Current;
    inc(St1P);
    while (Current[y] <> Lab.Stats.StartP[y]) or (Current[x] <> Lab.Stats.StartP[x]) do
    begin
      Current := CameFrom[Current[y]][Current[x]];
      St1[St1P] := Current;
      inc(St1P);
    end;
    Lab.Stats.WayOutLength[BFS] := St1P;

    // way out save
    j := 0;
    setlength(Lab.WayOut,St1P+1);
    for St1P := St1P-1 downto 0 do
    begin
      Lab.WayOut[j] := St1[St1P];
      inc(j);
    end;

    // visited stats
    Lab.Stats.AmountOfVis[BFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[BFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // updating path colors
    for j := 0 to High(lab.WayOut)-1 do
    begin
      Lab.CellColors[Lab.WayOut[j][Y],Lab.WayOut[j][X]] := clPath;
    end;
  end
  else
  begin
    // updating colors of visited
    Lab.Stats.AmountOfVis[BFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[BFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // end point is impossible
    Lab.Stats.EndP[BFS][y] := 0;
    Lab.Stats.EndP[BFS][x] := 0;
  end;
end;

// visual DFS
procedure solveDFS_Draw(var Lab: TMaze);
var
  Exit: TPointArray; // exit coordinates
  CameFrom: array of array of TPointArray;
  Current,Point: TPointArray;
  St1,St2: array of TPointArray;
  St1P,St2P: integer;
  i,j,TempSize: integer;
  ExitFound: Boolean;
begin
  // setting sizes of associated variables
  setlength(Lab.Visited,0,0);
  setlength(CameFrom,0,0);
  setlength(Lab.Visited,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(CameFrom,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(St1,(Lab.Seed.Height div 2 + 1)*Lab.Seed.Width);
  setlength(St2,(Lab.Seed.Height div 2 + 1)*Lab.Seed.Width);

  for i:=1 to Lab.Seed.Height do
    for j:=1 to Lab.Seed.Width do
    begin
      Lab.Visited[i][j] := false;
    end;
  // starting point is visited
  Lab.Visited[Lab.Stats.StartP[y],Lab.Stats.StartP[x]]:=true;

  St2P:=0;
  ExitFound:=false;

  // size of drawn cell
  TempSize := SquareSize(Lab);
  pbxMazeSquareDraw(Lab,clVisited,TempSize,Lab.Stats.StartP[Y],Lab.Stats.StartP[X]);

  St2[St2P]:=Lab.Stats.StartP;
  inc(St2P);

  // main cycle start
  while (St2P>0) and (not ExitFound) do
  begin

    // popping from St1
    if St2P<>0 then
    begin
      dec(St2P);
      Current:=St2[St2P];
    end;

    // if an exit is found
    if (Lab.Maze[Current[y]][Current[x]]=2) then
    begin
      ExitFound:=true;
      Exit[x]:=Current[x];
      Exit[y]:=Current[y];
    end;

    // checking all neighbour positions
    // if they make sense
    // pushing to St2
    // remembering where we came from for every position
    // and which ones we've visited
    if (not ExitFound) then
    begin
      if (Lab.Maze[Current[y]+1][Current[x]]<>1) and (not Lab.Visited[Current[y]+1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]+1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]][Current[x]-1]<>1) and (not Lab.Visited[Current[y]][Current[x]-1]) then
      begin
        Point[x]:=Current[x]-1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]-1][Current[x]]<>1) and (not Lab.Visited[Current[y]-1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]-1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
      if (Lab.Maze[Current[y]][Current[x]+1]<>1) and (not Lab.Visited[Current[y]][Current[x]+1]) then
      begin
        Point[x]:=Current[x]+1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
        pbxMazeSquareDraw(Lab,clVisited,TempSize,Point[Y],Point[X]);
      end;
    end;
  end;
  
  // all exit paths output
  if ExitFound then
  begin

    // for path draw
    St1P:=0;
    Current := Exit;
    Lab.Stats.EndP[DFS] := Exit;
    St1[St1P]:=Current;
    inc(St1P);
    while (Current[y] <> Lab.Stats.StartP[y]) or (Current[x] <> Lab.Stats.StartP[x]) do
    begin
      Current:=CameFrom[Current[y]][Current[x]];
      St1[St1P]:=Current;
      inc(St1P);
    end;

    // way out itself
    setlength(Lab.WayOut,St1P+1);
    Lab.Stats.WayOutLength[DFS] := St1P {+ 1};
    j := 0;
    for St1P := St1P-1 downto 0 do
    begin
      Lab.WayOut[j] := St1[St1P];
      inc(j);
    end;

    // updating colors
    Lab.Stats.AmountOfVis[DFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[DFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // drawing the path
    for j := 0 to High(lab.WayOut)-1 do
    begin
      pbxMazeSquareDraw(Lab,clPath,TempSize,Lab.WayOut[j][Y],Lab.WayOut[j][X]);
      Lab.CellColors[Lab.WayOut[j][Y],Lab.WayOut[j][X]] := clPath;
    end;
  end
  else
  begin
    // only visited if no exit
    Lab.Stats.AmountOfVis[DFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[DFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;
    Lab.Stats.EndP[DFS][y] := 0;
    Lab.Stats.EndP[DFS][x] := 0;
  end;

end;

// normal DFS
procedure solveDFS(var Lab: TMaze);
var
  T1,T2,CounterPerSec: TLargeInteger;
  Exit: TPointArray; // exit coordinates
  CameFrom: array of array of TPointArray;
  Current,Point: TPointArray;
  St1,St2: array of TPointArray;
  St1P,St2P: integer;
  i,j: integer;
  ExitFound: Boolean;
begin

  // setting sizes of associated variables
  setlength(Lab.Visited,0,0);
  setlength(CameFrom,0,0);
  setlength(Lab.Visited,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(CameFrom,Lab.Seed.Height+2,Lab.Seed.Width+2);
  setlength(St1,(Lab.Seed.Height div 2 + 1)*Lab.Seed.Width);
  setlength(St2,(Lab.Seed.Height div 2 + 1)*Lab.Seed.Width);
  for i:=1 to Lab.Seed.Height do
    for j:=1 to Lab.Seed.Width do
    begin
      Lab.Visited[i][j] := false;
    end;
    
  // start time counter
  QueryPerformanceFrequency(CounterPerSec);
  QueryPerformanceCounter(T1);

  // starting point is visited
  Lab.Visited[Lab.Stats.StartP[y],Lab.Stats.StartP[x]]:=true;
  St2P:=0;                          // are empty
  ExitFound:=false;
  St2[St2P]:=Lab.Stats.StartP;
  inc(St2P);

  // main cycle start
  while (St2P>0) and (not ExitFound) do
  begin

    // popping from St1
    if St2P<>0 then
    begin
      dec(St2P);
      Current:=St2[St2P];
    end;

    // if an exit is found
    if (Lab.Maze[Current[y]][Current[x]]=2) then
    begin
      ExitFound:=true;
      Exit[x]:=Current[x];
      Exit[y]:=Current[y];
    end;

    // checking all neighbour positions
    // if they make sense
    // pushing to St2
    // remembering where we came from for every position
    // and which ones we've visited
    if (not ExitFound) then
    begin
      if (Lab.Maze[Current[y]+1][Current[x]]<>1) and (not Lab.Visited[Current[y]+1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]+1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]][Current[x]-1]<>1) and (not Lab.Visited[Current[y]][Current[x]-1]) then
      begin
        Point[x]:=Current[x]-1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]-1][Current[x]]<>1) and (not Lab.Visited[Current[y]-1][Current[x]]) then
      begin
        Point[x]:=Current[x];
        Point[y]:=Current[y]-1;
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;
      if (Lab.Maze[Current[y]][Current[x]+1]<>1) and (not Lab.Visited[Current[y]][Current[x]+1]) then
      begin
        Point[x]:=Current[x]+1;
        Point[y]:=Current[y];
        St2[St2P]:=Point;
        inc(St2P);
        CameFrom[Point[y]][Point[x]]:=Current;
        Lab.Visited[Point[y]][Point[x]]:=true;
      end;


    end;

  end;
  // end of main cycle

  // stop time counter
  // update stats
  QueryPerformanceCounter(T2);
  Lab.Stats.Time[DFS] := (T2-T1)/CounterPerSec;


  // all exit paths output
  if ExitFound then
  begin
    Lab.Stats.Solved[DFS] := true;
    St1P:=0;
    Current := Exit;
    Lab.Stats.EndP[DFS] := Exit;

    // path
    St1[St1P]:=Current;
    inc(St1P);
    while (Current[y] <> Lab.Stats.StartP[y]) or (Current[x] <> Lab.Stats.StartP[x]) do
    begin
      Current:=CameFrom[Current[y]][Current[x]];
      St1[St1P]:=Current;
      inc(St1P);
    end;
    setlength(Lab.WayOut,St1P+1);
    Lab.Stats.WayOutLength[DFS] := St1P;
    j := 0;
    for St1P := St1P-1 downto 0 do
    begin
      Lab.WayOut[j] := St1[St1P];
      inc(j);
    end;

    // visited stats
    Lab.Stats.AmountOfVis[DFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[DFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // updating colors
    for j := 0 to High(lab.WayOut)-1 do
    begin
      Lab.CellColors[Lab.WayOut[j][Y],Lab.WayOut[j][X]] := clPath;
    end;
  end
  else
  begin
    // only visited if no exit
    Lab.Stats.AmountOfVis[DFS] := 0;
    for i:=0 to Lab.Seed.Height+1 do
      for j:=0 to Lab.Seed.Width+1 do
      begin
        if Lab.Visited[i][j] then
        begin
          Inc(Lab.Stats.AmountOfVis[DFS]);
          Lab.CellColors[i,j] := clVisited;
        end;
      end;

    // impossible end point  
    Lab.Stats.EndP[DFS][y] := 0;
    Lab.Stats.EndP[DFS][x] := 0;
  end;
end;

// text file maze input
procedure inMazeFromTextFile(var Lab: TMaze; const LayoutFileName: string;var ErrorStr: String);
var
  LayoutFile: TextFile;
  CorrectInput: Boolean;
  Temp,w,j,i: Integer;
  Str: string;
begin

  AssignFile(LayoutFile,LayoutFileName);
  if FileExists(LayoutFileName) then
  begin
    // input check first
    Reset(LayoutFile);
    readln(LayoutFile,str);
    w := Length(Str)-2;

    // line 0 of maze
    i := 0;
    j := 0;
    CorrectInput := True;
    
    // first line can't have zeroes
    while (j<w+2) and CorrectInput do
    begin
      if ((Str[j+1]<>'1') and (Str[j+1]<>'2')) then
        CorrectInput := False;
      inc(j);
    end;

    // other lines
    while not EOF(LayoutFile) and CorrectInput do
    begin
      readln(LayoutFile,str);
      inc(i);

      // not rectangle
      if ((Length(Str)-2) <> w) or (Str[Length(Str)]='0') or (Str[1]='0') then
        CorrectInput := False;

      j := 0;
      while (j<w+2) and CorrectInput do
      begin

        // wrong symbol
        if (Str[j+1]<>'1') and (Str[j+1]<>'2') and (Str[j+1]<>'0') then
          CorrectInput := False;
        inc(j);
      end;
    end;
    // last line once again
    j := 0;
    while (j<w+2) and CorrectInput do
    begin

      // last line can't have zeroes
      if (Str[j+1]<>'1') and (Str[j+1]<>'2') then
        CorrectInput := False;
      inc(j);
    end;

    // result of input check
    if not CorrectInput then
      ErrorStr := ErrorStr + 'Лабиринт введен неверно.' + #13
    else
    begin
      Lab.Seed.Height := i - 1;
      Lab.Seed.Width := w;
      Lab.Seed.Generated := UserText;
      Lab.Stats.Generated := UserText;
    end;
    CloseFile(LayoutFile);
  end
  else
  begin
    ErrorStr := ErrorStr + 'Файл не существует или недоступен.' + #13;
    CorrectInput := False;
  end;

  // real generation in case it's right
  if CorrectInput then
  begin
    Reset(LayoutFile);
    inMazeSize(Lab);
    i := 0;
    Lab.Seed.AmountOfExits := 0;
    while not EOF(LayoutFile) do
    begin
      readln(LayoutFile,str);
      j := 0;
      while (j<Lab.Seed.Width+2) do
      begin
        if Str[j] = '2' then
          inc(Lab.Seed.AmountOfExits);
        val(Str[j+1],Lab.Maze[i,j],Temp);
        inc(j);
      end;

      Inc(i); // i is the current number of line
    end;

  CloseFile(LayoutFile);
  end;
end;

// save maze to typed file
procedure writeMazeToTypedFile(const Lab: TMaze; const SeedFileName: string);
var
  SeedFile: TFileOfSeed;
begin
  AssignFile(SeedFile,SeedFileName);
  Rewrite(SeedFile);
  write(SeedFile,Lab.Seed);
  CloseFile(SeedFile);
end;

// generate maze by its seed
procedure inMazeFromItsSeed(var Lab: TMaze);
begin
  RandSeed := Lab.Seed.Value;
  case Lab.Seed.Generated of
    Sidewinder:
      begin
        inMazeSize(Lab);
        genSidewinder(Lab);
        addExits(Lab);
      end;
    AlduosBroder:
      begin
        inMazeSize(Lab);
        genAlduosBroder(Lab);
        addExits(Lab);
      end;
    Eller:
      begin
        inMazeSize(Lab);
        genEller(Lab);
        addExits(Lab);
      end;
  end;
end;

// input maze from saved file
procedure inMazeFromTypedFile(var Lab: TMaze; const SeedFileName: string);
var
  Temp: TMaze;
  SeedFile: TFileOfSeed;
begin
  AssignFile(SeedFile,SeedFileName);
  if FileExists(SeedFileName) then
  begin
    Reset(SeedFile);
    while not EOF(SeedFile) do
    begin
      Read(SeedFile,Temp.Seed);
      inMazeFromItsSeed(Temp);
      Lab.Seed := Temp.Seed;
      inMazeFromItsSeed(Lab);
    end;
  end;
  CloseFile(SeedFile);
end;

end.
 