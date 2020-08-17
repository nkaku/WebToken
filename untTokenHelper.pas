unit untTokenHelper;

interface

uses
  System.JSON, System.NetEncoding, System.Hash, System.SysUtils;

const
  TheKey = '{1017CD6D-2CCC-4F71-882B-A0448F432DC1}';

function GetTokenFromData(Data: string; SecretKey: string): string;
function GetDataFromToken(Token: string; SecretKey: string): string;

implementation

function GetTokenFromData(Data: string; SecretKey: string): string;
var
  EncodedData       : string;
  EncodedDataHash   : string;
  CustomEncoder     : TBase64Encoding;
begin
  CustomEncoder := TBase64Encoding.Create(0);
  EncodedData := CustomEncoder.Encode(Data);
  EncodedDataHash := THashSHA2.GetHMAC(EncodedData, SecretKey);
  Result := EncodedData + '.' + EncodedDataHash;
end;

function GetDataFromToken(Token: string; SecretKey: string): string;
var
  EncodedData       : string;
  EncodedDataHash   : string;
  CheckDataHash     : string;
  CustomEncoder     : TBase64Encoding;
begin
  CustomEncoder := TBase64Encoding.Create(0);
  EncodedData := Copy(Token, 1, Pos('.', Token) - 1);
  EncodedData := StringReplace(EncodedData, '%3D', '=', [rfReplaceAll]);
  EncodedDataHash := Copy(Token, Pos('.', Token) + 1, Length(Token)- (Pos('.', Token)));

  CheckDataHash := THashSHA2.GetHMAC(EncodedData, SecretKey);

  if CheckDataHash <> EncodedDataHash then
    Result := 'Invalid token'
  else
    Result := CustomEncoder.Decode(EncodedData);
end;

end.
