unit khReport;

interface

uses
    Winapi.Windows, System.Classes, System.SysUtils, Vcl.Printers, Vcl.Graphics, System.Types;

type
  TKhReport = Class(TComponent)
  private
	  { Private declarations }
	  FPrinter: String;
  public
    { Public declarations }
	  procedure SetPrinter(PrinterName: String);
	  procedure PrinterSetup;
	  procedure PrintBmp( ARect: TRect; ABitmap: TBitmap );
	  procedure PrintText(X,Y: Integer; Str: String);
	  procedure PrintLine(X1,Y1,X2,Y2: Integer; Color: TColor);

	  procedure BeginDoc;
	  procedure EndDoc;
	  procedure NewPage;
  published
	  { Published declarations }
	  property PrinterName: String read FPrinter write SetPrinter;
  end;

implementation

procedure Register;
begin
  RegisterComponents('skshpapa80_Pack', [TkhReport]);
end;

{ TKhReport }

procedure TKhReport.BeginDoc;
begin
    Printer.BeginDoc;
end;

procedure TKhReport.EndDoc;
begin
    Printer.EndDoc;
end;

procedure TKhReport.NewPage;
begin
    Printer.NewPage;
end;

procedure TKhReport.PrintBmp(ARect: TRect; ABitmap: TBitmap);
var
    Info: PBitmapInfo;
    InfoSize: DWORD;
    Image: Pointer;
    ImageSize: DWORD;
    Bits: HBITMAP;
    DIBWidth, DIBHeight: Longint;
begin
    with Printer, Canvas do begin
	    Bits := ABitmap.Handle;
	    GetDIBSizes( Bits, InfoSize, ImageSize );
	    Info := AllocMem( InfoSize );
	    try
		    Image := AllocMem( ImageSize );
		    try
		        GetDIB( Bits, ABitmap.Palette, Info^, Image^ );
		        with Info^.bmiHeader do begin
			        DIBWidth := biWidth;
			        DIBHeight := biHeight;
		        end;
		        StretchDIBits( Printer.Canvas.Handle,
							    ARect.Left, ARect.Top, ARect.Right, ARect.Bottom,
								  0, 0, DIBWidth, DIBHeight,
								  Image, Info^, DIB_RGB_COLORS, SRCCOPY );
		    finally
		        FreeMem( Image, ImageSize );
		    end;
	    finally
		    FreeMem( Info, InfoSize );
	    end;
    end;
end;

procedure TKhReport.PrinterSetup;
begin
    FPrinter := Printer.Printers.Strings[Printer.PrinterIndex];
end;

procedure TKhReport.PrintLine(X1, Y1, X2, Y2: Integer; Color: TColor);
begin
    with Printer do begin
	    Canvas.MoveTo(X1,Y1);
	    Canvas.LineTo(X2,Y2);
    end;
end;

procedure TKhReport.PrintText(X, Y: Integer; Str: String);
begin
    with Printer do begin
	    Canvas.TextOut(X,Y,Str);
    end;
end;

procedure TKhReport.SetPrinter(PrinterName: String);
begin
    FPrinter := PrinterName;
end;

end.
