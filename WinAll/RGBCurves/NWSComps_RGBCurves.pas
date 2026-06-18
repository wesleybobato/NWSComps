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
unit NWSComps_RGBCurves;
{$R-}
{$Q-}


// TRGBCurves

// Description:
// Component to edit RGB channels in 32, 24 bits TBitmap and in 24 bits TIEBitmap.
// The channels (R,G,B and Luminance) are manipulated using a "Curves" interface like the one in Photoshop

interface

{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_RGBCurves.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, math, inifiles, NWSComps_DataParser,
  NWSComps_RGBCurves_Const, NWSComps_RGBCurves_Types, NWSComps_RGBCurves_Math,
  NWSComps_RGBCurves_Reg, NWSComps_GdiPlus,
  imageenview, hyiedefs, hyieutils, {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps ,{$ENDIF}
 NWSComps_IEUtils_Previews;



type

  TRGBCurves = class(TCustomControl)
  private
    { Private declarations }
    fIEViewEventsHandler: TIEUtils_IEPreviewEventsHandler;

    fComplementaryCurves: boolean;
    fReadingFromFile: boolean;

    fUseGDIPlus: boolean;

    fLayout: TRGBCurves_Layout;
    fIO_Options: TRGBCurves_IO_Options;

    ffont: Tfont;

    fPointDetectTolerance: Cardinal;
    fCurveCoefs: TRGBCurves_DSplinevector;
    fInterpLinear_Min, fInterpLinear_Max: integer;

    fRGBSpace: TRGBCurves_RGBSpace;
    fCurveMode: TRGBCurves_mode;
    fChannelViewMode: TRGBCurves_Channel_ViewMode;
    fRGBmode: TRGBCurves_RGBmode;
    fEditMode: TRGBCurves_editmode;
    fColorSpaceMixAmount: integer;

    fOptions: TRGBCurves_Options;

    fShowHistogram: boolean;

    fHistogram: TRGBCurves_Histogram;
    fHistogramDisplayMode: TRGBCurves_HistogramDisplayMode;
    fHistogramRGBMode: TRGBCurves_HistogramRGBMode;
    fHistogramscaleMode: TRGBCurves_HistogramScaleMode;

    fFormulaCurve_Red, fFormulaCurve_Green, fFormulaCurve_Blue, fFormulaCurve_Lum: TRGBCurves_FormulaCurve;

    fpoints, fPoints_RGB, fPoints_RED, fPoints_GREEN, fPoints_BLUE: TRGBCurves_PointList;

    fxgap, fygap: integer;
    fXaxis, fYaxis: TRGBCurves_pointsarray;
    fstep: integer;
    fxratio, fyratio: single;

    fGraphBitmap: Tbitmap;

    fexportdirectory: string;
    fmaxfittingx, fminfittingx: integer;

    fOnchangeRGBMode: TnotifyEvent;
    fOnChangeCurve: TnotifyEvent;
    fOnPaint: TnotifyEvent;
    fOnMovePoint: TRGBCurves_MovePointEvent;
    fOnMovingPoint: TRGBCurves_MovingPointEvent;
    fOnAddPoint: TRGBCurves_Point_Event;
    fOnRemovePoint: TRGBCurves_Point_Event;
    fOnCustomDraw_Labels_HorzAxis: TRGBCurves_CustomDrawLabelEvent;
    fOnCustomDraw_Labels_VertAxis: TRGBCurves_CustomDrawLabelEvent;
    fOnCustomDraw_Point: TRGBCurves_CustomDrawPointEvent;
    fOnCustomDraw_MedianLine: TRGBCurves_CustomDrawMedianLine;
    fTransposeCurveOnComplementaryChanged: boolean;

    // Start  -------->******GETTERS*****************
    function GetVersion: string;
    function GetUSeFastPreview: boolean;
    function GetPreviewMode: TIEUtils_IEPreview_Mode;


    function GetOnIEView_BeforePreview: TNotifyEvent;
    function GetOnIEView_AfterPreview: TNotifyEvent;

    // End  <--------******GETTERS*****************

    // Start  -------->******SETTERS*****************
    procedure SetUseFastPreview(theValue: boolean);
    procedure SetPreviewMode(theValue: TIEUtils_IEPreview_Mode);


    procedure SetOnIEView_BeforePreview(thevalue: TNotifyEvent);
    procedure SetOnIEView_AfterPreview(thevalue: TNotifyEvent);

    function MouseOnGraphPoint(Graph_x, Graph_Y: double): integer;

    procedure SetInterpLinear_Min(value: integer);
    procedure SetInterpLinear_Max(value: integer);

    procedure SetFormulaCurve_Red(thefunction: TRGBCurves_FormulaCurve);
    procedure SetFormulaCurve_Green(thefunction: TRGBCurves_FormulaCurve);
    procedure SetFormulaCurve_Blue(thefunction: TRGBCurves_FormulaCurve);
    procedure SetFormulaCurve_Lum(thefunction: TRGBCurves_FormulaCurve);

    procedure SetRGBmode(theRGBmode: TRGBCurves_RGBmode);
    procedure SetRGBSpace(theRGBSpace: TRGBCurves_RGBSpace);
    procedure SetColorSpaceMixAmount(theAmount: integer);
    procedure SetCurvesMode(theCurvemode: TRGBCurves_mode);

    procedure SetFont(thefont: Tfont);
    procedure SetUseGDIPlus(Value: boolean);
    procedure SetHistogramDisplayMode(DisplayMode: TRGBCurves_HistogramDisplayMode);
    procedure Sethistogramscalemode(thescalemode: TRGBCurves_HistogramScaleMode);
    procedure SetHistogramRGBMode(mode: TRGBCurves_HistogramRGBMode);


    procedure SetOnAddPoint(value: TRGBCurves_Point_Event);
    procedure SetOnRemovePoint(value: TRGBCurves_Point_Event);

    procedure SetComplementaryCurves(value:boolean);
    procedure SwitchCurvetoComplementary(pl:TRGBCurves_PointList);


    // End  <--------******SETTERS*****************

    // Start  -------->******Private methods*****************

    procedure CheckLicense;
    procedure HandleLayoutChanged(Sender: TObject);

    procedure HandleCurvesChanged(sender: TObject);


    procedure Formulas_SetRGBMode;
    procedure Points_SetRGBMode;
    procedure Points_Swap(points: TRGBCurves_doublepointsarray; ix1, ix2: integer);

    procedure Calc_LUTS_All(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);
    procedure Calc_LUTS_PointCurves(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);
    procedure Calc_LUTS_Formulas(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);

    procedure Calc_LUT(var LUT: TRGBCurves_LUT; mode: TRGBCurves_RGBmode);
    procedure Calc_Formula_LUT(var LUT: TRGBCurves_LUT; mode: TRGBCurves_Channel_ViewMode);

    procedure Graph_PutUpDown;
    procedure Graph_Show;
    procedure Graph_Update;
    procedure Graph_Update_NoEvents;

    procedure Graph_UpdateAndShow;
    procedure Graph_UpdateAndShow_NoEvents;

    Function DrawPointGetColor: TColor;
    Function DrawCurveGetColor: TColor;
    function DrawFormulaCurveGetColor(idx: integer): TColor;


    procedure CreateExportList(var explist: Tstringlist);
    procedure ReadImportList(var implist: Tstringlist);

    procedure CreateExport(dp: TNWSComps_DataParser);
    procedure ReadImport(dp: TNWSComps_DataParser);


    // End  -------->******Private methods*****************

  protected
    { Protected declarations }
    property EditMode: TRGBCurves_editmode read fEditMode;

    // Start  -------->******Protected methods*****************

    procedure Resize; override;
    procedure Loaded; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; x, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; x, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; x, Y: integer); override;
    procedure IEView_Preview_RefreshPreview;
    procedure IEVIEW_RegisteredApplyMethod(previewID: TGUID; linkToFullBmp:boolean;
                                           theIEbmp: TIEbitmap; mask: TIEMask;
                                           EditedRect: TRect; const bUseMask: boolean);

    // End  -------->******Protected methods*****************

  public
    { Public declarations }

    property ColorSpaceMixAmount: integer read fColorSpaceMixAmount write SetColorSpaceMixAmount; // betw 0 and 100
    property RGBMode: TRGBCurves_RGBmode read fRGBmode write SetRGBmode;

    property Points: TRGBCurves_PointList read fpoints;


    property RedPoints: TRGBCurves_PointList read fPoints_RED;
    property GreenPoints: TRGBCurves_PointList read fPoints_GREEN;
    property BluePoints: TRGBCurves_PointList read fPoints_BLUE;
    property LumPoints: TRGBCurves_PointList read fPoints_RGB;

    //this is deprecated - only use for retro-compatibility
    property AllPoints: TRGBCurves_PointList read fPoints_RGB;


    property CyanPoints: TRGBCurves_PointList read fPoints_RED;
    property MagentaPoints: TRGBCurves_PointList read fPoints_GREEN;
    property YellowPoints: TRGBCurves_PointList read fPoints_BLUE;
    property InkPoints: TRGBCurves_PointList read fPoints_RGB;


    // Assign these functions if you are in TRGBCurves_Mode: cmViewFunction
    //(cannot edit points while in this mode)
    property FormulaCurve_Red: TRGBCurves_FormulaCurve read fFormulaCurve_Red write SetFormulaCurve_Red;
    property FormulaCurve_Green: TRGBCurves_FormulaCurve read fFormulaCurve_Green write SetFormulaCurve_Green;
    property FormulaCurve_Blue: TRGBCurves_FormulaCurve read fFormulaCurve_Blue write SetFormulaCurve_Blue;
    property FormulaCurve_Lum: TRGBCurves_FormulaCurve read fFormulaCurve_Lum write SetFormulaCurve_Lum;


    property FormulaCurve_Cyan: TRGBCurves_FormulaCurve read fFormulaCurve_Red write SetFormulaCurve_Red;
    property FormulaCurve_Magenta: TRGBCurves_FormulaCurve read fFormulaCurve_Green write SetFormulaCurve_Green;
    property FormulaCurve_Yellow: TRGBCurves_FormulaCurve read fFormulaCurve_Blue write SetFormulaCurve_Blue;
    property FormulaCurve_Ink: TRGBCurves_FormulaCurve read fFormulaCurve_Lum write SetFormulaCurve_Lum;


    property ExportDirectory: string read fexportdirectory write fexportdirectory;

    property MaxFittingX: integer read fmaxfittingx;
    property MinFittingX: integer read fminfittingx;


    // Start  -------->******Public methods*****************

    procedure Update; reintroduce;
    procedure Repaint; reintroduce;
    procedure Refresh; reintroduce;

    procedure GetHistogramfromBMP(bmp: Tbitmap);

    procedure ApplyCurvestoBitmap(thebitmap: Tbitmap);
    procedure ApplyGrayCurvetoBitmap_ToneMapped(thebitmap: Tbitmap; tonemap: Tbitmap; const dyn_amt: single);


    procedure GetHistoLimitValues(percentLimitMin:double;
                                         percentLimitMax:double;
                                         var LimitMinGray: byte;
                                         var  LimitMaxGray: byte;
                                         var LimitMinRed: byte;
                                         var  LimitMaxRed: byte;
                                         var LimitMinGreen: byte;
                                         var  LimitMaxGreen: byte;
                                         var LimitMinBlue: byte;
                                         var  LimitMaxBlue: byte;
                                         var LimitMinCyan: byte;
                                         var  LimitMaxCyan: byte;
                                         var LimitMinMagenta: byte;
                                         var  LimitMaxMagenta: byte;
                                         var LimitMinYellow: byte;
                                         var  LimitMaxYellow: byte;
                                         var LimitMinInk: byte;
                                         var  LimitMaxInk: byte);

    procedure GetHistogramfromIEBMP(theIEbmp: TIEbitmap);
    procedure GetHistogramfromImageEnView(theieView: TimageenView);

    procedure ApplyCurvestoIEBitmap(theIEbmp: TIEbitmap); overload;
    procedure ApplyCurvestoIEBitmap(theIEbmp: TIEbitmap; mask: TIEMask; EditedRect: TRect; const bUseMask: boolean); overload;
    procedure ApplyCurvestoImageEnView(theIEView: TimageenView);



    procedure IEView_Preview_ApplyChanges;
    procedure IEView_Preview_Register(theIEView: TimageenView);
    procedure IEView_Preview_UnRegister;
    procedure IEView_Preview_Lock;
    procedure IEView_Preview_UnLock;
    procedure IEView_Preview_Toggle(const bToggleOn: boolean);

    function PS_LoadCurves_FromFile(theCurvesfile: string):boolean;
    procedure PS_SaveCurves_ToFile(theCurvesfile: string);

    function LoadCurves_FromFile(theCurvesfile: string): boolean;
    procedure SaveCurves_ToFile(theCurvesfile: string);


    procedure ExportCurves;
    function ImportCurves: boolean;
    procedure ExportCurvestoINI(Inifile: Tinifile; IniSection: string);
    procedure ImportCurvesfromINI(Inifile: Tinifile; IniSection: string);
    procedure ResetPoints;
    procedure ResetPoints_NoUpdate;

    procedure SetthePoint(ix: integer; thepoint: TRGBCurves_doublepoint; const bUpdate: boolean); overload;
    procedure SetthePoint(ix: integer; thepoint: TPoint; const bUpdate: boolean); overload;

    procedure SetCurrentPoint(const thepoint: TRGBCurves_doublepoint; const bUpdate: boolean);
    Function GetCurrentPoint: TRGBCurves_doublepoint;
    Function GetCurrentPoint_IDX: integer;
    procedure SetCurrentPoint_Idx(theIdx: integer);

    procedure AddPoint(thepoint: TPoint; const bUpdate: boolean); overload;
    procedure AddPoint(thepoint: TRGBCurves_doublepoint; const bUpdate: boolean); overload;
    procedure RemovePoint(ix: integer; const bUpdate: boolean);
    procedure RemovePoint_Current(const bUpdate: boolean);
    Function GetPointAtXY(x,y: integer): TRGBCUrves_DoublePoint;
    function ExportLUT(mode: TRGBCurves_RGBmode): TRGBCurves_LUT;
    procedure ExportLUTs(var BGRALUTarray: TRGBCurves_Lutarray; var GrayLUT: TRGBCurves_LUT);

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // End  -------->******Public methods*****************

  published
    { Published declarations }
    property ComplementaryCurves: boolean read fComplementaryCurves write SetComplementaryCurves;

    property TransposeCurveOnComplementaryChanged: boolean read fTransposeCurveOnComplementaryChanged write fTransposeCurveOnComplementaryChanged;

    property Version: string read GetVersion;
    property IO_Options: TRGBCurves_IO_Options read fIO_Options write fIO_Options;
    property Layout: TRGBCurves_Layout read fLayout write fLayout;

    property InterpLinear_Min: integer read fInterpLinear_Min write SetInterpLinear_Min;
    property InterpLinear_Max: integer read fInterpLinear_Max write SetInterpLinear_Max;

    property Options: TRGBCurves_Options read fOptions write fOptions;

    property CurveMode: TRGBCurves_mode read fCurveMode write SetCurvesMode;

    property Font: Tfont read ffont write SetFont;

    property PointDetectTolerance: Cardinal read fPointDetectTolerance write fPointDetectTolerance;
    property RGBSpace: TRGBCurves_RGBSpace read fRGBSpace write SetRGBSpace;

    property UseGDIPlus: boolean read fUseGDIPlus write SetUseGDIPlus;

    Property UseFastPreview: boolean read GetUSeFastPreview write SetUseFastPreview;
    property PreviewMode: TIEUtils_IEPreview_Mode read GetPreviewMode write SetPreviewMode;

    property ShowHistogram: boolean read fShowHistogram write fShowHistogram;
    property HistogramDisplayMode: TRGBCurves_HistogramDisplayMode read fHistogramDisplayMode write SetHistogramDisplayMode;
    property HistogramRGBMode: TRGBCurves_HistogramRGBMode read fHistogramRGBMode write SetHistogramRGBMode;
    property Histogramscalemode: TRGBCurves_HistogramScaleMode read fHistogramscaleMode write Sethistogramscalemode;

    property OnChangeRGBMode: TnotifyEvent read fOnchangeRGBMode write fOnchangeRGBMode;
    property OnChangeCurve: TnotifyEvent read fOnChangeCurve write fOnChangeCurve;
    property OnPaint: TnotifyEvent read fOnPaint write fOnPaint;
    property OnMovePoint: TRGBCurves_MovePointEvent read fOnMovePoint write fOnMovePoint;
    property OnMovingPoint: TRGBCurves_MovingPointEvent read fOnMovingPoint write fOnMovingPoint;
    property OnAddPoint: TRGBCurves_Point_Event read fOnAddPoint write SetOnAddPoint;
    property OnRemovePoint: TRGBCurves_Point_Event  read fOnRemovePoint write SetOnRemovePoint;

    property OnCustomDraw_Labels_HorzAxis: TRGBCurves_CustomDrawLabelEvent read fOnCustomDraw_Labels_HorzAxis write fOnCustomDraw_Labels_HorzAxis;
    property OnCustomDraw_Labels_VertAxis: TRGBCurves_CustomDrawLabelEvent read fOnCustomDraw_Labels_VertAxis write fOnCustomDraw_Labels_VertAxis;

    property OnCustomDraw_Point: TRGBCurves_CustomDrawPointEvent read fOnCustomDraw_Point write fOnCustomDraw_Point;

    property OnIEView_BeforePreview: TnotifyEvent read GetOnIEView_BeforePreview write SetOnIEView_BeforePreview;
    property OnIEView_AfterPreview: TnotifyEvent read GetOnIEView_AfterPreview write SetOnIEView_AfterPreview;

    property Align;
    property Anchors;
    property AutoSize;
    property BorderWidth;
    property Constraints;
    property DragKind;
    property DragCursor;
    property DragMode;
    property Left;
    property Top;
    property Width;
    property Height;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

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

implementation



procedure AALine(x1, y1, x2, y2: single; color: tcolor; canvas: tcanvas);

  function CrossFadeColor(FromColor, ToColor: TColor; Rate: Single): TColor;
  var
    r, g, b: byte;
  begin
    r := Round(GetRValue(FromColor) * Rate + GetRValue(ToColor) * (1 - Rate));
    g := Round(GetGValue(FromColor) * Rate + GetGValue(ToColor) * (1 - Rate));
    b := Round(GetBValue(FromColor) * Rate + GetBValue(ToColor) * (1 - Rate));
    Result := RGB(r, g, b);
  end;

  procedure hpixel(x: single; y: integer);
  var
    FadeRate: single;
  begin
    FadeRate := x - trunc(x);
    with canvas do
    begin
      pixels[trunc(x), y] := CrossFadeColor(Color, Pixels[Trunc(x), y], 1 - FadeRate);
      pixels[trunc(x) + 1, y] := CrossFadeColor(Color, Pixels[Trunc(x) + 1, y], FadeRate);
    end;
  end;

  procedure vpixel(x: integer; y: single);
  var
    FadeRate: single;
  begin
    FadeRate := y - trunc(y);
    with canvas do
    begin
      pixels[x, trunc(y)] := CrossFadeColor(Color, Pixels[x, Trunc(y)], 1 - FadeRate);
      pixels[x, trunc(y) + 1] := CrossFadeColor(Color, Pixels[x, Trunc(y) + 1], FadeRate);
    end;
  end;

var
  i: integer;
  ly, lx, currentx, currenty, deltax, deltay, l, skipl: single;
begin
  if (x1 <> x2) or (y1 <> y2) then
  begin
    currentx := x1;
    currenty := y1;
    lx := abs(x2 - x1);
    ly := abs(y2 - y1);

    if lx > ly then
    begin
      l := trunc(lx);
      deltay := (y2 - y1) / l;
      if x1 > x2 then
      begin
        deltax := -1;
        skipl := (currentx - trunc(currentx));
      end
      else
      begin
        deltax := 1;
        skipl := 1 - (currentx - trunc(currentx));
      end;
    end
    else
    begin
      l := trunc(ly);
      deltax := (x2 - x1) / l;
      if y1 > y2 then
      begin
        deltay := -1;
        skipl := (currenty - trunc(currenty));
      end
      else
      begin
        deltay := 1;
        skipl := 1 - (currenty - trunc(currenty));
      end;
    end;

    currentx := currentx + deltax * skipl;
    currenty := currenty + deltay * skipl; { }

    for i := 1 to trunc(l) do
    begin
      if lx > ly then
        vpixel(trunc(currentx), currenty)
      else
        hpixel(currentx, trunc(currenty));
      currentx := currentx + deltax;
      currenty := currenty + deltay;
    end;
  end;
end;

function GetMaxvalue(intarray: array of cardinal): cardinal;
var
  i, temp: integer;
begin
  if length(intarray) = 0 then
  begin
    result := 0;
    exit;
  end;
  temp := intarray[0];
  for i := 0 to length(intarray) - 1 do
    temp := max(temp, intarray[i]);

  result := temp;
end;

function GetAvgvalue(intarray: array of cardinal): cardinal;
var
  i: integer;
  somma: cardinal;
begin
  if length(intarray) = 0 then
  begin
    result := 0;
    exit;
  end;
  somma := 0;
  for i := 0 to length(intarray) - 1 do
    somma := somma + intarray[i];

  result := somma div (length(intarray));
end;

procedure BlendHistogram(srcbmp, dstbmp: Tbitmap; const KeyCol: TColor);
type
  TBytearray = array [0 .. 32767] of byte;
  PByteArray = ^TBytearray;
  TBGRAbytearray = array [0 .. 3] of byte;
var
  pps, ppd: PByteArray;
  i, j, k: integer;
  BGRAs, BGRAd: TBGRAbytearray;
  shiftby, readby: integer;
  tempx: integer;
  x1, y1, x2, y2: integer;
  tras: integer;
  refcol: tcolor;
begin
  if (not assigned(srcbmp)) or (not assigned(dstbmp)) then
    exit;
  if (srcbmp.pixelformat <> pf24bit) or (dstbmp.pixelformat <> pf24bit) then
    exit;
  if (srcbmp.Width <> dstbmp.Width) or (srcbmp.Height <> dstbmp.Height) then
    exit;
  tras := 190;
  shiftby := 3;
  readby := 2;
  x1 := 0;
  y1 := 0;
  x2 := dstbmp.Width - 1;
  y2 := dstbmp.Height - 1;
  try
    for j := y1 to y2 do
    begin
      ppd := dstbmp.scanline[j];
      pps := srcbmp.scanline[j];
      for i := x1 to x2 do
      begin
        tempx := shiftby * i;
        for k := 0 to readby do
          BGRAs[k] := pps[tempx + k];
        refcol := rgb(BGRAs[2], BGRAs[1], BGRAs[0]);
        if (refcol = KeyCol) then
        begin
          for k := 0 to readby do
          begin
            BGRAd[k] := ppd[tempx + k];
            BGRAd[k] := (tras * BGRAd[k] + (255 - tras) * BGRAs[k]) div 255;
            ppd[tempx + k] := BGRAd[k];
          end;
        end;
      end;
    end;
  except
    ;
  end;
end;

procedure LumRGBToLumRGB(const r_old, g_old, b_old, Lum_old, Lum: byte; var r, g, b: byte);
var
  ratio: single;
begin
  if Lum_old = 0 then
    ratio := Lum
  else
    ratio := Lum / Lum_old;

  r := min(255, round(r_old * ratio));
  g := min(255, round(g_old * ratio));
  b := min(255, round(b_old * ratio));
end;

procedure RGBtoLum_Avg(const r, g, b: byte; var Lum: byte);
var
  mx, mn: byte;
begin
  if r > g then
  begin
    if r > b then
    begin
      mx := r;
      mn := min(g, b);
    end
    else
    begin
      mx := b;
      mn := min(g, r);
    end;
  end
  else
  begin
    if g > b then
    begin
      mx := g;
      mn := min(r, b);
    end
    else
    begin
      mx := b;
      mn := min(r, g);
    end;
  end;

  Lum := (mx + mn) div 2;
end;

procedure RGBtoLum_perceptive(const r, g, b: byte; var Lum: byte);
begin
  // Lum := round(0.3 * r + 0.6 * g + 0.1 * b);
  Lum := (30 * r + 60 * g + 10 * b) div 100;
end;

procedure RGBtoLum(const r, g, b: byte; var Lum: byte);
begin
  RGBtoLum_perceptive(r, g, b, Lum);
  if Lum = 0 then
    RGBtoLum_Avg(r, g, b, Lum);

end;




// --------------------------Class TRGBCurves--------------------------------------------

constructor TRGBCurves.Create(AOwner: TComponent);
var
  i: integer;
begin

  inherited Create(AOwner);

  fReadingFromFile := False;

  Width := 150;
  Height := 150;

  fGraphBitmap := Tbitmap.Create;
  fGraphBitmap.pixelformat := pf24bit;

  fIO_Options := TRGBCurves_IO_Options.create;

  fLayout := TRGBCurves_Layout.create(handlelayoutchanged, width, Height, 50, False);

  fComplementaryCurves := False;
  fTransposeCurveOnComplementaryChanged := true;

  fPoints_RGB := TRGBCurves_PointList.Create;
  fPoints_RED := TRGBCurves_PointList.Create;
  fPoints_GREEN := TRGBCurves_PointList.Create;
  fPoints_BLUE := TRGBCurves_PointList.Create;

  fPoints_RGB.OnCustomPointEvent := Handlelayoutchanged;
  fPoints_RED.OnCustomPointEvent := Handlelayoutchanged;
  fPoints_GREEN.OnCustomPointEvent := Handlelayoutchanged;
  fPoints_BLUE.OnCustomPointEvent := Handlelayoutchanged;

  fPoints_RGB.OnPointsChanged := HandleCurvesChanged;
  fPoints_RED.OnPointsChanged := HandleCurvesChanged;
  fPoints_GREEN.OnPointsChanged := HandleCurvesChanged;
  fPoints_BLUE.OnPointsChanged := HandleCurvesChanged;





  fPoints := fPoints_RGB;

  fPointDetectTolerance := 7;
  {$IFNDEF IMAGEEN_8_1_0_LATER}
  if GDIPLUS_Available then
  begin
    fUseGDIPlus := true;
    GDIPLUS_LoadLibrary;
  end
  else fUseGDIPlus := false;
  {$ELSE}
     fUseGDIPlus := true;
  {$ENDIF}

  fIEViewEventsHandler := TIEUtils_IEPreviewEventsHandler.Create(nil);

  DoubleBuffered := true;

  fInterpLinear_Min := 15;
  fInterpLinear_Max := 100;

  fOptions := [Opt_Allow_AddPoints, Opt_Allow_RemovePoints];

  fColorSpaceMixAmount := 50;
  fRGBSpace := csMixed;

  fOnchangeRGBMode := nil;
  fOnPaint := nil;
  // Color := clWhite;
  cursor := crcross;
  fexportdirectory := '';
  ffont := Tfont.Create;
  with ffont do
  begin
    name := 'Times New Roman';
    size := 8;
  end;
  fCurveMode := cmBuildCurves;
  fChannelViewMode := fvmRGB;
  fFormulaCurve_Lum := nil;
  fFormulaCurve_Red := nil;
  fFormulaCurve_Green := nil;
  fFormulaCurve_Blue := nil;

  fShowHistogram := false;
  fHistogramDisplayMode := HDmTransparent;
  fHistogramRGBMode := HmAll;
  fHistogramscaleMode := HSmauto;

  fHistogram := TRGBCurves_Histogram.Create;
  with fHistogram do
  begin
    active := false;
    DisplayMode := HDmTransparent;
    ScaleMode := fHistogramscaleMode;
    RGBMode := HmAll;
    for i := 0 to 255 do
    begin
      Reds[i] := 0;
      Greens[i] := 0;
      Blues[i] := 0;
      Grays[i] := 0;
      peakred := 255;
      peakgreen := 255;
      peakblue := 255;
      peakgray := 255;
      avgred := 0;
      avggreen := 0;
      avgblue := 0;
      avggray := 0;
    end;
  end;

  fstep := 64;

  fmaxfittingx := 255;
  fminfittingx := 0;

  setlength(fXaxis, 0);
  setlength(fYaxis, 0);

  ResetPoints_NoUpdate;

end;

destructor TRGBCurves.Destroy;
begin

  fIEViewEventsHandler.free;

  fHistogram.Free;
  fLayout.Free;
  fIO_Options.free;
  ffont.free;
  fGraphBitmap.free;

  setlength(fXaxis, 0);
  setlength(fYaxis, 0);

  fPoints_RGB.Free;
  fPoints_RED.Free;
  fPoints_GREEN.Free;
  fPoints_BLUE.Free;
  {$IFNDEF IMAGEEN_8_1_0_LATER}
  if fUseGDIPlus then
    GDIPLUS_UnLoadLibrary;
  {$ENDIF}
  inherited Destroy;
end;

procedure TRGBCurves.Graph_PutUpDown;
var
  j: integer;
  pp, ppp, tempsc: pointer;
  scsize: integer;
begin
  scsize := 3 * fGraphBitmap.Width;

  GetMem(tempsc, scsize);
  try
    for j := 0 to fGraphBitmap.Height div 2 do
    begin
      pp := fGraphBitmap.scanline[j];
      ppp := fGraphBitmap.scanline[fGraphBitmap.Height - j - 1];
      move(pp^, tempsc^, scsize);
      move(ppp^, pp^, scsize);
      move(tempsc^, ppp^, scsize);
    end;
  finally
    freeMem(tempsc, scsize);
  end;
end;

// ***********Private GETTERS*******************************

function TRGBCurves.GetVersion: string;
begin
  result := G_CONST_RGBCURVES_VERSION_STR;
end;


function TRGBCurves.GetUSeFastPreview: boolean;
begin
  result := fIEViewEventsHandler.UseFastPreview;
end;




function TRGBCurves.GetPreviewMode: TIEUtils_IEPreview_Mode;
begin
  result := fIEViewEventsHandler.PreviewMode;
end;





function TRGBCurves.GetOnIEView_BeforePreview: TNotifyEvent;
begin
  result := fIEViewEventsHandler.OnBeforePreview;
end;


function TRGBCurves.GetOnIEView_AfterPreview: TNotifyEvent;
begin
  result := fIEViewEventsHandler.OnAfterPreview;
end;

// ***********Private SETTERS*******************************

procedure TRGBCurves.SetUseFastPreview(theValue: boolean);
begin
  fIEViewEventsHandler.UseFastPreview := thevalue;
end;


procedure TRGBCurves.SetPreviewMode(theValue: TIEUtils_IEPreview_Mode);
begin
  fIEViewEventsHandler.PreviewMode := theValue;
end;


procedure TRGBCurves.SetOnIEView_BeforePreview(thevalue: TNotifyEvent);
begin
  fIEViewEventsHandler.OnBeforePreview := theValue;
end;


procedure TRGBCurves.SetOnIEView_AfterPreview(thevalue: TNotifyEvent);
begin
  fIEViewEventsHandler.OnAfterPreview := theValue;
end;


procedure TRGBCurves.SetInterpLinear_Min(value: integer);
begin
  value := max(0, min(100, value));
  fInterpLinear_Min := min(fInterpLinear_Max, value);
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetInterpLinear_Max(value: integer);
begin
  value := max(0, min(100, value));
  fInterpLinear_Max := max(fInterpLinear_Min, value);
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetFormulaCurve_Red(thefunction: TRGBCurves_FormulaCurve);
begin
  fFormulaCurve_Red := thefunction;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetFormulaCurve_Green(thefunction: TRGBCurves_FormulaCurve);
begin
  fFormulaCurve_Green := thefunction;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetFormulaCurve_Blue(thefunction: TRGBCurves_FormulaCurve);
begin
  fFormulaCurve_Blue := thefunction;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetFormulaCurve_Lum(thefunction: TRGBCurves_FormulaCurve);
begin
  fFormulaCurve_Lum := thefunction;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetRGBmode(theRGBmode: TRGBCurves_RGBmode);
begin
  fRGBmode := theRGBmode;
  Formulas_SetRGBMode;
  Points_SetRGBMode;

  Graph_UpdateAndShow_NoEvents;
  if assigned(OnChangeRGBMode) then
    OnChangeRGBMode(self);
end;

procedure TRGBCurves.SetColorSpaceMixAmount(theAmount: integer);
begin
  fColorSpaceMixAmount := theAmount;

end;

procedure TRGBCurves.SetRGBSpace(theRGBSpace: TRGBCurves_RGBSpace);
begin
  fRGBSpace := theRGBSpace;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetCurvesMode(theCurvemode: TRGBCurves_mode);
begin
  fCurveMode := theCurvemode;
  if fCurveMode = cmFormulaCurves then
    cursor := crdefault
  else
    cursor := crcross;
  Graph_UpdateAndShow;
end;

procedure TRGBCurves.SetFont(thefont: Tfont);
begin
  ffont.assign(thefont);
  Graph_UpdateAndShow_NoEvents;
end;

procedure TRGBCurves.SetUseGDIPlus(Value: boolean);
begin
  if Value then
  begin
    {$IFNDEF IMAGEEN_8_1_0_LATER}
    if (not GDIPLUS_Available) then
    begin
      fUseGDIPlus := false;
      if not (csLoading in componentstate) then
        showmessage('GDIPlus Not Available on this machine');
      EXIT;
    end;
    {$ENDIF}
  end;

  fUseGDIPlus := value;
  {$IFNDEF IMAGEEN_8_1_0_LATER}
  if Value then
    GDIPLUS_LoadLibrary
  else
    GDIPLUS_UnLoadLibrary;
  {$ENDIF}

  Graph_UpdateAndShow_NoEvents;
end;

procedure TRGBCurves.SetHistogramDisplayMode(DisplayMode: TRGBCurves_HistogramDisplayMode);
begin
  if fHistogramDisplayMode <> DisplayMode then
  begin
    fHistogramDisplayMode := DisplayMode;
    fHistogram.DisplayMode := DisplayMode;
    Graph_UpdateAndShow_NoEvents;
  end;
end;

procedure TRGBCurves.Sethistogramscalemode(thescalemode: TRGBCurves_HistogramScaleMode);
begin
  fHistogramscaleMode := thescalemode;
  fHistogram.ScaleMode := fHistogramscaleMode;
  Graph_UpdateAndShow_NoEvents;
end;

procedure TRGBCurves.SetHistogramRGBMode(mode: TRGBCurves_HistogramRGBMode);
begin
  if fHistogramRGBMode <> mode then
  begin
    fHistogramRGBMode := mode;
    fHistogram.RGBMode := mode;
    Graph_UpdateAndShow_NoEvents;
  end;
end;


procedure TRGBCurves.SetOnAddPoint(value: TRGBCurves_Point_Event);
begin
  fOnAddPoint := value;
  fPoints_RGB.OnAddPoint := value;
  fPoints_RED.OnAddPoint := value;
  fPoints_GREEN.OnAddPoint := value;
  fPoints_BLUE.OnAddPoint := value;

end;

procedure TRGBCurves.SetOnRemovePoint(value: TRGBCurves_Point_Event);
begin
  fOnRemovePoint := value;
  fPoints_RGB.OnDeletePoint := value;
  fPoints_RED.OnDeletePoint := value;
  fPoints_GREEN.OnDeletePoint := value;
  fPoints_BLUE.OnDeletePoint := value;
end;


procedure TRGBCurves.SetComplementaryCurves(value:boolean);
begin

  if (fComplementaryCurves<>value) and fTransposeCurveOnComplementaryChanged then
  begin
  //  SwitchCurvetoComplementary(fpoints);
    SwitchCurvetoComplementary(fPoints_RGB);
    SwitchCurvetoComplementary(fPoints_RED);
    SwitchCurvetoComplementary(fPoints_GREEN);
    SwitchCurvetoComplementary(fPoints_BLUE);
  end;

  fComplementaryCurves := value;

  Graph_UpdateAndShow;
end;


procedure TRGBCurves.SwitchCurvetoComplementary(pl:TRGBCurves_PointList);
var
i: integer;
aCurrentPt, aPt: TRGBCurves_doublePoint;
ptArray: TRGBCurves_DoublePointsarray;
closest: TRGBCurves_PointItem;
currentindex: integer;
begin

   aCurrentPt := pl.CurrentPoint;
   setlength(ptArray, pl.Count);

    for i  :=  pl.Count-1 downto 0 do
    begin
      aPt.x := 255 - TRGBCurves_PointItem(pl[i]).x;
      aPt.y := 255 - TRGBCurves_PointItem(pl[i]).y;
      ptArray[i] := aPt;
    end;

    pl.Define(ptArray, false);

    //find the new current point
    aCurrentPt.x := 255 - aCurrentPt.x;
    aCurrentPt.y := 255 - aCurrentPt.y;


    currentindex := pl.PointExists(aCurrentPt,closest);
    if currentindex>=0 then
      pl.CurrentIdx := currentindex;


end;

// ***********Private Methods*******************************

procedure TRGBCurves.CheckLicense;
var
  cp: TPoint;
begin
  {$IFDEF NWSCOMPS_REGISTRATION_OK}
    exit;  //>>>>>>>EXIT IF REGISTRATION OK
  {$ENDIF}


  if not(csDesigning in ComponentState) then
  begin
    canvas.TextOut(1, 2, ' UNREGISTERED: (C) 2003/2011 Francesco Savastano');
    cp := screentoclient(mouse.CursorPos);
  end;

end;

procedure TRGBCurves.HandleLayoutChanged(Sender: TObject);
begin
  if fReadingFromFile then  EXIT;

  Graph_UpdateAndShow_NoEvents;
end;

procedure TRGBCurves.HandleCurvesChanged(sender: TObject);
begin
  Graph_UpdateAndShow;
end;



procedure TRGBCurves.Formulas_SetRGBMode;
begin
  case fRGBmode of
    cmAll:
      fChannelViewMode := fvmAll;
    cmRed:
      fChannelViewMode := fvmRed;
    cmGreen:
      fChannelViewMode := fvmGreen;
    cmBlue:
      fChannelViewMode := fvmBlue;
    cmRGB:
      fChannelViewMode := fvmRGB;
  end;
end;

procedure TRGBCurves.Points_SetRGBMode;
begin
  case fRGBmode of
    cmAll, cmRGB:
      begin
        fpoints := fPoints_RGB;
      end;
    cmRed:
      begin
        fpoints := fPoints_RED;
      end;
    cmGreen:
      begin
        fpoints := fPoints_GREEN;
      end;
    cmBlue:
      begin
        fpoints := fPoints_BLUE;
      end;
  end;

end;

procedure TRGBCurves.Points_Swap(points: TRGBCurves_doublepointsarray; ix1, ix2: integer);
var
  temp: TRGBCurves_doublepoint;
begin
  temp := points[ix2];
  points[ix2] := points[ix1];
  points[ix1] := temp;
end;

procedure TRGBCurves.Calc_LUTS_All(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);
begin
  if (fCurveMode = cmBuildCurves) then
    Calc_LUTS_PointCurves(RGBLUT, rLUT, gLUT, bLUT)
  else
    Calc_LUTS_Formulas(RGBLUT, rLUT, gLUT, bLUT);
end;

procedure TRGBCurves.Calc_LUTS_PointCurves(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);
var
  i: integer;
  spcoefs_RGB, spcoefs_Red, spCoefs_Green, spcoefs_Blue: TRGBCurves_DSplinevector;
begin

    CalculateBSplineCoefs(spcoefs_RGB, fPoints_RGB);
    CalculateBSplineCoefs(spcoefs_Red, fPoints_RED);
    CalculateBSplineCoefs(spCoefs_Green, fPoints_GREEN);
    CalculateBSplineCoefs(spcoefs_Blue, fPoints_BLUE);




    {
    if fComplementaryCurves then
    begin
      for i := 0 to 255 do
      begin
        RGBLUT[i] := max(0,min(255, i - (RGBLUT[i] - i))) ;
        RLUT[i] := max(0,min(255, i - (RLUT[i] - i))) ;
        GLUT[i] := max(0,min(255, i - (GLUT[i] - i))) ;
        BLUT[i] := max(0,min(255, i - (BLUT[i] - i))) ;
      end;
    end;
    }

    if fComplementaryCurves then
    begin
     for i := 0 to 255 do
      begin
        RGBLUT[255 - i] := 255 - GetCombinedCurveValue_INT(spcoefs_RGB, i, fPoints_RGB, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        RLUT[255 - i] := 255 - GetCombinedCurveValue_INT(spcoefs_Red, i, fPoints_RED, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        GLUT[255 - i] := 255 - GetCombinedCurveValue_INT(spCoefs_Green, i, fPoints_GREEN, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        BLUT[255 - i] := 255 - GetCombinedCurveValue_INT(spcoefs_Blue, i, fPoints_BLUE, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
      end;
    end
    else
    begin
      for i := 0 to 255 do
      begin
        RGBLUT[i] := GetCombinedCurveValue_INT(spcoefs_RGB, i, fPoints_RGB, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        RLUT[i] := GetCombinedCurveValue_INT(spcoefs_Red, i, fPoints_RED, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        GLUT[i] := GetCombinedCurveValue_INT(spCoefs_Green, i, fPoints_GREEN, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
        BLUT[i] := GetCombinedCurveValue_INT(spcoefs_Blue, i, fPoints_BLUE, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
      end;
    end;

end;

procedure TRGBCurves.Calc_LUTS_Formulas(var RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT);
begin
  Calc_Formula_LUT(RGBLUT, fvmAll);
  Calc_Formula_LUT(rLUT, fvmRed);
  Calc_Formula_LUT(gLUT, fvmGreen);
  Calc_Formula_LUT(bLUT, fvmBlue);
end;

procedure TRGBCurves.Calc_LUT(var LUT: TRGBCurves_LUT; mode: TRGBCurves_RGBmode);
var
  i: integer;
  spcoefs: TRGBCurves_DSplinevector;
  thePoints: TRGBCurves_PointList;
begin

    case mode  of
      cmAll, cmRGB: thePoints := fPoints_RGB;
      cmRed: thePoints := fPoints_RED;
      cmGreen: thePoints :=  fPoints_GREEN;
      cmBlue: thePoints :=  fPoints_BLUE;
      else
      thepoints := nil;
    end;
    CalculateBSplineCoefs(spcoefs, thePoints);

    for i := 0 to 255 do
    begin
      LUT[i] := GetCombinedCurveValue_INT(spcoefs, i, thePoints, fInterpLinear_Min / 100, fInterpLinear_Max / 100);
    end;


end;

procedure TRGBCurves.Calc_Formula_LUT(var LUT: TRGBCurves_LUT; mode: TRGBCurves_Channel_ViewMode);
var
  i: integer;
  temp: integer;
  test: boolean;
  LUT_temp: TRGBCurves_LUT;
begin
  if fCurveMode = cmFormulaCurves then
  begin
    test := false;
    case mode of
      fvmAll, fvmLum:
        if assigned(FormulaCurve_Lum) then
          test := true;
      fvmRed:
        if assigned(FormulaCurve_Red) then
          test := true;
      fvmGreen:
        if assigned(FormulaCurve_Green) then
          test := true;
      fvmBlue:
        if assigned(FormulaCurve_Blue) then
          test := true;
    end;
    for i := 0 to 255 do
    begin
      if test then
      begin
        case mode of
          fvmAll:
            temp := round(FormulaCurve_Lum(i));
          fvmRed:
            temp := round(FormulaCurve_Red(i));
          fvmGreen:
            temp := round(FormulaCurve_Green(i));
          fvmBlue:
            temp := round(FormulaCurve_Blue(i))
          else
          temp := 0;  //never the case
        end;

        if temp < 0 then
          temp := 0
        else if temp > 255 then
          temp := 255;
      end
      else
        temp := i;
      LUT[i] := temp;
    end;
  end
  else
  begin
    for i := 0 to 255 do
    begin

      LUT[i] := i;
    end;
  end;


  if fComplementaryCurves then
  begin
     for i := 0 to 255 do
     begin
        LUT_temp[i] := LUT[i];
     end;
     for i := 0 to 255 do
     begin
        LUT[255 - i] := 255 - LUT_temp[i];
     end;
  end

end;

procedure TRGBCurves.Graph_Show;
begin
  if (Width = 0) or (Height = 0) then
    exit;

  canvas.copyrect(rect(0, 0, Width, Height), fGraphBitmap.canvas, rect(0, 0, Width, Height));
  CheckLicense;
end;

procedure TRGBCurves.Graph_Update;
begin
  Graph_Update_NoEvents;

  IEView_Preview_RefreshPreview;

  if assigned(fOnChangeCurve) then
    fOnChangeCurve(self);
end;



Function TRGBCurves.DrawPointGetColor: TColor;
  begin

    case fRGBmode of
      cmAll, cmRGB:
      begin
        if fComplementaryCurves then
          result := fLayout.PointColor_Ink
        else
          result := fLayout.PointColor_Lum;
      end;
      cmRed:
      begin
        if fComplementaryCurves then
          result := fLayout.PointColor_Cyan
        else
          result := fLayout.PointColor_Red;
      end;
      cmGreen:
      begin
        if fComplementaryCurves then
          result := fLayout.PointColor_Magenta
        else
          result := fLayout.PointColor_Green;
      end;
      cmBlue:
      begin
        if fComplementaryCurves then
          result := fLayout.PointColor_Yellow
        else
          result := fLayout.PointColor_Blue;
      end;

      else
      result := 0;

    end;

  end;

  Function TRGBCurves.DrawCurveGetColor: TColor;
  begin
    case fRGBmode of
      cmAll, cmRGB:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Ink
        else
          result := fLayout.CurveColor_Lum;
      end;

      cmRed:
        begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Cyan
        else
          result := fLayout.CurveColor_Red;
      end;
      cmGreen:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Magenta
        else
          result := fLayout.CurveColor_Green;
      end;
      cmBlue:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Yellow
        else
          result := fLayout.CurveColor_Blue;
      end
      else
      result := 0;
    end;
  end;

  Function TRGBCurves.DrawFormulaCurveGetColor(idx: integer): TColor;
  begin
    case idx of
      0:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Ink
        else
          result := fLayout.CurveColor_Lum;
      end;

      1:
        begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Cyan
        else
          result := fLayout.CurveColor_Red;
      end;
      2:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Magenta
        else
          result := fLayout.CurveColor_Green;
      end;
      3:
      begin
        if fComplementaryCurves then
          result := fLayout.CurveColor_Yellow
        else
          result := fLayout.CurveColor_Blue;
      end
      else
      result := 0;
    end;
  end;

procedure TRGBCurves.Graph_Update_NoEvents;
var
  x1, y1, x2, y2, x, Y: integer;
  function SafeLog2(x: Extended): Extended;
  begin
    result := log2(max(1, x));
  end;



  function DrawCreateGDIPlusCanvas: TGdiPlusCanvas;
  begin
    result := TGdiPlusCanvas.Create(fGraphBitmap.canvas, True);

    with result do
    begin

      GDPPen.Width := fGraphBitmap.canvas.Pen.Width;
      GDPPen.Color := fGraphBitmap.canvas.Pen.Color;
      GDPPen.Alpha := fLAyout.LineOpacity;
      GDPPen.Style := fGraphBitmap.canvas.Pen.style;

      GDPBrush.Color := fGraphBitmap.canvas.brush.Color;
      GDPBrush.Alpha := fLAyout.PointOpacity;
      GDPBrush.Style := fGraphBitmap.canvas.brush.style;

      Result.GDPSmoothingMode := smBestQty;
    end;
  end;

  procedure DrawEllipse(x1, y1, x2, y2: integer);
  var
    DestCanvas: TGdiPlusCanvas;
  begin
    if fUseGDIPlus then
    begin
      DestCanvas := DrawCreateGDIPlusCanvas;

      try
        DestCanvas.Ellipse(x1, y1, x2, y2);
      finally
        DestCanvas.free;
      end;
    end
    else
    begin
      fGraphBitmap.canvas.Ellipse(x1, y1, x2, y2);
    end;

  end;

  procedure DrawLine(x1, y1, x2, y2: integer);
  var
    DestCanvas: TGdiPlusCanvas;
  begin
    if fUseGDIPlus then
    begin
      DestCanvas := DrawCreateGDIPlusCanvas;

      try
        DestCanvas.drawline(x1, y1, x2, y2);
      finally
        DestCanvas.free;
      end;
    end
    else
    begin
      fGraphBitmap.canvas.MoveTo(x1, y1);
      fGraphBitmap.canvas.LineTo(x2, y2);
    end;

  end;

  procedure ReducePlottedPoints(var theReducedPoints: TRGBCurves_DoublePointsarray; var redCount: integer; theOriginalPoints: TRGBCurves_DoublePointsarray);
  var
    smoothCtr, i: integer;
    xp, yp: double;
  begin
    smoothCtr := -1;

    for i := 0 to high(theOriginalPoints) do
    begin
      xp := theOriginalPoints[i].X;
      yp := theOriginalPoints[i].Y;
      if (smoothCtr <= 0) or (yp <= y1) // when the curve falls on the x axis (y = yp1)
        or (yp >= y2) // when the curve falls on the top x axis (y = yp2)
        or (xp = theReducedPoints[smoothCtr].x) // should never happen
        or (theReducedPoints[smoothCtr - 1].x = theReducedPoints[smoothCtr].x) // should never happen
        or (abs((yp - theReducedPoints[smoothCtr].y) / (xp - theReducedPoints[smoothCtr].x) - (theReducedPoints[smoothCtr].y - theReducedPoints[smoothCtr - 1].y) /
            (theReducedPoints[smoothCtr].x - theReducedPoints[smoothCtr - 1].x)) > (self.Width + self.height) / 3500000) then

      begin
        inc(smoothCtr);
        theReducedPoints[smoothCtr] := theOriginalPoints[i];
      end;
    end;
    redCount := smoothCtr + 1;

    theReducedPoints[0] := theOriginalPoints[0];
    theReducedPoints[smoothCtr] := theOriginalPoints[ high(theOriginalPoints)];

  end;

  procedure ConvertPointsToInteger(var thePoints: TRGBCurves_pointsarray; theFPoints: TRGBCurves_DoublePointsarray);
  var
    i: integer;
  begin


    for i := 0 to high(theFPoints) do
    begin

      thePoints[i].X := round(theFPoints[i].x);
      thePoints[i].Y := round(theFPoints[i].Y);

    end;
  end;

  procedure DrawPolyLine_Normal_AA(thePoints: TRGBCurves_DoublePointsarray);
  var
    i: integer;
    ReducedPoints: TRGBCurves_DoublePointsarray;
    redCount: integer;
  begin
    // we can simulate antialias in normal gdi and we can use floating precision
    setlength(ReducedPoints, length(thePoints));
    redCount := length(thePoints);
    ReducePlottedPoints(reducedPoints, redCount, thePoints);
    setlength(ReducedPoints, redCount);

    for i := 0 to high(ReducedPoints) - 1 do
    begin
      AALine(ReducedPoints[i].x, ReducedPoints[i].y, ReducedPoints[i + 1].x, ReducedPoints[i + 1].y, fGraphBitmap.canvas.pen.Color, fGraphBitmap.canvas);

    end;
  end;

  procedure DrawPolyLine_Normal(thePoints: TRGBCurves_DoublePointsarray);
  var
    iPoints: TRGBCurves_Pointsarray;
  begin
    SetLength(IPoints, Length(thePoints));
    ConvertPointsToInteger(iPoints, thePoints);
    fGraphBitmap.canvas.Polyline(iPoints);

  end;

  procedure DrawPolyLine_GDIPLUS(thePoints: TRGBCurves_DoublePointsarray);
  var
    DestCanvas: TGdiPlusCanvas;
    ReducedPoints: TRGBCurves_DoublePointsarray;
    redCount: integer;
  begin

    DestCanvas := DrawCreateGDIPlusCanvas;
    try
      setlength(ReducedPoints, length(thePoints));
      redCount := length(thePoints);
      ReducePlottedPoints(reducedPoints, redCount, thePoints);
      setlength(ReducedPoints, redCount);
      DestCanvas.DrawLinesPath(TGDIPlus2DPointArray(reducedPoints));
    finally
      DestCanvas.free;
    end;
  end;


  procedure DrawPolyLine(thePoints: TRGBCurves_DoublePointsarray);
  begin
    if fUseGDIPlus then
    begin
      DrawPolyLine_GDIPLUS(thePoints);
    end
    else
    begin
      DrawPolyLine_Normal(thePoints);
    end;
  end;

  procedure DrawPoints;
  var
    i: integer;
    xp, yp: integer;
    aFillColor, aFillColor_def, aOutlineColor, aOutlineColor_def: TColor;
    aSize, aSize_def: integer;
    aLineSize, aLineSize_def: integer;
    aFillStyle, aFillStyle_def: TBrushStyle;

    aPt: TRGBCurves_PointItem;
  begin
    with fGraphBitmap.canvas do
    begin

      pen.Style := pssolid;

      aFillColor_def := DrawPointGetColor;
      aOutlineColor_def := DrawPointGetColor;
      aSize_def := fLAyout.PointSize;
      aLineSize_def := fLayout.LineSize;
      aFillstyle_def := fLAyout.PointFillStyle;

      for i := 0 to fPoints.count - 1 do
      begin
        aPt := fPoints.PointItem[i];
        if aPt.UseCustomLayout then
        begin
          aFillColor := aPt.CustomFillColor;
          aOutlineColor := aPt.CustomOutlineColor;
          aSize := aPt.CustomPointSize;
          aLineSize := aPt.CustomLineSize;
        end
        else
        begin
          aFillColor := aFillColor_def;
          aOutlineColor := aOutlineColor_def;
          aSize := aSize_def;
          aLineSize := aLineSize_def;
        end;
        aFillstyle := aFillStyle_def;
        if assigned(fOnCustomDraw_Point) then
        begin
          fOnCustomDraw_Point(fGraphBitmap.canvas, fPoints.Data[i], i, aOutlineColor, aFillColor, cardinal(aSize), cardinal(aLineSize), aFillStyle);
        end;

        pen.Width := aLineSize;
        pen.Color := aOutlineColor;
        brush.Color := aFillColor;
        brush.Style := aFillstyle;

        xp := x1 + round(fxratio * fpoints.Data[i].x);
        yp := y1 + round(fyratio * fpoints.Data[i].Y);

        DrawEllipse(xp - aSize div 2, yp - aSize div 2, xp + aSize div 2, yp + aSize div 2);

      end;
    end;
  end;

  procedure DrawPointsCurve;
  var
    i: integer;
    xp, yp: double;
    cvalue: integer;

    thePlotPoints: TRGBCurves_DoublePointsarray;

  begin

    if not(fCurveMode = cmBuildCurves) then
      EXIT;
    if fPoints.count = 0 then
      EXIT;

    CalculateBSplineCoefs(fCurveCoefs, fpoints);

    fmaxfittingx := -1;
    fminfittingx := -1;
    setlength(thePlotPoints, 255 + 1);

    for i := 0 to 255 do
    begin
      cvalue := GetCombinedCurveValue_INT(fCurveCoefs, i, fpoints, fInterpLinear_Min / 100, fInterpLinear_Max / 100);

      if (cvalue = 255) and (fmaxfittingx = -1) then
        fmaxfittingx := i
      else if (cvalue = 0) and (fminfittingx >= -1) then
        fminfittingx := i;

      xp := x1 + fxratio * i;
      yp := y1 + fyratio * cvalue;

      thePlotPoints[i].x := xp;
      thePlotPoints[i].y := yp;

    end;

    if fmaxfittingx = -1 then
      fmaxfittingx := 255;
    if fminfittingx = -1 then
      fminfittingx := 0;

    with fGraphBitmap.canvas do
    begin
      pen.Style := pssolid;
      pen.Width := fLayout.LineSize;
      pen.Color := DrawCurveGetColor;
      brush.Style := bsClear;
      brush.Color := clwhite;
    end;

    DrawPolyLine(thePlotPoints);

  end;

  procedure DrawFormulaCurves;
  var
    i, ic: integer;
    xp, yp: double;
    cvalue: double;
    curvecounter: integer;
    bTestDraw: boolean;

    thePoints: TRGBCurves_DoublePointsarray;
    Curve : TRGBCurves_FormulaCurve;
  begin

    curvecounter := 4;

    with fGraphBitmap.canvas do
    begin
      pen.Width := fLayout.LineSize;
      pen.Style := pssolid;
      brush.Style := bsClear;
      // brush.Color := clwhite;

      for ic := 1 to curvecounter do
      begin
        bTestDraw := false;
        if (fChannelViewMode= fvmAll) then
        begin
          bTestDraw := (assigned(fFormulaCurve_Lum) and (ic=1)) or
                        (assigned(fFormulaCurve_Red) and (ic=2)) or
                        (assigned(fFormulaCurve_Green) and (ic=3)) or
                        (assigned(fFormulaCurve_Blue) and (ic=4));
        end
        else if (fChannelViewMode= fvmRGB) then
        begin
          bTestDraw :=  (assigned(fFormulaCurve_Red) and (ic=2)) or
                        (assigned(fFormulaCurve_Green) and (ic=3)) or
                        (assigned(fFormulaCurve_Blue) and (ic=4));
        end
        else if (fChannelViewMode= fvmLum)  then
        begin
          bTestDraw := assigned(fFormulaCurve_Lum) and (ic=1);
        end
        else if (fChannelViewMode= fvmRed) then
        begin
          bTestDraw := assigned(fFormulaCurve_Red) and (ic=2);
        end
        else if (fChannelViewMode= fvmGreen) then
        begin
          bTestDraw := assigned(fFormulaCurve_Green) and (ic=3);
        end
        else if (fChannelViewMode= fvmBlue) then
        begin
          bTestDraw := assigned(fFormulaCurve_Blue) and (ic=4);
        end;

        if bTestDraw then
        begin
          if ic=1 then
          begin
            Curve := FormulaCurve_Lum;
          end
          else if ic=2 then
          begin
            Curve := FormulaCurve_Red;
          end
          else if ic=3 then
          begin
            Curve := FormulaCurve_Green;
          end
          else //if ic=4 then
          begin
            Curve := FormulaCurve_Blue;
          end;

          pen.Color := DrawFormulaCurveGetColor(ic-1);

          setlength(thePoints, 255 + 1);
          for i := 0 to 255 do
          begin
            cValue := curve(i);


            if cvalue > 255 then
              cvalue := 255
            else if cvalue < 0 then
              cvalue := 0;

            xp := x1 + fxratio * i;
            yp := y1 + fyratio * cvalue;

            thePoints[i].x := xp;
            thePoints[i].y := yp;
          end;
          DrawPolyLine(thePoints);

        end;
      end;
    end;
  end;

  procedure DrawtheCurve;
  begin
    if (fCurveMode = cmBuildCurves) then
    begin
      if flayout.DrawPointOverCurves then
      begin
        DrawPointsCurve;
        DrawPoints;
      end
      else
      begin
        DrawPoints;
        DrawPointsCurve;
      end;

    end
    else if fCurveMode = cmFormulaCurves then
      DrawFormulaCurves;
  end;

  procedure DrawGraphRect;
  begin
    with fGraphBitmap.canvas do
    begin
      brush.Color := fLAyout.GraphBackColor;
      brush.Style := bssolid;

      pen.Width := fLAyout.GridLineSize;
      pen.Style := pssolid;
      pen.Color := fLAyout.GraphBorderColor;

      rectangle(x1, y1, x2, y2);
    end;

  end;

  procedure DrawGrid;
  var
    i, j: integer;
    gridx, gridy: integer;
    labelindex: integer;

    aLineSize: cardinal;
    aLineColor: TColor;
    aPenStyle: TPenStyle;
  begin
    setlength(fXaxis, (255 + 1) div 64 + 1);
    setlength(fYaxis, (255 + 1) div 64 + 1);
    fXaxis[0] := point(x1, y1);
    fYaxis[0] := point(x1, y1);
    fXaxis[length(fXaxis) - 1] := point(x2, y1);
    fYaxis[length(fXaxis) - 1] := point(x1, y2);

    gridx := round(fstep * fxratio);
    gridy := round(fstep * fyratio);
    if gridx = 0 then
      gridx := 1;
    if gridy = 0 then
      gridy := 1;

    with fGraphBitmap.canvas do
    begin

      pen.Width := fLAyout.GridLineSize;
      pen.Style := fLAyout.GridPenStyle;
      pen.Color := fLAyout.GridColor;
    end;

    labelindex := 1;
    for i := x1 + fLayout.GridLineSize to x2 - fLayout.GridLineSize do
    begin
      x := i - fxgap;
      if x mod gridx = 0 then
      begin
        fXaxis[labelindex] := point(i, y2);
        DrawLine(i, y1, i, y2);

        inc(labelindex);
      end;
    end;

    labelindex := 1;
    for j := y1 + fLayout.GridLineSize to y2 - fLayout.GridLineSize do
    // for j := y1 + 1 to y2 - 1 do
    begin
      Y := j - fygap;
      if Y mod gridy = 0 then
      begin
        fYaxis[labelindex] := point(x1, j);
        DrawLine(x1, j, x2, j);
        inc(labelindex);
      end;
    end;

    if fLayout.ShowMedianLine then
    begin
      aLineSize := fLayout.GridMedianLineSize;
      aLineColor := fLayout.GridMedianLineColor;
      aPenStyle := fLAyout.GridMedianLinePenStyle;

      if assigned(fOnCustomDraw_MedianLine) then
        fOnCustomDraw_MedianLine(fGraphBitmap.Canvas, aLineColor, aLineSize, aPenStyle);

      // draw the diagonal
      with fGraphBitmap.canvas do
      begin
        pen.Style := aPenStyle;
        pen.Width := aLineSize;
        pen.Color := aLineColor;
      end;
      DrawLine(x1, y1, x2, y2);
    end;

  end;

  procedure DrawLabels;
  var
    i: integer;
    labelwidth, labelheight: integer;
    aLabelFont: TFont;
    aValue: double;
    aLabel: string;
    aMaxWidth, aMaxHeight: integer;
  begin
    aLabelFont := TFont.Create;
    try
      aLabelFont.Assign(fFont);
      // draw Axes labels
      with fGraphBitmap.canvas do
      begin
        brush.Style := bsclear;
        Font.assign(aLabelFont);
        labelwidth := textwidth(inttostr(255));
        labelheight := textheight(inttostr(255));

        aMaxWidth := labelwidth;
        aMaxHeight := labelHeight;

        if fLayout.ShowHorizontalCaptions then
        begin
          for i := 0 to length(fXaxis) - 1 do
          begin
            aValue := min(255, fstep * i);
            aLabel := inttostr(round(aValue));
            if assigned(fOnCustomDraw_Labels_HorzAxis) then
            begin
              fOnCustomDraw_Labels_HorzAxis(fGraphBitmap.canvas, aValue, aLabel, aLabelfont, aMaxWidth, aMAxHeight);
              if i = 0 then // only on first one assign font
              begin
                Font.assign(aLabelFont);
              end;
            end;

            TextOut(fXaxis[i].x - min(fGraphBitmap.canvas.textwidth(aLabel), aMaxWidth) div 2, Height - fygap, aLabel);
          end;
        end;

        if fLayout.ShowVerticalCaptions then
        begin
          for i := 1 to length(fYaxis) - 1 do
          begin
            aValue := min(255, fstep * i);
            aLabel := inttostr(round(aValue));
            if assigned(fOnCustomDraw_Labels_VertAxis) then
            begin
              fOnCustomDraw_Labels_VertAxis(fGraphBitmap.canvas, aValue, aLabel, aLabelfont, aMaxWidth, aMAxHeight);
              if i = 1 then // only on first one assign font
              begin
                Font.assign(aLabelFont);
              end;
            end;

            TextOut(fxgap - min(fGraphBitmap.canvas.textwidth(aLabel), aMaxWidth) - 2 - fLayout.GridLineSize, Height - fYaxis[i].Y - aMaxHeight div 2, aLabel);
          end;
        end;

      end;
    finally
      aLabelFont.Free;
    end;
  end;

  procedure DrawHistogram;
  var
    i, j: integer;
    Tempcol: tcolor;
    polygonarray: array [0 .. 255 + 3] of TPoint;
    xratioPixelstoNumbers, yRatioPixelstoNumbers: single;
    Histopeak: cardinal;
    Histoavg: cardinal;
    HistoBMP: Tbitmap;
    uselogscale: boolean;


  begin
    if not fHistogram.active then
      exit;
    with fGraphBitmap.canvas do
    begin
      with fHistogram do
      begin
        if fComplementaryCurves then
        begin
          Histopeak := max(peakink, max(peakyellow, max(peakcyan, peakmagenta)));
          Histoavg := max(avgink, max(avgyellow, max(avgcyan, avgmagenta)));
        end
        else
        begin
          Histopeak := max(peakgray, max(peakblue, max(peakred, peakgreen)));
          Histoavg := max(avggray, max(avgblue, max(avgred, avggreen)));
        end;


        xratioPixelstoNumbers := (x2 - x1) / 255;

        case fHistogram.ScaleMode of
          HSmLinear:
            uselogscale := false;
          HSmLog:
            uselogscale := true;
          HSmauto:
            begin
              if Histoavg > 0.2 * Histopeak then
                uselogscale := false
              else
                uselogscale := true;
            end
            else
             uselogscale := false;
        end;

        if not uselogscale then
          yRatioPixelstoNumbers := (y2 - y1) / Histopeak
        else
          yRatioPixelstoNumbers := (y2 - y1) / max(1, SafeLog2(Histopeak));
        for j := 0 to 3 do
        begin
          if (RGBMode = HmAll) or ((RGBMode = HmRed) and (j = 2)) or ((RGBMode = HmGreen) and (j = 1)) or ((RGBMode = HmBlue) and (j = 0)) or ((RGBMode = HmGray) and (j = 3)) then
          begin
            for i := 0 to 255 do
            begin
              with polygonarray[i] do
              begin
                x := x1 + round(i * xratioPixelstoNumbers);
                if not uselogscale then
                begin
                  if fComplementaryCurves then
                  begin
                    case j of
                    0:
                      Y := y1 + round(Yellows[i] * yRatioPixelstoNumbers);
                    1:
                      Y := y1 + round(Magentas[i] * yRatioPixelstoNumbers);
                    2:
                      Y := y1 + round(Cyans[i] * yRatioPixelstoNumbers);
                    3:
                      Y := y1 + round(Inks[i] * yRatioPixelstoNumbers);
                    end;
                  end
                  else
                  begin
                    case j of
                    0:
                      Y := y1 + round(Blues[i] * yRatioPixelstoNumbers);
                    1:
                      Y := y1 + round(Greens[i] * yRatioPixelstoNumbers);
                    2:
                      Y := y1 + round(Reds[i] * yRatioPixelstoNumbers);
                    3:
                      Y := y1 + round(Grays[i] * yRatioPixelstoNumbers);
                    end;
                  end;

                end
                else
                begin
                  if fComplementaryCurves then
                  begin
                    case j of
                    0:
                      Y := y1 + round(SafeLog2(Yellows[i]) * yRatioPixelstoNumbers);
                    1:
                      Y := y1 + round(SafeLog2(Magentas[i]) * yRatioPixelstoNumbers);
                    2:
                      Y := y1 + round(SafeLog2(Cyans[i]) * yRatioPixelstoNumbers);
                    3:
                      Y := y1 + round(SafeLog2(Inks[i]) * yRatioPixelstoNumbers);
                    end;
                  end
                  else
                  begin
                    case j of
                      0:
                        Y := y1 + round(SafeLog2(Blues[i]) * yRatioPixelstoNumbers);
                      1:
                        Y := y1 + round(SafeLog2(Greens[i]) * yRatioPixelstoNumbers);
                      2:
                        Y := y1 + round(SafeLog2(Reds[i]) * yRatioPixelstoNumbers);
                      3:
                        Y := y1 + round(SafeLog2(Grays[i]) * yRatioPixelstoNumbers);
                    end;
                  end;
                end;
              end;
            end; //
            polygonarray[255 + 1].x := x1 + round(255 * xratioPixelstoNumbers);
            polygonarray[255 + 1].Y := y1;
            polygonarray[255 + 2].x := x1;
            polygonarray[255 + 2].Y := y1;
            polygonarray[255 + 3].x := x1;
            if not uselogscale then
            begin
              if fComplementaryCurves then
              begin
                case j of
                  0:
                    polygonarray[255 + 3].Y := y1 + round(Yellows[0] * yRatioPixelstoNumbers);
                  1:
                    polygonarray[255 + 3].Y := y1 + round(Magentas[0] * yRatioPixelstoNumbers);
                  2:
                    polygonarray[255 + 3].Y := y1 + round(Cyans[0] * yRatioPixelstoNumbers);
                  3:
                    polygonarray[255 + 3].Y := y1 + round(Inks[0] * yRatioPixelstoNumbers);
                end;
              end
              else
              begin
                case j of
                  0:
                    polygonarray[255 + 3].Y := y1 + round(Blues[0] * yRatioPixelstoNumbers);
                  1:
                    polygonarray[255 + 3].Y := y1 + round(Greens[0] * yRatioPixelstoNumbers);
                  2:
                    polygonarray[255 + 3].Y := y1 + round(Reds[0] * yRatioPixelstoNumbers);
                  3:
                    polygonarray[255 + 3].Y := y1 + round(Grays[0] * yRatioPixelstoNumbers);
                end;
              end;
            end
            else
            begin
              if fComplementaryCurves then
              begin
                case j of
                  0:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Yellows[0]) * yRatioPixelstoNumbers);
                  1:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Magentas[0]) * yRatioPixelstoNumbers);
                  2:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Cyans[0]) * yRatioPixelstoNumbers);
                  3:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Inks[0]) * yRatioPixelstoNumbers);
                end;
              end
              else
              begin
                case j of
                  0:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Blues[0]) * yRatioPixelstoNumbers);
                  1:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Greens[0]) * yRatioPixelstoNumbers);
                  2:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Reds[0]) * yRatioPixelstoNumbers);
                  3:
                    polygonarray[255 + 3].Y := y1 + round(SafeLog2(Grays[0]) * yRatioPixelstoNumbers);
                end;
              end;
            end;

            // draw

            case j of
              0:
                if fComplementaryCurves then
                  Tempcol := rgb(200, 200, 0)
                else
                  Tempcol := clblue;
              1:
                if fComplementaryCurves then
                  Tempcol := rgb(200, 0, 200)
                else
                  Tempcol := clgreen;
              2:
                if fComplementaryCurves then
                  Tempcol := rgb(0, 200, 200)
                else
                  Tempcol := clred;
              3:
                Tempcol := clblack;
              else
                Tempcol := clblack;
            end;

            brush.Color := Tempcol;
            pen.Color := Tempcol;
            pen.Width := 1;
            if (DisplayMode = HDmLines) then
              polyline(polygonarray)
            else if DisplayMode = HDmFilled then
              polygon(polygonarray)
            else
            begin
              HistoBMP := Tbitmap.Create;
              HistoBMP.pixelformat := pf24bit;
              HistoBMP.Width := fGraphBitmap.Width;
              HistoBMP.Height := fGraphBitmap.Height;

              with HistoBMP.canvas do
              begin
                brush.Color := self.Color;
                brush.Style := bssolid;
                pen.Color := clblack;
                fillrect(rect(0, 0, HistoBMP.Width, HistoBMP.Height));
                brush.Color := Tempcol;
                pen.Color := Tempcol;
                pen.Width := 1;
                if ((j = 3) and (RGBMode = HmAll)) then
                  polyline(polygonarray)
                else
                begin
                  polygon(polygonarray);
                  polyline(polygonarray)
                end;
              end;

              BlendHistogram(HistoBMP, fGraphBitmap, tempcol);
              HistoBMP.free;
            end;
          end;
        end;
      end;
    end;
  end;

begin

  if (Width = 0) or (Height = 0) then
    exit;

  fLayout.recalc(Width, Height);

  fxgap := (Width - fLayout.GraphWidth) div 2;
  fygap := (Height - fLayout.GraphHeight) div 2;
  x1 := fxgap;
  y1 := fygap;
  x2 := fxgap + fLayout.GraphWidth;
  y2 := fygap + fLayout.GraphHeight;

  fxratio := fLayout.GraphWidth / 255;
  fyratio := fLayout.GraphHeight / 255;

  fGraphBitmap.Width := Width;
  fGraphBitmap.Height := Height;
  // first fill background rectangle
  with fGraphBitmap.canvas do
  begin
    brush.Color := fLAyout.GraphBackColor;
    brush.Style := bssolid;

    fillrect(rect(0, 0, Width, Height));
  end;

  DrawGraphRect;

  if fShowHistogram then
    DrawHistogram;
  // draw grid now
  DrawGrid;
  // draw the curve
  DrawtheCurve;
  Graph_PutUpDown;

  DrawLabels;

end;

procedure TRGBCurves.Graph_UpdateAndShow;
begin
  if (not(csLoading in ComponentState)) then
  begin
    Graph_Update;
    Graph_Show;
  end;
end;

procedure TRGBCurves.Graph_UpdateAndShow_NoEvents;
begin
  if (not(csLoading in ComponentState)) then
  begin
    Graph_Update_NoEvents;
    Graph_Show;
  end;
end;

procedure TRGBCurves.CreateExportList(var explist: Tstringlist);
var
  i: integer;
begin
  with explist do
  begin
    add(G_CONST_RGBCURVES_FILE_HEADER_TITLE_VALUE_OLD);
    add(G_CONST_RGBCURVES_FILE_HEADER_VERSION_VALUE_OLD);
    add(G_CONST_RGBCURVES_FILE_RGBPOINTS_TAG_OLD);
    add(inttostr(fPoints_RGB.count));
    for i := 0 to fPoints_RGB.count - 1 do
    begin
      add(floattostr(fPoints_RGB.data[i].x));
      add(floattostr(fPoints_RGB.data[i].Y));
    end;
    add(G_CONST_RGBCURVES_FILE_REDPOINTS_TAG_OLD);
    add(inttostr(fPoints_RED.Count));
    for i := 0 to fPoints_RED.Count - 1 do
    begin
      add(floattostr(fPoints_RED.data[i].x));
      add(floattostr(fPoints_RED.data[i].Y));
    end;
    add(G_CONST_RGBCURVES_FILE_GREENPOINTS_TAG_OLD);
    add(inttostr(fPoints_GREEN.Count));
    for i := 0 to fPoints_GREEN.Count - 1 do
    begin
      add(floattostr(fPoints_GREEN.data[i].x));
      add(floattostr(fPoints_GREEN.data[i].Y));
    end;
    add(G_CONST_RGBCURVES_FILE_BLUEPOINTS_TAG_OLD);
    add(inttostr(fPoints_BLUE.Count));
    for i := 0 to fPoints_BLUE.Count - 1 do
    begin
      add(floattostr(fPoints_BLUE.data[i].x));
      add(floattostr(fPoints_BLUE.data[i].Y));
    end;
  end;
end;

procedure TRGBCurves.CreateExport(dp: TNWSComps_DataParser);
var
  i: integer;
  aPoint: TRGBCurves_PointItem;
begin
  //header title
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_TITLE, G_CONST_RGBCURVES_FILE_HEADER_TITLE_VALUE);
  //header GUID
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_GUID, G_CONST_RGBCURVES_FILE_HEADER_GUID_VALUE);
  //header version
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_VERSION, G_CONST_RGBCURVES_VERSION_STR);


  //Interpolation Algorithm
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_ALGORITHM, RGBCurves_InterpAlgorithm);
  //Interp Constants MIN
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_INTERPLIN_MIN, inttostr(fInterpLinear_Min));
  //Interp Constants MAX
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_INTERPLIN_MAX, inttostr(fInterpLinear_Max));
  //Separator for floating point values
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_DECSEP, DataParser_GetDecimalSeparator);
  //Separator for X and Y Coordinates of Point in the Point String Value
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_POINTCOORDSSEP, G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE);
  // Separator between name of property and its value
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_PROPERTYSEP, G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE);


  //v.4
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_COMPLEMENTARY, booltostr(fComplementaryCurves));


  // RGB Points
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_COUNT, inttostr(fPoints_RGB.count));

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_DATA);
  try
    for i := 0 to fPoints_RGB.Count - 1 do
    begin
      dp.AddValue(floattostr(fPoints_RGB.data[i].x) + G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE + floattostr(fPoints_RGB.data[i].Y));
    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_DATA);
  end;

  // Red Points
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_COUNT, inttostr(RedPoints.count));

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_DATA);
  try
    for i := 0 to RedPoints.Count - 1 do
    begin
      dp.AddValue(floattostr(Redpoints.data[i].x) + G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE + floattostr(Redpoints.data[i].Y));

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_DATA);
  end;

  // green Points
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_COUNT, inttostr(GreenPoints.count));

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_DATA);
  try
    for i := 0 to GreenPoints.Count - 1 do
    begin
      dp.AddValue(floattostr(greenpoints.data[i].x) + G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE + floattostr(GreenPoints.data[i].Y));

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_DATA);
  end;


  // blue Points
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_COUNT, inttostr(BluePoints.count));

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_DATA);
  try
    for i := 0 to bluePoints.Count - 1 do
    begin
      dp.AddValue(floattostr(bluepoints.data[i].x) + G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE + floattostr(bluePoints.data[i].Y));

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_DATA);
  end;



  //saving the properties of each point
  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_PROPERTIES);
  try
    for i := 0 to fPoints_RGB.Count - 1 do
    begin
      aPoint := fPoints_RGB.pointitem[i];
      dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      try
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_USECUSTOMLAYOUT + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + booltostr(aPoint.UseCustomLayout));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_OUTLINECOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomOutlineColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_FILLCOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomFillColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_POINTSIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomPointSize));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_LINESIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomLineSize));
      finally
        dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      end;

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_PROPERTIES);
  end;

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_PROPERTIES);
  try
    for i := 0 to fPoints_RED.Count - 1 do
    begin
      aPoint := fPoints_RED.pointitem[i];
      dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      try
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_USECUSTOMLAYOUT + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + booltostr(aPoint.UseCustomLayout));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_OUTLINECOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomOutlineColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_FILLCOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomFillColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_POINTSIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomPointSize));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_LINESIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomLineSize));
      finally
        dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      end;

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_PROPERTIES);
  end;

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_PROPERTIES);
  try
    for i := 0 to fPoints_GREEN.Count - 1 do
    begin
      aPoint := fPoints_GREEN.pointitem[i];
      dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      try
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_USECUSTOMLAYOUT + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + booltostr(aPoint.UseCustomLayout));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_OUTLINECOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomOutlineColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_FILLCOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomFillColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_POINTSIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomPointSize));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_LINESIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomLineSize));
      finally
        dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      end;

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_PROPERTIES);
  end;

  dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_PROPERTIES);
  try
    for i := 0 to fPoints_BLUE.Count - 1 do
    begin
      aPoint := fPoints_BLUE.pointitem[i];
      dp.AddOpenTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      try
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_USECUSTOMLAYOUT + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + booltostr(aPoint.UseCustomLayout));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_OUTLINECOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomOutlineColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_FILLCOLOR + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomFillColor));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_POINTSIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomPointSize));
        dp.AddValue(G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_LINESIZE + G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE + inttostr(aPoint.CustomLineSize));
      finally
        dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i));
      end;

    end;
  finally
    dp.AddCloseTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_PROPERTIES);
  end;


end;

procedure TRGBCurves.ReadImport(dp: TNWSComps_DataParser);

var
  sparsedStr: string;
  bOk: boolean;
  origDecSep: char;
  sReadGuid: string;
  sReadTitle: string;
  sReadVersion: string;
  sReadDecSep: string;
  sReadPointCoordsSep: string;
  sReadPropSep: string;
  sReadAlgorithm: string;
  sReadInterpMin: string;
  sReadInterpMax: string;

  sReadComplementarv: string;

  sPArsedStr_PropId, sPArsedStr_PropValue: string;

  NRGB, NRed, NGreen, NBlue: integer;
  i, k: integer;

  aPoint: TRGBCurves_doublePoint;
  aTag: string;

  procedure DataStrToPoint(const dataStr: string; var thePoint: TRGBCurves_doublePoint);
  var
    apos: integer;
  begin
    aPos := pos(sReadPointCoordsSep, datastr);
    thePoint.x := strtofloat(copy(dataStr, 1, apos - 1));
    thePoint.y := strtofloat(copy(dataStr, apos + length(sReadPointCoordsSep), length(datastr) - aPos - length(sReadPointCoordsSep) + 1));
  end;


  procedure DataStrToProperty(const dataStr: string;
                              var PropIDStr: string;
                              var PropValueStr: String
                              );
  var
    apos: integer;
  begin
    aPos := pos(sReadPropSep, datastr);

    PropIDStr := copy(dataStr, 1, apos - 1);
    PropValueStr := copy(dataStr, apos + length(sReadPropSep), length(datastr) - aPos - length(sReadPropSep) + 1);

  end;


  procedure SetProperty(thePropId: string; thePropValue: string; thePoint: TRGBCurves_PointItem);
  begin
    if thePropid = G_CONST_RGBCURVES_FILE_ID_PROPERTY_USECUSTOMLAYOUT then
      thePoint.UseCustomLayout := boolean(strtoint(thePropValue))
    else if thePropId = G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_OUTLINECOLOR then
      thePoint.CustomOutlineColor := strtoint(thePropValue)
    else if thePropId = G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_FILLCOLOR then
      thePoint.CustomFillColor := strtoint(thePropValue)
    else if thePropId = G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_POINTSIZE then
      thePoint.CustomPointSize := strtoint(thePropValue)
    else if thePropId = G_CONST_RGBCURVES_FILE_ID_PROPERTY_CUSTOM_LINESIZE then
      thePoint.CustomLineSize := strtoint(thePropValue);


  end;

begin
  fReadingFromFile := TRUE;
  TRY
    origDecSep := DataParser_GetDecimalSeparator;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_TITLE, sReadTitle);
    bOk := bOk and (sReadTitle = G_CONST_RGBCURVES_FILE_HEADER_TITLE_VALUE);
    if not bOk then
      EXIT; // >>>> EXIT wrong Header

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_GUID, sReadGuid);
    bOk := bOk and (sReadGuid = G_CONST_RGBCURVES_FILE_HEADER_GUID_VALUE);
    if not bOk then
      EXIT; // >>>> EXIT wrong Header

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_HEADER_VERSION, sReadVersion);
    if not bOk then
      EXIT; // >>>> EXIT wrong Header (missing version)

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_DECSEP, sReadDecSep);
    if not bOk then
      EXIT; // >>>> EXIT missing decimal separator


    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_POINTCOORDSSEP, sReadPointCoordsSep);
    if not bOk then
      EXIT; // >>>> EXIT missing points coordinates separator

    // Separator between name of property and its value
    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_PROPERTYSEP, sReadPropSep);
    if not bOk then
      EXIT; // >>>> EXIT missing property separator

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_ALGORITHM, sReadAlgorithm);
    if not bOk then
    begin
      sReadAlgorithm := G_CONST_RGBCURVES_ALG_3200_1;
    end;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_INTERPLIN_MIN, sReadInterpMin);
    if not bOk then
    begin
      sReadInterpMin := '0';
    end;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_INTERPLIN_MIN, sReadInterpMax);
    if not bOk then
    begin
      sReadInterpMin := '75';
    end;

    // -----------------------------------
    DataParser_SetSysDecimalSeparator(sReadDecSep[1]);

    fInterpLinear_Min := strtoint(sReadInterpMin);
    fInterpLinear_Max := strtoint(sReadInterpMax);
    RGBCurves_InterpAlgorithm := sReadAlgorithm;
    // -----------------------------------


    //v.4
    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_COMPLEMENTARY, sReadComplementarv);
    if not bOk then
    begin
      sReadComplementarv := BoolToStr(false);
    end;
    fComplementaryCurves := StrToBool(sReadComplementarv);

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_COUNT, sParsedStr);
    if bOk then
    begin
      NRGB := strtoint(sParsedStr);
    end
    else
      NRGB := 0;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_COUNT, sParsedStr);
    if bOk then
    begin
      NRed := strtoint(sParsedStr);
    end
    else
      NRed := 0;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_COUNT, sParsedStr);
    if bOk then
    begin
      NGreen := strtoint(sParsedStr);
    end
    else
      NGreen := 0;

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_COUNT, sParsedStr);
    if bOk then
    begin
      NBlue := strtoint(sParsedStr);
    end
    else
      NBlue := 0;

    if NRGB > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_DATA);
      if bOk then
      begin
        fPoints_RGB.Clear;
        try
          for i := 0 to NRGB - 1 do
          begin
            if dp.ParseTag_Element(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_DATA, i, sParsedStr) then
            begin
              DataStrToPoint(sPArsedStr, aPoint);
              fPoints_RGB.AddPoint(aPoint, False);
            end;
          end;
        except
          fPoints_RGB.DefineDefault(False);
        end;
      end;
    end;
    if fPoints_RGB.Count < 2 then // something went wrong
    begin
      fPoints_RGB.DefineDefault(False);
    end;

    if NRed > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_DATA);
      if bOk then
      begin
        fPoints_Red.Clear;
        try
          for i := 0 to NRed - 1 do
          begin
            if dp.ParseTag_Element(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_DATA, i, sParsedStr) then
            begin
              DataStrToPoint(sPArsedStr, aPoint);
              fPoints_Red.AddPoint(aPoint, False);
            end;
          end;
        except
          fPoints_Red.DefineDefault(False);
        end;
      end;
    end;
    if fPoints_RED.Count < 2 then // something went wrong
    begin
      fPoints_RED.DefineDefault(False);
    end;

    if NGreen > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_DATA);
      if bOk then
      begin
        fPoints_Green.Clear;
        try
          for i := 0 to NGreen - 1 do
          begin
            if dp.ParseTag_Element(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_DATA, i, sParsedStr) then
            begin
              DataStrToPoint(sPArsedStr, aPoint);
              fPoints_Green.AddPoint(aPoint, False);
            end;
          end;
        except
          fPoints_GREEN.DefineDefault(False);
        end;
      end;
    end;
    if fPoints_Green.Count < 2 then // something went wrong
    begin
      fPoints_Green.DefineDefault(False);
    end;


    if NBlue > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_DATA);
      if bOk then
      begin
        fPoints_Blue.Clear;
        try
          for i := 0 to NBlue - 1 do
          begin
            if dp.ParseTag_Element(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_DATA, i, sParsedStr) then
            begin
              DataStrToPoint(sPArsedStr, aPoint);
              fPoints_Blue.AddPoint(aPoint, False);
            end;
          end;
        except
          fPoints_BLUE.DefineDefault(False);
        end;

      end;
    end;
    if fPoints_Blue.Count < 2 then // something went wrong
    begin
      fPoints_Blue.DefineDefault(False);
    end;


    if NRGB > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_PROPERTIES);
      if bOk then
      begin
        try

          for i := 0 to NRGB - 1 do
          begin
            aTag := G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i);
            bOk := dp.TagExists(aTag);
            if bOk then
            begin
              k := 0;
              while dp.ParseTag_Element(aTag, k, sParsedStr) do
              begin
                DataStrToProperty(sPArsedStr, sPArsedStr_PropId, sPArsedStr_PropValue);
                SetProperty(sPArsedStr_PropId, sPArsedStr_PropValue, fPoints_RGB.PointItem[i]);
                inc(k);
              end;
            end;

          end;
        except
          ;
        end;
      end;
    end;

   if NRED > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_REDPOINTS_PROPERTIES);
      if bOk then
      begin
        try

          for i := 0 to NRED - 1 do
          begin
            aTag := G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i);
            bOk := dp.TagExists(aTag);
            if bOk then
            begin
              k := 0;
              while dp.ParseTag_Element(aTag, k, sParsedStr) do
              begin
                DataStrToProperty(sPArsedStr, sPArsedStr_PropId, sPArsedStr_PropValue);
                SetProperty(sPArsedStr_PropId, sPArsedStr_PropValue, fPoints_RED.PointItem[i]);
                inc(k);
              end;
            end;

          end;
        except
          ;
        end;
      end;
    end;


    if NGREEN > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_GREENPOINTS_PROPERTIES);
      if bOk then
      begin
        try

          for i := 0 to NGREEN - 1 do
          begin
            aTag := G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i);
            bOk := dp.TagExists(aTag);
            if bOk then
            begin
              k := 0;
              while dp.ParseTag_Element(aTag, k, sParsedStr) do
              begin
                DataStrToProperty(sPArsedStr, sPArsedStr_PropId, sPArsedStr_PropValue);
                SetProperty(sPArsedStr_PropId, sPArsedStr_PropValue, fPoints_GREEN.PointItem[i]);
                inc(k);
              end;
            end;

          end;
        except
          ;
        end;
      end;
    end;


    if NBLUE > 0 then
    begin
      bOk := dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_BLUEPOINTS_PROPERTIES);
      if bOk then
      begin
        try

          for i := 0 to NBLUE - 1 do
          begin
            aTag := G_CONST_RGBCURVES_FILE_TAG_POINTITEM_X + inttostr(i);
            bOk := dp.TagExists(aTag);
            if bOk then
            begin
              k := 0;
              while dp.ParseTag_Element(aTag, k, sParsedStr) do
              begin
                DataStrToProperty(sPArsedStr, sPArsedStr_PropId, sPArsedStr_PropValue);
                SetProperty(sPArsedStr_PropId, sPArsedStr_PropValue, fPoints_BLUE.PointItem[i]);
                inc(k);
              end;
            end;

          end;
        except
          ;
        end;
      end;
    end;

  finally
    DataParser_SetSysDecimalSeparator(origDecSep);
    fReadingFromFile := False;
  end;
end;

procedure TRGBCurves.ReadImportList(var implist: Tstringlist);
var
  i: integer;
  tempstr: string;
  NRGB, NR, NG, NB, ix: integer;
  TransfArray: TRGBCurves_DoublePointsarray;
begin
  with implist do
  begin
    tempstr := strings[0];
    if tempstr = G_CONST_RGBCURVES_FILE_HEADER_TITLE_VALUE_OLD then
    begin
      tempstr := implist.strings[1];
      if tempstr = G_CONST_RGBCURVES_FILE_HEADER_VERSION_VALUE_OLD then
      begin
        ix := 2;

        ix := ix + 1; // RGB points
        NRGB := strtoint(strings[ix]);
        setlength(TransfArray, NRGB);
        for i := 0 to NRGB - 1 do
        begin
          ix := ix + 1;
          TransfArray[i].x := strtofloat(strings[ix]);
          ix := ix + 1;
          TransfArray[i].Y := strtofloat(strings[ix]);
        end;
        fPoints_RGB.Define(TransfArray, False);
        ix := ix + 1;

        ix := ix + 1; // R points
        NR := strtoint(strings[ix]);
        setlength(TransfArray, NR);
        for i := 0 to NR - 1 do
        begin
          ix := ix + 1;
          TransfArray[i].x := strtofloat(strings[ix]);
          ix := ix + 1;
          TransfArray[i].Y := strtofloat(strings[ix]);
        end;
        fPoints_RED.Define(TransfArray, False);
        ix := ix + 1;

        ix := ix + 1; // G points
        NG := strtoint(strings[ix]);
        setlength(TransfArray, NG);
        for i := 0 to NG - 1 do
        begin
          ix := ix + 1;
          TransfArray[i].x := strtofloat(strings[ix]);
          ix := ix + 1;
          TransfArray[i].Y := strtofloat(strings[ix]);
        end;
        fPoints_GREEN.Define(TransfArray, False);
        ix := ix + 1;

        ix := ix + 1; // B points
        NB := strtoint(strings[ix]);
        setlength(TransfArray, NB);
        for i := 0 to NB - 1 do
        begin
          ix := ix + 1;
          TransfArray[i].x := strtofloat(strings[ix]);
          ix := ix + 1;
          TransfArray[i].Y := strtofloat(strings[ix]);
        end;
        fPoints_BLUE.Define(TransfArray, False);

      end;
    end;
  end;

end;




// ***********Protected Methods*******************************

procedure TRGBCurves.Resize;
begin
  inherited;

  Graph_Update_NoEvents;
end;

procedure TRGBCurves.Loaded;
begin
  inherited;
  fLayout.IsReady := True;
  Graph_Update_NoEvents;
end;

procedure TRGBCurves.Paint;
begin
  inherited;
  Graph_Show;
  if assigned(fOnPaint) then
    fOnPaint(self);
end;

function TRGBCurves.MouseOnGraphPoint(Graph_x, Graph_Y: double): integer;
var
  m: integer;
begin
  result := -1;
  for m := 0 to fpoints.Count - 1 do
  begin
    if (abs(fpoints.Data[m].x - Graph_x) < fPointDetectTolerance) then
    begin
      if (not(Opt_Allow_Grip_OnYCoord in fOptions)) or (abs(fpoints.Data[m].y - Graph_Y) < fPointDetectTolerance) then
      begin
        result := m;
        break;
      end;
    end;
  end;

end;

procedure TRGBCurves.MouseDown(Button: TMouseButton; Shift: TShiftState; x, Y: integer);
var
  actualx, actualy: single;
  bClickonPoint: boolean;
  ClickIdx: integer;
  adblPoint: TRGBCurves_doublePoint;
begin
  inherited;
  fEditMode := emNil;
  if (fCurveMode <> cmBuildCurves) then
    exit; // >>>>EXIT

  actualx := 1 / fxratio * (x - fxgap);
  actualy := 1 / fyratio * (Height - Y - fygap);

  ClickIdx := MouseOnGraphPoint(actualx, actualy);
  bClickonPoint := ClickIdx <> -1;
  if bClickonPoint then
    fPoints.CurrentIdx := ClickIdx;

  if Button = mbleft then
  begin
    if bClickonPoint then
    begin
      fEditMode := emMovePoint;
    end
    else
    begin
      if Opt_Allow_AddPoints in fOptions then
      begin // add point
        fEditMode := emAddPoint;
        adblPoint.x := actualx;
        adblPoint.y := actualy;

        AddPoint(adblPoint, false);
      end;
    end;

  end
  else if bClickonPoint then
  begin // remove point
    if Opt_Allow_RemovePoints in fOptions then
      RemovePoint(fPoints.CurrentIdx, false);
  end;
end;


procedure TRGBCurves.MouseMove(Shift: TShiftState; x, Y: integer);
var
  actualx, actualy: single;
  minx, maxx: single;
  bTestOnPoint: boolean;
  iCurIdx: integer;

  temppoint: TRGBCurves_doublepoint;

  CanMove: TRGBCurves_CanMoveType;
begin
  inherited;

  actualx := 1 / fxratio * (x - fxgap);
  actualy := 1 / fyratio * (Height - Y - fygap);



  if fEditMode = emMovePoint then
  begin
    if fPoints.CurrentIdx = 0 then
      minx := 0
    else
      minx := fpoints.data[fpoints.CurrentIdx - 1].x + 1;

    if fPoints.CurrentIdx = fpoints.Count - 1 then
      maxx := 255
    else
      maxx := fpoints.data[fpoints.CurrentIdx + 1].x - 1;

    CanMove := cm_XY;
    if assigned(fOnMovePoint) then
      fOnMovePoint(self, fPoints.CurrentPoint, fPoints.CurrentIdx, CanMove);

    if CanMove <> cm_CannotMove then
    begin
      temppoint.x := fpoints.CurrentPoint.x;
      temppoint.Y := fpoints.CurrentPoint.Y;

      case CanMove of
        cm_XY, cm_X_only:
          begin
            actualx := max(actualx, minx);
            actualx := min(actualx, maxx);
            temppoint.x := actualx;
          end;
      end;

      case CanMove of
        cm_XY, cm_Y_only:
          begin
            actualy := max(0, actualy);
            actualy := min(255, actualy);

            temppoint.Y := actualy;
          end;
      end;

      if assigned(fOnMovingPoint) then
        fOnMovingPoint(self, temppoint);

      SetthePoint(fPoints.CurrentIdx, temppoint, false);
      Graph_UpdateAndShow;

    end;

  end
  else
  begin
    iCurIdx := MouseOnGraphPoint(actualx, actualy);
    bTestOnPoint := iCurIdx <> -1;

    (*
    if bTestOnPoint then
      fPoints.CurrentIdx := iCurIdx;
      *)
    if bTestOnPoint then
    begin
      cursor := crhandpoint;
    end
    else
    begin
      if fCurveMode = cmFormulaCurves then
        cursor := crdefault
      else
        cursor := crcross;
    end;

  end;

end;

procedure TRGBCurves.MouseUp(Button: TMouseButton; Shift: TShiftState; x, Y: integer);
begin
  inherited;
  fEditMode := emNil;
  Graph_UpdateAndShow;
end;



procedure TRGBCurves.IEView_Preview_RefreshPreview;
begin

  if not assigned(fIEViewEventsHandler) then
    EXIT;

  fIEViewEventsHandler.RefreshPReview;

end;

// ***********Public Methods*******************************

procedure TRGBCurves.Update;
begin
  Invalidate;
  Graph_Update;
  inherited;
end;

procedure TRGBCurves.Repaint;
begin
  Graph_Update;
  inherited;
end;

procedure TRGBCurves.Refresh;
begin
  Graph_Update;
  inherited;
end;

procedure TRGBCurves.GetHistogramfromBMP(bmp: Tbitmap);
type
  TBGRAbytearray = array [0 .. 3] of byte;
  TBytearray = array [0 .. 32767] of byte;
  PByteArray = ^TBytearray;
var
  i, j, k: integer;
  pp: PByteArray;
  gray: integer;
  BGRA: TBGRAbytearray;
  tempx: integer;
  shiftby, readby: integer;
  pf: TPixelFormat;
begin
  if not assigned(bmp) then
    exit;
  pf := bmp.pixelformat;
  case pf of
    pf8bit:
      shiftby := 1;
    pf24bit:
      shiftby := 3;
    pf32bit:
      shiftby := 4;
  else
    exit; // >>>>EXIT
  end;

  readby := min(shiftby - 1, 2);

  fHistogram.active := true;
  for i := 0 to 255 do
  begin
    fHistogram.Reds[i] := 0;
    fHistogram.Greens[i] := 0;
    fHistogram.Blues[i] := 0;
    fHistogram.Grays[i] := 0;
    fHistogram.Cyans[i] := 0;
    fHistogram.Magentas[i] := 0;
    fHistogram.Yellows[i] := 0;
    fHistogram.Inks[i] := 0;
  end;

  for j := 0 to bmp.Height - 1 do
  begin
    pp := bmp.scanline[j];
    for i := 0 to bmp.Width - 1 do
    begin
      tempx := shiftby * i;
      for k := 0 to readby do
        BGRA[k] := pp[tempx + k];

      case pf of
        pf8bit:
          begin
            gray := BGRA[0];
            fHistogram.Grays[gray] := fHistogram.Grays[gray] + 1;
            fHistogram.Inks[255 - gray] := fHistogram.Inks[255 - gray] + 1;
          end
        else
        begin
          gray := round(0.3 * BGRA[2] + 0.6 * BGRA[1] + 0.1 * BGRA[0]);
          fHistogram.Blues[BGRA[0]] := fHistogram.Blues[BGRA[0]] + 1;
          fHistogram.Greens[BGRA[1]] := fHistogram.Greens[BGRA[1]] + 1;
          fHistogram.Reds[BGRA[2]] := fHistogram.Reds[BGRA[2]] + 1;
          fHistogram.Grays[gray] := fHistogram.Grays[gray] + 1;


          fHistogram.Yellows[255 - BGRA[0]] := fHistogram.Yellows[255 - BGRA[0]] + 1;
          fHistogram.Magentas[255 - BGRA[1]] := fHistogram.Magentas[255 - BGRA[1]] + 1;
          fHistogram.Cyans[255 - BGRA[2]] := fHistogram.Cyans[255 - BGRA[2]] + 1;
          fHistogram.Inks[255 - gray] := fHistogram.Inks[255 - gray] + 1;
        end;
      end;

    end;
  end;

  with fHistogram do
  begin
    peakred := GetMaxvalue(fHistogram.Reds);
    peakgreen := GetMaxvalue(fHistogram.Greens);
    peakblue := GetMaxvalue(fHistogram.Blues);
    peakgray := GetMaxvalue(fHistogram.Grays);

    peakcyan := GetMaxvalue(fHistogram.Cyans);
    peakmagenta := GetMaxvalue(fHistogram.Magentas);
    peakyellow := GetMaxvalue(fHistogram.Yellows);
    peakink := GetMaxvalue(fHistogram.Inks);

    avgred := GetAvgvalue(fHistogram.Reds);
    avggreen := GetAvgvalue(fHistogram.Greens);
    avgblue := GetAvgvalue(fHistogram.Blues);
    avggray := GetAvgvalue(fHistogram.Grays);

    avgcyan := GetAvgvalue(fHistogram.Cyans);
    avgmagenta := GetAvgvalue(fHistogram.Magentas);
    avgyellow := GetAvgvalue(fHistogram.Yellows);
    avgink := GetAvgvalue(fHistogram.Inks);
  end;
  Graph_UpdateAndShow_NoEvents;
end;

procedure TRGBCurves.ApplyCurvestoBitmap(thebitmap: Tbitmap);
var
  i, j: integer;
  RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT;
  pp: tpRGBCurves_row;
  tempx: integer;
  shiftby: byte;
  r, g, b: byte;
  r_new, g_new, b_new: byte;
  Lum, Lum_old: byte;
  pf: TPixelFormat;
  mix_amt: integer;
begin
  if not assigned(thebitmap) then
    exit;

  pf := thebitmap.pixelformat;
  case pf of
    pf8bit:
      begin
        shiftby := 1;
        if CurveMode = cmFormulaCurves then
          Calc_Formula_LUT(RGBLUT, fvmAll)
        else
          Calc_LUT(RGBLUT, cmAll);
      end;
    pf24bit:
      begin
        shiftby := 3;
        Calc_LUTS_All(RGBLUT, rLUT, gLUT, bLUT);
      end;
    pf32bit:
      begin
        shiftby := 4;
        Calc_LUTS_All(RGBLUT, rLUT, gLUT, bLUT);
      end;
  else
    exit; // >>>> EXIT
  end;

  for j := 0 to thebitmap.Height - 1 do
  begin
    pp := thebitmap.scanline[j];
    for i := 0 to thebitmap.Width - 1 do
    begin

      case pf of
        pf8bit:
          begin
            Lum := pp[i];
            pp[i] := RGBLUT[Lum];
          end;
        pf24bit, pf32bit:
          begin
            tempx := shiftby * i;
            r := pp[tempx + 2];
            g := pp[tempx + 1];
            b := pp[tempx];
            r := rLUT[r];
            g := gLUT[g];
            b := bLUT[b];

            case fRGBSpace of
              csLum:
                begin
                  RGBtoLum(r, g, b, Lum_old);
                  Lum := RGBLUT[Lum_old];
                  LumRGBToLumRGB(r, g, b, Lum_old, Lum, r_new, g_new, b_new);

                  pp[tempx + 2] := r_new;
                  pp[tempx + 1] := g_new;
                  pp[tempx] := b_new;
                end;
              csMixed:
                begin
                  RGBtoLum(r, g, b, Lum_old);
                  Lum := RGBLUT[Lum_old];
                  LumRGBToLumRGB(r, g, b, Lum_old, Lum, r_new, g_new, b_new);
                  mix_amt :=  max(0, min(100, fColorSpaceMixAmount + round((lum - lum_old)* (255 - lum_old)/255) ));
                  pp[tempx + 2] := (mix_amt * r_new + (100 - mix_amt) * RGBLUT[r]) div 100;
                  pp[tempx + 1] := (mix_amt * g_new + (100 - mix_amt) * RGBLUT[g]) div 100;
                  pp[tempx] := (mix_amt * b_new + (100 - mix_amt) * RGBLUT[b]) div 100;

                end;
              csRGB:
                begin
                  r := RGBLUT[r];
                  g := RGBLUT[g];
                  b := RGBLUT[b];

                  pp[tempx + 2] := r;
                  pp[tempx + 1] := g;
                  pp[tempx] := b;
                end;
            end;

          end;
      end;

    end;
  end;
end;

procedure TRGBCurves.ApplyGrayCurvetoBitmap_ToneMapped(thebitmap: Tbitmap; tonemap: Tbitmap; const dyn_amt: single);
var
  i, j: integer;
  LumLUT: TRGBCurves_LUT;
  pp: tpRGBCurves_row;
  pp_tm: PByteArray;
  tempx: integer;
  shiftby: byte;
  r, g, b: byte;
  r_new, g_new, b_new: byte;
  r_new1, g_new1, b_new1: byte;
  Lum_new, Lum, Lum_InZone: byte;
  DL: integer;

  amt: byte;
begin
  if not assigned(thebitmap) then
    exit;
  if not assigned(tonemap) then
    exit;

  case thebitmap.pixelformat of
    pf24bit:
      shiftby := 3;
    pf32bit:
      shiftby := 4
    else
      exit;
  end;

  Calc_LUT(LumLUT, cmAll);

  for j := 0 to thebitmap.Height - 1 do
  begin
    pp := thebitmap.scanline[j];
    pp_tm := tonemap.scanline[j];
    for i := 0 to thebitmap.Width - 1 do
    begin
      tempx := shiftby * i;

      r := pp[tempx + 2];
      g := pp[tempx + 1];
      b := pp[tempx];

      RGBtoLum(r, g, b, Lum);
      Lum_InZone := pp_tm[i];

      amt := round(255 * (1 - abs(Lum - Lum_InZone) / (Lum + Lum_InZone + 1)));

      Lum_new := LumLUT[Lum_InZone];

      LumRGBToLumRGB(r, g, b, Lum_InZone, Lum_new, r_new, g_new, b_new);

      DL := Lum_new - Lum_InZone;

      if DL > 0 then
      begin
        r_new1 := min(255, r + DL);
        g_new1 := min(255, g + DL);
        b_new1 := min(255, b + DL);
      end
      else
      begin
        r_new1 := max(0, r + DL);
        g_new1 := max(0, g + DL);
        b_new1 := max(0, b + DL);
      end;

      r_new := (fColorSpaceMixAmount * r_new + (100 - fColorSpaceMixAmount) * r_new1) div 100;
      g_new := (fColorSpaceMixAmount * g_new + (100 - fColorSpaceMixAmount) * g_new1) div 100;
      b_new := (fColorSpaceMixAmount * b_new + (100 - fColorSpaceMixAmount) * b_new1) div 100;

      r_new := (amt * r_new + (255 - amt) * LumLUT[r]) div 255;
      g_new := (amt * g_new + (255 - amt) * LumLUT[g]) div 255;
      b_new := (amt * b_new + (255 - amt) * LumLUT[b]) div 255;

      pp[tempx + 2] := r_new;
      pp[tempx + 1] := g_new;
      pp[tempx] := b_new;
      { }

    end;
  end;
end;



procedure TRGBCurves.GetHistogramfromIEBMP(theIEbmp: TIEbitmap);
var
  i, j: integer;
  gray: integer;
  apixel24: TRGB;
  aPixel8: byte;
  pf: tiepixelformat;
  pb:pbyte;

begin
  if not assigned(theIEbmp) then
    exit;

  pf := theIEbmp.pixelformat;
  case pf of
    ie8p,ie8g, ie24RGB:
      ; // ok
  else
    exit; // >>>> EXIT
  end;


  fHistogram.active := true;


  for i := 0 to 255 do
  begin
    fHistogram.Reds[i] := 0;
    fHistogram.Greens[i] := 0;
    fHistogram.Blues[i] := 0;
    fHistogram.Grays[i] := 0;
    fHistogram.Cyans[i] := 0;
    fHistogram.Magentas[i] := 0;
    fHistogram.Yellows[i] := 0;
    fHistogram.Inks[i] := 0;
  end;

  for j := 0 to theIEbmp.Height - 1 do
  begin
     pb := theIEbmp.ScanLine[j];


    for i := 0 to theIEbmp.Width - 1 do
    begin
      case pf of
        ie24RGB:
          begin
          

            apixel24.b := pb^;
            inc(pb, sizeof(byte));
            apixel24.g := pb^;
            inc(pb, sizeof(byte));
            apixel24.r := pb^;
            inc(pb, sizeof(byte));

            gray := round(0.3 * apixel24.r + 0.6 * apixel24.g + 0.1 * apixel24.b);
            fHistogram.Blues[apixel24.b] := fHistogram.Blues[apixel24.b] + 1;
            fHistogram.Greens[apixel24.g] := fHistogram.Greens[apixel24.g] + 1;
            fHistogram.Reds[apixel24.r] := fHistogram.Reds[apixel24.r] + 1;
            fHistogram.Grays[gray] := fHistogram.Grays[gray] + 1;

            fHistogram.Yellows[255 - apixel24.b] := fHistogram.Yellows[255 - apixel24.b] + 1;
            fHistogram.Magentas[255 - apixel24.g] := fHistogram.Magentas[255 - apixel24.g] + 1;
            fHistogram.Cyans[255 - apixel24.r] := fHistogram.Cyans[255 - apixel24.r] + 1;
            fHistogram.Inks[255 - gray] := fHistogram.Inks[255 - gray] + 1;

           // inc(pt24);
         (*  *)
          end;
        ie8p,ie8g:
          begin
            //aPixel8 := theIEbmp.Pixels_ie8[i, j];
            //aPixel8 := pb[i];
            apixel8 := pb^;
            inc(pb, sizeof(byte));
            fHistogram.Grays[aPixel8] := fHistogram.Grays[aPixel8] + 1;
            fHistogram.Inks[255 - aPixel8] := fHistogram.Inks[255 - aPixel8] + 1;

            // Inc(PByte(pt8));
          end;
      end;

    end;
  end;

  with fHistogram do
  begin
    peakred := GetMaxvalue(fHistogram.Reds);
    peakgreen := GetMaxvalue(fHistogram.Greens);
    peakblue := GetMaxvalue(fHistogram.Blues);
    peakgray := GetMaxvalue(fHistogram.Grays);

    peakcyan := GetMaxvalue(fHistogram.Cyans);
    peakmagenta := GetMaxvalue(fHistogram.Magentas);
    peakyellow := GetMaxvalue(fHistogram.Yellows);
    peakink := GetMaxvalue(fHistogram.Inks);

    avgred := GetAvgvalue(fHistogram.Reds);
    avggreen := GetAvgvalue(fHistogram.Greens);
    avgblue := GetAvgvalue(fHistogram.Blues);
    avggray := GetAvgvalue(fHistogram.Grays);

    avgcyan := GetAvgvalue(fHistogram.Cyans);
    avgmagenta := GetAvgvalue(fHistogram.Magentas);
    avgyellow := GetAvgvalue(fHistogram.Yellows);
    avgink := GetAvgvalue(fHistogram.Inks);
  end;
  Graph_UpdateAndShow_NoEvents;
  (* *)
end;

procedure TRGBCurves.GetHistoLimitValues(percentLimitMin:double;
                                         percentLimitMax:double;
                                         var LimitMinGray: byte;
                                         var  LimitMaxGray: byte;
                                         var LimitMinRed: byte;
                                         var  LimitMaxRed: byte;
                                         var LimitMinGreen: byte;
                                         var  LimitMaxGreen: byte;
                                         var LimitMinBlue: byte;
                                         var  LimitMaxBlue: byte;
                                         var LimitMinCyan: byte;
                                         var  LimitMaxCyan: byte;
                                         var LimitMinMagenta: byte;
                                         var  LimitMaxMagenta: byte;
                                         var LimitMinYellow: byte;
                                         var  LimitMaxYellow: byte;
                                         var LimitMinInk: byte;
                                         var  LimitMaxInk: byte);
var
  sum, sumMin, sumMax:cardinal;
  i:integer;
  percMin, percMax: double;
begin
  percMin := percentLimitMin/100;
  percMax := percentLimitMax/100;
  LimitMinGray := 0;
  LimitMaxGray := 255;
  LimitMinRed := 0;
  LimitMaxRed := 255;
  LimitMinGreen := 0;
  LimitMaxGreen := 255;
  LimitMinBlue := 0;
  LimitMaxBlue := 255;
  LimitMinCyan := 0;
  LimitMaxCyan := 255;
  LimitMinMagenta := 0;
  LimitMaxMagenta := 255;
  LimitMinYellow := 0;
  LimitMaxYellow := 255;
  LimitMinInk := 0;
  LimitMaxInk := 255;

  if not fHistogram.active then  EXit;

  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Grays[i];

  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Grays[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinGray := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Grays[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxGray := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Reds[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Reds[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinRed := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Reds[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxRed := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Greens[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Greens[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinGreen := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Greens[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxGreen := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Blues[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Blues[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinBlue := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Blues[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxBlue := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Cyans[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Cyans[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinCyan := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Cyans[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxCyan := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Magentas[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Magentas[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinMagenta := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Magentas[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxMagenta := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Yellows[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Yellows[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinYellow := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Yellows[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxYellow := i;


  sum := 0;
  for I := 0 to 255 do
     sum := sum + fHistogram.Inks[i];
  sumMin := 0;
  for I := 0 to 255 do
  begin
    sumMin := sumMin + fHistogram.Inks[i];
    if sumMin > percmin * sum then
       break;
  end;
  LimitMinInk := i;

  sumMax := 0;
  for I := 255 downto 0 do
  begin
    sumMax := sumMax + fHistogram.Inks[i];
    if sumMax > percmax * sum then
       break;
  end;
  LimitMaxInk := i;


end;


procedure TRGBCurves.GetHistogramfromImageEnView(theieView: TimageenView);
begin
  GetHistogramfromIEBMP(theieView.IEBitmap);
end;


procedure TRGBCurves.IEVIEW_RegisteredApplyMethod(previewID: TGUID;linkToFullBmp:boolean;
                                               theIEbmp: TIEbitmap; mask: TIEMask;
                                               EditedRect: TRect; const bUseMask: boolean);
begin
    ApplyCurvestoIEBitmap(theIEBmp, mask, EditedRect, bUseMask);
end;


procedure TRGBCurves.ApplyCurvestoIEBitmap(theIEbmp: TIEbitmap);
begin
  ApplyCurvestoIEBitmap(theIEbmp, nil, rect(0, 0, theIEbmp.Width - 1, theIEbmp.Height - 1), false);
end;


procedure TRGBCurves.ApplyCurvestoIEBitmap(theIEbmp: TIEbitmap; mask: TIEMask; EditedRect: TRect; const bUseMask: boolean);
var
  i, j: integer;
  apixel24, resultPixel24: TRGB;
  aPixel8, resultPixel8: byte;
  aMaskPixel: byte;
  pf: tiepixelformat;
  RGBLUT, rLUT, gLUT, bLUT: TRGBCurves_LUT;
  r, g, b: byte;
  r_new, g_new, b_new: byte;
  Lum, Lum_old: byte;

  x1, y1, x2, y2: integer;
  i_rgb: integer;
  PixelP: PByteArray;

  mix_amt: integer;
begin

  if not assigned(theIEbmp) then
    exit;

  x1 := max(0, EditedRect.Left);
  y1 := max(0, EditedRect.Top);
  x2 := min(theIEbmp.Width - 1, EditedRect.Right);
  y2 := min(theIEbmp.height - 1, EditedRect.Bottom);

  pf := theIEbmp.pixelformat;

  case pf of
    ie8g:
      begin
        if CurveMode = cmFormulaCurves then
          Calc_Formula_LUT(RGBLUT, fvmAll)
        else
          Calc_LUT(RGBLUT, cmAll);
      end;
    ie24RGB:
      begin
        Calc_LUTS_All(RGBLUT, rLUT, gLUT, bLUT);
      end;

  else
    exit; // >>>> EXIT
  end;

  for j := y1 to y2 do
  begin
    PixelP := theIEbmp.ScanLine[j];
    for i := x1 to x2 do
    begin
      if (not bUseMask) or mask.IsEmpty or (mask.getpixel(i, j) > 0) then
      begin
        case pf of
          ie8g:
            begin
              aPixel8 := PixelP[i];
              resultPixel8 := RGBLUT[aPixel8];
              if bUseMask and (not mask.IsEmpty) then
              begin
                case mask.BitsPerPixel of

                  8:
                    begin
                      aMaskPixel := mask.getpixel(i, j);
                      resultPixel8 := (aMaskPixel * resultPixel8 + (255 - aMaskPixel) * aPixel8) div 255;
                    end;
                end;
              end;

              // theIEbmp.Pixels_ie8[i, j] := resultPixel8;
              PixelP[i] := resultPixel8;
            end;
          ie24RGB:
            begin
              i_rgb := 3 * i;

              r := rLUT[PixelP[i_rgb + 2]];
              g := gLUT[PixelP[i_rgb + 1]];
              b := bLUT[PixelP[i_rgb]];

              case fRGBSpace of
                csLum:
                  begin
                    RGBtoLum(r, g, b, Lum_old);
                    Lum := RGBLUT[Lum_old];
                    LumRGBToLumRGB(r, g, b, Lum_old, Lum, r_new, g_new, b_new);

                    resultpixel24.r := r_new;
                    resultpixel24.g := g_new;
                    resultpixel24.b := b_new;
                  end;
                csMixed:
                  begin
                    RGBtoLum(r, g, b, Lum_old);
                    Lum := RGBLUT[Lum_old];
                    LumRGBToLumRGB(r, g, b, Lum_old, Lum, r_new, g_new, b_new);
                    mix_amt :=  max(0, min(100, fColorSpaceMixAmount + round((lum - lum_old)* (255 - lum_old)/255) ));
                    resultpixel24.r := (mix_amt * r_new + (100 - mix_amt) * RGBLUT[r]) div 100;
                    resultpixel24.g := (mix_amt * g_new + (100 - mix_amt) * RGBLUT[g]) div 100;
                    resultpixel24.b := (mix_amt * b_new + (100 - mix_amt) * RGBLUT[b]) div 100;
                  end;
                csRGB:
                  begin
                    r_new := RGBLUT[r];
                    g_new := RGBLUT[g];
                    b_new := RGBLUT[b];

                    resultpixel24.r := r_new;
                    resultpixel24.g := g_new;
                    resultpixel24.b := b_new;
                  end;
              end;

              if bUseMask and (not mask.IsEmpty) then
              begin
                case mask.BitsPerPixel of
                  8:
                    begin
                      aMaskPixel := mask.getpixel(i, j);
                      resultPixel24.r := (aMaskPixel * resultPixel24.r + (255 - aMaskPixel) * aPixel24.r) div 255;
                      resultPixel24.g := (aMaskPixel * resultPixel24.g + (255 - aMaskPixel) * aPixel24.g) div 255;
                      resultPixel24.b := (aMaskPixel * resultPixel24.b + (255 - aMaskPixel) * aPixel24.b) div 255;
                    end;
                end;
              end;

              PixelP[i_rgb + 2] := resultPixel24.r;
              PixelP[i_rgb + 1] := resultPixel24.g;
              PixelP[i_rgb] := resultPixel24.b;
              // theIEbmp.Pixels_ie24RGB[i, j] := resultPixel24;
            end;
        end;

      end;

    end;
  end;

end;


procedure TRGBCurves.ApplyCurvestoImageEnView(theIEView: TimageenView);
begin
  ApplyCurvestoIEBitmap(theIeview.IEBitmap, theIEView.SelectionMask,
                        rect(0,0, theIEView.IEBitmap.Width - 1, theIEView.IEBitmap.height - 1),
                        assigned(theIEView.SelectionMask) and (not theIEView.SelectionMask.IsEmpty));
  //fIEViewEventsHandler.ApplyChanges_Once(theIEView, IEVIEW_RegisteredApplyMethod);
end;


procedure TRGBCurves.IEView_Preview_ApplyChanges;
begin
  fIEViewEventsHandler.ApplyPreview;
end;


procedure TRGBCurves.IEView_Preview_Register(theIEView: TimageenView);
begin
  // fIEViewEventsHandler.AttachedIEView := theIEView;
  fIEViewEventsHandler.RegisterIEView(theIEView, IEVIEW_RegisteredApplyMethod);
end;


procedure TRGBCurves.IEView_Preview_UnRegister;
begin
  fIEViewEventsHandler.UnRegisterIEView;
end;


procedure TRGBCurves.IEView_Preview_Lock;
begin
  fIEViewEventsHandler.LockPreview;
end;


procedure TRGBCurves.IEView_Preview_UnLock;
begin
  fIEViewEventsHandler.UnlockPreview(true);
end;


procedure TRGBCurves.IEView_Preview_Toggle(const bToggleOn: boolean);
begin
  fIEViewEventsHandler.TogglePreview(bToggleOn);
end;


function TRGBCurves.PS_LoadCurves_FromFile(theCurvesfile: string):boolean;
var
  aStream: TFilestream;
  v, aCurvesCount, aPointsCount : byte;
  TransfArray: TRGBCurves_DoublePointsarray;
  aPoint: TRGBCurves_doublePoint;
  i, k: integer;

procedure ReadTwoBytes(var v: byte);
begin
//read and discard first byte (in delphi there is no equivalent of unsigned short int
  astream.Read(v, 1);
  //the second byte is the good one
  astream.Read(v, 1);
 // showmessage(inttostr(v));
end;
begin
   result := False;
   astream := Tfilestream.Create(theCurvesFile, fmOpenRead, fmShareDenyWrite);
   try
     //read version //2 bytes - shortint
     ReadTwoBytes(v);
   //  aVersion := v;
     //read count of curves //2 bytes - shortint
     ReadTwoBytes(v);
     aCurvesCount := v;

     //read each curve , ech point is a pair of byte values
     for i := 1 to min(4, aCurvesCount) do
     begin
       //read number of points in each curve //2 bytes - shortint
       ReadTwoBytes(v);
       aPointsCount := v;


       setlength(TransfArray, aPointsCount);
       for k := 0 to apointscount-1 do
       begin
         //read points ech point is a pair of shortint values //2 bytes - shortint
          ReadTwoBytes(v);
          aPoint.y := v;
          ReadTwoBytes(v);
          aPoint.x := v;
          TransfArray[k] := apoint;
       end;

       case i of
         1:   //i = 1 is RGB curve
         begin
           fPoints_RGB.Define(TransfArray, False);
         end;
         2:   //i = 2 is Red curve
         begin
           fPoints_RED.Define(TransfArray, False);
         end;
         3:   //i = 3 is Green curve
         begin
           fPoints_GREEN.Define(TransfArray, False);
         end;
         4:   //i = 4 is Blue curve
         begin
           fPoints_Blue.Define(TransfArray, False);
         end;
       end;
     end;

     result := true;
   finally
     astream.Free;
   end;

    fRGBmode := cmAll;
    Points_SetRGBMode;

    Graph_UpdateAndShow;
    if assigned(fOnchangeRGBMode) then
      fOnchangeRGBMode(self);

end;


procedure TRGBCurves.PS_SaveCurves_ToFile(theCurvesfile: string);
var
  aStream: TFilestream;
  aVersion : byte;
  i, k: integer;
  aCurve:TRGBCurves_PointList;
procedure WriteTwoBytes(const v: byte);
var
zeroV: byte;
begin
zeroV := 0;
//write first 0 byte
  astream.write(zeroV, 1);

  //the second byte is the good one
  astream.write(v, 1);
 // showmessage(inttostr(v));
end;
begin

   astream := Tfilestream.Create(theCurvesFile, fmCreate, fmShareDenyWrite);
   try


     //write version //2 bytes - shortint
     aVersion := 4;
     WriteTwoBytes(aVersion);

     //write count of curves //2 bytes - shortint
     WriteTwoBytes(4); //version 4

     //read each curve , ech point is a pair of byte values
     for i := 1 to 4 do
     begin

       case i of
         1:   //i = 1 is RGB curve
         begin
           aCurve := fPoints_RGB;
         end;
         2:   //i = 2 is Red curve
         begin
           aCurve := fPoints_RED;
         end;
         3:   //i = 3 is Green curve
         begin
           aCurve := fPoints_GREEN;
         end;
         else   //i = 4 is Blue curve
         begin
           aCurve := fPoints_BLUE;
         end;
       end;

       //write number of points in each curve //2 bytes - shortint
       WriteTwoBytes(aCurve.Count);

       for k := 0 to aCurve.Count-1 do
       begin
         //read points ech point is a pair of shortint values //2 bytes - shortint
          WriteTwoBytes(round(aCurve.PointItem[k].y));
          WriteTwoBytes(round(aCurve.PointItem[k].x));
       end;
     end;

   finally
     astream.Free;
   end;
end;




function TRGBCurves.LoadCurves_FromFile(theCurvesfile: string):boolean;
var
  dp: TNWSComps_DataParser;
  implist: Tstringlist;
begin
  dp := TNWSComps_DataParser.Create(True);
      dp.ReadTags_FromTextFile(theCurvesfile);
      try
        if dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_HEADER_GUID) then
          readimport(dp)
        else
        begin
          try
            implist := Tstringlist.Create;
            implist.loadfromFile(theCurvesfile);
            ReadImportList(implist);
          finally
            implist.free;
          end;
        end;

      finally
        dp.free;
      end;

      result := true;


      fRGBmode := cmAll;
      Points_SetRGBMode;

      Graph_UpdateAndShow;
      if assigned(fOnchangeRGBMode) then
        fOnchangeRGBMode(self);
end;

procedure TRGBCurves.SaveCurves_ToFile(theCurvesfile: string);
var
  dp: TNWSComps_DataParser;
begin

    dp := TNWSComps_DataParser.Create(false);
   try
    CreateExport(dp);
    dp.WriteTags_ToTextFile(theCurvesfile);
  finally
    dp.free;
  end;
end;


procedure TRGBCurves.ExportCurves;
var
//  explist: Tstringlist;
  savedlg: Tsavedialog;


begin

    savedlg := Tsavedialog.Create(self);
   try
    with savedlg do
    begin
      if fexportdirectory <> '' then
        InitialDir := fexportdirectory;
      DefaultExt := fIO_Options.File_DefaultExtension;
      Filter := fIO_Options.File_DefaultFilterStr;
    end;
    if savedlg.execute then
      SaveCurves_toFile(savedlg.FileName);

  finally
    savedlg.free;
  end;
end;


function TRGBCurves.ImportCurves: boolean;
var

  opendlg: Topendialog;

begin
  result := false;

    opendlg := Topendialog.Create(self);
    try
    with opendlg do
    begin
      if fexportdirectory <> '' then
        InitialDir := fexportdirectory;
      DefaultExt := fIO_Options.File_DefaultExtension;
      Filter := fIO_Options.File_DefaultFilterStr;
    end;
    if opendlg.execute then
      result := LoadCurves_FromFile(opendlg.FileName);

  finally
    opendlg.free;
  end;
end;


procedure TRGBCurves.ExportCurvestoINI(Inifile: Tinifile; IniSection: string);
var
  dp: TNWSComps_DataParser;
begin

  dp := TNWSComps_DataParser.Create(false);
  try
    CreateExport(dp);
    dp.WriteTags_ToIniFile(Inifile, IniSection);
  finally
    dp.free;
  end;
end;


procedure TRGBCurves.ImportCurvesfromINI(Inifile: Tinifile; IniSection: string);
var
  implist: Tstringlist;
  dp: TNWSComps_DataParser;
  procedure purifyImportList(var list: Tstringlist);
  var
    k, m: integer;
    s: string;
  begin
    for k := 0 to list.Count - 1 do
    begin
      for m := 1 to length(list.strings[k]) do
      begin
        if list.strings[k][m] = '=' then
          break;
      end;
      if m < length(list.strings[k]) then
      begin
        s := list.strings[k];
        delete(s, 1, m);
        list.strings[k] := s;
      end;
    end;
  end;

begin

  dp := TNWSComps_DataParser.Create(True);
  dp.ReadTags_FromIniFile(Inifile, IniSection);
  try
    if dp.TagExists(G_CONST_RGBCURVES_FILE_TAG_HEADER_GUID) then
      readimport(dp)
    else
    begin
      try
        implist := Tstringlist.Create;
        Inifile.ReadSectionvalues(IniSection, implist);
        purifyImportList(implist);
        ReadImportList(implist);
      finally
        implist.free;
      end;
    end;

  finally
    dp.free;
  end;

  fRGBmode := cmAll;
  Points_SetRGBMode;

  Graph_UpdateAndShow;
  if assigned(fOnchangeRGBMode) then
    fOnchangeRGBMode(self);
end;


procedure TRGBCurves.ResetPoints;
begin
  ResetPoints_NoUpdate;

  Graph_UpdateAndShow;

  if assigned(OnChangeRGBMode) then
    OnChangeRGBMode(self);
end;

procedure TRGBCurves.ResetPoints_NoUpdate;
begin
  RGBCurves_InterpAlgorithm := G_CONST_RGBCURVES_ALG_3200_1;

  fRGBmode := cmAll;
  fEditMode := emNil;
  fCurveCoefs := nil;

  fPoints_RGB.init;
  fPoints_RED.init;
  fPoints_GREEN.init;
  fPoints_BLUE.init;

  Points_SetRGBMode;
end;

procedure TRGBCurves.SetthePoint(ix: integer; thepoint: TRGBCurves_doublepoint; const bUpdate: boolean);
begin
  fPoints.SetPoint(ix, thePoint, bUpdate);
end;

procedure TRGBCurves.SetthePoint(ix: integer; thepoint: TPoint; const bUpdate: boolean);
var
  adblPoint: TRGBCurves_doublepoint;
begin

  adblPoint.x := thepoint.x;
  adblPoint.Y := thepoint.Y;

  SetthePoint(ix, adblPoint, bupdate);
end;

// *** 27-01-2008
procedure TRGBCurves.SetCurrentPoint(const thepoint: TRGBCurves_doublepoint; const bUpdate: boolean);
begin
  SetthePoint(fPoints.CurrentIdx, thepoint, bupdate);
  if bUpdate then
    Graph_UpdateAndShow;
end;
// 27-01-2008 ***

// *** 27-01-2008
Function TRGBCurves.GetCurrentPoint: TRGBCurves_doublepoint;
begin
  result := fpoints.CurrentPoint;
end;
// 27-01-2008 ***

Function TRGBCurves.GetCurrentPoint_IDX: integer;
begin
  result := fPoints.CurrentIdx;
end;

procedure TRGBCurves.SetCurrentPoint_Idx(theIdx: integer);
begin
   fpoints.CurrentIdx := theIdx;
   Update;
end;

procedure TRGBCurves.AddPoint(thepoint: TPoint; const bUpdate: boolean);
var
  aDblPoint: TRGBCurves_doublepoint;
begin

  aDblPoint.x := thepoint.x;
  aDblPoint.Y := thepoint.Y;

  AddPoint(aDblPoint, bupdate);
end;

procedure TRGBCurves.AddPoint(thepoint: TRGBCurves_doublepoint; const bUpdate: boolean);
begin

  fPoints.AddPoint(thePoint, bupdate);

end;

procedure TRGBCurves.RemovePoint(ix: integer; const bUpdate: boolean);
begin
  fPoints.RemovePoint(ix, bupdate);
end;

procedure TRGBCurves.RemovePoint_Current(const bUpdate: boolean);
begin
  fPoints.RemovePoint(fPoints.CurrentIdx, bupdate);
end;

Function TRGBCurves.GetPointAtXY(x,y: integer): TRGBCUrves_DoublePoint;
var
actualx, actualy:double;
iCurIdx:integer;
pt: TRGBCUrves_DoublePoint;
begin
  actualx := 1 / fxratio * (x - fxgap);
  actualy := 1 / fyratio * (Height - Y - fygap);
  iCurIdx := MouseOnGraphPoint(actualx, actualy);
  if ICurIDx = -1 then
  begin
    result.x := -1;
    result.y := -1;
  end
  else
  begin
    result.x := fpoints.Data[iCurIdx].x;
    result.y := fpoints.Data[iCurIdx].y;
  end;
end;

function TRGBCurves.ExportLUT(mode: TRGBCurves_RGBmode): TRGBCurves_LUT;
begin
  if fCurveMode <> cmFormulaCurves then
  begin
    Calc_LUT(result, mode);
  end
  else
  begin
    case mode of
      cmAll:
        Calc_Formula_LUT(result, fvmAll);
      cmRed:
        Calc_Formula_LUT(result, fvmRed);
      cmGreen:
        Calc_Formula_LUT(result, fvmGreen);
      cmBlue:
        Calc_Formula_LUT(result, fvmBlue);
    end;
  end;
end;

procedure TRGBCurves.ExportLUTs(var BGRALUTarray: TRGBCurves_Lutarray; var GrayLUT: TRGBCurves_LUT);
begin
  if fCurveMode <> cmFormulaCurves then
  begin
    Calc_LUT(BGRALUTarray[0], cmBlue);
    Calc_LUT(BGRALUTarray[1], cmGreen);
    Calc_LUT(BGRALUTarray[2], cmRed);
    Calc_LUT(GrayLUT, cmAll);
  end
  else
  begin
    Calc_Formula_LUT(GrayLUT, fvmAll);
    Calc_Formula_LUT(BGRALUTarray[0], fvmBlue);
    Calc_Formula_LUT(BGRALUTarray[1], fvmGreen);
    Calc_Formula_LUT(BGRALUTarray[2], fvmRed);
  end;
end;

end.

