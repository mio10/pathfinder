uses
     crt;

const
     N = 24;

var
     map: array [1..N, 1..N] of integer;
     filled: boolean := false;

procedure InitMap();
begin
     for var i := 1 to N do
          for var j := 1 to N do
          begin
               map[i, j] := -1;
          end;
end;

procedure PrintMap();
begin
     for var i := 1 to N do
     begin
          for var j := 1 to N do
          begin
               //if map[i, j] <> -1 then
               //     Write(map[i, j])
               //else
                    write(0);
               
          end;
          Writeln();
     end;
end;

procedure MarkNeighbors(i: integer; j: integer; d: integer);
begin
     try
          if map[i, j-1] = -1 then
               map[i, j-1] := d;
     except
     end;

     try
          if map[i+1, j] = -1 then
               map[i+1, j] := d;
     except
     end;

     try
          if map[i, j+1] = -1 then
               map[i, j+1] := d;
     except
     end;

     try
          if map[i-1, j] = -1 then
               map[i-1, j] := d;
     except
     end;

end;

procedure WaveSpread(startX: integer; startY: integer; endX: integer; endY: integer);
begin
     map[startX, startY] := 0;
     var d := 0;
     while (map[endX, endY] = -1) and not filled do
     begin
          filled := true;
          for var i := 1 to N do
               for var j := 1 to N do
               begin
                    if map[i, j] = -1 then
                         filled := false;
                    if map[i, j] = d then
                         MarkNeighbors(i, j, d + 1);
               end;
          d += 1;
     end;
end;

procedure DrawPath(startX: integer; startY: integer; endX: integer; endY: integer);
begin
     var i := endX;
     var j := endY;
     if map[endX, endY] <> -2 then
          while (i <> startX) or (j <> startY) do
          begin
               gotoxy(i, j);
               write('.');
               try
                    if map[i, j-1] = map[i, j] - 1 then
                    begin
                         j -= 1;
                         continue;
                    end;
               except
               end;

               try
                    if map[i+1, j] = map[i, j] - 1 then
                    begin
                         i += 1;
                         continue;
                    end;
               except
               end;

               try
                    if map[i, j+1] = map[i, j] - 1 then
                    begin
                         j += 1;
                         continue;
                    end;
               except
               end;

               try
                    if map[i-1, j] = map[i, j] - 1 then
                    begin
                         i -= 1;
                         continue;
                    end;
               except
               end;

               
          end
     else
          Write('Path not found.');
     gotoxy(startX, startY);
     write('S');
     gotoxy(endX, endY);
     write('F');
end;

procedure DrawWalls();
begin
     for var i := 1 to N do
          for var j := 1 to N do
          begin
               if map[i, j] = -2 then
               begin
                     gotoxy(i, j);
                     write('#');
               end;
          end;
end;
begin
     InitMap();
     var ready: boolean := false;
     var posX := 1;
     var posY := 1;
     var startX := 1;
     var startY := 1;
     var endX := 24;
     var endY := 24;
     
     
          while not ready do
          begin
               ClrScr();
               gotoxy(26, 2);
               Write('[B] start at (' + startX + ', ' + startY + ')');
               gotoxy(26, 4);
               Write('[F] end at (' + endX + ', ' + endY + ')');
               gotoxy(26, 6);
               Write('[X] place wall');
               gotoxy(26, 8);
               write('[G] build path');
               gotoxy(startX, startY);
               write('S');
               gotoxy(endX, endY);
               write('F');
               gotoxy(posX, posY);
               write('x');
               DrawWalls();
               var key := ReadKey();
               
               if (key = 'w') and (posY > 1) then
                    posY -= 1;
               if (key = 's') and (posY < 24) then
                    posY += 1;
               if (key = 'a') and (posX > 1) then
                    posX -= 1;
               if (key = 'd') and (posX < 24) then
                    posX += 1;
               if key = 'b' then
               begin
                    startX := posX;
                    startY := posY;
               end;
               if key = 'f' then
               begin
                    endX := posX;
                    endY := posY;
               end;
               
               if key = 'x' then
                    if map[posX, posY] = -1 then
                         map[posX, posY] := -2;
                         
               if key = 'g' then
                    ready := true;
          end;
          
          WaveSpread(startX, startY, endX, endY);
          
          DrawPath(startX, startY, endX, endY);
          gotoxy(26,24);
     
end.