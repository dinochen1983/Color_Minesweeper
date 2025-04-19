unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, MATH, MMSystem, Vcl.Imaging.jpeg;


type TGRID=RECORD
NUMBER:INTEGER;
BOMB:INTEGER;  //0: NO BOMB  1: BOMB;
FLAG:INTEGER;  //0: NO FLAG  1,2,3: RGB FLAG
COVER:INTEGER;  //0 COVER 1: REVEAL
ID_BOMB:ARRAY [0..8]OF INTEGER;  //ID
COLOR:INTEGER; //1,R,2,G,3,B, BOMB COLOR
RR,GG,BB:INTEGER;
END;


type
  TForm1 = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image3: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Timer1: TTimer;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    PROCEDURE DRAW_GRID;
    PROCEDURE DRAW_BOMB;
    PROCEDURE FILL(I,J:INTEGER);
    PROCEDURE START_GAME;

    { Public declarations }
  end;

var
  Form1: TForm1;
  GRID:ARRAY OF ARRAY OF TGRID;
  SIZE:INTEGER;
  NUM_R,NUM_G,NUM_B:INTEGER;
  C_TIME:INTEGER;
  assets_bmp:tbitmap;
  kbmp:array[0..8] of tbitmap;

implementation

{$R *.dfm}
{$R MYRC.RES}

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
VAR KI,KJ:INTEGER;
WX,WY:DOUBLE;
KR_NUM,KG_NUM,KB_NUM:INTEGER;
GNUM:INTEGER;
I,J:INTEGER;
begin
   //
   //
   WX:=IMAGE1.Width/SIZE;
   WY:=IMAGE1.Height/SIZE;
   KI:=FLOOR(X/WX)+1;
   KJ:=FLOOR(Y/WY)+1;
   //
   IF BUTTON=MBLEFT THEN
   BEGIN
   IF GRID[KI,KJ].COVER=0 THEN
   BEGIN
    FILL(KI,KJ);
    DRAW_GRID;
    GRID[KI,KJ].FLAG:=0;
   END;
   //
   IF GRID[KI,KJ].BOMB=1 THEN
   BEGIN
   DRAW_BOMB;
   IMAGE1.Enabled:=FALSE;
   END;
   END;
   //
   IF BUTTON=MBRIGHT THEN
   BEGIN
    if GRID[KI,KJ].COVER=0 then
    BEGIN
    APPLICATION.ProcessMessages;
   // sndPlaySound('k1.wav',  SND_NODEFAULT);
    PlaySound('WAV1', 0, SND_RESOURCE);
    GRID[KI,KJ].FLAG:=(GRID[KI,KJ].FLAG+1)MOD 4;
    DRAW_GRID;
    END;
   END;
   //
   KR_NUM:=0;
   KG_NUM:=0;
   KB_NUM:=0;
   FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
       IF (GRID[I,J].FLAG=1) THEN
       BEGIN
        KR_NUM:=KR_NUM+1;
       END;
       IF (GRID[I,J].FLAG=2) THEN
       BEGIN
        KG_NUM:=KG_NUM+1;
       END;
       IF (GRID[I,J].FLAG=3) THEN
       BEGIN
        KB_NUM:=KB_NUM+1;
       END;
   END;

   GNUM:=KR_NUM+KG_NUM+KB_NUM;
   LABEL1.Caption:=INTTOSTR(GNUM);
   LABEL2.Caption:=INTTOSTR(KR_NUM);
   LABEL3.Caption:=INTTOSTR(KG_NUM);
   LABEL4.Caption:=INTTOSTR(KB_NUM);
   //
   IF (NUM_R=KR_NUM) AND (NUM_G=KG_NUM) AND (NUM_B=KB_NUM) THEN
   BEGIN
   LABEL5.Visible:=TRUE;
   LABEL5.Font.Color:=CLYELLOW;
   TIMER1.Enabled:=FALSE;
     image1.Canvas.Brush.Color:=clblack;
     image1.Canvas.Pen.Color:=clblack;
     image1.Canvas.Rectangle(50,200,50+400,200+100);
   LABEL5.Caption:='YOU WON!!!';
   APPLICATION.ProcessMessages;
 //  sndPlaySound('k3.wav',  SND_NODEFAULT);
   PlaySound('WAV3', 0, SND_RESOURCE);
   END;



end;


procedure TForm1.Image3Click(Sender: TObject);
begin
  IMAGE1.Enabled:=true;
  form1.START_GAME;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
begin
 C_TIME:=C_TIME+1;
 LABEL7.Caption:=INTTOSTR(C_TIME);
end;

PROCEDURE TFORM1.DRAW_BOMB;
VAR I,J:INTEGER;
WX,WY:DOUBLE;
AX,AY,BX,BY:INTEGER;
PX,PY:INTEGER;
KNUM:INTEGER;
BEGIN
 DRAW_GRID;
 WX:=IMAGE1.Width/SIZE;
 WY:=IMAGE1.Height/SIZE;
 FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
      IF GRID[I,J].BOMB=1 THEN
      BEGIN
      PX:=ROUND(WX*(I-0.5));  PY:=ROUND(WY*(J-0.5));
      IMAGE1.Canvas.Brush.Color:=CLYELLOW;
      IMAGE1.Canvas.Pen.Color:=CLBLACK;
       if GRID[I,J].COLOR=1 then
       BEGIN
         image1.Canvas.Draw(PX-25,PY-25,kbmp[0]);
       END
       else if GRID[I,J].COLOR=2 then
       BEGIN
         image1.Canvas.Draw(PX-25,PY-25,kbmp[1]);
       END
       else if GRID[I,J].COLOR=3 then
       BEGIN
         image1.Canvas.Draw(PX-25,PY-25,kbmp[2]);
       END;
      END;
   END;
     //
     LABEL5.Visible:=TRUE;
     LABEL5.Font.Color:=CLRED;
     image1.Canvas.Brush.Color:=clblack;
     image1.Canvas.Pen.Color:=clblack;
     image1.Canvas.Rectangle(50,200,50+400,200+100);
     LABEL5.Caption:='GAME OVER';
     TIMER1.Enabled:=FALSE;
     application.processmessages;
     //sndPlaySound('k2.wav',  SND_NODEFAULT);
     PlaySound('WAV2', 0, SND_RESOURCE);
END;


PROCEDURE TFORM1.FILL(I,J:INTEGER);
BEGIN
  IF (I<>0) AND (I<>SIZE+1) AND (J<>0) AND (J<>SIZE+1)  THEN
  BEGIN
  IF (GRID[I,J].BOMB=0) AND (GRID[I,J].COVER=0) AND (GRID[I,J].NUMBER<2) THEN
   BEGIN
   GRID[I,J].COVER:=1;
   FILL(I,J+1);
   FILL(I,J-1);
   FILL(I+1,J);
   FILL(I-1,J);
   END;
  IF (GRID[I,J].NUMBER>=2) THEN
   BEGIN
   GRID[I,J].COVER:=1;
   END;
  END;
END;




PROCEDURE TFORM1.DRAW_GRID;
VAR I,J:INTEGER;
WX,WY:DOUBLE;
AX,AY,BX,BY:INTEGER;
PX,PY:INTEGER;
KNUM:INTEGER;
CL2:TCOLOR;
BEGIN
 IMAGE1.Canvas.Rectangle(0,0,IMAGE1.Width,IMAGE1.Height);
 WX:=IMAGE1.Width/SIZE;
 WY:=IMAGE1.Height/SIZE;
 FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      BX:=ROUND(WX*(I));  BY:=ROUND(WY*(J));
      IMAGE1.Canvas.Rectangle(AX,AY,BX,BY);
   END;
 //
 IMAGE1.Canvas.Brush.Color:=CLGRAY;
 IMAGE1.Canvas.Pen.Color:=CLBLACK;
 FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
      IMAGE1.Canvas.Brush.Color:=CLGRAY;
      IMAGE1.Canvas.Brush.Style:=BSSOLID;
      IF GRID[I,J].COVER=0 THEN
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      BX:=ROUND(WX*(I));  BY:=ROUND(WY*(J));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[5]);
      END;
      IF GRID[I,J].COVER=1 THEN
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      BX:=ROUND(WX*(I));  BY:=ROUND(WY*(J));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[4]);
      END;
      IMAGE1.Canvas.Brush.Color:=CLRED;
      IF GRID[I,J].FLAG=1 THEN
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[6]);
      END
      ELSE if  GRID[I,J].FLAG=2  then
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[7]);
      END
      ELSE if  GRID[I,J].FLAG=3  then
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[8]);
      END;
      //
      IMAGE1.Canvas.Brush.Color:=CLGRAY;
      IF GRID[I,J].COVER=1 THEN
      BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      BX:=ROUND(WX*(I));  BY:=ROUND(WY*(J));
      IMAGE1.Canvas.Draw(AX,AY,kBMP[4]);
      PX:=ROUND(WX*(I-0.5));  PY:=ROUND(WY*(J-0.5));

      if (GRID[I,J].RR=1) AND (GRID[I,J].GG=0) AND (GRID[I,J].BB=0) then   CL2:=CLRED;
      if (GRID[I,J].RR=0) AND (GRID[I,J].GG=1) AND (GRID[I,J].BB=0) then   CL2:=CLGREEN;
      if (GRID[I,J].RR=0) AND (GRID[I,J].GG=0) AND (GRID[I,J].BB=1) then   CL2:=CLBLUE;

      if (GRID[I,J].RR=1) AND (GRID[I,J].GG=1) AND (GRID[I,J].BB=0) then   CL2:=CLYELLOW;
      if (GRID[I,J].RR=0) AND (GRID[I,J].GG=1) AND (GRID[I,J].BB=1) then   CL2:=CLAQUA;
      if (GRID[I,J].RR=1) AND (GRID[I,J].GG=0) AND (GRID[I,J].BB=1) then   CL2:=CLFUCHSIA;

      if (GRID[I,J].RR=1) AND (GRID[I,J].GG=1) AND (GRID[I,J].BB=1) then   CL2:=CLWHITE;
      if (GRID[I,J].RR=0) AND (GRID[I,J].GG=0) AND (GRID[I,J].BB=0) then   CL2:=CLBLACK;
      //
      PX:=ROUND(WX*(I-0.5));  PY:=ROUND(WY*(J-0.5));
      //
      IMAGE1.Canvas.Font.Size:=20;
        if GRID[I,J].NUMBER>0 then
        BEGIN
          IMAGE1.Canvas.Brush.Style:=BSCLEAR;
          IMAGE1.Canvas.Font.Color:=CLBLACK;
          IMAGE1.Canvas.TextOut(PX-10,PY-25,INTTOSTR(GRID[I,J].NUMBER));
          IMAGE1.Canvas.Font.Color:=CL2;
          IMAGE1.Canvas.TextOut(PX-11,PY-26,INTTOSTR(GRID[I,J].NUMBER));
        END;
      END;
      //
   END;

END;






procedure TForm1.FormCreate(Sender: TObject);
VAR K:INTEGER;
begin
assets_bmp:=tbitmap.Create;
assets_bmp.LoadFromResourceName(HInstance,'BMP1');

for K := 0 to 8 do
 BEGIN
  KBMP[K]:=TBITMAP.Create;
  KBMP[K].Width:=50;
  KBMP[K].Height:=50;
  KBMP[K].Canvas.CopyRect(RECT(0,0,50,50),assets_bmp.Canvas,RECT(k*50,0,k*50+50,50));
 END;

end;

procedure TForm1.FormDestroy(Sender: TObject);
VAR K:INTEGER;
begin
for K := 0 to 8 do
 BEGIN
  KBMP[K].Free;
 END;
assets_bmp.Free;
end;



procedure TForm1.FormShow(Sender: TObject);
begin
  form1.START_GAME;
end;

PROCEDURE TFORM1.START_GAME;
VAR I,J:INTEGER;
WX,WY:DOUBLE;
AX,AY,BX,BY:INTEGER;
PX,PY:INTEGER;
KNUM:INTEGER;
K:INTEGER;
VALUE:INTEGER;
CL_VALUE:ARRAY[0..3]OF INTEGER;
GG:INTEGER;
P:INTEGER;
K1,K2:INTEGER;
REP:BOOL;
begin
  /////////////////////////////////
  ///                            //
  ///    Start Game              //
  ///                            //
  /////////////////////////////////
  C_TIME:=0;
  LABEL5.Visible:=FALSE;
  TIMER1.Enabled:=TRUE;
  SIZE:=10;                       //grid size 10x10
  SETLENGTH(GRID,SIZE+2,SIZE+2);
  RANDOMIZE;
  FOR I:=0 TO SIZE+1 DO
   FOR J:=0 TO SIZE+1 DO
   BEGIN
     GRID[I,J].BOMB:=0;
     GRID[I,J].COVER:=0;
     GRID[I,J].FLAG:=0;
   END;
  /////////////////////////////////
   WX:=IMAGE1.Width/SIZE;
   WY:=IMAGE1.Height/SIZE;
  /////////////////////////////////
  ///                            //
  ///   gen grid                 //
  ///                            //
  /////////////////////////////////
  REP:=TRUE;
  while REP=TRUE do
  BEGIN
    FOR I:=1 TO SIZE DO
     FOR J:=1 TO SIZE DO
     BEGIN
       GRID[I,J].NUMBER:=0;
       GRID[I,J].BOMB:=ROUND(RANDOM*0.66);
       for K := 1 to 8 do
       BEGIN
         GRID[I,J].ID_BOMB[K]:=0;
       END;
     END;
     FOR I:=1 TO SIZE DO
     FOR J:=1 TO SIZE DO
     BEGIN
       KNUM:=0;
       IF GRID[I-1,J-1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[1]:=1; END;
       IF GRID[I  ,J-1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[2]:=1; END;
       IF GRID[I+1,J-1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[3]:=1; END;
       IF GRID[I-1,J  ].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[4]:=1; END;
       IF GRID[I+1,J  ].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[5]:=1; END;
       IF GRID[I-1,J+1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[6]:=1; END;
       IF GRID[I  ,J+1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[7]:=1; END;
       IF GRID[I+1,J+1].BOMB=1 THEN BEGIN KNUM:=KNUM+1; GRID[I,J].ID_BOMB[8]:=1; END;
       GRID[I,J].NUMBER:=KNUM;
     END;
     FOR I:=1 TO SIZE DO
     FOR J:=1 TO SIZE DO
     BEGIN
       IF GRID[I,J].BOMB=1 THEN GRID[I,J].NUMBER:=0;
     END;
     REP:=FALSE;
     FOR I:=1 TO SIZE DO
     FOR J:=1 TO SIZE DO
     BEGIN
       if GRID[I,J].NUMBER>=4 then
       BEGIN
         REP:=TRUE;
         BREAK;
       END;
     END;

   END;
   //
   RANDOMIZE;
   FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
     if GRID[I,J].BOMB=1 then
     begin
        GRID[I,J].COLOR:=CEIL(0.1+RANDOM*2.8); //r g b color
     end;
   END;
   //
   FOR I:=1 TO SIZE DO
     FOR J:=1 TO SIZE DO
     BEGIN
       CL_VALUE[1]:=0;
       CL_VALUE[2]:=0;
       CL_VALUE[3]:=0;
       IF (GRID[I-1,J-1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I-1,J-1].COLOR]:=CL_VALUE[GRID[I-1,J-1].COLOR]+1; END;
       IF (GRID[I  ,J-1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I  ,J-1].COLOR]:=CL_VALUE[GRID[I  ,J-1].COLOR]+1; END;
       IF (GRID[I+1,J-1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I+1,J-1].COLOR]:=CL_VALUE[GRID[I+1,J-1].COLOR]+1; END;
       IF (GRID[I-1,J].BOMB=1)   THEN BEGIN CL_VALUE[GRID[I-1,J  ].COLOR]:=CL_VALUE[GRID[I-1,J  ].COLOR]+1; END;
       IF (GRID[I+1,J].BOMB=1)   THEN BEGIN CL_VALUE[GRID[I+1,J  ].COLOR]:=CL_VALUE[GRID[I+1,J  ].COLOR]+1; END;
       IF (GRID[I-1,J+1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I-1,J+1].COLOR]:=CL_VALUE[GRID[I-1,J+1].COLOR]+1; END;
       IF (GRID[I  ,J+1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I  ,J+1].COLOR]:=CL_VALUE[GRID[I  ,J+1].COLOR]+1; END;
       IF (GRID[I+1,J+1].BOMB=1) THEN BEGIN CL_VALUE[GRID[I+1,J+1].COLOR]:=CL_VALUE[GRID[I+1,J+1].COLOR]+1; END;
       //
       GRID[I,J].RR:=0;
       GRID[I,J].GG:=0;
       GRID[I,J].BB:=0;
       //
       if CL_VALUE[1]<>0 then   GRID[I,J].RR:=1;
       if CL_VALUE[2]<>0 then   GRID[I,J].GG:=1;
       if CL_VALUE[3]<>0 then   GRID[I,J].BB:=1;
       // if GRID[I,J].VALUE<100 then GRID[I,J].TEXT_COLOR:=1;
     END;
   //
  NUM_R:=0;
  NUM_G:=0;
  NUM_B:=0;
  FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO
   BEGIN
     if (GRID[I,J].BOMB=1) AND (GRID[I,J].COLOR=1) then NUM_R:=NUM_R+1;
     if (GRID[I,J].BOMB=1)AND  (GRID[I,J].COLOR=2) then NUM_G:=NUM_G+1;
     if (GRID[I,J].BOMB=1)AND  (GRID[I,J].COLOR=3) then NUM_B:=NUM_B+1;
   END;
   LABEL6.Caption:=FORMAT('RED = %D, GREEN = %D, BLUE = %D',[NUM_R, NUM_G,NUM_B]);
   LABEL6.Visible:=FALSE;
  /////////////////////////////////
  ///                            //
  ///    draw grid               //
  ///                            //
  /////////////////////////////////
  IMAGE1.Canvas.FONT.Name:='Sitka Small';
  IMAGE1.Canvas.Font.Size:=16;
  IMAGE1.Canvas.Font.Style:=[FSBOLD];
  ////////////////////////////////////////////////////////////////////////////////
   FOR I:=1 TO SIZE DO
   FOR J:=1 TO SIZE DO    //draw block
   BEGIN
      AX:=ROUND(WX*(I-1));  AY:=ROUND(WY*(J-1));
      BX:=ROUND(WX*(I));  BY:=ROUND(WY*(J));
      IMAGE1.Canvas.Draw(AX,AY,kbmp[5]);
   END;

end;

end.
