program hamback;


{$mode objfpc}{$H+}

uses
  Classes, Crt, sysutils, hb_gamelogic, hb_constants
  { you can add units after this };

//var

procedure showBoard();
          var
            c:integer;
            r:integer;
            pips:string;
            mnum:string;
          begin
          writeln(' 0  1  2  3  4  5  6');
          writeln(' |  |  |  |  |  |  |');
          for r in [0..5] do  //rows
              begin
                write(' ');
                for c in [0..6] do
                    begin
                      if gameboard[c]> (5-r) then write('o  ') else write('|  ')
                    end;
                writeln();
              end;
          writeln(' |  |  |  |  |  |  |');
          str(dicePips, pips);
          str(moveCount, mnum);
          writeln('Move #'+mnum+' Rolled: ' + pips);
          end;

function askPlayer():integer;
(*reads input WITHOUT
validity check*)
          var
            choise:integer=0;
            inp:string;
            //cinp:
          begin
          writeln('Your move? (0-5 or "q" to surrender)');
                   repeat
                   inp:=readKey;
                   choise:=StrToInt(inp);
                   if UpperCase(inp) = 'Q' then halt(0);
                   until choise in [0..6];
               askPlayer:=choise;
          end;

procedure PlayGame();
          begin
          repeat
          doMove(askPlayer());
          showBoard();
          //writeln(StatusToString(gameStatus) )
          until (gameStatus() = WIN) or (gameStatus() = LOOSE) ;
          writeln('====================');
          writeln(StatusToString(gameStatus) )
          end;

procedure newGame();
          begin
          startGame(False);
          showBoard();
          PlayGame()
          end;

procedure newHardGame();
          begin
          startGame(True);
          showBoard();
          PlayGame()
          end;



procedure startScreen();
          var
            gotInput:boolean=false;
            keyin:string;
          begin
          writeln(' ---------------');
          writeln('|-H-A-M-B-A-C-K-|');
          writeln('N - New game, X - new eXtra hard game, Q-Quit');
          writeln();
                     repeat
                     keyin:=readKey;
                     gotInput:=True;
                           case UpperCase(keyin) of
                           'Q' : halt(0);
                           'N' : newGame;
                           'X' : newHardGame;
                           else gotInput:=False;
                      end;
                     until gotInput;
          end;





BEGIN
randomize;

startScreen;

END.

