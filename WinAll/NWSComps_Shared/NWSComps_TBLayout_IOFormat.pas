unit NWSComps_TBLayout_IOFormat;

interface

uses windows, sysutils, graphics, classes, contnrs, NWSComps_MultiPicsFormat, NWSComps_IOFormatStreamHandler;

type

//IMPORTANT TO UNDERSTAND!!
//  1) Every Ancestor Class writes its own CLASS SIGNATURE
//      In addition to the Class Signature of the current class

// 2) the file signature is written only once (in the base ancestor).
//    It identifies the kind of file the class is describing.
//    The file signature may be assigned externally in the creator
//    or if it is supposed to be unique for the class it is assigned inside the class itself 



  TB_Layout_IOFormatHandler = class(TMultiPicsFormatHandler)
    private
        fClassVersionMajor: integer;
        fClassVersionMinor: integer;
        fClassSignature: string;

    protected
        procedure DefineClassSignature; override;  //Every descendent has its own Class Signature

        procedure WriteClassSignature(st: TIOFormatStreamHandler); override; //when writing class Signature it must follow
                                                          // the writing of ancestor class Signature
        procedure WriteClassVersion(st: TIOFormatStreamHandler); override; //when writing class version it must follow
                                                          // the writing of ancestor class version

        function CheckClassSignature(st: TIOFormatStreamHandler): boolean; override;
        function CheckClassVersion(st: TIOFormatStreamHandler): boolean; override;

        function CheckSignature_Given(st: TIOFormatStreamHandler; theSignature: string): boolean;override;
        function CheckSignature(st: TIOFormatStreamHandler): boolean;  override;

        procedure InitWrite; override;
        procedure InitRead; override;
        procedure WriteHeader_body(st: TIOFormatStreamHandler); override;
        procedure ReadHeader_body(st: TIOFormatStreamHandler); override;
        procedure WriteCustom_AfterHeader(st: TIOFormatStreamHandler); override;
        procedure ReadCustom_AfterHeader(st: TIOFormatStreamHandler); override;
    public
       constructor Create(AOwner: TComponent; signature: string;
                           majorversion: integer; minorversion: integer); reintroduce; overload;
       constructor Create; reintroduce; overload;
       destructor Destroy; override;
  end;



implementation
 uses NWSComps_IOFormat_Const, NWSComps_MultiPicFormat_Const, NWSComps_TBLayout_IOFormat_Const;

constructor TB_Layout_IOFormatHandler.Create(AOwner: TComponent; signature: string; majorversion: integer; minorversion: integer);
begin
  inherited Create(AOwner, signature, majorversion, minorversion);

end;

constructor TB_Layout_IOFormatHandler.Create;
begin
  Create(nil,  TB_LAYOUT_CONST_SIGNATURE_GENERAL,
               TB_LAYOUT_CONST_VERSION_MAJ,
               TB_LAYOUT_CONST_VERSION_MIN);



end;

destructor TB_Layout_IOFormatHandler.Destroy;
begin
   inherited;
end;


procedure TB_Layout_IOFormatHandler.DefineClassSignature;
begin
  inherited;  //first define the class signatures of all ancestors

  fClassSignature := TB_LAYOUT_CONST_CLASSSIGNATURE;
  fClassVersionMajor := TB_LAYOUT_CONST_CLASSVERSION_MAJOR;
  fClassVersionMinor := TB_LAYOUT_CONST_CLASSVERSION_MINOR;
end;


procedure TB_Layout_IOFormatHandler.WriteClassSignature(st: TIOFormatStreamHandler);
begin
  inherited; //writes ancestor class signatures

  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_START);
  st.WriteAnsiStr_Direct(TB_LAYOUT_CONST_CLASSSIGNATURE);
  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);

end;

procedure TB_Layout_IOFormatHandler.WriteClassVersion(st: TIOFormatStreamHandler);
begin
  inherited; //writes ancestor class versions

  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_START);
  st.writeint(TB_LAYOUT_CONST_CLASSVERSION_MAJOR);
  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMAJOR_END);

  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_START);
  st.writeint(TB_LAYOUT_CONST_CLASSVERSION_MINOR);
  st.WriteTag_Identifier(IOFORMAT_CONST_TAG_CLASSVERSIONMINOR_END);

end;

function TB_Layout_IOFormatHandler.CheckClassSignature(st: TIOFormatStreamHandler): boolean;
var
buffer: ansistring;
begin

    result := inherited CheckClassSignature(st);


    result := result and
              st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_START) and
              st.TryReadAnsiStr_Direct(buffer, length(fClassSignature), fClassSignature) and
              st.TryReadTag_Identifier(IOFORMAT_CONST_TAG_CLASSSIGNATURE_END);

end;


function TB_Layout_IOFormatHandler.CheckClassVersion(st: TIOFormatStreamHandler): boolean;
var
  buffermaj: integer;
  buffermin: integer;
  readCount: integer;
  iVMaj, iVMin: integer;
begin
  result := inherited CheckClassVersion(st);

  if result then
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

end;



function TB_Layout_IOFormatHandler.CheckSignature_Given(st: TIOFormatStreamHandler; theSignature: string): boolean;
begin
   result := inherited CheckSignature_Given(st, theSignature);
end;

function TB_Layout_IOFormatHandler.CheckSignature(st: TIOFormatStreamHandler): boolean;
begin
  result := inherited CheckSignature(st);
end;


procedure TB_Layout_IOFormatHandler.InitWrite;
begin
   inherited;
end;

procedure TB_Layout_IOFormatHandler.InitRead;
begin
  inherited;
end;

procedure TB_Layout_IOFormatHandler.WriteHeader_body(st: TIOFormatStreamHandler);
begin
  inherited;
end;

procedure TB_Layout_IOFormatHandler.ReadHeader_body(st: TIOFormatStreamHandler);
begin
  inherited;
end;

procedure TB_Layout_IOFormatHandler.WriteCustom_AfterHeader(st: TIOFormatStreamHandler);
begin
  inherited;
end;

procedure TB_Layout_IOFormatHandler.ReadCustom_AfterHeader(st: TIOFormatStreamHandler);
begin
  inherited;
end;

end.
