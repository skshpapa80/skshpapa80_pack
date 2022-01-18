unit khTrayIcon;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Forms,
    Winapi.ShellApi;

const
    WM_MYICON = WM_USER+1;

type
    TkhTrayIcon = class(TComponent)
    private
	    { Private declarations }
	    FHandle: THandle;
	    FCaption: String;
	    Tray: TNotifyIconData;
        procedure SetCaption(const Value: String);
    protected
	    { Protected declarations }
	    procedure WMMYICON(var Message: TMessage); message WM_MYICON;
    public
	    { Public declarations }
	    constructor Create(AOwner: TComponent); override;
	    destructor Destroy; override;
	    procedure RegistTrayIcon;
	    procedure RemoveTrayIcon;
    published
	    { Published declarations }
	    property Caption : String Read FCaption write SetCaption;
    end;

procedure Register;

implementation

procedure Register;
begin
    RegisterComponents('skshpapa80_Pack', [TkhTrayIcon]);
end;

{ TkhTrayIcon }

constructor TkhTrayIcon.Create(AOwner: TComponent);
begin
    inherited;
    FHandle := TForm(AOwner).Handle;
end;

destructor TkhTrayIcon.Destroy;
begin
    inherited;
end;

procedure TkhTrayIcon.RegistTrayIcon;
begin
    Tray.cbSize := SizeOf(Tray);
    Tray.Wnd := FHandle;
    Tray.uID := 100;
    Tray.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    Tray.uCallbackMessage := WM_MYICON;
    //nid.hIcon  := Application.Icon.Handle;
    StrPCopy(Tray.szTip,'');
    StrPCopy(Tray.szTip,'¾Ë¶÷');

    Shell_NotifyIcon(NIM_ADD, @Tray);
end;

procedure TkhTrayIcon.RemoveTrayIcon;
begin
    Shell_NotifyIcon(NIM_DELETE, @Tray);
end;

procedure TkhTrayIcon.SetCaption(const Value: String);
begin
    FCaption := Value;
end;

procedure TkhTrayIcon.WMMYICON(var Message: TMessage);
var
    pt : TPoint;
begin
    case Message.LParam of
        WM_RBUTTONUP : begin
            GetCursorPos(pt);
        end;
        WM_LBUTTONDBLCLK : begin

        end;
    end;
end;

end.
