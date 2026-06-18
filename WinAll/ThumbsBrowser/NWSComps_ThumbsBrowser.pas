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
unit NWSComps_ThumbsBrowser;

interface

{$R-}
{$Q-}
{$J+}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
{$IFDEF IMAGEEN_5_0_LATER}
{$DEFINE TB_FOLDERMONITOR}
{$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER}
{$DEFINE TB_MULTIBITMAP}
{$ENDIF}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, stdctrls, extctrls, // filectrl,
  contnrs, comctrls, syncobjs, math,
  hyieutils, hyiedefs,
{$IFDEF TB_NATIVEDRAGDROP_TOIMAGEEN}
  imageenview, iemview,
{$ENDIF}
  imageenio, imageenproc, ieWIA, NWSComps_WIA,
{$IFDEF IMAGEEN_5_0_LATER}
  iexWindowsFunctions,
{$ENDIF}
{$IFDEF IMAGEEN_6_2_LATER}
  iexBitmaps,
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}
  iexWPD,
{$ENDIF}
  NWSComps_StyleEngine,
  NWSComps_ThumbsBrowser_const, NWSComps_ThumbsBrowser_Shell_Utils,
  NWSComps_ThumbsBrowser_Thumbs, NWSComps_ThumbsBrowser_Utils_Types,
  NWSComps_ThumbsBrowser_sorting_utils,
  NWSComps_ThumbsBrowser_Info,
  NWSComps_ThumbsBrowser_ScanFilesThread,
  NWSComps_ThumbsBrowser_LoadPicThread,
  NWSComps_Types,

  NWSComps_ThumbsBrowser_Database_Utils,
  NWSComps_ThumbsBrowser_DB;

CONST
  TIMEDEVENT_UPDATEVCLSTYLE = 0;

CONST
  TIMEDEVENT_REPAINT = 1;

CONST
  TIMEDEVENT_AFTERRESIZE = 2;

CONST
  RESETTIMEDEVENT = -12345678;

type
{$IFDEF TB_FOLDERMONITOR}
  TThumbsBrowserFolderMonitorEvent = procedure(theItems: TThumbsBrowser_FolderMonitor_Items; var bHandled: boolean)
    of object;
{$ENDIF}
  TThumbsBrowserDeafultFolder = (tbdfNone, tbdfDesktop, tbdfDrives, tbdfRootDir, tbdfMyDocuments, tbdfMyPictures,
    tbdfMyVideos, tbdfSpecified);

  TThumbsBrowserOnThumbBufferLoaded = procedure(theThumb: TThumbEx; const bufWidth, bufHeight: integer;
    var bResizeBuffer: boolean; var newbufWidth, newbufHeight: integer) of object;

  TThumbsBrowserMouseOverOption = (mooShowMouseOverEffect, mooAllowChangeRating, mooShowInfoBox);
  TThumbsBrowserMouseOverOptions = set of TThumbsBrowserMouseOverOption;

  TThumbsBrowserOnThumbMouseOverEvent = procedure(theThumb: TThumbEx; const Idx: integer;
    var options: TThumbsBrowserMouseOverOptions) of object;
  TThumbsBrowserOnThumbCancelEvent = procedure(theThumb: TThumbEx; var bCancel: boolean) of object;
  TThumbsBrowserOnThumbEvent = procedure(theThumb: TThumbEx; const Idx: integer) of object;

  TThumbsBrowserOnThumbClickedEvent = procedure(ClickedThumb: TThumbEx; const Idx: integer) of object;
  TThumbsBrowserOnThumbClickedEXEvent = procedure(ClickedThumb: TThumbEx; const Idx: integer;
    ThumbClick_x, ThumbClick_y: integer; HitRect: TTB_Thumb_HitRectResult) of object;

  TThumbsBrowserOnSearchCompare = procedure(theThumb: TThumbEx; Idx: integer; var compareresult: boolean) of object;
  TThumbsBrowserOnSortCompare = procedure(theThumb1, theThumb2: TThumbEx; var sortResult: integer) of object;

  TTB_Browser_OnItemHintText = procedure(theThumb: TThumbEx; Idx: integer; var HintText: string) of object;
  TTB_Browser_OnItemCustomDraw = procedure(theThumb: TThumbEx; Idx: integer; cv: Tcanvas; cv_rect: Trect;
    var Handled: boolean) of object;
  TTB_Browser_OnItemCustomDrawText = procedure(theThumb: TThumbEx; Idx: integer; cv: Tcanvas; cv_rect: Trect;
    var theText: string; var theTextColor: TColor; var theTextSelectedColor: TColor; var theTextBackColor: TColor;
    var theTextBackSelectedColor: TColor; var theTextStyle: TFontStyles; var theTextStyle_Selected: TFontStyles;
    var theTextOpacity: cardinal; var theTextOpacitySel: cardinal; var Handled: boolean) of object;

  TThumbsBrowser_ThumbVisibilityAction = (va_Reshow, va_ReshowNavMemory, va_ReshowFilter, va_ReshowUser,
    va_HideUnknownReason, va_HideNavMemory, va_HideFilter, va_HideUser);

  TThumbsBrowser_ThumbVisibilityType = (vtyp_NavMemory, vtyp_Filter, vtyp_User);
  TThumbsBrowser_ThumbVisibilityTypes = set of TThumbsBrowser_ThumbVisibilityType;

  TThumbsBrowser_ThumbVisibilityTransaction = (vtr_NothingToDo, vtr_NavMemoryHide, vtr_FilterHide, vtr_UserHide,
    vtr_NavMemoryShow, vtr_FilterShow, vtr_UserShow);
  TThumbsBrowser_ThumbVisibilityTransactions = set of TThumbsBrowser_ThumbVisibilityTransaction;

  TThumbsBrowser_NavMemoryOnFullAction = (NmOnFull_Clear, NmOnFull_ExpandMemory, NmOnFull_DoNothing);

  TThumbsBrowser_ViewPoint = record

    TOP: integer;
    SELECTED: integer;

  end;

  TThumbsBrowser_ScrollParams = record

    Display_PageSize: integer;
    Display_SmallChange: integer;
    Display_LargeChange: integer;
    Display_Maxlimited: integer;
    Display_Max, Display_Min: integer;
    Display_Pos: integer;

    PageSize: integer;
    SmallChange: integer;
    LargeChange: integer;
    Pos: integer;
  end;

  TThumbsScrollbar = class(TScrollBar)
  private
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TThumbsBrowser_DropBehavior = (ddb_Files, ddb_Thumbs);
  TThumbsBrowser_DragDropTransferMode = (dd_Copy, dd_Move, dd_DetectShiftState);
  TThumbsBrowser_DragDropAcceptEvent = procedure(sender: TObject; var bAccept: boolean;
    var mode: TThumbsBrowser_DragDropTransferMode) of object;
  TThumbsBrowser_ExplorerDragDropEvent = procedure(sender: TObject; Source: TObject; X, Y: integer; files: TStrings;
    var bHandled: boolean; var mode: TThumbsBrowser_DragDropTransferMode) of object;
  TThumbsBrowser_NativeDragDropEvent = procedure(sender: TObject; Source: TObject; X, Y: integer; var bHandled: boolean;
    var mode: TThumbsBrowser_DragDropTransferMode) of object;

  TThumbsBrowser_DragDropOptions = class(TPersistent)
  private
    FIS_DragSource_Explorer: boolean;
    FIS_DragSource_TB: boolean;
    FTransferMode_TB: TThumbsBrowser_DragDropTransferMode;
    FIS_DropTarget_Explorer: boolean;
    FIS_DropTarget_TB: boolean;
    FTransferMode_Exp: TThumbsBrowser_DragDropTransferMode;
    FOnPropertyChanged: TNotifyEvent;

    fRegisteredTargets: TList;
    fDropBehavior: TThumbsBrowser_DropBehavior;

    procedure SetIS_DropTarget_Explorer(const Value: boolean);

  public

    property OnPropertyChanged: TNotifyEvent read FOnPropertyChanged write FOnPropertyChanged;

    function IsDDSource: boolean;
    procedure RegisterTarget(theCtrl: TControl);
    procedure UnRegisterTarget(theCtrl: TControl);
    function IsRegistered(theCtrl: TControl): boolean;
    constructor Create(theChangeEventHandler: TNotifyEvent); reintroduce;
    destructor Destroy; override;
  published
    property IS_DragSource_TB: boolean read FIS_DragSource_TB write FIS_DragSource_TB;
    property IS_DropTarget_TB: boolean read FIS_DropTarget_TB write FIS_DropTarget_TB;
    property IS_DragSource_Explorer: boolean read FIS_DragSource_Explorer write FIS_DragSource_Explorer;
    property IS_DropTarget_Explorer: boolean read FIS_DropTarget_Explorer write SetIS_DropTarget_Explorer;
    property TransferMode_TB: TThumbsBrowser_DragDropTransferMode read FTransferMode_TB write FTransferMode_TB;
    property TransferMode_Exp: TThumbsBrowser_DragDropTransferMode read FTransferMode_Exp write FTransferMode_Exp;

    property DropBehavior: TThumbsBrowser_DropBehavior read fDropBehavior write fDropBehavior;
  end;

  TTBThumbsList = class(TNamedList)
  private

  public
    function Add(AKey: String; Item: Pointer): integer; reintroduce; overload;
    function Add(Item: Pointer): integer; reintroduce; overload;
    procedure Insert(Index: integer; Item: Pointer); reintroduce; overload;
    function IndexOf(Item: Pointer): integer; reintroduce; overload;
  end;

  TTBVisibleThumbsList = class(TList)
  private

  public
    function Add(Item: Pointer): integer; reintroduce;
    procedure Insert(Index: integer; Item: Pointer); reintroduce;
    function IndexOf(Item: Pointer): integer; reintroduce;
  end;

  TThumbsLoader = class;
  TThumbsBrowser = class;

  TThumbsBrowser_DragDropHandler = class(TComponent)
  private

    fDragFiles: TIEFileDragDrop;
    // fExternalDragDropThread: TTBDragDropThread;
    fDynTransferMode_TB, fDynTransferMode_Exp: TThumbsBrowser_DragDropTransferMode;
    fDragSource: TThumbsBrowser;
    fDragSource_Point: TPoint;
    fDropTarget: TThumbsBrowser;
    fDropTarget_Point: TPoint;
    fTimer: TTimer;

    fDraggingActive: boolean;
    fDragScrollInterval: cardinal;

    procedure StartExternalDragDrop;
    function FindDropControl(theMousePt: TPoint): TWinControl;
    function FindDropTarget(theMousePt: TPoint): TThumbsBrowser;
{$IFDEF TB_NATIVEDRAGDROP_TOIMAGEEN}
    function TryDropToIE(aCtrl: TWinControl): boolean;
{$ENDIF}
    function CheckDragDropAllowed(theCtrl: TWinControl): boolean;
    function TryDropToCtrl(aCtrl: TWinControl): boolean;
    procedure ResetDragDropParams;

  public

    InsertPt: TPoint;
    Insertidx: integer;
    PreviousInsertPt: TPoint;
    PreviousInsertIdx: integer;

    property DragSource: TThumbsBrowser read fDragSource;
    property DropTarget: TThumbsBrowser read fDropTarget;

    property DragScrollInterval: cardinal read fDragScrollInterval write fDragScrollInterval;
    property DraggingActive: boolean read fDraggingActive write fDraggingActive;

    function GetDynTransferModeTB(bShift: boolean): TThumbsBrowser_DragDropTransferMode;
    function GetDynTransferModeExp(bShift: boolean): TThumbsBrowser_DragDropTransferMode;

    procedure HandleTimer(sender: TObject);

    procedure CheckCursor(destTB: TThumbsBrowser; X, Y: integer; var bAllowed: boolean);

    procedure NotifyStartDragRequest(tb: TThumbsBrowser; srcPoint: TPoint);
    procedure NotifyDragOverRequest(tb: TThumbsBrowser; overPoint: TPoint);

    procedure DoDragDrop(shift: TShiftState; droppoint: TPoint); overload;
    procedure DoDragDrop(shift: TShiftState); overload;

    procedure StopDragDrop;

    Constructor Create; reintroduce;
    Destructor Destroy; override;
  end;

  TThumbsBrowser = class(TNWSCompsStyledControl)
  private
    { Private declarations }
    fUpdScrollertk: integer;
    fRecalcDisplay: boolean;

    fLastViewPoint: TThumbsBrowser_ViewPoint;
    fDropFiles: TIEFileDragDrop;

    fFileScannerCriticalSection: TCriticalSection;
    fBrowseFoldersRecursiveCriticalSection: TCriticalSection;
    fBrowseFoldersProgress_CriticalSection: TCriticalSection;

    fDragDropOptions: TThumbsBrowser_DragDropOptions;

    fBrowseFoldersRecursionThreads: array of TThumbsBrowser_BrowseFoldersRecursiveThread;

    fBrowseFoldersProgress_Button: TButton;
    fBrowseFoldersProgress_Panel: TPanel;
    fBrowseFoldersProgress_Display: TPanel;

    fMultithread: boolean;
    fMultithread_Pool_Count: integer;
    fMultithread_Timeout: dword;

    fFileThumbs: boolean;
    fFolderThumbs: boolean;
    fFolderNavigation: boolean;
    fFolderCheckBoxes: boolean;
    fFolderTitles: boolean;
    fNavMemory: boolean;

    fScanner: TThumbsBrowser_ScanFilesThread;

{$IFDEF TB_PORTABLEDEVICE}
    fBrowser_WPD: TIEPortableDevices;
    fBrowser_WPD_Items: TStringList;
    fWPDNavHistory: TStringList;
{$ENDIF}
    fWpdStartTk: integer;
    fAbortWPD: boolean;
    fAbortWia: boolean;
    fBrowser_WIA_IO: TImageenio;
    fBrowser_WIA: TNWSComps_WIA;
    fBrowser_WIA_DeviceIdx: integer;
    fBrowser_WIA_Items: TList;

    fAllowCustomformat_ExternalReader: boolean;
    fUserFileFormats_Read: array of TTB_Browser_FileFormat;

    fsort_updated: boolean;
    ffilter_updated: boolean;
    fInfoForm_Status: TThumbsbrowser_InfoForm_Status;
    fThumbsbrowser_InfoForm: TThumbsbrowser_InfoForm;
    fBrowserOrientation: TTB_Browser_Orientation;

    fMaxRows: integer;
    fMaxCols: integer;

    fFolderRecursionList: TStringList;

    fBrowsedPaths: TStringList;
    fReBrowsingExistingPaths: boolean;

    fSampleThumb, fBackupLayoutThumb: TThumbEx;

    fOnExplorerDragDrop: TThumbsBrowser_ExplorerDragDropEvent;
    fOnNativeDragDrop: TThumbsBrowser_NativeDragDropEvent;

    fOnAcceptExplorerDragDrop: TThumbsBrowser_DragDropAcceptEvent;
    fOnAcceptNativeDragDrop: TThumbsBrowser_DragDropAcceptEvent;

    fOnItemHintText: TTB_Browser_OnItemHintText;
    fOnItemCustomDrawPicture: TTB_Browser_OnItemCustomDraw;
    fOnItemCustomDrawFrame: TTB_Browser_OnItemCustomDraw;
    fOnItemCustomDrawCaption: TTB_Browser_OnItemCustomDrawText;
    fOnItemCustomDrawThumbBg: TTB_Browser_OnItemCustomDraw;
    fOnItemCustomDrawTopTitle: TTB_Browser_OnItemCustomDrawText;
    fOnItemCustomDrawBottomTitle: TTB_Browser_OnItemCustomDrawText;
    fOnItemCustomDrawAfterDraw: TTB_Browser_OnItemCustomDraw;
    // fOnDragRequest: Tnotifyevent;

    fOnWIAProgress: TTB_Browser_ProgressEvent;
    fOnWPDProgress: TTB_Browser_ProgressEvent;

    fOnStartedLoading: TNotifyEvent;
    fOnfinishedLoading: TNotifyEvent;
    fOnNavigateFolder: TTB_Browser_OnNavigateFolderEvent;
    fOnNavigateWPDFolder: TTB_Browser_OnNavigateWPDFolderEvent;
    fOnInitialized: TTB_Browser_OnInitializedEvent;
    fOnAllThumbsLoaded: TNotifyEvent;
    fOnThumbClicked, fOnThumbCheckClicked, fOnThumbRatingClicked, fOnThumbInfoClicked, fOnThumbCaptionClicked,
      fOnThumbRotateClicked, fOnThumbTopTitleClicked, fOnThumbBottomTitleClicked: TThumbsBrowserOnThumbClickedEvent;

    fOnThumbClickedEX: TThumbsBrowserOnThumbClickedEXEvent;

    fOnThumbCanAdd: TThumbsBrowserOnThumbCancelEvent;
    fOnThumbAdded: TThumbsBrowserOnThumbEvent;

    fOnThumbLayoutAssigned: TThumbsBrowserOnThumbEvent;
    fOnThumbLoaded: TThumbsBrowserOnThumbEvent;
    fOnThumbCheckSpecialCase: TThumbsBrowserOnThumbEvent;
    fOnThumbCanDelete: TThumbsBrowserOnThumbCancelEvent;
    fOnThumbDelete: TThumbsBrowserOnThumbEvent;

    fOnSearchCompare: TThumbsBrowserOnSearchCompare;
    fOnCustomSortCompare: TThumbsBrowserOnSortCompare;

    frotatedThumbs: TList;
    fSelectedThumbs: TList;
    fCheckedThumbs: TList;
    fThumbs: TTBThumbsList;
    fVisibleThumbs: TTBVisibleThumbsList; // DO NOT CHANGE THE TYPE OF THIS LIST

    fNavigatorThumb: TThumbEx;

    fMouseHoverThumb: TThumbEx;
    fMouseHoverThIdx: integer;

    fHiddenThumbs_Filter: TList;
    fHiddenThumbs_NavMem: TNamedList;
    fHiddenThumbs_User: TList;

    fLastShiftClickedID_s, fLastShiftClickedID_e: integer;
    fShiftFlag, fCTRLFlag: boolean;
    fdoubleclickFlag: boolean;
    fMouseDownFlag: boolean;
    fResizingHeader, fMovingHeader: boolean;
    fMouseMoveHeaderColInfo: array [ord(low(TTB_Thumb_CaptionsSetting)) .. ord(high(TTB_Thumb_CaptionsSetting))
      ] of TTB_Thumb_CaptionInfo;
    fHeaderCurColIdx, fHeaderOldCurCol: integer;
    fHeaderResizedColIdx, fHeaderSelectedColIdx: integer;

    fMouseDownPoint: TPoint;

    fSelectedIndex: integer;
    // fLastSelectedThumb: TthumbEx;
    fLastClickedThumb: TThumbEx;

    fFolderDefault: TThumbsBrowserDeafultFolder;
    fFolderCurrent: string;

    fThumbDefaultChecked: boolean;

    fDynamicMarginX: integer;
    fDynamicMarginY: integer;

    fBrowserRectNoBorders: Trect;
    fReportHeaderMargin: integer;

    fDisplayMarginTop: integer;
    fDisplayMarginBottom: integer;
    fDisplayMarginLeft: integer;
    fDisplayMarginRight: integer;

    fBrowserOwnMarginTop: integer;
    fBrowserOwnMarginBottom: integer;
    fBrowserOwnMarginLeft: integer;
    fBrowserOwnMarginRight: integer;

    fScrollParams: TThumbsBrowser_ScrollParams;

    fCentered: boolean;
    fNRows, fNColumns: cardinal;
    fNRows_float, fNColumns_float: double;
    fTopRow, fBottomRow: integer;
    fTopColumn, fBottomColumn: integer;
    fTopDisplayedThumbIdx, fBottomDisplayedThumbIdx: integer;

    fpassox, fpassoy: integer;

    fScroller: TThumbsScrollbar;
    fScrollerBox: TPanel;
    fScrollUpdateTimer: TTimer;
    fScrollUpdateTimerValue: double;
    fScrollUpdateTimerSender: TObject;

    fLoader: TThumbsLoader;
    fLoaderDBSessionGuid: TGuid;

    fDisplayBackBuffer: tbitmap;
    fBrowser_width, fBrowser_height: integer;
    fFilter: string;
    fFilterExclude: string;
    fPopupDefaultExplorer: boolean;
    fShowCaptions: boolean;
    fShowCheckBoxes: boolean;
    fShowRotateButtons: boolean;
    fShowInfoButton: boolean;
    fShowTopTitle: boolean;
    fShowBottomTitle: boolean;
    fShowRatingBox: boolean;

    fShowThumbnailHint: boolean;

    fHintThumbIdx: integer;
    fMemAppHintHidePause: integer;
    fMemAppHintShortPause, fMemAppHintPause: integer;

    fMultiSelect: boolean;

    fSortType: TTB_Browser_SortType;

    fBackgroundColor: TColor;

    fStyleOptions: TTB_Browser_StyleOptions;

    fLayoutResources: TTB_GraphicResources;

    // fVCLStyleTimer: TTImer;
    fVCLStyleLocked: integer;
    fUpdateLocked: integer;
    fPaintLocked: integer;
    fLoadingLocked: integer;
    fLayoutLocked: integer;
    fStyleLocked: integer;
    fVisTransOpened_FilterShow: integer;
    fVisTransOpened_NavMemoryShow: integer;
    fVisTransOpened_UserShow: integer;

    fVisTransOpened_FilterHide: integer;
    fVisTransOpened_NavMemoryHide: integer;
    fVisTransOpened_UserHide: integer;

    FInfoFormOpened: boolean;
    FInfoFormEmbeddingPanel: TCustomPanel;

    FBrowsingRecursively: boolean;
    FFileScanner_MaxTransfer: integer;
    fOnThumbMouseOver: TThumbsBrowserOnThumbMouseOverEvent;
    fOnThumbSelectionChange: TThumbsBrowserOnThumbEvent;

    fOnThumbCanSelect: TThumbsBrowserOnThumbCancelEvent;
    fOnThumbCanDeSelect: TThumbsBrowserOnThumbCancelEvent;

    fOnThumbCheckStateChange: TThumbsBrowserOnThumbEvent;
    fOnThumbVisibilityChange: TThumbsBrowserOnThumbEvent;
    fspacingX: cardinal;
    fspacingY: cardinal;
    fInternetOptions: TTB_Browser_InternetParams;
    fNRowsByPage: integer;
    fNColumnsByPage: integer;
    fNRowsByPagef: double;
    fNColumnsByPagef: double;
    fMetaTags: TThumbsbrowser_MetaTags;
    fMetaData_Options: TThumbsbrowser_MetaData_Options;
    fFilter_AllowMultiExt: boolean;
    fFileOptions: TThumbsbrowser_FileDisplay_Options;
    fOnInfoFormClosed: TNotifyEvent;
    fOnInfoFormOpened: TNotifyEvent;
    fNavMemMaxThumbs: cardinal;
    fOnMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent;
    fOnThumbBufferLoaded: TThumbsBrowserOnThumbBufferLoaded;

    fThumbCaption_Info: array [ord(low(TTB_Thumb_CaptionsSetting)) .. ord(high(TTB_Thumb_CaptionsSetting))
      ] of TTB_Thumb_CaptionInfo;
    fCursor: TCursor;
    fOnCaptionsOrderChanged: TNotifyEvent;
    fBackgroundType: TTB_Browser_BackgroundType;
    fBackground2ndColor: TColor;
    fThumbDropShadow: TTB_Thumb_DropShadowOptions;

    fLastEventStarted: array [TIMEDEVENT_UPDATEVCLSTYLE .. TIMEDEVENT_AFTERRESIZE] of integer;
    fLanguage: TNWSCompsLanguage;
    fFolderUpNavThumb: boolean;
    fShowDesignTestThumbs: boolean;
    fOnProgress: TIEProgressEvent;
    fLastLoadingType: TThumbsbrowser_LoadingType;

{$IFDEF TB_FOLDERMONITOR}
    FFolderMonitor_SuspendedList: TThreadObjectList;
    FFolderMonitor_GlobalSuspendedTime: integer;
    FFolderMonitor_GlobalStartSuspend: cardinal;
    FFolderMonitor_GlobalSuspendedActions: TWatchActions;
    FFolderMonitor_Locked: integer;
    FFolderMonitor_Active: boolean;
    FFolderMonitor_Actions: TWatchActions;
    FFolderMonitor_Options: TWatchOptions;
    fFolderMonitor_List: TThumbsBrowser_FolderMonitor_Items;
    fFolderMonitor_Timer: TTimer;
    FFolderMonitor_TimerInterval: cardinal;
    fOnFolderMonitorEvent: TThumbsBrowserFolderMonitorEvent;
{$ENDIF}
{$IFDEF TB_USEDB}
    fDB: TThumbsBrowser_DB;
{$ENDIF}
    fHeaderCaptionForSorting: TTB_Thumb_CaptionsSetting;
    fHeaderCaptionSortingDirection: TCompType;

    FcompareAsc, FcompareDesc: TCompFunction;
    FcompareHeaderMethodAsc, FcompareHeaderMethodDesc, FcompareCustomMethodAsc, FcompareCustomMethodDesc: TCompMethod;
    FCompType: TCompType;
    fOnThumbLoadDemand: TThumbsBrowserOnThumbEvent;
    fOnThumbLoadDemandAsync: TThumbsBrowser_Thumb_LoadThread_Event;

    procedure Handle_BrowserStyleOptionsChange(sender: TObject);

    function Handle_ScanFiles_ProgressEvent(filelist: TThumbsBrowser_ScanFilesThread_FileRcds;
      bTerminated: boolean): boolean;
    procedure Handle_Scanfiles_CheckFileExt_InFilter(var bInFilter: boolean; fname, fext: string);

    procedure Handle_FoldersRecursionSyncCheckDone(sender: TObject);
    procedure Handle_FoldersRecursionDone(sender: TObject; bAborted: boolean; theFolder: string;
      theFolderList, thePaths: TStringList);
    procedure Handle_FoldersRecursionProgress(sender: TObject; theFolder: string);
    procedure Handle_AbortClick(sender: TObject);

    procedure HandleExplorerDrop(sender: TObject; ssFiles: TStrings; dwEffect: integer);
    procedure HandleDragDropOptionsChanged(sender: TObject);

    procedure Init_Resources;
    procedure Finalize_Resources;

    procedure Init_WIA;
    procedure Finalize_WIA;

{$IFDEF TB_PORTABLEDEVICE}
    procedure Init_WPD;
    procedure Finalize_WPD;
{$ENDIF}
    procedure Init_Scroller;

    procedure Init_DB;
    procedure Finalize_DB;

    procedure Init_Loader;

    procedure Init_Objects;
    procedure Finalize_Objects;

    procedure Init_Settings;

    procedure ReassignThumbsLayout(bAffectStyle: boolean; bRefreshCaptions: boolean);

    function Detect_DragDrop_Insertpoint(X, Y: integer): integer;
    procedure SetScrollerOrientation;

    procedure NotifyChangeThumbVisibility(sender: TObject);
    procedure NotifyChangeThumbSelected(sender: TObject);
    procedure NotifyChangeThumbChecked(sender: TObject);
    procedure NotifyChangeThumbRotated(sender: TObject);

    procedure NotifyDrawThumbPicture(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);
    procedure NotifyDrawThumbFrame(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);

    procedure NotifyDrawThumbCaption(sender: TObject; cv: Tcanvas; cv_rect: Trect; var theCaptionText: string;
      var theCaptionColor, theCaptionSelectedColor: TColor;
      var theCaptionBackColor, theCaptionBackSelectedColor: TColor;
      var theCaptionStyle, theCaptionStyle_Selected: TFontStyles;
      var theCaptionOpacity, theCaptionOpacitySelected: cardinal; var Handled: boolean);

    procedure NotifyDrawThumbTopTitle(sender: TObject; cv: Tcanvas; cv_rect: Trect; var TitleText: string;
      var TitleColor, TitleSelectedColor: TColor; var TitleBackColor, TitleBackSelectedColor: TColor;
      var TitleStyle, TitleStyle_Selected: TFontStyles; var TitleOpacity, TitleOpacitySelected: cardinal;
      var Handled: boolean);

    procedure NotifyDrawThumbBottomTitle(sender: TObject; cv: Tcanvas; cv_rect: Trect; var TitleText: string;
      var TitleColor, TitleSelectedColor: TColor; var TitleBackColor, TitleBackSelectedColor: TColor;
      var TitleStyle, TitleStyle_Selected: TFontStyles; var TitleOpacity, TitleOpacitySelected: cardinal;
      var Handled: boolean);

    procedure NotifyDrawAfterDraw(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);

    procedure SetAllowCustomformat_ExternalReader(Value: boolean);
    function SetScrollPosition(sender: TObject; oldvalue, newValue: double; const FlagTimer: boolean = false): boolean;

    function GetMultithread: boolean;
    procedure SetMultithread(theValue: boolean);
    function GetMultithread_Pool_Count: integer;
    procedure SetMultithread_Pool_Count(theValue: integer);

    procedure SetMultiThread_Timeout(theValue: dword);

    function GetDragScrollInterval: cardinal;
    procedure SetDragScrollInterval(Value: cardinal);

    procedure SetbrowserOrientation(Value: TTB_Browser_Orientation);
    procedure SetFilter(const Value: string);
    procedure SetFilterExclude(const Value: string);

    procedure SetThumbCaption_Settings(Value: TTB_Thumb_CaptionsSettings);
    procedure SetThumbLayoutType(Value: TTB_Thumb_Layout_Type);

    procedure SetShowCaptions(Value: boolean);
    procedure SetShowCheckBoxes(Value: boolean);
    procedure SetShowRotateButtons(Value: boolean);
    procedure SetShowInfoButton(Value: boolean);
    procedure SetShowBottomTitle(const Value: boolean);
    procedure SetShowTopTitle(const Value: boolean);

    procedure SetMultiSelect(Value: boolean);
    procedure SetThumbsFrameBorderColor(Value: TColor);
    procedure SetThumbsFrameBorderSelectedColor(Value: TColor);
    procedure SetThumbsFrameBgColor(Value: TColor);
    procedure SetThumbsFrameBgSelectedColor(Value: TColor);

    procedure SetThumbsCaptionFontColor(Value: TColor);
    procedure SetThumbsCaptionFontSelectedColor(Value: TColor);
    procedure SetThumbsCaptionBackColor(Value: TColor);
    procedure SetThumbsCaptionBackSelectedColor(Value: TColor);

    procedure SetThumbsBottomTitleBackColor(const Value: TColor);
    procedure SetThumbsBottomTitleBackSelectedColor(const Value: TColor);
    procedure SetThumbsBottomTitleFontColor(const Value: TColor);
    procedure SetThumbsBottomTitleFontSelectedColor(const Value: TColor);
    procedure SetThumbsTopTitleBackColor(const Value: TColor);
    procedure SetThumbsTopTitleBackSelectedColor(const Value: TColor);
    procedure SetThumbsTopTitleFontColor(const Value: TColor);
    procedure SetThumbsTopTitleFontSelectedColor(const Value: TColor);

    procedure SetThumbsBackOpacity(const Value: cardinal);
    procedure SetThumbsBackOpacitySelected(const Value: cardinal);
    procedure SetThumbsCaptionOpacity(const Value: cardinal);
    procedure SetThumbsCaptionOpacitySelected(const Value: cardinal);
    procedure SetThumbsFrameBgOpacity(const Value: cardinal);

    procedure SetThumbsFrameBorderOpacity(const Value: cardinal);
    procedure SetThumbsFrameBorderOpacitySelected(const Value: cardinal);
    procedure SetThumbsTitleOpacity(const Value: cardinal);
    procedure SetThumbsTitleOpacitySelected(const Value: cardinal);

    procedure SetSorttype(Value: TTB_Browser_SortType);

    procedure SetThumbsFrameSize(Value: cardinal);
    procedure SetThumbsSpacing(Value: cardinal);

    procedure SetBuffer_ThumbSize(Value: integer);

    procedure SetResampleMethod(Value: TResamplefilter);

    function GetScroller_Position: integer;

    function GetLastClickedThumb: TBrowserThumb;
    function GetSelectedCount: integer;
    function GetCheckedCount: integer;
    function GetVisibleThumbsCount: integer;
    function GetTotalThumbsCount: integer;
    function GetRotatedCount: integer;

    procedure GetDisplayedThumbsList(var alist: TList; condition: TTB_Browser_PickCondition);

    procedure DoAfterInfoAcceptChanges(theFilename: string);
    procedure DoAfterInfoRenameFile(const old_Name: string; const new_Name: string);

    procedure DoAfterInfoClose(sender: TObject);
    procedure DoOnBeforeThumbLoaded(sender: TObject);
    procedure DoOnLoaderDebug(sender: TObject);

    procedure DoOnAfterThumbLoaded(sender: TObject; ID: integer);
    procedure DoOnAfterALLThumbsLoaded(sender: TObject);
    procedure DoAfterLoaderInitialized(sender: TObject);
    procedure DOOnScrollerScroll(sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
    procedure DOOnScrollerChange(sender: TObject);
    procedure DoOnThumbsAreaMouseUp(sender: TObject; Button: TMouseButton; shift: TShiftState; X, Y: integer);
    procedure DropThumbsFrom(srcTB: TThumbsBrowser; theTransferMode: TThumbsBrowser_DragDropTransferMode;
      destpoint: TPoint);
    procedure PopupExplorerMenu(X, Y: integer);

    procedure Loader_CreateNew;
    procedure Loader_Reload;

    procedure InvalidateDisplay;
    procedure UpdateDisplay;
    procedure UpdateDisplayRect(arect: Trect);

    function GetThumbfromList(List: TList; Idx: integer): TThumbEx;

    procedure StartBrowsing_FromScanner(theList: TThumbsBrowser_ScanFilesThread_FileRcds);
    function CreateThumb(theOriginator: TTB_Thumb_Originator; theUserObject: TObject;
      theLayoutType: TTB_Thumb_Layout_Type; bVisible: boolean): TThumbEx;

    procedure SeTThumbsizeH(const Value: cardinal);
    procedure SeTThumbsizeW(const Value: cardinal);
    procedure SeTThumbsize(Value: cardinal);
    function GetThumbSize: cardinal;

    procedure SetThumbsCaptionRoundnessPerc(const Value: cardinal);
    procedure SetThumbsFrameRoundnessPerc(const Value: cardinal);
    procedure SetThumbsTitleRoundnessPerc(const Value: cardinal);

    procedure SetThumbsBackPadding_Bottom(const Value: integer);
    procedure SetThumbsBackPadding_Left(const Value: integer);
    procedure SetThumbsBackPadding_Right(const Value: integer);
    procedure SetThumbsBackPadding_Top(const Value: integer);

    procedure SetThumbsFramePadding_Bottom(const Value: integer);
    procedure SetThumbsFramePadding_Left(const Value: integer);
    procedure SetThumbsFramePadding_Right(const Value: integer);
    procedure SetThumbsFramePadding_Top(const Value: integer);

    procedure SetThumbResources(const Value: TTB_GraphicResources);
    procedure SetFileScanner_MaxTransfer(const Value: integer);
    procedure SetScrollerBoxVisible(Value: boolean);

{$IFDEF TB_FOLDERMONITOR}
    procedure Handle_FolderMonitorTimer(sender: TObject);
    procedure Handle_FolderMonitorNotify(const sender: TObject; const Action: TWatchAction; const FileName: string);
    procedure SetFolderMonitor_Active(const Value: boolean);
    procedure SetFolderMonitor_Options(const Value: TWatchOptions);
    procedure SetFolderMonitor_Actions(const Value: TWatchActions);
    procedure SetFolderMonitor_TimerInterval(const Value: cardinal);
    procedure Init_FolderMonitor;
    procedure Finalize_FolderMonitor;
    procedure CreateFolderWatchTimer;
    procedure DestroyFolderWatchTimer;
    function IsWatchingFolder(thePath: string): boolean;
    procedure FolderMonitor_AddAllBrowsedPaths;
{$ENDIF}
    function GetDisplayRect: Trect;
    function GetBrowserTotalTopMargin: integer;
    function RectThumb2Display(Idx: integer): Trect;

    procedure LaunchFileScanner(sender: TObject; theFolder: string; theFolderRecursionList: TStringList);
    procedure StopScanner;
    procedure WaitScanner;
    procedure StopLoader(bFreeExplicit: boolean);

    procedure CheckFinalizeBrowsingRecursively;
    procedure FinalizeBrowsingRecursively;

    procedure Init_ProgressPanel;

    function AcceptFileCondition(sr: TSearchRec; fname, fext: string): boolean; overload;
    function AcceptFileCondition(FileName: string; bAcceptNotExist: boolean): boolean; overload;
    function AcceptFolderCondition(sr: TSearchRec; const bNavigate: boolean): boolean; overload;
    function AcceptFolderCondition(foldername: string; bAcceptNotExist: boolean): boolean; overload;

    function AcceptFileFilterCondition(fname, fext: string): boolean;

    procedure SetBackgroundColor(const Value: TColor);

    function GetFirstSelectedDisplayedThumbIdx: integer;
    procedure NotifyDrawThumbBackground(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);

    function HitResultIsSelect(hitResult: TTB_Thumb_HitRectResult): boolean;

    // procedure ForceScrollerBoxUpdate(bImmediateUpdate: boolean);

    function Paths_Add(thePath: string): boolean;
    procedure SetThumbsFrameBgOpacitySelected(const Value: cardinal);
    function GetThumbsBackOpacity: cardinal;
    function GetThumbsBackOpacitySelected: cardinal;
    function GetThumbsBackPadding_Bottom: integer;
    function GetThumbsBackPadding_Left: integer;
    function GetThumbsBackPadding_Right: integer;
    function GetThumbsBackPadding_Top: integer;
    function GetThumbsBottomTitleBackColor: TColor;
    function GetThumbsBottomTitleBackSelectedColor: TColor;
    function GetThumbsBottomTitleFontColor: TColor;
    function GetThumbsBottomTitleFontSelectedColor: TColor;
    function GetThumbsCaptionBackColor: TColor;
    function GetThumbsCaptionBackSelectedColor: TColor;
    function GetThumbsCaptionFontColor: TColor;
    function GetThumbsCaptionFontSelectedColor: TColor;
    function GetThumbsCaptionOpacity: cardinal;
    function GetThumbsCaptionOpacitySelected: cardinal;
    function GetThumbsCaptionRoundnessPerc: cardinal;
    function GetThumbsFrameBgColor: TColor;
    function GetThumbsFrameBgOpacity: cardinal;
    function GetThumbsFrameBgOpacitySelected: cardinal;
    function GetThumbsFrameBgSelectedColor: TColor;
    function GetThumbsFrameBorderColor: TColor;
    function GetThumbsFrameBorderOpacity: cardinal;
    function GetThumbsFrameBorderOpacitySelected: cardinal;
    function GetThumbsFrameBorderSelectedColor: TColor;
    function GetThumbsFramePadding_Bottom: integer;
    function GetThumbsFramePadding_Left: integer;
    function GetThumbsFramePadding_Right: integer;
    function GetThumbsFramePadding_Top: integer;
    function GetThumbsFrameRoundnessPerc: cardinal;
    function GetThumbsFrameSize: cardinal;
    function GetThumbsTitleOpacity: cardinal;
    function GetThumbsTitleOpacitySelected: cardinal;
    function GetThumbsTitleRoundnessPerc: cardinal;
    function GetThumbsTopTitleBackColor: TColor;
    function GetThumbsTopTitleBackSelectedColor: TColor;
    function GetThumbsTopTitleFontColor: TColor;
    function GetThumbsTopTitleFontSelectedColor: TColor;
    function GetBuffer_ThumbSize: integer;
    function GetThumbsizeH: cardinal;
    function GetThumbsizeW: cardinal;
    function GetDisplayMethod: TResamplefilter;
    function GetResampleMethod: TResamplefilter;
    function GetThumbCaption_Settings: TTB_Thumb_CaptionsSettings;

    function GetThumbLayoutType: TTB_Thumb_Layout_Type;
    procedure SetDisplayMethod(const Value: TResamplefilter);

    procedure PaintThumbToDisplay(athumb: TThumbEx; Idx: integer;
      const bQuickView, bRedrawBackground, bImmediateDisplay: boolean); overload;

    procedure PaintThumbToDisplay(athumb: TThumbEx; Idx: integer; X, Y: integer; const bQuickView: boolean;
      const bRedrawBackground: boolean); overload;
    procedure InvalidateBackBuffer(r: Trect);
    procedure SplitFileandUrlList(srcList, destUrlList, destFileList, destFolderList: TStringList);
    procedure SetThumbsSpacingX(const Value: cardinal);
    procedure SetThumbsSpacingY(const Value: cardinal);
    function GetThumbsSpacing: cardinal;
    function GetAvailableBackBufferWidth: integer;
    function GetAvailableBackBufferHeight: integer;
    function GetBrowsedFolders(Idx: integer): string;
    function GetBrowsedFoldersCount: integer;
    function GetCurrentFolder: string;
    procedure SetShowThumbnailHint(const Value: boolean);
    function PtBrowser2Thumb(Pt: TPoint; Idx: integer): TPoint;
    function PtThumb2Browser(Pt: TPoint; Idx: integer): TPoint;
    function GetThumbsTitleDrawFocusRectIfEmpty: boolean;
    procedure SetThumbsTitleDrawFocusRectIfEmpty(const Value: boolean);

    function GetThumbCaption_MissingText: string;
    procedure SetThumbCaption_MissingText(const Value: string);

    procedure DefineProperties(Filer: TFiler); override;
    procedure WriteThumbCaption_MissingText(Writer: TWriter);
    procedure Init_MetaData;
    procedure Finalize_MetaData;
    procedure Handle_MetaData_IptcFieldsChanged(sender: TObject);
    procedure Handle_MetaData_XmpFieldsChanged(sender: TObject);
    procedure SetFolderTitles(const Value: boolean);
    procedure SetFolderSpecialOptions(const bCheckBoxes, bTitles: boolean);
    procedure CheckSpecialCaseThumb(theThumb: TThumbEx);
    // procedure SetShowTitles(const bTopTitle, bBottomTitle: boolean);
    function IsFilterMultiExt(const theFilter: string): boolean;

    procedure Handle_MetaData_ExifFieldsChanged(sender: TObject);
    procedure Handle_MetaData_CommonFieldsChanged(sender: TObject);
    procedure Handle_MetaData_SyncTagChanged(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType;
      const oldTagstr, newTagstr: string);
    procedure Handle_ThumbSyncPropertyChanged(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType);

    function IsPathInPaths(const thePath: string): boolean;
    procedure StartNavigation(theFolder: string);
    procedure StopNavigation;

    procedure HideThumbs(VisibilityTypes: TThumbsBrowser_ThumbVisibilityTypes; const sourcetypes: TTB_SourceTypes;
      const condition: TTB_Browser_PickCondition; const bUpdateDisplay: boolean); overload;
    procedure HideThumbs(bForceVisibilityEvent: boolean; VisibilityTypes: TThumbsBrowser_ThumbVisibilityTypes;
      tl: TList; const bUpdateDisplay: boolean); overload;
    procedure HideThumbsToNavMemory(OnNavMemoryFull: TThumbsBrowser_NavMemoryOnFullAction;
      const bSwitchNavMemoryOn: boolean; const bUpdateDisplay: boolean); overload;

    procedure ClearThumbs(tl: TList; const bClearPaths: boolean; const bUpdateDisplay: boolean); overload;
    procedure ClearThumbs(const bIncludeInvisible: boolean; const sourcetypes: TTB_SourceTypes;
      const condition: TTB_Browser_PickCondition; const bClearPaths, bUpdateDisplay: boolean); overload;
    procedure ManageThumbVisibilityChange(VisibilityAction: TThumbsBrowser_ThumbVisibilityAction; athumb: TThumbEx);

    procedure OpenVisibilityTransaction(transactionTypes: TThumbsBrowser_ThumbVisibilityTransactions);
    procedure CloseVisibilityTransaction(transactionTypes: TThumbsBrowser_ThumbVisibilityTransactions);
    function AnyVisibilityTransactionOpened_Show: boolean;
    function AnyVisibilityTransactionOpened_Hide: boolean;
    function IsThumbHidden(visibilityType: TThumbsBrowser_ThumbVisibilityType; athumb: TThumbEx; var Idx: integer)
      : boolean; overload;
    function IsThumbHidden(visibilityType: TThumbsBrowser_ThumbVisibilityType; athumb: TThumbEx): boolean; overload;
    function GetThumbFileName(Idx: integer): string;
    function GetThumbImage(Idx: integer): TIEBitmap;
    function GetThumbUserObject(Idx: integer): TObject;
    function GetThumbUserTag(Idx: integer): integer;
    procedure SetThumbUserObject(Idx: integer; const Value: TObject);
    procedure SetThumbUserTag(Idx: integer; const Value: integer);
    procedure Handle_MetaData_AutoSyncOptionChanged(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType;
      oldOption, newOption: TThumbsbrowser_MetaData_SyncOpType);
    function GetFilteredOutThumbsCount: integer;
    procedure LoaderStart;
    function GetThumbfromList_Safe(List: TList; Idx: integer): TThumbEx;
    procedure LoaderInit(theFolder: string; theFileList, theUrlList, theWPDList: TStringList;
      theScannerList: TThumbsBrowser_ScanFilesThread_FileRcds);
    procedure setNavMemMaxThumbs(const Value: cardinal);
    function NavMemCheckAdd(athumb: TThumbEx; bAllowExpand: boolean): boolean;
    procedure GetSortInstruction(Thesorttype: TTB_Browser_SortType);
    procedure Paths_Delete(Idx: integer);
    procedure PauseLoading;
    procedure UnPauseLoading;
    procedure ChangeFileNameThumb(theThumb: TThumbEx; const new_Name: string);
    procedure ChangeThumbKey(const ID: integer; const newKey: string);

    procedure SetMaxCols(const Value: integer);
    procedure SetMaxRows(const Value: integer);
    procedure SetCentered(const Value: boolean);
    procedure SetFixedMarginBottom(const Value: integer);
    procedure SetFixedMarginLeft(const Value: integer);
    procedure SetFixedMarginRight(const Value: integer);
    procedure SetFixedMarginTop(const Value: integer);

    procedure SetFileThumbs(const Value: boolean);
    procedure SetShowOptions(Value: boolean; setting: TTB_Thumb_ShowSetting);
    function GetThumbsMouseOverOptions: TTB_Thumb_MouseOverOptions;
    procedure SetThumbsMouseOverOptions(const Value: TTB_Thumb_MouseOverOptions);
    procedure ResetMouseHover;
    procedure SetShowRatingBox(const Value: boolean);
    function CheckChangeVisualRating(theThumb: TThumbEx; thIdx: integer; mouseX, mouseY: integer;
      bVisualChange: boolean): integer;
    procedure SetOnThumbBufferLoaded(const Value: TThumbsBrowserOnThumbBufferLoaded);
    procedure NotifyThumbBufferLoaded(sender: TObject; const bufWidth, bufHeight: integer; var bResizeBuffer: boolean;
      var newbufWidth, newbufHeight: integer);
    procedure SetThumbCaptionOrder(Idx: integer; const Value: integer);
    function GetThumbCaptionOrder(Idx: integer): integer;
    function GetThumbCaption_OrderByCaption(cap: TTB_Thumb_CaptionsSetting): integer;

    procedure InitCaptionInfos;
    function GetThumbCaptionColumnPercWidth(Idx: integer): single;
    procedure SetThumbCaptionColumnPercWidth(Idx: integer; const Value: single);

    procedure NotifyGetCaptionInfo(const capSet: TTB_Thumb_CaptionsSetting; var info: TTB_Thumb_CaptionInfo);
    procedure NotifyGetCaptionIndex(const Pos: integer; var capIdx: integer);
    procedure SetFolderCurrent(const Value: string);
    procedure SetFolderDefault(const Value: TThumbsBrowserDeafultFolder);
    function GetThumbCaptionIncludeInFrame: boolean;
    procedure SetThumbCaptionIncludeInFrame(const Value: boolean);
    procedure ScrollTimerUpdate(sender: TObject; Value: double);
    procedure Handle_ScrollTimerUpdate(sender: TObject);
    function GetHeaderResizeColbyMouse(X, Y: integer): integer;
    function GetReportHeaderRect: Trect;
    function GetReportHeaderColumnRect(colIdx: integer): Trect;
    procedure ResizeHeaderColumn(colIdx, xBef, xAfter: integer);
    procedure CopyColumnsForMouseMove;
    procedure DrawReportHeader(const HilightColIdx: integer = -1);
    function GetHeaderColbyMouse(X, Y: integer): integer;
    procedure MoveHeaderColumn(curColIdx, xBef, xAfter: integer);
    procedure SetCursor(const Value: TCursor);
    procedure LockPaint;
    procedure UnlockPaint(const bUpdate: boolean);

    procedure CalcBrowserUsefulRect;
    procedure LockVCLStyle;
    procedure UnLockVCLStyle;

    function GetStoreType: TTB_Thumb_StoreType;
    procedure SetStoreType(const Value: TTB_Thumb_StoreType);
    procedure SetStyleOptions(const Value: TTB_Browser_StyleOptions);
    procedure SetStyle(const bUpdate: boolean);
    function RectBrowser2Display(arect: Trect): Trect;
    function RectDisplay2Browser(arect: Trect): Trect;
    procedure DoTimedEvent(eventConst: nativeint; interval: integer; const bCheckEventAlreadyStarted: boolean);
    procedure HandleTimedEvent(sender: TObject);
    procedure SetThumbCaptionOrderEX(Idx: integer; const Value: integer);
    procedure SetBackgroundType(const Value: TTB_Browser_BackgroundType);
    procedure SetBackground2ndColor(const Value: TColor);
    procedure SetThumbDropShadow(const Value: TTB_Thumb_DropShadowOptions);
    procedure HandleDropShadowOptionsChange(sender: TObject);
    procedure SetStyleColumnsSize(const theStyle: TTB_Browser_Style);
    function GetThumbChecked(Idx: integer): boolean;
    function GetThumbRotated(Idx: integer): TTB_Thumb_RotationMode;
    function GetThumbSelected(Idx: integer): boolean;
    function GetThumbIOParams(Idx: integer): TIOParams;

    procedure SetThumbSelected(Idx: integer; const Value: boolean);

    procedure SetLanguage(const Value: TNWSCompsLanguage);

    procedure HandleGlobalNotification(sender: TObject; notType: TNWSCompsNotificationType);
    procedure SetFolderUpNavThumb(const Value: boolean);
    function CheckShowInfoBox(theThumb: TThumbEx; thIdx, mouseX, mouseY: integer; bVisualChange: boolean): boolean;
    procedure RestoreMouseOver(thIdx: integer); overload;
    procedure RestoreMouseOver(theThumb: TThumbEx); overload;
    function MouseIsInside: boolean;
    function GetOwnUserObjects: boolean;
    procedure SetOwnUserObjects(const Value: boolean);
    function GetThumbBottomTitle(Idx: integer): string;
    function GetThumbCaption(Idx: integer): string;
    function GetThumbTopTitle(Idx: integer): string;
    procedure SetThumbBottomTitle(Idx: integer; const Value: string);
    procedure SetThumbCaption(Idx: integer; const Value: string);
    procedure SetThumbTopTitle(Idx: integer; const Value: string);
    function GetPickedThumbs(pickMode: TTB_Browser_PickCondition): TList;

    procedure ExtraUpdateForVCLSkin;
    procedure SetShowDesignTestThumbs(const Value: boolean);
    procedure CreateTests;
    function GetScrollbar: TScrollBar;
    function CustomSortComparerAsc(p1, p2: Pointer): integer;
    function CustomSortComparerDesc(p1, p2: Pointer): integer;
    function HeaderCaptionSortComparerAsc(p1, p2: Pointer): integer;
    function HeaderCaptionSortComparerDesc(p1, p2: Pointer): integer;
    procedure MethodSort(theList: TList; L, r: integer; compMethod: TCompMethod);
    procedure RetrieveThumb(athumb: TThumbEx);

  protected
    { Protected declarations }

    property Thumbs: TTBThumbsList read fThumbs;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function GetThumbIDfromVisibleThumbIdx(Idx: integer): integer;
    function GetThumbIDfromSelectedThumbIdx(Idx: integer): integer;
    function GetThumbIDfromCheckedThumbIdx(Idx: integer): integer;
    function GetThumbIDfromRotatedThumbIdx(Idx: integer): integer;

    function GetVisibleThumbIdxfromThumbID(ID: integer): integer;
    function GetSelectedThumbIdxfromThumbID(ID: integer): integer;
    function GetCheckedThumbIdxfromThumbID(ID: integer): integer;
    function GetRotatedThumbIdxfromThumbID(ID: integer): integer;

    function GetVisibleThumbIdxfromSelectedThumbIdx(Idx: integer): integer;
    function GetVisibleThumbIdxfromCheckedThumbIdx(Idx: integer): integer;
    function GetVisibleThumbIdxfromRotatedThumbIdx(Idx: integer): integer;

    function GetSelectedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;
    function GetCheckedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;
    function GetRotatedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;

    procedure SetFolderThumbs(const Value: boolean);
    procedure SetFolderNavigation(const Value: boolean);
    procedure SetFolderCheckBoxes(const Value: boolean);

    procedure CreateInfoForm(theThumb: TThumbEx; const thumbIdx: integer;
      theEmbeddingPanel: TCustomPanel = nil); overload;
    procedure CreateInfoForm(const PosX, PosY: integer; theEmbeddingPanel: TCustomPanel = nil); overload;

    function ScrollerPos_To_VirtualPos(Value: integer): integer;
    function VirtualPos_To_ScrollerPos(Value: double): integer;

    function IsThumbSelected(Idx: integer): boolean;
    procedure InitSampleThumb;

    procedure WMGetdlgcode(var Message: twmgetdlgcode); message WM_GETDLGCODE;
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;

    procedure CalcLayout(theThumb: TThumbEx);
    procedure CalcBasicLayout(theThumb: TThumbEx; bScrollerVisible: boolean);

    procedure SetScrollerParams;
    procedure RefreshListofThumbs(alist: TList);
    procedure DrawThumbsHorz(bQuickView: boolean);
    procedure DrawThumbsVert(bQuickView: boolean);

    procedure CreateVisibleThumbs(theLoadingType: TThumbsbrowser_LoadingType = tblt_None;
      theNamedList: TNamedList = nil);
    function ComplytoSearchCriterion(theThumb: TThumbEx): boolean;

    procedure SearchThumbs(const bGotoSelected: boolean);

    procedure SortThumbs(const bCheckalreadySorted: boolean; Thesorttype: TTB_Browser_SortType);

    procedure DoSort(theList: TList; Thesorttype: TTB_Browser_SortType);

    procedure Resize; override;
    procedure Paint; override;

    procedure BeforeDestruction; override;

    procedure ScrollThumbs(theScrollAmount: TTB_Browser_ScrollAmount);

    procedure MouseUp(Button: TMouseButton; shift: TShiftState; X, Y: integer); override;
    procedure MouseDown(Button: TMouseButton; shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(shift: TShiftState; X, Y: integer); override;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure DblClick; override;

    procedure KeyDown(var Key: Word; shift: TShiftState); override;
    procedure KeyUp(var Key: Word; shift: TShiftState); override;

    procedure FireOnStartedLoading;
    procedure FireOnFinishLoading;

    procedure SelectThumbNoUpdate(Idx: integer);
    procedure DeSelectThumbNoUpdate(Idx: integer);
    procedure DeselectAllThumbsNoUpdate;
    procedure SelectAllThumbsNoUpdate;

    procedure InvertSelectionThumbNoUpdate(Idx: integer);
    procedure DeselectThumbsRangeNoUpdate(fromthumb, tothumb: integer);
    procedure SelectThumbsRangeNoUpdate(fromthumb, tothumb: integer);

    procedure CheckMarkThumbNoUpdate(Idx: integer; checkvalue: boolean);
    procedure CheckMarkAllThumbsNoUpdate(checkvalue: boolean);

    procedure MarkRotatedThumbNoUpdate(Idx: integer; rm: TTB_Thumb_RotationMode);
    procedure MarkRotatedAllThumbsNoUpdate(rm: TTB_Thumb_RotationMode);

    Function DuplicateThumb(srcThumb: TThumbEx; Insertidx: integer): TThumbEx;
    procedure MoveThumb(fromIdx, ToIdx: integer);

    procedure InitThumb(theThumb: TThumbEx);

    procedure Addthumb(theThumb: TThumbEx; const theSearchKey: string; position: integer); overload;
    Function Addthumb(theOriginator: TTB_Thumb_Originator; const bVisible, bChecked: boolean;
      const theSearchKey: string; theStoreType: TTB_Thumb_StoreType; theUserObject: TObject = nil;
      const Insertidx: integer = -1): TThumbEx; overload;
    Function Addthumb(FileName: string; theStoreType: TTB_Thumb_StoreType; theUserObject: TObject = nil;
      const Insertidx: integer = -1; const bAsynchronousLoading: boolean = true;
      const bAllowCreateLoader: boolean = true): TThumbEx; overload;
    Function Addthumb(theIEBmp: TIEBitmap; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
      theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx; overload;
    function Addthumb(theStream: TStream; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
      theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx; overload;

    Function Addthumb(theBmp: tbitmap; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
      theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx; overload;

    function Deletethumb(ID: integer): boolean; overload;
    function Deletethumb(theThumb: TThumbEx): boolean; overload;

    Function GetReaderFunction(TheFileExt: string): TTB_Browser_FileReaderFunction;

    function WIA_CheckValidItem(aItem: TIEWiaItem): boolean;
    procedure WIA_FillPics;
    procedure WIA_FillPictureThumb(athumb: TThumbEx);

    procedure WIA_FillIInfo;
    procedure WIA_VerifyItems;

    function WPD_SubFoldersToMaxDepth(bSubFolders: boolean): integer;

{$IFDEF TB_PORTABLEDEVICE}
    procedure Handle_WPDLog(sender: TObject; const sMsg: String);

    function WPD_InNavhistory(const theObjID: string): boolean;
    function WPD_GetAdvProps(const theObjID: string; out Props: TIEWPDObjectAdvancedProps): boolean;
    procedure WPD_FillInfo(const DevID: string; const theFolderID: string = ''; const theFolderPath: string = '';
      const iMaxDepth: integer = 0; const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]
      ); overload;

    procedure StartBrowsing_WPD(aDeviceID: string = ''; aFolderID: string = ''; aFolderPAth: string = '';
      iMaxDepth: integer = 0; const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]
      ); overload;
{$ENDIF}
    property ReBrowsingExistingPaths: boolean read fReBrowsingExistingPaths;

    property SampleThumb: TThumbEx read fSampleThumb;

    procedure StopBrowsing(bAbortScanner: boolean); overload;

    function XDisplay2Browser(X: integer): integer;
    function YDisplay2Browser(Y: integer): integer;
    function XBrowser2Display(X: integer): integer;
    function YBrowser2Display(Y: integer): integer;

    function XDisplay2Thumb(X: integer; Idx: integer): integer;
    function YDisplay2Thumb(Y: integer; Idx: integer): integer;
    function XThumb2Display(X: integer; Idx: integer): integer;
    function YThumb2Display(Y: integer; Idx: integer): integer;

    function XDisplay2ThumbSimul(X: integer; Idx: integer; const theScrollPos: integer): integer;
    function YDisplay2ThumbSimul(Y: integer; Idx: integer; const theScrollPos: integer): integer;
    function XThumb2DisplaySimul(X: integer; Idx: integer; const theScrollPos: integer): integer;
    function YThumb2DisplaySimul(Y: integer; Idx: integer; const theScrollPos: integer): integer;

    procedure UpdateVCLStyle; override;
    procedure UnlockUpdate(const bDoUpdate: boolean); overload;
    procedure CheckApplyTheme;

    procedure LockStyle;
    procedure UnLockStyle;

    property SelectedThumbs: TList read fSelectedThumbs;
    property CheckedThumbs: TList read fCheckedThumbs;
    property RotatedThumbs: TList read frotatedThumbs;

  public
    { Public declarations }

    function PromptForFolder: boolean;

    procedure SetStyleEx(const theStyle: TTB_Browser_Style; const theCaptions: TTB_Thumb_CaptionsSettings = [];
      dbThumbZoom: double = -1; const bAdjustSpacing: boolean = true; const bAdjustStyle: boolean = true);

    procedure AbortBrowsingRecursively;

    procedure Loaded; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function InPaths(const theFilename: string): boolean; overload;
    function InPaths(theThumb: TThumbEx; bCheckSourceType: boolean): boolean; overload;

    // v.1.0.1
    procedure AddCustomFileFormatRead(theFormat: TTB_Browser_FileFormat);
    procedure ClearCustomFileFormatsRead;
    function IsFileExtSupported_Read(theExt: string): boolean;
    function IsFileExtSupported_Write(theExt: string): boolean;
    // v.1.0.1

{$IFDEF TB_FOLDERMONITOR}
    procedure FolderMonitor_AddFolder(const theFolder: string; const bSubTree: boolean);
    procedure FolderMonitor_RemoveFolder(const theFolder: string; const bSubTree: boolean);
{$ENDIF}
    procedure GetThumbsList(thumbList: TList; sourcetypes: TTB_SourceTypes; condition: TTB_Browser_PickCondition;
      bIncludeInvisible: boolean = false);

    procedure LockLoading;
    procedure UnLockLoading;

    procedure LockLayout;
    procedure UnLockLayout(const bDoUpdateLayout: boolean = true);

    procedure LockUpdate;
    procedure UnlockUpdate; overload;

    procedure UnlockUpdateEx;
    procedure Update; override;
    procedure Invalidate; override;
{$IFDEF TB_FOLDERMONITOR}
    procedure LockFolderMonitor;
    procedure UnlockFolderMonitor;
    procedure SuspendFolderMonitor(ms: integer; targetFileName: string = ''; const Actions: TWatchActions = []);
    procedure UnSuspendFolderMonitor(targetFileName: string = '');
{$ENDIF}
    procedure OpenThumbsTransaction; deprecated 'Use LockUpdate Instead';
    procedure CloseThumbsTransaction; deprecated 'Use UnlockUpdate instead';

    // this clears all thumbs (visible and invisible)
    procedure ClearThumbs_All(const bClearPaths: boolean = true); overload;

    procedure ClearThumbs(const bIncludeInvisible: boolean; const sourcetypes: TTB_SourceTypes;
      const condition: TTB_Browser_PickCondition; const bClearPaths: boolean); overload;

    procedure ClearThumbs(const bIncludeInvisible: boolean = false; const bClearPaths: boolean = true); overload;
    procedure ClearThumbs_NotInPaths;
    procedure ClearThumbs_Checked;
    procedure ClearThumbs_UnChecked;
    procedure ClearThumbs_Selected;
    procedure ClearThumbs_WIA;
    procedure ClearThumbs_NotInWIA;
    procedure ClearThumbs_WPD;
    procedure ClearThumbs_NotInWPD;

    procedure DropFilesFromTB(srcTB: TThumbsBrowser; mode: TThumbsBrowser_DragDropTransferMode; destpoint: TPoint);
    procedure DropFilesFromExplorer(filenames: TStrings; mode: TThumbsBrowser_DragDropTransferMode);

    Procedure ClearPathsofNonExistingThumbs; deprecated 'Use Paths_ClearUnused instead';
    procedure Paths_Clear;
    procedure Paths_ClearUnused;

    procedure HideThumbs; overload;
    procedure HideThumbs(const sourcetypes: TTB_SourceTypes; const condition: TTB_Browser_PickCondition); overload;
    procedure HideThumbs(theFileNames: TStringList); overload;
    procedure HideThumbsToNavMemory; overload;

    procedure ReShowHiddenThumbs;

    procedure FilterThumbs(const bGotoSelected: boolean = true);
    procedure Search; deprecated 'Please use FilterThumbs to find thumbs by filtering using the Filter Criteria';

    procedure StartBrowsingRecursively(theFolder: string);
    procedure StartBrowsing(theFolder: string); overload;
    procedure StartBrowsing(theFileList: TStringList; const bIfFolder_thenBrowseContent: boolean = true); overload;

    procedure StartBrowsing_WIA(const aDeviceIdx: integer);
{$IFDEF TB_PORTABLEDEVICE}
    procedure StopBrowsing_WPD;
    procedure StartBrowsing_WPD(DevID: string = ''; theFolderID: string = ''; const bSubFolders: boolean = false;
      const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]); overload;
    procedure StartBrowsing_WPD(DevID: string = ''; theFolderID: string = ''; const iMaxDepth: integer = 0;
      // 0 = no recursion | -1 = all subfolders
      const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]); overload;

    procedure NavigateToWPDFolderPath(aDeviceID: string; theFolderPath: string;
      objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
    procedure NavigateToWPDFolder(aDeviceID: string; theFolderID: string;
      objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
{$ENDIF}
    procedure NavigateToFolder(theFolder: string);

    procedure StopBrowsing; overload;
    procedure StopBrowsing_WIA;

    procedure ReloadFile(theThumb: TThumbEx); overload;
    procedure ReloadFile(Idx: integer); overload;
    procedure ReloadFile(const theFilename: string); overload;
    procedure RefreshFiles;
      deprecated
      'Please to rebrowse the content of the folders and search for new files use RefreshFolders or to reload the existing thumbs only use ReloadFiles.';
    procedure RefreshFolders;

    procedure ReLoadFiles(pickMode: TTB_Browser_PickCondition); overload;
    procedure ReLoadFiles; overload;
    procedure ReLoadFiles(filenames: TStringList); overload;

    procedure ReLoadThumbs(pickMode: TTB_Browser_PickCondition); overload;
    procedure ReLoadThumbs; overload;
    procedure ReLoadThumbs(tl: TList); overload;

    procedure LoadFile(const theFilename: string);
    procedure LoadFiles(filenames: TStringList);

    function IsThumbUpdated(theThumb: TThumbEx): boolean;

    procedure RefreshDisplay;
    procedure ResortThumbs;
    procedure RefreshThumb(Idx: integer; const bImmediateDisplay: boolean = true); overload;
    procedure RefreshThumb(theThumb:TThumbEX; const bImmediateDisplay: boolean = true);overload;
    procedure RefreshThumbs(sender: TObject; const bImmediateDisplay: boolean = false;
      const bAsFromLoader: boolean = false);

    procedure ClearThumbsInPath(Pathname: string);

    procedure SetVirtualScroll_Position(theposition: double);

    Function Add_File(FileName: string; aUserObject: TObject = nil; const Insertidx: integer = -1;
      const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified)
      : TBrowserThumb;

    Procedure Add_Files(filenames: TStringList; UserObjects: TList = nil; const Insertidx: integer = -1;
      const bAsynchronousLoading: boolean = true; const bGoToFirstAdded: boolean = false;
      theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified);
    procedure Remove_File(FileName: string);
    Procedure Remove_Files(filenames: TStringList);

    Function Add_a_Thumb(aUserObject: TObject = nil; const Insertidx: integer = -1;
      theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;
    Function Add_a_Thumb(FileName: string; aUserObject: TObject = nil; const Insertidx: integer = -1;
      const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified)
      : TBrowserThumb; overload;
    Function Add_a_Thumb(theIEBmp: TIEBitmap; const theCaption: string; aUserObject: TObject = nil;
      const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;
    Function Add_a_Thumb(theBmp: tbitmap; const theCaption: string; aUserObject: TObject = nil;
      const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;
    Function Add_a_Thumb(theStream: TStream; const theCaption: string; aUserObject: TObject = nil;
      const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;

    Function Set_a_Thumb(Idx: integer; FileName: string; aUserObject: TObject = nil;
      const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified)
      : TBrowserThumb; overload;
    Function Set_a_Thumb(Idx: integer; theIEBmp: TIEBitmap; const theCaption: string = ''; aUserObject: TObject = nil;
      theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;
    Function Set_a_Thumb(Idx: integer; theBmp: tbitmap; const theCaption: string = ''; aUserObject: TObject = nil;
      theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;
    Function Set_a_Thumb(Idx: integer; theStream: TStream; const theCaption: string = ''; aUserObject: TObject = nil;
      theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb; overload;

{$IFDEF TB_MULTIBITMAP}
    procedure ExportToMultiBitmap(pickMode: TTB_Browser_PickCondition; mb: TIECustomMultiBitmap;
      bTakeOriginalPics: boolean);
    function ExportToMultiFileFormat(pickMode: TTB_Browser_PickCondition; FileName: string; bTakeOriginalPics: boolean;
      IOParams: TIOMultiParams = nil; theOnProgressHandler: TIEProgressEvent = nil): boolean; overload;

    function ExportToMultiFileFormat(pickMode: TTB_Browser_PickCondition; FileName: string; bTakeOriginalPics: boolean;
      theOnProgressHandler: TIEProgressEvent = nil): boolean; overload;
{$ENDIF}
    procedure Move_a_Thumb(fromIdx, ToIdx: integer);

    function Duplicate_a_Thumb(Idx: integer; const Insertidx: integer = -1): TThumbEx; overload;
    function Duplicate_a_Thumb(theThumb: TThumbEx; const Insertidx: integer = -1): TThumbEx; overload;

    function Delete_a_Thumb_byAbsoluteIdx(ID: integer): boolean;
    function Delete_a_Thumb(Idx: integer): boolean; overload;
    function Delete_a_Thumb(theThumb: TThumbEx): boolean; overload;

    procedure EnsureImageLoaded(Idx: integer); overload;
    procedure EnsureImageLoaded(athumb: TThumbEx); overload;

    function GetThumbRowbyIdx(Idx: integer): integer;
    function GetThumbColumnbyIdx(Idx: integer): integer;

    function XBrowser2Thumb(X: integer; Idx: integer): integer;
    function YBrowser2Thumb(Y: integer; Idx: integer): integer;
    function XThumb2Browser(X: integer; Idx: integer): integer;
    function YThumb2Browser(Y: integer; Idx: integer): integer;
    function RectThumb2Browser(Idx: integer): Trect;

    function GetAbsoluteIdx(theThumb: TThumbEx): integer;
    function Thumbat_AbsoluteIdx(Idx: integer): TThumbEx;

    function GetThumbIdx(theThumb: TThumbEx): integer;
    function GetThumbIdxbyMousexy(X, Y: integer): integer;
    function GetThumbIdxbyFileName(FileName: string): integer;
    function GetThumbIdxbySelectedIdx(Idx: integer): integer;
    function GetThumbIdxbyCheckedIdx(Idx: integer): integer;

    function GetSelectedThumbIdxfromThumbIdx(Idx: integer): integer;
    function GetCheckedThumbIdxfromThumbIdx(Idx: integer): integer;

    function Thumbat(Idx: integer): TThumbEx; overload;
    function Thumbat(X, Y: integer): TThumbEx; overload;
    function Thumbat(FileName: string): TThumbEx; overload;

    procedure GetThumbsByFileName(const FileName: string; theThumbs: TList; const bClearList: boolean);

    procedure ThumbsSetColors(theBackcolor, theBackSelectedcolor, theCaptionFontColor, theCaptionFontSelectedColor,
      theCaptionBackColor, theCaptionBackSelectedColor, theTopTitleFontColor, theTopTitleFontSelectedColor,
      theTopTitleBackColor, theTopTitleBackSelectedColor, theBottomTitleFontColor, theBottomTitleFontSelectedColor,
      theBottomTitleBackColor, theBottomTitleBackSelectedColor, theFrameBorderColor, theSelFrameBorderColor: TColor);

    function GetSelected(Idx: integer): TThumbEx;
    function GetChecked(Idx: integer): TThumbEx;
    function GetRotated(Idx: integer): TThumbEx;

    procedure SelectThumb(Idx: integer);
    procedure DeSelectThumb(Idx: integer);
    procedure DeselectAllThumbs;
    procedure SelectAllThumbs;
    procedure SelectThumbbyFileName(FileName: string);
    procedure InvertSelectionThumbsRange(fromthumb, tothumb: integer);

    procedure CheckMarkThumb(Idx: integer; checkvalue: boolean);
    procedure CheckMarkAllThumbs(checkvalue: boolean);
    procedure InvertCheckedThumbsRange(fromthumb, tothumb: integer);

    procedure MarkRotatedThumb(Idx: integer; rm: TTB_Thumb_RotationMode);
    procedure MarkRotatedAllThumbs(rm: TTB_Thumb_RotationMode);

    function ThumbIsMouseOver(theThumb: TThumbEx): boolean;

    function GotoThumb(athumb: TThumbEx; bselect: boolean): integer;
    procedure GotoThumbPosition(Idx: integer; select: boolean);
    procedure GotoFileName(FileName: string; select: boolean);
    procedure GotoRow(theRow: integer);
    procedure GotoColumn(theCol: integer);
    function FindNearest(Idx: integer; condition: TTB_Browser_PickCondition): integer;

    procedure ViewPoint_Restore;
    procedure ViewPoint_Save;

    procedure ShowInfo(theEmbeddingPanel: TCustomPanel = nil); overload;
    procedure ShowInfo(theThumb: TThumbEx; theEmbeddingPanel: TCustomPanel = nil); overload;
    procedure CloseInfo;

    procedure TBBeginDrag;
    procedure TBEndDrag;
{$IFDEF TB_USEDB}
    procedure CleanDatabase(const bNonExisting_Only: boolean; const bInPath_Only: boolean);
{$ENDIF}
    Function IsUserFormat(theExt: string): boolean;
    constructor Init_TimedEvents;


    // public properties

    property LockLayoutCount: integer read fLayoutLocked;
    property LockUpdateCount: integer read fUpdateLocked;
    property LockLoadingCount: integer read fLoadingLocked;

    property InfoFormOpened: boolean read FInfoFormOpened write FInfoFormOpened;
    property InfoForm: TThumbsbrowser_InfoForm read fThumbsbrowser_InfoForm;

    property DisplayRect: Trect read GetDisplayRect;
    property BrowsingRecursively: boolean read FBrowsingRecursively;
    property LayoutResources: TTB_GraphicResources read fLayoutResources write SetThumbResources;
    property Scroller_Position: integer read GetScroller_Position;

    property CurrentFolder: string read GetCurrentFolder;
    property BrowsedFolders[Idx: integer]: string read GetBrowsedFolders;
    property BrowsedFoldersCount: integer read GetBrowsedFoldersCount;

    property WIA_Items: TList read fBrowser_WIA_Items;
    property WIA_DeviceIdx: integer read fBrowser_WIA_DeviceIdx;
    property WIA_IO: TImageenio read fBrowser_WIA_IO;

{$IFDEF TB_PORTABLEDEVICE}
    property WPD: TIEPortableDevices read fBrowser_WPD;
{$ENDIF}
    property Sort_Updated: boolean read fsort_updated;
    property Filter_Updated: boolean read ffilter_updated;

    procedure GetFileNames_Selected(filenames: TStrings);
    procedure GetFileNames_Checked(filenames: TStrings);

    property Thumb[Idx: integer]: TThumbEx read Thumbat;
    property ThumbFileName[Idx: integer]: string read GetThumbFileName;
    property ThumbImage[Idx: integer]: TIEBitmap read GetThumbImage;
    property ThumbSelected[Idx: integer]: boolean read GetThumbSelected write SetThumbSelected;
    property ThumbChecked[Idx: integer]: boolean read GetThumbChecked write CheckMarkThumb;
    property ThumbRotated[Idx: integer]: TTB_Thumb_RotationMode read GetThumbRotated write MarkRotatedThumb;
    property ThumbIOParams[Idx: integer]: TIOParams read GetThumbIOParams;

    property ThumbCaption[Idx: integer]: string read GetThumbCaption write SetThumbCaption;
    property ThumbTopTitle[Idx: integer]: string read GetThumbTopTitle write SetThumbTopTitle;
    property ThumbBottomTitle[Idx: integer]: string read GetThumbBottomTitle write SetThumbBottomTitle;

    property ThumbUserObject[Idx: integer]: TObject read GetThumbUserObject write SetThumbUserObject;
    property ThumbUserTag[Idx: integer]: integer read GetThumbUserTag write SetThumbUserTag;

    property ThumbsCount_Total: integer read GetTotalThumbsCount;
    property ThumbsCount: integer read GetVisibleThumbsCount;
    property ThumbsCount_FilteredOut: integer read GetFilteredOutThumbsCount;

    property LastClickedThumb: TBrowserThumb read GetLastClickedThumb;

    property TopDisplayedThumbIdx: integer read fTopDisplayedThumbIdx;
    property BottomDisplayedThumbIdx: integer read fBottomDisplayedThumbIdx;

    property SelectedCount: integer read GetSelectedCount;
    property SelectedIndex: integer read fSelectedIndex;
    property CheckedCount: integer read GetCheckedCount;
    property RotatedCount: integer read GetRotatedCount;

    property FixedMarginTop: integer read fBrowserOwnMarginTop write SetFixedMarginTop;
    property FixedMarginBottom: integer read fBrowserOwnMarginBottom write SetFixedMarginBottom;
    property FixedMarginLeft: integer read fBrowserOwnMarginLeft write SetFixedMarginLeft;
    property FixedMarginRight: integer read fBrowserOwnMarginRight write SetFixedMarginRight;

    property NColumns: cardinal read fNColumns;
    property NRows: cardinal read fNRows;
    property NRowsByPage: integer read fNRowsByPage;
    property NColumnsByPage: integer read fNColumnsByPage;
    property NRowsByPagef: double read fNRowsByPagef;
    property NColumnsByPagef: double read fNColumnsByPagef;

    property MetaTags: TThumbsbrowser_MetaTags read fMetaTags;

    Property AllowCustomformat_ExternalReader: boolean read fAllowCustomformat_ExternalReader
      write SetAllowCustomformat_ExternalReader;

    property ThumbCaptionOrder[Idx: integer]: integer read GetThumbCaptionOrder write SetThumbCaptionOrder;
    property ThumbCaptionColumnPercWidth[Idx: integer]: single read GetThumbCaptionColumnPercWidth
      write SetThumbCaptionColumnPercWidth;

    property Scrollbar: TScrollBar read GetScrollbar;
    property LastLoadingType: TThumbsbrowser_LoadingType read fLastLoadingType;
  published
    { Published declarations }

{$IFDEF TB_TOUCH}
{$IFDEF NWSCOMPS_DELPHI2010_UPPER}
    property Touch;
{$ENDIF}
{$ENDIF}
    property ShowDesignTestThumbs: boolean read fShowDesignTestThumbs write SetShowDesignTestThumbs;
    property Language: TNWSCompsLanguage read fLanguage write SetLanguage;
    property OwnUserObjects: boolean read GetOwnUserObjects write SetOwnUserObjects;

    property Cursor: TCursor read fCursor write SetCursor;

{$IFDEF TB_FOLDERMONITOR}
    property FolderMonitor_Active: boolean read FFolderMonitor_Active write SetFolderMonitor_Active;
    // property FolderMonitor_Options: TWatchOptions read FFolderMonitor_Options write SetFolderMonitor_Options;
    property FolderMonitor_Actions: TWatchActions read FFolderMonitor_Actions write SetFolderMonitor_Actions;
    property FolderMonitor_TimerInterval: cardinal read FFolderMonitor_TimerInterval
      write SetFolderMonitor_TimerInterval;
{$ENDIF}
    property MetaData_Options: TThumbsbrowser_MetaData_Options read fMetaData_Options write fMetaData_Options;
    property InternetOptions: TTB_Browser_InternetParams read fInternetOptions;

    property DragDropOptions: TThumbsBrowser_DragDropOptions read fDragDropOptions write fDragDropOptions;
    property FileScanner_MaxTransfer: integer read FFileScanner_MaxTransfer write SetFileScanner_MaxTransfer;

    property MultiThread: boolean read GetMultithread write SetMultithread;
    property MultiThread_Pool_Count: integer read GetMultithread_Pool_Count write SetMultithread_Pool_Count;
    property MultiThread_Timeout: dword read fMultithread_Timeout write SetMultiThread_Timeout;

    property BrowsingOrientation: TTB_Browser_Orientation read fBrowserOrientation write SetbrowserOrientation;
    property MaxRows: integer read fMaxRows write SetMaxRows;
    property MaxCols: integer read fMaxCols write SetMaxCols;
    property Centered: boolean read fCentered write SetCentered;

{$IFDEF TB_USEDB}
    property DB: TThumbsBrowser_DB read fDB;
{$ENDIF}
    property DragScrollInterval: cardinal read GetDragScrollInterval write SetDragScrollInterval;

    property FileThumbs: boolean read fFileThumbs write SetFileThumbs;
    property FolderThumbs: boolean read fFolderThumbs write SetFolderThumbs;
    property NavMemory: boolean read fNavMemory write fNavMemory;
    property NavMemoryMaxThumbs: cardinal read fNavMemMaxThumbs write setNavMemMaxThumbs;

    property FolderDefault: TThumbsBrowserDeafultFolder read fFolderDefault write SetFolderDefault;
    property FolderCurrent: string read fFolderCurrent write SetFolderCurrent;

    property FolderUpNavThumb: boolean read fFolderUpNavThumb write SetFolderUpNavThumb;
    property FolderNavigation: boolean read fFolderNavigation write SetFolderNavigation;
    property FolderCheckBoxes: boolean read fFolderCheckBoxes write SetFolderCheckBoxes;
    property FolderTitles: boolean read fFolderTitles write SetFolderTitles;

    property FileOptions: TThumbsbrowser_FileDisplay_Options read fFileOptions write fFileOptions;

    property BackgroundType: TTB_Browser_BackgroundType read fBackgroundType write SetBackgroundType;
    property BackgroundColor: TColor read fBackgroundColor write SetBackgroundColor;
    property Background2ndColor: TColor read fBackground2ndColor write SetBackground2ndColor;

    property StyleOptions: TTB_Browser_StyleOptions read fStyleOptions write SetStyleOptions;
    property MultiSelect: boolean read fMultiSelect write SetMultiSelect;

    property ThumbSize: cardinal read GetThumbSize write SeTThumbsize;
    property ThumbSizeW: cardinal read GetThumbsizeW write SeTThumbsizeW;
    property ThumbSizeH: cardinal read GetThumbsizeH write SeTThumbsizeH;

    property Buffer_ThumbSize: integer read GetBuffer_ThumbSize write SetBuffer_ThumbSize;
    property StoreType: TTB_Thumb_StoreType read GetStoreType write SetStoreType;

    property ThumbsMouseOverOptions: TTB_Thumb_MouseOverOptions read GetThumbsMouseOverOptions
      write SetThumbsMouseOverOptions;

    property ThumbsFrameBgColor: TColor read GetThumbsFrameBgColor write SetThumbsFrameBgColor;
    property ThumbsFrameBgSelectedColor: TColor read GetThumbsFrameBgSelectedColor write SetThumbsFrameBgSelectedColor;

    property ThumbsCaptionFontColor: TColor read GetThumbsCaptionFontColor write SetThumbsCaptionFontColor;
    property ThumbsCaptionFontSelectedColor: TColor read GetThumbsCaptionFontSelectedColor
      write SetThumbsCaptionFontSelectedColor;
    property ThumbsCaptionBackColor: TColor read GetThumbsCaptionBackColor write SetThumbsCaptionBackColor;
    property ThumbsCaptionBackSelectedColor: TColor read GetThumbsCaptionBackSelectedColor
      write SetThumbsCaptionBackSelectedColor;

    property ThumbsTopTitleFontColor: TColor read GetThumbsTopTitleFontColor write SetThumbsTopTitleFontColor;
    property ThumbsTopTitleFontSelectedColor: TColor read GetThumbsTopTitleFontSelectedColor
      write SetThumbsTopTitleFontSelectedColor;
    property ThumbsTopTitleBackColor: TColor read GetThumbsTopTitleBackColor write SetThumbsTopTitleBackColor;
    property ThumbsTopTitleBackSelectedColor: TColor read GetThumbsTopTitleBackSelectedColor
      write SetThumbsTopTitleBackSelectedColor;

    property ThumbsBottomTitleFontColor: TColor read GetThumbsBottomTitleFontColor write SetThumbsBottomTitleFontColor;
    property ThumbsBottomTitleFontSelectedColor: TColor read GetThumbsBottomTitleFontSelectedColor
      write SetThumbsBottomTitleFontSelectedColor;
    property ThumbsBottomTitleBackColor: TColor read GetThumbsBottomTitleBackColor write SetThumbsBottomTitleBackColor;
    property ThumbsBottomTitleBackSelectedColor: TColor read GetThumbsBottomTitleBackSelectedColor
      write SetThumbsBottomTitleBackSelectedColor;

    property ThumbsFrameBorderColor: TColor read GetThumbsFrameBorderColor write SetThumbsFrameBorderColor;
    property ThumbsFrameBorderSelectedColor: TColor read GetThumbsFrameBorderSelectedColor
      write SetThumbsFrameBorderSelectedColor;

    property ThumbsFrameSize: cardinal read GetThumbsFrameSize write SetThumbsFrameSize;

    property ThumbsFrameRoundnessPerc: cardinal read GetThumbsFrameRoundnessPerc write SetThumbsFrameRoundnessPerc;
    property ThumbsCaptionRoundnessPerc: cardinal read GetThumbsCaptionRoundnessPerc
      write SetThumbsCaptionRoundnessPerc;
    property ThumbsTitleRoundnessPerc: cardinal read GetThumbsTitleRoundnessPerc write SetThumbsTitleRoundnessPerc;

    property ThumbsBackOpacity: cardinal read GetThumbsBackOpacity write SetThumbsBackOpacity;
    property ThumbsBackOpacitySelected: cardinal read GetThumbsBackOpacitySelected write SetThumbsBackOpacitySelected;

    property ThumbsFrameBgOpacity: cardinal read GetThumbsFrameBgOpacity write SetThumbsFrameBgOpacity;
    property ThumbsFrameBgOpacitySelected: cardinal read GetThumbsFrameBgOpacitySelected
      write SetThumbsFrameBgOpacitySelected;

    property ThumbsFrameBorderOpacity: cardinal read GetThumbsFrameBorderOpacity write SetThumbsFrameBorderOpacity;
    property ThumbsFrameBorderOpacitySelected: cardinal read GetThumbsFrameBorderOpacitySelected
      write SetThumbsFrameBorderOpacitySelected;

    property ThumbsCaptionOpacity: cardinal read GetThumbsCaptionOpacity write SetThumbsCaptionOpacity;
    property ThumbsCaptionOpacitySelected: cardinal read GetThumbsCaptionOpacitySelected
      write SetThumbsCaptionOpacitySelected;

    property ThumbsTitleOpacity: cardinal read GetThumbsTitleOpacity write SetThumbsTitleOpacity;
    property ThumbsTitleOpacitySelected: cardinal read GetThumbsTitleOpacitySelected
      write SetThumbsTitleOpacitySelected;

    property ThumbsTitleDrawFocusRectIfEmpty: boolean read GetThumbsTitleDrawFocusRectIfEmpty
      write SetThumbsTitleDrawFocusRectIfEmpty;

    property ThumbsBackPadding_Left: integer read GetThumbsBackPadding_Left write SetThumbsBackPadding_Left;
    property ThumbsBackPadding_Right: integer read GetThumbsBackPadding_Right write SetThumbsBackPadding_Right;
    property ThumbsBackPadding_Bottom: integer read GetThumbsBackPadding_Bottom write SetThumbsBackPadding_Bottom;
    property ThumbsBackPadding_Top: integer read GetThumbsBackPadding_Top write SetThumbsBackPadding_Top;

    property ThumbsFramePadding_Left: integer read GetThumbsFramePadding_Left write SetThumbsFramePadding_Left;
    property ThumbsFramePadding_Right: integer read GetThumbsFramePadding_Right write SetThumbsFramePadding_Right;
    property ThumbsFramePadding_Top: integer read GetThumbsFramePadding_Top write SetThumbsFramePadding_Top;
    property ThumbsFramePadding_Bottom: integer read GetThumbsFramePadding_Bottom write SetThumbsFramePadding_Bottom;

    property ThumbsSpacing: cardinal read GetThumbsSpacing write SetThumbsSpacing;
    property ThumbsSpacingX: cardinal read fspacingX write SetThumbsSpacingX;
    property ThumbsSpacingY: cardinal read fspacingY write SetThumbsSpacingY;

    property ResampleMethod: TResamplefilter read GetResampleMethod write SetResampleMethod;
    property DisplayMethod: TResamplefilter read GetDisplayMethod write SetDisplayMethod;

    property FilterExclude: string read fFilterExclude write SetFilterExclude;
    property Filter: string read fFilter write SetFilter;

    property PopupDefaultExplorer: boolean read fPopupDefaultExplorer write fPopupDefaultExplorer;

    property ShowThumbnailHint: boolean read fShowThumbnailHint write SetShowThumbnailHint;
    property ShowTopTitle: boolean read fShowTopTitle write SetShowTopTitle;
    property ShowBottomTitle: boolean read fShowBottomTitle write SetShowBottomTitle;

    property ShowCaptions: boolean read fShowCaptions write SetShowCaptions;
    property ThumbCaption_Settings: TTB_Thumb_CaptionsSettings read GetThumbCaption_Settings
      write SetThumbCaption_Settings;
    property ThumbCaptionIncludeInFrame: boolean read GetThumbCaptionIncludeInFrame write SetThumbCaptionIncludeInFrame;
    property ThumbDropShadow: TTB_Thumb_DropShadowOptions read fThumbDropShadow write SetThumbDropShadow;

    // warning if you change the name of this property you need to change also
    // the hardcoded string in the property definition method: DefineProperties
    // this property has special handling to allow the user to set a empty string as a value in the object inspector
    property ThumbCaption_MissingText: string read GetThumbCaption_MissingText write SetThumbCaption_MissingText
      stored false;

    property ThumbLayoutType: TTB_Thumb_Layout_Type read GetThumbLayoutType write SetThumbLayoutType;
    // property ThumbCaptionSizePerc_HorzLayout: cardinal read GetThumbCaptionSizePerc_HorzLayout write SetThumbCaptionSizePerc_HorzLayout;

    property ThumbDefaultChecked: boolean read fThumbDefaultChecked write fThumbDefaultChecked;

    property ShowRatingBox: boolean read fShowRatingBox write SetShowRatingBox;
    property ShowCheckBoxes: boolean read fShowCheckBoxes write SetShowCheckBoxes;
    property ShowRotateButtons: boolean read fShowRotateButtons write SetShowRotateButtons;
    property ShowInfoButton: boolean read fShowInfoButton write SetShowInfoButton;

    property SortType: TTB_Browser_SortType read fSortType write SetSorttype;

{$IFDEF TB_FOLDERMONITOR}
    property OnFolderMonitorEvent: TThumbsBrowserFolderMonitorEvent read fOnFolderMonitorEvent
      write fOnFolderMonitorEvent;
{$ENDIF}
    property OnCaptionsOrderChanged: TNotifyEvent read fOnCaptionsOrderChanged write fOnCaptionsOrderChanged;

    property OnThumbVisibilityChange: TThumbsBrowserOnThumbEvent read fOnThumbVisibilityChange
      write fOnThumbVisibilityChange;
    property OnThumbSelectionChange: TThumbsBrowserOnThumbEvent read fOnThumbSelectionChange
      write fOnThumbSelectionChange;
    property OnThumbCheckStateChange: TThumbsBrowserOnThumbEvent read fOnThumbCheckStateChange
      write fOnThumbCheckStateChange;

    property OnThumbCanSelect: TThumbsBrowserOnThumbCancelEvent read fOnThumbCanSelect write fOnThumbCanSelect;
    property OnThumbCanDeSelect: TThumbsBrowserOnThumbCancelEvent read fOnThumbCanDeSelect write fOnThumbCanDeSelect;

    property OnThumbBufferLoaded: TThumbsBrowserOnThumbBufferLoaded read fOnThumbBufferLoaded
      write SetOnThumbBufferLoaded;
    property OnThumbMouseOver: TThumbsBrowserOnThumbMouseOverEvent read fOnThumbMouseOver write fOnThumbMouseOver;

    property OnThumbAdded: TThumbsBrowserOnThumbEvent read fOnThumbAdded write fOnThumbAdded;
    property OnThumbCanAdd: TThumbsBrowserOnThumbCancelEvent read fOnThumbCanAdd write fOnThumbCanAdd;

    property OnThumbLayoutAssigned: TThumbsBrowserOnThumbEvent read fOnThumbLayoutAssigned write fOnThumbLayoutAssigned;
    property OnThumbLoadDemand: TThumbsBrowserOnThumbEvent read fOnThumbLoadDemand write fOnThumbLoadDemand;
    property OnThumbLoadDemandAsync: TThumbsBrowser_Thumb_LoadThread_Event read fOnThumbLoadDemandAsync
      write fOnThumbLoadDemandAsync;
    property OnThumbLoaded: TThumbsBrowserOnThumbEvent read fOnThumbLoaded write fOnThumbLoaded;
    property OnThumbCheckSpecialCase: TThumbsBrowserOnThumbEvent read fOnThumbCheckSpecialCase
      write fOnThumbCheckSpecialCase;

    property OnThumbCanDelete: TThumbsBrowserOnThumbCancelEvent read fOnThumbCanDelete write fOnThumbCanDelete;
    property OnThumbDelete: TThumbsBrowserOnThumbEvent read fOnThumbDelete write fOnThumbDelete;

    property OnThumbClickedEX: TThumbsBrowserOnThumbClickedEXEvent read fOnThumbClickedEX write fOnThumbClickedEX;
    property OnThumbClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbClicked write fOnThumbClicked;
    property OnThumbCaptionClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbCaptionClicked
      write fOnThumbCaptionClicked;
    property OnThumbCheckClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbCheckClicked
      write fOnThumbCheckClicked;
    property OnThumbInfoClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbInfoClicked write fOnThumbInfoClicked;
    property OnThumbRotateClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbRotateClicked
      write fOnThumbRotateClicked;

    property OnThumbTopTitleClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbTopTitleClicked
      write fOnThumbTopTitleClicked;
    property OnThumbBottomTitleClicked: TThumbsBrowserOnThumbClickedEvent read fOnThumbBottomTitleClicked
      write fOnThumbBottomTitleClicked;

    property OnItemHintText: TTB_Browser_OnItemHintText read fOnItemHintText write fOnItemHintText;
    property OnItemCustomDrawPicture: TTB_Browser_OnItemCustomDraw read fOnItemCustomDrawPicture
      write fOnItemCustomDrawPicture;
    property OnItemCustomDrawFrame: TTB_Browser_OnItemCustomDraw read fOnItemCustomDrawFrame
      write fOnItemCustomDrawFrame;
    property OnItemCustomDrawCaption: TTB_Browser_OnItemCustomDrawText read fOnItemCustomDrawCaption
      write fOnItemCustomDrawCaption;
    property OnItemCustomDrawThumbBg: TTB_Browser_OnItemCustomDraw read fOnItemCustomDrawThumbBg
      write fOnItemCustomDrawThumbBg;
    property OnItemCustomDrawAfterDraw: TTB_Browser_OnItemCustomDraw read fOnItemCustomDrawAfterDraw
      write fOnItemCustomDrawAfterDraw;

    property OnItemCustomDrawTopTitle: TTB_Browser_OnItemCustomDrawText read fOnItemCustomDrawTopTitle
      write fOnItemCustomDrawTopTitle;
    property OnItemCustomDrawBottomTitle: TTB_Browser_OnItemCustomDrawText read fOnItemCustomDrawBottomTitle
      write fOnItemCustomDrawBottomTitle;

    property OnInfoFormClosed: TNotifyEvent read fOnInfoFormClosed write fOnInfoFormClosed;
    property OnInfoFormOpened: TNotifyEvent read fOnInfoFormOpened write fOnInfoFormOpened;

    property OnItemSearchCompare: TThumbsBrowserOnSearchCompare read fOnSearchCompare write fOnSearchCompare;
    property OnItemCustomSortCompare: TThumbsBrowserOnSortCompare read fOnCustomSortCompare write fOnCustomSortCompare;
    // property OnDragRequest: Tnotifyevent read fOnDragRequest write fOnDragRequest;

    property OnAcceptExplorerDragDrop: TThumbsBrowser_DragDropAcceptEvent read fOnAcceptExplorerDragDrop
      write fOnAcceptExplorerDragDrop;
    property OnExplorerDragDrop: TThumbsBrowser_ExplorerDragDropEvent read fOnExplorerDragDrop
      write fOnExplorerDragDrop;

    property OnAcceptNativeDragDrop: TThumbsBrowser_DragDropAcceptEvent read fOnAcceptNativeDragDrop
      write fOnAcceptNativeDragDrop;
    property OnNativeDragDrop: TThumbsBrowser_NativeDragDropEvent read fOnNativeDragDrop write fOnNativeDragDrop;

    property OnWIAProgress: TTB_Browser_ProgressEvent read fOnWIAProgress write fOnWIAProgress;
    property OnWPDProgress: TTB_Browser_ProgressEvent read fOnWPDProgress write fOnWPDProgress;
    property OnProgress: TIEProgressEvent read fOnProgress write fOnProgress;

    property OnStartedLoading: TNotifyEvent read fOnStartedLoading write fOnStartedLoading;
    property OnfinishedLoading: TNotifyEvent read fOnfinishedLoading write fOnfinishedLoading;
    property OnInitialized: TTB_Browser_OnInitializedEvent read fOnInitialized write fOnInitialized;
    property OnAllThumbsLoaded: TNotifyEvent read fOnAllThumbsLoaded write fOnAllThumbsLoaded;
    property OnNavigateFolder: TTB_Browser_OnNavigateFolderEvent read fOnNavigateFolder write fOnNavigateFolder;
    property OnNavigateWPDFolder: TTB_Browser_OnNavigateWPDFolderEvent read fOnNavigateWPDFolder
      write fOnNavigateWPDFolder;

    property OnMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent read fOnMetadataVisibility
      write fOnMetadataVisibility;

    property OnResize;
    property OnCanResize;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDrag;
  end;

  // ----------------------------------------------------------------------------
  TThumbsLoader = class(TThread)
  private
    { Private declarations }
    fAllowSyncOnTerminate: boolean;
    fWaitAllCompleted: boolean;
    fThumbLoadDemandAsyncHandler: TThumbsBrowser_Thumb_LoadThread_Event;
    fPauseCount: integer;
    fCleanupCS: TCriticalSection;
    fThumbReader: TTB_Browser_FileReaderFunction;
    fRunning, fRunningSynch: boolean;
    fMultithread: boolean;
    fMultiCleaned: boolean;
    fLastThreadCount, fThreadPool_count, fDynThreadPool_count: integer;
    fThreadTimeout: dword;

    fPriorityN, fPriorityL, fChildrenPriority: TThreadPriority;

    fDBSessionGuid: TGuid;
    fBrowser: TThumbsBrowser;
    fAllThumbs: TNamedList; // List Pointer to the thumbs in the browser
    fInitThumbs: TNamedList;

    fThumbsToExplore: TList; // thumbs to be explored
    fDoneThumbs: TThreadList;
    fThreads: TThreadList;
    fNewThreads: TList;
    fCurrentLoadedThumb: TThumbEx;
    fSuggestionInterval, fcurrent, fsuggestedcurrent, fLastTop: integer;
    fLastWaitResult: TWaitResult;
    fSuggestTikCount: integer;
    fAllExplored: boolean;

    fVisibleExploredCtr, fVisibleExploredCtr_Last: integer;

    fOnDebug: TNotifyEvent;
    fOnThumbLoaded: TTB_Browser_OnThumbLoadedEvent;
    fOnAllThumbsLoaded: TNotifyEvent;
    fOnBeforeThumbLoaded: TNotifyEvent;
    fOnInitialized: TNotifyEvent;
    fFolder: string;
    fFileList: TStringList;
    fUrlList: TStringList;
    fWPDList: TStringList;
    fScannerList: TThumbsBrowser_ScanFilesThread_FileRcds;

    TBCriticalSection: TCriticalSection;
    TBDatabaseCriticalSection: TCriticalSection;

    TBEvent: TEvent;
    TBEventCounter: TThumbsBrowser_Thumb_LoadThread_Counter;

    procedure Handle_ThumbThread_Done(sender: TThread; theThumb: TThumbEx);

    function GetRunning: boolean;
    procedure SetRunning(bValue: boolean);
    procedure SetRunningSynch;

    procedure GetSuggestedCurrent;

    procedure CurrentThumb_Explore;
    procedure CurrentThumb_Set;
    procedure CurrentThumb_ReadFromFile;

    function CurrentThumb_CheckRead_FromDB: TTB_DB_ThumbExistResult;
    procedure CurrentThumb_CheckWrite_ToDB(ThumbExistResult: TTB_DB_ThumbExistResult);

    procedure ExploredThumbs_Set;
    procedure ExploredThumbs_CreateThreads;
    procedure ExploredThumbs_LaunchThreads;

    procedure FillThumbsToExplore;

    procedure FireOnBeforeThumbLoaded;

    function AppendThumb(sr: TSearchRec; thefolder_slashed: string): TThumbEx; overload;
    function InsertThumb(position: integer; sr: TSearchRec; thefolder_slashed: string): TThumbEx; overload;
    function ReplaceOldThumb(position: integer; sr: TSearchRec; thefolder_slashed: string): TThumbEx; overload;
{$IFDEF TB_PORTABLEDEVICE}
    function AppendThumb(WPDObj: TIEWPDObject): TThumbEx; overload;
    function InsertThumb(position: integer; WPDObj: TIEWPDObject): TThumbEx; overload;
    function ReplaceOldThumb(position: integer; WPDObj: TIEWPDObject): TThumbEx; overload;
{$ENDIF}
    function FileThumb_Exists(FileName: string; filedate: Tdatetime; filesize: integer; const bPathWasPresent: boolean)
      : TTB_DB_ThumbExistResult; overload;
    function FileThumb_Exists(FileName: string; const bPathWasPresent: boolean): TTB_DB_ThumbExistResult; overload;

    function Thumb_Set(theThumb: TThumbEx; ID: integer): boolean;
    function Thumb_CheckRead_FromDB(theThumb: TThumbEx): TTB_DB_ThumbExistResult;
    procedure Thumb_CheckWrite_ToDB(theThumb: TThumbEx; ThumbExistResult: TTB_DB_ThumbExistResult);

    procedure Thumb_ReadFromFile(theThumb: TThumbEx);

    procedure CheckAllExplored;
    procedure DOOnBeforeTerminate;

    procedure PassUrlList(theUrlList: TStringList);
    function InitializeLoadingFromUrlList: boolean;
    function InitializeLoading_FromFolder: boolean;
    function InitializeLoadingFromFileList: boolean;
    function InitializeLoadingFromScannerList: boolean;
    function InitializeLoading_FromExistingPaths: boolean;
    procedure InitializeLoading;

{$IFDEF TB_PORTABLEDEVICE}
    function InitializeLoadingFromWPDList: boolean;
    procedure HandleNewWPDRecord(WPDObj: TIEWPDObject);
    function WPDThumb_Exists(WPDObj: TIEWPDObject): TTB_DB_ThumbExistResult;
{$ENDIF}
    function FindNextVisibleNotLoaded(Idx: integer; const bAllowRewind: boolean): integer;
    function RemoveThread(theThread: TThread): boolean;
    function AddThread(theThread: TThread): boolean;
    function CheckThreadsCount: integer;
    function ClearDoneThumbs: boolean;
    function AddDoneThumb(theThumb: TThumbEx): boolean;
    function CheckDoneThumbsCount: integer;
    procedure ClearThumbsToExplore(StatusesToClear: TTB_Thumb_ExploringStatuses);
    procedure CleanUpMultithread;
    function CheckAllTerminated(const waitTime: dword): TWaitResult;
    procedure CheckAllVisibleThumbsLoaded;
    procedure InitMultithread;
    procedure ExpectLeaksThumbsToExplore;
    procedure PassWPDList(theWPDList: TStringList);
    function GetSuggestedCurrentFromVisibleRange(defaultValue: integer; topIdx, bottomIdx: integer): integer;
    procedure HandleSearchRecordAction(sr: TSearchRec; const thefolder_slashed: string;
      testThumbExists: TTB_DB_ThumbExistResult; var Counter: integer);
    function GetOptimalThreadPriority(ctr: integer; theThumb: TThumbEx): TThreadPriority;
    function FindThumbByGUID(theGuid: TGuid): TThumbEx;
    procedure ResetExploringStatus_Unloaded;
    procedure AbortThreads;

  protected
    { Protected declarations }
    property Running: boolean read GetRunning;

    property Browser: TThumbsBrowser read fBrowser;
    property Folder: string read fFolder write fFolder;

    property ThreadTimeout: dword read fThreadTimeout write fThreadTimeout;

    property OnDebug: TNotifyEvent read fOnDebug write fOnDebug;

    property OnThumbLoaded: TTB_Browser_OnThumbLoadedEvent read fOnThumbLoaded write fOnThumbLoaded;
    property OnAllThumbsLoaded: TNotifyEvent read fOnAllThumbsLoaded write fOnAllThumbsLoaded;
    property OnBeforeThumbLoaded: TNotifyEvent read fOnBeforeThumbLoaded write fOnBeforeThumbLoaded;
    property OnInitialized: TNotifyEvent read fOnInitialized write fOnInitialized;

    procedure PassScannerList(theList: TThumbsBrowser_ScanFilesThread_FileRcds);
    procedure PassFileList(theFileList: TStringList);
    procedure HandleNewScannerRecord(scanner_record: TThumbsBrowser_ScanFilesThread_FileRcd);
    procedure HandleNewFileSearchRecord(sr: TSearchRec; const bIsUrl: boolean; const bAddToExisitingPaths: boolean;
      const thefolder_slashed: string; var Counter: integer);

    procedure Init(theFolder: string; theFileList: TStringList; theUrlList: TStringList; theWPDList: TStringList;
      theScannerList: TThumbsBrowser_ScanFilesThread_FileRcds);

    procedure Pause;
    procedure Unpause;

    procedure GetReader;
    procedure Execute; override;

    function Synchronize(method: TThreadMethod): boolean; reintroduce;
  public
    { Public declarations }

    constructor Create(theDBSessionGuid: TGuid; theBrowser: TThumbsBrowser; bMultithread: boolean;
      theMultithread_Pool_Count: integer; theMultithread_Timeout: dword);
    destructor Destroy; override;

    procedure Terminate(bFreeOnTerminate: boolean; bWaitAllCompleted: boolean); reintroduce;

  end;

implementation

{$R '..\_res\TB\NWSComps_ThumbsBrowser.RES' }

uses shlobj,
{$IFDEF TB_MULTIBITMAP}
  iemio,
{$ENDIF}
{$IFDEF TB_GDIPLUS}
  nwscomps_gdiplus,
{$ENDIF}
  NWSComps_ThumbsBrowser_utils_Const,
  NWSComps_ThumbsBrowser_utils,
  NWSComps_ThumbsBrowser_RES, NWSComps_ThumbsBrowser_RES_CONST;

var

{$IFDEF TB_FOLDERMONITOR}
  SharedFolderMonitor: TThumbsBrowser_FolderMonitor;
{$ENDIF}
  SharedDragDrop_Handler: TThumbsBrowser_DragDropHandler;

procedure DoubleBufferTrick(const bScrolling: boolean; theControl: TControl);
begin

  // we have to code this because of a delphi vcl or microsoft windows bug
  // painting of the scrollbar component is not done correctly on double buffered controls

  if assigned(theControl.Parent) and (theControl.Parent is TWinControl) then
  begin
    (* twincontrol(theControl.parent).DoubleBuffered := not bScrolling; *)
    if TWinControl(theControl.Parent).DoubleBuffered then
      TWinControl(theControl.Parent).DoubleBuffered := false;

  end;

end;

function EnsureFileExt(ext: string): string;
begin
  if (length(ext) = 0) or (ext[1] = '.') then
    result := ''
  else
    result := '.' + ext;
end;

procedure TB_ManualThumb_Init(theThumb: TThumbEx);
begin
  theThumb.Originator := tborig_Manual;
  theThumb.SetAdjournedFalse(theThumb.Unique_Name);
end;

procedure TB_ManualThumb_InitFromFile(theThumb: TThumbEx; const theFilename: string; const bRecreateSearchRec: boolean);
var
  sr: TSearchRec;
  sDecodedUrl: string;
begin
  if bRecreateSearchRec or (theThumb.searchrec.size <= 0) then // searchrec cannot be uninitialized
  begin
    if tbs_UrlIsValidUrl(theFilename) then
    begin
      sr := theThumb.searchrec;
      sr.Attr := TBCONST_SR_ATTR_URL;

      sDecodedUrl := tbs_UrlDecode(theFilename);
      sr.Name := tbs_UrlExtractFilename(sDecodedUrl, false);
      sr.Attr := TBCONST_SR_ATTR_URL; // this identifies urls

      theThumb.InitFromSearchRecord(sr, tbs_UrlExtractPath(sDecodedUrl, false));
    end
    else
    begin
      if FindFirst(theFilename, faAnyfile, sr) = 0 then
      begin
        try
          theThumb.InitFromSearchRecord(sr, Tbs_AddSlash(extractfilepath(theFilename)));
        finally
          FindClose(sr);
        end;
      end;
    end;
  end;
end;

procedure TB_ManualThumb_RetrieveFromFile(theThumb: TThumbEx; const theFilename: string;
  ReaderFunction: TTB_Browser_FileReaderFunction; const bRecreateSearchRec: boolean);
var
  aFormat: TTB_Browser_FileFormat;
  dummyIO: TImageenio;
begin
  TBFileFormat_GetEmptyFormat(aFormat);
  aFormat.ReaderFunction := ReaderFunction;

  TB_ManualThumb_InitFromFile(theThumb, theFilename, bRecreateSearchRec);

  if theThumb.SourceType = st_URL then
    theThumb.RetrieveFromUrl(theFilename)
  else
  begin
    theThumb.RetrieveFromSourceFile(theFilename, aFormat, nil, false, dummyIO);
    // correct thumb orientation even in case there was no exif thumb
    if (theThumb.MetaOptions.UseExifOrientationForThumbs) then
      TBAdjustEXIFOrientation(theThumb.IEBitmap, theThumb.SourceEXIF_Orientation);
  end;
end;





// Class TThumbsScrollbar--------------------------------

constructor TThumbsScrollbar.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TThumbsScrollbar.Destroy;
begin

  inherited;
end;

procedure TThumbsScrollbar.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  DoubleBufferTrick(false, self.Parent);
end;

procedure TThumbsScrollbar.CMMouseEnter(var Message: TMessage);
begin
  inherited;

  DoubleBufferTrick(true, self.Parent);
end;







// --------------------------------------------------------

Constructor TThumbsBrowser_DragDropHandler.Create;
begin
  inherited Create(nil);

  fDragFiles := nil;

  fDynTransferMode_TB := GetDynTransferModeTB(false);
  fDynTransferMode_Exp := GetDynTransferModeExp(false);

  fDragScrollInterval := 200;
  fDraggingActive := false;

  ResetDragDropParams;

end;

Destructor TThumbsBrowser_DragDropHandler.Destroy;
begin
  if assigned(fTimer) then
    Freeandnil(fTimer);

  inherited Destroy;
end;

function TThumbsBrowser_DragDropHandler.FindDropControl(theMousePt: TPoint): TWinControl;
begin
  result := FindVCLWindow(theMousePt);
end;

function TThumbsBrowser_DragDropHandler.FindDropTarget(theMousePt: TPoint): TThumbsBrowser;
var
  aCtrl: TWinControl;
begin
  aCtrl := FindDropControl(theMousePt);

  if assigned(aCtrl) and (aCtrl is TThumbsBrowser) then
    result := TThumbsBrowser(aCtrl)
  else
    result := nil;
end;

function TThumbsBrowser_DragDropHandler.GetDynTransferModeTB(bShift: boolean): TThumbsBrowser_DragDropTransferMode;
begin
  result := dd_Copy;
  if not assigned(fDragSource) then
    result := dd_Copy
  else
  begin

    case fDragSource.DragDropOptions.TransferMode_TB of
      dd_Copy:
        result := dd_Copy;
      dd_Move:
        result := dd_Move;
      dd_DetectShiftState:
        if bShift then
          result := dd_Copy
        else
          result := dd_Move;
    end;
  end;
end;

function TThumbsBrowser_DragDropHandler.GetDynTransferModeExp(bShift: boolean): TThumbsBrowser_DragDropTransferMode;
begin
  result := dd_Copy;
  if not assigned(fDragSource) then
    result := dd_Copy
  else
  begin

    case fDragSource.DragDropOptions.TransferMode_Exp of
      dd_Copy:
        result := dd_Copy;
      dd_Move:
        result := dd_Move;
      dd_DetectShiftState:
        if bShift then
          result := dd_Copy
        else
          result := dd_Move;
    end;
  end;
end;

procedure TThumbsBrowser_DragDropHandler.HandleTimer(sender: TObject);
var

  aPt, aClientPt: TPoint;
  aTargetTB: TThumbsBrowser;
  DeltaScroll: integer;
  athumb: TThumbEx;

  bAllowed: boolean;

  aCtrl: TWinControl;
begin
  if not fDraggingActive then
    EXIT;
  if not(assigned(fDragSource)) then
    EXIT;

  aPt := mouse.CursorPos;
  aTargetTB := FindDropTarget(aPt);

  bAllowed := false;

  if fDragSource.DragDropOptions.IS_DragSource_TB and assigned(aTargetTB) then
  begin
    CheckCursor(aTargetTB, aPt.X, aPt.Y, bAllowed);

    aClientPt := aTargetTB.ScreenToClient(aPt);

    if bAllowed then
    begin
      NotifyDragOverRequest(aTargetTB, aClientPt);

      case aTargetTB.BrowsingOrientation of
        tbo_horz:
          begin
            DeltaScroll := aTargetTB.fpassox div 4;
            if aClientPt.X > aTargetTB.fDisplayBackBuffer.Width - DeltaScroll then
              aTargetTB.SetVirtualScroll_Position(aTargetTB.fScrollParams.Display_Pos + DeltaScroll)
            else if aClientPt.X < DeltaScroll then
              aTargetTB.SetVirtualScroll_Position(aTargetTB.fScrollParams.Display_Pos - DeltaScroll)
          end;
        tbo_vert:
          begin
            DeltaScroll := aTargetTB.fpassoy div 4;
            if aClientPt.Y > aTargetTB.fDisplayBackBuffer.Height - DeltaScroll then
              aTargetTB.SetVirtualScroll_Position(aTargetTB.fScrollParams.Display_Pos + DeltaScroll)
            else if aClientPt.Y < DeltaScroll then
              aTargetTB.SetVirtualScroll_Position(aTargetTB.fScrollParams.Display_Pos - DeltaScroll);
          end;
      end;

      Insertidx := aTargetTB.Detect_DragDrop_Insertpoint(aClientPt.X, aClientPt.Y);

      athumb := aTargetTB.Thumbat(Insertidx);
      if assigned(athumb) then
      begin
        InsertPt.X := aTargetTB.XThumb2Browser(0, Insertidx) - aTargetTB.fspacingX;
        {
          if InsertIdx < aTargetTB.Thumbscount-1 then
          InsertPt.x := aTargetTB.XThumb2Browser(0,Insertidx) - aTargetTB.fspacingX
          else
          InsertPt.x := aTargetTB.XThumb2Browser(aThumb.totalwidth,Insertidx) + aTargetTB.fspacingX;
        }

        InsertPt.Y := aTargetTB.YThumb2Browser(0, Insertidx);

        aTargetTB.canvas.Brush.Color := aTargetTB.BackgroundColor;
        aTargetTB.canvas.fillrect(rect(PreviousInsertPt.X - 1, PreviousInsertPt.Y, PreviousInsertPt.X + 1,
          PreviousInsertPt.Y + athumb.TotalHeight));

        aTargetTB.RefreshThumb(PreviousInsertIdx - 1, true);
        aTargetTB.RefreshThumb(PreviousInsertIdx, true);

        PreviousInsertPt := InsertPt;
        PreviousInsertIdx := Insertidx;

        aTargetTB.canvas.Brush.Color := aTargetTB.ThumbsFrameBorderSelectedColor;
        aTargetTB.canvas.fillrect(rect(InsertPt.X - 1, InsertPt.Y, InsertPt.X + 1, InsertPt.Y + athumb.TotalHeight));
      end;
    end;
  end
  else
  begin
    CheckCursor(nil, aPt.X, aPt.Y, bAllowed);
    if bAllowed then
    begin
      NotifyDragOverRequest(nil, point(0, 0));

      if fDragSource.DragDropOptions.IS_DragSource_Explorer then
      begin
        aCtrl := FindDropControl(aPt);
        if (not assigned(aCtrl)) // if outside any control on the form
          Or (not fDragSource.DragDropOptions.IS_DragSource_TB) then // or native dragdrop not allowed from this source
        begin
          StartExternalDragDrop; // starts explorer dragdrop
        end;
      end;
    end;
  end;
end;

procedure TThumbsBrowser_DragDropHandler.StartExternalDragDrop;
  procedure GetFileNames(theFileNames: TStringList; theTB: TThumbsBrowser);
  var
    I: integer;
  begin
    theFileNames.clear;
    for I := 0 to theTB.SelectedThumbs.Count - 1 do
    begin
      theFileNames.Add(theTB.GetSelected(I).SourceFileName);
    end;

  end;

var
  ssFilenames: TStringList;
begin
  if not assigned(fDragSource) then
    EXIT;

  if assigned(fDragFiles) then
  begin
    try
      fDragFiles.Free;
      fDragFiles := nil;
    except
      EXIT;
    end;
  end;

  fDragFiles := TIEFileDragDrop.Create(fDragSource, nil);
  fDragFiles.ActivateDropping := false;
  ssFilenames := TStringList.Create;
  try
    GetFileNames(ssFilenames, fDragSource);

    // fDragRequest_Sender.RefreshDisplay;
    StopDragDrop; // stop internal drag drop before starting external
    fDynTransferMode_Exp := GetDynTransferModeExp(GetAsyncKeyState(VK_SHIFT) <> 0);

    if (fDynTransferMode_Exp = dd_Copy) then
      fDragFiles.InitiateDragging(ssFilenames, [iedaCopy])
    else
      fDragFiles.InitiateDragging(ssFilenames, [iedaMove]);

  finally
    ssFilenames.Free;
  end;
end;

function TThumbsBrowser_DragDropHandler.CheckDragDropAllowed(theCtrl: TWinControl): boolean;
begin

  result := false;
  if not assigned(fDragSource) then
    EXIT;

  if not assigned(theCtrl) then
    EXIT;

  result := (theCtrl is TThumbsBrowser) or
    (assigned(fDragSource) and fDragSource.DragDropOptions.IsRegistered(theCtrl));

end;

procedure TThumbsBrowser_DragDropHandler.CheckCursor(destTB: TThumbsBrowser; X, Y: integer; var bAllowed: boolean);
var
  bShift: boolean;
  aCtrl: TWinControl;
  bKnownCtrl: boolean;
begin

  if fDraggingActive then
  begin
    bShift := GetAsyncKeyState(VK_SHIFT) <> 0;
    fDynTransferMode_TB := GetDynTransferModeTB(bShift);

    if fDragSource.DragDropOptions.IS_DragSource_TB then
    begin
      aCtrl := FindDropControl(point(X, Y));

      bKnownCtrl := CheckDragDropAllowed(aCtrl);
      if aCtrl = nil then
        bAllowed := true
      else
        bAllowed := bKnownCtrl;

      if assigned(destTB) then
      begin
        if (not destTB.DragDropOptions.IS_DropTarget_TB) then // if dest tb does not allow drop
        begin
          bAllowed := false;
        end
        else
        begin
          // but check if there is a onaccept event to determine if still allowed in the event handler
          if assigned(destTB.OnAcceptNativeDragDrop) then
          begin
            destTB.OnAcceptNativeDragDrop(fDragSource, bAllowed, fDynTransferMode_TB);
          end;
        end;
      end;
    end
    else
      bAllowed := true; // if no native dragdrop so that eventual explorer dragdrop can take place

    if not bAllowed then
    begin
      screen.Cursor := crNoDrop;
    end
    else
    begin
      if assigned(destTB) then
        screen.Cursor := destTB.CursorDrag
      else
        screen.Cursor := crMultiDrag;
      {
        if fDynTransferMode_TB = dd_Copy then
        screen.cursor := TBCONST_dragplus_cursor_handle
        else
        screen.cursor := crmultidrag;
      }
    end;
  end
  else
    screen.Cursor := crdefault;
end;

procedure TThumbsBrowser_DragDropHandler.NotifyStartDragRequest(tb: TThumbsBrowser; srcPoint: TPoint);
begin

  if not assigned(tb) then
    EXIT;
  if (not tb.DragDropOptions.IS_DragSource_TB) and (not tb.DragDropOptions.IS_DragSource_Explorer) then
    EXIT;

  ResetDragDropParams;

  fDraggingActive := true;
  fDragSource := tb;

  fDragSource_Point := srcPoint;

  fDynTransferMode_TB := GetDynTransferModeTB(false);
  fDynTransferMode_Exp := GetDynTransferModeExp(false);

  if not assigned(fTimer) then
  begin
    fTimer := TTimer.Create(self);
    fTimer.enabled := false;
    fTimer.interval := fDragScrollInterval;
    fTimer.OnTimer := HandleTimer;
    fTimer.enabled := true;
  end;
end;

procedure TThumbsBrowser_DragDropHandler.NotifyDragOverRequest(tb: TThumbsBrowser; overPoint: TPoint);
begin
  if not fDraggingActive then
    EXIT;

  if (fDragSource = nil) then
  begin
    fDropTarget := nil;
  end
  else
  begin
    if (fDropTarget <> nil) and (fDropTarget <> tb) then
      fDropTarget.RefreshDisplay; // refresh display before replacing with new drop target

    fDropTarget := tb;
    fDropTarget_Point := overPoint;

  end;
end;

{$IFDEF TB_NATIVEDRAGDROP_TOIMAGEEN}

function TThumbsBrowser_DragDropHandler.TryDropToIE(aCtrl: TWinControl): boolean;
var
  iemview: TImageenmview;
  ieview: TImageenview;
  Idx: integer;
  procedure CopyToIE(theThumb: TThumbEx);
  begin
    if assigned(theThumb) then
    begin
      if assigned(iemview) then
      begin
        Idx := iemview.AppendImage;
        if (theThumb.SourceType = st_File) or (theThumb.SourceType = st_Folder) then
        begin
          iemview.SetImageFromFile(Idx, theThumb.SourceFileName);
        end
        else
        begin
          iemview.SetIEBitmapEx(Idx, theThumb.IEBitmap);

        end;
      end
      else if assigned(ieview) then
      begin
        if (theThumb.SourceType = st_File) or (theThumb.SourceType = st_Folder) then
        begin
          ieview.io.LoadFromFileAuto(theThumb.SourceFileName);
        end
        else
        begin
          ieview.IEBitmap.Assign(theThumb.IEBitmap);

        end;
      end;
    end;
  end;

var
  I, hi: integer;

  athumb: TThumbEx;
begin

  result := false;

  iemview := nil;
  ieview := nil;
  hi := -1;
  if aCtrl is TImageenmview then
  begin
    iemview := TImageenmview(aCtrl);
    hi := fDragSource.SelectedCount - 1;
  end
  else if aCtrl is TImageenview then
  begin
    ieview := TImageenview(aCtrl);
    hi := 0;
  end;

  if hi = -1 then
    EXIT;

  for I := 0 to hi do
  begin
    athumb := fDragSource.GetSelected(I);
    CopyToIE(athumb);
  end;

  result := true;
end;
{$ENDIF}

function TThumbsBrowser_DragDropHandler.TryDropToCtrl(aCtrl: TWinControl): boolean;
begin
  result := false;

  if not assigned(aCtrl) then
    EXIT;

  if not CheckDragDropAllowed(aCtrl) then
    EXIT;

{$IFDEF TB_NATIVEDRAGDROP_TOIMAGEEN}
  result := TryDropToIE(aCtrl);
{$ENDIF}
  if not result then
  begin
    aCtrl.DragDrop(fDragSource, aCtrl.ScreenToClient(mouse.CursorPos).X, aCtrl.ScreenToClient(mouse.CursorPos).Y);
  end;
end;

procedure TThumbsBrowser_DragDropHandler.DoDragDrop(shift: TShiftState; droppoint: TPoint);
var
  aCtrl: TWinControl;
  bHandled: boolean;
begin
   // if not active reset and exit
  if not(fDraggingActive) then
  begin
    StopDragDrop;
    EXIT;
  end;

  StopDragDrop;

  // if source not assigned reset and exit
  if not assigned(fDragSource) then
    EXIT;


    if not assigned(fDropTarget) then // no destination
    begin
      aCtrl := FindDropControl(mouse.CursorPos);
      if not TryDropToCtrl(aCtrl) then
      begin
        // dropped on any other incompatible control: do nothing
      end;
    end
    else if (not fDropTarget.DragDropOptions.IS_DropTarget_TB) then // target does not accept drop
    begin
      // showmessage('External');

    end
    else
    begin
      bHandled := false;
      if assigned(fDropTarget.OnNativeDragDrop) then
        fDropTarget.OnNativeDragDrop(fDropTarget, fDragSource, droppoint.X, droppoint.Y, bHandled, fDynTransferMode_TB);

      if not bHandled then
      begin
        if (fDropTarget.DragDropOptions.DropBehavior = ddb_Thumbs) or (fDropTarget = fDragSource) or
          (fDropTarget.CurrentFolder = '') then
        begin
          fDropTarget_Point := droppoint;
          fDropTarget.DropThumbsFrom(fDragSource, fDynTransferMode_TB, InsertPt);
          fDropTarget.RefreshDisplay;
          fDragSource.RefreshDisplay;
        end
        else
        begin
          fDropTarget.DropFilesFromTB(fDragSource, fDynTransferMode_TB, InsertPt);
          fDropTarget.RefreshDisplay;
          fDragSource.RefreshDisplay;
        end;
      end;

      if assigned(fDropTarget.OnDragDrop) then
        fDropTarget.OnDragDrop(fDropTarget, fDragSource, droppoint.X, droppoint.Y);

    end;
end;

procedure TThumbsBrowser_DragDropHandler.DoDragDrop(shift: TShiftState);
begin
  DoDragDrop(shift, fDropTarget_Point);
end;

procedure TThumbsBrowser_DragDropHandler.ResetDragDropParams;
begin
  PreviousInsertPt := point(-1234, -1234);
  PreviousInsertIdx := -1;
  InsertPt := point(-1234, -1234);
  Insertidx := -1;
  fDragSource := nil;
  fDropTarget := nil;
end;

procedure TThumbsBrowser_DragDropHandler.StopDragDrop;
begin
  fDraggingActive := false;
  if assigned(fTimer) then
  begin
    fTimer.enabled := false;
    Freeandnil(fTimer);
  end;

  if assigned(fDragSource) then
    fDragSource.TBEndDrag;

  // ResetDragDropParams;

  screen.Cursor := crdefault;
end;




// Class TThumbsBrowser--------------------------------

procedure TThumbsBrowser.Init_Resources;
begin
  screen.cursors[TBCONST_dragplus_cursor_handle] := LoadCursor(HInstance, 'CRDRAG_PLUS');
  fLayoutResources := TTB_GraphicResources.Create;
  fLayoutResources.LoadFromResources;

end;

procedure TThumbsBrowser.Finalize_Resources;
begin
  Freeandnil(fLayoutResources);
end;

procedure TThumbsBrowser.Init_WIA;
begin
  fAbortWia := false;
  fBrowser_WIA_IO := TImageenio.Create(self);
  fBrowser_WIA := TNWSComps_WIA(fBrowser_WIA_IO.WIAParams);
  fBrowser_WIA_Items := TList.Create;
  fBrowser_WIA_DeviceIdx := -1;
end;

procedure TThumbsBrowser.Finalize_WIA;
begin
  fBrowser_WIA_Items.Free;
  fBrowser_WIA_IO.Free;
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.Init_WPD;
begin
  fAbortWPD := false;
  fWpdStartTk := gettickcount;
  fBrowser_WPD := TIEPortableDevices.Create;

  fBrowser_WPD_Items := TStringList.Create;
  fWPDNavHistory := TStringList.Create;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.Finalize_WPD;
begin
  fBrowser_WPD_Items.Free;
  fBrowser_WPD.Free;
  fWPDNavHistory.Free;
end;
{$ENDIF}

function TThumbsBrowser.GetBrowserTotalTopMargin: integer;
begin
  result := fReportHeaderMargin + fBrowseFoldersProgress_Panel.Height * ord(fBrowseFoldersProgress_Panel.Visible);
end;

function TThumbsBrowser.Handle_ScanFiles_ProgressEvent(filelist: TThumbsBrowser_ScanFilesThread_FileRcds;
  bTerminated: boolean): boolean;
begin
  // Here we come always inside synchronization with main thread!
  result := false;
  FBrowsingRecursively := not bTerminated;
  StartBrowsing_FromScanner(filelist);
  result := true;
end;

procedure TThumbsBrowser.Handle_Scanfiles_CheckFileExt_InFilter(var bInFilter: boolean; fname, fext: string);
begin

  bInFilter := AcceptFileFilterCondition(fname, fext);
end;

procedure TThumbsBrowser.Init_ProgressPanel;
var
  pn_Button, pn_Label: TPanel;
begin
  fBrowseFoldersProgress_Panel := TPanel.Create(self);

  fBrowseFoldersProgress_Panel.Parent := self;
  fBrowseFoldersProgress_Panel.BorderStyle := bsNone;
  fBrowseFoldersProgress_Panel.BevelOuter := bvNone;
  fBrowseFoldersProgress_Panel.BevelInner := bvNone;
  fBrowseFoldersProgress_Panel.Height := 30;
  fBrowseFoldersProgress_Panel.Align := altop;

  pn_Button := TPanel.Create(fBrowseFoldersProgress_Panel);

  pn_Button.Parent := fBrowseFoldersProgress_Panel;
  pn_Button.BorderStyle := bsNone;
  pn_Button.BevelOuter := bvNone;
  pn_Button.BevelInner := bvNone;
  pn_Button.Align := alright;
  pn_Button.Width := 80;
  fBrowseFoldersProgress_Button := TButton.Create(pn_Button);
  with fBrowseFoldersProgress_Button do
  begin
    AutoSize := false;
    Parent := pn_Button;
    Width := 60;
    Height := 24;
    TOP := 2;
    left := 4;
    caption := 'Abort';
    OnClick := Handle_AbortClick;
  end;

  pn_Label := TPanel.Create(fBrowseFoldersProgress_Panel);

  pn_Label.Parent := fBrowseFoldersProgress_Panel;
  pn_Label.BorderStyle := bsNone;
  pn_Label.BevelOuter := bvNone;
  pn_Label.BevelInner := bvNone;
  pn_Label.Align := alClient;

  fBrowseFoldersProgress_Display := TPanel.Create(pn_Label);

  fBrowseFoldersProgress_Display.Parent := pn_Label;
  fBrowseFoldersProgress_Display.BevelInner := bvNone;

  fBrowseFoldersProgress_Display.Visible := true;
  fBrowseFoldersProgress_Display.Align := alClient;
  fBrowseFoldersProgress_Display.Hint := '';
  fBrowseFoldersProgress_Display.caption := '';

  fBrowseFoldersProgress_Panel.Visible := false;
end;

procedure TThumbsBrowser.Init_Scroller;
begin
  fScrollUpdateTimer := nil;
  fScrollUpdateTimerValue := 0;
  fScrollUpdateTimerSender := nil;
  fScrollerBox := TPanel.Create(self);
  fScrollerBox.Parent := self;
  fScrollerBox.DoubleBuffered := false;
  // fScrollerBox.BevelOuter := bvnone;
  // fScrollerBox.BevelInner := bvnone;

  // fScrollerBox.FullRepaint := false;
  fScrollerBox.caption := '';

  fScroller := TThumbsScrollbar.Create(self);
  fScroller.Parent := fScrollerBox;

  fScroller.Visible := true;

  fScroller.Align := alClient;

  fScroller.OnScroll := DOOnScrollerScroll;
  fScroller.OnChange := DOOnScrollerChange;
  fScroller.DoubleBuffered := false;
  SetScrollerBoxVisible(false);

end;

procedure TThumbsBrowser.SetScrollerBoxVisible(Value: boolean);
begin
  fScrollerBox.Visible := Value;

  SetScrollerOrientation;

end;

procedure TThumbsBrowser.Init_DB;
begin
{$IFDEF TB_USEDB}
  fDB := TThumbsBrowser_DB.Create(self);
{$ENDIF}
end;

procedure TThumbsBrowser.Finalize_DB;
begin
{$IFDEF TB_USEDB}
  Freeandnil(fDB);
{$ENDIF}
end;

procedure TThumbsBrowser.Init_Loader;
begin

  Loader_CreateNew;
end;

function TThumbsBrowser.CreateThumb(theOriginator: TTB_Thumb_Originator; theUserObject: TObject;
  theLayoutType: TTB_Thumb_Layout_Type; bVisible: boolean): TThumbEx;
begin
  result := TThumbEx.Create(theOriginator, self.canvas, theUserObject, bVisible);
  result.LayoutType := theLayoutType;
end;

procedure TThumbsBrowser.HandleExplorerDrop(sender: TObject; ssFiles: TStrings; dwEffect: integer);
var
  bAccept, bHandled: boolean;
  tm: TThumbsBrowser_DragDropTransferMode;
  I: integer;
  srcTB: TThumbsBrowser;
  src: TObject;
begin
  bAccept := true;
  bHandled := false;
  src := SharedDragDrop_Handler.DragSource;

  case fDragDropOptions.TransferMode_Exp of
    dd_Copy:
      tm := dd_Copy;
    dd_Move:
      tm := dd_Move;
    dd_DetectShiftState:
      if GetAsyncKeyState(VK_SHIFT) <> 0 then
        tm := dd_Copy
      else
        tm := dd_Move;
  end;

  if assigned(fOnAcceptExplorerDragDrop) then
    fOnAcceptExplorerDragDrop(self, bAccept, tm);

  if not bAccept then
    EXIT; // >>>> EXIT

  if ssFiles.Count = 0 then // no files (this is possible because the TIEDragdrop only supports
  // dragging / dropping from / to actual explorer windows)
  // , check if source is TB and retrieve files from source
  begin
    if SharedDragDrop_Handler.DragSource <> nil then
    begin
      srcTB := SharedDragDrop_Handler.DragSource;
      for I := 0 to srcTB.SelectedCount - 1 do
        if srcTB.GetSelected(I).SourceFileName <> '' then
          ssFiles.Add(srcTB.GetSelected(I).SourceFileName);
    end;
  end;

  if assigned(fOnExplorerDragDrop) then
    fOnExplorerDragDrop(self, src, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y, ssFiles,
      bHandled, tm);

  if not bHandled then
  begin
    if (DragDropOptions.DropBehavior = ddb_Thumbs) or (CurrentFolder = '') then
    begin
      if tm = dd_Move then
        StartBrowsing(TStringList(ssFiles))
      else if tm = dd_Copy then
        Add_Files(TStringList(ssFiles));
    end
    else
    begin
      DropFilesFromExplorer(ssFiles, tm);
    end;
  end;

  if assigned(OnDragDrop) then
    OnDragDrop(self, src, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y);
end;

procedure TThumbsBrowser.HandleDragDropOptionsChanged(sender: TObject);
begin
  if fDragDropOptions.IS_DropTarget_Explorer then
  begin
    if not assigned(fDropFiles) then
    begin
      fDropFiles := TIEFileDragDrop.Create(self, HandleExplorerDrop);
      fDropFiles.DropActions := [iedaCopy, iedaMove];
      RegisterExpectedMemoryLeak(fDropFiles);
    end;
  end;

  if assigned(fDropFiles) then
    fDropFiles.ActivateDropping := fDragDropOptions.IS_DropTarget_Explorer;

end;

procedure TThumbsBrowser.HandleDropShadowOptionsChange(sender: TObject);
begin
  RefreshDisplay;
end;

procedure TThumbsBrowser.Init_Objects;
begin
  fStyleOptions := TTB_Browser_StyleOptions.Create(Handle_BrowserStyleOptionsChange);
  fInternetOptions := TTB_Browser_InternetParams.Create;

  fBrowseFoldersProgress_CriticalSection := TCriticalSection.Create;
  fBrowseFoldersRecursiveCriticalSection := TCriticalSection.Create;
  fFileScannerCriticalSection := TCriticalSection.Create;

  RegisterExpectedMemoryLeak(fBrowseFoldersProgress_CriticalSection);
  RegisterExpectedMemoryLeak(fBrowseFoldersRecursiveCriticalSection);
  RegisterExpectedMemoryLeak(fFileScannerCriticalSection);

  fThumbs := TTBThumbsList.Create;
  fVisibleThumbs := TTBVisibleThumbsList.Create;
  fSelectedThumbs := TList.Create;
  fCheckedThumbs := TList.Create;
  frotatedThumbs := TList.Create;

  fHiddenThumbs_Filter := TList.Create;
  fHiddenThumbs_NavMem := TNamedList.Create;
  fHiddenThumbs_User := TList.Create;

  fBrowsedPaths := TStringList.Create;
  fFolderRecursionList := TStringList.Create;
  fDisplayBackBuffer := tbitmap.Create;
  fDisplayBackBuffer.PixelFormat := pf24bit;

  fDragDropOptions := TThumbsBrowser_DragDropOptions.Create(HandleDragDropOptionsChanged);
  fFileOptions := TThumbsbrowser_FileDisplay_Options.Create;
  fFileOptions.HiddenFiles := false;
  fFileOptions.HiddenFolders := false;
  fFileOptions.SystemFiles := false;
  fFileOptions.SystemFolders := false;

  fThumbDropShadow := TTB_Thumb_DropShadowOptions.Create(HandleDropShadowOptionsChange);

  HandleDragDropOptionsChanged(self);
end;

procedure TThumbsBrowser.Finalize_Objects;
var
  I: integer;
begin

  fHiddenThumbs_Filter.Free;
  fHiddenThumbs_NavMem.Free;
  fHiddenThumbs_User.Free;

  fSelectedThumbs.Free;
  fCheckedThumbs.Free;
  frotatedThumbs.Free;
  fVisibleThumbs.Free;

  for I := 0 to fThumbs.Count - 1 do
  begin
    if assigned(fThumbs[I]) then
      TThumbEx(fThumbs[I]).Free;
  end;

  fThumbs.Free;

  fDisplayBackBuffer.Free;
  fSampleThumb.Free;
  fBackupLayoutThumb.Free;
  fBrowsedPaths.Free;
  fFolderRecursionList.Free;

  fUserFileFormats_Read := nil;

  Freeandnil(fDragDropOptions);
  Freeandnil(fFileOptions);
  Freeandnil(fInternetOptions);
  Freeandnil(fStyleOptions);
  Freeandnil(fThumbDropShadow);
end;

procedure TThumbsBrowser.Init_MetaData;
var
  I: integer;
begin
  fMetaTags := TThumbsbrowser_MetaTags.Create(true);

  fMetaData_Options := TThumbsbrowser_MetaData_Options.Create;
  for I := 0 to fMetaTags.ExifTags.Count - 1 do
    fMetaData_Options.Fields_Exif.Add(fMetaTags.ExifTags.TagAsStr[I]);

  for I := 0 to fMetaTags.IptcTags.Count - 1 do
    fMetaData_Options.Fields_IPTC.Add(fMetaTags.IptcTags.TagAsStr[I]);

  for I := 0 to fMetaTags.XmpTags.Count - 1 do
    fMetaData_Options.Fields_Xmp.Add(fMetaTags.XmpTags.TagAsStr[I]);

  for I := 0 to fMetaTags.CommonTags.Count - 1 do
    fMetaData_Options.Fields_Common.Add(fMetaTags.CommonTags.TagAsStr[I]);

  fMetaData_Options.OnExifFieldsChanged := Handle_MetaData_ExifFieldsChanged;
  fMetaData_Options.OnIptcFieldsChanged := Handle_MetaData_IptcFieldsChanged;
  fMetaData_Options.OnXmpFieldsChanged := Handle_MetaData_XmpFieldsChanged;
  fMetaData_Options.OnCommonFieldsChanged := Handle_MetaData_CommonFieldsChanged;
  MetaData_Options.OnSyncTagChanged := Handle_MetaData_SyncTagChanged;
  MetaData_Options.OnAutoSyncOptionsChanged := Handle_MetaData_AutoSyncOptionChanged;

  fSampleThumb.MetaTags := fMetaTags;
  fSampleThumb.MetaOptions := fMetaData_Options;
  { }
end;

procedure TThumbsBrowser.Finalize_MetaData;
begin
  fMetaTags.Free;
  fMetaData_Options.Free;
end;

procedure TThumbsBrowser.Handle_MetaData_CommonFieldsChanged(sender: TObject);
var
  I: integer;
begin
  if assigned(fThumbsbrowser_InfoForm) then
    fThumbsbrowser_InfoForm.close;

  fMetaTags.CommonTags.clear;
  for I := 0 to fMetaData_Options.Fields_Common.Count - 1 do
  begin
    fMetaTags.CommonTags.Add(fMetaData_Options.Fields_Common[I]);
  end;
end;

procedure TThumbsBrowser.Handle_MetaData_SyncTagChanged(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType;
  const oldTagstr, newTagstr: string);
var
  I: integer;
  athumb: TThumbEx;
begin
  if csDesigning in ComponentState then
    EXIT;
  if csLoading in ComponentState then
    EXIT;

  LockUpdate;
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      if oldTagstr <> '' then
        athumb.MetaData_SyncWrite(syncType, oldTagstr);
      athumb.MetaData_SyncRead(syncType, newTagstr);
    end;
  finally
    UnlockUpdate(true);
  end;
end;

procedure TThumbsBrowser.Handle_MetaData_AutoSyncOptionChanged(sender: TObject;
  syncType: TThumbsbrowser_MetaData_SyncType; oldOption, newOption: TThumbsbrowser_MetaData_SyncOpType);
var
  I: integer;
  athumb: TThumbEx;
  bRead, bWrite: boolean;
  sSyncTag: string;
begin
  if csDesigning in ComponentState then
    EXIT;
  if csLoading in ComponentState then
    EXIT;

  if newOption = oldOption then
    EXIT;

  case newOption of
    mdSyncOp_ReadOnly:
      begin
        bRead := oldOption = mdSyncOpNone;
        bWrite := false;
      end;
    mdSyncOp_ReadWrite:
      begin
        bRead := oldOption = mdSyncOpNone;
        bWrite := oldOption = mdSyncOpNone;
      end;
  else
    EXIT; // mdSyncOpNone -> nothing to do
  end;

  if (not bRead) and (not bWrite) then
    EXIT;

  LockUpdate;
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      sSyncTag := fMetaData_Options.GetSyncTag(syncType);
      if bRead then
        athumb.MetaData_SyncRead(syncType, sSyncTag);
      if bWrite then
        athumb.MetaData_SyncWrite(syncType, sSyncTag);

    end;
  finally
    UnlockUpdate(true);
  end;

end;

procedure TThumbsBrowser.Handle_ThumbSyncPropertyChanged(sender: TObject; syncType: TThumbsbrowser_MetaData_SyncType);
var
  athumb: TThumbEx;
begin
  if sender = nil then
    EXIT;
  if not(sender is TThumbEx) then
    EXIT;

  athumb := TThumbEx(sender);

  case syncType of
    mdSyncTopTitle:
      athumb.MetaData_SyncWrite(syncType, fMetaData_Options.SyncField_TopTitle);
    mdSyncBottomTitle:
      athumb.MetaData_SyncWrite(syncType, fMetaData_Options.SyncField_BottomTitle);
    mdSyncRating:
      athumb.MetaData_SyncWrite(syncType, fMetaData_Options.SyncField_Rating);
    mdSyncKeywords:
      athumb.MetaData_SyncWrite(syncType, fMetaData_Options.SyncField_Keywords);
  end;

{$IFDEF TB_USEDB}
  if fDB.DBActive then
  begin
    athumb.EditDBRcd(nil, fDB, GUID_NULL);
  end;
{$ENDIF}
end;

procedure TThumbsBrowser.Handle_MetaData_ExifFieldsChanged(sender: TObject);
var
  I: integer;
begin
  if assigned(fThumbsbrowser_InfoForm) then
    fThumbsbrowser_InfoForm.close;

  fMetaTags.ExifTags.clear;
  for I := 0 to fMetaData_Options.Fields_Exif.Count - 1 do
  begin
    fMetaTags.ExifTags.Add(fMetaData_Options.Fields_Exif[I]);
  end;
end;

procedure TThumbsBrowser.Handle_MetaData_IptcFieldsChanged(sender: TObject);
var
  I: integer;
begin
  if assigned(fThumbsbrowser_InfoForm) then
    fThumbsbrowser_InfoForm.close;

  fMetaTags.IptcTags.clear;
  for I := 0 to fMetaData_Options.Fields_IPTC.Count - 1 do
  begin
    fMetaTags.IptcTags.Add(fMetaData_Options.Fields_IPTC[I]);
  end;
end;

procedure TThumbsBrowser.Handle_MetaData_XmpFieldsChanged(sender: TObject);
var
  I: integer;
begin
  if assigned(fThumbsbrowser_InfoForm) then
    fThumbsbrowser_InfoForm.close;

  fMetaTags.XmpTags.clear;
  for I := 0 to fMetaData_Options.Fields_Xmp.Count - 1 do
  begin
    fMetaTags.XmpTags.Add(fMetaData_Options.Fields_Xmp[I]);
  end;
end;

procedure TThumbsBrowser.Init_Settings;
var
  capSet: TTB_Thumb_CaptionsSetting;
begin
  for capSet := Low(TTB_Thumb_CaptionsSetting) to High(TTB_Thumb_CaptionsSetting) do
    fThumbCaption_Info[ord(capSet)].ColPercWidth := -1;

  for capSet := Low(TTB_Thumb_CaptionsSetting) to High(TTB_Thumb_CaptionsSetting) do
    fThumbCaption_Info[ord(capSet)].capIdx := ord(capSet);

  // then here following apply the order corrections in order to mantain compatibility for TTB_Thumb_CaptionsSetting with older versions

  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowDateTime), ord(cap_ShowFilePath));
  {
    cap_ShowFileName,
    <---cap_ShowFilePath,
    cap_ShowDateTime,
  }
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowCreateDate));
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowCreateDateAndTime));
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowEditDate));
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowEditDateAndTime));
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowEXIFDateTime));
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowFileSize), ord(cap_ShowFileDimensionsAndSize));

  { cap_ShowDateTime,
    <---cap_ShowCreateDate
    <---cap_ShowCreateDateAndTime
    <---cap_ShowEditDate
    <---cap_ShowEditDateAndTime
    <---cap_ShowEXIFDateTime
    <---cap_ShowFileDimensionsAndSize
    cap_ShowFileSize,
  }
  SetThumbCaptionOrderEX(GetThumbCaption_OrderByCaption(cap_ShowDimensions) + 1, ord(cap_ShowFileType));
  { cap_ShowDimensions,
    <---cap_ShowFileType }
  fUpdScrollertk := gettickcount;
  fResizingHeader := false;
  fMovingHeader := false;
  fRecalcDisplay := true;
  fMouseHoverThumb := nil;
  fMouseHoverThIdx := -1;

  fLoaderDBSessionGuid := GUID_NULL;
  FBrowsingRecursively := false;
  FFileScanner_MaxTransfer := 250;

  fMultithread := true;
  fMultithread_Pool_Count := 5;
  fMultithread_Timeout := 3000;

  Width := 100;
  Height := 100;
  FInfoFormOpened := false;
  FInfoFormEmbeddingPanel := nil;
  fAllowCustomformat_ExternalReader := false;

  fFileThumbs := true;
  fFolderThumbs := false;
  fFolderNavigation := false;
  fFolderUpNavThumb := true;
  fNavMemory := true;
  fNavMemMaxThumbs := 4000;

  fFolderCheckBoxes := true;
  fFolderTitles := false;
  fsort_updated := false;
  ffilter_updated := false;
  fBrowserOrientation := tbo_vert;
  fMaxRows := -1;
  fMaxCols := -1;
  fStyleLocked := 0;
  fLayoutLocked := 0;
  fLoadingLocked := 0;
  fUpdateLocked := 0;
  fPaintLocked := 0;
  fVCLStyleLocked := 0;

  fVisTransOpened_FilterShow := 0;
  fVisTransOpened_NavMemoryShow := 0;
  fVisTransOpened_UserShow := 0;
  fVisTransOpened_FilterHide := 0;
  fVisTransOpened_NavMemoryHide := 0;
  fVisTransOpened_UserHide := 0;
  fSelectedIndex := -1;
  fLastShiftClickedID_s := -1;
  fLastShiftClickedID_e := -1;
  fShiftFlag := false;
  fCTRLFlag := false;
  fLastClickedThumb := nil;

  fBackgroundType := tbbgt_SolidColor;
  fBackgroundColor := rgb(255, 255, 255);
  fBackground2ndColor := TBGetValidColor(clSkyBlue);
  Color := fBackgroundColor;

  fThumbDefaultChecked := true;

  fBrowser_width := 0;
  fBrowser_height := 0;
  fspacingX := 4;
  fspacingY := 4;

  fScrollParams.Display_PageSize := 0;
  fScrollParams.Display_Min := 0;
  fScrollParams.Display_Max := 1;
  fScrollParams.Display_Pos := 0;
  fScrollParams.Pos := 0;

  fCentered := true;
  fNRows := 0;
  fNColumns := 0;
  fNRows_float := 0;
  fNColumns_float := 0;
  fpassox := 0;
  fpassoy := 0;
  fDynamicMarginX := 0;
  fDynamicMarginY := 0;

  fReportHeaderMargin := 0;

  fDisplayMarginTop := 0;
  fDisplayMarginBottom := 0;
  fDisplayMarginLeft := 0;
  fDisplayMarginRight := 0;

  fBrowserOwnMarginTop := 0;
  fBrowserOwnMarginBottom := 0;
  fBrowserOwnMarginLeft := 0;
  fBrowserOwnMarginRight := 0;

  fFilter := '*.*';
  fFilter_AllowMultiExt := false;
  fFilterExclude := '';
  fPopupDefaultExplorer := true;

  fShowCaptions := false;
  fShowCheckBoxes := false;
  fShowRotateButtons := false;
  fShowInfoButton := false;
  fShowTopTitle := false;
  fShowBottomTitle := false;
  fShowRatingBox := false;
  fShowThumbnailHint := false;
  fShowDesignTestThumbs := false;
  fHintThumbIdx := 0;
  fMemAppHintHidePause := Application.HintHidePause;
  fMemAppHintShortPause := Application.HintShortPause;
  fMemAppHintPause := Application.HintPause;

  ShowHint := true;
  fMultiSelect := false;
  fSortType := stNameA;

  self.DoubleBuffered := false;
  self.Cursor := crhandpoint;

  fdoubleclickFlag := false;

  fInfoForm_Status.Defined := false;
end;

constructor TThumbsBrowser.Init_TimedEvents;
var
  I: integer;
begin
  for I := Low(fLastEventStarted) to High(fLastEventStarted) do
    fLastEventStarted[I] := RESETTIMEDEVENT;
end;

constructor TThumbsBrowser.Create(AOwner: TComponent);
begin
  inherited;

  NWSCOMPS.Subscribe(HandleGlobalNotification);
  // DoubleBuffered := true;
  Width := 100;
  Height := 100;

  fLanguage := NWSCOMPS.Language;
  fSampleThumb := CreateThumb(tborig_Auto, nil, ltVertical, false);
  fBackupLayoutThumb := CreateThumb(tborig_Auto, nil, ltVertical, false);

  Init_TimedEvents;
  Init_Objects;
{$IFDEF TB_FOLDERMONITOR}
  Init_FolderMonitor;
{$ENDIF}
  Init_MetaData;
  Init_Settings;
  Init_Resources;
  Init_WIA;
{$IFDEF TB_PORTABLEDEVICE}
  Init_WPD;
{$ENDIF}
  Init_DB;
  Init_Scroller;
  Init_ProgressPanel;

end;

destructor TThumbsBrowser.Destroy;
begin
  NWSCOMPS.UnSubscribe(HandleGlobalNotification);

  Finalize_DB;
  Finalize_Resources;
  Finalize_Objects;
  Finalize_WIA;
{$IFDEF TB_PORTABLEDEVICE}
  Finalize_WPD;
{$ENDIF}
  Finalize_MetaData;

  inherited;
end;

procedure TThumbsBrowser.Loaded;
begin
  inherited;

  InitSampleThumb;
  InitCaptionInfos;

  DoubleBufferTrick(false, self);

  Handle_MetaData_ExifFieldsChanged(fMetaData_Options);
  Handle_MetaData_IptcFieldsChanged(fMetaData_Options);
  Handle_MetaData_XmpFieldsChanged(fMetaData_Options);
  Handle_MetaData_CommonFieldsChanged(fMetaData_Options);

  SetLanguage(fLanguage);

  Init_Loader;

{$IFDEF TB_USEDB}
  if not(csDesigning in ComponentState) then
  begin
    fDB.Start;
    fLoaderDBSessionGuid := fDB.SessionInit(self, 800);
  end;
{$ENDIF}
  if (csDesigning in ComponentState) and fShowDesignTestThumbs then
  begin
    CreateTests;
  end;

  RefreshDisplay;
  if not(csDesigning in ComponentState) then
  begin
    CheckApplyTheme;

    if (fFolderDefault <> tbdfSpecified) then
      SetFolderDefault(fFolderDefault);
    // the above makes sure that folderCurrent is always according to folderDefault at start-up

    if (directoryexists(fFolderCurrent)) then
      NavigateToFolder(fFolderCurrent);
  end;

end;

procedure TThumbsBrowser.BeforeDestruction;
begin
  inherited;
{$IFDEF TB_FOLDERMONITOR}
  Finalize_FolderMonitor;
{$ENDIF}
  fOnfinishedLoading := nil;
  fOnInitialized := nil;
  fOnStartedLoading := nil;

  AbortBrowsingRecursively;
  sleep(100);
  CheckFinalizeBrowsingRecursively;
  StopScanner;
  StopLoader(true);

end;

procedure TThumbsBrowser.WMGetdlgcode(var Message: twmgetdlgcode);
begin
  message.result := DLGC_WANTARROWS
end;

procedure TThumbsBrowser.WMMouseWheel(var Message: TWMMouseWheel);
var
  DeltaScroll: integer;
begin
  if not fScrollerBox.Visible then
    EXIT;
  DeltaScroll := 0;
  case BrowsingOrientation of
    tbo_horz:
      begin
        DeltaScroll := fpassox div 2;
      end;
    tbo_vert:
      begin
        DeltaScroll := fpassoy div 2;
      end;
  end;

  if fStyleOptions.BrowserStyle = tbStyle_Columns then
    DeltaScroll := DeltaScroll * 2;

  if message.WheelDelta < 0 then
    SetVirtualScroll_Position(fScrollParams.Display_Pos + DeltaScroll)
  else if message.WheelDelta > 0 then
    SetVirtualScroll_Position(fScrollParams.Display_Pos - DeltaScroll);
end;

procedure TThumbsBrowser.Resize;
begin
  inherited;

  // to do change the size of horizontal layout
  DoTimedEvent(TIMEDEVENT_AFTERRESIZE, 800, true);

  RefreshDisplay;
end;

procedure TThumbsBrowser.Paint;
begin
  if fPaintLocked > 0 then
    EXIT;

  inherited;

  // DO NOT CALL REFRESHDISPLAY FROM INSIDE THE PAINT METHOD!

  if fRecalcDisplay then
    RefreshThumbs(self, false); // this recreates the thumbs on the back buffer without updating to screen

  fRecalcDisplay := false; // reset the flag
  UpdateDisplay; // draw the back buffer and other elements (columns header etc..) to component canvas

end;

function TThumbsBrowser.GetHeaderResizeColbyMouse(X, Y: integer): integer;
var
  hdRect: Trect;
  I: integer;
  cellW: integer;
  xCol: integer;
  LastCol: integer;
begin
  result := -1;

  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    EXIT;

  hdRect := GetReportHeaderRect;
  if (Y < hdRect.TOP) or (Y > hdRect.bottom) then
    EXIT;

  LastCol := -1;
  for I := high(fThumbCaption_Info) downto low(fThumbCaption_Info) do
    if fThumbCaption_Info[I].ColPercWidth >= 0 then
    begin
      LastCol := I;
      break;
    end;

  xCol := hdRect.left;
  for I := low(fThumbCaption_Info) to LastCol - 1 do
  begin
    if fThumbCaption_Info[I].ColPercWidth >= 0 then
    begin

      cellW := round(fThumbCaption_Info[I].ColPercWidth / 100 * TBGetRectWidth(hdRect));
      xCol := xCol + cellW;
      if abs(X - xCol) < 6 then
      begin
        result := I;
        break;
      end;
    end;
  end;

end;

function TThumbsBrowser.GetHeaderColbyMouse(X, Y: integer): integer;
var
  hdRect: Trect;
  I: integer;
  cellW, cellStart, cellEnd: integer;
begin
  result := -1;

  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    EXIT;

  hdRect := GetReportHeaderRect;
  if (Y < hdRect.TOP) or (Y > hdRect.bottom) then
    EXIT;

  cellStart := hdRect.left;
  for I := low(fThumbCaption_Info) to high(fThumbCaption_Info) do
  begin
    if fThumbCaption_Info[I].ColPercWidth >= 0 then
    begin
      cellW := round(fThumbCaption_Info[I].ColPercWidth / 100 * TBGetRectWidth(hdRect));
      cellEnd := cellStart + cellW;
      if (X >= cellStart) and (X < cellEnd) then
      begin
        result := I;
        break;
      end;
      cellStart := cellEnd;
    end;
  end;

end;

function TThumbsBrowser.GetReportHeaderColumnRect(colIdx: integer): Trect;
var
  hdRect: Trect;
  I: integer;
  cellW, cellStart, cellEnd: integer;
begin
  result := rect(0, 0, 0, 0);

  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    EXIT;

  hdRect := GetReportHeaderRect;

  cellStart := hdRect.left;
  for I := low(fThumbCaption_Info) to high(fThumbCaption_Info) do
  begin
    if fThumbCaption_Info[I].ColPercWidth >= 0 then
    begin
      cellW := round(fThumbCaption_Info[I].ColPercWidth / 100 * TBGetRectWidth(hdRect));
      cellEnd := cellStart + cellW;
      if I = colIdx then
      begin
        result := rect(cellStart, hdRect.TOP, cellEnd, hdRect.bottom);
        break;
      end;
      cellStart := cellEnd;
    end;
  end;

end;

function TThumbsBrowser.GetReportHeaderRect: Trect;
var
  thLeft, hdLeft, hdRight: integer;
  capRect: Trect;
begin

  thLeft := XThumb2Browser(0, TopDisplayedThumbIdx);
  capRect := fSampleThumb.GetRect(HitCaption);
  hdLeft := XThumb2Browser(capRect.left, TopDisplayedThumbIdx);
  hdRight := XThumb2Browser(capRect.Right, TopDisplayedThumbIdx);

  result := rect(hdLeft, YDisplay2Browser(0) - fReportHeaderMargin, hdRight, YDisplay2Browser(0) - 1);
end;

procedure TThumbsBrowser.CopyColumnsForMouseMove;
var
  I: integer;
begin
  for I := CAP_LOW_IDX to CAP_HIGH_IDX do
    fMouseMoveHeaderColInfo[I] := fThumbCaption_Info[I];
end;

procedure TThumbsBrowser.ResizeHeaderColumn(colIdx: integer; xBef, xAfter: integer);
var
  otherCol: integer;
  I, deltaX: integer;
  PixWidth, SumPixWidth, SumPerc: single;
  hdWidth: integer;
begin
  if (colIdx < low(fMouseMoveHeaderColInfo)) or (colIdx > high(fMouseMoveHeaderColInfo)) then
    EXIT;

  otherCol := -1;
  for I := colIdx + 1 to high(fMouseMoveHeaderColInfo) do
  begin
    if fMouseMoveHeaderColInfo[I].ColPercWidth >= 0 then
    begin
      otherCol := I;
      break;
    end;
  end;

  if otherCol = -1 then
  begin
    for I := colIdx - 1 downto low(fMouseMoveHeaderColInfo) do
    begin
      if fMouseMoveHeaderColInfo[I].ColPercWidth >= 0 then
      begin
        otherCol := I;
        break;
      end;
    end;
  end;
  if otherCol = -1 then
    EXIT;

  deltaX := xAfter - xBef;
  hdWidth := TBGetRectWidth(GetReportHeaderRect);

  PixWidth := fMouseMoveHeaderColInfo[colIdx].ColPercWidth / 100 * hdWidth;
  SumPixWidth := PixWidth + fMouseMoveHeaderColInfo[otherCol].ColPercWidth / 100 * hdWidth;

  SumPerc := fMouseMoveHeaderColInfo[otherCol].ColPercWidth + fMouseMoveHeaderColInfo[colIdx].ColPercWidth;
  if PixWidth + deltaX <= 0 then
  begin
    fThumbCaption_Info[otherCol].ColPercWidth := SumPerc;
    fThumbCaption_Info[colIdx].ColPercWidth := 0
  end
  else if PixWidth + deltaX >= SumPixWidth then
  begin
    fThumbCaption_Info[colIdx].ColPercWidth := SumPerc;
    fThumbCaption_Info[otherCol].ColPercWidth := 0
  end
  else
  begin
    fThumbCaption_Info[colIdx].ColPercWidth := fMouseMoveHeaderColInfo[colIdx].ColPercWidth + deltaX / PixWidth *
      fMouseMoveHeaderColInfo[colIdx].ColPercWidth;
    fThumbCaption_Info[otherCol].ColPercWidth := SumPerc - fThumbCaption_Info[colIdx].ColPercWidth;
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.MoveHeaderColumn(curColIdx: integer; xBef, xAfter: integer);
var
  otherCol: integer;
  otherColRect, hdRect: Trect;
  Pt: TPoint;
begin
  if (curColIdx < low(fMouseMoveHeaderColInfo)) or (curColIdx > high(fMouseMoveHeaderColInfo)) then
    EXIT;

  if  TTB_Thumb_CaptionsSetting(fMouseMoveHeaderColInfo[curColIdx].capIdx) = cap_empty then
    EXIT;

  hdRect := rect(-1, -1, -1, -1);
  hdRect := GetReportHeaderRect;
  otherCol := GetHeaderColbyMouse(xAfter, hdRect.TOP);

  if otherCol = -1 then
    EXIT;

  if ThumbCaptionOrder[otherCol] = fMouseMoveHeaderColInfo[curColIdx].capIdx then
    EXIT;

  SetThumbCaptionOrderEX(otherCol, fMouseMoveHeaderColInfo[curColIdx].capIdx);
  CopyColumnsForMouseMove;
  fHeaderSelectedColIdx := otherCol;
  otherColRect := GetReportHeaderColumnRect(otherCol);
  fMouseDownPoint.X := (otherColRect.Right + otherColRect.left) div 2;
  // reset coordinate of mouse down to be able to continue moving the columns
  Pt := clienttoscreen(point(fMouseDownPoint.X, fMouseDownPoint.Y));
  Setcursorpos(Pt.X, mouse.CursorPos.Y);
  RefreshDisplay;
  DrawReportHeader(fHeaderSelectedColIdx);
end;

procedure TThumbsBrowser.DrawReportHeader(const HilightColIdx: integer = -1);
const
  chevronW: integer = 6;
  chevronH: integer = 3;
var
  hiColor, headerColor, headerColorHi, fontColor, fontColorHi: TColor;
  chevronLeft, chevronTop: integer;
  cellx: integer;
  cellW: integer;
  sText: string;
  HeaderRect: Trect;
  I: integer;
  cap: TTB_Thumb_CaptionsSetting;
  cv: Tcanvas;
  xt, yt: integer;
begin
  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    EXIT;

  cv := self.canvas;

  hiColor := NwscompsStyle_GetColor(clBtnHighlight);
  headerColor := NwscompsStyle_GetColor(clbtnFace);
  headerColorHi := NwscompsStyle_GetColor(clHighlight);
  fontColor := NwscompsStyle_GetColor(clbtnText);
  fontColorHi := NwscompsStyle_GetColor(clHighlightText);

  cv.Brush.Style := bsSolid;
  cv.Brush.Color := headerColor;
  cv.Pen.Color := hiColor;
  cv.Pen.Width := 1;
  cv.Font := Font;
  cv.Font.Color := fontColor;

  HeaderRect := GetReportHeaderRect;

  // fill the header rectangle
  cv.fillrect(TBGetFR(rect(0, HeaderRect.TOP, DisplayRect.Right, HeaderRect.bottom)));

  cellx := HeaderRect.left;
  for I := CAP_LOW_IDX to CAP_HIGH_IDX do
  begin
    if fThumbCaption_Info[I].ColPercWidth >= 0 then
    begin
      cellW := round(fThumbCaption_Info[I].ColPercWidth / 100 * TBGetRectWidth(HeaderRect));
      cv.Pen.Color := hiColor;
      cv.moveto(cellx, HeaderRect.TOP);
      cv.lineto(cellx, HeaderRect.bottom);
      cap := TTB_Thumb_CaptionsSetting(fThumbCaption_Info[I].capIdx);
      case cap of
        cap_ShowFileName:
          sText := TBResStr[IDRS_CAP_SHOWFILENAME];
        cap_ShowDateTime:
          sText := TBResStr[IDRS_CAP_SHOWFILEDATE];
        cap_ShowFileSize:
          sText := TBResStr[IDRS_CAP_SHOWFILESIZE];
        cap_ShowDimensions:
          sText := TBResStr[IDRS_CAP_SHOWFILEDIMS];
        cap_ShowEXIFDateTime:
          sText := TBResStr[IDRS_CAP_SHOWEXIFDATETIME];
        cap_ShowEXIF_XPAuthor:
          sText := TBResStr[IDRS_CAP_SHOWEXIFAUTHOR];
        cap_ShowEXIF_XPTitle:
          sText := TBResStr[IDRS_CAP_SHOWEXIFTITLE];
        cap_ShowEXIF_XPSubject:
          sText := TBResStr[IDRS_CAP_SHOWEXIFSUBJECT];
        cap_ShowEXIF_XPComment:
          sText := TBResStr[IDRS_CAP_SHOWEXIFCOMMENT];
        cap_ShowEXIF_XPKeywords:
          sText := TBResStr[IDRS_CAP_SHOWEXIFKEYWORDS];
        cap_ShowEXIF_XPRating:
          sText := TBResStr[IDRS_CAP_SHOWEXIFRATING];
        cap_ShowKeywords:
          sText := TBResStr[IDRS_CAP_SHOWKEYWORDS];
        cap_ShowRating:
          sText := TBResStr[IDRS_CAP_SHOWRATING];
        cap_ShowFileNameWithoutExtension:
          sText := TBResStr[IDRS_CAP_SHOWFILENAMEWITHOUT];
        cap_ShowFilePath:
          sText := TBResStr[IDRS_CAP_SHOWFILEPATH];
        cap_ShowFileDimensionsAndSize:
          sText := TBResStr[IDRS_CAP_SHOWFILEDIMSSIZE];
        cap_ShowCreateDate:
          sText := TBResStr[IDRS_CAP_SHOWFILECREATEDATE];
        cap_ShowCreateDateAndTime:
          sText := TBResStr[IDRS_CAP_SHOWFILECREATEDATETIME];
        cap_ShowEditDate:
          sText := TBResStr[IDRS_CAP_SHOWFILEEDITDATE];
        cap_ShowEditDateAndTime:
          sText := TBResStr[IDRS_CAP_SHOWFILEEDITDATETIME];
        cap_ShowFileType:
          sText := TBResStr[IDRS_CAP_SHOWFILETYPE];
        cap_ShowTopTitle:
          sText := TBResStr[IDRS_CAP_SHOWTOPTITLE];
        cap_ShowBottomTitle:
          sText := TBResStr[IDRS_CAP_SHOWBOTTOMTITLE];
        cap_General:
          sText := TBResStr[IDRS_CAP_SHOWGENERAL];
        cap_Other1:
          sText := TBResStr[IDRS_CAP_SHOWOTHER1];
        cap_Other2:
          sText := TBResStr[IDRS_CAP_SHOWOTHER2];
        cap_Other3:
          sText := TBResStr[IDRS_CAP_SHOWOTHER3];
        cap_Other4:
          sText := TBResStr[IDRS_CAP_SHOWOTHER4];
        cap_Empty:
          sText := '';
      else
        sText := '';
      end;

      // draw selected background if mouse over cell
      if (HilightColIdx = I) then
      begin
        cv.Brush.Color := headerColorHi;
        cv.fillrect(TBGetFR(rect(cellx + 1, HeaderRect.TOP, cellx + cellW, HeaderRect.bottom)));
      end;

      // draw the sorting icon
      if cap = fHeaderCaptionForSorting then
      begin
        if cellW > chevronW then
        begin
          chevronTop := HeaderRect.TOP + 1;
          chevronLeft := max(0, cellx + cellW - 14);
          if fHeaderCaptionSortingDirection = compAscending then
          begin
            NWSCompsStyle_DrawChevronUp(cv, rect(chevronLeft, chevronTop, chevronLeft + chevronW - 1,
              chevronTop + chevronH - 1), chevronW, chevronH, fontColor, hiColor);

          end
          else
          begin

            NWSCompsStyle_DrawChevronDown(cv, rect(chevronLeft, chevronTop, chevronLeft + chevronW - 1,
              chevronTop + chevronH - 1), chevronW, chevronH, fontColor, hiColor);

          end;

        end;
      end;

      cv.Brush.Style := bsclear; // in order to use TextRect without background
      // draw the text of the cell
      xt := cellx + fStyleOptions.CaptionsOptions.TextPadding;
      yt := HeaderRect.TOP + 6;

      if (HilightColIdx = I) then
        cv.Font.Color := fontColorHi
      else
        cv.Font.Color := fontColor;
      cv.TextRect(rect(cellx, HeaderRect.TOP, cellx + cellW, HeaderRect.bottom), xt, yt, sText);
      cellx := cellx + cellW;
    end;
  end;

  cv.Pen.Style := psSolid;
  cv.Pen.Color := hiColor;
  cv.Brush.Color := hiColor;
  cv.Pen.Width := 1;
  cv.Brush.Style := bsclear;
  cv.rectangle(TBGetFR(rect(0, HeaderRect.TOP, DisplayRect.Right, HeaderRect.bottom)));
end;

procedure TThumbsBrowser.SetStyleColumnsSize(const theStyle: TTB_Browser_Style);
var
  ThumbAreaW: integer;
begin
  CalcBasicLayout(fSampleThumb, true);
  ThumbAreaW := max(1, TBGetRectWidth(fSampleThumb.GetRect(HitThumbArea)));

  case theStyle of
    tbStyle_Custom:
      ;
    tbStyle_ThumbsH:
      ;
    tbStyle_ThumbsV:
      ;
    tbStyle_DetailsH, tbStyle_DetailsV:
      fStyleOptions.CaptionsOptions.SizePerc_HorzLayout :=
        max(200, min(400, round((TBGetRectWidth(DisplayRect) div 2) / ThumbAreaW * 100)));
    tbStyle_Columns:
      fStyleOptions.CaptionsOptions.SizePerc_HorzLayout :=
        max(1, round((TBGetRectWidth(DisplayRect) - 10 - ThumbAreaW) / ThumbAreaW * 100));
  end;

end;

procedure TThumbsBrowser.SetStyleEx(const theStyle: TTB_Browser_Style;
  const theCaptions: TTB_Thumb_CaptionsSettings = []; dbThumbZoom: double = -1; const bAdjustSpacing: boolean = true;
  const bAdjustStyle: boolean = true);
var
  ratio: double;
  bufSize: integer;
begin

  LockStyle;
  LockLayout;
  try
    fStyleOptions.BrowserStyle := theStyle;

    // step1
    if theCaptions <> [] then
      ThumbCaption_Settings := theCaptions;
    if dbThumbZoom = -1 then
    begin
      case theStyle of
        tbStyle_ThumbsH, tbStyle_ThumbsV:
          dbThumbZoom := 80;
        tbStyle_DetailsH, tbStyle_DetailsV:
          dbThumbZoom := 50;
        tbStyle_Columns:
          dbThumbZoom := 32;
      else
        dbThumbZoom := 100;
      end;
    end;

    if (fSampleThumb.SizeOffScreen > 0) and (StoreType <> tbstore_FullImage) then
      bufSize := fSampleThumb.SizeOffScreen
    else
      bufSize := 150;

    ratio := fBackupLayoutThumb.SizeOnScreenW / max(1, fBackupLayoutThumb.SizeOnScreenH);
    ThumbSizeW := max(10, round(ratio * bufSize * dbThumbZoom / 100));
    ThumbSizeH := max(10, round(1 / ratio * bufSize * dbThumbZoom / 100));

    ThumbsFrameRoundnessPerc := fBackupLayoutThumb.FrameRoundnessPerc;
    ThumbsCaptionRoundnessPerc := fBackupLayoutThumb.CaptionRoundnessPerc;

    // step 2
    case theStyle of
      tbStyle_ThumbsH, tbStyle_ThumbsV:
        begin
          if theStyle = tbStyle_ThumbsH then
          begin
            BrowsingOrientation := tbo_horz;
            Centered := false;
            MaxCols := -1;
            MaxRows := -1;
          end
          else
          begin
            BrowsingOrientation := tbo_vert;
            Centered := true;
            MaxCols := -1;
            MaxRows := -1;
          end;
          ThumbLayoutType := ltVertical;
          fStyleOptions.CaptionsOptions.Style := capSt_RowsCentered;
        end;
      tbStyle_DetailsH, tbStyle_DetailsV:
        begin
          if theStyle = tbStyle_DetailsH then
          begin
            BrowsingOrientation := tbo_horz;
            Centered := false;
            MaxCols := -1;
            MaxRows := -1;
          end
          else
          begin
            BrowsingOrientation := tbo_vert;
            Centered := false;
            MaxCols := -1;
            MaxRows := -1;
          end;

          ThumbLayoutType := ltHorizontal;

          CalcBasicLayout(fSampleThumb, true);
          fStyleOptions.CaptionsOptions.Style := capSt_Rows;
          SetStyleColumnsSize(tbStyle_DetailsV);

        end;
      tbStyle_Columns:
        begin

          BrowsingOrientation := tbo_vert;
          Centered := false;
          MaxCols := 1;
          MaxRows := -1;

          ThumbLayoutType := ltHorizontal;
          fStyleOptions.CaptionsOptions.Style := capSt_Cols;
          SetStyleColumnsSize(tbStyle_Columns);
        end
    else
      begin // includes custom style
        MaxCols := -1;
        MaxRows := -1;
        fStyleOptions.CaptionsOptions.Style := capSt_RowsCentered;
      end;
    end;

    // step 3
    if bAdjustSpacing then
    begin
      case theStyle of
        tbStyle_ThumbsH:
          begin
            ThumbsSpacingX := 3;
            ThumbsSpacingY := 6;
          end;
        tbStyle_ThumbsV:
          begin
            ThumbsSpacingX := 6;
            ThumbsSpacingY := 3;
          end;
        tbStyle_DetailsH, tbStyle_DetailsV:
          begin
            ThumbsSpacingX := 6;
            ThumbsSpacingY := 2;
          end;
        tbStyle_Columns:
          begin
            ThumbsSpacingX := 8;
            ThumbsSpacingY := 0;
          end;
      else
        begin // includes custom style
          ThumbsSpacingX := 4;
          ThumbsSpacingY := 4;
        end;
      end;
    end;

    if bAdjustStyle then
    begin
      case theStyle of
        tbStyle_DetailsH, tbStyle_DetailsV:
          begin
            ThumbsFrameSize := 1;
            ThumbCaptionIncludeInFrame := true;
          end;
        tbStyle_Columns:
          begin
            ThumbsFrameSize := 0;
            ThumbCaptionIncludeInFrame := false;
            ThumbsFrameRoundnessPerc := 0;
            ThumbsCaptionRoundnessPerc := 0;
          end;
      else
        begin // includes custom style
          ThumbsFrameSize := 2;
          ThumbCaptionIncludeInFrame := false;
        end;
      end;
    end;
  finally
    UnLockLayout(false);
    UnLockStyle;
    SetStyle(false);
  end;

  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetStyle(const bUpdate: boolean);
begin
  if fStyleLocked > 0 then
    EXIT;

  fSampleThumb.CaptionStyle := fStyleOptions.CaptionsOptions.Style;
  InitCaptionInfos;
  if bUpdate then
    ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.LockStyle;
begin
  inc(fStyleLocked);
end;

procedure TThumbsBrowser.UnLockStyle;
begin
  if fStyleLocked > 0 then
    dec(fStyleLocked);
end;

procedure TThumbsBrowser.CheckApplyTheme;
begin
  if csLoading in ComponentState then
    EXIT;
  if csDesigning in ComponentState then
    EXIT;

  if not(fStyleOptions.ThemeEnabled) then
    EXIT;
  if fStyleLocked > 0 then
    EXIT;

  fStyleOptions.RefreshThemeInfo;

  LockStyle;
  LockLayout;
  try
    if thmcl_BrowserBg in fStyleOptions.ThemeColorOptions then
    begin
      BackgroundColor := NwscompsStyle_GetColor(clWindow);
      Background2ndColor := NwscompsStyle_GetColor(clScrollBar);
    end;
    if thmcl_FrameBg in fStyleOptions.ThemeColorOptions then
      ThumbsFrameBgColor := NwscompsStyle_GetColor(clWindow);
    if thmcl_FrameBgSel in fStyleOptions.ThemeColorOptions then
      ThumbsFrameBgSelectedColor := NwscompsStyle_GetColor(clHighlight);
    if thmcl_CaptionBg in fStyleOptions.ThemeColorOptions then
    begin
      ThumbsCaptionBackColor := NwscompsStyle_GetColor(clbtnFace);
      ThumbsTopTitleBackColor := NwscompsStyle_GetColor(clWindow);
      ThumbsBottomTitleBackColor := NwscompsStyle_GetColor(clWindow);
    end;
    if thmcl_CaptionBgSel in fStyleOptions.ThemeColorOptions then
    begin
      ThumbsCaptionBackSelectedColor := NwscompsStyle_GetColor(clHighlight);
      ThumbsTopTitleBackSelectedColor := NwscompsStyle_GetColor(clHighlight);
      ThumbsBottomTitleBackSelectedColor := NwscompsStyle_GetColor(clHighlight);
    end;
    if thmcl_CaptionFont in fStyleOptions.ThemeColorOptions then
    begin
      ThumbsCaptionFontColor := NwscompsStyle_GetColor(clbtnText);
      ThumbsTopTitleFontColor := NwscompsStyle_GetColor(clbtnText);
      ThumbsBottomTitleFontColor := NwscompsStyle_GetColor(clbtnText);
    end;
    if thmcl_CaptionFontSel in fStyleOptions.ThemeColorOptions then
    begin
      ThumbsCaptionFontSelectedColor := NwscompsStyle_GetColor(clHighlightText);
      ThumbsTopTitleFontSelectedColor := NwscompsStyle_GetColor(clHighlightText);
      ThumbsBottomTitleFontSelectedColor := NwscompsStyle_GetColor(clHighlightText);
    end;
    if thmcl_FrameBorder in fStyleOptions.ThemeColorOptions then
      ThumbsFrameBorderColor := NwscompsStyle_GetColor(clScrollBar);
    if thmcl_FrameBorderSel in fStyleOptions.ThemeColorOptions then
      ThumbsFrameBorderSelectedColor := NwscompsStyle_GetColor(clHighlight);
  finally
    UnLockLayout(false); // do not reassign layout inside here
    ReassignThumbsLayout(false, false); // but do it here specifying we do not need to refresh captions
    UnLockStyle;
    Update;

  end;

end;

procedure TThumbsBrowser.DoTimedEvent(eventConst: nativeint; interval: integer;
  const bCheckEventAlreadyStarted: boolean);
var
  aTimer: TTimer;
begin
  if bCheckEventAlreadyStarted and (gettickcount - fLastEventStarted[eventConst] < 1.1 * interval) then
    EXIT; // >>>> EXIT

  aTimer := TTimer.Create(self); // we need the timer otherwise there are errors!!
  aTimer.enabled := false;
  aTimer.interval := interval;
  aTimer.Tag := eventConst;
  aTimer.OnTimer := HandleTimedEvent;
  fLastEventStarted[eventConst] := gettickcount;
  aTimer.enabled := true;
end;

procedure TThumbsBrowser.HandleTimedEvent(sender: TObject);
var
  aTimer: TTimer;
  eventConst: integer;
begin
  aTimer := TTimer(sender);
  aTimer.enabled := false;
  eventConst := aTimer.Tag;
  try
    case eventConst of
      TIMEDEVENT_UPDATEVCLSTYLE:
        CheckApplyTheme;
      TIMEDEVENT_REPAINT:
        begin
          Invalidate;
          Update;
        end;
      TIMEDEVENT_AFTERRESIZE:
        begin
          if fStyleOptions.BrowserStyle = tbStyle_Columns then
            SetStyleColumnsSize(tbStyle_Columns);
        end;
    end;

  finally
    fLastEventStarted[eventConst] := RESETTIMEDEVENT;
    Freeandnil(aTimer);
  end;

end;

procedure TThumbsBrowser.UpdateVCLStyle;
begin
  inherited;

  if csLoading in ComponentState then
    EXIT;
  if csDesigning in ComponentState then
    EXIT;

  if fVCLStyleLocked > 0 then
    EXIT;

  LockVCLStyle;
  try
    DoTimedEvent(TIMEDEVENT_UPDATEVCLSTYLE, 150, true);
  finally
    UnLockVCLStyle;
  end;
end;

procedure TThumbsBrowser.CalcBrowserUsefulRect;
begin

  fBrowserRectNoBorders.left := min(clientrect.Width - 1, clientrect.left + fBrowserOwnMarginLeft);
  fBrowserRectNoBorders.TOP := min(clientrect.Height - 1, clientrect.TOP + fBrowserOwnMarginTop);
  fBrowserRectNoBorders.Right := max(0, clientrect.Width - fBrowserOwnMarginRight - 1);
  fBrowserRectNoBorders.bottom := max(0, clientrect.Height - fBrowserOwnMarginBottom - 1);

  // fBrowserRectNoBorders := clientrect;
end;

procedure TThumbsBrowser.MouseUp(Button: TMouseButton; shift: TShiftState; X, Y: integer);
begin
  fMouseDownFlag := false;

  if (not fdoubleclickFlag) then
    DoOnThumbsAreaMouseUp(self, Button, shift, X, Y);
  inherited;
end;

procedure TThumbsBrowser.MouseDown(Button: TMouseButton; shift: TShiftState; X, Y: integer);
begin
  inherited;
  DoubleBufferTrick(false, self);

  fShiftFlag := ssshift in shift;
  fCTRLFlag := ssCtrl in shift;

  // TBEndDrag;
  fMouseDownFlag := true;
  fMouseDownPoint := point(X, Y);
  if fdoubleclickFlag then
  begin
    fdoubleclickFlag := false;
    fMouseDownFlag := false;
    EXIT; // exits here
  end;

  SetFocus;

  fResizingHeader := false;
  fMovingHeader := false;

  fHeaderSelectedColIdx := -1;
  fHeaderResizedColIdx := GetHeaderResizeColbyMouse(X, Y);
  if fHeaderResizedColIdx <> -1 then
  begin
    fResizingHeader := true;
    CopyColumnsForMouseMove;
  end
  else
  begin
    fHeaderSelectedColIdx := GetHeaderColbyMouse(X, Y);
  end;
end;

function TThumbsBrowser.CheckShowInfoBox(theThumb: TThumbEx; thIdx: integer; mouseX, mouseY: integer;
  bVisualChange: boolean): boolean;
var
  Pt: TPoint;
  rb: Trect;
begin
  result := false;
  if not assigned(theThumb) then
    EXIT;

  Pt := PtBrowser2Thumb(point(mouseX, mouseY), thIdx);
  rb := theThumb.GetRect(HitInsideGeneral);

  if not TBIsPointInRect(Pt, rb) then
  begin
    EXIT;
  end;

  theThumb.ShowSettings := theThumb.ShowSettings + [th_ShowInfoBox];
  result := true;

  if bVisualChange then
  begin
    RefreshThumb(thIdx, true);
  end;

end;

function TThumbsBrowser.CheckChangeVisualRating(theThumb: TThumbEx; thIdx: integer; mouseX, mouseY: integer;
  bVisualChange: boolean): integer;
var
  Pt: TPoint;
  rb: Trect;
  memRating: integer;
  starW: integer;
begin
  result := -1;
  if not assigned(theThumb) then
    EXIT;

  if not fShowRatingBox then
    EXIT;

  Pt := PtBrowser2Thumb(point(mouseX, mouseY), thIdx);
  rb := theThumb.GetRect(HitRatingBox);

  if not TBIsPointInRect(Pt, rb) then
  begin

    EXIT;
  end;

  starW := ((rb.Right - rb.left + 1) div 5);
  result := 1 + trunc((Pt.X - rb.left) / starW);
  if (result = 1) and ((Pt.X - rb.left) / starW < 0.35) then
    result := 0;

  // this is not a clean solution
  // better to set another property of the thumb called tempRating
  // when the Rating is set tempRating will be also set to the actual value
  // when changing only tempRating, when the thumb refreshes the rating
  // will first check if tempRating is different from the rating
  // if so it will use the tempRating value
  if bVisualChange then
  begin
    memRating := theThumb.Rating;
    theThumb.Events_Lock; // need to lock event to avoid synchronization of metadata!!
    try
      theThumb.Rating := result;
      RefreshThumb(thIdx, true);
    finally
      theThumb.Rating := memRating;
      theThumb.Events_UnLock;
    end;
  end;
end;

procedure TThumbsBrowser.RestoreMouseOver(thIdx: integer);
var
  athumb: TThumbEx;
begin
  if (thIdx = -1) then
    EXIT;
  athumb := Thumbat(thIdx);

  if not assigned(athumb) then
    EXIT;
  { //commented out - need to check the type of thumb (file, folder, etc..)
    //and need to check which settings to enable
    aThumb.Layout_Lock;
    try

    if aThumb.ShowSettings <> fsamplethumb.ShowSettings then
    aThumb.ShowSettings := fsamplethumb.ShowSettings;
    finally
    aThumb.Layout_UnLock;
    end;
  }

  RefreshThumb(thIdx);
end;

procedure TThumbsBrowser.RestoreMouseOver(theThumb: TThumbEx);
begin
  if theThumb = nil then
    EXIT;

  RestoreMouseOver(fVisibleThumbs.IndexOf(theThumb));
end;

procedure TThumbsBrowser.MouseMove(shift: TShiftState; X, Y: integer);

var
  athumb: TThumbEx;
  sHint: string;
  thIdx: integer;
  moOptions: TThumbsBrowserMouseOverOptions;
  bRefreshThumb: boolean;
  bChangeMOThumb: boolean;
  hitResult: TTB_Thumb_HitRectResult;
begin
  inherited;
  if fdoubleclickFlag then
    EXIT;

  if fMouseDownFlag and fResizingHeader then
  begin
    ResizeHeaderColumn(fHeaderResizedColIdx, fMouseDownPoint.X, X);
    EXIT;
  end;

  if fMouseDownFlag and (fHeaderSelectedColIdx <> -1) then
  begin
    if (not fMovingHeader) and ((abs(X - fMouseDownPoint.X) > 5) or (abs(Y - fMouseDownPoint.Y) > 5)) then
    begin
      CopyColumnsForMouseMove;
      fMovingHeader := true;
    end;
  end;

  fHeaderCurColIdx := GetHeaderColbyMouse(X, Y);
  if fHeaderCurColIdx <> fHeaderOldCurCol then
  begin
    DrawReportHeader(fHeaderCurColIdx);
    fHeaderOldCurCol := fHeaderCurColIdx;
  end;

  if fResizingHeader then
    inherited Cursor := crHSplit
  else if GetHeaderResizeColbyMouse(X, Y) <> -1 then
    inherited Cursor := crHSplit
  else if fHeaderCurColIdx <> -1 then
  begin
    inherited Cursor := crdefault;
  end
  else
    inherited Cursor := fCursor;

  if fMovingHeader then
  begin
    MoveHeaderColumn(fHeaderSelectedColIdx, fMouseDownPoint.X, X);
    EXIT;
  end;

  if fHeaderCurColIdx <> -1 then
  begin
    if fShowThumbnailHint then
      Application.CancelHint;

    EXIT;
  end;

  // ---------------------------
  thIdx := GetThumbIdxbyMousexy(X, Y);
  athumb := Thumbat(thIdx); // get the thumb on which the mouse is moving
  // aThumb :=  thumbat(x, y);  //get the thumb on which the mouse is moving
  // ---------------------------
  if not assigned(athumb) then
    EXIT; // >>>>EXIT

  // check if starting a dragdrop operation
  if fMouseDownFlag and DragDropOptions.IsDDSource and
    ((abs(X - fMouseDownPoint.X) > 5) or (abs(Y - fMouseDownPoint.Y) > 5)) and // a drag/drop action has started
    (not SharedDragDrop_Handler.DraggingActive) then
  begin
    // inside here dragdrop things

    ResetMouseHover;

    if assigned(athumb) then
    begin
      // if dragged thumb is not selected, we select it first
      if not athumb.SELECTED then
        DoOnThumbsAreaMouseUp(self, TMouseButton(nil), shift, X, Y);
    end;

    if (fSelectedThumbs.Count > 0) then
    begin
      SharedDragDrop_Handler.NotifyStartDragRequest(self, point(X, Y));
    end;

  end
  else
  begin // normal mousemove
    hitResult := athumb.GetMouseHitResult(XBrowser2Thumb(X, thIdx), YBrowser2Thumb(Y, thIdx));
    case hitResult of
      HitCheck, HitRotateButtonLeft, HitRotateButtonRight, HitInfoBox, HitRatingBox, HitTopTitle, HitBottomTitle:
        inherited Cursor := CursorPointed;
    else
      inherited Cursor := Cursor;
    end;

    moOptions := [mooShowMouseOverEffect, mooAllowChangeRating];
    if assigned(fOnThumbMouseOver) then
      fOnThumbMouseOver(athumb, thIdx, moOptions);

    bChangeMOThumb := (athumb <> fMouseHoverThumb);
    if bChangeMOThumb then
    begin
      fMouseHoverThumb := athumb;
      RestoreMouseOver(fMouseHoverThIdx);
      fMouseHoverThIdx := thIdx;
    end;

    if (mooAllowChangeRating in moOptions) then // if allows rating changing
      CheckChangeVisualRating(athumb, thIdx, X, Y, true);

    bRefreshThumb := (mooShowMouseOverEffect in moOptions) and bChangeMOThumb;

    if (mooShowInfoBox in moOptions) and (not(th_ShowInfoBox in athumb.ShowSettings)) then // if show info box
    begin
      if CheckShowInfoBox(athumb, thIdx, X, Y, false) then
        bRefreshThumb := true;
    end;

    if (bRefreshThumb) then // mouse over thumb changed
    begin
      RefreshThumb(thIdx, true);

      if (mooShowMouseOverEffect in moOptions)
         and (not self.Focused) and
          (not fScroller.Focused) and
           (self.CanFocus) and (GetParentForm(self).Active)
      then
        self.SetFocus;
    end;

    if fShowThumbnailHint then
    begin
      if assigned(athumb) then
      begin
        if (TBIsPointInRect(PtBrowser2Thumb(point(X, Y), thIdx), athumb.GetRect(HitInsideGeneral))) then
        begin

          sHint := athumb.GetHintText;
          if assigned(fOnItemHintText) then
            fOnItemHintText(athumb, thIdx, sHint);

          if (sHint <> Hint) or (thIdx <> fHintThumbIdx) then
          begin
            Application.CancelHint;
            Hint := sHint;
            fHintThumbIdx := thIdx;
          end;

        end
        else
        begin
          Hint := '';
        end;
      end
      else
      begin
        Hint := '';
      end;
    end;
  end;

end;

procedure TThumbsBrowser.DblClick;
var
  curPos: TPoint;
  athumb: TThumbEx;
  aFolder: string;
begin
  fdoubleclickFlag := true;
  if fFolderNavigation then
  begin
    curPos := self.ScreenToClient(mouse.CursorPos);

    athumb := Thumbat(curPos.X, curPos.Y);
    if assigned(athumb) and ((athumb.SourceType = st_Folder) or (athumb.SourceType = st_folderNav)) then
    begin
      aFolder := athumb.SourceFileName;
      NavigateToFolder(aFolder);
    end
{$IFDEF TB_PORTABLEDEVICE}
    else if assigned(athumb) and ((athumb.SourceType = st_WPDFolder) or (athumb.SourceType = st_WPDFolderNav)) then
    begin
      NavigateToWPDFolder(fBrowser_WPD.ActiveDeviceID, athumb.AttachedWPDInfo.Rcd.ID);
    end
{$ENDIF}
    else
      inherited;

  end
  else
    inherited;
end;

procedure TThumbsBrowser.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  ResetMouseHover;
  Application.HintHidePause := fMemAppHintHidePause;
  Application.HintShortPause := fMemAppHintShortPause;
  Application.HintPause := fMemAppHintPause;
end;

procedure TThumbsBrowser.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  fMemAppHintHidePause := Application.HintHidePause;
  fMemAppHintShortPause := Application.HintShortPause;
  fMemAppHintPause := Application.HintPause;
  Application.HintHidePause := 8000;
  Application.HintShortPause := 1600;
  Application.HintPause := 1000;
end;

procedure TThumbsBrowser.TBBeginDrag;
begin
  BeginDrag(true);
end;

procedure TThumbsBrowser.TBEndDrag;
begin
  fMouseDownFlag := false;

  RefreshDisplay;
end;

procedure TThumbsBrowser.KeyDown(var Key: Word; shift: TShiftState);
var
  scp: integer;
begin
  inherited;

  fShiftFlag := ssshift in shift;
  fCTRLFlag := ssCtrl in shift;

  scp := fScrollParams.Pos;

  case Key of
    VK_TAB:
      ;
    VK_LEFT:
      ;
    VK_RIGHT:
      ;
    VK_UP:
      begin
        scp := scp - fScrollParams.SmallChange;
      end;
    VK_DOWN:
      begin
        scp := scp + fScrollParams.SmallChange;
      end;
    VK_PRIOR:
      begin
        scp := scp - fScrollParams.LargeChange;
      end;
    VK_NEXT:
      begin
        scp := scp + fScrollParams.LargeChange;
      end;
    VK_HOME:
      begin
        scp := fScroller.min;
      end;
    VK_END:
      begin
        scp := fScroller.max;
      end;
    VK_RETURN:
      ;
    VK_EXECUTE:
      ;
    VK_ESCAPE:
      ;
    VK_CANCEL:
      ;
  end;

  if scp <> fScrollParams.Pos then
    SetScrollPosition(self, fScrollParams.Pos, scp);

end;

procedure TThumbsBrowser.KeyUp(var Key: Word; shift: TShiftState);
begin
  inherited;
  fLastShiftClickedID_s := -1;
  fLastShiftClickedID_e := -1;
  fShiftFlag := false;
  fCTRLFlag := false;
end;

procedure TThumbsBrowser.FireOnFinishLoading;
begin
  if assigned(fOnfinishedLoading) then
    fOnfinishedLoading(self);
end;

procedure TThumbsBrowser.FireOnStartedLoading;
begin
  if assigned(fOnStartedLoading) then
    fOnStartedLoading(self);
end;

function TThumbsBrowser.GetReaderFunction(TheFileExt: string): TTB_Browser_FileReaderFunction;
var
  I: integer;
begin
  result := nil;
  if fAllowCustomformat_ExternalReader then
  begin
    for I := low(fUserFileFormats_Read) to high(fUserFileFormats_Read) do
    begin
      if comparetext(TheFileExt, fUserFileFormats_Read[I].Extension) = 0 then
      begin
        result := fUserFileFormats_Read[I].ReaderFunction;
        break;
      end;
    end;
  end;
end;

function TThumbsBrowser.GetResampleMethod: TResamplefilter;
begin
  result := fSampleThumb.ResampleFilter;
end;

procedure TThumbsBrowser.Loader_CreateNew;
begin

  FireOnStartedLoading;
  fLoader := nil;
  fLoader := TThumbsLoader.Create(fLoaderDBSessionGuid, self, fMultithread, fMultithread_Pool_Count,
    fMultithread_Timeout);

  fLoader.OnDebug := DoOnLoaderDebug;

  fLoader.OnThumbLoaded := DoOnAfterThumbLoaded;
  fLoader.OnAllThumbsLoaded := DoOnAfterALLThumbsLoaded;
  fLoader.OnBeforeThumbLoaded := DoOnBeforeThumbLoaded;
  fLoader.OnInitialized := DoAfterLoaderInitialized;

end;

procedure TThumbsBrowser.LoadFile(const theFilename: string);
var
  fl: TStringList;
begin
  fl := TStringList.Create;
  fl.Add(theFilename);
  try
    StartBrowsing(fl);
  finally
    fl.Free;
  end;
end;

procedure TThumbsBrowser.LoadFiles(filenames: TStringList);
begin
  StartBrowsing(filenames, true);
end;

procedure TThumbsBrowser.CreateInfoForm(theThumb: TThumbEx; const thumbIdx: integer;
  theEmbeddingPanel: TCustomPanel = nil);
begin
  CreateInfoForm(0, 0, theEmbeddingPanel);
  CreateInfoForm(XThumb2Browser(-(fThumbsbrowser_InfoForm.Width - theThumb.TotalWidth) div 2, thumbIdx),
    YThumb2Browser(theThumb.TotalHeight, thumbIdx), theEmbeddingPanel);

end;

procedure TThumbsBrowser.CreateInfoForm(const PosX, PosY: integer; theEmbeddingPanel: TCustomPanel = nil);
var
  p: TPoint;
begin
  if not assigned(fThumbsbrowser_InfoForm) then
  begin
    if theEmbeddingPanel = nil then
    begin
      fThumbsbrowser_InfoForm := TThumbsbrowser_InfoForm.Create(self);
      FInfoFormEmbeddingPanel := nil;
    end
    else
    begin
      fThumbsbrowser_InfoForm := TThumbsbrowser_InfoForm.Create(theEmbeddingPanel);
      fThumbsbrowser_InfoForm.Parent := theEmbeddingPanel;
      fThumbsbrowser_InfoForm.Align := alClient;
      fThumbsbrowser_InfoForm.BorderStyle := bsNone;
      fThumbsbrowser_InfoForm.BorderIcons := [biSystemMenu];
      fThumbsbrowser_InfoForm.BorderWidth := 0;
      FInfoFormEmbeddingPanel := theEmbeddingPanel;
    end;

    // Ask Child to notify us when it is destroyed
    fThumbsbrowser_InfoForm.FreeNotification(self);

    fThumbsbrowser_InfoForm.OnClose := DoAfterInfoClose;
    fThumbsbrowser_InfoForm.OnSaveFileMetadata := DoAfterInfoAcceptChanges;
    fThumbsbrowser_InfoForm.OnAcceptFilenameChange := DoAfterInfoRenameFile;
  end;

  if not FInfoFormOpened then
  begin
    p := self.clienttoscreen(point(0, 0));
    fThumbsbrowser_InfoForm.left := p.X + PosX;
    fThumbsbrowser_InfoForm.TOP := p.Y + PosY;

    fThumbsbrowser_InfoForm.TOP := min(screen.Height - fThumbsbrowser_InfoForm.Height - 10,
      max(0, fThumbsbrowser_InfoForm.TOP));
    fThumbsbrowser_InfoForm.left := min(screen.Width - fThumbsbrowser_InfoForm.Width,
      max(0, fThumbsbrowser_InfoForm.left));
  end;
end;

procedure TThumbsBrowser.ShowInfo(theEmbeddingPanel: TCustomPanel = nil);
var
  aWpd: TObject;
begin
  if fSelectedThumbs.Count <= 0 then
  begin
    ShowInfo(fLastClickedThumb, theEmbeddingPanel);
    EXIT; // >>>>EXIT
  end;

  CreateInfoForm(0, 0, theEmbeddingPanel);

  aWpd := nil;
{$IFDEF TB_PORTABLEDEVICE}
  aWpd := fBrowser_WPD;
{$ENDIF}
  fThumbsbrowser_InfoForm.Launch_Multi(fSelectedThumbs, fBrowser_WIA_IO, aWpd, fMetaTags, fMetaData_Options,
    fOnMetadataVisibility);

  if not FInfoFormOpened then
    fThumbsbrowser_InfoForm.ApplyFormStatus(fInfoForm_Status);

  FInfoFormOpened := true;

  if assigned(fOnInfoFormOpened) then
    fOnInfoFormOpened(self);
end;

procedure TThumbsBrowser.ShowInfo(theThumb: TThumbEx; theEmbeddingPanel: TCustomPanel = nil);
var
  Idx: integer;
  aWpd: TObject;
begin
  if fVisibleThumbs.Count <= 0 then
    EXIT;
  if not assigned(theThumb) then
    EXIT;

  Idx := fVisibleThumbs.IndexOf(theThumb);

  CreateInfoForm(theThumb, Idx, theEmbeddingPanel);

  aWpd := nil;
{$IFDEF TB_PORTABLEDEVICE}
  aWpd := fBrowser_WPD;
{$ENDIF}
  fThumbsbrowser_InfoForm.Launch_Single(theThumb, Idx, fBrowser_WIA_IO, aWpd, fMetaTags, fMetaData_Options,
    fOnMetadataVisibility);

  if not FInfoFormOpened then
    fThumbsbrowser_InfoForm.ApplyFormStatus(fInfoForm_Status);

  FInfoFormOpened := true;

  if assigned(fOnInfoFormOpened) then
    fOnInfoFormOpened(self);
end;

procedure TThumbsBrowser.CloseInfo;
begin
  if FInfoFormOpened and (assigned(fThumbsbrowser_InfoForm)) then
    fThumbsbrowser_InfoForm.close;

end;

procedure TThumbsBrowser.InitSampleThumb;
begin
  fSampleThumb.Layout_Lock;
  fSampleThumb.Events_Lock;
  try
    with fSampleThumb do
    begin
      ExploringStatus := thbNotExplored;
      UserObject := nil;
      OnVisibleChange := nil;

      InternetOptions := self.InternetOptions;
      DropShadowOptions := self.ThumbDropShadow;
      SourceExifFileDate := -1;
      IEBitmap.Width := 0;
      IEBitmap.Height := 0;
      Resources := self.LayoutResources;
      captionfont := self.Font;
      BrowserStyleOptions := fStyleOptions;
      CaptionStyle := fStyleOptions.CaptionsOptions.Style;

      TryReadExplorerThumb := true;
      // RotateButtonsStyle := self.fOtherOptions.RotateButtonsStyle;
      OnVisibleChange := self.NotifyChangeThumbVisibility;
      OnSelectedChange := self.NotifyChangeThumbSelected;
      OnCheckedChange := self.NotifyChangeThumbChecked;
      OnRotatedChange := self.NotifyChangeThumbRotated;
      OnBufferLoaded := self.NotifyThumbBufferLoaded;

      OnGetCaptionInfo := self.NotifyGetCaptionInfo;
      OnGetCaptionIdx := self.NotifyGetCaptionIndex;
      OnCustomDrawPicture := self.NotifyDrawThumbPicture;
      OnCustomDrawFrame := self.NotifyDrawThumbFrame;
      OnCustomDrawCaption := self.NotifyDrawThumbCaption;
      OnCustomDrawThumbBackground := self.NotifyDrawThumbBackground;
      OnCustomDrawTopTitle := self.NotifyDrawThumbTopTitle;
      OnCustomDrawBottomTitle := self.NotifyDrawThumbBottomTitle;
      OnCustomDrawAfterDraw := self.NotifyDrawAfterDraw;

      OnSyncPropertyChanged := self.Handle_ThumbSyncPropertyChanged;

    end;
  finally
    fSampleThumb.Events_UnLock;
    fSampleThumb.Layout_Unlock;
  end;

  fBackupLayoutThumb.AssignLayout(fSampleThumb, true); // make backup of thumb
end;

procedure TThumbsBrowser.CalcLayout(theThumb: TThumbEx);
var
  bscroller_visible: boolean;
begin
  if theThumb = nil then
    EXIT; // >>>>EXIT

  // Calculate all layout as if the browser needs scrollbars
  // ---------------------------------------------------------
  CalcBasicLayout(theThumb, true);
  SetScrollerParams;
  // ---------------------------------------------------------

  if fVisibleThumbs.Count = 0 then
    EXIT; // >>>>EXIT  needed to avoid access violation in ThumbAt!

  if (fBrowserOrientation = tbo_vert) and (YThumb2DisplaySimul(0, 0, 0) >= 0) and
    (YThumb2DisplaySimul(Thumbat(fVisibleThumbs.Count - 1).TotalHeight, fVisibleThumbs.Count - 1, 0) <=
    fDisplayBackBuffer.Height) then
  // (fNRows * fpassoy + fspacingY - fDisplayBackBuffer.height <= 0) then
  begin
    bscroller_visible := false;
    CalcBasicLayout(theThumb, false);
  end
  else if (fBrowserOrientation = tbo_horz) and (XThumb2DisplaySimul(0, 0, 0) >= 0) and
    (XThumb2DisplaySimul(Thumbat(fVisibleThumbs.Count - 1).TotalWidth, fVisibleThumbs.Count - 1, 0) <=
    fDisplayBackBuffer.Width) then
  // (fNColumns * fpassox + fspacingX - fDisplayBackBuffer.width <= 0) then
  begin
    bscroller_visible := false;
    CalcBasicLayout(theThumb, false);
  end
  else
  begin
    bscroller_visible := true;
    // CalcBasicLayout(thethumb, true);
  end;

  if fScrollerBox.Visible <> bscroller_visible then
  begin
    SetScrollerBoxVisible(bscroller_visible);
    if (not fScrollerBox.Visible) then
    begin
      SetScrollerParams;
      SetScrollPosition(self, fScrollParams.Pos, fScroller.min);
    end;
  end;

  fTopRow := min(fNRows - 1, ScrollerPos_To_VirtualPos(fScrollParams.Pos) div fpassoy);
  fBottomRow := min(fNRows - 1, (ScrollerPos_To_VirtualPos(fScrollParams.Pos) + fDisplayBackBuffer.Height) div fpassoy);
  fTopColumn := min(fNColumns - 1, ScrollerPos_To_VirtualPos(fScrollParams.Pos) div fpassox);
  fBottomColumn := min(fNColumns - 1, (ScrollerPos_To_VirtualPos(fScrollParams.Pos) + GetAvailableBackBufferWidth)
    div fpassox);

  case fBrowserOrientation of
    tbo_vert:
      begin
        fTopDisplayedThumbIdx := fTopRow * fNColumns;
        fBottomDisplayedThumbIdx := min(fVisibleThumbs.Count - 1, ((fBottomRow + 1) * fNColumns) - 1);
      end;
    tbo_horz:
      begin
        fTopDisplayedThumbIdx := fTopColumn * fNRows;
        fBottomDisplayedThumbIdx := min(fVisibleThumbs.Count - 1, ((fBottomColumn + 1) * fNRows) - 1);
      end;
  end;

end;

procedure TThumbsBrowser.CalcBasicLayout(theThumb: TThumbEx; bScrollerVisible: boolean);
begin
  if theThumb = nil then
    EXIT;

  CalcBrowserUsefulRect;

  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    fReportHeaderMargin := 0
  else
  begin
    canvas.Font := Font;
    fReportHeaderMargin := canvas.textheight('Test') + 8;
  end;

  if fDisplayBackBuffer.PixelFormat <> pf24bit then
    fDisplayBackBuffer.PixelFormat := pf24bit;
  fDisplayBackBuffer.canvas.Brush.Color := fBackgroundColor;

  case fBrowserOrientation of
    tbo_vert:
      begin
        fDisplayBackBuffer.Width := max(1, TBGetRectWidth(fBrowserRectNoBorders) - ord(bScrollerVisible) *
          fScrollerBox.Width);
        fDisplayBackBuffer.Height := max(1, TBGetRectHeight(fBrowserRectNoBorders) - GetBrowserTotalTopMargin);
        fScrollParams.Display_PageSize := fDisplayBackBuffer.Height;
      end;
    tbo_horz:
      begin
        fDisplayBackBuffer.Height := max(1, TBGetRectHeight(fBrowserRectNoBorders) - ord(bScrollerVisible) *
          fScrollerBox.Height);
        fDisplayBackBuffer.Width := max(1, TBGetRectWidth(fBrowserRectNoBorders));
        fScrollParams.Display_PageSize := fDisplayBackBuffer.Width;
      end;
  end;

  fBrowser_width := fDisplayBackBuffer.Width;
  fBrowser_height := fDisplayBackBuffer.Height;

  fpassox := theThumb.TotalWidth + 2 * fspacingX;
  fpassoy := theThumb.TotalHeight + 2 * fspacingY;
  fNRowsByPagef := GetAvailableBackBufferHeight / fpassoy;
  fNColumnsByPagef := GetAvailableBackBufferWidth / fpassox;

  fNRowsByPage := trunc(fNRowsByPagef);
  fNColumnsByPage := trunc(fNColumnsByPagef);

  case fBrowserOrientation of
    tbo_horz:
      fNRowsByPage := max(1, fNRowsByPage); // we do not allow this to become 0
    tbo_vert:
      fNColumnsByPage := max(1, fNColumnsByPage); // we do not allow this to become 0
  end;

  if fMaxCols > 0 then
  begin
    fNColumnsByPage := min(fMaxCols, fNColumnsByPage);
    fNColumnsByPagef := fNColumnsByPage;
  end;

  if fMaxRows > 0 then
  begin
    fNRowsByPage := min(fMaxRows, fNRowsByPage);
    fNRowsByPagef := fNRowsByPage;
  end;

  case fBrowserOrientation of
    tbo_vert:
      begin

        fNColumns_float := max(1, min(fVisibleThumbs.Count, fNColumnsByPagef));
        fNColumns := max(1, min(fVisibleThumbs.Count, fNColumnsByPage));

        fNRows_float := fVisibleThumbs.Count / fNColumns;
        fNRows := trunc(fNRows_float) + ord((fVisibleThumbs.Count mod fNColumns) <> 0);

        fScrollParams.Display_Maxlimited := max(1, fNRows * fpassoy + fDisplayMarginTop - fDisplayBackBuffer.Height);

        fScrollParams.Display_Min := 0;
        fScrollParams.Display_Max := max(1, (fNRows) * fpassoy + fDisplayMarginTop);

        if fCentered then
          fDynamicMarginX := max(0, (GetAvailableBackBufferWidth - fNColumnsByPage * fpassox) div 2)
        else
          fDynamicMarginX := 0;

        fDynamicMarginY := 0;
      end;
    tbo_horz:
      begin

        fNRows_float := max(1, min(fVisibleThumbs.Count, fNRowsByPagef));
        fNRows := max(1, min(fVisibleThumbs.Count, fNRowsByPage));

        fNColumns_float := fVisibleThumbs.Count / fNRows;
        fNColumns := trunc(fNColumns_float) + ord((fVisibleThumbs.Count mod fNRows) <> 0);

        fScrollParams.Display_Maxlimited := max(1, fNColumns * fpassox + fDisplayMarginLeft - fDisplayBackBuffer.Width);

        fScrollParams.Display_Min := 0;
        fScrollParams.Display_Max := max(1, (fNColumns) * fpassox + fDisplayMarginLeft);

        if fCentered then
          fDynamicMarginY := max(0, (GetAvailableBackBufferHeight - fNRowsByPage * fpassoy) div 2)
        else
          fDynamicMarginY := 0;
        fDynamicMarginX := 0;
      end;
  end;

end;

procedure TThumbsBrowser.SetScrollerParams;
begin

  if fScroller.min <> 0 then
    fScroller.min := 0;
  if fScroller.max <> 10000000 then
    fScroller.max := 10000000;

  fScrollParams.PageSize := VirtualPos_To_ScrollerPos(fScrollParams.Display_PageSize);
  if fScroller.PageSize <> fScrollParams.PageSize then
  begin
    fScroller.PageSize := fScrollParams.PageSize;

  end;

  fScrollParams.Display_SmallChange := fScrollParams.Display_PageSize div 3;
  fScrollParams.Display_LargeChange := fScrollParams.Display_PageSize;

  fScrollParams.SmallChange := VirtualPos_To_ScrollerPos(fScrollParams.Display_SmallChange);
  fScrollParams.LargeChange := VirtualPos_To_ScrollerPos(fScrollParams.Display_LargeChange);

  fScroller.SmallChange := fScrollParams.SmallChange;
  fScroller.LargeChange := fScrollParams.LargeChange;

end;

procedure TThumbsBrowser.PaintThumbToDisplay(athumb: TThumbEx; Idx: integer;
  const bQuickView, bRedrawBackground, bImmediateDisplay: boolean);
var
  bNeedToDraw: boolean;
  Pos: integer;
  r: Trect;
begin
  bNeedToDraw := athumb.Visible;
  case fBrowserOrientation of
    tbo_horz:
      begin
        Pos := GetThumbColumnbyIdx(Idx);
        bNeedToDraw := (Pos >= fTopColumn) and (Pos <= fBottomColumn);
      end;
    tbo_vert:
      begin
        Pos := GetThumbRowbyIdx(Idx);
        bNeedToDraw := (Pos >= fTopRow) and (Pos <= fBottomRow);
      end;
  end;

  if not bNeedToDraw then
    EXIT;

  r := RectThumb2Display(Idx);
  PaintThumbToDisplay(athumb, Idx, r.left, r.TOP, bQuickView, bRedrawBackground);

  if bImmediateDisplay then
    UpdateDisplayRect(r);
end;

procedure TThumbsBrowser.PaintThumbToDisplay(athumb: TThumbEx; Idx: integer; X, Y: integer; const bQuickView: boolean;
  const bRedrawBackground: boolean);
begin
  if (assigned(fOnThumbLoadDemand) and (not assigned(fOnThumbLoadDemandAsync))) then
  begin
    if (athumb.SourceType = st_General)
        and (athumb.ExploringStatus <> thbExplored)
        and (not athumb.Adjourned) then
    begin
      try
        fOnThumbLoadDemand(athumb, Idx);
        if assigned(fOnThumbLoaded) then
          fOnThumbLoaded(aThumb, idx);

      finally
        athumb.ExploringStatus := thbExplored;
      end;
    end;
  end;

  if bRedrawBackground then
    InvalidateBackBuffer(rect(X, Y, X + athumb.TotalWidth, Y + athumb.TotalHeight));

  athumb.PaintToCanvas(fDisplayBackBuffer.canvas, X, Y, fMouseHoverThumb = athumb, bQuickView);
end;

procedure TThumbsBrowser.RefreshThumb(Idx: integer; const bImmediateDisplay: boolean = true);

var
  athumb: TThumbEx;
  bQuickView: boolean;
begin
  if fUpdateLocked > 0 then
    EXIT; // >>>EXIT

  athumb := GetThumbfromList_Safe(fVisibleThumbs, Idx);
  if athumb = nil then
    EXIT;

  bQuickView := assigned(fLoader) and fLoader.Running;
  PaintThumbToDisplay(athumb, Idx, bQuickView, true, bImmediateDisplay);
end;

procedure TThumbsBrowser.RefreshListofThumbs(alist: TList);
var
  I: integer;
begin
  for I := 0 to alist.Count - 1 do
    RefreshThumb(fVisibleThumbs.IndexOf(TThumbEx(alist[I])), false);
  UpdateDisplay;
end;

procedure DrawCheckBoard(cv: Tcanvas; fr: Trect; const size: integer; const Color1, Color2: TColor);
var
  X, Y: integer;
  xd1, yd1, xd2, yd2: integer;
  HeadColor: TColor;
begin
  if fr.Right <= fr.left then
    EXIT;
  if fr.bottom <= fr.TOP then
    EXIT;

  X := 0;
  Y := 0;
  cv.Brush.Style := bsSolid;
  cv.Brush.Color := Color1;
  HeadColor := Color1;
  while (Y < fr.bottom) do
  begin
    if (X + size > fr.left) and (Y + size > fr.TOP) then
    begin
      xd1 := max(X, fr.left);
      yd1 := max(Y, fr.TOP);
      xd2 := min(X + size, fr.Right);
      yd2 := min(Y + size, fr.bottom);

      cv.fillrect(rect(xd1, yd1, xd2, yd2));
    end;

    X := X + size;
    if X >= fr.Right then
    begin
      X := 0;
      Y := Y + size;
      cv.Brush.Color := HeadColor;
      if HeadColor = Color1 then
        HeadColor := Color2
      else
        HeadColor := Color1;
    end;

    if cv.Brush.Color = Color1 then
      cv.Brush.Color := Color2
    else
      cv.Brush.Color := Color1;

  end;

end;

procedure TThumbsBrowser.InvalidateBackBuffer(r: Trect);
var
  grBmp: TIEBitmap;
  w, h: integer;
begin

  fDisplayBackBuffer.canvas.Brush.Style := bsSolid;
  fDisplayBackBuffer.canvas.Brush.Color := fBackgroundColor;

  case fBackgroundType of
    tbbgt_SolidColor:
      fDisplayBackBuffer.canvas.fillrect(r);
    tbbgt_CheckBoard:
      DrawCheckBoard(fDisplayBackBuffer.canvas, r, max(12, min(fDisplayBackBuffer.Width, fDisplayBackBuffer.Height)
        div 50), fBackgroundColor, fBackground2ndColor);
    tbbgt_Wallpaper:
      begin
        w := r.Right - r.left;
        h := r.bottom - r.TOP;

        if assigned(fLayoutResources) and fLayoutResources.HAS_Bg then
          fLayoutResources.bmp_Bg.RenderToCanvasWithAlpha(fDisplayBackBuffer.canvas, r.left, r.TOP, w, h, r.left,
            r.TOP, w, h)
        else
          fDisplayBackBuffer.canvas.fillrect(r);
      end;
    tbbgt_GradientH, tbbgt_GradientV:
      begin
        w := r.Right - r.left;
        h := r.bottom - r.TOP;

        if assigned(fLayoutResources) then
        begin
          grBmp := fLayoutResources.GetGradientBg(fDisplayBackBuffer.Width, fDisplayBackBuffer.Height, fBackgroundColor,
            fBackground2ndColor, fBackgroundType = tbbgt_GradientV);
          grBmp.RenderToTBitmapEx(fDisplayBackBuffer, r.left, r.TOP, w, h, r.left, r.TOP, w, h);
        end
      end
  else
    fDisplayBackBuffer.canvas.fillrect(r);
  end;

end;

function TThumbsBrowser.GetAvailableBackBufferWidth: integer;
begin
  result := (fDisplayBackBuffer.Width - fDisplayMarginLeft - fDisplayMarginRight);
end;

function TThumbsBrowser.GetAvailableBackBufferHeight: integer;
begin
  result := (fDisplayBackBuffer.Height - fDisplayMarginTop - fDisplayMarginBottom);
end;

procedure TThumbsBrowser.InitCaptionInfos;
var
  sumPerW: single;
  stdPerW: single;
  I: integer;
  cap: TTB_Thumb_CaptionsSetting;
begin

  if (fStyleOptions.CaptionsOptions.Style <> capSt_ColsCentered) and (fStyleOptions.CaptionsOptions.Style <> capSt_Cols)
  then
    EXIT;

  if (ThumbCaption_Settings = []) then
    stdPerW := 0
  else
    stdPerW := 100 / TBGetCap_Count(ThumbCaption_Settings);

  sumPerW := 0;
  // check current weights for columns and their sum
  for I := CAP_LOW_IDX to CAP_HIGH_IDX do
  begin
    cap := TTB_Thumb_CaptionsSetting(fThumbCaption_Info[I].capIdx);

    if cap in ThumbCaption_Settings then
    begin
      if fThumbCaption_Info[I].ColPercWidth = -1 then
        fThumbCaption_Info[I].ColPercWidth := stdPerW; // initialize this column with the standard value
      sumPerW := sumPerW + fThumbCaption_Info[I].ColPercWidth;
    end
    else
      fThumbCaption_Info[I].ColPercWidth := -1;
  end;

  if sumPerW > 0 then
  begin
    // recalculate weights for columns
    for I := CAP_LOW_IDX to CAP_HIGH_IDX do
    begin
      if fThumbCaption_Info[I].ColPercWidth >= 0 then
        fThumbCaption_Info[I].ColPercWidth := fThumbCaption_Info[I].ColPercWidth / sumPerW * 100;
    end;
  end;

end;

procedure TThumbsBrowser.DrawThumbsVert(bQuickView: boolean);
var
  I: integer;
  X, Y, x0, y0: integer;
  athumb: TThumbEx;
begin
  InvalidateBackBuffer(rect(0, 0, fDisplayBackBuffer.Width, fDisplayBackBuffer.Height));

  x0 := fDisplayMarginLeft + fDynamicMarginX + fspacingX;
  y0 := fDisplayMarginTop + fDynamicMarginY + fspacingY - ScrollerPos_To_VirtualPos(fScrollParams.Pos) mod fpassoy;
  Y := y0;
  X := x0;
  for I := fTopDisplayedThumbIdx to fBottomDisplayedThumbIdx do
  begin
    athumb := GetThumbfromList_Safe(fVisibleThumbs, I);

    // go to next row because does not fit
    if (I > fTopDisplayedThumbIdx) and (X + fpassox > x0 + fNColumns * fpassox) then
    begin
      Y := Y + fpassoy;
      X := x0;
    end;

    if assigned(athumb) then
      PaintThumbToDisplay(athumb, I, X, Y, bQuickView, false);

    X := X + fpassox;
  end;
end;

procedure TThumbsBrowser.DrawThumbsHorz(bQuickView: boolean);
var
  I: integer;
  X, Y, x0, y0: integer;
  athumb: TThumbEx;
begin
  InvalidateBackBuffer(rect(0, 0, fDisplayBackBuffer.Width, fDisplayBackBuffer.Height));

  x0 := fDisplayMarginLeft + fDynamicMarginX + fspacingX - ScrollerPos_To_VirtualPos(fScrollParams.Pos) mod fpassox;
  y0 := fDisplayMarginTop + fDynamicMarginY + fspacingY;

  X := x0;
  Y := y0;

  for I := fTopDisplayedThumbIdx to fBottomDisplayedThumbIdx do
  begin
    athumb := GetThumbfromList_Safe(fVisibleThumbs, I);

    // go to next col because does not fit
    if (I > fTopDisplayedThumbIdx) and (Y + fpassoy > y0 + fNRows * fpassoy) then
    begin
      X := X + fpassox;
      Y := y0;
    end;

    if assigned(athumb) then
      PaintThumbToDisplay(athumb, I, X, Y, bQuickView, false);

    Y := Y + fpassoy;
  end;
end;

procedure TThumbsBrowser.RefreshDisplay;
begin
  if csLoading in ComponentState then
    EXIT;
  if fUpdateLocked > 0 then
    EXIT;

  RefreshThumbs(self, false);
  UpdateDisplay;
end;

procedure TThumbsBrowser.InvalidateDisplay;
begin
  fRecalcDisplay := true;
  Invalidate;
end;

procedure TThumbsBrowser.UpdateDisplay;
var
  cv: Tcanvas;
begin
  if not assigned(self.Parent) then
    EXIT;
  cv := self.canvas;

  CalcBrowserUsefulRect;

  DrawReportHeader;

  cv.draw(XDisplay2Browser(0), YDisplay2Browser(0), fDisplayBackBuffer);

{$IFNDEF NWSCOMPS_REGISTRATION_OK}
  cv.textout(XDisplay2Browser(0), YDisplay2Browser(0),
    'Unregistered - TThumbsBrowser : Copyright (C) Francesco Savastano');
{$ENDIF}
end;

procedure TThumbsBrowser.UpdateDisplayRect(arect: Trect);
var
  destRect: Trect;
begin
  if assigned(self.Parent) then
    if assigned(fDisplayBackBuffer) then
    begin
      destRect := arect;

      destRect.TOP := YDisplay2Browser(destRect.TOP);
      destRect.bottom := YDisplay2Browser(destRect.bottom);

      canvas.CopyRect(TBGetFR(destRect), fDisplayBackBuffer.canvas, TBGetFR(arect));
    end;
end;

procedure TThumbsBrowser.RefreshThumb(theThumb: TThumbEX;
  const bImmediateDisplay: boolean);
begin
  RefreshThumb(GetThumbIdx(theThumb), bImmediateDisplay);
end;

procedure TThumbsBrowser.RefreshThumbs(sender: TObject; const bImmediateDisplay: boolean = false;
  const bAsFromLoader: boolean = false);
begin
  if (csLoading in ComponentState) then
    EXIT; // >>>> EXIT
  if (csDestroying in ComponentState) then
    EXIT; // >>>> EXIT
  if fUpdateLocked > 0 then
    EXIT; // >>>> EXIT

  if fVisibleThumbs.Count = 0 then
  begin
    SetScrollerBoxVisible(false);
    SetScrollerParams;
    SetScrollPosition(self, fScrollParams.Pos, fScroller.min);
    CalcBasicLayout(fSampleThumb, false);
    InvalidateBackBuffer(rect(0, 0, fDisplayBackBuffer.Width, fDisplayBackBuffer.Height));
    if bImmediateDisplay then
      UpdateDisplay;

    EXIT; // >>>> EXIT
  end;


  // -----------------Start Refresh-------------------------------------------------------------

  // calculate layout from sample thumb
  CalcLayout(fSampleThumb);

  case fBrowserOrientation of
    tbo_vert:
      DrawThumbsVert(assigned(fLoader) and fLoader.Running);
    tbo_horz:
      DrawThumbsHorz(assigned(fLoader) and fLoader.Running);
  end;

  if bImmediateDisplay then
    UpdateDisplay;
end;

function TThumbsBrowser.GetPickedThumbs(pickMode: TTB_Browser_PickCondition): TList;
begin
  case pickMode of
    IfSelected:
      result := fSelectedThumbs;
    IfChecked:
      result := fCheckedThumbs;
    IfNo_condition:
      result := fVisibleThumbs;
  else
    result := fVisibleThumbs;
  end;
end;

procedure TThumbsBrowser.ReLoadFiles;
begin
  ReLoadFiles(IfNo_condition);
end;

procedure TThumbsBrowser.ReLoadFiles(pickMode: TTB_Browser_PickCondition);
begin
  ReLoadThumbs(GetPickedThumbs(pickMode));
end;

procedure TThumbsBrowser.ReLoadFiles(filenames: TStringList);
var
  I: integer;
  L: TList;
begin
  if filenames.Count = 0 then
    EXIT;

  L := TList.Create;
  try
    for I := 0 to filenames.Count - 1 do
    begin
      GetThumbsByFileName(filenames[I], L, false);
    end;
    ReLoadThumbs(L);
  finally
    L.Free;
  end;
end;

procedure TThumbsBrowser.Handle_FoldersRecursionProgress(sender: TObject; theFolder: string);

  function GetShortenedPath(thePath: string): string;
  var
    s, sLeft, sRight, sTemp: string;
    I: integer;
    mid: integer;
    cv: Tcanvas;
    tempbmp: tbitmap;
    fitWidth: integer;
  begin

    result := thePath;

    if Pos('\', thePath) = 0 then
      EXIT;

    fitWidth := fBrowseFoldersProgress_Display.Width - 4;

    tempbmp := tbitmap.Create;
    cv := tempbmp.canvas;
    cv.Font := fBrowseFoldersProgress_Display.Font;
    try
      s := thePath;
      sLeft := s;
      sRight := s;

      while (cv.TextWidth(s) > fitWidth) and ((sLeft <> '') or (sRight <> '')) do
      begin
        sTemp := '';
        sLeft := '';
        sRight := '';
        mid := length(s) div 2;
        for I := mid - 1 downto 1 do
        begin
          if s[I] = '\' then
          begin
            sLeft := copy(s, 1, I);
            break;
          end;
        end;

        if sLeft = '' then
        begin
          mid := 1;
          sTemp := copy(s, 1, mid);;
        end;

        for I := mid to length(s) do
        begin
          if s[I] = '\' then
          begin
            sRight := copy(s, I, length(s) - I);
            break;
          end;
        end;

        if (sLeft = '') then
        begin
          s := sTemp;
          if (sRight <> '') then
            s := s + '...' + sRight;
        end
        else
        begin
          s := sLeft + '...';
          if (sRight <> '') then
            s := s + sRight;
        end;

      end;
    finally
      tempbmp.Free;
    end;

    result := s;
  end;

begin
  if not assigned(fBrowseFoldersProgress_CriticalSection) then
    EXIT;

  fBrowseFoldersProgress_CriticalSection.Enter;
  try
    fBrowseFoldersProgress_Display.Hint := theFolder;
    fBrowseFoldersProgress_Display.caption := GetShortenedPath(theFolder);
    fBrowseFoldersProgress_Button.Repaint;
    // fBrowseFoldersProgress_Panel.Repaint;
  finally
    fBrowseFoldersProgress_CriticalSection.Leave;
  end;

end;

procedure TThumbsBrowser.StopLoader(bFreeExplicit: boolean);
begin
  if assigned(fLoader) then
  begin
    try
      fLoader.OnDebug := nil;

      fLoader.OnThumbLoaded := nil;
      fLoader.OnAllThumbsLoaded := nil;

      fLoader.OnBeforeThumbLoaded := nil;
      fLoader.OnInitialized := nil;

      if fLoader.Running then
      begin
        fLoader.Terminate(not bFreeExplicit, bFreeExplicit);
        if bFreeExplicit then
        begin
          fLoader.WaitFor;
          fLoader.Free;
        end
        else
          RegisterExpectedMemoryLeak(fLoader);
      end
      else
        fLoader.Free;

      fLoader := nil;
    except
    end;

  end;
end;

procedure TThumbsBrowser.StopScanner;
begin

  FBrowsingRecursively := false;

  fFileScannerCriticalSection.Enter;
  try

    if assigned(fScanner) then
    begin
      if fScanner.Running then
      begin
        fScanner.Scanfiles_ProgressEvent := nil;
        sleep(50);
        fScanner.freeonterminate := true;

        fScanner.Terminate; // always terminate
        sleep(100);
      end
      else
        fScanner.Free;

      fScanner := nil; // very important do not remove!
    end;

  finally
    fFileScannerCriticalSection.Leave;
  end;

end;

procedure TThumbsBrowser.WaitScanner;
begin

  fFileScannerCriticalSection.Enter;
  try
    if assigned(fScanner) then
    begin
      while fScanner.Running do
      begin
        sleep(100);
      end;
    end;

  finally
    fFileScannerCriticalSection.Leave;
  end;
end;

procedure TThumbsBrowser.LaunchFileScanner(sender: TObject; theFolder: string; theFolderRecursionList: TStringList);
begin
  // Here we must come only in async mode
  // because of the waitScanner method, that will wait indefinitely
  WaitScanner;
  StopScanner;

  theFolderRecursionList.Add(theFolder);
  Paths_Add(Tbs_AddSlash(theFolder));

  fScanner := TThumbsBrowser_ScanFilesThread.Create(false, fFileScannerCriticalSection);

  fScanner.AssignFileScanParams(theFolderRecursionList, FFileScanner_MaxTransfer);

  fScanner.Scanfiles_ProgressEvent := Handle_ScanFiles_ProgressEvent;
  fScanner.Scanfiles_CheckFileExt_InFilter := Handle_Scanfiles_CheckFileExt_InFilter;
  fScanner.Start(fFileThumbs, fFolderThumbs);
end;

procedure TThumbsBrowser.StartBrowsingRecursively(theFolder: string);
begin
  setlength(fBrowseFoldersRecursionThreads, length(fBrowseFoldersRecursionThreads) + 1);
  fBrowseFoldersRecursionThreads[high(fBrowseFoldersRecursionThreads)] :=
    TThumbsBrowser_BrowseFoldersRecursiveThread.Create(theFolder, fFolderRecursionList, fBrowsedPaths,
    Handle_FoldersRecursionDone, Handle_FoldersRecursionProgress, Handle_FoldersRecursionSyncCheckDone,
    fBrowseFoldersRecursiveCriticalSection);

  CheckFinalizeBrowsingRecursively;
end;

procedure TThumbsBrowser.Handle_FoldersRecursionSyncCheckDone(sender: TObject);
begin
  CheckFinalizeBrowsingRecursively;
end;

procedure TThumbsBrowser.Handle_FoldersRecursionDone(sender: TObject; bAborted: boolean; theFolder: string;
  theFolderList: TStringList; thePaths: TStringList);
begin
  // Here we must come only in async mode (from one of the browse folders threads)
  if not bAborted then
    LaunchFileScanner(sender, theFolder, theFolderList);
end;

procedure TThumbsBrowser.Handle_AbortClick(sender: TObject);
begin
  AbortBrowsingRecursively;
end;

procedure TThumbsBrowser.Handle_BrowserStyleOptionsChange(sender: TObject);
begin
  if csLoading in ComponentState then
    EXIT;

  SetStyle(true);
end;

procedure TThumbsBrowser.StartBrowsing_FromScanner(theList: TThumbsBrowser_ScanFilesThread_FileRcds);
begin
  StopBrowsing(false);

{$IFDEF TB_FOLDERMONITOR}
  if FFolderMonitor_Active then
    FolderMonitor_AddAllBrowsedPaths;
  // we need to check this here because the scanner will add the paths without notifying
{$ENDIF}
  fReBrowsingExistingPaths := false;
  Loader_CreateNew;
  LoaderInit('', nil, nil, nil, theList);
  LoaderStart;

end;

procedure TThumbsBrowser.LoaderInit(theFolder: string; theFileList, theUrlList, theWPDList: TStringList;
  theScannerList: TThumbsBrowser_ScanFilesThread_FileRcds);
begin
  fLoader.Init(theFolder, theFileList, theUrlList, theWPDList, theScannerList);
end;

procedure TThumbsBrowser.LoaderStart;
begin
  if fLoadingLocked > 0 then
    EXIT;
  if not assigned(fLoader) then
    EXIT;

  if fLoader.Running then
    EXIT; // some one else already started the thread
  // this should not normally happen cause of synchronization
  // but the folder monitor timer will cause this to happen

{$IFDEF NWSCOMPS_DXE2_UPPER}
  fLoader.Start;
{$ELSE}
  fLoader.resume;
{$ENDIF}
end;

procedure TThumbsBrowser.LockLayout;
begin
  inc(fLayoutLocked);

  LockUpdate; // also locks update when locking layout
end;

procedure TThumbsBrowser.UnLockLayout(const bDoUpdateLayout: boolean = true);
begin
  if (fLayoutLocked > 0) then
  begin
    dec(fLayoutLocked);
    UnlockUpdate(not bDoUpdateLayout); // also unlocks update when locking layout
    if bDoUpdateLayout then
      ReassignThumbsLayout(false, true); // reassign layout

  end;
end;

procedure TThumbsBrowser.LockLoading;
begin
  inc(fLoadingLocked);
end;

procedure TThumbsBrowser.UnLockLoading;
begin
  if (fLoadingLocked > 0) then
    dec(fLoadingLocked);
end;

procedure TThumbsBrowser.PauseLoading;
begin
  if assigned(fLoader) then
    fLoader.Pause;
end;

procedure TThumbsBrowser.UnPauseLoading;
begin
  if assigned(fLoader) then
    fLoader.Unpause;
end;

procedure TThumbsBrowser.StartBrowsing(theFolder: string);
begin

  if theFolder = '' then
    theFolder := extractfilepath(Application.ExeName);

  if theFolder = '' then // if still empty exit
    EXIT;

  if not directoryexists(theFolder) then
    EXIT;

  StopBrowsing;
  Loader_CreateNew;

  fReBrowsingExistingPaths := false;
  LoaderInit(theFolder, nil, nil, nil, nil);
  StopNavigation; // this must stay here: after the Initialization of the loader!!
  LoaderStart;
end;

procedure TThumbsBrowser.SplitFileandUrlList(srcList: TStringList;
  destUrlList, destFileList, destFolderList: TStringList);
  procedure splitlistadd(s: string);
  begin
    if fileexists(s) then
      destFileList.Add(s)
    else if directoryexists(s) then
      destFolderList.Add(s)
    else if tbs_UrlIsValidUrl(s) then
      destUrlList.Add(s);
  end;

var
  I: integer;
begin
  for I := 0 to srcList.Count - 1 do
  begin
    splitlistadd(srcList[I]); // includes only files, if folders are found the files in those folders are taken
  end;
end;

procedure TThumbsBrowser.StartBrowsing(theFileList: TStringList; const bIfFolder_thenBrowseContent: boolean = true);
var
  aFolderOnlyList: TStringList; // includes only folders
  aFileOnlyList: TStringList; // includes only files
  aUrlOnlyList: TStringList; // includes only urls

  procedure vlistadd(s: string);
  var
    fl: TStringList;
    I: integer;
  begin
    if directoryexists(s) then
    begin
      fl := TStringList.Create;
      try
        TBGetFilesinFolder(fl, s);
        for I := 0 to fl.Count - 1 do
          aFileOnlyList.Add(fl[I]);
      finally
        fl.Free;
      end;
    end;
  end;

var
  I: integer;
begin
  if not assigned(theFileList) then
    EXIT;

  StopBrowsing;
  Loader_CreateNew;

  aUrlOnlyList := TStringList.Create;
  aFileOnlyList := TStringList.Create;
  aFolderOnlyList := TStringList.Create;
  SplitFileandUrlList(theFileList, aUrlOnlyList, aFileOnlyList, aFolderOnlyList);
  try
    if bIfFolder_thenBrowseContent then
    begin
      for I := 0 to aFolderOnlyList.Count - 1 do
      begin
        vlistadd(aFolderOnlyList[I]); // if folders are found the files in those folders are taken
      end;
    end
    else
    begin
      for I := 0 to aFolderOnlyList.Count - 1 do
      begin
        aFileOnlyList.Add(aFolderOnlyList[I]); // if folders are found they will be treated as files
      end;
    end;

    fReBrowsingExistingPaths := false;
    LoaderInit('', aFileOnlyList, aUrlOnlyList, nil, nil);
  finally
    aFolderOnlyList.Free;
    aFileOnlyList.Free;
    aUrlOnlyList.Free;
  end;

  LoaderStart;
end;

procedure TThumbsBrowser.StopBrowsing;
begin
  StopBrowsing(true);
end;

procedure TThumbsBrowser.StopBrowsing(bAbortScanner: boolean);
begin
  if assigned(fScrollUpdateTimer) then
  begin
    fScrollUpdateTimer.enabled := false;
    fScrollUpdateTimer.OnTimer := nil;
    Freeandnil(fScrollUpdateTimer);
  end;

  if bAbortScanner then
    AbortBrowsingRecursively;
{$IFDEF TB_PORTABLEDEVICE}
  StopBrowsing_WPD;
{$ENDIF}
  StopBrowsing_WIA;

  StopLoader(false);

  if bAbortScanner then
    StopScanner;
end;

function TThumbsBrowser.GetStoreType: TTB_Thumb_StoreType;
begin
  result := fSampleThumb.StoreType;
end;

procedure TThumbsBrowser.NavigateToFolder(theFolder: string);
begin
  if extractfilename(theFolder) = '..' then
  begin
    theFolder := copy(theFolder, 1, length(theFolder) - 3); // trim away '/..'
    NavigateToFolder(extractfilepath(theFolder)); // and navigate to parent folder
    EXIT; // >>>> EXIT
  end;

  StartNavigation(theFolder);

end;

procedure TThumbsBrowser.StartNavigation(theFolder: string);
begin

  if fNavMemory then
  begin
    HideThumbsToNavMemory(NmOnFull_Clear, true, false);
    ClearThumbs(false, TBGetSourceTypes_AllEXCEPT([st_General]), IfNo_condition, false);
    // clear remaining visible thumbs
  end
  else
  begin
    { ClearThumbs_All; }
    // clear visible and invisible of type file system
    ClearThumbs(true, TBGetSourceTypes_FileSystem + [st_folderNav], IfNo_condition, true);
    // clear remaining visible thumbs
    ClearThumbs(false, [], IfNo_condition, true);
  end;

  StartBrowsing(theFolder);
  GotoThumbPosition(0, false);

{$IFDEF TB_FOLDERMONITOR}
  if FFolderMonitor_Active then
  begin
    SharedFolderMonitor.StopWatching(self);
    SharedFolderMonitor.StartWatching(self, theFolder, false);
  end;
{$ENDIF}
  if assigned(fOnNavigateFolder) then
    fOnNavigateFolder(theFolder);

end;

procedure TThumbsBrowser.StopNavigation;
begin

end;

procedure TThumbsBrowser.StartBrowsing_WIA(const aDeviceIdx: integer);
begin
  StopBrowsing;

  FireOnStartedLoading;
  ClearThumbs_WIA;

  fReBrowsingExistingPaths := false;
  fAbortWia := false;

  fBrowser_WIA_DeviceIdx := aDeviceIdx;

  fBrowser_WIA.connectto(aDeviceIdx);
  fBrowser_WIA.FillList(fBrowser_WIA_Items, false);

  try
    WIA_VerifyItems;
    WIA_FillIInfo;

    if assigned(fOnInitialized) then
      fOnInitialized(self, bm_WIA);

    WIA_FillPics;

    if StyleOptions.BrowserStyle = tbStyle_Columns then
      SortThumbs(true, stAsFromReportHeader)
    else
      SortThumbs(true, fSortType);
    RefreshDisplay;
  finally
    FireOnFinishLoading;
  end;
end;

function TThumbsBrowser.WPD_SubFoldersToMaxDepth(bSubFolders: boolean): integer;
begin

  if bSubFolders then
    result := -1 { ALL SUB-FOLDERS }
  else
    result := 0; { CURRENT FOLDER ONLY }

end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.StartBrowsing_WPD(aDeviceID: string = ''; aFolderID: string = ''; aFolderPAth: string = '';
  iMaxDepth: integer = 0; const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
begin
  StopBrowsing;
  Loader_CreateNew;

  WPD_FillInfo(aDeviceID, aFolderID, aFolderPAth, iMaxDepth, theFilter, objTypes);

  fReBrowsingExistingPaths := false;
  LoaderInit('', nil, nil, fBrowser_WPD_Items, nil);
  StopNavigation; // this must stay here: after the Initialization of the loader!!
  LoaderStart;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.StopBrowsing_WPD;
begin
  fBrowser_WPD.OnLog := nil;
  fAbortWPD := true;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.StartBrowsing_WPD(DevID: string = ''; theFolderID: string = '';
  const bSubFolders: boolean = false; const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
begin

  StartBrowsing_WPD(DevID, theFolderID, '', WPD_SubFoldersToMaxDepth(bSubFolders), theFilter, objTypes);

end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.StartBrowsing_WPD(DevID: string = ''; theFolderID: string = ''; const iMaxDepth: integer = 0;
  const theFilter: string = ''; objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
begin
  StartBrowsing_WPD(DevID, theFolderID, '', iMaxDepth, theFilter, objTypes);
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.NavigateToWPDFolderPath(aDeviceID: string; theFolderPath: string;
  objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
begin

  // clear visible and invisible of type WPD
  ClearThumbs(true, TBGetSourceTypes_WPD + [st_WPDFolderNav], IfNo_condition, false);
  // clear remaining visible thumbs
  ClearThumbs(false, [], IfNo_condition, false);

  StartBrowsing_WPD(aDeviceID, '', theFolderPath, 0, '', objTypes);
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.NavigateToWPDFolder(aDeviceID: string; theFolderID: string;
  objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
var
  athumb: TThumbEx;
  aProps: TIEWPDObjectAdvancedProps;
  bInWPDNavHistory: boolean;
begin

  // clear visible and invisible of type WPD
  ClearThumbs(true, TBGetSourceTypes_WPD + [st_WPDFolderNav], IfNo_condition, false);
  // clear remaining visible thumbs
  ClearThumbs(false, [], IfNo_condition, false);

  if (theFolderID = '') then
  begin
    fWPDNavHistory.clear;
  end;

  bInWPDNavHistory := WPD_InNavhistory(theFolderID);

  aProps.ParentID := '';
  if (theFolderID <> '') and (WPD_GetAdvProps(theFolderID, aProps) or bInWPDNavHistory) then
  begin
    if fFolderNavigation and fFolderUpNavThumb then
    begin
      athumb := Addthumb(tborig_Auto, true, true, '', tbstore_Unspecified); // add navigator to the parent folder
      athumb.RetrieveAsWPDNavigator(fBrowser_WPD, aDeviceID, aProps.ParentID);
      fNavigatorThumb := athumb;
      RefreshThumb(GetThumbIdx(athumb), true);

      if not bInWPDNavHistory then
        fWPDNavHistory.Add(theFolderID);
    end;
  end;

  StartBrowsing_WPD(aDeviceID, theFolderID, '', 0, '', objTypes);

  if assigned(fOnNavigateWPDFolder) then
    fOnNavigateWPDFolder(aDeviceID, theFolderID);
end;
{$ENDIF}

procedure TThumbsBrowser.WIA_VerifyItems;
var
  I: integer;
  aItem: TIEWiaItem;
begin
  I := 0;
  while I <= fBrowser_WIA_Items.Count - 1 do
  begin
    aItem := TIEWiaItem(fBrowser_WIA_Items[I]);
    assert(assigned(aItem));

    if not WIA_CheckValidItem(aItem) then
      fBrowser_WIA_Items.Delete(I)
    else
      inc(I);
  end;

end;

procedure TThumbsBrowser.WIA_FillIInfo;
var
  I: integer;
  aItem: TIEWiaItem;
  athumb: TThumbEx;
  tk: integer;
  L: TList;
begin
  L := TList.Create;
  try

    tk := gettickcount;
    for I := 0 to fBrowser_WIA_Items.Count - 1 do
    begin
      if fAbortWia then
        break;

      aItem := TIEWiaItem(fBrowser_WIA_Items[I]);
      assert(assigned(aItem));
      athumb := Addthumb(tborig_Auto, false, true, '', tbstore_Unspecified);
      athumb.RetrieveParamsFromWIA(fBrowser_WIA, aItem);
      L.Add(athumb);
      if assigned(fOnWIAProgress) then
      begin
        if (I = fBrowser_WIA_Items.Count - 1) or (gettickcount - tk > 200) then
        begin
          tk := gettickcount;
          fOnWIAProgress(self, I, 0, fBrowser_WIA_Items.Count - 1);
          Application.ProcessMessages;
        end;
      end;
    end;

    LockUpdate;
    try
      for I := 0 to L.Count - 1 do
      begin
        TThumbEx(L[I]).Visible := true;
      end;
    finally
      UnlockUpdate(true);
    end;

  finally
    L.Free;
  end;
end;

procedure TThumbsBrowser.WIA_FillPics;
var
  I, ctr: integer;
  athumb: TThumbEx;
  tk: integer;
begin

  tk := gettickcount;
  ctr := 0;
  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    if fAbortWia then
      break;

    athumb := GetThumbfromList_Safe(fVisibleThumbs, I);
    if assigned(athumb) then
    begin
      if athumb.Source_IS_WIA then
      begin
        WIA_FillPictureThumb(athumb);

        if assigned(fOnWIAProgress) then
        begin
          if (ctr = fBrowser_WIA_Items.Count - 1) or (gettickcount - tk > 200) then
          begin
            tk := gettickcount;
            fOnWIAProgress(self, ctr, 0, fBrowser_WIA_Items.Count - 1);
          end;
        end;
        inc(ctr);
      end;
    end;
  end;

end;

function TThumbsBrowser.WIA_CheckValidItem(aItem: TIEWiaItem): boolean;
var
  bIsPicVid: boolean;

begin
  bIsPicVid := (witImage in aItem.ItemType) or (witVideo in aItem.ItemType);

  result := bIsPicVid;
  {
    bCanTransfer := (witTransfer in aItem.ItemType) and
    (not (witFree in aItem.ItemType)) and
    (not (witDeleted in aItem.ItemType));


    result := bIsPicVid and bCanTransfer;
  }
end;

procedure TThumbsBrowser.WIA_FillPictureThumb(athumb: TThumbEx);
begin
  if not assigned(athumb) then
    EXIT;

  athumb.RetrieveFromWIA(fBrowser_WIA, athumb.AttachedWIAItem);

  RefreshThumb(fVisibleThumbs.IndexOf(athumb), true);
  sleep(30);
  Application.ProcessMessages;
end;

procedure TThumbsBrowser.StopBrowsing_WIA;
begin
  fAbortWia := true;
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.Handle_WPDLog(sender: TObject; const sMsg: String);
begin
  {
    if gettickcount - fWpdStartTk > 1000 * 30 then
    begin
    if MessageDlg('Portable Device seems to take unusually long time to load info.'
    +' Do you want to abort the operation?',
    mtconfirmation, [mbyes, mbno, mbcancel], 0) = mryes then
    begin
    StopBrowsing_WPD;
    //fBrowser_WPD.ActiveDeviceID
    //WPDManager := TPortableDeviceManager.Create( nil );

    end;

    fWpdStartTk := gettickcount;
    end;
  }
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function TThumbsBrowser.WPD_InNavhistory(const theObjID: string): boolean;
var
  I: integer;
begin
  result := false;
  for I := 0 to fWPDNavHistory.Count - 1 do
    if fWPDNavHistory[I] = theObjID then
    begin
      result := true;
      EXIT;
    end;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

function TThumbsBrowser.WPD_GetAdvProps(const theObjID: string; out Props: TIEWPDObjectAdvancedProps): boolean;
var
  Idx: integer;
  bPropOk: boolean;
begin
  result := false;
  Idx := fBrowser_WPD.ObjectIDToIndex(theObjID);
  if Idx = -1 then
  begin
    EXIT;
  end;

  if fBrowser_WPD.ObjectIsFolder(Idx) then
    bPropOk := Pos(fBrowser_WPD.Objects[Idx].FileName, fBrowser_WPD.Objects[Idx].Path) > 0
  else
    bPropOk := true;

  if bPropOk then
    result := fBrowser_WPD.GetObjectAdvancedProps(Idx, Props)
  else
    result := false;
end;
{$ENDIF}
{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsBrowser.WPD_FillInfo(const DevID: string; const theFolderID: string = '';
  const theFolderPath: string = ''; const iMaxDepth: integer = 0; const theFilter: string = '';
  objTypes: TIEWPDObjectTypes = [iewFile, iewFolder]);
var
  I: integer;
begin
  fAbortWPD := false;
  fBrowser_WPD_Items.clear;
  fBrowser_WPD.OnLog := Handle_WPDLog;
  fWpdStartTk := gettickcount;

  if DevID = '' then
    raise Exception.Create('No Device Selected');

  if fBrowser_WPD.ActiveDeviceID <> DevID then
  begin
    if fBrowser_WPD.RefreshDevices = false then
      raise Exception.Create('Unable to get devices: ' + fBrowser_WPD.LastError);
  end;

  screen.Cursor := crhourglass;
  try
    if theFilter <> '' then // FIND EXTENSIONS
    begin
      fBrowser_WPD.FindFilesOfType(DevID, theFolderID, theFilter, iMaxDepth);
    end
    else
    begin // Navigate
      if theFolderPath = '' then
        fBrowser_WPD.NavigateToFolderID(DevID, theFolderID, false, objTypes)
      else
        fBrowser_WPD.NavigateToFolderPath(DevID, theFolderPath, false, objTypes);
    end;
  finally
    screen.Cursor := crdefault;
    fBrowser_WPD.OnLog := nil;
  end;

  for I := 0 to fBrowser_WPD.ObjectCount - 1 do
  begin

    if (fFolderThumbs and (fBrowser_WPD.Objects[I].ObjectType = iewFolder)) or
      (fFileThumbs and AcceptFileFilterCondition(fBrowser_WPD.Objects[I].FileName,
      extractfileext(fBrowser_WPD.Objects[I].FileName))) then
      fBrowser_WPD_Items.Add(fBrowser_WPD.Objects[I].ID);
  end;

end;
{$ENDIF}

procedure TThumbsBrowser.ReLoadThumbs(tl: TList);
var
  I: integer;
  athumb: TThumbEx;
begin
  for I := 0 to tl.Count - 1 do
  begin
    athumb := TThumbEx(tl[I]);
    if ((athumb.Originator = tborig_Manual) and (athumb.SourceType = st_General)) or (not IsThumbUpdated(athumb)) then
      athumb.ExploringStatus := thbNotExplored;
  end;
  Loader_Reload;
end;

procedure TThumbsBrowser.ReLoadThumbs(pickMode: TTB_Browser_PickCondition);
begin
  ReLoadThumbs(GetPickedThumbs(pickMode));
end;

procedure TThumbsBrowser.ReLoadThumbs;
begin
  ReLoadThumbs(fVisibleThumbs);
end;

procedure TThumbsBrowser.Loader_Reload;
begin
  StopBrowsing;

  Loader_CreateNew;

  fReBrowsingExistingPaths := false;
  LoaderInit('', nil, nil, nil, nil);

  LoaderStart;
end;

procedure TThumbsBrowser.Remove_File(FileName: string);
var
  L: TStringList;
begin
  L := TStringList.Create;
  try
    L.Add(FileName);
    Remove_Files(L);
  finally
    L.Free;
  end;
end;

procedure TThumbsBrowser.Remove_Files(filenames: TStringList);
var
  L: TList;
  I: integer;
begin
  L := TList.Create;
  LockUpdate;
  try
    for I := 0 to filenames.Count - 1 do
    begin
      GetThumbsByFileName(filenames[I], L, false);
    end;

    for I := L.Count - 1 downto 0 do
      Deletethumb(TThumbEx(L[I]));
  finally
    UnlockUpdate(true);
    L.Free;
  end;
end;

procedure TThumbsBrowser.RefreshFiles;
begin
  RefreshFolders;
end;

procedure TThumbsBrowser.RefreshFolders;
begin
  if csLoading in ComponentState then
    EXIT;

  StopBrowsing;
  Loader_CreateNew;
  fReBrowsingExistingPaths := true;
  LoaderInit('', nil, nil, nil, nil);
  LoaderStart;
end;

procedure TThumbsBrowser.ReloadFile(theThumb: TThumbEx);
begin
  if NOT assigned(theThumb) then
    EXIT;
  if not fileexists(theThumb.SourceFileName) then
    EXIT;

  theThumb.RetrieveFromSourceFile(theThumb.SourceFileName);

  // correct thumb orientation even in case there was no exif thumb
  if (theThumb.MetaOptions.UseExifOrientationForThumbs) then
    TBAdjustEXIFOrientation(theThumb.IEBitmap, theThumb.SourceEXIF_Orientation);

  RefreshThumb(fVisibleThumbs.IndexOf(theThumb), true);
end;

procedure TThumbsBrowser.ReloadFile(Idx: integer);
var
  athumb: TThumbEx;
begin
  athumb := Thumbat(Idx);
  ReloadFile(athumb);
end;

procedure TThumbsBrowser.ReloadFile(const theFilename: string);
var
  L: TStringList;
begin

  L := TStringList.Create;
  try
    L.Add(theFilename);
    ReLoadFiles(L);
  finally
    L.Free;
  end;

end;

procedure TThumbsBrowser.Invalidate;
begin

  inherited Invalidate;

  if assigned(fScrollerBox) and fScrollerBox.Visible then
    fScroller.Invalidate;

  if assigned(fBrowseFoldersProgress_Panel) and fBrowseFoldersProgress_Panel.Visible then
    fBrowseFoldersProgress_Panel.Invalidate;

end;

procedure TThumbsBrowser.Update;
begin
  fRecalcDisplay := true;
  inherited Update;
end;

procedure TThumbsBrowser.AbortBrowsingRecursively;
var
  I: integer;
begin

  for I := Low(fBrowseFoldersRecursionThreads) to High(fBrowseFoldersRecursionThreads) do
  begin
    if assigned(fBrowseFoldersRecursionThreads[I]) then
    begin
      if fBrowseFoldersRecursionThreads[I].Running then
        fBrowseFoldersRecursionThreads[I].Abort;
    end;

  end;

end;

procedure TThumbsBrowser.FinalizeBrowsingRecursively;
var
  I: integer;
begin

  for I := Low(fBrowseFoldersRecursionThreads) to High(fBrowseFoldersRecursionThreads) do
  begin
    if assigned(fBrowseFoldersRecursionThreads[I]) then
    begin
      if not fBrowseFoldersRecursionThreads[I].Running then
        Freeandnil(fBrowseFoldersRecursionThreads[I]);
    end;
  end;

end;

procedure TThumbsBrowser.CheckFinalizeBrowsingRecursively;
var
  I, ctr_Running, ctr_Success, ctr_Aborted: integer;
  bFinalize: boolean;
begin

  ctr_Running := 0;
  ctr_Success := 0;
  ctr_Aborted := 0;
  for I := Low(fBrowseFoldersRecursionThreads) to High(fBrowseFoldersRecursionThreads) do
  begin
    if assigned(fBrowseFoldersRecursionThreads[I]) then
    begin
      if fBrowseFoldersRecursionThreads[I].Running then
      begin
        inc(ctr_Running);
        if fBrowseFoldersRecursionThreads[I].Success then
          inc(ctr_Success)
        else if fBrowseFoldersRecursionThreads[I].Aborted then
          inc(ctr_Aborted);
      end;
    end;

  end;

  bFinalize := not(ctr_Running > ctr_Success + ctr_Aborted);

  fBrowseFoldersProgress_Panel.Visible := not bFinalize;

  RefreshDisplay;
  Update;

  if bFinalize then
    FinalizeBrowsingRecursively;
end;

procedure TThumbsBrowser.AddCustomFileFormatRead(theFormat: TTB_Browser_FileFormat);
begin
  setlength(fUserFileFormats_Read, length(fUserFileFormats_Read) + 1);
  fUserFileFormats_Read[high(fUserFileFormats_Read)] := theFormat;
end;

procedure TThumbsBrowser.ClearCustomFileFormatsRead;
begin
  setlength(fUserFileFormats_Read, 0);
end;

procedure TThumbsBrowser.Paths_Clear;
begin
  fBrowsedPaths.clear;
{$IFDEF TB_FOLDERMONITOR}
  if FFolderMonitor_Active then
    SharedFolderMonitor.StopWatching(self);
{$ENDIF}
end;

procedure TThumbsBrowser.Paths_ClearUnused;
var
  I, j, h: integer;
  bAdd, bDelete: boolean;
  compPath, aPath: string;

  tempList: TStringList;
begin

  tempList := TStringList.Create;
  try
    for I := 0 to fThumbs.Count - 1 do
    begin

      aPath := Tbs_AddSlash(Thumbat_AbsoluteIdx(I).SourceFilePath);
      bAdd := true;
      for h := tempList.Count - 1 downto 0 do
      begin
        compPath := tempList[h];

        if comparetext(compPath, aPath) = 0 then
        begin
          bAdd := false;
          break;
        end;
      end;

      if bAdd then
        tempList.Add(aPath);

    end;

    for j := fBrowsedPaths.Count - 1 downto 0 do
    begin
      bDelete := true;
      compPath := Tbs_AddSlash(fBrowsedPaths[j]);
      for h := tempList.Count - 1 downto 0 do
      begin
        if comparetext(compPath, aPath) = 0 then
        begin
          bDelete := false;
          break;
        end;

      end;

      if bDelete then
        Paths_Delete(j); // fBrowsedPaths.delete(j);

    end;
  finally
    tempList.Free;
  end;

end;

procedure TThumbsBrowser.Paths_Delete(Idx: integer);
begin
{$IFDEF TB_FOLDERMONITOR}
  if FFolderMonitor_Active then
    SharedFolderMonitor.StopWatching(self, fBrowsedPaths[Idx]);
{$ENDIF}
  if tbs_ComparePaths(fBrowsedPaths[Idx], fFolderCurrent) = 0 then
    fFolderCurrent := '';

  fBrowsedPaths.Delete(Idx);
end;

function TThumbsBrowser.Paths_Add(thePath: string): boolean;
begin
  result := TBCheckandAddPath(thePath, fBrowsedPaths);
  if result then // if path was added
  begin
{$IFDEF TB_FOLDERMONITOR}
    if FFolderMonitor_Active then
      SharedFolderMonitor.StartWatching(self, thePath, false);
{$ENDIF}
  end;
end;

procedure TThumbsBrowser.ClearPathsofNonExistingThumbs;
begin
  Paths_ClearUnused;
end;

function TThumbsBrowser.IsFileExtSupported_Read(theExt: string): boolean;
var
  ff: TTB_Browser_FileFormat;
begin
  result := TBStringinArray(theExt, TBCONST_ValidList_READ);
  if (length(fUserFileFormats_Read) > 0) and (result = false) then
  begin
    ff.Extension := theExt;
    result := (TBFileFormatGetArrayIdx(ff, fUserFileFormats_Read) <> -1);
  end;

end;

function TThumbsBrowser.IsFileExtSupported_Write(theExt: string): boolean;
begin
  result := TBStringinArray(theExt, TBCONST_ValidList_Write);
end;

function TThumbsBrowser.IsThumbUpdated(theThumb: TThumbEx): boolean;
var
  sr: TSearchRec;
begin
  if (theThumb.SourceType in TBGetSourceTypes_FileSystem) then
  begin
    if theThumb.searchrec.size = -1 then
      result := false
    else if FindFirst(theThumb.SourceFileName, faAnyfile, sr) <> 0 then
    begin
      FindClose(sr);
      result := (sr.size = theThumb.searchrec.size) and (sr.TimeStamp = theThumb.searchrec.TimeStamp);

      if not result then
        theThumb.searchrec := sr;
    end
    else
      result := theThumb.Adjourned;
  end
  else
    result := theThumb.Adjourned;
end;

procedure TThumbsBrowser.ClearThumbs_All(const bClearPaths: boolean = true);
var
  I: integer;
  athumb: TThumbEx;
begin
  StopBrowsing;

  for I := fThumbs.Count - 1 downto 0 do
  begin
    athumb := TThumbEx(fThumbs.items[I]);
    if assigned(athumb) then
    begin
      fThumbs.items[I] := nil;
      athumb.Free;
    end;
  end;
  fThumbs.clear;

  fVisibleThumbs.clear;
  fSelectedThumbs.clear;
  frotatedThumbs.clear;
  fCheckedThumbs.clear;

  fSelectedIndex := -1;
  fLastClickedThumb := nil;

  if bClearPaths then
    Paths_Clear;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs(const bIncludeInvisible: boolean; const sourcetypes: TTB_SourceTypes;
  const condition: TTB_Browser_PickCondition; const bClearPaths: boolean; const bUpdateDisplay: boolean);
var
  tl: TList;
begin
  tl := TList.Create;
  try
    GetThumbsList(tl, sourcetypes, condition, bIncludeInvisible);
    ClearThumbs(tl, bClearPaths, bUpdateDisplay);
  finally
    tl.Free;
  end;
end;

procedure TThumbsBrowser.ClearThumbs(const bIncludeInvisible: boolean; const sourcetypes: TTB_SourceTypes;
  const condition: TTB_Browser_PickCondition; const bClearPaths: boolean);
begin
  ClearThumbs(bIncludeInvisible, sourcetypes, condition, bClearPaths, true);
end;

procedure TThumbsBrowser.ClearThumbs(tl: TList; const bClearPaths: boolean; const bUpdateDisplay: boolean);
var
  I: integer;
  athumb: TThumbEx;
begin
  LockUpdate;
  try
    for I := 0 to tl.Count - 1 do
    begin
      athumb := TThumbEx(tl[I]);
      Deletethumb(GetAbsoluteIdx(athumb));
    end;

    if bClearPaths then
      Paths_ClearUnused;
  finally
    UnlockUpdate(bUpdateDisplay);
  end;

end;

procedure TThumbsBrowser.ClearThumbs_Checked;
var
  athumb: TThumbEx;
  I: integer;
begin

  for I := fCheckedThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    athumb := GetChecked(I);
    Deletethumb(athumb);
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs_UnChecked;
var
  athumb: TThumbEx;
  I: integer;
begin
  for I := fVisibleThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    athumb := Thumbat(I);
    if not athumb.Checked then
      Deletethumb(athumb);
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs(const bIncludeInvisible: boolean = false; const bClearPaths: boolean = true);
begin
  ClearThumbs(bIncludeInvisible, [], IfNo_condition, bClearPaths, true);
end;

procedure TThumbsBrowser.ClearThumbs_Selected;
var
  athumb: TThumbEx;
  I: integer;
begin
  for I := fSelectedThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    athumb := GetSelected(I);
    Deletethumb(athumb);
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs_NotInPaths;
var
  athumb: TThumbEx;
  I: integer;
begin
  for I := fVisibleThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    athumb := Thumbat(I);
    if (athumb.SourceType in TBGetSourceTypes_FileSystem) and (not InPaths(athumb, false)) then
      Deletethumb(athumb)
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbsInPath(Pathname: string);
  procedure EliminatePathfromList(Pathname: string);
  var
    I: integer;
  begin
    I := 0;
    while I < fBrowsedPaths.Count do
    begin
      if (comparetext(Tbs_AddSlash(Pathname), fBrowsedPaths[I]) = 0) then
        Paths_Delete(I) // fBrowsedPaths.Delete(i)
      else
        inc(I);
    end;
  end;

var
  I: integer;
  athumb: TThumbEx;
begin

  for I := fThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    athumb := Thumbat_AbsoluteIdx(I);
    if (not athumb.Source_IS_WIA) and (comparetext(Tbs_AddSlash(Pathname), extractfilepath(athumb.SourceFileName)) = 0)
    then
      Deletethumb(I)
  end;

  EliminatePathfromList(Pathname);

end;

procedure TThumbsBrowser.ClearThumbs_WIA;
var
  I: integer;
begin

  for I := fThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    if Thumbat_AbsoluteIdx(I).Source_IS_WIA then
      Deletethumb(I)
  end;

  fBrowser_WIA_Items.clear;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs_NotInWIA;
var
  I: integer;
begin

  for I := fThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    if (not Thumbat_AbsoluteIdx(I).Source_IS_WIA) then
      Deletethumb(I)
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs_WPD;
var
  I: integer;
begin
  for I := fThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    if Thumbat_AbsoluteIdx(I).Source_IS_WPD then
      Deletethumb(I)
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.ClearThumbs_NotInWPD;
var
  I: integer;
begin
  for I := fThumbs.Count - 1 downto 0 do // use downto because of deletethumb!!
  begin
    if (not Thumbat_AbsoluteIdx(I).Source_IS_WPD) then
      Deletethumb(I)
  end;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetVirtualScroll_Position(theposition: double);
begin
  if not fScrollerBox.Visible then
    EXIT;

  if theposition > fScrollParams.Display_Max then
    theposition := fScrollParams.Display_Max;
  if theposition < 0 then
    theposition := 0;

  SetScrollPosition(self, fScrollParams.Pos, VirtualPos_To_ScrollerPos(theposition));
end;

procedure TThumbsBrowser.RetrieveThumb(athumb: TThumbEx);
begin
  if athumb.Adjourned then
    EXIT;

  case athumb.SourceType of
    st_File:
      athumb.RetrieveFromSourceFile_EX(athumb.SourceFileName, GetReaderFunction(extractfileext(athumb.SourceFileName)),
        nil, false);
    st_WIA:
      begin
        WIA_IO.WIAParams.TakePicture := false;
        WIA_IO.WIAParams.TransferFormat := ietfDefault;
        WIA_IO.WIAParams.ProcessingBitmap := athumb.IEBitmap;
        WIA_IO.WIAParams.Transfer(athumb.AttachedWIAItem, false);
      end;
    st_URL:
      athumb.RetrieveFromUrl(athumb.SourceFileName);
{$IFDEF TB_PORTABLEDEVICE}
    st_WPDFile:
      athumb.RetrieveFromWPD(athumb.AttachedWPDInfo.WPD, athumb.AttachedWPDInfo.DevID,
        athumb.AttachedWPDInfo.Rcd.ID, false);
{$ENDIF}
  end;
end;

procedure TThumbsBrowser.EnsureImageLoaded(Idx: integer);
begin
  EnsureImageLoaded(Thumbat(Idx));
end;

procedure TThumbsBrowser.EnsureImageLoaded(athumb: TThumbEx);
begin
  if (athumb.Adjourned) then
  begin
    if athumb.Originator = tborig_Manual then
      EXIT; // already loaded and up to date

    if (athumb.ExploringStatus <> thbExploreInProcess) then
      EXIT; // already loaded and up to date
  end;

  RetrieveThumb(athumb);
end;

{$IFDEF TB_MULTIBITMAP}

procedure TThumbsBrowser.ExportToMultiBitmap(pickMode: TTB_Browser_PickCondition; mb: TIECustomMultiBitmap;
  bTakeOriginalPics: boolean);
var
  L: TList;
  I: integer;
  athumb: TThumbEx;
  mbIdx: integer;
  loadThb: TThumbEx;
begin
  loadThb := TThumbEx.Create(tborig_Auto, self.canvas, false);
  loadThb.StoreType := tbstore_FullImage;
  mb.LockUpdate;
  try
    L := GetPickedThumbs(pickMode);
    for I := 0 to L.Count - 1 do
    begin
      mbIdx := mb.AppendImage;
      athumb := TThumbEx(L[I]);
      loadThb.Assign(athumb);
      if bTakeOriginalPics then
        loadThb.StoreType := tbstore_FullImage
      else
        loadThb.StoreType := tbstore_Thumb;
      RetrieveThumb(loadThb);
      mb.SetImage(mbIdx, loadThb.IEBitmap);

      if assigned(fOnProgress) then
        fOnProgress(self, round((I + 1) / L.Count * 100));
    end;
  finally
    mb.UnlockUpdate;
    loadThb.Free;
  end;
end;
{$ENDIF}
{$IFDEF TB_MULTIBITMAP}

function TThumbsBrowser.ExportToMultiFileFormat(pickMode: TTB_Browser_PickCondition; FileName: string;
  bTakeOriginalPics: boolean; IOParams: TIOMultiParams = nil; theOnProgressHandler: TIEProgressEvent = nil): boolean;
var
  mb: TIEMultiBitmap;
  aMio: TImageenmio;
begin
  result := false;

  mb := TIEMultiBitmap.Create;
  try
    ExportToMultiBitmap(pickMode, mb, bTakeOriginalPics);
    result := mb.write(FileName, IOParams);
  finally
    mb.Free;
  end;
end;
{$ENDIF}
{$IFDEF TB_MULTIBITMAP}

function TThumbsBrowser.ExportToMultiFileFormat(pickMode: TTB_Browser_PickCondition; FileName: string;
  bTakeOriginalPics: boolean; theOnProgressHandler: TIEProgressEvent = nil): boolean;
var
  mb: TIEMultiBitmap;
  aMio: TImageenmio;
begin
  result := false;

  mb := TIEMultiBitmap.Create;
  try
    ExportToMultiBitmap(pickMode, mb, bTakeOriginalPics);
    aMio := TImageenmio.Create(nil);
    try
      aMio.AttachedIEMBitmap := mb;
      aMio.OnProgress := theOnProgressHandler;
      aMio.SaveToFile(FileName);
      result := true;
    finally
      aMio.Free;
    end;
  finally
    mb.Free;
  end;
end;
{$ENDIF}

function TThumbsBrowser.Set_a_Thumb(Idx: integer; FileName: string; aUserObject: TObject = nil;
  const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Thumbat(Idx));
  if result = nil then
    EXIT;

  with result do
  begin
    TB_ManualThumb_Init(result);
    if bAsynchronousLoading then
    begin
      TB_ManualThumb_InitFromFile(result, FileName, true);
      if ((fLoader = nil) OR (not fLoader.Running)) then
        Loader_Reload;
    end
    else
      TB_ManualThumb_RetrieveFromFile(result, FileName, GetReaderFunction(extractfileext(FileName)), true);
  end;
end;

function TThumbsBrowser.Set_a_Thumb(Idx: integer; theStream: TStream; const theCaption: string = '';
  aUserObject: TObject = nil; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Thumbat(Idx));
  if result = nil then
    EXIT;

  TB_ManualThumb_Init(result);
  result.RetrieveFromStream(theStream);
  if theCaption <> '' then
    result.SetCaption(theCaption);
end;

function TThumbsBrowser.Set_a_Thumb(Idx: integer; theIEBmp: TIEBitmap; const theCaption: string = '';
  aUserObject: TObject = nil; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Thumbat(Idx));
  if result = nil then
    EXIT;

  TB_ManualThumb_Init(result);
  result.RetrieveFromIEBitmap(theIEBmp);
  if theCaption <> '' then
    result.SetCaption(theCaption);
end;

function TThumbsBrowser.Set_a_Thumb(Idx: integer; theBmp: tbitmap; const theCaption: string = '';
  aUserObject: TObject = nil; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Thumbat(Idx));
  if result = nil then
    EXIT;

  TB_ManualThumb_Init(result);
  result.RetrieveFromBitmap(theBmp);
  if theCaption <> '' then
    result.SetCaption(theCaption);
end;

Function TThumbsBrowser.DuplicateThumb(srcThumb: TThumbEx; Insertidx: integer): TThumbEx;
begin
  result := Addthumb(srcThumb.Originator, srcThumb.Visible, srcThumb.Checked, srcThumb.SourceFileName,
    srcThumb.StoreType, srcThumb.UserObject, Insertidx);

  result.AssignInfo(srcThumb, true);

  // These settings below will enforce updating of visible, checked and selected collections
  // result.Visible := srcThumb.Visible;
  // result.Checked := srcThumb.Checked;
  result.SELECTED := srcThumb.SELECTED;
  result.RotateMode := srcThumb.RotateMode;
end;

procedure TThumbsBrowser.MoveThumb(fromIdx, ToIdx: integer);
begin
  if (fromIdx < 0) or (fromIdx >= fVisibleThumbs.Count) then
    EXIT;
  if (ToIdx < 0) or (ToIdx >= fVisibleThumbs.Count) then
    EXIT;

  ResetMouseHover;

  fVisibleThumbs.Move(fromIdx, ToIdx);

  fsort_updated := false;
end;

procedure TThumbsBrowser.InitThumb(theThumb: TThumbEx);
begin
  theThumb.Events_Lock;
  try
    // in case of initialization we need to determine the initial state of the thumbnail
    // Determine if thumb should be checked
    if (fThumbDefaultChecked) and (theThumb.SourceType <> st_folderNav) and (theThumb.SourceType <> st_WPDFolderNav)
    then
    begin
      if (theThumb.SourceType = st_Folder) and (NOT fFolderCheckBoxes) then
        theThumb.Checked := false
      else
      begin
        theThumb.Checked := true;
        fCheckedThumbs.Add(theThumb);
      end;
    end
    else
      theThumb.Checked := false;

  finally
    theThumb.Events_UnLock;
  end;

  CheckSpecialCaseThumb(theThumb);
end;

procedure TThumbsBrowser.CheckSpecialCaseThumb(theThumb: TThumbEx);
begin
  theThumb.Events_Lock;
  theThumb.Layout_Lock;
  try

    // Disable certain things in special cases
    if (theThumb.SourceType = st_folderNav) or (theThumb.SourceType = st_WPDFolderNav) then // folder navigator
    begin
      theThumb.ShowSettings := theThumb.ShowSettings - [th_ShowCheckBox, th_ShowRotateButtons, th_ShowInfoBox,
        th_ShowTopTitle, th_ShowBottomTitle, th_ShowRatingBox];
      theThumb.CaptionSettings := [];
    end
    else if (theThumb.SourceType = st_Folder) or (theThumb.SourceType = st_WPDFolder) then // folders
    begin
      theThumb.ShowSettings := theThumb.ShowSettings - [th_ShowRotateButtons, th_ShowInfoBox, th_ShowRatingBox];
      if (NOT fFolderCheckBoxes) then
        theThumb.ShowSettings := theThumb.ShowSettings - [th_ShowCheckBox];
      if (NOT fFolderTitles) then
      begin
        theThumb.ShowSettings := theThumb.ShowSettings - [th_ShowTopTitle, th_ShowBottomTitle];
      end;
    end;

    if assigned(fOnThumbCheckSpecialCase) then
      fOnThumbCheckSpecialCase(theThumb, GetThumbIdx(theThumb));

  finally
    theThumb.Layout_Unlock;
    theThumb.Events_UnLock;
  end;
end;

// this is the very basic addthumb
procedure TThumbsBrowser.Addthumb(theThumb: TThumbEx; const theSearchKey: string; position: integer);
begin
  if (position < 0) or (position >= fThumbs.Count) then
    fThumbs.Add(theSearchKey, theThumb)
  else
    fThumbs.Insert(position, theSearchKey, theThumb);

  // leave this here, when we are sure the thumb has been added:
  theThumb.OwnUserObject := OwnUserObjects;

  fsort_updated := false;
  ffilter_updated := false;
end;

// this is the basic addThumb function
Function TThumbsBrowser.Addthumb(theOriginator: TTB_Thumb_Originator; const bVisible, bChecked: boolean;
  const theSearchKey: string; theStoreType: TTB_Thumb_StoreType; theUserObject: TObject = nil;
  const Insertidx: integer = -1): TThumbEx;
var
  athumb: TThumbEx;

  bCancelAdd: boolean;
  oldIdx: integer;
begin
  athumb := CreateThumb(theOriginator, nil, ThumbLayoutType, true);
  result := athumb;

  athumb.Assign(SampleThumb);
  if theStoreType <> tbstore_Unspecified then
    athumb.StoreType := theStoreType;

  athumb.UserObject := theUserObject;

  bCancelAdd := false;
  if assigned(fOnThumbCanAdd) then
    fOnThumbCanAdd(athumb, bCancelAdd);

  if bCancelAdd then
  begin
    Freeandnil(athumb);
    EXIT; // >>>>>EXIT
  end;

  Addthumb(athumb, theSearchKey, -1); // call the very basic addthumb

  // this must go AFTER Asssigning the SampleThumb
  // because the onvisiblechange events are assigned there
  with athumb do
  begin
    Visible := bVisible;
    // this adds the thumb to the visible thumbs by firing the visible change event assigned to SampleThumb
    Checked := bChecked;
    // this adds the thumb to the visible thumbs by firing the checked change event assigned to SampleThumb
  end;

  if athumb.Visible and (Insertidx <> -1) then
  begin
    oldIdx := fVisibleThumbs.IndexOf(athumb);
    if oldIdx <> -1 then
      fVisibleThumbs.Move(oldIdx, max(0, min(fVisibleThumbs.Count - 1, Insertidx)));
  end;

  if assigned(fOnThumbAdded) then
    fOnThumbAdded(athumb, fVisibleThumbs.IndexOf(athumb));
end;

Function TThumbsBrowser.Addthumb(FileName: string; theStoreType: TTB_Thumb_StoreType; theUserObject: TObject = nil;
  const Insertidx: integer = -1; const bAsynchronousLoading: boolean = true; const bAllowCreateLoader: boolean = true)
  : TThumbEx;
begin
  result := Addthumb(tborig_Manual, true, true, FileName, theStoreType, theUserObject, Insertidx);

  with result do
  begin
    if bAsynchronousLoading then
    begin
      TB_ManualThumb_InitFromFile(result, FileName, true);
      if bAllowCreateLoader and ((fLoader = nil) OR (not fLoader.Running)) then
        Loader_Reload;
    end
    else
      TB_ManualThumb_RetrieveFromFile(result, FileName, GetReaderFunction(extractfileext(FileName)), true);
  end;

end;

Function TThumbsBrowser.Addthumb(theIEBmp: TIEBitmap; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
  theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx;
begin
  result := Addthumb(tborig_Manual, true, true, '', theStoreType, theUserObject, Insertidx);

  with result do
  begin
    RetrieveFromIEBitmap(theIEBmp);
    SetCaption(theCaption);
  end;
end;

Function TThumbsBrowser.Addthumb(theStream: TStream; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
  theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx;
begin
  result := Addthumb(tborig_Manual, true, true, '', theStoreType, theUserObject, Insertidx);

  with result do
  begin
    RetrieveFromStream(theStream);
    SetCaption(theCaption);
  end;
end;

Function TThumbsBrowser.Addthumb(theBmp: tbitmap; const theCaption: string; theStoreType: TTB_Thumb_StoreType;
  theUserObject: TObject = nil; const Insertidx: integer = -1): TThumbEx;
var
  aIEBMP: TIEBitmap;
begin
  aIEBMP := TIEBitmap.Create;
  try
    aIEBMP.CopyFromTBitmap(theBmp);
    result := Addthumb(aIEBMP, theCaption, theStoreType);
  finally
    aIEBMP.Free;
  end;

end;

procedure TThumbsBrowser.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('ThumbCaption_MissingText', nil, WriteThumbCaption_MissingText, true);
end;

function TThumbsBrowser.Deletethumb(theThumb: TThumbEx): boolean;
begin
  result := Deletethumb(fThumbs.IndexOf(theThumb));
end;

function TThumbsBrowser.Deletethumb(ID: integer): boolean;
var
  Idx: integer;
  athumb: TThumbEx;
  bCancel: boolean;
begin
  result := false;
  if (ID < 0) or (ID > fThumbs.Count - 1) then
    EXIT;

  athumb := Thumbat_AbsoluteIdx(ID);

  bCancel := false;
  if assigned(fOnThumbCanDelete) then
    fOnThumbCanDelete(athumb, bCancel);

  if bCancel then
    EXIT; // >>>>>EXIT without deleting

  Idx := GetSelectedThumbIdxfromThumbID(ID);
  if Idx <> -1 then
  begin
    fSelectedThumbs.Delete(Idx);

    if fSelectedIndex = GetVisibleThumbIdxfromSelectedThumbIdx(Idx) then
      fSelectedIndex := -1;
  end;

  Idx := GetCheckedThumbIdxfromThumbID(ID);
  if Idx <> -1 then
    fCheckedThumbs.Delete(Idx);

  if athumb.RotateMode <> trmnone then
  begin
    Idx := GetRotatedThumbIdxfromThumbID(ID);
    if Idx <> -1 then
      frotatedThumbs.Delete(Idx);
  end;

  if athumb.Visible then
  begin
    Idx := GetVisibleThumbIdxfromThumbID(ID);
    if Idx <> -1 then
      fVisibleThumbs.Delete(Idx);
  end;

  if IsThumbHidden(vtyp_NavMemory, athumb, Idx) then
    fHiddenThumbs_NavMem.Delete(Idx); // fHiddenThumbs_NavMem.Remove(athumb);

  if IsThumbHidden(vtyp_Filter, athumb, Idx) then
    fHiddenThumbs_Filter.Delete(Idx); // fHiddenThumbs_Filter.Remove(athumb);

  if IsThumbHidden(vtyp_User, athumb, Idx) then
    fHiddenThumbs_User.Delete(Idx); // fHiddenThumbs_User.Remove(athumb);

  try
    if assigned(fOnThumbDelete) then
      fOnThumbDelete(athumb, GetVisibleThumbIdxfromThumbID(ID));
  except
    ;
  end;

  if assigned(athumb) then // should not happen. but just in case by mistake in the onthumbdelete event
  // the user should free the thumb himself
  begin
    Freeandnil(athumb);
    fThumbs.Delete(ID);
  end;

  result := true;
end;

Function TThumbsBrowser.Add_a_Thumb(aUserObject: TObject = nil; const Insertidx: integer = -1;
  theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(tborig_Manual, true, true, '', theStoreType, aUserObject, Insertidx));
  result.SourceType := st_General;
  RefreshDisplay;
end;

Function TThumbsBrowser.Add_a_Thumb(FileName: string; aUserObject: TObject = nil; const Insertidx: integer = -1;
  const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(FileName, theStoreType, aUserObject, Insertidx, bAsynchronousLoading, true));
  if not bAsynchronousLoading then
    RefreshDisplay;
end;

Function TThumbsBrowser.Add_a_Thumb(theIEBmp: TIEBitmap; const theCaption: string; aUserObject: TObject = nil;
  const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(theIEBmp, theCaption, theStoreType, aUserObject, Insertidx));
  RefreshDisplay;
end;

Function TThumbsBrowser.Add_a_Thumb(theBmp: tbitmap; const theCaption: string; aUserObject: TObject = nil;
  const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(theBmp, theCaption, theStoreType, aUserObject, Insertidx));
  RefreshDisplay;
end;

Function TThumbsBrowser.Add_a_Thumb(theStream: TStream; const theCaption: string; aUserObject: TObject = nil;
  const Insertidx: integer = -1; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(theStream, theCaption, theStoreType, aUserObject, Insertidx));
  RefreshDisplay;
end;

function TThumbsBrowser.Add_File(FileName: string; aUserObject: TObject = nil; const Insertidx: integer = -1;
  const bAsynchronousLoading: boolean = true; theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified): TBrowserThumb;
begin
  result := TBrowserThumb(Addthumb(FileName, theStoreType, aUserObject, Insertidx, bAsynchronousLoading, true));
end;

procedure TThumbsBrowser.Add_Files(filenames: TStringList; UserObjects: TList = nil; const Insertidx: integer = -1;
  const bAsynchronousLoading: boolean = true; const bGoToFirstAdded: boolean = false;
  theStoreType: TTB_Thumb_StoreType = tbstore_Unspecified);
var
  I: integer;
  aObj: TObject;
  athumb, firstThumb: TThumbEx;
begin
  if filenames.Count = 0 then
    EXIT;
  firstThumb := nil;

  LockUpdate;
  try
    for I := 0 to filenames.Count - 1 do
    begin
      aObj := nil;
      if assigned(UserObjects) then
      begin
        if UserObjects.Count > I then
          aObj := UserObjects[I];
      end;
      athumb := Addthumb(filenames[I], theStoreType, aObj, Insertidx, bAsynchronousLoading, false);
      if (I = 0) then
        firstThumb := athumb;

    end;
  finally
    UnlockUpdateEx;
  end;

  if bAsynchronousLoading then
  begin
    if (fLoader = nil) OR (not fLoader.Running) then
      Loader_Reload;
  end;

  if bGoToFirstAdded and assigned(firstThumb) and firstThumb.Visible then
    GotoThumbPosition(GetThumbIdx(firstThumb), true)
  else
    RefreshDisplay;

end;

procedure TThumbsBrowser.Move_a_Thumb(fromIdx, ToIdx: integer);
begin
  MoveThumb(fromIdx, ToIdx);
  RefreshDisplay;
end;

function TThumbsBrowser.Delete_a_Thumb_byAbsoluteIdx(ID: integer): boolean;
begin
  result := Deletethumb(ID);
  RefreshDisplay;
end;

function TThumbsBrowser.Delete_a_Thumb(Idx: integer): boolean;
begin
  result := Deletethumb(Thumbat(Idx));
  RefreshDisplay;
end;

function TThumbsBrowser.Delete_a_Thumb(theThumb: TThumbEx): boolean;
begin
  result := Deletethumb(theThumb);
  RefreshDisplay;
end;

Function TThumbsBrowser.Duplicate_a_Thumb(Idx: integer; const Insertidx: integer = -1): TThumbEx;
var
  athumb: TThumbEx;
begin
  athumb := Thumbat(Idx);
  if not assigned(athumb) then
  begin
    result := nil;
    EXIT;
  end;

  result := DuplicateThumb(athumb, Insertidx);
  RefreshDisplay;
end;

Function TThumbsBrowser.Duplicate_a_Thumb(theThumb: TThumbEx; const Insertidx: integer = -1): TThumbEx;
begin
  result := Duplicate_a_Thumb(GetThumbIdx(theThumb), Insertidx);
  RefreshDisplay;
end;

procedure TThumbsBrowser.GotoRow(theRow: integer);
begin
  SetVirtualScroll_Position(theRow * fpassoy);
end;

procedure TThumbsBrowser.GotoColumn(theCol: integer);
begin
  SetVirtualScroll_Position(theCol * fpassox);
end;

function TThumbsBrowser.FindNearest(Idx: integer; condition: TTB_Browser_PickCondition): integer;
var
  I, dw_idx, uw_idx: integer;
  athumb: TThumbEx;
begin
  result := -1;
  dw_idx := -1;
  uw_idx := -1;

  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
    EXIT;

  I := Idx;
  // search downword
  while (I > -1) do
  begin
    athumb := Thumbat(I);
    if athumb.SatisfiesCondition(condition) then
    begin
      dw_idx := I;
      break;
    end;
    dec(I);
  end;

  I := Idx;
  // search downword
  while (I < fVisibleThumbs.Count) do
  begin
    athumb := Thumbat(I);
    if athumb.SatisfiesCondition(condition) then
    begin
      uw_idx := I;
      break;
    end;
    inc(I);
  end;

  if dw_idx = -1 then
    result := uw_idx
  else if uw_idx = -1 then
    result := dw_idx
  else
  begin
    if abs(uw_idx - Idx) < abs(dw_idx - Idx) then
      result := uw_idx
    else
      result := dw_idx;
  end;
end;

function TThumbsBrowser.GotoThumb(athumb: TThumbEx; bselect: boolean): integer;
begin
  result := GetThumbIdx(athumb);
  if result = -1 then
    EXIT;

  GotoThumbPosition(result, bselect);
end;

procedure TThumbsBrowser.GotoThumbPosition(Idx: integer; select: boolean);
var
  col, row: integer;
begin
  if fVisibleThumbs.Count = 0 then
    EXIT;
  if GetThumbfromList_Safe(fVisibleThumbs, Idx) = nil then
    EXIT;

  Idx := max(0, min(Idx, fVisibleThumbs.Count - 1));

  case fBrowserOrientation of
    tbo_horz:
      begin
        col := GetThumbColumnbyIdx(Idx);
        if (col < fTopColumn) or (col > fBottomColumn) then // thumb is out of display
          GotoColumn(col)
      end;
    tbo_vert:
      begin
        row := GetThumbRowbyIdx(Idx);
        if (row < fTopRow) or (row > fBottomRow) then
          GotoRow(row)
      end;
  end;

  if select then
  begin
    if (MultiSelect = false) and (fSelectedIndex >= 0) then
      DeSelectThumbNoUpdate(fSelectedIndex)
    else
      DeselectAllThumbsNoUpdate;

    SelectThumbNoUpdate(Idx);
    RefreshDisplay;
  end;

end;

procedure TThumbsBrowser.GotoFileName(FileName: string; select: boolean);
var
  Idx: integer;
begin
  Idx := GetThumbIdxbyFileName(FileName);
  if Idx > -1 then
    GotoThumbPosition(Idx, select);

end;

procedure TThumbsBrowser.DoAfterInfoAcceptChanges(theFilename: string);
begin
{$IFDEF TB_FOLDERMONITOR}
  if (FFolderMonitor_Active) and (IsWatchingFolder(extractfilepath(theFilename))) and
    (waModified in FFolderMonitor_Actions) then
    EXIT; // the folder monitor will take care of the refresh
{$ENDIF}
  ReloadFile(theFilename);
end;

procedure TThumbsBrowser.DoAfterInfoRenameFile(const old_Name: string; const new_Name: string);
var
  tl: TList;
  athumb: TThumbEx;
  I: integer;
begin

{$IFDEF TB_FOLDERMONITOR}
  if (FFolderMonitor_Active) and (IsWatchingFolder(extractfilepath(old_Name))) and (waModified in FFolderMonitor_Actions)
  then
    EXIT; // the folder monitor will take care of the refresh
{$ENDIF}
  // fFolderMonitorCriticalSection.Enter;
  tl := TList.Create;
  try
    GetThumbsByFileName(old_Name, tl, true);

    for I := tl.Count - 1 downto 0 do
    begin
      athumb := GetThumbfromList(tl, I);
      ChangeFileNameThumb(athumb, new_Name);
    end;
  finally
    // fFolderMonitorCriticalSection.Leave;
    tl.Free;
  end;

end;

procedure TThumbsBrowser.ChangeFileNameThumb(theThumb: TThumbEx; const new_Name: string);
var
  ID: integer;
begin
  ID := fThumbs.IndexOf(theThumb.SourceFileName);
  if ID = -1 then
    EXIT;

  ChangeThumbKey(ID, new_Name);

  theThumb.SourceFileName := new_Name;
  theThumb.RetrieveParamsfromSourceFile(new_Name);
  theThumb.RefreshCaptions;

  RefreshThumb(GetThumbIdx(theThumb), true);
end;

procedure TThumbsBrowser.ChangeThumbKey(const ID: integer; const newKey: string);
begin
  fThumbs.SetKey(ID, newKey);
  fHiddenThumbs_NavMem.SetKey(fHiddenThumbs_NavMem.IndexOf(fThumbs[ID]), newKey);
end;

procedure TThumbsBrowser.DoAfterInfoClose(sender: TObject);
begin
  fInfoForm_Status := fThumbsbrowser_InfoForm.FormStatus;

  if assigned(fOnInfoFormClosed) then
    fOnInfoFormClosed(self);
end;

procedure TThumbsBrowser.DoOnBeforeThumbLoaded(sender: TObject);
begin;
end;

procedure TThumbsBrowser.DoOnLoaderDebug(sender: TObject);
begin
  assert(sender = fLoader);
end;

procedure TThumbsBrowser.DoOnAfterThumbLoaded(sender: TObject; ID: integer);
var
  Idx: integer;
begin
  Idx := GetVisibleThumbIdxfromThumbID(ID);

  if (Idx <> -1) and assigned(fOnThumbLoaded) then
    fOnThumbLoaded(Thumbat(Idx), Idx);

  RefreshThumb(Idx); // refresh after the onthumbloaded
end;

procedure TThumbsBrowser.DoOnAfterALLThumbsLoaded(sender: TObject);
begin

  if assigned(fOnAllThumbsLoaded) then
    fOnAllThumbsLoaded(self);
end;

procedure TThumbsBrowser.DoAfterLoaderInitialized(sender: TObject);
begin

  if fLoadingLocked = 0 then // if loading not locked
  begin
    if assigned(fOnInitialized) then
      fOnInitialized(self, bm_Files);
  end;

end;

{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.FolderMonitor_AddFolder(const theFolder: string; const bSubTree: boolean);
begin
  if not FFolderMonitor_Active then
    SetFolderMonitor_Active(true);

  SharedFolderMonitor.StartWatching(self, theFolder, bSubTree);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.FolderMonitor_RemoveFolder(const theFolder: string; const bSubTree: boolean);
var
  fl: TStringList;
  I: integer;
begin
  if bSubTree then
  begin
    fl := TStringList.Create;
    try

      TBGetFoldersRecursively(theFolder, fl);
      fl.Add(theFolder); // put in the end!
      for I := 0 to fl.Count - 1 do
        SharedFolderMonitor.StopWatching(self, fl[I]);
    finally
      fl.Free;
    end;
  end
  else
    SharedFolderMonitor.StopWatching(self, theFolder);
end;
{$ENDIF}

procedure TThumbsBrowser.DOOnScrollerScroll(sender: TObject; ScrollCode: TScrollCode; var ScrollPos: integer);
var
  mpos: TPoint;
begin
  if not fScrollerBox.Visible then
    EXIT;

  case ScrollCode of
    scLineDown:
      begin
        ScrollPos := ScrollPos - fScroller.SmallChange + fScrollParams.SmallChange;
        if ScrollerPos_To_VirtualPos(ScrollPos) > fScrollParams.Display_Maxlimited then
        begin
          ScrollPos := VirtualPos_To_ScrollerPos(fScrollParams.Display_Maxlimited);
        end;

      end;
    scLineUp:
      begin
        ScrollPos := ScrollPos + fScroller.SmallChange - fScrollParams.SmallChange;
      end;
    scPageDown:
      begin
        ScrollPos := ScrollPos - fScroller.LargeChange + fScrollParams.LargeChange;
      end;
    scPageUp:
      begin
        ScrollPos := ScrollPos + fScroller.LargeChange - fScrollParams.LargeChange;
      end;
  end;

  mpos := mouse.CursorPos;
  if ScrollPos <> fScrollParams.Pos then
    if not SetScrollPosition(fScroller, fScrollParams.Pos, ScrollPos) then
    begin
      if fBrowserOrientation = tbo_vert then
        Setcursorpos(mouse.CursorPos.X, mpos.Y)
      else
        Setcursorpos(mpos.X, mouse.CursorPos.Y)
    end;

end;

procedure TThumbsBrowser.DOOnScrollerChange(sender: TObject);
begin
  //
end;

function TThumbsBrowser.VirtualPos_To_ScrollerPos(Value: double): integer;
begin
  result := fScroller.min + round((Value - fScrollParams.Display_Min) /
    (fScrollParams.Display_Max - fScrollParams.Display_Min) * (fScroller.max - fScroller.min));
end;

function TThumbsBrowser.ScrollerPos_To_VirtualPos(Value: integer): integer;
begin
  result := fScrollParams.Display_Min + round(min(1, (Value - fScroller.min) / (fScroller.max - fScroller.min)) *
    (fScrollParams.Display_Max - fScrollParams.Display_Min))
end;

procedure TThumbsBrowser.DropThumbsFrom(srcTB: TThumbsBrowser; theTransferMode: TThumbsBrowser_DragDropTransferMode;
  destpoint: TPoint);
var
  Idx, new_idx: integer;

  procedure SortIntArray(var IntArray: array of integer);

    function _Compare(Item1, Item2: integer): integer;
    begin
      result := Item1 - Item2;
    end;

    procedure _QuickSort(L, r: integer);
    var
      I, j: integer;
      p: integer;
      T: integer;
    begin
      repeat
        I := L;
        j := r;
        p := IntArray[(L + r) shr 1];
        repeat
          while _Compare(IntArray[I], p) < 0 do
            inc(I);
          while _Compare(IntArray[j], p) > 0 do
            dec(j);
          if I <= j then
          begin
            T := IntArray[I];
            IntArray[I] := IntArray[j];
            IntArray[j] := T;
            inc(I);
            dec(j);
          end;
        until I > j;
        if L < j then
          _QuickSort(L, j);
        L := I;
      until I >= r;
    end;

  begin
    _QuickSort(Low(IntArray), High(IntArray));
  end;

  procedure DropToSelf;
  var
    I: integer;
    sortedList: array of integer;
    sortedThumbs: TList;
    ref_new_idx: integer;
    ref_thumb: TThumbEx;
  begin
    setlength(sortedList, self.SelectedCount);
    for I := 0 to self.SelectedCount - 1 do
    begin
      Idx := GetThumbIdx(SelectedThumbs[I]);
      sortedList[I] := Idx;
    end;

    SortIntArray(sortedList);
    // TArray.Sort<INTEGER>(sortedList);

    sortedThumbs := TList.Create;
    try
      for I := 0 to high(sortedList) do
        sortedThumbs.Add(fVisibleThumbs[sortedList[I]]);

      for I := 0 to high(sortedList) do // first move all to last
        fVisibleThumbs.Move(fVisibleThumbs.IndexOf(TThumbEx(sortedThumbs[I])), fVisibleThumbs.Count - 1);

      ref_new_idx := max(0, min(new_idx, fVisibleThumbs.Count - length(sortedList)));
      ref_thumb := fVisibleThumbs[ref_new_idx];

      for I := 0 to high(sortedList) do
      begin
        fVisibleThumbs.Move(fVisibleThumbs.IndexOf(TThumbEx(sortedThumbs[I])), ref_new_idx);
        ref_new_idx := fVisibleThumbs.IndexOf(ref_thumb);
      end;
    finally
      sortedThumbs.Free;
    end;

  end;

  procedure DropToOther;
  var
    sel_count: integer;
    aThumb_src, aThumb_dest: TThumbEx;
    copy_list: TList;
    I: integer;

    ref_new_idx: integer;
  begin

    copy_list := TList.Create;
    try

      sel_count := srcTB.SelectedCount;
      for I := 0 to sel_count - 1 do
        copy_list.Add(srcTB.SelectedThumbs[I]);

      ref_new_idx := new_idx;
      for I := 0 to copy_list.Count - 1 do
      begin
        aThumb_src := TThumbEx(copy_list[I]);
        aThumb_dest := DuplicateThumb(aThumb_src, ref_new_idx);

        ref_new_idx := GetThumbIdx(aThumb_dest);
      end;

      for I := 0 to copy_list.Count - 1 do
      begin
        aThumb_src := TThumbEx(copy_list[I]);
        if (theTransferMode = dd_Copy) then
          aThumb_src.SELECTED := false
        else
          srcTB.Deletethumb(aThumb_src)
      end;

    finally
      copy_list.Free;
    end;
  end;

begin
  if not assigned(srcTB) then
    EXIT;
  if srcTB.SelectedThumbs.Count = 0 then
    EXIT;

  ResetMouseHover;

  new_idx := Detect_DragDrop_Insertpoint(destpoint.X, destpoint.Y);

  if (srcTB = self) and (theTransferMode = dd_Move) then
    DropToSelf
  else
    DropToOther;

  fsort_updated := false;
  ffilter_updated := false;
end;

procedure TThumbsBrowser.DropFilesFromTB(srcTB: TThumbsBrowser; mode: TThumbsBrowser_DragDropTransferMode;
  destpoint: TPoint);
var
  selectFName: string;
  sl: TStringList;
  sfilenames: string;
begin
  // Here we handle the DragDrop event in order to copy / move the actual files rather than their thumbnails
  if not assigned(srcTB) then
    EXIT;
  if srcTB.SelectedCount = 0 then
    EXIT;

  ResetMouseHover;
  selectFName := IncludeTrailingPathDelimiter(FolderCurrent) + extractfilename(srcTB.GetSelected(0).SourceFileName);

  sl := TStringList.Create;
  try
    srcTB.GetFileNames_Selected(sl);
    sfilenames := TBFileListToShellParamStr(sl);
  finally
    sl.Free;
  end;

  if mode = dd_Copy then
    TBCopyFileList(sfilenames, fFolderCurrent)
  else if mode = dd_Move then
    TBMoveFileList(sfilenames, fFolderCurrent);

  // this is only needed if Folder Monitor is not active
  if {$IFDEF TB_FOLDERMONITOR}(not IsWatchingFolder(fFolderCurrent)){$ELSE} true {$ENDIF} then
  begin
    RefreshFolders;
    // goto first filename
    GotoFileName(selectFName, true);
  end;

  if mode = dd_Move then
  begin
    // refresh source
    srcTB.ReLoadFiles;
  end;

end;

procedure TThumbsBrowser.DropFilesFromExplorer(filenames: TStrings; mode: TThumbsBrowser_DragDropTransferMode);
var
  selectFName, sfilenames: string;
begin
  if filenames.Count = 0 then
    EXIT;

  // Here we handle the DragDrop event in order to copy / move the actual files rather than their thumbnails
  selectFName := IncludeTrailingPathDelimiter(FolderCurrent) + extractfilename(filenames[0]);

  sfilenames := TBFileListToShellParamStr(filenames);

  if mode = dd_Copy then
    TBCopyFileList(sfilenames, fFolderCurrent)
  else if mode = dd_Move then
    TBMoveFileList(sfilenames, fFolderCurrent);

  // this is only needed if Folder Monitor is not active
  if {$IFDEF TB_FOLDERMONITOR}(not IsWatchingFolder(fFolderCurrent)){$ELSE} true {$ENDIF} then
  begin
    RefreshFolders;
    // goto first filename
    GotoFileName(selectFName, true);
  end;
end;

procedure TThumbsBrowser.ResetMouseHover;
begin
  RestoreMouseOver(fMouseHoverThumb);
  fMouseHoverThumb := nil;
  RestoreMouseOver(fMouseHoverThIdx);
  fMouseHoverThIdx := -1;
end;

procedure TThumbsBrowser.HideThumbs;
begin
  HideThumbs([], IfNo_condition);
end;

procedure TThumbsBrowser.HideThumbs(const sourcetypes: TTB_SourceTypes; const condition: TTB_Browser_PickCondition);
begin
  HideThumbs([vtyp_User], sourcetypes, condition, true);
end;

procedure TThumbsBrowser.HideThumbs(theFileNames: TStringList);
var
  tl: TList;
  I: integer;
begin
  tl := TList.Create;
  try
    for I := 0 to theFileNames.Count - 1 do
    begin
      GetThumbsByFileName(theFileNames[I], tl, false);
    end;
    HideThumbs(false, [vtyp_User], tl, true);
  finally
    tl.Free;
  end;
end;

procedure TThumbsBrowser.HideThumbs(VisibilityTypes: TThumbsBrowser_ThumbVisibilityTypes;
  const sourcetypes: TTB_SourceTypes; const condition: TTB_Browser_PickCondition; const bUpdateDisplay: boolean);
var
  tl: TList;
begin
  tl := TList.Create;
  try
    GetThumbsList(tl, sourcetypes, condition, false);
    HideThumbs(false, VisibilityTypes, tl, bUpdateDisplay);
  finally
    tl.Free;
  end;
end;

procedure TThumbsBrowser.HideThumbs(bForceVisibilityEvent: boolean;
  VisibilityTypes: TThumbsBrowser_ThumbVisibilityTypes; tl: TList; const bUpdateDisplay: boolean);
var
  I: integer;
  athumb: TThumbEx;
  vtransTypes: TThumbsBrowser_ThumbVisibilityTransactions;
begin
  vtransTypes := [];
  if vtyp_NavMemory in VisibilityTypes then
    vtransTypes := vtransTypes + [vtr_NavMemoryHide];
  if vtyp_Filter in VisibilityTypes then
    vtransTypes := vtransTypes + [vtr_FilterHide];
  if vtyp_User in VisibilityTypes then
    vtransTypes := vtransTypes + [vtr_UserHide];

  LockUpdate;
  OpenVisibilityTransaction(vtransTypes);
  try
    for I := 0 to tl.Count - 1 do
    begin
      athumb := TThumbEx(tl[I]);

      if athumb.Visible then
        athumb.Visible := false;

      if bForceVisibilityEvent then
      begin
        if fVisTransOpened_FilterHide > 0 then
          ManageThumbVisibilityChange(va_HideFilter, athumb);
        if fVisTransOpened_NavMemoryHide > 0 then
          ManageThumbVisibilityChange(va_HideNavMemory, athumb);
        if fVisTransOpened_UserHide > 0 then
          ManageThumbVisibilityChange(va_HideUser, athumb);
      end;

    end;
  finally
    CloseVisibilityTransaction(vtransTypes);
    UnlockUpdate(bUpdateDisplay);
  end;

end;

procedure TThumbsBrowser.HideThumbsToNavMemory;
begin
  HideThumbsToNavMemory(NmOnFull_Clear, true, true);
end;

procedure TThumbsBrowser.HideThumbsToNavMemory(OnNavMemoryFull: TThumbsBrowser_NavMemoryOnFullAction;
  const bSwitchNavMemoryOn, bUpdateDisplay: boolean);
var

  I: integer;
  athumb: TThumbEx;
  bDeleted: boolean;
begin
  StopBrowsing;

  if bSwitchNavMemoryOn then
    fNavMemory := true;

  if assigned(fNavigatorThumb) then
    Deletethumb(fNavigatorThumb);

  LockUpdate;
  try

    for I := fThumbs.Count - 1 downto 0 do // downward because of deletethumb
    begin
      athumb := TThumbEx(fThumbs[I]);
      bDeleted := false;
      // assert(aThumb.sourcefilename = fThumbs.GetKey(i));
      if (athumb.SourceType in TBGetSourceTypes_FileSystem) and (athumb.Originator = tborig_Auto) then
      begin
        // NOTICE THIS MUST BE DONE FIRST  (because of the special handling of nav memory)
        // ------------------------------------------------------------------------
        if not IsThumbHidden(vtyp_NavMemory, athumb) then
        begin
          if OnNavMemoryFull = NmOnFull_ExpandMemory then // if can expand memory
            NavMemCheckAdd(athumb, true) // add to memory passing bCanExpand = true
          else
          begin // else if cannot expand memory
            if not NavMemCheckAdd(athumb, false) then // check if can add without expanding
            begin
              if OnNavMemoryFull = NmOnFull_Clear then // if cannot add and mode is clear
                bDeleted := Deletethumb(I);
            end;
          end;
        end;
        // ------------------------------------------------------------------------

        // NOTICE THIS MUST BE DONE AFTER  (because of the special handling of nav memory)
        // ------------------------------------------------------------------------
        if not bDeleted then // thumb was not deleted
        begin
          if athumb.Visible then
            athumb.Visible := false;
        end;
        // ------------------------------------------------------------------------
      end;
    end;

  finally
    UnlockUpdate(bUpdateDisplay);
  end;

  Paths_Clear;
end;

procedure TThumbsBrowser.ManageThumbVisibilityChange(VisibilityAction: TThumbsBrowser_ThumbVisibilityAction;
  athumb: TThumbEx);
begin
  case VisibilityAction of
    va_Reshow:
      begin
        fHiddenThumbs_NavMem.remove(athumb);
        fHiddenThumbs_Filter.remove(athumb);
        fHiddenThumbs_User.remove(athumb);
      end;
    va_ReshowNavMemory:
      begin
        fHiddenThumbs_NavMem.remove(athumb);
      end;
    va_ReshowFilter:
      begin
        fHiddenThumbs_Filter.remove(athumb);
      end;
    va_ReshowUser:
      begin
        fHiddenThumbs_User.remove(athumb);
      end;
    va_HideUnknownReason:
      begin
        if athumb.SourceType in TBGetSourceTypes_FileSystem then
        begin
          if not IsThumbHidden(vtyp_NavMemory, athumb) then
            NavMemCheckAdd(athumb, true);
        end;
      end;
    va_HideNavMemory:
      if not IsThumbHidden(vtyp_NavMemory, athumb) then
        NavMemCheckAdd(athumb, true);
    va_HideFilter:
      if not IsThumbHidden(vtyp_Filter, athumb) then
        fHiddenThumbs_Filter.Add(athumb);
    va_HideUser:
      if not IsThumbHidden(vtyp_User, athumb) then
        fHiddenThumbs_User.Add(athumb);
  end;
end;

function TThumbsBrowser.NavMemCheckAdd(athumb: TThumbEx; bAllowExpand: boolean): boolean;
begin
  if fHiddenThumbs_NavMem.Count < fNavMemMaxThumbs then // if within limit
  begin
    fHiddenThumbs_NavMem.Add(athumb.SourceFileName, athumb);
    result := true;
  end // outside limit
  else if bAllowExpand then
  begin
    // expand memory adding 100 to maximum
    fNavMemMaxThumbs := fNavMemMaxThumbs + 100;
    fHiddenThumbs_NavMem.Add(athumb.SourceFileName, athumb);
    result := true;
  end
  else // outside limit and cannot expand: return false
    result := false;
end;

function TThumbsBrowser.HitResultIsSelect(hitResult: TTB_Thumb_HitRectResult): boolean;
begin
  result := (hitResult <> HitOutside) AND (hitResult <> HitCheck) AND (hitResult <> HitRotateButtonLeft) AND
    (hitResult <> HitRotateButtonRight);

end;

procedure TThumbsBrowser.PopupExplorerMenu(X, Y: integer);
var
  sl: TStringList;
  I: integer;
  athumb: TThumbEx;
begin
  sl := TStringList.Create;
  try
    for I := 0 to fSelectedThumbs.Count - 1 do
    begin
      athumb := GetSelected(I);
      if (athumb.SourceType = st_File) or (athumb.SourceType = st_Folder) then
        sl.Add(athumb.SourceFileName);
    end;
{$IFDEF IMAGEEN_5_0_LATER}
    iexWindowsFunctions.PopupSystemMenu(Handle, sl, X, Y);
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}
    if not FFolderMonitor_Active then
{$ENDIF}
    begin
      for I := 0 to sl.Count - 1 do
      begin
        if not fileexists(sl[I]) then
        begin
          RefreshFolders;
          break;
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function TThumbsBrowser.PromptForFolder: boolean;
var
  sFolder: string;
begin
  sFolder := fFolderCurrent;
  result := WindowsSelectDirectory(iemsg(IEMSG_SelectAFolderToOpen), sFolder, self);
  if result then
    FolderCurrent := sFolder;
end;

procedure TThumbsBrowser.DoOnThumbsAreaMouseUp(sender: TObject; Button: TMouseButton; shift: TShiftState;
  X, Y: integer);
var
  ClickedIdx: integer;
  mupResult: TTB_Thumb_MouseUpResult;
  hitResult: TTB_Thumb_HitRectResult;
  procedure DoSelectionStuff;
  var
    shift_active: boolean;
    ctrl_active: boolean;
  begin
    shift_active := fMultiSelect and fShiftFlag;
    ctrl_active := fMultiSelect and fCTRLFlag;

    if (not ctrl_active) then
      DeselectAllThumbsNoUpdate;

    if shift_active then // shift+multiselect
    begin
      if (fLastShiftClickedID_s = -1) then
        fLastShiftClickedID_s := ClickedIdx;
      if fLastShiftClickedID_e <> -1 then
        DeselectThumbsRangeNoUpdate(fLastShiftClickedID_s, fLastShiftClickedID_e);
      SelectThumbsRangeNoUpdate(fLastShiftClickedID_s, ClickedIdx);
      fLastShiftClickedID_e := ClickedIdx;
      // fLastShiftClickedID_e := ClickedId;
    end
    else
    begin // ctrl+multiselect and single select
      if not ctrl_active then
        fLastShiftClickedID_s := ClickedIdx;
      if not IsThumbSelected(ClickedIdx) then
        SelectThumbNoUpdate(ClickedIdx)
      else
      begin
        if (fSelectedThumbs.Count > 1) or (fMultiSelect) then
          DeSelectThumbNoUpdate(ClickedIdx);
      end;
    end;
  end;

var
  thumbs_indisplay: TList;
  bMinorClickOccurred: boolean;
  clickPt: TPoint;
begin
  if (fHeaderSelectedColIdx <> -1) and (not fMovingHeader) then
  begin
    // clicked on report column: sort columns
    if fHeaderCaptionForSorting = TTB_Thumb_CaptionsSetting(fThumbCaption_Info[fHeaderSelectedColIdx].capIdx) then
    begin
      if fHeaderCaptionSortingDirection = compAscending then
        fHeaderCaptionSortingDirection := compDescending
      else
        fHeaderCaptionSortingDirection := compAscending;
    end
    else
      fHeaderCaptionForSorting := TTB_Thumb_CaptionsSetting(fThumbCaption_Info[fHeaderSelectedColIdx].capIdx);

    SortThumbs(false, stAsFromReportHeader);
    RefreshDisplay;
    fHeaderSelectedColIdx := -1;
    EXIT; // >>>>EXIT
  end;
  fHeaderSelectedColIdx := -1;
  fHeaderResizedColIdx := -1;
  if fResizingHeader then
  begin
    fResizingHeader := false;
    EXIT; // >>>>EXIT
  end;
  if (fMovingHeader) then
  begin
    fMovingHeader := false;
    if assigned(fOnCaptionsOrderChanged) then
      fOnCaptionsOrderChanged(self);
    EXIT; // >>>>EXIT
  end;

  if SharedDragDrop_Handler.DraggingActive then
  begin
    SharedDragDrop_Handler.DoDragDrop(shift);
    // ForceScrollerBoxUpdate(true);
    EXIT; // >>>> EXIT
  end;

  if (Button = mbRight) then
  begin
    if fPopupDefaultExplorer and (PopupMenu = nil) then
    begin
      PopupExplorerMenu(X, Y);
      EXIT;
    end
    else if (PopupMenu <> nil) then
      EXIT;
  end;

  ClickedIdx := GetThumbIdxbyMousexy(X, Y);
  if ClickedIdx = -1 then
    EXIT;

  fLastClickedThumb := GetThumbfromList_Safe(fVisibleThumbs, ClickedIdx);
  clickPt := point(XBrowser2Thumb(X, ClickedIdx), YBrowser2Thumb(Y, ClickedIdx));
  fLastClickedThumb.ClickPoint := clickPt;

  mupResult := fLastClickedThumb.HandleMouseUp(Button, shift, fLastClickedThumb.ClickPoint.X,
    fLastClickedThumb.ClickPoint.Y, hitResult);

  if mupResult = mupoutside then
    EXIT; // >>>>EXIT - clicked outside nothing else to do

  // DO Check and rotate stuff here
  case hitResult of
    HitCheck:
      begin
        CheckMarkThumbNoUpdate(ClickedIdx, not fLastClickedThumb.Checked);
        // RefreshThumb(clickedId);
      end;
    HitRotateButtonLeft:
      begin
        if fLastClickedThumb.RotateMode <> trmLeft then
          MarkRotatedThumbNoUpdate(ClickedIdx, trmLeft)
        else
          MarkRotatedThumbNoUpdate(ClickedIdx, trmnone);
      end;
    HitRotateButtonRight:
      begin
        if fLastClickedThumb.RotateMode <> trmRight then
          MarkRotatedThumbNoUpdate(ClickedIdx, trmRight)
        else
          MarkRotatedThumbNoUpdate(ClickedIdx, trmnone);
      end;
    HitRatingBox:
      begin
{$IFDEF TB_FOLDERMONITOR}
        SuspendFolderMonitor(2000, fLastClickedThumb.SourceFileName);
{$ENDIF}
        if CheckChangeVisualRating(fLastClickedThumb, ClickedIdx, X, Y, false) <> -1 then
          fLastClickedThumb.Rating := CheckChangeVisualRating(fLastClickedThumb, ClickedIdx, X, Y, false);

      end;
  end;

  // Handle minor click events (before selection stuff)
  bMinorClickOccurred := false;
  if hitResult = HitTopTitle then
  begin
    if assigned(fOnThumbTopTitleClicked) and (fLastClickedThumb.SELECTED) then
    begin
      fOnThumbTopTitleClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if hitResult = HitBottomTitle then
  begin
    if assigned(fOnThumbBottomTitleClicked) and (fLastClickedThumb.SELECTED) then
    begin
      fOnThumbBottomTitleClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if hitResult = HitCaption then
  begin
    if assigned(fOnThumbCaptionClicked) and (fLastClickedThumb.SELECTED) then
    begin
      fOnThumbCaptionClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if hitResult = HitCheck then
  begin
    if assigned(fOnThumbCheckClicked) then
    begin
      fOnThumbCheckClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if hitResult = HitInfoBox then
  begin
    if assigned(fOnThumbInfoClicked) then
    begin
      fOnThumbInfoClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if (hitResult = HitRotateButtonLeft) or (hitResult = HitRotateButtonRight) then
  begin
    if assigned(fOnThumbRotateClicked) then
    begin
      fOnThumbRotateClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end
  else if (hitResult = HitRatingBox) then
  begin
    if assigned(fOnThumbRatingClicked) then
    begin
      fOnThumbRatingClicked(fLastClickedThumb, ClickedIdx);
      bMinorClickOccurred := true;
    end;
  end;

  // do selection stuff before handling main click event
  // if  (not fMultiSelect) or (fSelectedthumbs.Count = 0) then
  if HitResultIsSelect(hitResult) and (not bMinorClickOccurred) then
  begin

    if fMultiSelect and fShiftFlag then
    begin
      DoSelectionStuff;
      RefreshDisplay;
    end
    else
    begin
      thumbs_indisplay := TList.Create;
      try
        GetDisplayedThumbsList(thumbs_indisplay, IfSelected);
        DoSelectionStuff;

        RefreshListofThumbs(thumbs_indisplay);

        RefreshThumb(ClickedIdx);
      finally
        thumbs_indisplay.Free;
      end;
    end;
  end
  else
    RefreshThumb(ClickedIdx);

  if not bMinorClickOccurred then
  begin
    if assigned(fThumbsbrowser_InfoForm) then
    begin
      if (SelectedCount = 1) and (fLastClickedThumb = GetSelected(0)) then
        ShowInfo(fLastClickedThumb)
      else
        ShowInfo;
    end;

    if (hitResult = HitInfoBox) and (fLastClickedThumb.Source_IS_FileSystem) and fPopupDefaultExplorer then
      PopupExplorerMenu(X, Y);
  end;

  // main click event
  if assigned(fOnThumbClicked) then
    fOnThumbClicked(fLastClickedThumb, ClickedIdx);

  if assigned(fOnThumbClickedEX) then
    fOnThumbClickedEX(fLastClickedThumb, ClickedIdx, clickPt.X, clickPt.Y, hitResult);
end;

function TThumbsBrowser.GetThumbfromList(List: TList; Idx: integer): TThumbEx;
begin
  if (Idx < 0) or (Idx > List.Count - 1) then
    // if (Idx > List.count - 1) then
    result := nil
  else
    result := TThumbEx(List.items[Idx]);
end;

function TThumbsBrowser.GetThumbfromList_Safe(List: TList; Idx: integer): TThumbEx;
begin
  if (Idx < 0) or (Idx > List.Count - 1) then
    result := nil
  else
  begin
    try
      result := TThumbEx(List.items[Idx]);
    except
      result := nil;
    end;
  end;
end;

function TThumbsBrowser.Thumbat_AbsoluteIdx(Idx: integer): TThumbEx;
begin
  result := GetThumbfromList(fThumbs, Idx);
end;

function TThumbsBrowser.ThumbIsMouseOver(theThumb: TThumbEx): boolean;
begin
  result := theThumb = fMouseHoverThumb;
end;

function TThumbsBrowser.Thumbat(Idx: integer): TThumbEx;
begin
  result := GetThumbfromList(fVisibleThumbs, Idx);
end;

function TThumbsBrowser.Thumbat(X, Y: integer): TThumbEx;
var
  Idx: integer;
begin
  Idx := GetThumbIdxbyMousexy(X, Y);
  result := GetThumbfromList_Safe(fVisibleThumbs, Idx);
end;

function TThumbsBrowser.Thumbat(FileName: string): TThumbEx;
var
  Idx: integer;
begin
  Idx := GetThumbIdxbyFileName(FileName);
  result := GetThumbfromList_Safe(fVisibleThumbs, Idx);
end;

procedure TThumbsBrowser.GetThumbsByFileName(const FileName: string; theThumbs: TList; const bClearList: boolean);
var
  I: integer;
  athumb: TThumbEx;
begin
  if not assigned(theThumbs) then
    EXIT;

  if bClearList then
    theThumbs.clear;

  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    athumb := Thumbat(I);
    if comparetext(athumb.SourceFileName, FileName) = 0 then
      theThumbs.Add(athumb);
  end;
end;

function TThumbsBrowser.InPaths(const theFilename: string): boolean;
begin
  result := IsPathInPaths(tbs_GetParentPath(theFilename));
end;

function TThumbsBrowser.InPaths(theThumb: TThumbEx; bCheckSourceType: boolean): boolean;
begin
  result := false;
  if bCheckSourceType and (theThumb.SourceType in TBGetSourceTypes_NonFileSystem) then
    EXIT;

  result := IsPathInPaths(tbs_GetParentPath(theThumb.SourceFileName));
end;

function TThumbsBrowser.IsPathInPaths(const thePath: string): boolean;
var
  j: integer;
  sPath: string;
begin
  result := false;

  if thePath = '' then
    EXIT;

  sPath := Tbs_AddSlash(thePath);

  for j := 0 to fBrowsedPaths.Count - 1 do
  begin
    result := (comparetext(sPath, fBrowsedPaths[j]) = 0);
    if result then
      break;
  end;
end;

function TThumbsBrowser.Detect_DragDrop_Insertpoint(X, Y: integer): integer;
var
  Idx, xt, xDisp, yDisp, w_half, c, r, new_r, new_c: integer;
  athumb: TThumbEx;
begin
  result := -1;

  Idx := GetThumbIdxbyMousexy(X, Y);
  if (Idx = -1) then
  begin
    if MouseIsInside then
      Idx := ThumbsCount - 1
    else
      EXIT;
  end;

  if (Idx = -1) then
    EXIT;

  athumb := Thumbat(Idx);

  xt := XBrowser2Thumb(X, Idx);
  w_half := athumb.TotalWidth div 2;

  c := GetThumbColumnbyIdx(Idx);
  r := GetThumbRowbyIdx(Idx);
  new_c := c;
  new_r := r;

  if xt > w_half then
    new_c := c + 1;

  if new_c > fNColumns - 1 then
  begin
    if r + 1 < fNRows then
    begin
      new_c := 0;
      new_r := r + 1;
    end
    else
      new_c := fNColumns;
  end;

  xDisp := 0;
  yDisp := 0;
  case fBrowserOrientation of
    tbo_vert:
      begin
        xDisp := fDisplayMarginLeft + fDynamicMarginX + new_c * fpassox;
        yDisp := fDisplayMarginTop + fDynamicMarginY + new_r * fpassoy - ScrollerPos_To_VirtualPos(fScrollParams.Pos);
      end;
    tbo_horz:
      begin
        xDisp := fDisplayMarginLeft + fDynamicMarginX + new_c * fpassox - ScrollerPos_To_VirtualPos(fScrollParams.Pos);
        yDisp := fDisplayMarginTop + fDynamicMarginY + new_r * fpassoy;
      end;
  end;

  result := GetThumbIdxbyMousexy(XDisplay2Browser(xDisp), YDisplay2Browser(yDisp));
  if result = -1 then
    result := fVisibleThumbs.Count - 1;
end;

function TThumbsBrowser.GetThumbLayoutType: TTB_Thumb_Layout_Type;
begin
  result := fSampleThumb.LayoutType;
end;

function TThumbsBrowser.GetThumbIOParams(Idx: integer): TIOParams;
begin
  result := Thumb[Idx].IOParams;
end;

procedure TThumbsBrowser.SetFileThumbs(const Value: boolean);
begin
  if fFileThumbs = Value then
    EXIT;

  fFileThumbs := Value;

  CreateVisibleThumbs;
  if Value then
  begin
    if StyleOptions.BrowserStyle = tbStyle_Columns then
      SortThumbs(false, stAsFromReportHeader)
    else
      SortThumbs(false, fSortType);
  end;
  RefreshDisplay;

  if (csDesigning in ComponentState) and (not(csLoading in ComponentState)) then
  begin
    if not(fFileThumbs or fFolderThumbs) then
      showmessage('Warning! Both FileThumbs and FolderThumbs are disabled!');
  end;
end;

procedure TThumbsBrowser.SetFolderThumbs(const Value: boolean);
begin
  if fFolderThumbs = Value then
    EXIT;

  fFolderThumbs := Value;
  CreateVisibleThumbs;
  if Value then
  begin
    if StyleOptions.BrowserStyle = tbStyle_Columns then
      SortThumbs(false, stAsFromReportHeader)
    else
      SortThumbs(false, fSortType);
  end;
  RefreshDisplay;

  if (csDesigning in ComponentState) and (not(csLoading in ComponentState)) then
  begin
    if not(fFileThumbs or fFolderThumbs) then
      showmessage('Warning! Both FileThumbs and FolderThumbs are disabled!');
  end;
end;

procedure TThumbsBrowser.SetFolderNavigation(const Value: boolean);
begin
  if fFolderNavigation = Value then
    EXIT;

  fFolderNavigation := Value;
  CreateVisibleThumbs;
  if Value then
  begin
    if StyleOptions.BrowserStyle = tbStyle_Columns then
      SortThumbs(false, stAsFromReportHeader)
    else
      SortThumbs(false, fSortType);
  end;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetFolderUpNavThumb(const Value: boolean);
begin
  fFolderUpNavThumb := Value;

  if assigned(fNavigatorThumb) then
  begin
    Delete_a_Thumb(fNavigatorThumb);
    fNavigatorThumb := nil;
  end;
end;

procedure TThumbsBrowser.SetFolderSpecialOptions(const bCheckBoxes, bTitles: boolean);
var
  tl: TList;
  I: integer;
  athumb: TThumbEx;
begin
  tl := TList.Create;
  LockUpdate;
  try
    GetThumbsList(tl, [st_Folder], IfNo_condition, true);
    for I := 0 to tl.Count - 1 do
    begin
      athumb := TThumbEx(tl[I]);

      athumb.Layout_Lock;
      try
        athumb.Checked := bCheckBoxes;
        if bCheckBoxes then
          athumb.ShowSettings := athumb.ShowSettings + [th_ShowCheckBox]
        else
          athumb.ShowSettings := athumb.ShowSettings - [th_ShowCheckBox];

        if bTitles then
        begin
          if fShowTopTitle then
            athumb.ShowSettings := athumb.ShowSettings + [th_ShowTopTitle];

          if fShowBottomTitle then
            athumb.ShowSettings := athumb.ShowSettings + [th_ShowBottomTitle];
        end
        else
        begin
          athumb.ShowSettings := athumb.ShowSettings - [th_ShowTopTitle, th_ShowBottomTitle];
        end;

      finally
        athumb.Layout_Unlock;
      end;
    end;
  finally
    UnlockUpdate(true);
    tl.Free;
  end;

end;

procedure TThumbsBrowser.SetFolderTitles(const Value: boolean);
begin
  if Value = fFolderTitles then
    EXIT;

  fFolderTitles := Value;
  SetFolderSpecialOptions(fFolderCheckBoxes, fFolderTitles);
end;

procedure TThumbsBrowser.SetLanguage(const Value: TNWSCompsLanguage);
begin
  fLanguage := Value;
  if (csLoading in ComponentState) then
    EXIT;

  fMetaTags.SetLanguage(fLanguage);
  RefreshDisplay;
end;

procedure TThumbsBrowser.HandleGlobalNotification(sender: TObject; notType: TNWSCompsNotificationType);
begin
  case notType of
    nwsNotTyp_Lang:
      begin
        SetLanguage(NWSCOMPS.Language);
      end;
  end;

end;

procedure TThumbsBrowser.SetFolderCheckBoxes(const Value: boolean);
begin
  if Value = fFolderCheckBoxes then
    EXIT;

  fFolderCheckBoxes := Value;
  SetFolderSpecialOptions(fFolderCheckBoxes, fFolderTitles);
end;

procedure TThumbsBrowser.SetFolderCurrent(const Value: string);
begin
  if comparetext(IncludeTrailingPathDelimiter(fFolderCurrent), IncludeTrailingPathDelimiter(Value)) = 0 then
    EXIT;

  if (csDesigning in ComponentState) or (csLoading in ComponentState) and (Value = '') then
  begin
    fFolderCurrent := '';
    EXIT;
  end;

  if not directoryexists(Value) then
  begin
    showmessage('Folder: ' + Value + ' does not exist.');
    EXIT;
  end;
  fFolderCurrent := Value;
  if csDesigning in ComponentState then
    fFolderDefault := tbdfSpecified
  else if not(csLoading in ComponentState) then
    NavigateToFolder(fFolderCurrent);
end;

procedure TThumbsBrowser.SetFolderDefault(const Value: TThumbsBrowserDeafultFolder);
begin
  fFolderDefault := Value;

  // if csLoading in ComponentState then
  begin
    // do not use the setter of folderCurrent!
    case Value of
      tbdfNone:
        fFolderCurrent := '';
      tbdfDesktop:
        fFolderCurrent := tbs_GetSpecialFolderPath(CSIDL_DESKTOP);
      tbdfDrives:
        fFolderCurrent := tbs_GetSpecialFolderPath(CSIDL_DRIVES);
      tbdfRootDir:
        fFolderCurrent := extractfiledrive(Application.ExeName);
      tbdfMyDocuments:
        fFolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYDOCUMENTS);
      tbdfMyPictures:
        fFolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYPICTURES);
      tbdfMyVideos:
        fFolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYVIDEO);
      tbdfSpecified:
        ;
    end;
  end;
end;

{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.Handle_FolderMonitorNotify(const sender: TObject; const Action: TWatchAction;
  const FileName: string);
var
  suspList: TList;
  aItem: TThumbsBrowser_FolderMonitor_Item;
  suspItem: TThumbsBrowser_FolderMonitor_SuspendedItem;
  bCanGo: boolean;
  I: integer;
  bThisItemIsSuspended: boolean;
begin
  if not FFolderMonitor_Active then
    EXIT;
  if FFolderMonitor_Locked > 0 then
    EXIT;
  if FFolderMonitor_GlobalSuspendedTime > 0 then
  begin
    if (FFolderMonitor_GlobalSuspendedTime <> -1) and
      ((gettickcount - FFolderMonitor_GlobalStartSuspend) > FFolderMonitor_GlobalSuspendedTime) then
      FFolderMonitor_GlobalSuspendedTime := 0
    else if ((FFolderMonitor_GlobalSuspendedActions = []) or (Action in FFolderMonitor_GlobalSuspendedActions)) then
      EXIT; // >>>>EXIT (Suspended globally)
  end;

  bThisItemIsSuspended := false;
  if assigned(FFolderMonitor_SuspendedList) then
  begin
    suspList := FFolderMonitor_SuspendedList.LockList; // enter critical section
    try
      for I := suspList.Count - 1 downto 0 do
      begin
        suspItem := TThumbsBrowser_FolderMonitor_SuspendedItem(suspList[I]);
        if (suspItem.SuspendInterval <> -1) and (suspItem.SuspensionStart + suspItem.SuspendInterval <= gettickcount)
        then
        begin
          // suspension finished: remove item
          suspList.Delete(I);
        end
        else if (comparetext(ExcludeTrailingPathDelimiter(suspItem.FileName), ExcludeTrailingPathDelimiter(FileName))
          = 0) and ((suspItem.SuspendedActions = []) or (Action in suspItem.SuspendedActions)) then
        begin
          // suspension in course: suspend this item
          bThisItemIsSuspended := true;
        end;
      end;
    finally
      FFolderMonitor_SuspendedList.unlocklist;
    end;
  end;

  if bThisItemIsSuspended then
    EXIT; // >>>>EXIT

  bCanGo := AcceptFileCondition(FileName, Action = waRemoved) or AcceptFolderCondition(FileName, Action = waRemoved);

  if bCanGo then
  begin
    aItem := TThumbsBrowser_FolderMonitor_Item.Create(FileName, Action);
    fFolderMonitor_List.Add(aItem);
    CreateFolderWatchTimer;
  end;

end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.Handle_FolderMonitorTimer(sender: TObject);
var
  I: integer;
  filesToAdd, filesToRefresh: TStringList;
  aItem: TThumbsBrowser_FolderMonitor_Item;

  bLock: boolean;
  bHandled: boolean;
begin
  if assigned(fFolderMonitor_Timer) then
    fFolderMonitor_Timer.enabled := false;

  if not FFolderMonitor_Active then
  begin
    fFolderMonitor_List.clear;
    EXIT;
  end;

  if assigned(fOnFolderMonitorEvent) then
  begin
    bHandled := false;
    fOnFolderMonitorEvent(fFolderMonitor_List, bHandled);
    if bHandled then
      EXIT;
  end;

  filesToAdd := TStringList.Create;
  filesToRefresh := TStringList.Create;
  try
    for I := 0 to fFolderMonitor_List.Count - 1 do
    begin
      aItem := fFolderMonitor_List[I];
      case aItem.Action of
        waAdded:
          begin
            filesToAdd.Add(aItem.FileName);
          end;
        waRenamedNew:
          begin
            filesToAdd.Add(aItem.FileName);
          end;
        waRemoved, waModified: // , waRenamedOld:
          begin
            filesToRefresh.Add(aItem.FileName);
          end;
      end;
    end;

    bLock := (filesToAdd.Count > 0) and (filesToRefresh.Count > 0);

    if bLock then
      LockLoading;
    try
      if filesToAdd.Count > 0 then
        StartBrowsing(filesToAdd, false);
    finally
      if bLock then
        UnLockLoading;
    end;

    if filesToRefresh.Count > 0 then
      ReLoadFiles(filesToRefresh);

  finally
    filesToRefresh.Free;
    filesToAdd.Free;
    fFolderMonitor_List.clear;
  end;

end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

function TThumbsBrowser.IsWatchingFolder(thePath: string): boolean;
begin
  result := FFolderMonitor_Active and SharedFolderMonitor.PathWatched(thePath, self);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.SetFolderMonitor_Active(const Value: boolean);
var
  I: integer;
begin
  if FFolderMonitor_Active = Value then
    EXIT;

  FFolderMonitor_Active := Value;

  if csLoading in ComponentState then
    EXIT;

  if FFolderMonitor_Active then
  begin
    for I := 0 to fBrowsedPaths.Count - 1 do
      FolderMonitor_AddFolder(fBrowsedPaths[I], false);
  end;

end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.SetFolderMonitor_Options(const Value: TWatchOptions);
begin
  FFolderMonitor_Options := Value;
  SharedFolderMonitor.ChangeListenerProperties(self, FFolderMonitor_Options, FFolderMonitor_Actions);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.SetFolderMonitor_TimerInterval(const Value: cardinal);
begin
  FFolderMonitor_TimerInterval := max(300, Value);
  if assigned(fFolderMonitor_Timer) then
    fFolderMonitor_Timer.interval := FFolderMonitor_TimerInterval;
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.SetFolderMonitor_Actions(const Value: TWatchActions);
begin
  FFolderMonitor_Actions := Value;
  SharedFolderMonitor.ChangeListenerProperties(self, FFolderMonitor_Options, FFolderMonitor_Actions);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.Init_FolderMonitor;
begin
  FFolderMonitor_GlobalSuspendedTime := 0;
  FFolderMonitor_GlobalStartSuspend := gettickcount;
  FFolderMonitor_GlobalSuspendedActions := [];

  FFolderMonitor_SuspendedList := nil;
  FFolderMonitor_Locked := 0;
  FFolderMonitor_Active := false;
  // (woFileName, woFolderName, woSize, woLastWrite, woAttributes, woLastAccess, woCreation, woSecurity);
  FFolderMonitor_Options := [woFileName, woFolderName, woSize, woLastWrite];
  FFolderMonitor_Actions := [waAdded, waRemoved, waModified, waRenamedOld, waRenamedNew];
  fFolderMonitor_Timer := nil;
  FFolderMonitor_TimerInterval := 1000;
  fFolderMonitor_List := TThumbsBrowser_FolderMonitor_Items.Create;

  SharedFolderMonitor.AddListener(self, Handle_FolderMonitorNotify, FFolderMonitor_Options, FFolderMonitor_Actions);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.Finalize_FolderMonitor;
begin
  SharedFolderMonitor.RemoveListener(self);
  DestroyFolderWatchTimer;
  Freeandnil(fFolderMonitor_List);
  if assigned(FFolderMonitor_SuspendedList) then
    Freeandnil(FFolderMonitor_SuspendedList);
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.FolderMonitor_AddAllBrowsedPaths;
var
  I: integer;
begin
  if FFolderMonitor_Active then
  begin
    for I := 0 to fBrowsedPaths.Count - 1 do
    begin
      SharedFolderMonitor.StartWatching(self, fBrowsedPaths[I], false);
    end;
  end;
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.CreateFolderWatchTimer;
begin
  if not assigned(fFolderMonitor_Timer) then
  begin
    fFolderMonitor_Timer := TTimer.Create(self);
    fFolderMonitor_Timer.interval := FFolderMonitor_TimerInterval;
    fFolderMonitor_Timer.OnTimer := Handle_FolderMonitorTimer;
  end;
  fFolderMonitor_Timer.enabled := true;
end;
{$ENDIF}
{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.DestroyFolderWatchTimer;
begin
  if assigned(fFolderMonitor_Timer) then
  begin
    fFolderMonitor_Timer.enabled := false;
    Freeandnil(fFolderMonitor_Timer);
  end;
end;
{$ENDIF}

function TThumbsBrowser.GetSelected(Idx: integer): TThumbEx;
begin
  result := GetThumbfromList(fSelectedThumbs, Idx);
end;

function TThumbsBrowser.GetChecked(Idx: integer): TThumbEx;
begin
  result := GetThumbfromList(fCheckedThumbs, Idx);
end;

function TThumbsBrowser.GetRotated(Idx: integer): TThumbEx;
begin
  result := GetThumbfromList(frotatedThumbs, Idx);
end;

function TThumbsBrowser.AcceptFileCondition(FileName: string; bAcceptNotExist: boolean): boolean;
var
  sr: TSearchRec;
begin
  if FindFirst(FileName, faAnyfile, sr) = 0 then
  begin
    FindClose(sr);
    result := AcceptFileCondition(sr, extractfilename(FileName), extractfileext(FileName));
  end
  else if bAcceptNotExist then
    result := fFileThumbs and AcceptFileFilterCondition(extractfilename(FileName), extractfileext(FileName))
  else
    result := false;
end;

function TThumbsBrowser.AcceptFileCondition(sr: TSearchRec; fname, fext: string): boolean;
begin
  if not fFileThumbs then
  begin
    result := false;
    EXIT;
  end;

  result := true;
  if not fFileOptions.HiddenFiles then
    result := result and ((sr.Attr and faHidden) = 0);
  if not fFileOptions.SystemFiles then
    result := result and ((sr.Attr and faSysFile) = 0);

  result := result and AcceptFileFilterCondition(fname, fext);
end;

function TThumbsBrowser.AcceptFileFilterCondition(fname, fext: string): boolean;
begin
  if fFilterExclude <> '' then
  begin
    if tbs_IsFileExt_InFilter(fext, fFilterExclude, fFilter_AllowMultiExt) then
    begin
      result := false;
      EXIT; // exclude because of exclusion filter
    end;
  end;
  result := (fFilter = '[*.*]') and (fname <> '.') and (fname <> '') and (fname <> '..');
  result := result or (IsFileExtSupported_Read(fext) and tbs_IsFileExt_InFilter(fext, fFilter, fFilter_AllowMultiExt));

end;

function TThumbsBrowser.AcceptFolderCondition(sr: TSearchRec; const bNavigate: boolean): boolean;
begin
  if (sr.Attr and faDirectory) = 0 then // if not a folder
  begin
    result := false;
  end
  else if fReBrowsingExistingPaths and (fBrowsedPaths.Count > 1) and (sr.Name = '..') then
  begin
    result := false;
  end
  else
  begin
    if fFolderThumbs then
    begin
      if sr.Name = '.' then
        result := false
      else
      if (sr.Name = '..') then
        result := bNavigate and fFolderNavigation and fFolderUpNavThumb
      else
        result := true;

      if result then
      begin
        if not fFileOptions.HiddenFolders then
          result := result and ((sr.Attr and faHidden) = 0);
        if not fFileOptions.SystemFolders then
          result := result and ((sr.Attr and faSysFile) = 0);
      end;
    end
    else
      result := false;
  end;
end;

function TThumbsBrowser.AcceptFolderCondition(foldername: string; bAcceptNotExist: boolean): boolean;
var
  sr: TSearchRec;
begin
  if FindFirst(foldername, faDirectory, sr) = 0 then
  begin
    FindClose(sr);
    result := AcceptFolderCondition(sr, false);
  end
  else if bAcceptNotExist then
    result := (fFolderThumbs) and (extractfileext(ExcludeTrailingPathDelimiter(foldername)) = '')
  else
    result := false;
end;

function TThumbsBrowser.GetThumbIDfromVisibleThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  result := fThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetThumbIDfromSelectedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fSelectedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fSelectedThumbs, Idx);
  result := fThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetThumbIDfromCheckedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fCheckedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fCheckedThumbs, Idx);
  result := fThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetThumbIDfromRotatedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > frotatedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(frotatedThumbs, Idx);
  result := fThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetVisibleThumbIdxfromThumbID(ID: integer): integer;
var
  athumb: TThumbEx;
begin
  if (ID < 0) or (ID > fThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := Thumbat_AbsoluteIdx(ID);
  result := fVisibleThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetSelectedThumbIdxfromThumbID(ID: integer): integer;
var
  athumb: TThumbEx;
begin
  if (ID < 0) or (ID > fThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := Thumbat_AbsoluteIdx(ID);
  result := fSelectedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetCheckedThumbIdxfromThumbID(ID: integer): integer;
var
  athumb: TThumbEx;
begin
  if (ID < 0) or (ID > fThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := Thumbat_AbsoluteIdx(ID);
  result := fCheckedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetRotatedThumbIdxfromThumbID(ID: integer): integer;
var
  athumb: TThumbEx;
begin
  if (ID < 0) or (ID > fThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := Thumbat_AbsoluteIdx(ID);
  result := frotatedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetVisibleThumbIdxfromSelectedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fSelectedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fSelectedThumbs, Idx);
  result := fVisibleThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetVisibleThumbIdxfromCheckedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fCheckedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fCheckedThumbs, Idx);
  result := fVisibleThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetVisibleThumbIdxfromRotatedThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > frotatedThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(frotatedThumbs, Idx);
  result := fVisibleThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetSelectedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  result := fSelectedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetCheckedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  result := fCheckedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetCurrentFolder: string;
begin
  if fBrowsedPaths.Count = 0 then
    result := ''
  else
    result := fBrowsedPaths[fBrowsedPaths.Count - 1];
end;

function TThumbsBrowser.GetRotatedThumbIdxfromVisibleThumbIdx(Idx: integer): integer;
var
  athumb: TThumbEx;
begin
  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
  begin
    result := -1;
    EXIT;
  end;

  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  result := frotatedThumbs.IndexOf(athumb);
end;

function TThumbsBrowser.GetThumbIdxbyFileName(FileName: string): integer;
var
  testfound: boolean;
  I: integer;
begin
  if fVisibleThumbs.Count = 0 then
  begin
    result := -1;
    EXIT;
  end;

  testfound := false;
  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    if comparetext(Thumbat(I).SourceFileName, FileName) = 0 then
    begin
      testfound := true;
      break;
    end;
  end;

  if testfound then
    result := I
  else
    result := -1;
end;

function TThumbsBrowser.GetThumbIdxbySelectedIdx(Idx: integer): integer;
begin
  result := GetVisibleThumbIdxfromSelectedThumbIdx(Idx);
end;

function TThumbsBrowser.GetThumbImage(Idx: integer): TIEBitmap;
begin
  result := Thumb[Idx].IEBitmap;
end;

function TThumbsBrowser.GetThumbIdxbyCheckedIdx(Idx: integer): integer;
begin
  result := GetVisibleThumbIdxfromCheckedThumbIdx(Idx);
end;

function TThumbsBrowser.GetSelectedThumbIdxfromThumbIdx(Idx: integer): integer;
begin
  result := GetSelectedThumbIdxfromVisibleThumbIdx(Idx);
end;

function TThumbsBrowser.GetCheckedThumbIdxfromThumbIdx(Idx: integer): integer;
begin
  result := GetCheckedThumbIdxfromVisibleThumbIdx(Idx);
end;

function TThumbsBrowser.XBrowser2Display(X: integer): integer;
begin
  result := X - fBrowserRectNoBorders.left;
end;

function TThumbsBrowser.XDisplay2Browser(X: integer): integer;
begin
  result := X + fBrowserRectNoBorders.left;
end;

function TThumbsBrowser.YBrowser2Display(Y: integer): integer;
begin
  result := Y - fBrowserRectNoBorders.TOP - GetBrowserTotalTopMargin;
end;

function TThumbsBrowser.YDisplay2Browser(Y: integer): integer;
begin
  result := Y + fBrowserRectNoBorders.TOP + GetBrowserTotalTopMargin;
end;

function TThumbsBrowser.XBrowser2Thumb(X: integer; Idx: integer): integer;
begin
  result := XBrowser2Display(XDisplay2Thumb(X, Idx));
end;

function TThumbsBrowser.XDisplay2Thumb(X, Idx: integer): integer;
begin
  result := XDisplay2ThumbSimul(X, Idx, fScrollParams.Pos);
end;

function TThumbsBrowser.XDisplay2ThumbSimul(X: integer; Idx: integer; const theScrollPos: integer): integer;
begin
  result := -1;
  if fVisibleThumbs.Count = 0 then
    EXIT;
  case fBrowserOrientation of
    tbo_vert:
      result := X - GetThumbColumnbyIdx(Idx) * fpassox - fspacingX - fDynamicMarginX - fDisplayMarginLeft;
    tbo_horz:
      result := X + ScrollerPos_To_VirtualPos(theScrollPos) - GetThumbColumnbyIdx(Idx) * fpassox - fspacingX -
        fDynamicMarginX - fDisplayMarginLeft;
  end;
end;

function TThumbsBrowser.YBrowser2Thumb(Y: integer; Idx: integer): integer;
begin
  result := YBrowser2Display(YDisplay2Thumb(Y, Idx));
end;

function TThumbsBrowser.YDisplay2Thumb(Y, Idx: integer): integer;
begin
  result := YDisplay2ThumbSimul(Y, Idx, fScrollParams.Pos);
end;

function TThumbsBrowser.YDisplay2ThumbSimul(Y: integer; Idx: integer; const theScrollPos: integer): integer;
begin
  result := -1;
  if fVisibleThumbs.Count = 0 then
    EXIT;

  case fBrowserOrientation of
    tbo_vert:
      result := Y + ScrollerPos_To_VirtualPos(theScrollPos) - GetThumbRowbyIdx(Idx) * fpassoy - fspacingY -
        fDisplayMarginTop - fDynamicMarginY;
    tbo_horz:
      result := Y - GetThumbRowbyIdx(Idx) * fpassoy - fspacingY - fDisplayMarginTop - fDynamicMarginY;
  end;
end;

function TThumbsBrowser.XThumb2Browser(X: integer; Idx: integer): integer;
begin
  result := XDisplay2Browser(XThumb2Display(X, Idx));
end;

function TThumbsBrowser.XThumb2Display(X, Idx: integer): integer;
begin
  result := XThumb2DisplaySimul(X, Idx, fScrollParams.Pos);
end;

function TThumbsBrowser.XThumb2DisplaySimul(X: integer; Idx: integer; const theScrollPos: integer): integer;
begin
  case fBrowserOrientation of
    tbo_vert:
      result := fDynamicMarginX + fDisplayMarginLeft + fspacingX + X + GetThumbColumnbyIdx(Idx) * fpassox;
    tbo_horz:
      result := fDynamicMarginX + fDisplayMarginLeft + fspacingX + X - ScrollerPos_To_VirtualPos(theScrollPos) +
        GetThumbColumnbyIdx(Idx) * fpassox;
  else
    result := -1;
  end;
end;

function TThumbsBrowser.YThumb2Browser(Y: integer; Idx: integer): integer;
begin
  result := YDisplay2Browser(YThumb2Display(Y, Idx));
end;

function TThumbsBrowser.YThumb2Display(Y, Idx: integer): integer;
begin
  result := YThumb2DisplaySimul(Y, Idx, fScrollParams.Pos);
end;

function TThumbsBrowser.YThumb2DisplaySimul(Y: integer; Idx: integer; const theScrollPos: integer): integer;
begin
  case fBrowserOrientation of
    tbo_vert:
      result := fDynamicMarginY + fDisplayMarginTop + fspacingY + Y - ScrollerPos_To_VirtualPos(theScrollPos) +
        GetThumbRowbyIdx(Idx) * fpassoy;
    tbo_horz:
      result := fDynamicMarginY + fDisplayMarginTop + fspacingY + Y + GetThumbRowbyIdx(Idx) * fpassoy;
  else
    result := -1;
  end;
end;

function TThumbsBrowser.PtBrowser2Thumb(Pt: TPoint; Idx: integer): TPoint;
begin
  result.X := XBrowser2Thumb(Pt.X, Idx);
  result.Y := YBrowser2Thumb(Pt.Y, Idx);
end;

function TThumbsBrowser.PtThumb2Browser(Pt: TPoint; Idx: integer): TPoint;
begin
  result.X := XThumb2Browser(Pt.X, Idx);
  result.Y := YThumb2Browser(Pt.Y, Idx);
end;

procedure TThumbsBrowser.ReassignThumbsLayout(bAffectStyle: boolean; bRefreshCaptions: boolean);
var
  I: integer;
  athumb: TThumbEx;
begin

  if bAffectStyle and (fStyleLocked = 0) then // if affect style and style not locked
  begin
    LockStyle; // lock style
    try
      fStyleOptions.BrowserStyle := tbStyle_Custom; // set custom style without triggering style update
      fBackupLayoutThumb.AssignLayout(fSampleThumb, true); // make backup of thumb
    finally
      UnLockStyle; // unlock style
    end;
  end;

  if fLayoutLocked > 0 then
    EXIT; // if layout locked exit

  LockUpdate;
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      if bRefreshCaptions then
      begin
        athumb.CaptionSettings := fSampleThumb.CaptionSettings;
        athumb.RefreshCaptions;
      end;
      athumb.AssignLayout(fSampleThumb, true);
      if assigned(fOnThumbLayoutAssigned) then
        fOnThumbLayoutAssigned(athumb, GetVisibleThumbIdxfromThumbID(I));
    end;
  finally
    UnlockUpdate(true);
  end;

end;

function TThumbsBrowser.RectThumb2Browser(Idx: integer): Trect;
var
  athumb: TThumbEx;
  arect: Trect;
begin
  athumb := Thumbat(Idx);
  arect := athumb.TotalRect;
  with result do
  begin
    left := XThumb2Browser(arect.left, Idx);
    TOP := YThumb2Browser(arect.TOP, Idx);
    Right := XThumb2Browser(arect.Right, Idx);
    bottom := YThumb2Browser(arect.bottom, Idx);
  end;
end;

function TThumbsBrowser.RectThumb2Display(Idx: integer): Trect;
var
  athumb: TThumbEx;
  arect: Trect;
begin
  athumb := Thumbat(Idx);
  arect := athumb.TotalRect;
  with result do
  begin
    left := XThumb2Display(arect.left, Idx);
    TOP := YThumb2Display(arect.TOP, Idx);
    Right := XThumb2Display(arect.Right, Idx);
    bottom := YThumb2Display(arect.bottom, Idx);
  end;
end;

function TThumbsBrowser.RectDisplay2Browser(arect: Trect): Trect;
begin

  with result do
  begin
    left := XDisplay2Browser(arect.left);
    TOP := YDisplay2Browser(arect.TOP);
    Right := XDisplay2Browser(arect.Right);
    bottom := YDisplay2Browser(arect.bottom);
  end;
end;

function TThumbsBrowser.RectBrowser2Display(arect: Trect): Trect;
begin
  with result do
  begin
    left := XBrowser2Display(arect.left);
    TOP := YBrowser2Display(arect.TOP);
    Right := XBrowser2Display(arect.Right);
    bottom := YBrowser2Display(arect.bottom);
  end;
end;

function TThumbsBrowser.GetAbsoluteIdx(theThumb: TThumbEx): integer;
begin
  result := fThumbs.IndexOf(theThumb);
end;

function TThumbsBrowser.GetBrowsedFolders(Idx: integer): string;
begin
  result := fBrowsedPaths[Idx];
end;

function TThumbsBrowser.GetBrowsedFoldersCount: integer;
begin
  result := fBrowsedPaths.Count;
end;

function TThumbsBrowser.GetBuffer_ThumbSize: integer;
begin
  result := fSampleThumb.SizeOffScreen;
end;

function TThumbsBrowser.GetThumbIdx(theThumb: TThumbEx): integer;
begin
  result := fVisibleThumbs.IndexOf(theThumb);
end;

function TThumbsBrowser.GetThumbIdxbyMousexy(X, Y: integer): integer;
var
  r, c: integer;
begin
  result := -1;
  if fVisibleThumbs.Count = 0 then
    EXIT;

  X := XBrowser2Display(X);
  Y := YBrowser2Display(Y);

  case fBrowserOrientation of
    tbo_vert:
      begin
        r := (Y - fDynamicMarginY - fDisplayMarginTop + ScrollerPos_To_VirtualPos(fScrollParams.Pos)) div fpassoy;
        c := (X - fDynamicMarginX - fDisplayMarginLeft) div fpassox;
        // r := min(fNRows - 1, r);
        c := min(fNColumns - 1, c);
        result := r * fNColumns + c;
      end;
    tbo_horz:
      begin
        r := (Y - fDynamicMarginY - fDisplayMarginTop) div fpassoy;
        c := (X - fDynamicMarginX - fDisplayMarginLeft + ScrollerPos_To_VirtualPos(fScrollParams.Pos)) div fpassox;
        r := min(fNRows - 1, r);
        // c := min(fNColumns - 1, c);
        result := c * fNRows + r;
      end;
  end;

  if (result < 0) or (result > fVisibleThumbs.Count - 1) then
    result := -1;
end;

function TThumbsBrowser.GetThumbRotated(Idx: integer): TTB_Thumb_RotationMode;
begin
  result := Thumb[Idx].RotateMode;
end;

function TThumbsBrowser.GetThumbRowbyIdx(Idx: integer): integer;
var
  c: integer;
begin
  case fBrowserOrientation of
    tbo_vert:
      result := Idx div max(fNColumns, 1);
    tbo_horz:
      begin
        c := GetThumbColumnbyIdx(Idx) + 1;

        if c = 1 then
          result := Idx
        else
          result := fNRows - (c * fNRows mod (Idx + 1)) - 1;
      end
  else
    result := -1;
  end;
end;

function TThumbsBrowser.GetThumbColumnbyIdx(Idx: integer): integer;
var
  r: integer;
begin
  case fBrowserOrientation of
    tbo_vert:
      begin
        r := GetThumbRowbyIdx(Idx) + 1;

        if r = 1 then
          result := Idx
        else
          result := fNColumns - (r * fNColumns mod (Idx + 1)) - 1;
      end;
    tbo_horz:
      begin
        result := Idx div max(fNRows, 1);
        // result := idx;
      end;
  else
    result := -1;
  end;
end;

function TThumbsBrowser.GetThumbFileName(Idx: integer): string;
begin
  result := Thumb[Idx].SourceFileName;
end;

function TThumbsBrowser.GetThumbsBackOpacity: cardinal;
begin
  result := fSampleThumb.BackOpacity;
end;

function TThumbsBrowser.GetThumbsBackOpacitySelected: cardinal;
begin
  result := fSampleThumb.BackOpacitySelected;
end;

function TThumbsBrowser.GetThumbsBackPadding_Bottom: integer;
begin
  result := fSampleThumb.BackPadding_Bottom;
end;

function TThumbsBrowser.GetThumbsBackPadding_Left: integer;
begin
  result := fSampleThumb.BackPadding_Left;
end;

function TThumbsBrowser.GetThumbsBackPadding_Right: integer;
begin
  result := fSampleThumb.BackPadding_Right;
end;

function TThumbsBrowser.GetThumbsBackPadding_Top: integer;
begin
  result := fSampleThumb.BackPadding_Top;
end;

function TThumbsBrowser.GetThumbsBottomTitleBackColor: TColor;
begin
  result := fSampleThumb.BottomTitleBackColor;
end;

function TThumbsBrowser.GetThumbsBottomTitleBackSelectedColor: TColor;
begin
  result := fSampleThumb.BottomTitleBackSelectedColor;
end;

function TThumbsBrowser.GetThumbsBottomTitleFontColor: TColor;
begin
  result := fSampleThumb.BottomTitleFontColor;
end;

function TThumbsBrowser.GetThumbsBottomTitleFontSelectedColor: TColor;
begin
  result := fSampleThumb.BottomTitleSelectedFontColor;
end;

function TThumbsBrowser.GetThumbsCaptionBackColor: TColor;
begin
  result := fSampleThumb.CaptionBackColor;
end;

function TThumbsBrowser.GetThumbsCaptionBackSelectedColor: TColor;
begin
  result := fSampleThumb.CaptionBackSelectedColor;
end;

function TThumbsBrowser.GetThumbsCaptionFontColor: TColor;
begin
  result := fSampleThumb.CaptionFontColor;
end;

function TThumbsBrowser.GetThumbsCaptionFontSelectedColor: TColor;
begin
  result := fSampleThumb.CaptionFontSelectedColor;
end;

function TThumbsBrowser.GetThumbCaptionIncludeInFrame: boolean;
begin
  result := fSampleThumb.CaptionIncludeInFrame;
end;

function TThumbsBrowser.GetThumbsCaptionOpacity: cardinal;
begin
  result := fSampleThumb.CaptionOpacity;
end;

function TThumbsBrowser.GetThumbsCaptionOpacitySelected: cardinal;
begin
  result := fSampleThumb.CaptionOpacitySelected;
end;

function TThumbsBrowser.GetThumbsCaptionRoundnessPerc: cardinal;
begin
  result := fSampleThumb.CaptionRoundnessPerc;
end;

function TThumbsBrowser.GetThumbSelected(Idx: integer): boolean;
begin
  result := Thumb[Idx].SELECTED;
end;

function TThumbsBrowser.GetThumbsFrameBgColor: TColor;
begin
  result := fSampleThumb.FrameBgColor;
end;

function TThumbsBrowser.GetThumbsFrameBgOpacity: cardinal;
begin
  result := fSampleThumb.FrameBgOpacity;
end;

function TThumbsBrowser.GetThumbsFrameBgOpacitySelected: cardinal;
begin
  result := fSampleThumb.FrameBgOpacitySelected;
end;

function TThumbsBrowser.GetThumbsFrameBgSelectedColor: TColor;
begin
  result := fSampleThumb.FrameBgSelectedColor;
end;

function TThumbsBrowser.GetThumbsFrameBorderColor: TColor;
begin
  result := fSampleThumb.FrameBorderColor;
end;

function TThumbsBrowser.GetThumbsFrameBorderOpacity: cardinal;
begin
  result := fSampleThumb.FrameBorderOpacity;
end;

function TThumbsBrowser.GetThumbsFrameBorderOpacitySelected: cardinal;
begin
  result := fSampleThumb.FrameBorderOpacitySelected;
end;

function TThumbsBrowser.GetThumbsFrameBorderSelectedColor: TColor;
begin
  result := fSampleThumb.FrameBorderSelectedColor;
end;

function TThumbsBrowser.GetThumbsFramePadding_Bottom: integer;
begin
  result := fSampleThumb.FramePadding_Bottom;
end;

function TThumbsBrowser.GetThumbsFramePadding_Left: integer;
begin
  result := fSampleThumb.FramePadding_Left;
end;

function TThumbsBrowser.GetThumbsFramePadding_Right: integer;
begin
  result := fSampleThumb.FramePadding_Right;
end;

function TThumbsBrowser.GetThumbsFramePadding_Top: integer;
begin
  result := fSampleThumb.FramePadding_Top;
end;

function TThumbsBrowser.GetThumbsFrameRoundnessPerc: cardinal;
begin
  result := fSampleThumb.FrameRoundnessPerc;
end;

function TThumbsBrowser.GetThumbsFrameSize: cardinal;
begin
  result := fSampleThumb.FrameSize;
end;

function TThumbsBrowser.GetThumbSize: cardinal;
begin
  result := max(fSampleThumb.SizeOnScreenW, fSampleThumb.SizeOnScreenH);
end;

function TThumbsBrowser.GetThumbsizeH: cardinal;
begin
  result := fSampleThumb.SizeOnScreenH;
end;

function TThumbsBrowser.GetThumbsizeW: cardinal;
begin
  result := fSampleThumb.SizeOnScreenW;
end;

procedure TThumbsBrowser.GetThumbsList(thumbList: TList; sourcetypes: TTB_SourceTypes;
  condition: TTB_Browser_PickCondition; bIncludeInvisible: boolean = false);
var
  I: integer;
  athumb: TThumbEx;
begin
  assert(thumbList <> nil);
  for I := 0 to fThumbs.Count - 1 do
  begin
    athumb := Thumbat_AbsoluteIdx(I);
    if bIncludeInvisible or athumb.Visible then
    begin
      if (sourcetypes = []) or (athumb.SourceType in sourcetypes) then
      begin

        if (condition = IfNo_condition) or ((condition = IfSelected) and (athumb.SELECTED)) or
          ((condition = IfChecked) and (athumb.Checked)) then
        begin
          thumbList.Add(athumb);
        end;
      end;
    end;
  end;
end;

function TThumbsBrowser.GetThumbsMouseOverOptions: TTB_Thumb_MouseOverOptions;
begin
  result := fSampleThumb.MouseOverOptions;
end;

function TThumbsBrowser.GetThumbsSpacing: cardinal;
begin
  result := max(fspacingX, fspacingY);
end;

function TThumbsBrowser.GetThumbsTitleDrawFocusRectIfEmpty: boolean;
begin
  result := fSampleThumb.TitleDrawFocusRectIfEmpty;
end;

function TThumbsBrowser.GetThumbsTitleOpacity: cardinal;
begin
  result := fSampleThumb.TitleOpacity;
end;

function TThumbsBrowser.GetThumbsTitleOpacitySelected: cardinal;
begin
  result := fSampleThumb.TitleOpacitySelected;
end;

function TThumbsBrowser.GetThumbsTitleRoundnessPerc: cardinal;
begin
  result := fSampleThumb.TitleRoundnessPerc;
end;

function TThumbsBrowser.GetThumbsTopTitleBackColor: TColor;
begin
  result := fSampleThumb.TopTitleBackColor;
end;

function TThumbsBrowser.GetThumbsTopTitleBackSelectedColor: TColor;
begin
  result := fSampleThumb.TopTitleBackSelectedColor;
end;

function TThumbsBrowser.GetThumbsTopTitleFontColor: TColor;
begin
  result := fSampleThumb.TopTitleFontColor;
end;

function TThumbsBrowser.GetThumbsTopTitleFontSelectedColor: TColor;
begin
  result := fSampleThumb.TopTitleSelectedFontColor;
end;

function TThumbsBrowser.GetThumbTopTitle(Idx: integer): string;
begin
  result := Thumb[Idx].TopTitle;
end;

function TThumbsBrowser.GetThumbUserObject(Idx: integer): TObject;
begin
  result := Thumb[Idx].UserObject;
end;

function TThumbsBrowser.GetThumbUserTag(Idx: integer): integer;
begin
  result := Thumb[Idx].UserTag;
end;

function TThumbsBrowser.GetThumbCaption_MissingText: string;
begin
  result := fSampleThumb.CaptionMissingText;
end;

function TThumbsBrowser.GetThumbBottomTitle(Idx: integer): string;
begin
  result := Thumb[Idx].BottomTitle;
end;

function TThumbsBrowser.GetThumbCaption(Idx: integer): string;
begin
  result := Thumb[Idx].GetCaption;
end;

function TThumbsBrowser.GetThumbCaptionColumnPercWidth(Idx: integer): single;
begin
  result := fThumbCaption_Info[Idx].ColPercWidth;
end;

function TThumbsBrowser.GetThumbCaptionOrder(Idx: integer): integer;
begin
  result := fThumbCaption_Info[Idx].capIdx;
end;

function TThumbsBrowser.GetThumbCaption_OrderByCaption(cap: TTB_Thumb_CaptionsSetting): integer;
var
  I: integer;
begin
  result := -1;
  for I := low(fThumbCaption_Info) to High(fThumbCaption_Info) do
  begin
    if fThumbCaption_Info[I].capIdx = ord(cap) then
    begin
      result := I;
      break;
    end;
  end;
end;

function TThumbsBrowser.GetThumbCaption_Settings: TTB_Thumb_CaptionsSettings;
begin
  result := fSampleThumb.CaptionSettings;
end;

function TThumbsBrowser.GetThumbChecked(Idx: integer): boolean;
begin
  result := Thumb[Idx].Checked;
end;

function TThumbsBrowser.GetVisibleThumbsCount: integer;
begin
  result := fVisibleThumbs.Count;
end;

function TThumbsBrowser.GetTotalThumbsCount: integer;
begin
  result := fThumbs.Count;
end;

function TThumbsBrowser.GetCheckedCount: integer;
begin
  result := fCheckedThumbs.Count;
end;

function TThumbsBrowser.GetRotatedCount: integer;
begin
  result := frotatedThumbs.Count;
end;

function TThumbsBrowser.GetSelectedCount: integer;
begin
  result := fSelectedThumbs.Count;
end;

function TThumbsBrowser.IsThumbSelected(Idx: integer): boolean;
var
  athumb: TThumbEx;
begin
  athumb := GetThumbfromList(fVisibleThumbs, Idx);

  result := assigned(athumb) and athumb.SELECTED;
end;

function TThumbsBrowser.GetScrollbar: TScrollBar;
begin
  result := TScrollBar(fScroller);
end;

function TThumbsBrowser.GetScroller_Position: integer;
begin
  result := fScrollParams.Pos;
end;

function TThumbsBrowser.GetLastClickedThumb: TBrowserThumb;
begin
  result := TBrowserThumb(fLastClickedThumb);
end;

procedure TThumbsBrowser.GetDisplayedThumbsList(var alist: TList; condition: TTB_Browser_PickCondition);
var
  I: integer;
  canadd: boolean;
begin
  if alist = nil then
    EXIT;
  alist.clear;
  for I := fTopDisplayedThumbIdx to fBottomDisplayedThumbIdx do
  begin
    canadd := true;
    case condition of
      IfSelected:
        canadd := TThumbEx(fVisibleThumbs[I]).SELECTED;
      IfChecked:
        canadd := TThumbEx(fVisibleThumbs[I]).Checked;
      IfNo_condition:
        canadd := true;
    end;
    if canadd then
      alist.Add(fVisibleThumbs[I]);
  end;
end;

function TThumbsBrowser.GetDisplayMethod: TResamplefilter;
begin
  result := fSampleThumb.DisplayFilter;
end;

function TThumbsBrowser.GetDisplayRect: Trect;
begin
  if assigned(fDisplayBackBuffer) then
  begin
    result := rect(0, 0, fDisplayBackBuffer.Width - 1, fDisplayBackBuffer.Height - 1);
  end
  else
    result := rect(0, 0, 0, 0);

  result := RectDisplay2Browser(result);
end;

procedure TThumbsBrowser.InvertSelectionThumbNoUpdate(Idx: integer);
var
  athumb: TThumbEx;
begin
  athumb := GetThumbfromList(fVisibleThumbs, Idx);

  if assigned(athumb) then
  begin
    if athumb.SELECTED then
      DeSelectThumbNoUpdate(Idx)
    else
      SelectThumbNoUpdate(Idx);
  end;
end;

procedure TThumbsBrowser.SelectThumbNoUpdate(Idx: integer);
var
  athumb: TThumbEx;
begin
  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  if assigned(athumb) then
    athumb.SELECTED := true;

end;

procedure TThumbsBrowser.DeSelectThumbNoUpdate(Idx: integer);
var
  s_idx: integer;
begin
  if (Idx < 0) or (Idx > fVisibleThumbs.Count - 1) then
    EXIT;

  s_idx := GetSelectedThumbIdxfromVisibleThumbIdx(Idx);
  if s_idx = -1 then
    EXIT;

  GetThumbfromList(fVisibleThumbs, Idx).SELECTED := false;
end;

procedure TThumbsBrowser.CheckMarkThumbNoUpdate(Idx: integer; checkvalue: boolean);
var
  athumb: TThumbEx;
begin
  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  if assigned(athumb) then
    athumb.Checked := checkvalue;
end;

procedure TThumbsBrowser.CheckMarkThumb(Idx: integer; checkvalue: boolean);
begin
  CheckMarkThumbNoUpdate(Idx, checkvalue);
  RefreshThumb(Idx, true);
end;

procedure TThumbsBrowser.MarkRotatedThumbNoUpdate(Idx: integer; rm: TTB_Thumb_RotationMode);
var
  athumb: TThumbEx;
begin
  athumb := GetThumbfromList(fVisibleThumbs, Idx);
  if assigned(athumb) then
    athumb.RotateMode := rm;
end;

procedure TThumbsBrowser.MarkRotatedThumb(Idx: integer; rm: TTB_Thumb_RotationMode);
begin
  MarkRotatedThumbNoUpdate(Idx, rm);
  RefreshThumb(Idx, true);
end;

procedure TThumbsBrowser.DeselectAllThumbsNoUpdate;
var
  Idx: integer;
  athumb: TThumbEx;
begin
  Idx := fSelectedThumbs.Count - 1;
  while (Idx >= 0) do
  begin
    athumb := GetThumbfromList(fSelectedThumbs, Idx);
    if assigned(athumb) then
      athumb.SELECTED := false;
    dec(Idx);
  end;
end;

procedure TThumbsBrowser.SelectAllThumbsNoUpdate;
var
  I: integer;
begin
  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    SelectThumbNoUpdate(I);
  end;
end;

procedure TThumbsBrowser.DeselectAllThumbs;
begin
  DeselectAllThumbsNoUpdate;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SelectAllThumbs;
begin
  SelectAllThumbsNoUpdate;
  RefreshDisplay;
end;

procedure TThumbsBrowser.CheckMarkAllThumbsNoUpdate(checkvalue: boolean);
var
  I: integer;
begin
  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    CheckMarkThumbNoUpdate(I, checkvalue);
  end;
end;

procedure TThumbsBrowser.CheckMarkAllThumbs(checkvalue: boolean);
begin
  CheckMarkAllThumbsNoUpdate(checkvalue);
  RefreshDisplay;
end;

procedure TThumbsBrowser.InvertCheckedThumbsRange(fromthumb, tothumb: integer);
var
  I, temp: integer;
  athumb: TThumbEx;
begin
  if fromthumb > tothumb then
  begin
    temp := tothumb;
    tothumb := fromthumb;
    fromthumb := temp;
  end;
  for I := fromthumb to tothumb do
  begin
    athumb := Thumbat(I);
    CheckMarkThumbNoUpdate(I, not athumb.Checked);
  end;
  RefreshDisplay;
end;

procedure TThumbsBrowser.MarkRotatedAllThumbsNoUpdate(rm: TTB_Thumb_RotationMode);
var
  I: integer;
begin

  for I := 0 to fVisibleThumbs.Count - 1 do
  begin
    MarkRotatedThumbNoUpdate(I, rm);
  end;

end;

procedure TThumbsBrowser.MarkRotatedAllThumbs(rm: TTB_Thumb_RotationMode);
begin
  MarkRotatedAllThumbsNoUpdate(rm);
  RefreshDisplay;
end;

procedure TThumbsBrowser.ReShowHiddenThumbs;
var
  I: integer;
  athumb: TThumbEx;
begin
  LockUpdate;
  OpenVisibilityTransaction([vtr_UserShow]);
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := TThumbEx(fThumbs[I]);
      if (not athumb.Visible) and (IsThumbHidden(vtyp_User, athumb)) then
        athumb.Visible := true;
    end;

  finally
    CloseVisibilityTransaction([vtr_UserShow]);
    UnlockUpdate(true);
  end;
end;

procedure TThumbsBrowser.LockUpdate;
begin
  inc(fUpdateLocked);
end;

procedure TThumbsBrowser.UnlockUpdate;
begin
  UnlockUpdate(true);
end;

procedure TThumbsBrowser.UnlockUpdate(const bDoUpdate: boolean);
begin
  if fUpdateLocked = 0 then
    EXIT;

  dec(fUpdateLocked);

  if bDoUpdate and (fUpdateLocked = 0) then
    RefreshDisplay;
end;

procedure TThumbsBrowser.UnlockUpdateEx;
begin
  UnlockUpdate(false);
end;

procedure TThumbsBrowser.LockVCLStyle;
begin
  inc(fVCLStyleLocked);
end;

procedure TThumbsBrowser.UnLockVCLStyle;
begin
  if fVCLStyleLocked = 0 then
    EXIT;

  dec(fVCLStyleLocked);

end;

procedure TThumbsBrowser.LockPaint;
begin
  inc(fPaintLocked);
end;

procedure TThumbsBrowser.UnlockPaint(const bUpdate: boolean);
begin
  if fPaintLocked = 0 then
    EXIT;

  dec(fPaintLocked);

  if bUpdate and (fPaintLocked = 0) then
    RefreshDisplay;
end;

{$IFDEF TB_FOLDERMONITOR}

procedure TThumbsBrowser.LockFolderMonitor;
begin
  inc(FFolderMonitor_Locked);
end;

procedure TThumbsBrowser.UnlockFolderMonitor;
begin
  dec(FFolderMonitor_Locked);
end;

procedure TThumbsBrowser.SuspendFolderMonitor(ms: integer; targetFileName: string = '';
  const Actions: TWatchActions = []);
var
  suspList: TList;
  suspItem: TThumbsBrowser_FolderMonitor_SuspendedItem;
  bCanAdd: boolean;
  I: integer;
begin
  targetFileName := ExcludeTrailingPathDelimiter(targetFileName);

  if targetFileName = '' then // no target specified, then suspend the all monitor
  begin
    FFolderMonitor_GlobalSuspendedTime := ms;
    FFolderMonitor_GlobalStartSuspend := gettickcount;
    FFolderMonitor_GlobalSuspendedActions := Actions;
  end
  else
  begin
    if FFolderMonitor_SuspendedList = nil then
      FFolderMonitor_SuspendedList := TThreadObjectList.Create;

    suspList := FFolderMonitor_SuspendedList.LockList; // enter critical section
    try
      bCanAdd := true;
      for I := 0 to suspList.Count - 1 do
      begin
        suspItem := TThumbsBrowser_FolderMonitor_SuspendedItem(suspList[I]);
        if comparetext(ExcludeTrailingPathDelimiter(suspItem.FileName), targetFileName) = 0 then
        begin
          suspItem.SuspensionStart := gettickcount;
          suspItem.SuspendInterval := ms;
          suspItem.SuspendedActions := suspItem.SuspendedActions + Actions;
          bCanAdd := false;
          break;
        end;
      end;

      if bCanAdd then
        suspList.Add(TThumbsBrowser_FolderMonitor_SuspendedItem.Create(targetFileName, ms, Actions));
    finally
      FFolderMonitor_SuspendedList.unlocklist;
    end;
  end;
end;

procedure TThumbsBrowser.UnSuspendFolderMonitor(targetFileName: string = '');
var
  I: integer;
  suspList: TList;
begin
  if targetFileName = '' then // no target specified, then remove suspend to all monitor
  begin
    FFolderMonitor_GlobalSuspendedTime := 0;
    FFolderMonitor_GlobalSuspendedActions := [];
  end
  else
  begin
    if FFolderMonitor_SuspendedList <> nil then
    begin
      suspList := FFolderMonitor_SuspendedList.LockList; // enter critical section
      try
        for I := suspList.Count - 1 downto 0 do
          if TThumbsBrowser_FolderMonitor_SuspendedItem(suspList[I]).FileName = targetFileName then
          begin
            suspList.Delete(I);
            break;
          end;
      finally
        FFolderMonitor_SuspendedList.unlocklist;
      end;
    end;
  end;
end;
{$ENDIF}

procedure TThumbsBrowser.OpenThumbsTransaction;
begin
  LockUpdate;
end;

procedure TThumbsBrowser.CloseThumbsTransaction;
begin
  UnlockUpdateEx;
end;

procedure TThumbsBrowser.OpenVisibilityTransaction(transactionTypes: TThumbsBrowser_ThumbVisibilityTransactions);
begin
  if vtr_NavMemoryShow in transactionTypes then
    inc(fVisTransOpened_NavMemoryShow);
  if vtr_NavMemoryHide in transactionTypes then
    inc(fVisTransOpened_NavMemoryHide);
  if vtr_FilterShow in transactionTypes then
    inc(fVisTransOpened_FilterShow);
  if vtr_FilterHide in transactionTypes then
    inc(fVisTransOpened_FilterHide);
  if vtr_UserShow in transactionTypes then
    inc(fVisTransOpened_UserShow);
  if vtr_UserHide in transactionTypes then
    inc(fVisTransOpened_UserHide);
end;

procedure TThumbsBrowser.CloseVisibilityTransaction(transactionTypes: TThumbsBrowser_ThumbVisibilityTransactions);
begin
  if vtr_NavMemoryShow in transactionTypes then
    dec(fVisTransOpened_NavMemoryShow);
  if vtr_NavMemoryHide in transactionTypes then
    dec(fVisTransOpened_NavMemoryHide);
  if vtr_FilterShow in transactionTypes then
    dec(fVisTransOpened_FilterShow);
  if vtr_FilterHide in transactionTypes then
    dec(fVisTransOpened_FilterHide);
  if vtr_UserShow in transactionTypes then
    dec(fVisTransOpened_UserShow);
  if vtr_UserHide in transactionTypes then
    dec(fVisTransOpened_UserHide);
end;

function TThumbsBrowser.IsThumbHidden(visibilityType: TThumbsBrowser_ThumbVisibilityType; athumb: TThumbEx;
  var Idx: integer): boolean;
var
  L: TList;
begin

  case visibilityType of
    vtyp_NavMemory:
      L := fHiddenThumbs_NavMem;
    vtyp_Filter:
      L := fHiddenThumbs_Filter;
    vtyp_User:
      L := fHiddenThumbs_User;
  else
    L := nil;
  end;

  if L = nil then
  begin
    Idx := -1;
    result := false;
  end
  else
  begin
    Idx := L.IndexOf(athumb);
    result := Idx <> -1;
  end;
end;

function TThumbsBrowser.IsThumbHidden(visibilityType: TThumbsBrowser_ThumbVisibilityType; athumb: TThumbEx): boolean;
var
  Idx: integer;
begin
  result := IsThumbHidden(visibilityType, athumb, Idx);
end;

function TThumbsBrowser.AnyVisibilityTransactionOpened_Show: boolean;
begin
  result := (fVisTransOpened_NavMemoryShow > 0) or (fVisTransOpened_FilterShow > 0) or (fVisTransOpened_UserShow > 0);
end;

function TThumbsBrowser.AnyVisibilityTransactionOpened_Hide: boolean;
begin
  result := (fVisTransOpened_NavMemoryHide > 0) or (fVisTransOpened_FilterHide > 0) or (fVisTransOpened_UserHide > 0);
end;

procedure TThumbsBrowser.DeselectThumbsRangeNoUpdate(fromthumb, tothumb: integer);
var
  I, temp: integer;
begin
  if fromthumb > tothumb then
  begin
    temp := tothumb;
    tothumb := fromthumb;
    fromthumb := temp;
  end;
  for I := fromthumb to tothumb do
  begin
    DeSelectThumbNoUpdate(I);
  end;
end;

procedure TThumbsBrowser.SelectThumbsRangeNoUpdate(fromthumb, tothumb: integer);
var
  I, temp: integer;
begin
  if fromthumb > tothumb then
  begin
    temp := tothumb;
    tothumb := fromthumb;
    fromthumb := temp;
  end;
  for I := fromthumb to tothumb do
  begin
    SelectThumbNoUpdate(I);
  end;
end;

procedure TThumbsBrowser.InvertSelectionThumbsRange(fromthumb, tothumb: integer);
var
  I, temp: integer;
begin
  if fromthumb > tothumb then
  begin
    temp := tothumb;
    tothumb := fromthumb;
    fromthumb := temp;
  end;
  for I := fromthumb to tothumb do
  begin
    InvertSelectionThumbNoUpdate(I);
  end;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SelectThumb(Idx: integer);
begin
  SelectThumbNoUpdate(Idx);
  RefreshDisplay;
end;

procedure TThumbsBrowser.DeSelectThumb(Idx: integer);
begin
  DeSelectThumbNoUpdate(Idx);
  RefreshDisplay;
end;

procedure TThumbsBrowser.SelectThumbbyFileName(FileName: string);
begin
  GotoFileName(FileName, true);
end;

procedure TThumbsBrowser.SetStyleOptions(const Value: TTB_Browser_StyleOptions);
begin
  fStyleOptions := Value;
  Handle_BrowserStyleOptionsChange(self);
end;

procedure TThumbsBrowser.SetBuffer_ThumbSize(Value: integer);
begin
  if fSampleThumb.SizeOffScreen = Value then
    EXIT;

  if (Value <> -1) and (Value < 1) then
  begin
    if csDesigning in ComponentState then
    begin
      showmessage('Only Values > 0 (Resize Buffer) or the value of -1 (Keep Original Size) are allowed');
      EXIT;
    end;
  end;

  if Value = -1 then
    fSampleThumb.StoreType := tbstore_FullImage;

  fSampleThumb.SizeOffScreen := Value;

  ReassignThumbsLayout(false, false);

  if csLoading in ComponentState then
    EXIT;

  ReLoadThumbs(fVisibleThumbs);
end;

procedure TThumbsBrowser.SetCentered(const Value: boolean);
begin
  if fCentered = Value then
    EXIT;

  fCentered := Value;

  // if csDesigning in ComponentState then EXIT;
  RefreshDisplay;

end;

procedure TThumbsBrowser.SetCursor(const Value: TCursor);
begin
  fCursor := Value;
  inherited Cursor := Value;
end;

procedure TThumbsBrowser.SetOnThumbBufferLoaded(const Value: TThumbsBrowserOnThumbBufferLoaded);
begin
  fOnThumbBufferLoaded := Value;
end;

procedure TThumbsBrowser.SetOwnUserObjects(const Value: boolean);
begin
  if fSampleThumb.OwnUserObject = Value then
    EXIT;

  fSampleThumb.OwnUserObject := Value;

end;

procedure TThumbsBrowser.SetResampleMethod(Value: TResamplefilter);
begin
  if fSampleThumb.ResampleFilter = Value then
    EXIT;

  fSampleThumb.ResampleFilter := Value;
  ReassignThumbsLayout(false, false);

  if csLoading in ComponentState then
    EXIT;

  Loader_Reload;
end;

procedure TThumbsBrowser.SeTThumbsize(Value: cardinal);
begin
  if (fSampleThumb.SizeOnScreenW = Value) and (fSampleThumb.SizeOnScreenH = Value) then
    EXIT;

  fSampleThumb.SizeOnScreenW := Value;
  fSampleThumb.SizeOnScreenH := Value;
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SeTThumbsizeW(const Value: cardinal);
begin
  if fSampleThumb.SizeOnScreenW = Value then
    EXIT;

  fSampleThumb.SizeOnScreenW := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SeTThumbsizeH(const Value: cardinal);
begin
  if fSampleThumb.SizeOnScreenH = Value then
    EXIT;

  fSampleThumb.SizeOnScreenH := Value;
  ReassignThumbsLayout(false, false);
end;

function TThumbsBrowser.ComplytoSearchCriterion(theThumb: TThumbEx): boolean;
var
  cr: boolean;
begin
  result := false;
  if not assigned(theThumb) then
    EXIT;

  cr := false;
  if assigned(fOnSearchCompare) then
    fOnSearchCompare(theThumb, fVisibleThumbs.IndexOf(theThumb), cr);
  result := cr;
end;

procedure TThumbsBrowser.SearchThumbs(const bGotoSelected: boolean);
var
  I: integer;
  athumb: TThumbEx;
  // olds_id, news_idx: integer;
begin
  if not assigned(fOnSearchCompare) then
    EXIT;

  ViewPoint_Save;

  LockUpdate;
  OpenVisibilityTransaction([vtr_FilterShow, vtr_FilterHide]);
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      if ComplytoSearchCriterion(athumb) then
      begin

        if (not athumb.Visible) then // and (not IsThumbHidden(vtyp_NavMemory, aThumb)) then
        begin
          if IsThumbHidden(vtyp_Filter, athumb) then // reshow only thumbs that were hidden by the filter
            athumb.Visible := true;
        end;
      end
      else if athumb.Visible then
      begin
        athumb.Visible := false;
        if athumb.SELECTED then
          athumb.SELECTED := false;
      end;
    end;
  finally
    CloseVisibilityTransaction([vtr_FilterShow, vtr_FilterHide]);
    UnlockUpdateEx;

    // fsort_updated := false;
    if StyleOptions.BrowserStyle = tbStyle_Columns then
      SortThumbs(false, stAsFromReportHeader)
    else
      SortThumbs(false, self.SortType);

    if bGotoSelected then
    begin
      ViewPoint_Restore;
    end;
  end;
end;

procedure TThumbsBrowser.Search;
begin
  FilterThumbs(true);
end;

procedure TThumbsBrowser.FilterThumbs(const bGotoSelected: boolean = true);
begin
  SearchThumbs(bGotoSelected);

  RefreshDisplay;
end;

procedure TThumbsBrowser.CreateVisibleThumbs(theLoadingType: TThumbsbrowser_LoadingType = tblt_None;
  theNamedList: TNamedList = nil);
var
  I: integer;
  athumb: TThumbEx;
  olds_id: integer;
  bShow, bHide, bToDelete: boolean;
  sTypesLoadable: TTB_SourceTypes;
begin
  if (theLoadingType <> tblt_None) and // when loading type is not none
    (assigned(theNamedList)) and //
    (theNamedList.Count > 0) then // and there are files added to the named list
    fsort_updated := false; // visible list must be resorted

  olds_id := GetThumbIDfromVisibleThumbIdx(fSelectedIndex);

  sTypesLoadable := TBGetSourceTypes_Loadable;

  LockUpdate;
  try

    if assigned(theNamedList) then
    begin
      for I := 0 to theNamedList.Count - 1 do
      begin
        athumb := TThumbEx(theNamedList[I]);

        if not athumb.Visible then
          athumb.Visible := true;
      end;
    end;

    for I := fThumbs.Count - 1 downto 0 do // because of delete
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      // -----------------------------------------------------------------------
      if (athumb.ExploringStatus = thbExploreInProcess) then // if explore in process
        athumb.ExploringStatus := thbNotExplored; // the thumb needs to be reexplored / reloaded
      // -----------------------------------------------------------------------

      bShow := false;
      bHide := false;
      bToDelete := false;
      if theLoadingType = tblt_None then
      begin
        if athumb.Visible then
        begin
          if (athumb.SourceType = st_File) or (athumb.SourceType = st_WPDFile) or (athumb.SourceType = st_URL) then
            bHide := (not fFileThumbs) or (not AcceptFileFilterCondition(athumb.SourceFileNameShort,
              athumb.SourceFileExtension))
          else if (athumb.SourceType = st_Folder) or (athumb.SourceType = st_WPDFolder) then
            bHide := not fFolderThumbs
          else if (athumb.SourceType = st_folderNav) or (athumb.SourceType = st_WPDFolderNav) then
            bHide := not(fFolderThumbs and fFolderNavigation and fFolderUpNavThumb);
        end
        else
        begin
          if (not IsThumbHidden(vtyp_User, athumb)) then
          begin
            if (athumb.SourceType = st_File) or (athumb.SourceType = st_URL) then
              bShow := fFileThumbs and ((athumb.Originator = tborig_Manual) or InPaths(athumb, false)) and
                AcceptFileFilterCondition(athumb.SourceFileNameShort, athumb.SourceFileExtension)
            else if (athumb.SourceType = st_Folder) then
              bShow := fFolderThumbs and ((athumb.Originator = tborig_Manual) or InPaths(athumb, false))
            else if (athumb.SourceType = st_folderNav) or (athumb.SourceType = st_WPDFolderNav) then
              bShow := fFolderThumbs and fFolderNavigation and fFolderUpNavThumb;
          end;
        end;
      end
      else if (theLoadingType = tblt_FileSystem) then
      begin
        bToDelete := ((athumb.SourceType = st_File) and (not fileexists(athumb.SourceFileName))) or
          ((athumb.SourceType = st_Folder) and (not directoryexists(athumb.SourceFileName)));

      end
      else if (theLoadingType = tblt_Reload) then
      begin
        // -----------------------------------------------------------------------
        if (athumb.Visible) and (athumb.SourceType in sTypesLoadable) then
        // if (athumb.SourceType in sTypesLoadable) then
          athumb.ExploringStatus := thbNotExplored; // the thumb needs to be reexplored / reloaded
        // -----------------------------------------------------------------------
        bToDelete := ((athumb.SourceType = st_File) and (not fileexists(athumb.SourceFileName))) or
          ((athumb.SourceType = st_Folder) and (not directoryexists(athumb.SourceFileName)));

      end
      else if (theLoadingType = tblt_WPD) then
      begin
{$IFDEF TB_PORTABLEDEVICE}
        bToDelete := ((athumb.SourceType = st_WPDFile) and (WPD.ObjectIDToIndex(athumb.AttachedWPDInfo.Rcd.ID) = -1)) or
          ((athumb.SourceType = st_WPDFolder) and (WPD.ObjectIDToIndex(athumb.AttachedWPDInfo.Rcd.ID) = -1));
{$ENDIF}
      end;

      // se il file non esiste più l'icona deve essere eliminata e anche il record del database
      if bToDelete then
      begin
        if Deletethumb(I) then // if deleted remove the record from db
        begin
{$IFDEF TB_USEDB}
          if DB.DBActive then
          begin
            DB.DeleteRcd(GUID_NULL, athumb.Unique_Name);
          end;
{$ENDIF}
        end;
      end
      else
      begin
        if bShow then
          athumb.Visible := true
        else if bHide then
        begin
          athumb.Visible := false;
          if (athumb.SELECTED) then
            athumb.SELECTED := false;
        end;
      end;
    end;

  finally
    UnlockUpdateEx;
    fSelectedIndex := GetVisibleThumbIdxfromThumbID(olds_id);
  end;

  ffilter_updated := true;
end;

procedure TThumbsBrowser.ResortThumbs;
begin
  if StyleOptions.BrowserStyle = tbStyle_Columns then
     SortThumbs(false, stAsFromReportHeader)
  else
    SortThumbs(false, fSortType);
  RefreshDisplay;
end;

procedure TThumbsBrowser.MethodSort(theList: TList; L, r: integer; compMethod: TCompMethod);
var
  I, j: integer;
  p, T: Pointer;
begin
  repeat
    I := L;
    j := r;
    p := theList[(L + r) shr 1];
    repeat
      while compMethod(theList[I], p) < 0 do
        inc(I);
      while compMethod(theList[j], p) > 0 do
        dec(j);
      if I <= j then
      begin
        if I <> j then
        begin
          T := theList[I];
          theList[I] := theList[j];
          theList[j] := T;
        end;
        inc(I);
        dec(j);
      end;
    until I > j;
    if L < j then
      MethodSort(theList, L, j, compMethod);
    L := I;
  until I >= r;
end;

procedure TThumbsBrowser.DoSort(theList: TList; Thesorttype: TTB_Browser_SortType);
begin
  if theList.Count = 0 then
    EXIT;

  if (Thesorttype = stNotSorted) then
    EXIT;

  if (Thesorttype = stCustomA) or (Thesorttype = stCustomD) then // Custom Compare
  begin
    assert(assigned(FcompareCustomMethodAsc), 'No Custom Comparer for Sorting');
    assert(assigned(FcompareCustomMethodDesc), 'No Custom Comparer for Sorting');
    if (FCompType = compAscending) then
      MethodSort(theList, 0, theList.Count - 1, FcompareCustomMethodAsc)
    else
      MethodSort(theList, 0, theList.Count - 1, FcompareCustomMethodDesc);
  end
  else if (Thesorttype = stAsFromReportHeader) then
  begin
    assert(assigned(FcompareHeaderMethodAsc), 'No Custom Comparer for Sorting');
    assert(assigned(FcompareHeaderMethodDesc), 'No Custom Comparer for Sorting');
    if (FCompType = compAscending) then
      MethodSort(theList, 0, theList.Count - 1, FcompareHeaderMethodAsc)
    else
      MethodSort(theList, 0, theList.Count - 1, FcompareHeaderMethodDesc);
  end
  else
  begin
    assert(assigned(FcompareAsc), 'No Custom Comparer for Sorting');
    assert(assigned(FcompareDesc), 'No Custom Comparer for Sorting');

    if (FCompType = compAscending) then
      theList.Sort(FcompareAsc)
    else
      theList.Sort(FcompareDesc);
  end;
end;

procedure TThumbsBrowser.SortThumbs(const bCheckalreadySorted: boolean; Thesorttype: TTB_Browser_SortType);
var
  finalList: TTBVisibleThumbsList;
  theFileList, theFolderList: TList;
  I: integer;
  athumb: TThumbEx;
  navThumb, navThumbWPD: TThumbEx;
begin
  if bCheckalreadySorted and fsort_updated then
    EXIT; // nothing to do

  if Thesorttype = stNotSorted then
  begin
    fsort_updated := true;
    EXIT;
  end;

  GetSortInstruction(Thesorttype);

  theFileList := fVisibleThumbs;
  if theFileList.Count = 0 then
    EXIT; // >>>> EXIT

  ViewPoint_Save;

  if fFolderThumbs then
  begin
    navThumb := nil;
    navThumbWPD := nil;
    theFolderList := TList.Create;
    // first we need to create a list containing only folders
    // and we remove the folder items from thefilelist
    try
      I := 0;
      repeat
      begin
        athumb := TThumbEx(theFileList[I]);
        if (athumb.SourceType = st_Folder) or (athumb.SourceType = st_folderNav) or (athumb.SourceType = st_WPDFolder)
          or (athumb.SourceType = st_WPDFolderNav) then
        begin
          theFileList.Delete(I); // remove from file list
          if (athumb.SourceType = st_folderNav) then
            navThumb := athumb
          else if (athumb.SourceType = st_WPDFolderNav) then
            navThumbWPD := athumb
          else
            theFolderList.Add(athumb);
        end
        else
          inc(I);
      end
      until I = theFileList.Count;

      // now sort first the folders:
      DoSort(theFolderList, Thesorttype);

      // move the folder navigator always on top
      if navThumb <> nil then
        theFolderList.Insert(0, navThumb);
      if navThumbWPD <> nil then
        theFolderList.Insert(0, navThumbWPD);

      // then sort the file list
      DoSort(theFileList, Thesorttype);

      // and finally merge the two again
      finalList := TTBVisibleThumbsList.Create;
      try

        for I := 0 to theFolderList.Count - 1 do
          finalList.Add(theFolderList[I]);

        for I := 0 to theFileList.Count - 1 do
          finalList.Add(theFileList[I]);

        theFileList.Assign(finalList);

      finally
        finalList.Free;
      end;

    finally
      theFolderList.Free;
    end;
  end
  else
    DoSort(theFileList, Thesorttype);

  fsort_updated := true;

  // fselectedindex := GetVisibleThumbIdxfromThumbID(oldIdSel);
  ViewPoint_Restore;

end;

function TThumbsBrowser.CustomSortComparerAsc(p1, p2: Pointer): integer;
begin
  fOnCustomSortCompare(TThumbEx(p1), TThumbEx(p2), result);
end;

function TThumbsBrowser.CustomSortComparerDesc(p1, p2: Pointer): integer;
begin
  result := -CustomSortComparerAsc(p1, p2);
end;

function TThumbsBrowser.HeaderCaptionSortComparerAsc(p1, p2: Pointer): integer;
var
  cap1, cap2: TTB_Thumb_Caption;
begin

  case fHeaderCaptionForSorting of
    cap_ShowFileName:
      result := ThumbSort_NameAsc(p1, p2);
    cap_ShowDateTime:
      result := ThumbSort_DateAsc(p1, p2);
    cap_ShowFileSize:
      result := ThumbSort_SizeAsc(p1, p2);
    cap_ShowDimensions:
      result := (TThumbEx(p1).SourceFileWidth * TThumbEx(p1).SourceFileHeight) -
        (TThumbEx(p2).SourceFileWidth * TThumbEx(p2).SourceFileHeight);
    cap_ShowEXIFDateTime:
      result := ThumbSort_ExifDateAsc(p1, p2);
    cap_ShowEXIF_XPAuthor:
      result := comparetext(TThumbEx(p1).SourceExif_XPAuthor, TThumbEx(p2).SourceExif_XPAuthor);
    cap_ShowEXIF_XPTitle:
      result := comparetext(TThumbEx(p1).SourceExif_XPTitle, TThumbEx(p2).SourceExif_XPTitle);
    cap_ShowEXIF_XPSubject:
      result := comparetext(TThumbEx(p1).SourceExif_XPSubject, TThumbEx(p2).SourceExif_XPSubject);
    cap_ShowEXIF_XPComment:
      result := comparetext(TThumbEx(p1).SourceExif_XPComments, TThumbEx(p2).SourceExif_XPComments);
    cap_ShowEXIF_XPKeywords:
      result := comparetext(TThumbEx(p1).SourceExif_XPKeywords, TThumbEx(p2).SourceExif_XPKeywords);
    cap_ShowEXIF_XPRating:
      result := TThumbEx(p1).SourceExif_XPRating - TThumbEx(p2).SourceExif_XPRating;
    cap_ShowKeywords:
      result := comparetext(TThumbEx(p1).Keywords, TThumbEx(p2).Keywords);
    cap_ShowRating:
      result := TThumbEx(p1).Rating - TThumbEx(p2).Rating;
    cap_ShowFileNameWithoutExtension:
      result := comparetext(changefileext(TThumbEx(p1).SourceFileNameShort, ''),
        changefileext(TThumbEx(p2).SourceFileNameShort, ''));
    cap_ShowFilePath:
      result := ThumbSort_FolderNaturalAsc(p1, p2);
    // cap_ShowFileDimensionsAndSize: ;
    // cap_ShowCreateDate: ;
    // cap_ShowCreateDateAndTime: ;
    cap_ShowEditDate:
      result := ThumbSort_DateAsc(p1, p2);
    cap_ShowEditDateAndTime:
      result := ThumbSort_DateAsc(p1, p2);
    // cap_ShowFileType: ;
    cap_ShowTopTitle:
      result := comparetext(TThumbEx(p1).TopTitle, TThumbEx(p2).TopTitle);
    cap_ShowBottomTitle:
      result := comparetext(TThumbEx(p1).BottomTitle, TThumbEx(p2).BottomTitle);
    // cap_ShowCustomMetaData: ;
    // cap_General: ;
  else
    begin
      cap1 := TThumbEx(p1).captions.GetCaptionbySetting(fHeaderCaptionForSorting);
      if cap1 = nil then
        result := 0
      else
      begin
        cap2 := TThumbEx(p2).captions.GetCaptionbySetting(fHeaderCaptionForSorting);
        if cap2 = nil then
          result := 0
        else
          result := comparetext(cap1.Text, cap2.Text);
      end;
    end;
  end;
end;

function TThumbsBrowser.HeaderCaptionSortComparerDesc(p1, p2: Pointer): integer;
begin
  result := -HeaderCaptionSortComparerAsc(p1, p2);
end;

procedure TThumbsBrowser.GetSortInstruction(Thesorttype: TTB_Browser_SortType);
begin
  FcompareCustomMethodAsc := nil;
  FcompareCustomMethodDesc := nil;
  FcompareHeaderMethodAsc := nil;
  FcompareHeaderMethodDesc := nil;
  FcompareAsc := nil;
  FcompareDesc := nil;
  FCompType := compAscending;

  case Thesorttype of

    stAsFromReportHeader:
      begin
        FCompType := fHeaderCaptionSortingDirection;
        FcompareHeaderMethodAsc := HeaderCaptionSortComparerAsc;
        FcompareHeaderMethodDesc := HeaderCaptionSortComparerDesc;
      end;
    stNotSorted:
      begin
        FcompareAsc := ThumbSort_NotSortedAsc;
        FcompareDesc := ThumbSort_NotSortedDesc;
        FCompType := compAscending;
      end;
    stCustomA:
      begin
        if assigned(fOnCustomSortCompare) then
        begin
          FcompareCustomMethodAsc := CustomSortComparerAsc;
          FcompareCustomMethodDesc := CustomSortComparerDesc;
          FCompType := compAscending;
        end;
      end;
    stCustomD:
      begin
        if assigned(fOnCustomSortCompare) then
        begin
          FcompareCustomMethodAsc := CustomSortComparerAsc;
          FcompareCustomMethodDesc := CustomSortComparerDesc;
          FCompType := compDescending;
        end;
      end;
    stNameA:
      begin
        FcompareAsc := ThumbSort_NameAsc;
        FcompareDesc := ThumbSort_NameDesc;
        FCompType := compAscending;
      end;
    stNameD:
      begin
        FcompareAsc := ThumbSort_NameAsc;
        FcompareDesc := ThumbSort_NameDesc;
        FCompType := compDescending;
      end;
    stNameNaturalA:
      begin
        FcompareAsc := ThumbSort_NameNaturalAsc;
        FcompareDesc := ThumbSort_NameNaturalDesc;
        FCompType := compAscending;
      end;
    stNameNaturalD:
      begin
        FcompareAsc := ThumbSort_NameNaturalAsc;
        FcompareDesc := ThumbSort_NameNaturalDesc;
        FCompType := compDescending;
      end;
    stNameWithPathA:
      begin
        FcompareAsc := ThumbSort_NameWithPathAsc;
        FcompareDesc := ThumbSort_NameWithPathDesc;
        FCompType := compAscending;
      end;
    stNameWithPathD:
      begin
        FcompareAsc := ThumbSort_NameWithPathAsc;
        FcompareDesc := ThumbSort_NameWithPathDesc;
        FCompType := compDescending;
      end;
    stNameWithPathNaturalA:
      begin
        FcompareAsc := ThumbSort_NameWithPathNaturalAsc;
        FcompareDesc := ThumbSort_NameWithPathNaturalDesc;
        FCompType := compAscending;
      end;
    stNameWithPathNaturalD:
      begin
        FcompareAsc := ThumbSort_NameWithPathNaturalAsc;
        FcompareDesc := ThumbSort_NameWithPathNaturalDesc;
        FCompType := compDescending;
      end;
    stFolderNaturalA:
      begin
        FcompareAsc := ThumbSort_FolderNaturalAsc;
        FcompareDesc := ThumbSort_FolderNaturalDesc;
        FCompType := compAscending;
      end;
    stFolderNaturalD:
      begin
        FcompareAsc := ThumbSort_FolderNaturalAsc;
        FcompareDesc := ThumbSort_FolderNaturalDesc;
        FCompType := compDescending;
      end;
    stTopTitleA:
      begin
        FcompareAsc := ThumbSort_TopTitleAsc;
        FcompareDesc := ThumbSort_TopTitleDesc;
        FCompType := compAscending;
      end;
    stTopTitleD:
      begin
        FcompareAsc := ThumbSort_TopTitleAsc;
        FcompareDesc := ThumbSort_TopTitleDesc;
        FCompType := compDescending;
      end;
    stBottomTitleA:
      begin
        FcompareAsc := ThumbSort_BottomTitleAsc;
        FcompareDesc := ThumbSort_BottomTitleDesc;
        FCompType := compAscending;
      end;
    stBottomTitleD:
      begin
        FcompareAsc := ThumbSort_BottomTitleAsc;
        FcompareDesc := ThumbSort_BottomTitleDesc;
        FCompType := compDescending;
      end;
    stDateA:
      begin
        FcompareAsc := ThumbSort_DateAsc;
        FcompareDesc := ThumbSort_DateDesc;
        FCompType := compAscending;
      end;
    stDateD:
      begin
        FcompareAsc := ThumbSort_DateAsc;
        FcompareDesc := ThumbSort_DateDesc;
        FCompType := compDescending;
      end;
    stEXIFDateA:
      begin
        FcompareAsc := ThumbSort_ExifDateAsc;
        FcompareDesc := ThumbSort_ExifDateDesc;
        FCompType := compAscending;
      end;
    stEXIFDateD:
      begin
        FcompareAsc := ThumbSort_ExifDateAsc;
        FcompareDesc := ThumbSort_ExifDateDesc;
        FCompType := compDescending;
      end;
    stSizeA:
      begin
        FcompareAsc := ThumbSort_SizeAsc;
        FcompareDesc := ThumbSort_SizeDesc;
        FCompType := compAscending;
      end;
    stSizeD:
      begin
        FcompareAsc := ThumbSort_SizeAsc;
        FcompareDesc := ThumbSort_SizeDesc;
        FCompType := compDescending;
      end;
    stFolderA:
      begin
        FcompareAsc := ThumbSort_FolderAsc;
        FcompareDesc := ThumbSort_FolderDesc;
        FCompType := compAscending;
      end;
    stFolderD:
      begin
        FcompareAsc := ThumbSort_FolderAsc;
        FcompareDesc := ThumbSort_FolderDesc;
        FCompType := compDescending;
      end;
    stFileTypeA:
      begin
        FcompareAsc := ThumbSort_FileTypeAsc;
        FcompareDesc := ThumbSort_FileTypeDesc;
        FCompType := compAscending;
      end;
    stFileTypeD:
      begin
        FcompareAsc := ThumbSort_FileTypeAsc;
        FcompareDesc := ThumbSort_FileTypeDesc;
        FCompType := compDescending;
      end;
  end;
end;

procedure TThumbsBrowser.ViewPoint_Save;
begin
  fLastViewPoint.TOP := GetThumbIDfromVisibleThumbIdx(TopDisplayedThumbIdx);
  fLastViewPoint.SELECTED := GetThumbIDfromVisibleThumbIdx(GetFirstSelectedDisplayedThumbIdx);
end;

procedure TThumbsBrowser.ViewPoint_Restore;
begin
  if fLastViewPoint.SELECTED = -1 then
  begin
    // take top
    GotoThumbPosition(GetVisibleThumbIdxfromThumbID(fLastViewPoint.TOP), false);
  end
  else
  begin
    fSelectedIndex := -1;
    // take selected
    GotoThumbPosition(GetVisibleThumbIdxfromThumbID(fLastViewPoint.SELECTED), true);
  end;
end;

procedure TThumbsBrowser.GetFileNames_Selected(filenames: TStrings);
var
  I: integer;
begin
  filenames.clear;
  for I := 0 to fSelectedThumbs.Count - 1 do
    filenames.Add(GetSelected(I).SourceFileName);
end;

procedure TThumbsBrowser.GetFileNames_Checked(filenames: TStrings);
var
  I: integer;
begin
  filenames.clear;
  for I := 0 to fCheckedThumbs.Count - 1 do
    filenames.Add(GetChecked(I).SourceFileName);
end;

function TThumbsBrowser.GetFilteredOutThumbsCount: integer;
begin
  result := fHiddenThumbs_Filter.Count + fHiddenThumbs_User.Count;
end;

function TThumbsBrowser.GetFirstSelectedDisplayedThumbIdx: integer;
var
  I: integer;
begin
  result := -1;
  for I := TopDisplayedThumbIdx to BottomDisplayedThumbIdx do
  begin

    if GetSelectedThumbIdxfromVisibleThumbIdx(I) >= 0 then
    begin
      result := I;
      break;
    end;

  end;
end;

procedure TThumbsBrowser.SetScrollerOrientation;
begin
  case fBrowserOrientation of
    tbo_vert:
      begin
        fScrollerBox.Align := alright;
        fScroller.Kind := sbVertical;
        if fScrollerBox.Visible then
          fScrollerBox.Width := GetSystemMetrics(SM_CXVSCROLL)
        else
          fScrollerBox.Width := 0;

      end;
    tbo_horz:
      begin
        fScrollerBox.Align := alBottom;
        fScroller.Kind := sbHorizontal;
        if fScrollerBox.Visible then
          fScrollerBox.Height := GetSystemMetrics(SM_CXVSCROLL)
        else
          fScrollerBox.Height := 0;
      end;
  end;

end;

procedure TThumbsBrowser.NotifyChangeThumbVisibility(sender: TObject);
var
  athumb: TThumbEx;
  Idx: integer;
begin
  athumb := TThumbEx(sender);

  Idx := fVisibleThumbs.IndexOf(athumb);

  if (athumb.Visible) then // if the thumb visibility has been set to true
  begin
    if (Idx = -1) then // if the thumb is not already in the visible list
    begin

      fVisibleThumbs.Add(athumb);
      if not AnyVisibilityTransactionOpened_Show then
        ManageThumbVisibilityChange(va_Reshow, athumb)
      else
      begin
        if fVisTransOpened_FilterShow > 0 then
          ManageThumbVisibilityChange(va_ReshowFilter, athumb);
        if fVisTransOpened_NavMemoryShow > 0 then
          ManageThumbVisibilityChange(va_ReshowNavMemory, athumb);
        if fVisTransOpened_UserShow > 0 then
          ManageThumbVisibilityChange(va_ReshowUser, athumb);
      end;

    end;
  end
  else // else thumb visibility has been set to false
  begin
    if (Idx <> -1) then // if the thumb is in the visible list
    begin
      athumb.LastVisibleIdx := -1;
      fVisibleThumbs.Delete(Idx);

      if not AnyVisibilityTransactionOpened_Hide then
        ManageThumbVisibilityChange(va_HideUnknownReason, athumb)
      else
      begin
        if fVisTransOpened_FilterHide > 0 then
          ManageThumbVisibilityChange(va_HideFilter, athumb);
        if fVisTransOpened_NavMemoryHide > 0 then
          ManageThumbVisibilityChange(va_HideNavMemory, athumb);
        if fVisTransOpened_UserHide > 0 then
          ManageThumbVisibilityChange(va_HideUser, athumb);
      end;

    end;
  end;

  if assigned(fOnThumbVisibilityChange) then
    fOnThumbVisibilityChange(athumb, GetThumbIdx(athumb));
end;

procedure TThumbsBrowser.NotifyChangeThumbSelected(sender: TObject);
var
  athumb: TThumbEx;
  Idx, s_idx: integer;

  bCancel: boolean;
  bSelected: boolean;
begin
  athumb := TThumbEx(sender);

  Idx := fVisibleThumbs.IndexOf(athumb);

  if (assigned(fOnThumbCanSelect) and athumb.SELECTED) then
  begin
    athumb.Events_Lock;
    try
      bSelected := athumb.SELECTED;
      fOnThumbCanSelect(athumb, bCancel);
      if bCancel then
      begin
        athumb.SELECTED := not bSelected; // this must be done inside the Events_lock
        // to avoid recursion!!
        EXIT; // >>>>EXIT
      end;
    finally
      athumb.Events_UnLock;
    end;
  end;

  if (assigned(fOnThumbCanDeSelect) and (not athumb.SELECTED)) then
  begin
    athumb.Events_Lock;
    try
      bSelected := athumb.SELECTED;
      fOnThumbCanDeSelect(athumb, bCancel);
      if bCancel then
      begin
        athumb.SELECTED := not bSelected; // this must be done inside the Events_lock
        // to avoid recursion!!
        EXIT; // >>>>EXIT
      end;
    finally
      athumb.Events_UnLock;
    end;
  end;

  s_idx := fSelectedThumbs.IndexOf(athumb);
  if athumb.SELECTED then
  begin
    if (s_idx = -1) then // if the thumb is not already selected
    begin
      fSelectedThumbs.Add(athumb);
      if athumb.Visible then
        fSelectedIndex := Idx;
    end;
  end
  else
  begin
    if (s_idx <> -1) then // if the thumb is actually selected
    begin
      fSelectedThumbs.Delete(s_idx);

      if fSelectedThumbs.Count > 0 then
        fSelectedIndex := GetVisibleThumbIdxfromSelectedThumbIdx(fSelectedThumbs.Count - 1)
      else
        fSelectedIndex := -1;
    end;
  end;

  if assigned(fOnThumbSelectionChange) then
  begin
    athumb.Events_Lock;
    try
      fOnThumbSelectionChange(athumb, Idx);
    finally
      athumb.Events_UnLock;
    end;
  end;

end;

procedure TThumbsBrowser.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;

  if (AComponent = fThumbsbrowser_InfoForm) and (Operation = opRemove) then
  begin
    fThumbsbrowser_InfoForm := nil;
    FInfoFormOpened := false;
  end;
end;

procedure TThumbsBrowser.NotifyChangeThumbChecked(sender: TObject);
var
  athumb: TThumbEx;
  c_idx: integer;
begin
  athumb := TThumbEx(sender);

  c_idx := fCheckedThumbs.IndexOf(athumb);

  if athumb.Checked then
  begin
    if (c_idx = -1) then // if the thumb is not already checked
      fCheckedThumbs.Add(athumb);
  end
  else
  begin
    if c_idx <> -1 then
      fCheckedThumbs.Delete(c_idx);
  end;

  if assigned(fOnThumbCheckStateChange) then
    fOnThumbCheckStateChange(athumb, GetThumbIdx(athumb));
end;

procedure TThumbsBrowser.NotifyChangeThumbRotated(sender: TObject);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);

  r_idx := frotatedThumbs.IndexOf(athumb);

  if (athumb.RotateMode = trmnone) then // thumb not rotated
  begin
    if r_idx <> -1 then
      frotatedThumbs.Delete(r_idx);
  end
  else
  begin // thumb rotated
    if (r_idx = -1) then
      frotatedThumbs.Add(athumb);
  end;
end;

procedure TThumbsBrowser.NotifyThumbBufferLoaded(sender: TObject; const bufWidth, bufHeight: integer;
  var bResizeBuffer: boolean; var newbufWidth, newbufHeight: integer);
begin
  if assigned(fOnThumbBufferLoaded) then
    fOnThumbBufferLoaded(TThumbEx(sender), bufWidth, bufHeight, bResizeBuffer, newbufWidth, newbufHeight);

end;

procedure TThumbsBrowser.NotifyGetCaptionInfo(const capSet: TTB_Thumb_CaptionsSetting; var info: TTB_Thumb_CaptionInfo);
begin
  info := fThumbCaption_Info[GetThumbCaption_OrderByCaption(capSet)];
end;

procedure TThumbsBrowser.NotifyGetCaptionIndex(const Pos: integer; var capIdx: integer);
begin
  capIdx := fThumbCaption_Info[Pos].capIdx;
end;

procedure TThumbsBrowser.NotifyDrawThumbPicture(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawPicture) then
    fOnItemCustomDrawPicture(athumb, r_idx, cv, cv_rect, Handled);
end;

procedure TThumbsBrowser.NotifyDrawThumbTopTitle(sender: TObject; cv: Tcanvas; cv_rect: Trect; var TitleText: string;
  var TitleColor, TitleSelectedColor: TColor; var TitleBackColor, TitleBackSelectedColor: TColor;
  var TitleStyle, TitleStyle_Selected: TFontStyles; var TitleOpacity, TitleOpacitySelected: cardinal;
  var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawTopTitle) then
    fOnItemCustomDrawTopTitle(athumb, r_idx, cv, cv_rect, TitleText, TitleColor, TitleSelectedColor, TitleBackColor,
      TitleBackSelectedColor, TitleStyle, TitleStyle_Selected, TitleOpacity, TitleOpacitySelected, Handled);

end;

procedure TThumbsBrowser.NotifyDrawThumbBottomTitle(sender: TObject; cv: Tcanvas; cv_rect: Trect; var TitleText: string;
  var TitleColor, TitleSelectedColor: TColor; var TitleBackColor, TitleBackSelectedColor: TColor;
  var TitleStyle, TitleStyle_Selected: TFontStyles; var TitleOpacity, TitleOpacitySelected: cardinal;
  var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawBottomTitle) then
    fOnItemCustomDrawBottomTitle(athumb, r_idx, cv, cv_rect, TitleText, TitleColor, TitleSelectedColor, TitleBackColor,
      TitleBackSelectedColor, TitleStyle, TitleStyle_Selected, TitleOpacity, TitleOpacitySelected, Handled);

end;

procedure TThumbsBrowser.NotifyDrawThumbFrame(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawFrame) then
    fOnItemCustomDrawFrame(athumb, r_idx, cv, cv_rect, Handled);
end;

procedure TThumbsBrowser.NotifyDrawThumbCaption(sender: TObject; cv: Tcanvas; cv_rect: Trect;
  var theCaptionText: string; var theCaptionColor, theCaptionSelectedColor: TColor;
  var theCaptionBackColor, theCaptionBackSelectedColor: TColor;
  var theCaptionStyle, theCaptionStyle_Selected: TFontStyles;
  var theCaptionOpacity, theCaptionOpacitySelected: cardinal; var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawCaption) then
    fOnItemCustomDrawCaption(athumb, r_idx, cv, cv_rect, theCaptionText, theCaptionColor, theCaptionSelectedColor,
      theCaptionBackColor, theCaptionBackSelectedColor, theCaptionStyle, theCaptionStyle_Selected, theCaptionOpacity,
      theCaptionOpacitySelected, Handled);
end;

procedure TThumbsBrowser.NotifyDrawAfterDraw(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawAfterDraw) then
    fOnItemCustomDrawAfterDraw(athumb, r_idx, cv, cv_rect, Handled);

end;

procedure TThumbsBrowser.NotifyDrawThumbBackground(sender: TObject; cv: Tcanvas; cv_rect: Trect; var Handled: boolean);
var
  athumb: TThumbEx;
  r_idx: integer;
begin
  athumb := TThumbEx(sender);
  r_idx := fVisibleThumbs.IndexOf(athumb);
  if assigned(fOnItemCustomDrawThumbBg) then
    fOnItemCustomDrawThumbBg(athumb, r_idx, cv, cv_rect, Handled);
end;


//

{$IFDEF TB_USEDB}

procedure TThumbsBrowser.CleanDatabase(const bNonExisting_Only: boolean; const bInPath_Only: boolean);
begin
  fDB.CleanDatabase(GUID_NULL, bNonExisting_Only, bInPath_Only, fBrowsedPaths);
end;
{$ENDIF}

procedure TThumbsBrowser.SetDisplayMethod(const Value: TResamplefilter);
begin
  if fSampleThumb.DisplayFilter = Value then
    EXIT;

  fSampleThumb.DisplayFilter := Value;
  ReassignThumbsLayout(false, false);

end;

function TThumbsBrowser.GetDragScrollInterval: cardinal;
begin
  result := SharedDragDrop_Handler.DragScrollInterval;
end;

procedure TThumbsBrowser.SetDragScrollInterval(Value: cardinal);
begin
  SharedDragDrop_Handler.DragScrollInterval := max(100, Value);
end;

procedure TThumbsBrowser.SetAllowCustomformat_ExternalReader(Value: boolean);
begin
  fAllowCustomformat_ExternalReader := Value;
  // RefreshFolders;
end;

procedure TThumbsBrowser.SetBackground2ndColor(const Value: TColor);
begin
  if fBackground2ndColor = TBGetValidColor(Value) then
    EXIT;

  fBackground2ndColor := TBGetValidColor(Value);
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetBackgroundColor(const Value: TColor);
begin
  if fBackgroundColor = TBGetValidColor(Value) then
    EXIT;

  fBackgroundColor := TBGetValidColor(Value);
  Color := fBackgroundColor;
  inherited Color := fBackgroundColor;

  if (BorderWidth > 0) then
    RecreateWnd
  else
    RefreshDisplay;
end;

procedure TThumbsBrowser.SetBackgroundType(const Value: TTB_Browser_BackgroundType);
begin
  if fBackgroundType = Value then
    EXIT;

  fBackgroundType := Value;
  RefreshDisplay;
end;

function TThumbsBrowser.GetMultithread: boolean;
begin
  result := fMultithread;
end;

procedure TThumbsBrowser.SetMultithread(theValue: boolean);
begin
  fMultithread := theValue;
end;

function TThumbsBrowser.GetMultithread_Pool_Count: integer;
begin
  result := fMultithread_Pool_Count;
end;

procedure TThumbsBrowser.SetMultithread_Pool_Count(theValue: integer);
begin

  fMultithread_Pool_Count := max(1, theValue);
  if (not(csLoading in ComponentState)) and (csDesigning in ComponentState) then
  begin
    if theValue < 1 then
      showmessage('Values below 1 are not allowed');
  end;

  SetMultiThread_Timeout(fMultithread_Timeout);
end;

function TThumbsBrowser.GetOwnUserObjects: boolean;
begin
  result := fSampleThumb.OwnUserObject;
end;

procedure TThumbsBrowser.SetMultiThread_Timeout(theValue: dword);
const
  lowLim: integer = 200;
var
  upLim, upLimDisc: integer;
  sUpLim, sUpLimDisc: string;
begin
  upLim := fMultithread_Pool_Count * 1500;
  sUpLim := '> NThreads * 1500 = ' + inttostr(upLim);
  upLimDisc := fMultithread_Pool_Count * 800;
  sUpLimDisc := '> NThreads * 800 = ' + inttostr(upLimDisc);

  fMultithread_Timeout := min(max(lowLim, theValue), upLim);

  if (not(csLoading in ComponentState)) and (csDesigning in ComponentState) then
  begin

    if theValue < lowLim then
      showmessage('Values of Timeout below ' + inttostr(lowLim) + ' are not allowed')
    else if theValue > upLim then
      showmessage('Values of Timeout ' + sUpLim + ' are not allowed')
    else if theValue > upLimDisc then
      showmessage('Values of Timeout ' + sUpLimDisc + ' are likely to offer poor performance');
  end;
end;

procedure TThumbsBrowser.setNavMemMaxThumbs(const Value: cardinal);
begin
  fNavMemMaxThumbs := Value;

  if fNavMemMaxThumbs < fHiddenThumbs_NavMem.Count then
    fHiddenThumbs_NavMem.Count := fNavMemMaxThumbs;
end;

procedure TThumbsBrowser.ExtraUpdateForVCLSkin;
begin
  fScrollerBox.Invalidate;
  fScroller.Invalidate;
  fScrollerBox.Update;
end;

function TThumbsBrowser.SetScrollPosition(sender: TObject; oldvalue, newValue: double;
  const FlagTimer: boolean = false): boolean;
  procedure CheckChangeScroller(Pos: integer);
  begin
    if fScrollParams.Pos <> Pos then
    begin
      fScroller.OnChange := nil;
      fScroller.OnScroll := nil;
      try
        fScrollParams.Pos := Pos;
        fScrollParams.Display_Pos := ScrollerPos_To_VirtualPos(Pos);
        fScroller.position := Pos;
      finally
        fScroller.OnChange := DOOnScrollerChange;
        fScroller.OnScroll := DOOnScrollerScroll;
      end;
    end;
  end;

var
  scp: integer;
begin
  { result := FALSE;

    if(fScrollUpdateTimer = nil) then
    begin
    if (assigned(fLoader)) and (fLoader.Running) then
    begin
    CheckChangeScroller(round(oldValue));
    ScrollTimerUpdate(sender, NewValue);
    EXIT;
    end
    end
    else if not FlagTimer  then
    begin
    CheckChangeScroller(round(oldValue));
    EXIT;
    end;
  }

  result := true;

  scp := max(fScroller.min, round(newValue));

  if ScrollerPos_To_VirtualPos(scp) > fScrollParams.Display_Maxlimited then
    scp := VirtualPos_To_ScrollerPos(fScrollParams.Display_Maxlimited);


  CheckChangeScroller(scp);

  if (fVisibleThumbs.Count > 0) then
  begin
    InvalidateDisplay;
    if (sender <> fScroller) or (gettickcount -  fUpdScrollertk > 80) then
    begin
      update;  //this will ensure the scroller to be repainted immediately
      fUpdScrollertk := gettickcount;
    end;

    if (sender <> fScroller) and (not fMouseDownFlag) then
    begin
      if MouseIsInside then
        MouseMove([ssLeft], self.ScreenToClient(mouse.CursorPos).X, self.ScreenToClient(mouse.CursorPos).Y);
      // to refresh mouse over effect
    end;
  end;

end;

function TThumbsBrowser.MouseIsInside: boolean;
var
  Pt: TPoint;
begin
  Pt := self.ScreenToClient(mouse.CursorPos);
  result := (Pt.X >= 0) and (Pt.X < self.Width) and (Pt.Y >= 0) and (Pt.Y < self.Height);
end;

procedure TThumbsBrowser.ScrollTimerUpdate(sender: TObject; Value: double);
begin
  if (fScrollUpdateTimer = nil) then
    fScrollUpdateTimer := TTimer.Create(self);
  fScrollUpdateTimerValue := Value;
  fScrollUpdateTimerSender := sender;
  fScrollUpdateTimer.enabled := false;
  fScrollUpdateTimer.interval := 10;
  fScrollUpdateTimer.OnTimer := Handle_ScrollTimerUpdate;
  fScrollUpdateTimer.enabled := true;
end;

procedure TThumbsBrowser.Handle_ScrollTimerUpdate(sender: TObject);
begin
  if not assigned(fScrollUpdateTimer) then
    EXIT;

  try
    SetScrollPosition(fScrollUpdateTimerSender, fScrollParams.Pos, fScrollUpdateTimerValue, true);
  finally
    fScrollUpdateTimer.enabled := false;
    Freeandnil(fScrollUpdateTimer);
  end;
end;

procedure TThumbsBrowser.ScrollThumbs(theScrollAmount: TTB_Browser_ScrollAmount);
var
  scp: integer;
begin
  if fScrollerBox.Visible then
  begin
    case theScrollAmount of
      sa_SmallAmount_Prev:
        scp := fScrollParams.Pos - integer(fScrollParams.SmallChange);
      sa_SmallAmount_Next:
        scp := fScrollParams.Pos + integer(fScrollParams.SmallChange);
      sa_LargeAmount_Prev:
        scp := fScrollParams.Pos - integer(fScrollParams.LargeChange);
      sa_LargeAmount_Next:
        scp := fScrollParams.Pos + integer(fScrollParams.LargeChange);
    end;
    fScroller.Scroll(scPosition, scp);
    // scLineUp, scLineDown, scPageUp, scPageDown
  end;
end;

procedure TThumbsBrowser.SetbrowserOrientation(Value: TTB_Browser_Orientation);
begin
  if fBrowserOrientation = Value then
    EXIT;
  fBrowserOrientation := Value;

  // SetScrollerBoxVisible(false);
  SetScrollerOrientation;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetFileScanner_MaxTransfer(const Value: integer);
begin
  FFileScanner_MaxTransfer := max(10, min(5000, Value));
end;

function TThumbsBrowser.IsFilterMultiExt(const theFilter: string): boolean;
begin
  result := Pos(';', theFilter) > 0
end;

procedure TThumbsBrowser.SetFilter(const Value: string);
begin
  if fFilter = Value then
    EXIT;

  fFilter_AllowMultiExt := IsFilterMultiExt(Value) or IsFilterMultiExt(fFilterExclude);

  fFilter := Value;
  ffilter_updated := false;

  CreateVisibleThumbs;
  RefreshDisplay;
  if fSelectedThumbs.Count = 0 then
    GotoThumbPosition(0, false)
  else
    GotoThumbPosition(fSelectedIndex, false);
end;

procedure TThumbsBrowser.SetFilterExclude(const Value: string);
begin
  if fFilterExclude = Value then
    EXIT;

  fFilter_AllowMultiExt := IsFilterMultiExt(Value) or IsFilterMultiExt(fFilter);

  fFilterExclude := Value;
  ffilter_updated := false;

  CreateVisibleThumbs;
  if fSelectedThumbs.Count = 0 then
  begin
    RefreshDisplay;
    GotoThumbPosition(0, false);
  end
  else
    GotoThumbPosition(fSelectedIndex, false);
end;

procedure TThumbsBrowser.SetFixedMarginBottom(const Value: integer);
begin
  if fBrowserOwnMarginBottom = Value then
    EXIT;

  fBrowserOwnMarginBottom := Value;
  // if (csDesigning in ComponentState) then EXIT;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetFixedMarginLeft(const Value: integer);
begin
  if fBrowserOwnMarginLeft = Value then
    EXIT;

  fBrowserOwnMarginLeft := Value;
  // if (csDesigning in ComponentState) then EXIT;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetFixedMarginRight(const Value: integer);
begin
  if fBrowserOwnMarginRight = Value then
    EXIT;

  fBrowserOwnMarginRight := Value;
  // if (csDesigning in ComponentState) then EXIT;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetFixedMarginTop(const Value: integer);
begin
  if fBrowserOwnMarginTop = Value then
    EXIT;

  fBrowserOwnMarginTop := Value;
  // if (csDesigning in ComponentState) then EXIT;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetShowCaptions(Value: boolean);
begin
  SetShowOptions(Value, th_ShowCaption);
end;

procedure TThumbsBrowser.SetShowCheckBoxes(Value: boolean);
begin
  SetShowOptions(Value, th_ShowCheckBox);
end;

procedure TThumbsBrowser.SetShowDesignTestThumbs(const Value: boolean);
begin
  if Value = fShowDesignTestThumbs then
    EXIT;

  fShowDesignTestThumbs := Value;
  if csLoading in ComponentState then
    EXIT;
  if not(csDesigning in ComponentState) then
    EXIT;

  if Value then
  begin
    CreateTests;
    RefreshDisplay;
  end
  else
    ClearThumbs_All;
end;

procedure TThumbsBrowser.CreateTests;
  function MakeTestBmp(w, h: integer; Color: TColor): TIEBitmap;
  begin
    result := TIEBitmap.Create(w, h, ie24rgb);
    result.Fill(Color);
  end;

var
  aBmp: TIEBitmap;
  athumb: TThumbEx;
  I, w, h: integer;
  Color: TColor;
  sColor: string;
begin
  if not(csDesigning in ComponentState) then
    EXIT;

  InitSampleThumb;
  w := 0;
  h := 0;
  for I := 0 to 2 do
  begin
    case I of
      0:
        begin
          w := 500;
          h := 300;
          Color := clblue;
          sColor := 'Test Blue';
        end;
      1:
        begin
          w := 400;
          h := 400;
          Color := clgreen;
          sColor := 'Test Green (Selected)';
        end;
      2:
        begin
          w := 300;
          h := 500;
          Color := clred;
          sColor := 'Test Red';
        end;
    end;

    aBmp := MakeTestBmp(w, h, Color);
    try
      athumb := Addthumb(aBmp, sColor, tbstore_Thumb);
      if I = 1 then
        athumb.SELECTED := true;
    finally
      aBmp.Free;
    end;
  end;

end;

procedure TThumbsBrowser.SetShowRatingBox(const Value: boolean);
begin
  SetShowOptions(Value, th_ShowRatingBox);
end;

procedure TThumbsBrowser.SetShowRotateButtons(Value: boolean);
begin
  SetShowOptions(Value, th_ShowRotateButtons);
end;

procedure TThumbsBrowser.SetShowInfoButton(Value: boolean);
begin
  SetShowOptions(Value, th_ShowInfoBox);
end;

procedure TThumbsBrowser.SetShowOptions(Value: boolean; setting: TTB_Thumb_ShowSetting);
  function CanChange(theThumb: TThumbEx): boolean;
  begin
    result := true;
    case setting of
      th_ShowCaption:
        ;
      th_ShowCheckBox:
        begin
          theThumb.Checked := Value;
        end;
      th_ShowRotateButtons:
        begin
          result := (theThumb.SourceType = st_File) or (theThumb.SourceType = st_WIA) or
            (theThumb.SourceType = st_WPDFile);
          if result then
            theThumb.RotateMode := trmnone; // reset rotation in any case
        end;
      th_ShowInfoBox:
        ;
      th_ShowTopTitle:
        ;
      th_ShowBottomTitle:
        ;
    end;

  end;

var
  I: integer;
  athumb: TThumbEx;
begin

  if (setting = th_ShowCheckBox) and (fShowCheckBoxes = Value) then
    EXIT;
  if (setting = th_ShowInfoBox) and (fShowInfoButton = Value) then
    EXIT;
  if (setting = th_ShowCaption) and (fShowCaptions = Value) then
    EXIT;
  if (setting = th_ShowRotateButtons) and (fShowRotateButtons = Value) then
    EXIT;
  if (setting = th_ShowTopTitle) and (fShowTopTitle = Value) then
    EXIT;
  if (setting = th_ShowBottomTitle) and (fShowBottomTitle = Value) then
    EXIT;
  if (setting = th_ShowRatingBox) and (fShowRatingBox = Value) then
    EXIT;

  fSampleThumb.Layout_Lock;
  try
    if Value then
      fSampleThumb.ShowSettings := fSampleThumb.ShowSettings + [setting]
    else
      fSampleThumb.ShowSettings := fSampleThumb.ShowSettings - [setting];
  finally
    fSampleThumb.Layout_Unlock;
  end;

  case setting of
    th_ShowCaption:
      begin
        fShowCaptions := Value;
      end;
    th_ShowCheckBox:
      begin
        fShowCheckBoxes := Value;
      end;
    th_ShowRotateButtons:
      begin
        fShowRotateButtons := Value;
      end;
    th_ShowInfoBox:
      begin
        fShowInfoButton := Value;
      end;
    th_ShowTopTitle:
      begin
        fShowTopTitle := Value;
      end;
    th_ShowBottomTitle:
      begin
        fShowBottomTitle := Value;
      end;
    th_ShowRatingBox:
      begin
        fShowRatingBox := Value;
      end;
  end;

  LockUpdate;
  try
    for I := 0 to fThumbs.Count - 1 do
    begin
      athumb := Thumbat_AbsoluteIdx(I);
      athumb.Layout_Lock;
      try
        if CanChange(athumb) then
        begin
          if Value then
            athumb.ShowSettings := athumb.ShowSettings + [setting]
          else
            athumb.ShowSettings := athumb.ShowSettings - [setting];

          CheckSpecialCaseThumb(athumb);
        end;
      finally
        athumb.Layout_Unlock;
      end;
    end;
  finally
    UnlockUpdate(true);
  end;

end;

procedure TThumbsBrowser.SetShowBottomTitle(const Value: boolean);
begin
  SetShowOptions(Value, th_ShowBottomTitle);
end;

procedure TThumbsBrowser.SetShowThumbnailHint(const Value: boolean);
begin
  fShowThumbnailHint := Value;
  if Value then
    ShowHint := true
  else
    Hint := '';
end;

procedure TThumbsBrowser.SetShowTopTitle(const Value: boolean);
begin
  SetShowOptions(Value, th_ShowTopTitle);
end;

procedure TThumbsBrowser.SetThumbCaptionColumnPercWidth(Idx: integer; const Value: single);
begin
  if Value < 0 then
    EXIT;

  fThumbCaption_Info[Idx].ColPercWidth := Value;
end;

procedure TThumbsBrowser.SetThumbCaptionOrderEX(Idx: integer; const Value: integer);
var
  oldPos: integer;
  oldInfo, swap: TTB_Thumb_CaptionInfo;
  I: integer;
begin
  if (Value > High(fThumbCaption_Info)) or (Value < low(fThumbCaption_Info)) then
    EXIT;

  oldPos := -1;
  for I := low(fThumbCaption_Info) to High(fThumbCaption_Info) do
  begin
    if fThumbCaption_Info[I].capIdx = Value then
    begin
      oldPos := I;
      break;
    end;
  end;
  if oldPos = -1 then
    raise Exception.Create('Error: cannot perform ordering');

  oldInfo := fThumbCaption_Info[oldPos];

  if oldPos < Idx then
  begin
    for I := oldPos to Idx - 1 do
    begin
      swap := fThumbCaption_Info[I + 1];
      fThumbCaption_Info[I] := swap;
    end;
  end
  else if oldPos > Idx then
  begin
    for I := oldPos downto Idx + 1 do
    begin
      swap := fThumbCaption_Info[I - 1];
      fThumbCaption_Info[I] := swap;
    end;
  end;

  fThumbCaption_Info[Idx] := oldInfo;

end;

procedure TThumbsBrowser.SetThumbCaptionOrder(Idx: integer; const Value: integer);
begin
  SetThumbCaptionOrderEX(Idx, Value);
  if assigned(fOnCaptionsOrderChanged) then
    fOnCaptionsOrderChanged(self);
end;

procedure TThumbsBrowser.WriteThumbCaption_MissingText(Writer: TWriter);
begin
  Writer.WriteString(GetThumbCaption_MissingText);
end;

procedure TThumbsBrowser.SetThumbCaption_MissingText(const Value: string);
begin
  if fSampleThumb.CaptionMissingText = Value then
    EXIT;

  fSampleThumb.CaptionMissingText := Value;
  ReassignThumbsLayout(false, true);
end;

procedure TThumbsBrowser.SetThumbCaption_Settings(Value: TTB_Thumb_CaptionsSettings);
begin
  if fSampleThumb.CaptionSettings = Value then
    EXIT;

  if cap_Empty in Value then
    SetThumbCaptionOrderEX(High(fThumbCaption_Info),ord(cap_Empty));//put it at last

  fSampleThumb.CaptionSettings := Value;
  InitCaptionInfos;
  ReassignThumbsLayout(false, true);

end;

procedure TThumbsBrowser.SetThumbDropShadow(const Value: TTB_Thumb_DropShadowOptions);
begin
  if fThumbDropShadow = Value then
    EXIT;
  fThumbDropShadow := Value;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetThumbLayoutType(Value: TTB_Thumb_Layout_Type);
begin
  if fSampleThumb.LayoutType = Value then
    EXIT;

  fSampleThumb.LayoutType := Value;
  ReassignThumbsLayout(true, true);

end;

procedure TThumbsBrowser.SetThumbResources(const Value: TTB_GraphicResources);
var
  I: integer;
  athumb: TThumbEx;
begin
  fLayoutResources.Assign(Value);

  athumb := Thumbat(0);
  if assigned(athumb) and ((athumb.SourceType = st_folderNav) or (athumb.SourceType = st_WPDFolderNav)) then
  begin
    athumb.RetrieveFromIEBitmap(fLayoutResources.BMP_FolderUpLevel);
    athumb.SourceType := st_folderNav;
  end;

  LockUpdate;

  try
    for I := 0 to fThumbs.Count - 1 do
      Thumbat_AbsoluteIdx(I).ForceRefreshDimensions;

  finally
    UnlockUpdate(true);
  end;
end;

procedure TThumbsBrowser.SetMaxCols(const Value: integer);
begin
  if fMaxCols = Value then
    EXIT;

  if Value = 0 then
  begin
    if csDesigning in ComponentState then
      showmessage('Value can be only -1 or greater than 0');

    EXIT;
  end;

  fMaxCols := max(-1, Value);

  // if csDesigning in ComponentState then EXIT;

  RefreshDisplay;
end;

procedure TThumbsBrowser.SetMaxRows(const Value: integer);
begin
  if fMaxRows = Value then
    EXIT;

  if Value = 0 then
  begin
    if csDesigning in ComponentState then
      showmessage('Value can be only -1 or greater than 0');

    EXIT;
  end;

  fMaxRows := max(-1, Value);

  // if csDesigning in ComponentState then EXIT;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetMultiSelect(Value: boolean);
begin
  if fMultiSelect <> Value then
  begin
    fMultiSelect := Value;
    if not Value then
    begin
      if fSelectedThumbs.Count > 1 then
        DeselectAllThumbs;
      // RefreshDisplay;
    end;
  end;
end;

procedure TThumbsBrowser.SetThumbsFrameBorderOpacity(const Value: cardinal);
begin
  if fSampleThumb.FrameBorderOpacity = Value then
    EXIT;

  fSampleThumb.FrameBorderOpacity := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBorderColor(Value: TColor);
begin
  if fSampleThumb.FrameBorderColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.FrameBorderColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBgOpacity(const Value: cardinal);
begin
  if fSampleThumb.FrameBgOpacity = Value then
    EXIT;

  fSampleThumb.FrameBgOpacity := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBgOpacitySelected(const Value: cardinal);
begin
  if fSampleThumb.FrameBgOpacitySelected = Value then
    EXIT;

  fSampleThumb.FrameBgOpacitySelected := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFramePadding_Bottom(const Value: integer);
begin
  if fSampleThumb.FramePadding_Bottom = Value then
    EXIT;

  fSampleThumb.FramePadding_Bottom := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFramePadding_Left(const Value: integer);
begin
  if fSampleThumb.FramePadding_Left = Value then
    EXIT;

  fSampleThumb.FramePadding_Left := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFramePadding_Right(const Value: integer);
begin
  if fSampleThumb.FramePadding_Right = Value then
    EXIT;

  fSampleThumb.FramePadding_Right := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFramePadding_Top(const Value: integer);
begin
  if fSampleThumb.FramePadding_Top = Value then
    EXIT;

  fSampleThumb.FramePadding_Top := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameRoundnessPerc(const Value: cardinal);
begin
  if fSampleThumb.FrameRoundnessPerc = Value then
    EXIT;

  fSampleThumb.FrameRoundnessPerc := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBorderSelectedColor(Value: TColor);
begin
  if fSampleThumb.FrameBorderSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.FrameBorderSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBorderOpacitySelected(const Value: cardinal);
begin
  if fSampleThumb.FrameBorderOpacitySelected = Value then
    EXIT;

  fSampleThumb.FrameBorderOpacitySelected := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBgColor(Value: TColor);
begin
  if fSampleThumb.FrameBgColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.FrameBgColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBackOpacity(const Value: cardinal);
begin
  if fSampleThumb.BackOpacity = Value then
    EXIT;

  fSampleThumb.BackOpacity := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBackPadding_Bottom(const Value: integer);
begin
  if fSampleThumb.BackPadding_Bottom = Value then
    EXIT;

  fSampleThumb.BackPadding_Bottom := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBackPadding_Left(const Value: integer);
begin
  if fSampleThumb.BackPadding_Left = Value then
    EXIT;

  fSampleThumb.BackPadding_Left := Value;
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetThumbsBackPadding_Right(const Value: integer);
begin
  if fSampleThumb.BackPadding_Right = Value then
    EXIT;

  fSampleThumb.BackPadding_Right := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBackPadding_Top(const Value: integer);
begin
  if fSampleThumb.BackPadding_Top = Value then
    EXIT;

  fSampleThumb.BackPadding_Top := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsFrameBgSelectedColor(Value: TColor);
begin
  if fSampleThumb.FrameBgSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.FrameBgSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBackOpacitySelected(const Value: cardinal);
begin
  if fSampleThumb.BackOpacitySelected = Value then
    EXIT;

  fSampleThumb.BackOpacitySelected := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBottomTitleBackColor(const Value: TColor);
begin
  if fSampleThumb.BottomTitleBackColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.BottomTitleBackColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBottomTitleBackSelectedColor(const Value: TColor);
begin
  if fSampleThumb.BottomTitleBackSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.BottomTitleBackSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBottomTitleFontColor(const Value: TColor);
begin
  if fSampleThumb.BottomTitleFontColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.BottomTitleFontColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsBottomTitleFontSelectedColor(const Value: TColor);
begin
  if fSampleThumb.BottomTitleSelectedFontColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.BottomTitleSelectedFontColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsCaptionFontColor(Value: TColor);
begin
  if fSampleThumb.CaptionFontColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.CaptionFontColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetThumbsCaptionFontSelectedColor(Value: TColor);
begin
  if fSampleThumb.CaptionFontSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.CaptionFontSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetThumbCaptionIncludeInFrame(const Value: boolean);
begin
  if fSampleThumb.CaptionIncludeInFrame = Value then
    EXIT;

  fSampleThumb.CaptionIncludeInFrame := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsCaptionOpacity(const Value: cardinal);
begin
  if fSampleThumb.CaptionOpacity = Value then
    EXIT;

  fSampleThumb.CaptionOpacity := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsCaptionRoundnessPerc(const Value: cardinal);
begin
  if fSampleThumb.CaptionRoundnessPerc = Value then
    EXIT;

  fSampleThumb.CaptionRoundnessPerc := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbSelected(Idx: integer; const Value: boolean);
begin
  if Value then
    SelectThumb(Idx)
  else
    DeSelectThumb(Idx);
end;

procedure TThumbsBrowser.SetThumbsCaptionOpacitySelected(const Value: cardinal);
begin
  if fSampleThumb.CaptionOpacitySelected = Value then
    EXIT;

  fSampleThumb.CaptionOpacitySelected := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsCaptionBackColor(Value: TColor);
begin
  if fSampleThumb.CaptionBackColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.CaptionBackColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetThumbsCaptionBackSelectedColor(Value: TColor);
begin
  if fSampleThumb.CaptionBackSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.CaptionBackSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.ThumbsSetColors(theBackcolor, theBackSelectedcolor, theCaptionFontColor,
  theCaptionFontSelectedColor, theCaptionBackColor, theCaptionBackSelectedColor, theTopTitleFontColor,
  theTopTitleFontSelectedColor, theTopTitleBackColor, theTopTitleBackSelectedColor, theBottomTitleFontColor,
  theBottomTitleFontSelectedColor, theBottomTitleBackColor, theBottomTitleBackSelectedColor, theFrameBorderColor,
  theSelFrameBorderColor: TColor);
begin
  fSampleThumb.FrameBgColor := theBackcolor;
  fSampleThumb.FrameBgSelectedColor := theBackSelectedcolor;

  fSampleThumb.CaptionBackColor := theCaptionBackColor;
  fSampleThumb.CaptionBackSelectedColor := theCaptionBackSelectedColor;
  fSampleThumb.CaptionFontColor := theCaptionFontColor;
  fSampleThumb.CaptionFontSelectedColor := theCaptionFontSelectedColor;

  fSampleThumb.TopTitleBackColor := theTopTitleBackColor;
  fSampleThumb.TopTitleBackSelectedColor := theTopTitleBackSelectedColor;
  fSampleThumb.TopTitleFontColor := theTopTitleFontColor;
  fSampleThumb.TopTitleSelectedFontColor := theTopTitleFontSelectedColor;

  fSampleThumb.BottomTitleBackColor := theBottomTitleBackColor;
  fSampleThumb.BottomTitleBackSelectedColor := theBottomTitleBackSelectedColor;
  fSampleThumb.BottomTitleFontColor := theBottomTitleFontColor;
  fSampleThumb.BottomTitleSelectedFontColor := theBottomTitleFontSelectedColor;

  fSampleThumb.FrameBorderColor := theFrameBorderColor;
  fSampleThumb.FrameBorderSelectedColor := theSelFrameBorderColor;

  ReassignThumbsLayout(false, false);

end;

procedure TThumbsBrowser.SetThumbsFrameSize(Value: cardinal);
begin
  if fSampleThumb.FrameSize = Value then
    EXIT;

  fSampleThumb.FrameSize := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsMouseOverOptions(const Value: TTB_Thumb_MouseOverOptions);
begin
  if fSampleThumb.MouseOverOptions = Value then
    EXIT;

  fSampleThumb.MouseOverOptions := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsSpacing(Value: cardinal);
begin

  fspacingX := Value;
  fspacingY := Value;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetThumbsSpacingX(const Value: cardinal);
begin
  fspacingX := Value;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetThumbsSpacingY(const Value: cardinal);
begin
  fspacingY := Value;
  RefreshDisplay;
end;

procedure TThumbsBrowser.SetThumbsTitleDrawFocusRectIfEmpty(const Value: boolean);
begin
  if fSampleThumb.TitleDrawFocusRectIfEmpty = Value then
    EXIT;

  fSampleThumb.TitleDrawFocusRectIfEmpty := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTitleOpacity(const Value: cardinal);
begin
  if fSampleThumb.TitleOpacity = Value then
    EXIT;

  fSampleThumb.TitleOpacity := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTitleRoundnessPerc(const Value: cardinal);
begin
  if fSampleThumb.TitleRoundnessPerc = Value then
    EXIT;

  fSampleThumb.TitleRoundnessPerc := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTitleOpacitySelected(const Value: cardinal);
begin
  if fSampleThumb.TitleOpacitySelected = Value then
    EXIT;

  fSampleThumb.TitleOpacitySelected := Value;
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTopTitleBackColor(const Value: TColor);
begin
  if fSampleThumb.TopTitleBackColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.TopTitleBackColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTopTitleBackSelectedColor(const Value: TColor);
begin
  if fSampleThumb.TopTitleBackSelectedColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.TopTitleBackSelectedColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTopTitleFontColor(const Value: TColor);
begin
  if fSampleThumb.TopTitleFontColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.TopTitleFontColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbsTopTitleFontSelectedColor(const Value: TColor);
begin
  if fSampleThumb.TopTitleSelectedFontColor = TBGetValidColor(Value) then
    EXIT;

  fSampleThumb.TopTitleSelectedFontColor := TBGetValidColor(Value);
  ReassignThumbsLayout(false, false);
end;

procedure TThumbsBrowser.SetThumbTopTitle(Idx: integer; const Value: string);
begin
  Thumb[Idx].TopTitle := Value;
end;

procedure TThumbsBrowser.SetThumbBottomTitle(Idx: integer; const Value: string);
begin
  Thumb[Idx].BottomTitle := Value;
end;

procedure TThumbsBrowser.SetThumbCaption(Idx: integer; const Value: string);
begin
  Thumb[Idx].SetCaption(Value);
end;

procedure TThumbsBrowser.SetThumbUserObject(Idx: integer; const Value: TObject);
begin
  Thumb[Idx].UserObject := Value;
end;

procedure TThumbsBrowser.SetThumbUserTag(Idx: integer; const Value: integer);
begin
  Thumb[Idx].UserTag := Value;
end;

procedure TThumbsBrowser.SetSorttype(Value: TTB_Browser_SortType);
begin
  if fSortType = Value then
    EXIT;

  fSortType := Value;
  ResortThumbs;
end;

procedure TThumbsBrowser.SetStoreType(const Value: TTB_Thumb_StoreType);
begin
  if Value = fSampleThumb.StoreType then
    EXIT;

  fSampleThumb.StoreType := Value;
  // no need to reassign to all thumbs, because the thumbs that are already loaded
  // should be reloaded and this can be undesired
  // let the user use the reload method himself if he desires to reload
end;

Function TThumbsBrowser.IsUserFormat(theExt: string): boolean;
var
  k: integer;
begin
  result := false;
  for k := low(fUserFileFormats_Read) to high(fUserFileFormats_Read) do
  begin
    if comparetext(theExt, fUserFileFormats_Read[k].Extension) = 0 then
    begin
      result := true;
      break;
    end;
  end;
end;



// Class TThumbsLoader--------------------------------

constructor TThumbsLoader.Create(theDBSessionGuid: TGuid; theBrowser: TThumbsBrowser; bMultithread: boolean;
  theMultithread_Pool_Count: integer; theMultithread_Timeout: dword);
begin
  inherited Create(true);
  freeonterminate := false;

  fAllowSyncOnTerminate := false;
  fWaitAllCompleted := false;
  fInitThumbs := TNamedList.Create;

  fDBSessionGuid := theDBSessionGuid;
  fBrowser := theBrowser;
  fAllThumbs := theBrowser.Thumbs;
  fThumbLoadDemandAsyncHandler := fBrowser.OnThumbLoadDemandAsync;

  fMultithread := bMultithread;
  fThreadPool_count := max(1, theMultithread_Pool_Count);
  fDynThreadPool_count := fThreadPool_count;

  fThreadTimeout := theMultithread_Timeout;

  fPauseCount := 0;

  TBCriticalSection := TCriticalSection.Create;
  TBDatabaseCriticalSection := TCriticalSection.Create;

  fFileList := TStringList.Create;
  fUrlList := TStringList.Create;
  fWPDList := TStringList.Create;
  fScannerList := TThumbsBrowser_ScanFilesThread_FileRcds.Create;
end;

destructor TThumbsLoader.Destroy;
begin
  Freeandnil(fInitThumbs);
  Freeandnil(fFileList);
  Freeandnil(fUrlList);
  Freeandnil(fWPDList);

  Dispose_ScanFilesThread_FileRcds(fScannerList, true);

  TBFreeCS(TBCriticalSection);
  TBFreeCS(TBDatabaseCriticalSection);

  inherited;
end;

function TThumbsLoader.GetRunning: boolean;
begin
  result := fRunningSynch;
end;

procedure TThumbsLoader.SetRunning(bValue: boolean);
begin
  fRunning := bValue;
  Synchronize(SetRunningSynch);
end;

procedure TThumbsLoader.SetRunningSynch;
begin
  fRunningSynch := fRunning;
end;

function TThumbsLoader.Synchronize(method: TThreadMethod): boolean;
begin
  result := false;
  if Terminated and (not fAllowSyncOnTerminate) then
    EXIT;
  /// >>>>EXIT

  inherited Synchronize(method);

  result := true;
end;

procedure TThumbsLoader.GetReader;
begin
  fThumbReader := fBrowser.GetReaderFunction(fCurrentLoadedThumb.SourceFileExtension);
end;

function TThumbsLoader.CheckAllTerminated(const waitTime: dword): TWaitResult;
begin
  result := wrError;

  try
    result := TBEvent.WaitFor(waitTime); // when TBEvent is set all threads are finished
  except
    sleep(0);
  end;
end;

procedure TThumbsLoader.Execute;
  function KeepWaitingThreads(theWaitingStart: cardinal): boolean;
  var
    thrCount: integer;
  begin
    thrCount := CheckThreadsCount;

    result := thrCount > 0;

    if result then
    begin
      if gettickcount - theWaitingStart >= fThreadTimeout then
      begin
        result := false; // do not wait beyound timeou
      end;
    end;
  end;
  procedure CheckPaused;
  begin
    // if paused wait in loop until pause is removed or terminated
    while (not Terminated) and (fPauseCount > 0) do
      sleep(15);
  end;

var
  n: integer;
  tkThreadsWaitingStart: cardinal;
  dispInterval: integer;
begin

  if Terminated then
    EXIT;

  fPriorityN := tpNormal;
  fPriorityL := tpLower;
  fChildrenPriority := fPriorityN;

  priority := fPriorityN;

  n := fAllThumbs.Count;

  if n = 0 then
    EXIT;

  // ------------------------
  SetRunning(true);
  // ------------------------

  if fMultithread then
  begin
    InitMultithread;
  end
  else
  begin
    fCurrentLoadedThumb := TThumbEx.Create(tborig_Auto, fBrowser.canvas, nil, true);
  end;

  try
    fLastWaitResult := wrSignaled;
    fMultiCleaned := false;
    fAllExplored := false;

    fcurrent := 0; // current thumb advancement index
    fLastTop := 0;
    fsuggestedcurrent := 0;
    fSuggestionInterval := 50;
    fSuggestTikCount := gettickcount;

    fVisibleExploredCtr := 0;
    fVisibleExploredCtr_Last := 0;

    // if thread is not terminated
    // and not all thumbs have been explored or there are thumbs in the queue
    // keep looping
    while (assigned(fBrowser)) and (not Terminated) and ((not fAllExplored)) do
    begin

      CheckPaused; // check if loading has been paused: if so wait until pause is removed

      if fMultithread then // **************************multi thread*******************************
      begin
        fLastThreadCount := CheckThreadsCount;
        fDynThreadPool_count := max(1, fThreadPool_count - round(fLastThreadCount / 2.5));

        // sleep(max(0, 2 * (fThreadPool_count - fDynThreadPool_count)));

        // add new thumbs to a thread list to be explored
        // this also increment fCurrent !! we must always go inside here!!
        Synchronize(FillThumbsToExplore);
        // this also increment fCurrent !!

        ExploredThumbs_CreateThreads;
        ExploredThumbs_LaunchThreads; // Launch the new threads

        tkThreadsWaitingStart := gettickcount;

        {
          tkDisplayThumbs := GetTickCount;
          dispInterval :=  min(15, 2 + 2 * fDynThreadPool_count);
          while (not Terminated) and KeepWaitingThreads(tkThreadsWaitingStart) do
          //wait for the threads to finish
          begin

          if (gettickcount > tkDisplayThumbs + dispInterval) and (CheckDoneThumbsCount>0) then
          begin
          synchronize(ExploredThumbs_Set);  //check if any thumb is loaded and Set it to Browser
          tkDisplayThumbs := GetTickCount;
          end;
          end;
        }

        dispInterval := min(20, 4 + 2 * fDynThreadPool_count);
        while (not Terminated) and (CheckAllTerminated(dispInterval) <> wrSignaled) do
        // wait for the threads to finish
        begin
          if gettickcount - tkThreadsWaitingStart >= fThreadTimeout then
          begin
            break;
          end;

          if (CheckDoneThumbsCount > 0) then
            Synchronize(ExploredThumbs_Set); // check if any thumb is loaded and Set it to Browser

        end;

        if (CheckDoneThumbsCount > 0) then
          Synchronize(ExploredThumbs_Set);

        fLastWaitResult := CheckAllTerminated(0);

      end
      else
      begin // **************************single thread*******************************
        if gettickcount - fSuggestTikCount > fSuggestionInterval then
        begin
          Synchronize(GetSuggestedCurrent); // get the current thumbnail idx from which start exploring
          fcurrent := fsuggestedcurrent;
        end;

        Synchronize(CurrentThumb_Explore); // get thumb at suggested idx

        // START LOADING THE THUMB-------------------------------------------------------------
        if (fCurrentLoadedThumb.ExploringStatus = thbNotExplored) then // if not explored yet
        begin
          Synchronize(FireOnBeforeThumbLoaded);
          Synchronize(GetReader);

          try
{$IFDEF TB_USEDB}
            if not fBrowser.DB.DBActive then
            begin
              CurrentThumb_ReadFromFile;
            end
            else
            begin
              priority := fPriorityL;
              try
                CurrentThumb_CheckWrite_ToDB(CurrentThumb_CheckRead_FromDB);
              finally
                priority := fPriorityN;
              end;
            end;
{$ELSE}
            CurrentThumb_ReadFromFile;
{$ENDIF}
            fCurrentLoadedThumb.RefreshCaptions;
          except
            // exception on loading file
            ;
          end;

          Synchronize(CurrentThumb_Set);
        end;
        // STOP LOADING THE THUMB-------------------------------------------------------------

      end;

      // if terminated then jump directly to the loop checking condition and exit loop
      // -----------------------------------------------------------------------------
      if not Terminated then
      begin
        if fcurrent >= n - 1 then // if some thumbs were removed in the meantime fcurrent could be
        // greater than n - 1
        begin

          n := fAllThumbs.Count;
          Synchronize(CheckAllExplored); // when arrives at the end check if all thumbs are loaded
          // and set the fAllExplored variable

          fcurrent := 0; // go to  first thumb again by default
        end
        else
        begin
          inc(fcurrent);
        end;
      end;
      // -----------------------------------------------------------------------------

    end; // jump to loop checking condition
    // END OF THE MAIN WHILE LOOP on all thumbs

  finally

    try

      if not Terminated then
      begin
        Synchronize(DOOnBeforeTerminate);
      end;

      if fMultithread then
      begin
        if Terminated then
          Synchronize(ResetExploringStatus_Unloaded);
        CleanUpMultithread;
      end
      else
      begin
        fCurrentLoadedThumb.Free;
      end;

    finally
      SetRunning(false); // the internal try..finally make sure the thread always reset
      // the running property even in case of error inside the previous try..finally
    end;
  end;
end;

procedure TThumbsLoader.ResetExploringStatus_Unloaded;
var
  I: integer;
  athumb: TThumbEx;
begin
  for I := 0 to fThumbsToExplore.Count - 1 do
    if TThumbEx(fThumbsToExplore[I]).ExploringStatus = thbExploreInProcess then
    begin
      athumb := FindThumbByGUID(TThumbEx(fThumbsToExplore[I]).UniqueID);
      if athumb <> nil then
        athumb.ExploringStatus := thbNotExplored;
    end;
end;

procedure TThumbsLoader.InitMultithread;
begin
  TBEvent := TEvent.Create(nil, true, false, '', true);
  TBEventCounter := TThumbsBrowser_Thumb_LoadThread_Counter.Create;

  fThumbsToExplore := TList.Create;
  fCleanupCS := TCriticalSection.Create;

  fThreads := TThreadList.Create;
  fNewThreads := TList.Create;
  fDoneThumbs := TThreadList.Create;
end;

procedure TThumbsLoader.CleanUpMultithread;
begin
  AbortThreads;
  if Terminated then
  begin
    if fWaitAllCompleted then
    begin
      if debughook <> 0 then
        fLastWaitResult := CheckAllTerminated(3000)
      else
        fLastWaitResult := CheckAllTerminated(800);
    end
    else if (not freeonterminate) then
      fLastWaitResult := CheckAllTerminated(100) // if free itself then can wait more time
    else
      fLastWaitResult := CheckAllTerminated(0);
  end
  else
    fLastWaitResult := CheckAllTerminated(0); // else do not wait

  fCleanupCS.Enter;
  try

    if CheckDoneThumbsCount > 0 then
      ClearDoneThumbs;
    if fLastWaitResult = wrSignaled then // if no thread is running, delete all thumbs (explored and not)
      ClearThumbsToExplore([])
    else
    begin
      ClearThumbsToExplore([thbExplored]); // else delete only explored: this can lead to a memory leak
      // but avoids possible access violations because some threads still running
      ExpectLeaksThumbsToExplore;
    end;

    fThumbsToExplore.Free;
    fDoneThumbs.Free;
    fThreads.Free;
    fNewThreads.Free;

    // TWaitResult = (wrSignaled, wrTimeout, wrAbandoned, wrError, wrIOCompletion);
    if (fLastWaitResult = wrSignaled) and (debughook = 0) then
    begin
      Freeandnil(TBEvent);
      Freeandnil(TBEventCounter);
    end
    else
    begin
      RegisterExpectedMemoryLeak(TBEvent);
      RegisterExpectedMemoryLeak(TBEventCounter);
    end;
  finally
    fMultiCleaned := true;
    fCleanupCS.Leave;
    sleep(50); // wait some more before freeing the CS so that the threads that were waiting can exit
    TBFreeCS(fCleanupCS);
  end;
end;

procedure TThumbsLoader.Handle_ThumbThread_Done(sender: TThread; theThumb: TThumbEx);
begin
  try
    if RemoveThread(sender) then
      AddDoneThumb(theThumb);
  except
    ;
  end;
end;

procedure CopyFileRcdsList(src, dest: TThumbsBrowser_ScanFilesThread_FileRcds);
var
  I: integer;
  Rcd: TThumbsBrowser_ScanFilesThread_FileRcd;
begin

  dest.clear;
  for I := 0 to src.Count - 1 do
  begin
    Rcd := TThumbsBrowser_ScanFilesThread_FileRcd.Create;
    Rcd.Assign(TThumbsBrowser_ScanFilesThread_FileRcd(src[I]));
    dest.Add(Rcd);
  end;
end;

procedure TThumbsLoader.PassScannerList(theList: TThumbsBrowser_ScanFilesThread_FileRcds);
begin

  if not assigned(theList) then
    Dispose_ScanFilesThread_FileRcds(fScannerList, false)
  else
  begin
    Dispose_ScanFilesThread_FileRcds(fScannerList, false);
    CopyFileRcdsList(theList, fScannerList);
    Dispose_ScanFilesThread_FileRcds(theList, false);
  end;
end;

procedure TThumbsLoader.PassFileList(theFileList: TStringList);
begin
  if not assigned(theFileList) then
  begin
    fFileList.clear;
  end
  else
    TBStringListcopy(theFileList, fFileList);
end;

procedure TThumbsLoader.PassUrlList(theUrlList: TStringList);
begin
  if not assigned(theUrlList) then
  begin
    fUrlList.clear;
  end
  else
    TBStringListcopy(theUrlList, fUrlList);
end;

procedure TThumbsLoader.PassWPDList(theWPDList: TStringList);
begin
  if not assigned(theWPDList) then
  begin
    fWPDList.clear;
  end
  else
    TBStringListcopy(theWPDList, fWPDList);
end;

procedure TThumbsLoader.Pause;
begin
  inc(fPauseCount);
end;

procedure TThumbsLoader.Unpause;
begin
  if fPauseCount > 0 then
    dec(fPauseCount);
end;

procedure TThumbsLoader.HandleSearchRecordAction(sr: TSearchRec; const thefolder_slashed: string;
  testThumbExists: TTB_DB_ThumbExistResult; var Counter: integer);
var
  mode: TTB_Browser_FileRecord_AddMode;
  athumb: TThumbEx;
begin
  mode := amNoAction;
  case testThumbExists.MatchType of
    TERcdDoesntExist:
      mode := amAppend;
    TERcdExistsOld:
      mode := amReplace;
    TERcdExists:
      mode := amNoAction;
  end;

  athumb := nil;
  case mode of
    amNoAction:
      athumb := TThumbEx(testThumbExists.MatchedThumb); // thumb is already up to date
    amAppend:
      athumb := AppendThumb(sr, thefolder_slashed);
    amInsert:
      athumb := InsertThumb(Counter, sr, thefolder_slashed);
    amReplace:
      athumb := ReplaceOldThumb(testThumbExists.Index, sr, thefolder_slashed);
  end;

  if athumb <> nil then
  begin
    // -----------------------------------------------------------------------
    if mode <> amNoAction then
      athumb.ExploringStatus := thbNotExplored; // the thumb needs to be reexplored / reloaded
    // -----------------------------------------------------------------------

    fInitThumbs.Add(athumb.SourceFileName, athumb);
  end;
end;

procedure TThumbsLoader.HandleNewFileSearchRecord(sr: TSearchRec; const bIsUrl: boolean;
  const bAddToExisitingPaths: boolean; const thefolder_slashed: string; var Counter: integer);
var

  fcompletename: string;
  fname: string;
  fext: string;
  fdate: Tdatetime;
  fsize: integer;
  testThumbExists: TTB_DB_ThumbExistResult;
  bCanLoad_ASFile, bCanLoad_AsFolder, bCanLoad: boolean;

  bPathWasPresent: boolean;
begin
  fname := extractfilename(sr.Name);
  fext := extractfileext(sr.Name);
  fcompletename := thefolder_slashed + sr.Name;

  if sr.Attr = TBCONST_SR_ATTR_URL then
    bPathWasPresent := true // this forces to look for duplicate urls in all thumbs in next step
  else
  begin
    if bAddToExisitingPaths then
      bPathWasPresent := not fBrowser.Paths_Add(thefolder_slashed) // path was not present, path added
    else
      bPathWasPresent := fBrowser.InPaths(fcompletename); // path was present
  end;

  bCanLoad_ASFile := fBrowser.AcceptFileCondition(sr, fname, fext);
  bCanLoad_AsFolder := fBrowser.AcceptFolderCondition(sr, true);

  bCanLoad := bCanLoad_ASFile or bCanLoad_AsFolder;

  if bCanLoad then
  begin
    inc(Counter);

    fdate := tbs_getfiledate(sr);
    fsize := sr.size;

    if sr.Attr = TBCONST_SR_ATTR_URL then
      testThumbExists := FileThumb_Exists(fcompletename, bPathWasPresent)
    else
      testThumbExists := FileThumb_Exists(fcompletename, fdate, fsize, bPathWasPresent);

    HandleSearchRecordAction(sr, thefolder_slashed, testThumbExists, Counter);

  end;
end;

procedure TThumbsLoader.HandleNewScannerRecord(scanner_record: TThumbsBrowser_ScanFilesThread_FileRcd);
var
  testThumbExists: TTB_DB_ThumbExistResult;
  Counter: integer;
begin
  Counter := 0;
  testThumbExists := FileThumb_Exists(scanner_record.fname, scanner_record.fdate, scanner_record.fsize, true);

  HandleSearchRecordAction(scanner_record.sr, scanner_record.fFolderSlashed, testThumbExists, Counter);
end;

{$IFDEF TB_PORTABLEDEVICE}

procedure TThumbsLoader.HandleNewWPDRecord(WPDObj: TIEWPDObject);
var
  testThumbExists: TTB_DB_ThumbExistResult;
  mode: TTB_Browser_FileRecord_AddMode;
  athumb: TThumbEx;
begin

  testThumbExists := WPDThumb_Exists(WPDObj);

  mode := amNoAction;
  case testThumbExists.MatchType of
    TERcdDoesntExist:
      mode := amAppend;
    TERcdExistsOld:
      mode := amReplace;
    TERcdExists:
      mode := amNoAction;
  end;

  athumb := nil;
  case mode of
    amNoAction:
      athumb := TThumbEx(testThumbExists.MatchedThumb); // thumb is already up to date
    amAppend:
      athumb := AppendThumb(WPDObj);
    amInsert:
      athumb := InsertThumb(0, WPDObj);
    amReplace:
      athumb := ReplaceOldThumb(testThumbExists.Index, WPDObj);
  end;
  if athumb <> nil then
  begin
    // -----------------------------------------------------------------------
    if mode <> amNoAction then
      athumb.ExploringStatus := thbNotExplored; // the thumb needs to be reexplored / reloaded
    // -----------------------------------------------------------------------
    fInitThumbs.Add(athumb.SourceFileName, athumb);
  end;
end;
{$ENDIF}

procedure TThumbsLoader.Init(theFolder: string; theFileList: TStringList; theUrlList: TStringList;
  theWPDList: TStringList; theScannerList: TThumbsBrowser_ScanFilesThread_FileRcds);
begin
  fRunning := false;
  fRunningSynch := false;
  try
    fFolder := theFolder;
    if theFileList <> nil then
      PassFileList(theFileList);
    if theUrlList <> nil then
      PassUrlList(theUrlList);
    if theWPDList <> nil then
      PassWPDList(theWPDList);
    if theScannerList <> nil then
      PassScannerList(theScannerList);

  finally;
  end;

  InitializeLoading;
end;

function TThumbsLoader.InitializeLoading_FromFolder: boolean;
var
  Counter: integer;
  sr: TSearchRec;
  thefolder_slashed: string;
  FileAttrs: integer;
begin
  result := false;
  if (fFolder = '') then
  begin
    // Browser.fFolderCurrent := '';
    EXIT;
  end;

  if not directoryexists(fFolder) then
    EXIT;

  thefolder_slashed := Tbs_AddSlash(fFolder);
  fBrowser.fFolderCurrent := thefolder_slashed; // DO NOT USE THE SETTER OF FOLDER CURRENT!!

  fBrowser.Paths_Add(thefolder_slashed);

  FileAttrs := faAnyfile;

  Counter := -1;
  if FindFirst(thefolder_slashed + '*.*', FileAttrs, sr) = 0 then
  begin
    try
      HandleNewFileSearchRecord(sr, false, false, thefolder_slashed, Counter);

      while FindNext(sr) = 0 do
      begin
        HandleNewFileSearchRecord(sr, false, false, thefolder_slashed, Counter);
      end;

    finally
      FindClose(sr);
    end;

  end;

  result := true;
end;

function TThumbsLoader.InitializeLoadingFromFileList: boolean;
var
  Counter: integer;
  sr: TSearchRec;
  thefolder_slashed: string;
  FileAttrs: integer;

  I: integer;
begin
  result := false;

  if not assigned(fFileList) then
    EXIT;
  if fFileList.Count = 0 then
    EXIT;

  FileAttrs := faAnyfile;

  for I := 0 to fFileList.Count - 1 do
  begin
    if FindFirst(fFileList.Strings[I], FileAttrs, sr) = 0 then
    begin
      try
        thefolder_slashed := extractfilepath(fFileList.Strings[I]);
        HandleNewFileSearchRecord(sr, false, true, thefolder_slashed, Counter);
      finally
        FindClose(sr);
      end;

    end;
  end;

  result := true;
end;

function TThumbsLoader.InitializeLoadingFromUrlList: boolean;
var
  Counter: integer;
  sr: TSearchRec;
  thefolder_slashed: string;

  I: integer;
  sDecodedUrl: string;
begin
  result := false;
  if not assigned(fUrlList) then
    EXIT;
  if fUrlList.Count = 0 then
    EXIT;

  for I := 0 to fUrlList.Count - 1 do
  begin
    if tbs_UrlIsValidUrl(fUrlList[I]) then
    begin
      sDecodedUrl := tbs_UrlDecode(fUrlList[I]);
      sr.Name := tbs_UrlExtractFilename(sDecodedUrl, false);
      sr.Attr := TBCONST_SR_ATTR_URL; // this identifies urls
      thefolder_slashed := tbs_UrlExtractPath(sDecodedUrl, false);
      try
        HandleNewFileSearchRecord(sr, true, false, thefolder_slashed, Counter);
      finally

      end;

    end;
  end;
  result := true;
end;

{$IFDEF TB_PORTABLEDEVICE}

function TThumbsLoader.InitializeLoadingFromWPDList: boolean;
var
  I, Idx, tk: integer;
begin
  result := false;

  if not assigned(fWPDList) then
    EXIT;
  if fWPDList.Count = 0 then
    EXIT;

  tk := gettickcount;
  for I := 0 to fWPDList.Count - 1 do
  begin
    if fBrowser.fAbortWPD then
      break;

    Idx := fBrowser.WPD.ObjectIDToIndex(fWPDList[I]);
    if Idx >= 0 then
      HandleNewWPDRecord(fBrowser.WPD.Objects[Idx]);

    if (I = fWPDList.Count - 1) or (gettickcount - tk > 300) then
    begin
      if assigned(fBrowser.OnWPDProgress) then
        fBrowser.OnWPDProgress(fBrowser, I, 0, fWPDList.Count - 1);

      Application.ProcessMessages;
    end;
  end;

  result := true;
end;
{$ENDIF}

function TThumbsLoader.InitializeLoadingFromScannerList: boolean;
var
  I: integer;
  aScannerRecord: TThumbsBrowser_ScanFilesThread_FileRcd;
begin
  result := false;
  if not assigned(fScannerList) then
    EXIT;
  if fScannerList.Count = 0 then
    EXIT;

  for I := 0 to fScannerList.Count - 1 do
  begin
    aScannerRecord := TThumbsBrowser_ScanFilesThread_FileRcd(fScannerList[I]);
    HandleNewScannerRecord(aScannerRecord);
  end;
  result := true;
end;

function TThumbsLoader.InitializeLoading_FromExistingPaths: boolean;
var
  I: integer;
begin
  result := fBrowser.fBrowsedPaths.Count > 0;

  for I := 0 to fBrowser.fBrowsedPaths.Count - 1 do
  begin
    fFolder := fBrowser.fBrowsedPaths[I];
    InitializeLoading_FromFolder;
  end;

  fFolder := '';
end;

procedure TThumbsLoader.InitializeLoading;
var
  loadingType: TThumbsbrowser_LoadingType;
begin
  loadingType := tblt_Reload;

  // -----------Add new Thumbs to Existing ones (if any) from a source based on Browsing settings---------------------------------
  if fBrowser.ReBrowsingExistingPaths then
  begin
    if InitializeLoading_FromExistingPaths then
    // if the RefreshFolders method was called we need to refresh just current files
      loadingType := tblt_FileSystem;
  end
  else
  begin
    if InitializeLoading_FromFolder or InitializeLoadingFromFileList or InitializeLoadingFromScannerList or InitializeLoadingFromUrlList
    then
      loadingType := tblt_FileSystem;

{$IFDEF TB_PORTABLEDEVICE}
    if InitializeLoadingFromWPDList then
      loadingType := tblt_WPD;
{$ENDIF}
  end;
  // --------------------------------------------
  fBrowser.fLastLoadingType := loadingType;
  // --------------------------------------------

  fBrowser.CreateVisibleThumbs(loadingType, fInitThumbs); // and we need to recreate the visible thumbs list

  if Browser.StyleOptions.BrowserStyle = tbStyle_Columns then
    fBrowser.SortThumbs(true, stAsFromReportHeader)
  else
    fBrowser.SortThumbs(true, fBrowser.SortType); // as well as a resort

  fInitThumbs.clear;

  fBrowser.CalcLayout(fBrowser.SampleThumb); // do not remove this

  fBrowser.RefreshDisplay;
  // finally we refresh current thumbs on screen (later they will be filled with pics by the Loader)

  if assigned(fOnDebug) then
    fOnDebug(self);
  if assigned(fOnInitialized) then
    fOnInitialized(self);
end;

procedure TThumbsLoader.DOOnBeforeTerminate;
begin
  if not assigned(fBrowser) then
    EXIT;

  fBrowser.FireOnFinishLoading;
end;

procedure TThumbsLoader.CheckAllExplored;
var
  I: integer;
  athumb: TThumbEx;

  bAll: boolean;
begin

  bAll := true;

  for I := 0 to fAllThumbs.Count - 1 do
  begin
    athumb := TThumbEx(fAllThumbs[I]);
    // if (aThumb.ExploringStatus = thbNotExplored) then
    if (athumb.ExploringStatus <> thbExplored) then
    begin
      bAll := false;
      break;
    end;
  end;

  fAllExplored := bAll;

end;

{$IFDEF TB_PORTABLEDEVICE}

function TThumbsLoader.WPDThumb_Exists(WPDObj: TIEWPDObject): TTB_DB_ThumbExistResult;
var
  Props: TIEWPDObjectAdvancedProps;
  fname: string;
begin
  // TODO
  result.Index := -1;

  if fBrowser.WPD_GetAdvProps(WPDObj.ID, Props) then
  begin
    if WPDObj.ObjectType = iewFolder then
      fname := WPDObj.Path
    else
      fname := extractfilepath(WPDObj.Path) + extractfilename(WPDObj.FileName);

    result := FileThumb_Exists(fname, Props.DateModified, Props.SizeBytes, true);
    if result.Index <> -1 then
    begin
      if (assigned(result.MatchedThumb)) and (not TThumbEx(result.MatchedThumb).Source_IS_WPD) then
        result.Index := -1;
    end;
  end;

  if result.Index = -1 then
  begin
    result.MatchType := TERcdDoesntExist;
    result.MatchedThumb := nil;
  end;
end;
{$ENDIF}

function TThumbsLoader.FileThumb_Exists(FileName: string; filedate: Tdatetime; filesize: integer;
  const bPathWasPresent: boolean): TTB_DB_ThumbExistResult;
var
  athumb: TThumbEx;
begin
  result := FileThumb_Exists(FileName, bPathWasPresent);

  if result.MatchType = TERcdExists then
  begin
    athumb := TThumbEx(result.MatchedThumb);
    if abs(athumb.SourceFileDate - filedate) <= 0.0000000001 then
      result.MatchType := TERcdExists
    else
      result.MatchType := TERcdExistsOld;

    if (result.MatchType = TERcdExists) and (athumb.SourceFileSize <> filesize) then
      result.MatchType := TERcdDoesntExist; // shouldnt happen
  end;
end;

function TThumbsLoader.FileThumb_Exists(FileName: string; const bPathWasPresent: boolean): TTB_DB_ThumbExistResult;
begin
  // result.Index := fAllThumbs.IndexOf(filename);
  result.Index := -1;
  if bPathWasPresent then
    result.Index := fAllThumbs.IndexOf(FileName) // if path was present need to search in all thumbs
  else
    result.Index := fBrowser.fHiddenThumbs_NavMem.IndexOf(FileName); // else search only in navigation memory

  if result.Index = -1 then
  begin
    result.MatchType := TERcdDoesntExist;
    result.MatchedThumb := nil;
  end
  else
  begin
    result.MatchType := TERcdExists;
    result.MatchedThumb := fAllThumbs[result.Index];
  end;
end;

function TThumbsLoader.AppendThumb(sr: TSearchRec; thefolder_slashed: string): TThumbEx;
begin
  result := InsertThumb(-1, sr, thefolder_slashed);
end;

function TThumbsLoader.InsertThumb(position: integer; sr: TSearchRec; thefolder_slashed: string): TThumbEx;
var
  athumb: TThumbEx;
  bCancel: boolean;
begin
  result := nil;

  athumb := TThumbEx.Create(tborig_Auto, fBrowser.canvas, nil, false);
  athumb.Assign(fBrowser.SampleThumb);
  athumb.InitFromSearchRecord(sr, thefolder_slashed);

  if (athumb.SourceType = st_folderNav) then
    fBrowser.fNavigatorThumb := athumb;

  fBrowser.InitThumb(athumb);

  bCancel := false;
  if assigned(fBrowser.OnThumbCanAdd) then
    fBrowser.OnThumbCanAdd(athumb, bCancel);

  if bCancel then
    Freeandnil(athumb)
  else
  begin
    // fInitThumbs.Add(aThumb.SourceFileName, aThumb);
    fBrowser.Addthumb(athumb, athumb.SourceFileName, position);
    // -------------
    result := athumb;
    // -------------
    if assigned(fBrowser.OnThumbAdded) then
      fBrowser.OnThumbAdded(athumb, fBrowser.GetThumbIdx(athumb));
  end;
end;

function TThumbsLoader.ReplaceOldThumb(position: integer; sr: TSearchRec; thefolder_slashed: string): TThumbEx;
var
  olduniquename: string;
  athumb: TThumbEx;
begin
  result := nil;
  if position < 0 then
    EXIT;
  if position > fAllThumbs.Count - 1 then
    EXIT;

  athumb := TThumbEx(fAllThumbs[position]);

  // fInitThumbs.Add(aThumb.SourceFileName, aThumb);

  olduniquename := athumb.Unique_Name;
  athumb.InitFromSearchRecord(sr, thefolder_slashed);

{$IFDEF TB_USEDB}
  if fBrowser.DB.DBActive then
  begin
    fBrowser.DB.DeleteRcd(GUID_NULL, olduniquename);
  end;
{$ENDIF}
  // -------------
  result := athumb;
  // -------------
end;

{$IFDEF TB_PORTABLEDEVICE}

function TThumbsLoader.AppendThumb(WPDObj: TIEWPDObject): TThumbEx;
begin
  result := InsertThumb(-1, WPDObj);
end;

function TThumbsLoader.InsertThumb(position: integer; WPDObj: TIEWPDObject): TThumbEx;
var
  athumb: TThumbEx;
  bCancel: boolean;
begin
  result := nil;

  athumb := TThumbEx.Create(tborig_Auto, fBrowser.canvas, nil, false);
  athumb.Assign(fBrowser.SampleThumb);
  athumb.InitFromWPD(fBrowser.WPD, fBrowser.WPD.ActiveDeviceID, WPDObj);

  fBrowser.InitThumb(athumb);

  bCancel := false;
  if assigned(fBrowser.OnThumbCanAdd) then
    fBrowser.OnThumbCanAdd(athumb, bCancel);

  if bCancel then
    Freeandnil(athumb)
  else
  begin
    // fInitThumbs.Add(aThumb.SourceFileName, aThumb);
    fBrowser.Addthumb(athumb, athumb.SourceFileName, position);

    // -------------
    result := athumb;
    // -------------

    if assigned(fBrowser.OnThumbAdded) then
      fBrowser.OnThumbAdded(athumb, fBrowser.GetThumbIdx(athumb));
  end;
end;

function TThumbsLoader.ReplaceOldThumb(position: integer; WPDObj: TIEWPDObject): TThumbEx;
var
  olduniquename: string;
  athumb: TThumbEx;
begin
  result := nil;

  if position < 0 then
    EXIT;
  if position > fAllThumbs.Count - 1 then
    EXIT;

  athumb := TThumbEx(fAllThumbs[position]);

  // fInitThumbs.Add(aThumb.SourceFileName, aThumb);

  olduniquename := athumb.Unique_Name;
  athumb.InitFromWPD(fBrowser.WPD, fBrowser.WPD.ActiveDeviceID, WPDObj);

  // -------------
  result := athumb;
  // -------------
end;
{$ENDIF}

function TThumbsLoader.FindNextVisibleNotLoaded(Idx: integer; const bAllowRewind: boolean): integer;
const
  bRewinding: boolean = false; // rewritable constant
var
  Counter: integer;
begin
  if (Idx < 0) then
  begin
    result := -1;
    EXIT;
  end;

  Counter := 0;

  while (Idx + Counter < fBrowser.ThumbsCount) and
    (fBrowser.Thumbat(Idx + Counter).ExploringStatus <> thbNotExplored) do
  begin
    inc(Counter);
  end;
  if (Idx + Counter >= fBrowser.ThumbsCount) then
    result := -1
  else
    result := Idx + Counter;

  if (result = -1) then
  begin
    if bAllowRewind and (not bRewinding) then
    begin
      bRewinding := true;
      result := FindNextVisibleNotLoaded(0, true);
    end;
  end;

end;

procedure TThumbsLoader.GetSuggestedCurrent;
var
  topIdx, bottomIdx: integer;
  // lookahead, speedBrowsing, speedLoading: double;
begin
  if fBrowser.ThumbsCount_Total = 0 then
    fSuggestionInterval := 50
  else
    fSuggestionInterval := max(20, 50 * round(fBrowser.ThumbsCount / fBrowser.ThumbsCount_Total));

  topIdx := fBrowser.TopDisplayedThumbIdx; // then start from top row
  bottomIdx := fBrowser.BottomDisplayedThumbIdx;

  {
    if (fBrowser.TopDisplayedThumbIdx <= flastTop)  then    //if the top row was not advanced by the user scrolling the display
    begin
    topIdx := fBrowser.TopDisplayedThumbIdx;   //then start from top row
    bottomIdx := fBrowser.BottomDisplayedThumbIdx;
    end
    else
    begin  //looking a little ahead
    speedBrowsing :=  (fBrowser.TopDisplayedThumbIdx - fLastTop)/ max(1, (fBrowser.BottomDisplayedThumbIdx - fBrowser.TopDisplayedThumbIdx));
    speedLoading :=   fSuggestionInterval /  max(1, (GetTickCount - fSuggestTikCount));
    lookahead := max(0, min(2, speedBrowsing - speedLoading));
    topIdx := fBrowser.TopDisplayedThumbIdx + round(0.5 * lookahead * (fBrowser.BottomDisplayedThumbIdx - fBrowser.TopDisplayedThumbIdx));
    bottomIdx := fBrowser.BottomDisplayedThumbIdx+ round(lookahead * (fBrowser.BottomDisplayedThumbIdx - fBrowser.TopDisplayedThumbIdx));
    end;
  }

  fsuggestedcurrent := GetSuggestedCurrentFromVisibleRange(fcurrent, topIdx, bottomIdx);
  // -------------------------------------------
  fSuggestTikCount := gettickcount;
  // -------------------------------------------

  fLastTop := fBrowser.TopDisplayedThumbIdx;
end;

function TThumbsLoader.GetSuggestedCurrentFromVisibleRange(defaultValue: integer; topIdx, bottomIdx: integer): integer;
var
  curr_idx: integer;
  nextNotLoaded: integer;

  bNewSuggestion: boolean;
  bAllVisibleExplored: boolean;
  bAllowRewind: boolean;
begin
  result := defaultValue;

  topIdx := max(0, topIdx);
  bottomIdx := min(fBrowser.ThumbsCount - 1, bottomIdx);
  bNewSuggestion := false;
  bAllVisibleExplored := fVisibleExploredCtr_Last < fBrowser.ThumbsCount;

  bAllowRewind := not bAllVisibleExplored;
  // if not all visible thumbs are explored then rewind is set to true

  curr_idx := fBrowser.GetVisibleThumbIdxfromThumbID(fcurrent);
  if curr_idx = -1 then // case the current thumb is invisible
  begin
    nextNotLoaded := FindNextVisibleNotLoaded(topIdx, bAllowRewind);
    if (nextNotLoaded >= topIdx) and (nextNotLoaded <= bottomIdx) then
      bNewSuggestion := true;
  end
  else
  begin // case the current thumb is visible
    nextNotLoaded := FindNextVisibleNotLoaded(curr_idx, bAllowRewind);
    if (nextNotLoaded >= topIdx) and (nextNotLoaded <= bottomIdx) then
      bNewSuggestion := true
    else
    begin
      nextNotLoaded := FindNextVisibleNotLoaded(topIdx, bAllowRewind);
      if (nextNotLoaded >= topIdx) and (nextNotLoaded <= bottomIdx) then
        bNewSuggestion := true;
    end;
  end;

  bNewSuggestion := bNewSuggestion or ((nextNotLoaded <> -1) and (not bAllVisibleExplored));
  // when visible thumbs not all explored take the suggestion anyway

  if bNewSuggestion then
    result := fBrowser.GetThumbIDfromVisibleThumbIdx(nextNotLoaded);

end;

procedure TThumbsLoader.CurrentThumb_Explore;
var
  athumb: TThumbEx;
begin

  if fcurrent < fAllThumbs.Count then
  begin
    athumb := TThumbEx(fAllThumbs[fcurrent]);
    fCurrentLoadedThumb.ThumbTag := fcurrent; // identifies the index of the thumb
    fCurrentLoadedThumb.ExploringStatus := athumb.ExploringStatus;

    if fCurrentLoadedThumb.ExploringStatus = thbNotExplored then
    begin
      fCurrentLoadedThumb.Assign(athumb); // here get current thumb

      fCurrentLoadedThumb.UniqueID := athumb.UniqueID;
      // assign the same uniqueId to match the original thumb when the thumb is loaded
    end;

  end;
end;

procedure TThumbsLoader.CurrentThumb_Set;
begin
  Thumb_Set(fCurrentLoadedThumb, fCurrentLoadedThumb.ThumbTag);
end;

procedure TThumbsLoader.ClearThumbsToExplore(StatusesToClear: TTB_Thumb_ExploringStatuses);
var
  I: integer;
  athumb: TThumbEx;
begin
  for I := fThumbsToExplore.Count - 1 downto 0 do
  begin
    athumb := TThumbEx(fThumbsToExplore[I]);
    if athumb = nil then
      fThumbsToExplore.Delete(I) // thumb is nil
    else
    begin
      if (StatusesToClear = []) or (athumb.ExploringStatus in StatusesToClear) then
      begin
        fThumbsToExplore.Delete(I);
        Freeandnil(athumb);
      end;
    end;
  end;
end;

procedure TThumbsLoader.ExpectLeaksThumbsToExplore;
var
  I: integer;
  athumb: TThumbEx;
begin
  for I := fThumbsToExplore.Count - 1 downto 0 do
  begin
    athumb := TThumbEx(fThumbsToExplore[I]);
    if athumb <> nil then
      RegisterExpectedMemoryLeak(athumb);
  end;
end;

procedure TThumbsLoader.FillThumbsToExplore;
  function ThumbAlreadyAdded(athumb: TThumbEx): boolean;
  var
    I: integer;
  begin
    result := false;
    for I := 0 to fThumbsToExplore.Count - 1 do
    begin
      if (assigned(TThumbEx(fThumbsToExplore[I]))) and
        IsEqualGuid(athumb.UniqueID, TThumbEx(fThumbsToExplore[I]).UniqueID) then
      begin
        result := true;
        break;
      end;
    end;
  end;

  function CheckAddVisibleThumbToExplore(theIdx: integer; var ictr: integer): boolean;
  var
    srcThumb, athumb: TThumbEx;
  begin
    result := false;

    srcThumb := fBrowser.Thumbat(theIdx);
    if not assigned(srcThumb) then
      EXIT;

    if ((srcThumb.SourceType <> st_General) and (not(srcThumb.SourceType in TBGetSourceTypes_Loadable))) then
    begin
      srcThumb.ExploringStatus := thbExplored;
      EXIT;
    end;

    if (srcThumb.ExploringStatus = thbNotExplored) and (not ThumbAlreadyAdded(srcThumb)) then
    // add only if not explored yet
    begin
      athumb := TThumbEx.Create(tborig_Auto, fBrowser.canvas, nil, true);
      athumb.Assign(srcThumb);
      srcThumb.ExploringStatus := thbExploreInProcess;
      // aThumb.ExploringStatus := thbExploreInProcess;  //this will be done when thread is launched
      athumb.UniqueID := srcThumb.UniqueID;
      athumb.ThumbTag := fBrowser.GetThumbIDfromVisibleThumbIdx(theIdx);
      fThumbsToExplore.Add(athumb);
      inc(ictr);
      result := true;
    end;
  end;

  function CheckAddThumbToExplore(theId: integer; var ictr: integer): boolean;
  var
    srcThumb, athumb: TThumbEx;
  begin
    result := false;
    if theId = -1 then
      EXIT;

    srcThumb := TThumbEx(fAllThumbs[theId]);

    if (srcThumb.ExploringStatus <> thbExplored) then
    begin
      if ((srcThumb.SourceType <> st_General) and (not(srcThumb.SourceType in TBGetSourceTypes_Loadable))) then
      begin
        srcThumb.ExploringStatus := thbExplored;
        EXIT;
      end;
    end;

    if (srcThumb.ExploringStatus = thbNotExplored) and (not ThumbAlreadyAdded(srcThumb)) then
    // add only if not explored yet
    begin
      athumb := TThumbEx.Create(tborig_Auto, fBrowser.canvas, nil, true);
      athumb.Assign(srcThumb);
      srcThumb.ExploringStatus := thbExploreInProcess;
      // aThumb.ExploringStatus := thbExploreInProcess; // this will be done when thread is launched
      athumb.UniqueID := srcThumb.UniqueID;
      athumb.ThumbTag := theId;
      fThumbsToExplore.Add(athumb);
      inc(ictr);
      result := true;
    end;
  end;

var
  ictr: integer;
  newCurrent: integer;
  curVisible: integer;
  topIdx, bottomIdx: integer;
  deltath: integer;
begin
  // ------------
  ictr := 0;
  // ------------

  ClearThumbsToExplore([thbExplored]);

  deltath := fBrowser.BottomDisplayedThumbIdx - fBrowser.TopDisplayedThumbIdx;
  if fBrowser.TopDisplayedThumbIdx > fLastTop + deltath then
  begin
    topIdx := fBrowser.TopDisplayedThumbIdx + deltath div 2; // then start from top row
    bottomIdx := fBrowser.BottomDisplayedThumbIdx + deltath div 2;
  end
  else if fBrowser.TopDisplayedThumbIdx < fLastTop - deltath then
  begin
    topIdx := fBrowser.TopDisplayedThumbIdx - deltath div 2; // then start from top row
    bottomIdx := fBrowser.BottomDisplayedThumbIdx - deltath div 2;
  end
  else
  begin
    topIdx := fBrowser.TopDisplayedThumbIdx; // then start from top row
    bottomIdx := fBrowser.BottomDisplayedThumbIdx;
  end;

  topIdx := max(0, topIdx);
  bottomIdx := min(fBrowser.ThumbsCount - 1, bottomIdx);

  fLastTop := fBrowser.TopDisplayedThumbIdx;

  fsuggestedcurrent := GetSuggestedCurrentFromVisibleRange(fcurrent, topIdx, bottomIdx);
  fcurrent := fsuggestedcurrent;

  newCurrent := fcurrent;
  curVisible := fBrowser.GetVisibleThumbIdxfromThumbID(newCurrent);

  // check visible
  if fBrowser.ThumbsCount > 0 then
  begin
    while (ictr <= fDynThreadPool_count) and (curVisible < fBrowser.ThumbsCount) do
    begin
      // --------------------------------------
      CheckAddVisibleThumbToExplore(curVisible, ictr);
      inc(curVisible);
      // --------------------------------------
    end;

    if ictr > 0 then // if at least one was added
    begin
      curVisible := curVisible - 1; // go back one
      newCurrent := fBrowser.GetThumbIDfromVisibleThumbIdx(curVisible);
      if (newCurrent < 0) then
        newCurrent := 0;

      fcurrent := newCurrent;
    end;

    if ictr = fDynThreadPool_count then
      EXIT; // >>>>EXIT
  end;

  // check invisible

  if fAllThumbs.Count > 0 then
  begin
    while (ictr <= fDynThreadPool_count) and (newCurrent < fAllThumbs.Count) do
    // add  fDynThreadPool_count thumbs to be explored
    // or less number if exceeds the end of original thumbs list
    begin
      CheckAddThumbToExplore(newCurrent, ictr); // newCurrent incremented inside
      inc(newCurrent);
    end;

    if (newCurrent < 0) or (newCurrent >= fAllThumbs.Count) then
      newCurrent := fAllThumbs.Count - 1;

    fcurrent := newCurrent;
  end;

end;

function TThumbsLoader.GetOptimalThreadPriority(ctr: integer; theThumb: TThumbEx): TThreadPriority;
var
  timeoutF, multThreadCount1, multThreadCount2, multCtr1, multCtr2: single;
begin
  if (not theThumb.Visible) then
  begin
    multThreadCount1 := 2;
    multCtr1 := 0.2;
    multThreadCount2 := 3;
    multCtr2 := 0.5;
  end
  else if (theThumb.SourceType = st_Folder) or (theThumb.SourceType = st_folderNav) or
    (theThumb.SourceType = st_WPDFolder) or (theThumb.SourceType = st_WPDFolderNav) then
  begin
    multThreadCount1 := 7;
    multCtr1 := 1;
    multThreadCount2 := 7;
    multCtr2 := 1;
  end
  else if (theThumb.SourceType = st_File) then
  begin
    if (tbs_FileExtIsJPG(theThumb.SourceFileExtension)) then
    begin
      multThreadCount1 := 6;
      multCtr1 := 1;
      multThreadCount2 := 6;
      multCtr2 := 1;
    end
    else if (tbs_FileExtIsRAW(theThumb.SourceFileExtension)) then
    begin
      multThreadCount1 := 3;
      multCtr1 := 0.4;
      multThreadCount2 := 4;
      multCtr2 := 0.65;
    end
    else if (tbs_FileExtIsVIDEO(theThumb.SourceFileExtension)) then
    begin
      multThreadCount1 := 3;
      multCtr1 := 0.4;
      multThreadCount2 := 5;
      multCtr2 := 0.75;
    end
    else if (theThumb.searchrec.size > 3000000) then // 3mb circa
    begin
      multThreadCount1 := 4;
      multCtr1 := 0.8;
      multThreadCount2 := 6;
      multCtr2 := 1;
    end
    else
    begin // all other cases fall back here
      multThreadCount1 := 3.5;
      multCtr1 := 0.8;
      multThreadCount2 := 7;
      multCtr2 := 1;
    end;
  end
  else if (theThumb.SourceType = st_URL) then
  begin
    multThreadCount1 := 4;
    multCtr1 := 0.8;
    multThreadCount2 := 7;
    multCtr2 := 1;
  end
  else if (theThumb.SourceType = st_General) then
  begin
    multThreadCount1 := 6;
    multCtr1 := 1;
    multThreadCount2 := 6;
    multCtr2 := 1;
  end
  else
  begin // all other cases fall back here
    multThreadCount1 := 3.5;
    multCtr1 := 1;
    multThreadCount2 := 7;
    multCtr2 := 1;
  end;

  timeoutF := min(4, max(1, fThreadTimeout / (200 * fThreadPool_count))); // fThreadPool_count is always >= 1

  multCtr1 := multCtr1 + timeoutF / 4 * 0.25;
  multCtr2 := multCtr2 + timeoutF / 4 * 0.25;

  if (fLastThreadCount > multThreadCount2 * fThreadPool_count) or (ctr > multCtr2 * fDynThreadPool_count) then
    result := tpLowest
  else if (fLastThreadCount > multThreadCount1 * fThreadPool_count) or (ctr > multCtr1 * fDynThreadPool_count) then
    result := tpLower
  else
    result := tpNormal;

end;

procedure TThumbsLoader.ExploredThumbs_CreateThreads;
var
  I: integer;
  athumb: TThumbEx;
  aThread: TThumbsBrowser_Thumb_LoadThread;
  ctr: integer;
begin

  fNewThreads.clear;

  ctr := 0;
  for I := 0 to fThumbsToExplore.Count - 1 do
  begin
    athumb := TThumbEx(fThumbsToExplore[I]);
    if assigned(athumb) and (athumb.ExploringStatus = thbNotExplored) then
    begin
      inc(ctr);
      athumb.ExploringStatus := thbExploreInProcess;
      aThread := TThumbsBrowser_Thumb_LoadThread.Create;
      aThread.priority := GetOptimalThreadPriority(ctr, athumb);

{$IFDEF TB_USEDB}
      aThread.Init(fBrowser.DB.DBActive, fBrowser.DB.DBActive, athumb.SourceFileName, athumb, self,
        Handle_ThumbThread_Done, TBCriticalSection, TBDatabaseCriticalSection, fBrowser.fDB, fDBSessionGuid, fCleanupCS,
        TBEvent, TBEventCounter, fBrowser.GetReaderFunction(extractfileext(athumb.SourceFileName)),
        fThumbLoadDemandAsyncHandler);

{$ELSE}
      aThread.Init(athumb.SourceFileName, athumb, self, Handle_ThumbThread_Done, TBCriticalSection, fCleanupCS, TBEvent,
        TBEventCounter, fBrowser.GetReaderFunction(extractfileext(athumb.SourceFileName)),
        fThumbLoadDemandAsyncHandler);
{$ENDIF}
      fNewThreads.Add(aThread);
    end;
  end;

end;

procedure TThumbsLoader.ExploredThumbs_LaunchThreads;
var
  I: integer;
  aThread: TThumbsBrowser_Thumb_LoadThread;
begin

  // TBEvent.ResetEvent;    //this is done by every new thread when its launched
  for I := 0 to fNewThreads.Count - 1 do
  begin
    aThread := TThumbsBrowser_Thumb_LoadThread(fNewThreads[I]);
    if assigned(aThread) then
    begin
      AddThread(aThread);
      aThread.Launch;
    end;
  end;
end;

function TThumbsLoader.ClearDoneThumbs: boolean;
var
  mylist: TList;
begin
  result := false;
  mylist := fDoneThumbs.LockList;
  try
    mylist.clear;
    result := true;
  finally
    fDoneThumbs.unlocklist;
  end;
end;

function TThumbsLoader.AddDoneThumb(theThumb: TThumbEx): boolean;
var
  mylist: TList;
begin
  result := false;
  mylist := fDoneThumbs.LockList;
  try
    assert(assigned(theThumb));
    if Terminated then
      theThumb.ExploringStatus := thbExplored;
    mylist.Add(theThumb);
    result := true;
  finally
    fDoneThumbs.unlocklist;
  end;
end;

function TThumbsLoader.CheckDoneThumbsCount: integer;
var
  mylist: TList;
begin
  mylist := fDoneThumbs.LockList;
  try
    result := mylist.Count;
  finally
    fDoneThumbs.unlocklist;
  end;
end;

function TThumbsLoader.RemoveThread(theThread: TThread): boolean;
var
  mylist: TList;
begin
  result := false;

  mylist := fThreads.LockList;
  try
    if mylist.IndexOf(theThread) <> -1 then
    begin
      mylist.remove(theThread);
      result := true;
    end;
  finally
    fThreads.unlocklist;
  end;
end;

function TThumbsLoader.AddThread(theThread: TThread): boolean;
var
  mylist: TList;
begin
  result := false;
  mylist := fThreads.LockList;
  try
    mylist.Add(theThread);
    result := true;
  finally
    fThreads.unlocklist;
  end;
end;

function TThumbsLoader.CheckThreadsCount: integer;
var
  mylist: TList;
begin
  mylist := fThreads.LockList;
  try
    result := mylist.Count;
  finally
    fThreads.unlocklist;
  end;
end;

procedure TThumbsLoader.AbortThreads;
var
  mylist: TList;
  I: integer;
begin
  mylist := fThreads.LockList;
  try
    for I := 0 to mylist.Count - 1 do
      if assigned(mylist[I]) then
      begin
        try
          TThumbsBrowser_Thumb_LoadThread(mylist[I]).Abort;
        except
          ;
        end;
      end;
  finally
    fThreads.unlocklist;
  end;
end;

procedure TThumbsLoader.ExploredThumbs_Set;
var
  I: integer;
  athumb: TThumbEx;
  mylist: TList;
  tempList: TList;
begin
  tempList := TList.Create;
  try
    mylist := fDoneThumbs.LockList;
    try
      for I := mylist.Count - 1 downto 0 do
      begin
        athumb := TThumbEx(mylist[I]);
        tempList.Add(athumb);
        mylist.Delete(I);
      end;
    finally
      fDoneThumbs.unlocklist;
    end;

    for I := 0 to tempList.Count - 1 do
    begin
      athumb := TThumbEx(tempList[I]);
      Thumb_Set(athumb, athumb.ThumbTag);
    end;

  finally
    tempList.Free;
  end;
end;

function TThumbsLoader.FindThumbByGUID(theGuid: TGuid): TThumbEx;
var
  I: integer;
begin
  result := nil;
  for I := 0 to fAllThumbs.Count - 1 do
    if IsEqualGuid(theGuid, fBrowser.Thumbat_AbsoluteIdx(I).UniqueID) then
    begin
      result := fBrowser.Thumbat_AbsoluteIdx(I);
      break;
    end;
end;

function TThumbsLoader.Thumb_Set(theThumb: TThumbEx; ID: integer): boolean;
var
  athumb: TThumbEx;
begin
  result := false;
  if not assigned(theThumb) then
    EXIT;

  theThumb.ExploringStatus := thbExplored;

  try
    if (ID < fAllThumbs.Count) then
    begin
      athumb := fBrowser.Thumbat_AbsoluteIdx(ID);

      if assigned(athumb) then
      begin
        if IsEqualGuid(athumb.UniqueID, theThumb.UniqueID) then // only if same unique ID
        begin
          if theThumb.Adjourned then    //do not remove this - useful for loadondemand to not trigger fOnThumbLoaded
          begin
            if athumb.SourceType = st_General then
              athumb.AssignInfo(theThumb, false)
            else
              athumb.AssignFileLoadingInfo(theThumb);

            athumb.ExploringStatus := thbExplored;

            result := true;

            if assigned(fOnThumbLoaded) then
              fOnThumbLoaded(self, ID);

            if athumb.Visible then
            begin
              inc(fVisibleExploredCtr);
              CheckAllVisibleThumbsLoaded;
            end;
          end
          else
          begin
            athumb.ExploringStatus := thbNotExplored;
          end;
        end
        else
        begin
          athumb := FindThumbByGUID(theThumb.UniqueID);
          if athumb <> nil then
            athumb.ExploringStatus := thbNotExplored;
        end;
      end;
    end;

  finally

  end;
end;

procedure TThumbsLoader.Thumb_ReadFromFile(theThumb: TThumbEx);
begin
  priority := fPriorityL;
  try

    if (theThumb.SourceType = st_General) and assigned(fThumbLoadDemandAsyncHandler) then
    begin
      fThumbLoadDemandAsyncHandler(self, theThumb);
    end
    else
    begin
      theThumb.RetrieveFromSourceFile_EX(theThumb.SourceFileName, fThumbReader, nil, false);

      // correct thumb orientation even in case there was no exif thumb
      if (theThumb.MetaOptions.UseExifOrientationForThumbs) then
        TBAdjustEXIFOrientation(theThumb.IEBitmap, theThumb.SourceEXIF_Orientation);
    end;

    sleep(0);  // I guess this is something useful
  finally
    priority := fPriorityN;
  end;

end;

procedure TThumbsLoader.Terminate(bFreeOnTerminate: boolean; bWaitAllCompleted: boolean);
begin
  freeonterminate := bFreeOnTerminate;
  fAllowSyncOnTerminate := bFreeOnTerminate;
  fWaitAllCompleted := bWaitAllCompleted;

  inherited Terminate;
end;

function TThumbsLoader.Thumb_CheckRead_FromDB(theThumb: TThumbEx): TTB_DB_ThumbExistResult;
begin
  result.Index := -1;
  result.MatchedThumb := theThumb; // no thumb needs to be matched just a record in the db-table
  result.MatchType := TERcdDoesntExist;

  if theThumb.Source_IS_WPD then
  begin
    Thumb_ReadFromFile(theThumb);
    EXIT; // >>>EXIT
  end;

{$IFDEF TB_USEDB}
  TBDatabaseCriticalSection.Enter;
  try
    result := theThumb.ExistsinDB(nil, fBrowser.DB, fDBSessionGuid);
    case result.MatchType of
      TERcdExists:
        begin
          if not theThumb.RetrieveFromDB(nil, fBrowser.DB, fDBSessionGuid, false) then
          begin
            Thumb_ReadFromFile(theThumb);
            result.MatchType := TERcdExistsOld;
          end;
        end;
      TERcdExistsWithOldParams:
        begin
          if not theThumb.RetrieveFromDB(nil, fBrowser.DB, fDBSessionGuid, false) then
          begin
            Thumb_ReadFromFile(theThumb);
            result.MatchType := TERcdExistsOld;
          end
          else
            theThumb.RetrieveParamsfromSourceFile(theThumb.SourceFileName);
        end
    else
      begin
        Thumb_ReadFromFile(theThumb);
      end;
    end;
  finally
    TBDatabaseCriticalSection.Leave;
  end;
{$ENDIF}
end;

procedure TThumbsLoader.Thumb_CheckWrite_ToDB(theThumb: TThumbEx; ThumbExistResult: TTB_DB_ThumbExistResult);
begin
  if not theThumb.CanSaveToDB then
    EXIT;

{$IFDEF TB_USEDB}
  ThumbExistResult := theThumb.SaveToDB(TBDatabaseCriticalSection, fBrowser.DB, fDBSessionGuid, true);
{$ENDIF}
end;

procedure TThumbsLoader.CurrentThumb_ReadFromFile;
begin
  Thumb_ReadFromFile(fCurrentLoadedThumb);
end;

function TThumbsLoader.CurrentThumb_CheckRead_FromDB: TTB_DB_ThumbExistResult;
begin
  Thumb_CheckRead_FromDB(fCurrentLoadedThumb);
end;

procedure TThumbsLoader.CurrentThumb_CheckWrite_ToDB(ThumbExistResult: TTB_DB_ThumbExistResult);
begin
  Thumb_CheckWrite_ToDB(fCurrentLoadedThumb, ThumbExistResult);
end;

procedure TThumbsLoader.CheckAllVisibleThumbsLoaded;
begin
  if fVisibleExploredCtr = fBrowser.ThumbsCount then // all visible thumbs were explored
  begin
    if fBrowser.ThumbsCount <> fVisibleExploredCtr_Last then
    begin
      fVisibleExploredCtr_Last := fVisibleExploredCtr;

      if assigned(fOnDebug) then
        fOnDebug(self);
      if assigned(fOnAllThumbsLoaded) then
        fOnAllThumbsLoaded(self);
    end;
  end;
end;

procedure TThumbsLoader.FireOnBeforeThumbLoaded;
begin
  if assigned(fOnDebug) then
    fOnDebug(self);
  if assigned(fOnBeforeThumbLoaded) then
    fOnBeforeThumbLoaded(self);
end;

{ TThumbsBrowser_DragDropOptions }

constructor TThumbsBrowser_DragDropOptions.Create(theChangeEventHandler: TNotifyEvent);
begin
  inherited Create;
  fRegisteredTargets := nil;
  FOnPropertyChanged := theChangeEventHandler;

  FIS_DragSource_TB := true;
  FIS_DragSource_Explorer := false;
  FIS_DropTarget_TB := true;
  FIS_DropTarget_Explorer := false;
  FTransferMode_TB := dd_DetectShiftState;
  FTransferMode_Exp := dd_Copy;
  fDropBehavior := ddb_Thumbs;
end;

destructor TThumbsBrowser_DragDropOptions.Destroy;
begin
  if assigned(fRegisteredTargets) then
    Freeandnil(fRegisteredTargets);
  inherited;
end;

function TThumbsBrowser_DragDropOptions.IsDDSource: boolean;
begin
  result := IS_DragSource_TB or IS_DragSource_Explorer;
end;

function TThumbsBrowser_DragDropOptions.IsRegistered(theCtrl: TControl): boolean;
begin
  result := assigned(fRegisteredTargets) and (fRegisteredTargets.IndexOf(theCtrl) <> -1);
end;

procedure TThumbsBrowser_DragDropOptions.RegisterTarget(theCtrl: TControl);
begin
  if not assigned(theCtrl) then
    EXIT;
  if IsRegistered(theCtrl) then
    EXIT;

  if fRegisteredTargets = nil then
    fRegisteredTargets := TList.Create;

  fRegisteredTargets.Add(theCtrl);
  FIS_DragSource_TB := true; // automatically set to true
end;

procedure TThumbsBrowser_DragDropOptions.UnRegisterTarget(theCtrl: TControl);
begin
  if fRegisteredTargets = nil then
    EXIT;

  fRegisteredTargets.remove(theCtrl);
end;

procedure TThumbsBrowser_DragDropOptions.SetIS_DropTarget_Explorer(const Value: boolean);
begin
  FIS_DropTarget_Explorer := Value;
  if assigned(FOnPropertyChanged) then
    FOnPropertyChanged(self);
end;

{ TTBVisibleThumbsList }

function TTBVisibleThumbsList.Add(Item: Pointer): integer;
begin
  if Item = nil then
  begin
    result := -1;
    EXIT;
  end;
  result := inherited Add(Item);
  TThumbEx(Item).LastVisibleIdx := result;
end;

procedure TTBVisibleThumbsList.Insert(Index: integer; Item: Pointer);
begin
  if Item = nil then
    EXIT;

  inherited Insert(Index, Item);
  TThumbEx(Item).LastVisibleIdx := Index;
end;

function TTBVisibleThumbsList.IndexOf(Item: Pointer): integer;
begin
  if Item = nil then
  begin
    result := -1;
    EXIT;
  end;

  if (TThumbEx(Item).LastVisibleIdx >= 0) and (TThumbEx(Item).LastVisibleIdx < Count) then
  begin
    if TThumbEx(Item) = TThumbEx(items[TThumbEx(Item).LastVisibleIdx]) then
      result := TThumbEx(Item).LastVisibleIdx
    else
    begin
      result := inherited IndexOf(Item);
      TThumbEx(Item).LastVisibleIdx := result; // set it back to thumb for next search
    end;
  end
  else
  begin
    result := inherited IndexOf(Item);
    TThumbEx(Item).LastVisibleIdx := result; // set it back to thumb for next search
  end;
end;

{ TTBThumbsList }

function TTBThumbsList.Add(Item: Pointer): integer;
begin
  if Item = nil then
  begin
    result := -1;
    EXIT;
  end;

  result := inherited Add(Item);
  TThumbEx(Item).ThumbTag := result;
end;

function TTBThumbsList.Add(AKey: String; Item: Pointer): integer;
begin
  result := inherited Add(AKey, Item);
  TThumbEx(Item).ThumbTag := result;
end;

procedure TTBThumbsList.Insert(Index: integer; Item: Pointer);
begin
  if Item = nil then
    EXIT;

  inherited Insert(Index, Item);
  TThumbEx(Item).ThumbTag := Index;
end;

function TTBThumbsList.IndexOf(Item: Pointer): integer;
begin
  if Item = nil then
  begin
    result := -1;
    EXIT;
  end;

  if (TThumbEx(Item).ThumbTag >= 0) and (TThumbEx(Item).ThumbTag < Count) then
  begin
    if TThumbEx(Item) = TThumbEx(items[TThumbEx(Item).ThumbTag]) then
      result := TThumbEx(Item).ThumbTag
    else
    begin
      result := inherited IndexOf(Item);
      TThumbEx(Item).ThumbTag := result; // set it back to thumb for next search
    end;
  end
  else
  begin
    result := inherited IndexOf(Item);
    TThumbEx(Item).ThumbTag := result; // set it back to thumb for next search
  end;
end;

Initialization

SharedDragDrop_Handler := TThumbsBrowser_DragDropHandler.Create;

{$IFDEF TB_FOLDERMONITOR}
SharedFolderMonitor := TThumbsBrowser_FolderMonitor.Create;
{$ENDIF}
{$IFDEF TB_GDIPLUS}
{$IFNDEF IMAGEEN_8_1_0_LATER}
if GDIPLUS_Available then
  GDIPLUS_LoadLibrary;
  {$ENDIF}
{$ENDIF}

Finalization

{$IFDEF TB_FOLDERMONITOR}
  Freeandnil(SharedFolderMonitor);
{$ENDIF}
Freeandnil(SharedDragDrop_Handler);

{$IFDEF TB_GDIPLUS}
{$IFNDEF IMAGEEN_8_1_0_LATER}
if GDIPLUS_Available then
  GDIPLUS_UnLoadLibrary;
  {$ENDIF}
{$ENDIF}

end.
