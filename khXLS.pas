unit khXLS;

interface

uses
    System.SysUtils, System.Classes, System.Variants, System.win.ComObj;

type
    TkhXLS = class(TComponent)
    private
        { Private declarations }
        oXL, oWK, oSheet: Variant;
    protected
        { Protected declarations }
    public
        { Public declarations }
        procedure AddSheet;
        procedure AddWork;
        procedure CloseXLS;
        function GetCell(Row, Col: Integer): String;
        function InitXLS:Boolean;
        function RowCount: Integer;
        procedure SaveXLS(SaveName: String);
        procedure SelSheet(Index: Integer);
        procedure SelWork(Index: Integer = 1);
        procedure SetCell(Row, Col: Integer; Value: String);
        procedure SetSheetName(SheetName: String);
		function XlsOpen(FileName: String):Boolean;
    published
        { Published declarations }
    end;

    procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('skshpapa80_Pack', [TkhXLS]);
end;

{ TkhXLS }

procedure TkhXLS.AddSheet;
begin
    oSheet := oWK.WorkSheets.Add;
end;

procedure TkhXLS.AddWork;
begin
    oWK := oXL.Workbooks.Add;
end;

procedure TkhXLS.CloseXLS;
begin
    oXL.WorkBooks.Close;
    oXL.Quit;
    oXL := unassigned;
end;

function TkhXLS.GetCell(Row, Col: Integer): String;
begin
    Result := VarToStr(oSheet.Cells[Row,Col]);
end;

function TkhXLS.InitXLS: Boolean;
begin
    // Initial Excel
    Result := False;
    try
	    oXL := CreateOleObject('Excel.Application');
    except
	    Exit;
    end;
    Result := True;
end;

function TkhXLS.RowCount: Integer;
begin
    Result := StrToInt(oSheet.UsedRange.Rows.count);
end;

procedure TkhXLS.SaveXLS(SaveName: String);
begin
    if SaveName = '' then Exit;
    oXL.Workbooks[1].SaveAs(SaveName);
end;

procedure TkhXLS.SelSheet(Index: Integer);
begin
    // Sheet Selecte
    if Index = 0 then
        oSheet := oWK.ActiveSheet
    else
        oSheet := oWK.WorkSheets.Item[Index];
end;

procedure TkhXLS.SelWork(Index: Integer);
begin
    oWK := oXL.WorkBooks.Item[Index];
end;

procedure TkhXLS.SetCell(Row, Col: Integer; Value: String);
begin
    if Value = '' then Exit;
    oSheet.Cells[Row,Col] := Value;
end;

procedure TkhXLS.SetSheetName(SheetName: String);
begin
    if SheetName = '' then Exit;
    oSheet.Name := SheetName;
end;

function TkhXLS.XlsOpen(FileName: String): Boolean;
begin
    // Excel File Open
    Result := False;
    try
	    oXL.Visible := False;
	    oXL.DisplayAlerts := False;
	    oXL.WorkBooks.Open(FileName, 0, true); // Read Only
    except
	    Exit;
    end;
    Result := True;
end;

end.
