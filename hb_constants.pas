unit hb_constants;

{$mode objfpc}{$H+}

interface
const
  (*statuses*)
  WIN=        1; //game won
  LOOSE=      2; //game lost
  INPROCESS=  3; //game is going on
  WAITING=    4;
  ERROR=      5;  //error?
  IDLE=       6; //no game at all
  TRADE=     7; //no moves in regular rulers, trade 1



//uses
function StatusToString(s:integer):string;

implementation

function StatusToString(s:integer):string;
         var
           r:string;
         begin
           case s of
                WIN: r:= 'Game is won';
                LOOSE: r:= 'Game is lost';
                INPROCESS: r:='Game in process';
                WAITING: r:='Game waits for something';
                ERROR: r:='Error occured';
                IDLE: r:='Game either finished or not started';
                TRADE: r:='You can''t move, one stone goes back';
                else r:='Unknown status';
           end;
           StatusToString:=r;
         end;




end.

