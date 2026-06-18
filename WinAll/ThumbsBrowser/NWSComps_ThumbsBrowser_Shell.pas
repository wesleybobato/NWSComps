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
unit NWSComps_ThumbsBrowser_Shell;
{$R-}
{$Q-}

interface

{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}

uses
  Windows, Messages, dialogs, SysUtils, Classes, forms,
  Graphics, Controls, contnrs,
  hyieutils, hyiedefs, {$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF}
  imageenio, imageenproc, ieWIA,
  NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs,
  NWSComps_ThumbsBrowser_const,
  NWSComps_ThumbsBrowser_Shell_Utils,
  NWSComps_ThumbsBrowser_Utils_Types;

type
{$IFNDEF IMAGEEN_6_2_LATER}
  TIOParams = TIOParamsVals;
{$ENDIF}

  TThumbsBrowserShellProcessor = class(TComponent)
  private
    fHWnd: HWND;
    fattachedBrowser: TThumbsBrowser;
    fInProcessCtr: integer;

    fDefaultFormat_FolderRename: TTB_Shell_FolderRenameFormat;
    fDefaultFormat_FileRename: TTB_Shell_FileRenameFormat;

    fClipboard_Rcd: TTB_Shell_ClipboardRecord;
    // fClipboardFiles: TStringlist;

    fOnClipBoardChanged: TTB_Shell_ClipboardChange_Event;
    FSaveParametersDefault: TTB_Shell_SaveParameters;
    fWiaImportJpegQuality: TTB_Browser_WIA_Transfer_JpegQuality;

    function SH_OP_ENABLED: boolean;
    procedure SH_OP_START;
    procedure SH_OP_END;

    procedure SetAborted(value: boolean);

    function Convert_FileRenameFormat_ConstToFmt(theRenameFormatConst: TTB_Shell_FileRenameFormat)
      : TTB_Shell_FileRenameFormat;
    function Convert_FolderRenameFormat_ConstToFmt(theRenameFormatConst: TTB_Shell_FolderRenameFormat)
      : TTB_Shell_FolderRenameFormat;

    procedure ResetDefault_SaveParameters;

    procedure copydefaultSaveParametersfromIOParams(source: TIOParams; var dest: TTB_Shell_SaveParameters);
    procedure copySaveParametersfromIOParams(source: TIOParams; var dest: TTB_Shell_SaveParameters);
    procedure copySaveParameterstoIOParams(source: TTB_Shell_SaveParameters; dest: TIOParams);

    procedure WMDrawClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
    procedure WMChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;
    function SH_OP_TransferWiaItem(athumb: TTHumbEX; var theFilename: string; bDeleteTakenPic: boolean;
      jpegTransferQty: TTB_Browser_WIA_Transfer_JpegQuality): boolean;
    function SH_OP_TransferWiaItemToFolder(athumb: TTHumbEX; theFolder: string; bDeleteTakenPic: boolean;
      jpegTransferQty: TTB_Browser_WIA_Transfer_JpegQuality): boolean;
    function GetAborted: boolean;

{$IFDEF TB_PORTABLEDEVICE}
    function SH_OP_DeleteWPDObject(athumb: TTHumbEX): boolean;
    function SH_OP_TransferWPDObjectToFolder(athumb: TTHumbEX; theFolder: string; bDeleteObject: boolean): boolean;

    function SH_OP_TransferWPDObject(athumb: TTHumbEX; theFilename: string; bDeleteObject: boolean): boolean;
{$ENDIF}
  protected
    procedure WndMethod(var Msg: TMessage); virtual;
  public

    MinExifYear: integer;
    Compare_Date: Tdatetime;
    Compare_DateRange_Start, Compare_DateRange_End: Tdatetime;

    OnProgress: TTB_Browser_ProgressEvent_Perc;
    OnRenamedFile: TTB_Shell_RenamedFileEvent;
    OnRenamedCopiedFile: TTB_Shell_RenamedCopiedFileEvent;

    SaveParameters: TTB_Shell_SaveParameters;

    property WiaImportJpegQuality: TTB_Browser_WIA_Transfer_JpegQuality read fWiaImportJpegQuality
      write fWiaImportJpegQuality;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;

    property Aborted: boolean read GetAborted write SetAborted;

    procedure AbortProcess;

    procedure SetDefaultFormat_RenameFolder(theValue: TTB_Shell_FolderRenameFormat);
    procedure SetDefaultFormat_RenameFile(theValue: TTB_Shell_FileRenameFormat);

    procedure SH_OP_Cut_TO_ClipBoard_Checked;
    procedure SH_OP_Cut_TO_ClipBoard_Selected;
    procedure SH_OP_Cut_TO_ClipBoard(theFiles: TStringlist); overload;
    procedure SH_OP_Cut_TO_ClipBoard(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition); overload;

    procedure SH_OP_Copy_TO_ClipBoard_Checked;
    procedure SH_OP_Copy_TO_ClipBoard_Selected;
    procedure SH_OP_Copy_TO_ClipBoard(theFiles: TStringlist); overload;
    procedure SH_OP_Copy_TO_ClipBoard(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition); overload;
    procedure SH_OP_Paste_FromClipboardToFolder(theFolder: string);
    procedure SH_OP_ShowClipboardContentInBrowser;
    function SH_OP_GetClipboardFileCount: integer;
    function SH_OP_ClipboardHasFiles: boolean;

    procedure SH_OP_Delete_Checked;
    procedure SH_OP_Delete_Selected;
    procedure SH_OP_Delete(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition); overload;
    procedure SH_OP_Delete(theFiles: TStringlist; bSendToBin: boolean; bRemoveThumbs: boolean); overload;

    procedure SH_OP_RecycletoBin_Checked;
    procedure SH_OP_RecycletoBin_Selected;
    procedure SH_OP_RecycletoBin(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition); overload;
    procedure SH_OP_RecycletoBin(theFiles: TStringlist; bRemoveThumbs: boolean); overload;

    procedure SH_OP_CopytoFolder_Checked(theFolder: string; theFlags: integer = 0);
    procedure SH_OP_CopytoFolder_Selected(theFolder: string; theFlags: integer = 0);
    procedure SH_OP_CopytoFolder(theFolder: string; theFiles: TStringlist; theFlags: integer = 0); overload;
    procedure SH_OP_CopytoFolder(theFolder: string; om: TTB_Shell_PickMode;
      condition: TTB_Browser_PickCondition; theFlags: integer = 0); overload;

    procedure SH_OP_MovetoFolder_Checked(theFolder: string; theFlags: integer = 0);
    procedure SH_OP_MovetoFolder_Selected(theFolder: string; theFlags: integer = 0);
    procedure SH_OP_MovetoFolder(theFolder: string; theFiles: TStringlist; theFlags: integer = 0); overload;
    procedure SH_OP_MovetoFolder(theFolder: string; om: TTB_Shell_PickMode;
      condition: TTB_Browser_PickCondition; theFlags: integer = 0); overload;

    procedure SH_OP_Rename_Checked(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean);
    procedure SH_OP_Rename_Selected(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean);

    procedure SH_OP_Rename(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean;
      om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

    procedure SH_OP_CopyRename_Checked(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean;
      const bCopyFileDates: boolean);
    procedure SH_OP_CopyRename_Selected(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean;
      const bCopyFileDates: boolean);
    procedure SH_OP_CopyRename(const bUseDefaultFormat: boolean; FileRenameFormat: TTB_Shell_FileRenameFormat;
      FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string; const bAddFolderByFileType: boolean;
      const bCopyFileDates: boolean; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition;
      const bChangeThumbsNames: boolean);

    procedure SH_OP_Rotate_Checked(const bAllowOverWriteFile: boolean = true);
    procedure SH_OP_Rotate_Selected(const bAllowOverWriteFile: boolean = true);
    procedure SH_OP_Rotate(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition;
      const bAllowOverWriteFile: boolean = true);

    procedure SH_OP_CorrectImageOrientation_Checked;
    procedure SH_OP_CorrectImageOrientation_Selected;
    procedure SH_OP_CorrectImageOrientation(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
    procedure SH_OP_CorrectImageOrientation_List(theFileList: TStringlist);

    procedure SH_OP_SaveChecked_To(outputFolder: string; outputEXT: string);
    procedure SH_OP_SaveSelected_To(outputFolder: string; outputEXT: string);
    procedure SH_OP_SaveListTo(outputFolder: string; outputEXT: string; theFileList: TStringlist;
      var ReturnedFileNames: TStringlist); overload;
    procedure SH_OP_SaveListTo(outputFolder: string; outputEXT: string; theFileList: TStringlist); overload;

    procedure SH_OP_SaveTo(outputFolder: string; outputEXT: string; om: TTB_Shell_PickMode;
      condition: TTB_Browser_PickCondition); overload;
    procedure SH_OP_SaveTo(outputFolder: string; outputEXT: string; om: TTB_Shell_PickMode;
      condition: TTB_Browser_PickCondition; var ReturnedFileNames: TStringlist); overload;

    procedure SH_OP_GetFilenameList_Selected(var fl: TStringlist);
    procedure SH_OP_GetFilenameList_Checked(var fl: TStringlist);

    procedure SH_OP_GetFilenameList(var fl: TStringlist; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

    function SH_OP_ReturnRenamedFile_SampleString(const bUseDefaultFormat: boolean;
      RenameFormat: TTB_Shell_FileRenameFormat): string;

    function SH_OP_ReturnRenamedFolder_SampleString(const bUseDefaultFormat: boolean;
      RenameFormat: TTB_Shell_FolderRenameFormat): string;

    function SH_OP_ReturnRenamedFile(const bUseDefaultFormat: boolean; theThumb: TTHumbEX; tofolder: string;
      idx: integer; RenameFormat: TTB_Shell_FileRenameFormat; checkexistence: boolean): string; overload;

    procedure SH_OP_ReturnRenamedFolder_Node(var theFolderNode: TTB_Shell_Tree_Folder_Node;
      const bUseDefaultFormat: boolean; toPath: string; RenameFormat: TTB_Shell_FolderRenameFormat);

    procedure SH_OP_GetTreeNodes_byDate(var dl: TTB_Shell_Tree_Folders_NodeArray; mode: TTB_Shell_FolderNodes_PickMode;
      const IgnoreExif: boolean; condition: TTB_Browser_PickCondition);

    function SH_Node_Folder_DefineNew(const theRelativePAth: string): TTB_Shell_Tree_Folder_Node;

    function SH_Nodes_CompareDate(node1, node2: TTB_Shell_Tree_Folder_Node;
      checkmode: TTB_Shell_FolderNodes_PickMode): boolean;
    function SH_Nodes_CheckAddFolder(var dl: TTB_Shell_Tree_Folders_NodeArray;
      theCandidateNode: TTB_Shell_Tree_Folder_Node; checkmode: TTB_Shell_FolderNodes_PickMode): integer;

    function CompareDate(dt1, dt2: Tdatetime; datemode: TTB_Shell_CompareDateMode): boolean;

  published

    property AttachedBrowser: TThumbsBrowser read fattachedBrowser write fattachedBrowser;

    property OnClipBoardChanged: TTB_Shell_ClipboardChange_Event read fOnClipBoardChanged write fOnClipBoardChanged;
  end;

implementation

uses Clipbrd, ActiveX, shlobj, shellapi, math,
  NWSComps_ThumbsBrowser_utils, NWSComps_ThumbsBrowser_RES, NWSComps_ThumbsBrowser_RES_CONST;

(*
  Call StrToDate to parse a string that specifies a date.
  If S does not contain a valid date, StrToDate raises an EConvertError exception.

  S must consist of two or three numbers, separated by the character defined by
  the DateSeparator global variable.

  The order for month, day, and year is determined by the ShortDateFormat global variable
  --possible combinations are m/d/y, d/m/y, and y/m/d.

  If S contains only two numbers, it is interpreted as a date (m/d or d/m) in the current year.
*)


// Class TThumbsBrowserShellProcessor

constructor TThumbsBrowserShellProcessor.Create(AOwner: TComponent);
begin
  inherited;
  fClipboard_Rcd := TTB_Shell_ClipboardRecord.Create;

  fWiaImportJpegQuality := wtq_Png;

  Compare_Date := now;
  Compare_DateRange_Start := now;
  Compare_DateRange_End := now;
  MinExifYear := 1970;

  SetDefaultFormat_RenameFile(TBSHELLCONST_DEFRENAMEFORMAT_FILES);
  // internal def format set here (changing also the separator inside date format)
  SetDefaultFormat_RenameFolder(TBSHELLCONST_DEFRENAMEFORMAT_FOLDERS);
  // internal def format set here (changing also the separator inside date format)

  ResetDefault_SaveParameters;

  SaveParameters := FSaveParametersDefault;
  fInProcessCtr := 0;
end;

destructor TThumbsBrowserShellProcessor.Destroy;
begin

  ChangeClipboardChain(fHWnd, fClipboard_Rcd.NextHandle);
  DeallocateHWnd(fHWnd);

  // fClipboardFiles.Free;

  fClipboard_Rcd.Free;
  inherited;
end;

function TThumbsBrowserShellProcessor.GetAborted: boolean;
begin
  result := fInProcessCtr = -1;
end;

procedure TThumbsBrowserShellProcessor.Loaded;
begin
  inherited;
  fHWnd := AllocateHWnd(WndMethod);
  fClipboard_Rcd.NextHandle := SetClipboardViewer(fHWnd);

  if assigned(fOnClipBoardChanged) then
    fOnClipBoardChanged(fClipboard_Rcd.HasFiles, self); // notify initial state of clipboard

end;

function TThumbsBrowserShellProcessor.SH_OP_ENABLED: boolean;
begin
  result := (assigned(fattachedBrowser));

  if not result then
    showmessage('Attached Browser not assigned');
end;

procedure TThumbsBrowserShellProcessor.SetAborted(value: boolean);
begin
  fInProcessCtr := -1;
end;

procedure TThumbsBrowserShellProcessor.ResetDefault_SaveParameters;
var
  io: timageenio;
begin
  io := timageenio.Create(nil);
  try
    copySaveParametersfromIOParams(io.Params, FSaveParametersDefault);
  finally
    io.Free;
  end;
end;

function TThumbsBrowserShellProcessor.Convert_FileRenameFormat_ConstToFmt(theRenameFormatConst
  : TTB_Shell_FileRenameFormat): TTB_Shell_FileRenameFormat;
begin
  result := theRenameFormatConst;
  with result do
  begin
    DateFormat := StringReplace(DateFormat, TBCONST_GENSEPARATOR, Sep_Date, [rfReplaceAll]);

    TimeFormat := StringReplace(TimeFormat, TBCONST_GENSEPARATOR, Sep_Time, [rfReplaceAll]);
  end;
end;

function TThumbsBrowserShellProcessor.Convert_FolderRenameFormat_ConstToFmt(theRenameFormatConst
  : TTB_Shell_FolderRenameFormat): TTB_Shell_FolderRenameFormat;
begin
  result := theRenameFormatConst;
  with result do
  begin
    DateFormat := StringReplace(DateFormat, TBCONST_GENSEPARATOR, Sep_Date, [rfReplaceAll]);
  end;
end;

procedure TThumbsBrowserShellProcessor.SetDefaultFormat_RenameFolder(theValue: TTB_Shell_FolderRenameFormat);
begin
  fDefaultFormat_FolderRename := Convert_FolderRenameFormat_ConstToFmt(theValue);
end;

procedure TThumbsBrowserShellProcessor.SetDefaultFormat_RenameFile(theValue: TTB_Shell_FileRenameFormat);
begin
  fDefaultFormat_FileRename := Convert_FileRenameFormat_ConstToFmt(theValue);
end;

procedure TThumbsBrowserShellProcessor.copydefaultSaveParametersfromIOParams(source: TIOParams;
  var dest: TTB_Shell_SaveParameters);
  function matchrgb(rgb1, rgb2: TRGB): boolean;
  begin
    result := (rgb1.r = rgb2.r) and (rgb1.g = rgb2.g) and (rgb1.b = rgb2.b);
  end;

begin
  if not assigned(source) then
    exit;

  if dest.BitsPerSample = FSaveParametersDefault.BitsPerSample then
    dest.BitsPerSample := source.BitsPerSample;
  if dest.Dpi = FSaveParametersDefault.Dpi then
    dest.Dpi := source.Dpi;
  if dest.DpiX = FSaveParametersDefault.DpiX then
    dest.DpiX := source.DpiX;
  if dest.DpiY = FSaveParametersDefault.DpiY then
    dest.DpiY := source.DpiY;
  if dest.SamplesPerPixel = FSaveParametersDefault.SamplesPerPixel then
    dest.SamplesPerPixel := source.SamplesPerPixel;

  if dest.BMP_Compression = FSaveParametersDefault.BMP_Compression then
    dest.BMP_Compression := source.BMP_Compression;
  if dest.BMP_Version = FSaveParametersDefault.BMP_Version then
    dest.BMP_Version := source.BMP_Version;
  if matchrgb(dest.GIF_Background, FSaveParametersDefault.GIF_Background) then
    dest.GIF_Background := source.GIF_Background;
  if dest.GIF_FlagTranspColor = FSaveParametersDefault.GIF_FlagTranspColor then
    dest.GIF_FlagTranspColor := source.GIF_FlagTranspColor;
  if dest.GIF_Interlaced = FSaveParametersDefault.GIF_Interlaced then
    dest.GIF_Interlaced := source.GIF_Interlaced;
  if dest.GIF_Ratio = FSaveParametersDefault.GIF_Ratio then
    dest.GIF_Ratio := source.GIF_Ratio;
  if matchrgb(dest.GIF_TranspColor, FSaveParametersDefault.GIF_TranspColor) then
    dest.GIF_TranspColor := source.GIF_TranspColor;
  if dest.GIF_Version = FSaveParametersDefault.GIF_Version then
    dest.GIF_Version := source.GIF_Version;

  if dest.JPEG_ColorSpace = FSaveParametersDefault.JPEG_ColorSpace then
    dest.JPEG_ColorSpace := source.JPEG_ColorSpace;
  if dest.JPEG_DCTMethod = FSaveParametersDefault.JPEG_DCTMethod then
    dest.JPEG_DCTMethod := source.JPEG_DCTMethod;
  if dest.JPEG_OptimalHuffman = FSaveParametersDefault.JPEG_OptimalHuffman then
    dest.JPEG_OptimalHuffman := source.JPEG_OptimalHuffman;
  if dest.JPEG_Progressive = FSaveParametersDefault.JPEG_Progressive then
    dest.JPEG_Progressive := source.JPEG_Progressive;
  if dest.JPEG_Quality = FSaveParametersDefault.JPEG_Quality then
    dest.JPEG_Quality := source.JPEG_Quality;
  if dest.JPEG_Scale = FSaveParametersDefault.JPEG_Scale then
    dest.JPEG_Scale := source.JPEG_Scale;
  if dest.JPEG_Smooth = FSaveParametersDefault.JPEG_Smooth then
    dest.JPEG_Smooth := source.JPEG_Smooth;

  if dest.J2000_ColorSpace = FSaveParametersDefault.J2000_ColorSpace then
    dest.J2000_ColorSpace := source.J2000_ColorSpace;
  if dest.J2000_Rate = FSaveParametersDefault.J2000_Rate then
    dest.J2000_Rate := source.J2000_Rate;
  if dest.J2000_ScalableBy = FSaveParametersDefault.J2000_ScalableBy then
    dest.J2000_ScalableBy := source.J2000_ScalableBy;

  if dest.PCX_Compression = FSaveParametersDefault.PCX_Compression then
    dest.PCX_Compression := source.PCX_Compression;
  if dest.TIFF_Compression = FSaveParametersDefault.TIFF_Compression then
    dest.TIFF_Compression := source.TIFF_Compression;
  if dest.TIFF_DocumentName = FSaveParametersDefault.TIFF_DocumentName then
    dest.TIFF_DocumentName := source.TIFF_DocumentName;
  if dest.TIFF_ImageDescription = FSaveParametersDefault.TIFF_ImageDescription then
    dest.TIFF_ImageDescription := source.TIFF_ImageDescription;
  if dest.TIFF_JPEGColorSpace = FSaveParametersDefault.TIFF_JPEGColorSpace then
    dest.TIFF_JPEGColorSpace := source.TIFF_JPEGColorSpace;

  if dest.TIFF_JPEGQuality = FSaveParametersDefault.TIFF_JPEGQuality then
    dest.TIFF_JPEGQuality := source.TIFF_JPEGQuality;
  if matchrgb(dest.CUR_Background, FSaveParametersDefault.CUR_Background) then
    dest.CUR_Background := source.CUR_Background;
  if matchrgb(dest.ICO_Background, FSaveParametersDefault.ICO_Background) then
    dest.ICO_Background := source.ICO_Background;

  if matchrgb(dest.PNG_Background, FSaveParametersDefault.PNG_Background) then
    dest.PNG_Background := source.PNG_Background;
  if dest.PNG_Compression = FSaveParametersDefault.PNG_Compression then
    dest.PNG_Compression := source.PNG_Compression;
  if dest.PNG_Filter = FSaveParametersDefault.PNG_Filter then
    dest.PNG_Filter := source.PNG_Filter;
  if dest.PNG_Interlaced = FSaveParametersDefault.PNG_Interlaced then
    dest.PNG_Interlaced := source.PNG_Interlaced;
  if dest.TGA_AspectRatio = FSaveParametersDefault.TGA_AspectRatio then
    dest.TGA_AspectRatio := source.TGA_AspectRatio;
  if dest.TGA_Author = FSaveParametersDefault.TGA_Author then
    dest.TGA_Author := source.TGA_Author;
  if matchrgb(dest.TGA_Background, FSaveParametersDefault.TGA_Background) then
    dest.TGA_Background := source.TGA_Background;
  if dest.TGA_Compressed = FSaveParametersDefault.TGA_Compressed then
    dest.TGA_Compressed := source.TGA_Compressed;
  if dest.TGA_Date = FSaveParametersDefault.TGA_Date then
    dest.TGA_Date := source.TGA_Date;
  if dest.TGA_Descriptor = FSaveParametersDefault.TGA_Descriptor then
    dest.TGA_Descriptor := source.TGA_Descriptor;
  if dest.TGA_Gamma = FSaveParametersDefault.TGA_Gamma then
    dest.TGA_Gamma := source.TGA_Gamma;
  if dest.TGA_GrayLevel = FSaveParametersDefault.TGA_GrayLevel then
    dest.TGA_GrayLevel := source.TGA_GrayLevel;
end;

procedure TThumbsBrowserShellProcessor.copySaveParametersfromIOParams(source: TIOParams;
  var dest: TTB_Shell_SaveParameters);
begin
  if not assigned(source) then
    exit;

  dest.BitsPerSample := source.BitsPerSample;
  dest.Dpi := source.Dpi;
  dest.DpiX := source.DpiX;
  dest.DpiY := source.DpiY;
  dest.SamplesPerPixel := source.SamplesPerPixel;
  dest.BMP_Compression := source.BMP_Compression;
  dest.BMP_Version := source.BMP_Version;
  dest.GIF_Background := source.GIF_Background;
  dest.GIF_FlagTranspColor := source.GIF_FlagTranspColor;
  dest.GIF_Interlaced := source.GIF_Interlaced;
  dest.GIF_Ratio := source.GIF_Ratio;
  dest.GIF_TranspColor := source.GIF_TranspColor;
  dest.GIF_Version := source.GIF_Version;

  dest.JPEG_ColorSpace := source.JPEG_ColorSpace;
  dest.JPEG_DCTMethod := source.JPEG_DCTMethod;
  dest.JPEG_OptimalHuffman := source.JPEG_OptimalHuffman;
  dest.JPEG_Progressive := source.JPEG_Progressive;
  dest.JPEG_Quality := source.JPEG_Quality;
  dest.JPEG_Scale := source.JPEG_Scale;
  dest.JPEG_Smooth := source.JPEG_Smooth;

  dest.J2000_ColorSpace := source.J2000_ColorSpace;
  dest.J2000_Rate := source.J2000_Rate;
  dest.J2000_ScalableBy := source.J2000_ScalableBy;

  dest.PCX_Compression := source.PCX_Compression;
  dest.TIFF_Compression := source.TIFF_Compression;
  dest.TIFF_DocumentName := source.TIFF_DocumentName;
  dest.TIFF_ImageDescription := source.TIFF_ImageDescription;
  dest.TIFF_JPEGColorSpace := source.TIFF_JPEGColorSpace;

  dest.TIFF_JPEGQuality := source.TIFF_JPEGQuality;

  dest.CUR_Background := source.CUR_Background;

  dest.ICO_Background := source.ICO_Background;

  dest.PNG_Background := source.PNG_Background;
  dest.PNG_Compression := source.PNG_Compression;
  dest.PNG_Filter := source.PNG_Filter;
  dest.PNG_Interlaced := source.PNG_Interlaced;

  dest.TGA_AspectRatio := source.TGA_AspectRatio;
  dest.TGA_Author := source.TGA_Author;
  dest.TGA_Background := source.TGA_Background;
  dest.TGA_Compressed := source.TGA_Compressed;
  dest.TGA_Date := source.TGA_Date;
  dest.TGA_Descriptor := source.TGA_Descriptor;
  dest.TGA_Gamma := source.TGA_Gamma;
  dest.TGA_GrayLevel := source.TGA_GrayLevel;
end;

procedure TThumbsBrowserShellProcessor.copySaveParameterstoIOParams(source: TTB_Shell_SaveParameters; dest: TIOParams);
begin
  if not assigned(dest) then
    exit;

  dest.BitsPerSample := source.BitsPerSample;
  dest.Dpi := source.Dpi;
  dest.DpiX := source.DpiX;
  dest.DpiY := source.DpiY;
  dest.SamplesPerPixel := source.SamplesPerPixel;
  dest.BMP_Compression := source.BMP_Compression;
  dest.BMP_Version := source.BMP_Version;
  dest.GIF_Background := source.GIF_Background;
  dest.GIF_FlagTranspColor := source.GIF_FlagTranspColor;
  dest.GIF_Interlaced := source.GIF_Interlaced;
  dest.GIF_Ratio := source.GIF_Ratio;
  dest.GIF_TranspColor := source.GIF_TranspColor;
  dest.GIF_Version := source.GIF_Version;

  dest.JPEG_ColorSpace := source.JPEG_ColorSpace;
  dest.JPEG_DCTMethod := source.JPEG_DCTMethod;
  dest.JPEG_OptimalHuffman := source.JPEG_OptimalHuffman;
  dest.JPEG_Progressive := source.JPEG_Progressive;
  dest.JPEG_Quality := source.JPEG_Quality;
  dest.JPEG_Scale := source.JPEG_Scale;
  dest.JPEG_Smooth := source.JPEG_Smooth;

  dest.J2000_ColorSpace := source.J2000_ColorSpace;
  dest.J2000_Rate := source.J2000_Rate;
  dest.J2000_ScalableBy := source.J2000_ScalableBy;

  dest.PCX_Compression := source.PCX_Compression;
  dest.TIFF_Compression := source.TIFF_Compression;
  dest.TIFF_DocumentName := source.TIFF_DocumentName;
  dest.TIFF_ImageDescription := source.TIFF_ImageDescription;
  dest.TIFF_JPEGColorSpace := source.TIFF_JPEGColorSpace;

  dest.TIFF_JPEGQuality := source.TIFF_JPEGQuality;

  dest.CUR_Background := source.CUR_Background;

  dest.ICO_Background := source.ICO_Background;

  dest.PNG_Background := source.PNG_Background;
  dest.PNG_Compression := source.PNG_Compression;
  dest.PNG_Filter := source.PNG_Filter;
  dest.PNG_Interlaced := source.PNG_Interlaced;

  dest.TGA_AspectRatio := source.TGA_AspectRatio;
  dest.TGA_Author := source.TGA_Author;
  dest.TGA_Background := source.TGA_Background;
  dest.TGA_Compressed := source.TGA_Compressed;
  dest.TGA_Date := source.TGA_Date;
  dest.TGA_Descriptor := source.TGA_Descriptor;
  dest.TGA_Gamma := source.TGA_Gamma;
  dest.TGA_GrayLevel := source.TGA_GrayLevel;
end;

procedure TThumbsBrowserShellProcessor.WndMethod(var Msg: TMessage);
var
  Handled: boolean;
begin
  // Assume we handle message
  Handled := true;
  case Msg.Msg of
    WM_DRAWCLIPBOARD:
      WMDrawClipboard(Msg);
    // Code to handle a message
    WM_CHANGECBCHAIN:
      WMChangeCBChain(Msg);
    // Code to handle another message
    // Handle other messages here
  else
    // We didn't handle message
    Handled := False;
  end;
  if Handled then
    // We handled message - record in message result
    Msg.result := 0
  else
    // We didn't handle message
    // pass to DefWindowProc and record result
    Msg.result := DefWindowProc(fHWnd, Msg.Msg, Msg.WParam, Msg.LParam);

end;

procedure TThumbsBrowserShellProcessor.WMDrawClipboard(var Msg: TMessage);
var
  files: TStringlist;
  bMoveFiles: boolean;
begin
  if not SH_OP_ENABLED then
    exit;

  if Clipboard.HasFormat(CF_HDROP) then
  begin
    if fClipboard_Rcd.InternalMode then // if in internal mode files were already added directly by us
      fClipboard_Rcd.UnSetInternalMode // just unset the internal mode without adding the files
    else
    begin // else files were added by someone else, so we add them to our container
      files := TStringlist.Create;
      try
        TBPasteFilenamesFromClipboard(AttachedBrowser.Handle, files, bMoveFiles);
        if bMoveFiles then
          fClipboard_Rcd.CutToClip(files)
        else
          fClipboard_Rcd.CopyToClip(files);
      finally
        files.Free;
      end;
    end;
  end
  else
  begin
    if not fClipboard_Rcd.InternalMode then
    // if in internal mode we are in a transition caused by us do not clear files
      fClipboard_Rcd.ClearClip;
  end;

  if assigned(fOnClipBoardChanged) then
    fOnClipBoardChanged(fClipboard_Rcd.HasFiles, self);

  if fClipboard_Rcd.NextHandle <> 0 then
    SendMessage(fClipboard_Rcd.NextHandle, WM_DRAWCLIPBOARD, 0, 0)
end;

procedure TThumbsBrowserShellProcessor.WMChangeCBChain(var Msg: TMessage);
var
  Remove, Next: THandle;
begin
  Remove := Msg.WParam;
  Next := Msg.LParam;
  with Msg do
    if fClipboard_Rcd.NextHandle = Remove then
      fClipboard_Rcd.NextHandle := Next
    else if fClipboard_Rcd.NextHandle <> 0 then
      SendMessage(fClipboard_Rcd.NextHandle, WM_CHANGECBCHAIN, Remove, Next)
end;

procedure TThumbsBrowserShellProcessor.AbortProcess;
begin
  Aborted := true;
end;

function TThumbsBrowserShellProcessor.SH_OP_ReturnRenamedFile_SampleString(const bUseDefaultFormat: boolean;
  RenameFormat: TTB_Shell_FileRenameFormat): string;

  function GetFmtString_SampleString: string;
  var
    s, s_date, s_time: string;
  begin
    result := '';
    case RenameFormat.RenameOptions of
      rf_Subject_Date, rf_Date_Subject:
        begin

          s_date := RenameFormat.DateFormat;
          s_time := RenameFormat.TimeFormat;

          s := s_date + ' ' + s_time;

          result := s;
        end;
      rf_usenumeration:
        begin
          result := 'SERIAL';
        end;
    end;
  end;

var
  s_NewName: string;
  s_fmt: string;
  s_Tot: string;
begin
  if bUseDefaultFormat then
    RenameFormat := fDefaultFormat_FileRename
  else
    RenameFormat := Convert_FileRenameFormat_ConstToFmt(RenameFormat);

  // if DONOTRENAME
  if RenameFormat.RenameOptions = rf_donotrename then
  begin
    s_NewName := 'ORIGINALNAME';
  end
  else
  begin // Else (RENAME)

    s_fmt := GetFmtString_SampleString; // Get the Format String Part

    if RenameFormat.FixedStr = '' then // if the fixed part is empty then do not add it
      s_Tot := s_fmt
    else
    begin
      case RenameFormat.RenameOptions of
        rf_Date_Subject:
          begin
            s_Tot := s_fmt + RenameFormat.Sep_Main + RenameFormat.FixedStr; // add first date and then fixed part
          end;
        rf_Subject_Date:
          begin
            s_Tot := RenameFormat.FixedStr + RenameFormat.Sep_Main + s_fmt; // add first fixed part and then date
          end;
        rf_usenumeration:
          begin
            s_Tot := RenameFormat.FixedStr + RenameFormat.Sep_Main + s_fmt; // add first fixed part and then serial
          end;
        rf_Custom:
          begin; // not implemented
          end;
      end;
    end;

  end;

  result := s_Tot;
end;

function TThumbsBrowserShellProcessor.SH_OP_ReturnRenamedFolder_SampleString(const bUseDefaultFormat: boolean;
  RenameFormat: TTB_Shell_FolderRenameFormat): string;
var
  s_Tot: string;
  sFixed, sdate: string;
begin
  if bUseDefaultFormat then
    RenameFormat := fDefaultFormat_FolderRename
  else
    RenameFormat := Convert_FolderRenameFormat_ConstToFmt(RenameFormat);

  s_Tot := '';
  sFixed := RenameFormat.FixedStr;

  // Format Strings
  // ----------------------------------------------------------------------
  case RenameFormat.RenameOptions of
    rfd_Subject:
      begin
        s_Tot := sFixed;
      end;
    rfd_Subject_Date, rfd_Date_Subject:
      begin
        sdate := RenameFormat.DateFormat;

        if RenameFormat.RenameOptions = rfd_Subject_Date then
          s_Tot := sFixed + RenameFormat.Sep_Main + sdate
        else
          s_Tot := sdate + RenameFormat.Sep_Main + sFixed;
      end;
  end;

  result := s_Tot;
end;

function TThumbsBrowserShellProcessor.SH_OP_ReturnRenamedFile(const bUseDefaultFormat: boolean; theThumb: TTHumbEX;
  tofolder: string; idx: integer; RenameFormat: TTB_Shell_FileRenameFormat; checkexistence: boolean): string;
  function GetFmtString(oldname: string; idx: integer): string;
  var
    s, s_date, s_time: string;
    dt: Tdatetime;
    athumb: TTHumbEX;
    s_millisecs: string;

    LengthMilliSecs: integer;
  begin
    result := '';
    case RenameFormat.RenameOptions of
      rf_Subject_Date, rf_Date_Subject:
        begin
          athumb := fattachedBrowser.Thumbat(oldname);

          if RenameFormat.UseExifDate then
            dt := athumb.SourceExifFileDate
          else
            dt := athumb.SourceFileDate;

          if not tbs_ExifDateisValid(dt, MinExifYear) then
            dt := athumb.SourceFileDate;

          if RenameFormat.DateFormat = '' then
            s_date := ''
          else
            s_date := FormatDateTime(RenameFormat.DateFormat, dt);

          if RenameFormat.TimeFormat = '' then
            s_time := ''
          else
            s_time := FormatDateTime(RenameFormat.TimeFormat, dt);

          s := '';
          if s_date <> '' then
            s := s + s_date;
          if s_time <> '' then
            s := s + ' ' + s_time;

          LengthMilliSecs := 3 + length(RenameFormat.Sep_Time);
          s_millisecs := copy(s, length(s) - LengthMilliSecs + 1, LengthMilliSecs);
          if s_millisecs = RenameFormat.Sep_Time + '000' then
            s := copy(s, 1, length(s) - LengthMilliSecs);

          result := s;
        end;
      rf_usenumeration:
        begin
          result := inttostr(idx + 1);
        end;
    end;
  end;

var
  s_NewCompleteName: string;
  s_NewName: string;
  s_NewExt: string;
  s_fmt: string;
  oldname: string;
begin
  result := '';
  if not assigned(theThumb) then
    exit;

  oldname := theThumb.SourceFileName;

  if bUseDefaultFormat then
    RenameFormat := fDefaultFormat_FileRename;

  // if DO NOT RENAME
  if RenameFormat.RenameOptions = rf_donotrename then
  begin
    // -------------------------------------
    s_NewName := changefileext(extractfilename(oldname), '');
    // -------------------------------------

  end
  else
  begin // Else GET A NEW NAME

    s_fmt := GetFmtString(oldname, idx); // Get the Format String Part

    // -------------------------------------
    if RenameFormat.FixedStr = '' then // if the fixed part is empty then do not add it
      s_NewName := s_fmt
    else
    begin
      case RenameFormat.RenameOptions of
        rf_Date_Subject:
          begin
            s_NewName := s_fmt + RenameFormat.Sep_Main + RenameFormat.FixedStr; // add first date and then fixed part
          end;
        rf_Subject_Date:
          begin
            s_NewName := RenameFormat.FixedStr + RenameFormat.Sep_Main + s_fmt; // add first fixed part and then date
          end;
        rf_usenumeration:
          begin
            s_NewName := RenameFormat.FixedStr + RenameFormat.Sep_Main + s_fmt; // add first fixed part and then serial
          end;
        rf_Custom:
          begin; // not implemented
          end;
      end;
    end;
    // -------------------------------------

  end;

  // -------------------------------------
  if RenameFormat.ChangeExt then
    s_NewExt := RenameFormat.NewExt
  else
    s_NewExt := extractfileext(oldname);
  // -------------------------------------

  // apply file name capitalization rules
  case RenameFormat.CapitalizeOptions of
    fc_AsOriginal:
      ;
    fc_CapitalizeAll:
      begin
        s_NewName := UpperCase(s_NewName);
        s_NewExt := UpperCase(s_NewExt);
      end;
    fc_CapitalizeName:
      begin
        s_NewName := UpperCase(s_NewName);
      end;
    fc_CapitalizeExtension:
      begin
        s_NewExt := UpperCase(s_NewExt);
      end;
    fc_UncapitalizeAll:
      begin
        s_NewName := LowerCase(s_NewName);
        s_NewExt := LowerCase(s_NewExt);
      end;
    fc_UncapitalizeName:
      begin
        s_NewName := LowerCase(s_NewName);
      end;
    fc_UncapitalizeExtension:
      begin
        s_NewExt := LowerCase(s_NewExt);
      end;
  end;

  s_NewCompleteName := s_NewName + s_NewExt;

  if tofolder = '' then
    s_NewCompleteName := extractfilepath(oldname) + s_NewCompleteName
  else
    s_NewCompleteName := Tbs_AddSlash(tofolder) + s_NewCompleteName;

  if checkexistence then
    s_NewCompleteName := tbs_EnsureUniqueFileName(s_NewCompleteName);

  result := s_NewCompleteName;

end;

{
  function TThumbsBrowserShellProcessor.SH_OP_ReturnRenamedFile(const bUseDefaultFormat: boolean;
  oldname: string;
  tofolder: string;
  idx: integer;
  RenameFormat: TTB_Shell_FileRenameFormat;
  checkexistence: boolean): string;
  begin

  end;
}

procedure TThumbsBrowserShellProcessor.SH_OP_ReturnRenamedFolder_Node(var theFolderNode: TTB_Shell_Tree_Folder_Node;
  const bUseDefaultFormat: boolean; toPath: string; RenameFormat: TTB_Shell_FolderRenameFormat);
var
  s_NewName: string;

  sl: TStringlist;

  s, stoken, sdate, sdate_buff, sFixed: string;
  dt: Tdatetime;

  iPos: integer;
  iSubStrCtr: integer;
  k: integer;
begin

  if bUseDefaultFormat then
    RenameFormat := fDefaultFormat_FolderRename;

  sl := TStringlist.Create;
  try

    s := '';
    sFixed := RenameFormat.FixedStr;

    // Format Strings
    // ----------------------------------------------------------------------
    case RenameFormat.RenameOptions of
      rfd_Subject:
        begin
          s := sFixed;
        end;
      rfd_Subject_Date, rfd_Date_Subject:
        begin
          dt := theFolderNode.node_info.Date_Used;

          sdate := FormatDateTime(RenameFormat.DateFormat, dt);
          sdate_buff := sdate;

          if sFixed = '' then
            s := sdate
          else if RenameFormat.RenameOptions = rfd_Subject_Date then
            s := sFixed + RenameFormat.Sep_Main + sdate
          else if RenameFormat.RenameOptions = rfd_Date_Subject then
            s := sdate + RenameFormat.Sep_Main + sFixed;

        end;
    end;

    s_NewName := s;
    // ----------------------------------------------------------------------

    // Add SubStrings tokens to string list
    // ----------------------------------------------------------------------
    if sFixed <> '' then
      sl.Add(sFixed);

    case RenameFormat.RenameOptions of
      rfd_Subject_Date, rfd_Date_Subject:
        begin
          iSubStrCtr := 0;
          Repeat
            iPos := pos(RenameFormat.Sep_Date, sdate_buff);
            if iPos <> 0 then
            begin
              stoken := copy(sdate_buff, 1, iPos - 1);

              // reposition after the separator and trim sdate_buff to exclude searched characters
              iPos := iPos + length(RenameFormat.Sep_Date);
              sdate_buff := copy(sdate_buff, iPos, length(sdate_buff) - iPos + 1);

              inc(iSubStrCtr);

              // add substring to String list
              if RenameFormat.RenameOptions = rfd_Subject_Date then
                sl.Add(stoken)
              else
                sl.Insert(iSubStrCtr - 1, stoken);
            end;
          until iPos = 0;

          if RenameFormat.RenameOptions = rfd_Subject_Date then
            sl.Add(sdate_buff)
          else
            sl.Insert(iSubStrCtr, sdate_buff);

        end;
    end;
    // -----------------------------------------------------------------------

    if toPath <> '' then
      s_NewName := Tbs_AddSlash(toPath) + s_NewName;

    theFolderNode.node_name := s_NewName;
    setlength(theFolderNode.node_name_SubStrings, sl.Count);
    for k := 0 to sl.Count - 1 do
      theFolderNode.node_name_SubStrings[k] := sl[k];

  finally
    sl.Free;
  end;
end;

function TThumbsBrowserShellProcessor.CompareDate(dt1, dt2: Tdatetime; datemode: TTB_Shell_CompareDateMode): boolean;
var
  dy1, dm1, dd1: word;
  dy2, dm2, dd2: word;
begin
  DecodeDate(dt1, dy1, dm1, dd1);
  DecodeDate(dt2, dy2, dm2, dd2);

  case datemode of
    cd_date:
      result := (dy1 = dy2) and (dm1 = dm2) and (dd1 = dd2);
    cd_year:
      result := (dy1 = dy2);
    cd_yearmonth:
      result := (dy1 = dy2) and (dm1 = dm2);
  else
    result := False;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_GetFilenameList(var fl: TStringlist; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition);
  procedure AddName(theThumb: TTHumbEX);
  var
    test_canadd: boolean;
  begin
    test_canadd := False;

    case condition of
      IfNo_condition:
        test_canadd := true;
      IfSelected:
        test_canadd := theThumb.selected;
      IfChecked:
        test_canadd := theThumb.Checked;
    end;

    if test_canadd then
    begin
      if theThumb.Source_IS_WIA then
        fl.Add(GetWiaFileName(fattachedBrowser.GetAbsoluteIdx(theThumb)))
      else if theThumb.Source_IS_WPD then
        fl.Add(GetWPDFileName(fattachedBrowser.GetAbsoluteIdx(theThumb)))
      else
        fl.Add(theThumb.SourceFileName);

    end;
  end;

var
  i: integer;
  athumb: TTHumbEX;
  dt: Tdatetime;
  dy, dm, dd: word;
  c_dy, c_dm, c_dd: word;
  c_dy_s, c_dm_s, c_dd_s: word;
  c_dy_e, c_dm_e, c_dd_e: word;
begin

  with fattachedBrowser do
  begin
    fl.clear;
    case om of
      omPickAll:
        begin
          for i := 0 to ThumbsCount - 1 do
            AddName(Thumbat(i));
        end;
      omPickSelected:
        begin
          for i := 0 to SelectedCount - 1 do
            AddName(GetSelected(i));
        end;
      omPickChecked:
        begin
          for i := 0 to CheckedCount - 1 do
            AddName(GetChecked(i));
        end;
      omPickRotated:
        begin
          // ShowMessage(inttostr(RotatedCount));
          for i := 0 to rotatedCount - 1 do
            AddName(getrotated(i));
        end;

      omPickSameDate:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if (dy = c_dy) and (dm = c_dm) and (dd = c_dd) then
              AddName(athumb);
          end;
        end;

      omPickSameDateRange:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_DateRange_Start, c_dy_s, c_dm_s, c_dd_s);
            DecodeDate(Compare_DateRange_End, c_dy_e, c_dm_e, c_dd_e);

            if (dy >= c_dy_s) and (dy <= c_dy_e) and (dm >= c_dm_s) and (dm <= c_dm_e) and (dd >= c_dd_s) and
              (dd <= c_dd_e) then
              AddName(athumb);
          end;
        end;

      omPickSameExifDate:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceExifFileDate;
            if not tbs_ExifDateisValid(dt, MinExifYear) then
              dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if (dy = c_dy) and (dm = c_dm) and (dd = c_dd) then
              AddName(athumb);
          end;
        end;

      omPickSameExifDateRange:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceExifFileDate;
            if not tbs_ExifDateisValid(dt, MinExifYear) then
              dt := athumb.SourceFileDate;

            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_DateRange_Start, c_dy_s, c_dm_s, c_dd_s);
            DecodeDate(Compare_DateRange_End, c_dy_e, c_dm_e, c_dd_e);

            if (dy >= c_dy_s) and (dy <= c_dy_e) and (dm >= c_dm_s) and (dm <= c_dm_e) and (dd >= c_dd_s) and
              (dd <= c_dd_e) then
              AddName(athumb);
          end;
        end;
      omPicksameYear:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if dy = c_dy then
              AddName(athumb);
          end;
        end;
      omPicksameExifYear:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceExifFileDate;
            if not tbs_ExifDateisValid(dt, MinExifYear) then
              dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if dy = c_dy then
              AddName(athumb);
          end;
        end;
      omPicksameYearMonth:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if (dy = c_dy) and (dm = c_dm) then
              AddName(athumb);
          end;
        end;
      omPicksameExifYearMonth:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceExifFileDate;
            if not tbs_ExifDateisValid(dt, MinExifYear) then
              dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if (dy = c_dy) and (dm = c_dm) then
              AddName(athumb);
          end;
        end;

      omPicksameMonth:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if dm = c_dm then
              AddName(athumb);
          end;
        end;
      omPicksameDay:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            DecodeDate(dt, dy, dm, dd);
            DecodeDate(Compare_Date, c_dy, c_dm, c_dd);
            if dd = c_dd then
              AddName(athumb);
          end;
        end;
      omPickSameDatetime:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            dt := athumb.SourceFileDate;
            if abs(dt - Compare_Date) <= 0.0000000001 then
              AddName(athumb);
          end;
        end;
      omPickFolders:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_Folder then
              AddName(athumb);
          end;
        end;
      omPickFiles:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_File then
              AddName(athumb);
          end;
        end;
      omPickWPDFolders:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_WPDFolder then
              AddName(athumb);
          end;
        end;
      omPickWPDFiles:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_WPDFile then
              AddName(athumb);
          end;
        end;
      omPickUrls:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_URL then
              AddName(athumb);
          end;
        end;
      omPickWia:
        begin
          for i := 0 to ThumbsCount - 1 do
          begin
            athumb := Thumbat(i);
            if athumb.SourceType = st_WIA then
              AddName(athumb);
          end;
        end;

    end;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_GetFilenameList_Checked(var fl: TStringlist);
begin
  SH_OP_GetFilenameList(fl, omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_GetFilenameList_Selected(var fl: TStringlist);
begin
  SH_OP_GetFilenameList(fl, omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_GetTreeNodes_byDate(var dl: TTB_Shell_Tree_Folders_NodeArray;
  mode: TTB_Shell_FolderNodes_PickMode; const IgnoreExif: boolean; condition: TTB_Browser_PickCondition);

  procedure Node_Folder_SetInfo_Date(var aItem: TTB_Shell_Tree_Folder_Node; theDate: Tdatetime; bDateIsExif: boolean);
  begin
    aItem.node_info.Date_Used := theDate;

    if bDateIsExif then
    begin
      aItem.node_info.Date_EXIF := theDate;
    end
    else
    begin
      aItem.node_info.date := theDate;
    end;
  end;

  procedure Node_File_SetInfo_Date(var aItem: TTB_Shell_Tree_File_Node; theDate: Tdatetime; bDateIsExif: boolean);
  begin
    aItem.node_info.Date_Used := theDate;

    if bDateIsExif then
    begin
      aItem.node_info.Date_EXIF := theDate;
    end
    else
    begin
      aItem.node_info.date := theDate;
    end;
  end;

  procedure AddChild_File(var parent: TTB_Shell_Tree_Folder_Node; theDate: Tdatetime; bDateIsExif: boolean;
    theThumb: TTHumbEX; const theThumbIdx: integer);
  var
    test_canadd: boolean;
  begin
    test_canadd := False;

    case condition of
      IfNo_condition:
        test_canadd := true;
      IfSelected:
        test_canadd := theThumb.selected;
      IfChecked:
        test_canadd := theThumb.Checked;
    end;

    if not test_canadd then
      exit;

    inc(parent.FilesCount);
    if length(parent.files) < parent.FilesCount then
      setlength(parent.files, parent.FilesCount + 10);

    Node_File_SetInfo_Date(parent.files[parent.FilesCount - 1], theDate, bDateIsExif);

    // ------Save theThumb Index of the node---------------------------------------
    // parent.files[parent.FilesCount - 1].idx := max(0, fattachedbrowser.GetVisibleThumbIdxfromThumbID(fattachedbrowser.Thumbs.IndexOf(thethumb)));
    parent.files[parent.FilesCount - 1].idx := theThumbIdx;

    // ------Save theThumb Index of the node---------------------------------------
  end;

var
  i: integer;
  athumb: TTHumbEX;
  adate: Tdatetime;
  bDateIsExif: boolean;
  aCandidateNode: TTB_Shell_Tree_Folder_Node;
  currentFolder: integer;
begin
  setlength(dl, 0);

  if not SH_OP_ENABLED then
    exit;

  if fattachedBrowser.ThumbsCount = 0 then
    exit; // EXIT

  // must loop through all thumbs in order to detect folders (do not apply condition here!)
  for i := 0 to fattachedBrowser.ThumbsCount - 1 do // do not change this!
  begin
    athumb := fattachedBrowser.Thumbat(i);

    if IgnoreExif then
    begin
      adate := athumb.SourceFileDate;
      bDateIsExif := False;
    end
    else
    begin
      adate := athumb.SourceExifFileDate;
      if not tbs_ExifDateisValid(adate, MinExifYear) then
      begin
        bDateIsExif := False;
        adate := athumb.SourceFileDate;
      end
      else
        bDateIsExif := true;
    end;

    aCandidateNode := SH_Node_Folder_DefineNew('');
    Node_Folder_SetInfo_Date(aCandidateNode, adate, bDateIsExif);
    currentFolder := SH_Nodes_CheckAddFolder(dl, aCandidateNode, mode);
    if currentFolder >= 0 then
      AddChild_File(dl[currentFolder], adate, bDateIsExif, athumb, i);
  end;
end;

function TThumbsBrowserShellProcessor.SH_Node_Folder_DefineNew(const theRelativePAth: string)
  : TTB_Shell_Tree_Folder_Node;
begin
  with result do
  begin
    node_name := '';
    node_relativepath := theRelativePAth;
    with node_info do
    begin
      date := now;
      Date_EXIF := date;
      Date_Used := date;
    end;
    FilesCount := 0;
    files := nil;
    FolderIdx := -1;

  end;
end;

function TThumbsBrowserShellProcessor.SH_Nodes_CompareDate(node1, node2: TTB_Shell_Tree_Folder_Node;
  checkmode: TTB_Shell_FolderNodes_PickMode): boolean;
var
  yy1, mm1, dd1: word;
  yy2, mm2, dd2: word;
begin
  DecodeDate(node1.node_info.Date_Used, yy1, mm1, dd1);
  DecodeDate(node2.node_info.Date_Used, yy2, mm2, dd2);

  // Establish if date is new or it is duplicate
  case checkmode of
    fn_PickSameDate:
      result := ((dd1 = dd2) and (mm1 = mm2) and (yy1 = yy2));
    fn_PicksameYear:
      result := (yy1 = yy2);
    fn_PicksameMonth:
      result := (mm1 = mm2);
    fn_PicksameDay:
      result := (dd1 = dd2);
    fn_PicksameYearMonth:
      result := ((mm1 = mm2) and (yy1 = yy2));
  else
    result := False;
  end;
end;

function TThumbsBrowserShellProcessor.SH_Nodes_CheckAddFolder(var dl: TTB_Shell_Tree_Folders_NodeArray;
  theCandidateNode: TTB_Shell_Tree_Folder_Node; checkmode: TTB_Shell_FolderNodes_PickMode): integer;
var
  j: integer;
  bFoundNew: boolean;

  FirstFound: integer;
begin

  if length(dl) = 0 then
  begin
    setlength(dl, 1);
    dl[0] := theCandidateNode;
    result := 0;
    exit;
  end;

  // Loop on previous nodes to check if there is already a node folder that matches the node criteria
  bFoundNew := true;
  j := high(dl);
  FirstFound := -1;
  while (bFoundNew = true) and (j >= 0) do
  begin

    // Establish if date is new or it is duplicate
    case checkmode of
      fn_PickSameDate, fn_PicksameYear, fn_PicksameMonth, fn_PicksameDay, fn_PicksameYearMonth:
        begin
          bFoundNew := not SH_Nodes_CompareDate(theCandidateNode, dl[j], checkmode);
        end;
    end;

    if not bFoundNew then // if folder match is found then stop searching
    begin
      FirstFound := j;
      Break;
    end;

    dec(j);
  end;

  // if folder date is new then first create the folder
  if bFoundNew then
  begin
    setlength(dl, length(dl) + 1);
    dl[high(dl)] := theCandidateNode;
    result := high(dl);
  end
  else
  begin
    // dl[FirstFound] := theCandidateNode;
    result := FirstFound;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_Copy_TO_ClipBoard(om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_Copy_TO_ClipBoard(fl);
  finally
    fl.Free;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_Copy_TO_ClipBoard(theFiles: TStringlist);
begin
  if theFiles.Count > 0 then
  begin
    fClipboard_Rcd.CopyToClip(theFiles);
    fClipboard_Rcd.SetInternalMode;
    TBCopyFilenamesToClipboard(AttachedBrowser.Handle, theFiles);
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Copy_TO_ClipBoard_Checked;
begin
  SH_OP_Copy_TO_ClipBoard(omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Copy_TO_ClipBoard_Selected;
begin
  SH_OP_Copy_TO_ClipBoard(omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Cut_TO_ClipBoard(om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_Cut_TO_ClipBoard(fl);
  finally
    fl.Free;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_Cut_TO_ClipBoard(theFiles: TStringlist);
begin
  if theFiles.Count > 0 then
  begin
    fClipboard_Rcd.CutToClip(theFiles);
    fClipboard_Rcd.SetInternalMode;
    TBCutFilenamesToClipboard(AttachedBrowser.Handle, theFiles);
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Cut_TO_ClipBoard_Checked;
begin
  SH_OP_Cut_TO_ClipBoard(omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Cut_TO_ClipBoard_Selected;
begin
  SH_OP_Cut_TO_ClipBoard(omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_ShowClipboardContentInBrowser;
var
  files: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;
  if not fClipboard_Rcd.HasFiles then
    exit;

  files := TStringlist.Create;
  try
    fClipboard_Rcd.GetFiles(files, [shft_File, shft_Folder, shft_Url]);

    fattachedBrowser.StartBrowsing(files);
  finally
    files.Free;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_START;
begin
  if fInProcessCtr < 0 then // if previously aborted reset to zero
    fInProcessCtr := 0;

  inc(fInProcessCtr);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_END;
begin
  if fInProcessCtr > 0 then
    dec(fInProcessCtr);
end;

function TThumbsBrowserShellProcessor.SH_OP_GetClipboardFileCount: integer;
var
  files: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  result := 0;
  if not fClipboard_Rcd.HasFiles then
    exit;

  files := TStringlist.Create;
  try
    fClipboard_Rcd.GetFiles(files, [shft_File, shft_Folder, shft_Url]);
    result := files.Count;
  finally
    files.Free;
  end;
end;

function TThumbsBrowserShellProcessor.SH_OP_ClipboardHasFiles: boolean;
begin
  result := fClipboard_Rcd.HasFiles;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Paste_FromClipboardToFolder(theFolder: string);
var
  srcFilesCopy, srcFilesCut, srcUrls: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;
  if not fClipboard_Rcd.HasFiles then
    exit;

  fClipboard_Rcd.UnSetInternalMode;

  srcFilesCopy := TStringlist.Create;
  srcFilesCut := TStringlist.Create;
  srcUrls := TStringlist.Create;
  try
    // first paste normal files and folders
    fClipboard_Rcd.GetFilesToCopyOrCut(srcFilesCopy, srcFilesCut, [shft_File, shft_Folder]);

    TBCopyFileList(TBFileListToShellParamStr(srcFilesCopy), theFolder);
    TBMoveFileList(TBFileListToShellParamStr(srcFilesCut), theFolder);
    // ----------------------------------------------------------------------------------------

    // then paste special files such as urls using loading from url and saving to file
    fClipboard_Rcd.GetFiles(srcUrls, [shft_Url]);
    if srcUrls.Count > 0 then
      SH_OP_SaveListTo(theFolder, '', srcUrls);

    fClipboard_Rcd.ClearFilesToCut;
    if srcFilesCut.Count > 0 then
      EmptyClipboard;

    if assigned(fOnClipBoardChanged) then
      fOnClipBoardChanged(fClipboard_Rcd.HasFiles, self);
  finally
    srcUrls.Free;
    srcFilesCut.Free;
    srcFilesCopy.Free;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Delete(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_Delete(fl, False, true);
  finally
    fl.Free;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_Delete(theFiles: TStringlist; bSendToBin: boolean; bRemoveThumbs: boolean);
var
  L: TStringlist;
  i, thID: integer;
  athumb: TTHumbEX;
  toDel: TList;
begin
  if theFiles.Count = 0 then
    exit;

  toDel := TList.Create;
  try
    // first handle normal files
    L := TStringlist.Create;
    try
      TBExtractPureFileList(theFiles, L);

      if bSendToBin then
        TBRecycleFileList(TBFileListToShellParamStr(L))
      else
        TBDeleteFileList(TBFileListToShellParamStr(L));

      if bRemoveThumbs and assigned(fattachedBrowser) then
      begin
        for i := 0 to L.Count - 1 do
        begin
          athumb := fattachedBrowser.Thumbat(L[i]);
          if assigned(athumb) then
            if not fileexists(L[i]) then
              toDel.Add(athumb);
        end;
      end;

    finally
      L.Free;
    end;

    // now delete the wpds
    if assigned(fattachedBrowser) then
    begin
{$IFDEF TB_PORTABLEDEVICE}
      L := TStringlist.Create;
      try
        TBExtractwpdFromFileList(theFiles, L);
        if L.Count > 0 then
        begin
          if (not bSendToBin) or (messagedlg(Format(TBResStr[IDRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD],
            [inttostr(L.Count)]), mtconfirmation, [mbyes, mbno], 0) = mryes) then
          begin
            for i := 0 to L.Count - 1 do
            begin
              thID := ExtractWPdThumbId(L[i]);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);

              if SH_OP_DeleteWPDObject(athumb) then
              begin
                if bRemoveThumbs and assigned(athumb) then
                  toDel.Add(athumb);
              end;

              if assigned(OnProgress) then
                OnProgress(self, TBGetPercent(i + 1, 1, L.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
            end;
          end;
        end;
      finally
        L.Free;
      end;
{$ENDIF}
    end;

    // now delete WIA
    if assigned(fattachedBrowser) then
    begin
      L := TStringlist.Create;
      try
        TBExtractwiaFromFileList(theFiles, L);
        if L.Count > 0 then
        begin
          if (not bSendToBin) or (messagedlg(Format(TBResStr[IDRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA],
            [inttostr(L.Count)]), mtconfirmation, [mbyes, mbno], 0) = mryes) then
          begin
            for i := 0 to L.Count - 1 do
            begin
              thID := ExtractWiaThumbId(L[i]);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);

              fattachedBrowser.WIA_IO.WIAParams.DeleteItem(athumb.AttachedWIAItem);
              if fattachedBrowser.WIA_IO.WIAParams.IsItemDeleted(athumb.AttachedWIAItem) then
              begin
                if bRemoveThumbs and assigned(athumb) then
                  toDel.Add(athumb);
              end;

              if assigned(OnProgress) then
                OnProgress(self, TBGetPercent(i + 1, 1, L.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
            end;
          end;
        end;
      finally
        L.Free;
      end;
    end;

    // remove thumbs of deleted items from browser
    if bRemoveThumbs and assigned(fattachedBrowser) then
    begin
      fattachedBrowser.LockUpdate;
      try
        for i := 0 to toDel.Count - 1 do
        begin
          athumb := TTHumbEX(toDel[i]);
          if assigned(athumb) then
            fattachedBrowser.Delete_a_Thumb(athumb);
        end;
      finally
        fattachedBrowser.UnlockUpdate;
        fattachedBrowser.RefreshDisplay;
      end;
    end;

  finally
    toDel.Free;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Delete_Checked;
begin
  SH_OP_Delete(omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Delete_Selected;
begin
  SH_OP_Delete(omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_RecycletoBin(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_RecycletoBin(fl, true);
  finally
    fl.Free;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_RecycletoBin(theFiles: TStringlist; bRemoveThumbs: boolean);
begin
  SH_OP_Delete(theFiles, true, bRemoveThumbs);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_RecycletoBin_Checked;
begin
  SH_OP_RecycletoBin(omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_RecycletoBin_Selected;
begin
  SH_OP_RecycletoBin(omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopytoFolder(theFolder: string; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition; theFlags: integer = 0);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_CopytoFolder(theFolder, fl, theFlags);
  finally
    fl.Free;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopytoFolder(theFolder: string; theFiles: TStringlist; theFlags: integer = 0);
var
  urls, wias {$IFDEF TB_PORTABLEDEVICE}, wpds {$ENDIF}: TStringlist;
  thID: integer;
  athumb: TTHumbEX;
  i: integer;
begin
  if theFiles.Count > 0 then
    TBCopyFileList(TBFileListToShellParamStr(theFiles), theFolder, theFlags); // this will copy the files

  // now transfer the urls
  urls := TStringlist.Create;
  try
    TBExtractUrlsFromFileList(theFiles, urls);
    if urls.Count > 0 then
    begin
      for i := 0 to urls.Count - 1 do
      begin
        TBTransferFromUrlToFile(urls[i], Tbs_AddSlash(theFolder) + tbs_UrlExtractFilename(urls[i], true));
        if assigned(OnProgress) then
          OnProgress(self, TBGetPercent(i + 1, 1, urls.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
      end;
    end;
  finally
    urls.Free;
  end;

  if assigned(fattachedBrowser) then
  begin
    // now transfer the WIAs
    wias := TStringlist.Create;
    try
      TBExtractwiaFromFileList(theFiles, wias);
      if wias.Count > 0 then
      begin
        for i := 0 to wias.Count - 1 do
        begin
          thID := ExtractWiaThumbId(wias[i]);
          athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);
          if assigned(athumb) then
            SH_OP_TransferWiaItemToFolder(athumb, Tbs_AddSlash(theFolder), False, fWiaImportJpegQuality);

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, wias.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
        end;
      end;
    finally
      wias.Free;
    end;

{$IFDEF TB_PORTABLEDEVICE}
    // now transfer the WPDS
    wpds := TStringlist.Create;
    try
      TBExtractwpdFromFileList(theFiles, wpds);
      if wpds.Count > 0 then
      begin
        for i := 0 to wpds.Count - 1 do
        begin
          thID := ExtractWiaThumbId(wpds[i]);
          athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);
          if assigned(athumb) then
            SH_OP_TransferWPDObjectToFolder(athumb, Tbs_AddSlash(theFolder), False);

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, wpds.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
        end;
      end;
    finally
      wpds.Free;
    end;
{$ENDIF}
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopytoFolder_Checked(theFolder: string; theFlags: integer = 0);
begin
  SH_OP_CopytoFolder(theFolder, omPickChecked, IfNo_condition, theFlags);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopytoFolder_Selected(theFolder: string; theFlags: integer = 0);
begin
  SH_OP_CopytoFolder(theFolder, omPickSelected, IfNo_condition, theFlags);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_MovetoFolder(theFolder: string; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition; theFlags: integer = 0);
var
  fl: TStringlist;
  i: integer;
  athumb: TTHumbEX;
  newName: string;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  fattachedBrowser.LockUpdate;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    if fl.Count > 0 then
    begin
      SH_OP_MovetoFolder(theFolder, fl, theFlags);

      // now remove moved thumbnails because they have different filenames
      for i := 0 to fl.Count - 1 do
      begin
        if not fileexists(fl[i]) then
        begin

          athumb := fattachedBrowser.Thumbat(fl[i]);
          newName := Tbs_AddSlash(theFolder) + extractfilename(athumb.SourceFileName);
          if (fileexists(newName)) and (fattachedBrowser.InPaths(newName)) then
          begin
            athumb.SourceFileName := Tbs_AddSlash(theFolder) + extractfilename(athumb.SourceFileName);
            athumb.RefreshCaptions;
          end
          else
            fattachedBrowser.Delete_a_Thumb(athumb);
        end;
      end;
    end;
  finally
    fattachedBrowser.UnlockUpdate;
    fl.Free;
    fattachedBrowser.RefreshDisplay;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_MovetoFolder(theFolder: string; theFiles: TStringlist; theFlags: integer = 0);
var
  urls, wias{$IFDEF TB_PORTABLEDEVICE}, wpds {$ENDIF}: TStringlist;
  thID: integer;
  athumb: TTHumbEX;
  i: integer;
begin
  if theFiles.Count > 0 then
    TBMoveFileList(TBFileListToShellParamStr(theFiles), theFolder, theFlags);

  // now transfer the urls
  urls := TStringlist.Create;
  try
    TBExtractUrlsFromFileList(theFiles, urls);
    if (urls.Count > 0) and (messagedlg(TBResStr[IDRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED], mtconfirmation,
      [mbyes, mbno], 0) = mryes) then
    begin
      for i := 0 to urls.Count - 1 do
      begin
        TBTransferFromUrlToFile(urls[i], Tbs_AddSlash(theFolder) + tbs_UrlExtractFilename(urls[i], true));
        if assigned(OnProgress) then
          OnProgress(self, TBGetPercent(i + 1, 1, urls.Count), TBResStr[IDRS_SH_OP_MOVINGFILES]);
      end;
    end;
  finally
    urls.Free;
  end;

  if assigned(fattachedBrowser) then
  begin
    // now transfer the WIAs
    wias := TStringlist.Create;
    try
      TBExtractwiaFromFileList(theFiles, wias);
      if wias.Count > 0 then
      begin
        for i := 0 to wias.Count - 1 do
        begin
          thID := ExtractWiaThumbId(wias[i]);
          athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);
          if assigned(athumb) then
            SH_OP_TransferWiaItemToFolder(athumb, Tbs_AddSlash(theFolder), true, fWiaImportJpegQuality);

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, wias.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
        end;
      end;
    finally
      wias.Free;
    end;

{$IFDEF TB_PORTABLEDEVICE}
    // now transfer the WPDS
    wpds := TStringlist.Create;
    try
      TBExtractwpdFromFileList(theFiles, wpds);
      if wpds.Count > 0 then
      begin
        for i := 0 to wpds.Count - 1 do
        begin
          thID := ExtractWiaThumbId(wpds[i]);
          athumb := fattachedBrowser.Thumbat_AbsoluteIdx(thID);
          if assigned(athumb) then
            SH_OP_TransferWPDObjectToFolder(athumb, Tbs_AddSlash(theFolder), true);

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, wpds.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
        end;
      end;
    finally
      wpds.Free;
    end;
{$ENDIF}
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_MovetoFolder_Checked(theFolder: string; theFlags: integer = 0);
begin
  SH_OP_MovetoFolder(theFolder, omPickChecked, IfNo_condition, theFlags);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_MovetoFolder_Selected(theFolder: string; theFlags: integer = 0);
begin
  SH_OP_MovetoFolder(theFolder, omPickSelected, IfNo_condition, theFlags);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rename(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean; om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition);

  function CheckAddFileTypeFolder(thename: String): string;
  var
    spath: string;
    sname: string;
  begin
    if bAddFolderByFileType then
    begin
      sname := extractfilename(thename);
      spath := extractfilepath(thename);
      spath := spath + Tbs_AddSlash(tbs_GetExtensionFolder(sname, FolderRenameFormat.TypeFolder_Capitalized));
      if not SysUtils.directoryexists(spath) then
        SysUtils.forcedirectories(spath);
      result := spath + sname;
    end
    else
      result := thename;
  end;

  function dorename(oldname, newName: string): boolean;
  var
    drive_old: string;
    drive_new: string;
  begin

    try
      drive_old := ExtractFileDrive(oldname);
      drive_new := ExtractFileDrive(newName);

      if CompareText(drive_old, drive_new) = 0 then
      begin
        result := renamefile(oldname, newName);
      end
      else
      begin

        result := TBCopyFile(oldname, newName, true);
        if result then
        begin
          if fileexists(oldname) then
            DeleteFile(oldname);
        end;
      end;

    except
      result := False;
    end;
  end;

  function docopyrename(oldname, newName: string): boolean;
  begin
    try
      result := TBCopyFile(oldname, newName, true);
    except
      result := False;
    end;
  end;

  procedure DoRenameThumb(theThumb: TTHumbEX; newName: string);
  begin
    if assigned(theThumb) then
    begin
      theThumb.SourceFileName := newName;
      if theThumb.SourceType <> st_File then
        theThumb.SourceType := st_File;

      theThumb.RefreshCaptions;
    end;
  end;

  procedure DoRenameThumbs(oldname, newName: string);
  var
    k: integer;
    LThumbs: TList;
  begin
    LThumbs := TList.Create;
    try
      fattachedBrowser.GetThumbsByFileName(oldname, LThumbs, true);
      for k := LThumbs.Count - 1 downto 0 do
        DoRenameThumb(TTHumbEX(LThumbs[k]), newName);

    finally
      LThumbs.Free;
    end;
  end;

var
  fl: TStringlist;
  i: integer;
  oldname, newName, newname_temp: string;

  athumb: TTHumbEX;
  bIsWia, bIsWPD: boolean;
  WIAThumbID, WPDThumbID: integer;
begin
  if not SH_OP_ENABLED then
    exit;

  SH_OP_START;
  try
    fl := TStringlist.Create;
    fattachedBrowser.LockUpdate;
    try
      SH_OP_GetFilenameList(fl, om, condition);
      if fl.Count > 0 then
      begin
        for i := 0 to fl.Count - 1 do
        begin
          if Aborted then
          begin
            if assigned(OnProgress) then
              OnProgress(self, 100);
            Break;
          end;
          oldname := fl[i];

          bIsWia := IsFileNameWIA(oldname);
          bIsWPD := IsFileNameWPD(oldname);

          // if picture comes from WIA is handled in different way
          if bIsWia then
          begin
            try
              WIAThumbID := ExtractWiaThumbId(oldname);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(WIAThumbID);
              if athumb.Source_IS_WIA then
              begin
                oldname := athumb.SourceFileName;
                newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, true);

                if bAddFolderByFileType then
                begin
                  newName := CheckAddFileTypeFolder(newName);
                  newName := tbs_EnsureUniqueFileName(newName);
                end;

                if SH_OP_TransferWiaItem(athumb, newName, true, fWiaImportJpegQuality) then
                begin
                  DoRenameThumb(athumb, newName);
                  if assigned(OnRenamedFile) then
                    OnRenamedFile(oldname, newName);
                end;

              end;
            except
              ;
            end;

          end
          else if bIsWPD then
          begin
{$IFDEF TB_PORTABLEDEVICE}
            try
              WPDThumbID := ExtractWPdThumbId(oldname);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(WPDThumbID);
              if athumb.Source_IS_WPD then
              begin

                oldname := athumb.SourceFileName;
                newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, true);

                if bAddFolderByFileType then
                begin
                  newName := CheckAddFileTypeFolder(newName);
                  newName := tbs_EnsureUniqueFileName(newName);
                end;
                if SH_OP_TransferWPDObject(athumb, newName, true) then
                begin
                  DoRenameThumb(athumb, newName);
                  if assigned(OnRenamedFile) then
                    OnRenamedFile(oldname, newName);
                end;

              end;
            except
              ;
            end;
{$ENDIF}
          end
          else
          begin
            // picture comes from file-system
            athumb := fattachedBrowser.Thumbat(oldname);
            newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, False);
            // get new name
            if bAddFolderByFileType then // add file type folder if needed
            begin
              newName := CheckAddFileTypeFolder(newName);
            end;

            // now check if we are renaming same file with same name
            if CompareText(oldname, newName) = 0 then
            // we are renaming the source file in the source folder with same name
            begin // still we may need to change capitalization

              // two steps renaming (to avoid windows not understanding the difference in file name due to capitalization
              newname_temp := tbs_EnsureUniqueFileName(newName);
              if dorename(oldname, newname_temp) then
              begin
                if dorename(newname_temp, newName) then
                begin

                  DoRenameThumb(athumb, newName);

                  if assigned(OnRenamedFile) then
                    OnRenamedFile(oldname, newName);
                end
                else // for some reason first step failed
                  dorename(newname_temp, oldname); // revert to old name
              end;
            end
            else
            begin
              newName := tbs_EnsureUniqueFileName(newName);
              // ensure there is no file with the same name in destination folder

              if dorename(oldname, newName) then // if rename is successfull
              begin
                DoRenameThumb(athumb, newName);

                if assigned(OnRenamedFile) then
                  OnRenamedFile(oldname, newName);
              end
              else
              begin // else try a copy rename
                if docopyrename(oldname, newName) then
                begin
                  // DoRenameThumbs(oldname, newname);
                  DoRenameThumb(athumb, newName);

                  if assigned(OnRenamedCopiedFile) then
                    OnRenamedCopiedFile(oldname, newName);
                end;
              end;

            end;
          end;

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, fl.Count), TBResStr[IDRS_SH_OP_MOVINGFILES]);
        end;
      end;

    finally
      fattachedBrowser.UnlockUpdate;
      fl.Free;
      fattachedBrowser.RefreshDisplay;
    end;

  finally
    SH_OP_END;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rename_Checked(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean);
begin
  SH_OP_Rename(bUseDefaultFormat, FileRenameFormat, FolderRenameFormat, tofolder, bAddFolderByFileType, omPickChecked,
    IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rename_Selected(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean);
begin
  SH_OP_Rename(bUseDefaultFormat, FileRenameFormat, FolderRenameFormat, tofolder, bAddFolderByFileType, omPickSelected,
    IfNo_condition);
end;

{$IFDEF TB_PORTABLEDEVICE}

function TThumbsBrowserShellProcessor.SH_OP_DeleteWPDObject(athumb: TTHumbEX): boolean;
begin
  result := fattachedBrowser.WPD.DeleteFromDevice(athumb.AttachedWPDInfo.DevID, athumb.AttachedWPDInfo.Rcd.ID) <> -1;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function TThumbsBrowserShellProcessor.SH_OP_TransferWPDObjectToFolder(athumb: TTHumbEX; theFolder: string;
  bDeleteObject: boolean): boolean;
var
  newName: string;
  FileRenameFormat: TTB_Shell_FileRenameFormat;
begin
  FileRenameFormat := fDefaultFormat_FileRename;
  FileRenameFormat.RenameOptions := rf_donotrename;
  newName := SH_OP_ReturnRenamedFile(False, athumb, theFolder, 0, FileRenameFormat, true);

  result := SH_OP_TransferWPDObject(athumb, newName, bDeleteObject);
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function TThumbsBrowserShellProcessor.SH_OP_TransferWPDObject(athumb: TTHumbEX; theFilename: string;
  bDeleteObject: boolean): boolean;
begin
  result := fattachedBrowser.WPD.CopyFileFromDevice(athumb.AttachedWPDInfo.DevID, athumb.AttachedWPDInfo.Rcd.ID,
    theFilename);
  if result and bDeleteObject then
    fattachedBrowser.WPD.DeleteFromDevice(athumb.AttachedWPDInfo.DevID, athumb.AttachedWPDInfo.Rcd.ID);
end;
{$ENDIF}

function TThumbsBrowserShellProcessor.SH_OP_TransferWiaItemToFolder(athumb: TTHumbEX; theFolder: string;
  bDeleteTakenPic: boolean; jpegTransferQty: TTB_Browser_WIA_Transfer_JpegQuality): boolean;
var
  newName: string;
  FileRenameFormat: TTB_Shell_FileRenameFormat;
begin
  FileRenameFormat := fDefaultFormat_FileRename;
  FileRenameFormat.RenameOptions := rf_donotrename;
  newName := SH_OP_ReturnRenamedFile(False, athumb, theFolder, 0, FileRenameFormat, true);
  result := SH_OP_TransferWiaItem(athumb, newName, bDeleteTakenPic, fWiaImportJpegQuality);
end;

function TThumbsBrowserShellProcessor.SH_OP_TransferWiaItem(athumb: TTHumbEX; var theFilename: string;
  bDeleteTakenPic: boolean; jpegTransferQty: TTB_Browser_WIA_Transfer_JpegQuality): boolean;
  function replaceExt(fname, ext: string): string;
  var
    oldExt, NewExt: string;
    i: integer;
    bCap: boolean;

  begin
    oldExt := extractfileext(fname);
    NewExt := '';
    bCap := False;
    for i := 1 to length(ext) do
    begin
      if i = length(ext) then // if last character
        bCap := oldExt[length(oldExt)] = UpperCase(oldExt[length(oldExt)]) // check last character of old extension
      else if i < length(oldExt) then
        bCap := oldExt[i] = UpperCase(oldExt[i]); // check character by character
      // else bCap will stay same as last case

      if bCap then
        NewExt := NewExt + UpperCase(ext[i])
      else
        NewExt := NewExt + LowerCase(ext[i]);
    end;

    result := changefileext(theFilename, NewExt)
  end;

{$IFDEF NWSCOMPS_IEWIA_PATCH}
  function TransferDirect: boolean;
  begin
    fattachedBrowser.WIA_IO.WIAParams.TakePicture := False;
    // this only activates the camera or a scanner to take a picture!!
    fattachedBrowser.WIA_IO.WIAParams.SaveTransferBufferAs := theFilename;
    fattachedBrowser.WIA_IO.WIAParams.DeleteTakenPicture := bDeleteTakenPic;
    fattachedBrowser.WIA_IO.WIAParams.TransferFormat := ietfCustom;
    // fattachedBrowser.WIA_IO.WIAParams.ProcessingBitmap := nil;
    result := fattachedBrowser.WIA_IO.WIAParams.Transfer(athumb.AttachedWIAItem, False);

    {
      if TBDetectSameOrientation(srcname) then
      begin
      tbs_removeFileReadOnly(srcname);
      TBCorrectJpegOrientationLossless(srcname, athumb.SourceExif_Orientation);
      athumb.SourceExif_Orientation := 1;
      end;
    }
    // TBCorrectJpegOrientationLossless();
    // TBCorrectTiffOrientation();
  end;
{$ENDIF}
  function TransferThroughMemoryBmp: boolean;
  var
    WiaBMP: TIEBitmap;
    aIo: timageenio;

    bTransferAsPng: boolean;
  begin
    fattachedBrowser.WIA_IO.WIAParams.TakePicture := False;
    // this only activates the camera or a scanner to take a picture!!
    fattachedBrowser.WIA_IO.WIAParams.DeleteTakenPicture := False; // we delete it manually lateron
    fattachedBrowser.WIA_IO.WIAParams.TransferFormat := ietfDefault;

    WiaBMP := TIEBitmap.Create();
    aIo := timageenio.Create(nil);
    try
      fattachedBrowser.WIA_IO.WIAParams.ProcessingBitmap := WiaBMP;
      result := fattachedBrowser.WIA_IO.WIAParams.Transfer(athumb.AttachedWIAItem, False);

      if result then
      begin
        aIo.AttachedIEBitmap := WiaBMP;

        aIo.Params.PNG_Filter := ioPNG_FILTER_PAETH;
        aIo.Params.PNG_Compression := 0;

        // if we move the file or it is not a jpg
        if tbs_FileExtIsTif(extractfileext(theFilename)) then
        begin
          aIo.SaveToFileTIFF(theFilename);
        end
        else
        begin
          bTransferAsPng := (not tbs_FileExtIsJPG(extractfileext(theFilename))) or (jpegTransferQty = wtq_Png);
          if bTransferAsPng then
          begin
            // we save to a png file for maximum quality and compression
            theFilename := replaceExt(theFilename, '.png');
            theFilename := tbs_EnsureUniqueFileName(theFilename);
            aIo.SaveToFilePng(theFilename);
          end
          else
          begin
            if jpegTransferQty = wtq_Jpeg96 then
            begin
              aIo.Params.JPEG_ColorSpace := ioJPEG_RGB;
              aIo.Params.JPEG_Quality := 96;
            end
            else
            begin
              aIo.Params.JPEG_ColorSpace := ioJPEG_RGB;
              aIo.Params.JPEG_Quality := 90;
            end;
            aIo.SaveToFileJpeg(theFilename);
          end;
        end;

        result := fileexists(theFilename) and aIo.ParamsFromFile(theFilename); // to make sure we saved a valid file

      end;

    finally
      aIo.Free;
      WiaBMP.Free;
    end;
  end;

var

  witem: IWiaItem;
begin
  result := False;

{$IFDEF NWSCOMPS_IEWIA_PATCH}
  result := TransferDirect;
{$ELSE}
  if tbs_FileExtIsJPG(extractfileext(theFilename)) then
    result := TransferThroughMemoryBmp;
{$ENDIF}
  if result and bDeleteTakenPic then // if we saved a valid file then in case we need to we delete the pic
  begin
    witem := athumb.AttachedWIAItem.This;
    // delete the taken item
    witem.DeleteItem(0);

    // possible alternative to test
    // fattachedBrowser.WIA_IO.WIAParams.DeleteItem(athumb.AttachedWIAItem);
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopyRename(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean; const bCopyFileDates: boolean; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition; const bChangeThumbsNames: boolean);

  function CheckAddFileTypeFolder(thename: String): string;
  var
    spath: string;
    sname: string;
  begin
    if bAddFolderByFileType then
    begin
      sname := extractfilename(thename);
      spath := extractfilepath(thename);
      spath := spath + Tbs_AddSlash(tbs_GetExtensionFolder(sname, FolderRenameFormat.TypeFolder_Capitalized));
      if not SysUtils.directoryexists(spath) then
        SysUtils.forcedirectories(spath);
      result := spath + sname;
    end
    else
      result := thename;
  end;

  function docopyrename(oldname, newName: string): boolean;
  begin
    try
      result := TBCopyFile(oldname, newName, true);
    except
      result := False;
    end;
  end;

  procedure DoSetFileDate(theThumb: TTHumbEX; newName: string);
  begin
    if FileRenameFormat.UseExifDate and theThumb.SourceHasExif and tbs_ExifDateisValid(theThumb.SourceExifFileDate,
      MinExifYear) then
      tbs_SetFileTime(newName, theThumb.SourceExifFileDate, true, true, true)
    else
      tbs_SetFileTime(newName, theThumb.SourceFileDate, true, true, true);
  end;

  procedure DoRenameThumb(theThumb: TTHumbEX; newName: string);
  begin
    if assigned(theThumb) then
    begin

      theThumb.SourceFileName := newName;
      if theThumb.SourceType <> st_File then
        theThumb.SourceType := st_File;

      theThumb.RefreshCaptions;
    end;
  end;

  procedure DoRenameThumbs(oldname, newName: string);
  var
    k: integer;
    LThumbs: TList;
  begin
    LThumbs := TList.Create;
    try
      fattachedBrowser.GetThumbsByFileName(oldname, LThumbs, true);
      for k := LThumbs.Count - 1 downto 0 do
        DoRenameThumb(TTHumbEX(LThumbs[k]), newName);

    finally
      LThumbs.Free;
    end;
  end;

var
  fl: TStringlist;
  i: integer;
  oldname, newName: string;

  athumb: TTHumbEX;
  bIsWia, bIsWPD: boolean;
  WIAThumbID, WPDThumbID: integer;
begin
  if not SH_OP_ENABLED then
    exit;

  SH_OP_START;
  try

    fl := TStringlist.Create;
    fattachedBrowser.LockUpdate;
    try
      SH_OP_GetFilenameList(fl, om, condition);
      if fl.Count > 0 then
      begin
        for i := 0 to fl.Count - 1 do
        begin
          if Aborted then
          begin
            if assigned(OnProgress) then
              OnProgress(self, 100);
            Break;
          end;
          oldname := fl[i];

          bIsWia := IsFileNameWIA(oldname);
          bIsWPD := IsFileNameWPD(oldname);

          if bIsWia then
          begin
            try
              WIAThumbID := ExtractWiaThumbId(oldname);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(WIAThumbID);
              if athumb.Source_IS_WIA then
              begin
                oldname := athumb.SourceFileName;
                newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, true);
                if bAddFolderByFileType then
                begin
                  newName := CheckAddFileTypeFolder(newName);
                  newName := tbs_EnsureUniqueFileName(newName);
                end;
                // Take photo

                if SH_OP_TransferWiaItem(athumb, newName, False, fWiaImportJpegQuality) then
                begin
                  if bChangeThumbsNames then
                    DoRenameThumb(athumb, newName);

                  if bCopyFileDates then
                  begin
                    DoSetFileDate(athumb, newName);
                  end;

                  if assigned(OnRenamedCopiedFile) then
                    OnRenamedCopiedFile(oldname, newName);
                end;

              end;
            except
              ;
            end;

          end
          else if bIsWPD then
          begin
{$IFDEF TB_PORTABLEDEVICE}
            try
              WPDThumbID := ExtractWPdThumbId(oldname);
              athumb := fattachedBrowser.Thumbat_AbsoluteIdx(WPDThumbID);
              if athumb.Source_IS_WPD then
              begin

                oldname := athumb.SourceFileName;
                newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, true);

                if bAddFolderByFileType then
                begin
                  newName := CheckAddFileTypeFolder(newName);
                  newName := tbs_EnsureUniqueFileName(newName);
                end;
                if SH_OP_TransferWPDObject(athumb, newName, False) then
                begin
                  if bChangeThumbsNames then
                    DoRenameThumb(athumb, newName);

                  if bCopyFileDates then
                  begin
                    DoSetFileDate(athumb, newName);
                  end;

                  if assigned(OnRenamedCopiedFile) then
                    OnRenamedCopiedFile(oldname, newName);
                end;

              end;
            except
              ;
            end;
{$ENDIF}
          end
          else
          begin
            athumb := fattachedBrowser.Thumbat(oldname);
            newName := SH_OP_ReturnRenamedFile(bUseDefaultFormat, athumb, tofolder, i, FileRenameFormat, False);
            if bAddFolderByFileType then
            begin
              newName := CheckAddFileTypeFolder(newName);
            end;

            newName := tbs_EnsureUniqueFileName(newName); // ensure unique name

            if newName <> oldname then // otherwise we are renaming exactly the same file
            begin
              if docopyrename(oldname, newName) then
              begin
                if bChangeThumbsNames then
                  DoRenameThumb(athumb, newName);

                if bCopyFileDates then
                begin
                  DoSetFileDate(athumb, newName);
                end;

                if assigned(OnRenamedCopiedFile) then
                  OnRenamedCopiedFile(oldname, newName);
              end;
            end;
          end;

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, fl.Count), TBResStr[IDRS_SH_OP_COPYINGFILES]);
        end;
      end;

    finally
      fattachedBrowser.UnlockUpdate;
      fl.Free;
      fattachedBrowser.RefreshDisplay;
    end;

  finally
    SH_OP_END;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopyRename_Checked(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean; const bCopyFileDates: boolean);
begin
  SH_OP_CopyRename(bUseDefaultFormat, FileRenameFormat, FolderRenameFormat, tofolder, bAddFolderByFileType,
    bCopyFileDates, omPickChecked, IfNo_condition, False);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CopyRename_Selected(const bUseDefaultFormat: boolean;
  FileRenameFormat: TTB_Shell_FileRenameFormat; FolderRenameFormat: TTB_Shell_FolderRenameFormat; tofolder: string;
  const bAddFolderByFileType: boolean; const bCopyFileDates: boolean);
begin
  SH_OP_CopyRename(bUseDefaultFormat, FileRenameFormat, FolderRenameFormat, tofolder, bAddFolderByFileType,
    bCopyFileDates, omPickSelected, IfNo_condition, False);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rotate_Checked(const bAllowOverWriteFile: boolean = true);
begin
  SH_OP_Rotate(omPickChecked, IfNo_condition, bAllowOverWriteFile);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rotate_Selected(const bAllowOverWriteFile: boolean = true);
begin
  SH_OP_Rotate(omPickSelected, IfNo_condition, bAllowOverWriteFile);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_Rotate(om: TTB_Shell_PickMode; condition: TTB_Browser_PickCondition;
  const bAllowOverWriteFile: boolean = true);
type
  TRotationResult = (rrOk, rrFailed, rrUnsupported);

  function RotateNonJpeg(srcname: string; theThumb: TTHumbEX; angle: integer): TRotationResult;
  var
    io: timageenio;
    abmp: TIEBitmap;
    iproc: timageenproc;

    function CheckPixelFormatCanRotate: boolean;
    begin
      result := (abmp.PixelFormat = ie24rgb) or (abmp.PixelFormat = ie1g);
    end;

    procedure SaveToOtherFile(var newName: string);
    var
      renfmt: TTB_Shell_FileRenameFormat;
    begin
      renfmt.RenameOptions := rf_donotrename;
      renfmt.UseExifDate := true;
      renfmt.ChangeExt := true;
      renfmt.NewExt := '.png';
      newName := SH_OP_ReturnRenamedFile(False, theThumb, '', -1, renfmt, true);
      io.Params.PNG_Filter := ioPNG_FILTER_PAETH;
      io.Params.PNG_Compression := 9;
      io.SaveToFile(newName);
    end;

  var
    bSaveToSelf: boolean;
    bIco, bGif, bTif, bOtherFormat: boolean;

    newName: String;
  begin
    newName := srcname;
    result := rrOk;
    io := timageenio.Create(nil);
    abmp := TIEBitmap.Create;
    iproc := timageenproc.Create(nil);
    try
      try
        with io.Params do
        begin
          {
          RAW_Gamma := 0.6;
          RAW_Bright := 1.0;
          RAW_RedScale := 1.0;
          RAW_BlueScale := 1.0;
          RAW_QuickInterpolate := true;
          RAW_UseAutoWB := true;
          RAW_UseCameraWB := False;
          RAW_FourColorRGB := False;
          RAW_AutoAdjustColors := False;
          }
          RAW_QuickInterpolate := false;
          RAW_UseAutoWB := false;
          RAW_UseCameraWB := true;
          RAW_FourColorRGB := false;
          RAW_AutoAdjustColors := false;

        end;
        io.AttachedIEBitmap := abmp;

        if not io.loadfromfile(srcname) then
          Raise Exception.Create('File format not recognized');

        iproc.AttachedIEBitmap := abmp;

        if not CheckPixelFormatCanRotate then
        begin
          abmp.PixelFormat := ie24rgb;
          iproc.Rotate(angle);
          newName := tbs_getUniqueFileName(srcname);
          SaveToOtherFile(newName);
          result := rrUnsupported;
        end
        else
        begin
          iproc.Rotate(angle);

          bIco := False;
          bGif := False;
          bTif := False;
          bOtherFormat := False;
          bSaveToSelf := False; // by default do not save to self
          if not bAllowOverWriteFile then
            bSaveToSelf := False
          else
          begin
            if fattachedBrowser.IsFileExtSupported_Write(extractfileext(srcname)) then
            begin
              if tbs_FileExtIsGif(extractfileext(srcname)) then
                bGif := true
              else if tbs_FileExtIsTif(extractfileext(srcname)) then
                bTif := true
              else if tbs_FileExtIsIco(extractfileext(srcname)) then
                bIco := true
              else
                bOtherFormat := true;

              bSaveToSelf := (bOtherFormat) or (bIco and (length(io.Params.ICO_Sizes) = 1)) OR
                (bGif and (io.Params.GIF_ImageCount = 1)) OR
                (bTif and (io.Params.TIFF_ImageCount = 1) and (not io.Params.TIFF_BigTIFF));
            end;
          end;

          if bTif then // if tif and there is an exif thumb we rotate the thumb before saving
          begin
            if io.Params.EXIF_HasEXIFData then
            begin
              if assigned(io.Params.EXIF_Bitmap) then
              begin
                iproc.AttachedIEBitmap := io.Params.EXIF_Bitmap;
                try
                  iproc.Rotate(angle);
                finally
                  iproc.AttachedIEBitmap := abmp;
                end;
              end;
            end;
          end;

          if bSaveToSelf then
          begin
            io.SaveToFile(srcname); // save to same file when it is a suitable gif, tiff or other format
            result := rrOk;
          end
          else
          begin // if not possible to overwrite the save to other
            newName := tbs_getUniqueFileName(srcname);
            SaveToOtherFile(newName);
            result := rrUnsupported;
          end;
        end;

        if (result = rrUnsupported) and
           (newName <> srcname) and
           {$IFDEF TB_FOLDERMONITOR}(not fattachedBrowser.IsWatchingFolder(extractfilepath(newName)) and {$ENDIF}
           (fattachedBrowser.InPaths(newName))  then
          fattachedBrowser.Add_a_Thumb(newName);

      except
        result := rrFailed;
      end;
    finally
      iproc.Free;
      abmp.Free;
      io.Free;
    end;
  end;
  function Rotateajpglossless(srcname: string; angle: integer): TRotationResult;
  var
    io: timageenio;
  begin
    result := rrOk;

    io := timageenio.Create(nil);
    try
      io.ParamsFromFile(srcname);
      if angle = 90 then
        JpegLosslessTransform2(srcname, jtRotate90, False, jcCopyAll, rect(0, 0, 0, 0))
      else
        JpegLosslessTransform2(srcname, jtRotate270, False, jcCopyAll, rect(0, 0, 0, 0));
      try
      finally
        io.Free;
      end;
      if angle = 90 then
        TBInjectRotatedExifBitmap(srcname, 270)
      else
        TBInjectRotatedExifBitmap(srcname, 90);
    except
      result := rrFailed;
      if assigned(io) then
        io.Free;
    end;

  end;

var
  fl: TStringlist;
  athumb: TTHumbEX;
  srcname: string;
  i: integer;
begin

  if not SH_OP_ENABLED then
    exit;

  SH_OP_START;
  try

    fl := TStringlist.Create;
    fattachedBrowser.LockUpdate;
    try
      SH_OP_GetFilenameList(fl, om, condition);
      if fl.Count > 0 then
      begin
        if assigned(OnProgress) then
            OnProgress(self, 0, TBResStr[IDRS_SH_OP_ROTATINGFILES]);
        for i := 0 to fl.Count - 1 do
        begin
          if Aborted then
          begin
            if assigned(OnProgress) then
              OnProgress(self, 100);
            Break;
          end;

          athumb := fattachedBrowser.Thumbat(fl[i]);
          if (assigned(athumb)) and (athumb.RotateMode <> TRmNone) then
          begin
            srcname := athumb.SourceFileName;

            if (not athumb.Source_IS_WIA) and (not tbs_FileExtIsVIDEO(extractfileext(srcname))) then
            begin
              if athumb.RotateMode = TRmleft then
              begin
                tbs_removeFileReadOnly(srcname);
                if bAllowOverWriteFile and tbs_FileExtIsJPG(extractfileext(srcname)) then
                  Rotateajpglossless(srcname, 270)
                else
                  RotateNonJpeg(srcname, athumb, 90);

                athumb.RotateMode := TRmNone;
                // athumb.SetAdjournedFalse(athumb.RecreateUniqueName);
                // fattachedBrowser.ReloadFile(aThumb);
              end
              else if athumb.RotateMode = TRmRight then
              begin
                tbs_removeFileReadOnly(srcname);
                if bAllowOverWriteFile and tbs_FileExtIsJPG(extractfileext(srcname)) then
                  Rotateajpglossless(srcname, 90)
                else
                  RotateNonJpeg(srcname, athumb, 270);

                athumb.RotateMode := TRmNone;
                // athumb.SetAdjournedFalse(athumb.RecreateUniqueName);
              end;
            end;
          end;

          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, fl.Count), TBResStr[IDRS_SH_OP_ROTATINGFILES]);
        end; // end for
      end;

    finally
      fattachedBrowser.UnlockUpdate;
      fl.Free;
      fattachedBrowser.RefreshDisplay;
    end;

  finally
    SH_OP_END;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CorrectImageOrientation(om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_CorrectImageOrientation_List(fl);
  finally
    fl.Free;
  end;

end;

procedure TThumbsBrowserShellProcessor.SH_OP_CorrectImageOrientation_Checked;
begin
  SH_OP_CorrectImageOrientation(omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CorrectImageOrientation_List(theFileList: TStringlist);
var
  athumb: TTHumbEX;
  srcname: string;
  i: integer;
begin
  if not SH_OP_ENABLED then
    exit;

  SH_OP_START;
  try

    fattachedBrowser.LockUpdate;
    try
      if theFileList.Count > 0 then
      begin
        for i := 0 to theFileList.Count - 1 do
        begin
          if Aborted then
          begin
            if assigned(OnProgress) then
              OnProgress(self, 100);
            Break;
          end;
          athumb := fattachedBrowser.Thumbat(theFileList[i]);
          srcname := athumb.SourceFileName;
          if athumb.SourceExif_Orientation > 1 then
          begin

            if tbs_FileExtIsJPG(extractfileext(srcname)) then
            begin
            //  if TBDetectSameOrientation(srcname, TRUE) then
              begin
                tbs_removeFileReadOnly(srcname);
                TBCorrectJpegOrientationLossless(srcname, athumb.SourceExif_Orientation);
                athumb.SourceExif_Orientation := 1;
              end;
            end
            else if tbs_FileExtIsTif(extractfileext(srcname)) then
            begin
             // if TBDetectSameOrientation(srcname, TRUE) then
              begin
                tbs_removeFileReadOnly(srcname);
                TBCorrectTiffOrientation(srcname, athumb.SourceExif_Orientation);
                athumb.SourceExif_Orientation := 1;
              end;
            end;

          end;
          if assigned(OnProgress) then
            OnProgress(self, TBGetPercent(i + 1, 1, theFileList.Count), TBResStr[IDRS_SH_OP_CORRECTINGORIENTATION]);
        end;
      end;
    finally
      fattachedBrowser.UnlockUpdate;
      fattachedBrowser.RefreshDisplay;
    end;

  finally
    SH_OP_END;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_CorrectImageOrientation_Selected;
begin
  SH_OP_CorrectImageOrientation(omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveChecked_To(outputFolder, outputEXT: string);
begin
  SH_OP_SaveTo(outputFolder, outputEXT, omPickChecked, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveListTo(outputFolder, outputEXT: string; theFileList: TStringlist;
  var ReturnedFileNames: TStringlist);
var
  srcname, destname: string;
  i: integer;
  io: timageenio;
  destnames: TStringlist;
  bIsUrl, bIsFile: boolean;
  tempName, tempPath: string;
begin
  if not SH_OP_ENABLED then
    exit;

  SH_OP_START;
  try
    if theFileList.Count = 0 then
      exit;

    destnames := TStringlist.Create;
    try
      for i := 0 to theFileList.Count - 1 do
      begin
        if Aborted then
        begin
          if assigned(OnProgress) then
            OnProgress(self, 100);
          Break;
        end;

        srcname := theFileList[i];

        bIsUrl := False;
        bIsFile := False;
        if fileexists(srcname) then
          bIsFile := true
        else if tbs_UrlIsValidUrl(srcname) then // it is a url
          bIsUrl := true;

        if bIsUrl then
        begin
          tempName := tbs_UrlExtractFilename(srcname, true);
          tempPath := Tbs_AddSlash(outputFolder);
        end
        else
        begin
          tempName := extractfilename(srcname);
          if (outputFolder = '') or (not SysUtils.directoryexists(outputFolder)) then
            tempPath := extractfilepath(srcname)
          else
            tempPath := Tbs_AddSlash(outputFolder);
        end;

        if tempPath = '' then
        begin
          if assigned(AttachedBrowser) then
            tempPath := Tbs_AddSlash(AttachedBrowser.currentFolder);

          if tempPath = '' then // if still empty
            tempPath := extractfilepath(Application.ExeName);
        end;

        if outputEXT = '' then
          destname := Tbs_AddSlash(tempPath) + tempName
        else
          destname := Tbs_AddSlash(tempPath) + changefileext(tempName, outputEXT);

        destname := tbs_getUniqueFileName(destname);
        destnames.Add(destname);

        if bIsUrl then // it is a url
        begin
          io := timageenio.Create(nil);
          try
            if assigned(fattachedBrowser) then
            begin
              io.ProxyAddress := fattachedBrowser.InternetOptions.ProxyAddress;
              io.ProxyUser := fattachedBrowser.InternetOptions.ProxyUser;
              io.ProxyPassword := fattachedBrowser.InternetOptions.ProxyPassword;
            end;
            TBLoadFromUrl(io, srcname);

            copydefaultSaveParametersfromIOParams(io.Params, SaveParameters);
            copySaveParameterstoIOParams(SaveParameters, io.Params);
            TBsavetofile(io, destname);
          finally
            io.Free;
          end;
        end
        else if bIsFile then
        begin // it is a file
          io := timageenio.Create(nil);
          try
            TBLoadFromFile(io, srcname, False);
            copydefaultSaveParametersfromIOParams(io.Params, SaveParameters);
            copySaveParameterstoIOParams(SaveParameters, io.Params);
            TBsavetofile(io, destname);
          finally
            io.Free;
          end;
        end;

        if assigned(OnProgress) then
          OnProgress(self, TBGetPercent(i + 1, 1, theFileList.Count), TBResStr[IDRS_SH_OP_SAVINGFILES]);
      end;

      if assigned(ReturnedFileNames) then
      begin
        TBStringListcopy(destnames, ReturnedFileNames);
      end;

    finally
      destnames.Free;
    end;
  finally
    SH_OP_END;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveListTo(outputFolder, outputEXT: string; theFileList: TStringlist);
var
  dummylist: TStringlist;
begin
  dummylist := nil;
  SH_OP_SaveListTo(outputFolder, outputEXT, theFileList, dummylist);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveSelected_To(outputFolder, outputEXT: string);
begin
  SH_OP_SaveTo(outputFolder, outputEXT, omPickSelected, IfNo_condition);
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveTo(outputFolder, outputEXT: string; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition; var ReturnedFileNames: TStringlist);
var
  fl: TStringlist;
begin
  if not SH_OP_ENABLED then
    exit;

  fl := TStringlist.Create;
  try
    SH_OP_GetFilenameList(fl, om, condition);
    SH_OP_SaveListTo(outputFolder, outputEXT, fl, ReturnedFileNames);
  finally
    fl.Free;
  end;
end;

procedure TThumbsBrowserShellProcessor.SH_OP_SaveTo(outputFolder: string; outputEXT: string; om: TTB_Shell_PickMode;
  condition: TTB_Browser_PickCondition);
var
  dummylist: TStringlist;

begin
  dummylist := nil;
  SH_OP_SaveTo(outputFolder, outputEXT, om, condition, dummylist);
end;

end.
