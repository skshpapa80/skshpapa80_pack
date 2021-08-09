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
