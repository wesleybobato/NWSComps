unit NWSComps_ThumbsBrowser_IEWrapper;

interface

(*

    /////////////////////
    // P U B L I C

    procedure Clear;
    procedure PaintTo(DestBitmap: TBitmap); virtual;
    procedure PaintToCanvas(DestCanvas: TCanvas); virtual;

    property SoftShadow: TIEVSoftShadow read fSoftShadow;

    property GradientEndColor: TColor read fGradientEndColor write SetGradientEndColor;

    property ThumbsRounded: Integer read fThumbsRounded write fThumbsRounded;


    procedure SetPresetThumbnailFrame(PresetIndex: Integer; UnSelectedColor: TColor; SelectedColor: TColor);


    property ThumbnailFrame: TIEBitmap read fThumbnailFrame write fThumbnailFrame;
    property ThumbnailFrameSelected: <A TIEBitmap>;

    procedure FillFromDirectory(const Directory: WideString; Limit : integer = -1; AllowUnknownFormats : boolean = false; const ExcludeExtensions : WideString = '';
                                DetectFileFormat : boolean = false; const FilterMask : WideString = ''; IncludeVideoFiles : Boolean = False;
                                LoadOnDemand : boolean = true;
                                DefaultTopText : TIEImageEnMViewDefaultText = iedtNone;
                                DefaultInfoText : TIEImageEnMViewDefaultText = iedtNone;
                                DefaultBottomText : TIEImageEnMViewDefaultText = iedtFilename;
                                bShowHiddenFiles : Boolean = False;
                                bShowFolders : Boolean = False);

    property EnableAdjustOrientation: Boolean read fEnableAdjustOrientation write fEnableAdjustOrientation;

    // images
    property ImageCount: integer read GetImageCount;
    property ImageWidth[idx: integer]: integer read GetImageWidth;
    property ImageHeight[idx: integer]: integer read GetImageHeight;
    property ImageOriginalWidth[idx: integer]: integer read GetImageOriginalWidth write SetImageOriginalWidth;
    property ImageOriginalHeight[idx: integer]: integer read GetImageOriginalHeight write SetImageOriginalHeight;
    property ImageX[idx: integer]: integer read GetImageX;
    property ImageY[idx: integer]: integer read GetImageY;
    property ImageRow[idx: integer]: integer read GetImageRow;
    property ImageCol[idx: integer]: integer read GetImageCol;
    property ImageFileName[idx: integer]: WideString read GetImageFileName write SetImageFileName;
    property ImageID[idx: integer]: integer read GetImageID write SetImageID;
    property ImageTag[idx: integer]: integer read GetImageTag write SetImageTag;
    property ImageUserPointer[idx: Integer]:pointer read GetImageUserPointer write SetImageUserPointer;
    property ImageBackground[idx: integer]: TColor read GetImageBackground write SetImageBackground;
    property ImageDelayTime[idx: integer]: Double read GetImageDelayTime write SetimageDelayTime;
    property ImageCreateDate[idx: Integer]:TDateTime read GetImageCreateDate write SetImageCreateDate;
    property ImageEditDate[idx: integer]: TDateTime read GetImageEditDate write SetImageEditDate;
    property ImageFileSize[idx: integer]: Int64 read GetImageFileSize write SetImageFileSize;
    property ImageTopText[idx: integer]: TIEMText read GetImageTopText;
    property ImageBottomText[idx: integer]: TIEMText read GetImageBottomText;
    property ImageInfoText[idx: integer]: TIEMText read GetImageInfoText;

    procedure UpdateImage(idx: integer);
    procedure ReloadImage(idx: Integer);

    function AppendImage(): integer; overload;
    function AppendImage(Stream: TStream): integer; overload;
    function AppendImage(Bitmap: TIEBitmap): integer; overload;
    function AppendImage(Bitmap : TBitmap): integer; overload;
    function AppendImage(Width,Height: Integer; PixelFormat: TIEPixelFormat = ie24RGB): Integer; overload;
    function AppendImage(const FileName: String): integer; overload;
    function AppendImage(const FileName: String;
                         LoadOnDemand : boolean;
                         DefaultTopText : TIEImageEnMViewDefaultText = iedtNone;
                         DefaultInfoText : TIEImageEnMViewDefaultText = iedtNone;
                         DefaultBottomText : TIEImageEnMViewDefaultText = iedtFilename;
                         bSelectIt : Boolean = true): integer; overload;

    procedure InsertImage(Idx : integer); overload;
    procedure InsertImage(Idx : integer; Stream : TStream); overload;
    procedure InsertImage(Idx : integer; Bitmap : TIEBitmap); overload;
    procedure InsertImage(Idx : integer; Bitmap : TBitmap); overload;
    procedure InsertImage(Idx : integer; Width, Height : integer; PixelFormat : TIEPixelFormat = ie24RGB); overload;
    procedure InsertImage(Idx : integer; const FileName : string); overload;
    procedure InsertImage(Idx : integer; const FileName : string;
                          LoadOnDemand : boolean;
                          DefaultTopText : TIEImageEnMViewDefaultText = iedtNone;
                          DefaultInfoText : TIEImageEnMViewDefaultText = iedtNone;
                          DefaultBottomText : TIEImageEnMViewDefaultText = iedtFilename;
                          bSelectIt : Boolean = true); overload;

    procedure MoveImage(idx: integer; destination: integer);
    procedure MoveSelectedImagesTo(beforeImage: Integer);
    procedure Sort(Compare: TIEImageEnMViewSortCompare); overload;
    procedure Sort(Compare: TIEImageEnMViewSortCompareEx); overload;
    procedure Sort(OrderBy: TIEImageEnMViewSortBy; Ascending: boolean = true; CaseSensitive: boolean = true); overload;


    procedure DeleteImage(idx: integer);
    procedure DeleteSelectedImages;

    procedure SetImage(idx: integer; srcImage: TBitmap); overload;
    procedure SetImage(idx: Integer; width, height: Integer; PixelFormat: TIEPixelFormat); overload;
    procedure SetIEBitmap(idx: integer; srcImage: TIEBaseBitmap);
    function SetImageFromFile(idx: integer; const FileName: WideString; SourceImageIndex: Integer = 0): boolean;
    function SetImageFromStream(idx: integer; Stream: TStream; SourceImageIndex: Integer = 0): boolean;
    procedure GetImageToFile(idx: Integer; const FileName: WideString);
    procedure GetImageToStream(idx: Integer; Stream: TStream; ImageFormat:TIOFileType);

    procedure CopyToIEBitmap(idx: integer; bmp: TIEBitmap);
    function GetBitmap(idx: integer): TBitmap;
    function GetTIEBitmap(idx: integer): TIEBitmap;
    function GetImageVisibility(idx: integer): integer;
    function ImageAtPos(x, y: integer; checkBounds: Boolean = true): integer;
    function ImageAtGridPos(row, col: integer): integer;


    property SelectedImage: integer read fSelectedItem write SetSelectedItem;
    procedure DeSelect;


    property MultiSelectedImages[index: integer]: integer read GetMultiSelectedImages;
    property MultiSelectedImagesCount: integer read GetMultiSelectedImagesCount;
    procedure MultiSelectSortList;
    procedure UnSelectImage(idx: integer);
    procedure ToggleSelectImage(idx: integer);
    procedure SelectImage(idx: integer);
    procedure SelectAll;

    function IsSelected(idx: integer): boolean;

     // Checkboxes
    function CheckedCount : Integer;
    property Checked[index: integer]: Boolean read GetChecked write SetChecked;
    procedure SetCheckboxParams(iHorzMargin, iVertMargin : Integer; CustomCheckedImage : TBitmap = nil; CustomUncheckedImage : TBitmap = nil);
    procedure CheckAll;
    procedure UncheckAll;


    // input&output
    procedure SaveSnapshot(Stream: TStream; SaveCache: Boolean = True; Compressed: Boolean = False; SaveParams: Boolean = False); overload; virtual;
    procedure SaveSnapshot(FileName: WideString; SaveCache: Boolean = True; Compressed: Boolean = False; SaveParams: Boolean = False); overload; virtual;
    procedure SaveSnapshotEx(Stream: TStream; SaveCache: Boolean; Compressed: Boolean; SaveParams: Boolean; GetExtraParams: TIEProcessStreamEvent);
    function LoadSnapshot(Stream: TStream): Boolean; overload; virtual;
    function LoadSnapshot(FileName: WideString): Boolean; overload; virtual;
    function LoadSnapshotEx(Stream: TStream; SetExtraParams: TIEProcessStreamEvent): Boolean;

{!!
<FS>TImageEnMView.MIO

<FM>Declaration<FC>
property MIO: <A TImageEnMIO>;

<FM>Description<FN>
The MIO property encapsulates the <A TImageEnMIO> component inside TImageEnMView (it is created automatically the first time that it is used).

<FM>Example<FC>
ImageEnMView1.MIO.LoadFromFile('C:\film.avi');

ImageEnMView1.MIO.Acquire;
!!}
    property MIO: TImageEnMIO read GetImageEnMIO;

{!!





*)
implementation

end.