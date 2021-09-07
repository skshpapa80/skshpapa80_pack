unit khGrid;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Grids, System.Variants, System.win.ComObj;

type
  TkhGrid = class(TStringGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure InsertRow(Index: Integer);            // Row Add
    procedure DeleteRow(Index: Integer); override;  // Row Remove
    function SaveXLS(SaveName: String): Boolean;
    procedure LoadXLS(LodeFileName : String);
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('skshpapa80_Pack', [TkhGrid]);
end;

{ TkhGrid }

constructor TkhGrid.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
end;

procedure TkhGrid.DeleteRow(Index: Integer);
begin
    inherited DeleteRow(Index);
end;

destructor TkhGrid.Destroy;
begin
    inherited;
end;

procedure TkhGrid.InsertRow(Index: Integer);
begin
    RowCount := RowCount + 1;
    RowMoved(RowCount,Index);
end;

procedure TkhGrid.LoadXLS(LodeFileName: String);
var
    oXL, oWK, oSheet: Variant;
    //oXL -> Excel Object
    //oWK -> Excel WorkBook Object
    //oSheet -> Excel Sheet Object
    i, j : integer;
begin
    oXL := CreateOleObject('Excel.Application'); // Initial Excel

    oXL.Visible := False; // Un Visible
    oXL.DisplayAlerts := False; // message not display
    oXL.WorkBooks.Open(LodeFileName, 0, true); // read only

    oWK := oXL.WorkBooks.Item[1];
    oSheet := oWK.ActiveSheet; // Get Select Sheet

    // Sheet Number Selection
    //oSheet := oWK.WorkSheets.Item[1];

    // oSheet.UsedRange.Rows.count = Sheet Row
    // oSheet.UsedRange.Columns.count = Sheet Col
    Self.ColCount := StrToInt(oSheet.UsedRange.Columns.count);
    Self.RowCount := StrToInt(oSheet.UsedRange.Rows.count);

    for i := 1 to StrToInt(oSheet.UsedRange.Rows.count) do begin
        // Cell Value VarToStr(oSheet.Cells[i,1])
        // Read Cell Value
        for j := 1 to StrToInt(oSheet.UsedRange.Columns.count) do begin
            Self.Cells[ j-1, i-1] := VarToStr(oSheet.Cells[i,j]);
        end;
    end;

    // Excel Close
    oXL.WorkBooks.Close;
    oXL.Quit;
    oXL := unassigned;
end;

function TkhGrid.SaveXLS(SaveName: String): Boolean;
var
    oXL, wb, Range: OleVariant;
    arrData: Variant;
    i, j: Integer;
begin
    Result := False;
    if SaveName = '' then Exit;

    // Data Area Make
    arrData := VarArrayCreate([1, Self.RowCount, 1, Self.ColCount], varVariant);

    // Data Binding
    for i := 1 to Self.RowCount do
        for j := 1 to Self.ColCount do
            arrData[i, j] := Self.Cells[j-1, i-1];

    // Initial Excel
    try
	    oXL := CreateOLEObject('Excel.Application');
    except
	    Exit;
    end;

    oXL.Visible := False;
	oXL.DisplayAlerts := False;

    // Workbook add
    wb := oXL.Workbooks.Add;

    // Workbook Range Setting
    Range := wb.WorkSheets[1].Range[wb.WorkSheets[1].Cells[1, 1],
                                 wb.WorkSheets[1].Cells[Self.RowCount, Self.ColCount]];

    // Workbook Value Insert
    Range.Value := arrData;

    // Complete
    oXL.Workbooks[1].SaveAs(SaveName);
    oXL.WorkBooks.Close;
    oXL.Quit;
    oXL := unassigned;
    Result := True;
end;

end.
