unit khComponent;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
    TkhComboBox = class(TComboBox)
    private
        { Private declarations }
	    FValues: TStrings;
	    FReadOnly: Boolean;
	    procedure SetReadOnly(const Value: Boolean);
        procedure SetValues(Value: TStrings);
    protected
	    { Protected declarations }
	    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
	    procedure KeyPress(var Key: Char); override;
    public
        { Public declarations }
        constructor Create(AOwner: TComponent); override;
	    destructor  Destroy; override;
	    Function    GetValue:String;
	    Procedure   SetIndex(Value : String);
    published
        { Published declarations }
	    property    Values: TStrings read FValues write SetValues;
	    property    ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    end;

    TkhEdit = class(TEdit)
    private
        { Private declarations }
        FAlignment :TAlignment;
        FOnMouseLeave: TNotifyEvent;
        FOnMouseEnter: TNotifyEvent;
        procedure SetAlign(const Value : TAlignment);
    protected
        { Protected declarations }
        procedure CreateParams( var params: TCreateParams ); override;
	    procedure CmMouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
        procedure CmMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
    public
	    { Public declarations }
    published
        { Published declarations }
        property Alignment: TAlignment read FAlignment write SetAlign default taLeftJustify;
        property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
        property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    end;

    procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('skshpapa80_Pack', [TkhEdit]);
    RegisterComponents('skshpapa80_Pack', [TkhComboBox]);
end;

{ TkhComboBox }

constructor TkhComboBox.Create(AOwner : TComponent);
begin
    inherited Create(AOwner);
    FValues := TStringList.Create;
end;

destructor TkhComboBox.Destroy;
begin
    FValues.Free;
    inherited Destroy;
end;

{ 선택한 값 가져오기 }
function TkhComboBox.GetValue: String;
begin
    if Self.Text <> '' then
        Result := Self.FValues.Strings[Self.ItemIndex]
    else
        Result := '';
end;

{ 인덱스 설정 }
procedure TkhComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
    if FReadOnly then Key := 0;
    if (Key <> 0) then inherited KeyDown(Key, Shift);
end;

procedure TkhComboBox.KeyPress(var Key: Char);
begin
    if FReadOnly then Key := #0;
    if (Key <> #0) then inherited KeyPress(Key);
end;

procedure TkhComboBox.SetIndex(Value: String);
begin
    if Value = '' then Exit;
    Self.ItemIndex := Self.FValues.IndexOf(Value)
end;

{ 값 넘기기 }
procedure TkhComboBox.SetReadOnly(const Value: Boolean);
begin
    FReadOnly := Value;
    if FReadOnly then Style := csSimple
    else Style := csDropDownList;
end;

procedure TkhComboBox.SetValues(Value: TStrings);
begin
    Values.BeginUpdate;
    values.Clear;
    Values.Assign(Value);
    Values.EndUpdate;
end;

{ TkhEdit }

procedure TkhEdit.CreateParams(var params: TCreateParams);
const
    Styles : Array [TAlignment] of DWORD =(ES_LEFT, ES_RIGHT, ES_CENTER );
begin
    inherited;
    params.style := params.style or Styles[ FAlignment ] or ES_MULTILINE;
end;

procedure TkhEdit.SetAlign(const Value : TAlignment);
begin
    If FAlignment <> Value Then Begin
        FAlignment := Value;
        RecreateWnd;
    end;
end;

procedure TkhEdit.CmMouseEnter(var Msg: TMessage);
begin
    inherited;
    if Assigned(FOnMouseEnter) then
        FOnMouseEnter(Self);
end;

procedure TkhEdit.CmMouseLeave(var Msg: TMessage);
begin
    inherited;
    if Assigned(FOnMouseLeave) then
        FOnMouseLeave(Self);
end;

end.
