unit hb_gamelogic;

{$mode objfpc}{$H+}


(*
The Move consists of:


1. Get player's input <--\
2. Check for win          |
3. Move pawns             |
4. Throw                  |
5. Check loose            |
6. Start over >----------/

*)

interface

uses
  Classes, SysUtils, hb_constants;
type
  cbprocedure = procedure();  //callback
var
  gameboard:array[0..6] of integer;
  dicePips:integer;
  status:integer=IDLE;
  isHardened:boolean;
  moveCount:integer = 0;
  endcallback:cbprocedure;


function doMove(f:integer):boolean;
function gameStatus():integer;
procedure startGame(hardened:boolean);
procedure dummyCallback();


implementation

procedure setGameStatus(s:integer);
          begin
          writeln( 'Status changed: ' + StatusTOString(s) );
          status := s
          end;

procedure dummyCallback();
          begin
          writeln( StatusToString(status))
          end;


procedure throwDice();
          begin
            dicePips:= random(5)+1;
          end;

procedure startGame(hardened:boolean);
          var
            i:integer;
          begin
            gameboard[0]:=6;
            for  i in [1..6] do gameboard[i]:=0;
            isHardened:= hardened;
            setGameStatus(INPROCESS);
            moveCount:=1;
            throwDice()
          end;

procedure endGame();
          begin
          setGameStatus(IDLE);
          moveCount:=0;
          end;


function gameStatus():integer;
         begin
           gameStatus:=status;
         end;

function checkMove(f:integer):boolean;
         begin
          if gameboard[f] = 0 then
          begin
            checkMove:=False;
            exit;
          end;

          if (f+dicePips>6) and isHardened then
          begin
            checkMove:=False;
            exit;
          end;

          if (not isHardened) then
          begin
            if (f+dicePips>6) then
            begin
              if gameboard[6]=0 then
              begin
                checkMove:=False;
                exit;
              end
              else setGameStatus(TRADE);
            end;
          end;
         //end;

          checkMove:=True
        end;

function isAnyMovePossible():boolean;
         var
           x:integer;
         begin
           for x in [0..5] do
               begin
                 if checkMove(x) then
                    begin
                    isAnyMovePossible:=True;
                    exit;
                    end;
               end;
         isAnyMovePossible:=False;
         end;



function checkWin():boolean;
         var
         st:boolean;
         begin
              st:= gameboard[6]=6;
              if st then setGameStatus(WIN);
              checkWin:= st
         end;

procedure looseGame();
begin
    setGameStatus(LOOSE);
end;

function checkLoose():boolean;
begin
  if isHardened then
    begin
    if not isAnyMovePossible() then
       begin
       looseGame();
       checkLoose:=True;
       exit;
       end
    end
  else
  begin
    //lost conditions in non-hardened game
    if not isAnyMovePossible() and (gameboard[6] = 0) then
       begin
       looseGame();
       checkLoose:=true;
       exit;
       end;
    if not isAnyMovePossible() then
       begin
       setGameStatus(TRADE);
       checkLoose:=false;
       end;
  end;
end;

function doMove(f:integer):boolean;
(*This function does most of the work *)
         begin
         if (status=WIN) or (status=LOOSE)  then
            begin
                 writeln('Error: doMove called wrongly');
                 exit;
            end;

         if checkMove(f) then
            begin
                 if (status <> TRADE) then
                 begin
                      gameboard[f]:= gameboard[f]-1;
                      gameboard[f+dicePips]:= gameboard[f+dicePips]+1
                 end
                 else
                 begin
                      gameboard[0]+=1;
                      gameboard[6]-=1;
                      setGameStatus(INPROCESS)
                 end
            end;
            doMove:=True;
            if checkWin() then exit;

            throwDice();
            checkLoose();
            moveCount+=1;
            //doMove:=True;
            //checkLoose();
            //doMove:=False
         end;



end.

