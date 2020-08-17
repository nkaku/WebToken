unit untController;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type

  [MVCPath('/api')]
  TMyController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/login')]
    [MVCHTTPMethod([httpGET])]
    procedure Login;

    [MVCPath('/validCall')]
    [MVCHTTPMethod([httpGET])]
    procedure ValidCall;


  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, System.JSON, untTokenHelper,
  Web.HTTPApp, System.DateUtils;

procedure TMyController.Index;
begin
  //use Context property to access to the HTTP request and response
  Render('Hello DelphiMVCFramework World');
end;

procedure TMyController.Login;
var
  JO: TJSONObject;
  NC: TCookie;
begin

  JO := TJSONObject.Create;
  JO.AddPair('UserID', '1');
  JO.AddPair('FullName', 'Nirav Kaku');
  JO.AddPair('Database', 'abccorp');

  NC := Context.Response.Cookies.Add;
//  NC.Secure := True;
  NC.Expires :=  IncHour(Now);
//  NC.Domain := 'localhost';
  NC.Name := 'authtoken';
  NC.Value := untTokenHelper.GetTokenFromData(JO.ToJSON, untTokenHelper.TheKey);

  Render('Logged In');

  JO.Free;
end;

procedure TMyController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TMyController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;



procedure TMyController.ValidCall;
var
  JO  : TJSONObject;
  CD  : string;
  D   : string;
begin
  CD := Context.Request.Cookie('authtoken');
  D := untTokenHelper.GetDataFromToken(CD, untTokenHelper.TheKey);
  if D <> 'Invalid token' then
  begin
    JO := TJSONObject.ParseJSONValue(D) as TJSONObject;
    Render( JO.GetValue('UserID').Value + ',' +
            JO.GetValue('FullName').Value + ',' +
            JO.GetValue('Database').Value);
  end
  else
    Render('Invalid login');
end;

end.
