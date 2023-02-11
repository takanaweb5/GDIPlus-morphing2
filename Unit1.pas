unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, GDIPOBJ, GDIPAPI;

type
  TForm1 = class(TForm)
    Image1: TImage;
    procedure Image1Click(Sender: TObject);
  private
    FGPBitmap: array[1..2] of TGPBitmap;
    FFlg: Boolean;
    procedure Image1Paint(Count: Integer);
  public
    { Public 宣言 }
  end;

const
  FILE1 = 'z:\file2.jpg';
  WAITTIME = 10; //1回ごとのウェイトタイム（ミリ秒）
  TIMES = 100;   //変身までに何回描画するか

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Image1Click(Sender: TObject);
begin
  for var i := 0 to TIMES do begin
    Image1Paint(i);
    Image1.Repaint;
    Sleep(WAITTIME);
  end;
  FFlg := not FFlg;
end;

procedure TForm1.Image1Paint(Count: Integer);
const
  CM_DEFAULT : TColorMatrix = (
      (1/3, 1/3, 1/3, 0, 0),
      (1/3, 1/3, 1/3, 0, 0),
      (1/3, 1/3, 1/3, 0, 0),
      (0, 0, 0, 1, 0),
      (0, 0, 0, 0, 1));
var
  gcanvas: TGPGraphics;
  cm: TColorMatrix;
  ia: TGPImageAttributes;
begin

  FGPBitmap[1] := TGPBitmap.Create(FILE1);
  var w := FGPBitmap[1].GetWidth;
  var h := FGPBitmap[1].GetHeight;
//  FGPBitmap[2] := TGPBitmap.Create(w,h,FGPBitmap[1].GetPixelFormat);
  FGPBitmap[2] := TGPBitmap.Create(w,h,PixelFormat32bppARGB);

  ia := TGPImageAttributes.Create;
  cm := CM_DEFAULT;

  ia.SetColorMatrix(cm);
  gcanvas := TGPGraphics.Create(FGPBitmap[2]);
  gcanvas.DrawImage(FGPBitmap[1], MakeRect(0, 0, w, h),
                                           0, 0, w, h,
                                  UnitPixel, ia);

  if FFlg then ia.SetThreshold(1- Count/TIMES)
          else ia.SetThreshold(Count/TIMES);

  FreeAndNil(gcanvas);
  gcanvas := TGPGraphics.Create(Image1.Canvas.Handle);
  gcanvas.DrawImage(FGPBitmap[2], MakeRect(0, 0, w, h),
                                           0, 0, w, h,
                                  UnitPixel, ia);


  FreeAndNil(gcanvas);
  FreeAndNil(ia);

  FreeAndNil(FGPBitmap[1]);
  FreeAndNil(FGPBitmap[2]);
end;

end.
