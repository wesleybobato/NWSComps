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
unit NWSComps_RGBCurves_Types;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_RGBCurves.inc}
uses
Windows, Messages, SysUtils, Classes, Graphics, contnrs, inifiles,
 hyiedefs, hyieutils, NWSComps_IEUtils_Previews,
 NWSComps_RGBCurves_Const;

const G_CONST_PARSER_DATANOTFOUND: integer = -1234;

type


  TRGBCurves_HistogramDisplayMode = (HDmFilled, HDmTransparent, HDmLines);
  TRGBCurves_HistogramScaleMode = (HSmLinear, HSmLog, HSmauto);
  TRGBCurves_HistogramRGBMode = (HmRed, HmGreen, HmBlue, HmGray, HmAll);

  TRGBCurves_doublePoint = record
    x: double;
    y: double;
  end;

  TRGBCurves_DoublePointsarray = array of TRGBCurves_doublePoint;
  TRGBCurves_pointsarray = array of TPoint;

  TRGBCurves_Histogram = Class(TPersistent)
    public
    active: boolean;
    DisplayMode: TRGBCurves_HistogramDisplayMode;
    ScaleMode: TRGBCurves_HistogramScaleMode;
    RGBMode: TRGBCurves_HistogramRGBMode;

    Reds: array [0 .. 255] of cardinal;
    Greens: array [0 .. 255] of cardinal;
    Blues: array [0 .. 255] of cardinal;
    Grays: array [0 .. 255] of cardinal;

    Cyans: array [0 .. 255] of cardinal;
    Magentas: array [0 .. 255] of cardinal;
    Yellows: array [0 .. 255] of cardinal;
    Inks: array [0 .. 255] of cardinal;

    peakred, peakgreen, peakblue, peakgray, peakCyan, peakMagenta, peakYellow, peakInk: cardinal;
    avgred, avggreen, avgblue, avggray, avgCyan, avgMagenta, avgYellow, avgInk: cardinal;

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;


  TRGBCurves_PointItem = Class(TPersistent)
     private
     procedure SetX(theValue: double);
     procedure SetY(theValue: double);

     procedure SetUseCustomLayout(value: boolean);
     procedure SetCustomOutlineColor(value: TCOlor);
     procedure SetCustomFillColor(value: TCOlor);
     procedure SetCustomPointSize(value: Cardinal);
     procedure SetCustomLineSize(value: Cardinal);

     public
       fUniqueID: TGUID;
       fX: double;
       fY: double;

       fUseCustomLayout: boolean;
       fCustomOutlineColor: TColor;
       fCustomFillColor: TColor;
       fCustomPointSize: cardinal;
       fCustomLineSize: cardinal;

       fOnCustomEvent: TNotifyEvent;


       property UniqueID: TGUID read fUniqueID;
       property X: double read fX write SetX;
       property Y: double read fY write SetY;

       property UseCustomLayout: boolean read fUseCustomLayout write SetUseCustomLayout;
       property CustomOutlineColor: TColor read fCustomOutlineColor write SetCustomOutlineColor;
       property CustomFillColor: TColor read fCustomFillColor write SetCustomFillColor;
       property CustomPointSize: cardinal read fCustomPointSize write SetCustomPointSize;
       property CustomLineSize: cardinal read fCustomLineSize write SetCustomLineSize;

       property OnCustomEvent: TNotifyEvent read fOnCustomEvent write fOnCustomEvent;


       constructor Create(theCustomEvent: TNotifyEvent); reintroduce;
       procedure Assign(Source: TObject); reintroduce;

       procedure UnSetCustom;
       procedure SetCustom(Const theCustomOutlineColor: tColor;
                           Const theCustomFillColor: TColor;
                           Const theCustomPointSize: cardinal;
                           const theCustomLineSize: cardinal);
  End;

  TRGBCurves_Point_Event = procedure (thePointItem: TRGBCurves_PointItem) of object;

  TRGBCurves_PointList = Class(TObjectList)
     private

       fOnPointsChanged: TNotifyEvent;
       fOnAddPoint: TRGBCurves_Point_Event;
       fOnDeletePoint: TRGBCurves_Point_Event;
       fCustomPointEvent: TNotifyEvent;
      // fCurrentPoint : TRGBCurves_DoublePoint;
       fCurrentIdx: integer;
       procedure SetCurrentIdx(theIdx: integer);

       function GetUniqueID(theIdx: integer): TGUID;
       function GetData(theIdx: integer): TRGBCurves_DoublePoint;
       procedure SetData(theIdx: integer; thePoint: TRGBCurves_DoublePoint);

       function GetPointItem(theIdx: integer): TRGBCurves_PointItem;
       procedure SetPointItem(theIdx: integer; thePoint: TRGBCurves_PointItem);
    function GetCurrentPoint: TRGBCurves_DoublePoint;

     public
       property CurrentPoint : TRGBCurves_DoublePoint read GetCurrentPoint;
       property CurrentIdx: integer read fCurrentIdx write SetCurrentIdx;

       constructor Create; reintroduce;

       procedure Fire_PointsChanged;
       procedure Init;

       property UniqueID[theIdx: integer]: TGUID read GetUniqueID;
       property Data[theIdx: integer]: TRGBCurves_DoublePoint read GetData write SetData;
       property PointItem[theIdx: integer]: TRGBCurves_PointItem read GetPointItem write SetPointItem;

       property OnAddPoint: TRGBCurves_Point_Event read fOnAddPoint write fOnAddPoint;
       property OnDeletePoint: TRGBCurves_Point_Event read fOnDeletePoint write fOnDeletePoint;
       property OnCustomPointEvent: TNotifyEvent read fCustomPointEvent write fCustomPointEvent;
       property OnPointsChanged: TNotifyEvent read fOnPointsChanged write fOnPointsChanged;


       procedure Define(thePoints: TRGBCurves_DoublePointsarray; const bUpdate: boolean);
       procedure DefineDefault(const bUpdate: boolean);

       function PointExists(thePoint: TRGBCurves_DoublePoint; var ClosestItem: TRGBCurves_PointItem): integer;
       function AddPoint(thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean): integer;
       procedure RemovePoint(thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean);  overload;
       procedure RemovePoint(theIdx: integer; const bUpdate: boolean); overload;
       procedure SetPoint(theIdx: integer; thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean);


  End;


  TRGBCurves_IO_Options = class(TPersistent)
    private

    fFile_DefaultExtension: string;
    fFile_DefaultFilterStr: string;

    public

    Constructor Create; reintroduce;

    published

    property File_DefaultExtension: string read fFile_DefaultExtension write fFile_DefaultExtension;
    property File_DefaultFilterStr: string read fFile_DefaultFilterStr write fFile_DefaultFilterStr;

  end;

  TRGBCurves_Layout = class(TPersistent)

    private

    fTotWidth, fTotHeight: integer;
    fGraphWidth, fGraphHeight: integer;
    fOnChangedLayout: TNotifyEvent;
    fborderpercent: single;
    fborderfixed: cardinal;
    fShowHorizontalCaptions:boolean;
    fShowVerticalCaptions: boolean;
    fShowMedianLine: boolean;

    fDrawPointOverCurves: boolean;

    fGraphBackColor: TColor;
    fGraphBorderColor: TColor;

    fGridPenStyle: TPenStyle;
    fGridLineSize: integer;
    fGridColor : TColor;
    fGridMedianLinePenStyle: TPenStyle;
    fGridMedianLineSize: integer;
    fGridMedianLineColor: TColor;

    fCurveColor_Lum: TColor;
    fCurveColor_Red: TColor;
    fCurveColor_Green: TColor;
    fCurveColor_Blue: TColor;

    fCurveColor_Ink: TColor;
    fCurveColor_Cyan: TColor;
    fCurveColor_Magenta: TColor;
    fCurveColor_Yellow: TColor;

    fLineOpacity: byte;
    fLineSize: integer;

    fPointOpacity: byte;

    fPointColor_Lum: TColor;
    fPointColor_Red: TColor;
    fPointColor_Green: TColor;
    fPointColor_Blue: TColor;

    fPointColor_Ink: TColor;
    fPointColor_Cyan: TColor;
    fPointColor_Magenta: TColor;
    fPointColor_Yellow: TColor;

    fPointSize: integer;
    fPointFillStyle: TBrushStyle;


    procedure SetDrawPointOverCurves(theValue: boolean);

    procedure SetGraphBackColor(theValue: TColor);
    procedure SetGraphBorderColor(theValue: TColor);

    procedure SetGridPenStyle(thevalue: TPenStyle);
    procedure SetGridLineSize(thevalue: integer);
    procedure SetGridColor(theValue: TColor);
    procedure SetGridMedianLinePenStyle(thevalue: TPenStyle);
    procedure SetGridMedianLineColor(theValue: TColor);
    procedure SetGridMedianLineSize(thevalue: integer);

    procedure SetCurveColor_Lum(theValue: TColor);
    procedure SetCurveColor_Red(theValue: TColor);
    procedure SetCurveColor_Green(theValue: TColor);
    procedure SetCurveColor_Blue(theValue: TColor);

    procedure SetCurveColor_Ink(theValue: TColor);
    procedure SetCurveColor_Cyan(theValue: TColor);
    procedure SetCurveColor_Magenta(theValue: TColor);
    procedure SetCurveColor_Yellow(theValue: TColor);

    procedure SetPointColor_Lum(theValue: TColor);
    procedure SetPointColor_Red(theValue: TColor);
    procedure SetPointColor_Green(theValue: TColor);
    procedure SetPointColor_Blue(theValue: TColor);

    procedure SetPointColor_Ink(theValue: TColor);
    procedure SetPointColor_Cyan(theValue: TColor);
    procedure SetPointColor_Magenta(theValue: TColor);
    procedure SetPointColor_Yellow(theValue: TColor);

    procedure SetLineOpacity(theValue: byte);
    procedure SetPointOpacity(theValue: byte);

    procedure SetLineSize(theValue: integer);
    procedure SetPointSize(theValue: integer);
    procedure SetPointFillStyle(theValue: TBrushStyle);
    procedure SetTotWidth(theValue: integer);
    procedure SetTotHeight(theValue: integer);
    procedure SetBorderPrecent(theValue: single);
    procedure SetBorderFixed(theValue: cardinal);
    procedure SetShowHorizontalCaptions(theValue: boolean);
    procedure SetShowVerticalCaptions(theValue: boolean);
    procedure SetShowMedianLine(theValue: boolean);


    public
    IsReady: boolean;

   

    property GraphWidth: integer read fGraphWidth;
    property GraphHeight: integer read fGraphHeight;

    property TotWidth: integer read fTotWidth write SetTotWidth;
    property TotHeight: integer read fTotHeight write SetTotHeight;


    constructor create(theOnChangedLayout: TNotifyEvent;
                       theWidth, theHeight: integer;
                       theBorderFixed: integer;
                       const bReady: boolean); reintroduce;
    destructor Destroy; override;
    procedure Recalc; overload;
    procedure Recalc(newWidth, newHeight: integer); overload;

    published

    property DrawPointOverCurves: boolean read fDrawPointOverCurves write SetDrawPointOverCurves;

    property GraphBackColor: TColor read fGraphBackColor write SetGraphBackColor;
    property GraphBorderColor: TColor read fGraphBorderColor write SetGraphBorderColor;

    property GridPenStyle: TPenStyle read fGridPenStyle write SetGridPenStyle;
    property GridLineSize: integer read fGridLineSize write SetGridLineSize;
    property GridColor: TColor read fGridColor write SetGridColor;

    property GridMedianLinePenStyle: TPenStyle read fGridMedianLinePenStyle write SetGridMedianLinePenStyle;
    property GridMedianLineSize: integer read fGridMedianLineSize write SetGridMedianLineSize;
    property GridMedianLineColor: TColor read fGridMedianLineColor write SetGridMedianLineColor;

    property CurveColor_Lum: TColor read fCurveColor_Lum write SetCurveColor_Lum;
    property CurveColor_Red: TColor read fCurveColor_Red write SetCurveColor_Red;
    property CurveColor_Green: TColor read fCurveColor_Green write SetCurveColor_Green;
    property CurveColor_Blue: TColor read fCurveColor_Blue write SetCurveColor_Blue;

    property CurveColor_Ink: TColor read fCurveColor_Ink write SetCurveColor_Ink;
    property CurveColor_Cyan: TColor read fCurveColor_Cyan write SetCurveColor_Cyan;
    property CurveColor_Magenta: TColor read fCurveColor_Magenta write SetCurveColor_Magenta;
    property CurveColor_Yellow: TColor read fCurveColor_Yellow write SetCurveColor_Yellow;


    property PointColor_Lum: TColor read fPointColor_Lum write SetPointColor_Lum;
    property PointColor_Red: TColor read fPointColor_Red write SetPointColor_Red;
    property PointColor_Green: TColor read fPointColor_Green write SetPointColor_Green;
    property PointColor_Blue: TColor read fPointColor_Blue write SetPointColor_Blue;

    property PointColor_Ink: TColor read fPointColor_Ink write SetPointColor_Ink;
    property PointColor_Cyan: TColor read fPointColor_Cyan write SetPointColor_Cyan;
    property PointColor_Magenta: TColor read fPointColor_Magenta write SetPointColor_Magenta;
    property PointColor_Yellow: TColor read fPointColor_Yellow write SetPointColor_Yellow;

    property LineSize: integer read fLineSize write SetLineSize;
    property LineOpacity: byte read fLineOpacity write SetLineOpacity;

    property PointSize: integer read fPointSize write SetPointSize;
    property PointOpacity: byte read fPointOpacity write SetPointOpacity;
    property PointFillStyle: TBrushStyle read fPointFillStyle write SetPointFillStyle;

    property BorderPercent: single read fborderpercent write SetBorderPrecent;
    property BorderFixed: cardinal read fborderfixed write SetBorderFixed;
    property ShowHorizontalCaptions:boolean read fShowHorizontalCaptions write SetShowHorizontalCaptions;
    property ShowVerticalCaptions: boolean read fShowVerticalCaptions write SetShowVerticalCaptions;
    property ShowMedianLine: boolean read fShowMedianLine write SetShowMedianLine;

  end;


  TRGBCurves_CustomDrawEvent = procedure(aCanvas: TCanvas;
                                         const aDestRect: TRect
                                         ) of object;

  TRGBCurves_CustomDrawLabelEvent = procedure(aCanvas: TCanvas;
                                              const aValue: double;
                                              var aLabel: string;
                                              var aFont: TFont;
                                              var MaxWidth: integer;
                                              var MaxHeight: integer) of object;

  TRGBCurves_CustomDrawPointEvent = procedure(aCanvas: TCanvas;
                                              const thePoint: TRGBCurves_doublePoint;
                                              const theIdx: integer;
                                              var theOutlineColor: TColor;
                                              var theFillColor: TColor;
                                              var theSize: cardinal;
                                              var theLineSize: cardinal;
                                              var theFillStyle: TBrushStyle) of object;


  TRGBCurves_CustomDrawMedianLine = procedure(aCanvas: TCanvas;
                                              var theColor: TColor;
                                              var theLineSize: cardinal;
                                              var theStyle: TPenStyle) of object;


  TRGBCurves_FastPreviewQuality = (pq_Fast, pq_Normal, pq_Slow);

  TRGBCurves_CanMoveType = (cm_XY, cm_X_only, cm_Y_only, cm_CannotMove);
  TRGBCurves_MovePointEvent = procedure(sender: TObject; CurrentPoint: TRGBCurves_doublePoint;
    CurrentPoint_Idx: integer; var CanMove: TRGBCurves_CanMoveType) of object;
  TRGBCurves_MovingPointEvent = procedure(sender: TObject; MovingPoint: TRGBCurves_doublePoint) of object;

  TRGBCurves_Options = Set of (Opt_Allow_AddPoints,
                               Opt_Allow_RemovePoints,
                               Opt_Allow_Grip_OnYCoord);

  TRGBCurves_mode = (cmFormulaCurves, cmBuildCurves, cmNoCurves);
  // cmNoCurves is used for viewing just the histogram
  TRGBCurves_RGBmode = (cmAll, cmRed, cmGreen, cmBlue, cmRGB);
  TRGBCurves_RGBSpace = (csRGB, csLum, csMixed);
  TRGBCurves_editmode = (emNil, emMovePoint, emAddPoint);



  TRGBCurves_LUT = array [0 .. 255] of byte;
  TRGBCurves_Lutarray = array [0 .. 3] of TRGBCurves_LUT;

  TRGBCurves_row = array [0 .. 30000] of byte;
  tpRGBCurves_row = ^TRGBCurves_row;

  TRGBCurves_Channel_ViewMode = (fvmAll, fvmRed, fvmGreen, fvmBlue, fvmRGB, fvmLum);
  TRGBCurves_FormulaCurve = function(x: single): single of object;


implementation
   uses math;

 
   //-----------------------------------------------------------------------

   constructor TRGBCurves_Histogram.Create;
   begin

   end;

   Destructor TRGBCurves_Histogram.Destroy;
   begin

      inherited;
   end;

   //-------------------------------------------------------------------------------------------------------

   function CoCreateGuid(out guid: TGUID): HResult; stdcall; external 'ole32.dll' name 'CoCreateGuid';


   procedure TRGBCurves_PointItem.SetX(theValue: double);
   begin
     fX := theValue;
   end;

   procedure TRGBCurves_PointItem.SetY(theValue: double);
   begin
     fY := theValue;
   end;

   procedure TRGBCurves_PointItem.SetUseCustomLayout(value: boolean);
   begin
     fUseCustomLayout := value;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);
   end;

   procedure TRGBCurves_PointItem.SetCustomOutlineColor(value: TCOlor);
   begin
     fCustomOutlineColor := value;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);
   end;

   procedure TRGBCurves_PointItem.SetCustomFillColor(value: TCOlor);
   begin
     fCustomFillColor := value;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);
   end;

   procedure TRGBCurves_PointItem.SetCustomPointSize(value: Cardinal);
   begin
     fCustomPointSize := value;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);

   end;

   procedure TRGBCurves_PointItem.SetCustomLineSize(value: Cardinal);
   begin
     fCustomLineSize := value;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);

   end;



   constructor TRGBCurves_PointItem.Create(theCustomEvent: TNotifyEvent);
   begin
     inherited Create;
      fX := 0;
      fY := 0;
      CoCreateGuid(fUniqueID);

      fOnCustomEvent := theCustomEvent;
      fUseCustomLayout := False;
      fCustomOutlineColor := clblack;
      fCustomFillColor := clblack;
      fCustomPointSize := 8;
      fCustomLineSize := 2;
   end;

   procedure TRGBCurves_PointItem.Assign(Source: TObject);
   var
   srcPt: TRGBCurves_PointItem;
   begin
     if not (source is TRGBCurves_PointItem) then EXIT;

     srcPt := TRGBCurves_PointItem(source);

     fX := srcpt.X;
     fY := srcpt.Y;
     fUniqueID := srcpt.UniqueID;

     fUseCustomLayout := srcpt.UseCustomLayout;
     fCustomOutlineColor := srcpt.CustomOutlineColor;
     fCustomFillColor := srcpt.CustomFillColor;
     fCustomPointSize := srcpt.CustomPointSize;
     fCustomLineSize := srcpt.CustomLineSize;

   end;


   procedure TRGBCurves_PointItem.UnSetCustom;
   begin
     fUseCustomLayout := false;
     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);
   end;

   procedure TRGBCurves_PointItem.SetCustom(Const theCustomOutlineColor: tColor;
                                        Const theCustomFillColor: TColor;
                                        Const theCustomPointSize: cardinal;
                                        const theCustomLineSize: cardinal);

   begin
     fUseCustomLayout := true;
     fCustomOutlineColor := theCustomOutlineColor;
     fCustomFillColor := theCustomFillColor;
     fCustomPointSize := theCustomPointSize;
     fCustomLineSize := theCustomLineSize;

     if assigned(fOnCustomEvent) then
       fOnCustomEvent(self);
   end;


   //--------------------------------------------------------------------------------
   function TRGBCurves_PointList.GetUniqueID(theIdx: integer): TGUID;
   var
     aPoint: TRGBCurves_PointItem;
   begin

     aPoint := TRGBCurves_PointItem(getitem(theIdx));
     result := aPoint.UniqueID;

   end;

  function TRGBCurves_PointList.GetCurrentPoint: TRGBCurves_DoublePoint;
  begin

    result := Data[fCurrentIdx];

  end;

function TRGBCurves_PointList.GetData(theIdx: integer): TRGBCurves_DoublePoint;
   var
     aPoint: TRGBCurves_PointItem;
   begin
     result.x := 0;
     result.y := 0;

     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     aPoint := TRGBCurves_PointItem(getitem(theIdx));
     result.x := aPoint.x;
     result.y := aPoint.y;
   end;

   procedure TRGBCurves_PointList.SetData(theIdx: integer; thePoint: TRGBCurves_DoublePoint);
   var
     aPoint: TRGBCurves_PointItem;
   begin

     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     aPoint := TRGBCurves_PointItem(getitem(theIdx));
     aPoint.X := thePoint.x;
     aPoint.Y := thePoint.y;

   end;

   function TRGBCurves_PointList.GetPointItem(theIdx: integer): TRGBCurves_PointItem;
   begin
     result := nil;

     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     result := TRGBCurves_PointItem(getitem(theIdx));
   end;

   procedure TRGBCurves_PointList.SetPointItem(theIdx: integer; thePoint: TRGBCurves_PointItem);
      var
     aPoint: TRGBCurves_PointItem;
   begin

     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     aPoint := TRGBCurves_PointItem(getitem(theIdx));
     aPoint.Assign(thePoint);
   end;

   constructor TRGBCurves_PointList.Create;
   begin
      inherited Create(TRUE);

      fCurrentIdx := -1;
      Init;
   end;


   procedure TRGBCurves_PointList.Fire_PointsChanged;
   begin

     if assigned(fOnPointsChanged) then fOnPointsChanged(self);

   end;

   procedure TRGBCurves_PointList.Init;
   begin
      DefineDefault(False);

   end;




   procedure TRGBCurves_PointList.Define(thePoints: TRGBCurves_DoublePointsarray; const bUpdate: boolean);
   var
     i: integer;
   begin
       clear;

       for i := 0 to high(thePoints) do
       begin
         AddPoint(thePoints[i], False);
       end;

       if bUpdate then
         Fire_PointsChanged;
   end;


   procedure TRGBCurves_PointList.DefineDefault(const bUpdate: boolean);
   var
     thePoints: TRGBCurves_DoublePointsarray;
   begin

      setlength(thePoints, 2);
      thePoints[0].x := 0;
      thePoints[0].y := 0;
      thePoints[1].x := 255;
      thePoints[1].y := 255;

      Define(thePoints, bUpdate);

   end;



   function TRGBCurves_PointList.PointExists(thePoint: TRGBCurves_DoublePoint;
                                             var ClosestItem: TRGBCurves_PointItem
                                             ): integer;
   var
     i: integer;
     aPoint: TRGBCurves_PointItem;
   begin
     result := -1;
     ClosestItem := nil;
     for i  := 0 to Count - 1 do
     begin
        aPoint := TRGBCurves_PointItem(GetItem(i));
        if (abs(thePoint.x - aPoint.x) < 0.001) then
        begin
          result := i;
          ClosestItem := aPoint;
          break;
        end
        else
        begin
          if (not assigned(ClosestItem)) or (abs(ClosestItem.X - thePoint.x) > abs(aPoint.X - thePoint.x))  then
          begin
            ClosestItem := aPoint;
          end;
        end;
     end;
   end;


   function TRGBCurves_PointList.AddPoint(thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean): integer;
   var
     aPoint: TRGBCurves_PointItem;
     aIdx: integer;
     aClosestItem: TRGBCurves_PointItem;
   begin
     thePoint.X := max(0, min(255, thePoint.x));
     thePoint.Y := max(0, min(255, thePoint.y));

     aIdx := PointExists(thePoint, aClosestItem);

     if aIdx = -1 then  //points does not exist
     begin
       aPoint := TRGBCurves_PointItem.Create(fCustomPointEvent);
       aPoint.X := thePoint.x;
       aPoint.Y := thePoint.y;


       if (aClosestItem = nil) then
       begin
         aIdx := 0;
         insert(aIdx, aPoint);
       end
       else
       begin
         if aClosestItem.x < aPoint.X then
          aIdx := indexof(aClosestItem) + 1
         else
          aIdx := indexof(aClosestItem);

         insert(aIdx, aPoint)
       end;
     end
     else
     aPoint := aClosestItem;


     result := aIdx;
     SetCurrentIdx(aIdx);

     if assigned(fOnAddPoint) then
       fOnAddPoint(aPoint);

     if bUpdate then
         Fire_PointsChanged;
   end;


   procedure TRGBCurves_PointList.RemovePoint(thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean);
   var

     aIdx: integer;
     ClosestItem:  TRGBCurves_PointItem;
   begin
      aIdx := PointExists(thePoint, ClosestItem);
      if aIdx <> -1 then
      begin
        RemovePoint(aIdx, bUpdate);
      end;
   end;

   procedure TRGBCurves_PointList.RemovePoint(theIdx: integer; const bUpdate: boolean);
   var aPoint: TRGBCurves_PointItem;
   begin
     if Count <= 2 then EXIT;

     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     aPoint := GetPointItem(theIdx);
     

     Delete(theIdx);
     SetCurrentIdx(max(0, theIdx - 1));

     if assigned(fOnDeletePoint) then
        fOnDeletePoint(aPoint);

     if bUpdate then
         Fire_PointsChanged;
   end;

   procedure TRGBCurves_PointList.SetPoint(theIdx: integer; thePoint: TRGBCurves_DoublePoint; const bUpdate: boolean);
   var
     aPoint: TRGBCurves_PointItem;

   begin
     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     aPoint := TRGBCurves_PointItem(GetItem(theIdx));

     if theidx> 0 then
       thePoint.x := min(255, max(thePoint.x, TRGBCurves_PointItem(GetItem(theIdx-1)).x + 0.1));

     if theidx< Count-1 then
       thePoint.x := max(0, min(thePoint.x, TRGBCurves_PointItem(GetItem(theIdx+1)).x - 0.1));


     aPoint.X := thePoint.x;
     aPoint.Y := ThePoint.y;

     if bUpdate then
         Fire_PointsChanged;
   end;

   procedure TRGBCurves_PointList.SetCurrentIdx(theIdx: integer);
   begin
     if (theIdx < 0) or (theIdx > Count-1) then EXIT;

     fCurrentIdx := theIdx;
   //  fCurrentPoint := getData(theIdx);
   end;

   //---------------------------------------------------------------------------

   Constructor TRGBCurves_IO_Options.Create;
   begin
     inherited create;

     fFile_DefaultExtension := '.fcc';
     fFile_DefaultFilterStr := 'Curve files (*.fcc)|*.fcc';
   end;



   //---------------------------------------------------------------------------

    constructor TRGBCurves_Layout.create(theOnChangedLayout: TNotifyEvent;
                                         theWidth, theHeight: integer;
                                         theBorderFixed: integer;
                                         const bReady: boolean);
    begin
       inherited create;
       IsReady := bReady;

       fDrawPointOverCurves := False;

       fGraphBackColor := clwhite;
       fGraphBorderColor := clblack;
       fGridPenStyle := psdot;
       fGridLineSize := 1;
       fGridColor := rgb(127, 127, 127);
       fGridMedianLinePenStyle := psDash;
       fGridMedianLineSize := 1;
       fGridMedianLineColor := rgb(127, 127, 127);

       fCurveColor_Lum :=  clblack;
       fCurveColor_Red := clred;
       fCurveColor_Green := clgreen;
       fCurveColor_Blue := clblue;

       fCurveColor_Ink :=  clblack;
       fCurveColor_Cyan := clAqua;
       fCurveColor_Magenta := clPurple;
       fCurveColor_Yellow := clYellow;

       fPointColor_Lum :=  clblack;
       fPointColor_Red := clred;
       fPointColor_Green := clgreen;
       fPointColor_Blue := clblue;

       fPointColor_Ink :=  clblack;
       fPointColor_Cyan := clAqua;
       fPointColor_Magenta := clPurple;
       fPointColor_Yellow := clYellow;

       fLineOpacity := 255;
       fPointOpacity := 255;

       fPointSize := 8;
       fPointFillStyle := bsSolid;
       fLineSize := 1;
       fTotWidth := theWidth;
       fTotHeight := theHeight;
       fborderfixed := theBorderFixed;
       fOnChangedLayout := theOnChangedLayout;
       fShowHorizontalCaptions := true;
       fShowVerticalCaptions := true;
       fShowMedianLine := true;

       Recalc;

    end;

    destructor TRGBCurves_Layout.destroy;
    begin
       inherited;

    end;

    procedure TRGBCurves_Layout.Recalc;
    begin
       Recalc(fTotWidth, fTotHeight);
    end;

    procedure TRGBCurves_Layout.Recalc(newWidth, newHeight: integer);
    begin
       fTotWidth := newWidth;
       fTotHeight := newHeight;
       fGraphWidth := fTotWidth - fborderfixed;
       fGraphHeight := fTotHeight - fborderfixed;
       fborderpercent := round(fborderfixed / max(1, fTotWidth) * 100);
    end;

    procedure TRGBCurves_Layout.SetDrawPointOverCurves(theValue: boolean);
    begin
      fDrawPointOverCurves := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetGraphBackColor(theValue: TColor);
    begin
      fGraphBackColor := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetGraphBorderColor(theValue: TColor);
    begin
      fGraphBorderColor := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetGridPenStyle(thevalue: TPenStyle);
    begin
       fGridPenStyle := theValue;

       if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetGridLineSize(thevalue: integer);
    begin
      fGridLineSize := min(10, max(1, theValue));

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);

    end;


    procedure TRGBCurves_Layout.SetGridColor(theValue: TColor);
    begin
      fGridColor := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetGridMedianLinePenStyle(thevalue: TPenStyle);
    begin
       fGridMedianLinePenStyle := theValue;

       if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetGridMedianLineSize(thevalue: integer);
    begin
        fGridMedianLineSize := min(10, max(1, theValue));

        if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);

    end;

    procedure TRGBCurves_Layout.SetGridMedianLineColor(theValue: TColor);
    begin
      fGridMedianLineColor := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Lum(theValue: TColor);
    begin
      fCurveColor_Lum := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Red(theValue: TColor);
    begin
      fCurveColor_Red := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetCurveColor_Green(theValue: TColor);
    begin
      fCurveColor_Green := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Blue(theValue: TColor);
    begin
      fCurveColor_Blue := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Ink(theValue: TColor);
    begin
      fCurveColor_Ink := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Cyan(theValue: TColor);
    begin
      fCurveColor_Cyan := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Magenta(theValue: TColor);
    begin
      fCurveColor_Magenta := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetCurveColor_Yellow(theValue: TColor);
    begin
      fCurveColor_Yellow := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointColor_Lum(theValue: TColor);
    begin
      fPointColor_Lum := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetPointColor_Red(theValue: TColor);
    begin
      fPointColor_Red := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointColor_Green(theValue: TColor);
    begin
      fPointColor_Green := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetPointColor_Blue(theValue: TColor);
    begin
      fPointColor_Blue := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetPointColor_Ink(theValue: TColor);
    begin
      fPointColor_Ink := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointColor_Cyan(theValue: TColor);
    begin
      fPointColor_Cyan := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointColor_Magenta(theValue: TColor);
    begin
      fPointColor_Magenta := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointColor_Yellow(theValue: TColor);
    begin
      fPointColor_Yellow := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetLineOpacity(theValue: byte);
    begin
      fLineOpacity := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetPointOpacity(theValue: byte);
    begin
      fPointOpacity := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;




    procedure TRGBCurves_Layout.SetLineSize(theValue: integer);
    begin
      if theValue <> fLineSize then
      begin
        fLineSize := min(10, max(1, theValue));

        if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);
      end;
    end;

    procedure TRGBCurves_Layout.SetPointSize(theValue: integer);
    begin
      if theValue <> fPointSize then
      begin
        fPointSize := max(1, theValue);

        if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);
      end;
    end;

    procedure TRGBCurves_Layout.SetPointFillStyle(theValue: TBrushStyle);
    begin
      if theValue <> fPointFillStyle then
      begin
        fPointFillStyle := theValue;

        if assigned(fOnChangedLayout) then
          fOnChangedLayout(self);
      end;
    end;

    procedure TRGBCurves_Layout.SetTotWidth(theValue: integer);
    begin
      fTotWidth := theValue;
      Recalc;

       if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetTotHeight(theValue: integer);
    begin
      fTotHeight := theValue;
      Recalc;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;


    procedure TRGBCurves_Layout.SetBorderPrecent(theValue: single);
    var
    w: integer;
    begin
      fborderpercent := min(100, max(0, theValue));
      w := round((100 - fborderpercent)/100 * fTotWidth);
      SetBorderFixed(fTotWidth - w);
    end;

    procedure TRGBCurves_Layout.SetBorderFixed(theValue: cardinal);
    begin
      fBorderFixed := theValue;
      Recalc;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetShowHorizontalCaptions(theValue: boolean);
    begin
      fShowHorizontalCaptions := theValue;


      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetShowVerticalCaptions(theValue: boolean);
    begin
      fShowVerticalCaptions := theValue;


      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

    procedure TRGBCurves_Layout.SetShowMedianLine(theValue: boolean);
    begin
      fShowMedianLine := theValue;

      if assigned(fOnChangedLayout) then
        fOnChangedLayout(self);
    end;

end.
