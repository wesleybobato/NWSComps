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
unit NWSComps_Proc_Engine;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}

uses
  Windows, SysUtils, Classes, forms, Graphics, math, messages, dialogs, syncobjs,
  hyiedefs, hyieutils, {$IFDEF IMAGEEN_6_2_LATER} iexBitmaps, {$ENDIF} imageenproc, imageenview,
  NWSComps_RGBCurves_Math, NWSComps_RGBCurves_Types, NWSComps_Proc_Filter_Types,
  NWSComps_Proc_Filter_Lib_Const, NWSComps_IEUtils_Previews, NWSComps_MultiThreadProc;


type
    TIEProc_Ex_CustomMultiThreadInfoEvent = procedure(filter: TIEProc_EX_Filter;
                                                     var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                                     var MtNrThreads: cardinal;
                                                     var theOverlap: cardinal;
                                                     var bAutoOverlap: boolean;
                                                     var OverlapMethod: TIEMultiProc_EX_OverlapMethod) of object;

  TBEBrightMode = (bmShadows, bmMidlights, bmHilights, bmAll);
  TbeRGBSpace = (csRGB, csLum, csMixed);

  TbeProgressEvent = procedure(Sender: TObject; per: integer) of object;

  TBESmartShadowsMode = (ssveryflat, ssFlat, ssMediumContrast, ssHighContrast);

  TbebyteArray = array [0 .. 32767] of byte;
  pbebyteArray = ^TbebyteArray;
  TbeRGBArray = array [0 .. 32767] of TRGBTriple;
  pbeRGBArray = ^TbeRGBArray;
  TbeRGBQuadArray = array [0 .. 32767] of TRGBQuad;
  pbeRGBQuadArray = ^TbeRGBQuadArray;

  TbeLABarray = array [0 .. 2] of single;
  TbeLABIntarray = array [0 .. 2] of integer;

  TbeBGRboolArray = array [0 .. 2] of boolean;
  TbeBGRbytearray = array [0 .. 2] of byte;
  TbeBGRsinglearray = array [0 .. 2] of single;
  TbeBGRDoublearray = array [0 .. 2] of double;
  TbeBGRintarray = array [0 .. 2] of integer;
  TbeBGRint64array = array [0 .. 2] of int64;

  TbeBGRAboolArray = array [0 .. 3] of boolean;
  TbeBGRAbytearray = array [0 .. 3] of byte;
  TbeBGRAsinglearray = array [0 .. 3] of single;
  TbeBGRADoublearray = array [0 .. 3] of double;
  TbeBGRAintarray = array [0 .. 3] of integer;
  TbeBGRAint64array = array [0 .. 3] of int64;

  TbeBGRGrayboolArray = array [0 .. 3] of boolean;
  TbeBGRGraybytearray = array [0 .. 3] of byte;
  TbeBGRGraysinglearray = array [0 .. 3] of single;
  TbeBGRGrayDoublearray = array [0 .. 3] of double;
  TbeBGRGrayintarray = array [0 .. 3] of integer;
  TbeBGRGrayint64array = array [0 .. 3] of int64;

  TbeBGRAGraybytearray = array [0 .. 4] of byte;
  TbeBGRAGraysinglearray = array [0 .. 4] of single;
  TbeBGRAGrayintarray = array [0 .. 4] of integer;
  TbeBGRAGrayint64array = array [0 .. 4] of int64;

  TbeByteLUT = array [0 .. 255] of byte;
  TbeByteLUTarray = array [0 .. 3] of TbeByteLUT;

  TbeHueRangeLUT = array [0 .. 360] of byte;
  TbeMaskarray = array of array of byte;
  Tbebooleanmask = array of array of boolean;
  TbeTreshtable = array of array of byte;

  Tbedoublepoint = record
    x: double;
    y: double;
  end;

  // TCurveDoublePointsarray = array of Tbedoublepoint;
  TbeDVector = array of double;

  TbeLUTObjFunction = function(x: single): single of object;
  TbeLUTFunction = function(x: single): single;

  Tbepixelformat = (bepf8, bepf16, bepf24, bepf32, bepfother);

  TBeMaskCoeffArray = array of array of byte;

  TBEMaskSmartMode = (sm_shadows, sm_hilights, sm_midtones, sm_shadows_midtones,
                      sm_lum_Variation, sm_hue_Variation, sm_FindEdges);

  TBE_ByteScanline = array [0 .. 0] of byte;
  pBE_ByteScanline = ^TBE_ByteScanline;
  pBE_ByteScanline_Array = array of pBE_ByteScanline;

  TBE_RGBTripleScanline = array [0 .. 0] of TRGBTriple;
  pBE_RGBTripleScanline = ^TBE_RGBTripleScanline;
  pBE_RGBTripleScanline_Array = array of pBE_RGBTripleScanline;


  TbeBGRAGrayHistoEntries = array[0..255] of TbeBGRAGrayintarray;


  TbeScanlines = class(TPersistent)
  private

  public

    Scanlines: pBE_ByteScanline_Array;
    Scanlines_RGB: pBE_RGBTripleScanline_Array;

    procedure CreateScanlines(theBMP: TIEBitmap); overload;
    procedure CreateScanlines(theBMP: TIEBitmap; y1, y2: integer); overload;
    procedure CreateScanlines_RGB(theBMP: TIEBitmap);

    constructor Create; reintroduce;
    Destructor Destroy; override;
  end;

  const
    BEMASK_FILTERPARAM_SMARTMODE = 'SMARTMODE';
    BEMASK_FILTERPARAM_RADIUS = 'RADIUS';
    BEMASK_FILTERPARAM_INVERTMASK = 'INVERTMASK';

  type

  TbeHistogram = class
  private
  //  fBMP_Width, fBMP_Height: integer;

    fBGRAGraydata: TbeBGRAGrayHistoEntries;
    fBGRAGrayMinEntry, fBGRAGrayMaxEntry: TbeBGRAGraybytearray;
    fBGRAGrayAverage: TbeBGRAGrayintarray;
    fNumberOfValues: integer;

    fNumberOfValuesinShadows, fNumberOfValuesinMidTones, fNumberOfValuesinHilights: TbeBGRAGrayintarray;
    fBGRAGrayDensityS, fBGRAGrayDensityM, fBGRAGrayDensityH: TbeBGRAGraysinglearray;

    //    fSuggestedLeftLimit_Gray, fSuggestedRightLimit_Gray, fSuggestedLeftLimit_RGB, fSuggestedRightLimit_RGB: integer;

    fsignificant_shadows_ratio: single;
    fHighest_hilights_ratio: single;

    fAverageGrayDensityS, fAverageGrayDensityM, fAverageGrayDensityH: single;

    fGRAYConsts: TbeBGRAbytearray;

  public

    property NumberofValues: integer read fnumberofvalues;
    property BGRAGrayDensityS: TbeBGRAGraysinglearray read fBGRAGrayDensityS;
    property BGRAGrayDensityM: TbeBGRAGraysinglearray read fBGRAGrayDensityM;
    property BGRAGrayDensityH: TbeBGRAGraysinglearray read fBGRAGrayDensityH;
    property BGRAGrayMinEntry: TbeBGRAGraybytearray read fBGRAGrayMinEntry write fBGRAGrayMinEntry;
    property BGRAGrayMaxEntry: TbeBGRAGraybytearray read fBGRAGrayMaxEntry write fBGRAGrayMaxEntry;
    property BGRAGrayAverage: TbeBGRAGrayintarray read fBGRAGrayAverage;
    property Ssignificant_shadows_ratio: single read fsignificant_shadows_ratio;
    property Highest_hilights_ratio: single read fHighest_hilights_ratio;
    property AverageGrayDensityS: single read fAverageGrayDensityS;
    property AverageGrayDensityM: single read fAverageGrayDensityM;
    property AverageGrayDensityH: single read fAverageGrayDensityH;

    procedure GetHistogramfromBMP(Bitmap: TIEbitmap; editrect: Trect);
    procedure GetHistogramAndDatafromBMP(Bitmap: TIEbitmap; editrect: Trect; grayOnly: boolean; const bScale: boolean = false);
    procedure GetHistogramvariances(var variances: TbeBGRAGraysinglearray; var integralsS, integralsM, integralsH: TbeBGRAGrayint64array);
    procedure AdjournHistogramData(grayOnly: boolean; const PicScale: single = 1);
    procedure AdjournHistogramDensity(grayOnly: boolean);
    procedure AdjournHistogramLimits(grayOnly: boolean; const PicScale: single = 1);

    procedure SetGrayConsts(const BlueConst, GreenConst, RedConst: byte);
    procedure ResetGrayConsts;

    constructor Create; reintroduce;
  end;


  TBEMask = class // 8bit mask 255=opaque, 0=transparent
  private

    fTempFilter: TIEProc_EX_Filter;
    fMaskMTProc: TIEMultiProc_EX;
    fmaskarray: TbeMaskarray;
    fWidth: integer; // width of bit mask
    fHeight: integer; // height of bit mask
    fBitsperpixel: integer; // max 8 bits per pixel
    fX1, fY1, fX2, fY2: integer;
 
    procedure SetX1(x: integer);
    procedure SetY1(y: integer);
    procedure MaskGblur(bMultithreaded: boolean; bitmap: TIEBitmap; radius: double);

    procedure Filter_MaskGBlur(sender: TObject; theFilter:TIEProc_EX_Filter;
                                                  bitmap: TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent);
  public
    property Width: integer read fWidth;
    property Height: integer read fHeight;
    property X1: integer read fX1 write SetX1;
    property y1: integer read fY1 write SetY1;
    property X2: integer read fX2;
    property y2: integer read fY2;
    property BitsperPixel: integer read fBitsperpixel;

    constructor Create;
    destructor Destroy; override;

    procedure DefineFromIeMask(theIEMask: TIEMask);

    procedure Define(theWidth, theHeight, The_x1, The_y1: integer;
      blankValue: byte);
    procedure ReDefine(theWidth, theHeight, The_x1, The_y1: integer);

    function GetValue(x, y: integer): byte;
    function GetValue_bool(x, y: integer): boolean;

    procedure SetValue(x, y: integer; Value: byte);
    procedure SetValue_bool(x, y: integer; Value: boolean);

    procedure LoadFrom8bitBMP(theBMP: TIEBitmap;
      const Inverted: boolean = false);
    procedure LoadfromBMP(theBMP: TIEBitmap; bInvertMAsk: boolean);

    procedure GetMap_Coefs(var coeffarray: TBeMaskCoeffArray;
      var blocksize: integer; theBMP: TIEBitmap; radius: single;
      smartmask_mode: TBEMaskSmartMode; InvertCoef: boolean);

    procedure GetMap(bMultithreaded: boolean;coeffarray: TBeMaskCoeffArray; BMP: TIEBitmap;
      blocksize: integer; radius: single; const bApplyBlur: boolean = true);

   

    procedure CopyBitmap(Dest, Source: TIEBitmap; amount: integer;
      const alignSourcetoMask: boolean = false;
      const bInverted: boolean = false);

    procedure GetFromBMPTones(bMultiThreaded: boolean; mode: TBEMaskSmartMode; theBMP: TIEBitmap;
      radius: integer; bInvertMAsk: boolean; bQuickMask:boolean);
    procedure GetFromBmpEdges(theBMP: TIEBitmap; KernelSize: TIEProc_EX_Filter_Kernelsize; bInvertMAsk: boolean);

  end;

  TbePreviewMask = class

    private
    fMask: TBemask;
    fPreviewID: TGUID;
    fMaskId: string;

    public

    property Mask:TBemask read fMask;

    property PreviewID: TGUID read fPreviewID;
    property MaskID: string read fMaskId;

    constructor Create(thePreviewId: TGUid; theMaskId: string; memoryMask:TBemask); reintroduce;
    destructor Destroy; override;
  end;

  TbePreviewMasks = class(TList)
    private
      fCS: TCriticalSection;
      function GetMask(idx:integer): TbePreviewMask;
      procedure Clear; override;
    public

      procedure SaveMask(thePreviewId: TGUid; theMaskId: string; theMask:TBeMask);
      function RequireMask(thePreviewId: TGUid; theMaskId: string):TBemask;


      constructor Create; reintroduce;
      destructor Destroy; override;
  end;


  TBE = class(TPersistent)

  private
    fMultiProc: TIEMultiProc_EX;
    fPreviewMasks: TbePreviewMasks;
    fInternalProc: TImageenProc;
    fOnFinishWork: TNotifyEvent;
    fOnProgress: TIEProgressEvent;
    fMultiThreadEnabled: boolean;
    fMultiIsRunning: boolean;
    fMultiThreadNrThreads: cardinal;
    fOnFilter_CustomMultiThreadInfo: TIEProc_Ex_CustomMultiThreadInfoEvent;
    fMultiThreadDefOverlapMethod: TIEMultiProc_EX_OverlapMethod;
    procedure Handle_MProcInit(sender: TObject);
    procedure Handle_MProcFinished(sender: TObject);
    procedure HandleProgress(Sender: TObject; per: integer);
    procedure HandleFinishWork(Sender: TObject);
    function _GetAvgGray(bitmap: TIEBitmap): byte;
    procedure _GetCutBitmap(bitmap: TIEBitmap; EditRect: Trect;
      CutBitmap: TIEBitmap);
    function _IsRectFull(editRect: TRect; bmpW, bmpH: integer): boolean;
    function _CanProcess(bitmap: TIEBitmap): boolean;
    function _CreateTempIEProc(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent): TImageEnProc;
    procedure _AdvanceProgress(sender: TObject; theFilterProgress: TIEProgressEvent; per: integer);
    function _Blendchannel(backchan, forechan, inttras: byte; blendmode: TIEProc_EX_Filter_Blendmode): byte;
    function _Blendpixel(backBGRA, foreBGRA: TbeBGRAbytearray; inttras: byte;
                         blendmode: TIEProc_EX_Filter_Blendmode;
                         readby: integer): TbeBGRAbytearray;


    procedure _RGBColorBalance(bitmap: tIEBitmap; EditRect: Trect;
                               bUniform: boolean;
                               BGRGrayamountSH, BGRGrayamountMid, BGRGrayamountHi, BGRGrayamountAll : TbeBGRGrayIntarray;
                               theProgressEvent: TIEProgressEvent);
    procedure _ColorFilter(bitmap: tIEBitmap; EditRect: Trect;
                           color:TColor;inttras:byte; blendmode: TIEProc_EX_Filter_Blendmode;
                               theProgressEvent: TIEProgressEvent);

    procedure _AutoColor(bitmap: tIEBitmap; EditRect: Trect; strength: integer;
                         theProgressEvent: TIEProgressEvent);

    procedure _ApplyBilateral24(bitmap:TIEBitmap; Radius, SigmaI, SigmaD:Integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _ApplyBilateral24(bitmap: TIEBitmap; EditRect: Trect;
  Radius, SigmaI, SigmaD:Integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _ApplyBilateral8(bitmap: TIEBitmap; Radius, SigmaI, SigmaD: Integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _ApplyBilateral8(bitmap: TIEBitmap; EditRect: Trect; Radius, SigmaI, SigmaD: Integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _SmartContrast(bitmap: TIEBitmap;
  amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;
    procedure _SmartContrast(bitmap: TIEBitmap; EditRect: Trect;
  amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;

    procedure _SmartFlash(bitmap: TIEBitmap; amount, radius: integer;
                          PreviewId: TGUID; theProgressEvent: TIEProgressEvent);  overload;
    procedure _SmartFlash(bitmap: TIEBitmap; EditRect: Trect;
      amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;


    procedure _ReduceHighlights(bitmap: TIEBitmap;
      amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;
    procedure _ReduceHighlights(bitmap: TIEBitmap; EditRect: Trect;
      amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;


    procedure _FillBackLight(bitmap: TIEBitmap;  Fillamount, BackAmount,
      radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;
    procedure _FillBackLight(bitmap: TIEBitmap; EditRect: Trect; Fillamount, BackAmount,
      radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;

    procedure _Smooth(bitmap: TIEBitmap;  amount: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;
    procedure _Smooth(bitmap: TIEBitmap; EditRect: Trect; amount: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;


    procedure _LightEffect_Ellipse(Bitmap:TIEBitmap; color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent);  overload;
    procedure _LightEffect_Ellipse(Bitmap:TIEBitmap; EditRect: Trect; color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;

    procedure _LightEffect_Beam(Bitmap:TIEBitmap; color:TColor; LightAmount: integer;BeamSize:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent);  overload;
    procedure _LightEffect_Beam(Bitmap:TIEBitmap; EditRect: Trect; color:TColor; LightAmount: integer; BeamSize:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;

    procedure _LightEffect_DoubleBeam(Bitmap:TIEBitmap; color:TColor; LightAmount: integer;BeamSize:integer; Opening:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent);  overload;
    procedure _LightEffect_DoubleBeam(Bitmap:TIEBitmap; EditRect: Trect; color:TColor; LightAmount: integer; BeamSize:integer; Opening:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_UnsharpMask(bitmap: TIEBitmap;
      radius, amount, threshold: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_UnsharpMask(bitmap: TIEBitmap; EditRect: Trect;
      radius, amount, threshold: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Blur(bitmap: TIEBitmap; radius: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_Blur(bitmap: TIEBitmap; EditRect: Trect; radius: double; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_HSLVar(bitmap: TIEBitmap;
      Hue, Sat, Lum: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_HSLVar(bitmap: TIEBitmap; EditRect: Trect;
      Hue, Sat, Lum: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_HSVVar(bitmap: TIEBitmap;
      Hue, Sat, Value: integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_HSVVar(bitmap: TIEBitmap; EditRect: Trect;
      Hue, Sat, Value: integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_MedianSharpen(bitmap:TIEBitmap; Window, Multiplier:integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_MedianSharpen(bitmap:TIEBitmap; EditRect: Trect; Window, Multiplier:integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Median(bitmap:TIEBitmap; Window, Threshold:integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Median(bitmap:TIEBitmap; EditRect: Trect; Window, Threshold:integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_FindEdges(bitmap:TIEBitmap; KernelSize:TIEProc_EX_Filter_Kernelsize; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Findedges(bitmap:TIEBitmap; EditRect: Trect; KernelSize:TIEProc_EX_Filter_Kernelsize; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Sharpen(bitmap:TIEBitmap; Amount, Window:integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Sharpen(bitmap:TIEBitmap; EditRect: Trect; Amount, Window:integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Negative(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Negative(bitmap: TIEBitmap; EditRect: Trect; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_IntensityRGBAll(bitmap: TIEBitmap;
      IntRed, IntGreen, IntBlue: integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_IntensityRGBAll(bitmap: TIEBitmap; EditRect: Trect;
      IntRed, IntGreen, IntBlue: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Intensity(bitmap: TIEBitmap;
      loLimit, HiLimit, Change: integer; UseAverageRgb, doRed, doGreen,
      doBlue: boolean; theProgressEvent: TIEProgressEvent);  overload;

    procedure _IE_Intensity(bitmap: TIEBitmap; EditRect: Trect;
      loLimit, HiLimit, Change: integer; UseAverageRgb, doRed, doGreen,
      doBlue: boolean; theProgressEvent: TIEProgressEvent);  overload;


    procedure _IE_Contrast(bitmap: TIEBitmap; amount: double; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Contrast(bitmap: TIEBitmap; EditRect: Trect; amount: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Contrast2(bitmap: TIEBitmap; amount: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_Contrast2(bitmap: TIEBitmap; EditRect: Trect; amount: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Contrast3(bitmap: TIEBitmap;
      Change, MidPoint: integer; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_Contrast3(bitmap: TIEBitmap; EditRect: Trect;
      Change, MidPoint: integer; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_GammaCorrect(bitmap: TIEBitmap;
      Gamma: double; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_GammaCorrect(bitmap: TIEBitmap; EditRect: Trect;
      Gamma: double; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_AutoSharp(bitmap: TIEBitmap;
      Intensity: integer; Rate: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_AutoSharp(bitmap: TIEBitmap; EditRect: Trect;
      Intensity: integer; Rate: double; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_Colorize(bitmap: TIEBitmap;  Hue: integer;
      Sat: integer; Lum: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_Colorize(bitmap: TIEBitmap; EditRect: Trect; Hue: integer;
      Sat: integer; Lum: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_Brightness_Contrast_Saturation(bitmap: TIEBitmap;
       Brightness, Contrast, Sat: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_Brightness_Contrast_Saturation(bitmap: TIEBitmap;
      EditRect: Trect; Brightness, Contrast, Sat: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_AdjustTint(bitmap: TIEBitmap;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_AdjustTint(bitmap: TIEBitmap; EditRect: Trect;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_AdjustSaturation(bitmap: TIEBitmap;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_AdjustSaturation(bitmap: TIEBitmap; EditRect: Trect;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_AdjustTemperature(bitmap: TIEBitmap;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_AdjustTemperature(bitmap: TIEBitmap; EditRect: Trect;
      amount: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_AdjustLumSatHisto(bitmap: TIEBitmap;
      Sat, Lum: double; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_AdjustLumSatHisto(bitmap: TIEBitmap; EditRect: Trect;
      Sat, Lum: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_WhiteBalance_coef(bitmap: TIEBitmap;
      Red, Green, Blue: double; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_WhiteBalance_coef(bitmap: TIEBitmap; EditRect: Trect;
      Red, Green, Blue: double; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_WhiteBalance_GrayWorld(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_WhiteBalance_GrayWorld(bitmap: TIEBitmap; EditRect: Trect;
      bFullApply: boolean; theProgressEvent: TIEProgressEvent); overload;

    procedure _IE_WhiteBalance_WhiteAt(bitmap: TIEBitmap;
      WhiteX, WhiteY: integer; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_WhiteBalance_WhiteAt(bitmap: TIEBitmap; EditRect: Trect;
      WhiteX, WhiteY: integer; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_WhiteBalance_AutoWhite(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent); overload;
    procedure _IE_WhiteBalance_AutoWhite(bitmap: TIEBitmap; EditRect: Trect;
      bFullApply: boolean; theProgressEvent: TIEProgressEvent); overload;


    procedure _IE_AutoImageEnhance1(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent;
      SubsampledSize: integer = 60; Slope: integer = 20;
      Cut: integer = 25; Neightbour: integer = 2); overload;
    procedure _IE_AutoImageEnhance1(bitmap: TIEBitmap; EditRect: Trect;
      bFullApply: boolean; theProgressEvent: TIEProgressEvent; SubsampledSize: integer = 60; Slope: integer = 20;
      Cut: integer = 25; Neightbour: integer = 2); overload;


    procedure _IE_AutoImageEnhance2(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent;
       ScaleCount: integer = 3; ScaleCurve: integer = 2;
      Variance: double = 1.8; ScaleHigh: integer = 200;
      Luminance: boolean = true); overload;

    procedure _IE_AutoImageEnhance2(bitmap: TIEBitmap; EditRect: Trect;
      bFullApply: boolean; theProgressEvent: TIEProgressEvent;
      ScaleCount: integer = 3; ScaleCurve: integer = 2;
      Variance: double = 1.8; ScaleHigh: integer = 200;
      Luminance: boolean = true); overload;


    procedure _IE_AutoImageEnhance3(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent;
       Gamma: double = 0.35; Saturation: integer = 80); overload;
    procedure _IE_AutoImageEnhance3(bitmap: TIEBitmap; EditRect: Trect;
      bFullApply: boolean; theProgressEvent: TIEProgressEvent; Gamma: double = 0.35; Saturation: integer = 80); overload;

    procedure ExecFilter(sender: TObject; theFilter: TIEProc_EX_Filter; theiebitmap: TIEbitmap; EditedRect: TRect; theFilterProgress: TIEProgressEvent);overload;
    procedure GetMultiThreadInfo(theFilter: TIEProc_EX_Filter;
                                 EditedRect: TRect;
                                 var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                 var theOverlap: cardinal; var bAutoOverlap: boolean);
    procedure SetMultiThreadNrThreads(const Value: cardinal);
    function _FilterDefaultNoChange(theFilter: TIEProc_EX_Filter): boolean;

    procedure _getautohistogramvalues(grayonly: boolean; bitmap: tIEbitmap; editrect: trect; var minBGRA, maxBGRA, avBGRA: TbeBGRAbytearray;
                                      var mingray, maxgray, avgray: byte);

    public

    procedure GetAutoColorCasts_SMH(const GuessAmount: integer; var Cast_Sh, Cast_Mid, Cast_Hi: TbeBGRAbytearray; bitmap: tIEbitmap; editrect: Trect);


    procedure ExecFilter(sender: TObject; theFilter: TIEProc_EX_Filter; theiebitmap: TIEbitmap; EditedRect: TRect); overload;

    constructor Create; reintroduce;
    Destructor Destroy; override;

    property MultiThreadEnabled: boolean read fMultiThreadEnabled write fMultiThreadEnabled;
    property MultiThreadNrThreads: cardinal read fMultiThreadNrThreads write SetMultiThreadNrThreads;
    property MultiThreadDefOverlapMethod: TIEMultiProc_EX_OverlapMethod read fMultiThreadDefOverlapMethod write fMultiThreadDefOverlapMethod;

    property OnProgress: TIEProgressEvent read fOnProgress write fOnProgress;
    property OnFinishWork: TNotifyEvent read fOnFinishWork write fOnFinishWork;
    property OnFilter_CustomMultiThreadInfo: TIEProc_Ex_CustomMultiThreadInfoEvent read fOnFilter_CustomMultiThreadInfo write fOnFilter_CustomMultiThreadInfo;
  end;

  procedure BE_GetLUTfromFunction(var LUT: TbeByteLUT;
    LutFunction: TbeLUTObjFunction); overload;
  procedure BE_GetLUTfromFunction(var LUT: TbeByteLUT;
    LutFunction: TbeLUTFunction); overload;

  procedure BE_ApplyCurvesbyFunction(bitmap: TIEBitmap; EditRect: Trect;
    RFunction, GFunction, BFunction, RGBFunction: TbeLUTObjFunction); overload;
  procedure BE_ApplyCurvesbyFunction(bitmap: TIEBitmap; EditRect: Trect;
    RFunction, GFunction, BFunction, RGBFunction: TbeLUTFunction); overload;

  procedure BE_ApplyLUTs1x1toBGRGray(BGRGrayLUTs: TbeByteLUTarray; bitmap: TIEBitmap;
    EditRect: Trect);

  procedure BE_ConvertBMP24To8(bitmap: TIEBitmap);

  procedure BE_ApplyScaledFilter(theiebitmap, theBuffer, theBufferOriginal
    : TIEBitmap; EditedRect: Trect);


implementation

type
  TbeBGRgrayconsts = array [0 .. 3] of single;

var
  interpPoints: TRGBCurves_DoublePointsarray;

  coefs_BE_BrightShadows, coefs_BE_BrightHilights,
  coefs_BE_DarkShadows, coefs_BE_DarkHilights,
    coefs_BE_LowContrast, coefs_BE_HiContrast, coefs_BE_ContrastLess,
    coefs_BE_ContrastMore, coefs_BE_DarkenShadows, coefs_BE_LightenHilights,
    coefs_BE_EnhanceContrastShadows, coefs_BE_EnhanceContrastShadows1,
    coefs_BE_EnhanceShadows, coefs_BE_EnhanceHilights,coefs_BE_EnhanceHilights2, coefs_BE_SmartFlash
    : TRGBCurves_DSplinevector;

const
  beLUTObjFunctionNil: TbeLUTObjFunction = nil;
  beLUTFunctionNil: TbeLUTFunction = nil;
  beBGRAgrayconsts_a: TbeBGRgrayconsts = (0.07, 0.64, 0.29, 0);

  beScaledSampleSize: integer = 400;
  beScaledSampleFilter: TResampleFilter = rffastlinear;

const
  beMaxGaussKernelSize = 100; // New Gaussian Blur optimized
  beKernelScale = 16;
  beKernelMultiplier = 1 shl beKernelScale;
  beKernelMultiplierd2 = beKernelMultiplier div 2;

const
BECONST_SHADOWS_VERYDARK_SIGNIFICANT_LIM_FROM = 30;
BECONST_SHADOWS_VERYDARK_SIGNIFICANT_LIM_TO = 45;

BECONST_SHADOWS_LIM_FROM = 0;
BECONST_SHADOWS_LIM_TO = 90;
BECONST_MIDTONES_LIM_FROM = BECONST_SHADOWS_LIM_TO + 1;
BECONST_MIDTONES_LIM_TO = 190;
BECONST_HIGHLIGHTS_LIM_FROM = BECONST_MIDTONES_LIM_TO + 1;
BECONST_HIGHLIGHTS_LIM_TO = 255;
BECONST_HIGHLIGHTSHIGH_LIM = 235;

type
  TbeGaussKernelSize = 1 .. beMaxGaussKernelSize;

  TbeGaussKernel = record
    Size: TbeGaussKernelSize;
    RealWeights: array [-beMaxGaussKernelSize .. beMaxGaussKernelSize]
      of double;
    IntWeights: array [-beMaxGaussKernelSize .. beMaxGaussKernelSize]
      of integer;
  end;

  PRGBRow = ^TRGBRow;
  TRGBRow = array [0 .. 1000000] of TRGBTriple;

  PRGB = ^TRGBTriple;


procedure DrawIEBitmapToIeBitmap(src, dest: TIEBitmap; XDest, YDest: integer; srcIERect: TIERectangle);   overload;
var
 xSrc1, xSrc2, ySrc1, ySrc2: integer;
 xdest1, xdest2, ydest1, ydest2: integer;
 ys,I, J, k: integer;
 pbs, pbd: pbytearray;
 bs, bd: integer;
 deltaByte: integer;
begin
   {$IFDEF IMAGEEN_6_3_0_LATER}  //copy alpha channel as well (available from ie 6.3.0 only)
      src.CopyRectTo(dest, srcIERect.x, srcIERect.y, XDest, YDest, srcIERect.width, srcIERect.height, true);
   {$ELSE}
      src.CopyRectTo(dest, srcIERect.x, srcIERect.y, XDest, YDest, srcIERect.width, srcIERect.height);
   {$ENDIF}

   EXIT;
   //below is our own implementation , which does not copy alpha channel


  if (src.PixelFormat <> dest.PixelFormat) or
     ((src.PixelFormat <> ie32rgb) and (src.PixelFormat <> ie24rgb) and (src.PixelFormat <> ie8g)) then
     raise Exception.Create('Wrong pixel format');

  case src.PixelFormat of
    ie32RGB: deltaByte := 3;
    ie24RGB: deltaByte := 2;
    else deltaByte := 0; //ie8g:
  end;


  xSrc1 := max(0, srcIERect.x);
  xSrc2 := min(src.Width - 1, srcIERect.x + srcIERect.width - 1);
  ySrc1 := max(0, srcIERect.y);
  ySrc2 := min(src.Height - 1, srcIERect.y + srcIERect.Height - 1);

  xDest1 := max(0, XDest);
  yDest1 := max(0, YDest);
  xDest2 := min(dest.width - 1, xDest + srcIERect.width - 1);
  yDest2 := min(dest.Height - 1, yDest + srcIERect.height - 1);

  for j := yDest1 to yDest2 do
  begin
    ys := j - yDest + ySrc1;
    pbd := dest.ScanLine[j];
    pbs := src.ScanLine[ys];

    bd := xDest1 * (deltaByte + 1);
    bs := (xDest1 - xDest + xSrc1) * (deltaByte + 1);
    for i := xDest1 to xDest2 do
    begin
      for k := 0 to deltaByte do
      begin
        pbd[bd] := pbs[bs];
        inc(bd);
        inc(bs);
      end;
    end;
  end;

end;


procedure DrawIEBitmapToIeBitmap(src, dest: TIEBitmap; XDest, YDest: integer); overload;
var
srcIERect: TIERectangle;
begin
  srcIERect.x := 0;
  srcIERect.y := 0;
  srcIERect.width := src.Width;
  srcIERect.height := src.Height;
  DrawIEBitmapToIeBitmap(src, dest, XDest, YDest, srcIERect);
end;

function GetSmartMaskID(mode:TBEMaskSmartMode; radius: integer; bInvertMAsk: boolean): string;
begin
  result := 'SmartID->' + inttostr(ord(mode)) + inttostr(radius) + booltostr(bInvertmask);
end;

procedure GBlur_MakeGaussKernel(var Kernel: TbeGaussKernel; radius: double);
var
  J: integer;
  Temp: double;
begin
  for J := Low(Kernel.RealWeights) to High(Kernel.RealWeights) do
  begin
    Temp := J / radius;
    Kernel.RealWeights[J] := Exp(-Temp * Temp / 1.5); // was / 2 instead of 1.5
  end;

  // normalize kernel
  Temp := 0;
  for J := Low(Kernel.RealWeights) to High(Kernel.RealWeights) do
    Temp := Temp + Kernel.RealWeights[J];
  for J := Low(Kernel.RealWeights) to High(Kernel.RealWeights) do
    Kernel.IntWeights[J] :=
      round(Kernel.RealWeights[J] * beKernelMultiplier / Temp);
  Kernel.Size := beMaxGaussKernelSize;


  // optimize size
  while (Kernel.Size > 1) and (Kernel.IntWeights[Kernel.Size] = 0) and
    (Kernel.IntWeights[-integer(Kernel.Size)] = 0) do  //integer(Kernel.Size) solves AV with 64 bits compiler
    dec(Kernel.Size);


end;

procedure GBlur_BlurRow24Bit(const Kernel: TbeGaussKernel;
  SourcePtr, DestPtr: PRGBRow; RowLen: integer);
var
  RowIndex, LoopIndex, KernelIndex, StopIndex: integer;
  Src, Dst: PRGB;
  MaxLen: integer;
  RR, GG, BB: integer;
  W: integer;
begin
  MaxLen := RowLen - 1;
  Dst := @DestPtr^[0];
  for RowIndex := 0 to MaxLen do
  begin
    KernelIndex := -Kernel.Size;
    LoopIndex := RowIndex - Kernel.Size;
    StopIndex := RowIndex + Kernel.Size;
    if StopIndex > MaxLen then
      StopIndex := MaxLen;
    // start values
    RR := beKernelMultiplierd2;
    GG := beKernelMultiplierd2;
    BB := beKernelMultiplierd2;
    // left part
    W := 0;
    while LoopIndex < 0 do
    begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
      inc(LoopIndex);
    end;
    with PRGB(SourcePtr)^ do
    begin
      inc(RR, W * rgbtred);
      inc(GG, W * rgbtgreen);
      inc(BB, W * rgbtblue);
    end;
    Src := @SourcePtr^[LoopIndex];
    // center part
    while LoopIndex <= StopIndex do
    begin
      W := Kernel.IntWeights[KernelIndex];
      with Src^ do
      begin
        inc(RR, W * rgbtred);
        inc(GG, W * rgbtgreen);
        inc(BB, W * rgbtblue);
      end;
      inc(KernelIndex);
      inc(LoopIndex);
      inc(Src);
    end;
    W := 0;
    while KernelIndex <= Kernel.Size do
    begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
    end;
    with SourcePtr^[MaxLen] do
    begin
      inc(RR, W * rgbtred);
      inc(GG, W * rgbtgreen);
      inc(BB, W * rgbtblue);
    end;
    // set pixel
    with Dst^ do
    begin
      rgbtred := RR shr beKernelScale;
      rgbtgreen := GG shr beKernelScale;
      rgbtblue := BB shr beKernelScale;
    end;
    inc(Dst);
  end;
end;

procedure GBlur_BlurRow8Bit(const Kernel: TbeGaussKernel;
  SourcePtr, DestPtr: pbytearray; RowLen: integer);
var
  RowIndex, LoopIndex, KernelIndex, StopIndex: integer;
  Src, Dst: pbyte;
  MaxLen: integer;
  GR: integer;
  W: integer;
begin
  MaxLen := RowLen - 1;
  Dst := @DestPtr^[0];
  for RowIndex := 0 to MaxLen do
  begin
    KernelIndex := -Kernel.Size;
    LoopIndex := RowIndex - Kernel.Size;
    StopIndex := RowIndex + Kernel.Size;
    if StopIndex > MaxLen then
      StopIndex := MaxLen;
    // start values
    GR := beKernelMultiplierd2;
    // left part
    W := 0;
    while LoopIndex < 0 do
    begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
      inc(LoopIndex);
    end;
    inc(GR, W * SourcePtr[0]);
    Src := @SourcePtr^[LoopIndex];
    // center part
    while LoopIndex <= StopIndex do
    begin
      W := Kernel.IntWeights[KernelIndex];
      inc(GR, W * Src^);
      inc(KernelIndex);
      inc(LoopIndex);
      inc(Src);
    end;
    W := 0;
    while KernelIndex <= Kernel.Size do
    begin
      inc(W, Kernel.IntWeights[KernelIndex]);
      inc(KernelIndex);
    end;
    inc(GR, W * SourcePtr^[MaxLen]);
    // set pixel
    Dst^ := GR shr beKernelScale;
    inc(Dst);
  end;
end;

procedure GBlur(bitmap: TIEBitmap; radius: double);
var
  x, y: integer;
  RowPtr, ColPtr: PRGBRow;
  RowPtr8, ColPtr8: pbytearray;
  Kernel: TbeGaussKernel;
  ScanBMP: TbeScanlines;

begin

  ScanBMP := TbeScanlines.Create;

  try

    if radius > 0 then
    begin
      // calculate kernel

      GBlur_MakeGaussKernel(Kernel, radius);



      case bitmap.PixelFormat of
        ie24RGB:
          begin
            ScanBMP.CreateScanlines_RGB(bitmap);
            if bitmap.Width > bitmap.Height then
              GetMem(RowPtr, bitmap.Width * SizeOf(TRGBTriple))
            else
              GetMem(RowPtr, bitmap.Height * SizeOf(TRGBTriple));
            // blur rows
            for y := 0 to bitmap.Height - 1 do
            begin
              GBlur_BlurRow24Bit(Kernel, PRGBRow(ScanBMP.Scanlines_RGB[y]),
                RowPtr, bitmap.Width);
              copymemory(PRGBRow(ScanBMP.Scanlines_RGB[y]), RowPtr,
                bitmap.Width * SizeOf(TRGBTriple));
            end;

            // blur columns
            GetMem(ColPtr, bitmap.Height * SizeOf(TRGBTriple));
            for x := 0 to bitmap.Width - 1 do
            begin
              for y := 0 to bitmap.Height - 1 do
              begin
                // RowPtr[Y] := PRGBROW(Bitmap.Scanline[y])[x];
                RowPtr[y] := PRGBRow(ScanBMP.Scanlines_RGB[y])[x];
              end;
              GBlur_BlurRow24Bit(Kernel, RowPtr, ColPtr, bitmap.Height);

              for y := 0 to bitmap.Height - 1 do
              begin
                // PRGBROW(Bitmap.Scanline[y])[x] := ColPtr[Y];
                PRGBRow(ScanBMP.Scanlines_RGB[y])[x] := ColPtr[y];
              end;
            end;
            FreeMem(ColPtr);
            FreeMem(RowPtr);
          end;
        ie8p, ie8g:
          begin
            ScanBMP.CreateScanlines(bitmap);
            if bitmap.Width > bitmap.Height then
              GetMem(RowPtr8, bitmap.Width)
            else
              GetMem(RowPtr8, bitmap.Height);
            // blur rows
            for y := 0 to bitmap.Height - 1 do
            begin
              GBlur_BlurRow8Bit(Kernel, pbytearray(ScanBMP.Scanlines[y]),
                RowPtr8, bitmap.Width);
              copymemory(pbytearray(ScanBMP.Scanlines[y]), RowPtr8,
                bitmap.Width);
              
            end;
            // blur columns
            GetMem(ColPtr8, bitmap.Height);
            for x := 0 to bitmap.Width - 1 do
            begin
              for y := 0 to bitmap.Height - 1 do
              begin
                RowPtr8[y] := pbytearray(ScanBMP.Scanlines[y])[x];
                // RowPtr8[Y] := pbytearray(Bitmap.Scanline[y])[x];
              end;
              GBlur_BlurRow8Bit(Kernel, RowPtr8, ColPtr8, bitmap.Height);
              for y := 0 to bitmap.Height - 1 do
              begin
                pbytearray(ScanBMP.Scanlines[y])[x] := ColPtr8[y];
                // pbytearray(Bitmap.Scanline[y])[x] := ColPtr8[Y];
              end;
            end;
            FreeMem(ColPtr8);
            FreeMem(RowPtr8);
          end;
      end;
    end;

  finally
    ScanBMP.free;
  end;
end;

function KeepinRange(Thevalue: integer): byte;
begin
  if Thevalue > 255 then
    Result := 255
  else if Thevalue < 0 then
    Result := 0
  else
    Result := Thevalue;
end;

procedure GenerateNoChangeLUT(var theLUT: TbeByteLUT);
var
  i: integer;
begin
  for i := 0 to High(theLUT) do
    theLUT[i] := i;
end;





function BE_PreserveBGRA_lum(oldBGRA, newBGRA: TbeBGRAbytearray): TbeBGRAbytearray;
var
  l, lold: integer;
  k: integer;
begin
  lold := round(0.3 * oldBGRA[2] + 0.6 * oldBGRA[1] + 0.1 * oldBGRA[0]);
  l := round(0.3 * newBGRA[2] + 0.6 * newBGRA[1] + 0.1 * newBGRA[0]);

  for k := 0 to 2 do
  begin
    result[k] := max(0, min(255, round(newBGRA[k] * lold / (l + 1))));
  end;

end;


function BE_InterpolatedCurve(x: single): single;
var
  coefs: TRGBCurves_DSplinevector;
begin
  CalculateBSplineCoefs(coefs, TRGBCurves_DoublePointsarray(interpPoints));
  Result := GetSplineCurveValue(coefs, x);
end;

function BE_GetInterpFunctionfromPoints(points: TRGBCurves_DoublePointsarray)
  : TbeLUTFunction;
var
  i: integer;
begin
  setlength(interpPoints, length(points));
  for i := 0 to length(points) - 1 do
    interpPoints[i] := points[i];
  Result := BE_InterpolatedCurve;
end;



procedure GetInterpPoints_BE_BrightShadows(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 6);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 20.970;
  points[1].y := 81.964;
  points[2].x := 54.523;
  points[2].y := 133.571;
  points[3].x := 128.338;
  points[3].y := 145.714;
  points[4].x := 192.088;
  points[4].y := 193.273;
  points[5].x := 255;
  points[5].y := 255;
end;

function BE_BrightShadows(x: single): single;
begin

  Result := GetSplineCurveValue(coefs_BE_BrightShadows, x);
end;

procedure GetInterpPoints_BE_BrightHilights(var points
  : TRGBCurves_DoublePointsarray);
begin

 setlength(points, 6);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 66.266;
  points[1].y := 69.821;
  points[2].x := 93.947;
  points[2].y := 110.297;
  points[3].x := 123.306;
  points[3].y := 193.273;
  points[4].x := 180.345;
  points[4].y := 246.904;
  points[5].x := 255;
  points[5].y := 255;
end;

function BE_BrightHilights(x: single): single;
begin

  Result := GetSplineCurveValue(coefs_BE_BrightHilights, x);
end;




procedure GetInterpPoints_BE_DarkShadows(var points
  : TRGBCurves_DoublePointsarray);
begin

  setlength(points, 5);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 38.5855255126953;
  points[1].y := 3.03571438789368;
  points[2].x := 97.3026275634766;
  points[2].y := 20.238094329834;
  points[3].x := 134.210525512695;
  points[3].y := 108.273811340332;
  points[4].x := 255;
  points[4].y := 255;
end;

function BE_DarkShadows(x: single): single;
begin

  Result := GetSplineCurveValue(coefs_BE_DarkShadows, x);
end;

procedure GetInterpPoints_BE_DarkHilights(var points
  : TRGBCurves_DoublePointsarray);
begin

 setlength(points, 6);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 115.756576538086;
  points[1].y := 106.25;
  points[2].x := 152.664474487305;
  points[2].y := 123.452377319336;
  points[3].x := 199.638153076172;
  points[3].y := 139.642852783203;
  points[4].x := 244.09538269043;
  points[4].y := 191.25;
  points[5].x := 255;
  points[5].y := 255;
end;

function BE_DarkHilights(x: single): single;
begin

  Result := GetSplineCurveValue(coefs_BE_DarkHilights, x);
end;



procedure GetInterpPoints_BE_LowContrast(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 11);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 18;
  points[1].y := 64;
  points[2].x := 32;
  points[2].y := 90;
  points[3].x := 64;
  points[3].y := 112;
  points[4].x := 96;
  points[4].y := 122;
  points[5].x := 128;
  points[5].y := 128;

  points[6].x := 192;
  points[6].y := 144;
  points[7].x := 224;
  points[7].y := 160;
  points[8].x := 247;
  points[8].y := 192;
  points[9].x := 251;
  points[9].y := 224;
  points[10].x := 255;
  points[10].y := 255;
end;

function BE_LowContrast(x: single): single;
begin

  Result := GetSplineCurveValue(coefs_BE_LowContrast, x);
end;

procedure GetInterpPoints_BE_HiContrast(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 11);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 32;
  points[1].y := 4;
  points[2].x := 64;
  points[2].y := 8;
  points[3].x := 96;
  points[3].y := 32;
  points[4].x := 112;
  points[4].y := 64;
  points[5].x := 128;
  points[5].y := 128;

  points[6].x := 144;
  points[6].y := 192;
  points[7].x := 160;
  points[7].y := 224;
  points[8].x := 192;
  points[8].y := 250;
  points[9].x := 224;
  points[9].y := 253;
  points[10].x := 255;
  points[10].y := 255;
end;

function BE_HiContrast(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_HiContrast, x);
end;

procedure GetInterpPoints_BE_DarkenShadows(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 9);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 29.691780090332;
  points[1].y := 8.25;
  points[2].x := 59.3835601806641;
  points[2].y := 24.75;
  points[3].x := 93.441780090332;
  points[3].y := 57.75;
  points[4].x := 153.698623657227;
  points[4].y := 153;
  points[5].x := 170.291091918945;
  points[5].y := 171;
  points[6].x := 192;
  points[6].y := 192;
  points[7].x := 217;
  points[7].y := 217;
  points[8].x := 255;
  points[8].y := 255;
end;

function BE_DarkenShadows(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_DarkenShadows, x);
end;

procedure GetInterpPoints_BE_LightenHilights(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 9);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 22.7054786682129;
  points[1].y := 23.25;
  points[2].x := 38.4246559143066;
  points[2].y := 39.75;
  points[3].x := 65.4965744018555;
  points[3].y := 65.25;
  points[4].x := 96.934928894043;
  points[4].y := 99;
  points[5].x := 134;
  points[5].y := 163;
  points[6].x := 172;
  points[6].y := 214;
  points[7].x := 205;
  points[7].y := 238;
  points[8].x := 255;
  points[8].y := 255;
end;

function BE_LightenHilights(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_LightenHilights, x);
end;

procedure GetInterpPoints_BE_contrastMore(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 7);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 23.6293430328369;
  points[1].y := 16.0089683532715;
  points[2].x := 74.8262557983398;
  points[2].y := 51.4573974609375;
  points[3].x := 123.069496154785;
  points[3].y := 126.928253173828;
  points[4].x := 178.204635620117;
  points[4].y := 216.121078491211;
  points[5].x := 233.339767456055;
  points[5].y := 246.995513916016;
  points[6].x := 255;
  points[6].y := 255;

end;

function BE_contrastMore(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_ContrastMore, x);
end;

procedure GetInterpPoints_BE_contrastless(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 5);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 30.2697830200195;
  points[1].y := 58.9082260131836;
  points[2].x := 127.5;
  points[2].y := 127.5;
  points[3].x := 205.467620849609;
  points[3].y := 171.075942993164;
  points[4].x := 255;
  points[4].y := 255;
end;

function BE_contrastless(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_ContrastLess, x);
end;

procedure GetInterpPoints_BE_EnhanceContrastShadows
  (var points: TRGBCurves_DoublePointsarray);
begin
  setlength(points, 9);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 14.845890045166;
  points[1].y := 35.25;
  points[2].x := 28.8184909820557;
  points[2].y := 69.75;
  points[3].x := 58.5102729797363;
  points[3].y := 131.25;
  points[4].x := 93.441780090332;
  points[4].y := 185.25;
  points[5].x := 114.400680541992;
  points[5].y := 204.75;
  points[6].x := 137.979446411133;
  points[6].y := 216.75;
  points[7].x := 184.655166625977;
  points[7].y := 228.479995727539;
  points[8].x := 255;
  points[8].y := 255;
end;

function BE_EnhanceContrastShadows(x: single): single;
begin
  Result := 1.21 * GetSplineCurveValue(coefs_BE_EnhanceContrastShadows, x);
end;

procedure GetInterpPoints_BE_EnhanceContrastShadows1
  (var points: TRGBCurves_DoublePointsarray);
begin

  setlength(points, 7);

  points[0].x := 0;
  points[0].y := 0;

  points[1].x := 10.8301162719727;
  points[1].y := 23.2826080322266;

  points[2].x := 26.5830116271973;
  points[2].y := 63.1956520080566;

  points[3].x := 45.2895736694336;
  points[3].y := 113.086952209473;

  points[4].x := 64.9806976318359;
  points[4].y := 155.217391967773;

  points[5].x := 205.775314331055;
  points[5].y := 255;

  points[6].x := 255;
  points[6].y := 255;

end;

function BE_SmartFlash(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_SmartFlash, x);
end;

function BE_EnhanceContrastShadows1(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_EnhanceContrastShadows1, x);
end;

procedure GetInterpPoints_BE_SmartFlash(var points
  : TRGBCurves_DoublePointsarray);
begin

  setlength(points, 6);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 32.9032249450684;
  points[1].y := 58.698112487793;
  points[2].x := 66.7204284667969;
  points[2].y := 132.792449951172;
  points[3].x := 106.935485839844;
  points[3].y := 192.452835083008;
  points[4].x := 160;
  points[4].y := 217;
  points[5].x := 255;
  points[5].y := 255;
end;

procedure GetInterpPoints_BE_EnhanceShadows(var points
  : TRGBCurves_DoublePointsarray);
begin

  setlength(points, 5);

  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 31.245059967041;
  points[1].y := 103.291137695313;
  points[2].x := 54.4268760681152;
  points[2].y := 151.708862304688;
  points[3].x := 154.209487915039;
  points[3].y := 255;
  points[4].x := 255;
  points[4].y := 255;
end;

function BE_EnhanceShadows(x: single): single;
begin
  Result := 1.0 * GetSplineCurveValue(coefs_BE_EnhanceShadows, x);
end;

function BE_EnhanceContrastShadows2_8(x: single): single;
begin
  Result := 0.25 * BE_EnhanceContrastShadows1(x) + 0.75 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows3_7(x: single): single;
begin
  Result := 0.35 * BE_EnhanceContrastShadows1(x) + 0.65 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows4_6(x: single): single;
begin
  Result := 0.42 * BE_EnhanceContrastShadows1(x) + 0.58 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows5_5(x: single): single;
begin
  Result := 0.55 * BE_EnhanceContrastShadows1(x) + 0.45 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows6_4(x: single): single;
begin
  Result := 0.62 * BE_EnhanceContrastShadows1(x) + 0.38 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows7_3(x: single): single;
begin
  Result := 0.72 * BE_EnhanceContrastShadows1(x) + 0.28 * BE_EnhanceShadows(x);
end;

function BE_EnhanceContrastShadows8_2(x: single): single;
begin
  Result := 0.8 * BE_EnhanceContrastShadows1(x) + 0.2 * BE_EnhanceShadows(x);
end;

procedure GetInterpPoints_BE_EnhanceHilights(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 4);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 136;
  points[1].y := 10;
  points[2].x := 189.48616027832;
  points[2].y := 61.9626159667969;
  points[3].x := 255;
  points[3].y := 255;
end;

function BE_EnhanceHilights(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_EnhanceHilights, x);
end;


procedure GetInterpPoints_BE_EnhanceHilights2(var points
  : TRGBCurves_DoublePointsarray);
begin
  setlength(points, 4);
  points[0].x := 0;
  points[0].y := 0;
  points[1].x := 190;
  points[1].y := 135;
  points[2].x := 220;
  points[2].y := 192;
  points[3].x := 255;
  points[3].y := 255;
end;

function BE_EnhanceHilights2(x: single): single;
begin
  Result := GetSplineCurveValue(coefs_BE_EnhanceHilights2, x);
end;


function BE_Brightness(amount, x: single; brightnessmode: Tbebrightmode): single;
begin
  result := x;
  if abs(amount) < 0.01 then
    exit;


    case brightnessmode of
    bmShadows:
      if amount>0 then
        result := (x * (255 - amount) + BE_BrightShadows(x) * amount) / 255
      else
        result := (x * (255 + amount) - BE_DarkShadows(x) * amount) / 255;

    bmMidlights:
      result := (255 * x + 2 * (255 - x) * amount * x / 255) / 255;
    bmhilights:
      if amount>0 then
        result := (x * (255 - amount) + BE_BrightHilights(x) * amount) / 255
      else
        result := (x * (255 + amount) - BE_DarkHilights(x) * amount) / 255;
    bmAll:
      result := x + amount;
    end;
end;

function BE_Brightness1(amount, x: single; brightnessmode: Tbebrightmode; selectivity: single): single;
begin
  result := x;
  if abs(amount) < 0.01 then
    exit;

  if amount > 0 then
  begin
    case brightnessmode of
    bmShadows:
      result := x + power(1 + selectivity * 3, max(0, (128 - x))/128) * amount ; //result := x + (255 - x) * amount / 255;
    bmMidlights:
      result := (255 * x + 2 * (255 - x) * amount * x / 255) / 255;
    bmhilights:
      result := x + power(1 + selectivity * 1.5, x/ 255) * amount;
    bmAll:
      result := x + amount;
    end;
  end
  else
  begin
    case brightnessmode of
    bmShadows:
      result := x + power(1 / (1 + 3 * selectivity), max(0, (128 - x))/128) * amount ; //result := x + (255 - x) * amount / 255;
    bmMidlights:
      result := (255 * x + 2 * (255 - x) * amount * x / 255) / 255;
    bmhilights:
      result := x + power(1 / (1 + selectivity * 1.5), x/ 255) * amount;
    bmAll:
      result := x + amount;
  end;
  end;


end;


procedure GetBrightnessLUT(var theLUT: TbeByteLUT; amount: integer; brightnessmode: Tbebrightmode; selectivity: single); overload;
var
  i: integer;
begin
  for i := 0 to High(TheLUT) do
  begin
    TheLUT[i] := keepinrange(round(BE_Brightness(amount, i, brightnessmode)));
  end;
end;



procedure GetBrightnessLUT(var theLUT: TbeByteLUT; amountSh, amountMid, amountHi, amountAll: integer); overload;
var
  i: integer;
  s:single;
begin
  for i := 0 to High(TheLUT) do
  begin
    s := i;

    s := BE_Brightness(amountMid, s, bmMidlights);
    s := BE_Brightness(amountSh, s, bmShadows);
    s := BE_Brightness(amountHi, s, bmHilights);
    s := BE_Brightness(amountAll, s, bmAll);

    TheLUT[i] := keepinrange(round(s));
  end;
end;




procedure BE_BlendPixel_RGB(var result_R, result_G, result_B: byte;
  fg_R, fg_G, fg_B, bg_R, bg_G, bg_B: byte; amt: integer);
var
  transp: integer;
begin
  transp := 255 - amt;
  result_R := (fg_R * amt + bg_R * transp) div 255;
  result_G := (fg_G * amt + bg_G * transp) div 255;
  result_B := (fg_B * amt + bg_B * transp) div 255;
end;

function BE_DummyFunction(Self: TObject; x: single): single;
begin
  Result := TbeLUTFunction(Self)(x);
end;

procedure BE_Get_Shiftby_Readby_Values(var Shiftby, Readby: integer;
  bepf: Tbepixelformat; const bEditAlpha: boolean = false);
begin
  case bepf of
    bepf8:
      begin
        Shiftby := 1;
        Readby := 0;
      end;
    bepf16:
      begin
        Shiftby := 2;
        Readby := 1;
      end;
    bepf24:
      begin
        Shiftby := 3;
        Readby := 2;
      end;
    bepf32:
      begin
        Shiftby := 4;
        if bEditAlpha then
          Readby := 3
        else
          Readby := 2;
      end;
  end;

end;

procedure BE_Getpixelformat(var thebepf: Tbepixelformat; thebitmap: TIEBitmap);
begin
  with thebitmap do
  begin
    case PixelFormat of
      ie8g, ie8p:
        thebepf := bepf8;
      ie24RGB:
        thebepf := bepf24;
      ie32RGB:
        thebepf := bepf32;
    else
      thebepf := bepfother;
    end;
    
  end;
end;

procedure BE_GetEditCoords(var X1, y1, X2, y2: integer; ERect: Trect;
  bmpw, bmph: integer);
begin
  X1 := max(0, ERect.left);
  y1 := max(0, ERect.top);
  X2 := min(bmpw - 1, ERect.right);
  y2 := min(bmph - 1, ERect.bottom);
end;

procedure BE_LoadArrayFromBMP(var My2DArray: TbeMaskarray; bitmap: TIEBitmap;
  const Inverted: boolean = false);
var
  row: integer;
  Src, Dst: pbebyteArray;
  copysize: integer;
begin

  case bitmap.PixelFormat of
    ie32RGB:
      copysize := 4 * bitmap.Width;
    ie24RGB:
      copysize := 3 * bitmap.Width;
    ie8g, ie8p:
      copysize := bitmap.Width;
  else
    exit;
  end;

  setlength(My2DArray, bitmap.Height, copysize);

  for row := 0 to bitmap.Height - 1 do
  begin
    Src := bitmap.scanline[row];
    Dst := @My2DArray[row, 0];
    move(Src^, Dst^, copysize);
  end;
end;

procedure BE_LoadBMPFromArray(var bitmap: TIEBitmap; My2DArray: TbeMaskarray;
  const Inverted: boolean = false);
var
  row: integer;
  Src, Dst: pbebyteArray;
  copysize, divisor: integer;
begin
  copysize := length(My2DArray[0]);

  case bitmap.PixelFormat of
    ie32RGB:
      divisor := 4;
    ie24RGB:
      divisor := 3;
    ie8g, ie8p:
      divisor := 1;
  else
    exit;
  end;

  bitmap.Height := length(My2DArray);
  bitmap.Width := copysize div divisor;

  for row := 0 to bitmap.Height - 1 do
  begin
    Src := @My2DArray[row, 0];
    Dst := bitmap.scanline[row];
    move(Src^, Dst^, copysize);
  end;
end;

{ TbeScanlines }

constructor TbeScanlines.Create;
begin
  inherited Create;
end;

Destructor TbeScanlines.Destroy;
begin
  Scanlines := nil;
  Scanlines_RGB := nil;
  inherited;
end;

procedure TbeScanlines.CreateScanlines(theBMP: TIEBitmap);
var
  J: integer;
begin
  setlength(Scanlines, 0);
  setlength(Scanlines, theBMP.Height);

  for J := 0 to theBMP.Height - 1 do
    Scanlines[J] := theBMP.scanline[J];
end;

procedure TbeScanlines.CreateScanlines(theBMP: TIEBitmap; y1, y2: integer);
var
  J: integer;
begin
  setlength(Scanlines, 0);
  setlength(Scanlines, theBMP.Height);

  for J := y1 to y2 do
    Scanlines[J] := theBMP.scanline[J];
end;

procedure TbeScanlines.CreateScanlines_RGB(theBMP: TIEBitmap);
var
  J: integer;
begin
  setlength(Scanlines_RGB, 0);
  setlength(Scanlines_RGB, theBMP.Height);

  for J := 0 to theBMP.Height - 1 do
    Scanlines_RGB[J] := theBMP.scanline[J];

end;

{ TBemask }
constructor TBEMask.Create;
begin

  fWidth := 0;
  fHeight := 0;
  fBitsperpixel := 8;
  fmaskarray := nil;
  fX1 := 0;
  fY1 := 0;
  fX2 := 0;
  fY2 := 0;
  fMaskMTProc := TIEMultiProc_EX.Create;
  fMaskMTProc.ProcessMessagesWhileInProgress := FALSE;

  fTempFilter := TIEProc_EX_Filter.Create;

end;

destructor TBEMask.Destroy;
begin
  fTempFilter.Free;
  fMaskMTProc.free;
  inherited;
end;

(*
procedure TBEMask.DefineFromIeMask(theIEMask: TIEMask);
var
  i, J: integer;
  ax1, ay1, ax2, ay2: integer;
begin
  ax1 := theIEMask.X1;
  ax2 := theIEMask.X2;
  ay1 := theIEMask.y1;
  ay2 := theIEMask.y2;

  Define(ax2 - ax1 + 1, ay2 - ay1 + 1, ax1, ay1, 0);


  for i := ax1 to ax2 do
  begin
    for J := ay1 to ay2 do
    begin
      case theIEMask.BitsperPixel of
        8:
          SetValue(i - ax1, J - ay1, theIEMask.GetPixel(i, J));
        1:
          begin
            if theIEMask.GetPixel(i, J) = 0 then
              SetValue(i - ax1, J - ay1, 0)
            else
              SetValue(i - ax1, J - ay1, 255);
          end;
      end;

    end;
  end;
end;
*)

procedure TBEMask.DefineFromIeMask(theIEMask: TIEMask);
var
  i, J: integer;
  ax1, ay1, ax2, ay2: integer;
  psel:pbyte;
begin
  ax1 := theIEMask.X1;
  ax2 := theIEMask.X2;
  ay1 := theIEMask.y1;
  ay2 := theIEMask.y2;

  Define(ax2 - ax1 + 1, ay2 - ay1 + 1, ax1, ay1, 0);

  for J := ay1 to ay2 do
  begin
    psel := theIEMask.ScanLine[j];
    case theIEMask.BitsperPixel of
    1:
      begin
        for i := ax1 to ax2 do
        begin
          if (pbytearray(psel)^[i shr 3] and iebitmask1[i and $7]) = 0 then
             SetValue(i - ax1, J - ay1, 0)
          else
             SetValue(i - ax1, J - ay1, 255);
        end;
      end;
    8:
      begin
        inc(psel, sizeof(byte)*ax1);
        for i := ax1 to ax2 do
        begin
          SetValue(i - ax1, J - ay1, psel^);
          inc(psel);
        end;
      end;
    end;
  end;
end;

procedure TBEMask.Define(theWidth, theHeight, The_x1, The_y1: integer;
  blankValue: byte);
var
  i, J: integer;
begin
  fX1 := The_x1;
  fY1 := The_y1;
  fWidth := theWidth;
  fHeight := theHeight;
  fX2 := fX1 + fWidth - 1;
  fY2 := fY1 + fHeight - 1;
  setlength(fmaskarray, theHeight, theWidth);

  for J := 0 to fHeight - 1 do
    for i := 0 to fWidth - 1 do
      fmaskarray[J, i] := blankValue;
end;

procedure TBEMask.ReDefine(theWidth, theHeight, The_x1, The_y1: integer);
begin
  fX1 := The_x1;
  fY1 := The_y1;
  fWidth := theWidth;
  fHeight := theHeight;
  fX2 := fX1 + fWidth - 1;
  fY2 := fY1 + fHeight - 1;
  setlength(fmaskarray, theHeight, theWidth);
end;

function TBEMask.GetValue(x, y: integer): byte;
begin
  Result := fmaskarray[y, x];
end;

function TBEMask.GetValue_bool(x, y: integer): boolean;
begin
  Result := GetValue(x, y) > 0;
end;

procedure TBEMask.SetValue(x, y: integer; Value: byte);
begin
  fmaskarray[y, x] := Value;
end;

procedure TBEMask.SetValue_bool(x, y: integer; Value: boolean);
begin
  if Value then
    SetValue(x, y, 1)
  else
    SetValue(x, y, 0);
end;

procedure TBEMask.SetX1(x: integer);
begin
  fX1 := x;
  fX2 := x + fWidth - 1;
end;

procedure TBEMask.SetY1(y: integer);
begin
  fY1 := y;
  fY2 := y + fHeight - 1;
end;

procedure TBEMask.LoadFrom8bitBMP(theBMP: TIEBitmap;
  const Inverted: boolean = false);
begin
  if not assigned(theBMP) then
    exit;

  fWidth := theBMP.Width;
  fHeight := theBMP.Height;
  fX2 := fX1 + fWidth - 1;
  fY2 := fY1 + fHeight - 1;
  fBitsperpixel := 8;

  BE_LoadArrayFromBMP(fmaskarray, theBMP);
end;

procedure TBEMask.LoadfromBMP(theBMP: TIEBitmap; bInvertMAsk: boolean);
var
  bepf: Tbepixelformat;
  Readby, Shiftby: integer;

  i, J, k: integer;
  pp: pbebyteArray;
  tempx: integer;
  gray: integer;

begin
  if not assigned(theBMP) then
    exit;

  bepf := bepfother;
  BE_Getpixelformat(bepf, theBMP);
  if bepf = bepfother then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);
  setlength(fmaskarray, theBMP.Height, theBMP.Width);

  fWidth := theBMP.Width;
  fHeight := theBMP.Height;
  fX2 := fX1 + fWidth - 1;
  fY2 := fY1 + fHeight - 1;
  fBitsperpixel := 8;
  (*
  try
    try
    *)
      for J := 0 to theBMP.Height - 1 do
      begin
        pp := theBMP.scanline[J];
        tempx := 0;
        for i := 0 to theBMP.Width - 1 do
        begin
          gray := 0;
          for k := 0 to Readby do
          begin
            gray := gray + pp[tempx + k];
          end;
          gray := gray div Shiftby;
          case bInvertMAsk of
            false:
              fmaskarray[J, i] := gray;
            true:
              fmaskarray[J, i] := 255 - gray;
          end;
          tempx := tempx + Shiftby;
        end;
      end;
   (* except
      ;
    end;
  finally

  end; *)
end;

procedure TBEMask.GetMap_Coefs(var coeffarray: TBeMaskCoeffArray;
  var blocksize: integer; theBMP: TIEBitmap; radius: single;
  smartmask_mode: TBEMaskSmartMode; InvertCoef: boolean);
var
  i, J, ii, jj, X1, y1, X2, y2: integer;

  blockLeft, blockright, blocktop, blockbottom: integer;
  numblocksHorz, numblocksvert: integer;
  blockRect: Trect;

  coef_s: single;
  somma, coef: integer;
  Tots, totm, toth, tot_other, pixamount: single;
  totpixels: integer;
  denss, densm, densh, dens_other: single;
  avg_gray, gray: integer;

  // pp_array: array of pbebytearray;

  ScanBMP: TbeScanlines;
begin
  blocksize := max(1, round(2 * radius));

  numblocksHorz := theBMP.Width div blocksize;
  numblocksvert := theBMP.Height div blocksize;

  if (theBMP.Width) mod blocksize > 0 then
    numblocksHorz := numblocksHorz + 1;
  if (theBMP.Height) mod blocksize > 0 then
    numblocksvert := numblocksvert + 1;

  setlength(coeffarray, numblocksHorz, numblocksvert);

  X1 := 0;
  y1 := 0;
  X2 := theBMP.Width - 1;
  y2 := theBMP.Height - 1;

  ScanBMP := TbeScanlines.Create;
  ScanBMP.CreateScanlines(theBMP);

  try
    // setlength(pp_array, thebmp.height);

    for J := 0 to numblocksvert - 1 do
    begin
      blocktop := J * blocksize;
      blockbottom := min(y2, (J + 1) * blocksize - 1);
      for i := 0 to numblocksHorz - 1 do
      begin
        blockLeft := i * blocksize;
        blockright := min(X2, (i + 1) * blocksize - 1);
        blockRect := rect(blockLeft, blocktop, blockright, blockbottom);

        case smartmask_mode of
            sm_shadows_midtones, sm_Midtones, sm_lum_Variation:
            begin
              somma := 0;
              totpixels := 0;
              for jj := blocktop to blockbottom do
              begin

                for ii := blockLeft to blockright do
                begin
                  somma := somma + ScanBMP.Scanlines[jj, ii];
                  inc(totpixels);
                end;
              end;
              avg_gray := somma div totpixels;
            end
            else
              avg_gray := 127;
        end;
        avg_gray := max(1, avg_gray);

        Tots := 0;
        totm := 0;
        toth := 0;
        tot_other := 0;
        totpixels := 0;
        for jj := blocktop to blockbottom do
        begin

          for ii := blockLeft to blockright do
          begin
            inc(totpixels);
            gray := ScanBMP.Scanlines[jj, ii];
            case smartmask_mode of

              sm_lum_Variation:
                begin
                  pixamount := sqrt(abs(gray - avg_gray) / 255) * gray / 255;
                  // pixamount := abs(gray - avg_gray)/255*gray/255;
                  tot_other := tot_other + pixamount;
                end;
              sm_shadows:
                begin

                  if gray < 70 then
                  begin
                    pixamount := gray / 70;
                    totm := totm + pixamount;
                    Tots := Tots + 1 - pixamount;


                  end
                  else
                  begin
                    pixamount := (gray - 70) / (255 - 70);
                    toth := toth + pixamount;
                    totm := totm + 1 - pixamount;
                  end;
                end;
              sm_hilights:
                begin
                  if gray < 128 then
                  begin
                    pixamount := gray / 127;
                    totm := totm + pixamount;
                    Tots := Tots + 1 - pixamount;
                  end
                  else
                  begin
                    pixamount := (gray - 128) / 128;
                    toth := toth + pixamount;
                    totm := totm + 1 - pixamount;
                  end;
                end;
              sm_midtones:
                begin
                  pixamount := 1 - abs((gray - avg_gray) / 255);
                  pixamount := max(0, pixamount - 0.3 * ord(gray < 0.6 * avg_gray) - 0.4 * ord(gray > 1.2 * avg_gray));

                  totm := totm + pixamount;
                end;
              sm_shadows_midtones:
                begin

                  if gray < avg_gray then
                  begin
                    pixamount := gray / avg_gray;
                    totm := totm + pixamount;
                    Tots := Tots + 1 - pixamount;
                    if gray<0.35 * avg_gray then
                      Tots := Tots + 0.85;  //incentive to shadows
                  end
                  else if gray < 175 then
                  begin
                    pixamount := (gray - avg_gray) / (175 - avg_gray);
                    toth := toth + 0.5 * pixamount;
                    Totm := Totm + 0.5 * (1 - pixamount);
                  end
                  else
                  begin
                    pixamount := (gray - 175) / (255 - 175);
                    toth := toth + pixamount;
                    if gray >210 then
                      toth := toth + 0.75; //incentive to hilights
                  end;

                end;

            end;

          end;
        end;

        denss := Tots / totpixels;
        densm := totm / totpixels;
        densh := toth / totpixels;
        dens_other := tot_other / totpixels;

        case smartmask_mode of
          sm_shadows:
            coef_s := min(1, max(0, 5 * denss - 0.1 * densm - 0.35 * densh));
          sm_hilights:
            coef_s := min(1, max(0, 1.2 * densh - 0.2 * densm - 0.6 * denss));
          sm_midtones:
            coef_s := densm;
          sm_shadows_midtones:
            coef_s := min(1, max(0, 3.2 * denss + 0.8 * densm - 0.3 * densh));
          sm_lum_Variation:
            coef_s := min(1, max(0, dens_other));
          else
            coef_s := 0;
        end;

        coef := round(coef_s * 255);
        if InvertCoef then
          coeffarray[i, J] := 255 - coef
        else
          coeffarray[i, J] := coef;
      end;
    end;
  finally
    ScanBMP.free;
  end;
end;

procedure TBEMask.GetMap(bMultithreaded: boolean; coeffarray: TBeMaskCoeffArray; BMP: TIEBitmap;
  blocksize: integer; radius: single; const bApplyBlur: boolean = true);
var
  ii, jj, tempi, tempj: integer;
  W, h: integer;
  scan: TbeScanlines;
begin
  W := BMP.Width;
  h := BMP.Height;

  BMP.Width := 0;
  BMP.Height := 0;
  BMP.PixelFormat := ie8g;

  BMP.Width := W;
  BMP.Height := h;

  scan := TbeScanlines.Create;
  try
    scan.CreateScanlines(BMP);

    for jj := 0 to BMP.Height - 1 do
    begin
      tempj := jj div blocksize;
      for ii := 0 to BMP.Width - 1 do
      begin
        tempi := ii div blocksize;

        scan.Scanlines[jj, ii] := coeffarray[tempi, tempj];
      end;
    end;
  finally
    scan.free;
  end;


  // Now smooth mask
  if bApplyBlur then
  begin
     MaskGblur(bMultiThreaded, BMP, radius);
  end;

end;




procedure TBEMask.Filter_MaskGBlur(sender: TObject;
  theFilter: TIEProc_EX_Filter; bitmap: TIEBitmap; EditRect: Trect;
  FilterProgress: TIEProgressEvent);
begin
  GBlur(bitmap, theFilter.Params.Param_Byname(BEMASK_FILTERPARAM_RADIUS).GetValue_double);
end;


procedure TBEMask.MaskGblur(bMultithreaded: boolean; bitmap: TIEBitmap; radius: double);
 
 var
  pf: TIEPixelFormat;
begin
  pf := bitmap.PixelFormat;


  case pf of
    ie24RGB, ie8p, ie8g: //do nothing
  else
    bitmap.PixelFormat := ie24RGB;
  end;


     fTempFilter.ClearParams;
     fTempFilter.Params.AddParam(BEMASK_FILTERPARAM_RADIUS, pt_double);
     fTempFilter.SetParamValue(BEMASK_FILTERPARAM_RADIUS, radius);


     if bMultithreaded and (fMaskMTProc.NumberOfProcessors>1)then
     begin
       fMaskMTProc.ProcessMessagesWhileInProgress := FALSE;
       fMaskMTProc.Run(fMaskMTProc.NumberOfProcessors, bitmap, rect(0,0, bitmap.width - 1, bitmap.Height - 1), Filter_MaskGBlur,
                         fTempFilter, round(1.0 * radius), omAddExtraPixels, true);
     end
     else
       Filter_MaskGBlur(self, fTempFilter, bitmap, rect(0,0, bitmap.Width-1, bitmap.height - 1), nil);


  if bitmap.PixelFormat <> pf then
    bitmap.PixelFormat := pf;

end;




procedure TBEMask.GetFromBmpEdges(theBMP: TIEBitmap;
  KernelSize: TIEProc_EX_Filter_Kernelsize; bInvertMAsk: boolean);
var
  arr9: array[0..8] of double;
  arr25: array[0..24] of double;
  X1, Y1: integer;
  tempbmp: TIEBitmap;
  tempIEProc:TImageenproc;
begin
  tempbmp := TIEBitmap.Create;
  tempIEProc := TImageenproc.Create(nil);
  tempIEProc.AttachedIEBitmap := tempbmp;
  try
    tempbmp.Assign(theBmp);
    tempbmp.PixelFormat := ie24rgb;
    x1 := 0;
    y1 := 0;
    case KernelSize of
      ksSmall:
      begin
        arr9[0] := 1;
        arr9[1] := 1;
        arr9[2] := 1;
        arr9[3] := 1;
        arr9[4] := -8;
        arr9[5] := 1;
        arr9[6] := 1;
        arr9[7] := 1;
        arr9[8] := 1;
        tempIEProc.Convolve(arr9,3,3,1);
      end;
      ksMedium:
      begin
        arr25[0] := 1;
        arr25[1] := 1;
        arr25[2] := 1;
        arr25[3] := 1;
        arr25[4] := 1;

        arr25[5] := 1;
        arr25[6] := -1;
        arr25[7] := 0;
        arr25[8] := -1;
        arr25[9] := 1;

        arr25[10] := 1;
        arr25[11] := 0;
        arr25[12] := -12;
        arr25[13] := 0;
        arr25[14] := 1;

        arr25[15] := 1;
        arr25[16] := -1;
        arr25[17] := 0;
        arr25[18] := -1;
        arr25[19] := 1;

        arr25[20] := 1;
        arr25[21] := 1;
        arr25[22] := 1;
        arr25[23] := 1;
        arr25[24] := 1;
        tempIEProc.Convolve(arr25,5,5,12);
      end;
    end;
    fBitsperpixel := 8;
    SetX1(X1);
    SetY1(y1);

    tempbmp.PixelFormat := ie8g;
    MaskGblur(false,tempbmp, 8);

    if bInvertMAsk then
      Self.LoadfromBMP(tempbmp, bInvertMAsk)
    else
      Self.LoadFrom8bitBMP(tempbmp);
    fX2 := fX1 + fWidth - 1;
    fY2 := fY1 + fHeight - 1;

  finally
    tempbmp.Free;
  end;
end;

procedure TBEMask.GetFromBMPTones(bMultiThreaded: boolean; mode:TBEMaskSmartMode; theBMP: TIEBitmap;
                                  radius: integer; bInvertMAsk: boolean; bQuickMask:boolean);
var
  bepf: Tbepixelformat;
  X1, Y1: integer;
  tempbmp: TIEBitmap;

  smoother: single;
  coeffarray: TBeMaskCoeffArray;
  blocksize: integer;
begin
  if not assigned(theBMP) then
    exit;
  if (theBMP.Width <= 0) or (theBMP.Height <= 0) then
    exit;

  bepf := bepfother;
  BE_Getpixelformat(bepf, theBMP);
  if bepf = bepfother then
    exit;


  X1 := 0;
  y1 := 0;


  tempbmp := TIEBitmap.Create;
  try

    if theBMP.PixelFormat = ie8g then
      tempbmp.Assign(theBMP)
    else
    begin
      tempbmp.Assign(theBMP);
      tempbmp.PixelFormat := ie24RGB;

      BE_ConvertBMP24To8(tempbmp);
    end;

      GetMap_Coefs(coeffarray, blocksize, tempbmp, radius, mode, false);


      (*
      if (mode = sm_midtones) then
        smoother := 3.1
      else if (mode = sm_shadows_midtones) then
        smoother := 3.4
      else
        smoother := 3.2;
        *)
      if bQuickMask then
      begin
        if (mode = sm_midtones) then
        smoother := 1
      else if (mode = sm_shadows_midtones) then
        smoother := 1.1
      else
        smoother := 1.1;
      end
      else
      begin
        if (mode = sm_midtones) then
        smoother := 2
      else if (mode = sm_shadows_midtones) then
        smoother := 2.2
      else
        smoother := 2.2;
      end;


      GetMap(bMultiThreaded, coeffarray, tempbmp, blocksize, smoother * blocksize);


    fBitsperpixel := 8;
    SetX1(X1);
    SetY1(y1);

    if bInvertMAsk then
      Self.LoadfromBMP(tempbmp, bInvertMAsk)
    else
      Self.LoadFrom8bitBMP(tempbmp);
    fX2 := fX1 + fWidth - 1;
    fY2 := fY1 + fHeight - 1;

  finally
    tempbmp.free;
    setlength(coeffarray, 0);
  end;
end;




procedure TBEMask.CopyBitmap(Dest, Source: TIEBitmap; amount: integer;
  const alignSourcetoMask: boolean = false; const bInverted: boolean = false);
var
  bepf: Tbepixelformat;
  Readby, Shiftby: integer;
  BGRA: TbeBGRAbytearray;
  BGRAs, BGRAd: TbeBGRAbytearray;
  i, J, k: integer;

  tempx: integer;
  intAmt, baseAmt: integer;
  X1, y1, X2, y2: integer;
  tempxs, ys: integer;
var
  ScanDest: TbeScanlines;
  ScanSrc: TbeScanlines;
begin

  if (not assigned(Source)) or (not assigned(Dest)) then
    exit;

  bepf := bepfother;
  BE_Getpixelformat(bepf, Source);
  if bepf = bepfother then
    exit;

  if Dest.PixelFormat <> Source.PixelFormat then
    Dest.PixelFormat := Source.PixelFormat;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  X1 := max(0, fX1);
  y1 := max(0, fY1);
  X2 := min(Dest.Width - 1, fX2);
  y2 := min(Dest.Height - 1, fY2);

  if alignSourcetoMask then
  begin
    X2 := X1 + min(Source.Width - 1, X2 - X1);
    y2 := y1 + min(Source.Height - 1, y2 - y1);
  end;

  baseAmt := amount;

  ScanDest := TbeScanlines.Create;
  ScanSrc := TbeScanlines.Create;

  try

    ScanDest.CreateScanlines(Dest);
    ScanSrc.CreateScanlines(Source);

      for J := y1 to y2 do
      begin

        if alignSourcetoMask then
          ys := J - y1
        else
          ys := J;
        

        for i := X1 to X2 do
        begin
          tempx := Shiftby * i;

          if alignSourcetoMask then
            tempxs := Shiftby * (i - X1)
          else
            tempxs := tempx;
         
          if bInverted then
            intAmt := 255 - fmaskarray[J - y1, i - X1]
          else
            intAmt := fmaskarray[J - y1, i - X1];


          intAmt := (intAmt * baseAmt) div 255;

          for k := 0 to Readby do
          begin
            BGRAs[k] := ScanSrc.Scanlines[ys, tempxs + k];
            BGRAd[k] := ScanDest.Scanlines[J, tempx + k];
          end;

          BE_BlendPixel_RGB(BGRA[2], BGRA[1], BGRA[0], BGRAs[2], BGRAs[1],
            BGRAs[0], BGRAd[2], BGRAd[1], BGRAd[0], intAmt);

          for k := 0 to Readby do
          begin
            ScanDest.Scanlines[J, tempx + k] := BGRA[k];
          end;

        end;
      end;

  finally
    ScanDest.free;
    ScanSrc.free;

  end;
end;

procedure BE_GetLUTfromFunction(var LUT: TbeByteLUT; LutFunction: TbeLUTObjFunction);
var
  i: integer;
begin
  for i := 0 to high(LUT) do
  begin
    LUT[i] := KeepinRange(round(LutFunction(i)));

  end;
end;

procedure BE_GetLUTfromFunction(var LUT: TbeByteLUT; LutFunction: TbeLUTFunction);
var
  Method: TbeLUTObjFunction;
begin
  if assigned(LutFunction) then
  begin
    TMethod(Method).Code := @BE_DummyFunction;
    TMethod(Method).Data := @LutFunction;
  end
  else
    Method := beLUTObjFunctionNil;
  // Not sure if i got the @ operators correct here. Delphi handles
  // getting a pointer to a procedural type different as you would
  // expect
  BE_GetLUTfromFunction(LUT, Method);
end;

procedure BE_ApplyCurvesbyFunction(bitmap: TIEBitmap; EditRect: Trect;
  RFunction, GFunction, BFunction, RGBFunction: TbeLUTObjFunction);
var
  MethodR, Methodg, Methodb, MethodRGB: TbeLUTObjFunction;
begin
  if assigned(RFunction) then
  begin
    TMethod(MethodR).Code := @BE_DummyFunction;
    TMethod(MethodR).Data := @RFunction;
  end
  else
    MethodR := beLUTObjFunctionNil;
  if assigned(GFunction) then
  begin
    TMethod(Methodg).Code := @BE_DummyFunction;
    TMethod(Methodg).Data := @GFunction;
  end
  else
    Methodg := beLUTObjFunctionNil;
  if assigned(BFunction) then
  begin
    TMethod(Methodb).Code := @BE_DummyFunction;
    TMethod(Methodb).Data := @BFunction;
  end
  else
    Methodb := beLUTObjFunctionNil;
  if assigned(RGBFunction) then
  begin
    TMethod(MethodRGB).Code := @BE_DummyFunction;
    TMethod(MethodRGB).Data := @RGBFunction;
  end
  else
    MethodRGB := beLUTObjFunctionNil;

  BE_ApplyCurvesbyFunction(bitmap, EditRect, MethodR, Methodg, Methodb,
    MethodRGB);

end;

procedure BE_ApplyCurvesbyFunction(bitmap: TIEBitmap; EditRect: Trect;
  RFunction, GFunction, BFunction, RGBFunction: TbeLUTFunction);
var
  LUTs: TbeByteLUTarray;

begin
  if assigned(BFunction) then
    BE_GetLUTfromFunction(LUTs[0], BFunction)
  else
    GenerateNoChangeLUT(LUTs[0]);

  if assigned(GFunction) then
    BE_GetLUTfromFunction(LUTs[1], GFunction)
  else
    GenerateNoChangeLUT(LUTs[1]);

  if assigned(RFunction) then
    BE_GetLUTfromFunction(LUTs[2], RFunction)
  else
    GenerateNoChangeLUT(LUTs[2]);

  if assigned(RGBFunction) then
    BE_GetLUTfromFunction(LUTs[3], RGBFunction)
  else
    GenerateNoChangeLUT(LUTs[3]);

  BE_ApplyLUTs1x1toBGRGray(LUTs, bitmap, EditRect);
end;

procedure BE_ApplyLUTs1x1toBGRGray(BGRGrayLUTs: TbeByteLUTarray; bitmap: TIEBitmap;
  EditRect: Trect);
var
  pp: pbebyteArray;
  i, J, k: integer;
  bepf: Tbepixelformat;
  BGRA: TbeBGRAbytearray;
  BGRA_new: TbeBGRAbytearray;
  Shiftby, Readby: integer;
  tempx: integer;
  X1, y1, X2, y2: integer;
begin
  if not assigned(bitmap) then
    exit;
  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);
  if (bitmap.Width <= 0) or (bitmap.Height <= 0) then
    exit;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  for J := y1 to y2 do
  begin
    pp := bitmap.scanline[J];
    for i := X1 to X2 do
    begin
      tempx := Shiftby * i;

      for k := 0 to Readby do
      begin
        BGRA[k] := pp[tempx + k];
        BGRA_new[k] := (BGRGrayLUTs[k])[BGRA[k]];
        BGRA_new[k] := (BGRGrayLUTs[3])[BGRA_new[k]];
        pp[tempx + k] := BGRA_new[k];
      end;

    end;
  end;

end;

procedure BE_ConvertBMP24To8(bitmap: TIEBitmap);
var

  i, J, k: integer;
  pp, pb: pbebyteArray;
  tempx: integer;
  gray: integer;
  tempbmp: TIEBitmap;
begin
  if not assigned(bitmap) then
    exit;

  tempbmp := TIEBitmap.Create;
  try
    tempbmp.Assign(bitmap);

    bitmap.PixelFormat := ie8g;

    for J := 0 to bitmap.Height - 1 do
    begin
      pp := tempbmp.scanline[J];
      pb := bitmap.scanline[J];
      tempx := 0;
      for i := 0 to bitmap.Width - 1 do
      begin

        gray := 0;
        for k := 0 to 2 do
        begin
          gray := gray + round(pp[tempx + k] * beBGRAgrayconsts_a[k]);
        end;

        pb[i] := gray;
        tempx := tempx + 3;
      end;
    end;

  finally
    tempbmp.free;
  end;

end;








procedure BE_ApplyScaledFilter(theiebitmap, theBuffer, theBufferOriginal
  : TIEBitmap; EditedRect: Trect);
  function InRange(v: integer): byte;
  begin
    if v > 255 then
      Result := 255
    else if v < 0 then
      Result := 0
    else
      Result := v;
  end;

  function GetValue(vBuf, vBufOrig, vPix: integer): byte;
  begin
    (*
      if vBufOrig = 0 then
      result := vBuf
      else
      result := Inrange(trunc(vBuf/ vBufOrig * vPix));
    *)
    Result := InRange(vPix + vBuf - vBufOrig);
  end;

var
  bufferRect: Trect;

  i, J: integer;

  pf: TIEPixelFormat;

  X1, y1, X2, y2: integer;
  i_rgb, ibuffer_rgb, ibuffer, jbuffer: integer;

  Scan_Bmp, Scan_Buffer, Scan_BufferOrig: TbeScanlines;

  rbuffer_H, rbuffer_w: double;
begin
  if not assigned(theiebitmap) then
    exit;

  if not assigned(theBuffer) then
    exit;

  pf := theiebitmap.PixelFormat;
  case pf of
    ie8g, ie24RGB:
      begin; // OK
      end;
  else
    exit; // >>>> EXIT
  end;

  if pf <> theBuffer.PixelFormat then
    exit; // >>>> EXIT

  rbuffer_H := theBuffer.Height / theiebitmap.Height;
  rbuffer_w := theBuffer.Width / theiebitmap.Width;
  bufferRect.left := round(EditedRect.left * rbuffer_w);
  bufferRect.right := round(EditedRect.right * rbuffer_w);
  bufferRect.top := round(EditedRect.top * rbuffer_H);
  bufferRect.bottom := round(EditedRect.bottom * rbuffer_H);

  Scan_Bmp := TbeScanlines.Create;
  Scan_Buffer := TbeScanlines.Create;
  Scan_BufferOrig := TbeScanlines.Create;

  try

    X1 := max(0, EditedRect.left);
    y1 := max(0, EditedRect.top);
    X2 := min(theiebitmap.Width - 1, EditedRect.right);
    y2 := min(theiebitmap.Height - 1, EditedRect.bottom);

    Scan_Bmp.CreateScanlines(theiebitmap, y1, y2);
    Scan_Buffer.CreateScanlines(theBuffer);
    Scan_BufferOrig.CreateScanlines(theBufferOriginal);
    for J := y1 to y2 do
    begin

      jbuffer := trunc(rbuffer_H * J);

      for i := X1 to X2 do
      begin

        case pf of
          ie8g:
            begin
              ibuffer := trunc(rbuffer_w * i);
              Scan_Bmp.Scanlines[J, i] :=
                GetValue(Scan_Buffer.Scanlines[jbuffer, ibuffer],
                Scan_BufferOrig.Scanlines[jbuffer, ibuffer],
                Scan_Bmp.Scanlines[J, i]);
            end;
          ie24RGB:
            begin
              i_rgb := 3 * i;
              ibuffer_rgb := 3 * trunc(rbuffer_w * i);

              Scan_Bmp.Scanlines[J, i_rgb + 2] :=
                GetValue(Scan_Buffer.Scanlines[jbuffer, ibuffer_rgb + 2],
                Scan_BufferOrig.Scanlines[jbuffer, ibuffer_rgb + 2],
                Scan_Bmp.Scanlines[J, i_rgb + 2]);
              Scan_Bmp.Scanlines[J, i_rgb + 1] :=
                GetValue(Scan_Buffer.Scanlines[jbuffer, ibuffer_rgb + 1],
                Scan_BufferOrig.Scanlines[jbuffer, ibuffer_rgb + 1],
                Scan_Bmp.Scanlines[J, i_rgb + 1]);
              Scan_Bmp.Scanlines[J, i_rgb] :=
                GetValue(Scan_Buffer.Scanlines[jbuffer, ibuffer_rgb],
                Scan_BufferOrig.Scanlines[jbuffer, ibuffer_rgb],
                Scan_Bmp.Scanlines[J, i_rgb]);

            end;
        end;

      end;
    end;

  finally
    Scan_Bmp.free;
    Scan_Buffer.free;
    Scan_BufferOrig.free;

  end;

end;

{ TBE }

constructor TBE.Create;
begin
  fInternalProc := TImageenProc.Create(nil);
  fInternalProc.AutoUndo := false;
  fInternalProc.OnProgress := HandleProgress;
  fInternalProc.OnFinishWork := HandleFinishWork;

  fPreviewMasks := TbePreviewMasks.create;

  fMultiThreadEnabled := false;
  fMultiThreadDefOverlapMethod := omAddExtraThreads;
  fMultiThreadNrThreads := 2;
  fMultiIsRunning := false;
  fMultiProc := TIEMultiProc_EX.Create;
end;

destructor TBE.Destroy;
begin
  fPreviewMasks.free;
  fInternalProc.free;
  fMultiProc.free;
  inherited;
end;

procedure TBE.GetMultiThreadInfo( theFilter: TIEProc_EX_Filter; EditedRect: TRect;
                                 var MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
                                 var theOverlap: cardinal;
                                 var bAutoOverlap: boolean);
begin
  MtEnabled := mtDisabled;
  theOverlap := 0;
  bAutoOverlap := false;
  theFilter.GetMultiThreadInfo(EditedRect, MtEnabled, theOverlap, bAutoOverlap);
end;



procedure TBE._GetCutBitmap(bitmap: TIEBitmap; EditRect: Trect; CutBitmap: TIEBitmap);
var
  X1, y1, X2, y2: integer;
  bepf: Tbepixelformat;
begin
  if not assigned(CutBitmap) then
  begin
    raise Exception.Create('Destination cannot be nil');
  end;

  if not assigned(bitmap) then
  begin
    freeandnil(CutBitmap);
    exit;
  end;
  if (bitmap.Width <= 0) or (bitmap.Height <= 0) then
  begin
    freeandnil(CutBitmap);
    exit;
  end;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  CutBitmap.PixelFormat := bitmap.PixelFormat;

  CutBitmap.Width := X2 - X1;
  CutBitmap.Height := y2 - y1;
  bitmap.CopyRectTo(CutBitmap, X1, y1, 0, 0, CutBitmap.Width, CutBitmap.Height);
end;

function TBE._IsRectFull(editRect:TRect; bmpW, bmpH:integer): boolean;
begin
  result := (editRect.Right - editRect.Left + 1 = bmpW) and
             (editRect.Bottom - editRect.Top + 1 = bmpH);
end;


procedure TBE._AdvanceProgress(sender: TObject; theFilterProgress: TIEProgressEvent; per: integer);
begin
  if assigned(theFilterProgress) then
    theFilterProgress(sender, per);
end;

function TBE._FilterDefaultNoChange(theFilter: TIEProc_EX_Filter): boolean;
var
  I: Integer;
  iDefNoChange: integer;
  bFail:boolean;
begin

  iDefNoChange := 0;
  bFail := false;
  for I := 0 to thefilter.Params.Count-1 do
  begin

    if (not thefilter.Params[i].IsFlag) then
    begin
      if (thefilter.Params.IsParamDefNoChange(thefilter.Params[i])) then
      begin
        if thefilter.params[i].ValueIsDefault then
          inc(iDefNoChange)
        else
        begin
          bFail := true;
          break;
        end;
      end;
    end;
  end;

  result := (iDefNoChange > 0) and (not bFail);

{
  if result then
    sleep(0);
}
end;

function TBE._CanProcess(bitmap: TIEBitmap): boolean;
var
  bepf: Tbepixelformat;
begin
  result := false;

   if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
      exit;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;

  result := true;
end;

function TBE._CreateTempIEProc(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent): TImageEnProc;
begin
  result := TImageEnProc.Create(nil);
  result.AutoUndo := false;
  result.AttachedIEBitmap := bitmap;
  result.OnProgress := theProgressEvent;
 // result.OnFinishWork := HandleFinishWork;

end;


procedure TBE._getautohistogramvalues(grayonly: boolean; bitmap: tIEbitmap; editrect: trect; var minBGRA, maxBGRA, avBGRA: TbeBGRAbytearray;
  var mingray, maxgray, avgray: byte);
var
  histogram: tbehistogram;
  k: integer;
begin

  histogram := TbeHistogram.Create;
  try
    histogram.GetHistogramAndDatafromBMP(bitmap, editrect, grayonly, true);

    //minBGRA,maxBGRA,avBGRA:TbeBGRAbytearray;var mingray,maxgray,avgray
    for k := 0 to 3 do
    begin
      minBGRA[k] := histogram.BGRAGrayMinEntry[k];
      maxBGRA[k] := histogram.BGRAGrayMaxEntry[k];
      avBGRA[k] := histogram.BGRAGrayAverage[k];
    end;

    minGray := histogram.BGRAGrayMinEntry[4];
    maxGray := histogram.BGRAGrayMaxEntry[4];
    avGray := histogram.BGRAGrayAverage[4];

  finally
    histogram.free;
  end;
end;

procedure TBE.GetAutoColorCasts_SMH(const GuessAmount: integer; var Cast_Sh, Cast_Mid, Cast_Hi: TbeBGRAbytearray; bitmap: tIEbitmap; editrect: Trect);
var
  i, j, k: integer;
  pp: pbebytearray;

  satBGRA: TbeBGRGrayIntarray;
  BGRA: TbeBGRAbytearray;
  bepf: Tbepixelformat;
  x1, y1, x2, y2: integer;
  tempx: integer;
  shiftby, readby: integer;

  gray: integer;
  currentindex: integer;
  factor, grayf: single;
  counter_Lo, counter_Hi, counter_Mid, counter_tot: TbeBGRGrayIntarray;

  ColorCast_Hi, ColorCast_Lo, ColorCast_Mid: TbeBGRGrayIntarray;
  ColorCast_Hi_orig, ColorCast_Lo_orig, ColorCast_Mid_orig: TbeBGRAbytearray;
  Limit_Hi, Limit_Lo: integer;
  MidRange: integer;
  satlimit, baseSatLimitFact: single;
  minBGRA, maxBGRA, avBGRA: TbeBGRAbytearray;
  mingray, maxgray, avgray: byte;

  stretch_mulBGRA_SH, stretch_mulBGRA_HI: TbeBGRAsingleArray;

  maxCastHi, maxCastSh, MaxCastMid: integer;
  maxCastHi_old, maxCastSh_old, MaxCastMid_old: integer;

  const
    BaseSat: integer = 40;
begin
 
  _Getautohistogramvalues(false, bitmap, editrect, minBGRA, maxBGRA, avBGRA, mingray, maxgray, avgray);

  satBGRA[0] := ((avBGRA[0] - avBGRA[1]) + (avBGRA[0] - avBGRA[2])) div 2;
  satBGRA[1] := ((avBGRA[1] - avBGRA[0]) + (avBGRA[1] - avBGRA[2])) div 2;
  satBGRA[2] := ((avBGRA[2] - avBGRA[0]) + (avBGRA[2] - avBGRA[1])) div 2;

  baseSatLimitFact := min(1, max(satBGRA[2], max(satBGRA[0], satBGRA[1]))/ BaseSat);

  for k := 0 to 2 do
    stretch_mulBGRA_SH[k] := min(1, minBGRA[k] / 255);

  for k := 0 to 2 do
    stretch_mulBGRA_HI[k] := min(1, (255 - maxBGRA[k]) / 255);

  Limit_Hi := 205;
  Limit_Lo := 80;
  MidRange := Limit_Hi - Limit_lo;

  for k := 0 to 2 do
  begin
    ColorCast_Hi_orig[k] := Limit_Hi + (255 - Limit_Hi) div 2;
    ColorCast_Mid_orig[k] := 128;
    ColorCast_lo_orig[k] := Limit_lo div 2;

    ColorCast_Hi[k] := ColorCast_Hi_orig[k];
    ColorCast_Mid[k] := ColorCast_Mid_orig[k];
    ColorCast_lo[k] := ColorCast_lo_orig[k];
  end;

  if not assigned(Bitmap) then
    exit;
  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if (bepf <> bepf24) and (bepf <> bepf32) then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  if (bitmap.width <= 0) or (bitmap.height <= 0) then
    exit;

  BE_GetEditCoords(x1, y1, x2, y2, EditRect, bitmap.width, bitmap.height);

  for k := 0 to 2 do
  begin
    counter_Lo[k] := 0;
    counter_Hi[k] := 0;
    counter_mid[k] := 0;
  end;

  for j := y1 to y2 do
  begin
    pp := bitmap.scanline[j];
    for i := x1 to x2 do
    begin
      tempx := shiftby * i;
      for k := 0 to 2 do
        BGRA[k] := pp[tempx + k];

      gray := (BGRA[0] + BGRA[1] + BGRA[2]) div 3;

      satBGRA[0] := ((BGRA[0] - BGRA[1]) + (BGRA[0] - BGRA[2])) div 2;
      satBGRA[1] := ((BGRA[1] - BGRA[0]) + (BGRA[1] - BGRA[2])) div 2;
      satBGRA[2] := ((BGRA[2] - BGRA[0]) + (BGRA[2] - BGRA[1])) div 2;


      if (satBGRA[0] >= satBGRA[1]) and (satBGRA[0] >= satBGRA[2]) then
        currentindex := 0
      else if (satBGRA[1] >= satBGRA[0]) and (satBGRA[1] >= satBGRA[2]) then
        currentindex := 1
      else
        currentindex := 2;

      if satBGRA[currentindex] > 0 then
      begin

        if gray > Limit_Hi then
        begin
          grayf := (gray - Limit_Hi) / (255 - Limit_Hi);
          satlimit :=  baseSat * baseSatLimitFact * (1 + grayf);
        end
        else if gray < Limit_Lo then
        begin
          grayf := (Limit_Lo - gray) / Limit_Lo;
          satlimit := 0.2 * baseSat * baseSatLimitFact * (1 + grayf);
        end
        else
        begin
          grayf := 2 * abs(gray - 128) / 128;
          satlimit := 0.12 * baseSat * baseSatLimitFact * (1 + grayf);
        end;

        satLimit := satlimit * GuessAmount / 100;
        if (satBGRA[currentindex] < satlimit) then
        begin
          factor := (1 - satBGRA[currentindex] / satlimit);

          if gray > Limit_Hi then
          begin
            inc(counter_Hi[currentindex]);
            for k := 0 to 2 do
              ColorCast_Hi[k] := round((1 - factor) * ColorCast_Hi[k] + factor * BGRA[k]);
          end
          else if gray < Limit_Lo then
          begin
            inc(counter_Lo[currentindex]);
            for k := 0 to 2 do
              ColorCast_Lo[k] := round((1 - factor) * ColorCast_Lo[k] + factor * BGRA[k]);
          end
          else
          begin
            inc(counter_Mid[currentindex]);
            for k := 0 to 2 do
              ColorCast_Mid[k] := round((1 - factor) * ColorCast_Mid[k] + factor * BGRA[k]);
          end;

        end;
      end;
    end;
  end;

  for k := 0 to 2 do
    counter_tot[k] := counter_Lo[k] + counter_hi[k] + counter_Mid[k] + 1;

  maxCastSh_old := 0;
  MaxCastMid_old := 0;
  maxCastHi_old := 0;

  for k := 0 to 2 do
  begin
    maxCastSh_old := max(maxCastSh_old, Colorcast_lo[k]);
    MaxCastMid_old := max(maxCastMid_old, Colorcast_Mid[k]);
    maxCastHi_old := max(maxCastHi_old, Colorcast_Hi[k]);
  end;

  for k := 0 to 2 do
  begin
    Colorcast_Lo[k] := round(ColorCast_Lo[k] * (1 + stretch_mulBGRA_Sh[k] / 5 * (1 - counter_lo[k] / counter_tot[k])));
    //  Colorcast_mid[k] := round(ColorCast_mid[k] * counter_mid[k]/counter_tot[k]);
    Colorcast_Hi[k] := round(ColorCast_Hi[k] * (1 - stretch_mulBGRA_HI[k] / 5 * (1 - counter_hi[k] / counter_tot[k])));
  end;

  maxCastsh := 0;
  MaxCastMid := 0;
  maxCastHi := 0;

  for k := 0 to 2 do
  begin
    maxCastSh := max(maxCastSh, Colorcast_lo[k]);
    MaxCastMid := max(maxCastMid, Colorcast_Mid[k]);
    maxCastHi := max(maxCastHi, Colorcast_Hi[k]);
  end;

  maxCastSh := maxCastSh + 1;
  MaxCastMid := MaxCastMid + 1;
  maxCastHi := maxCastHi + 1;

  for k := 0 to 2 do
  begin
    Cast_Sh[k] := round(maxCastSh_old / maxCastSh * Colorcast_lo[k]);
    Cast_Mid[k] := Colorcast_mid[k];
    Cast_Hi[k] := round(maxCastHi_old / maxcasthi * Colorcast_Hi[k]);
  end;

end;


procedure TBE.ExecFilter(sender: TObject; theFilter: TIEProc_EX_Filter; theiebitmap: TIEbitmap; EditedRect: TRect);
begin
  ExecFilter(sender, theFilter, theiebitmap, EditedRect, HandleProgress);
end;

procedure TBE.ExecFilter(sender: TObject; theFilter: TIEProc_EX_Filter; theiebitmap: TIEbitmap;
                         EditedRect: TRect; theFilterProgress: TIEProgressEvent);

function GetGuid(param: TIEProc_EX_Filter_Param): TGUID;
begin
  result := Param.GetValue_GUID;
end;

function GetBool(param: TIEProc_EX_Filter_Param): boolean;
begin
  result := Param.GetValue_bool;
end;

function GetInt(param: TIEProc_EX_Filter_Param): integer;
begin
  result := Param.GetValue_int;
end;

function GetDbl(param: TIEProc_EX_Filter_Param): double;
begin
  result := Param.GetValue_double;
end;

var
  RGBLumAmount_Sh, RGBLumAmount_Mid, RGBLumAmount_Hi, RGBLumAmount_All: TbeBGRGrayintarray;

var
 aProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
 bRunningMultiThread: boolean;

 MtEnabled: TIEProc_EX_Filter_MultiThreadEnabled;
 MtOverlap: cardinal;
 MtAutoOverlap: boolean;
 MTOvMethod: TIEMultiProc_EX_OverlapMethod;
 MtNrThreads: cardinal;
 previewID: TGUID;
begin
   if _FilterDefaultNoChange(theFilter) then   //default values for no change: filter will not affect image
   begin
     _AdvanceProgress(sender, theFilterProgress, 100);
     EXIT;  //so exit;
   end;

   bRunningMultiThread := sender is TIEMultiProc_EX_Thread;

   if (not bRunningMultiThread) and
       fMultiThreadEnabled then
   begin
     GetMultiThreadInfo(theFilter, EditedRect, MtEnabled, MtOverlap, MtAutoOverlap);

     MTOvMethod := fMultiThreadDefOverlapMethod;
     MtNrThreads := fMultiThreadNrThreads;

     if assigned(fOnFilter_CustomMultiThreadInfo) then
       fOnFilter_CustomMultiThreadInfo(theFilter, MtEnabled, MtNrThreads, MtOverlap, MtAutoOverlap, MtOvMethod);

     MtNrThreads := max(1, MtNrThreads);

     previewId := theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).GetValue_GUID;
     if (MtEnabled = mtAlwaysEnabled) or
         ((MtEnabled = mtEnabledExceptPreview) and compareguid(PreviewId, IEPROC_EX_GUID_NULL))or
         ((MtEnabled = mtEnabledInPreviewOnly) and (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)))
         then
     begin
       aProcFilterMethod := ExecFilter;
       fMultiProc.OnInitialized := Handle_MProcInit;
       fMultiProc.OnFinished := Handle_MProcFinished;
       fMultiProc.ProcessMessagesWhileInProgress := false;
       fMultiProc.OnProgress := HandleProgress;

       fMultiProc.Run(MtNrThreads, theiebitmap, EditedRect, aProcFilterMethod, theFilter, MtOverlap, MTOvMethod, MtAutoOverlap);

       EXIT;//>>>EXIT
     end;
   end;



   case theFilter.ID of

     IEPROC_EX_SMARTFLASH_ID:
     begin
       _SmartFlash(theiebitmap, editedrect,
                   theFilter.Params.Param_Byname(IEPROC_EX_SMARTFLASH_AMOUNT).GetValue_int,
                   theFilter.Params.Param_Byname(IEPROC_EX_SMARTFLASH_RADIUS).GetValue_int,
                   GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),
                   //theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).GetValue_GUID,
                   theFilterProgress);


     end;
     IEPROC_EX_REDUCEHIGHLIGHTS_ID:
     begin
       _ReduceHighlights(theiebitmap, editedrect,
                   theFilter.Params.Param_Byname(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT).GetValue_int,
                   theFilter.Params.Param_Byname(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS).GetValue_int,
                   GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),
//                   theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).GetValue_GUID,
                   theFilterProgress);

     end;
     IEPROC_EX_FILLBACKLIGHT_ID:
     begin
       _FillBackLight(theiebitmap, editedrect,
                   theFilter.Params.Param_Byname(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT).GetValue_int,
                   theFilter.Params.Param_Byname(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT).GetValue_int,
                   theFilter.Params.Param_Byname(IEPROC_EX_FILLBACKLIGHT_RADIUS).GetValue_int,
                   GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),
//                   theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).GetValue_GUID,
                   theFilterProgress);

     end;
     IEPROC_EX_SMARTCONTRAST_ID:
     begin
       _SmartContrast(theiebitmap, editedrect,
                   theFilter.Params.Param_Byname(IEPROC_EX_SMARTCONTRAST_AMOUNT).GetValue_int,
                   theFilter.Params.Param_Byname(IEPROC_EX_SMARTCONTRAST_RADIUS).GetValue_int,
                   GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),
                  // theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).GetValue_GUID,
                   theFilterProgress);

     end;
     IEPROC_EX_RGBBALANCE_ID:
     begin
       RGBLumAmount_Sh[3] :=  0;
       RGBLumAmount_Sh[2] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED).GetValue_int;
       RGBLumAmount_Sh[1] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN).GetValue_int;
       RGBLumAmount_Sh[0] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE).GetValue_int;

       RGBLumAmount_Mid[3] :=  0;
       RGBLumAmount_Mid[2] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Mid_RED).GetValue_int;
       RGBLumAmount_Mid[1] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Mid_GREEN).GetValue_int;
       RGBLumAmount_Mid[0] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Mid_BLUE).GetValue_int;

       RGBLumAmount_Hi[3] :=  0;
       RGBLumAmount_Hi[2] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Hi_RED).GetValue_int;
       RGBLumAmount_Hi[1] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Hi_GREEN).GetValue_int;
       RGBLumAmount_Hi[0] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_Hi_BLUE).GetValue_int;

       RGBLumAmount_All[3] :=  0;
       RGBLumAmount_All[2] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_All_RED).GetValue_int;
       RGBLumAmount_All[1] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_All_GREEN).GetValue_int;
       RGBLumAmount_All[0] :=  theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_AMOUNT_All_BLUE).GetValue_int;

       _RGBColorBalance(theiebitmap, editedrect,
                        theFilter.Params.Param_Byname(IEPROC_EX_RGBBALANCE_UNIFORM).GetValue_bool,
                        RGBLumAmount_Sh, RGBLumAmount_Mid, RGBLumAmount_Hi, RGBLumAmount_All,
                        theFilterProgress);

     end;
     IEPROC_EX_AUTOCOLOR_ID:
     begin
       _AutoColor(theiebitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_AUTOCOLOR_STRENGTH).GetValue_int,
                  theFilterProgress);
     end;
     IEPROC_EX_COLORFILTER_ID:
     begin
       _ColorFilter(theiebitmap, editedrect,
                    theFilter.Params.Param_Byname(IEPROC_EX_COLORFILTER_COLOR).GetValue_int,
                    255 - theFilter.Params.Param_Byname(IEPROC_EX_COLORFILTER_AMOUNT).GetValue_byte,
                    TIEProc_EX_Filter_Blendmode(theFilter.Params.Param_Byname(IEPROC_EX_COLORFILTER_BLENDMODE).GetValue_byte),
                    theFilterProgress);
     end;
     IEPROC_EX_SMOOTHFILTER_ID:
     begin
       _Smooth(theiebitmap, editedrect,
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_SMOOTHFILTER_AMOUNT)),
                    GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),theFilterProgress);
     end;
     IEPROC_EX_BILATERALFILTER_ID:
     begin
       if theiebitmap.PixelFormat = ie24rgb then
       begin
       _ApplyBilateral24(theiebitmap, editedrect,
                         theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_RADIUS).GetValue_int,
                         theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_SIGMA).GetValue_int,
                         Getint(theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE)),
                         theFilterProgress
                         );
       end
       else if theiebitmap.PixelFormat = ie8g then
       begin
       _ApplyBilateral8(theiebitmap, editedrect,
                         theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_RADIUS).GetValue_int,
                         theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_SIGMA).GetValue_int,
                         Getint(theFilter.Params.Param_Byname(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE)),
                         theFilterProgress
                         );
       end
     end;
     IEPROC_EX_LIGHTFX_ELLIPSE_ID:
     begin
     //color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer
       _LightEffect_Ellipse(theiebitmap, editedrect,
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_COLOR)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX)),
                    GetInt(theFilter.Params.Param_Byname(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY)),
                    GetGuid(theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),theFilterProgress);
     end;
     IEPROC_EX_LIGHTFX_BEAM_ID:
     begin
       with theFilter.Params do
       begin
     //color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer
          _LightEffect_Beam(theiebitmap, editedrect,
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_COLOR)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_ANGLE)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_CENTERX)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_BEAM_CENTERY)),
                    GetGuid(Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),theFilterProgress);
       end;
     end;
     IEPROC_EX_LIGHTFX_DOUBLEBEAM_ID:
     begin
       with theFilter.Params do
       begin
          _LightEffect_DoubleBeam(theiebitmap, editedrect,
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX)),
                    GetInt(Param_Byname(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY)),
                    GetGuid(Param_Byname(IEPROC_EX_FLAGS_PREVIEWID)),theFilterProgress);
       end;
     end;
     IEPROC_EX_IE_UNSHARPMASK_ID:
     begin

       _IE_UnsharpMask(theIeBitmap, editedrect,
                   theFilter.Params.Param_Byname(IEPROC_EX_IE_UNSHARPMASK_RADIUS).GetValue_double,
                   theFilter.Params.Param_Byname(IEPROC_EX_IE_UNSHARPMASK_AMOUNT).GetValue_double,
                   GetDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD)),
                   //theFilter.Params.Param_Byname(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD).GetValue_double,
                   theFilterProgress);
     end;
     IEPROC_EX_IE_BLUR_ID:
     begin

       _IE_Blur(theIeBitmap, editedrect,
                GetDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_BLUR_RADIUS)),
                //theFilter.Params.Param_Byname(IEPROC_EX_IE_BLUR_RADIUS).GetValue_double,
                theFilterProgress);
     end;
     IEPROC_EX_IE_HSLVAR_ID:
     begin

       _IE_HSLVar(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_HSLVAR_HUE).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_HSLVAR_SAT).GetValue_int,
                  GetInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_HSLVAR_LUM)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_HSLVAR_LUM).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_HSVVAR_ID:
     begin
       
       _IE_HSVVar(theIeBitmap, editedrect,
                  Getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_HSVVAR_HUE)),
                  Getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_HSVVAR_SAT)),
                  Getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_HSVVAR_VALUE)),
                   theFilterProgress
                  );
     end;
     IEPROC_EX_IE_NEGATIVE_ID:
     begin

       _IE_Negative(theIeBitmap, editedrect, theFilterProgress);
     end;
     IEPROC_EX_IE_INTENSITYRGBALL_ID:
     begin

       _IE_IntensityRGBAll(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN).GetValue_int,
                  GetInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_INTENSITY_ID:
     begin

       _IE_Intensity(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_LOLIMIT).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_HILIMIT).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_CHANGE).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB).GetValue_bool,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_DORED).GetValue_bool,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_DOGREEN).GetValue_bool,
                  GetBool(theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_DOBLUE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_INTENSITY_DOBLUE).GetValue_bool,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_CONTRAST_ID:
     begin

       _IE_Contrast(theIeBitmap, editedrect,
                  getdbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST_AMOUNT)),
                 // theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST_AMOUNT).GetValue_double,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_CONTRAST2_ID:
     begin

       _IE_Contrast2(theIeBitmap, editedrect,
                  getdbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST2_AMOUNT)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST2_AMOUNT).GetValue_double,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_CONTRAST3_ID:
     begin
       _IE_Contrast3(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_CHANGE).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_MIDPOINT).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_DORED).GetValue_bool,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_DOGREEN).GetValue_bool,
                  getBool(theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_DOBLUE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_CONTRAST3_DOBLUE).GetValue_bool,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_GAMMACORRECT_ID:
     begin
       _IE_GammaCorrect(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_GAMMACORRECT_GAMMA).GetValue_double,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_GAMMACORRECT_DORED).GetValue_bool,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_GAMMACORRECT_DOGREEN).GetValue_bool,
                  getBool(theFilter.Params.Param_Byname(IEPROC_EX_IE_GAMMACORRECT_DOBLUE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_GAMMACORRECT_DOBLUE).GetValue_bool,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_AUTOSHARP_ID:
     begin
       _IE_AutoSharp(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOSHARP_INTENSITY).GetValue_int,
                  getDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOSHARP_RATE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOSHARP_RATE).GetValue_double,
                  theFilterProgress
                  );
     end;
      IEPROC_EX_IE_COLORIZE_ID:
     begin
       _IE_COLORIZE(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_COLORIZE_HUE).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_COLORIZE_SAT).GetValue_int,
                  getDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_COLORIZE_LUM)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_COLORIZE_LUM).GetValue_double,
                  theFilterProgress
                  );
     end;
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_ID:
     begin
       _IE_Brightness_Contrast_Saturation(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS).GetValue_int,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST).GetValue_int,
                  getInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_ADJUST_TINT_ID:
     begin
       _IE_AdjustTint(theIeBitmap, editedrect,
                  getInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_TINT_AMOUNT)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_TINT_AMOUNT).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_ADJUST_SATURATION_ID:
     begin
       _IE_AdjustSaturation(theIeBitmap, editedrect,
                  getInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_ADJUST_TEMPERATURE_ID:
     begin
       _IE_AdjustTemperature(theIeBitmap, editedrect,
                  getInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT).GetValue_int,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_ID:
     begin
       _IE_AdjustLumSatHisto(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT).GetValue_double,
                  getDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM).GetValue_double,
                  theFilterProgress
                  );
     end;
     IEPROC_EX_IE_WHITEBALANCE_COEF_ID:
     begin
       _IE_WhiteBalance_coef(theIeBitmap, editedrect,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_COEF_RED).GetValue_double,
                  theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN).GetValue_double,
                  getDbl(theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE)),
                  //theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE).GetValue_double,
                  theFilterProgress);
     end;
     IEPROC_EX_IE_WHITEBALANCE_GRAYWORLD_ID:
     begin
       _IE_WhiteBalance_GrayWorld(theIeBitmap, editedrect, theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).GetValue_bool, theFilterProgress);
     end;
     IEPROC_EX_IE_WHITEBALANCE_AUTOWHITE_ID:
     begin
       _IE_WhiteBalance_AutoWhite(theIeBitmap, editedrect, theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).GetValue_bool, theFilterProgress);
     end;
     IEPROC_EX_IE_AUTOIMAGEENHANCE1_ID:
     begin
       _IE_AutoImageEnhance1(theIeBitmap, editedrect, theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).GetValue_bool,
                             theFilterProgress,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR).GetValue_int);
     end;
     IEPROC_EX_IE_AUTOIMAGEENHANCE2_ID:
     begin
       _IE_AutoImageEnhance2(theIeBitmap, editedrect, theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).GetValue_bool,
                             theFilterProgress,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE).GetValue_double,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH).GetValue_int,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE).GetValue_bool);
     end;
     IEPROC_EX_IE_AUTOIMAGEENHANCE3_ID:
     begin
       _IE_AutoImageEnhance3(theIeBitmap, editedrect, theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).GetValue_bool,
                             theFilterProgress,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA).GetValue_double,
                             theFilter.Params.Param_Byname(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION).GetValue_int);
     end;
     IEPROC_EX_IE_WHITEBALANCE_WHITEAT_ID:
     begin
       _IE_WhiteBalance_WhiteAt(theIeBitmap, editedrect,
                                theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX).GetValue_int,
                                getInt(theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY)),
                               // theFilter.Params.Param_Byname(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY).GetValue_int,
                                theFilterProgress
                                );
     end;
     IEPROC_EX_IE_MEDIANSHARPEN_ID:
     begin
       _IE_MedianSharpen(theIeBitmap, editedrect,
                          getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW)),
                          getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER))
                          ,theFilterProgress);
     end;
     IEPROC_EX_IE_MEDIAN_ID:
     begin
       _IE_Median(theIeBitmap, editedrect,
                          getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_MEDIAN_WINDOW)),
                          getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_MEDIAN_THRESHOLD))
                          ,theFilterProgress);
     end;
     IEPROC_EX_IE_SHARPEN_ID:
     begin
       _IE_Sharpen(theIeBitmap, editedrect,
                    getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_SHARPEN_AMOUNT)),
                    getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_SHARPEN_WINDOW))
                          ,theFilterProgress);
     end;
     IEPROC_EX_IE_FINDEDGES_ID:
     begin
       _IE_FindEdges(theIeBitmap, editedrect,
                    TIEProc_EX_Filter_Kernelsize(getint(theFilter.Params.Param_Byname(IEPROC_EX_IE_FINDEDGES_KERNELSIZE))),
                    theFilterProgress);
     end
     else
     begin
       if (theFilter is TIEProc_EX_Filter_BaseCustom) then
       begin
         TIEProc_EX_Filter_BaseCustom(theFilter).Process(theiebitmap, editedrect,  theFilterProgress);
       end;
       //else filter not recognized
     end;
   end;
end;

procedure TBE.HandleProgress(Sender: TObject; per: integer);
begin
 // fMTCs.enter;
  try
    if assigned(fOnProgress) then
    fOnProgress(Self, per);
  finally
   // fMTCs.leave;
  end;

end;



procedure TBE.Handle_MProcFinished(sender: TObject);
begin
  fMultiIsRunning := false;
end;

procedure TBE.Handle_MProcInit(sender: TObject);
begin
  fMultiIsRunning := true;
end;

procedure TBE.SetMultiThreadNrThreads(const Value: cardinal);
begin
  fMultiThreadNrThreads := Max(1, Value);
end;

procedure TBE.HandleFinishWork(Sender: TObject);
begin
  if assigned(fOnFinishWork) then
    fOnFinishWork(Self);
end;


function TBE._GetAvgGray(bitmap: TIEBitmap): byte;
var
  scan: TbeScanlines;
  i,j, k, si :integer;
  sum: int64;
  bepf: Tbepixelformat;
  Shiftby, Readby: integer;
begin
  result := 127;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;
  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  sum := 0;
  scan := TbeScanlines.Create;
  try
    scan.CreateScanlines(bitmap);
    for j := 0 to bitmap.Height - 1 do
    begin
      for i := 0 to bitmap.Width - 1 do
      begin
        si := shiftby * i;
        for k := 0 to readby do
          sum := sum + scan.Scanlines[j, si + k];
      end;
    end;

    result := sum div ((readby + 1) * bitmap.Width * bitmap.Height);

  finally
    scan.free;
  end;
end;

procedure TBE._AutoColor(bitmap: tIEBitmap; EditRect: Trect; strength: integer;
  theProgressEvent: TIEProgressEvent);
var
  k: integer;
  Cast_Hi, Cast_Mid, Cast_Sh: TBeBGRAbytearray;
  gray_sh, gray_Mid, gray_Hi: integer;
  colbalBGRA_All, colbalBGRA_Sh, colbalBGRA_Mid, colbalBGRA_Hi: TbeBGRGrayIntarray;
begin

  GetAutoColorCasts_SMH(100, Cast_Sh, Cast_Mid, Cast_Hi, bitmap, editrect);

  gray_Sh := (Cast_Sh[2] + Cast_Sh[1] + Cast_Sh[0]) div 3;
  gray_Mid := (Cast_Mid[2] + Cast_Mid[1] + Cast_Mid[0]) div 3;
  gray_Hi := (Cast_Hi[2] + Cast_Hi[1] + Cast_Hi[0]) div 3;

  for k := 0 to 2 do
  begin
    colbalBGRA_Sh[k] := strength * (gray_Sh - Cast_Sh[k]);
    colbalBGRA_Hi[k] := strength * (gray_Hi - Cast_Hi[k]);
    colbalBGRA_Mid[k] := gray_Mid - Cast_Mid[k];
    colbalBGRA_All[k] := 0;
  end;

  _RGBColorBalance(bitmap, editrect, false, colbalBGRA_Sh, colbalBGRA_Mid, colbalBGRA_Hi, colbalBGRA_All, theProgressEvent);
end;

procedure TBE._RGBColorBalance(bitmap: tIEbitmap; EditRect: Trect;
                               bUniform: boolean;
                               BGRGrayamountSH, BGRGrayamountMid, BGRGrayamountHi, BGRGrayamountAll : TbeBGRGrayIntarray;
                               theProgressEvent: TIEProgressEvent);
procedure GetAvgMax(BGRA: TbeBGRAbytearray; var avgV, maxV: byte);
var
  k: shortint;
begin
  maxV := BGRA[0];
  avgV := BGRA[0];
  for k := 1 to 2 do
  begin
    avgV := (avgV + BGRA[k]) div 2;
    if BGRA[k] > maxV then
      maxV := BGRA[k];
  end;
end;
var
  pp: pbebytearray;
  i, j, k: integer;
  bepf: Tbepixelformat;

  shiftby, readby: integer;
  tempx: integer;
  LUT: TbeByteLUTarray;


  x1, y1, x2, y2: integer;
  exittest: boolean;
  skiptest: array[0..3] of boolean;
  memBGRA: TbeBGRAbytearray;
  deltaBGRA: TbeBGRGrayIntarray;
  intBGRA: TbeBGRAIntarray;
begin
  if not assigned(Bitmap) then
    exit;

  exittest := true;
  for k := 0 to 2 do
  begin
    skiptest[k] := (BGRGrayamountSH[k] = 0) and (BGRGrayamountMid[k] = 0)
                    and (BGRGrayamountHi[k] = 0) and (BGRGrayamountAll[k] = 0);
    if not skiptest[k] then
      exittest := false;
  end;

  if exittest then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  for k := 0 to 2 do
  begin

    if not skiptest[k] then
      getbrightnesslut(lut[k], BGRGrayamountSH[k], BGRGrayamountMid[k], BGRGrayamountHi[k], BGRGrayamountAll[k]);

  end;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if (bepf <> bepf24) and (bepf <> bepf32) then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  if (bitmap.width <= 0) or (bitmap.height <= 0) then
    exit;

  BE_GetEditCoords(x1, y1, x2, y2, EditRect, bitmap.width, bitmap.height);


  for j := y1 to y2 do
  begin
    if ((j - y1) mod 100 = 0) and assigned(fOnProgress) then
      _AdvanceProgress(Self, theProgressEvent, trunc((j-y1) * 100 / max(y2 - y1, 1)));
    pp := bitmap.scanline[j];
    for i := x1 to x2 do
    begin
      tempx := shiftby * i;
      for k := 0 to 2 do
         memBGRA[k] := pp[tempx + k];

        for k := 0 to 2 do
        begin
          if skiptest[k] then
          begin
            intBGRA[k] :=  memBGRA[k];
            deltaBGRA[k] := 0;
          end
          else
          begin
            intBGRA[k] := (LUT[k])[memBGRA[k]];
            if bUniform then
            begin
              intBGRA[k] := (memBGRA[k] + intBGRA[k]) div 2;
              deltaBGRA[k] := (memBGRA[k] - intBGRA[k]) div 4;
            end;
          end;


        end;
      if bUniform then
      begin
        intBGRA[1] := intBGRA[1] + deltaBGRA[0];
        intBGRA[2] := intBGRA[2] + deltaBGRA[0];

        intBGRA[0] := intBGRA[0] + deltaBGRA[1];
        intBGRA[2] := intBGRA[2] + deltaBGRA[1];

        intBGRA[0] := intBGRA[0] + deltaBGRA[2];
        intBGRA[1] := intBGRA[1] + deltaBGRA[2];
      end;

      for k := 0 to 2 do
        pp[tempx + k] := keepinrange(intBGRA[k]);

    end;
  end;

_AdvanceProgress(Self, theProgressEvent, 100);


end;


function TBE._Blendchannel(backchan, forechan, inttras: byte; blendmode: TIEProc_EX_Filter_Blendmode): byte;
var
  temp: byte;
  tempSqr: integer;
  blended: byte;
begin
   case blendmode of
    blmnormal:
      blended := forechan;
    blmoverlay:
      begin
        tempSqr := backchan * backchan;
        blended := (2 * forechan * backchan - 2 * forechan * tempSqr div 255 + tempSqr) div 255;
      end;
    blmmultiply:
      blended := backchan * forechan div 255;
    blmscreen:
      blended := 255 - ((255 - backchan) * (255 - forechan) div 255);
    blmhardlight:
      begin
        temp := backchan * forechan div 255;
        blended := (forechan * (forechan + backchan - temp) + temp * (255 - forechan)) div 255;
      end
    else
      blended := forechan;

  end;

  if inttras > 0 then
    result := (backchan * inttras + blended * (255 - inttras)) div 255
  else
    result := blended;

end;

function TBE._Blendpixel(backBGRA, foreBGRA: TbeBGRAbytearray; inttras: byte;
                         blendmode: TIEProc_EX_Filter_Blendmode;
                         readby: integer): TbeBGRAbytearray;
var
k:integer;
begin
  for k := 0 to readby do
  begin
    result[k] := _blendchannel(backBGRA[k], foreBGRA[k], inttras, blendmode);
  end;
end;

procedure TBE._ColorFilter(bitmap: tIEBitmap; EditRect: Trect;
                           color:TColor; inttras:byte; blendmode: TIEProc_EX_Filter_Blendmode;
                               theProgressEvent: TIEProgressEvent);
var
  pp: pbebytearray;
  i, j, k: integer;
  bepf: Tbepixelformat;

  shiftby, readby: integer;
  tempx: integer;
  x1, y1, x2, y2: integer;

  foreBGRA: TbeBGRAbytearray;
  h,l,s, ch,cl,cs:double;
  rgb_back,rgb_fore:TRGB;
begin
   bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if (bepf <> bepf24) and (bepf <> bepf32) then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  if (bitmap.width <= 0) or (bitmap.height <= 0) then
    exit;

  BE_GetEditCoords(x1, y1, x2, y2, EditRect, bitmap.width, bitmap.height);

  foreBGRA[0] := getBValue(color);
  foreBGRA[1] := getGValue(color);
  foreBGRA[2] := getRValue(color);
  RGB2HSL(TColor2TRGB(color),ch,cs,cl);
  for j := y1 to y2 do
  begin
    if ((j - y1) mod 100 = 0) and assigned(fOnProgress) then
      _AdvanceProgress(Self, theProgressEvent, trunc((j - y1) * 100 / max(y2 - y1, 1)));
    pp := bitmap.scanline[j];
    tempx := shiftby * x1;
    for i := x1 to x2 do
    begin
       case blendmode of

         blmhsl:
         begin
           rgb_back := CreateRGB(pp[tempx+2], pp[tempx+1], pp[tempx]);
           RGB2HSL(rgb_back,h,s,l);
           HSL2RGB(rgb_fore,ch,cs,l);
           pp[tempx] := _Blendchannel(rgb_back.b, rgb_fore.b, inttras,blmnormal);
           pp[tempx+1] := _Blendchannel(rgb_back.g, rgb_fore.g, inttras,blmnormal);
           pp[tempx+2] := _Blendchannel(rgb_back.r, rgb_fore.r, inttras,blmnormal);
         end;
         else
         begin
           for k := 0 to 2 do
             pp[tempx + k] := _blendchannel(pp[tempx + k], foreBGRA[k], inttras, blendmode);

         end;
       end;

      
       tempx := tempx + shiftby;
    end;
  end;

_AdvanceProgress(Self, theProgressEvent, 100);

end;


procedure TBE._ApplyBilateral24(bitmap:TIEBitmap; Radius, SigmaI, SigmaD:Integer; theProgressEvent: TIEProgressEvent);
type
TBigArray=array[0..2000000000] of byte;
pBigArray=^TBigArray;
var
ImWidth, ImRAWWidth, ImHeight:Integer;
pSource, pTarget:pBigArray;
X, Y, TempX, TempY:Integer;
Hl:Integer;
ISource1, ISource2, ISource3, ISourceN1, ISourceN2, ISourceN3:Integer;
IFiltered1, IFiltered2, IFiltered3:Double;
Dist:Double;
Gi1, Gi2, Gi3:Double;
Gs:Double;
W1, W2, W3:Double;
Wp1, Wp2, Wp3:Double;
I, J:Integer;
NeighbourX, NeighbourY:Integer;
Diameter:integer;
FilteredBmp:TIEBitmap;
sqrSigmaI, sqrSigmaD, _4SqrSigmaI, _4SqrSigmaD: integer;
_2piSqrSigmaI,_2piSqrSigmaD :double;
begin
  if Radius = 0 then
    Radius := 1;
  Diameter := 2 * Radius;
  Hl:=Radius;
  sqrSigmaI := SigmaI * SigmaI;
  sqrSigmaD := SigmaD * SigmaD;
  _2piSqrSigmaI := 2 * pi * sqrSigmaI;
  _4SqrSigmaI := 4 * sqrSigmaI;
  _2piSqrSigmaD := 2 * pi *sqrSigmaD;
  _4SqrSigmaD := 4 * sqrSigmaD;

  if not Assigned(bitmap) then
  Exit;

  FilteredBmp := TIEBitmap.Create;
  try

  ImWidth:=bitmap.Width;
  ImHeight:=bitmap.Height;
  if (ImWidth=0) or (ImHeight=0) then
  Exit;

  if bitmap.PixelFormat <> ie24RGB then
  EXIT;

  FilteredBmp.Width:=ImWidth;
  FilteredBmp.Height:=ImHeight;
  FilteredBmp.PixelFormat:=ie24RGB;


  pSource:=bitmap.ScanLine[ImHeight-1];
  pTarget:=FilteredBmp.ScanLine[ImHeight-1];

//ImRAWWidth:=Integer(SourceBmp.ScanLine[ImHeight-2])-Integer(SourceBmp.ScanLine[ImHeight-1]);
  ImRAWWidth:=NativeUInt(bitmap.ScanLine[ImHeight-2])-NativeUInt(bitmap.ScanLine[ImHeight-1]);

  for Y:=0 to ImHeight-1 do
  begin
  TempY:=Y*ImRAWWidth;
    if (y mod 100 = 0) and assigned(fOnProgress) then
      _AdvanceProgress(Self, theProgressEvent, trunc(y * 100 / ImHeight));
    for X:=0 to ImWidth-1 do
    begin
    TempX:=X*3;

    ISource1:=pSource^[TempY+TempX];
    ISource2:=pSource^[TempY+TempX+1];
    ISource3:=pSource^[TempY+TempX+2];
    IFiltered1:=0;
    IFiltered2:=0;
    IFiltered3:=0;
    Wp1:=0;
    Wp2:=0;
    Wp3:=0;

    I:=0;
      while I<Diameter do
      begin
      J:=0;
        NeighbourX:=min(imWidth-1, max(0, X-Hl+I));
        while J<Diameter do
        begin
      //  NeighbourX:=min(imWidth-1, max(0, X-Hl+I));
        NeighbourY:=min(imHeight-1, max(0, Y-Hl+J));

        ISourceN1:=pSource^[NeighbourY*ImRAWWidth+NeighbourX*3];
        ISourceN2:=pSource^[NeighbourY*ImRAWWidth+NeighbourX*3+1];
        ISourceN3:=pSource^[NeighbourY*ImRAWWidth+NeighbourX*3+2];

    //define gaussian(x, sigma):
    //formula:  1 / (2 * Pi * (sigma ** 2))) * e**(- (x ** 2) / (2 * sigma ** 2)

    //    Gi:=gaussian(ISourceN-ISource, SigmaI);
        Gi1:=1/(_2piSqrSigmaI) * Exp(-(ISourceN1-ISource1)*(ISourceN1-ISource1)/_4SqrSigmaI);
        Gi2:=1/(_2piSqrSigmaI) * Exp(-(ISourceN2-ISource2)*(ISourceN2-ISource2)/_4SqrSigmaI);
        Gi3:=1/(_2piSqrSigmaI) * Exp(-(ISourceN3-ISource3)*(ISourceN3-ISource3)/_4SqrSigmaI);

        Dist:=Sqrt((NeighbourX-X)*(NeighbourX-X)+((NeighbourY-Y))*((NeighbourY-Y)));
    //   Gs:=gaussian(distance(NeighbourX, NeighbourY, x, y), SigmaS);
        Gs:=1/_2piSqrSigmaD * Exp(-Dist*Dist/(_4SqrSigmaD));

        W1:=Gi1*Gs;
        W2:=Gi2*Gs;
        W3:=Gi3*Gs;

        IFiltered1:=IFiltered1+ISourceN1*W1;
        IFiltered2:=IFiltered2+ISourceN2*W2;
        IFiltered3:=IFiltered3+ISourceN3*W3;

        Wp1:=Wp1+W1;
        Wp2:=Wp2+W2;
        Wp3:=Wp3+W3;
        Inc(J);
        end;

      Inc(I);
      end;

    IFiltered1:=Round(IFiltered1/Wp1);
    IFiltered2:=Round(IFiltered2/Wp2);
    IFiltered3:=Round(IFiltered3/Wp3);
    pTarget^[TempY+TempX]:=Round(IFiltered1);
    pTarget^[TempY+TempX+1]:=Round(IFiltered2);
    pTarget^[TempY+TempX+2]:=Round(IFiltered3);
    end;
  end;

  bitmap.Assign(FilteredBmp);
  finally

    FilteredBmp.Free;
  end;
end;


procedure TBE._ApplyBilateral24(bitmap: TIEBitmap; EditRect: Trect;
  Radius, SigmaI, SigmaD:Integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if (not assigned(bitmap)) or (bitmap.PixelFormat <> ie24RGB)or(Bitmap.Width = 0) or (Bitmap.Height=0) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _ApplyBilateral24(bitmap, radius, SigmaI, SigmaD, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _ApplyBilateral24(tempbmp, radius, SigmaI, SigmaD, theProgressEvent);

    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);

  finally
    tempbmp.free;
  end;
end;


procedure TBE._ApplyBilateral8(bitmap: TIEBitmap; Radius, SigmaI, SigmaD: Integer; theProgressEvent: TIEProgressEvent);
type
TBigArray=array[0..2000000000] of byte;
pBigArray=^TBigArray;
var
ImWidth, ImHeight:Integer;
pSource, pTarget:pBigArray;
X, Y, TempY:Integer;
Hl:Integer;
ISource, ISourceN:Integer;
IFiltered:Double;
Dist:Double;
Gi:Double;
Gs:Double;
W:Double;
Wp:Double;
I, J:Integer;
NeighbourX, NeighbourY:Integer;
Diameter:integer;
FilteredBmp: TIEBitmap;
sqrSigmaI, sqrSigmaD, _4SqrSigmaI, _4SqrSigmaD: integer;
_2piSqrSigmaI,_2piSqrSigmaD :double;
begin
  if Radius = 0 then
    Radius := 1;
  Diameter := 2 * Radius;
  Hl:=Radius;
  sqrSigmaI := SigmaI * SigmaI;
  sqrSigmaD := SigmaD * SigmaD;
  _2piSqrSigmaI := 2 * pi * sqrSigmaI;
  _4SqrSigmaI := 4 * sqrSigmaI;
  _2piSqrSigmaD := 2 * pi *sqrSigmaD;
  _4SqrSigmaD := 4 * sqrSigmaD;

  if not Assigned(bitmap) then
  Exit;

  ImWidth:=bitmap.Width;
  ImHeight:=bitmap.Height;
  if (ImWidth=0) or (ImHeight=0) then
  Exit;

  FilteredBmp := TIEBitmap.Create;
  try

  FilteredBmp.Width:=ImWidth;
  FilteredBmp.Height:=ImHeight;
  FilteredBmp.PixelFormat:=ie8g;

  pSource:=bitmap.ScanLine[ImHeight-1];
  pTarget:=FilteredBmp.ScanLine[ImHeight-1];

  for Y:=0 to ImHeight-1 do
  begin
  TempY:=Y*ImWidth;
    if (y mod 100 = 0) and assigned(fOnProgress) then
      _AdvanceProgress(Self, theProgressEvent, trunc(y * 100 / ImHeight));
    for X:=0 to ImWidth-1 do
    begin
    ISource:=pSource^[TempY+X];
    IFiltered:=0;
    Wp:=0;

    I:=0;
      while I<Diameter do
      begin
      J:=0;
        NeighbourX:=min(imWidth-1, max(0, X-Hl+I));
        while J<Diameter do
        begin
        //  NeighbourX:=min(imWidth-1, max(0, X-Hl+I));
        NeighbourY:=min(imHeight-1, max(0, Y-Hl+J));

        ISourceN:=pSource^[NeighbourY*ImWidth+NeighbourX];
        Gi:=1/_2piSqrSigmaI * Exp(-(ISourceN-ISource)*(ISourceN-ISource)/_4SqrSigmaI);

        Dist:=Sqrt((NeighbourX-X)*(NeighbourX-X)+((NeighbourY-Y))*((NeighbourY-Y)));
        Gs:=1/_2piSqrSigmaD * Exp(-Dist*Dist/_4SqrSigmaD);

        W:=Gi*Gs;
        IFiltered:=IFiltered+ISourceN*W;

        Wp:=Wp+W;
        Inc(J);
        end;

      Inc(I);
      end;

    IFiltered:=Round(IFiltered/Wp);
    pTarget^[TempY+X]:=Round(IFiltered);
    end;
  end;
    bitmap.assign(FilteredBmp);
  finally
    FilteredBmp.Free;
  end;

end;

procedure TBE._ApplyBilateral8(bitmap: TIEBitmap; EditRect: Trect;
  Radius, SigmaI, SigmaD:Integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if (not assigned(bitmap)) or (bitmap.PixelFormat <> ie8g)or(Bitmap.Width = 0) or (Bitmap.Height=0) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _ApplyBilateral8(bitmap, radius, SigmaI, SigmaD, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _ApplyBilateral8(tempbmp, radius, SigmaI, SigmaD, theProgressEvent);

    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);

  finally
    tempbmp.free;
  end;
end;


procedure TBE._SmartContrast(bitmap: TIEBitmap; amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  mask: TBEMask;
  bCreateMAsk:boolean;
  maskId:string;

  tempBmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;


    _AdvanceProgress(Self, theProgressEvent, 10);
    mask := nil;
    if compareguid(PreviewId, IEPROC_EX_GUID_NULL) or fMultiIsRunning then
    begin
      bCreateMask := true;
    end
    else
    begin
      maskId := GetSmartMaskID(sm_midtones, max(1, radius) , false);
      mask := fPreviewMasks.RequireMask(PreviewId, maskId);
      bCreateMask := not assigned(mask);
    end;

    if bCreateMAsk then
    begin
      mask := TBEMask.Create;
      //When multithread is on:
      // if we are already inside multithread processing then we load the mask as single thread!!
      //otherwise proceed with loading the mask in multithread
      mask.GetFromBMPTones(fMultiThreadEnabled and (not fMultiIsRunning),
      sm_midtones, bitmap, max(1, radius), false,not compareguid(PreviewId, IEPROC_EX_GUID_NULL));
    end;

   tempBmp := TIEBitmap.create;
   try

    _AdvanceProgress(Self, theProgressEvent, 50);

    tempbmp.Assign(bitmap);


    BE_ApplyCurvesbyFunction(tempbmp, Rect(0, 0, tempBmp.width - 1, tempBmp.Height - 1), nil, nil, nil,
      BE_contrastMore);

    mask.CopyBitmap(bitmap, tempbmp, amount);

    _AdvanceProgress(Self, theProgressEvent, 100);
  finally
    tempbmp.free;

    if bCreateMAsk then
    begin
      if (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)) and (not fMultiIsRunning) then
      begin
        fPreviewMasks.SaveMask(PreviewId, maskId, mask); //mask kept in memory
      end
      else
        mask.free;  //mask was not saved, must be freed
    end;
  end;

end;


procedure TBE._SmartContrast(bitmap: TIEBitmap; EditRect: Trect;
  amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _SmartContrast(bitmap, amount, radius, PreviewId, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _SmartContrast(tempbmp, amount, radius, PreviewId, theProgressEvent);

    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;



procedure TBE._SmartFlash(bitmap: TIEBitmap; amount, radius: integer;
  PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
var
  mask: TBEMask;

  bCreateMAsk:boolean;
  maskId:string;

  tempBmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;


    _AdvanceProgress(Self, theProgressEvent, 10);
    mask := nil;
    if compareguid(PreviewId, IEPROC_EX_GUID_NULL) or fMultiIsRunning then
    begin
      bCreateMask := true;
    end
    else
    begin
      maskId := GetSmartMaskID(sm_shadows, max(1, radius) , false);
      mask := fPreviewMasks.RequireMask(PreviewId, maskId);
      bCreateMask := not assigned(mask);
    end;


    if bCreateMAsk then
    begin
      mask := TBEMask.Create;
      //When multithread is on:
      // if we are already inside multithread  processing then we load the mask as single thread!!
      //otherwise proceed with loading the mask in multithread
      mask.GetFromBMPTones(fMultiThreadEnabled and (not fMultiIsRunning),
       sm_shadows, bitmap, max(1, radius), false,not compareguid(PreviewId, IEPROC_EX_GUID_NULL));


    end;

   tempBmp := TIEBitmap.create;
   try

    _AdvanceProgress(Self, theProgressEvent, 50);

    tempbmp.Assign(bitmap);


    BE_ApplyCurvesbyFunction(tempbmp, Rect(0, 0, tempBmp.width - 1, tempBmp.Height - 1), nil, nil, nil,
      BE_EnhanceContrastShadows8_2);

    mask.CopyBitmap(bitmap, tempbmp, amount);

    _AdvanceProgress(Self, theProgressEvent, 100);
  finally
    tempbmp.free;

    if bCreateMAsk then
    begin
      if (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)) and (not fMultiIsRunning) then
      begin
        fPreviewMasks.SaveMask(PreviewId, maskId, mask); //mask kept in memory
      end
      else
        mask.free;  //mask was not saved, must be freed
    end;
  end;

end;


procedure TBE._SmartFlash(bitmap: TIEBitmap; EditRect: Trect;
  amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;



  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _SmartFlash(bitmap, amount, radius, PreviewId, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _SmartFlash(tempbmp, amount, radius, PreviewId, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;



procedure TBE._Smooth(bitmap: TIEBitmap; amount: integer; PreviewId: TGUID;
  theProgressEvent: TIEProgressEvent);
var
  bepf: Tbepixelformat;
  mask: TBEMask;

  bCreateMAsk:boolean;
  maskId:string;
  tempIEProc:TImageenproc;
  tempBmp: TIEBitmap;
begin
  if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;

    _AdvanceProgress(Self, theProgressEvent, 10);

    mask := nil;
    if compareguid(PreviewId, IEPROC_EX_GUID_NULL) or fMultiIsRunning then
    begin
      bCreateMask := true;
    end
    else
    begin
      maskId := GetSmartMaskID(sm_FindEdges, 8 , false);
      mask := fPreviewMasks.RequireMask(PreviewId, maskId);
      bCreateMask := not assigned(mask);
    end;

    if bCreateMAsk then
    begin
      mask := TBEMask.Create;
      //When multithread is on:
      // if we are already inside multithread  processing then we load the mask as single thread!!
      //otherwise proceed with loading the mask in multithread
       mask.GetFromBmpEdges(bitmap, ksMedium, true);
    end;


  //  mask := TBEMask.Create;

   tempBmp := TIEBitmap.create;
   tempIEProc := TImageenproc.CreateFromBitmap(tempbmp);
   try

    _AdvanceProgress(Self, theProgressEvent, 50);

    tempbmp.Assign(bitmap);
    tempieproc.Blur(amount);
    mask.CopyBitmap(bitmap, tempbmp, 128);

    _AdvanceProgress(Self, theProgressEvent, 100);
  finally
    tempieproc.Free;
    tempbmp.free;

    if bCreateMAsk then
    begin
      if (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)) and (not fMultiIsRunning) then
      begin
        fPreviewMasks.SaveMask(PreviewId, maskId, mask); //mask kept in memory
      end
      else
        mask.free;  //mask was not saved, must be freed
    end;

  end;
end;

procedure TBE._Smooth(bitmap: TIEBitmap; EditRect: Trect; amount: integer;
  PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _Smooth(bitmap, amount, PreviewId, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _Smooth(tempbmp, amount, PreviewId, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._LightEffect_Ellipse(Bitmap:TIEBitmap; color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
begin
  _LightEffect_Ellipse(Bitmap, rect(0,0,Bitmap.Width-1,bitmap.Height-1), color, LightAmount, EllipseMinor, EllipseMajor, Angle, xc, yc, PreviewId, theProgressEvent);
end;


procedure TBE._LightEffect_Ellipse(Bitmap:TIEBitmap; EditRect: Trect; color:TColor; LightAmount: integer; EllipseMinor, EllipseMajor:integer; Angle:integer; xc,yc:integer;PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  pb:pbytearray;

  I, j, k: Integer;
  BGR:TbeBGRbytearray;
  coseno, seno:double;
  eff, dist: double;
  la: TbeBGRDoublearray;

  shiftby, readby: integer;
  tempx:integer;
  SqrsemiEllMaj, SqrsemiEllMin: integer;
  blended:byte;
  i1,j1:integer;
  dbo:double;
  m: Integer;
  x_sn, y_sn: integer;
  x1,y1,x2,y2: integer;
begin
  if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  if(bitmap.PixelFormat <> ie24rgb) then EXIT;

  coseno := cos(angle/180*pi);
  seno := sin(angle/180*pi);
  SqrsemiEllMin := sqr(max(1,EllipseMinor div 2));
  SqrsemiEllMaj := sqr(max(1,EllipseMajor div 2));
  la[0] := (LightAmount /100 + getbvalue(Color)/255)/2;
  la[1] := (LightAmount /100 + getgvalue(Color)/255)/2;
  la[2] := (LightAmount /100 + getrvalue(Color)/255)/2;

  shiftby := 3;
  readby := 2;
  BE_GetEditCoords(x1,y1,x2,y2,EditRect, Bitmap.Width, Bitmap.Height);

  for j := y1 to y2 do
  begin
     pb := Bitmap.ScanLine[j];
     if (j mod 100 = 0)and assigned(theProgressEvent) then
        theProgressEvent(self, round((j - y1)/(y2 - y1 + 1) * 100));
     for I := x1 to x2 do
     begin
       tempx := shiftby * i;

        i1 := i - xc;
        j1 := j - yc;
        dist := sqr(i1*coseno + j1*seno)/SqrsemiEllMaj + sqr(i1 * seno - j1 * coseno)/SqrsemiEllMin ;

        if dist <= 1 then
          eff := (1 - dist)
        else
          eff := 0;
       for k := 0 to readby do
       begin
         BGR[k] := pb[tempx + k];
         blended := min(255, round(BGR[k] * (1 + la[k])));
         pb[tempx + k] := round(eff * blended + (1 - eff) * BGR[k]);
       end;

     end;
  end;
end;


procedure TBE._LightEffect_Beam(Bitmap: TIEBitmap; color: TColor; LightAmount:integer;
 BeamSize:integer; Angle:integer; xc, yc: integer; PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
begin
   _LightEffect_Beam(Bitmap,rect(0,0,Bitmap.Width-1,Bitmap.Height-1), color, LightAmount, BeamSize, Angle, xc,yc, PreviewId, theProgressEvent);
end;

procedure TBE._LightEffect_Beam(Bitmap: TIEBitmap; EditRect: Trect;
  color: TColor; LightAmount:integer; BeamSize:integer; Angle:integer; xc, yc: integer; PreviewId: TGUID;
  theProgressEvent: TIEProgressEvent);
var
  pb:pbytearray;
  I, j, k: Integer;
  BGR:TbeBGRbytearray;
  eff, dist: double;
  la: TbeBGRDoublearray;
  shiftby, readby: integer;
  tempx:integer;
  blended:byte;
  dbo:double;
  tangent:double;
  x1,y1,x2,y2: integer;
Function CalcTan(theAngle:double):double;
begin
  if (round(theAngle) mod 90) = 0 then
    result := 1000000
  else
    result := tan(theAngle/180*pi);
end;
begin
  if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  if(bitmap.PixelFormat <> ie24rgb) then EXIT;


  la[0] := (LightAmount /100 + getbvalue(Color)/255)/2;
  la[1] := (LightAmount /100 + getgvalue(Color)/255)/2;
  la[2] := (LightAmount /100 + getrvalue(Color)/255)/2;
  tangent := CalcTan(angle);

  shiftby := 3;
  readby := 2;
  BE_GetEditCoords(x1,y1,x2,y2,EditRect, Bitmap.Width, Bitmap.Height);

  for j := y1 to y2 do
  begin
     pb := Bitmap.ScanLine[j];
     if (j mod 100 = 0)and assigned(theProgressEvent) then
        theProgressEvent(self, round((j - y1)/(y2 - y1 + 1) * 100));
     for I := x1 to x2 do
     begin
       tempx := shiftby * i;

        dist := abs(j - (tangent * i - tangent * xc + yc))/sqrt(1 + sqr(tangent));
        eff := max(0, 1 - dist/BeamSize);

       for k := 0 to readby do
       begin
         BGR[k] := pb[tempx + k];
         blended := min(255, round(BGR[k] * (1 + la[k])));
         pb[tempx + k] := round(eff * blended + (1 - eff) * BGR[k]);
       end;

     end;
  end;

end;

procedure TBE._LightEffect_DoubleBeam(Bitmap: TIEBitmap; color: TColor;
  LightAmount, BeamSize, Opening, Angle, xc, yc: integer; PreviewId: TGUID;
  theProgressEvent: TIEProgressEvent);
begin
  _LightEffect_DoubleBeam(Bitmap,rect(0,0,Bitmap.Width-1,Bitmap.Height-1), color, LightAmount, BeamSize, Opening, Angle, xc,yc, PreviewId, theProgressEvent);
end;

procedure TBE._LightEffect_DoubleBeam(Bitmap: TIEBitmap; EditRect: Trect;
  color: TColor; LightAmount, BeamSize, Opening, Angle, xc, yc: integer;
  PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
var
  pb:pbytearray;
  I, j, k: Integer;
  BGR:TbeBGRbytearray;
  eff, dist, dist1: double;
  la: TbeBGRDoublearray;
  shiftby, readby: integer;
  tempx:integer;
  blended:byte;
  dbo:double;
  tangent:double;
  x1,y1,x2,y2: integer;
Function CalcTan(theAngle:double):double;
begin
  if (round(theAngle) mod 90) = 0 then
    result := 1000000
  else
    result := tan(theAngle/180*pi);
end;
begin
  if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  if(bitmap.PixelFormat <> ie24rgb) then EXIT;


  la[0] := (LightAmount /100 + getbvalue(Color)/255)/2;
  la[1] := (LightAmount /100 + getgvalue(Color)/255)/2;
  la[2] := (LightAmount /100 + getrvalue(Color)/255)/2;
  tangent := CalcTan(angle);
  dbo := Opening/100;

  shiftby := 3;
  readby := 2;
  BE_GetEditCoords(x1,y1,x2,y2,EditRect, Bitmap.Width, Bitmap.Height);

  for j := y1 to y2 do
  begin
     pb := Bitmap.ScanLine[j];
     if (j mod 100 = 0)and assigned(theProgressEvent) then
        theProgressEvent(self, round((j - y1)/(y2 - y1 + 1) * 100));
     for I := x1 to x2 do
     begin
       tempx := shiftby * i;

        dist := abs(j - (tangent * i - tangent * xc + yc))/sqrt(1 + sqr(tangent));
         dist1 := sqrt(sqr(i-xc)+sqr(j-yc));
         eff := max(0, 1- (dist / (Beamsize + dbo * dist1)));

       for k := 0 to readby do
       begin
         BGR[k] := pb[tempx + k];
         blended := min(255, round(BGR[k] * (1 + la[k])));
         pb[tempx + k] := round(eff * blended + (1 - eff) * BGR[k]);
       end;

     end;
  end;

end;

procedure TBE._ReduceHighlights(bitmap: TIEBitmap; amount, radius: integer;
  PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
var
  bepf: Tbepixelformat;
  mask: TBEMask;

  bCreateMAsk:boolean;
  maskId:string;

  tempBmp: TIEBitmap;
begin
  if (not assigned(bitmap)) or (bitmap.Width <= 0) or
    (bitmap.Height <= 0) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  bepf := bepfother;
  BE_Getpixelformat(bepf, bitmap);
  if bepf = bepfother then
    exit;

    _AdvanceProgress(Self, theProgressEvent, 10);

    mask := nil;
    if compareguid(PreviewId, IEPROC_EX_GUID_NULL) or fMultiIsRunning then
    begin
      bCreateMask := true;
    end
    else
    begin
      maskId := GetSmartMaskID(sm_hilights, max(1, radius) , false);
      mask := fPreviewMasks.RequireMask(PreviewId, maskId);
      bCreateMask := not assigned(mask);
    end;

    if bCreateMAsk then
    begin
      mask := TBEMask.Create;
      //When multithread is on:
      // if we are already inside multithread  processing then we load the mask as single thread!!
      //otherwise proceed with loading the mask in multithread
      mask.GetFromBMPTones(fMultiThreadEnabled and (not fMultiIsRunning),
      sm_hilights, bitmap, max(1, radius), false,not compareguid(PreviewId, IEPROC_EX_GUID_NULL));
    end;

   tempBmp := TIEBitmap.create;
   try

    _AdvanceProgress(Self, theProgressEvent, 50);

    tempbmp.Assign(bitmap);


    BE_ApplyCurvesbyFunction(tempbmp, Rect(0, 0, tempBmp.width - 1, tempBmp.Height - 1), nil, nil, nil,
      BE_EnhanceHilights);

    mask.CopyBitmap(bitmap, tempbmp, amount);

    _AdvanceProgress(Self, theProgressEvent, 100);
  finally
    tempbmp.free;

    if bCreateMAsk then
    begin
      if (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)) and (not fMultiIsRunning) then
      begin
        fPreviewMasks.SaveMask(PreviewId, maskId, mask); //mask kept in memory
      end
      else
        mask.free;  //mask was not saved, must be freed
    end;
  end;

end;

procedure TBE._ReduceHighlights(bitmap: TIEBitmap; EditRect: Trect;
  amount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _ReduceHighlights(bitmap, amount, radius, PreviewId, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _ReduceHighlights(tempbmp, amount, radius, PreviewId, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;


procedure TBE._FillBackLight(bitmap: TIEBitmap; Fillamount, BackAmount,
  radius: integer; PreviewId: TGUID; theProgressEvent: TIEProgressEvent);
var
  mask: TBEMask;
  bCreateMAsk:boolean;
  maskId:string;

  tempBmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;


    _AdvanceProgress(Self, theProgressEvent, 10);

    mask := nil;
    if compareguid(PreviewId, IEPROC_EX_GUID_NULL) or fMultiIsRunning then
    begin
      bCreateMask := true;
    end
    else
    begin
      maskId := GetSmartMaskID(sm_shadows_midtones, max(1, radius) , false);
      mask := fPreviewMasks.RequireMask(PreviewId, maskId);
      bCreateMask := not assigned(mask);
    end;

    if bCreateMAsk then
    begin
      mask := TBEMask.Create;
      //When multithread is on:
      // if we are already inside multithread  processing then we load the mask as single thread!!
      //otherwise proceed with loading the mask in multithread
      mask.GetFromBMPTones(fMultiThreadEnabled and (not fMultiIsRunning),
       sm_shadows_midtones, bitmap, max(1, radius), false,not compareguid(PreviewId, IEPROC_EX_GUID_NULL));
    end;

   tempBmp := TIEBitmap.create;
   try


    _AdvanceProgress(Self, theProgressEvent, 50);

    if (Fillamount > 0) then
    begin
      tempbmp.Assign(bitmap);

      BE_ApplyCurvesbyFunction(tempbmp, Rect(0, 0, tempBmp.width - 1, tempBmp.Height - 1), nil, nil, nil,
        BE_EnhanceContrastShadows3_7);

      mask.CopyBitmap(bitmap, tempbmp, Fillamount);

    end;


    _AdvanceProgress(Self, theProgressEvent, 75);

    if (Backamount > 0) then
    begin
      tempbmp.Assign(bitmap);
      BE_ApplyCurvesbyFunction(tempbmp, Rect(0, 0, tempBmp.width - 1, tempBmp.Height - 1), nil, nil, nil,
        BE_EnhanceHilights2);

      mask.CopyBitmap(bitmap, tempbmp, BackAmount, false, true);
    end;

    _AdvanceProgress(Self, theProgressEvent, 100);
  finally
    tempbmp.free;

    if bCreateMAsk then
    begin
      if (not compareguid(PreviewId, IEPROC_EX_GUID_NULL)) and (not fMultiIsRunning) then
      begin
        fPreviewMasks.SaveMask(PreviewId, maskId, mask); //mask kept in memory
      end
      else
        mask.free;  //mask was not saved, must be freed
    end;
  end;

end;

procedure TBE._FillBackLight(bitmap: TIEBitmap; EditRect: Trect;
  Fillamount, BackAmount, radius: integer; PreviewId:TGUID; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _FillBackLight(bitmap, FillAmount, BackAmount, radius, PreviewId, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _FillBackLight(tempbmp, FillAmount, BackAmount, radius, PreviewId, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;



procedure TBE._IE_UnsharpMask(bitmap: TIEBitmap; radius, amount,
  threshold: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
  begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
  end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.unsharpmask(radius, amount, threshold);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_UnsharpMask(bitmap: TIEBitmap; EditRect: Trect;
  radius, amount, threshold: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_UnsharpMask(bitmap, radius, amount, threshold, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_UnsharpMask(tempbmp, radius, amount, threshold, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;


procedure TBE._IE_Blur(bitmap: TIEBitmap; radius: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
  begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
  end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Blur(radius);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_Blur(bitmap: TIEBitmap; EditRect: Trect; radius: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Blur(bitmap, radius, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Blur(tempbmp, radius, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;




procedure TBE._IE_HSLVar(bitmap: TIEBitmap; Hue, Sat, Lum: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
  begin
    _AdvanceProgress(Self, theProgressEvent, 100);
    exit;
  end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.HSLvar(Hue, Sat, Lum);
  finally
    tempIEProc.free;
  end;
  
end;

procedure TBE._IE_HSLVar(bitmap: TIEBitmap; EditRect: Trect;
  Hue, Sat, Lum: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_HSLVar(bitmap, Hue, Sat, Lum, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_HSLVar(tempbmp, Hue, Sat, Lum, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;



procedure TBE._IE_HSVVar(bitmap: TIEBitmap; Hue, Sat, Value: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.HSVvar(Hue, Sat, Value);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_HSVVar(bitmap: TIEBitmap; EditRect: Trect;
  Hue, Sat, Value: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_HSVVar(bitmap, Hue, Sat, Value, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try

    _IE_HSVVar(tempbmp, Hue, Sat, Value, theProgressEvent);

    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;


procedure TBE._IE_Negative(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Negative;
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_Negative(bitmap: TIEBitmap; EditRect: Trect; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Negative(bitmap, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Negative(tempbmp, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;




procedure TBE._IE_IntensityRGBAll(bitmap: TIEBitmap; IntRed, IntGreen,
  IntBlue: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.IntensityRGBAll(IntRed, IntGreen, IntBlue);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_IntensityRGBAll(bitmap: TIEBitmap; EditRect: Trect;
  IntRed, IntGreen, IntBlue: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;


  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_IntensityRGBAll(bitmap, IntRed, IntGreen, IntBlue, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_IntensityRGBAll(tempbmp, IntRed, IntGreen, IntBlue, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;

procedure TBE._IE_Median(bitmap: TIEBitmap; Window, Threshold: integer;
  theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.MedianFilter(Window, Window, 50, 50, 1, Threshold, mfMedianFilter);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_Median(bitmap: TIEBitmap; EditRect: Trect; Window,
  Threshold: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Median(bitmap, Window, Threshold, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Median(tempbmp, Window, Threshold, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_MedianSharpen(bitmap: TIEBitmap; Window, Multiplier:integer;
  theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.MedianFilter(Window, Window, 50, 50, Multiplier, 50, mfSharpen);
  finally
    tempIEProc.free;
  end;

end;



procedure TBE._IE_MedianSharpen(bitmap: TIEBitmap; EditRect: Trect;
  Window, Multiplier:integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_MedianSharpen(bitmap, Window, Multiplier, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_MedianSharpen(tempbmp, Window, Multiplier, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._IE_Sharpen(bitmap: TIEBitmap; Amount, Window: integer;
  theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
  if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Sharpen(Amount, Window);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_Sharpen(bitmap: TIEBitmap; EditRect: Trect; Amount,
  Window: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if bitmap.PixelFormat<>ie24rgb then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Sharpen(bitmap, Amount, Window, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Sharpen(tempbmp, Amount, Window, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;

procedure TBE._IE_Intensity(bitmap: TIEBitmap; loLimit, HiLimit,
  Change: integer; UseAverageRgb, doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Intensity(loLimit, HiLimit, Change, UseAverageRgb, doRed,
      doGreen, doBlue);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_Intensity(bitmap: TIEBitmap; EditRect: Trect;
  loLimit, HiLimit, Change: integer; UseAverageRgb, doRed, doGreen,
  doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Intensity(bitmap, loLimit, HiLimit, Change, UseAverageRgb, doRed, doGreen, doBlue, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Intensity(tempbmp, loLimit, HiLimit, Change, UseAverageRgb, doRed, doGreen, doBlue, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_Contrast(bitmap: TIEBitmap; amount: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Contrast(amount);
  finally
    tempIEProc.free;
  end;
end;



procedure TBE._IE_Contrast(bitmap: TIEBitmap; EditRect: Trect; amount: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Contrast(bitmap, amount, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Contrast(tempbmp, amount, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;



procedure TBE._IE_Contrast2(bitmap: TIEBitmap; amount: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Contrast2(amount);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_Contrast2(bitmap: TIEBitmap; EditRect: Trect; amount: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Contrast2(bitmap, amount, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Contrast2(tempbmp, amount, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_Contrast3(bitmap: TIEBitmap; Change, MidPoint: integer; doRed,
  doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Contrast3(Change, MidPoint, doRed, doGreen, doBlue);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_Contrast3(bitmap: TIEBitmap; EditRect: Trect;
  Change, MidPoint: integer; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Contrast3(bitmap, Change, MidPoint, doRed, doGreen, doBlue, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Contrast3(tempbmp, Change, MidPoint, doRed, doGreen, doBlue, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;

procedure TBE._IE_FindEdges(bitmap: TIEBitmap;
  KernelSize: TIEProc_EX_Filter_Kernelsize; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
arr9: array[0..8] of double;
arr25: array[0..24] of double;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    case KernelSize of
      ksSmall:
      begin
        arr9[0] := 1;
        arr9[1] := 1;
        arr9[2] := 1;
        arr9[3] := 1;
        arr9[4] := -8;
        arr9[5] := 1;
        arr9[6] := 1;
        arr9[7] := 1;
        arr9[8] := 1;
        tempIEProc.Convolve(arr9,3,3,1);
      end;
      ksMedium:
      begin
        arr25[0] := 1;
        arr25[1] := 1;
        arr25[2] := 1;
        arr25[3] := 1;
        arr25[4] := 1;

        arr25[5] := 1;
        arr25[6] := -1;
        arr25[7] := 0;
        arr25[8] := -1;
        arr25[9] := 1;

        arr25[10] := 1;
        arr25[11] := 0;
        arr25[12] := -12;
        arr25[13] := 0;
        arr25[14] := 1;

        arr25[15] := 1;
        arr25[16] := -1;
        arr25[17] := 0;
        arr25[18] := -1;
        arr25[19] := 1;

        arr25[20] := 1;
        arr25[21] := 1;
        arr25[22] := 1;
        arr25[23] := 1;
        arr25[24] := 1;
        tempIEProc.Convolve(arr25,5,5,12);
      end;

    end;

  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_FindEdges(bitmap: TIEBitmap; EditRect: Trect;
  KernelSize: TIEProc_EX_Filter_Kernelsize; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_FindEdges(bitmap, KernelSize, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_FindEdges(tempbmp,  KernelSize, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_GammaCorrect(bitmap: TIEBitmap; Gamma: double; doRed, doGreen,
  doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
  aIEChannels: TIEChannels;
  tempIEProc: TImageEnProc;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

   aIEChannels := [];
    if doRed then
      aIEChannels := aIEChannels + [iecRed];
    if doGreen then
      aIEChannels := aIEChannels + [iecGreen];
    if doBlue then
      aIEChannels := aIEChannels + [iecBlue];

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.GammaCorrect(Gamma, aIEChannels);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_GammaCorrect(bitmap: TIEBitmap; EditRect: Trect;
  Gamma: double; doRed, doGreen, doBlue: boolean; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_GammaCorrect(bitmap, Gamma, doRed, doGreen, doBlue, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_GammaCorrect(tempbmp, Gamma, doRed, doGreen, doBlue, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;



procedure TBE._IE_AutoSharp(bitmap: TIEBitmap; Intensity: integer;
  Rate: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AutoSharp(Intensity, Rate);
  finally
    tempIEProc.free;
  end;

end;

procedure TBE._IE_AutoSharp(bitmap: TIEBitmap; EditRect: Trect;
  Intensity: integer; Rate: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AutoSharp(bitmap, Intensity, Rate, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_AutoSharp(tempbmp, Intensity, Rate, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._IE_Colorize(bitmap: TIEBitmap; Hue, Sat: integer; Lum: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.Colorize(Hue, Sat, Lum);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_Colorize(bitmap: TIEBitmap; EditRect: Trect; Hue: integer;
  Sat: integer; Lum: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Colorize(bitmap, Hue,  Sat, Lum, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Colorize(tempbmp, Hue,  Sat, Lum, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._IE_Brightness_Contrast_Saturation(bitmap: TIEBitmap; Brightness,
  Contrast, Sat: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AdjustBrightnessContrastSaturation(Brightness, Contrast, Sat);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_Brightness_Contrast_Saturation(bitmap: TIEBitmap;
  EditRect: Trect; Brightness, Contrast, Sat: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if (Brightness = 0) and (Contrast = 0) and (Sat = 0) then
   exit;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_Brightness_Contrast_Saturation(bitmap, Brightness, Contrast, Sat, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_Brightness_Contrast_Saturation(tempbmp, Brightness, Contrast, Sat, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_AdjustTint(bitmap: TIEBitmap; amount: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AdjustTint(amount);
  finally
    tempIEProc.free;
  end;
end;



procedure TBE._IE_AdjustTint(bitmap: TIEBitmap; EditRect: Trect;
  amount: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AdjustTint(bitmap, amount, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_AdjustTint(tempbmp, amount, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;

procedure TBE._IE_AdjustSaturation(bitmap: TIEBitmap; amount: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AdjustSaturation(amount);
  finally
    tempIEProc.free;
  end;
end;



procedure TBE._IE_AdjustSaturation(bitmap: TIEBitmap; EditRect: Trect;
  amount: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AdjustSaturation(bitmap, amount, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_AdjustSaturation(tempbmp, amount, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._IE_AdjustTemperature(bitmap: TIEBitmap; amount: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AdjustTemperature(amount);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_AdjustTemperature(bitmap: TIEBitmap; EditRect: Trect;
  amount: integer; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AdjustTemperature(bitmap, amount, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_AdjustTemperature(tempbmp, amount, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;

end;


procedure TBE._IE_AdjustLumSatHisto(bitmap: TIEBitmap; Sat, Lum: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AdjustLumSatHistogram(Sat, Lum);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_AdjustLumSatHisto(bitmap: TIEBitmap; EditRect: Trect;
  Sat, Lum: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AdjustLumSatHisto(bitmap, Sat, Lum, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_AdjustLumSatHisto(tempbmp, Sat, Lum, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;

procedure TBE._IE_WhiteBalance_coef(bitmap: TIEBitmap; Red, Green,
  Blue: double; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.WhiteBalance_coef(Red, Green, Blue);
  finally
    tempIEProc.free;
  end;
end;



procedure TBE._IE_WhiteBalance_coef(bitmap: TIEBitmap; EditRect: Trect;
  Red, Green, Blue: double; theProgressEvent: TIEProgressEvent);
var
  tempbmp: TIEBitmap;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_WhiteBalance_coef(bitmap, Red, Green, Blue, theProgressEvent);
    EXIT;
  end;

  tempbmp := TIEBitmap.Create;
  _GetCutBitmap(bitmap, EditRect, tempBmp);
  if not assigned(tempbmp) then EXIT;
  try
    _IE_WhiteBalance_coef(tempbmp, Red, Green, Blue, theProgressEvent);
    DrawIEBitmapToIeBitmap(tempbmp, bitmap, editrect.left, editrect.Top);
 //   tempbmp.DrawToTIEBitmap(bitmap, editrect.left, editrect.Top);
  finally
    tempbmp.free;
  end;
end;

procedure TBE._IE_WhiteBalance_GrayWorld(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.WhiteBalance_GrayWorld;
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_WhiteBalance_GrayWorld(bitmap: TIEBitmap; EditRect: Trect;
  bFullApply: boolean; theProgressEvent: TIEProgressEvent);
var
  bufferOrig, buffer: TIEBitmap;
  X1, y1, X2, y2: integer;
  W, h: integer;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_WhiteBalance_GrayWorld(bitmap, theProgressEvent);
    EXIT;
  end;

   BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  if bFullApply then
  begin
    buffer := TIEBitmap.Create;

    try
      buffer.Assign(bitmap);
      _IE_WhiteBalance_GrayWorld(buffer, theProgressEvent);
      buffer.CopyRectTo(bitmap, X1, y1, X1, y1, X2 - X1 + 1, y2 - y1 + 1);
    finally
      buffer.free;

    end;
  end
  else
  begin
    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    bufferOrig.Assign(bitmap);
    W := bufferOrig.Width;
    h := bufferOrig.Height;
    try

      fInternalProc.AttachedIEBitmap := bufferOrig;
      if W > h then
        fInternalProc.Resample(beScaledSampleSize,
          round(beScaledSampleSize * h / max(1, W)), beScaledSampleFilter)
      else
        fInternalProc.Resample(round(beScaledSampleSize * W / max(1, h)),
          beScaledSampleSize, beScaledSampleFilter);

      buffer.Assign(bufferOrig);
      _IE_WhiteBalance_GrayWorld(buffer, theProgressEvent);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;
  end;
end;


procedure TBE._IE_WhiteBalance_WhiteAt(bitmap: TIEBitmap; WhiteX,
  WhiteY: integer; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.WhiteBalance_WhiteAt(WhiteX, WhiteY);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_WhiteBalance_WhiteAt(bitmap: TIEBitmap; EditRect: Trect;
  WhiteX, WhiteY: integer; theProgressEvent: TIEProgressEvent);
var
  bufferOrig, buffer: TIEBitmap;
  W, h: integer;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_WhiteBalance_WhiteAt(bitmap, WhiteX, WhiteY, theProgressEvent);
    EXIT;
  end;

    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    W := bitmap.Width;
    h := bitmap.Height;
    try
      bufferOrig.PixelFormat := bitmap.PixelFormat;
      if W > h then
      begin
        bufferOrig.width := beScaledSampleSize;
        bufferOrig.Height := round(beScaledSampleSize * h / max(1, W));
      end
      else
      begin
        bufferOrig.Height := beScaledSampleSize;
        bufferOrig.width := round(beScaledSampleSize * W / max(1, H));
      end;
      bitmap.StretchRectTo(bufferOrig, 0,0, bufferorig.width, bufferorig.Height,
                           0,0, bitmap.width, bitmap.Height, rfLanczos3);

      buffer.Assign(bufferOrig);
      _IE_WhiteBalance_WhiteAt(buffer, round(WhiteX * buffer.Width / max(1, W)),
      round(WhiteY * buffer.Width / max(1, h)), theProgressEvent);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;
end;


procedure TBE._IE_WhiteBalance_AutoWhite(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.WhiteBalance_AutoWhite;
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_WhiteBalance_AutoWhite(bitmap: TIEBitmap; EditRect: Trect;
  bFullApply: boolean; theProgressEvent: TIEProgressEvent);
var
  bufferOrig, buffer: TIEBitmap;
  X1, y1, X2, y2: integer;
  W, h: integer;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if bFullApply and _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_WhiteBalance_AutoWhite(bitmap, theProgressEvent);
    EXIT;
  end;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  if bFullApply then
  begin
    buffer := TIEBitmap.Create;
    try
      buffer.Assign(bitmap);
      _IE_WhiteBalance_AutoWhite(buffer, theProgressEvent);
      buffer.CopyRectTo(bitmap, X1, y1, X1, y1, X2 - X1 + 1, y2 - y1 + 1);
    finally
      buffer.free;
    end;
  end
  else
  begin
    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    bufferOrig.Assign(bitmap);
    W := bufferOrig.Width;
    h := bufferOrig.Height;
    try

      fInternalProc.AttachedIEBitmap := bufferOrig;
      if W > h then
        fInternalProc.Resample(beScaledSampleSize,
          round(beScaledSampleSize * h / max(1, W)), beScaledSampleFilter)
      else
        fInternalProc.Resample(round(beScaledSampleSize * W / max(1, h)),
          beScaledSampleSize, beScaledSampleFilter);
      buffer.Assign(bufferOrig);
      _IE_WhiteBalance_AutoWhite(buffer, theProgressEvent);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;
  end;
end;



procedure TBE._IE_AutoImageEnhance1(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent;
  SubsampledSize, Slope, Cut, Neightbour: integer);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AutoImageEnhance1(SubsampledSize, Slope, Cut, Neightbour);
  finally
    tempIEProc.free;
  end;
end;


procedure TBE._IE_AutoImageEnhance1(bitmap: TIEBitmap; EditRect: Trect;
  bFullApply: boolean; theProgressEvent: TIEProgressEvent; SubsampledSize: integer = 60; Slope: integer = 20;
  Cut: integer = 25; Neightbour: integer = 2);
var
  bufferOrig, buffer: TIEBitmap;
  X1, y1, X2, y2: integer;
  W, h: integer;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if bFullApply and _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AutoImageEnhance1(bitmap, theProgressEvent, SubsampledSize, Slope, Cut, Neightbour);
    EXIT;
  end;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  if bFullApply then
  begin
    buffer := TIEBitmap.Create;
    try
      buffer.Assign(bitmap);
      _IE_AutoImageEnhance1(buffer, theProgressEvent, SubsampledSize, Slope, Cut, Neightbour);
      buffer.CopyRectTo(bitmap, X1, y1, X1, y1, X2 - X1 + 1, y2 - y1 + 1);
    finally
      buffer.free;
    end;
  end
  else
  begin
    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    W := bitmap.Width;
    h := bitmap.Height;
    try
      bufferOrig.PixelFormat := bitmap.PixelFormat;
      if W > h then
      begin
        bufferOrig.width := beScaledSampleSize;
        bufferOrig.Height := round(beScaledSampleSize * h / max(1, W));
      end
      else
      begin
        bufferOrig.Height := beScaledSampleSize;
        bufferOrig.width := round(beScaledSampleSize * W / max(1, H));
      end;
      bitmap.StretchRectTo(bufferOrig, 0,0, bufferorig.width, bufferorig.Height,
                           0,0, bitmap.width, bitmap.Height, rfLanczos3);

      buffer.Assign(bufferOrig);
      _IE_AutoImageEnhance1(buffer, theProgressEvent, SubsampledSize, Slope, Cut, Neightbour);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;
  end;
end;



procedure TBE._IE_AutoImageEnhance2(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent;
  ScaleCount, ScaleCurve: integer; Variance: double; ScaleHigh: integer;
  Luminance: boolean);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AutoImageEnhance2(ScaleCount, ScaleCurve, Variance, ScaleHigh, Luminance);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_AutoImageEnhance2(bitmap: TIEBitmap; EditRect: Trect;
  bFullApply: boolean; theProgressEvent: TIEProgressEvent; ScaleCount: integer = 3; ScaleCurve: integer = 2;
  Variance: double = 1.8; ScaleHigh: integer = 200; Luminance: boolean = true);
var
  bufferOrig, buffer: TIEBitmap;
  X1, y1, X2, y2: integer;
  W, h: integer;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if bFullApply and _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AutoImageEnhance2(bitmap, theProgressEvent, ScaleCount, ScaleCurve, Variance, ScaleHigh, Luminance);
    EXIT;
  end;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  if bFullApply then
  begin
    buffer := TIEBitmap.Create;
    try
      buffer.Assign(bitmap);
      _IE_AutoImageEnhance2(buffer, theProgressEvent, ScaleCount, ScaleCurve, Variance, ScaleHigh, Luminance);
      buffer.CopyRectTo(bitmap, X1, y1, X1, y1, X2 - X1 + 1, y2 - y1 + 1);
    finally
      buffer.free;
    end;
  end
  else
  begin
    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    W := bitmap.Width;
    h := bitmap.Height;
    try
      bufferOrig.PixelFormat := bitmap.PixelFormat;
      if W > h then
      begin
        bufferOrig.width := beScaledSampleSize;
        bufferOrig.Height := round(beScaledSampleSize * h / max(1, W));
      end
      else
      begin
        bufferOrig.Height := beScaledSampleSize;
        bufferOrig.width := round(beScaledSampleSize * W / max(1, H));
      end;
      bitmap.StretchRectTo(bufferOrig, 0,0, bufferorig.width, bufferorig.Height,
                           0,0, bitmap.width, bitmap.Height, rfLanczos3);

      buffer.Assign(bufferOrig);
      _IE_AutoImageEnhance2(buffer, theProgressEvent, ScaleCount, ScaleCurve, Variance, ScaleHigh, Luminance);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;
  end;

end;

procedure TBE._IE_AutoImageEnhance3(bitmap: TIEBitmap; theProgressEvent: TIEProgressEvent; Gamma: double;
  Saturation: integer);
var
tempIEProc: TImageEnProc;
begin
   if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  tempIEProc := _CreateTempIEProc(bitmap, theProgressEvent);
  try
    tempIEProc.AutoImageEnhance3(Gamma, Saturation);
  finally
    tempIEProc.free;
  end;
end;

procedure TBE._IE_AutoImageEnhance3(bitmap: TIEBitmap; EditRect: Trect;
  bFullApply: boolean; theProgressEvent: TIEProgressEvent; Gamma: double = 0.35; Saturation: integer = 80);
var
  bufferOrig, buffer: TIEBitmap;
  X1, y1, X2, y2: integer;
  W, h: integer;
begin
  if not _CanProcess(bitmap) then
   begin
     _AdvanceProgress(Self, theProgressEvent, 100);
     exit;
   end;

  if bFullApply and _IsRectFull(editRect, bitmap.width, bitmap.height) then
  begin
    _IE_AutoImageEnhance3(bitmap, theProgressEvent, Gamma, Saturation);
    EXIT;
  end;

  BE_GetEditCoords(X1, y1, X2, y2, EditRect, bitmap.Width, bitmap.Height);

  if bFullApply then
  begin
    buffer := TIEBitmap.Create;
    try
      buffer.Assign(bitmap);
      _IE_AutoImageEnhance3(buffer, theProgressEvent, Gamma, Saturation);
      buffer.CopyRectTo(bitmap, X1, y1, X1, y1, X2 - X1 + 1, y2 - y1 + 1);
    finally
      buffer.free;
    end;
  end
  else
  begin
    bufferOrig := TIEBitmap.Create;
    buffer := TIEBitmap.Create;
    W := bitmap.Width;
    h := bitmap.Height;
    try
      bufferOrig.PixelFormat := bitmap.PixelFormat;
      if W > h then
      begin
        bufferOrig.width := beScaledSampleSize;
        bufferOrig.Height := round(beScaledSampleSize * h / max(1, W));
      end
      else
      begin
        bufferOrig.Height := beScaledSampleSize;
        bufferOrig.width := round(beScaledSampleSize * W / max(1, H));
      end;
      bitmap.StretchRectTo(bufferOrig, 0,0, bufferorig.width, bufferorig.Height,
                           0,0, bitmap.width, bitmap.Height, rfLanczos3);

      buffer.Assign(bufferOrig);
      _IE_AutoImageEnhance3(buffer, theProgressEvent,  Gamma, Saturation);
      BE_ApplyScaledFilter(bitmap, buffer, bufferOrig, EditRect);

    finally
      buffer.free;
      bufferOrig.free;
    end;

  end;
end;



{ TbePreviewMask }

constructor TbePreviewMask.Create(thePreviewId: TGUid; theMaskId: string;
  memoryMask: TBemask);
begin
  inherited Create;

  fPreviewID := thePreviewId;
  fMaskId := theMaskId;
  fMask := memoryMask;

end;

destructor TbePreviewMask.Destroy;
begin
  if assigned(fMask) then
    freeandnil(fMask);
  inherited;
end;

{ TbePreviewMasks }

procedure TbePreviewMasks.Clear;
var
 i:integer;
 pm:TBePreviewmask;
begin
  for I := count-1 downto 0 do
  begin
    Pm := GetMask(i);
    FreeAndNil(pm);
  end;

  inherited;
end;

constructor TbePreviewMasks.Create;
begin
  inherited;
  fCs := TCriticalSection.create;
end;

destructor TbePreviewMasks.Destroy;
begin
  Clear;  //overridden method also frees the memory
  fCs.free;
  inherited;
end;

function TbePreviewMasks.GetMask(idx: integer): TbePreviewMask;
begin
  result := TbePreviewMask(items[idx]);
end;

function TbePreviewMasks.RequireMask(thePreviewId: TGUid;
  theMaskId: string): TBemask;
var
  I: Integer;
  pm: TBEPreviewMask;
begin
  result := nil;
  fCs.enter;
  try
      for I := 0 to count-1 do
      begin
        pm := Getmask(i);
        if CompareGUID(pm.PreviewID, thePreviewId) then
        begin
          if themaskId = pm.MaskID then
          begin
            result := pm.Mask;
            break;
          end;
        end
        else
        begin
          Clear;  //found at least one preview id different from required one so delete all memory of all masks
          break;
        end;
      end;
  finally
    fCS.leave;
  end;
end;

procedure TbePreviewMasks.SaveMask(thePreviewId: TGUid; theMaskId: string; theMask:TBeMask);
var
  I: Integer;
  pm, newPm: TBEPreviewMask;
  bFound:boolean;
begin
  bFound := false;
  fCs.Enter;
  try
      for I := 0 to count-1 do
      begin
        pm := Getmask(i);
        if CompareGUID(pm.PreviewID, thePreviewId) then
        begin
          if themaskId = pm.MaskID then
          begin
            bFound := true;
            break;
          end;
        end
        else
        begin
          Clear;  //found at least one preview id different from required one so delete all memory of all masks
          break;
        end;
      end;

      newPm := TBEPreviewMask.Create(thePreviewId, theMaskId, theMask);
      if bFound then
      begin
        freeandnil(pm);
        items[i] := newpm;
      end
      else
        add(newpm);

  finally
    fCs.leave;
  end;
end;

{TbeHistogram}
constructor TbeHistogram.Create;
begin
  ReSetGrayConsts;
end;

procedure TbeHistogram.SetGrayConsts(const BlueConst, GreenConst, RedConst: byte);
begin
  fGRAYConsts[0] := BlueConst;
  fGRAYConsts[1] := GreenConst;
  fGRAYConsts[2] := RedConst;
end;

procedure TbeHistogram.ReSetGrayConsts;
begin
  fGRAYConsts[0] := 9;
  fGRAYConsts[1] := 58;
  fGRAYConsts[2] := 33;
end;

procedure TbeHistogram.GetHistogramfromBMP(Bitmap: TIEbitmap; editrect: Trect);
var
  i, j, k: integer;
  pp: pbebytearray;
  gray: integer;
  BGRA: TbeBGRAbytearray;
  bepf: Tbepixelformat;
  x1, y1, x2, y2: integer;
  tempx: integer;
  shiftby, readby: integer;
begin
  if not assigned(Bitmap) then
    exit;
  bepf := bepfother;

  BE_Getpixelformat(bepf, bitmap);

  if bepf = bepfother then
    exit;

  BE_Get_Shiftby_Readby_Values(Shiftby, Readby, bepf);

  if (bitmap.width <= 0) or (bitmap.height <= 0) then
    exit;

  BE_GetEditCoords(x1, y1, x2, y2, EditRect, bitmap.width, bitmap.height);

  for i := 0 to 255 do
  begin
    for k := 0 to 4 do
      fBGRAGraydata[i, k] := 0;
  end;

  for j := y1 to y2 do
  begin
    pp := bitmap.scanline[j];
    for i := x1 to x2 do
    begin
      tempx := shiftby * i;
      for k := 0 to readby do
        BGRA[k] := pp[tempx + k];

      case bepf of
        bepf8: gray := BGRA[0];
      else
        gray := (fgrayconsts[2] * BGRA[2] + fgrayconsts[1] * BGRA[1] + fgrayconsts[0] * BGRA[0]) div 100;
      end;

      for k := 0 to readby do
        fBGRAGraydata[BGRA[k], k] := fBGRAGraydata[BGRA[k], k] + 1;

      fBGRAGraydata[gray, 4] := fBGRAGraydata[gray, 4] + 1;
    end;
  end;
  fNumberOfValues := (x2 - x1 + 1) * (y2 - y1 + 1);
end;

procedure TbeHistogram.GetHistogramAndDatafromBMP(Bitmap: TIEbitmap; editrect: Trect; grayonly: boolean; const bScale: boolean = false);
var
  samplesize: integer;
begin
  GetHistogramfromBMP(Bitmap, editrect);

  if bScale then
  begin
    samplesize := (bitmap.width + bitmap.height) div 2;
    AdjournHistogramData(grayonly, samplesize/1000);
  end
  else
    AdjournHistogramData(grayonly, 1);
end;

procedure TbeHistogram.GetHistogramvariances(var variances: TbeBGRAGraysinglearray; var integralsS, integralsM, integralsH: TbeBGRAGrayint64array);
var
  i, k: integer;
  sums: TbeBGRAGrayint64array;
  avsum: int64;
  value: integer;
begin
  for k := 0 to 4 do
  begin
    sums[k] := 0;
    integralsS[k] := 0;
    integralsM[k] := 0;
    integralsH[k] := 0;
  end;

  for k := 0 to 4 do
    for i := 0 to 255 do
    begin
      value := i * fBGRAGraydata[i, k];
      sums[k] := sums[k] + value;
      if i <= BECONST_SHADOWS_LIM_TO then
        integralsS[k] := integralsS[k] + value
      else if (i >= BECONST_MIDTONES_LIM_FROM) and (i <= BECONST_MIDTONES_LIM_TO) then
        integralsM[k] := integralsM[k] + value
      else
        integralsH[k] := integralsH[k] + value
    end;

  //for k:=0 to 4 do
  //  integrals[k]:=sums[k];

  avsum := (sums[0] + sums[1] + sums[2]) div 3;

  variances[4] := 1;
  for k := 0 to 2 do
    variances[k] := sums[k] / max(1, avsum);

end;

procedure TbeHistogram.AdjournHistogramData(grayOnly: boolean; const PicScale: single = 1);
begin
  AdjournHistogramDensity(grayonly);
  AdjournHistogramLimits(grayonly, PicScale);
end;

procedure TbeHistogram.AdjournHistogramDensity(grayOnly: boolean);
var
  i, k, kstart: integer;
  NshValues: TbeBGRAGrayintarray;
  NHiValues: TbeBGRAGrayintarray;
  NMValues: TbeBGRAGrayintarray;
  Nsh_significantValues: TbeBGRAGrayintarray;
  NHi_Highestvalues: TbeBGRAGrayintarray;
  divisor: integer;

  maxdens: single;
begin
  // Calculate Density
  if grayonly then
    kstart := 4
  else
    kstart := 0;

  for k := kstart to 4 do
  begin
    NshValues[k] := 0;
    NHiValues[k] := 0;
    NMValues[k] := 0;
    Nsh_significantValues[k] := 0;
    NHi_Highestvalues[k] := 0;
  end;

  for i := BECONST_SHADOWS_VERYDARK_SIGNIFICANT_LIM_FROM to BECONST_SHADOWS_VERYDARK_SIGNIFICANT_LIM_TO do
    for k := kstart to 4 do
      Nsh_significantValues[k] := Nsh_significantValues[k] + fBGRAGraydata[i, k];

  for i := BECONST_HIGHLIGHTSHIGH_LIM to 255 do
    for k := kstart to 4 do
      NHi_Highestvalues[k] := NHi_Highestvalues[k] + fBGRAGraydata[i, k];

  for i := BECONST_SHADOWS_LIM_FROM to BECONST_SHADOWS_LIM_TO do
    for k := kstart to 4 do
      NshValues[k] := NshValues[k] + fBGRAGraydata[i, k];

  for i := BECONST_HIGHLIGHTS_LIM_FROM to BECONST_HIGHLIGHTS_LIM_TO do
    for k := kstart to 4 do
      NHiValues[k] := NHiValues[k] + fBGRAGraydata[i, k];

  for i := BECONST_MIDTONES_LIM_FROM to BECONST_MIDTONES_LIM_TO do
    for k := kstart to 4 do
      NMValues[k] := NMValues[k] + fBGRAGraydata[i, k];

  divisor := max(1, fNumberOfValues);

  fsignificant_shadows_ratio := Nsh_significantValues[4] / max(1, NshValues[4]);
  fHighest_hilights_ratio := NHi_Highestvalues[4] / max(1, NHiValues[4]);

  for k := kstart to 4 do
  begin
    fNumberOfValuesinShadows[k] := NshValues[k];
    fBGRAGrayDensityS[k] := fNumberOfValuesinShadows[k] / divisor;
  end;

  for k := kstart to 4 do
  begin
    fNumberOfValuesinHilights[k] := NHiValues[k];
    fBGRAGrayDensityH[k] := fNumberOfValuesinHilights[k] / divisor;
  end;

  for k := kstart to 4 do
  begin
    fNumberOfValuesinMidTones[k] := NMValues[k];
    fBGRAGrayDensityM[k] := fNumberOfValuesinMidTones[k] / divisor;
  end;

  maxdens := 0;
  for k := kstart to 4 do
    maxdens := max(maxdens, fBGRAGrayDensityS[k]);

  fAverageGrayDensityS := (fBGRAGrayDensityS[4] + maxdens) / 2;

  maxdens := 0;
  for k := kstart to 4 do
    maxdens := max(maxdens, fBGRAGrayDensityM[k]);

  fAverageGrayDensitym := (fBGRAGrayDensityM[4] + maxdens) / 2;

  maxdens := 0;
  for k := kstart to 4 do
    maxdens := max(maxdens, fBGRAGrayDensityH[k]);

  fAverageGrayDensityh := (fBGRAGrayDensityH[4] + maxdens) / 2;

  if fAverageGrayDensitym + fAverageGrayDensitys + fAverageGrayDensityh > 0 then
  begin
    fAverageGrayDensitys := fAverageGrayDensitys / (fAverageGrayDensitym + fAverageGrayDensitys + fAverageGrayDensityh);
    fAverageGrayDensitym := fAverageGrayDensitym / (fAverageGrayDensitym + fAverageGrayDensitys + fAverageGrayDensityh);
    fAverageGrayDensityh := fAverageGrayDensityh / (fAverageGrayDensitym + fAverageGrayDensitys + fAverageGrayDensityh);
  end;
end;


procedure TbeHistogram.AdjournHistogramLimits(grayOnly: boolean; const PicScale: single = 1);
var
  sommaBGRAGray: TbeBGRAGrayint64array;
  i, k, kstart: integer;
  rightlimit, leftlimit, leftlimit_gray, rightlimit_gray: integer;
var
  coefColor_Right: single;
  coefColor_Left: single;
  coefGray_Right: single;
  coefGray_Left: single;
begin

  coefColor_Right := 0.0004 * PicScale;
  coefColor_Left := 0.0015 * PicScale;
  coefGray_Right := 0.0008 * PicScale;
  coefGray_Left := 0.002 * PicScale;

  if grayonly then
    kstart := 4
  else
    kstart := 0;

  for k := 0 to 4 do
    sommaBGRAGray[k] := 0;

  for i := 0 to 255 do
    for k := kstart to 4 do
      sommaBGRAGray[k] := sommaBGRAGray[k] + fBGRAGraydata[i, k] * i;

  for k := kstart to 4 do
    fBGRAGrayAverage[k] := sommaBGRAGray[k] div fNumberOfValues;

  for k := kstart to 4 do
    fBGRAGrayMinEntry[k] := 0;

  for k := kstart to 4 do
    fBGRAGrayMaxEntry[k] := 0;


  rightlimit := round(coefColor_Right * fNumberOfValues);
  leftlimit := round(coefColor_Left * fNumberOfValues);

  rightlimit_gray := round(coefGray_Right * fNumberOfValues);
  leftlimit_gray := round(coefGray_Left * fNumberOfValues);

  for k := kstart to 2 do
  begin
    i := 0;
    sommaBGRAGray[k] := 0;
    while (i < fBGRAGrayAverage[k]) and (sommaBGRAGray[k] < leftlimit) do
    begin

      sommaBGRAGray[k] := sommaBGRAGray[k] + fBGRAGraydata[i, k];
      i := i + 1;
    end;
    fBGRAGrayMinEntry[k] := i;

    i := 255;
    sommaBGRAGray[k] := 0;
    while (i > fBGRAGrayAverage[k]) and (sommaBGRAGray[k] < rightlimit) do
    begin

      sommaBGRAGray[k] := sommaBGRAGray[k] + fBGRAGraydata[i, k];
      i := i - 1;
    end;
    fBGRAGrayMaxEntry[k] := i;
  end;

  i := 0;
  sommaBGRAGray[4] := 0;
  while (i < fBGRAGrayAverage[4]) and (sommaBGRAGray[4] < leftlimit_gray) do
  begin

    sommaBGRAGray[4] := sommaBGRAGray[4] + fBGRAGraydata[i, 4];
    i := i + 1;
  end;
  fBGRAGrayMinEntry[4] := i;

  i := 255;
  sommaBGRAGray[4] := 0;
  while (i > fBGRAGrayAverage[4]) and (sommaBGRAGray[4] < rightlimit_gray) do
  begin

    sommaBGRAGray[4] := sommaBGRAGray[4] + fBGRAGraydata[i, 4];
    i := i - 1;
  end;
  fBGRAGrayMaxEntry[4] := i;

end;


initialization

GetInterpPoints_BE_BrightShadows(interpPoints);
CalculateBSplineCoefs(coefs_BE_BrightShadows,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_BrightHilights(interpPoints);
CalculateBSplineCoefs(coefs_BE_BrightHilights,
  TRGBCurves_DoublePointsarray(interpPoints));


GetInterpPoints_BE_DarkShadows(interpPoints);
CalculateBSplineCoefs(coefs_BE_DarkShadows,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_DarkHilights(interpPoints);
CalculateBSplineCoefs(coefs_BE_DarkHilights,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_LowContrast(interpPoints);
CalculateBSplineCoefs(coefs_BE_LowContrast,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_HiContrast(interpPoints);
CalculateBSplineCoefs(coefs_BE_HiContrast,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_contrastless(interpPoints);
CalculateBSplineCoefs(coefs_BE_ContrastLess,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_contrastMore(interpPoints);
CalculateBSplineCoefs(coefs_BE_ContrastMore,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_DarkenShadows(interpPoints);
CalculateBSplineCoefs(coefs_BE_DarkenShadows,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_LightenHilights(interpPoints);
CalculateBSplineCoefs(coefs_BE_LightenHilights,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_EnhanceContrastShadows(interpPoints);
CalculateBSplineCoefs(coefs_BE_EnhanceContrastShadows,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_EnhanceContrastShadows1(interpPoints);
CalculateBSplineCoefs(coefs_BE_EnhanceContrastShadows1,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_EnhanceShadows(interpPoints);
CalculateBSplineCoefs(coefs_BE_EnhanceShadows,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_EnhanceHilights(interpPoints);
CalculateBSplineCoefs(coefs_BE_EnhanceHilights,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_EnhanceHilights2(interpPoints);
CalculateBSplineCoefs(coefs_BE_EnhanceHilights2,
  TRGBCurves_DoublePointsarray(interpPoints));

GetInterpPoints_BE_SmartFlash(interpPoints);
CalculateBSplineCoefs(coefs_BE_SmartFlash,
  TRGBCurves_DoublePointsarray(interpPoints));

finalization

end.
