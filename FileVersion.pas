unit FileVersion;

interface
type
  TFileVersionInfo = class
  private
    FInfo: array of Char;
    FInfoSize: Cardinal;
    FFilename, FKey,

    FCompanyName,
      FDescription,
      FVersion,
      FInternalName,
      FLegalCopyright,
      FLegalTrademarks,
      FOriginalFilename,
      FProductName,
      FProductVersion,
      FComments: string;

    function GetFilename: string;
    function GetVersion: string;
    function GetFileVersionString(const KeyName: string): string;
    function GetDescription: string;
    function GetNLSKey: string;
    function GetInternalName: string;
    function GetLegalCopyright: string;
    function GetLegalTrademarks: string;
    function GetCompanyName: string;
    function GetComments: string;
    function GetOriginalFilename: string;
    function GetProductName: string;
    function GetProductVersion: string;
    function GetValue(const KeyName: string): string;
  protected
    property Key: string read GetNLSKey;
  public
    constructor Create(const Filename: string);
    property Filename: string read GetFilename;
    property CompanyName: string read GetCompanyName;
    property Description: string read GetDescription;
    property Version: string read GetVersion;
    property InternalName: string read GetInternalName;
    property LegalCopyright: string read GetLegalCopyright;
    property LegalTrademarks: string read GetLegalTrademarks;
    property OriginalFilename: string read GetOriginalFilename;
    property ProductName: string read GetProductName;
    property ProductVersion: string read GetProductVersion;
    property Comments: string read GetComments;
    property Values[const KeyName: string]: string read GetValue; default;
  end;

implementation
  uses Windows, SysUtils;

{ TFilenameVersion }

constructor TFileVersionInfo.Create(const Filename: string);
begin
  inherited Create;
  FFileName := Filename;
end;

function TFileVersionInfo.GetComments: string;
begin
  if FComments = '' then
    FComments := Values['Comments'];
  Result := FComments;
end;

function TFileVersionInfo.GetCompanyName: string;
begin
  if FCompanyName = '' then
    FCompanyName := Values['CompanyName'];
  Result := FCompanyName;
end;

function TFileVersionInfo.GetDescription: string;
begin
  if FDescription = '' then
    FDescription := Values['FileDescription'];
  Result := FDescription;
end;

function TFileVersionInfo.GetFilename: string;
begin
  Result := FFilename;
end;

function TFileVersionInfo.GetFileVersionString(
  const KeyName: string): string;
var
  Temp: Cardinal;
  Buffer: PChar;
begin
  if FInfoSize = 0 then
    begin
      FInfoSize := GetFileVersionInfoSize(PChar(Filename), Temp);
      SetLength(FInfo, FInfoSize);
      GetFileVersionInfo(PChar(Filename), 0, FInfoSize, FInfo);
    end;
  if FInfoSize > 0 then
    begin
      if VerQueryValue(FInfo, PChar(Format('%s\%s', [Key, KeyName])),
        Pointer(Buffer), FInfoSize) then
        Result := Buffer;
    end;
end;

function TFileVersionInfo.GetInternalName: string;
begin
  if FInternalName = '' then
    FInternalName := Values['InternalName'];
  Result := FInternalName;
end;

function TFileVersionInfo.GetValue(const KeyName: string): string;
begin
  Result := GetFileVersionString(KeyName);
end;

function TFileVersionInfo.GetLegalCopyright: string;
begin
  if FLegalCopyright = '' then
    FLegalCopyright := Values['LegalCopyright'];
  Result := FLegalCopyright;
end;

function TFileVersionInfo.GetLegalTrademarks: string;
begin
  if FLegalTrademarks = '' then
    FLegalTrademarks := Values['LegalTrademarks'];
  Result := FLegalTrademarks;
end;

function TFileVersionInfo.GetNLSKey: string;
var
  P: Pointer;
  Len: Cardinal;
begin
  if FKey = '' then
    begin
      VerQueryValue(FInfo, '\VarFileInfo\Translation', P, Len);
      if Assigned(P) then
        FKey := Format('\StringFileInfo\%4.4x%4.4x', [LoWord(Longint(P^)), HiWord(Longint(P^))]);
    end;
  Result := FKey;
end;

function TFileVersionInfo.GetOriginalFilename: string;
begin
  if FOriginalFilename = '' then
    FOriginalFilename := Values['OriginalFilename'];
  Result := FOriginalFilename;
end;

function TFileVersionInfo.GetProductName: string;
begin
  if FProductName = '' then
    FProductName := Values['ProductName'];
  Result := FProductName;
end;

function TFileVersionInfo.GetProductVersion: string;
begin
  if FProductVersion = '' then
    FProductVersion := Values['ProductVersion'];
  Result := FProductVersion;
end;

function TFileVersionInfo.GetVersion: string;
begin
  if FVersion = '' then
    FVersion := Values['FileVersion'];
  Result := FVersion;
end;

end.
