unit untOtherController;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type

  [MVCPath('/api')]
  TCustomerController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;

    [MVCPath('/anothercall')]
    [MVCHTTPMethod([httpGET])]
    procedure AnotherCall;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;
  end;

implementation

uses
  System.SysUtils, MVCFramework.Logger, System.StrUtils, untTokenHelper,
  System.JSON;

procedure TCustomerController.Index;
begin
  //use Context property to access to the HTTP request and response 
  Render('Hello DelphiMVCFramework World');
end;

procedure TCustomerController.AnotherCall;
var
  S: string;
  JO: TJSONObject;
begin
  S := Context.Request.Cookie('authtoken');
  JO := TJSONObject.ParseJSONValue(untTokenHelper.GetDataFromToken(S, untTokenHelper.TheKey)) as TJSONObject;
  Render( JO.GetValue('UserID').Value + ',' +
          JO.GetValue('FullName').Value + ',' +
          JO.GetValue('Database').Value);
end;

procedure TCustomerController.OnAfterAction(Context: TWebContext; const AActionName: string); 
begin
  { Executed after each action }
  inherited;
end;

procedure TCustomerController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;



end.
