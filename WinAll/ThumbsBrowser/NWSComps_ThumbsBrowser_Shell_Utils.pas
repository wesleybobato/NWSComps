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
unit NWSComps_ThumbsBrowser_Shell_Utils;
{$R-}
{$Q-}

interface

{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}

uses windows,
  Sysutils, Graphics, classes, forms, contnrs,
  messages, SyncObjs,
  hyieutils, hyiedefs, imageenproc,
{$IFDEF IMAGEEN_5_0_LATER} iexWindowsFunctions, {$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF}
  imageenio;

var
  tbs_specialFolders: TStringlist;

type
  // --------------Shell---------------------------------------------------

  TTB_Shell_FileType = (shft_File, shft_Folder, shft_Url, shft_Wia, shft_Other);
  TTB_Shell_FileTypes = set of TTB_Shell_FileType;

  TTB_Shell_URLType = (utUnknown, utHTTP, utHTTPS, utFTP);

  TTB_Shell_ClipboardChange_Event = procedure(bHasFiles: boolean; sender: TObject) of object;

  TTB_Shell_ClipboardOperation = (coCut, coCopy);

  TTB_Shell_ClipboardItem = class
  private
    fFileName: string;
    fOperationType: TTB_Shell_ClipboardOperation;
  public

    property filename: string read fFileName;
    property OperationType: TTB_Shell_ClipboardOperation read fOperationType;

    constructor Create(theFileName: string; theOperationType: TTB_Shell_ClipboardOperation);
  end;

  TTB_Shell_ClipboardRecord = class(TObject)
  private
    fNextHandle: THandle;

    fItems: TObjectList;
    fInternalMode: boolean;
    function GetHasFiles: boolean;
    function GetItem(idx: integer): TTB_Shell_ClipboardItem;

  public
    property NextHandle: THandle read fNextHandle write fNextHandle;
    property HasFiles: boolean read GetHasFiles;
    procedure CopyToClip(theFiles: TStringlist);
    procedure CutToClip(theFiles: TStringlist);
    procedure ClearClip;
    procedure ClearFilesToCut;

    Property Item[idx: integer]: TTB_Shell_ClipboardItem read GetItem;
    Property InternalMode: boolean read fInternalMode;

    Procedure SetInternalMode;
    Procedure UnSetInternalMode;

    procedure GetFilesToCopyOrCut(theFilesToCopy, theFilesToCut: TStringlist; theFileTypes: TTB_Shell_FileTypes);
    procedure GetFiles(theFiles: TStringlist; theFileTypes: TTB_Shell_FileTypes);

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  TTB_Shell_FileRenameOptions = (rf_Subject_Date, rf_Date_Subject, rf_donotrename, rf_usenumeration, rf_Custom);
  TTB_Shell_FolderRenameOptions = (rfd_Subject_Date, rfd_Date_Subject, rfd_Subject, rfd_usenumeration, rfd_Custom);

  TTB_Shell_FileRename_Capitalization = (fc_AsOriginal, fc_CapitalizeAll, fc_CapitalizeName, fc_CapitalizeExtension,
    fc_UncapitalizeAll, fc_UncapitalizeName, fc_UncapitalizeExtension);

  TTB_Shell_FileRenameFormat = record
    ChangeExt: boolean;
    NewExt: string;
    FixedStr: string;
    Sep_Main: String;
    Sep_Date: string;
    Sep_Time: string;
    Sep_FileSubject: string;
    Sep_FileAuthor: string;
    DateFormat: string;
    TimeFormat: string;
    RenameOptions: TTB_Shell_FileRenameOptions;
    CapitalizeOptions: TTB_Shell_FileRename_Capitalization;
    UseExifDate: boolean;
  end;

  TTB_Shell_FolderRenameFormat = record
    FixedStr: string;
    Sep_Main: String;
    Sep_Date: string;
    Sep_Time: string;
    Sep_Subject: string;
    DateFormat: string;
    RenameOptions: TTB_Shell_FolderRenameOptions;
    UseExifDate: boolean;
    AddFileTypeFolder: boolean;
    TypeFolder_Capitalized: boolean;
  end;

  TTB_Shell_SaveParameters = record
    BitsPerSample: integer;
    Dpi: integer;
    DpiX: integer;
    DpiY: integer;
    InputICCProfile: TIEICC;
    OutputICCProfile: TIEICC;
    SamplesPerPixel: integer;
    BMP_Compression: TIOBMPCompression;
    BMP_Version: TIOBMPVersion;
    GIF_Background: TRGB;
    GIF_FlagTranspColor: boolean;
    GIF_Interlaced: boolean;
    GIF_Ratio: integer;
    GIF_TranspColor: TRGB;
    GIF_Version: string;
    JPEG_ColorSpace: TIOJPEGColorSpace;
    JPEG_DCTMethod: TIOJPEGDCTMethod;
    JPEG_OptimalHuffman: boolean;
    JPEG_Progressive: boolean;
    JPEG_Quality: integer;
    JPEG_Scale: TIOJPEGScale;
    JPEG_Smooth: integer;
    J2000_ColorSpace: TIOJ2000ColorSpace;
    J2000_Rate: double;
    J2000_ScalableBy: TIOJ2000ScalableBy;
    PCX_Compression: TIOPCXCompression;
    TIFF_Compression: TIOTIFFCompression;
    TIFF_DocumentName: string;
    TIFF_ImageDescription: string;
    TIFF_JPEGColorSpace: TIOJPEGColorSpace;
    TIFF_JPEGQuality: integer;
    CUR_Background: TRGB;
    ICO_Background: TRGB;
    PNG_Background: TRGB;
    PNG_Compression: integer;
    PNG_Filter: TIOPNGFilter;
    PNG_Interlaced: boolean;
    TGA_AspectRatio: double;
    TGA_Author: string;
    TGA_Background: TRGB;
    TGA_Compressed: boolean;
    TGA_Date: TDateTime;
    TGA_Descriptor: string;
    TGA_Gamma: double;
    TGA_GrayLevel: boolean;
  end;

  TTB_Shell_Tree_File_Node_Info = record

    Date: TDateTime;
    Date_EXIF: TDateTime;
    Date_Used: TDateTime;
  end;

  TTB_Shell_Tree_File_Node = record
    node_name: string;
    node_FileName_Full: string;
    node_FileName_Short: string;
    node_info: TTB_Shell_Tree_File_Node_Info;
    idx: cardinal;
  end;

  TTB_Shell_Tree_Files_NodeArray = array of TTB_Shell_Tree_File_Node;

  TTB_Shell_Tree_Folder_Node = record
    node_name: string;
    node_name_SubStrings: array of string;
    node_relativepath: string;
    node_info: TTB_Shell_Tree_File_Node_Info;

    FilesCount: integer;
    Files: TTB_Shell_Tree_Files_NodeArray;
    FolderIdx: integer;
  end;

  TTB_Shell_Tree_Folders_NodeArray = array of TTB_Shell_Tree_Folder_Node;

  TTB_Shell_CompareDateMode = (cd_date, cd_year, cd_yearmonth);

  TTB_Shell_RenamedFileEvent = procedure(oldname, newname: string) of object;
  TTB_Shell_RenamedCopiedFileEvent = procedure(srcname, destname: string) of object;

  TTB_Shell_PickMode = (omPickAll, omPickSelected, omPickChecked, omPickRotated, omPicksameYear, omPicksameMonth,
    omPicksameDay, omPicksameYearMonth, omPickSameDate, omPickSameDateRange, omPickSameDatetime, omPickSameExifYear,
    omPicksameExifMonth, omPicksameExifDay, omPickSameExifYearMonth, omPickSameExifDate, omPickSameExifDateRange,
    omPickFolders, omPickFiles, omPickUrls, omPickWia, omPickWPDFolders, omPickWPDFiles);

  TTB_Shell_FolderNodes_PickMode = (fn_PickNone, fn_PicksameYear, fn_PicksameMonth, fn_PicksameDay,
    fn_PicksameYearMonth, fn_PickSameDate);

var

  TBSHELLCONST_DEFRENAMEFORMAT_FILES: TTB_Shell_FileRenameFormat;
  TBSHELLCONST_DEFRENAMEFORMAT_FOLDERS: TTB_Shell_FolderRenameFormat;
  TBSHELLCONST_EMPTYRENAMEFORMAT_FILES: TTB_Shell_FileRenameFormat;
  TBSHELLCONST_EMPTYRENAMEFORMAT_FOLDERS: TTB_Shell_FolderRenameFormat;

procedure tbs_WIAFillDevices(sl: TStrings);

{$IFDEF TB_PORTABLEDEVICE}
procedure tbs_WPDFillDevices(sl: TStrings);
function tbs_WPDDecodeDevID(s: string): string;
function tbs_WPDDecodeDevName(s: string): string;
{$ENDIF}
function tbs_UrlIsValidUrl(theUrl: string): boolean;
function tbs_UrlType(theUrl: string): TTB_Shell_URLType;

function tbs_UrlDecode(theUrl: string): string;
function tbs_UrlExtractFilename(theUrl: string; bDecode: boolean): string;
function tbs_UrlExtractPath(theUrl: string; bDecode: boolean): string;

function tbs_GetParentPath(path: string): string;
function tbs_ComparePaths(path1, path2: string): integer;

function tbs_PathIsChildOfPath(childPath, path: string): boolean;

function tbs_FileIsReadOnly(filename: String): boolean;
function tbs_SetFileReadOnly(filename: String; ReadOnly: boolean = True): boolean;
function tbs_removeFileReadOnly(srcname: string): boolean;

function tbs_GetExtensionFolder(const theFileName: string; bCapitalize: boolean): string;
function tbs_EnsureUniqueFileName(thename: string): string;

// function tbs_ExifDateStrtoDateTime(const s: string): TDatetime;
function tbs_ExifDateisValid(dt: TDateTime; minyear: integer): boolean;

function tbs_IsSpecialFolder(Folder: string): boolean;
function tbs_GetSpecialFolderPath(const Folder: integer): string;
procedure tbs_GetSpecialFolders(sl: TStringlist);
function tbs_PathDivisions(path: string): integer;

function TBS_RemoveEmptyFolders(rootFolder: string): boolean;
function tbs_IsDirectoryEmpty(const directory: string): boolean;

function tbs_getfiledate(Rec: TSearchRec): TDateTime; overload;
function tbs_getfiledate(FileNameFull: string): TDateTime; overload;
function tbs_getfilesize(FileNameFull: string): int64;

function Tbs_AddSlash(s: string): string;

function tbs_SamePath(path1, path2: string): boolean;

function tbs_FmtSettings_ShortDateFmt: string;
function tbs_FmtSettings_DateSeparator: char;
function tbs_FmtSettings_TimeSeparator: char;

Function tbs_Convert_PickMode_To_FolderNodes_PickMode(aPickMode: TTB_Shell_PickMode): TTB_Shell_FolderNodes_PickMode;
function tbs_GetFilePickModeFromFolderRenameFormat(theFolderRenameFormat: TTB_Shell_FolderRenameFormat;
  bUseExif: boolean): TTB_Shell_PickMode;

procedure tbs_SetFileTime(const filename: string; const theDateTime: TDateTime;
  const bCreationTime, bModifiedTime, bAccessTime: boolean);

function tbs_GetFileTimes(const filename: string; var creationTime, lastAccessTime, lastModificationTime
  : TDateTime): boolean;

function tbs_FileExtIsDICOM(ext: string): boolean;
function tbs_FileExtIsJPG(ext: string): boolean;
function tbs_FileExtIsGif(ext: string): boolean;
function tbs_FileExtIsTif(ext: string): boolean;
function tbs_FileextIsIco(ext: string): boolean;
function tbs_FileExtIsRAW(ext: string): boolean;
function tbs_FileExtIsVIDEO(ext: string): boolean;

function tbs_GetFilterString_VALID_READ: string;
function tbs_GetFilterString_VALID_WRITE: string;


function tbs_FileExtSupportExif(ext: string): boolean;

function tbs_IsFilename_InFilter(fname: string; filter: string; const bAllowMultipleExtInFilter: boolean): boolean;
function tbs_IsFileExt_InFilter(fext: string; filter: string; const bAllowMultipleExtInFilter: boolean): boolean;

function tbs_GetFileIcon(fname: string; theIeBitmap: TIEBitmap; bJumbo: boolean): boolean;
function tbs_GetFileTypeDescription(ext: string): string;
function tbs_GetUniqueFileName(fname: string): string;

implementation

uses shlobj, shellapi, ComObj,
  ActiveX, CommCtrl,
  bmpfilt,
{$IFDEF TB_PORTABLEDEVICE}
  iexWPD,
{$ENDIF}
  NWSComps_ThumbsBrowser_const;

(*
  Call StrToDate to parse a string that specifies a date.
  If S does not contain a valid date, StrToDate raises an EConvertError exception.

  S must consist of two or three numbers, separated by the character defined by
  the DateSeparator global variable.

  The order for month, day, and year is determined by the ShortDateFormat global variable
  --possible combinations are m/d/y, d/m/y, and y/m/d.

  If S contains only two numbers, it is interpreted as a date (m/d or d/m) in the current year.
*)

var
  tbs_specialFoldersCS: TCriticalSection;
  tbs_ShellIconsCS: TCriticalSection;

const
  Shell_32_Dll = 'shell32.dll';
  SHIL_LARGE = $00;
  // The image size is normally 32x32 pixels. However, if the Use large icons option is selected from the Effects section of the Appearance tab in Display Properties, the image is 48x48 pixels.
  SHIL_SMALL = $01;
  // These images are the Shell standard small icon size of 16x16, but the size can be customized by the user.
  SHIL_EXTRALARGE = $02;
  // These images are the Shell standard extra-large icon size. This is typically 48x48, but the size can be customized by the user.
  SHIL_SYSSMALL = $03;
  // These images are the size specified by GetSystemMetrics called with SM_CXSMICON and GetSystemMetrics called with SM_CYSMICON.
  SHIL_JUMBO = $04; // Windows Vista and later. The image is normally 256x256 pixels.
  IID_IImageList: TGUID = '{46EB5926-582E-4017-9FDF-E8998DAA0950}';

var
  Shell32Lib: HModule;
  Func_SHGetImageList: function(iImageList: integer; const riid: TGUID; var ppv: Pointer): hResult; stdcall;
  HSHJumboImageList, HSHLargeImageList: HImageList;

const
  DEV_ID_SEP = '    |:||:|    ';

function tbs_GetImageListSH(SHIL_FLAG: cardinal): HImageList;
begin
  Result := 0;

  if (Assigned(Func_SHGetImageList) = False) and (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    Shell32Lib := GetModuleHandle(Shell_32_Dll);
    if Shell32Lib > 0 then
      Func_SHGetImageList := GetProcAddress(Shell32Lib, PChar(727));
  end;

  if Assigned(Func_SHGetImageList) then
    Func_SHGetImageList(SHIL_FLAG, IID_IImageList, Pointer(Result));
end;

function tbs_GetUniqueFileName(fname: string): string;
var
  ctr: integer;
begin
  ctr := 1;
  while fileexists(fname) do
  begin
    fname := changefileext(fname, '') + inttostr(ctr) + extractfileext(fname);
    inc(ctr);
  end;
  Result := fname;
end;

function tbs_GetFileIcon(fname: string; theIeBitmap: TIEBitmap; bJumbo: boolean): boolean;
var
  SFI: TSHFileInfo;
  icon: hIcon;
  shlNr: cardinal;
Begin
  tbs_ShellIconsCS.Enter;
  try
    icon := 0;

    if bJumbo then
      shlNr := SHIL_JUMBO
    else
      shlNr := SHIL_LARGE;

    CoInitialize(nil);
    try
      // Get the index of the imagelist
      FillChar(SFI, SizeOf(TSHFileInfo), 0);

      SHGetFileInfo(PChar(fname), FILE_ATTRIBUTE_NORMAL, SFI, SizeOf(TSHFileInfo), SHGFI_ICON or SHGFI_LARGEICON);

      // Get the imagelist

      if bJumbo then
      begin
        if HSHJumboImageList = 0 then
          HSHJumboImageList := tbs_GetImageListSH(shlNr);

        if HSHJumboImageList <> 0 then
        begin
          // Extract the icon handle
          icon := ImageList_GetIcon(HSHJumboImageList, SFI.iIcon, ILD_IMAGE);
        end;
        // IEGetFileIcon
      end
      else
      begin
        if HSHLargeImageList = 0 then
          HSHLargeImageList := tbs_GetImageListSH(shlNr);

        if HSHLargeImageList <> 0 then
        begin
          // Extract the icon handle
          icon := ImageList_GetIcon(HSHLargeImageList, SFI.iIcon, ILD_IMAGE);
        end;
      end;

    finally
      CoUninitialize;
    end;
  finally
    tbs_ShellIconsCS.leave;
  end;

  if (icon <> 0) then // if icon was loaded from shell imagelist
  begin
    try
      IEConvertIconToBitmap(icon, theIeBitmap);
      Result := True;
    finally
      DestroyIcon(icon);
    end;
  end
  else if bJumbo then // jumbo icon was not loaded try with large
    Result := tbs_GetFileIcon(fname, theIeBitmap, False) // try to load the large icon instead
  else
  begin
    IEGetFileIcon(fname, theIeBitmap);
    Result := True;
  end;

End;

function tbs_GetFileTypeDescription(ext: string): string;
var
  FileInfo: SHFILEINFO;
begin
  Result := '';
  ext := '*' + ext;

  // Get description type
  if SHGetFileInfo(PChar(ext), FILE_ATTRIBUTE_NORMAL, FileInfo, SizeOf(FileInfo),
    SHGFI_TYPENAME or SHGFI_USEFILEATTRIBUTES) <> 0 then
    Result := (FileInfo.szTypeName);
end;

function tbs_FmtSettings_ShortDateFmt: string;
begin
{$IFDEF NWSCOMPS_DXE_UPPER}
  Result := FormatSettings.ShortDateFormat;
{$ELSE}
  Result := ShortDateFormat;
{$ENDIF}
end;

function tbs_FmtSettings_DateSeparator: char;
begin
{$IFDEF NWSCOMPS_DXE_UPPER}
  Result := FormatSettings.DateSeparator;
{$ELSE}
  Result := DateSeparator;
{$ENDIF}
end;

function tbs_FmtSettings_TimeSeparator: char;
begin
{$IFDEF NWSCOMPS_DXE_UPPER}
  Result := FormatSettings.TimeSeparator;
{$ELSE}
  Result := TimeSeparator;
{$ENDIF}
end;

function Tbs_AddSlash(s: string): string;
begin
  if s = '' then
  begin
    Result := s;
    exit;
  end;
  if s[length(s)] <> PathDelim then
    Result := s + PathDelim
  else
    Result := s;
end;

procedure tbs_WIAFillDevices(sl: TStrings);
var
  i: integer;
  io: TImageenio;
begin
  sl.Clear;
  io := TImageenio.Create(nil);
  try
    for i := 0 to io.WIAParams.DevicesInfoCount - 1 do
    begin
      sl.Add(io.WIAParams.DevicesInfo[i].Name);
    end;
  finally
    io.free;
  end;
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure tbs_WPDFillDevices(sl: TStrings);
var
  i: integer;
  wpd: TIEPortableDevices;
begin
  sl.Clear;

  wpd := TIEPortableDevices.Create;
  wpd.HideEmptyDevices := True;
  wpd.RefreshDevices;
  try
    for i := 0 to wpd.DeviceCount - 1 do
    begin
      sl.Add(wpd.Devices[i].FriendlyName + DEV_ID_SEP + wpd.Devices[i].ID);
    end;
  finally
    wpd.free;
  end;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function tbs_WPDDecodeDevID(s: string): string;
var
  IDPos: integer;
begin
  Result := '';
  IDPos := pos(DEV_ID_SEP, s);
  if IDPos = 0 then
    exit;

  IDPos := IDPos + length(DEV_ID_SEP);
  Result := copy(s, IDPos, length(s) - IDPos + 1);
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function tbs_WPDDecodeDevName(s: string): string;
var
  IDPos: integer;
begin
  Result := '';

  IDPos := pos(DEV_ID_SEP, s);
  if IDPos = 0 then
    exit;

  Result := copy(s, 1, IDPos);
end;
{$ENDIF}

function tbs_UrlIsValidUrl(theUrl: string): boolean;
begin
  Result := tbs_UrlType(theUrl) <> utUnknown;
end;

function tbs_UrlType(theUrl: string): TTB_Shell_URLType;
var
  tmp: String;
begin
  tmp := LowerCase(theUrl);
  if copy(tmp, 1, 7) = 'http://' then
    Result := utHTTP
  else if copy(tmp, 1, 8) = 'https://' then
    Result := utHTTPS
  else if copy(tmp, 1, 6) = 'ftp://' then
    Result := utFTP
  else
    Result := utUnknown;

end;

function tbs_UrlDecode(theUrl: string): string;
  function HexToInt(HexStr: String): int64;
  var
    RetVar: int64;
    i: byte;
  begin
    HexStr := UpperCase(HexStr);
    if HexStr[length(HexStr)] = 'H' then
      Delete(HexStr, length(HexStr), 1);
    RetVar := 0;

    for i := 1 to length(HexStr) do
    begin
      RetVar := RetVar shl 4;
      if HexStr[i] in ['0' .. '9'] then
        RetVar := RetVar + (byte(HexStr[i]) - 48)
      else if HexStr[i] in ['A' .. 'F'] then
        RetVar := RetVar + (byte(HexStr[i]) - 55)
      else
      begin
        RetVar := 0;
        break;
      end;
    end;

    Result := RetVar;
  end;

var
  i: integer;
begin
  Result := '';
  if length(theUrl) > 0 then
  begin
    i := 1;
    while i <= length(theUrl) do
    begin
      if theUrl[i] = '%' then
      begin
        Result := Result + Chr(HexToInt(theUrl[i + 1] + theUrl[i + 2]));
        i := Succ(Succ(i));
      end
      else if theUrl[i] = '+' then
        Result := Result + ' '
      else
        Result := Result + theUrl[i];

      i := Succ(i);
    end;
  end;
end;

function tbs_UrlExtractFilename(theUrl: string; bDecode: boolean): string;
var
  i: integer;
begin
  i := LastDelimiter('/', theUrl);
  Result := copy(theUrl, i + 1, MaxInt);
  if bDecode then
    Result := tbs_UrlDecode(Result);
end;

function tbs_UrlExtractPath(theUrl: string; bDecode: boolean): string;
var
  i: integer;
begin
  i := LastDelimiter('/', theUrl);
  Result := copy(theUrl, 1, i);
  if bDecode then
    Result := tbs_UrlDecode(Result);
end;

function tbs_GetParentPath(path: string): string;
begin
  Result := Tbs_AddSlash(ExtractFilePath(ExcludeTrailingPathDelimiter(path)));
end;

function tbs_ComparePaths(path1, path2: string): integer;
begin
  Result := Comparetext(Tbs_AddSlash(path1), Tbs_AddSlash(path2));
end;

function tbs_PathIsChildOfPath(childPath, path: string): boolean;
begin
  path := UpperCase(Tbs_AddSlash(path));
  childPath := UpperCase(Tbs_AddSlash(childPath));

  Result := pos(path, childPath) = 1;

end;

function tbs_FileIsReadOnly(filename: String): boolean;
begin

  // Result := GetFileAttributes(PChar(FileName)) and FILE_ATTRIBUTE_READONLY > 0;
  Result := GetFileAttributesW(PWideChar(filename)) and FILE_ATTRIBUTE_READONLY > 0;

end;

function tbs_SetFileReadOnly(filename: String; ReadOnly: boolean = True): boolean;
begin
  if not fileexists(filename) then
    Result := False
  else
  begin
    if ReadOnly then
      Result := SetFileAttributesW(PWideChar(filename), GetFileAttributesW(PWideChar(filename)) or
        FILE_ATTRIBUTE_READONLY)
    else
      Result := SetFileAttributesW(PWideChar(filename), FILE_ATTRIBUTE_NORMAL);

  end;
end;

function tbs_removeFileReadOnly(srcname: string): boolean;
var
  attr: integer;
begin
  Result := False;
  attr := Sysutils.FileGetAttr(srcname);
  if attr and faReadOnly <> 0 then
  begin
    Result := (Sysutils.FileSetAttr(srcname, attr - faReadOnly) >= 0);
  end;
end;

function tbs_GetExtensionFolder(const theFileName: string; bCapitalize: boolean): string;
begin
  Result := extractfileext(theFileName);
  Result := copy(Result, 2, length(Result) - 1);
  if bCapitalize then
    Result := UpperCase(Result);
end;

function tbs_EnsureUniqueFileName(thename: string): string;
var
  Name, ext, s: string;
  ctr: integer;
begin
  name := changefileext(thename, '');
  ext := extractfileext(thename);

  ctr := 0;
  s := '';
  while fileexists(name + s + ext) do
  begin
    inc(ctr);
    s := '_' + inttostr(ctr);
  end;
  Result := name + s + ext;
end;

function tbs_ExifDateisValid(dt: TDateTime; minyear: integer): boolean;
var
  y, m, d: word;
begin
  Result := (dt > 0);
  if Result then
  begin
    decodedate(dt, y, m, d);
    Result := Result and (y >= minyear);
  end;
end;

function tbs_IsSpecialFolder(Folder: string): boolean;
var
  i: integer;
begin
  tbs_specialFoldersCS.Enter;
  try
    Result := False;
    Folder := Tbs_AddSlash(Folder);

    for i := 0 to tbs_specialFolders.count - 1 do
    begin
      if Comparetext(tbs_specialFolders[i], Folder) = 0 then
      begin
        Result := True;
        break;
      end;
    end;

  finally
    tbs_specialFoldersCS.leave;
  end;
end;

function tbs_PathDivisions(path: string): integer;
  function Occurrences(const SubText, Text: string): integer;
  begin
    if (SubText = '') OR (Text = '') OR (pos(SubText, Text) = 0) then
      Result := 0
    else
      Result := (length(Text) - length(StringReplace(Text, SubText, '', [rfReplaceAll]))) div length(SubText);
  end;

begin
  Result := Occurrences(PathDelim, ExcludeTrailingPathDelimiter(path));
  // examples:
  // c:\  -> 0 divisions
  // d:\data\ -> 1 division
end;

function tbs_GetSpecialFolderPath(const Folder: integer): string;
var
  shellMalloc: IMalloc;
  ppidl: PItemIdList;
begin
  ppidl := nil;
  try
    if SHGetMalloc(shellMalloc) = NOERROR then
    begin
      SHGetSpecialFolderLocation(Application.Handle, Folder, ppidl);
      SetLength(Result, MAX_PATH);
      if SHGetPathFromIDList(ppidl, PWideChar(Result)) then
        SetLength(Result, lStrLen(PWideChar(Result)))
      else
        Result := '';
    end;
  finally
    if ppidl <> nil then
      shellMalloc.free(ppidl);
  end;
end;

procedure tbs_GetSpecialFolders(sl: TStringlist);
var
  i: integer;
  s: string;
begin
  sl.Clear;
  for i := CSIDL_DESKTOP to CSIDL_CDBURN_AREA do
  begin
    s := tbs_GetSpecialFolderPath(i);
    if s <> '' then
      sl.Add(Tbs_AddSlash(s));
  end;
end;

function TBS_RemoveEmptyFolders(rootFolder: string): boolean;
var
  iRet: integer;
  bRemove: boolean;
  sr: TSearchRec;
begin
  rootFolder := IncludeTrailingPathDelimiter(rootFolder);
  Result := False;
  bRemove := True;
  iRet := FindFirst(rootFolder + '*.*', faAnyFile, sr);
  while (iRet = 0) do
  begin
    if (sr.Name[1] <> '.') then
    begin
      if (sr.attr and faDirectory) <> 0 then
      begin
        if not TBS_RemoveEmptyFolders(rootFolder + sr.Name) then
          bRemove := False;
      end
      else
      begin
        bRemove := False;
      end;
    end;
    iRet := FindNext(sr);
  end;
  FindClose(sr);
  if bRemove then
    Result := RemoveDir(rootFolder);
end;

function tbs_IsDirectoryEmpty(const directory: string): boolean;
var
  searchRec: TSearchRec;
begin
  try
    Result := (FindFirst(IncludeTrailingPathDelimiter(directory) + '*.*', faAnyFile, searchRec) = 0) AND
      (FindNext(searchRec) = 0) AND (FindNext(searchRec) <> 0);
  finally
    FindClose(searchRec);
  end;
end;

function tbs_getfiledate(Rec: TSearchRec): TDateTime;
begin
{$IFDEF NWSCOMPS_DXE2_UPPER}
  Result := Rec.TimeStamp;
{$ELSE}
  Result := FileDateToDateTime(Rec.Time);
{$ENDIF}
end;

function tbs_getfiledate(FileNameFull: string): TDateTime;
var
  Rec: TSearchRec;
begin
  if FindFirst(FileNameFull, faAnyFile, Rec) = 0 then
  begin
    Result := tbs_getfiledate(Rec);

    FindClose(Rec);
  end
  else
    Result := now;
end;

function tbs_getfilesize(FileNameFull: string): int64;
var
  Rec: TSearchRec;
begin
  if FindFirst(FileNameFull, faAnyFile, Rec) = 0 then
  begin
    Result := Rec.Size;

    FindClose(Rec);
  end
  else
    Result := 0;
end;

function tbs_SamePath(path1, path2: string): boolean;
begin
  path1 := Tbs_AddSlash(path1);
  path2 := Tbs_AddSlash(path2);

  Result := Comparetext(path1, path2) = 0;

end;

Function tbs_Convert_PickMode_To_FolderNodes_PickMode(aPickMode: TTB_Shell_PickMode): TTB_Shell_FolderNodes_PickMode;
begin
  case aPickMode of
    omPicksameYear, omPickSameExifYear:
      Result := fn_PicksameYear;
    omPicksameMonth, omPicksameExifMonth:
      Result := fn_PicksameMonth;
    omPicksameDay, omPicksameExifDay:
      Result := fn_PicksameDay;
    omPicksameYearMonth, omPickSameExifYearMonth:
      Result := fn_PicksameYearMonth;
    omPickSameDate, omPickSameExifDate:
      Result := fn_PickSameDate;
  else
    Result := fn_PickNone;
  end;
end;

function tbs_GetFilePickModeFromFolderRenameFormat(theFolderRenameFormat: TTB_Shell_FolderRenameFormat;
  bUseExif: boolean): TTB_Shell_PickMode;
var
  rf: TTB_Shell_FolderRenameFormat;
begin
  Result := omPickAll;

  rf := theFolderRenameFormat;

  case rf.RenameOptions of
    rfd_Date_Subject, rfd_Subject_Date:
      begin
        if (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY) then
        begin
          if bUseExif then
            Result := omPickSameExifYear
          else
            Result := omPicksameYear;
        end
        else if (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MT) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MONTH) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MM) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MT) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MONTH) then
        begin
          if bUseExif then
            Result := omPickSameExifYearMonth
          else
            Result := omPicksameYearMonth;
        end
        else if (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM_DD) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MT_DD) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MONTH_DD) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MM_DD) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MT_DD) or
          (rf.DateFormat = TBCONST_RENAMEFORMAT_DATEFORMAT_YY_MONTH_DD) then
        begin
          if bUseExif then
            Result := omPickSameExifDate
          else
            Result := omPickSameDate;
        end;
      end;
    rfd_Subject:
      begin
        rf.RenameOptions := rfd_Subject;
        Result := omPickAll;
      end;
  end;
end;

function tbs_StringInArray(Text: string; const strarray: array of string): boolean;
var
  ix: integer;
begin

  Result := False;
  Text := Trim(Text);
  for ix := low(strarray) to high(strarray) do
    if Comparetext(Trim(strarray[ix]), Text) = 0 then
    begin
      Result := True;
      break;
    end;

end;

procedure tbs_SetFileTime(const filename: string; const theDateTime: TDateTime;
  const bCreationTime, bModifiedTime, bAccessTime: boolean);
var
  Handle: THandle;
  SystemTime: TSystemTime;
  FileTime: TFileTime;
  pFTCreate, pFTModified, pFTAccess: pFileTime;
begin
  Handle := CreateFile(PChar(filename), FILE_WRITE_ATTRIBUTES, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  if Handle = INVALID_HANDLE_VALUE then
    exit; // >>Exit

  try
    DateTimeToSystemTime(theDateTime, SystemTime);
    if SystemTimeToFileTime(SystemTime, FileTime) then
    begin
      if bCreationTime then
        pFTCreate := @FileTime
      else
        pFTCreate := nil;

      if bModifiedTime then
        pFTModified := @FileTime
      else
        pFTModified := nil;

      if bAccessTime then
        pFTAccess := @FileTime
      else
        pFTAccess := nil;

      SetFileTime(Handle, pFTCreate, pFTAccess, pFTModified);
    end;

  finally
    CloseHandle(Handle);
  end;
end;

function tbs_FileTimeToDateTime(FileTime: TFileTime; var dateTime: TDateTime): boolean;
var
  sysTime: TSystemTime;
begin
  Result := FileTimeToSystemTime(FileTime, sysTime);
  if Result then
    dateTime := SystemTimeToDateTime(sysTime);
end; { DSiFileTimeToDateTime }

function tbs_GetFileTimes(const filename: string; var creationTime, lastAccessTime, lastModificationTime
  : TDateTime): boolean;
var
  fileHandle: cardinal;
  fsCreationTime: TFileTime;
  fsLastAccessTime: TFileTime;
  fsLastModificationTime: TFileTime;
begin
  Result := False;
  fileHandle := CreateFile(PChar(filename), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if fileHandle <> INVALID_HANDLE_VALUE then
    try
      Result := GetFileTime(fileHandle, @fsCreationTime, @fsLastAccessTime, @fsLastModificationTime) and
        tbs_FileTimeToDateTime(fsCreationTime, creationTime) and tbs_FileTimeToDateTime(fsLastAccessTime,
        lastAccessTime) and tbs_FileTimeToDateTime(fsLastModificationTime, lastModificationTime);
    finally
      CloseHandle(fileHandle);
    end;
end; { DSiGetFileTimes }

function tbs_FileExtIsDICOM(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_DICOM);
end;

function tbs_FileExtIsJPG(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_JPG);
end;

function tbs_FileExtIsGif(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_GIF);
end;

function tbs_FileExtIsTif(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_TIF);
end;

function tbs_FileextIsIco(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_ICO);
end;

function tbs_FileExtIsRAW(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_RAW);

end;

function tbs_FileExtIsVIDEO(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_VIDEO);

end;


function tbs_GetFilterString_VALID_READ: string;
var
i:integer;
begin
  result := '';
  for I := 0 to high(TBCONST_ValidList_READ) do
    result := result + '*' + TBCONST_ValidList_READ[i] + ';';
end;

function tbs_GetFilterString_VALID_WRITE: string;
var
i:integer;
begin
  result := '';
  for I := 0 to high(TBCONST_ValidList_WRITE) do
    result := result + '*' + TBCONST_ValidList_WRITE[i] + ';';
end;

function tbs_FileExtSupportExif(ext: string): boolean;
begin
  Result := tbs_FileExtIsJPG(ext) or tbs_FileExtIsTif(ext) or tbs_FileExtIsRAW(ext);
end;

function tbs_FileExtIsPIC_READ(ext: string): boolean;
begin
  Result := tbs_StringInArray(ext, TBCONST_ValidList_Read) and (not tbs_StringInArray(ext, TBCONST_ValidList_VIDEO));
end;

function tbs_IsFilename_InFilter(fname: string; filter: string; const bAllowMultipleExtInFilter: boolean): boolean;
begin
  Result := tbs_IsFileExt_InFilter(extractfileext(fname), filter, bAllowMultipleExtInFilter);
end;

function tbs_IsFileExt_InFilter(fext: string; filter: string;
                                const bAllowMultipleExtInFilter: boolean): boolean;
var
  starredExt: string;
begin
  if (filter = '[*.*]') then
  begin
    Result := True;
  end
  else if (filter = '*.*') then
  begin
    Result := True;
  end
  else if (filter = TBCONST_FilterExtsGblIdentifier_PICTURE) then
  begin
    Result := tbs_FileExtIsPIC_READ(fext);
  end
  else if (filter = TBCONST_FilterExtsGblIdentifier_RAW) then
  begin
    Result := tbs_FileExtIsRAW(fext);
  end
  else if (filter = TBCONST_FilterExtsGblIdentifier_VIDEO) then
  begin
    Result := tbs_FileExtIsVIDEO(fext);
  end
  else
  begin
    starredExt := '*' + fext;
    Result := Comparetext(filter, starredExt) = 0;
    if not Result and bAllowMultipleExtInFilter then
    begin
      Result := PosInsens(starredExt, filter) > 0;
    end;
  end;

end;

{ TTB_Shell_ClipboardRecord }

procedure TTB_Shell_ClipboardRecord.ClearClip;
begin
  fItems.Clear;
end;

procedure TTB_Shell_ClipboardRecord.ClearFilesToCut;
var
  i: integer;
begin
  for i := fItems.count - 1 downto 0 do
    if self.Item[i].OperationType = coCut then
      fItems.Delete(i);

end;

procedure TTB_Shell_ClipboardRecord.CopyToClip(theFiles: TStringlist);
var
  i: integer;
begin
  for i := 0 to theFiles.count - 1 do
  begin
    // if fileexists(theFiles[i]) then
    fItems.Add(TTB_Shell_ClipboardItem.Create(theFiles[i], coCopy));
  end;
end;

procedure TTB_Shell_ClipboardRecord.CutToClip(theFiles: TStringlist);
var
  i: integer;
begin
  ClearClip;
  for i := 0 to theFiles.count - 1 do
  begin
    // if fileexists(theFiles[i]) then
    fItems.Add(TTB_Shell_ClipboardItem.Create(theFiles[i], coCut));
  end;
end;

constructor TTB_Shell_ClipboardRecord.Create;
begin
  inherited;
  fItems := TObjectList.Create;
  fInternalMode := False;
end;

destructor TTB_Shell_ClipboardRecord.Destroy;
begin
  fItems.free;
  inherited;
end;

procedure TTB_Shell_ClipboardRecord.GetFilesToCopyOrCut(theFilesToCopy, theFilesToCut: TStringlist;
  theFileTypes: TTB_Shell_FileTypes);
  function CanInclude(theFileName: string): boolean;
  begin
    Result := (shft_File in theFileTypes) and (fileexists(theFileName)) or (shft_Folder in theFileTypes) and
      (DirectoryExists(theFileName)) or (shft_Url in theFileTypes) and (tbs_UrlIsValidUrl(theFileName)) or
      (shft_Wia in theFileTypes) or (shft_Other in theFileTypes);

  end;

var
  i: integer;
  bCopy, bCut: boolean;
begin
  bCopy := Assigned(theFilesToCopy);
  bCut := Assigned(theFilesToCut);
  if bCopy then
    theFilesToCopy.Clear;

  if bCut then
    theFilesToCut.Clear;

  for i := 0 to fItems.count - 1 do
  begin
    if CanInclude(Item[i].filename) then
    begin
      if bCopy and (Item[i].OperationType = coCopy) then
        theFilesToCopy.Add(Item[i].filename)
      else if bCut and (Item[i].OperationType = coCut) then
        theFilesToCut.Add(Item[i].filename);
    end;
  end;
end;

procedure TTB_Shell_ClipboardRecord.GetFiles(theFiles: TStringlist; theFileTypes: TTB_Shell_FileTypes);
  function CanInclude(theFileName: string): boolean;
  begin
    Result := (shft_File in theFileTypes) and (fileexists(theFileName)) or (shft_Folder in theFileTypes) and
      (DirectoryExists(theFileName)) or (shft_Url in theFileTypes) and (tbs_UrlIsValidUrl(theFileName)) or
      (shft_Wia in theFileTypes) or (shft_Other in theFileTypes);

  end;

var
  i: integer;
begin
  if not Assigned(theFiles) then
    exit;

  theFiles.Clear;

  for i := 0 to fItems.count - 1 do
  begin
    if CanInclude(Item[i].filename) then
    begin
      theFiles.Add(Item[i].filename);
    end;
  end;
end;

function TTB_Shell_ClipboardRecord.GetHasFiles: boolean;
begin
  Result := fItems.count > 0;
end;

function TTB_Shell_ClipboardRecord.GetItem(idx: integer): TTB_Shell_ClipboardItem;
begin
  Result := TTB_Shell_ClipboardItem(fItems[idx]);
end;

procedure TTB_Shell_ClipboardRecord.SetInternalMode;
begin
  fInternalMode := True;
end;

procedure TTB_Shell_ClipboardRecord.UnSetInternalMode;
begin
  fInternalMode := False;
end;

{ TTB_Shell_ClipboardItem }

constructor TTB_Shell_ClipboardItem.Create(theFileName: string; theOperationType: TTB_Shell_ClipboardOperation);
begin
  fFileName := theFileName;
  fOperationType := theOperationType;
end;

procedure InitConst;
begin
  with TBSHELLCONST_DEFRENAMEFORMAT_FILES do // file rename format
  begin
    RenameOptions := rf_donotrename;
    UseExifDate := True;
    ChangeExt := False;
    NewExt := '';
    FixedStr := '';
    Sep_Main := TBCONST_RENAMEFORMAT_MAIN_FILE_SEPARATOR;
    Sep_Date := TBCONST_RENAMEFORMAT_DATESEPARATOR;
    Sep_Time := TBCONST_RENAMEFORMAT_TIMESEPARATOR;
    Sep_FileSubject := TBCONST_RENAMEFORMAT_SUBJECTSEPARATOR;
    Sep_FileAuthor := TBCONST_RENAMEFORMAT_AUTHORSEPARATOR;
    DateFormat := TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM_DD;
    TimeFormat := TBCONST_RENAMEFORMAT_TIMEFORMAT_HH_NN_SS_ZZZ;
  end;

  with TBSHELLCONST_DEFRENAMEFORMAT_FOLDERS do // folder rename format
  begin
    RenameOptions := rfd_Date_Subject;
    UseExifDate := True;
    FixedStr := '';
    Sep_Main := TBCONST_RENAMEFORMAT_MAIN_FOLDER_SEPARATOR;
    Sep_Date := TBCONST_RENAMEFORMAT_DATESEPARATOR;
    Sep_Time := TBCONST_RENAMEFORMAT_TIMESEPARATOR;
    Sep_Subject := TBCONST_RENAMEFORMAT_SUBJECTSEPARATOR;
    DateFormat := TBCONST_RENAMEFORMAT_DATEFORMAT_YYYY_MM_DD;
  end;

  TBSHELLCONST_EMPTYRENAMEFORMAT_FILES := TBSHELLCONST_DEFRENAMEFORMAT_FILES;
  TBSHELLCONST_EMPTYRENAMEFORMAT_FOLDERS := TBSHELLCONST_DEFRENAMEFORMAT_FOLDERS;
end;

initialization

InitConst;
tbs_specialFoldersCS := TCriticalSection.Create;
tbs_ShellIconsCS := TCriticalSection.Create;
tbs_specialFolders := TStringlist.Create;
tbs_GetSpecialFolders(tbs_specialFolders);

finalization

tbs_ShellIconsCS.free;
tbs_specialFolders.free;
tbs_specialFoldersCS.free;

end.
