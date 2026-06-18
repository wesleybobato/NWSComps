unit NWSComps_IOFormat;

interface

uses windows, sysutils, classes, contnrs, NWSComps_IOFormatStreamHandler;

     (*
     //Class Signatures and Versions
     //Format Name Signature and Version
     //Header
     //After Header

     *)


type



  TIOFormatHandler = class(TComponent)

  private

    fClassVersionMajor: integer;
    fClassVersionMinor: integer;
    fClassSignature: string;
    fsignature: string;
    fmajorversion: integer;
    fminorversion: integer;




  protected
    procedure AppendStreamToStream(SourceStream, DestStream: Tstream);
    procedure ReadStreamFromStream(SourceStream, DestStream: Tstream; ReadSize: integer);

    procedure WriteClassVersion(st: TIOFormatStreamHandler); virtual;
    procedure WriteClassSignature(st: TIOFormatStreamHandler); virtual;
    procedure WriteClassSignatureAndVersion(st: TIOFormatStreamHandler); virtual;

    procedure DefineClassSignature; virtual;
    procedure DefineSignature(signature: string; majVersion: integer; minVersion: integer); virtual;

    function CheckClassVersion(st: TIOFormatStreamHandler): boolean; virtual;
    function CheckClassSignature(st: TIOFormatStreamHandler): boolean; virtual; //it can be overriden by descendent
                                                                  //classes for retro-compatibility

    procedure WriteSignature(st: TIOFormatStreamHandler);
    procedure WriteVersion(st: TIOFormatStreamHandler);
    function CheckSignature_Given(st: TIOFormatStreamHandler; theSignature: string): boolean; virtual;
    function CheckSignature(st: TIOFormatStreamHandler): boolean; virtual; //it can be overriden by descendent
                                                                  //classes for retro-compatibility

    function CheckVersion(st: TIOFormatStreamHandler): boolean; virtual; //it can be overriden by descendent
 
    procedure InitWrite; virtual;
    procedure InitRead; virtual;

    procedure WriteHeader(st: TIOFormatStreamHandler);
    procedure WriteHeader_Body(st: TIOFormatStreamHandler); virtual;abstract;

    procedure ReadHeader(st: TIOFormatStreamHandler);
    procedure ReadHeader_StartTag(st: TIOFormatStreamHandler); virtual;
    procedure ReadHeader_Body(st: TIOFormatStreamHandler); virtual; abstract;
    procedure ReadHeader_EndTag(st: TIOFormatStreamHandler); virtual;

    procedure WriteCustom_AfterHeader(st: TIOFormatStreamHandler); virtual; abstract;
    procedure ReadCustom_AfterHeader(st: TIOFormatStreamHandler); virtual; abstract;

    property ClassVersionMajor: integer read fClassVersionMajor write fClassVersionMajor;
    property ClassVersionMinor: integer read fClassVersionMinor write fClassVersionMinor;
    property ClassSignature: string read fClassSignature write fClassSignature;
   { }
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; signature: string; majversion: integer; minversion: integer); reintroduce;  overload;
    destructor Destroy; override;


    procedure WritetoFile(thefilename: string);  virtual;
    function ReadFromFile(thefilename: string): boolean;  virtual;

    
    property Signature: string read fsignature;
    property MajorVersion: integer read fmajorversion write fmajorversion;
    property MinorVersion: integer read fminorversion write fminorversion;

  end;

implementation
uses dialogs, IOFormat_Const ;


constructor TIOFormatHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);


  DefineClassSignature;  //First define a class signature
end;


constructor TIOFormatHandler.Create(AOwner: TComponent; signature: string; majversion: integer; minversion: integer);
begin
  Create(AOwner);
  DefineSignature(signature, majversion, minversion);
end;

destructor TIOFormatHandler.Destroy;
begin

  inherited;
end;


procedure TIOFormatHandler.AppendStreamToStream(SourceStream, DestStream: Tstream);
begin
  DestStream.CopyFrom(SourceStream, 0);
end;

procedure TIOFormatHandler.ReadStreamFromStream(SourceStream, DestStream: Tstream; ReadSize: integer);
begin

end;


procedure TIOFormatHandler.DefineClassSignature;
begin
  fClassSignature := IOFORMAT_CONST_CLASSSIGNATURE;
  fClassVersionMajor := IOFORMAT_CONST_CLASSVERSION_MAJOR;
  fClassVersionMinor := IOFORMAT_CONST_CLASSVERSION_MINOR;
end;

procedure TIOFormatHandler.DefineSignature(signature: string;  majVersion: integer; minVersion: integer);
begin

  fsignature := signature;
  fmajorversion := majVersion;
  fminorversion := minVersion;
end;


procedure TIOFormatHandler.WriteClassVersion(st: TIOFormatStreamHandler);
begin
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_START);
  st.writeint( IOFORMAT_CONST_CLASSVERSION_MAJOR);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_END);

  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_START);
  st.writeint( IOFORMAT_CONST_CLASSVERSION_MINOR);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_END);
end;

procedure TIOFormatHandler.WriteClassSignature(st: TIOFormatStreamHandler);
begin
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSSIGNATURE_START);
  st.WriteAnsiStr_Direct( IOFORMAT_CONST_CLASSSIGNATURE);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);
end;

procedure TIOFormatHandler.WriteClassSignatureAndVersion(st: TIOFormatStreamHandler);
begin
  WriteClassSignature(st);
  WriteClassVersion(st);
end;


procedure TIOFormatHandler.WriteSignature(st: TIOFormatStreamHandler);
begin
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_SIGNATURE_START);
  st.WriteAnsiStr_Direct( fSignature);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_SIGNATURE_END);
end;

procedure TIOFormatHandler.WriteVersion(st: TIOFormatStreamHandler);
begin
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_VERSIONMAJOR_START);
  st.writeint( fmajorversion);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_VERSIONMAJOR_END);
  
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_VERSIONMINOR_START);
  st.writeint( fminorversion);
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_VERSIONMINOR_END);
end;

procedure TIOFormatHandler.InitWrite;
begin

end;

procedure TIOFormatHandler.InitRead;
begin

end;



procedure TIOFormatHandler.WriteHeader(st: TIOFormatStreamHandler);
begin
  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_HEADER_START);

    //-----------Body--------------
   WriteHeader_body(st);
  //-----------Body--------------

  st.WriteTag_Identifier( IOFORMAT_CONST_TAG_HEADER_END);

end;


procedure TIOFormatHandler.ReadHeader(st: TIOFormatStreamHandler);
var
  aTag: AnsiString;
begin
  ReadHeader_StartTag(st);

  //-----------Body--------------
   ReadHeader_body(st);          //implemented in descendant classes
  //-----------Body--------------

  ReadHeader_EndTag(st);
end;

 procedure TIOFormatHandler.ReadHeader_StartTag(st: TIOFormatStreamHandler);
 begin
   st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_HEADER_START);
 end;

 procedure TIOFormatHandler.ReadHeader_EndTag(st: TIOFormatStreamHandler);
 begin
   st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_HEADER_END);
 end;

function TIOFormatHandler.CheckClassVersion(st: TIOFormatStreamHandler): boolean;
var
  buffermaj: integer;
  buffermin: integer;
  readCount: integer;
begin
  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_START)
              and
              st.TryReadInt(buffermaj)
              and
              st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_END);


  //-------------------------------------------------------------------

      result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_START)
              and
              st.TryReadInt(buffermin)
              and
              st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_END);



    fClassVersionMajor := buffermaj;
    fClassVersionMinor := buffermin;
end;



function TIOFormatHandler.CheckClassSignature(st: TIOFormatStreamHandler): boolean;
var
  buffer: Ansistring;
begin
  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_START);
  if not result then EXIT;

  result := st.TryReadAnsiStr_Direct(buffer, length(fClassSignature), fClassSignature);
  if not result then EXIT;

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);
  if not result then EXIT;
 
end;

function TIOFormatHandler.CheckSignature_Given(st: TIOFormatStreamHandler; theSignature: string): boolean;
var
  buffer: Ansistring;
begin
  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_SIGNATURE_START);
  if not result then EXIT;

  result := st.TryReadAnsiStr_Direct(buffer, length(theSignature), theSignature) ;
  if not result then EXIT;

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_SIGNATURE_END);
  if not result then EXIT;

end;

function TIOFormatHandler.CheckSignature(st: TIOFormatStreamHandler): boolean;
var
  buffer: Ansistring;
begin
  result := CheckSignature_Given(st, fSignature);
end;

function TIOFormatHandler.CheckVersion(st: TIOFormatStreamHandler): boolean;
var
  buffermaj: integer;
  buffermin: integer;
  readCount: integer;
begin
   result := True;

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_VERSIONMAJOR_START);
  if not result then EXIT; 

  readCount := st.Read(buffermaj, sizeof(fmajorversion));
  result := readCount = sizeof(fmajorversion);
  if not result then EXIT;

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_VERSIONMAJOR_END);
  if not result then EXIT;
  //-------------------------------------------------------------------

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_VERSIONMINOR_START);
  if not result then EXIT;

  readCount := st.Read(buffermin, sizeof(fminorversion));
  result := result and (readcount = sizeof(fminorversion));
  if not result then EXIT;

  result := st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_VERSIONMINOR_END);
  if not result then EXIT;

  fmajorversion := buffermaj;
  fminorversion := buffermin;
end;


procedure TIOFormatHandler.WritetoFile(thefilename: string);
var
  StreamHandler: TIOFormatFileStreamHandler;
  fs: TIOFormatStreamHandler;
//  Fs: TFilestream;
  bCanGo: Boolean;
begin
  InitWrite;

//  FS := TFilestream.Create(thefilename, fmcreate);
  StreamHandler := TIOFormatFileStreamHandler.Create(thefilename, fmcreate);
  fs := StreamHandler.StreamHandler;
  try
    WriteClassSignature(fs);
    WriteClassVersion(fs);

    WriteSignature(fs);
    WriteVersion(fs);

    WriteHeader(fs);
    WriteCustom_AfterHeader(fs);



  finally
    StreamHandler.free;
 //   FS.free;
  end;
end;


function TIOFormatHandler.ReadFromFile(thefilename: string): boolean;
var
  StreamHandler: TIOFormatFileStreamHandler;
//  Fs: TFilestream;
  fs : TIOFormatStreamHandler;
  bCanGo: Boolean;
begin
  result := False;
  InitRead;

//  FS := TFilestream.Create(thefilename, fmOpenRead);
  StreamHandler := TIOFormatFileStreamHandler.Create(thefilename, fmOpenRead);
  fs := StreamHandler.StreamHandler;
  try
    if not CheckClassSignature(fs) then
      exit;    //can't go on if class signature does not match

    CheckClassVersion(fs);


    if not CheckSignature(fs) then
      exit;  //can't go on if file signature does not match (we would be reading soemthign different from expected)

    CheckVersion(fs);

    ReadHeader(fs);
    ReadCustom_AfterHeader(fs);


    result := True;
  finally
    StreamHandler.free;
 //   FS.free;
  end;

end;

end.
