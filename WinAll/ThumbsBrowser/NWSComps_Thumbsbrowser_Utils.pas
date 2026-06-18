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
unit NWSComps_ThumbsBrowser_utils;
{$R-}
{$Q-}
{$J+}

interface

{$I ..\_inc\NWSComps_Shared.inc}
{$IFDEF IMAGEEN_5_2_LATER}
{$IFDEF NWSCOMPS_DELPHI2005_UPPER}
{$DEFINE NWSCOMPS_TB_METADATA_USEHELPERS}
{$ENDIF}
{$ENDIF}

uses Windows, Messages, SysUtils, Classes, graphics, dialogs, math, syncobjs,
  iesettings, hyieutils, hyiedefs, imageenio, imageenproc,
{$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF}
{$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
  iexMetahelpers,
{$ELSE}
  iexEXIFRoutines,
  iexIPTCRoutines,
  iexDICOMRoutines,
{$ENDIF}
  NWSComps_ThumbsBrowser_const,
  NWSComps_ThumbsBrowser_Utils_Types;

{$IFNDEF IMAGEEN_6_2_LATER}

type
  TIOParams = TIOParamsVals;
{$ENDIF}

type
  TTBArrayStr = Array Of string;

const
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
  CF_PreferredDropEffect_Str = 'Preferred DropEffect';

function TBCoCreateGuid(out guid: TGUID): HResult; stdcall; external 'ole32.dll' name 'CoCreateGuid';

procedure TBFreeCS(theCS: TCriticalSection);
function TBEnterCS(theCS: TCriticalSection): boolean;
procedure TBLeaveCS(theCS: TCriticalSection);

function TBGetSourceTypes_Loadable: TTB_SourceTypes;
function TBGetSourceTypes_NonFileSystem: TTB_SourceTypes;
function TBGetSourceTypes_FileSystem: TTB_SourceTypes;
function TBGetSourceTypes_WPD: TTB_SourceTypes;
function TBGetSourceTypes_AllEXCEPT(excludeTypes: TTB_SourceTypes): TTB_SourceTypes;

function TBGetValidColor(const theColor: TColor): TColor;
procedure TBFileFormat_GetEmptyFormat(var theFormat: TTB_Browser_FileFormat);

function TBCompareNatural(s1, s2: String; const IsFile: boolean = false): Integer; // by Roy M Klever

procedure tbFitDisplay(var w, h: cardinal; maxw, maxh: Integer);
function TBCheckandAddPath(thepath: string; var thepathlist: Tstringlist): boolean;

Function TBGetOppositeEXIFOrientation(Orientation: Integer): Integer;

function TBDetectSameOrientation(OrigThumbWidth, OrigThumbHeight, OrigFullBmpWidth, OrigFullBmpHeight: integer): boolean; overload;
function TBDetectSameOrientation(OrigThumbBmp: TIEBitmap; OrigFullBmp: TIEBitmap): boolean; overload;
function TBDetectSameOrientation(OrigThumbBmp: TIEBitmap; filename: string): boolean; overload;
function TBDetectSameOrientation(filename: string; bAdvanced: boolean): boolean; overload;
function TBDetectSameOrientation(aio: TImageenio; filename: string; bLoadParamsFromFile: boolean;
  OrigFullBmp: TIEBitmap): boolean; overload;
procedure TBAdjustEXIFOrientation(bmp: TIEBitmap; Orientation: Integer);

procedure TBLoadFromFile(abmp: TIEBitmap; srcname: string; bQuickLoad: boolean); overload;
procedure TBLoadFromFile(io: TImageenio; srcname: string; bQuickLoad: boolean); overload;

function TBLoadFromUrl(abmp: TIEBitmap; srcname: string; const theProxyAddress: string = '';
  const theProxyUser: string = ''; const theProxyPassword: string = ''): boolean; overload;
function TBLoadFromUrl(io: TImageenio; srcname: string): boolean; overload;

function TBTransferFromUrlToFile(srcname: string; destname: string; const theProxyAddress: string = '';
  const theProxyUser: string = ''; const theProxyPassword: string = ''): boolean;
procedure TBSavetoFile(io: TImageenio; destname: string);

function TBGetPercent(value, minvalue, maxvalue: Integer): Integer;

function TBGetCap_Count(aSet: TTB_Thumb_CaptionsSettings): Integer;
function TBIdxIsinRange(theList: TList; idx: Integer): boolean;
function TBGenerateUniquename(fname: string; ftime: Tdatetime; fsize: Integer): string;
function TBIsPointInRect(const thepoint: tpoint; const therect: trect): boolean;
function TBListFindString(text: string; slist: TStrings): Integer;
function TBStringInList(text: string; slist: TStrings): boolean;
function TBStringinArray(text: string; const strarray: array of string): boolean;

function TBFileFormatGetArrayIdx(ff: TTB_Browser_FileFormat; const ffarray: array of TTB_Browser_FileFormat): Integer;
function TBFileFormatGetFromExtension(ext: string; const ffarray: array of TTB_Browser_FileFormat)
  : TTB_Browser_FileFormat;

function TBDateTimeAddTime(SrcDT: Tdatetime; SrcTime: Tdatetime): Tdatetime;

function TBFileTimeToDateTime(const FileTime: TFileTime): Tdatetime;
function TBInvertColor(const theColor: TColor): TColor;
procedure TBListcopy(src: TList; var dst: TList);
procedure TBStringListcopy(src: Tstringlist; var dst: Tstringlist);

procedure TBInjectRotatedExifBitmap(filename: string; angle: Integer);
procedure TBCorrectTiffOrientation(const srcname: string; const Orientation: Integer);
procedure TBCorrectJpegOrientationLossless(const srcname: string; const Orientation: Integer);
procedure TBRecreateExifBitmap(filename: string; forceRecreate: boolean);

function TBMetadataCanWriteToFile(filename: string; params: TIOParams; bCompareExtension: boolean): boolean;
procedure TBMetaDataModify(theIo: TImageenio; fields: TThumbsbrowser_MetaData_FieldsList);
procedure TBMetadataInjectToFile(destname: string; const bExif, bIptc: boolean;
  fields: TThumbsbrowser_MetaData_FieldsList);

procedure TBBeginProfile;
procedure TBEndProfile;

function TBSplitString(text: String; const Delimiter: string): TTBArrayStr;

function TBGetRectWidth(aRect: trect): Integer;
function TBGetRectHeight(aRect: trect): Integer;
function TBGetFR(aRect: trect): trect;

procedure TBSortStringList(sl: Tstringlist; const bDescending: boolean);

function TBDeleteFileList(Files: string; const bConfirmDelete: boolean = true;
                          const bRecycle: boolean = false): Integer;
function TBRecycleFileList(Files: string): Integer;

function TBCopyFile(sourcename, destname: string; bFailIfExists: boolean): boolean;

function TBMoveFileList(Files: string; DestDir: string; theFlags: integer = 0): Integer;
function TBCopyFileList(Files: string; DestDir: string; theFlags: integer = 0): Integer;

function TBCopyFilenamesToClipboard(theHandle: HWND; Filenames: TStrings): boolean;
function TBCutFilenamesToClipboard(theHandle: HWND; Filenames: TStrings): boolean;
procedure TBPasteFilenamesFromClipboard(theHandle: HWND; Filenames: TStrings; out bMoveFiles: boolean);

procedure TBGetFilesinFolder(fl: TStrings; thefolder: string);
function TBFileListToShellParamStr(FileList: TStrings): string;
procedure TBExtractUrlsFromFileList(FileList: TStrings; Urls: TStrings);
procedure TBExtractWIAFromFileList(FileList: TStrings; Wias: TStrings);
procedure TBExtractWPDFromFileList(FileList: TStrings; Wpds: TStrings);
procedure TBExtractPureFileList(FileList: TStrings; Files: TStrings);

procedure TBGetFoldersRecursively(thefolder: string; theFolderRecursionList: Tstringlist);

implementation

uses // {$IFDEF IMAGEEN_5_0_LATER}  iexWindowsFunctions, {$ENDIF}
  shlobj, shellapi, ActiveX, clipbrd, NWSComps_ThumbsBrowser_Shell_Utils;

var
    tbtickcount: Integer;


function TBSplitString(text: String; const Delimiter: string): TTBArrayStr;
var
  intIdx: Integer;
  intIdxOutput: Integer;
begin
  intIdxOutput := 0;
  SetLength(Result, 1);
  Result[0] := '';

  for intIdx := 1 to Length(text) do
  begin
    if text[intIdx] = Delimiter then
    begin
      intIdxOutput := intIdxOutput + 1;
      SetLength(Result, Length(Result) + 1);
    end
    else
      Result[intIdxOutput] := Result[intIdxOutput] + text[intIdx];
  end;
end;

function TBGetRectWidth(aRect: trect): Integer;
begin
  Result := aRect.Right - aRect.Left + 1;
end;

function TBGetRectHeight(aRect: trect): Integer;
begin
  Result := aRect.Bottom - aRect.Top + 1;
end;

function TBGetFR(aRect: trect): trect;
begin
  Result := aRect;
  Result.Right := Result.Right + 1;
  Result.Bottom := Result.Bottom + 1;
end;

function SC_Asc(List: Tstringlist; Index1, Index2: Integer): Integer;
begin
  Result := AnsiCompareStr(List[Index1], List[Index2]); // Will sort in normal order
end;

function SC_Desc(List: Tstringlist; Index1, Index2: Integer): Integer;
begin
  Result := AnsiCompareStr(List[Index2], List[Index1]); // Will sort in reverse order
end;

procedure TBSortStringList(sl: Tstringlist; const bDescending: boolean);
begin
  if bDescending then
    sl.CustomSort(SC_Desc)
  else
    sl.CustomSort(SC_Asc);
end;

Function TBGetOppositeEXIFOrientation(Orientation: Integer): Integer;
begin
  Result := 0;
  case Orientation of
    5: // 0th row = left-hand side of the image, 0th column = visual top.
      begin
        Result := 7;
      end;
    6: // 0th row = right-hand side of the image, 0th column = visual top.
      begin
        Result := 8;
      end;
    7: // 0th row = right-hand side of the image, 0th column = visual bottom.
      begin
        Result := 5;
      end;
    8: // 0th row = left-hand side of the image, 0th column = visual bottom.
      begin
        Result := 6;
      end;
  end;

end;

function TBDetectSameOrientation(OrigThumbBmp: TIEBitmap; filename: string): boolean;
var
  aio: TImageenio;
begin
  Result := false;
  aio := TImageenio.create(nil);
  try
    if aio.LoadFromFileAuto(filename) then
      Result := TBDetectSameOrientation(OrigThumbBmp, aio.AttachedIEBitmap);
  finally
    aio.free;
  end;
end;

function TBDetectSameOrientation(filename: string; bAdvanced: boolean): boolean;
var
  aio: TImageenio;
begin
  Result := false;
  aio := TImageenio.create(nil);
  try
    if bAdvanced then
    begin
      if aio.LoadFromFileAuto(filename) then
        Result := TBDetectSameOrientation(aio, filename, false, aio.AttachedIEBitmap);
    end
    else
    begin
      if aio.ParamsFromFile(filename) then
        Result := TBDetectSameOrientation(aio, filename, false, nil);
    end;
  finally
    aio.free;
  end;
end;

function TBDetectSameOrientation(aio: TImageenio;
                                 filename: string;
                                 bLoadParamsFromFile: boolean;
                                 OrigFullBmp: TIEBitmap): boolean;
var
  thumbBmp: TIEBitmap;
begin
  Result := false;

  if bLoadParamsFromFile or (comparetext(aio.params.filename, filename) <> 0) or (not aio.params.EXIF_HasEXIFData) then
    aio.ParamsFromFile(filename);

  if not aio.params.EXIF_HasEXIFData then
    EXIT;

  if (aio.params.EXIF_Bitmap <> nil) and (aio.params.EXIF_Bitmap.Width <> 0) then
    thumbBmp := aio.params.EXIF_Bitmap
  else
  begin
    aio.params.GetThumbnail := true;
    aio.LoadFromFile(filename);
    thumbBmp := aio.AttachedIEBitmap;
  end;

  if thumbBmp = nil then
    Result := FALSE
  else if OrigFullBmp = nil then
    Result := TBDetectSameOrientation(thumbBmp.width, thumbBmp.height, aio.Params.Width, aio.Params.Height)
  else
    Result := TBDetectSameOrientation(thumbBmp, OrigFullBmp);
end;


function TBDetectSameOrientation(OrigThumbWidth, OrigThumbHeight, OrigFullBmpWidth, OrigFullBmpHeight: integer): boolean;
begin
  if (OrigFullBmpWidth=0) or (OrigFullBmpHeight = 0) or
     (OrigThumbWidth=0) or (OrigThumbHeight = 0) then
  begin
    result := FALSE;
    EXIT;
  end;

  result :=  abs((OrigFullBmpWidth / OrigFullBmpHeight) -
          (OrigThumbWidth/OrigThumbHeight)) <= 0.25; //ample margin!!!

  if not Result then
    if (OrigThumbWidth = OrigThumbHeight) then
      RESULT := TRUE;  //maybe the thumbnail is a Square uniform background
                        //and the picture is fitted therein
                        //in this single case we assume the orientation is correct
end;

function TBDetectSameOrientation(OrigThumbBmp: TIEBitmap; OrigFullBmp: TIEBitmap): boolean;
var
  proc: TImageenProc;
  bmp1, bmp2: TIEBitmap;
begin
  result := FALSE;
  if (OrigThumbBmp = nil) or (OrigFullBmp = nil) then
    EXIT;

  result := TBDetectSameOrientation(OrigThumbBmp.width, OrigThumbBmp.Height, OrigFullBmp.width, OrigFullBmp.Height);
  if (not result)  then
    EXIT;

  {
  if (OrigFullBmp.Width=0) or (OrigFullBmp.Height = 0) or
     (OrigThumbBmp.Width=0) or (OrigThumbBmp.Height = 0) then
  begin
    result := FALSE;
    EXIT;
  end;
  }

  proc := TImageenProc.create(nil);
  bmp1 := TIEBitmap.create;
  bmp2 := TIEBitmap.create;
  try
    bmp1.assign(OrigThumbBmp);
    bmp1.PixelFormat := ie24RGB;

    bmp2.assign(OrigFullBmp);
    bmp2.PixelFormat := ie24RGB;

    proc.AttachedIEBitmap := bmp2;
    if OrigFullBmp.Width / OrigFullBmp.height > OrigThumbBmp.Width / OrigThumbBmp.height then
      proc.Resample(OrigThumbBmp.Width, round(OrigThumbBmp.Width * OrigFullBmp.height / OrigFullBmp.Width))
    else
      proc.Resample(round(OrigThumbBmp.height * OrigFullBmp.Width / OrigFullBmp.height), OrigThumbBmp.height);

    bmp2.DrawToTIEBitmap(bmp1, (bmp1.Width - bmp2.Width) div 2, (bmp1.Height - bmp2.Height) div 2);
    bmp2.Assign(OrigThumbBmp);

    proc.AttachedIEBitmap := bmp1;
    Result := proc.CompareWith(bmp2, nil) > 0.95;

  finally
    bmp1.free;
    bmp2.free;
    proc.free;
  end;

  {
  proc := TImageenProc.create(nil);
  bmp1 := TIEBitmap.create;
  bmp2 := TIEBitmap.create;
  try
    bmp1.assign(OrigFullBmp);
    bmp1.PixelFormat := ie24RGB;
    bmp2.assign(OrigThumbBmp);
    bmp2.PixelFormat := ie24RGB;

    proc.AttachedIEBitmap := bmp1;
    proc.Resample(OrigThumbBmp.Width, OrigThumbBmp.height);
    Result := proc.CompareWith(bmp2, nil) > 0.95;
  finally
    bmp1.free;
    bmp2.free;
    proc.free;
  end;
  }

end;

procedure TBAdjustEXIFOrientation(bmp: TIEBitmap; Orientation: Integer);
begin
  if (Orientation <> 1) then
  begin
    case Orientation of
      2: // 0th row = top of the image, 0th column = right-hand side.
        begin
          _FlipEx(bmp, fdHorizontal);
        end;
      3: // 0th row = bottom of the image, 0th column = right-hand side.
        begin
          _FlipEx(bmp, fdVertical);
          _FlipEx(bmp, fdHorizontal);
        end;
      4: // 0th row = bottom of the image, 0th column = left-hand side.
        begin
          _FlipEx(bmp, fdVertical);
        end;
      5: // 0th row = left-hand side of the image, 0th column = visual top.
        begin
          _FlipEx(bmp, fdHorizontal);
          _RotateEx(bmp, 90, false, creatergb(0, 0, 0), nil, nil);
        end;
      6: // 0th row = right-hand side of the image, 0th column = visual top.
        begin
          _RotateEx(bmp, -90, false, creatergb(0, 0, 0), nil, nil);
        end;
      7: // 0th row = right-hand side of the image, 0th column = visual bottom.
        begin
          _FlipEx(bmp, fdHorizontal);
          _RotateEx(bmp, -90, false, creatergb(0, 0, 0), nil, nil);
        end;
      8: // 0th row = left-hand side of the image, 0th column = visual bottom.
        begin
          _RotateEx(bmp, 90, false, creatergb(0, 0, 0), nil, nil);
        end;
    end;
  end;
end;

procedure tbFitDisplay(var w, h: cardinal; maxw, maxh: Integer);
var
  r: single;
begin
  r := w / h;
  if h / maxh > w / maxw then
  begin
    h := maxh;
    w := round(r * h);
  end
  else
  begin
    w := maxw;
    h := round(1 / r * w);
  end;
end;

function TBCheckandAddPath(thepath: string; var thepathlist: Tstringlist): boolean;
var
  i: Integer;
  testfound: boolean;
begin
  testfound := false;
  thepath := IncludeTrailingPathDelimiter(thepath);
  for i := 0 to thepathlist.count - 1 do
    if comparetext(thepath, thepathlist[i]) = 0 then
    begin
      testfound := true;
      break;
    end;
  if not testfound then
    thepathlist.Add(thepath);

  Result := not testfound;
end;

procedure TBLoadFromFile(abmp: TIEBitmap; srcname: string; bQuickLoad: boolean);
var
  io: TImageenio;
begin
  io := TImageenio.create(nil);
  try
    io.params.RAW_QuickInterpolate := false;
    io.AttachedIEBitmap := abmp;
    TBLoadFromFile(io, srcname, bQuickLoad);
  finally
    io.free;
  end;
end;

procedure TBLoadFromFile(io: TImageenio; srcname: string; bQuickLoad: boolean);
var
  bcms_enabled: boolean;
begin
  with io do
  begin
{$IFDEF IMAGEEN_6_2_LATER}
    if FindFileFormat(srcname, ffContentOnly) = ioUnknown then
    begin
      EXIT;
    end;
{$ENDIF}
    params.ICO_Background := creatergb(255, 255, 255);

    with params do
    begin
      RAW_QuickInterpolate := bQuickLoad; // for quick loading
      RAW_UseAutoWB := false;
      RAW_UseCameraWB := true;
      RAW_FourColorRGB := false;
      RAW_AutoAdjustColors := false;

      RAW_GetExifThumbnail := io.params.GetThumbnail;

    end;

    if params.GetThumbnail then
    begin
      LoadFromFileAuto(srcname);
    end
    else
    begin
      params.OutputICCProfile.Assign_sRGBProfile;

{$IFDEF IMAGEEN_5_0_LATER}
      bcms_enabled := IEGlobalSettings().EnableCMS;
      IEGlobalSettings().EnableCMS := true;
{$ELSE}
      bcms_enabled := iegEnableCMS;
      iegEnableCMS := true;
{$ENDIF}
      try

        LoadFromFile(srcname);
      finally
{$IFDEF IMAGEEN_5_0_LATER}
        IEGlobalSettings().EnableCMS := bcms_enabled;
{$ELSE}
        iegEnableCMS := bcms_enabled;
{$ENDIF}
      end;
    end;

  end;
end;

function TBLoadFromUrl(abmp: TIEBitmap; srcname: string; const theProxyAddress: string = '';
  const theProxyUser: string = ''; const theProxyPassword: string = ''): boolean;
var
  aio: TImageenio;
begin
  Result := false;

  aio := TImageenio.create(nil);
  aio.ProxyAddress := theProxyAddress;
  aio.ProxyUser := theProxyUser;
  aio.ProxyPassword := theProxyPassword;
  aio.AttachedIEBitmap := abmp;
  try
    Result := TBLoadFromUrl(aio, srcname);
  finally
    freeandnil(aio);
  end;
end;

function TBLoadFromUrl(io: TImageenio; srcname: string): boolean;
begin
  Result := false;
  if IEGetURLTypeW(srcname) = ieurlUNKNOWN then
    EXIT;

  Result := io.LoadFromURL(srcname);
end;

function TBTransferFromUrlToFile(srcname: string; destname: string; const theProxyAddress: string = '';
  const theProxyUser: string = ''; const theProxyPassword: string = ''): boolean;
var
  ms: TMemoryStream;
  FileExt: string;
  bAborting: boolean;
  aio: TImageenio;
begin
  Result := false;

  bAborting := false;
  aio := TImageenio.create(nil);
  ms := TMemoryStream.create;
  try
    if IEGetFromURL(srcname, ms, theProxyAddress, theProxyUser, theProxyPassword, nil, nil, @bAborting, FileExt) then
    begin
      ms.Position := 0;

      ms.SaveToFile(destname);
      Result := true;
    end;

  finally
    freeandnil(ms);
    aio.free;
  end;
end;

procedure TBSavetoFile(io: TImageenio; destname: string);
begin
  if assigned(io.params.foutputicc) then
    freeandnil(io.params.foutputicc);
  if assigned(io.params.finputIcc) then
    freeandnil(io.params.finputIcc);
  io.params.JPEG_MarkerList.clear;

  with io.params do
  begin

  end;

  io.SaveToFile(destname);
end;

function TBGetPercent(value, minvalue, maxvalue: Integer): Integer;
var
  d: Integer;
begin
  d := (maxvalue - minvalue);
  if d < 0 then
    Result := 0
  else if d = 0 then
    Result := 100
  else
    Result := round((value - minvalue + 1) / (d + 1) * 100);
end;

function TBGetCap_Count(aSet: TTB_Thumb_CaptionsSettings): Integer;
var
  cap: TTB_Thumb_CaptionsSetting;
begin
  Result := 0;

  for cap := Low(TTB_Thumb_CaptionsSetting) to High(TTB_Thumb_CaptionsSetting) do
  begin
    if TTB_Thumb_CaptionsSetting(cap)<> cap_Empty then
      Result := Result + ord(cap in aSet);
  end;
end;

function TBIdxIsinRange(theList: TList; idx: Integer): boolean;
begin
  Result := false;
  if not assigned(theList) then
    EXIT;

  Result := (idx >= 0) and (idx < theList.count);
end;

function TBGenerateUniquename(fname: string; ftime: Tdatetime; fsize: Integer): string;
begin
  Result := '';
  Result := Result + fname + DateTimeToStr(ftime) + inttostr(fsize);
end;

function TBIsPointInRect(const thepoint: tpoint; const therect: trect): boolean;
begin
  Result := (thepoint.x >= therect.Left) and (thepoint.x <= therect.Right) and (thepoint.y >= therect.Top) and
    (thepoint.y <= therect.Bottom);
end;

function TBListFindString(text: string; slist: TStrings): Integer;
var
  ix: Integer;
begin
  Result := -1;
  if not assigned(slist) then
    EXIT;
  text := Trim(text);
  for ix := 0 to slist.count - 1 do // CompareText is faster than Like!
    if comparetext(Trim(slist[ix]), text) = 0 then
    begin
      Result := ix;
      break;
    end;
end;

function TBStringInList(text: string; slist: TStrings): boolean;
begin
  Result := TBListFindString(text, slist) >= 0;
end;

function TBStringinArray(text: string; const strarray: array of string): boolean;
var
  ix: Integer;
begin

  Result := false;
  text := Trim(text);
  for ix := low(strarray) to high(strarray) do
    if comparetext(Trim(strarray[ix]), text) = 0 then
    begin
      Result := true;
      break;
    end;

end;

// v.1.0.1
function TBFileFormatGetArrayIdx(ff: TTB_Browser_FileFormat; const ffarray: array of TTB_Browser_FileFormat): Integer;
var
  ix: Integer;
begin
  Result := -1;

  for ix := low(ffarray) to high(ffarray) do
    if comparetext(ffarray[ix].extension, ff.extension) = 0 then
    begin
      Result := ix;
      break;
    end;

end;

function TBFileFormatGetFromExtension(ext: string; const ffarray: array of TTB_Browser_FileFormat)
  : TTB_Browser_FileFormat;
var
  ix: Integer;
begin
  Result.extension := ext;
  ix := TBFileFormatGetArrayIdx(Result, ffarray);
  if ix = -1 then
    Result.extension := ''
  else
    Result := ffarray[ix];
end;
// v.1.0.1

(* *)

function TBDateTimeAddTime(SrcDT: Tdatetime; SrcTime: Tdatetime): Tdatetime;
var
  hr, min, sec, ms: word;
begin

  Decodetime(SrcTime, hr, min, sec, ms);

  Result := SrcDT + hr / 24 + min / 1440 + sec / 86400 + ms / 86400000;

end;

function TBFileTimeToDateTime(const FileTime: TFileTime): Tdatetime;
const
  FileTimeStep: Extended = 24.0 * 60.0 * 60.0 * 1000.0 * 1000.0 * 10.0; // 100 nSek per Day
  FileTimeBase = -109205.0;
begin
  Result := Int64(FileTime) / FileTimeStep;
  Result := Result + FileTimeBase;
end;

function TBInvertColor(const theColor: TColor): TColor;
begin
  Result := rgb(255 - getrvalue(theColor), 255 - getgvalue(theColor), 255 - getbvalue(theColor))
end;

procedure TBListcopy(src: TList; var dst: TList);
var
  i: Integer;
begin
  if dst = nil then
    EXIT;
  if src = nil then
  begin
    dst := nil;
    EXIT;
  end;
  dst.clear;
  for i := 0 to Pred(src.count) do
    dst.Add(src.Items[i]);
end;

procedure TBStringListcopy(src: Tstringlist; var dst: Tstringlist);
var
  i: Integer;
  s: string;
begin
  if dst = nil then
    EXIT;
  if src = nil then
  begin
    dst := nil;
    EXIT;
  end;
  dst.clear;
  for i := 0 to Pred(src.count) do
  begin
    s := src[i];
    dst.Add(s);
  end;
end;

procedure TBInjectRotatedExifBitmap(filename: string; angle: Integer);
var
  io: TImageenio;
  iproc: TImageenProc;
  abmp: TIEBitmap;
  test_bmpFailed: boolean;
begin
  test_bmpFailed := false;
  io := TImageenio.create(nil);
  try
    io.ParamsFromFile(filename);
    if (io.params.EXIF_HasEXIFData) then
    begin
      if (assigned(io.params.EXIF_Bitmap) and (io.params.EXIF_Bitmap.Width <> 0) and (io.params.EXIF_Bitmap.height <> 0))
      then
      begin
        abmp := TIEBitmap.create;
        iproc := TImageenProc.create(nil);
        try
          abmp.assign(io.params.EXIF_Bitmap);
          iproc.AttachedIEBitmap := abmp;
          iproc.Rotate(angle);
          io.params.EXIF_Bitmap.assign(abmp);
          io.params.EXIF_Orientation := 1;
        finally
          iproc.free;
          abmp.free;
        end;

        io.InjectJpegEXIF(filename);
      end
      else
        test_bmpFailed := true;
    end;
  finally
    io.free;
  end;

  if test_bmpFailed then
    TBRecreateExifBitmap(filename, true);

end;

procedure TBRevertJpegLosslessTransform(const srcname: string; transform: TIEJpegTransform);
begin
  // this function in case of an error will try to restore the original jpeg
  if transform = jtHorizFlip then
    JpegLosslessTransform2(srcname, jtHorizFlip, false, jcCopyAll, rect(0, 0, 0, 0))
  else if transform = jtVertFlip then
    JpegLosslessTransform2(srcname, jtVertFlip, false, jcCopyAll, rect(0, 0, 0, 0))
  else if transform = jtRotate90 then // correct the rotation
    JpegLosslessTransform2(srcname, jtRotate270, false, jcCopyAll, rect(0, 0, 0, 0))
  else if transform = jtRotate270 then // correct the rotation
    JpegLosslessTransform2(srcname, jtRotate90, false, jcCopyAll, rect(0, 0, 0, 0));
end;

procedure TBCorrectJpegOrientationLossless(const srcname: string; const Orientation: Integer);
type
  jtTransformArray = array of TIEJpegTransform;

  procedure AddTransform(var transArray: jtTransformArray; transf: TIEJpegTransform);
  begin
    SetLength(transArray, Length(transArray) + 1);
    transArray[high(transArray)] := transf;
  end;

var
  aio: TImageenio;
  appliedTransf, successTransf: jtTransformArray;
  i: Integer;
begin
  if not tbs_FileExtIsJPG(extractfileext(srcname)) then
    EXIT;

  if (Orientation <= 1) then
    EXIT;

  SetLength(appliedTransf, 0);
  SetLength(successTransf, 0);
  aio := TImageenio.create(nil);
  try
    case Orientation of
      2: // 0th row = top of the image, 0th column = right-hand side.
        begin
          AddTransform(successTransf, jtHorizFlip);

          if JpegLosslessTransform2(srcname, jtHorizFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtHorizFlip);
        end;
      3: // 0th row = bottom of the image, 0th column = right-hand side.
        begin
          AddTransform(successTransf, jtHorizFlip);
          AddTransform(successTransf, jtVertFlip);
          if JpegLosslessTransform2(srcname, jtHorizFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtHorizFlip);

          if JpegLosslessTransform2(srcname, jtVertFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtVertFlip);
        end;
      4: // 0th row = bottom of the image, 0th column = left-hand side.
        begin
          AddTransform(successTransf, jtVertFlip);
          if JpegLosslessTransform2(srcname, jtVertFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtVertFlip);
        end;
      5: // 0th row = left-hand side of the image, 0th column = visual top.
        begin
          AddTransform(successTransf, jtHorizFlip);
          AddTransform(successTransf, jtRotate270);
          if JpegLosslessTransform2(srcname, jtHorizFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtHorizFlip);

          if JpegLosslessTransform2(srcname, jtRotate270, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtRotate270);
          // warning!! ie has inconsistency in the convention of angles: ie 90 = jpeg 270 and ie 270 = jpeg 90
          { corresponds to
            _FlipEx(thumb_bitmap, fdHorizontal);
            _RotateEx(thumb_bitmap, 90, false, creatergb(0, 0, 0), nil, nil);
          }
        end;
      6: // 0th row = right-hand side of the image, 0th column = visual top.
        begin
          AddTransform(successTransf, jtRotate90);
          if JpegLosslessTransform2(srcname, jtRotate90, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtRotate90);
          // warning!! ie has inconsistency in the convention of angles: ie 90 = jpeg 270 and ie 270 = jpeg 90
          { corresponds to
            _RotateEx(thumb_bitmap, 270, false, creatergb(0, 0, 0), nil, nil);
          }
        end;
      7: // 0th row = right-hand side of the image, 0th column = visual bottom.
        begin
          AddTransform(successTransf, jtHorizFlip);
          AddTransform(successTransf, jtRotate90);
          if JpegLosslessTransform2(srcname, jtHorizFlip, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtHorizFlip);

          if JpegLosslessTransform2(srcname, jtRotate90, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtRotate90);

          // warning!! ie has inconsistency in the convention of angles: ie 90 = jpeg 270 and ie 270 = jpeg 90
          { corresponds to
            _FlipEx(thumb_bitmap, fdHorizontal);
            _RotateEx(thumb_bitmap, 270, false, creatergb(0, 0, 0), nil, nil);
          }
        end;
      8: // 0th row = left-hand side of the image, 0th column = visual bottom.
        begin
          AddTransform(successTransf, jtRotate270);
          if JpegLosslessTransform2(srcname, jtRotate270, false, jcCopyAll, rect(0, 0, 0, 0)) then
            AddTransform(appliedTransf, jtRotate270);
          // warning!! ie has inconsistency in the convention of angles: ie 90 = jpeg 270 and ie 270 = jpeg 90
          { corresponds to
            _RotateEx(thumb_bitmap, 90, false, creatergb(0, 0, 0), nil, nil);
          }
        end;
    end;

    if Length(appliedTransf) < Length(successTransf) then // error not all transformations were applied
    begin
      for i := high(appliedTransf) downto low(appliedTransf) do
      // revert the applied transformations in reverse order of applying
      begin
        TBRevertJpegLosslessTransform(srcname, appliedTransf[i]);
      end;
      EXIT; // >>>>EXIT
    end;

//    the JpegLosslessTransform will also update the orientation of the exif thumbnail correctly ??

    aio.ParamsFromFile(srcname);
    aio.params.EXIF_Orientation := 1;
    aio.InjectJpegEXIF(srcname);

  finally
    aio.free;
  end;

end;

procedure TBCorrectTiffOrientation(const srcname: string; const Orientation: Integer);
var
  aio: TImageenio;
  iproc: TImageenProc;

  wDivH: double;
  maxSize: integer;
  aIEBitmap: TIEBitmap;
begin
  if not tbs_FileExtIsTif(extractfileext(srcname)) then
    EXIT;

  if (Orientation <= 1) then
    EXIT;

  aio := TImageenio.create(nil);
  iproc := TImageenProc.create(nil);
  try
    if (aio.LoadFromFile(srcname)) and (aio.Params.TIFF_ImageCount = 1) then
    begin
      iproc.AttachedIEBitmap := aio.AttachedIEBitmap;
      case Orientation of
        2: // 0th row = top of the image, 0th column = right-hand side.
          begin
            iproc.Flip(fdHorizontal);
          end;
        3: // 0th row = bottom of the image, 0th column = right-hand side.
          begin
            iproc.Flip(fdHorizontal);
            iproc.Flip(fdVertical);
          end;
        4: // 0th row = bottom of the image, 0th column = left-hand side.
          begin
            iproc.Flip(fdVertical);
          end;
        5: // 0th row = left-hand side of the image, 0th column = visual top.
          begin
            iproc.Flip(fdHorizontal);
            iproc.Rotate(90);
          end;
        6: // 0th row = right-hand side of the image, 0th column = visual top.
          begin
            iproc.Rotate(270);
          end;
        7: // 0th row = right-hand side of the image, 0th column = visual bottom.
          begin
            iproc.Flip(fdHorizontal);
            iproc.Rotate(270);
          end;
        8: // 0th row = left-hand side of the image, 0th column = visual bottom.
          begin
            iproc.Rotate(90);
          end;
      end;

    {  if aio.params.EXIF_HasEXIFData and assigned(aio.params.EXIF_Bitmap) then
        TBAdjustEXIFOrientation(aio.params.EXIF_Bitmap, Orientation);
    }

      if aio.params.EXIF_HasEXIFData and assigned(aio.params.EXIF_Bitmap) then
      begin
        if TBDetectSameOrientation(aio, srcName, false, nil) then
          TBAdjustEXIFOrientation(aio.params.EXIF_Bitmap, Orientation)
        else
        begin
          aIEBitmap := iproc.AttachedIEBitmap;

          wDivH := aIEBitmap.width / aIEBitmap.height;
          maxSize := max(aio.params.EXIF_Bitmap.Width, aio.params.EXIF_Bitmap.height);
          if aIEBitmap.width > aIEBitmap.height then
             iproc.Resample(maxSize, round(maxSize / wDivH))
          else
             iproc.Resample(round(maxSize * wDivH), maxSize);

          aio.params.EXIF_Bitmap.assign(aIEBitmap);
        end;
      end;


      aio.params.EXIF_Orientation := 1;
      aio.SaveToFile(srcname);
    end;
  finally
    iproc.free;
    aio.free;
  end;

end;

procedure TBRecreateExifBitmap(filename: string; forceRecreate: boolean);
var
  io: TImageenio;
  iproc: TImageenProc;
  abmp: TIEBitmap;
  thsize: Integer;
  ratio_exif, ratio: double;
begin
  io := TImageenio.create(nil);
  try
    io.ParamsFromFile(filename);
    if (io.params.EXIF_HasEXIFData) and assigned(io.params.EXIF_Bitmap) and (io.params.Width <> 0) and
      (io.params.height <> 0) then
    begin
      ratio := io.params.Width / io.params.height;
      if (io.params.EXIF_Bitmap.Width <> 0) and (io.params.EXIF_Bitmap.height <> 0) then
        ratio_exif := io.params.EXIF_Bitmap.Width / io.params.EXIF_Bitmap.height
      else
        ratio_exif := -1;

      thsize := max(io.params.EXIF_Bitmap.Width, io.params.EXIF_Bitmap.height);
      if thsize = 0 then
        thsize := 150;

      if forceRecreate or (ratio_exif < 0) or (abs(ratio - ratio_exif) > 0.3) then
      begin
        abmp := TIEBitmap.create;
        iproc := TImageenProc.create(nil);
        try
          io.AttachedIEBitmap := abmp;
          io.LoadFromFileAuto(filename);
          iproc.AttachedIEBitmap := abmp;
          if ratio > 1 then
            iproc.Resample(thsize, round(1 / ratio * thsize), rfLanczos3)
          else
            iproc.Resample(round(ratio * thsize), thsize, rfLanczos3);

          io.params.EXIF_Bitmap.assign(abmp);
          io.params.EXIF_Orientation := 0;
        finally
          iproc.free;
          abmp.free;
        end;
        io.InjectJpegEXIF(filename);

      end;
    end;
  finally
    io.free;
  end;
end;

function TBMetadataCanWriteToFile(filename: string; params: TIOParams; bCompareExtension: boolean): boolean;

var
  ext: string;
begin
  Result := false;

  if bCompareExtension then
  begin
    ext := extractfileext(filename);
    if tbs_FileExtIsJPG(ext) then
    begin
      Result := true;
    end
    else if tbs_FileExtIsTif(ext) then
    begin
      Result := (params.TIFF_ImageCount = 1) and (not params.TIFF_BigTIFF);
    end
    else
    begin
      Result := false;
    end;
  end
  else
  begin
    if (comparetext(params.filename, filename) <> 0) then
      Result := false
    else if params.FileType = ioJPEG then
    begin
      Result := true;
    end
    else if params.FileType = ioTIFF then
    begin
      Result := (params.TIFF_ImageCount = 1) and (not params.TIFF_BigTIFF);
    end
    else
    begin
      Result := false;
    end;
  end;

end;

procedure TBMetaDataModify(theIo: TImageenio; fields: TThumbsbrowser_MetaData_FieldsList);
var
  i: Integer;
  f: TThumbsbrowser_MetaData_Field;
begin
  for i := 0 to fields.count - 1 do
  begin
    f := fields.Field[i];
    TBMetaDataWriteFieldAsStr(theIo, f.FieldType, f.idx, f.value, fields.MetaTags);
  end;

end;

procedure TBMetadataInjectToFile(destname: string; const bExif, bIptc: boolean;
  fields: TThumbsbrowser_MetaData_FieldsList);
var
  aio: TImageenio;
  fExt: string;
  bJpg, bTiff: boolean;
begin

  if tbs_UrlIsValidUrl(destname) then
    EXIT; // url cannot save
  if not fileexists(destname) then
    EXIT; // file does not exist

  fExt := extractfileext(destname);

  aio := TImageenio.create(nil);
  try
    aio.ParamsFromFile(destname);

    if TBMetadataCanWriteToFile(destname, aio.params, true) then
    begin
      bJpg := aio.params.FileType = ioJPEG;
      bTiff := aio.params.FileType = ioTIFF;

      if bIptc and fields.IPTCModified and bTiff then
      begin
        bTiff := aio.LoadFromFile(destname);
      end;

      TBMetaDataModify(aio, fields); // replace the params with the modified ones

      if bExif and fields.ExifModified and bJpg then
      begin
        aio.params.EXIF_HasEXIFData := true;
        aio.InjectJpegEXIF(destname)
      end
      else if bExif and fields.ExifModified and bTiff then
      begin
        aio.params.EXIF_HasEXIFData := true;
        aio.InjectTIFFEXIF(destname);
      end;

      if bIptc and fields.IPTCModified and bJpg then
        aio.InjectJpegIPTC(destname)
      else if bIptc and fields.IPTCModified and bTiff then
      begin
        aio.SaveToFile(destname);
      end;
    end;
  finally
    aio.free;
  end;

end;

procedure TBBeginProfile;
begin
  tbtickcount := GetTickCount;
end;

procedure TBEndProfile;
begin
  tbtickcount := GetTickCount - tbtickcount;
  showmessage(inttostr(tbtickcount));
end;

function TB_SORT_isDigitChar(a: char): boolean;
begin
  Result := a in ['0' .. '9']

end;

procedure TB_Sort_ExtractNumber(s: string; fromP, Top: Integer; var NewFromP: Integer; var NDigits: Integer;
  var Nr: Integer; var NZeros: Integer; var sNr: string);
var
  i: Integer;
  bStop: boolean;
  L, L_NZ: Int64;
  def_int64: Int64;
  c: char;
  bHasLeadingZeros: boolean;
begin

  NZeros := 0;
  NDigits := 0;
  bHasLeadingZeros := s[fromP] = '0';

  bStop := false;
  i := fromP;
  repeat
    c := s[i];

    if TB_SORT_isDigitChar(c) then
      inc(NDigits)
    else
      bStop := true;

    inc(i);
  until bStop or (i > Top);

  NewFromP := fromP + NDigits + 1;

  if NDigits > 0 then
  begin
    sNr := copy(s, fromP, NDigits);
    def_int64 := round(power(2, 62));
    Nr := StrToInt64Def(sNr, def_int64);
    if bHasLeadingZeros then
    begin
      L := Length(sNr);
      L_NZ := Length(inttostr(Nr));
      NZeros := L - L_NZ;
    end;
  end;

end;

function TBCompareNatural(s1, s2: String; const IsFile: boolean = false): Integer; // by Roy M Klever

  Function Sign(n: Integer): Integer;
  begin
    if n > 0 then
      Result := 1
    else if n < 0 then
      Result := -1
    else
      Result := 0;
  end;

var
  fromP1, toP1, NewfromP1, NDigits1, Nr1, Nzeros1: Integer;
  fromP2, toP2, NewfromP2, NDigits2, Nr2, Nzeros2: Integer;
  sNr1, sNr2: string;
  sExt1, sExt2: string;
begin
  Result := 0;

  if IsFile then
  begin
    sExt1 := extractfileext(s1);
    sExt2 := extractfileext(s2);
    s1 := ChangeFileExt(s1, '');
    s2 := ChangeFileExt(s2, '');
  end;

  s1 := LowerCase(s1);
  s2 := LowerCase(s2);
  toP1 := Length(s1);
  toP2 := Length(s2);

  if (s1 <> s2) and (s1 <> '') and (s2 <> '') then
  begin

    fromP1 := 1;
    fromP2 := 1;
    while (Result = 0) and (fromP1 <= toP1) and (fromP2 <= toP2) do
    begin

      TB_Sort_ExtractNumber(s1, fromP1, toP1, NewfromP1, NDigits1, Nr1, Nzeros1, sNr1);
      if NDigits1 = 0 then // number not found in first string
      begin
        Result := comparestr(s1[fromP1], s2[fromP2]);
        inc(fromP1);
        inc(fromP2);
      end
      else // found number in first string
      begin
        TB_Sort_ExtractNumber(s2, fromP2, toP2, NewfromP2, NDigits2, Nr2, Nzeros2, sNr2);
        if NDigits2 = 0 then // number not found in second string
        begin
          Result := comparestr(s1[fromP1], s2[fromP2]);
          inc(fromP1);
          inc(fromP2);
        end
        else
        begin // found number in second string

          if NDigits1 <> NDigits2 then
          begin
            Result := Sign(NDigits1 - NDigits2);
          end
          else
          begin

            // Compare numbers
            Result := Sign(Nr1 - Nr2);
          end;
          fromP1 := NewfromP1;
          fromP2 := NewfromP2;
        end;
      end;
    end;

  end;

  if Result = 0 then
    Result := Sign(Length(s1) - Length(s2));

  if Result = 0 then
  begin
    if IsFile then
    begin
      Result := comparestr(sExt1, sExt2);
    end;
  end;
end;

procedure TBFreeCS(theCS: TCriticalSection);
begin
{$IFDEF NWSCOMPS_DXE2_UPPER}
  if theCS.TryEnter then
    freeandnil(theCS)
  else
    RegisterExpectedMemoryLeak(theCS);
{$ELSE}
  try
    freeandnil(theCS);
  except
    RegisterExpectedMemoryLeak(theCS);
  end;
{$ENDIF}
end;

function TBEnterCS(theCS: TCriticalSection): boolean;
begin
  try
    theCS.Enter;
    Result := true;
  except
    Result := false;
  end;
end;

procedure TBLeaveCS(theCS: TCriticalSection);
begin
  try
    theCS.Leave;
  except

  end;
end;

function TBGetSourceTypes_Loadable: TTB_SourceTypes;
begin
  Result := [st_FolderNav] + TBGetSourceTypes_FileSystem + TBGetSourceTypes_WPD;
end;

function TBGetSourceTypes_NonFileSystem: TTB_SourceTypes;
begin
  Result := [st_General, st_FolderNav, st_WIA, st_WPDFile, st_WPDFolder];
end;

function TBGetSourceTypes_FileSystem: TTB_SourceTypes;
begin
  Result := [st_File, st_Folder, st_URL];
end;

function TBGetSourceTypes_WPD: TTB_SourceTypes;
begin
  Result := [st_WPDFile, st_WPDFolder];
end;

function TBGetSourceTypes_AllEXCEPT(excludeTypes: TTB_SourceTypes): TTB_SourceTypes;
var
  typ: TTB_SourceType;
begin
  Result := [];
  for typ := Low(TTB_SourceType) to High(TTB_SourceType) do
    if not(typ in excludeTypes) then
      Result := Result + [typ];
end;

function TBGetValidColor(const theColor: TColor): TColor;
begin
  if theColor < 0 then
    Result := GetSysColor(theColor and $000000FF)
  else
    Result := theColor;
end;

procedure TBFileFormat_GetEmptyFormat(var theFormat: TTB_Browser_FileFormat);
begin
  with theFormat do
  begin
    extension := '';
    Description := '';
    IsMultiPicture := false;
    IsVideo := false;
    ReaderFunction := nil;
  end;
end;

function TBDeleteFileList(Files: string; const bConfirmDelete: boolean = true;
                          const bRecycle: boolean = false)
  : Integer;
var
  SHFileOp: TSHFileOpStruct;
begin
  FillChar(SHFileOp, SizeOf(SHFileOp), 0);
  with SHFileOp do
  begin
    wFunc := FO_DELETE; // function
    pFrom := PChar(Files); // file list
    fFlags := 0; // flags
    fFlags := fFlags OR FOF_SILENT;
    if bRecycle then
      fFlags := fFlags or FOF_ALLOWUNDO;
    if not bConfirmDelete then
      fFlags := fFlags or FOF_NOCONFIRMATION;

    lpszProgressTitle := PChar('Delete Files'); // Title
  end;
  Result := SHFileOperation(SHFileOp);

  (*


    Flags that control the file operation. This member can take a combination of the following flags.

    FOF_ALLOWUNDO

    Preserve undo information, if possible.

    Prior to Windows Vista, operations could be undone only from the same process that performed the original operation.

    In Windows Vista and later systems, the scope of the undo is a user session. Any process running in the user session can undo another operation. The undo state is held in the Explorer.exe process, and as long as that process is running, it can coordinate the undo functions.

    If the source file parameter does not contain fully qualified path and file names, this flag is ignored.

    FOF_CONFIRMMOUSE

    Not used.

    FOF_FILESONLY

    Perform the operation only on files (not on folders) if a wildcard file name is specified.

    FOF_MULTIDESTFILES

    The pTo member specifies multiple destination files (one for each source file in pFrom) rather than one directory where all source files are to be deposited.

    FOF_NOCONFIRMATION

    Respond with Yes to All for any dialog box that is displayed.

    FOF_NOCONFIRMMKDIR

    Do not ask the user to confirm the creation of a new directory if the operation requires one to be created.

    FOF_NO_CONNECTED_ELEMENTS

    Version 5.0. Do not move connected files as a group. Only move the specified files.

    FOF_NOCOPYSECURITYATTRIBS

    Version 4.71. Do not copy the security attributes of the file. The destination file receives the security attributes of its new folder.

    FOF_NOERRORUI

    Do not display a dialog to the user if an error occurs.

    FOF_NORECURSEREPARSE

    Not used.

    FOF_NORECURSION

    Only perform the operation in the local directory. Do not operate recursively into subdirectories, which is the default behavior.

    FOF_NO_UI

    Windows Vista. Perform the operation silently, presenting no UI to the user.
    This is equivalent to FOF_SILENT | FOF_NOCONFIRMATION | FOF_NOERRORUI | FOF_NOCONFIRMMKDIR.

    FOF_RENAMEONCOLLISION

    Give the file being operated on a new name in a move, copy, or rename operation if a file with the target name already exists at the destination.

    FOF_SILENT

    Do not display a progress dialog box.

    FOF_SIMPLEPROGRESS

    Display a progress dialog box but do not show individual file names as they are operated on.

    FOF_WANTMAPPINGHANDLE

    If FOF_RENAMEONCOLLISION is specified and any files were renamed, assign a name mapping object that contains their old and new names to the hNameMappings member. This object must be freed using SHFreeNameMappings when it is no longer needed.

    FOF_WANTNUKEWARNING

    Version 5.0. Send a warning if a file is being permanently destroyed during a delete operation rather than recycled. This flag partially overrides FOF_NOCONFIRMATION.


  *)
end;

function TBRecycleFileList(Files: string): Integer;
var
  SHFileOp: TSHFileOpStruct;
begin
  FillChar(SHFileOp, SizeOf(SHFileOp), 0);
  with SHFileOp do
  begin
    wFunc := FO_DELETE; // function
    pFrom := PChar(Files); // file list
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION; // flags
    lpszProgressTitle := PChar('Send Files To Recycle Bin'); // Title
  end;
  Result := SHFileOperation(SHFileOp);
end;

function TBCopyFile(sourcename, destname: string; bFailIfExists: boolean): boolean;
begin
  Result := copyfileW(pWideChar(sourcename), pWideChar(destname), true);
  // result := copyfile(pchar(sourcename), pchar(destname), true);
end;

function TBMoveFileList(Files: string; DestDir: string; theFlags: integer = 0): Integer;
var
  SHFileOp: TSHFileOpStruct;
begin
  FillChar(SHFileOp, SizeOf(SHFileOp), 0);
  with SHFileOp do
  begin
    wFunc := FO_MOVE; // function
    pFrom := PChar(Files); // file list
    pTo := PChar(DestDir); // destination directory
    fFlags := theFlags; // flags
    lpszProgressTitle := PChar('Move Files To ' + DestDir); // Title
  end;
  Result := SHFileOperation(SHFileOp);
end;

function TBCopyFileList(Files: string; DestDir: string; theFlags: integer = 0): Integer;
var
  SHFileOp: TSHFileOpStruct;
begin
  FillChar(SHFileOp, SizeOf(SHFileOp), 0);
  with SHFileOp do
  begin
    wFunc := FO_COPY; // function
    pFrom := PChar(Files); // file list
    pTo := PChar(DestDir);
    fFlags := theFlags; // flags
    lpszProgressTitle := PChar('Copy Files To ' + DestDir); // Title
  end;
  Result := SHFileOperation(SHFileOp);
end;

// Main part of the Source: http://www.martinstoeckli.ch/delphi/
function TBCopyCutFilesToClipboard(Handle: HWND; Filenames: TStrings; bCut: boolean): boolean;
type
  pcardinal = ^cardinal;
const
  C_UNABLE_TO_ALLOCATE_MEMORY = 'Unable to allocate memory.';
  C_UNABLE_TO_ACCESS_MEMORY = 'Unable to access allocated memory.';
var
  DropFiles: PDropFiles;
  hGlobal: THandle;
  iLen: Integer;
  sFilenames: String;
  iIndex: Integer;
  dEff: pcardinal;
  f: UINT;
begin

  Result := false;
  if (Filenames = nil) and (Filenames.count = 0) then
    EXIT;

  // Filenames are separated by #0 and end with a double #0#0
  sFilenames := '';
  for iIndex := 0 to Filenames.count - 1 do
    sFilenames := sFilenames + ExcludeTrailingPathDelimiter(Filenames.Strings[iIndex]) + #0;
  sFilenames := sFilenames + #0;

  Clipboard.Open;
  try
    if bCut then
      Clipboard.clear;

    iLen := Length(sFilenames);
    hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT,
      SizeOf(TDropFiles) + ((iLen + 2) * SizeOf(char)));
    if (hGlobal = 0) then
      raise Exception.create(C_UNABLE_TO_ALLOCATE_MEMORY);
    try
      DropFiles := GlobalLock(hGlobal);
      if (DropFiles = nil) then
        raise Exception.create(C_UNABLE_TO_ACCESS_MEMORY);
      try
        DropFiles^.pFiles := SizeOf(TDropFiles);
        // DropFiles^.fWide := True;
        DropFiles^.fWide := (SizeOf(char) = SizeOf(WideChar));

        if sFilenames <> '' then
          Move(sFilenames[1], (PByte(DropFiles) + SizeOf(TDropFiles))^, iLen * SizeOf(char));
      finally
        GlobalUnlock(hGlobal);
      end;
      Clipboard.SetAsHandle(CF_HDROP, hGlobal);
    except
      GlobalFree(hGlobal);
    end;

    if bCut then
    begin
      hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(dword));
      if (hGlobal = 0) then
        raise Exception.create(C_UNABLE_TO_ALLOCATE_MEMORY);
      try
        dEff := GlobalLock(hGlobal);
        if (dEff = nil) then
          raise Exception.create(C_UNABLE_TO_ACCESS_MEMORY);
        try
          f := RegisterClipboardFormat(PChar(CF_PreferredDropEffect_Str));
          hGlobal := GlobalAlloc(GMEM_SHARE or GMEM_MOVEABLE or GMEM_ZEROINIT, SizeOf(dword));
          dEff := pcardinal(GlobalLock(hGlobal));
          dEff^ := DROPEFFECT_MOVE;
          Clipboard.SetAsHandle(f, hGlobal);
        finally
          GlobalUnlock(hGlobal);
        end;

      except
        GlobalFree(hGlobal);
      end;
    end;

  finally
    Clipboard.close;
  end;

  Result := true;
end;

// Main part of the Source: http://www.martinstoeckli.ch/delphi/
procedure TBPasteFilenamesFromClipboard(theHandle: HWND; Filenames: TStrings; out bMoveFiles: boolean);
type
  pcardinal = ^cardinal;
var
  hdroppEff: hGlobal;
  hDropHandle: HDROP;
  szBuffer: PChar;
  iCount, iIndex: Integer;
  iLength: Integer;

  pDropEff: pcardinal;
  CF_DROPEFFECT: UINT;
begin
  // check entry conditions
  if (Filenames = nil) then
    EXIT;

  CF_DROPEFFECT := RegisterClipboardFormat(CF_PreferredDropEffect_Str);
  bMoveFiles := false;

  Filenames.clear;
  // lock clipboard
  Clipboard.Open;
  try
    // does clipboard contain filenames?
    if (Clipboard.HasFormat(CF_HDROP)) then
    begin
      // get drop handle from the clipboard
      hDropHandle := Clipboard.GetAsHandle(CF_HDROP);
      // enumerate filenames
      iCount := DragQueryFile(hDropHandle, $FFFFFFFF, nil, 0);
      for iIndex := 0 to iCount - 1 do
      begin
        // get length of filename
        iLength := DragQueryFile(hDropHandle, iIndex, nil, 0);
        // allocate the memory, the #0 is not included in "iLength"
        szBuffer := StrAlloc(iLength + 1);
        try
          // get filename
          DragQueryFile(hDropHandle, iIndex, szBuffer, iLength + 1);
          Filenames.Add(szBuffer);
        finally // free the memory
          StrDispose(szBuffer);
        end;
      end;
    end;

    if Clipboard.HasFormat(CF_DROPEFFECT) then
    begin
      hdroppEff := Clipboard.GetAsHandle(CF_DROPEFFECT);
      if hdroppEff <> 0 then
      begin
        pDropEff := pcardinal(GlobalLock(hdroppEff));
        try
          if pDropEff <> nil then
            bMoveFiles := (pDropEff^) = DROPEFFECT_MOVE;
        finally
          GlobalUnlock(hdroppEff);
        end;
      end;
    end;

  finally
    // unlock clipboard
    Clipboard.close;
  end;
end;

function TBCopyFilenamesToClipboard(theHandle: HWND; Filenames: TStrings): boolean;
begin
  Result := TBCopyCutFilesToClipboard(theHandle, Filenames, false);
end;

function TBCutFilenamesToClipboard(theHandle: HWND; Filenames: TStrings): boolean;
begin
  Result := TBCopyCutFilesToClipboard(theHandle, Filenames, true);
end;

procedure TBGetFilesinFolder(fl: TStrings; thefolder: string);
var
  fExt: string;
  sr: TSearchRec;
  FileAttrs: Integer;
  f_slashed: string;
begin
  if not directoryexists(thefolder) then
    EXIT;

  f_slashed := IncludeTrailingPathDelimiter(thefolder);
  FileAttrs := faAnyFile;
  if FindFirst(f_slashed + '*.*', FileAttrs, sr) = 0 then
  begin
    fExt := extractfileext(sr.name);
    if TBStringinArray(fExt, TBCONST_ValidList_READ) then
      fl.Add(f_slashed + sr.name);

    while FindNext(sr) = 0 do
    begin
      fExt := extractfileext(sr.name);
      if TBStringinArray(fExt, TBCONST_ValidList_READ) then
        fl.Add(f_slashed + sr.name);
    end;
    FindClose(sr);
  end;
end;

function TBFileListToShellParamStr(FileList: TStrings): string;
var
  i: Integer;
begin
  Result := '';
  for i := FileList.count - 1 downto 0 do
  begin
    if fileexists(FileList.Strings[i]) then
      Result := Result + FileList.Strings[i] + #0;
  end;
  Result := Result + #0#0;
end;

procedure TBExtractUrlsFromFileList(FileList: TStrings; Urls: TStrings);
var
  i: Integer;
begin
  Urls.clear;
  for i := FileList.count - 1 downto 0 do
  begin
    if tbs_UrlIsValidUrl(FileList.Strings[i]) then
      Urls.Add(FileList.Strings[i]);
  end;
end;

procedure TBExtractWIAFromFileList(FileList: TStrings; Wias: TStrings);
var
  i: Integer;
begin
  Wias.clear;
  for i := FileList.count - 1 downto 0 do
  begin
    if IsFileNameWIA(FileList.Strings[i]) then
      Wias.Add(FileList.Strings[i]);
  end;
end;

procedure TBExtractWPDFromFileList(FileList: TStrings; Wpds: TStrings);
var
  i: Integer;
begin
  Wpds.clear;
  for i := FileList.count - 1 downto 0 do
  begin
    if IsFileNameWPD(FileList.Strings[i]) then
      Wpds.Add(FileList.Strings[i]);
  end;
end;

procedure TBExtractPureFileList(FileList: TStrings; Files: TStrings);
var
  i: Integer;
begin
  Files.clear;
  for i := FileList.count - 1 downto 0 do
  begin
    if fileexists(FileList.Strings[i]) then
      Files.Add(FileList.Strings[i]);
  end;
end;

procedure TBGetFoldersRecursively(thefolder: string; theFolderRecursionList: Tstringlist);
const
  flagInRecursion: Integer = -1;
  lastTick: Integer = 0;

  procedure AddFolder(thename: string; const bAddSelf, bAddTree: boolean);
  begin
    // StartBrowsing(thename);
    if bAddSelf then
      theFolderRecursionList.Add(thename);

    if bAddTree then
      TBGetFoldersRecursively(thename, theFolderRecursionList);
  end;

var
  sr: TSearchRec;
  FileAttrs: Integer;
  slashedfolder: string;
begin

  if thefolder = '' then
    EXIT;

  if flagInRecursion = -1 then
    theFolderRecursionList.clear;

  flagInRecursion := flagInRecursion + 1;

  slashedfolder := IncludeTrailingPathDelimiter(thefolder);
  try
    FileAttrs := faAnyFile;

    if FindFirst(slashedfolder + '*.*', FileAttrs, sr) = 0 then
    begin
      try
        if ((sr.attr and faDirectory) <> 0) and (sr.name <> '.') and (sr.name <> '..') then
        begin
          AddFolder(slashedfolder + sr.name, true, true);
        end;

        while FindNext(sr) = 0 do
        begin
          if ((sr.attr and faDirectory) <> 0) and (sr.name <> '.') and (sr.name <> '..') then
          begin
            AddFolder(slashedfolder + sr.name, true, true);
          end;
        end;
      finally
        FindClose(sr);
      end;
    end;

    dec(flagInRecursion);
  finally;
  end;
end;


end.
