unit NWSComps_MultiPicsFormat;

interface

uses windows, sysutils, graphics, classes, contnrs, NWSComps_IOFormat,
  NWSComps_IOFormatStreamHandler;

type

  TPicBlock = class(Tcomponent)
  private

  public

    Version_Number: integer;
    Name: String;
    Category: string;

    bmpstream: Tmemorystream;
    bmpinfostream: Tmemorystream;

    constructor Create(AOwner: Tcomponent); override;
    destructor Destroy; override;

    procedure AssignBlock(srcblock: TPicBlock);

    procedure WriteToStream(St: TStream; const FromPos: longint);
    procedure ReadFromStream(St: TStream);

  end;


  TMultiPicsFormatHandler = class(TIOFormatHandler)

  private
    fClassVersionMajor: integer;
    fClassVersionMinor: integer;
    fClassSignature: string;

    fFileThumb: TPicBlock;
    fPicList: TObjectList;

   
    function GetPicCount: integer;

    function ReadPicCount(St: TIOFormatStreamHandler): integer;
    procedure WritePicCount(St: TIOFormatStreamHandler);

    function ReadInfoBlockSize(St: TIOFormatStreamHandler): integer;
    procedure WriteInfoBlockSize(St: TIOFormatStreamHandler);

    procedure ReadPicBlock(St: TIOFormatStreamHandler; pb: TPicBlock);
    procedure WritePicBlock(St: TIOFormatStreamHandler; idx: integer;
      var st_pos: longint);

  protected
    fReadFileThumbOnly: boolean;

    procedure WritePics(St: TIOFormatStreamHandler); virtual;
    procedure ReadPics(St: TIOFormatStreamHandler); virtual;
    procedure WriteFileThumb(St: TIOFormatStreamHandler); virtual;
    procedure ReadFileThumb(St: TIOFormatStreamHandler); virtual;

    procedure DefineClassSignature; override;
    // Every descendent has its own Class Signature
    procedure WriteClassSignature(St: TIOFormatStreamHandler); override;
    // when writing class Signature it must follow
    // the writing of ancestor class Signature
    procedure WriteClassVersion(St: TIOFormatStreamHandler); override;
    // when writing class version it must follow
    // the writing of ancestor class version

    function CheckClassVersion(St: TIOFormatStreamHandler): boolean; override;
    // when reading class version it must follow
    // the reading of ancestor class version
    function CheckClassSignature(St: TIOFormatStreamHandler): boolean; override;
    // when reading class signature it must follow
    // the reading of ancestor class signature

    function CheckSignature(St: TIOFormatStreamHandler): boolean; override;
    function CheckVersion(St: TIOFormatStreamHandler): boolean; override;

    procedure InitWrite; override;
    procedure InitRead; override;
    procedure WriteHeader_body(St: TIOFormatStreamHandler); override;

    procedure ReadHeader_body(St: TIOFormatStreamHandler); override;
    procedure ReadHeader_StartTag(St: TIOFormatStreamHandler); override;
    procedure ReadHeader_EndTag(St: TIOFormatStreamHandler); override;

    procedure WriteCustom_AfterHeader(St: TIOFormatStreamHandler); override;
    procedure ReadCustom_AfterHeader(St: TIOFormatStreamHandler); override;
    procedure ReadCustom_AfterHeader_FileThumb(St: TIOFormatStreamHandler);virtual;
  public
   

    property PicCount: integer read GetPicCount;
    property FileThumb: TPicBlock read fFileThumb write fFileThumb;

    constructor Create(AOwner: Tcomponent; signature: string;
      majversion: integer; minversion: integer); reintroduce; overload;
    constructor Create; reintroduce; overload;
    destructor Destroy; override;

    procedure ClearPictures;
    function GetPicture(idx: integer): TPicBlock;
    procedure AddPicture(ThePicBlock: TPicBlock);

    procedure AssignFileThumb(BMP: Tbitmap);

    procedure WritetoFile(thefilename: string); override;
    function ReadFromFile(thefilename: string; bOnlyFileThumb: boolean): boolean; reintroduce;

  end;

implementation

uses NWSComps_IOFormat_Const, NWSComps_MultiPicFormat_Const;

constructor TPicBlock.Create(AOwner: Tcomponent);
begin
  inherited;
  Version_Number := 1; // version number 1

  bmpstream := Tmemorystream.Create;
  bmpinfostream := Tmemorystream.Create;

end;

destructor TPicBlock.Destroy;
begin
  bmpstream.free;
  bmpinfostream.free;

  inherited;
end;

procedure TPicBlock.AssignBlock(srcblock: TPicBlock);
begin
  Version_Number := srcblock.Version_Number;
  Name := srcblock.Name;
  Category := srcblock.Category;

  srcblock.bmpstream.seek(0, 0);
  srcblock.bmpinfostream.seek(0, 0);

  self.bmpstream.seek(0, 0);
  self.bmpinfostream.seek(0, 0);

  self.bmpstream.CopyFrom(srcblock.bmpstream, srcblock.bmpstream.size);
  self.bmpinfostream.CopyFrom(srcblock.bmpinfostream,
    srcblock.bmpinfostream.size);
end;

procedure TPicBlock.WriteToStream(St: TStream; const FromPos: longint);
var
  size: int64;
  pb: TPicBlock;
  SH_Info: TIOFormatStreamHandler;
begin
  St.position := FromPos;

  {
    //----Modify the Info Stream-----------------
    SH_Info := TIOFormatStreamHandler(ST);
    SH_Info.Seek(0,0);
    SH_Info.WriteInt(Version_Number);
    SH_Info.WriteAnsiStr(Name);
    SH_Info.WriteAnsiStr(Category);
    //----Modify the Info Stream-----------------
  }

  // --> Write INFO Stream Size (bytes)
  size := bmpinfostream.size;
  St.Write(size, sizeof(int64)); // add the data size (a Int64 Descriptor)

  // --> Write INFO Stream Data
  St.CopyFrom(bmpinfostream, 0); // copy info to the main stream

  // --> Write BMP Stream Size (bytes)
  size := bmpstream.size;
  St.Write(size, sizeof(int64));

  St.CopyFrom(bmpstream, 0); // copy bitmap
end;

procedure TPicBlock.ReadFromStream(St: TStream);
var
  size, copied: int64;
begin
  try

      // --> Read INFO Stream Size (bytes)
      St.Read(size, sizeof(int64));

      bmpinfostream.position := 0;
      if size > 0 then
        bmpinfostream.CopyFrom(St, size);

      // --> Read BMP Stream Size (bytes)
      St.Read(size, sizeof(int64));

      bmpstream.position := 0;
      if size > 0 then
        bmpstream.CopyFrom(St, size);


  except
    ;
  end;
end;

// ---------------------------------------------

constructor TMultiPicsFormatHandler.Create(AOwner: Tcomponent;
  signature: string; majversion: integer; minversion: integer);
begin
  inherited Create(AOwner, signature, majversion, minversion);

  fFileThumb := TPicBlock.Create(nil);
  fPicList := TObjectList.Create(true);
  // fPicInfoBlockSize := 0;

end;

constructor TMultiPicsFormatHandler.Create;
begin
  Create(nil, MULTIPICFORMAT_CONST_SIGNATURE_GENERAL,
    MULTIPICFORMAT_CONST_VERSION_MAJ, MULTIPICFORMAT_CONST_VERSION_MIN);

end;

destructor TMultiPicsFormatHandler.Destroy;
begin
  fFileThumb.free;
  fPicList.free;
  inherited;
end;

procedure TMultiPicsFormatHandler.AssignFileThumb(BMP: Tbitmap);
begin

end;

procedure TMultiPicsFormatHandler.WritetoFile(thefilename: string);
begin
  inherited;
end;

function TMultiPicsFormatHandler.ReadFromFile(thefilename: string; bOnlyFileThumb: boolean): boolean;
var
bInheritedResult: boolean;
begin
  fReadFileThumbOnly := bOnlyFileThumb;
  bInheritedResult := inherited ReadFromFile(thefilename);
  result := bInheritedResult;
end;



function TMultiPicsFormatHandler.GetPicCount: integer;
begin
  result := fPicList.Count;
end;

function TMultiPicsFormatHandler.ReadInfoBlockSize
  (St: TIOFormatStreamHandler): integer;
begin
  St.TryReadInt(result);
end;

procedure TMultiPicsFormatHandler.WriteInfoBlockSize
  (St: TIOFormatStreamHandler);
begin
  // writeint(st, fPicInfoBlockSize);
  St.writeint(0);
end;

procedure TMultiPicsFormatHandler.WritePicCount(St: TIOFormatStreamHandler);
begin
  St.writeint(fPicList.Count);
end;

function TMultiPicsFormatHandler.ReadPicCount
  (St: TIOFormatStreamHandler): integer;
begin
  St.TryReadInt(result);
end;

procedure TMultiPicsFormatHandler.WritePics(St: TIOFormatStreamHandler);
var
  i, st_pos: integer;
begin
  st_pos := St.position;
  for i := 0 to fPicList.Count - 1 do
  begin
    WritePicBlock(St, i, st_pos);
  end;
end;

procedure TMultiPicsFormatHandler.ReadPics(St: TIOFormatStreamHandler);
var
  i: integer;
begin
  for i := 0 to fPicList.Count - 1 do
  begin
    ReadPicBlock(St, TPicBlock(fPicList[i]));
  end;

end;

procedure TMultiPicsFormatHandler.WriteFileThumb(St: TIOFormatStreamHandler);
var
  pos: integer;
begin
  pos := St.position;
  WritePicBlock(St, -1, pos);
end;

procedure TMultiPicsFormatHandler.ReadFileThumb(St: TIOFormatStreamHandler);
begin
  ReadPicBlock(St, fFileThumb);
end;

procedure TMultiPicsFormatHandler.WritePicBlock(St: TIOFormatStreamHandler;
  idx: integer; var st_pos: longint);
var
  size: int64;
  atempstream: Tmemorystream;
  pb: TPicBlock;
begin

  if (idx < -1) or (idx > fPicList.Count - 1) then
    exit;

  if idx = -1 then
    pb := fFileThumb
  else
    pb := TPicBlock(fPicList[idx]);

  St.position := st_pos;
  pb.WriteToStream(St, st_pos);
  st_pos := St.position;
end;

procedure TMultiPicsFormatHandler.ReadPicBlock(St: TIOFormatStreamHandler;
  pb: TPicBlock);
var
  size, copied: int64;
begin
  if not assigned(pb) then
    exit;
  pb.ReadFromStream(St);
end;

procedure TMultiPicsFormatHandler.ClearPictures;
begin
  fPicList.Clear;
end;

function TMultiPicsFormatHandler.GetPicture(idx: integer): TPicBlock;
begin
  if (idx >= 0) and (idx < fPicList.Count) then
  begin
    result := TPicBlock(fPicList[idx]);

  end
  else
    result := nil;

end;

procedure TMultiPicsFormatHandler.AddPicture(ThePicBlock: TPicBlock);
var
  apicblock: TPicBlock;
begin
  apicblock := TPicBlock.Create(nil);
  apicblock.AssignBlock(ThePicBlock);
  fPicList.Add(apicblock);
end;

procedure TMultiPicsFormatHandler.DefineClassSignature;
begin
  inherited; // first define the class signatures of all ancestors

  fClassSignature := MULTIPICFORMAT_CONST_CLASSSIGNATURE;
  fClassVersionMajor := MULTIPICFORMAT_CONST_CLASSVERSION_MAJOR;
  fClassVersionMinor := MULTIPICFORMAT_CONST_CLASSVERSION_MINOR;
end;

procedure TMultiPicsFormatHandler.WriteClassSignature
  (St: TIOFormatStreamHandler);
begin
  inherited; // writes ancestor class signatures

  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_START);
  St.WriteAnsiStr_Direct(MULTIPICFORMAT_CONST_CLASSSIGNATURE);
  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);

end;

procedure TMultiPicsFormatHandler.WriteClassVersion(St: TIOFormatStreamHandler);
begin
  inherited; // writes ancestor class versions

  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_START);
  St.writeint(MULTIPICFORMAT_CONST_CLASSVERSION_MAJOR);
  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_END);

  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_START);
  St.writeint(MULTIPICFORMAT_CONST_CLASSVERSION_MINOR);
  St.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_END);

end;

function TMultiPicsFormatHandler.CheckClassVersion
  (St: TIOFormatStreamHandler): boolean;
var
  buffermaj: integer;
  buffermin: integer;
  readCount: integer;
  iVMaj, iVMin: integer;
begin
  result := inherited CheckClassVersion(St);


    result := St.TryReadTag_Identifier
      (IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_START) and St.TryReadInt(buffermaj)
      and St.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_END);


    // -------------------------------------------------------------------

    result := St.TryReadTag_Identifier
      (IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_START) and St.TryReadInt(buffermin)
      and St.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_END);

    fClassVersionMajor := buffermaj;
    fClassVersionMinor := buffermin;


end;

function TMultiPicsFormatHandler.CheckClassSignature
  (St: TIOFormatStreamHandler): boolean;
var
  buffer: ansistring;
  iVMaj, iVMin: integer;

  function CheckOldClassSignature(St: TIOFormatStreamHandler): boolean;
  begin
    result := St.TryReadAnsiStr_Direct(buffer, length(fClassSignature),
      fClassSignature);
  end;

begin
  result := inherited CheckClassSignature(St);


  result := St.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_START)
    and St.TryReadAnsiStr_Direct(buffer, length(fClassSignature),
    fClassSignature) and St.TryReadTag_Identifier
    (IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);

end;

function TMultiPicsFormatHandler.CheckSignature
  (St: TIOFormatStreamHandler): boolean;
var
  buffer: ansistring;
  aSign: string;
begin
  result := inherited CheckSignature(St);
  if not result then
  begin
    aSign := signature;
    result := St.TryReadAnsiStr_Direct(buffer, length(aSign), aSign);
  end;
end;

function TMultiPicsFormatHandler.CheckVersion
  (St: TIOFormatStreamHandler): boolean;
var
  buffermaj: integer;
  buffermin: integer;
  readCount: integer;
  iVMaj, iVMin: integer;
begin
     result := inherited CheckVersion(St)

end;

procedure TMultiPicsFormatHandler.InitWrite;
begin

end;

procedure TMultiPicsFormatHandler.InitRead;
begin

end;

procedure TMultiPicsFormatHandler.WriteHeader_body(St: TIOFormatStreamHandler);
begin

    // -----------Pictures Count Only--------------
    St.writeint(fPicList.Count);
    // -----------Pictures Count--------------

end;

procedure TMultiPicsFormatHandler.ReadHeader_body(St: TIOFormatStreamHandler);
var
  pc, i: integer;
  apicblock: TPicBlock;
  aTag: ansistring;
begin


    // -----------Pictures are prepared only--------------
    pc := ReadPicCount(St);

    fPicList.Clear;
    for i := 0 to pc - 1 do
    begin
      apicblock := TPicBlock.Create(nil);
      fPicList.Add(apicblock);
    end;
    // ------------------------------------------------------

end;

procedure TMultiPicsFormatHandler.ReadHeader_StartTag
  (St: TIOFormatStreamHandler);
begin
    inherited;
end;

procedure TMultiPicsFormatHandler.ReadHeader_EndTag(St: TIOFormatStreamHandler);
begin
    inherited;
end;

procedure TMultiPicsFormatHandler.WriteCustom_AfterHeader
  (St: TIOFormatStreamHandler);
begin
 
  WriteFileThumb(St);
  WritePics(St);
end;

procedure TMultiPicsFormatHandler.ReadCustom_AfterHeader
  (St: TIOFormatStreamHandler);
begin
  
  if fReadFileThumbOnly then
    ReadCustom_AfterHeader_FileThumb(St)
  else
  begin
    ReadCustom_AfterHeader_FileThumb(St);
    ReadPics(St);
  end;
end;

procedure TMultiPicsFormatHandler.ReadCustom_AfterHeader_FileThumb(St: TIOFormatStreamHandler);
begin
  ReadFileThumb(St);
end;

end.
