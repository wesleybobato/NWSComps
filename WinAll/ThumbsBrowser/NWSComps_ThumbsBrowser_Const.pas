 (*
Part of NWSComps Bundle
v. 3
Copyright (C) Francesco Savastano. All Rights Reserved.

This software comes without any warranty either implied or expressed.
In no case shall the author be liable for any damage or unwanted behavior
 of any computer hardware and/or software.

You cannot DISTRIBUTE THIS SOURCE CODE OR ITS COMPILED .DCU IN ANY FORM.

This unit cannot be included in any commercial, shareware or freeware DELPHI
libraries or components.

email: nws@centurybyte.com
web site: www.nwscomps.com
*)
unit NWSComps_ThumbsBrowser_Const;
{$R-}
{$Q-}
interface
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
uses Windows, Messages, SysUtils, Classes, graphics,
     hyieutils, hyiedefs,
     {$IFDEF IMAGEEN_5_0_LATER}iesettings,{$ENDIF}
     {$IFDEF IMAGEEN_6_2_LATER}iexBitmaps,{$ENDIF}
     imageenio;


 var

 TBCONST_ValidList_READ : array of string;
 TBCONST_ValidList_WRITE : array of string;

  const


    
    TBCONST_dragplus_cursor_handle = 9000;

    TBCONST_SR_ATTR_URL = -16;

    TBCONST_ValidList_Read_Base: array[0..43] of string = (
    '.bmp', '.ico', '.png', '.dib', '.jpg', '.psd', '.jpeg',
    '.jpe', '.gif', '.tif', '.tiff', '.fax', '.g3n', '.g3f',
    '.rle', '.wmf', '.emf', '.wbmp',
    '.cur', '.pcx', '.tga', '.targa',
    '.jp2', '.j2k', '.jpc', '.j2c',
    '.vda', '.icb', '.vst', '.pix', '.pxm',
    '.pbm', '.pgm', '.ppm',
    '.pdd', '.gdt', '.pcd', '.cut',
    '.dcm', '.dic', '.dicom', '.v2',
    '.thm', '.wmp'
    );






  TBCONST_ValidList_Write_Base: array[0..27] of string = (
    '.bmp', '.dib', '.rle', '.jpg', '.jpeg',
    '.jpe', '.gif', '.tif', '.tiff', '.ico',
    '.pcx', '.png', '.tga', '.targa',
    '.vda', '.icb', '.vst', '.pix', '.pxm',
    '.pbm', '.pgm', '.ppm', '.jp2', '.j2k',
    '.jpc', '.ps', '.eps', '.pdf');



  TBCONST_ValidList_RAW: array[0..37] of string = ('.3FR','.ARI', '.ARW', '.BAY', '.CRW', '.CR2',
                                             '.CAP', '.DCR', '.DCS', '.DNG', '.DRF',
                                             '.EIP', '.ERF', '.FFF', '.IIQ',
                                             '.K25', '.KDC', '.MDC', '.MEF', '.MOS', '.MRW',
                                             '.NEF', '.NRW', '.OBM', '.ORF',
                                             '.PEF', '.PTX', '.PXN',
                                             '.R3D', '.RAF', '.RAW', '.RWL', '.RW2', '.RWZ',
                                             '.SR2', '.SRF', '.SRW', '.X3F'
                                              );



  TBCONST_ValidList_ICO: array[0..0] of string = ('.ICO');
  TBCONST_ValidList_TIF: array[0..1] of string = ('.TIF', '.TIFF');

  TBCONST_ValidList_GIF: array[0..0] of string = ('.GIF');

  TBCONST_ValidList_DICOM: array[0..3] of string = ('.DICOM', '.DCM', '.DIC', '.V2');

  TBCONST_ValidList_JPG: array[0..2] of string = ('.JPG', '.JPEG', '.JPE');

  TBCONST_ValidList_VIDEO: array[0..14] of string = ('.AVI', '.MPG', '.MPE', '.MPEG', '.WMV',
                                                    '.ASF', '.IVF', '.WM', '.MP4','.MOV',
                                                    '.QT', '.RM', '.M2TS', '.MTS', '.MOD');
  // ALL_KNOWN_EXPLORER_VIDEO_FORMATS = '*.AVI;*.MPG;*.MPE;*.MPEG;*.WMV;*.ASF;*.IVF;*.WM;*.MP4;*.MOV;*.QT;*.RM;*.M2TS;*.MTS;*.MOD;';


  TBCONST_FilterExtsGblIdentifier_RAW = '[RAW FILES]';
  TBCONST_FilterExtsGblIdentifier_VIDEO = '[VIDEO FILES]';
  TBCONST_FilterExtsGblIdentifier_PICTURE = '[PICTURE FILES]';

  ZeroExifDate = '1899/12/30';


  TBCONST_ISWIA_TAG = '***WIA***';   //use the character * because it cannot be contained in any file name
  TBCONST_ISWIA_TAG_LENGTH = Length(TBCONST_ISWIA_TAG);

  TBCONST_ISWPD_TAG = '***WPD***';  //use the character * because it cannot be contained in any file name
  TBCONST_ISWPD_TAG_LENGTH = Length(TBCONST_ISWPD_TAG);

  TBCONST_GENSEPARATOR = '?';
  TBCONST_RENAMEFORMAT_MAIN_FILE_SEPARATOR = '_';
  TBCONST_RENAMEFORMAT_MAIN_FOLDER_SEPARATOR = ' ';
  TBCONST_RENAMEFORMAT_DATESEPARATOR = '-';
  TBCONST_RENAMEFORMAT_TIMESEPARATOR = '-';
  TBCONST_RENAMEFORMAT_SUBJECTSEPARATOR = '';
  TBCONST_RENAMEFORMAT_AUTHORSEPARATOR = '-';


  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM_DD = 'YYYY'+ TBCONST_GENSEPARATOR +
                                               'MM'+ TBCONST_GENSEPARATOR +
                                               'DD';



  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MT_DD = 'YYYY'+ TBCONST_GENSEPARATOR +
                                               'MMM'+ TBCONST_GENSEPARATOR +
                                               'DD';


  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MONTH_DD = 'YYYY'+ TBCONST_GENSEPARATOR +
                                                  'MMMM'+ TBCONST_GENSEPARATOR +
                                                  'DD';


  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MM_DD = 'YY'+ TBCONST_GENSEPARATOR +
                                             'MM'+ TBCONST_GENSEPARATOR +
                                             'DD';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MT_DD = 'YY'+ TBCONST_GENSEPARATOR +
                                             'MMM'+ TBCONST_GENSEPARATOR +
                                             'DD';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MONTH_DD = 'YY'+ TBCONST_GENSEPARATOR +
                                                'MMMM'+ TBCONST_GENSEPARATOR +
                                                'DD';

//------------------------------------------------------------------------------

  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM = 'YYYY'+ TBCONST_GENSEPARATOR +
                                               'MM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MT = 'YYYY'+ TBCONST_GENSEPARATOR +
                                            'MMM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MONTH = 'YYYY'+ TBCONST_GENSEPARATOR +
                                               'MMMM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MM = 'YY'+ TBCONST_GENSEPARATOR +
                                          'MM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MT = 'YY'+ TBCONST_GENSEPARATOR +
                                          'MMM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MONTH = 'YY'+ TBCONST_GENSEPARATOR +
                                             'MMMM';

  TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY = 'YYYY';
  TBCONST_RENAMEFORMAT_DATEFORMAT_YY = 'YY';

  TBCONST_RENAMEFORMAT_TIMEFORMAT_HH_NN_SS_ZZZ = 'HH' + TBCONST_GENSEPARATOR +
                                                 'NN' + TBCONST_GENSEPARATOR +
                                                 'SS' + TBCONST_GENSEPARATOR +
                                                 'ZZZ';

  TBCONST_RENAMEFORMAT_TIMEFORMAT_HH_NN_SS = 'HH' + TBCONST_GENSEPARATOR +
                                                 'NN' + TBCONST_GENSEPARATOR +
                                                 'SS';

  TBCONST_RENAMEFORMAT_TIMEFORMAT_HH_NN = 'HH' + TBCONST_GENSEPARATOR +
                                                 'NN';



    function IsFileNameWIA(fname: string):boolean;
    function GetWiaFileName(thethumbID: integer): string;
    function ExtractWiaThumbId(fname: String): integer;
    function GetWPDFileName(thethumbID: integer): string;
    function ExtractWPDThumbId(fname: String): integer;
    function IsFileNameWPD(fname: string): boolean;
    function PosInsens(const SubStr, S: string; Offset: Integer = 1): Integer;

implementation
type
  TCharUpCaseTable = array [Char] of Char;

var

  CharUpCaseTable: TCharUpCaseTable;



function ExtractWiaThumbId(fname:String):integer;
begin
  result := strtoint(copy(fname,TBCONST_ISWIA_TAG_LENGTH + 1, length(fname) - TBCONST_ISWIA_TAG_LENGTH));
end;

function ExtractWPDThumbId(fname:String):integer;
begin
  result := strtoint(copy(fname,TBCONST_ISWPD_TAG_LENGTH + 1, length(fname) - TBCONST_ISWPD_TAG_LENGTH));
end;

function GetWiaFileName(thethumbID: integer):string;
begin
  result := TBCONST_ISWIA_TAG + inttostr(thethumbID);
end;

function GetWPDFileName(thethumbID: integer):string;
begin
  result := TBCONST_ISWPD_TAG + inttostr(thethumbID);
end;

function IsFileNameWIA(fname:string):boolean;
begin
  result := (length(fname) >= TBCONST_ISWIA_TAG_LENGTH) and
            (copy(fname,1, TBCONST_ISWIA_TAG_LENGTH) = TBCONST_ISWIA_TAG);
end;

function IsFileNameWPD(fname:string):boolean;
begin
  result := (length(fname) >= TBCONST_ISWPD_TAG_LENGTH) and
            (copy(fname,1, TBCONST_ISWPD_TAG_LENGTH) = TBCONST_ISWPD_TAG);
end;

{$IFDEF IMAGEEN_5_0_LATER}
procedure InitFormats_PICS_IE;
function ProperExt(theExt:string):string;
begin
  if length(theExt) <2 then
    result := ''
  else
  begin
    result := theExt;
    if result[1]='*' then
      result := copy(result, 2, length(result)-1);
    if result[1]<> '.' then
      result := '.' + result;
  end;
end;
var
I, j:integer;
ff: TIEFileFormatInfo;
begin



  //add picture formats
  for I := 0 to IEGlobalsettings.FileFormats.Count-1 do
  begin
    ff := TIEFileFormatInfo(IEGlobalsettings.FileFormats.Items[i]);

    if assigned(ff.ReadFunction) then
    begin
      for j := 0 to IEFileFormatGetExtCount(ff.FileType)-1 do
      begin

        setlength(TBCONST_ValidList_READ, length(TBCONST_ValidList_READ)+1);
        TBCONST_ValidList_READ[high(TBCONST_ValidList_READ)] := ProperExt(IEFileFormatGetExt(ff.FileType, j));
      end;
    end;

    if assigned(ff.WriteFunction) then
    begin
      for j := 0 to IEFileFormatGetExtCount(ff.FileType)-1 do
      begin
        setlength(TBCONST_ValidList_WRITE, length(TBCONST_ValidList_WRITE)+1);
        TBCONST_ValidList_WRITE[high(TBCONST_ValidList_WRITE)] := ProperExt(IEFileFormatGetExt(ff.FileType, j));
      end;
    end;

  end;

end;
{$ENDIF}




procedure InitFormats_PICS;
var
I, ctr, start:integer;
begin
  start := length(TBCONST_ValidList_READ);
  setlength(TBCONST_ValidList_READ, length(TBCONST_ValidList_READ) +
                                    length(TBCONST_ValidList_Read_Base)
                                    + length(TBCONST_ValidList_RAW));

  ctr := start;
  for I := 0 to High(TBCONST_ValidList_Read_Base) do
  begin
    TBCONST_ValidList_READ[ctr] := TBCONST_ValidList_Read_Base[i];
    inc(ctr);
  end;

  for I := 0 to High(TBCONST_ValidList_RAW) do
  begin
    TBCONST_ValidList_READ[ctr] := TBCONST_ValidList_RAW[i];
    inc(ctr);
  end;

  start := length(TBCONST_ValidList_WRITE);
  setlength(TBCONST_ValidList_WRITE, length(TBCONST_ValidList_WRITE) + length(TBCONST_ValidList_Write_Base));

  ctr := start;
  for I := 0 to High(TBCONST_ValidList_Write_Base) do
  begin
    TBCONST_ValidList_WRITE[ctr] := TBCONST_ValidList_Write_Base[i];
    inc(ctr);
  end;
end;

procedure InitFormats_VIDEOS;
var
I, ctr, start:integer;
begin
  start := length(TBCONST_ValidList_READ);
  setlength(TBCONST_ValidList_READ, length(TBCONST_ValidList_READ) +
                                    length(TBCONST_ValidList_VIDEO));

  ctr := start;
  for I := 0 to High(TBCONST_ValidList_VIDEO) do
  begin
    TBCONST_ValidList_READ[ctr] := TBCONST_ValidList_VIDEO[i];
    inc(ctr);
  end;
end;

procedure InitFormats;
begin
  setlength(TBCONST_ValidList_READ, 0);
  setlength(TBCONST_ValidList_WRITE, 0);

  {$IFDEF IMAGEEN_5_0_LATER}
   InitFormats_PICS_IE;
  {$ELSE}
   InitFormats_PICS;
  {$ENDIF}


  InitFormats_VIDEOS;
end;

procedure InitCharUpCaseTable(var Table: TCharUpCaseTable);
var
  n: cardinal;
begin
  for n := 0 to Length(Table) - 1 do
    Table[Char(n)] := Char(n);
  CharUpperBuff(@Table, Length(Table));
end;

function PosInsens(const SubStr, S: string; Offset: Integer = 1): Integer;
var
  n              :integer;
  SubStrLength   :integer;
  SLength        :integer;
label
  Fail;
begin
  SLength := length(s);
  if (SLength > 0) and (Offset > 0) then
  begin
    SubStrLength := length(SubStr);
    result := Offset;
    while SubStrLength <= SLength - result + 1 do begin
      for n := 1 to SubStrLength do
        if CharUpCaseTable[SubStr[n]] <> CharUpCaseTable[s[result + n - 1]] then
          goto Fail;
      exit;

      Fail:
      inc(result);
    end;
  end;
  result := 0;
end;




 initialization

  InitCharUpCaseTable(CharUpCaseTable);
  IEAutoLoadIOPlugins;
  InitFormats;

end.
 