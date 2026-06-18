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
unit NWSComps_ThumbsBrowser_Thumbs;
{$R-}
{$Q-}

interface

// {$J+}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
{$IFDEF IMAGEEN_6_2_LATER}
{$DEFINE TB_MULTIBITMAP}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  stdctrls,
  contnrs,
  syncobjs,
  // filectrl,
  hyieutils, hyiedefs,
{$IFDEF IMAGEEN_5_0_LATER} ieSettings, {$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}
  iexWPD,
{$ENDIF}
  imageenio, imageenproc, ieWIA,
  NWSComps_ThumbsBrowser_Const,
  NWSComps_ThumbsBrowser_Shell_Utils,
  NWSComps_ThumbsBrowser_Utils_Types,
  NWSComps_ThumbsBrowser_Database_Utils,
  NWSComps_ThumbsBrowser_DB;

type

{$IFNDEF IMAGEEN_6_2_LATER}
  TIOParams = TIOParamsVals;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

  TThumbPortableDeviceInfo = record
    WPD: TIEPortableDevices;
    DevID: string;
    Rcd: TIEWPDObject;
    ExtendedProps: TIEWPDObjectAdvancedProps;
  end;
{$ENDIF}

  TTB_Thumb_ExploringStatus = (thbExplored, thbNotExplored,
    thbExploreInProcess);
  TTB_Thumb_ExploringStatuses = set of TTB_Thumb_ExploringStatus;

  TThumb = class(TPersistent)
  private
    { Private declarations }
    fCanSaveToDB: boolean;
    fInternetOptions: TTB_Browser_InternetParams;
    FTitleDrawFocusRectIfEmpty: boolean;
    fFileType: TTB_SourceFileType;
    fOnBufferLoaded: TTB_Thumb_OnThumbBufferLoaded;
    fStoreType: TTB_Thumb_StoreType;
    fSizeOffScreenW: integer;
    fSizeOffScreenH: integer;

    procedure HandleWIATransfer(theIEBitmap: TIEBitmap; var IOParams: TObject);

    function GetSourceHasIOParams_Full: boolean;
    procedure SetSizeOnScreenH(value: cardinal);
    procedure SetSizeOnScreenW(value: cardinal);

    procedure SetSizeOffScreen(thesize: integer);
    procedure SetFrameSize(thesize: cardinal);

    procedure SetFramePadding_Left(const value: integer);
    procedure SetFramePadding_Bottom(const value: integer);
    procedure SetFramePadding_Right(const value: integer);
    procedure SetFramePadding_Top(const value: integer);

    procedure SetSourceFileName(thevalue: string);
    function GetIOParams: TIOParams;
    procedure SetSourceType(const value: TTB_SourceType); virtual;

    procedure SetCaptionRoundnessPerc(const value: cardinal);
    procedure SetFrameRoundnessPerc(const value: cardinal);
    procedure SetTitleRoundnessPerc(const value: cardinal);

    procedure SetCaptionOpacity(const value: cardinal);
    procedure SetCaptionOpacitySelected(const value: cardinal);
    procedure SetFrameBgOpacity(const value: cardinal);
    procedure SetFrameBorderOpacity(const value: cardinal);
    procedure SetFrameBorderOpacitySelected(const value: cardinal);
    procedure SetTitleOpacity(const value: cardinal);
    procedure SetTitleOpacitySelected(const value: cardinal);
    procedure SetBackOpacity(const value: cardinal);
    procedure SetBackOpacitySelected(const value: cardinal);
    procedure SetBackPadding_Bottom(const value: integer);
    procedure SetBackPadding_Left(const value: integer);
    procedure SetBackPadding_Right(const value: integer);
    procedure SetBackPadding_Top(const value: integer);
    procedure SetFrameBgOpacitySelected(const value: cardinal);

    procedure SetTitleDrawFocusRectIfEmpty(const value: boolean);
    procedure AssignIEBitmap(src: TIEBitmap; bHardCopy: boolean);
    procedure ResetIOParams;
    function GetSource_IS_WPD: boolean;
    function GetSource_IS_FileSystem: boolean;
    procedure SetStoreType(const value: TTB_Thumb_StoreType);
    function GetIEBitmap: TIEBitmap;
    function IsZeroBitmap: boolean;

  protected
    { Protected declarations }
    fResources: TTB_GraphicResources;

    fIOParams: TIOParams;

    fUniqueID: TGUID;
    fUserPointer: Pointer;
    fUserTag: integer;

    fAdjourned: boolean;
    fQued: boolean;
    fExploringStatus: TTB_Thumb_ExploringStatus;
    fResampleFilter: TResampleFilter;
    fDisplayFilter: TResampleFilter;
    fIEBitmap: TIEBitmap;
    fproc: TImageenProc;

{$IFDEF TB_PORTABLEDEVICE}
    fAttachedWPDInfo: TThumbPortableDeviceInfo;
{$ENDIF}
    fAttachedWIAItem: TIEWIAItem;
    fSourceType: TTB_SourceType;
    fSourceHasIOParams_Basic: boolean;
    fSourceHasExif: boolean;
    fSourceHasIPTC: boolean;
    fSourceHasDICOM: boolean;
    fSourceHasXMP: boolean;

    fSourceFilePath: string;
    fSourceFileExtension: string;
    fSourceFileName: string;
    fSourceFileNameShort: string;
    fSourceFileDate: TDatetime;
    fSourceExifFileDate: TDatetime;
    fSourceExif_XPTitle: string;
    fSourceExif_XPAuthor: string;
    fSourceExif_XPSubject: string;
    fSourceExif_XPComments: string;
    fSourceExif_XPKeywords: string;
    fSourceExif_XPRating: integer;
    fSourceExif_Orientation: integer;
    fSourceExif_GetThumb: boolean;

    fSourceFileSize: integer;
    fSourceFileWidth: integer;
    fSourceFileHeight: integer;
    fSourceFileRes: integer;

    fSourceFileCreateDate: TDatetime;
    fSourceFileTypeDescr: string;
    fSourceFileTypeInt: integer;
    // LAyout fields

    // fSizeOnScreen: cardinal;
    fSizeOnScreenW: cardinal;
    fSizeOnScreenH: cardinal;

    fSizeOffScreen: integer;

    fFrameBgColor: TColor;
    fFrameBgSelectedColor: TColor;

    fCaptionFontColor: TColor;
    fCaptionFontSelectedColor: TColor;

    fCaptionBackColor: TColor;
    fCaptionBackSelectedColor: TColor;

    fFrameBorderColor: TColor;
    fFrameBorderSelectedColor: TColor;

    fFrameSize: cardinal;

    fBottomTitleBackColor: TColor;
    fTopTitleFontColor: TColor;
    fTopTitleBackSelectedColor: TColor;
    fTopTitleBackColor: TColor;
    fBottomTitleSelectedFontColor: TColor;
    fBottomTitleFontColor: TColor;
    fBottomTitleBackSelectedColor: TColor;
    fTopTitleSelectedFontColor: TColor;

    fFrameRoundnessPerc: cardinal;
    fCaptionRoundnessPerc: cardinal;
    fTitleRoundnessPerc: cardinal;

    fBackOpacity: cardinal;
    fBackOpacitySelected: cardinal;

    fFrameBgOpacity: cardinal;
    fFrameBgOpacitySelected: cardinal;

    fFrameBorderOpacity: cardinal;
    fFrameBorderOpacitySelected: cardinal;

    fCaptionOpacity: cardinal;
    fTitleOpacity: cardinal;

    fCaptionOpacitySelected: cardinal;
    fTitleOpacitySelected: cardinal;

    FBackPadding_Left: integer;
    FBackPadding_Right: integer;
    FBackPadding_Bottom: integer;
    FBackPadding_Top: integer;

    FFramePadding_Left: integer;
    FFramePadding_Right: integer;
    FFramePadding_Bottom: integer;
    FFramePadding_Top: integer;

    fDisplayedWidth, fDisplayedHeight: cardinal;
    fTotalWidth, fTotalHeight: cardinal;

    fSelected: boolean;
    fUniqueName: string;
    fTryReadExplorerThumb: boolean;
    fSearchRec: TSearchRec;

    fMetaTags: TThumbsbrowser_MetaTags;
    fMetaOptions: TThumbsbrowser_MetaData_Options;
    fMetaEditedFields: TThumbsbrowser_MetaData_FieldsList;

    procedure SetResources(theresources: TTB_GraphicResources);

    function GetSource_IS_WIA: boolean;
    procedure GetResizedDimensions(var new_w, new_h: integer; w, h: integer);

    procedure DoFinishLoading(loaded: boolean;
      const bCanSaveToDb: boolean); virtual;

    function GetExifDate_ex(aio: TImageenio): TDatetime;

    function GetOffScreenWidth: integer;
    function GetOffScreenHeight: integer;

  public
    { Public declarations }
    property StoreType: TTB_Thumb_StoreType read fStoreType write SetStoreType;

    property InternetOptions: TTB_Browser_InternetParams read fInternetOptions
      write fInternetOptions;
    property Resources: TTB_GraphicResources read fResources write SetResources;

    property IOParams: TIOParams read GetIOParams;

    property UniqueID: TGUID read fUniqueID write fUniqueID;

    property UserPointer: Pointer read fUserPointer write fUserPointer;
    // user may use this to attach some info to the thumb
    property UserTag: integer read fUserTag write fUserTag;
    // user may use this to attach some info to the thumb

    property CanSaveToDB: boolean read fCanSaveToDB;
    property Adjourned: boolean read fAdjourned; // write fAdjourned;
    property Qued: boolean read fQued write fQued;
    property ExploringStatus: TTB_Thumb_ExploringStatus read fExploringStatus
      write fExploringStatus;
    property ResampleFilter: TResampleFilter read fResampleFilter
      write fResampleFilter;
    property DisplayFilter: TResampleFilter read fDisplayFilter
      write fDisplayFilter;

{$IFDEF TB_PORTABLEDEVICE}
    property AttachedWPDInfo: TThumbPortableDeviceInfo read fAttachedWPDInfo
      write fAttachedWPDInfo;
{$ENDIF}
    property AttachedWIAItem: TIEWIAItem read fAttachedWIAItem
      write fAttachedWIAItem;
    property SearchRec: TSearchRec read fSearchRec write fSearchRec;
    property FileType: TTB_SourceFileType read fFileType write fFileType;
    property SourceType: TTB_SourceType read fSourceType write SetSourceType;
    property Source_IS_FileSystem: boolean read GetSource_IS_FileSystem;
    property Source_IS_WIA: boolean read GetSource_IS_WIA;
    property Source_IS_WPD: boolean read GetSource_IS_WPD;
    property SourceFileName: string read fSourceFileName
      write SetSourceFileName;
    property SourceFilePath: string read fSourceFilePath;
    property SourceFileExtension: string read fSourceFileExtension;
    property SourceFileNameShort: string read fSourceFileNameShort;
    property SourceFileDate: TDatetime read fSourceFileDate
      write fSourceFileDate;
    property SourceFileSize: integer read fSourceFileSize write fSourceFileSize;
    property SourceFileWidth: integer read fSourceFileWidth
      write fSourceFileWidth;
    property SourceFileHeight: integer read fSourceFileHeight
      write fSourceFileHeight;
    property SourceFileRes: integer read fSourceFileRes write fSourceFileRes;

    property SourceFileTypeDescr: string read fSourceFileTypeDescr
      write fSourceFileTypeDescr;
    property SourceFileTypeInt: integer read fSourceFileTypeInt
      write fSourceFileTypeInt;

    property SourceHasIOParams_Basic: boolean read fSourceHasIOParams_Basic
      write fSourceHasIOParams_Basic;
    property SourceHasIOParams_Full: boolean read GetSourceHasIOParams_Full;
    property SourceHasExif: boolean read fSourceHasExif write fSourceHasExif;
    property SourceExifFileDate: TDatetime read fSourceExifFileDate
      write fSourceExifFileDate;
    property SourceExif_XPTitle: string read fSourceExif_XPTitle
      write fSourceExif_XPTitle;
    property SourceExif_XPAuthor: string read fSourceExif_XPAuthor
      write fSourceExif_XPAuthor;
    property SourceExif_XPSubject: string read fSourceExif_XPSubject
      write fSourceExif_XPSubject;
    property SourceExif_XPComments: string read fSourceExif_XPComments
      write fSourceExif_XPComments;
    property SourceExif_XPKeywords: string read fSourceExif_XPKeywords
      write fSourceExif_XPKeywords;
    property SourceExif_XPRating: integer read fSourceExif_XPRating
      write fSourceExif_XPRating;

    property SourceExif_Orientation: integer read fSourceExif_Orientation  write fSourceExif_Orientation;
    property SourceExif_GetThumb: boolean read fSourceExif_GetThumb;


    property SourceHasIPTC: boolean read fSourceHasIPTC write fSourceHasIPTC;
    property SourceHasDICOM: boolean read fSourceHasDICOM write fSourceHasDICOM;
    property SourceHasXMP: boolean read fSourceHasXMP write fSourceHasXMP;

    property SizeOnScreenW: cardinal read fSizeOnScreenW write SetSizeOnScreenW;
    property SizeOnScreenH: cardinal read fSizeOnScreenH write SetSizeOnScreenH;

    property SizeOffScreenW: integer read fSizeOffScreenW write fSizeOffScreenW;
    property SizeOffScreenH: integer read fSizeOffScreenH write fSizeOffScreenH;
    property SizeOffScreen: integer read fSizeOffScreen write SetSizeOffScreen;
    property FrameSize: cardinal read fFrameSize write SetFrameSize;

    property FrameRoundnessPerc: cardinal read fFrameRoundnessPerc
      write SetFrameRoundnessPerc;
    property CaptionRoundnessPerc: cardinal read fCaptionRoundnessPerc
      write SetCaptionRoundnessPerc;
    property TitleRoundnessPerc: cardinal read fTitleRoundnessPerc
      write SetTitleRoundnessPerc;

    property BackOpacity: cardinal read fBackOpacity write SetBackOpacity;
    property BackOpacitySelected: cardinal read fBackOpacitySelected
      write SetBackOpacitySelected;
    property FrameBgOpacity: cardinal read fFrameBgOpacity
      write SetFrameBgOpacity;
    property FrameBgOpacitySelected: cardinal read fFrameBgOpacitySelected
      write SetFrameBgOpacitySelected;
    property FrameBorderOpacity: cardinal read fFrameBorderOpacity
      write SetFrameBorderOpacity;
    property FrameBorderOpacitySelected: cardinal
      read fFrameBorderOpacitySelected write SetFrameBorderOpacitySelected;

    property CaptionOpacity: cardinal read fCaptionOpacity
      write SetCaptionOpacity;
    property CaptionOpacitySelected: cardinal read fCaptionOpacitySelected
      write SetCaptionOpacitySelected;

    property TitleDrawFocusRectIfEmpty: boolean read FTitleDrawFocusRectIfEmpty
      write SetTitleDrawFocusRectIfEmpty;
    property TitleOpacity: cardinal read fTitleOpacity write SetTitleOpacity;
    property TitleOpacitySelected: cardinal read fTitleOpacitySelected
      write SetTitleOpacitySelected;

    property FramePadding_Left: integer read FFramePadding_Left
      write SetFramePadding_Left;
    property FramePadding_Right: integer read FFramePadding_Right
      write SetFramePadding_Right;
    property FramePadding_Top: integer read FFramePadding_Top
      write SetFramePadding_Top;
    property FramePadding_Bottom: integer read FFramePadding_Bottom
      write SetFramePadding_Bottom;

    property BackPadding_Left: integer read FBackPadding_Left
      write SetBackPadding_Left;
    property BackPadding_Right: integer read FBackPadding_Right
      write SetBackPadding_Right;
    property BackPadding_Bottom: integer read FBackPadding_Bottom
      write SetBackPadding_Bottom;
    property BackPadding_Top: integer read FBackPadding_Top
      write SetBackPadding_Top;

    property FrameBgColor: TColor read fFrameBgColor write fFrameBgColor;
    property FrameBgSelectedColor: TColor read fFrameBgSelectedColor
      write fFrameBgSelectedColor;
    property CaptionFontColor: TColor read fCaptionFontColor
      write fCaptionFontColor;
    property CaptionFontSelectedColor: TColor read fCaptionFontSelectedColor
      write fCaptionFontSelectedColor;
    property CaptionBackColor: TColor read fCaptionBackColor
      write fCaptionBackColor;
    property CaptionBackSelectedColor: TColor read fCaptionBackSelectedColor
      write fCaptionBackSelectedColor;

    property TopTitleFontColor: TColor read fTopTitleFontColor
      write fTopTitleFontColor;
    property TopTitleSelectedFontColor: TColor read fTopTitleSelectedFontColor
      write fTopTitleSelectedFontColor;
    property TopTitleBackColor: TColor read fTopTitleBackColor
      write fTopTitleBackColor;
    property TopTitleBackSelectedColor: TColor read fTopTitleBackSelectedColor
      write fTopTitleBackSelectedColor;

    property BottomTitleFontColor: TColor read fBottomTitleFontColor
      write fBottomTitleFontColor;
    property BottomTitleSelectedFontColor: TColor
      read fBottomTitleSelectedFontColor write fBottomTitleSelectedFontColor;
    property BottomTitleBackColor: TColor read fBottomTitleBackColor
      write fBottomTitleBackColor;
    property BottomTitleBackSelectedColor: TColor
      read fBottomTitleBackSelectedColor write fBottomTitleBackSelectedColor;

    property FrameBorderColor: TColor read fFrameBorderColor
      write fFrameBorderColor;
    property FrameBorderSelectedColor: TColor read fFrameBorderSelectedColor
      write fFrameBorderSelectedColor;
    property IEBitmap: TIEBitmap read GetIEBitmap;
    property TotalWidth: cardinal read fTotalWidth;
    property TotalHeight: cardinal read fTotalHeight;
    property Selected: boolean read fSelected write fSelected;
    property Unique_Name: string read fUniqueName write fUniqueName;

    property MetaTags: TThumbsbrowser_MetaTags read fMetaTags write fMetaTags;
    property MetaOptions: TThumbsbrowser_MetaData_Options read fMetaOptions
      write fMetaOptions;

    property TryReadExplorerThumb: boolean read fTryReadExplorerThumb
      write fTryReadExplorerThumb;

    property OnBufferLoaded: TTB_Thumb_OnThumbBufferLoaded read fOnBufferLoaded
      write fOnBufferLoaded;

    constructor Create; reintroduce; virtual;
    destructor Destroy; override;

    Function IsEmpty: boolean;
    procedure SetZeroBitmap;

    procedure AssignOffScreenBitmap(theIEBitmap: TIEBitmap);

    procedure GetBasicIOParamsFromIO(aio: TImageenio); virtual;

    procedure RetrieveParamsfromSourceFile(theFilename: string);
    procedure RetrieveFromSourceFile(theFilename: string); overload; virtual;
    procedure RetrieveFromSourceFile(theFilename: string;
      theFormat: TTB_Browser_FileFormat; theCriticalSection: TCriticalSection;
      bUseCriticalSection_whenNeeded: boolean;
      var theLoadingIO: TImageenio); overload;
    procedure RetrieveFromBitmap(theBitmap: Tbitmap); virtual;
    procedure RetrieveFromIEBitmap(theIEBitmap: TIEBitmap); virtual;
    procedure RetrieveFromStream(st: TStream); virtual;
    procedure RetrieveFromUrl(url: string); virtual;
    procedure RetrieveFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem); virtual;
    procedure RetrieveParamsFromWIA(aWIA: TIEWIA;
      aWIAItem: TIEWIAItem); virtual;

{$IFDEF TB_PORTABLEDEVICE}
    procedure RetrieveAsWPDNavigator(aWPD: TIEPortableDevices;
      const DevID: string; parentFolderID: string);
    procedure RetrieveFromWPD(aWPD: TIEPortableDevices;
      const DevID, ObjID: string; const bLoadInfo: boolean;
      CS: TCriticalSection = nil); virtual;

    procedure InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
      ObjID: string); overload; virtual;
    procedure InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
      aWPDObj: TIEWPDObject); overload; virtual;
{$ENDIF}
    procedure SaveThumbToFile(theFilename: string; quality: integer);
    // quality between 0..100

    procedure PaintToCanvas(cv: Tcanvas; x0, y0: integer); virtual;
    procedure Assign(Source: TPersistent); override;

    procedure AssignLayout(Source: TPersistent; bRefresh: boolean); virtual;
    procedure AssignFileLoadingInfo(Source: TPersistent); virtual;
    procedure AssignInfo(Source: TPersistent; bRefresh: boolean); virtual;
    procedure AssignStatus(Source: TPersistent); virtual;

    procedure RefreshDimensions; virtual;

    procedure SetAdjournedTrue;
    procedure SetAdjournedFalse(newUniqueName: string);
    function RecreateUniqueName: string;
    procedure InitFromSearchRecord(sr: TSearchRec;
      thefolder_slashed: string); virtual;

  published
    { Published declarations }
  end;

  TThumbEx = class(TThumb)
  private
    { Private declarations }
    fOwnerCanvas: Tcanvas;
    fLayoutType: TTB_Thumb_Layout_Type;

    fUserObject: TObject;

    fClickPoint: TPoint;

    fTotalRect: TRect;
    fFramedThumbAreaRect: TRect;
    fThumbAreaRect: TRect;
    fThumbAreaRestrictedRect: TRect;
    fCaptionRect: TRect;

    fLayoutElements: TTB_Thumb_LayoutElements;

    fChecked: boolean;
    fRotateMode: TTB_Thumb_RotationMode;

    fShowSettings: TTB_Thumb_ShowSettings;

    fFontHeight: integer;

    fcaptions: TTB_Thumb_Captions;
    fCaptionFont: tFont;

    fcaptionMissingText: string;
    fcaptionheight: cardinal;
    fcaptionwidth: cardinal;
    fcaptionSettings: TTB_Thumb_CaptionsSettings;

    fVisible: boolean;

    fOnVisibleChange: TnotifyEvent;
    fOnSelectedChange: TnotifyEvent;
    fOnCheckedChange: TnotifyEvent;
    fOnRotatedChange: TnotifyEvent;
    fOnPictureLoaded: TnotifyEvent;
    fOnCustomDrawPicture: TTB_Thumb_OnCustomDraw;
    fOnCustomDrawFrame: TTB_Thumb_OnCustomDraw;
    fOnCustomDrawCaption: TTB_Thumb_OnCustomDrawText;
    fOnCustomDrawThumbBackground: TTB_Thumb_OnCustomDraw;
    fOnCustomDrawBottomTitle: TTB_Thumb_OnCustomDrawText;
    fOnCustomDrawTopTitle: TTB_Thumb_OnCustomDrawText;
    fOnGetCaptionInfo: TTB_Thumb_OnGetCaptionInfo;
    fOnGetCaptionIdx: TTB_Thumb_OnGetCaptionIdx;
    fOnCustomDrawAfterDraw: TTB_Thumb_OnCustomDraw;

    fEvents_LockCtr: integer;
    fLayout_LockCtr: integer;
    FTopTitle: string;
    FBottomTitle: string;

    fRating: integer;
    fKeywords: string;
    fOnSyncPropertyChanged: TThumbsbrowser_MetaData_SyncPropertyChangedEvent;
    fMouseOverOptions: TTB_Thumb_MouseOverOptions;

    fCaptionStyle: TTB_Thumb_CaptionStyle;

    fCaptionIncludeInFrame: boolean;
    fBrowserStyleOptions: TTB_Browser_StyleOptions;
    fDropShadowOptions: TTB_Thumb_DropShadowOptions;
    fOwnUserObject: boolean;
    fOriginator: TTB_Thumb_Originator;
    fLastVisibleIdx: integer;

    procedure DoFinishLoading(loaded: boolean;
      const bCanSaveToDb: boolean); override;

    Function GetOnVisibleChange: TnotifyEvent;
    Function GetOnSelectedChange: TnotifyEvent;
    Function GetOnCheckedChange: TnotifyEvent;
    Function GetOnRotatedChange: TnotifyEvent;
    Function GetOnPictureLoaded: TnotifyEvent;

    procedure SetOnVisibleChange(value: TnotifyEvent);
    procedure SetOnSelectedChange(value: TnotifyEvent);
    procedure SetOnCheckedChange(value: TnotifyEvent);
    procedure SetOnRotatedChange(value: TnotifyEvent);
    procedure SetOnPictureLoaded(value: TnotifyEvent);
    procedure SetOnCustomDrawPicture(value: TTB_Thumb_OnCustomDraw);
    procedure SetOnCustomDrawFrame(value: TTB_Thumb_OnCustomDraw);
    procedure SetOnCustomDrawCaption(value: TTB_Thumb_OnCustomDrawText);
    procedure SetOnCustomDrawThumbBackground(const value
      : TTB_Thumb_OnCustomDraw);
    procedure SetOnCustomDrawAfterDraw(const value: TTB_Thumb_OnCustomDraw);

    procedure SetBottomTitle(const value: string);
    procedure SetTopTitle(const value: string);

    procedure SetShowSettings(thesettings: TTB_Thumb_ShowSettings);
    procedure SetCaptionFont(thefont: tFont);
    procedure SetCaptionSettings(value: TTB_Thumb_CaptionsSettings);
    procedure SetLayoutType(theLayoutType: TTB_Thumb_Layout_Type);

    procedure refitdisplay(const pw, ph: cardinal);
    procedure RefreshDimensions; override;
    function CalcFontHeight: integer;
    procedure SetOnCustomDrawBottomTitle(const value
      : TTB_Thumb_OnCustomDrawText);
    procedure SetOnCustomDrawTopTitle(const value: TTB_Thumb_OnCustomDrawText);

    procedure SetVisible(thevisible: boolean);
    procedure SetSelected(theselected: boolean);
    procedure SetChecked(thechecked: boolean);
    procedure SetRotated(value: TTB_Thumb_RotationMode);

    procedure SetSourceType(const value: TTB_SourceType); override;

    procedure GetCaptions(var sl: TTB_Thumb_Captions;
      theCaptionSettings: TTB_Thumb_CaptionsSettings);
    procedure setcaptionMissingText(const value: string);
    function EnsureMetaData_Write: boolean;
    function EnsureMetaData_Read: boolean;

    procedure SetKeywords(const value: string);
    procedure SetRating(const value: integer);
    procedure SetCaptionStyle(const value: TTB_Thumb_CaptionStyle);
    procedure SetCaptionIncludeInFrame(const value: boolean);
    function GetCaptionSizePerc_HorzLayout: cardinal;
    procedure SetUserObject(const value: TObject);

  protected
    { Protected declarations }

  public
    { Public declarations }

    ThumbTag: integer deprecated
      'Do not use this tag It is Reserved For Internal Use!! Use instead UserTag, UserPointer, UserObject)';
    //

    procedure DeleteUserObject;

    function GetHintText: string;
    function GetRect(HitPoint: TTB_Thumb_HitRectResult): TRect;

    procedure ResetFontHeight;

    procedure Layout_Lock;
    procedure Layout_UnLock;
    function LayoutLocked: boolean;

    procedure Events_Lock;
    procedure Events_UnLock;
    function EventsLocked: boolean;

    property LastVisibleIdx: integer read fLastVisibleIdx write fLastVisibleIdx;
    // Internal USE ONLY!

    property BrowserStyleOptions: TTB_Browser_StyleOptions
      read fBrowserStyleOptions write fBrowserStyleOptions;
    property LinkedObject: TObject read fUserObject write fUserObject;
    // this is a duplicate for retro-compatibility
    property UserObject: TObject read fUserObject write SetUserObject;
    // User may link an object to the thumb
    property OwnUserObject: boolean read fOwnUserObject write fOwnUserObject;
    // if true the UserObject will be destroyed when the Thumb is destroyed

    property TotalRect: TRect read fTotalRect;

    property Visible: boolean read fVisible write SetVisible;
    property Selected: boolean read fSelected write SetSelected;
    property Checked: boolean read fChecked write SetChecked;
    property RotateMode: TTB_Thumb_RotationMode read fRotateMode
      write SetRotated;
    property ShowSettings: TTB_Thumb_ShowSettings read fShowSettings
      write SetShowSettings;

    property TopTitle: string read FTopTitle write SetTopTitle;
    property BottomTitle: string read FBottomTitle write SetBottomTitle;

    property Rating: integer read fRating write SetRating;
    property Keywords: string read fKeywords write SetKeywords;

    property CaptionMissingText: string read fcaptionMissingText
      write setcaptionMissingText;
    property CaptionStyle: TTB_Thumb_CaptionStyle read fCaptionStyle
      write SetCaptionStyle;
    property CaptionIncludeInFrame: boolean read fCaptionIncludeInFrame
      write SetCaptionIncludeInFrame;
    property Captions: TTB_Thumb_Captions read fcaptions;
    property CaptionFont: tFont read fCaptionFont write SetCaptionFont;
    property CaptionSettings: TTB_Thumb_CaptionsSettings read fcaptionSettings
      write SetCaptionSettings;

    property LayoutType: TTB_Thumb_Layout_Type read fLayoutType
      write SetLayoutType;
    property DropShadowOptions: TTB_Thumb_DropShadowOptions
      read fDropShadowOptions write fDropShadowOptions;

    property Originator: TTB_Thumb_Originator read fOriginator
      write fOriginator;

    constructor Create(theOriginator: TTB_Thumb_Originator;
      OwnerCanvas: Tcanvas; aUserObject: TObject;
      const bVisible: boolean = true); reintroduce; overload;
    constructor Create(theOriginator: TTB_Thumb_Originator;
      OwnerCanvas: Tcanvas; const bVisible: boolean = true);
      reintroduce; overload;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure AssignLayout(Source: TPersistent; bRefresh: boolean); override;
    procedure AssignFileLoadingInfo(Source: TPersistent); override;
    procedure AssignInfo(Source: TPersistent; bRefresh: boolean); override;
    procedure AssignStatus(Source: TPersistent); override;

    procedure AssignEvents(srcthumb: TThumbEx);

    procedure GetBasicIOParamsFromIO(aio: TImageenio); override;

    procedure RetrieveFromSourceFile_EX(theFilename: string;
      theExternaFileReader: TTB_Browser_FileReaderFunction;
      theCriticalSection: TCriticalSection;
      bUseCriticalSection_whenNeeded: boolean;
      var theLoadingIO: TImageenio); overload;

    procedure RetrieveFromSourceFile_EX(theFilename: string;
      theExternaFileReader: TTB_Browser_FileReaderFunction;
      theCriticalSection: TCriticalSection;
      bUseCriticalSection_whenNeeded: boolean); overload;

    procedure RetrieveFromBitmap(theBitmap: Tbitmap); override;
    procedure RetrieveFromIEBitmap(theIEBitmap: TIEBitmap); override;
    procedure RetrieveFromStream(st: TStream); override;
    procedure RetrieveFromUrl(url: string); override;
    procedure RetrieveFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem); override;
    procedure RetrieveParamsFromWIA(aWIA: TIEWIA;
      aWIAItem: TIEWIAItem); override;

    procedure SetCaption(value: string); // sets a general caption
    function GetCaption: string; // returns the general caption

{$IFDEF TB_PORTABLEDEVICE}
    procedure RetrieveFromWPD(aWPD: TIEPortableDevices;
      const DevID, ObjID: string; const bLoadInfo: boolean;
      CS: TCriticalSection = nil); override;
    procedure InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
      ObjID: string); overload; override;
    procedure InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
      aWPDObj: TIEWPDObject); overload; override;
{$ENDIF}
{$IFDEF TB_USEDB}
    function RetrieveFromDB(theDBCriticalSection: TCriticalSection;
      theDB: TThumbsBrowser_DB; theSessionGuid: TGUID;
      const bSeek: boolean): boolean;
    procedure EditDBRcd(theDBCriticalSection: TCriticalSection;
      theDB: TThumbsBrowser_DB; theSessionGuid: TGUID);
    function SaveToDB(theDBCriticalSection: TCriticalSection;
      theDB: TThumbsBrowser_DB; theSessionGuid: TGUID; bAllowSavePic: boolean)
      : TTB_DB_ThumbExistResult;
    function ExistsinDB(theDBCriticalSection: TCriticalSection;
      theDB: TThumbsBrowser_DB; theSessionGuid: TGUID): TTB_DB_ThumbExistResult;
{$ENDIF}
    procedure MetaData_Read(var theField: TThumbsbrowser_MetaData_Field);
    procedure MetaData_Write(theField: TThumbsbrowser_MetaData_Field;
      const bInjectToFile: boolean);
    procedure MetaData_SaveChangesToFile;

    procedure MetaData_SyncRead(const syncType
      : TThumbsbrowser_MetaData_SyncType; const syncTagStr: string);
    procedure MetaData_SyncWrite(const syncType
      : TThumbsbrowser_MetaData_SyncType; const syncTagStr: string);

    procedure PaintToCanvas(cv: Tcanvas; x0, y0: integer; bMouseOver: boolean;
      roughmode: boolean); reintroduce;
    function HasConsistentOrientation: boolean;
    function SatisfiesCondition(condition: TTB_Browser_PickCondition): boolean;

    procedure ForceRefreshDimensions;
    procedure RefreshCaptions;

    procedure InitFromSearchRecord(sr: TSearchRec;
      thefolder_slashed: string); override;

    function GetMouseHitResult(X, Y: integer): TTB_Thumb_HitRectResult;
    function HandleMouseUp(Button: TmouseButton; Shift: TShiftState;
      X, Y: integer; var HitResult: TTB_Thumb_HitRectResult)
      : TTB_Thumb_MouseUpResult;

    property ClickPoint: TPoint read fClickPoint write fClickPoint;

    property MouseOverOptions: TTB_Thumb_MouseOverOptions read fMouseOverOptions
      write fMouseOverOptions;

    property OnVisibleChange: TnotifyEvent read GetOnVisibleChange
      write SetOnVisibleChange;
    property OnSelectedChange: TnotifyEvent read GetOnSelectedChange
      write SetOnSelectedChange;
    property OnCheckedChange: TnotifyEvent read GetOnCheckedChange
      write SetOnCheckedChange;
    property OnRotatedChange: TnotifyEvent read GetOnRotatedChange
      write SetOnRotatedChange;
    property OnPictureLoaded: TnotifyEvent read GetOnPictureLoaded
      write SetOnPictureLoaded;
    property OnCustomDrawPicture: TTB_Thumb_OnCustomDraw
      read fOnCustomDrawPicture write SetOnCustomDrawPicture;
    property OnCustomDrawFrame: TTB_Thumb_OnCustomDraw read fOnCustomDrawFrame
      write SetOnCustomDrawFrame;
    property OnCustomDrawThumbBackground: TTB_Thumb_OnCustomDraw
      read fOnCustomDrawThumbBackground write SetOnCustomDrawThumbBackground;
    property OnCustomDrawCaption: TTB_Thumb_OnCustomDrawText
      read fOnCustomDrawCaption write SetOnCustomDrawCaption;
    property OnGetCaptionInfo: TTB_Thumb_OnGetCaptionInfo read fOnGetCaptionInfo
      write fOnGetCaptionInfo;
    property OnGetCaptionIdx: TTB_Thumb_OnGetCaptionIdx read fOnGetCaptionIdx
      write fOnGetCaptionIdx;

    property OnCustomDrawTopTitle: TTB_Thumb_OnCustomDrawText
      read fOnCustomDrawTopTitle write SetOnCustomDrawTopTitle;
    property OnCustomDrawBottomTitle: TTB_Thumb_OnCustomDrawText
      read fOnCustomDrawBottomTitle write SetOnCustomDrawBottomTitle;
    property OnCustomDrawAfterDraw: TTB_Thumb_OnCustomDraw
      read fOnCustomDrawAfterDraw write SetOnCustomDrawAfterDraw;

    property OnSyncPropertyChanged
      : TThumbsbrowser_MetaData_SyncPropertyChangedEvent
      read fOnSyncPropertyChanged write fOnSyncPropertyChanged;

  published
    { Published declarations }
  end;

  TBrowserThumb = class(TThumbEx)
  private

  protected
    { Protected declarations }

    property TotalRect;
    property CaptionFont;
    property LayoutType;
    property ClickPoint;
    property OnVisibleChange;
    property OnSelectedChange;
    property OnCheckedChange;
    property OnRotatedChange;
    property OnPictureLoaded;
    property OnCustomDrawPicture;
    property OnCustomDrawFrame;
    property OnCustomDrawThumbBackground;
    property OnCustomDrawCaption;

    property OnCustomDrawTopTitle;
    property OnCustomDrawBottomTitle;
    property OnCustomDrawAfterDraw;

  public
    { Public declarations }

  published
    { Published declarations }
  end;

  TThumbsBrowser_Thumb_LoadThread_Counter = class
  private
    fLockCounter: TCriticalSection;
    fcounter: integer;
  public

    property value: integer read fcounter;

    constructor Create;
    Destructor Destroy; override;

    function IncCounter: integer;
    function DecCounter: integer;
    procedure SetCounter(v: integer);
  end;

  TThumbsBrowser_Thumb_LoadThread_Event = procedure(sender: TThread;
    theThumb: TThumbEx) of object;

  TThumbsBrowser_Thumb_LoadThread = class(TThread)
  private
    { Private declarations }
    fAborted: boolean;
    fIoTOAbort: TImageenio;
    fThumb: TThumbEx;
    ffilename: string;
    fLoader: TObject;
    fOnLoaded: TThumbsBrowser_Thumb_LoadThread_Event;

    fLoadFromDB: boolean;
    fSaveToDB: boolean;
    fDatabaseCriticalSection: TCriticalSection;
    fDatabaseSessionGUID: TGUID;
    fCriticalSection: TCriticalSection;
    fCleanupCriticalSection: TCriticalSection;
{$IFDEF TB_USEDB}
    fDB: TThumbsBrowser_DB;
{$ENDIF}
    fEvent: TEvent;
    fCounterObj: TThumbsBrowser_Thumb_LoadThread_Counter;
    fExternalReader: TTB_Browser_FileReaderFunction;
    fLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event;

    procedure Init_Common(theFilename: string; theThumb: TThumbEx;
      TheLoader: TObject; theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
      theCriticalSection: TCriticalSection; theCleanUpCS: TCriticalSection;
      theEvent: TEvent;
      theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
      theExternaFileReader: TTB_Browser_FileReaderFunction;
      theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);

    procedure SendMessage_Finished_ToReceiver;
    procedure CheckCounterObj;
    function CanProceed: boolean;

  protected

    procedure Execute; override;
  public
    property Aborted: boolean read fAborted;
    constructor Create;
    destructor Destroy; override;

{$IFDEF TB_USEDB}
    procedure Init(bLoadFromDB: boolean; bSaveToDB: boolean;
      theFilename: string; theThumb: TThumbEx; TheLoader: TObject;
      theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
      theCriticalSection: TCriticalSection;
      theDatabaseCriticalSection: TCriticalSection; theDB: TThumbsBrowser_DB;
      theDBSessionGuid: TGUID; theCleanUpCS: TCriticalSection; theEvent: TEvent;
      theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
      theExternaFileReader: TTB_Browser_FileReaderFunction;
      theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);
{$ELSE}
    procedure Init(theFilename: string; theThumb: TThumbEx; TheLoader: TObject;
      theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
      theCriticalSection: TCriticalSection; theCleanUpCS: TCriticalSection;
      theEvent: TEvent;
      theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
      theExternaFileReader: TTB_Browser_FileReaderFunction;
      theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);
{$ENDIF}
{$IFDEF TB_USEDB}
    procedure InitDB(bLoadFromDB, bSaveToDB: boolean);
{$ENDIF}
    procedure Launch;
    procedure Abort;

    property Thumb: TThumbEx read fThumb;
  end;

implementation

uses math, printers, dialogs, shlobj, shellapi, bmpfilt,
  NWSComps_ThumbsBrowser_utils,
{$IFDEF TB_GDIPLUS}NWSComps_GdiPlus, {$ENDIF}
  NWSComps_StyleEngine;

const
  sEmptyCap: string = '';
  CONST_DATENULL = -700000;

function EnsureFileExt(ext: string): string;
begin
  if (length(ext) = 0) or (ext[1] = '.') then
    result := ''
  else
    result := '.' + ext;
end;

procedure RenderIEBmpToCanvas(Srcbmp: TIEBitmap; cv: Tcanvas;
  xDst, yDst, dxDst, dyDst: integer; IntOpacity: integer;
  Filter: TResampleFilter);
var
  bmp: TIEBitmap;
begin

  bmp := TIEBitmap.Create;
  bmp.PixelFormat := ie24rgb;
  try

    bmp.Width := Srcbmp.Width;
    bmp.Height := Srcbmp.Height;
    bmp.Canvas.CopyRect(rect(0, 0, bmp.Width, bmp.Height), cv,
      rect(xDst, yDst, xDst + dxDst, yDst + dyDst));

    Srcbmp.RenderToCanvasWithAlpha(bmp.Canvas, 0, 0, bmp.Width, bmp.Height, 0,
      0, Srcbmp.Width, Srcbmp.Height, IntOpacity, Filter);

    cv.CopyRect(rect(xDst, yDst, xDst + dxDst, yDst + dyDst), bmp.Canvas,
      rect(0, 0, bmp.Width, bmp.Height));

  finally
    bmp.free;
  end;
end;

{$IFDEF TB_GDIPLUS}

procedure RenderFrameToCanvas_GDIPlus(cv: Tcanvas; theRect: TRect;
  Roundness: cardinal; // 0..100 percent
  FillOpacity: cardinal; // 0..255
  BorderOpacity: cardinal; // 0..255
  borderWidth: integer; backCol, borderCol: TColor);
var
  calcRect: TRect;
  gcv: TGdiPlusCanvas;
  roundSize: integer;
begin
  if Roundness > 0 then
    calcRect := theRect
  else
    calcRect := TBGetFR(theRect);

  // gdiplus drawing
  gcv := TGdiPlusCanvas.Create(cv, true);
  try
    with gcv do
    begin

      GDPPen.Width := borderWidth;

      GDPPen.Alpha := BorderOpacity;
      if borderWidth > 0 then
        GDPPen.Style := psSolid
      else
        GDPPen.Style := psClear;

      GDPBrush.Alpha := FillOpacity;
      if (FillOpacity = 0) then
        GDPBrush.Style := bsClear
      else
        GDPBrush.Style := bssolid;

      GDPPen.Color := borderCol; // assign color always after the style!
      GDPBrush.Color := backCol; // assign color always after the style!

      GDPSmoothingMode := smBestQty;

      if Roundness > 0 then
      begin
        roundSize :=
          round(Roundness / 100 * min((calcRect.Right - calcRect.Left),
          (calcRect.Bottom - calcRect.Top)));

        gcv.RoundRect(calcRect.Left, calcRect.Top, calcRect.Right,
          calcRect.Bottom, roundSize, roundSize);
      end
      else
        gcv.Rectangle(calcRect.Left, calcRect.Top, calcRect.Right,
          calcRect.Bottom);

    end;
  finally
    gcv.free;
  end;

end;
{$ENDIF}

procedure RenderFrameToCanvas(cv: Tcanvas; theRect: TRect; Roundness: cardinal;
  // 0..100
  FillOpacity: cardinal; // 0..255
  BorderOpacity: cardinal; // 0..255
  borderWidth: integer; backCol, borderCol: TColor);
var
  calcRect: TRect;
begin

{$IFDEF TB_GDIPLUS}
  if {$IFNDEF IMAGEEN_8_1_0_LATER}GDIPLUS_Available and{$ENDIF}
   ((Roundness > 0) or (FillOpacity < 255) or
    (BorderOpacity < 255)) then
  begin
    RenderFrameToCanvas_GDIPlus(cv, theRect, Roundness, FillOpacity,
      BorderOpacity, borderWidth, backCol, borderCol);
    EXIT;
  end;
{$ENDIF}
  calcRect := TBGetFR(theRect);
  // normal gdi drawing
  if FillOpacity = 255 then
  begin
    if cv.Brush.Style <> bssolid then
      cv.Brush.Style := bssolid;

    cv.Brush.Color := backCol;
    cv.FillRect(calcRect);

  end;
  if borderWidth > 0 then
  begin
    cv.Brush.Style := bsClear;
    cv.pen.Color := borderCol;
    cv.pen.Width := borderWidth;
    cv.Rectangle(calcRect);
  end;
end;

constructor TThumbsBrowser_Thumb_LoadThread_Counter.Create;
begin
  fLockCounter := TCriticalSection.Create;
  RegisterExpectedMemoryLeak(fLockCounter);
  fcounter := 0;
end;

destructor TThumbsBrowser_Thumb_LoadThread_Counter.Destroy;
begin
  freeandnil(fLockCounter);
  inherited;
end;

function TThumbsBrowser_Thumb_LoadThread_Counter.IncCounter: integer;
begin
  fLockCounter.enter;
  try
    inc(fcounter);

  finally
    result := fcounter;
    fLockCounter.leave;
  end;
end;

function TThumbsBrowser_Thumb_LoadThread_Counter.DecCounter: integer;
begin
  fLockCounter.enter;
  try
    if fcounter > 0 then
      dec(fcounter);
  finally
    result := fcounter;
    fLockCounter.leave;
  end;
end;

procedure TThumbsBrowser_Thumb_LoadThread_Counter.SetCounter(v: integer);
begin
  fLockCounter.enter;
  try
    fcounter := v;
  finally
    fLockCounter.leave;
  end;
end;

// --------------------------------------------------------------------------------
constructor TThumbsBrowser_Thumb_LoadThread.Create;
begin
  inherited Create(true);

  FreeOnTerminate := true;
  fDatabaseSessionGUID := GUID_NULL;
  fIoTOAbort := nil;
  fAborted := FALSE;
end;

destructor TThumbsBrowser_Thumb_LoadThread.Destroy;
begin

  inherited;
end;

procedure TThumbsBrowser_Thumb_LoadThread.Init_Common(theFilename: string;
  theThumb: TThumbEx; TheLoader: TObject;
  theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
  theCriticalSection: TCriticalSection; theCleanUpCS: TCriticalSection;
  theEvent: TEvent; theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
  theExternaFileReader: TTB_Browser_FileReaderFunction;
  theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);
begin
  FreeOnTerminate := true;
  // ------------------------

  fThumb := theThumb;
  ffilename := theFilename;
  fLoader := TheLoader;
  fOnLoaded := theLoadEvent;

  fCriticalSection := theCriticalSection;
  fCleanupCriticalSection := theCleanUpCS;
  fEvent := theEvent;
  fCounterObj := theEventCounter;

  fExternalReader := theExternaFileReader;
  fLoadOnDemandAsyncHandler := theLoadOnDemandAsyncHandler;
end;

{$IFDEF TB_USEDB}

procedure TThumbsBrowser_Thumb_LoadThread.Init(bLoadFromDB: boolean;
  bSaveToDB: boolean; theFilename: string; theThumb: TThumbEx;
  TheLoader: TObject; theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
  theCriticalSection: TCriticalSection;
  theDatabaseCriticalSection: TCriticalSection; theDB: TThumbsBrowser_DB;
  theDBSessionGuid: TGUID; theCleanUpCS: TCriticalSection; theEvent: TEvent;
  theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
  theExternaFileReader: TTB_Browser_FileReaderFunction;
  theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);
begin
  Init_Common(theFilename, theThumb, TheLoader, theLoadEvent,
    theCriticalSection, theCleanUpCS, theEvent, theEventCounter,
    theExternaFileReader, theLoadOnDemandAsyncHandler);

  fLoadFromDB := bLoadFromDB;
  fSaveToDB := bSaveToDB;
  fDatabaseCriticalSection := theDatabaseCriticalSection;
  fDB := theDB;
  fDatabaseSessionGUID := theDBSessionGuid;
end;
{$ELSE}

procedure TThumbsBrowser_Thumb_LoadThread.Init(theFilename: string;
  theThumb: TThumbEx; TheLoader: TObject;
  theLoadEvent: TThumbsBrowser_Thumb_LoadThread_Event;
  theCriticalSection: TCriticalSection; theCleanUpCS: TCriticalSection;
  theEvent: TEvent; theEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;
  theExternaFileReader: TTB_Browser_FileReaderFunction;
  theLoadOnDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event);
begin
  Init_Common(theFilename, theThumb, TheLoader, theLoadEvent,
    theCriticalSection, theCleanUpCS, theEvent, theEventCounter,
    theExternaFileReader, theLoadOnDemandAsyncHandler);
end;

{$ENDIF}
{$IFDEF TB_USEDB}

procedure TThumbsBrowser_Thumb_LoadThread.InitDB(bLoadFromDB,
  bSaveToDB: boolean);
begin
  fLoadFromDB := bLoadFromDB;
  fSaveToDB := bSaveToDB;
end;
{$ENDIF}

procedure TThumbsBrowser_Thumb_LoadThread.Launch;
begin

{$IFDEF NWSCOMPS_DXE2_UPPER}
  Start;
{$ELSE}
  resume;
{$ENDIF}
  if assigned(fCounterObj) then
  begin
    fCounterObj.IncCounter;
    fEvent.ReSetEvent;
  end;
end;

procedure TThumbsBrowser_Thumb_LoadThread.CheckCounterObj;
begin
  if assigned(fCounterObj) then
  begin
    if fCounterObj.DecCounter = 0 then
      fEvent.SetEvent;
  end;
end;

procedure TThumbsBrowser_Thumb_LoadThread.Execute;
  function FExists(fname: string; theThumb: TThumbEx): boolean;
  begin
    if theThumb.SourceType = st_File then
      result := fileexists(fname)
    else if theThumb.SourceType = st_Folder then
      result := directoryexists(fname)
    else if theThumb.SourceType = st_FolderNav then
      result := true
    else if theThumb.SourceType = st_Url then
      result := true
    else if theThumb.Source_IS_WPD then
      result := true
    else
      result := FALSE;
  end;

var

  bDBLoadOk: boolean;
begin
  // Starts here------------------------------------------------
  if not CanProceed then
  begin
    freeandnil(fThumb);
    EXIT;
  end;

  if (fThumb.SourceType = st_General) and assigned(fLoadOnDemandAsyncHandler)
  then
  begin
    fLoadOnDemandAsyncHandler(self, fThumb);
    SendMessage_Finished_ToReceiver;
    EXIT;
  end;

  // CoInitialize(nil);
  try

    bDBLoadOk := FALSE;

{$IFDEF TB_USEDB}
    if fLoadFromDB and (not fThumb.Source_IS_WPD) and
      assigned(fDatabaseCriticalSection) and assigned(fDB) and (fDB.DBActive)
      and (fThumb.SourceType = st_File) then
    begin
      fDatabaseCriticalSection.enter;
      try
        if fThumb.ExistsinDB(nil, fDB, fDatabaseSessionGUID).MatchType = TERcdExists
        then
        begin
          bDBLoadOk := fThumb.RetrieveFromDB(nil, fDB, fDatabaseSessionGUID, FALSE);
        end;

      finally
        fDatabaseCriticalSection.leave;
      end;

    end;
{$ENDIF}
    if bDBLoadOk then
    begin
      SendMessage_Finished_ToReceiver;
    end
    else
    begin
      // load thumb from file
      if not CanProceed then
      begin
        freeandnil(fThumb);
        EXIT;
      end;

      try
        if FExists(ffilename, fThumb) then
        begin

          fThumb.RetrieveFromSourceFile_EX(ffilename, fExternalReader,
            fCriticalSection, true, fIoTOAbort);

{$IFDEF TB_USEDB}
          if fSaveToDB and assigned(fDatabaseCriticalSection) and assigned(fDB)
            and (fThumb.Adjourned) and (fThumb.SourceType = st_File) then
          begin
            fThumb.SaveToDB(fDatabaseCriticalSection, fDB, fDatabaseSessionGUID, true);
          end;
{$ENDIF}
          // correct thumb orientation
          if (fThumb.MetaOptions.UseExifOrientationForThumbs) then
          begin
            TBAdjustEXIFOrientation(fThumb.IEBitmap, fThumb.SourceExif_Orientation);
          end;
        end;

      finally
        SendMessage_Finished_ToReceiver;

      end;
    end;

  finally
    // CoUninitialize;
  end;
end;

procedure TThumbsBrowser_Thumb_LoadThread.Abort;
begin
  fAborted := true;

  priority := tpLowest;

  if assigned(fIoTOAbort) then
  begin
    try
      fIoTOAbort.Aborting := true;
    except
      ;
    end;
  end;
end;

function TThumbsBrowser_Thumb_LoadThread.CanProceed: boolean;
begin
  try
    result := (not fAborted) and assigned(fLoader) and
      assigned(fCleanupCriticalSection);
  except
    result := FALSE;
  end;
end;

procedure TThumbsBrowser_Thumb_LoadThread.SendMessage_Finished_ToReceiver;
begin
  if not CanProceed then
  begin
    freeandnil(fThumb);
    EXIT;
  end;

  if not TBEnterCS(fCleanupCriticalSection) then
  // If could not enter CS does not exist
  begin
    if assigned(fThumb) then
    begin
      freeandnil(fThumb);
      EXIT;
    end;
  end;
  // entered CS

  try
    if assigned(fOnLoaded) then
    begin
      fOnLoaded(self, fThumb);
      CheckCounterObj;
    end
    else
      freeandnil(fThumb);

  finally
    TBLeaveCS(fCleanupCriticalSection); // leave CS
  end;
end;

// Class TThumb--------------------------------
constructor TThumb.Create;
begin
  inherited Create;

  TBCoCreateGuid(fUniqueID);

  fStoreType := tbstore_Thumb;
  fCanSaveToDB := true;

  fAdjourned := FALSE;
  fQued := FALSE;
  fExploringStatus := thbNotExplored;

  fResampleFilter := rfNearest;
  fDisplayFilter := rfNearest;

  fIOParams := nil;

  fIEBitmap := TIEBitmap.Create;
  fIEBitmap.PixelFormat := ie24rgb;

  fSizeOnScreenW := 100;
  fSizeOnScreenH := 100;
  fSizeOffScreen := 100;
  fSizeOffScreenW := -1;
  fSizeOffScreenH := -1;

  fSourceType := st_General;
  fFileType := ft_Other;
  fSearchRec.Size := -1;
  // initialize the search record with negative size to show that it contains no useful data

{$IFDEF TB_PORTABLEDEVICE}
  fAttachedWPDInfo.DevID := '';
{$ENDIF}
  fAttachedWIAItem := nil;

  fSourceFileName := '';
  fSourceFileNameShort := '';
  fSourceFilePath := '';
  fSourceFileExtension := '';
  fSourceFileDate := 0;

  fSourceHasIOParams_Basic := FALSE;
  fSourceHasExif := FALSE;
  fSourceHasIPTC := FALSE;
  fSourceHasDICOM := FALSE;
  fSourceHasXMP := FALSE;
  fSourceExif_Orientation := 0;
  fSourceExif_GetThumb := FALSE;
  fSourceExifFileDate := -1;
  fSourceExif_XPTitle := '';
  fSourceExif_XPAuthor := '';
  fSourceExif_XPSubject := '';
  fSourceExif_XPComments := '';
  fSourceExif_XPKeywords := '';
  fSourceExif_XPRating := 0;

  fSourceFileSize := 0;
  fSourceFileWidth := 0;
  fSourceFileHeight := 0;
  fSourceFileRes := 150;
  fSourceFileCreateDate := CONST_DATENULL;

  fFrameBgColor := rgb(255, 255, 255);
  fFrameBgSelectedColor := rgb(255, 255, 255);
  fCaptionFontColor := rgb(0, 0, 0);
  fCaptionFontSelectedColor := rgb(0, 0, 0);

  fCaptionBackColor := rgb(255, 255, 255);
  fCaptionBackSelectedColor := $00FCEADA;

  fTopTitleFontColor := rgb(0, 0, 0);
  fTopTitleSelectedFontColor := rgb(0, 0, 0);
  fTopTitleBackColor := rgb(255, 255, 255);
  fTopTitleBackSelectedColor := rgb(255, 255, 255);

  fBottomTitleFontColor := rgb(0, 0, 0);
  fBottomTitleSelectedFontColor := rgb(0, 0, 0);
  fBottomTitleBackColor := rgb(255, 255, 255);
  fBottomTitleBackSelectedColor := rgb(255, 255, 255);

  fFrameBorderColor := rgb(200, 200, 200);
  fFrameBorderSelectedColor := $00CEA27D;
  fFrameSize := 2;

  fFrameRoundnessPerc := 8;
  fCaptionRoundnessPerc := 10;
  fTitleRoundnessPerc := 0;

  fBackOpacity := 255;
  fFrameBgOpacity := 255;
  fFrameBgOpacitySelected := 255;
  fFrameBorderOpacity := 255;
  fCaptionOpacity := 0;
  fTitleOpacity := 0;

  fBackOpacitySelected := 255;
  fFrameBorderOpacitySelected := 255;
  fCaptionOpacitySelected := 255;
  fTitleOpacitySelected := 255;

  FTitleDrawFocusRectIfEmpty := true;

  FBackPadding_Left := 0;
  FBackPadding_Right := 0;
  FBackPadding_Top := 0;
  FBackPadding_Bottom := 0;

  FFramePadding_Left := 2;
  FFramePadding_Right := 2;
  FFramePadding_Top := 2;
  FFramePadding_Bottom := 2;

  fTotalWidth := fSizeOnScreenW + 2 * fFrameSize;
  fTotalHeight := fSizeOnScreenH + 2 * fFrameSize;

  fDisplayedWidth := fSizeOnScreenW;
  fDisplayedHeight := fSizeOnScreenH;

  fSelected := FALSE;
  fTryReadExplorerThumb := FALSE;

  SetZeroBitmap;

end;

destructor TThumb.Destroy;
begin

  freeandnil(fIEBitmap);
  if assigned(fIOParams) then
    freeandnil(fIOParams);

  inherited;
end;

procedure TThumb.Assign(Source: TPersistent);
var
  srcthumb: TThumb;
begin
  if not(Source is TThumb) then
  begin
    inherited;
    EXIT;
  end;
  // implement below custom assign
  srcthumb := TThumb(Source);

  // the unique ID must not be assigned

  AssignStatus(Source);
  AssignInfo(Source, FALSE);
  AssignLayout(Source, FALSE);

  RefreshDimensions;
end;

procedure TThumb.AssignStatus(Source: TPersistent);
var
  srcthumb: TThumb;
begin
  if not(Source is TThumb) then
    EXIT;

  // implement below custom assign
  srcthumb := TThumb(Source);
  // Status
  fAdjourned := srcthumb.Adjourned;
  fQued := srcthumb.Qued;
  fExploringStatus := srcthumb.ExploringStatus;
end;

procedure TThumb.AssignIEBitmap(src: TIEBitmap; bHardCopy: boolean);
var
  hcBmp: TIEBitmap;
begin
  if not assigned(src) then
    EXIT;

  if src = fIEBitmap then
    EXIT; // same bitmap - leave this!!

  if bHardCopy then
  begin
    hcBmp := TIEBitmap.Create(src);
    try
      fIEBitmap.Assign(hcBmp);
    finally
      hcBmp.free;
    end;
  end
  else
    fIEBitmap.Assign(src);
end;

// ---here assigns all info after loading from file
procedure TThumb.AssignFileLoadingInfo(Source: TPersistent);
var
  srcthumb: TThumb;
begin
  if not(Source is TThumb) then
    EXIT;

  // implement below custom assign
  srcthumb := TThumb(Source);

  fAdjourned := srcthumb.Adjourned;

  // picture
  AssignIEBitmap(srcthumb.IEBitmap, FALSE);

  // Source Type and File info
  // fSourceType := srcthumb.SourceType;
  SetSourceType(srcthumb.SourceType);
  fFileType := srcthumb.FileType;

  fSearchRec := srcthumb.SearchRec;

  // files db unique name
  fUniqueName := srcthumb.Unique_Name;
  fCanSaveToDB := srcthumb.CanSaveToDB;

  fSourceFileName := srcthumb.SourceFileName;
  fSourceFileNameShort := srcthumb.SourceFileNameShort;
  fSourceFilePath := srcthumb.SourceFilePath;
  fSourceFileExtension := srcthumb.SourceFileExtension;
  fSourceFileDate := srcthumb.SourceFileDate;

  fSourceFileTypeInt := srcthumb.SourceFileTypeInt;
  fSourceFileTypeDescr := srcthumb.SourceFileTypeDescr;
  fSourceFileCreateDate := srcthumb.fSourceFileCreateDate;

  fSourceHasIOParams_Basic := srcthumb.SourceHasIOParams_Basic;
  fSourceHasExif := srcthumb.SourceHasExif;
  fSourceHasIPTC := srcthumb.SourceHasIPTC;
  fSourceHasDICOM := srcthumb.SourceHasDICOM;
  fSourceHasXMP := srcthumb.SourceHasXMP;

  fSourceExifFileDate := srcthumb.SourceExifFileDate;
  fSourceExif_XPTitle := srcthumb.SourceExif_XPTitle;
  fSourceExif_XPAuthor := srcthumb.SourceExif_XPAuthor;
  fSourceExif_XPSubject := srcthumb.SourceExif_XPSubject;
  fSourceExif_XPComments := srcthumb.SourceExif_XPComments;
  fSourceExif_XPKeywords := srcthumb.SourceExif_XPKeywords;
  fSourceExif_XPRating := srcthumb.SourceExif_XPRating;
  fSourceExif_Orientation := srcthumb.SourceExif_Orientation;
  fSourceExif_GetThumb := srcThumb.SourceExif_GetThumb;

  fSourceFileSize := srcthumb.SourceFileSize;
  fSourceFileWidth := srcthumb.SourceFileWidth;
  fSourceFileRes := srcthumb.SourceFileRes;
  fSourceFileHeight := srcthumb.SourceFileHeight;

  if assigned(srcthumb.fIOParams) then
  // use the field, DO NOT replace with the property name!!
  begin
    if not assigned(fIOParams) then
      fIOParams := TIOParams.Create(nil);

    fIOParams.Assign(srcthumb.fIOParams);
  end
  else
  begin
    freeandnil(fIOParams);
  end;
end;

procedure TThumb.AssignInfo(Source: TPersistent; bRefresh: boolean);
var
  srcthumb: TThumb;
begin
  if not(Source is TThumb) then
    EXIT;

  // implement below custom assign
  srcthumb := TThumb(Source);

  fStoreType := srcthumb.StoreType;

  fUserTag := srcthumb.UserTag;
  fUserPointer := nil;
  fUserPointer := srcthumb.UserPointer;

  fTryReadExplorerThumb := srcthumb.TryReadExplorerThumb;
  fAttachedWIAItem := srcthumb.AttachedWIAItem;
{$IFDEF TB_PORTABLEDEVICE}
  fAttachedWPDInfo := srcthumb.AttachedWPDInfo;
{$ENDIF}
  fMetaTags := srcthumb.MetaTags;
  fMetaOptions := srcthumb.MetaOptions;

  AssignFileLoadingInfo(Source);
  // ---here assigns all info that are changed after loading from file

  if bRefresh then
    RefreshDimensions;
end;

procedure TThumb.AssignLayout(Source: TPersistent; bRefresh: boolean);
var
  srcthumb: TThumb;
begin
  if not(Source is TThumb) then
    EXIT;

  // implement below custom assign
  srcthumb := TThumb(Source);

  // Layout
  fResampleFilter := srcthumb.ResampleFilter;
  fDisplayFilter := srcthumb.DisplayFilter;
  fResources := srcthumb.Resources;

  fSizeOnScreenW := srcthumb.SizeOnScreenW;
  fSizeOnScreenH := srcthumb.SizeOnScreenH;

  fSizeOffScreen := srcthumb.SizeOffScreen;
  fSizeOffScreenW := srcthumb.SizeOffScreenW;
  fSizeOffScreenH := srcthumb.SizeOffScreenH;

  fFrameBgColor := srcthumb.FrameBgColor;
  fFrameBgSelectedColor := srcthumb.FrameBgSelectedColor;

  fCaptionFontColor := srcthumb.CaptionFontColor;
  fCaptionFontSelectedColor := srcthumb.CaptionFontSelectedColor;
  fCaptionBackColor := srcthumb.CaptionBackColor;
  fCaptionBackSelectedColor := srcthumb.CaptionBackSelectedColor;

  fTopTitleFontColor := srcthumb.TopTitleFontColor;
  fTopTitleSelectedFontColor := srcthumb.TopTitleSelectedFontColor;
  fTopTitleBackColor := srcthumb.TopTitleBackColor;
  fTopTitleBackSelectedColor := srcthumb.TopTitleBackSelectedColor;

  fBottomTitleFontColor := srcthumb.BottomTitleFontColor;
  fBottomTitleSelectedFontColor := srcthumb.BottomTitleSelectedFontColor;
  fBottomTitleBackColor := srcthumb.BottomTitleBackColor;
  fBottomTitleBackSelectedColor := srcthumb.BottomTitleBackSelectedColor;

  fFrameBorderColor := srcthumb.FrameBorderColor;
  fFrameBorderSelectedColor := srcthumb.FrameBorderSelectedColor;
  fFrameSize := srcthumb.FrameSize;

  fFrameRoundnessPerc := srcthumb.FrameRoundnessPerc;
  fCaptionRoundnessPerc := srcthumb.CaptionRoundnessPerc;
  fTitleRoundnessPerc := srcthumb.TitleRoundnessPerc;

  fBackOpacity := srcthumb.BackOpacity;
  fFrameBgOpacity := srcthumb.FrameBgOpacity;
  fFrameBgOpacitySelected := srcthumb.FrameBgOpacitySelected;
  fFrameBorderOpacity := srcthumb.FrameBorderOpacity;
  fCaptionOpacity := srcthumb.CaptionOpacity;
  fTitleOpacity := srcthumb.TitleOpacity;

  fBackOpacitySelected := srcthumb.BackOpacitySelected;
  fFrameBorderOpacitySelected := srcthumb.FrameBorderOpacitySelected;
  fCaptionOpacitySelected := srcthumb.CaptionOpacitySelected;
  fTitleOpacitySelected := srcthumb.TitleOpacitySelected;

  FTitleDrawFocusRectIfEmpty := srcthumb.TitleDrawFocusRectIfEmpty;

  FBackPadding_Left := srcthumb.BackPadding_Left;
  FBackPadding_Right := srcthumb.BackPadding_Right;
  FBackPadding_Top := srcthumb.BackPadding_Top;
  FBackPadding_Bottom := srcthumb.BackPadding_Bottom;

  FFramePadding_Left := srcthumb.FramePadding_Left;
  FFramePadding_Right := srcthumb.FramePadding_Right;
  FFramePadding_Top := srcthumb.FramePadding_Top;
  FFramePadding_Bottom := srcthumb.FramePadding_Bottom;

  fTotalWidth := srcthumb.TotalWidth;
  fTotalHeight := srcthumb.TotalHeight;

  fDisplayedWidth := srcthumb.fDisplayedWidth;
  fDisplayedHeight := srcthumb.fDisplayedHeight;

  if bRefresh then
    RefreshDimensions;
end;

procedure TThumb.AssignOffScreenBitmap(theIEBitmap: TIEBitmap);
begin
  if theIEBitmap = nil then
    EXIT;

  AssignIEBitmap(theIEBitmap, FALSE);
  RefreshDimensions;
end;

Function TThumb.IsEmpty: boolean;
begin
  result := IsZeroBitmap;
end;

procedure TThumb.SetZeroBitmap;
begin
  fIEBitmap.PixelFormat := ie24rgb;
  fIEBitmap.Width := 0;
  fIEBitmap.Height := 0;
end;

function TThumb.IsZeroBitmap: boolean;
begin
  result := (fIEBitmap.Width = 0) or (fIEBitmap.Height = 0);
end;

procedure TThumb.SetResources(theresources: TTB_GraphicResources);
begin
  fResources := theresources;
  RefreshDimensions;
end;

function TThumb.GetSourceHasIOParams_Full: boolean;
begin
  result := fIOParams <> nil;
end;

function TThumb.GetSource_IS_FileSystem: boolean;
begin
  result := (fSourceType = st_File) or (fSourceType = st_Folder);
end;

function TThumb.GetSource_IS_WIA: boolean;
begin
  result := fSourceType = st_Wia;
end;

function TThumb.GetSource_IS_WPD: boolean;
begin
  result := (fSourceType = st_WpdFile) or (fSourceType = st_WpdFolder) or
    (fSourceType = st_WpdFolderNav);
end;

procedure TThumb.GetResizedDimensions(var new_w, new_h: integer; w, h: integer);
begin
  if (fSizeOffScreenW > 0) and (fSizeOffScreenH > 0) then
  begin
    new_w := fSizeOffScreenW;
    new_h := fSizeOffScreenH;
  end
  else if fSizeOffScreen <= 0 then
  begin
    new_w := w;
    new_h := h;
  end
  else if (w <= fSizeOffScreen) and (h <= fSizeOffScreen) then
  begin
    new_w := w;
    new_h := h;
  end
  else
  begin
    if w > h then
    begin
      new_w := fSizeOffScreen;
      new_h := round(new_w * h / w);
    end
    else
    begin
      new_h := fSizeOffScreen;
      new_w := round(new_h * w / h);
    end;
  end;
end;

procedure TThumb.GetBasicIOParamsFromIO(aio: TImageenio);
begin
  fSourceFileTypeInt := aio.Params.FileType;
  fSourceFileTypeDescr := aio.Params.FileTypeStr;
  fSourceFileWidth := aio.Params.Width;
  fSourceFileHeight := aio.Params.Height;
  fSourceFileRes := aio.Params.Dpi;

  fSourceHasExif := aio.Params.EXIF_HasEXIFData;
  fSourceHasIPTC := aio.Params.IPTC_Info.Count > 0;
  fSourceHasDICOM := aio.Params.DICOM_Tags.Count > 0;
  fSourceHasXMP := aio.Params.XMP_Info <> '';

  if fSourceHasExif then
  begin
    fSourceExifFileDate := GetExifDate_ex(aio);
    fSourceExif_XPTitle := aio.Params.EXIF_XPTitle;
    fSourceExif_XPAuthor := aio.Params.EXIF_XPAuthor;
    fSourceExif_XPSubject := aio.Params.EXIF_XPSubject;
    fSourceExif_XPComments := aio.Params.EXIF_XPComment;
    fSourceExif_XPKeywords := aio.Params.EXIF_XPKeywords;
    fSourceExif_XPRating := aio.Params.EXIF_XPRating;
    fSourceExif_Orientation := aio.Params.EXIF_Orientation;
  end;
  fSourceHasIOParams_Basic := true;
end;

procedure TThumb.ResetIOParams;
begin
  fSourceHasIOParams_Basic := FALSE;
  if assigned(fIOParams) then
    freeandnil(fIOParams);
  // Reset the previous params storage if any were created
end;

procedure TThumb.RetrieveParamsfromSourceFile(theFilename: string);
var
  aio: TImageenio;
begin

  if theFilename = '' then
    EXIT;

  ResetIOParams;

  if (fSourceType = st_Folder) or (fSourceType = st_FolderNav) then
  begin
    fSourceHasExif := FALSE;
    fSourceHasIPTC := FALSE;
    fSourceHasDICOM := FALSE;
    fSourceHasXMP := FALSE;
  end
  else
  begin
    aio := TImageenio.Create(nil);
    try
      aio.ParamsFromFile(theFilename);
      GetBasicIOParamsFromIO(aio);
    finally
      aio.free;
    end;
  end;
end;

procedure TThumb.RetrieveFromSourceFile(theFilename: string);
var
  aFormat: TTB_Browser_FileFormat;
  dummyIO: TImageenio;
begin
  TBFileFormat_GetEmptyFormat(aFormat);
  RetrieveFromSourceFile(theFilename, aFormat, nil, FALSE, dummyIO);
end;

procedure TThumb.RetrieveFromSourceFile(theFilename: string;
  theFormat: TTB_Browser_FileFormat; theCriticalSection: TCriticalSection;
  bUseCriticalSection_whenNeeded: boolean; var theLoadingIO: TImageenio);
type
  TThumbExExtractResult = (exThumb, exIcon, exNone);
var
  aio: TImageenio;

  function GetSystemIcon: boolean;
  begin
    if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
      theCriticalSection.enter;
    try
      result := tbs_GetFileIcon(fSourceFileName, fIEBitmap, FALSE);
    finally
      if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
        theCriticalSection.leave;
    end;
  end;

  function GetJumboFileIcon(const bAssignToResource: boolean;
    resourceType: TTB_Thumb_GraphicResourceType): boolean;
  Begin
    if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
      theCriticalSection.enter;
    try
      result := tbs_GetFileIcon(fSourceFileName, fIEBitmap, true);

      if result then
      begin
        if bAssignToResource then
          fResources.AssignResource(fIEBitmap, resourceType);
      end;
    finally
      if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
        theCriticalSection.leave;
    end;
  End;

  procedure DoLoad_FileIcon;
  begin
    GetSystemIcon;

    fFileType := ft_Other;
    DoFinishLoading(true, FALSE)
  end;

  procedure DoLoad_FolderIcon;
  var
    bIsSpecial: boolean;
  begin
    bIsSpecial := tbs_IsSpecialFolder(SourceFileName);

    if bIsSpecial then
      GetJumboFileIcon(FALSE, gr_FolderNormal)
    else
    begin
      if (fResources.HAS_FolderNormal) then
        AssignIEBitmap(fResources.BMP_FolderNormal, FALSE)
      else
        GetJumboFileIcon(true, gr_FolderNormal);
      // get the normal folder icon and save it to resource
    end;

    fFileType := ft_Other;
    DoFinishLoading(true, FALSE);
  end;

  function DoLoad_PictureFile(bTakeExifThumb: boolean): boolean;
  var
    bWrongExifThumb: boolean;
  begin

    result := FALSE;

    bTakeExifThumb := bTakeExifThumb and (fStoreType = tbstore_Thumb);
    try
      aio.AttachedIEBitmap := fIEBitmap;
      aio.Params.Width := fSizeOffScreen; // set in order to autocalc jpeg size
      aio.Params.Height := fSizeOffScreen; // set in order to autocalc jpeg size

      if (fStoreType = tbstore_Thumb) then
      begin
        aio.Params.JPEG_Scale := IOJPEG_AUTOCALC;
        aio.Params.RAW_HalfSize := true;
        aio.Params.RAW_QuickInterpolate := true;
      end
      else
      begin
        aio.Params.JPEG_Scale := ioJPEG_FULLSIZE;
        aio.Params.RAW_HalfSize := FALSE;
        aio.Params.RAW_QuickInterpolate := FALSE;
      end;

      //-----------------------------------------------------------------
      aio.Params.GetThumbnail := (bTakeExifThumb); // should we get the thumbnail ?
      //-----------------------------------------------------------------

      TBLoadFromFile(aio, fSourceFileName, (fStoreType = tbstore_Thumb));

      if bTakeExifThumb then   //verify consistent orientation (due to inconsistency in the EXIF data)
      begin
        if IsZeroBitmap then
          bWrongExifThumb := TRUE
        else if (aio.Params.EXIF_Orientation >1) and
                (not TBDetectSameOrientation(fIEBitmap.width, fIEBitmap.Height, aio.Params.Width, aio.Params.Height)) then
          bWrongExifThumb := TRUE
        else
          bWrongExifThumb := FALSE;

        if bWrongExifThumb then // error no thumbnail found //load the whole file
        begin
          aio.Params.GetThumbnail := FALSE;
          TBLoadFromFile(aio, fSourceFileName, (fStoreType = tbstore_Thumb));
        end;
      end;

      result := not IsZeroBitmap;

      if result then
      begin
        fFileType := ft_Pic;
        fSourceExif_GetThumb := aio.Params.GetThumbnail;
      end
      else
      begin // if still zero size then load system icon
        fFileType := ft_Other;
        GetSystemIcon;
      end;

    finally
      DoFinishLoading(true, true);
    end;
  end;

  function DoLoad_VIDEO: boolean;
  var
    fc: integer;
  begin
    result := FALSE;
    aio.AttachedIEBitmap := fIEBitmap;
    fc := aio.OpenMediaFile(fSourceFileName);

    try
      if fc > 0 then
      begin
        aio.LoadFromMediaFile(fc div 2);
        fSourceFileWidth := aio.Params.Width;
        fSourceFileHeight := aio.Params.Height;
        result := true;
      end;
    finally
      aio.CloseMediaFile;
    end;

    if result then
      fFileType := ft_Video
    else
    begin
      fFileType := ft_Other;
      GetSystemIcon;
    end;

    DoFinishLoading(true, true);
  end;

  function DoLoad_RAW: boolean;
  var
  bWrongExifThumb:boolean;
  begin
    result := FALSE;
    aio.Params.Width := fSizeOffScreen;
    aio.Params.Height := fSizeOffScreen;

    if (fStoreType = tbstore_Thumb) and aio.Params.EXIF_HasEXIFData and
      assigned(aio.Params.EXIF_Bitmap) and (aio.Params.EXIF_Bitmap.Width > 0)
      and (aio.Params.EXIF_Bitmap.Height > 0) then
    begin
      AssignIEBitmap(aio.Params.EXIF_Bitmap, FALSE);
      aio.Params.GetThumbnail := true;
    end
    else
    begin
      aio.Params.RAW_QuickInterpolate := (fStoreType = tbstore_Thumb);
      aio.Params.RAW_HalfSize := (fStoreType = tbstore_Thumb);
      aio.Params.GetThumbnail := (fStoreType = tbstore_Thumb);

      aio.AttachedIEBitmap := fIEBitmap;
      TBLoadFromFile(aio, fSourceFileName, (fStoreType = tbstore_Thumb));
    end;


    if aio.Params.GetThumbnail then   //verify non-zero exif thumb and
                                     // consistent orientation (due to inconsistency in the EXIF data)
      begin
        if IsZeroBitmap then
          bWrongExifThumb := TRUE
        else if (aio.Params.EXIF_Orientation >1) and
                (not TBDetectSameOrientation(fIEBitmap.width, fIEBitmap.Height, aio.Params.Width, aio.Params.Height)) then
          bWrongExifThumb := TRUE
        else
          bWrongExifThumb := FALSE;

        if bWrongExifThumb then // error no thumbnail found or orientation incorrect //load the whole file
        begin
          aio.Params.GetThumbnail := FALSE;
          TBLoadFromFile(aio, fSourceFileName, (fStoreType = tbstore_Thumb));
        end;
      end;

     {
    if IsZeroBitmap and (aio.Params.GetThumbnail) then
    // error no thumbnail found
    begin // load the whole file
      aio.Params.GetThumbnail := FALSE;
      TBLoadFromFile(aio, fSourceFileName, true);
    end; }

    result := not IsZeroBitmap;

    if result then
      fFileType := ft_Pic
    else
    begin // if still zero size then load system icon
      fFileType := ft_Other;
      GetSystemIcon;
    end;

    DoFinishLoading(true, true);
  end;

  function DoLoad_ExternalReader: boolean;
  var
    bExternalReader_AllowSaveToDB: boolean;
  begin
    result := FALSE;
    if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
      theCriticalSection.enter;
    try
      result := theFormat.ReaderFunction(bExternalReader_AllowSaveToDB,
        fIEBitmap, fSourceFileName, 0);
    finally
      if bUseCriticalSection_whenNeeded and assigned(theCriticalSection) then
        theCriticalSection.leave;
    end;

    if result then
    begin
      if theFormat.IsVideo then
        fFileType := ft_Video
      else
        fFileType := ft_Pic;
    end
    else
    begin
      fFileType := ft_Other;
      GetSystemIcon;
    end;

    DoFinishLoading(true, bExternalReader_AllowSaveToDB)
  end;

// ---------------------------------------------------------------------------------------
begin
  if theFilename = '' then
    EXIT;

{$IFDEF TB_PORTABLEDEVICE}
  if Source_IS_WPD and (fSourceType <> st_WpdFolderNav) then
  begin

    if bUseCriticalSection_whenNeeded then
      RetrieveFromWPD(fAttachedWPDInfo.WPD, fAttachedWPDInfo.DevID,
        fAttachedWPDInfo.Rcd.ID, FALSE, theCriticalSection)
    else
      RetrieveFromWPD(fAttachedWPDInfo.WPD, fAttachedWPDInfo.DevID,
        fAttachedWPDInfo.Rcd.ID, FALSE);

    EXIT;
  end;
{$ENDIF}
  if fSearchRec.Attr = TBCONST_SR_ATTR_URL then
  begin
    RetrieveFromUrl(theFilename);
    EXIT; // >>>>EXIT
  end;

  if fSearchRec.Size < 0 then // search record not initialized
  begin
    if findfirst(theFilename, faAnyfile, fSearchRec) = 0 then
      findclose(fSearchRec)
    else
      EXIT; // search record not initialized
  end;

  SourceFileName := theFilename;
  // ---------------------------------------------

  if (fSearchRec.name = '') then
  begin
    fSourceType := st_FolderNav;
  end
  else if (fSearchRec.Attr and faDirectory) <> 0 then
  begin
    if (fSearchRec.name = '..') then
      fSourceType := st_FolderNav
    else
      fSourceType := st_Folder;
  end
  else
  begin
    fSourceType := st_File;
  end;
  // ---------------------------------------------
  fSourceFileDate := tbs_getfiledate(fSearchRec);
  fSourceFileSize := fSearchRec.Size;

  Unique_Name := TBGenerateUniquename(fSourceFileName, fSourceFileDate,
    fSourceFileSize);

  if fSourceType = st_FolderNav then
  begin
    AssignIEBitmap(fResources.BMP_FolderUpLevel, FALSE);
    fFileType := ft_Other;
    DoFinishLoading(true, FALSE);
    EXIT;
  end
  else if (fSourceType = st_Folder) then
  begin
    DoLoad_FolderIcon;
    EXIT; // >>>> EXIT
  end;

  // Here loads the picture data from source file
  // resample to fit Offscreensize and store into the buffer
  if assigned(fIOParams) then
    freeandnil(fIOParams);
  // Reset the previous params storage if any were created

  aio := TImageenio.Create(nil);
  // ---------------------
  theLoadingIO := aio;
  // ---------------------
  try
    aio.AsyncMode := FALSE;
    aio.ParamsFromFile(fSourceFileName);
    GetBasicIOParamsFromIO(aio);

    fSourceExif_GetThumb := FALSE;

    if assigned(theFormat.ReaderFunction) then
    begin
      if not DoLoad_ExternalReader then
        DoLoad_FileIcon;
    end
    else if tbs_FileExtIsVIDEO(fSourceFileExtension) then
      DoLoad_VIDEO
    else if tbs_FileExtIsRAW(fSourceFileExtension) then
      DoLoad_RAW
    else if (fSourceFileWidth = 0) or (fSourceFileHeight = 0) then
    // file not recognized
      DoLoad_FileIcon
    else
      DoLoad_PictureFile(aio.Params.EXIF_HasEXIFData);
  finally
    aio.free;
  end;
end;

procedure TThumb.DoFinishLoading(loaded: boolean; const bCanSaveToDb: boolean);
var
  w, h, new_w, new_h: integer;
  bResize: boolean;
begin
  fCanSaveToDB := bCanSaveToDb;

  SetAdjournedTrue;

  // --------------------------------------------------------------------------
  if not(fSourceType in (TBGetSourceTypes_FileSystem + [st_FolderNav])) then
    fSearchRec.Size := -1;
  // --------------------------------------------------------------------------

  if (not loaded) or (IsZeroBitmap) then
  begin
    SetZeroBitmap;
    EXIT; // >>>>EXIT
  end;

  // Important------------------------
  // ---------------------------------
  fIEBitmap.PixelFormat := ie24rgb;
  fIEBitmap.Location := ieFile;
  // ---------------------------------

  w := fIEBitmap.Width;
  h := fIEBitmap.Height;

  GetResizedDimensions(new_w, new_h, w, h);

  // -------------------------------
  bResize := ((fSizeOffScreen > 0) and (fStoreType = tbstore_Thumb)) and
    (fSourceType <> st_FolderNav) and (fSourceType <> st_WpdFolderNav);
  // -------------------------------
  if assigned(fOnBufferLoaded) then
    fOnBufferLoaded(self, w, h, bResize, new_w, new_h);

  if bResize and ((fIEBitmap.Width <> new_w) or (fIEBitmap.Height <> new_h))
  then
  begin
    fproc := TImageenProc.Create(nil);
    try
      fproc.AttachedIEBitmap := fIEBitmap;
      fproc.resample(new_w, new_h, fResampleFilter);
      // this will resample the alpha channel as well (if any)
    finally
      fproc.free;
    end;
  end;

  if (fSourceType = st_General) then
  begin
    fSourceFileWidth := fIEBitmap.Width;
    fSourceFileHeight := fIEBitmap.Height;
    fSourceFileSize := (fIEBitmap.Width * fIEBitmap.Height * 3);
    fSourceFileDate := now;
    fSourceFileCreateDate := now;
  end;


  RefreshDimensions; // this refreshes the dimensions on display
end;

procedure TThumb.RetrieveFromIEBitmap(theIEBitmap: TIEBitmap);
begin

  if not assigned(theIEBitmap) then
    EXIT;

  // ------------------------------
  fSourceType := st_General;
  // ------------------------------
  AssignIEBitmap(theIEBitmap, FALSE);

  DoFinishLoading(true, FALSE);
end;

procedure TThumb.RetrieveFromBitmap(theBitmap: Tbitmap);
begin

  if not assigned(theBitmap) then
    EXIT;
  // ------------------------------
  fSourceType := st_General;
  // ------------------------------

  fIEBitmap.Assign(theBitmap);

  DoFinishLoading(true, FALSE);
end;

procedure TThumb.RetrieveFromStream(st: TStream);
var
  aio: TImageenio;
begin
  if not assigned(st) then
    EXIT;
  // ------------------------------
  fSourceType := st_General;
  // ------------------------------
  aio := TImageenio.Create(nil);
  try
    aio.AttachedIEBitmap := fIEBitmap;
    aio.LoadFromStream(st);
    DoFinishLoading(true, FALSE);
  finally

    aio.free;

  end;

end;

procedure TThumb.RetrieveFromUrl(url: string);
var
  bSuccess: boolean;
  aio: TImageenio;
begin
  SourceFileName := url;

  aio := TImageenio.Create(nil);
  if assigned(fInternetOptions) then
  begin
    aio.ProxyAddress := fInternetOptions.ProxyAddress;
    aio.ProxyUser := fInternetOptions.ProxyUser;
    aio.ProxyPassword := fInternetOptions.ProxyPassword;
  end;
  aio.AttachedIEBitmap := fIEBitmap;
  try
    bSuccess := TBLoadFromUrl(aio, url);
    if bSuccess then
    begin
      fSourceType := st_Url;
      GetBasicIOParamsFromIO(aio);
    end
    else
      fSourceType := st_General;
  finally

    freeandnil(aio);

    DoFinishLoading(true, true);
  end;
end;

procedure TThumb.RetrieveParamsFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem);
var
  adt_array: array of dword;
  aDt, aDate, aTime: TDatetime;
begin
  if not assigned(aWIA) then
    EXIT;
  if not assigned(aWIAItem) then
    EXIT;

  // ------------------------------
  fSourceType := st_Wia;
  // this is set her as well in the RetrieveFromWIA method as WIA loading is a two steps process
  // ------------------------------
  fAttachedWIAItem := aWIAItem;
  fSourceFilePath := '';
  fSourceFileExtension :=
    EnsureFileExt(aWIA.getitemproperty(WIA_IPA_FILENAME_EXTENSION, aWIAItem));
  fSourceFileNameShort := extractfilename
    (aWIA.getitemproperty(WIA_IPA_ITEM_NAME, aWIAItem)) + fSourceFileExtension;
  fSourceFileName := extractfilename
    (aWIA.getitemproperty(WIA_IPA_FULL_ITEM_NAME, aWIAItem)) +
    fSourceFileExtension;
  fSourceFileSize := aWIA.getitemproperty(WIA_IPA_ITEM_SIZE, aWIAItem);
  aDt := now;
  try
    adt_array := aWIA.getitemproperty(WIA_IPA_ITEM_TIME, aWIAItem);
    if adt_array[0] <> 0 then
    begin
      aDate := EncodeDate(adt_array[0], adt_array[1], adt_array[3]);
      aTime := EncodeTime(adt_array[4], adt_array[5], adt_array[6],
        adt_array[7]);
      aDt := TBDateTimeAddTime(aDate, aTime);
    end;
  except
    ;
  end;

  fSourceFileDate := aDt;
  Unique_Name := TBGenerateUniquename(fSourceFileName, fSourceFileDate,
    fSourceFileSize);
  //
  fSourceFileWidth := aWIA.getitemproperty(WIA_DPC_PICT_WIDTH, aWIAItem);
  if fSourceFileWidth = 0 then
    fSourceFileWidth := aWIA.getitemproperty(WIA_IPC_THUMB_WIDTH, aWIAItem);

  fSourceFileHeight := aWIA.getitemproperty(WIA_DPC_PICT_HEIGHT, aWIAItem);
  if fSourceFileHeight = 0 then
    fSourceFileHeight := aWIA.getitemproperty(WIA_IPC_THUMB_HEIGHT, aWIAItem);

  fSourceExifFileDate := fSourceFileDate;
  fSourceHasExif := FALSE;
  fSourceHasIPTC := FALSE;
  fSourceHasDICOM := FALSE;
  fSourceHasXMP := FALSE;
end;

procedure TThumb.RetrieveFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem);
begin
  if not assigned(aWIA) then
    EXIT;
  if not assigned(aWIAItem) then
    EXIT;

  // ------------------------------
  fSourceType := st_Wia;
  // this is set her as well in the RetrieveParamsFromWIA method as WIA loading is a two steps process
  // ------------------------------
  RetrieveParamsFromWIA(aWIA, aWIAItem);
  aWIA.GetItemThumbnail(aWIAItem, fIEBitmap);

  DoFinishLoading(true, FALSE);
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumb.RetrieveAsWPDNavigator(aWPD: TIEPortableDevices;
  const DevID: string; parentFolderID: string);
begin

  if not assigned(aWPD) then
    EXIT;

  // ------------------------------
  fSourceType := st_WpdFolderNav;
  // ------------------------------

  fAttachedWPDInfo.WPD := aWPD;
  fAttachedWPDInfo.DevID := DevID;
  fAttachedWPDInfo.Rcd.ID := parentFolderID;

  AssignIEBitmap(fResources.BMP_FolderUpLevel, FALSE);
  DoFinishLoading(true, FALSE);

end;

procedure TThumb.InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
  ObjID: string);
var
  Idx: integer;
begin
  if not assigned(aWPD) then
    EXIT;

  Idx := aWPD.ObjectIDToIndex(ObjID);
  InitFromWPD(aWPD, DevID, aWPD.Objects[Idx]);

end;

procedure TThumb.InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
  aWPDObj: TIEWPDObject);
var
  bPropOk: boolean;
  Idx: integer;
  props: TIEWPDObjectAdvancedProps;
begin
  fAttachedWPDInfo.WPD := aWPD;
  fAttachedWPDInfo.DevID := DevID;
  fAttachedWPDInfo.Rcd := aWPDObj;

  // ------------------------------
  if aWPDObj.ObjectType = iewFolder then
    fSourceType := st_WpdFolder
  else
    fSourceType := st_WpdFile;
  // ------------------------------

  Idx := aWPD.ObjectIDToIndex(aWPDObj.ID);

  fSourceFilePath := aWPDObj.Path;
  fSourceFileExtension := extractfileext(aWPDObj.Filename);
  fSourceFileNameShort := extractfilename(aWPDObj.Filename);
  if aWPDObj.ObjectType = iewFolder then
    fSourceFileName := fSourceFilePath
  else
    fSourceFileName := extractfilepath(fSourceFilePath) +
      extractfilename(aWPDObj.Filename);

  if fSourceFileNameShort = '' then
    fSourceFileNameShort := fSourceFileName;

  if aWPD.ObjectIsFolder(Idx) then
    bPropOk := pos(aWPD.Objects[Idx].Filename, aWPD.Objects[Idx].Path) > 0
  else
    bPropOk := true;

  if bPropOk then
  begin
    aWPD.GetObjectAdvancedProps(DevID, aWPDObj.ID, props);
    fAttachedWPDInfo.ExtendedProps := props;

    fSourceFileSize := props.SizeBytes;
    fSourceFileDate := props.DateModified;
  end;

  Unique_Name := TBGenerateUniquename(fSourceFileName, fSourceFileDate,
    fSourceFileSize);

  fSourceExifFileDate := fSourceFileDate;
  fSourceHasExif := FALSE;
  fSourceHasIPTC := FALSE;
  fSourceHasDICOM := FALSE;
  fSourceHasXMP := FALSE;
end;

procedure TThumb.RetrieveFromWPD(aWPD: TIEPortableDevices;
  const DevID, ObjID: string; const bLoadInfo: boolean;
  CS: TCriticalSection = nil);
  procedure CheckEnterCS;
  begin
    if assigned(CS) then
      CS.enter;
  end;

  procedure CheckLeaveCS;
  begin
    if assigned(CS) then
      CS.leave;
  end;

  function CopyFromDevice(ms: TMemorystream): boolean;
  begin
    CheckEnterCS;
    try
      result := aWPD.CopyStreamFromDevice(DevID, fAttachedWPDInfo.Rcd.ID, ms);
    finally
      CheckLeaveCS;
    end;
  end;

var
  aMemStream: TMemorystream;
begin
  if not assigned(aWPD) then
    EXIT;

  if bLoadInfo then
  begin
    CheckEnterCS;
    try
      InitFromWPD(aWPD, DevID, ObjID);
    finally
      CheckLeaveCS;
    end;
  end;

  if (fAttachedWPDInfo.Rcd.ObjectType = iewFolder) then
  begin
    CheckEnterCS;
    try
      // Get a folder icon
      tbs_GetFileIcon(tbs_GetSpecialFolderPath(CSIDL_PROGRAM_FILES),
        fIEBitmap, true);
    finally
      CheckLeaveCS;
    end;

  end
  else
  begin
    if (IsKnownFormat(fAttachedWPDInfo.Rcd.Filename)) and
    // try to load only known format
      (not tbs_FileExtIsVIDEO(extractfileext(fAttachedWPDInfo.Rcd.Filename)))
    then // but do not include videos (too slow)
    begin
      // Retrieve the image from the device
      aMemStream := TMemorystream.Create;
      try
        if CopyFromDevice(aMemStream) then // inside here use the CS
        begin
          fIEBitmap.Read(aMemStream); // outside the CS is not needed

          fSourceFileWidth := fIEBitmap.Width;
          fSourceFileHeight := fIEBitmap.Height;
        end;
      finally
        aMemStream.free;
      end;
    end
    else
    begin
      CheckEnterCS;
      try
        // Get file icon
        tbs_GetFileIcon('*' + extractfileext(fAttachedWPDInfo.Rcd.Filename),
          fIEBitmap, FALSE);
      finally
        CheckLeaveCS;
      end;

    end;
  end;

  DoFinishLoading(true, FALSE);
end;
{$ENDIF}

procedure TThumb.HandleWIATransfer(theIEBitmap: TIEBitmap;
  var IOParams: TObject);
begin
  AssignIEBitmap(theIEBitmap, FALSE);
end;

procedure TThumb.RefreshDimensions;
var
  offscrW, offscrH: integer;
begin
  offscrW := GetOffScreenWidth;
  offscrH := GetOffScreenHeight;

  if (fSizeOnScreenW = 0) or (fSizeOnScreenH = 0) then
  begin
    fDisplayedWidth := 0;
    fDisplayedHeight := 0;
  end
  else if offscrW / fSizeOnScreenW > offscrH / fSizeOnScreenH then
  begin
    if offscrW > fSizeOnScreenW then
    begin
      fDisplayedWidth := fSizeOnScreenW;
      fDisplayedHeight := round(fDisplayedWidth * offscrH / offscrW);
    end
    else
    begin
      fDisplayedWidth := offscrW;
      fDisplayedHeight := offscrH;
    end;
  end
  else
  begin
    if offscrH > fSizeOnScreenH then
    begin
      fDisplayedHeight := fSizeOnScreenH;
      fDisplayedWidth := round(fDisplayedHeight * offscrW / offscrH);
    end
    else
    begin
      fDisplayedWidth := offscrW;
      fDisplayedHeight := offscrH;
    end;
  end;

  fTotalWidth := fSizeOnScreenW + 2 * fFrameSize;
  fTotalHeight := fSizeOnScreenH + 2 * fFrameSize;
end;

procedure TThumb.PaintToCanvas(cv: Tcanvas; x0, y0: integer);
begin
  // virtual only implemented in TThumbEX
end;

procedure TThumb.SetSizeOnScreenW(value: cardinal);
begin
  fSizeOnScreenW := value;
  RefreshDimensions;
end;

procedure TThumb.SetSizeOnScreenH(value: cardinal);
begin
  fSizeOnScreenH := value;
  RefreshDimensions;
end;

procedure TThumb.SetSizeOffScreen(thesize: integer);
begin
  fSizeOffScreen := thesize;
  fSizeOffScreenW := -1;
  fSizeOffScreenH := -1;
  RefreshDimensions;
end;

procedure TThumb.SaveThumbToFile(theFilename: string; quality: integer);
var
  io: TImageenio;
  qty: integer;
begin
  if GetIEBitmap = nil then
    EXIT;

  qty := 40 + (60 * quality div 100);
  io := TImageenio.Create(nil);
  try
    io.AttachedIEBitmap := GetIEBitmap;
    io.Params.JPEG_Quality := qty;
    io.Params.PNG_Compression := 9;
    io.SaveToFile(theFilename);
  finally
    io.free;
  end;

end;

procedure TThumb.SetAdjournedFalse(newUniqueName: string);
begin
  fUniqueName := newUniqueName;
  fAdjourned := FALSE;
end;

procedure TThumb.SetAdjournedTrue;
begin
  fAdjourned := true;
end;

function TThumb.RecreateUniqueName: string;
begin
  if findfirst(fSourceFileName, faAnyfile, fSearchRec) = 0 then
    findclose(fSearchRec);

  // inside here the new unique name is recreated
  InitFromSearchRecord(fSearchRec, extractfilepath(fSourceFileName));

  result := fUniqueName;
end;

procedure TThumb.InitFromSearchRecord(sr: TSearchRec;
  thefolder_slashed: string);
begin

  fSearchRec := sr;
  // fSourceFileName := thefolder_slashed + sr.Name;
  SetSourceFileName(thefolder_slashed + sr.name);
  fSourceFileDate := tbs_getfiledate(sr);
  fSourceFileSize := sr.Size;

  if sr.Attr = TBCONST_SR_ATTR_URL then
  begin
    fSourceType := st_Url;
  end
  else
  begin
    if (sr.Attr and faDirectory) <> 0 then
    begin
      if sr.name = '..' then
        fSourceType := st_FolderNav
      else
        fSourceType := st_Folder;
    end
    else
      fSourceType := st_File;
  end;
  fUniqueName := TBGenerateUniquename(fSourceFileName, fSourceFileDate,
    fSourceFileSize);
  SetAdjournedFalse(fUniqueName);
end;

procedure TThumb.SetBackOpacity(const value: cardinal);
begin
  fBackOpacity := value;
end;

procedure TThumb.SetBackPadding_Bottom(const value: integer);
begin
  FBackPadding_Bottom := value;
  RefreshDimensions;
end;

procedure TThumb.SetBackPadding_Left(const value: integer);
begin
  FBackPadding_Left := value;
  RefreshDimensions;
end;

procedure TThumb.SetBackPadding_Right(const value: integer);
begin
  FBackPadding_Right := value;
  RefreshDimensions;
end;

procedure TThumb.SetBackPadding_Top(const value: integer);
begin
  FBackPadding_Top := value;
  RefreshDimensions;
end;

procedure TThumb.SetBackOpacitySelected(const value: cardinal);
begin
  fBackOpacitySelected := value;
end;

procedure TThumb.SetCaptionOpacity(const value: cardinal);
begin
  fCaptionOpacity := value;
end;

procedure TThumb.SetCaptionRoundnessPerc(const value: cardinal);
begin
  fCaptionRoundnessPerc := value;
  RefreshDimensions;
end;

procedure TThumb.SetCaptionOpacitySelected(const value: cardinal);
begin
  fCaptionOpacitySelected := value;
end;

procedure TThumb.SetFrameBorderOpacity(const value: cardinal);
begin
  fFrameBorderOpacity := value;
end;

procedure TThumb.SetFrameBgOpacity(const value: cardinal);
begin
  fFrameBgOpacity := value;
end;

procedure TThumb.SetFrameBgOpacitySelected(const value: cardinal);
begin
  fFrameBgOpacitySelected := value;
end;

procedure TThumb.SetFramePadding_Bottom(const value: integer);
begin
  FFramePadding_Bottom := value;
  RefreshDimensions;
end;

procedure TThumb.SetFramePadding_Left(const value: integer);
begin
  FFramePadding_Left := value;
  RefreshDimensions;
end;

procedure TThumb.SetFramePadding_Right(const value: integer);
begin
  FFramePadding_Right := value;
  RefreshDimensions;
end;

procedure TThumb.SetFramePadding_Top(const value: integer);
begin
  FFramePadding_Top := value;
  RefreshDimensions;
end;

procedure TThumb.SetFrameRoundnessPerc(const value: cardinal);
begin
  fFrameRoundnessPerc := value;
  RefreshDimensions;
end;

procedure TThumb.SetFrameBorderOpacitySelected(const value: cardinal);
begin
  fFrameBorderOpacitySelected := value;
end;

procedure TThumb.SetFrameSize(thesize: cardinal);
begin
  fFrameSize := thesize;
  RefreshDimensions;
end;

procedure TThumb.SetSourceFileName(thevalue: string);
begin

  fSourceFileName := thevalue;
  if SourceType = st_Url then
  begin
    fSourceFileNameShort := tbs_UrlExtractFilename(fSourceFileName, FALSE);
    fSourceFilePath := tbs_Urlextractpath(fSourceFileName, FALSE);
    fSourceFileExtension := extractfileext(fSourceFileName);
  end
  else
  begin
    fSourceFileNameShort := extractfilename(fSourceFileName);
    fSourceFilePath := extractfilepath(fSourceFileName);
    fSourceFileExtension := extractfileext(fSourceFileName);
  end;
end;

procedure TThumb.SetSourceType(const value: TTB_SourceType);
begin
  fSourceType := value;

  if not(fSourceType in (TBGetSourceTypes_FileSystem + [st_FolderNav])) then
    fSearchRec.Size := -1;
end;

procedure TThumb.SetStoreType(const value: TTB_Thumb_StoreType);
begin
  if value = tbStore_Unspecified then
    EXIT;
  if value = fStoreType then
    EXIT;

  fStoreType := value;

  SetAdjournedFalse(fUniqueName);
end;

procedure TThumb.SetTitleDrawFocusRectIfEmpty(const value: boolean);
begin
  FTitleDrawFocusRectIfEmpty := value;
end;

procedure TThumb.SetTitleOpacity(const value: cardinal);
begin
  fTitleOpacity := value;
end;

procedure TThumb.SetTitleRoundnessPerc(const value: cardinal);
begin
  fTitleRoundnessPerc := value;
  RefreshDimensions;
end;

procedure TThumb.SetTitleOpacitySelected(const value: cardinal);
begin
  fTitleOpacitySelected := value;
end;

function TThumb.GetExifDate_ex(aio: TImageenio): TDatetime;
begin
  result := -2;
  // set a invalid date by default in case the picture has not exif data
  if (aio.Params.EXIF_HasEXIFData) then
  begin
    result := aio.Params.EXIF_DateTimeOriginal2;
    if result = 0 then
      result := -2;
  end;

end;

function TThumb.GetIEBitmap: TIEBitmap;
begin
  result := fIEBitmap;
end;

function TThumb.GetIOParams: TIOParams;
var
  aio: TImageenio;
  bRecreateParams: boolean;
begin
  result := fIOParams;
  if (fSourceFileName = '') or (not fileexists(fSourceFileName)) then
    EXIT;
  if fSourceType <> st_File then
    EXIT;

  bRecreateParams := (not assigned(fIOParams)) OR
    (comparetext(fIOParams.Filename, fSourceFileName) <> 0);
  // recreate if not exists or name changed

  if bRecreateParams then
  begin
    aio := TImageenio.Create(nil);
    aio.ParamsFromFile(SourceFileName);
    try

      fIOParams := TIOParams.Create(nil);
      fIOParams.Assign(aio.Params);

    finally
      aio.free;
    end;

  end;

  result := fIOParams;
end;

function TThumb.GetOffScreenHeight: integer;
begin
  if GetIEBitmap = nil then
    result := 100
  else
    result := GetIEBitmap.Height;
end;

function TThumb.GetOffScreenWidth: integer;
begin
  if GetIEBitmap = nil then
    result := 100
  else
    result := GetIEBitmap.Width;
end;

// Class TThumbEx--------------------------------

constructor TThumbEx.Create(theOriginator: TTB_Thumb_Originator;
  OwnerCanvas: Tcanvas; aUserObject: TObject; const bVisible: boolean = true);
begin
  Create(theOriginator, OwnerCanvas, bVisible);

  fUserObject := aUserObject;
end;

constructor TThumbEx.Create(theOriginator: TTB_Thumb_Originator;
  OwnerCanvas: Tcanvas; const bVisible: boolean = true);
begin
  inherited Create;
  assert(OwnerCanvas <> nil, 'Owner Canvas cannot be nil');

  fLastVisibleIdx := -1;
  fOriginator := theOriginator;
  fOwnerCanvas := OwnerCanvas;
  fLayoutElements := TTB_Thumb_LayoutElements.Create;
  fBrowserStyleOptions := nil;
  fLayoutType := ltVertical;
  fCaptionStyle := capSt_RowsCentered;

  fCaptionIncludeInFrame := FALSE;
  fUserObject := nil;
  fOwnUserObject := FALSE;

  fcaptions := TTB_Thumb_Captions.Create;
  fcaptionMissingText := '????';

  fVisible := bVisible;
  fChecked := true;
  fRotateMode := TRmNone;

  fcaptionheight := 0;
  fcaptionwidth := 0;

  ResetFontHeight;
  // important initialize to -1 because we make a test later based on this value

  fcaptionSettings := [cap_ShowFileName, cap_ShowDateTime];

  fEvents_LockCtr := 0;
  fLayout_LockCtr := 0;

  fClickPoint := point(-1, -1);
  fMouseOverOptions := [moFrameBg, moFrameBorder, moCaptionBg, moCaptionText];

  fCaptionRect := rect(0, 0, 0, 0);
  fTotalRect := rect(0, 0, 0, 0);
  fFramedThumbAreaRect := rect(0, 0, 0, 0);
  fThumbAreaRect := rect(0, 0, 0, 0);
  fThumbAreaRestrictedRect := rect(0, 0, 0, 0);

  fShowSettings := [];

  FTopTitle := '';
  FBottomTitle := '';
  fKeywords := '';
  fRating := 0;
end;

destructor TThumbEx.Destroy;
begin

  fcaptions.Clear;
  fcaptions.free;

  fLayoutElements.free;

  if assigned(fMetaEditedFields) then
    freeandnil(fMetaEditedFields);

  if fOwnUserObject then
    DeleteUserObject;

  inherited;
end;

procedure TThumbEx.Assign(Source: TPersistent);
var
  srcthumb: TThumbEx;
begin

  if not(Source is TThumbEx) then
  begin
    inherited;
    EXIT;
  end;

  Layout_Lock;
  try
    inherited Assign(Source);
    srcthumb := TThumbEx(Source);
    AssignEvents(srcthumb);
  finally
    Layout_UnLock;
  end;

end;

procedure TThumbEx.AssignStatus(Source: TPersistent);
var
  srcthumb: TThumbEx;
begin
  inherited;

  if not(Source is TThumbEx) then
    EXIT;

  srcthumb := TThumbEx(Source);

  fVisible := srcthumb.Visible;
  fSelected := srcthumb.Selected;
  fChecked := srcthumb.Checked;
  fRotateMode := srcthumb.RotateMode;
  fShowSettings := srcthumb.ShowSettings;
  fClickPoint := srcthumb.ClickPoint;
end;

procedure TThumbEx.AssignFileLoadingInfo(Source: TPersistent);
var
  srcthumb: TThumbEx;
begin
  inherited;
  if not(Source is TThumbEx) then
    EXIT;

  srcthumb := TThumbEx(Source);
  fcaptions.Assign(srcthumb.Captions, true);
  // assign excluding general captions

  FTopTitle := srcthumb.TopTitle;
  // user should not change this while the browser hasn't loaded the thumb yet
  FBottomTitle := srcthumb.BottomTitle;
  // user should not change this while the browser hasn't loaded the thumb yet
  fKeywords := srcthumb.Keywords;
  // user should not change this while the browser hasn't loaded the thumb yet
  fRating := srcthumb.Rating;
  // user should not change this while the browser hasn't loaded the thumb yet
end;

procedure TThumbEx.AssignInfo(Source: TPersistent; bRefresh: boolean);
var
  srcthumb: TThumbEx;
begin
  inherited;
  if not(Source is TThumbEx) then
    EXIT;

  srcthumb := TThumbEx(Source);

  if fOwnUserObject and (fUserObject <> srcthumb.UserObject) then
    DeleteUserObject;

  fUserObject := nil; // deferenzia prima
  fUserObject := srcthumb.UserObject;

  fcaptions.Assign(srcthumb.Captions);
  fcaptionSettings := srcthumb.CaptionSettings;

  FTopTitle := srcthumb.TopTitle;
  FBottomTitle := srcthumb.BottomTitle;
  fKeywords := srcthumb.Keywords;
  fRating := srcthumb.Rating;

  if bRefresh then
    RefreshDimensions;
end;

procedure TThumbEx.AssignLayout(Source: TPersistent; bRefresh: boolean);
var
  srcthumb: TThumbEx;
begin
  inherited;

  if not(Source is TThumbEx) then
    EXIT;

  srcthumb := TThumbEx(Source);
  fBrowserStyleOptions := srcthumb.BrowserStyleOptions;
  fDropShadowOptions := srcthumb.DropShadowOptions;
  fLayoutType := srcthumb.LayoutType;
  fcaptionMissingText := srcthumb.CaptionMissingText;
  fCaptionFont := srcthumb.CaptionFont;
  fFontHeight := srcthumb.fFontHeight;
  fcaptionheight := srcthumb.fcaptionheight;
  fcaptionwidth := srcthumb.fcaptionwidth;
  fCaptionStyle := srcthumb.CaptionStyle;
  fCaptionIncludeInFrame := srcthumb.CaptionIncludeInFrame;

  fMouseOverOptions := srcthumb.MouseOverOptions;

  if bRefresh then
    RefreshDimensions;
end;

procedure TThumbEx.AssignEvents(srcthumb: TThumbEx);
begin
  fOnVisibleChange := srcthumb.OnVisibleChange;
  fOnSelectedChange := srcthumb.OnSelectedChange;
  fOnCheckedChange := srcthumb.OnCheckedChange;
  fOnRotatedChange := srcthumb.OnRotatedChange;
  fOnCustomDrawPicture := srcthumb.OnCustomDrawPicture;
  fOnCustomDrawFrame := srcthumb.OnCustomDrawFrame;
  fOnCustomDrawThumbBackground := srcthumb.OnCustomDrawThumbBackground;
  fOnCustomDrawCaption := srcthumb.OnCustomDrawCaption;
  fOnCustomDrawBottomTitle := srcthumb.OnCustomDrawBottomTitle;
  fOnCustomDrawTopTitle := srcthumb.OnCustomDrawTopTitle;
  fOnCustomDrawAfterDraw := srcthumb.OnCustomDrawAfterDraw;
  fOnGetCaptionInfo := srcthumb.OnGetCaptionInfo;
  fOnGetCaptionIdx := srcthumb.OnGetCaptionIdx;
  fOnSyncPropertyChanged := srcthumb.OnSyncPropertyChanged;
  fOnBufferLoaded := srcthumb.OnBufferLoaded;
end;

procedure TThumbEx.refitdisplay(const pw, ph: cardinal);
var
  h_restr_top, h_restr_bottom, w_restr, h_restr_otherTop, h_restr_otherBottom,
    w_restr_other, w_restr_all, h_restr_all: integer;
  h, w: cardinal;
  pic_width, pic_height: cardinal;
  tryRect: TRect;
  tryW, tryH: integer;
  maxW, maxH: integer;
  bFitWidth, bFitHeight: boolean;

  infoW, infoH, rotW, rotH, checkW, checkH: integer;

begin
  infoW := fLayoutElements.InfoBox.Width + 2;
  infoH := fLayoutElements.InfoBox.Height + 2;
  rotW := fLayoutElements.RotateButtons_L.Width + 2;
  rotH := fLayoutElements.RotateButtons_L.Height + 2;
  checkW := fLayoutElements.CheckBox.Width + 2;
  checkH := fLayoutElements.CheckBox.Height + 2;

  maxW := TBGetRectWidth(fThumbAreaRect);
  maxH := TBGetRectHeight(fThumbAreaRect);
  pic_width := pw;
  pic_height := ph;

  fThumbAreaRestrictedRect := fThumbAreaRect;

  if (pic_width = 0) or (pic_height = 0) then
    EXIT;

  w_restr := 0;
  w_restr_other := 0;

  w_restr_other := max(w_restr_other,
    2 * ord(th_ShowRotateButtons in fShowSettings) * rotW);
  w_restr_other := max(w_restr_other,
    2 * ord(th_ShowInfoBox in fShowSettings) * infoW);
  w_restr_other := max(w_restr_other, 2 * ord(th_ShowCheckBox in fShowSettings)
    * checkW);

  h_restr_top := 0;
  h_restr_bottom := 0;
  h_restr_otherTop := 0;
  h_restr_otherBottom := 0;

  h_restr_top := h_restr_top + ord(th_ShowTopTitle in fShowSettings) *
    (fLayoutElements.TopTitle.Height + 2);
  h_restr_bottom := h_restr_bottom + ord(th_ShowBottomTitle in fShowSettings) *
    (fLayoutElements.BottomTitle.Height + 2);
  h_restr_bottom := h_restr_bottom + ord(th_ShowRatingBox in fShowSettings) *
    (fLayoutElements.RatingBox.Height + 2);

  h_restr_otherTop := max(h_restr_otherTop,
    ord(th_ShowRotateButtons in fShowSettings) * rotH);
  h_restr_otherBottom := max(h_restr_otherBottom,
    ord(th_ShowInfoBox in fShowSettings) * infoH);
  h_restr_otherBottom := max(h_restr_otherBottom,
    ord(th_ShowCheckBox in fShowSettings) * checkH);
  // h_restr_other := h_restr_other + ord(th_ShowRatingBox in fShowsettings) *(fLayoutElements.RatingBox.Height + 2);

  w_restr_all := max(w_restr, w_restr_other);
  // h_restr_All := max(h_restr_top + h_restr_bottom, h_restr_otherBottom + h_restr_otherTop);
  h_restr_all := max(h_restr_top, h_restr_otherTop) +
    max(h_restr_bottom, h_restr_otherBottom);

  w := min(GetOffScreenWidth, maxW - w_restr_all);
  h := min(GetOffScreenHeight, maxH - h_restr_all);

  tryRect.Left := fThumbAreaRect.Left + w_restr_all div 2;
  tryRect.Right := fThumbAreaRect.Right - w_restr_all div 2;
  tryRect.Top := fThumbAreaRect.Top + max(h_restr_top, h_restr_otherTop);
  tryRect.Bottom := fThumbAreaRect.Bottom - max(h_restr_bottom,
    h_restr_otherBottom);

  bFitWidth := FALSE;
  bFitHeight := FALSE;
  if w / pic_width > h / pic_height then
  begin
    h := TBGetRectHeight(tryRect);
    bFitHeight := true;
  end
  else
  begin
    w := TBGetRectWidth(tryRect);
    bFitWidth := true;
  end;

  // simulate now what happens if we do not apply the other restrictions
  if bFitWidth then
  begin
    if w_restr_other > w_restr then
    // if other restrictions are more stringent then go on to check
    begin
      tryH := round(w * pic_height / pic_width);
      if tryH <= h then
      begin
        tryRect.Left := fThumbAreaRect.Left + w_restr div 2;
        tryRect.Right := fThumbAreaRect.Right - w_restr div 2;
        w := TBGetRectWidth(tryRect);
      end;
    end;
  end
  else
  begin
    if h_restr_otherTop + h_restr_otherBottom > (h_restr_top + h_restr_bottom)
    then // if other restrictions are more stringent then go on to check
    begin
      tryW := round(h * pic_width / pic_height);
      if tryW <= w then
      begin
        tryRect.Top := fThumbAreaRect.Top + h_restr_top;
        tryRect.Bottom := fThumbAreaRect.Bottom - h_restr_bottom;

        h := TBGetRectHeight(tryRect);
      end;
    end;
  end;

  tbFitDisplay(pic_width, pic_height, w, h);

  fDisplayedWidth := pic_width;
  fDisplayedHeight := pic_height;

  fThumbAreaRestrictedRect := tryRect;
end;

procedure TThumbEx.RefreshDimensions;
var
  X, Y: integer;

  starSize: integer;
  mainW, mainH, ratW, ratH, infoW, infoH, checkW, checkH, rotW, rotH: integer;

  roundFramePadding: integer;
  Elsize: TSize;
begin
  if LayoutLocked then
    EXIT;

  if not assigned(fResources) then
    EXIT;

  inherited RefreshDimensions;

  if fFontHeight = -1 then
    fFontHeight := CalcFontHeight;

  fFramedThumbAreaRect := rect(FBackPadding_Left, FBackPadding_Top,
    FBackPadding_Left + fSizeOnScreenW + 2 * fFrameSize + FBackPadding_Right -
    1, FBackPadding_Top + fSizeOnScreenH + 2 * fFrameSize +
    FBackPadding_Bottom - 1);

  roundFramePadding := round(fFrameRoundnessPerc / 628 *
    min((fFramedThumbAreaRect.Right - fFramedThumbAreaRect.Left),
    (fFramedThumbAreaRect.Bottom - fFramedThumbAreaRect.Top)));

  fThumbAreaRect := rect(fFramedThumbAreaRect.Left + fFrameSize +
    roundFramePadding + FFramePadding_Left, fFramedThumbAreaRect.Top +
    fFrameSize + roundFramePadding + FFramePadding_Top,
    fFramedThumbAreaRect.Right - fFrameSize - roundFramePadding -
    FFramePadding_Right, fFramedThumbAreaRect.Bottom - fFrameSize -
    roundFramePadding - FFramePadding_Bottom);

  // ------------------Caption------------------------------------
  if fLayoutType = ltVertical then
  begin
    fcaptionwidth := TBGetRectWidth(fThumbAreaRect);

    if (not assigned(fCaptionFont)) or (not(th_ShowCaption in fShowSettings))
    then
      fcaptionheight := 0
    else
    begin
      if (fCaptionStyle = capSt_RowsCentered) or (fCaptionStyle = capSt_Rows)
      then
        fcaptionheight := round(TBGetCap_Count(fcaptionSettings) * fFontHeight)
      else if (fCaptionStyle = capSt_ColsCentered) or
        (fCaptionStyle = capSt_Cols) then
        fcaptionheight := fFontHeight;
    end;

    if fCaptionIncludeInFrame then
    begin
      fCaptionRect := rect(fThumbAreaRect.Left, fThumbAreaRect.Bottom + 1,
        fThumbAreaRect.Right, fThumbAreaRect.Bottom + fcaptionheight);
    end
    else
      fCaptionRect := rect(fFramedThumbAreaRect.Left,
        fFramedThumbAreaRect.Bottom + 1, fFramedThumbAreaRect.Right,
        fFramedThumbAreaRect.Bottom + fcaptionheight);

  end
  else
  begin

    fcaptionwidth := round(GetCaptionSizePerc_HorzLayout / 100 *
      TBGetRectWidth(fThumbAreaRect));
    fcaptionheight := TBGetRectHeight(fFramedThumbAreaRect);

    if fCaptionIncludeInFrame then
    begin
      fCaptionRect := rect(fThumbAreaRect.Right + 1, fThumbAreaRect.Top,
        fThumbAreaRect.Right + fcaptionwidth, fThumbAreaRect.Bottom);
    end
    else
      fCaptionRect := rect(fFramedThumbAreaRect.Right + 1,
        fFramedThumbAreaRect.Top, fFramedThumbAreaRect.Right + fcaptionwidth,
        fFramedThumbAreaRect.Bottom);
  end;

  if fCaptionIncludeInFrame then
  begin
    if fLayoutType = ltVertical then
    begin
      fFramedThumbAreaRect.Bottom := fFramedThumbAreaRect.Bottom +
        TBGetRectHeight(fCaptionRect);
      // fThumbAreaRect.bottom := fThumbAreaRect.bottom + TBGetRectHeight(fCaptionRect);
    end
    else
    begin
      fFramedThumbAreaRect.Right := fFramedThumbAreaRect.Right +
        TBGetRectWidth(fCaptionRect);
      // fThumbAreaRect.right := fThumbAreaRect.right + TBGetRectWidth(fCaptionRect);
    end;
  end;

  // TOTAL RECT-------------------------------------------------------------
  if fLayoutType = ltVertical then
  begin
    fTotalHeight := TBGetRectHeight(fFramedThumbAreaRect) +
      ord(not fCaptionIncludeInFrame) * TBGetRectHeight(fCaptionRect);
    fTotalWidth := TBGetRectWidth(fFramedThumbAreaRect);
  end
  else
  begin
    fTotalHeight := TBGetRectHeight(fFramedThumbAreaRect);
    fTotalWidth := TBGetRectWidth(fFramedThumbAreaRect) +
      ord(not fCaptionIncludeInFrame) * TBGetRectWidth(fCaptionRect);
  end;

  fTotalRect := rect(0, 0, fTotalWidth - 1, fTotalHeight - 1);

  mainW := TBGetRectWidth(fThumbAreaRect);
  mainH := TBGetRectHeight(fThumbAreaRect);

  // ------------------Check Box -----------------------------------
  if not(th_ShowCheckBox in fShowSettings) then
  begin
    checkW := 0;
    checkH := 0;
  end
  else
  begin
    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_Checkbox in fBrowserStyleOptions.ThemeElements) then
    begin
      Elsize := fBrowserStyleOptions.ThemeElementInfo[thmele_Checkbox].Size;
      checkW := Elsize.cx;
      checkH := Elsize.cy;
    end
    else if assigned(fResources.bmp_Checked) then
    begin
      checkW := fResources.bmp_Checked.Width;
      checkH := fResources.bmp_Checked.Height;
    end
    else
    begin
      checkW := 0;
      checkH := 0;
    end;
  end;

  fLayoutElements.CheckBox.rect := rect(fThumbAreaRect.Left + 1,
    fThumbAreaRect.Bottom - 1 - checkH + 1, fThumbAreaRect.Left + 1 + checkW -
    1, fThumbAreaRect.Bottom - 1);



  // ------------------Info Box------------------------------------

  if not(th_ShowInfoBox in fShowSettings) then
  begin
    infoW := 0;
    infoH := 0;
  end
  else
  begin
    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_InfoBox in fBrowserStyleOptions.ThemeElements) then
    begin
      Elsize := fBrowserStyleOptions.ThemeElementInfo[thmele_InfoBox].Size;
      infoW := Elsize.cx;
      infoH := Elsize.cy;
    end
    else if assigned(fResources.bmp_Info) then
    begin
      infoW := fResources.bmp_Info.Width;
      infoH := fResources.bmp_Info.Height;
    end
    else
    begin
      infoW := 0;
      infoH := 0;
    end;
  end;

  fLayoutElements.InfoBox.rect := rect(fThumbAreaRect.Right - 1 - infoW + 1,
    fThumbAreaRect.Bottom - 1 - infoH + 1, fThumbAreaRect.Right - 1,
    fThumbAreaRect.Bottom - 1);




  // ------------------Rotate buttons------------------------------------

  if not(th_ShowRotateButtons in fShowSettings) then
  begin
    rotW := 0;
    rotH := 0;
  end
  else
  begin
    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_RotateButtons in fBrowserStyleOptions.ThemeElements) then
    begin
      Elsize := fBrowserStyleOptions.ThemeElementInfo
        [thmele_RotateButtons].Size;
      rotW := Elsize.cx;
      rotH := Elsize.cy;
    end
    else if assigned(fResources.bmp_Info) then
    begin
      rotW := fResources.bmp_RotRight_Up.Width;
      rotH := fResources.bmp_RotRight_Up.Height;
    end
    else
    begin
      rotW := 0;
      rotH := 0;
    end;
  end;

  X := fThumbAreaRect.Left;
  Y := fThumbAreaRect.Top;
  fLayoutElements.RotateButtons_R.rect := rect(X, Y, X + rotW - 1,
    Y + rotH - 1);

  X := fThumbAreaRect.Right - rotW + 1;
  Y := fThumbAreaRect.Top;
  fLayoutElements.RotateButtons_L.rect := rect(X, Y, X + rotW - 1,
    Y + rotH - 1);

  // ------------------Titles------------------------------------
  fLayoutElements.TopTitle.rect :=
    rect(fLayoutElements.RotateButtons_R.rect.Right + 2,
    fLayoutElements.RotateButtons_R.rect.Top,
    fLayoutElements.RotateButtons_L.rect.Left - 2,
    fLayoutElements.RotateButtons_R.rect.Top + fFontHeight);

  fLayoutElements.BottomTitle.rect :=
    rect(fLayoutElements.CheckBox.rect.Right + 2, fThumbAreaRect.Bottom -
    fFontHeight, fThumbAreaRect.Right - 2 - (fLayoutElements.InfoBox.rect.Right
    - fLayoutElements.InfoBox.rect.Left), fThumbAreaRect.Bottom);

  // ------------------Rating Box------------------------------------
  starSize := 0;
  if (th_ShowRatingBox in fShowSettings) then
  begin

    if assigned(fResources.bmp_RatingStar) then
    begin
      starSize := min(fResources.bmp_RatingStar.Width,
        fLayoutElements.BottomTitle.Width div 5);
    end
  end;
  ratW := 5 * starSize;
  ratW := min(ratW, mainW - 2 * max(ord(th_ShowInfoBox in fShowSettings) *
    (1 + fLayoutElements.InfoBox.rect.Width),
    ord(th_ShowCheckBox in fShowSettings) *
    (1 + fLayoutElements.CheckBox.rect.Width)));
  ratH := starSize;

  X := fThumbAreaRect.Left + (mainW - ratW) div 2;

  Y := fLayoutElements.BottomTitle.rect.Bottom -
    ord(th_ShowBottomTitle in fShowSettings) *
    fLayoutElements.BottomTitle.rect.Height - ratH;

  fLayoutElements.RatingBox.rect := rect(X, Y, X + ratW - 1, Y + ratH - 1);

  if IsZeroBitmap then
  begin
    fDisplayedWidth := 0;
    fDisplayedHeight := 0;
    fThumbAreaRestrictedRect := fThumbAreaRect;
  end
  else
  begin
    fDisplayedWidth := GetIEBitmap.Width;
    fDisplayedHeight := GetIEBitmap.Height;
    refitdisplay(fDisplayedWidth, fDisplayedHeight);
  end;
end;

procedure TThumbEx.GetBasicIOParamsFromIO(aio: TImageenio);
begin
  inherited;
  if not assigned(fMetaOptions) then
    EXIT;

  Layout_Lock;
  try
    MetaData_SyncRead(mdSyncTopTitle, fMetaOptions.SyncField_TopTitle);
    MetaData_SyncRead(mdSyncBottomTitle, fMetaOptions.SyncField_BottomTitle);
    MetaData_SyncRead(mdSyncRating, fMetaOptions.SyncField_Rating);
    MetaData_SyncRead(mdSyncKeywords, fMetaOptions.SyncField_Keywords);
  finally
    Layout_UnLock;
  end;

end;

procedure TThumbEx.RetrieveFromSourceFile_EX(theFilename: string;
  theExternaFileReader: TTB_Browser_FileReaderFunction;
  theCriticalSection: TCriticalSection; bUseCriticalSection_whenNeeded: boolean;
  var theLoadingIO: TImageenio);
var
  aFormat: TTB_Browser_FileFormat;
  dummyIO: TImageenio;
begin

  TBFileFormat_GetEmptyFormat(aFormat);
  aFormat.Extension := extractfileext(theFilename);
  aFormat.ReaderFunction := theExternaFileReader;

  RetrieveFromSourceFile(theFilename, aFormat, theCriticalSection,
    bUseCriticalSection_whenNeeded, dummyIO);
end;

procedure TThumbEx.RetrieveFromSourceFile_EX(theFilename: string;
  theExternaFileReader: TTB_Browser_FileReaderFunction;
  theCriticalSection: TCriticalSection;
  bUseCriticalSection_whenNeeded: boolean);
var
  dummyIO: TImageenio;
begin

  RetrieveFromSourceFile_EX(theFilename, theExternaFileReader,
    theCriticalSection, bUseCriticalSection_whenNeeded, dummyIO);

end;

{$IFDEF TB_USEDB}

procedure TThumbEx.EditDBRcd(theDBCriticalSection: TCriticalSection;
  theDB: TThumbsBrowser_DB; theSessionGuid: TGUID);
var
  ExistResult: TTB_DB_ThumbExistResult;
begin
  if not theDB.DBActive then
    EXIT; // >>>>EXIT

  if assigned(theDBCriticalSection) then
    theDBCriticalSection.enter;
  try
    ExistResult := ExistsinDB(nil, theDB, theSessionGuid);

    if ExistResult.MatchType = TERcdExists then
    begin
      theDB.ThumbSavetoDB(theSessionGuid, self, dbmEdit, true)
    end;
  finally
    if assigned(theDBCriticalSection) then
      theDBCriticalSection.leave;
  end;

end;
{$ENDIF}
{$IFDEF TB_USEDB}

function TThumbEx.SaveToDB(theDBCriticalSection: TCriticalSection;
  theDB: TThumbsBrowser_DB; theSessionGuid: TGUID; bAllowSavePic: boolean)
  : TTB_DB_ThumbExistResult;
begin
  if (not theDB.DBActive) or (StoreType <> tbstore_Thumb) then
  begin
    result.Index := -1;
    result.MatchedThumb := self;
    result.MatchType := TERcdDoesntExist;
    EXIT; // >>>>EXIT
  end;

  if assigned(theDBCriticalSection) then
    theDBCriticalSection.enter;
  try
    result := ExistsinDB(nil, theDB, theSessionGuid);

    if result.MatchType = TERcdExistsOld then
    begin
      if bAllowSavePic then
        theDB.ThumbSavetoDB(theSessionGuid, self, dbmEdit, FALSE)
      else // else we do not have permission to save the pic but the db tells us we should
        theDB.DeleteRcd(theSessionGuid, fUniqueName);
      // to avoid inconsistencies  we delete the record
    end
    else if result.MatchType = TERcdExistsWithOldParams then
    begin
      theDB.ThumbSavetoDB(theSessionGuid, self, dbmEdit, true);
    end
    else if result.MatchType = TERcdDoesntExist then
    begin
      if bAllowSavePic then
        theDB.ThumbSavetoDB(theSessionGuid, self, dbmInsert, FALSE)
      else // else we do not have permission to save the pic but the db tells us we should
        theDB.DeleteRcd(theSessionGuid, fUniqueName);
      // to avoid inconsistencies  we delete the record
    end;
  finally
    if assigned(theDBCriticalSection) then
      theDBCriticalSection.leave;
  end;

end;
{$ENDIF}

{$IFDEF TB_USEDB}
function TThumbEx.RetrieveFromDB(theDBCriticalSection: TCriticalSection;
  theDB: TThumbsBrowser_DB; theSessionGuid: TGUID;
  const bSeek: boolean): boolean;
begin

  if (not theDB.DBActive) or (StoreType <> tbstore_Thumb) then
  begin
    result := FALSE;
    EXIT; // >>>>EXIT
  end;

  if assigned(theDBCriticalSection) then
    theDBCriticalSection.enter;
  try
    result := theDB.ThumbRetrieveFromDB(theSessionGuid, self, bSeek);
    if result then
      SetAdjournedTrue;
  finally
    if assigned(theDBCriticalSection) then
      theDBCriticalSection.leave;
  end;
end;
{$ENDIF}

{$IFDEF TB_USEDB}
function TThumbEx.ExistsinDB(theDBCriticalSection: TCriticalSection;
  theDB: TThumbsBrowser_DB; theSessionGuid: TGUID): TTB_DB_ThumbExistResult;
begin
  if not theDB.DBActive then
  begin
    result.Index := -1;
    result.MatchedThumb := self;
    result.MatchType := TERcdDoesntExist;
    EXIT; // >>>>EXIT
  end;

  if assigned(theDBCriticalSection) then
    theDBCriticalSection.enter;
  try
    result := theDB.ThumbExistsinDB(theSessionGuid, self, fUniqueName,
      fSizeOffScreen);
  finally
    if assigned(theDBCriticalSection) then
      theDBCriticalSection.leave;
  end;
end;
{$ENDIF}

procedure TThumbEx.RetrieveFromBitmap(theBitmap: Tbitmap);
begin
  inherited;
end;

procedure TThumbEx.RetrieveFromIEBitmap(theIEBitmap: TIEBitmap);
begin
  inherited;
end;

procedure TThumbEx.RetrieveFromStream(st: TStream);
begin
  inherited;
end;

procedure TThumbEx.RetrieveFromUrl(url: string);
begin
  inherited;

end;

procedure TThumbEx.RetrieveFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem);
begin
  inherited;
end;

procedure TThumbEx.RetrieveParamsFromWIA(aWIA: TIEWIA; aWIAItem: TIEWIAItem);
begin
  inherited;

  RefreshCaptions;
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbEx.RetrieveFromWPD(aWPD: TIEPortableDevices;
  const DevID, ObjID: string; const bLoadInfo: boolean;
  CS: TCriticalSection = nil);
begin
  inherited;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbEx.InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
  ObjID: string);
begin
  inherited;
  RefreshCaptions;
end;

procedure TThumbEx.InitFromWPD(aWPD: TIEPortableDevices; const DevID: string;
  aWPDObj: TIEWPDObject);
begin
  inherited;
  RefreshCaptions;
end;
{$ENDIF}

procedure TThumbEx.RefreshCaptions;
begin
  GetCaptions(fcaptions, fcaptionSettings);
end;

procedure TThumbEx.GetCaptions(var sl: TTB_Thumb_Captions;
  theCaptionSettings: TTB_Thumb_CaptionsSettings);
var
  ds, temps: string;
  bIsFile, bIsFolder, bIsNav: boolean;
  bHasFileTimes: boolean;
  I: integer;
  capSetting: TTB_Thumb_CaptionsSetting;
  k: integer;
  capIdx: integer;
  crTime, modTime, AccTime: TDatetime;

  slGeneral: TTB_Thumb_Captions;
begin
  if not assigned(fOnGetCaptionIdx) then EXIT;

  slGeneral := TTB_Thumb_Captions.Create;
  try
    for I := 0 to sl.Count - 1 do
      if TBIsCaptionGeneral(sl[I].CaptionSetting) then
        slGeneral.add(sl[I].Text, sl[I].CaptionSetting);

    sl.Clear;

    bHasFileTimes := FALSE;
    bIsFile := (fSourceType = st_File) or (fSourceType = st_WpdFile) or
      (fSourceType = st_Url) or (fSourceType = st_Wia);
    bIsFolder := (fSourceType = st_Folder) or (fSourceType = st_WpdFolder);
    bIsNav := (fSourceType = st_FolderNav) or (fSourceType = st_WpdFolderNav);

    for k := CAP_LOW_IDX to CAP_HIGH_IDX do
    begin

      fOnGetCaptionIdx(k, capIdx);
      capSetting := TTB_Thumb_CaptionsSetting(capIdx);

      if capSetting in theCaptionSettings then
      begin
        case capSetting of
          cap_ShowFileName:
            begin
              if (bIsFile or bIsFolder) then
                sl.add(SourceFileNameShort, capSetting)
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowFileNameWithoutExtension:
            begin
              if (bIsFile or bIsFolder) then
                sl.add(changefileext(SourceFileNameShort, ''), capSetting)
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowFilePath:
            begin
              if bIsFile or bIsFolder then
                sl.add(fSourceFilePath, capSetting)
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowCreateDate, cap_ShowCreateDateAndTime:
            begin
              if bIsFile then
              begin
                if not bHasFileTimes then
                begin
                  if fSourceFileCreateDate = CONST_DATENULL then
                  begin
                    tbs_GetFileTimes(fSourceFileName, crTime, AccTime, modTime);
                    fSourceFileCreateDate := crTime;
                  end
                  else
                    crTime := fSourceFileCreateDate;

                  bHasFileTimes := true;
                end;
                if capSetting = cap_ShowCreateDate then
                  DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt, crTime)
                else
                  DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt +
                    ' hh:mm', crTime);
                sl.add(ds, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowFileType:
            begin
              if bIsFile then
              begin
                // temps := tbs_GetFileTypeDescription(fSourceFileExtension);
                temps := fSourceFileTypeDescr;
                if (temps <> '') then
                  sl.add(temps, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowDateTime, cap_ShowEditDate, cap_ShowEditDateAndTime:
            begin
              if (bIsFile or bIsFolder) then
              begin
                if capSetting = cap_ShowEditDate then
                  DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt,
                    SourceFileDate)
                else
                  DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt + ' hh:mm',
                    SourceFileDate);
                sl.add(ds, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowFileSize:
            begin
              if bIsFile then
              begin
                if SourceFileSize / sqr(1024) > 1 then
                  sl.add(formatfloat('0.#', SourceFileSize / sqr(1024)) + ' Mb',
                    capSetting)
                else
                  sl.add(formatfloat('0.#', SourceFileSize / 1024) + ' Kb',
                    capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowDimensions:
            begin
              if (not bIsNav) and (not bIsFolder) then
                sl.add(inttostr(SourceFileWidth) + ' X ' +
                  inttostr(SourceFileHeight), capSetting)
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowFileDimensionsAndSize:
            begin
              temps := '';
              if (not bIsNav) and (not bIsFolder) then
                temps := temps + (inttostr(SourceFileWidth) + ' X ' +
                  inttostr(SourceFileHeight));
              if bIsFile then
              begin
                if (temps <> '') then
                  temps := temps + ' | ';
                if SourceFileSize / sqr(1024) > 1 then
                  temps := temps + formatfloat('0.#',
                    SourceFileSize / sqr(1024)) + ' Mb'
                else
                  temps := temps + formatfloat('0.#',
                    SourceFileSize / 1024) + ' Kb';

              end;
              if temps <> '' then
                sl.add(temps, capSetting)
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIFDateTime:
            begin
              if bIsFile then
              begin
                if SourceExifFileDate > 0 then
                begin
                  DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt + ' hh:mm',
                    SourceExifFileDate);
                  sl.add(ds, capSetting);
                end
                else
                begin
                  if not(cap_ShowDateTime in theCaptionSettings) then
                  // if the date is not already displayed we display it instead of the exif date
                  begin
                    DateTimeToString(ds, tbs_FmtSettings_ShortDateFmt +
                      ' hh:mm', SourceFileDate);
                    sl.add(ds, capSetting);
                  end
                  else // otherwise we write unknown exif date
                    sl.add('????/??/?? ??:??', capSetting);
                end;
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPAuthor:
            begin
              if bIsFile then
              begin
                if SourceExif_XPAuthor <> '' then
                  sl.add(SourceExif_XPAuthor, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPTitle:
            begin
              if bIsFile then
              begin
                if SourceExif_XPTitle <> '' then
                  sl.add(SourceExif_XPTitle, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPSubject:
            begin
              if bIsFile then
              begin
                if SourceExif_XPSubject <> '' then
                  sl.add(SourceExif_XPSubject, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPComment:
            begin
              if bIsFile then
              begin
                if SourceExif_XPComments <> '' then
                  sl.add(SourceExif_XPComments, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPKeywords:
            begin
              if bIsFile then
              begin
                if SourceExif_XPKeywords <> '' then
                  sl.add(SourceExif_XPKeywords, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowEXIF_XPRating:
            begin
              if bIsFile then
              begin
                if SourceExif_XPRating > 0 then
                begin
                  temps := '';
                  for I := 1 to SourceExif_XPRating do
                    temps := temps + '*';

                  temps := temps + ' (Windows)';
                  sl.add(temps, capSetting);
                end
                else
                  sl.add('Unrated (Windows)', capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowKeywords:
            begin
              if bIsFile then
              begin
                if fKeywords <> '' then
                  sl.add(fKeywords, capSetting)
                else if fcaptionMissingText <> '' then
                  sl.add(fcaptionMissingText, capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowRating:
            begin
              if bIsFile then
              begin
                if fRating > 0 then
                begin
                  temps := '';
                  for I := 1 to fRating do
                    temps := temps + '*';

                  sl.add(temps, capSetting);
                end
                else
                  sl.add('Unrated', capSetting);
              end
              else
                sl.add(sEmptyCap, capSetting);
            end;
          cap_ShowTopTitle:
            begin
              if FTopTitle = '' then
                sl.add(sEmptyCap, capSetting)
              else
                sl.add(FTopTitle, capSetting);
            end;
          cap_ShowBottomTitle:
            begin
              if FBottomTitle = '' then
                sl.add(sEmptyCap, capSetting)
              else
                sl.add(FBottomTitle, capSetting);
            end;
          cap_ShowCustomMetaData:
            begin

            end;
        end;
      end;
    end;

    if slGeneral.Count > 0 then
    begin
      for I := slGeneral.Count - 1 downto 0 do
      begin
        capSetting := slGeneral[I].CaptionSetting;
        assert(assigned(fOnGetCaptionIdx));

        for k := CAP_LOW_IDX to CAP_HIGH_IDX do
        begin
          fOnGetCaptionIdx(k, capIdx);
          if capIdx = ord(capSetting) then
            break;
        end;
        k := max(0, min(sl.Count, k));
        sl.Insert(k, slGeneral[I].Text, slGeneral[I].CaptionSetting);
      end;
    end;

  finally
    slGeneral.free;
  end;
end;

function TThumbEx.HasConsistentOrientation: boolean;
begin
  result := true;
  if (fSourceFileWidth = 0) or (fSourceFileHeight = 0) or
    (GetOffScreenWidth = 0) or (GetOffScreenHeight = 0) then
    EXIT;

  result := abs(fSourceFileWidth / fSourceFileHeight - GetOffScreenWidth /
    GetOffScreenHeight) < 0.2;
end;

procedure TThumbEx.InitFromSearchRecord(sr: TSearchRec;
  thefolder_slashed: string);
begin
  inherited;
  RefreshCaptions;
end;

function TThumbEx.SatisfiesCondition(condition
  : TTB_Browser_PickCondition): boolean;
begin
  result := FALSE;
  case condition of
    IfSelected:
      result := fSelected;
    IfChecked:
      result := fChecked;
  else
    result := true;
  end;
end;

procedure TThumbEx.PaintToCanvas(cv: Tcanvas; x0, y0: integer;
  bMouseOver: boolean; roughmode: boolean);
  function getResFilter(srcW, srcH: integer; destW, destH: integer)
    : TResampleFilter;
  begin
    if (srcW = destW) and (srcH = destH) then
    begin
      result := rfnone;
    end
    else
    begin
      // result := rfLinear;
      result := rfTriangle;
    end;
  end;

var
  aDrawingBmp: Tbitmap;

  function GetMaxCharString(s: string; maxW: integer): string;
  var
    ext: string;
  begin
    result := s;
    while (aDrawingBmp.Canvas.TextWidth(result) >= maxW - 4) and
      (length(result) > 0) do
    begin
      setlength(result, length(result) - 1);
    end;

    if length(result) = length(s) then
      EXIT;

    ext := extractfileext(s);

    if (ext = '') or (changefileext(extractfilename(s), '') = '') then
    begin
      setlength(result, max(0, length(result) - 2));
      result := result + '..';
    end
    else
    begin
      setlength(result, max(0, length(result) - length(ext) - 1));
      result := result + '..' + ext;
    end;
  end;

  procedure DrawBmp;
  var
    bDropShadow: boolean;
    dropW, dropH, dropX, dropY, dropSize: integer;

  var
    xb, yb: integer;
    w, h: cardinal;
    abmp, rotbmp: TIEBitmap;
    proc: TImageenProc;
    maxW, maxH, mintop, minleft: integer;
    aFilter: TResampleFilter;
    tempIebmp: TIEBitmap;
    tempRect: TRect;
    tempText: string;
    bmpDrop: TIEBitmap;
    ratio: double;
  begin
    dropW := 0;
    dropH := 0;
    dropSize := 0;

    if IsZeroBitmap then
    begin
      if (fSourceType = st_File) or (fSourceType = st_Folder) then
      begin
        tempRect := fThumbAreaRestrictedRect;
        tempText := '';
        if (Adjourned) then
          tempText := 'Not Available'
        else
          tempText := 'Loading..';

        if (tempText <> '') and (aDrawingBmp.Canvas.TextWidth(tempText) <
          TBGetRectWidth(fThumbAreaRect)) then
        begin
          // aDrawingBmp.Canvas.pen.Style := pssolid;
          aDrawingBmp.Canvas.Brush.Style := bsClear;
          aDrawingBmp.Canvas.TextRect(tempRect, tempText,
            [tfSingleline, tfCenter, tfVerticalCenter]);
          aDrawingBmp.Canvas.Brush.Style := bssolid;
        end;

        EXIT; // >>>>EXIT (bitmap is empty - nothing to draw)
      end;
    end;

    // --------------------
    abmp := GetIEBitmap;
    // --------------------

    if fRotateMode <> TRmNone then
    begin
      w := abmp.Height;
      h := abmp.Width;
    end
    else
    begin
      w := abmp.Width;
      h := abmp.Height;
    end;

    refitdisplay(w, h);
    if (w = 0) or (h = 0) then
      EXIT; // >>>>EXIT (bitmap is zero length - nothing to draw)

    maxW := TBGetRectWidth(fThumbAreaRestrictedRect);
    maxH := TBGetRectHeight(fThumbAreaRestrictedRect);
    mintop := fThumbAreaRestrictedRect.Top;
    minleft := fThumbAreaRestrictedRect.Left;

    rotbmp := nil;
    if fRotateMode <> TRmNone then // rotate
    begin
      rotbmp := TIEBitmap.Create;
      proc := TImageenProc.Create(nil);
      try
        try
          rotbmp.Assign(abmp);
          proc.AttachedIEBitmap := rotbmp;
          if fRotateMode = trmleft then
            proc.Rotate(90) // rotate anticlockwise
          else
            proc.Rotate(270); // rotate clockwise

          // -------------------------------------------------------------------------
          abmp := rotbmp;
          // Get the rotated Bmp (this will be destroyed at the end)
          // -------------------------------------------------------------------------
        finally
          proc.free;
        end;
      except
        abmp := GetIEBitmap;
        freeandnil(rotbmp);
      end;
    end;

    if (abmp.Width > fDisplayedWidth) and (abmp.Height > fDisplayedHeight) then
    begin
      w := fDisplayedWidth;
      h := fDisplayedHeight;
    end
    else
    begin
      w := abmp.Width;
      h := abmp.Height;
    end;

    bDropShadow := fDropShadowOptions.Enabled and (not(abmp.HasAlphaChannel))
      and (fSourceType <> st_Folder) and (fSourceType <> st_FolderNav) and
      (fSourceType <> st_WpdFolder) and (fSourceType <> st_WpdFolderNav);
    if bDropShadow then
    begin
      dropSize := 1 + round(fDropShadowOptions.Size * min(w, h) /
        min(fDisplayedWidth, fDisplayedHeight));
      dropW := w;
      dropH := h;
      ratio := w / h;
      if ratio > 1 then
      begin
        w := w - dropSize * 2;
        h := round(w * 1 / ratio);
      end
      else
      begin
        h := h - dropSize * 2;
        w := round(h * ratio);
      end;
    end;

    xb := minleft + (maxW - w) div 2;
    yb := mintop + (maxH - h) div 2;

    if (fSourceType = st_FolderNav) or (fSourceType = st_WpdFolderNav) then
      aFilter := rflinear
    else
    begin
      if roughmode then
        aFilter := rflinear
      else
        aFilter := fDisplayFilter;
    end;

    if abmp.HasAlphaChannel then
    begin
      tempIebmp := TIEBitmap.Create;
      try
        tempIebmp.CopyFromTBitmap(aDrawingBmp);
        tempIebmp.MergeWithAlpha(abmp, xb, yb, w, h, 255, aFilter);
        // to do check compaibility to replace with RenderToCanvasWithAlpha
        tempIebmp.CopyToTBitmap(aDrawingBmp);
      finally
        tempIebmp.free;
      end;
    end
    else
    begin
      if bDropShadow then // drop shadow
      begin
        dropX := xb;
        dropY := yb;

        xb := xb - dropSize div 2;
        yb := yb - dropSize div 2;
        dropX := dropX + dropSize div 2;
        dropY := dropY + dropSize div 2;

        bmpDrop := fResources.GetDropShadow(dropW, dropH, dropSize);
        bmpDrop.RenderToCanvasWithAlpha(aDrawingBmp.Canvas, dropX, dropY, dropW,
          dropH, 0, 0, bmpDrop.Width, bmpDrop.Height, 255);
        abmp.RenderToCanvas(aDrawingBmp.Canvas, xb, yb, w, h, aFilter, 1);
      end
      else
        abmp.RenderToCanvas(aDrawingBmp.Canvas, xb, yb, w, h, aFilter, 1);

    end;

    if assigned(rotbmp) then
    begin
      rotbmp.free;
    end;
  end;

  procedure DrawThumbBackground;
  var
    bUseResBmp: boolean;
    abmp: TIEBitmap;
    op: integer;
  begin
    if fSelected then
    begin
      bUseResBmp := assigned(fResources) and fResources.HAS_ThumbBgSelected;
      abmp := fResources.bmp_ThumbBgSelected;
      op := fBackOpacitySelected;
    end
    else
    begin
      bUseResBmp := assigned(fResources) and fResources.HAS_ThumbBg;
      abmp := fResources.bmp_ThumbBg;
      op := fBackOpacity;
    end;

    if bUseResBmp then
    begin
      RenderIEBmpToCanvas(abmp, aDrawingBmp.Canvas, fTotalRect.Left,
        fTotalRect.Top, TBGetRectWidth(fTotalRect), TBGetRectHeight(fTotalRect),
        op, getResFilter(fResources.bmp_ThumbBg.Width,
        fResources.bmp_ThumbBg.Height, TBGetRectWidth(fTotalRect),
        TBGetRectHeight(fTotalRect)));
    end
    else
    begin

      // else do nothing- normally we do not draw the background of the thumb
    end;
  end;

  procedure DrawFrame;
  var
    xfr1, yfr1, xfr2, yfr2: integer;
    backCol, frameCol: TColor;
    abmp: TIEBitmap;
    bUseResBmp: boolean;
    opBg, opBorder: integer;
  begin
    if fSelected then
    begin
      bUseResBmp := assigned(fResources) and fResources.HAS_ThumbFrameSelected;
      abmp := fResources.bmp_ThumbFrameSelected;
      backCol := fFrameBgSelectedColor;
      frameCol := fFrameBorderSelectedColor;
      opBorder := fFrameBorderOpacitySelected;
      opBg := fFrameBgOpacitySelected;

    end
    else
    begin
      bUseResBmp := assigned(fResources) and fResources.HAS_ThumbFrame;
      abmp := fResources.bmp_ThumbFrame;
      backCol := fFrameBgColor;
      frameCol := fFrameBorderColor;
      opBorder := fFrameBorderOpacity;
      opBg := fFrameBgOpacity;

      if bMouseOver then
      begin
        if moFrameBorder in fMouseOverOptions then
        begin
          opBorder := (fFrameBorderOpacitySelected + fFrameBorderOpacity) div 2;
          frameCol :=
            rgb((getrvalue(fFrameBorderColor) * 20 +
            getrvalue(fFrameBorderSelectedColor) * 80) div 100,
            (getgvalue(fFrameBorderColor) * 20 +
            getgvalue(fFrameBorderSelectedColor) * 80) div 100,
            (getbvalue(fFrameBorderColor) * 20 +
            getbvalue(fFrameBorderSelectedColor) * 80) div 100);
        end;

        if moFrameBg in fMouseOverOptions then
        begin
          opBg := (fFrameBgOpacitySelected + fFrameBgOpacity) div 2;

          backCol :=
            rgb((getrvalue(fFrameBgColor) * 50 +
            getrvalue(fFrameBgSelectedColor) * 50) div 100,
            (getgvalue(fFrameBgColor) * 50 + getgvalue(fFrameBgSelectedColor) *
            50) div 100, (getbvalue(fFrameBgColor) * 50 +
            getbvalue(fFrameBgSelectedColor) * 50) div 100);
        end;
      end;
    end;

    if bUseResBmp then
    begin

      RenderIEBmpToCanvas(abmp, aDrawingBmp.Canvas, fFramedThumbAreaRect.Left,
        fFramedThumbAreaRect.Top, TBGetRectWidth(fFramedThumbAreaRect),
        TBGetRectHeight(fFramedThumbAreaRect), opBg,
        getResFilter(fResources.bmp_ThumbFrameSelected.Width,
        fResources.bmp_ThumbFrameSelected.Height,
        TBGetRectWidth(fFramedThumbAreaRect),
        TBGetRectHeight(fFramedThumbAreaRect)));

    end
    else
    begin
      // RenderFrameToCanvas(aDrawingBmp.canvas, fFramedThumbAreaRect, fFrameRoundnessPerc, true, 0, backcol, framecol, op);

      xfr1 := fFramedThumbAreaRect.Left + fFrameSize div 2;
      yfr1 := fFramedThumbAreaRect.Top + fFrameSize div 2;
      xfr2 := fFramedThumbAreaRect.Right - fFrameSize div 2 + 1 - 1 *
        ord(fFrameSize mod 2 <> 0);
      yfr2 := fFramedThumbAreaRect.Bottom - fFrameSize div 2 + 1 - 1 *
        ord(fFrameSize mod 2 <> 0);
      RenderFrameToCanvas(aDrawingBmp.Canvas, rect(xfr1, yfr1, xfr2, yfr2),
        fFrameRoundnessPerc, opBg, opBorder, fFrameSize, backCol, frameCol);

    end;
  end;

  procedure DrawCaption(theCaption: string; theCaptionColor, theCaptionColorSel,
    theCaptionBackColor, theCaptionBackColorSel: TColor;
    theCaptionStyle, theCaptionStyleSel: TFontstyles;
    theCaptionOpacity, theCaptionOpacitySelected: cardinal);
  var
    I, xtText, xt, yt, ht, wt, wtStd, sW: integer;
    temps: string;
    capTop: integer;
    backCol, foreCol: TColor;
    abmp: TIEBitmap;
    bUseResBmp: boolean;
    op: integer;
    aStyle: TFontstyles;
    capInfo: TTB_Thumb_CaptionInfo;
    caption: TTB_Thumb_Caption;
    capIdx, capRectWidth, capRectHeight, Xpadding: integer;
  begin
    if not(th_ShowCaption in fShowSettings) then
      EXIT;
    if not assigned(fCaptionFont) then
      EXIT;

    capRectWidth := TBGetRectWidth(fCaptionRect);
    capRectHeight := TBGetRectHeight(fCaptionRect);

    if fSelected then
    begin
      bUseResBmp := assigned(fResources) and
        fResources.HAS_ThumbCaptionBgSelected;
      abmp := fResources.bmp_ThumbCaptionBgSelected;
      backCol := theCaptionBackColorSel;
      foreCol := theCaptionColorSel;
      op := theCaptionOpacitySelected;
      aStyle := theCaptionStyleSel;
    end
    else
    begin
      bUseResBmp := assigned(fResources) and fResources.HAS_ThumbCaptionBg;
      abmp := fResources.bmp_ThumbCaptionBg;
      backCol := theCaptionBackColor;
      foreCol := theCaptionColor;
      op := theCaptionOpacity;
      aStyle := theCaptionStyle;

      if bMouseOver then
      begin
        if moCaptionBg in fMouseOverOptions then
        begin
          backCol :=
            rgb((getrvalue(theCaptionBackColor) * 25 +
            getrvalue(theCaptionBackColorSel) * 75) div 100,
            (getgvalue(theCaptionBackColor) * 25 +
            getgvalue(theCaptionBackColorSel) * 75) div 100,
            (getbvalue(theCaptionBackColor) * 25 +
            getbvalue(theCaptionBackColorSel) * 75) div 100);

          op := (theCaptionOpacity + theCaptionOpacitySelected) div 2;
        end;

        if moCaptionText in fMouseOverOptions then
        begin

          foreCol := theCaptionColorSel;
        end;
      end;

    end;

    if bUseResBmp then
    begin

      RenderIEBmpToCanvas(abmp, aDrawingBmp.Canvas, fCaptionRect.Left,
        fCaptionRect.Top, capRectWidth, capRectHeight, op,
        getResFilter(fResources.bmp_ThumbCaptionBgSelected.Width,
        fResources.bmp_ThumbCaptionBgSelected.Height, capRectWidth,
        capRectHeight));

    end
    else
    begin
      RenderFrameToCanvas(aDrawingBmp.Canvas, fCaptionRect,
        fCaptionRoundnessPerc, op, op, 0, backCol, foreCol);
    end;

    if aDrawingBmp.Canvas.Brush.Style <> bsClear then
      aDrawingBmp.Canvas.Brush.Style := bsClear;
    aDrawingBmp.Canvas.Font.Assign(fCaptionFont);

    aDrawingBmp.Canvas.Font.Color := foreCol;
    aDrawingBmp.Canvas.Font.Style := aStyle;
    ht := fFontHeight;
    if assigned(fBrowserStyleOptions) then
      Xpadding := fBrowserStyleOptions.CaptionsOptions.TextPadding
    else
      Xpadding := 4;

    if theCaption = '' then
    // if custom caption text not assigned draw the captions list
    begin
      assert(assigned(fOnGetCaptionIdx));
      assert(assigned(fOnGetCaptionInfo));

      case fCaptionStyle of
        capSt_RowsCentered, capSt_Rows:
          begin
            if fLayoutType = ltHorizontal then
              capTop := max(fCaptionRect.Top,
                fCaptionRect.Top + (capRectHeight - ht * fcaptions.Count) div 2)
            else
              capTop := fCaptionRect.Top;
            yt := capTop;

            for I := CAP_LOW_IDX to CAP_HIGH_IDX do
            begin

              fOnGetCaptionIdx(I, capIdx);

              caption := fcaptions.GetCaptionbySetting(TTB_Thumb_CaptionsSetting(capIdx));

              if assigned(caption)and(caption.CaptionSetting <> cap_Empty)  then
              begin
                if caption.Text <> sEmptyCap then
                begin
                  if (caption.CaptionSetting = cap_ShowFileName) and
                     ((fBrowserStyleOptions.BrowserStyle = tbStyle_DetailsH) or (fBrowserStyleOptions.BrowserStyle = tbStyle_DetailsV))
                  then
                    aDrawingBmp.Canvas.Font.Style := aStyle + [fsbold]
                  else
                    aDrawingBmp.Canvas.Font.Style := aStyle;
                  temps := GetMaxCharString(caption.Text,
                    capRectWidth - Xpadding);
                  if fCaptionStyle = capSt_RowsCentered then
                    xt := fCaptionRect.Left + (capRectWidth - aDrawingBmp.Canvas.TextWidth(temps)) div 2
                  else
                    xt := fCaptionRect.Left + Xpadding;
                  aDrawingBmp.Canvas.TextRect(rect(xt, yt, fCaptionRect.Right,
                    fCaptionRect.Bottom), xt, yt, temps);
                  yt := yt + ht; // inc position of row
                end;
              end;
            end;
          end;
        capSt_ColsCentered, capSt_Cols:
          begin
            if fcaptions.Count > 0 then
            begin
              if fLayoutType = ltHorizontal then
                capTop := max(fCaptionRect.Top, fCaptionRect.Top + capRectHeight
                  - ht) div 2
              else
                capTop := fCaptionRect.Top;
              wtStd := capRectWidth div fcaptions.Count;
              wt := wtStd;
              xt := fCaptionRect.Left;
              yt := capTop;

              for I := CAP_LOW_IDX to CAP_HIGH_IDX do
              begin
                fOnGetCaptionIdx(I, capIdx);

                caption := fcaptions.GetCaptionbySetting(TTB_Thumb_CaptionsSetting(capIdx));

                fOnGetCaptionInfo(TTB_Thumb_CaptionsSetting(capIdx), capInfo);
                wt := max(0, round(capInfo.ColPercWidth * capRectWidth / 100));

                if assigned(caption)and(caption.CaptionSetting <> cap_Empty) and (wt>0) then
                begin
                  temps := GetMaxCharString(caption.Text, wt - Xpadding);
                  sW := aDrawingBmp.Canvas.TextWidth(temps);

                  if fCaptionStyle = capSt_ColsCentered then
                    xtText := fCaptionRect.Left + (capRectWidth - sW) div 2
                  else
                    xtText := xt + Xpadding;
                  aDrawingBmp.Canvas.TextRect(rect(xtText, yt, xtText + sW, yt + sW), xtText, yt, temps);
                end;

                xt := xt + wt; // inc position of column
              end;
            end;
          end;
      end;

    end
    else
    begin // user assigned a custom text
      capTop := max(fCaptionRect.Top, fCaptionRect.Top +
        (fCaptionRect.Bottom - fCaptionRect.Top - ht) div 2);
      yt := capTop;
      temps := GetMaxCharString(theCaption, fCaptionRect.Right -
        fCaptionRect.Left);
      xt := fCaptionRect.Left + (fCaptionRect.Right - fCaptionRect.Left -
        aDrawingBmp.Canvas.TextWidth(temps)) div 2;
      aDrawingBmp.Canvas.TextRect(rect(xt, yt, fCaptionRect.Right,
        fCaptionRect.Bottom), xt, yt, temps);
    end;
  end;

  procedure DrawTitle(theTitleRect: TRect; theTitle: string;
    titleColor, titleColorSel, titleBackColor, titleBackColorSel: TColor;
    titleStyle, titleStyleSel: TFontstyles;
    TitleOpacity, TitleOpacitySelected: cardinal);
  var
    tf: TTextFormat;
    cv: Tcanvas;
    backCol, foreCol: TColor;
    fs: TFontstyles;
    op: integer;
  begin
    if not assigned(fCaptionFont) then
      EXIT;

    cv := aDrawingBmp.Canvas;

    if fSelected then
    begin
      backCol := titleBackColorSel;
      foreCol := titleColorSel;
      fs := titleStyleSel;
      op := TitleOpacitySelected;
    end
    else
    begin
      backCol := titleBackColor;
      foreCol := titleColor;
      fs := titleStyle;
      op := TitleOpacity;
    end;

    if (theTitle = '') and FTitleDrawFocusRectIfEmpty then
    begin
      cv.pen.Color := foreCol;
      cv.pen.Mode := pmCopy;
      cv.pen.Style := psDot;
      cv.Brush.Style := bsClear;
      cv.Rectangle(theTitleRect);
      cv.pen.Mode := pmCopy;
      cv.Brush.Style := bssolid;
      cv.pen.Style := psSolid;
    end
    else
    begin
      RenderFrameToCanvas(aDrawingBmp.Canvas, theTitleRect, fTitleRoundnessPerc,
        op, op, 0, backCol, foreCol);

      if cv.Brush.Style <> bsClear then
        cv.Brush.Style := bsClear;
      cv.Font.Assign(fCaptionFont);
      cv.Font.Style := fs;
      cv.Font.Color := foreCol;

      // Draw title
      tf := [tfCenter];
      theTitle := GetMaxCharString(theTitle, theTitleRect.Right -
        theTitleRect.Left);
      cv.TextRect(theTitleRect, theTitle, tf);
    end;
  end;

  procedure DrawCheck;
  begin
    if not(th_ShowCheckBox in fShowSettings) then
      EXIT;

    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_Checkbox in fBrowserStyleOptions.ThemeElements) then
    begin
      if fChecked then
        NWScompsStyle_DrawThemeElement(nwsStyleEl_CheckBoxChecked,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.CheckBox.rect))
      else
        NWScompsStyle_DrawThemeElement(nwsStyleEl_CheckBoxUnChecked,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.CheckBox.rect));
    end
    else
    begin

      if (not assigned(fResources.bmp_Unchecked)) or
        (not assigned(fResources.bmp_Checked)) then
        EXIT;

      if fChecked then
        RenderIEBmpToCanvas(fResources.bmp_Checked, aDrawingBmp.Canvas,
          fLayoutElements.CheckBox.rect.Left, fLayoutElements.CheckBox.rect.Top,
          fLayoutElements.CheckBox.Width, fLayoutElements.CheckBox.Height, 255,
          getResFilter(fResources.bmp_Checked.Width,
          fResources.bmp_Checked.Height, fLayoutElements.CheckBox.Width,
          fLayoutElements.CheckBox.Height))
      else
        RenderIEBmpToCanvas(fResources.bmp_Unchecked, aDrawingBmp.Canvas,
          fLayoutElements.CheckBox.rect.Left, fLayoutElements.CheckBox.rect.Top,
          fLayoutElements.CheckBox.Width, fLayoutElements.CheckBox.Height, 255,
          getResFilter(fResources.bmp_Unchecked.Width,
          fResources.bmp_Unchecked.Height, fLayoutElements.CheckBox.Width,
          fLayoutElements.CheckBox.Height));
    end;
  end;

  procedure DrawInfoBox;
  begin
    if not(th_ShowInfoBox in fShowSettings) then
      EXIT;

    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_InfoBox in fBrowserStyleOptions.ThemeElements) then
    begin
      NWScompsStyle_DrawThemeElement(nwsStyleEl_InfoButton, aDrawingBmp.Canvas,
        TBGetFR(fLayoutElements.InfoBox.rect));
    end
    else
    begin
      if not assigned(fResources.bmp_Info) then
        EXIT;

      RenderIEBmpToCanvas(fResources.bmp_Info, aDrawingBmp.Canvas,
        fLayoutElements.InfoBox.rect.Left, fLayoutElements.InfoBox.rect.Top,
        fLayoutElements.InfoBox.Width, fLayoutElements.InfoBox.Height, 255,
        getResFilter(fResources.bmp_Info.Width, fResources.bmp_Info.Height,
        fLayoutElements.InfoBox.Width, fLayoutElements.InfoBox.Height));
    end;
  end;

  procedure DrawRotateButtons;
  var
    abmp: TIEBitmap;
  begin
    if not(th_ShowRotateButtons in fShowSettings) then
      EXIT;

    if assigned(fBrowserStyleOptions) and fBrowserStyleOptions.ThemeEnabled and
      (thmele_RotateButtons in fBrowserStyleOptions.ThemeElements) then
    begin
      // right
      if fRotateMode = tRmRight then
        NWScompsStyle_DrawThemeElement(nwsStyleEl_RotateButtonRightDown,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.RotateButtons_R.rect))
      else
        NWScompsStyle_DrawThemeElement(nwsStyleEl_RotateButtonRight,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.RotateButtons_R.rect));
      // left
      if fRotateMode = trmleft then
        NWScompsStyle_DrawThemeElement(nwsStyleEl_RotateButtonLeftDown,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.RotateButtons_L.rect))
      else
        NWScompsStyle_DrawThemeElement(nwsStyleEl_RotateButtonLeft,
          aDrawingBmp.Canvas, TBGetFR(fLayoutElements.RotateButtons_L.rect));

    end
    else
    begin

      if aDrawingBmp.Canvas.Brush.Style <> bssolid then
        aDrawingBmp.Canvas.Brush.Style := bssolid;

      if fRotateMode = tRmRight then
        abmp := fResources.bmp_RotRight_Down
      else
        abmp := fResources.bmp_RotRight_Up;

      RenderIEBmpToCanvas(abmp, aDrawingBmp.Canvas,
        fLayoutElements.RotateButtons_R.rect.Left,
        fLayoutElements.RotateButtons_R.rect.Top,
        fLayoutElements.RotateButtons_R.Width,
        fLayoutElements.RotateButtons_R.Height, 255,
        getResFilter(abmp.Width, abmp.Height,
        fLayoutElements.RotateButtons_R.Width,
        fLayoutElements.RotateButtons_R.Height));

      if fRotateMode = trmleft then
        abmp := fResources.bmp_RotLeft_Down
      else
        abmp := fResources.bmp_RotLeft_Up;

      RenderIEBmpToCanvas(abmp, aDrawingBmp.Canvas,
        fLayoutElements.RotateButtons_L.rect.Left,
        fLayoutElements.RotateButtons_L.rect.Top,
        fLayoutElements.RotateButtons_L.Width,
        fLayoutElements.RotateButtons_L.Height, 255,
        getResFilter(abmp.Width, abmp.Height,
        fLayoutElements.RotateButtons_L.Width,
        fLayoutElements.RotateButtons_L.Height));

    end;
  end;

  procedure DrawRatingBox;
  var
    I: integer;
    starSize: integer;

    bmpStar, bmpStarEmpty: TIEBitmap;
  begin
    if not(th_ShowRatingBox in fShowSettings) then
      EXIT;

    if (not assigned(fResources.bmp_RatingStar)) or
      (not assigned(fResources.bmp_RatingStarEmpty)) then
      EXIT;

    starSize := fLayoutElements.RatingBox.Width div 5;

    if (fRating > 0) and ((fResources.bmp_RatingStar.Width <> starSize) or
      (fResources.bmp_RatingStar.Height <> fLayoutElements.RatingBox.Height))
    then
    begin
      bmpStar := TIEBitmap.Create(fResources.bmp_RatingStar);
      bmpStar.resample(starSize, fLayoutElements.RatingBox.Height,
        getResFilter(bmpStar.Width, bmpStar.Height, starSize,
        fLayoutElements.RatingBox.Height));
    end
    else
      bmpStar := fResources.bmp_RatingStar;

    if (fRating < 5) and ((fResources.bmp_RatingStarEmpty.Width <> starSize) or
      (fResources.bmp_RatingStarEmpty.Height <>
      fLayoutElements.RatingBox.Height)) then
    begin
      bmpStarEmpty := TIEBitmap.Create(fResources.bmp_RatingStarEmpty);
      bmpStarEmpty.resample(starSize, fLayoutElements.RatingBox.Height,
        getResFilter(bmpStarEmpty.Width, bmpStarEmpty.Height, starSize,
        fLayoutElements.RatingBox.Height));
    end
    else
      bmpStarEmpty := fResources.bmp_RatingStarEmpty;

    try
      for I := 1 to fRating do
      begin
        RenderIEBmpToCanvas(bmpStar, aDrawingBmp.Canvas,
          fLayoutElements.RatingBox.rect.Left + (I - 1) * starSize,
          fLayoutElements.RatingBox.rect.Top, starSize,
          fLayoutElements.RatingBox.Height, 255, rfnone);
      end;

      for I := fRating + 1 to 5 do
      begin
        RenderIEBmpToCanvas(bmpStarEmpty, aDrawingBmp.Canvas,
          fLayoutElements.RatingBox.rect.Left + (I - 1) * starSize,
          fLayoutElements.RatingBox.rect.Top, starSize,
          fLayoutElements.RatingBox.Height, 255, rfnone);
      end;
    finally
      if bmpStar <> fResources.bmp_RatingStar then
        bmpStar.free;

      if bmpStarEmpty <> fResources.bmp_RatingStarEmpty then
        bmpStarEmpty.free;

    end;
  end;

var
  fdrawingHandled: boolean;
  aText: string;
  aTextColor, aTextColorSel: TColor;
  aTextBackColor, aTextBackColorSel: TColor;
  aTextOpacity, aTextOpacitySelected: cardinal;
  aTextStyle, aTextStyleSel: TFontstyles;
begin
  if not assigned(cv) then
    EXIT;

  aDrawingBmp := Tbitmap.Create;
  try
    aDrawingBmp.PixelFormat := pf24bit;
    aDrawingBmp.Canvas.Brush.Color := fFrameBgColor;
    aDrawingBmp.Width := fTotalWidth;
    aDrawingBmp.Height := fTotalHeight;
    aDrawingBmp.Canvas.CopyRect(TBGetFR(fTotalRect), cv,
      TBGetFR(rect(x0, y0, x0 + fTotalRect.Right - fTotalRect.Left,
      y0 + fTotalRect.Bottom - fTotalRect.Top)));
    // Draw the background
    fdrawingHandled := FALSE;
    if assigned(fOnCustomDrawThumbBackground) then
      fOnCustomDrawThumbBackground(self, aDrawingBmp.Canvas, fTotalRect,
        fdrawingHandled);
    if not fdrawingHandled then
      DrawThumbBackground;

    // Draw the frame
    fdrawingHandled := FALSE;
    if assigned(fOnCustomDrawFrame) then
      fOnCustomDrawFrame(self, aDrawingBmp.Canvas, fFramedThumbAreaRect,
        fdrawingHandled);
    if not fdrawingHandled then
      DrawFrame;

    // Draw the picture thumbnail
    fdrawingHandled := FALSE;
    if assigned(fOnCustomDrawPicture) then
      fOnCustomDrawPicture(self, aDrawingBmp.Canvas, fThumbAreaRect,
        fdrawingHandled);
    if not fdrawingHandled then
      DrawBmp;

    // Draw the check box
    DrawCheck;

    // Draw the Caption
    if (fSourceType <> st_FolderNav) and (fSourceType <> st_WpdFolderNav) then
    begin
      fdrawingHandled := FALSE;
      if assigned(fOnCustomDrawCaption) then
      begin
        aText := '';
        aTextColor := fCaptionFontColor;
        aTextColorSel := fCaptionFontSelectedColor;
        aTextBackColor := fCaptionBackColor;
        aTextBackColorSel := fCaptionBackSelectedColor;
        aTextStyle := [];
        aTextStyleSel := [];
        aTextOpacity := fCaptionOpacity;
        aTextOpacitySelected := fCaptionOpacitySelected;

        fOnCustomDrawCaption(self, aDrawingBmp.Canvas, fCaptionRect, aText,
          aTextColor, aTextColorSel, aTextBackColor, aTextBackColorSel,
          aTextStyle, aTextStyleSel, aTextOpacity, aTextOpacitySelected,
          fdrawingHandled);

      end;
      if not fdrawingHandled then
        DrawCaption(aText, aTextColor, aTextColorSel, aTextBackColor,
          aTextBackColorSel, aTextStyle, aTextStyleSel, aTextOpacity,
          aTextOpacitySelected);
    end;

    // Draw the rotate buttons
    DrawRotateButtons;

    // Draw the Info button
    DrawInfoBox;

    // Draw the top title
    if th_ShowTopTitle in fShowSettings then
    begin
      aText := FTopTitle;
      aTextColor := fTopTitleFontColor;
      aTextColorSel := fTopTitleSelectedFontColor;
      aTextBackColor := fTopTitleBackColor;
      aTextBackColorSel := fTopTitleBackSelectedColor;
      aTextStyle := [];
      aTextStyleSel := [];
      aTextOpacity := fTitleOpacity;
      aTextOpacitySelected := fTitleOpacitySelected;
      fdrawingHandled := FALSE;
      if assigned(fOnCustomDrawTopTitle) then
        fOnCustomDrawTopTitle(self, aDrawingBmp.Canvas,
          fLayoutElements.TopTitle.rect, aText, aTextColor, aTextColorSel,
          aTextBackColor, aTextBackColorSel, aTextStyle, aTextStyleSel,
          aTextOpacity, aTextOpacitySelected, fdrawingHandled);
      if not fdrawingHandled then
        DrawTitle(fLayoutElements.TopTitle.rect, aText, aTextColor,
          aTextColorSel, aTextBackColor, aTextBackColorSel, aTextStyle,
          aTextStyleSel, aTextOpacity, aTextOpacitySelected);
    end;

    if th_ShowBottomTitle in fShowSettings then
    begin
      aText := FBottomTitle;
      aTextColor := fBottomTitleFontColor;
      aTextColorSel := fBottomTitleSelectedFontColor;
      aTextBackColor := fBottomTitleBackColor;
      aTextBackColorSel := fBottomTitleBackSelectedColor;
      aTextStyle := [];
      aTextStyleSel := [];
      aTextOpacity := fTitleOpacity;
      aTextOpacitySelected := fTitleOpacitySelected;
      fdrawingHandled := FALSE;
      if assigned(fOnCustomDrawBottomTitle) then
        fOnCustomDrawBottomTitle(self, aDrawingBmp.Canvas,
          fLayoutElements.BottomTitle.rect, aText, aTextColor, aTextColorSel,
          aTextBackColor, aTextBackColorSel, aTextStyle, aTextStyleSel,
          aTextOpacity, aTextOpacitySelected, fdrawingHandled);
      if not fdrawingHandled then
        DrawTitle(fLayoutElements.BottomTitle.rect, aText, aTextColor,
          aTextColorSel, aTextBackColor, aTextBackColorSel, aTextStyle,
          aTextStyleSel, aTextOpacity, aTextOpacitySelected);
    end;

    DrawRatingBox;

    // Custom After Draw
    fdrawingHandled := FALSE;
    if assigned(fOnCustomDrawAfterDraw) then
      fOnCustomDrawAfterDraw(self, aDrawingBmp.Canvas, fTotalRect,
        fdrawingHandled);

    cv.Draw(x0, y0, aDrawingBmp);

    aDrawingBmp.FreeImage;
    // important releases resources to avoid out of resources problem
  finally
    if assigned(aDrawingBmp) then
      freeandnil(aDrawingBmp);
  end;

end;

function TThumbEx.GetMouseHitResult(X, Y: integer): TTB_Thumb_HitRectResult;
begin
  result := HitOutside;

  if TBIsPointInRect(point(X, Y), fTotalRect) then
    result := HitInsideGeneral;

  if (th_ShowTopTitle in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fLayoutElements.TopTitle.rect)) then
  begin
    result := HitTopTitle;
  end
  else if (th_ShowBottomTitle in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fLayoutElements.BottomTitle.rect)) then
  begin
    result := HitBottomTitle;
  end
  else if (th_ShowRatingBox in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fLayoutElements.RatingBox.rect)) then
  begin
    result := HitRatingBox;
  end
  else if (th_ShowCaption in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fCaptionRect)) then
  begin
    result := HitCaption;
  end
  else if (th_ShowCheckBox in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fLayoutElements.CheckBox.rect)) then
  begin
    result := HitCheck;
  end
  else if (th_ShowInfoBox in fShowSettings) and
    (TBIsPointInRect(point(X, Y), fLayoutElements.InfoBox.rect)) then
  begin
    result := HitInfoBox;
  end
  else if (th_ShowRotateButtons in fShowSettings) then
  begin
    if TBIsPointInRect(point(X, Y), fLayoutElements.RotateButtons_R.rect) then
    begin
      result := HitRotateButtonRight;
    end
    else if TBIsPointInRect(point(X, Y), fLayoutElements.RotateButtons_L.rect)
    then
    begin
      result := HitRotateButtonLeft;
    end;
  end
  else if (TBIsPointInRect(point(X, Y), fThumbAreaRestrictedRect)) then
  begin
    result := HitPicture;
  end
end;

function TThumbEx.HandleMouseUp(Button: TmouseButton; Shift: TShiftState;
  X, Y: integer; var HitResult: TTB_Thumb_HitRectResult)
  : TTB_Thumb_MouseUpResult;
begin
  result := mupOutside;
  HitResult := HitOutside;

  if Button = mbright then
    EXIT;

  HitResult := GetMouseHitResult(X, Y);

  if HitResult <> HitOutside then
    result := mupInside;
end;

procedure TThumbEx.DoFinishLoading(loaded: boolean;
  const bCanSaveToDb: boolean);
begin
  inherited;

  if loaded then
  begin
    RefreshCaptions;
    if assigned(fOnPictureLoaded) then
      fOnPictureLoaded(self);
  end;
end;

function TThumbEx.GetRect(HitPoint: TTB_Thumb_HitRectResult): TRect;
begin

  case HitPoint of
    HitOutside:
      result := rect(-1, -1, -1, -1);
    HitInsideGeneral:
      result := fTotalRect;
    HitCheck:
      result := fLayoutElements.CheckBox.rect;
    HitRotateButtonLeft:
      result := fLayoutElements.RotateButtons_L.rect;
    HitRotateButtonRight:
      result := fLayoutElements.RotateButtons_R.rect;
    HitInfoBox:
      result := fLayoutElements.InfoBox.rect;
    HitCaption:
      result := fCaptionRect;
    HitTopTitle:
      result := fLayoutElements.TopTitle.rect;
    HitBottomTitle:
      result := fLayoutElements.BottomTitle.rect;
    HitRatingBox:
      result := fLayoutElements.RatingBox.rect;
    HitPicture:
      result := fThumbAreaRestrictedRect;
    HitThumbArea:
      result := fThumbAreaRect;
  else
    result := rect(-1, -1, -1, -1);
  end;
end;

Function TThumbEx.GetOnVisibleChange: TnotifyEvent;
begin
  result := fOnVisibleChange;
end;

Function TThumbEx.GetOnSelectedChange: TnotifyEvent;
begin
  result := fOnSelectedChange;
end;

function TThumbEx.GetHintText: string;

var
  I: integer;
  newline: string;
  sType, sFileName: string;
  sCaptions: TTB_Thumb_Captions;
  settings: TTB_Thumb_CaptionsSettings;
  procedure AddLine(s: String);
  begin
    if s <> '' then
      result := result + '  ' + s + '  ' + newline;
  end;

begin
  newline := #13#10;
  result := '';

  case SourceType of
    st_General:
      sType := '';
    st_File:
      begin
        sType := '[' + (fSourceFileTypeDescr) + ']'; // uppercase
      end;
    st_WpdFile:
      begin
        sType := '[' + (tbs_GetFileTypeDescription(fSourceFileExtension)) + ']';
      end;
    st_Folder, st_WpdFolder:
      sType := '[FOLDER]';
    st_FolderNav:
      sType := '';
    st_Wia:
      sType := '[WIA ITEM]';
    st_Url:
      sType := '[URL]';
  end;

  sFileName := SourceFileNameShort;

  AddLine(sType);
  AddLine(sFileName);

  sCaptions := TTB_Thumb_Captions.Create;
  try
    settings := fcaptionSettings;
    settings := settings - [cap_ShowFileName] + [cap_ShowFilePath];
    GetCaptions(sCaptions, settings);
    for I := 0 to sCaptions.Count - 1 do
      AddLine(sCaptions[I].Text);
  finally
    sCaptions.free;
  end;

end;

Function TThumbEx.GetOnCheckedChange: TnotifyEvent;
begin
  result := fOnCheckedChange;
end;

Function TThumbEx.GetOnRotatedChange: TnotifyEvent;
begin
  result := fOnRotatedChange;
end;

Function TThumbEx.GetOnPictureLoaded: TnotifyEvent;
begin
  result := fOnPictureLoaded;
end;

procedure TThumbEx.SetOnVisibleChange(value: TnotifyEvent);
begin
  fOnVisibleChange := value;
end;

procedure TThumbEx.SetOnSelectedChange(value: TnotifyEvent);
begin
  fOnSelectedChange := value;
end;

procedure TThumbEx.SetOnCheckedChange(value: TnotifyEvent);
begin
  fOnCheckedChange := value;
end;

procedure TThumbEx.SetOnRotatedChange(value: TnotifyEvent);
begin
  fOnRotatedChange := value;
end;

procedure TThumbEx.SetOnPictureLoaded(value: TnotifyEvent);
begin
  fOnPictureLoaded := value;
end;

procedure TThumbEx.SetOnCustomDrawPicture(value: TTB_Thumb_OnCustomDraw);
begin
  fOnCustomDrawPicture := value;
end;

procedure TThumbEx.SetOnCustomDrawThumbBackground
  (const value: TTB_Thumb_OnCustomDraw);
begin
  fOnCustomDrawThumbBackground := value;
end;

procedure TThumbEx.SetOnCustomDrawFrame(value: TTB_Thumb_OnCustomDraw);
begin
  fOnCustomDrawFrame := value;
end;

procedure TThumbEx.SetOnCustomDrawAfterDraw(const value
  : TTB_Thumb_OnCustomDraw);
begin
  fOnCustomDrawAfterDraw := value;
end;

procedure TThumbEx.SetOnCustomDrawBottomTitle(const value
  : TTB_Thumb_OnCustomDrawText);
begin
  fOnCustomDrawBottomTitle := value;
end;

procedure TThumbEx.SetOnCustomDrawTopTitle(const value
  : TTB_Thumb_OnCustomDrawText);
begin
  fOnCustomDrawTopTitle := value;
end;

procedure TThumbEx.SetOnCustomDrawCaption(value: TTB_Thumb_OnCustomDrawText);
begin
  fOnCustomDrawCaption := value;
end;

procedure TThumbEx.SetShowSettings(thesettings: TTB_Thumb_ShowSettings);
begin
  fShowSettings := thesettings;
  RefreshDimensions;
end;

procedure TThumbEx.SetSourceType(const value: TTB_SourceType);
begin
  inherited;
  case fSourceType of
    st_General:
      ;
    st_File:
      ;
    st_Folder, st_FolderNav, st_WpdFolder, st_WpdFolderNav:
      fShowSettings := fShowSettings - [th_ShowRotateButtons];
    st_Wia:
      ;
  end;
end;

procedure TThumbEx.SetBottomTitle(const value: string);
begin
  FBottomTitle := value;
  RefreshDimensions;

  if (not EventsLocked) and assigned(fOnSyncPropertyChanged) then
    fOnSyncPropertyChanged(self, mdSyncBottomTitle);
end;

procedure TThumbEx.SetTopTitle(const value: string);
begin
  FTopTitle := value;
  RefreshDimensions;

  if (not EventsLocked) and assigned(fOnSyncPropertyChanged) then
    fOnSyncPropertyChanged(self, mdSyncTopTitle);
end;

procedure TThumbEx.SetUserObject(const value: TObject);
begin
  if value = fUserObject then
    EXIT;

  if fOwnUserObject then
    DeleteUserObject;

  fUserObject := value;

end;

procedure TThumbEx.DeleteUserObject;
begin
  if (fUserObject <> nil) then
  begin
    try
      freeandnil(fUserObject);
    except
      fUserObject := nil;
    end;
  end;
end;

procedure TThumbEx.SetCaption(value: string);
var
  I: integer;
begin
  for I := fcaptions.Count - 1 downto 0 do
  begin
    if fcaptions[I].CaptionSetting = cap_General then
      fcaptions.Delete(I);
  end;

  fcaptions.add(value, cap_General);
end;

function TThumbEx.GetCaption: string;
var
  I: integer;
begin
  result := '';
  for I := 0 to fcaptions.Count - 1 do
  begin
    if fcaptions[I].CaptionSetting = cap_General then
    begin
      if result <> '' then
        result := result + #13#10;

      result := result + fcaptions[I].Text;
    end;
  end;
end;
{
  ExtractStrings
}

procedure TThumbEx.SetCaptionFont(thefont: tFont);
var
  bResetFontHeight: boolean;
begin
  bResetFontHeight := (thefont = nil) OR (fCaptionFont = nil) OR
    (thefont.name <> fCaptionFont.name) OR (thefont.Size <> fCaptionFont.Size)
    OR (thefont.Style <> fCaptionFont.Style);
  if bResetFontHeight then
    ResetFontHeight;

  fCaptionFont := thefont;

  RefreshDimensions;
end;

procedure TThumbEx.SetCaptionIncludeInFrame(const value: boolean);
begin
  fCaptionIncludeInFrame := value;
  RefreshDimensions;
end;

procedure TThumbEx.setcaptionMissingText(const value: string);
begin
  fcaptionMissingText := value;
  RefreshCaptions;
end;

procedure TThumbEx.ResetFontHeight;
begin
  fFontHeight := -1;
end;

function TThumbEx.CalcFontHeight: integer;
var
  tempbmp: Tbitmap;
begin
  result := -1;

  if fCaptionFont = nil then
    EXIT;

  tempbmp := Tbitmap.Create;
  try
    tempbmp.PixelFormat := pf24bit;
    tempbmp.Canvas.Font := fCaptionFont;
    result := tempbmp.Canvas.textheight('Tg') + 2;
    tempbmp.FreeImage;
  finally
    tempbmp.free;
  end;

end;

procedure TThumbEx.SetCaptionSettings(value: TTB_Thumb_CaptionsSettings);
begin
  fcaptionSettings := value;
  RefreshCaptions;
  RefreshDimensions;
end;

function TThumbEx.GetCaptionSizePerc_HorzLayout: cardinal;
begin
  if assigned(fBrowserStyleOptions) then
    result := fBrowserStyleOptions.CaptionsOptions.SizePerc_HorzLayout
  else
    result := 150;

end;

procedure TThumbEx.SetCaptionStyle(const value: TTB_Thumb_CaptionStyle);
begin
  fCaptionStyle := value;
  RefreshDimensions;
end;

procedure TThumbEx.SetLayoutType(theLayoutType: TTB_Thumb_Layout_Type);
begin
  fLayoutType := theLayoutType;
  RefreshDimensions;
end;

(*
  procedure TThumbEx.SetRotateButtonsStyle(thestyle: TTB_Browser_Options_RotateButtonsStyle);
  begin
  fRotateButtonsStyle := thestyle;
  RefreshDimensions;
  end;
*)

procedure TThumbEx.Layout_Lock;
begin
  inc(fLayout_LockCtr);
end;

procedure TThumbEx.Layout_UnLock;
begin
  dec(fLayout_LockCtr);
  if not LayoutLocked then
    RefreshDimensions;
end;

function TThumbEx.EnsureMetaData_Write: boolean;
begin
  if (fMetaTags = nil) or (GetIOParams = nil) then
  begin
    result := FALSE;
    EXIT;
  end;

  if not assigned(fMetaEditedFields) then
    fMetaEditedFields := TThumbsbrowser_MetaData_FieldsList.Create(fMetaTags,
      GetIOParams);

  result := true;
end;

function TThumbEx.EnsureMetaData_Read: boolean;
begin
  if (fMetaTags = nil) or (GetIOParams = nil) then
  begin
    result := FALSE;
    EXIT;
  end;

  result := true;
end;

procedure TThumbEx.MetaData_Read(var theField: TThumbsbrowser_MetaData_Field);
begin
  if theField = nil then
    EXIT;
  if not EnsureMetaData_Read then
    EXIT;

  theField.value := TBMetaDataReadFieldAsStr(fIOParams, theField.FieldType,
    theField.Idx, fMetaTags);

end;

procedure TThumbEx.MetaData_Write(theField: TThumbsbrowser_MetaData_Field;
  const bInjectToFile: boolean);
begin
  if theField = nil then
    EXIT;
  if not EnsureMetaData_Write then
    EXIT;

  fMetaEditedFields.AddField(theField);
  if bInjectToFile then
    MetaData_SaveChangesToFile;

end;

procedure TThumbEx.MetaData_SaveChangesToFile;
begin
  if not EnsureMetaData_Write then
    EXIT;
  TBMetadataInjectToFile(fSourceFileName, fSourceHasExif, fSourceHasIPTC,
    fMetaEditedFields);
  fMetaEditedFields.Clear;
end;

procedure TThumbEx.MetaData_SyncRead(const syncType
  : TThumbsbrowser_MetaData_SyncType; const syncTagStr: string);
var
  syncField: TThumbsbrowser_MetaData_Field;
begin
  if not EnsureMetaData_Read then
    EXIT;
  if fMetaOptions.GetAutoSyncOption(syncType) = mdSyncOpNone then
    EXIT; // not permitted to read

  syncField := TThumbsbrowser_MetaData_Field.Create(syncTagStr, fMetaTags,
    mdft_Common, '', mdum_Replace);
  if syncField.Idx = -1 then
  begin
    syncField.free;
    EXIT;
  end;
  Events_Lock; // important to avoid recursion when setting the property value
  Layout_Lock;
  try
    MetaData_Read(syncField);
    if syncField.value <> '' then
    begin
      case syncType of
        mdSyncTopTitle:
          begin
            TopTitle := syncField.value;
          end;
        mdSyncBottomTitle:
          begin
            BottomTitle := syncField.value;
          end;
        mdSyncRating:
          begin
            Rating := strtoint(syncField.value);
          end;
        mdSyncKeywords:
          begin
            Keywords := syncField.value;
          end;
      end;
    end;
  finally
    Layout_UnLock;
    Events_UnLock;
    syncField.free;
  end;

end;

procedure TThumbEx.MetaData_SyncWrite(const syncType
  : TThumbsbrowser_MetaData_SyncType; const syncTagStr: string);
var
  syncField: TThumbsbrowser_MetaData_Field;
begin
  if not EnsureMetaData_Write then
    EXIT;
  if fMetaOptions.GetAutoSyncOption(syncType) <> mdSyncOp_ReadWrite then
    EXIT; // not permitted to write

  syncField := TThumbsbrowser_MetaData_Field.Create(syncTagStr, fMetaTags,
    mdft_Common, '', mdum_Replace);
  if syncField.Idx = -1 then
  begin
    syncField.free;
    EXIT;
  end;

  try

    case syncType of
      mdSyncTopTitle:
        begin
          syncField.value := FTopTitle;
        end;
      mdSyncBottomTitle:
        begin
          syncField.value := FBottomTitle;
        end;
      mdSyncRating:
        begin
          syncField.value := inttostr(fRating);
        end;
      mdSyncKeywords:
        begin
          syncField.value := fKeywords;
        end;
    end;

    MetaData_Write(syncField, true);
  finally

    syncField.free;
  end;

end;

function TThumbEx.LayoutLocked: boolean;
begin
  result := fLayout_LockCtr > 0;
end;

procedure TThumbEx.Events_Lock;
begin
  inc(fEvents_LockCtr);
end;

procedure TThumbEx.Events_UnLock;
begin
  dec(fEvents_LockCtr);
end;

function TThumbEx.EventsLocked: boolean;
begin
  result := fEvents_LockCtr > 0;
end;

procedure TThumbEx.ForceRefreshDimensions;
begin
  RefreshDimensions;
end;

procedure TThumbEx.SetVisible(thevisible: boolean);
begin
  fVisible := thevisible;
  if (not EventsLocked) and assigned(fOnVisibleChange) then
    fOnVisibleChange(self);
end;

procedure TThumbEx.SetSelected(theselected: boolean);
begin
  fSelected := theselected;
  if (not EventsLocked) and assigned(fOnSelectedChange) then
    fOnSelectedChange(self);
end;

procedure TThumbEx.SetChecked(thechecked: boolean);
begin
  fChecked := thechecked;
  if (not EventsLocked) and assigned(fOnCheckedChange) then
    fOnCheckedChange(self);
end;

procedure TThumbEx.SetKeywords(const value: string);
begin
  fKeywords := value;

  if (not EventsLocked) and assigned(fOnSyncPropertyChanged) then
    fOnSyncPropertyChanged(self, mdSyncKeywords);
end;

procedure TThumbEx.SetRating(const value: integer);
begin
  fRating := value;

  if (not EventsLocked) and assigned(fOnSyncPropertyChanged) then
    fOnSyncPropertyChanged(self, mdSyncRating)
end;

procedure TThumbEx.SetRotated(value: TTB_Thumb_RotationMode);
begin
  if fRotateMode = value then EXIT;

  fRotateMode := value;

  if (not EventsLocked) and assigned(fOnRotatedChange) then
    fOnRotatedChange(self);

end;

end.
