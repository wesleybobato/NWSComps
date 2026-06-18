unit NWSComps_IOFormatStreamHandler;

interface


uses windows, sysutils, classes, contnrs;

type



TIOFormatStreamHandler = Class(TStream)
  private


  public

    procedure WriteBool(value: bool);
    procedure WriteByte(value: byte);
    procedure WriteInt(value: integer);
    procedure WriteInt64(value: int64);
    procedure WriteAnsiStr(value: AnsiString);
    procedure WriteAnsiStr_Direct(value: AnsiString);

    function TryReadBool(var value: boolean): boolean;
    function TryReadByte(var value: byte): boolean;
    function TryReadInt(var value: integer): boolean;
    function TryReadInt64(var value: int64): boolean;
    function TryReadAnsiStr(var value: AnsiString): boolean;
    function TryReadAnsiStr_Direct(var value: AnsiString;
                                   nChars: integer;
                                   const expectedValue: string): boolean;

    procedure WriteTag_Identifier(aTag: AnsiString);
    function TryReadTag_Identifier(const theTag: AnsiString): boolean;

    function FindTag_Identifier(aTag: AnsiString; const FromPos, ToPos: integer; const bgoto: boolean): boolean;


  Constructor Create; reintroduce;
  Destructor Destroy; override;


end;


TIOFormatFileStreamHandler = Class(TFileStream)
  private
   fStreamHandler: TIOFormatStreamHandler;

  public
    property StreamHandler: TIOFormatStreamHandler read fStreamHandler write fStreamHandler;

  constructor Create(const FileName: string; Mode: Word); reintroduce;
  destructor Destroy; override;
end;

implementation
uses
IOFormat_Const;



constructor TIOFormatFileStreamHandler.Create(const FileName: string; Mode: Word);
begin
  inherited;

  fStreamHandler := TIOFormatStreamHandler(self);
end;

destructor TIOFormatFileStreamHandler.Destroy;
begin

  inherited;
end;



Constructor TIOFormatStreamHandler.Create;
begin
  inherited Create;


end;


Destructor TIOFormatStreamHandler.Destroy;
begin

  inherited;
end;


procedure TIOFormatStreamHandler.WriteBool( value: bool);

var
 aboolbyte: byte;
begin
  case value of
    false: aboolbyte := 0
    else
      aboolbyte := 1;
  end;
  self.Write(aboolbyte, sizeof(byte));
end;


procedure TIOFormatStreamHandler.WriteByte( value: byte);
begin
  self.Write(value, sizeof(value));
end;

procedure TIOFormatStreamHandler.WriteInt( value: integer);
begin
  self.Write(value, sizeof(value));
end;

procedure TIOFormatStreamHandler.WriteInt64( value: int64);
begin
  self.Write(value, sizeof(value));
end;


procedure TIOFormatStreamHandler.WriteAnsiStr_Direct( value: Ansistring);
var
  i: integer;
  aChar: byte;
begin
  for i := 1 to length(value) do
  begin
    aChar := byte(Ansichar(value[i]));
    self.Write(aChar, sizeof(aChar));
  end;
end;

procedure TIOFormatStreamHandler.WriteAnsiStr( value: Ansistring);
begin
  WriteAnsiStr_Direct(IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_START);
  WriteInt64(length(value));
  WriteAnsiStr_Direct(IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_END);
  WriteAnsiStr_Direct(value);
end;

function TIOFormatStreamHandler.TryReadBool( var value: boolean): boolean;
var
 aboolbyte: byte;
 pos: int64;
begin
  pos := self.Position;
  result := (self.Read(aboolbyte, 1) = 1);
  case aboolbyte of
    0: value := false
    else
      value := True;
  end;

  if not result then
    self.Position := pos;

end;

function TIOFormatStreamHandler.TryReadByte( var value: byte): boolean;
var
 pos: int64;
begin
  pos := self.Position;
  result := (self.Read(value, 1) = 1);

  if not result then
    self.Position := pos;
end;

function TIOFormatStreamHandler.TryReadInt( var value: integer): boolean;
var
 pos: int64;
begin
  pos := self.Position;
  result := (self.Read(value, sizeof(integer)) = sizeof(integer));

  if not result then
    self.Position := pos;
end;

function TIOFormatStreamHandler.TryReadInt64( var value: int64): boolean;
var
 pos: int64;
begin
  pos := self.Position;
  result := (self.Read(value, sizeof(int64)) = sizeof(int64));

  if not result then
    self.Position := pos;
end;

function TIOFormatStreamHandler.TryReadAnsiStr_Direct(
                                                var value: AnsiString;
                                                nChars: integer;
                                                const expectedValue: string): boolean;
var
  i: integer;
  buffer: byte;
  pos: int64;
begin
  pos := self.Position;
  result := false;
  value := '';
  try
    for i := 1 to nChars do
    begin
      self.read(buffer, sizeof(byte));
      value := value + Ansichar(buffer);
    end;
    result := (expectedValue='') or (expectedValue = value);
  finally

  
  if not result then
    self.Position := pos;
  end;
end;

function TIOFormatStreamHandler.TryReadAnsiStr( var value: AnsiString): boolean;
var
 aTag: ansistring;
 nChars: int64;
begin

  result := TryReadAnsiStr_Direct(aTag,
                                  length(IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_START),
                                  IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_START);
  if not result then
   EXIT;

  result := TryReadInt64(nChars);
  if not result then
   EXIT;

  result := TryReadAnsiStr_Direct(aTag,
                                  length(IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_END),
                                  IOFORMAT_CONST_TAG_ANSISTRING_NCHARS_END);
  if not result then
   EXIT;

  result := TryReadAnsiStr_Direct(value, nChars,'');

end;



procedure TIOFormatStreamHandler.WriteTag_Identifier(aTag: AnsiString);
begin
  WriteAnsiStr_Direct(aTag);
end;

function TIOFormatStreamHandler.TryReadTag_Identifier(const theTag: AnsiString): boolean;
var
readTag: ansistring;
pos: int64;
begin
  pos := self.Position;
  readTag := '';
  result := TryReadAnsiStr_Direct(readTag, length(theTag), theTag);
  
  if not result then
    self.Position := pos;  //take back the position
end;




function TIOFormatStreamHandler.FindTag_Identifier(aTag: AnsiString;  const FromPos, ToPos: integer; const bgoto: boolean): boolean;
var
  or_pos, pos: int64;
  bFound: boolean;
  sFound: ansistring;
begin
  result := False;
  or_pos := self.Position;


  bFound := False;
  pos := FromPos;
  while (not bFound) and (self.position< ToPos) do
  begin
    if not TryReadAnsiStr_Direct(sFound, length(aTag), aTag) then
      self.Position := self.position + 1
    else
      bFound := True;
  end;

  result := bFound;
  if not bgoto then
    self.position := or_pos;
end;

end.
