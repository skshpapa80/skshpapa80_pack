//**************************************************************
//
//  khImage Component
//    - Bitmap/Jpeg Image Load
//    - Zoom/Rotate
//  Make By skshpapa80@gmail.com
//
//**************************************************************
unit khImage;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Graphics, System.Types,
  Vcl.Imaging.Jpeg, System.Math;

type
  // Image View Mode
  TViewMode = (Normal, Fit);
  // Left Mouse Mode
  TMouseMode = (mNone, mZoom, mDrag);

  TkhImage = class(TGraphicControl)
  private
    { Private declarations }
    FFileName: String;
    FBitmap: TBitmap;
    FViewMode: TViewMode;
    FZoom: Integer;
    FShowRect, FPicRect: TRect;
    FMouseMode: TMouseMode;
    X1,Y1,X2,Y2: Integer;
  protected
    { Protected declarations }
    procedure Paint; override;

    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;

    procedure SetViewMode(Value : TViewMode);
    procedure SetMouseMode(Value : TMouseMode);
    procedure SetZoom(Value : Integer);
    procedure Invert;

    Function LoadImage(FileName: String):Boolean;
    Function LoadJpeg(FileName: String):Boolean;
  published
    { Published declarations }
    property Color;
    property Align;
    property Width;
    property Height;
    property DragCursor;
    property DragMode;
    property Visible;
    property Hint;
    property ShowHint;

    property ViewMode : TViewMode read FViewMode write SetViewMode default Normal;
    property MouseMode : TMouseMode read FMouseMode write SetMouseMode default mZoom;
    property Zoom : Integer read FZoom write SetZoom default 100;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('skshpapa80_Pack', [TkhImage]);
end;

//****************************************************************
//JPEG 체크 함수
//****************************************************************
Function IsJpeg(filename:string):integer; // 1이면 jpeg
var
    Fsrc: integer;
    Op: longint;
    buffer: array [0..3072] of byte;
begin
    op:=0;
    Fsrc := Fileopen(filename, fmopenread);
    if Fsrc >= 0 then begin
	    Fileseek(Fsrc, 0, 2);
	    Fileseek(Fsrc, 0, 0);
	    Fileread(Fsrc, buffer, sizeof( buffer));
	    Fileclose(Fsrc);
	    // ff d8 ff 검출
	    if (buffer[0]=$ff) and (buffer[1]=$d8) and (buffer[2]=$ff) then begin
		    op:=1;
	     end;
    end
    else begin
	    op:=0;
    end;
    Result:=op;
end;

{ TkhImage }

constructor TkhImage.Create(AOwner: TComponent);
begin
    inherited;
    ControlStyle := ControlStyle + [csReplicatable,csOpaque];
    FBitmap := TBitmap.Create;
    FBitmap.Width := Width;
    FBitmap.Height := Height;
end;

destructor TkhImage.Destroy;
begin
    FBitmap.Free;
    inherited;
end;

procedure TkhImage.Invert;
var
    x, y: Integer;
    ByteArray: PByteArray;
begin
    // Invert
    FBitmap.PixelFormat := pf24Bit;
    for y := 0 to FBitmap.Height - 1 do begin
	    ByteArray := FBitmap.ScanLine[y];
	    for x := 0 to FBitmap.Width * 3 - 1 do begin
            ByteArray[x] := 255 - ByteArray[x];
        end;
    end;
    Paint;
end;

function TkhImage.LoadImage(FileName: String): Boolean;
begin
    Result := False;
    if FileName = '' then Exit;
    if not FileExists(FileName) then Exit;

    FFileName := FileName;

    // Chk Jpeg Image
    if IsJpeg(FileName) = 1 then begin
	    // Jpeg Image Load
	    if not LoadJpeg(FileName) then
		    Exit
	    else begin
		    Result := True;
		    Exit;
	    end;
    end
    else begin
	    try
		    FBitmap.LoadFromFile(FileName);
		    FPicRect := Rect(0,0,FBitmap.Width,FBitmap.Height);
	    except
		    Exit;
	    end;
    end;
    Paint;
    Result := True;
end;

function TkhImage.LoadJpeg(FileName: String): Boolean;
var
    JpegImg: TJpegImage;
begin
    Result := False;
    if FileName = '' then Exit;

    JpegImg := TJpegImage.Create;
    try
	    JpegImg.LoadFromFile(FileName);
	    JpegImg.DIBNeeded;
	    FBitmap.Height := JpegImg.Height;
	    FBitmap.Width  := JpegImg.Width;
	    FBitmap.Assign(JpegImg);
	    FPicRect := Rect(0,0,FBitmap.Width,FBitmap.Height);
    except
	    JpegImg.Free;
	    Exit;
    end;
    JpegImg.Free;
    Result := True;
end;

procedure TkhImage.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    inherited;
    if FMouseMode = mNone then
        Exit
    else if FMouseMode = mZoom then begin
	    X1 := X;
	    Y1 := Y;
	    X2 := X;
	    Y2 := Y;
	    Canvas.Pen.Mode:=pmNot;
    end
    else if FMouseMode = mDrag then begin

    end;
end;

procedure TkhImage.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
    inherited;
    if FMouseMode = mNone then
        Exit
    else if FMouseMode = mZoom then begin
	    Canvas.DrawFocusRect(Rect(Min(X1,X2),Min(Y1,Y2),Max(X1,X2),Max(Y1,Y2)));
	    X2 := X; Y2 := Y;
	    Canvas.DrawFocusRect(Rect(Min(X1,X2),Min(Y1,Y2),Max(X1,X2),Max(Y1,Y2)));
    end
    else if FMouseMode = mDrag then begin

    end;
end;

procedure TkhImage.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    inherited;
    if FMouseMode = mNone then
        Exit
    else if FMouseMode = mZoom then begin

    end
    else if FMouseMode = mDrag then begin

    end;
end;

procedure TkhImage.Paint;
var
    Buf: TBitmap;
begin
    inherited;
    if FBitmap.Empty then Exit;
    FShowRect := Rect(0,0,Width,Height);

    Buf := TBitmap.Create;
    Buf.Width := Width;
    Buf.Height := Height;
    Buf.Canvas.CopyMode := cmSrcCopy;
    Buf.Canvas.CopyRect(FPicRect,FBitmap.Canvas,FPicRect);

    Canvas.CopyMode:=cmSrcCopy;
    Canvas.Draw(0,0,Buf);
    Buf.Free;
end;

procedure TkhImage.SetMouseMode(Value: TMouseMode);
begin
    FMouseMode := Value;
end;

procedure TkhImage.SetViewMode(Value: TViewMode);
begin
    FViewMode := Value;
end;

procedure TkhImage.SetZoom(Value: Integer);
begin
    FZoom := Value;
end;

end.
