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



unit NWSComps_IEPaintengine;
{$R-}
{$Q-}
(*
  TImageEnPaintEngine for ImageEn

  The ImageEn suite is a powerful graphics library and can be downloaded
  at www.imageen.com

  The supported pixel formats of this engine for now are the most common ones:
  IE24RGB (24 bits True color)
  IE8g (8 bits Grayscale)

  To use at best this engine please look at the sample project provided
  with any distribution of this software.
*)


interface


{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_IEPaintEngine.inc}

uses
  Windows, Classes, sysutils, controls, contnrs, extctrls, math,
  ImageEnview, hyiedefs, hyieutils,{$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF} imageenProc,
  NWSComps_IEPaintEngine_Utils,
  NWSComps_IEPaintEngine_Color,
  NWSComps_IEPaintEngine_Types,
  graphics, dialogs, syncobjs
{$IFDEF USE_JANTAB}
    , JH_WinTab, JH_WinTab_Const
{$ENDIF}
    ;





type

  TPeMousePositions = array of TPoint;


  TImageEnPaintEngine = class(TThread)
  private
    fRunTimeMode: boolean;
    fpeSession: TPESession;

    fpeParams_Paint: TpePaintPArams;
    fpeParams_Color: tPeColorParams;
    fpeParams_Texture: tPeTextureParams;
    fpeParams_History: tPeHistoryParams;
    fpeParams_Cloning: TpeCloningParams;
    fpeParams_Warp: TPeDeformationParams;
    fpeParams_Retouch: TPeRetouchParams;
    fpeParams_ObjectStamp: tPeObjectStampParams;

{$IFDEF USE_JANTAB}
    fpeParams_Tablet: TPeTabletParams;
{$ENDIF}
    fpeImageen: Timageenview;
    fpeBitmap: TIEbitmap;


    fPeCursorList:TObjectList;
    fPECursorCloneList:TObjectList;

    fPeIsRunning: boolean;
    fPeIsRunningSynch: boolean;
    fPeGoEvent: TSimpleEvent;

    fpeUtils: TpeUtilsStatus;
    fpeStatus: tPeStatus;
    fpeNotRunningStatus: tPeNotRunningStatus;
    fpeCoords: tPeCoords;
    fpeBrushStatus: TPEBrushStatus;
    fPeIEViewStatus: TPeImageEnStatus;

    fpeBe: TpeBitmapEditor;

    fProc: TImageEnProc;
    pBrush: tpebrushrowarray;
    pDest, pDestAlpha, pBuf, pBufAlpha, pCloneBuf, pCloneAlphaBuf, pBuf_Sel: tperowarray;


    PaintToAlphaTable: array [0 .. 255] of array [0 .. 255] of byte;
    BlendToAlphaTable: array [0 .. 255] of array [0 .. 255] of byte;
    TranspTable: array [0 .. 255] of byte;

    fHoldsDrawBackBuffer: boolean;
    fHoldsDrawCanvas: boolean;
    fOldDrawBackBuffer: TNotifyEvent;
    fOldDrawCanvas: TIEOnDrawCanvas;
    fpeOnStartedPainting: TnotifyEvent;
    fpeOnPainting: tpeNotifyEvent;
    fpeOnDebugging: TnotifyEvent;
    fpeOnFinishedPainting: TnotifyEvent;
    fpeOnInfoChanged: tPeParamsChangedEvent;
    fpeOnSessionEvent: tPeParamsSessionEvent;
    fUpdatePriority: TPEUpdatePriority;
    fUpdateMode: TPEUpdateMode;


    fCSTerminate: TCriticalSection;

    fImageEnGUI: TGUID;

    procedure checkRegistration;

    procedure HandleInfoChanged(Sender: TObject;
      nsRequest: tpeNewSessionRequest);


    procedure CalcPaintToAlphaTable;
    procedure CalcTranspTable;

    function GetTabletPressure: byte;

    function myXScr2BMP(x: integer): integer;
    function myYScr2BMP(y: integer): integer;
    function myXBMP2Scr(x: integer): integer;  overload;
    function myYBMP2Scr(y: integer): integer;  overload;
    function myXBMP2Scr(x: integer; laynum:integer): integer;  overload;
    function myYBMP2Scr(y: integer; laynum:integer): integer;  overload;



    procedure SyncSetIsRunning;
    function GetIsRunning: boolean;

    function GetBrushTras(const x, y: integer; const tp: byte): byte;
    function GetBlendedTras(inttras: byte ): byte;


   
    procedure calculateaverageBGRA(x, y: integer);

    function GetSelectivityfactorHSL(BGRA: TbeBGRAbytearray): single; overload;

    procedure SetpeImageen(theimageen: Timageenview);
    procedure SetPeMode(theValue: TPeMode);

    procedure InitStatus;
    procedure InitCoords;
    procedure InitIEViewStatus;
    procedure InitBrush;
    procedure InitUtils;

    procedure FinalizeStatus;
    procedure FinalizeCoords;
    procedure FinalizeIEViewStatus;
    procedure FinalizeBrush;
    procedure FinalizeUtils;

    procedure CaptureImageEnDrawBackBuffer;
    procedure ReleaseImageEnDrawBackBuffer;

    procedure CaptureImageEnDrawCanvas;
    procedure ReleaseImageEnDrawCanvas;

    procedure ResetSession(const bForceNew: boolean);

    procedure ResetCoords;
    procedure ResetUtils;

    procedure ResetPointers;
    procedure ResetBuffer;
    procedure ResetBrush;
    procedure ResetBlending;
    procedure ResetSelectionMask;
    procedure ResetEditedRect;

    procedure CheckStillRunning;

    procedure AcquirePositions;

    procedure RefreshImageEn;
    procedure myUpdateRect(rc:Trect);


    procedure RefreshCursor;

    // procedure DoRefresh;
    procedure CheckAutoScroll;
    procedure FinalUpdate;
    procedure CheckThreadRunningRequisites;

    procedure _getShiftbyReadby(var shiftby, readby: integer;
      pf: tbepixelformat);
    function _averagepixel(pemap: tperowarray; j, i: integer;
      byteperpix: integer; convradius: integer): TbeBGRAbytearray;

    procedure Paint_onAlphaChannelNoBuffer(AlphaMap: TPeAlphaMap);
    procedure Paint_onAlphaChannelWithBuffer(AlphaMap: TPeAlphaMap);

    procedure Paint_EraseAlphaNoBuffer;
    procedure Paint_EraseAlphaWithBuffer;
    procedure Paint_AirbrushNoBuffer;
    procedure Paint_AirbrushWithBuffer;
    procedure Paint_TextureNobuffer;
    procedure Paint_TextureWithBuffer;
    procedure Paint_CloneNoBuffer(theAlphaMap: TPeAlphaMap);
    procedure Paint_CloneWithBuffer(theAlphaMap: TPeAlphaMap);
    procedure Paint_HistoryNoBuffer;
    procedure Paint_HistoryWithBuffer;
    procedure Paint_ConvolutionWithBuffer;
    procedure Paint_ConvolutionNoBuffer;
    procedure Paint_RetouchwithBuffer;
    procedure Paint_RetouchNoBuffer;
    procedure Paint_RetouchCustomwithBuffer;
    procedure Paint_RetouchCustomNoBuffer;
    procedure Paint_ObjectWithBuffer;
    // procedure Paint_ObjectNoBuffer;

    procedure Paint_DeformationWithBuffer;

    procedure DoPaint;

    procedure FireOnDebug;
    procedure FireOnFinishedPainting;
    procedure FireOnStartedPainting;
    procedure CalcRefreshRect(oldX,  oldY, newX, newY: integer; theUpdMode: TPEUpdateMode);
    procedure ResetRefreshRect;
    procedure ResetCursorRect;

    function GetTabletActive: boolean;

    procedure ResetTickCounts;
    procedure ResetRect(var theRect: TRect);
    function IsRectInitialized(theRect:Trect): boolean;
    function GetPriorityIndex: integer;
    procedure Handle_DrawBackBuffer(sender: TObject);
    procedure DrawLine(oldx, oldy, newx, newy: integer);
    procedure CalcCursorRect;
    function GetNewTranspbySelectivity(inttras:byte;x, y: integer): byte;

    procedure DisableIEStuff;
    procedure ReEnableIEStuff;

    procedure Finalize;
    procedure SetRunning(bValue: boolean);
    procedure LockIEUpDate;
    procedure UnLockIEUpDate;

    procedure RefreshCursorNP;
    procedure Handle_DrawCanvas(sender: TObject; cv: TCanvas; aRect: TRect);
    function myRectBMP2Scr(theRect: TRect): TRect;
    function ImageEnBgIsNormal(theImageEn:TImageEnView): boolean;
    procedure ResetIEViewStatus;

    procedure Brush_CalculateNew(bResize: boolean; bRotate: boolean);
    procedure Brush_DoSpray;
    procedure Brush_LoadFromBitmap(theBMP: TIEBitmap; TheRadius: integer);
    procedure Brush_Build1Pixel;
    procedure Brush_BuildRound(TheRadius: integer);
    procedure Brush_DefinePointers;
    procedure Brush_To8BitsBitmap(theBrushArray: tpeBrushArray; theBmp: TIEBitmap);
    procedure Bitmap8BitsToBrush(theBmp: TIEBitmap;
      var theBrushArray: tpeBrushArray);
    procedure Brush_Copy(theSrc: tpeBrushArray; var theDest: tpeBrushArray);
    function GetTabletDynamic_Opacity: byte;
    function GetTabletDynamic_Radius: byte;

    function _GetBrushRotateAngle: double;
    function CheckShowBrushNoPaint: boolean;



    procedure CleanUp;
  protected
    procedure synchronize(tm: TThreadMethod); reintroduce;
    procedure Execute; override;

  public

    procedure FireInfoChanged(Sender: TObject; bNewSession: boolean);

    constructor Create(const bRunTimeMode: boolean); reintroduce;
    destructor Destroy; override;
    procedure Init(theimageen: Timageenview); overload;
    procedure Init(theimageen: Timageenview; theMode: TPeMode); overload;
    procedure StartPainting(ForceNewSession: boolean);
    procedure StopPainting;


    procedure Terminate; reintroduce;

    property IsRunning: boolean read GetIsRunning;
    property Session: TPESession read fpeSession write fpeSession;

{$IFDEF USE_JANTAB}
    property PArams_Tablet: TPeTabletParams read fpeParams_Tablet
      write fpeParams_Tablet;
{$ENDIF}
    property Params_Paint: TpePaintPArams read fpeParams_Paint
      write fpeParams_Paint;
    property Params_Color: tPeColorParams read fpeParams_Color
      write fpeParams_Color;
    property Params_Texture: tPeTextureParams read fpeParams_Texture
      write fpeParams_Texture;
    property Params_History: tPeHistoryParams read fpeParams_History
      write fpeParams_History;

    property Params_Cloning: TpeCloningParams read fpeParams_Cloning
      write fpeParams_Cloning;
    property Params_Warp: TPeDeformationParams read fpeParams_Warp
      write fpeParams_Warp;
    property Params_Retouch: TPeRetouchParams read fpeParams_Retouch
      write fpeParams_Retouch;
    property Params_ObjectStamp: tPeObjectStampParams read fpeParams_ObjectStamp
      write fpeParams_ObjectStamp;

    property UpdateMode: TPEUpdateMode read fUpdateMode write fUpdateMode;
    property UpdatePriority: TPEUpdatePriority read fUpdatePriority write fUpdatePriority;

    property IEViewStatus: TPeImageEnStatus read fPeIEViewStatus;
    property EditedRect: Trect read fpeStatus.EditedRect;

    property Imageen: Timageenview read fpeImageen write SetpeImageen;

    property OnStartedPainting: TnotifyEvent read fpeOnStartedPainting
      write fpeOnStartedPainting;
    property OnPainting: tpeNotifyEvent read fpeOnPainting write fpeOnPainting;
    property OnFinishedPainting: TnotifyEvent read fpeOnFinishedPainting
      write fpeOnFinishedPainting;
    property OnDebugging: TnotifyEvent read fpeOnDebugging write fpeOnDebugging;
    property OnInfoChanged: tPeParamsChangedEvent read fpeOnInfoChanged
      write fpeOnInfoChanged;
    property OnSessionEvent: tPeParamsSessionEvent read fpeOnSessionEvent
      write fpeOnSessionEvent;
  //  property OnGetRadiusValue: tPeGetRadiusEvent read fOngetRadiusValue write fOngetRadiusValue;
  end;

implementation

uses NWSComps_IEPaintEngine_Const, NWSComps_IEPaintEngine_Reg;

type


  tconvmode = (cmBlur3, cmBlur5, cmSharpen3, cmSharpen5);

  tconvCoeffs = record
    convmatrix: array of array of integer;
    convdiv: integer;
    convradius: integer;
  end;

  tBGRAFunction = function(BGRA: TbeBGRAbytearray; readby, amount: integer)
    : TbeBGRAbytearray;

var
  convcoeffs: tconvCoeffs;
  BGRAFunction: tBGRAFunction;
  PEBitmaplocked: boolean = false;
  PECloneLocked: boolean = false;
  PEHistorylocked: boolean = false;
  PEBufferlocked: boolean = false;
  PEtextureLocked: boolean = false;
  PEBrushLocked: boolean = false;

procedure TImageEnPaintEngine.checkRegistration;
begin

  {$IFDEF NWSCOMPS_REGISTRATION_OK}
    exit;  //>>>>>>>EXIT IF REGISTRATION OK
  {$ENDIF}

    if random < 0.1 then
      messagedlg
        ('This is a Nag message of unregistered version of TImageEnPaintEngine, (C) 2005-2011 Francesco Savastano',
        mtinformation, [mbok], 0);
end;

function PEIsValidIEBmp(IEBMP: TIEbitmap): boolean;
begin
  result := (IEBMP.width > 0) and (IEBMP.height > 0);
end;

function Saturate(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  k, gray: integer;
begin

  gray := 0;
  for k := 0 to readby do
    gray := gray + BGRA[k];

  gray := gray div (readby + 1);

  for k := 0 to readby do
    result[k] :=
      max(0, min(255, BGRA[k] + round(amount * (BGRA[k] - gray) / 255)));

end;

function Desaturate(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  k, gray: integer;
begin
  gray := 0;
  for k := 0 to readby do
    gray := gray + BGRA[k];

  gray := gray div (readby + 1);

  for k := 0 to readby do
    result[k] :=
      max(0, min(255, BGRA[k] - round(amount * (BGRA[k] - gray) / 255)));
end;

function Lighten(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  k: integer;
begin
  for k := 0 to readby do
  begin
    result[k] := min(255, round(BE_Brightness(amount, BGRA[k], bmMidlights)));
  end;
end;

function Darken(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  k: integer;
begin
  for k := 0 to readby do
  begin
    result[k] := max(0, round(BE_Brightness(-amount, BGRA[k], bmMidlights)));
  end;
end;

function Dodge(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  lum: byte;
begin

  rgbtolum(BGRA[2], BGRA[1], BGRA[0], lum);
  LumRGBToLumRGB(BGRA[2], BGRA[1], BGRA[0], lum,
    min(255, lum + lum * amount div 255), result[2], result[1], result[0]);

end;

function Burn(BGRA: TbeBGRAbytearray; readby, amount: integer)
  : TbeBGRAbytearray;
var
  lum: byte;
begin

  rgbtolum(BGRA[2], BGRA[1], BGRA[0], lum);
  LumRGBToLumRGB(BGRA[2], BGRA[1], BGRA[0], lum,
    max(0, lum - (255 - lum) * amount div 255), result[2], result[1],
    result[0]);

end;

procedure GetRetouchFunction(theRetKind: TpeRetouchKind);
begin
  case theRetKind of
    rk_dodge:
      BGRAFunction := Dodge;
    rk_burn:
      BGRAFunction := Burn;
    rk_Lighten:
      BGRAFunction := Lighten;
    rk_Darken:
      BGRAFunction := Darken;
    rk_Saturate:
      BGRAFunction := Saturate;
    rk_DeSaturate:
      BGRAFunction := Desaturate;
  end;
end;

procedure getConvCoeffs(convmode: tconvmode);
var
  convsize: integer;
  r: integer;
begin
  case convmode of
    cmBlur3, cmSharpen3:
      convsize := 3;
    cmBlur5, cmSharpen5:
      convsize := 5;
  else
    convsize := 0;
  end;
  convcoeffs.convradius := trunc(convsize / 2);
  setlength(convcoeffs.convmatrix, convsize);
  for r := 0 to convsize - 1 do
    setlength(convcoeffs.convmatrix[r], convsize);

  with convcoeffs do
  begin
    case convmode of
      cmBlur3:
        begin
          // (1, 2, 1, 2, 20, 2, 1, 2, 1, 32); // ** blur
          convmatrix[0, 0] := 1;
          convmatrix[0, 1] := 2;
          convmatrix[0, 2] := 1;
          convmatrix[1, 0] := 2;
          convmatrix[1, 1] := 20;
          convmatrix[1, 2] := 2;
          convmatrix[2, 0] := 1;
          convmatrix[2, 1] := 2;
          convmatrix[2, 2] := 1;
          convdiv := 32;
        end;
      cmSharpen3:
        begin
          // (-1, -2, -1, -2, 28, -2, -1, -2, -1, 16); // ** sharpen
          convmatrix[0, 0] := -1;
          convmatrix[0, 1] := -2;
          convmatrix[0, 2] := -1;
          convmatrix[1, 0] := -2;
          convmatrix[1, 1] := 28;
          convmatrix[1, 2] := -2;
          convmatrix[2, 0] := -1;
          convmatrix[2, 1] := -2;
          convmatrix[2, 2] := -1;
          convdiv := 16;
        end;
      cmBlur5:
        begin
          // (1, 2, 4, 2, 1, 2, 4, 6, 4, 2, 4, 6, 8, 6, 4,2, 4, 6, 4, 2, 1, 2, 4, 2, 1, 84); // blur more
          convmatrix[0, 0] := 1;
          convmatrix[0, 1] := 2;
          convmatrix[0, 2] := 4;
          convmatrix[0, 3] := 2;
          convmatrix[0, 4] := 1;
          convmatrix[1, 0] := 2;
          convmatrix[1, 1] := 4;
          convmatrix[1, 2] := 6;
          convmatrix[1, 3] := 4;
          convmatrix[1, 4] := 2;
          convmatrix[2, 0] := 4;
          convmatrix[2, 1] := 6;
          convmatrix[2, 2] := 8;
          convmatrix[2, 3] := 6;
          convmatrix[2, 4] := 4;
          convmatrix[3, 0] := 2;
          convmatrix[3, 1] := 4;
          convmatrix[3, 2] := 6;
          convmatrix[3, 3] := 4;
          convmatrix[3, 4] := 2;
          convmatrix[4, 0] := 1;
          convmatrix[4, 1] := 2;
          convmatrix[4, 2] := 4;
          convmatrix[4, 3] := 2;
          convmatrix[4, 4] := 1;
          convdiv := 84;
        end;
      cmSharpen5:
        begin
        end;
    end;
  end;
end;

procedure TImageEnPaintEngine.InitStatus;
begin
  fpeNotRunningstatus.Flag_InsideImageEn := false;

  fpeStatus.HasRunningRequisites := false;
  fpeStatus.Buffer := TIEbitmap.Create;
  fpeStatus.Buffer.pixelformat := ie24RGB;
  setlength(fpeStatus.Buffermap, 0);

  fpeStatus.Buffer_Sel := TIEbitmap.Create;
  fpeStatus.Buffer_Sel.pixelformat := ie24RGB;

  fpeStatus.EditedRect := rect(0, 0, 0, 0);
  fpeStatus.UseBuffer := false;
  fpeStatus.UseBuffer_Deform := false;
  fpeStatus.UseBuffer_Selectivity := false;
end;

procedure TImageEnPaintEngine.InitCoords;
begin
  fpeCoords.CurX := 0;
  fpeCoords.CurY := 0;
  fpeCoords.memx := 0;
  fpeCoords.memy := 0;
  fpeCoords.mem1x := 0;
  fpeCoords.mem1y := 0;
  fpeCoords.mem2x := 0;
  fpeCoords.mem2y := 0;

  fpeCoords.mouse_x := 0;
  fpeCoords.mouse_y := 0;
end;

procedure TImageEnPaintEngine.InitIEViewStatus;
begin
  fPeIEViewStatus.ZoomF := 1;
  fPeIEViewStatus.PixelFmt := bepfother;
  fPeIEViewStatus.SelMask := nil;
  fPeIEViewStatus.LayerCount := 0;
end;

procedure TImageEnPaintEngine.InitBrush;
begin
  setlength(fpeBrushStatus.BrushArray, 0);
  setlength(fpeBrushStatus.BrushArray_Fixed, 0);

  fpeBrushStatus.OffSetX := 0;
  fpeBrushStatus.OffSetY := 0;
end;

procedure TImageEnPaintEngine.InitUtils;
begin

  fpeUtils.AverageBGRA[0] := 0;
  fpeUtils.AverageBGRA[1] := 0;
  fpeUtils.AverageBGRA[2] := 0;
  fpeUtils.AverageBGRA[3] := 0;
  fpeUtils.AverageBGRAsat := 0;
  fpeUtils.AverageBGRAhue := 0;
  fpeUtils.AverageBGRAlum := 0;
end;

constructor TImageEnPaintEngine.Create(const bRunTimeMode: boolean);
begin
  inherited Create(false);
  fCSTerminate := TCriticalSection.Create;
  RegisterExpectedMemoryLeak(fCSTerminate);

  Priority := tpNormal;
  FreeOnTerminate := false;

  fImageEnGUI := StringToGUID('{00000000-0000-0000-0000-000000000000}');
  fPeCursorList := TObjectList.Create;
  fPECursorCloneList := TObjectList.Create;

  fRunTimeMode := bRunTimeMode;
  fHoldsDrawBackBuffer := false;
  fHoldsDrawCanvas := false;

  fpeSession := TPESession.Create;

  fpeSession.New := true;

  fPeIsRunning := false;
  fPeIsRunningSynch := false;



  fPeGoEvent := TSimpleEvent.Create;
  fpeBe := TpeBitmapEditor.Create(nil);
  fProc := TImageEnProc.create(nil);
  fProc.AutoUndo := false;

{$IFDEF USE_JANTAB}
  fpeParams_Tablet := TPeTabletParams.Create;
{$ENDIF}
  fpeParams_Paint := TpePaintPArams.Create;
  fpeParams_Paint.OnChanged := HandleInfoChanged;

  fpeParams_Color := tPeColorParams.Create;
  fpeParams_Color.OnChanged := HandleInfoChanged;
  fpeParams_Texture := tPeTextureParams.Create;
  fpeParams_Texture.OnChanged := HandleInfoChanged;
  fpeParams_History := tPeHistoryParams.Create;
  fpeParams_History.OnChanged := HandleInfoChanged;

  fpeParams_Cloning := TpeCloningParams.Create;
  fpeParams_Cloning.OnChanged := HandleInfoChanged;
  fpeParams_Warp := TPeDeformationParams.Create;
  fpeParams_Warp.OnChanged := HandleInfoChanged;
  fpeParams_Retouch := TPeRetouchParams.Create;
  fpeParams_Retouch.OnChanged := HandleInfoChanged;


  InitCoords;
  InitUtils;
  InitStatus;
  InitIEViewStatus;
  InitBrush;

  fUpdateMode := umEachStroke;
  fUpdatePriority := upHigh;

  fpeBitmap := nil;
  fpeImageen := nil;

  fpeOnPainting := nil;


  setlength(pBrush, 0);
  setlength(pDest, 0);
  setlength(pDestAlpha, 0);
  setlength(pBuf, 0);
  setlength(pBufAlpha, 0);

  setlength(pBuf_sel, 0);
  setlength(pCloneBuf, 0);
  setlength(pCloneAlphaBuf, 0);

end;



procedure TImageEnPaintEngine.FinalizeUtils;
begin
  setlength(fpeBrushStatus.BrushArray, 0);
  setlength(fpeBrushStatus.BrushArray_Fixed, 0);
end;

procedure TImageEnPaintEngine.FinalizeStatus;
begin

  setlength(fpeStatus.Buffermap, 0);
  fpeStatus.Buffer.free;
  fpeStatus.Buffer_Sel.free;
end;

procedure TImageEnPaintEngine.FinalizeCoords;
begin

end;

procedure TImageEnPaintEngine.FinalizeIEViewStatus;
begin
  fPeIEViewStatus.SelMask := nil;
end;

procedure TImageEnPaintEngine.FinalizeBrush;
begin

end;

procedure TImageenPaintEngine.Finalize;
begin
  FinalizeStatus;
  FinalizeCoords;
  FinalizeIEViewStatus;
  FinalizeBrush;
  FinalizeUtils;
  fPeCursorList.free;
  fPECursorCloneList.Free;
  setlength(pBrush, 0);
  setlength(pDest, 0);
  setlength(pDestAlpha, 0);
  setlength(pCloneBuf, 0);
  setlength(pCloneAlphaBuf, 0);

  setlength(pBuf, 0);
  setlength(pBufAlpha, 0);
  setlength(pBuf_Sel, 0);

  fpeParams_Tablet.free;
  fpeParams_Color.free;
  fpeParams_Texture.free;
  fpeParams_History.free;
  fpeParams_Cloning.free;
  fpeParams_Warp.free;
  fpeParams_Retouch.free;

  fpeParams_Paint.free;
  fpeBe.free;
  fProc.free;
  fpeSession.free;

  fPeGoEvent.free;

end;

destructor TImageEnPaintEngine.Destroy;
begin

   //Synchronize(Finalize);
   Finalize;

     
  inherited;
end;

procedure TImageEnPaintEngine.CleanUp;
begin

  fpeParams_Paint.ShowBrushWhenNotRunning := false;


end;



procedure TImageEnPaintEngine.SetpeImageen(theimageen: Timageenview);
begin

  if fpeImageen <> theimageen then
    fpeSession.New := true;


  fpeImageen := theimageen;
  fpeBitmap := fpeImageen.IEBitmap;


  fPeIEViewStatus.PixelFmt := bepfother;
  BE_Getpixelformat(fPeIEViewStatus.PixelFmt, fpeBitmap);
  if fPeIEViewStatus.PixelFmt = bepfother then
    raise Exception.Create('Pixel Format not supported');


end;

procedure TImageEnPaintEngine.SetPeMode(theValue: TPeMode);
begin
  if fpeParams_Paint.Mode <> theValue then
    fpeSession.New := true;

  fpeParams_Paint.Mode := theValue;
end;

function TImageEnPaintEngine.myXScr2BMP(x: integer): integer;
begin
  // result:=  fpeImageen.XScr2Bmp(x)-fpeImageen.Layers[fpeImageen.layerscurrent].PosX;
  with fpeImageen do
    result := trunc((XScr2Bmp(x) - Layers[fpeImageen.layerscurrent].PosX) *
      IEBitmap.width / Layers[fpeImageen.layerscurrent].width);
end;

function TImageEnPaintEngine.myYScr2BMP(y: integer): integer;
begin
  // result:=  fpeImageen.YScr2Bmp(y)-fpeImageen.Layers[fpeImageen.layerscurrent].PosY;
  with fpeImageen do
    result := trunc((YScr2Bmp(y) - Layers[fpeImageen.layerscurrent].PosY) *
      IEBitmap.height / Layers[fpeImageen.layerscurrent].height);
end;

function TImageEnPaintEngine.myXBMP2Scr(x: integer): integer;
begin

  result := myXBMP2Scr(x, fpeImageen.layerscurrent);
end;

function TImageEnPaintEngine.myYBMP2Scr(y: integer): integer;
begin
  result := myYBMP2Scr(y, fpeImageen.layerscurrent);
end;

function TImageEnPaintEngine.myRectBMP2Scr(theRect: TRect): TRect;
begin
  result := rect(myXBMP2Scr(theRect.left), myYBMP2Scr(theRect.Top), myXBMP2Scr(theRect.right), myYBMP2Scr(theRect.Bottom));
end;

function TImageEnPaintEngine.myXBMP2Scr(x: integer; laynum:integer): integer;
begin
  with fpeImageen do
    result := XBMP2scr(trunc(x * Layers[laynum].width /
      Layers[laynum].Bitmap.width) + Layers[laynum].PosX);
end;

function TImageEnPaintEngine.myYBMP2Scr(y: integer; laynum:integer): integer;
begin
  // result:= fpeImageen.YBMP2Scr(fpeImageen.Layers[fpeImageen.layerscurrent].PosY+y);
  with fpeImageen do
    result := YBMP2scr(trunc(y * Layers[laynum].height /
      Layers[laynum].Bitmap.height) + Layers[laynum].PosY);
end;



procedure TImageEnPaintEngine.FireInfoChanged(Sender: TObject;
  bNewSession: boolean);
begin
  if bNewSession then
    fpeSession.New := true;

  if Sender is TPeTabletParams then
  begin
    fpeParams_Tablet.Assign(TPeTabletParams(Sender));
  end
  else if Sender is TpePaintPArams then
  begin
    fpeParams_Paint.Assign(TpePaintPArams(Sender));
  end
  else if Sender is TpeCloningParams then
  begin
    fpeParams_Cloning.Assign(TpeCloningParams(Sender));
  end
  else if Sender is TPeDeformationParams then
  begin
    fpeParams_Warp.Assign(TPeDeformationParams(Sender));
  end
  else if Sender is TPeRetouchParams then
  begin
    fpeParams_Retouch.Assign(TPeRetouchParams(Sender));
  end;
end;

procedure TImageEnPaintEngine.HandleInfoChanged(Sender: TObject;
  nsRequest: tpeNewSessionRequest);
begin
  if IsRunning then
    EXIT;

  assert(Sender is tPeCustomParams);

  case nsRequest of
    ns_Needed:
      fpeSession.New := true;
    ns_AskUser:
      ;
  end;

  if assigned(fpeOnSessionEvent) then
  begin
    fpeOnSessionEvent(tPeCustomParams(Sender), fpeSession);
  end;

end;






procedure TImageEnPaintEngine.CalcTranspTable;
var
i: integer;
begin
  for i := 0 to 255 do
    TranspTable[i] := GetBlendedTras(i);
end;


function TImageEnPaintEngine.GetTabletPressure: byte;
begin
  result := 255;

{$IFDEF USE_JANTAB}
  if fpeParams_Tablet.PressureSensitive and assigned(fpeParams_Tablet.Tablet)
    and fpeParams_Tablet.Tablet.active and fpeParams_Tablet.Tablet.InProximity
  then
  begin

    sleep(0); // Added in order to process tablet messages

    case fpeParams_Tablet.PressureMode of
      pmLinear:
        begin
          result := round(min(1, fpeParams_Tablet.Tablet.CurrentPacket.pkPressure /
            (200 + fpeParams_Tablet.PressureVar)) * 255);
        end;
      pmUnlinear:
        begin
          result := round(min(1,
            power(fpeParams_Tablet.Tablet.CurrentPacket.pkPressure /
            (200 + fpeParams_Tablet.PressureVar),
            1 + 0.5 * fpeParams_Tablet.PressureUnlinearStrength / 100)) * 255);
        end;
    end;

    sleep(0); // Added in order to process tablet messages
    // Pressure.axUnits/100
  end
  else
    result := 255;
{$ENDIF}
end;

function TImageEnPaintEngine.GetTabletDynamic_Opacity: byte;
begin
  if pdBrushOpacity in fpeParams_Tablet.PressureDynamics then
    result := GetTabletPressure
  else
    result := 255;
end;

function TImageEnPaintEngine.GetTabletDynamic_Radius: byte;
begin
  if pdBrushRadius in fpeParams_Tablet.PressureDynamics then
    result := GetTabletPressure
  else
    result := 255;
end;

function TImageEnPaintEngine.GetTabletActive: boolean;
begin
    result := false;

{$IFDEF USE_JANTAB}
  if assigned(fpeParams_Tablet.Tablet)
    and fpeParams_Tablet.Tablet.active and fpeParams_Tablet.Tablet.InProximity
  then
  begin
    result := true;
  end;
{$ENDIF}
end;

function TImageEnPaintEngine.GetIsRunning: boolean;
begin
  result := fPeIsRunningSynch;
end;

procedure TImageEnPaintEngine.SyncSetIsRunning;
begin
  fPeIsRunningSynch := fPeIsRunning;


end;

procedure TImageEnPaintEngine.Terminate;
begin

  fCSTerminate.Enter;
  try
     CleanUp;
     inherited Terminate;
  finally
     fCSTerminate.Leave;
  end;

end;

procedure TImageEnPaintEngine.SetRunning(bValue: boolean);
begin
  fPeIsRunning := bValue;
  SyncSetIsRunning;
end;

function TImageEnPaintEngine.GetBrushTras(const x, y: integer;
  const tp: byte): byte;
begin
  result := pBrush[fpeBrushStatus.OffSetY + y - fpeStatus.yret1,
    fpeBrushStatus.OffSetX + x - fpeStatus.xret1];


  // Tablet Pressure
  result := round(255 - ((255 - result) * tp) div 255);


end;

function TImageEnPaintEngine.GetBlendedTras(inttras: byte): byte;
var
  opnew, op, opbase: byte;
begin

  op := 255 - inttras;
  opbase := 255 - fpeParams_Paint.Transparence;
  opnew := (op * opbase) div 255;
  result := 255 - opnew;
  { result := inttras; }
end;







procedure TImageEnPaintEngine.CalcPaintToAlphaTable;
var
  i, j: integer;
  newPaintTransp, np1, np2: byte;
begin
  // i=inttras
  // j= alphachan
  for i := 0 to 255 do
  begin

    for j := 0 to 255 do
    begin
      newPaintTransp := min(255, round(
                                        (1.00
                                         + power((255 - j)/25000, 0.45 + 0.6 * j/255)
                                         )
                                         * i
                                         )
                                     );
      if fpestatus.UseBuffer then
      begin
        PaintToAlphaTable[i, j] := newPaintTransp;

        BlendToAlphaTable[i,j] := max(0, i - (newPaintTransp - i));
      end
      else
      begin
        np1 := round(newPaintTransp * 0.88 + 0.12 * i);
        np2 := round(newPaintTransp * 0.8 + 0.2 * i);

       // np2 := newpainttransp;
        PaintToAlphaTable[i, j] := np1;

        BlendToAlphaTable[i,j] := max(0, i - (np2 - i));
      end;

    end;
  end;
end;


procedure TImageEnPaintEngine.calculateaverageBGRA(x, y: integer);
var
  x1, y1, x2, y2: integer;
  i, j, k: integer;
  pb: pbebytearray;
  readby, shiftby: integer;
  tempx: integer;
  sumBGRA: TbeBGRAint64array;
  Npixels: integer;

  r:integer;
begin
  if not assigned(fpeBitmap) then
    EXIT;

  if fPeIEViewStatus.PixelFmt = bepfother then
    EXIT;

  _getShiftbyReadby(shiftby, readby, fPeIEViewStatus.PixelFmt);

  r := max(0, round(0.2 *fpeBrushStatus.PaintRadius));

  x1 := max(0, x - r);
  y1 := max(0, y - r);
  x2 := min(fPeIEViewStatus.BitmapW - 1, x + r);
  y2 := min(fPeIEViewStatus.BitmapH - 1, y + r);

  sumBGRA[0] := 0;
  sumBGRA[1] := 0;
  sumBGRA[2] := 0;
  sumBGRA[3] := 0;

  fpeUtils.AverageBGRA[0] := 0;
  fpeUtils.AverageBGRA[1] := 0;
  fpeUtils.AverageBGRA[2] := 0;
  fpeUtils.AverageBGRA[3] := 0;


  for j := y1 to y2 do
  begin
    pb := fpeBitmap.scanline[j];
    for i := x1 to x2 do
    begin
      tempx := shiftby * i;
      for k := 0 to readby do
        sumBGRA[k] := sumBGRA[k] + pb[tempx + k];
    end;
  end;

  Npixels := (y2 - y1 + 1) * (x2 - x1 + 1);
  if NPixels <= 1 then  //radius = 0
  begin
    for k := 0 to readby do
      fpeUtils.AverageBGRA[k] := sumBGRA[k];
  end
  else
  begin

    for k := 0 to readby do
      fpeUtils.AverageBGRA[k] := min(255, sumBGRA[k] div Npixels);

  end;

  rgb2hls(fpeUtils.AverageBGRA[2] / 255, fpeUtils.AverageBGRA[1] / 255,
    fpeUtils.AverageBGRA[0] / 255, fpeUtils.AverageBGRAhue,
    fpeUtils.AverageBGRAsat, fpeUtils.AverageBGRAlum);
 // showmessage(floattostr(fpeUtils.AverageBGRAhue));
end;



function TImageEnPaintEngine.GetSelectivityfactorHSL
  (BGRA: TbeBGRAbytearray): single;
var
  h, l, s, delta: single;
begin

  rgb2hls(BGRA[2] / 255, BGRA[1] / 255, BGRA[0] / 255, h, l, s);

  if abs(h - fpeUtils.AverageBGRAhue) < 180 then
    delta := abs(h - fpeUtils.AverageBGRAhue) / 180
  else
    delta := (360 - abs(h - fpeUtils.AverageBGRAhue)) / 180;

  delta := 0.4 * delta + 0.4 * abs(s - fpeUtils.AverageBGRAsat) + 0.2 *
    abs(l - fpeUtils.AverageBGRAlum);
  result := delta;

end;
(**)

function TImageEnPaintEngine.GetNewTranspbySelectivity(inttras:byte; x,y:integer): byte;
var
maxDiff, diff: integer;
//sumDiff, avgDiff: integer;
k:integer;
f:single;
BGRA:TbeBGRAbytearray;
begin

 // sumDiff := 0;
  maxDiff := 0;
  for k := 0 to fPeIEViewStatus.ReadBy do
  begin
    BGRA[k] := pbuf_sel[y,x+k];
    diff := abs(bgra[k] - fpeUtils.AverageBGRA[k]);
    maxDiff := max(maxDiff, diff);
   // sumDiff := sumDiff + diff;
  end;

 // avgDiff := (sumDiff div fPeIEViewStatus.shiftby);
//  showmessage(inttostr(avgdiff));
  if fpeParams_Paint.SelTolerance=0 then
  begin
    if maxDiff > 0 then
      result := 255
    else
      result := inttras;
  end
  else
  begin
    //implement auto-learn
    if maxDiff > fpeParams_Paint.SelTolerance then
    begin
      result := 255;
    end
    else
    begin
      f := (fpeParams_Paint.SelTolerance - maxDiff)  / fpeParams_Paint.SelTolerance;
      result := round(255 * (1-f) + inttras * f);
    end;
  end;

end;

procedure TImageEnPaintEngine.Init(theimageen: Timageenview; theMode: TPeMode);
begin
  SetpeImageen(theimageen);
  SetPeMode(theMode);

end;

procedure TImageEnPaintEngine.Init(theimageen: Timageenview);
begin
  SetpeImageen(theimageen);
end;

procedure TImageEnPaintEngine.StartPainting(ForceNewSession: boolean);
begin
  if fPeIsRunning then
    EXIT;

  synchronize(CheckThreadRunningRequisites);

  if not fpeStatus.HasRunningRequisites then
    EXIT; // >>> EXIT

  // -----------------------------------
  ResetSession(ForceNewSession or
               (fpeImageen.Layers[fpeImageen.LayersCurrent].Guid <> fImageEnGUI) or
              (fpeParams_Paint.SessionMode <> sm_KeepSessionMemory_UntilManualReset));
  // -----------------------------------
  fImageEnGUI := fpeImageen.Layers[fpeImageen.LayersCurrent].Guid;
  /// //////////////  Other Initialization
  synchronize(ResetPointers);
  synchronize(ResetBrush);
  synchronize(ResetBlending);
  synchronize(ResetSelectionMask);
  synchronize(ResetEditedRect);
  /// //////////////

  // -----------------------------------
  fPeGoEvent.SetEvent; // Give the go
  // -----------------------------------

end;

procedure TImageEnPaintEngine.StopPainting;
begin
  fPeGoEvent.ResetEvent

end;

procedure TImageEnPaintEngine.synchronize(tm: TThreadMethod);
begin
  if Terminated then
  begin
    sleep(0);
    EXIT;
  end;
  inherited;

end;

procedure TImageEnPaintEngine.ResetSession(const bForceNew: boolean);
begin

  fpeSession.New := fpeSession.New or bForceNew;
  if fpeParams_Paint.Mode = pemDeformations then
  begin
    fpeSession.New := true;
    fpeStatus.UseBuffer := false;
    fpeStatus.UseBuffer_Deform := true;
    fpeStatus.UseBuffer_Selectivity := false;
  end
  else
  begin

    fpeStatus.UseBuffer := fpeParams_Paint.SessionMode <> sm_IgnoreSessionMemory;  // fpeParams_Paint.PaintOnlyOnce;
    fpeStatus.UseBuffer_Deform := false;
    fpeStatus.UseBuffer_Selectivity := fpeParams_Paint.Selective;
  end;

  synchronize(ResetIEViewStatus); // this must go before all the other resets!
  synchronize(ResetCoords); // read mouse position..
  synchronize(ResetUtils);
  synchronize(ResetBuffer);
  fpeParams_Warp.CurrentStep := 0;
end;



procedure TImageEnPaintEngine.ResetIEViewStatus;
begin
  //reset view status
  with fPeIEViewStatus do
  begin
    BgIsNormal := ImageEnBgIsNormal(fpeImageEn);
    ZoomFilter := fpeImageen.ZoomFilter;
    ZoomF := fpeImageen.zoom / 100;
    Scrx := round(fpeImageen.viewx / fPeIEViewStatus.ZoomF);
    Scry := round(fpeImageen.viewy / fPeIEViewStatus.ZoomF);

    if assigned(fpeBitmap) then
    begin
      PixelFmt := bepfother;
      BE_Getpixelformat(PixelFmt, fpeBitmap);
      _getShiftbyReadby(ShiftBy, Readby, PixelFmt);
      BitmapW := fpeBitmap.width;
      BitmapH := fpeBitmap.height;
      LayerW := fpeImageen.Layers[fpeImageen.layerscurrent].width;
      LayerH := fpeImageen.Layers[fpeImageen.layerscurrent].height;
      LayerX := fpeImageen.Layers[fpeImageen.layerscurrent].PosX;
      LayerY := fpeImageen.Layers[fpeImageen.layerscurrent].PosY;
      LayerhasAlpha := fpeImageen.IEBitmap.HasAlphaChannel;

    end;
    LayerCount := fpeImageen.LayersCount;
  end;
end;

procedure TImageEnPaintEngine.ResetCoords;
begin
  //reset coords
  fpeCoords.mouse_x := fpeImageen.screentoclient(mouse.CursorPos).x ;
  fpeCoords.mouse_y := fpeImageen.screentoclient(mouse.CursorPos).y;

  fpeCoords.CurX := myXScr2BMP(fpeCoords.mouse_x);
  fpeCoords.CurY := myYScr2BMP(fpeCoords.mouse_y);

  // copy position in 3 different couples of variables
  fpeCoords.memx := fpeCoords.CurX;
  fpeCoords.memy := fpeCoords.CurY;
  fpeCoords.mem1x := fpeCoords.CurX;
  fpeCoords.mem1y := fpeCoords.CurY;
  fpeCoords.mem2x := fpeCoords.CurX;
  fpeCoords.mem2y := fpeCoords.CurY;

  setlength(fpeCoords.ret_array, 100);
  fpeCoords.ret_counter := 0;
  fpeCoords.ret_idx := -1;
end;



procedure TImageEnPaintEngine.ResetUtils;
begin
  with fpeUtils do
  begin
    if assigned(fpeParams_Texture.TextureBitmap) then
    begin
      TextureW := fpeParams_Texture.TextureBitmap.width;
      TextureH := fpeParams_Texture.TextureBitmap.height;
    end;
    if assigned(fpeParams_Cloning.SrcIeBitmap) then
    begin
      CloneW := fpeParams_Cloning.SrcIeBitmap.width;
      CloneH := fpeParams_Cloning.SrcIeBitmap.height;
    end;
    if assigned(fpeParams_History.HistoryBitmap) then
    begin
      HistoryW := fpeParams_History.HistoryBitmap.width;
      HistoryH := fpeParams_History.HistoryBitmap.height;
      HistoryHasAlphaChannel := fpeParams_History.HistoryBitmap.HasAlphaChannel;
    end;
  end;

  case fpeParams_Retouch.Kind of
    rk_blur:
      getConvCoeffs(cmBlur5);
    rk_Sharpen:
      getConvCoeffs(cmSharpen3);
  else
    GetRetouchFunction(fpeParams_Retouch.Kind);
  end;

  if fpeParams_Paint.Selective then
    calculateaverageBGRA(fpeCoords.CurX, fpeCoords.CurY);
end;

procedure TImageEnPaintEngine.ResetPointers;
var
  j: integer;
begin

  // Now prepare the array of pointers  for fast access of the fpeBitmap pixels
  setlength(pDest, fpeBitmap.height);
  for j := 0 to fpeBitmap.height - 1 do
    pDest[j] := fpeBitmap.scanline[j];

  if fpeBitmap.HasAlphaChannel then
  begin
    setlength(pDestAlpha, fpeBitmap.AlphaChannel.height);
    for j := 0 to fpeBitmap.AlphaChannel.height - 1 do
      pDestAlpha[j] := fpeBitmap.AlphaChannel.scanline[j];
  end;

  if assigned(fpeParams_Cloning.SrcIeBitmap) then
  begin
    setlength(pCloneBuf, fpeParams_Cloning.SrcIeBitmap.height);
    for j := 0 to fpeParams_Cloning.SrcIeBitmap.height - 1 do
      pCloneBuf[j] := fpeParams_Cloning.SrcIeBitmap.scanline[j];

    if (fpeParams_Cloning.SrcIeBitmap.HasAlphaChannel) then
    begin
       setlength(pCloneAlphaBuf, fpeParams_Cloning.SrcIeBitmap.height);
       for j := 0 to fpeParams_Cloning.SrcIeBitmap.height - 1 do
         pCloneAlphaBuf[j] := fpeParams_Cloning.SrcIeBitmap.AlphaChannel.scanline[j];
    end;
  end;

  if assigned(fpeStatus.Buffer) then
  begin
    setlength(pBuf, fpeStatus.Buffer.height);
    for j := 0 to fpeStatus.Buffer.height - 1 do
      pBuf[j] := fpeStatus.Buffer.scanline[j];

    if fpeStatus.Buffer.HasAlphaChannel then
    begin
      setlength(pBufAlpha, fpeStatus.Buffer.height);
      for j := 0 to fpeStatus.Buffer.height - 1 do
        pBufAlpha[j] := fpeStatus.Buffer.Alphachannel.scanline[j];
    end;
  end;

  if assigned(fpeStatus.Buffer_sel) then
  begin
    setlength(pBuf_sel, fpeStatus.Buffer_sel.height);

    for j := 0 to fpeStatus.Buffer_sel.height - 1 do
      pBuf_sel[j] := fpeStatus.Buffer_sel.scanline[j];
  end;
end;

procedure TImageEnPaintEngine.ResetBuffer;
var
  i, j: integer;
begin
  if fpeSession.New then
  begin
    setlength(fpeStatus.Buffermap, 0, 0);
    fpeStatus.Buffermap := nil;
  end;

  if fpeStatus.UseBuffer then
  begin
    if fpeStatus.Buffermap = nil then
    begin
      fpeStatus.Buffer.Assign(fpeBitmap);
      setlength(fpeStatus.Buffermap, fpeBitmap.width, fpeBitmap.height);

      for i := 0 to fpeBitmap.width - 1 do
      begin
        for j := 0 to fpeBitmap.height - 1 do
        begin
          fpeStatus.Buffermap[i, j].RGB := false;
          fpeStatus.Buffermap[i, j].alpha := false;
        end;
      end;

    end;
  end
  else if (fpeStatus.UseBuffer_Deform) then
  begin
    fpeStatus.Buffer.Assign(fpeBitmap);
  end;

  if(fpeStatus.UseBuffer_Selectivity) then
  begin
    fpeStatus.Buffer_Sel.Assign(fpeBitmap);
  end
  else
  begin
    fpeStatus.Buffer_Sel.width := 0;
    fpeStatus.Buffer_Sel.height := 0;
  end;

end;


procedure TImageEnPaintEngine.Brush_To8BitsBitmap(theBrushArray: tpeBrushArray; theBmp: TIEBitmap);
var
  i,j: integer;
  pb: pbyte;
begin
  theBmp.PixelFormat := ie8g;
  theBmp.width := length(theBrushArray);
  theBmp.height := length(theBrushArray);

      for j := 0 to theBmp.height - 1 do
      begin
        pb := theBmp.scanline[j];
        for i := 0 to theBmp.width - 1 do
        begin
          pb^:= theBrushArray[j, i];
          inc(pb);
        end;
      end;
end;


procedure TImageEnPaintEngine.Bitmap8BitsToBrush(theBmp: TIEBitmap; var theBrushArray: tpeBrushArray);
var
  i,j: integer;
  pb: pbyte;
begin
  assert(theBmp.PixelFormat = ie8g);

  setlength(theBrushArray, theBmp.height);
    for j := 0 to high(theBrushArray) do
      setlength(theBrushArray[j], theBmp.width);

      for j := 0 to theBmp.height - 1 do
      begin
        pb := theBmp.scanline[j];
        for i := 0 to theBmp.width - 1 do
        begin
          theBrushArray[j, i] := pb^;
          inc(pb);
        end;
      end;
end;

 procedure TImageEnPaintEngine.Brush_Copy(theSrc: tpeBrushArray; var theDest: tpeBrushArray);
 var
 i,j:integer;
 temp: byte;
 begin
    setlength(theDest, length(theSrc));
    for j := 0 to high(theDest) do
      setlength(theDest[j], length(theSrc[j]));
    for i := 0 to High(theDest) do
      for j := 0 to High(theDest[0]) do
      begin
        temp := theSrc[i, j];
        theDest[i, j] := temp;
      end;
 end;

procedure TImageEnPaintEngine.Brush_CalculateNew(bResize: boolean;
                                                 bRotate: boolean);
var
tempBmp: TIEBitmap;
tp: byte;
newRadius: integer;
begin

  if (not bResize) and (not bRotate) then EXIT;   //nothing to do EXIT

  newRadius := fpeBrushStatus.PaintRadiusFixed;
  if bResize then
  begin
    tp := GetTabletDynamic_Radius;
    newRadius := round((fpeBrushStatus.PaintRadiusFixed div 2) * (1 + tp/255));  //get new radius from pressure


    if newRadius = 0 then
    begin
      Brush_Build1Pixel;
      exit;
    end;
  end;

  tempBmp := TIEBitmap.Create;
  try
    if bResize then
    begin
      Brush_To8BitsBitmap(fpeBrushStatus.BrushArray_Fixed, tempbmp);
      tempbmp.PixelFormat := ie24RGB;

      fProc.AutoUndo := false;
      fProc.AttachedIEBitmap := tempbmp;
      fProc.Resample(2 * newRadius, 2 * newRadius, rfFastLinear);

      Brush_LoadFromBitmap(tempbmp, newRadius);
    end;
    if bRotate then
    begin
      if not bResize then
      begin
        Brush_To8BitsBitmap(fpeBrushStatus.BrushArray_Fixed, tempbmp);
        tempbmp.PixelFormat := ie24RGB;
      end;

      fproc.AttachedIEBitmap := tempBmp;
      fproc.Rotate(-_GetBrushRotateAngle * 360, ierfast, clwhite);

      if (tempBmp.Width <> tempbmp.height) then
        fproc.Resample(min(tempbmp.width, tempbmp.height), min(tempbmp.width, tempbmp.height), rffastlinear);

      Brush_LoadFromBitmap(tempbmp, tempBmp.Width div 2);
    end;
  finally
     tempBmp.Free;
  end;


  Brush_DoSpray;

end;

procedure TIMageenPaintengine.Brush_DoSpray;
var
  I,J: Integer;
  newValue: byte;
  rnd:integer;
begin
  if fpeParams_Paint.SprayEffect=0 then Exit;
   
   randomize;

   for j := Low(fpeBrushStatus.BrushArray) to High(fpeBrushStatus.BrushArray) do
   begin
     for i := Low(fpeBrushStatus.BrushArray[j]) to High(fpeBrushStatus.BrushArray[j]) do
     begin

       rnd := Random(1500);
       newValue := min(pBrush[j,i]+rnd, 255);
       pBrush[j,i] :=  round(fpeParams_Paint.SprayEffect/100 * newValue
                              + (100 - fpeParams_Paint.SprayEffect)/100 * pBrush[j,i]);
     end;
   end;
end;

function TImageenPaintEngine._GetBrushRotateAngle: double;
begin
    result := 0;
  if fpeCoords.memy = fpeCoords.mem1y then
  begin
    if fpeCoords.memx > fpeCoords.mem1x then
      result := pi / 2;
    if fpeCoords.memx < fpeCoords.mem1x then
      result := 3 * pi / 2;
  end
  else
  begin
    if abs(fpeCoords.memx - fpeCoords.mem1x) > 0 then
    begin
      result := arctan(abs(fpeCoords.memy - fpeCoords.mem1y) /
        abs(fpeCoords.memx - fpeCoords.mem1x));
      if fpeCoords.memx > fpeCoords.mem1x then
      begin
        if fpeCoords.memy > fpeCoords.mem1y then
          result := pi / 2 - result
        else
          result := pi / 2 + result;
      end
      else
      begin
        if fpeCoords.memy > fpeCoords.mem1y then
          result := 3 / 2 * pi + result
        else
          result := 3 / 2 * pi - result;
      end;
    end
    else
    begin
      if fpeCoords.memy > fpeCoords.mem1y then
        result := 0
      else
        result := pi;
    end;
  end;
end;


procedure TImageEnPaintEngine.Brush_LoadFromBitmap(theBMP: TIEBitmap; TheRadius: integer);
  var
    i, j, k: integer;
    gray: integer;
    shiftby, readby: integer;
    pp: pbebytearray;
    tempx: integer;
    w, h: integer;
  begin
    fpeBrushStatus.PaintRadius := theRadius;
    fpeBrushStatus.BrushArray := nil;

    setlength(fpeBrushStatus.BrushArray, 2 * TheRadius);
    for j := 0 to high(fpeBrushStatus.BrushArray) do
      setlength(fpeBrushStatus.BrushArray[j], 2 * TheRadius);

    Brush_DefinePointers;

      shiftby := 3;
      readby := 2;

      h := min(2 * TheRadius, theBMP.height);
      w := min(2 * TheRadius, theBMP.width);

      for j := 0 to h - 1 do
      begin
        pp := theBMP.scanline[j];

        for i := 0 to w - 1 do
        begin
          tempx := shiftby * i;
          gray := 0;
          for k := 0 to readby do
            gray := gray + pp[tempx + k];

          gray := gray div shiftby;
          fpeBrushStatus.BrushArray[j, i] := gray;
        end;
      end;


end;

procedure TImageEnPaintEngine.Brush_BuildRound(TheRadius: integer);
  var
    i, j: integer;
    rndIdx, rndx, rndy: double;
    dith, dithExpCoef: single;
    hi: integer;
    tras, radialDist, radialDistRatio: double;
    gapI, gapJ, newI, newJ: single;
    baseGap: single;
    // InvfeatherLn: single;
    fd, ff: double;
    stepf, stepInterfValue: double;
  begin
    stepf := Params_Paint.Step / (Params_Paint.Radius + 0.05);
    stepInterfValue :=  max(0, 1 -  abs(stepf - 0.3));


    if fpeParams_Paint.SessionMode = sm_IgnoreSessionMemory then
      dithExpCoef := 0.5
                    + 0.3 * (1 - ord(Params_Paint.ContinuousPainting))
                    +  1.7 * sqr(fpeParams_Paint.Transparence / 255)
                    +  0.7 * stepInterfValue
    else
      dithExpCoef := 0.5
                    + 0.3 * (1 - ord(Params_Paint.ContinuousPainting))
                    +  1 * sqr(fpeParams_Paint.Transparence / 255)
                    +  0.3 * stepInterfValue;


    fpeBrushStatus.PaintRadius := theRadius;
    fpeBrushStatus.BrushArray := nil;

    setlength(fpeBrushStatus.BrushArray, 2 * TheRadius);
    for j := 0 to high(fpeBrushStatus.BrushArray) do
      setlength(fpeBrushStatus.BrushArray[j], 2 * TheRadius);

    Brush_DefinePointers;

    if TheRadius = 1 then
    begin
      fpeBrushStatus.BrushArray[0, 0] :=
        round(fpeParams_Paint.Feather / 100 * 255);
      fpeBrushStatus.BrushArray[0, 1] :=
        round((100 - fpeParams_Paint.Feather) / 100 * 255);
      fpeBrushStatus.BrushArray[1, 0] :=
        round(fpeParams_Paint.Feather / 100 * 255);
      fpeBrushStatus.BrushArray[1, 1] :=
        round((100 - fpeParams_Paint.Feather) / 100 * 255);
      EXIT; // >>>> EXIT
    end;

    ff := Max(0.001, fpeParams_Paint.Feather / 100);
    baseGap := TheRadius / (45 - 15 * fpeParams_Paint.Transparence / 255 - 10 * stepInterfValue - 5 * fpeParams_Paint.Dithering / 100) ;

    hi := 2 * TheRadius - 1;

    for i := 0 to hi do
    begin
      Randomize;
      for j := 0 to hi do
      begin
        rndx := random;
        rndy := random;
        if random > 0.5 then
          rndIdx := 1
        else
          rndIdx := -1;

        radialDist := sqrt(sqr(i - TheRadius) + sqr(j - TheRadius));
        radialDistRatio := (radialDist / TheRadius);

        dith := max(0,
                      (0.01 + fpeParams_Paint.Dithering / 100) *
                       fpeParams_Paint.Feather / 100 *  (1- radialDistRatio)
                    );

        gapI := +rndIdx * rndX * dith * baseGap *
          sqr(max(0, (dithExpCoef - radialDistRatio)));
        gapJ := +rndIdx * rndY * dith * baseGap *
          sqr(max(0, (dithExpCoef - radialDistRatio)));

        newI := i - TheRadius + gapI;
        newJ := j - TheRadius + gapJ;

        newI := max(-TheRadius, min(TheRadius, newI));
        newJ := max(-TheRadius, min(TheRadius, newJ));

        radialDist := sqrt(sqr(newI) + sqr(newJ));
        radialDistRatio := max(0.001, (radialDist / TheRadius));

        fd := 1- ff;

        //ff goes from 0.001 to 1 represents the feather amount
        //fd is complementary to ff, represents the distance (0..1) of the feather from the center

        if radialDistRatio>  fd then
          tras := min(1, power((radialDistRatio - fd) / ff , 1/(1.0 + 2 * fpeParams_Paint.Gradation/100)))
        else
          tras := 0;

        fpeBrushStatus.BrushArray[i, j] := round(tras * 255);

      end;
    end;
  end;

  procedure TImageEnPaintEngine.Brush_Build1Pixel;
  begin
    fpeBrushStatus.PaintRadius := 1;
    fpeBrushStatus.BrushArray := nil;
    setlength(fpeBrushStatus.BrushArray, 1);
    setlength(fpeBrushStatus.BrushArray[0], 1);
    fpeBrushStatus.BrushArray[0, 0] := 0;

    Brush_DefinePointers;
  end;

  procedure TImageenPaintEngine.Brush_DefinePointers;
  var
  j:integer;
  begin
    setlength(pBrush, length(fpeBrushStatus.BrushArray[0]));
    for j := 0 to length(pBrush) - 1 do
      pBrush[j] := @fpeBrushStatus.BrushArray[j, 0];
  end;

procedure TImageEnPaintEngine.ResetBrush;


begin
  //------------------------------------------------
  fpeBrushStatus.PaintRadiusFixed := fpeParams_Paint.Radius;
  fpeBrushStatus.PaintRadius := fpeParams_Paint.Radius;
  //------------------------------------------------



  if fpeBrushStatus.PaintRadiusFixed = 0 then
    Brush_Build1Pixel
  else
  begin
    if not assigned(fpeParams_Paint.BrushBitmap) then
      Brush_BuildRound(fpeBrushStatus.PaintRadiusFixed)
    else
      Brush_LoadFromBitmap(fpeParams_Paint.BrushBitmap, fpeBrushStatus.PaintRadiusFixed);
  end;


  Brush_Copy(fpeBrushStatus.BrushArray, fpeBrushStatus.BrushArray_Fixed);
end;






procedure TImageEnPaintEngine.ResetBlending;
begin
  if fpeStatus.UseBuffer then
  begin
    case fpeParams_Paint.Mode of
      pemRetouch:
        begin
          case fpeParams_Retouch.Kind of
            rk_blur, rk_Sharpen:
              fpeBe.CalcBlendLUT(round(255 - fpeParams_Retouch.amount *
                sqrt((255 - fpeParams_Paint.Transparence) / 255)), blmnormal);
          else
            fpeBe.CalcBlendLUT(fpeParams_Paint.Transparence, fpeParams_Paint.BlendMode);
          end;
        end;
    else
      fpeBe.CalcBlendLUT(fpeParams_Paint.Transparence, fpeParams_Paint.BlendMode);
    end;
  end
  else
    fpeBe.CalcBlendLUT(fpeParams_Paint.Transparence, fpeParams_Paint.BlendMode);
end;



procedure TImageEnPaintEngine.ResetSelectionMask;
begin
  // initialize the bitmap editor
  fpeBe.AttachedImageEn := fpeImageen;

  // Get the array of mask from the bitmap editor
  fpeBe.GetmaskRect(fpeStatus.Xmask1, fpeStatus.Ymask1, fpeStatus.Xmask2,
    fpeStatus.Ymask2, fPeIEViewStatus.SelMask);

  if assigned(fPeIEViewStatus.SelMask) and (not fPeIEViewStatus.SelMask.IsEmpty) then
    fPeIEViewStatus.HasSelection := true
  else
    fPeIEViewStatus.HasSelection := false;

  fPeIEViewStatus.SelVisible := fpeimageen.VisibleSelection;
  fPeIEViewStatus.SelAnimated := iesoAnimated in fpeImageen.SelectionOptions;
 
  fpeBe.AttachedImageEn := nil;
  fpeBe.AttachedBitmap := nil;
  fpeBe.AttachedIEBitmap := nil;
end;

procedure TImageEnPaintEngine.ResetEditedRect;
begin
  fpeStatus.EditedRect.left := fPeIEViewStatus.BitmapW - 1;
  fpeStatus.EditedRect.top := fPeIEViewStatus.BitmapH - 1;
  fpeStatus.EditedRect.right := 0;
  fpeStatus.EditedRect.bottom := 0;
end;




procedure TImageEnPaintEngine.CaptureImageEnDrawBackBuffer;
begin

   if fHoldsDrawBackBuffer then EXIT; //nothing to capture

   fOldDrawBackBuffer := fpeImageen.OnDrawBackBuffer;
   fpeImageen.OnDrawBackBuffer := Handle_DrawBackBuffer;
   fHoldsDrawBackBuffer := true;
end;

procedure TImageEnPaintEngine.CaptureImageEnDrawCanvas;
begin
   if fHoldsDrawCanvas then EXIT; //nothing to capture

   fOldDrawCanvas := fpeImageen.OnDrawCanvas;
   fpeImageen.OnDrawCanvas := Handle_DrawCanvas;
   fHoldsDrawCanvas := true;
end;

procedure TImageEnPaintEngine.CalcRefreshRect(oldX,  oldY, newX, newY: integer; theUpdMode: TPEUpdateMode);
var
  r:integer;
  minx, maxx, miny, maxy: integer;
  rf:single;
begin
  if theUpdMode = umEachLine then
    rf := max(0.2, min(0.8, 1 - fpeBrushStatus.PaintRadius/ G_CONST_PE_MAXRADIUS))
  else
    rf := 0;
  r := round( (1 + rf) * max(1, fpeBrushStatus.PaintRadius));

  minx := min(oldx, newx);
  miny := min(oldy, newy);
  maxx := max(oldx, newx);
  maxy := max(oldy, newy);

  fpeStatus.RefreshRect_Cur.Left := minx - r;
  fpeStatus.RefreshRect_Cur.Right := maxx + r;
  fpeStatus.RefreshRect_Cur.Top := miny - r;
  fpeStatus.RefreshRect_Cur.Bottom := maxy + r;

 
  // the refresh rectangle is now bounded with the width and height of available bitmap
  if fpeStatus.RefreshRect_Cur.Left < 0 then
    fpeStatus.RefreshRect_Cur.Left := 0;
  if fpeStatus.RefreshRect_Cur.Top < 0 then
    fpeStatus.RefreshRect_Cur.Top := 0;
  if fpeStatus.RefreshRect_Cur.Right > fPeIEViewStatus.BitmapW - 1 then
    fpeStatus.RefreshRect_Cur.Right := fPeIEViewStatus.BitmapW - 1;
  if fpeStatus.RefreshRect_Cur.Bottom > fPeIEViewStatus.BitmapH - 1 then
    fpeStatus.RefreshRect_Cur.Bottom := fPeIEViewStatus.BitmapH - 1;


  if not IsRectInitialized(fpeStatus.RefreshRect_Sync) then
    fpeStatus.RefreshRect_Sync :=  fpeStatus.RefreshRect_Cur
  else
  begin
    fpeStatus.RefreshRect_Sync.Left := min(fpeStatus.RefreshRect_Sync.Left, fpeStatus.RefreshRect_Cur.Left);
    fpeStatus.RefreshRect_Sync.Top := min(fpeStatus.RefreshRect_Sync.top, fpeStatus.RefreshRect_Cur.top);
    fpeStatus.RefreshRect_Sync.Right := max(fpeStatus.RefreshRect_Sync.Right, fpeStatus.RefreshRect_Cur.Right);
    fpeStatus.RefreshRect_Sync.Bottom := max(fpeStatus.RefreshRect_Sync.Bottom, fpeStatus.RefreshRect_Cur.Bottom);
   end;

end;

procedure TImageEnPaintEngine.ResetTickCounts;
begin
   fpeStatus.Refresh_Limit := 0;
   fpeStatus.Refresh_TickCount := GetTickCount;
   fpeStatus.Sel_TickCount := GetTickCount;
   fpeStatus.Paint_TickCount := GetTickCount;
   fpeStatus.Cursor_TickCount := GetTickCount;
   fpeStatus.CtrRefreshRequests := 0;
   fpeStatus.CtrRefreshDone := 0;
   fpeStatus.CtrRefreshAll := 0;
   fpeStatus.CtrAcqPosSingle := 0;
   fpeStatus.CtrAcqPosMulti := 0;
end;

procedure TImageEnPaintEngine.ResetRect(var theRect:TRect);
begin
   theRect.Left := 50000;
   theRect.Right := -50000;
   theRect.top := 50000;
   theRect.bottom := -50000;
end;

function TImageEnPaintEngine.IsRectInitialized(theRect:TRect): boolean;
begin
   result :=  (theRect.right <> -50000) and
              (theRect.Left <> 50000);
end;

procedure TImageEnPaintEngine.ResetCursorRect;
begin
  ResetRect(fpeStatus.CursorRect);
  ResetRect(fpeStatus.CursorRect_Clone);
end;

procedure TImageEnPaintEngine.ResetRefreshRect;
begin
   ResetRect(fpeStatus.RefreshRect_Sync);
end;





procedure TImageEnPaintEngine.Execute;
var
  dist: double;
  canpaint: boolean;
  bFirstPaint: boolean;
begin
    while not fRunTimeMode do
    begin
      sleep(200);  //necessary to make the thread not to consume all the CPU while waiting!!!
      if Terminated then
        break;
    end;
    if not fRunTimeMode then
      EXIT;



    //------------------------------Runtime-------------------------------------------
    // Starts outer loop (no painting)
    while true do
    begin
    try
      if Terminated then
        break;

        //-------DO NOT REMOVE----------------------------------------------------------------
        sleep(20);
        //-------DO NOT REMOVE----------------------------------------------------------------

        bFirstPaint := not fpeisrunning;
        while (wrSignaled = fPeGoEvent.waitfor(0)) do   //starts inner loop (painting)
        begin

          try
            if bFirstPaint then
            begin
              ResetTickCounts;
              ResetRefreshRect;
              ResetCursorRect;
              CalcTranspTable;
              CalcPaintToAlphaTable;
              synchronize(FireOnStartedPainting);
              synchronize(DisableIEStuff);
              synchronize(LockIEUpDate);
              synchronize(CaptureImageEnDrawBackBuffer);
              setRunning(True);
            end;


            sleep(0); // 2011-5-4 Added in order to process main thread messages

            synchronize(CheckStillRunning); // 2011-6-6 Added in order to
            // detect if the imageen control still holds the mouse
            // in case a mouseup event is skipped

            AcquirePositions;

            synchronize(RefreshImageEn); // needs to refresh first time

            //calculates coordinates
            inc(fpeCoords.ret_idx); // initialized to -1 then becomes 0
            fpeCoords.CurX := fpeCoords.ret_array[fpeCoords.ret_idx].x;
            fpeCoords.CurY := fpeCoords.ret_array[fpeCoords.ret_idx].y;

            fpeCoords.memx := fpeCoords.CurX;
            fpeCoords.memy := fpeCoords.CurY;

            dist := sqrt(sqr(fpeCoords.memx - fpeCoords.mem1x) + sqr(fpeCoords.memy - fpeCoords.mem1y));

            if fpeParams_Paint.LArgeSteps then
              fpeStatus.NStrokes := 1    // if we have largesteps option just use 1 single step
            else
              fpeStatus.NStrokes := max(1, round(dist / fpeParams_Paint.Step)); // number of paint steps to cover the distance


            // the Step together with fpeContinuousPainting
            // determines when a mouse movement should trigger painting
            canpaint := true;
            canpaint := canpaint and ( bFirstPaint or
                                       fpeParams_Paint.ContinuousPainting or
                                       (fpeParams_Paint.Mode = pemDeformations) or
                                       (dist >= fpeParams_Paint.Step)
                                       );

            bFirstPaint := false;

            if (not fpeParams_Paint.LArgeSteps) and
              (not fpeParams_Paint.ContinuousPainting) and
              (fpeParams_Paint.Mode <> pemDeformations) then
              canpaint := canpaint and
                (abs(abs(fpeCoords.memx - fpeCoords.mem1x) - abs(fpeCoords.mem1x -
                fpeCoords.mem2x)) <= dist) and
                (abs(abs(fpeCoords.memy - fpeCoords.mem1y) - abs(fpeCoords.mem1y -
                fpeCoords.mem2y)) <= dist);



            if canpaint then // do the paint here
            begin
              {$IFDEF USE_JANTAB}
                Brush_CalculateNew((fpeParams_Tablet.PressureSensitive)and(pdBrushRadius in fpeParams_Tablet.PressureDynamics), fpeParams_Paint.RotateBrush);
              {$ELSE}
                Brush_CalculateNew(False, fpeParams_Paint.RotateBrush);
              {$ENDIF}


              DrawLine(fpeCoords.mem1x, fPeCoords.mem1y, fpeCoords.memx, fpeCoords.memy);

              fpeCoords.mem2x := fpeCoords.mem1x;
              fpeCoords.mem2y := fpeCoords.mem1y;
              fpeCoords.mem1x := fpeCoords.memx;
              fpeCoords.mem1y := fpeCoords.memy;
            end;

            synchronize(RefreshCursor);
            synchronize(CheckAutoScroll);

          finally

          end;
        end; // End While wrSignaled = fPeGoEvent.waitfor(0)

        if fPeIsRunning then
        begin

          fpeSession.New := false;
          synchronize(ReleaseImageEnDrawBackBuffer);
          synchronize(UNLockIEUpDate);

          synchronize(ReEnableIEStuff);

          synchronize(FireOnFinishedPainting);
          SetRunning(false);
          synchronize(FinalUpdate);

          synchronize(checkRegistration);

        end
        else
        begin

          if CheckShowBrushNoPaint then
          begin
            Synchronize(RefreshCursorNP);
          end;
        end;

     finally

     end;

 end;

end;

function TImageenpaintengine.CheckShowBrushNoPaint:boolean;
begin
  result := fCSTerminate.tryEnter;
  if result then
  begin
      try
        result := (not Terminated)
             and assigned(fpeimageen)
             and (GetTickCount - fpeStatus.Cursor_TickCount > 100)
             and fpeParams_Paint.ShowBrushWhenNotRunning;
      finally
        fCSTerminate.leave;
      end;
  end;

end;

procedure TImageenpaintengine.LockIEUpDate;
begin
 fpeImageen.LockUpdate;
end;

procedure TImageenpaintengine.UnLockIEUpDate;
begin
 fpeImageen.UnLockUpdateEX;
end;

procedure TImageenpaintengine.DisableIEStuff;
begin
  if fPeIEViewStatus.HasSelection then
  begin
  //  fpeImageen.VisibleSelection := true;
    fpeIeviewstatus.SelAnimated  :=  iesoAnimated in fpeImageen.SelectionOptions;
    fpeImageen.SelectionOptions := fpeImageen.SelectionOptions - [iesoAnimated];
  end;
end;

procedure TImageenpaintengine.ReEnableIEStuff;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    fpeImageen.VisibleSelection := fPeIEViewStatus.SelVisible;
    if fpeIeviewstatus.SelAnimated then
      fpeImageen.SelectionOptions := fpeImageen.SelectionOptions + [iesoAnimated];
  end;
end;


procedure TImageenpaintengine.DrawLine(oldx, oldy, newx, newy: integer);
var
i:integer;
ratio:single;
xinterval, yinterval: double;
begin
  fpeStatus.EditedRect.left := min(fpeStatus.EditedRect.left, fpeCoords.CurX - round(1.05 * fpeBrushStatus.PaintRadius));
  fpeStatus.EditedRect.top := min(fpeStatus.EditedRect.top, fpeCoords.CurY - round(1.05 * fpeBrushStatus.PaintRadius));
  fpeStatus.EditedRect.right := max(fpeStatus.EditedRect.right, fpeCoords.CurX + round(1.05 * fpeBrushStatus.PaintRadius));
  fpeStatus.EditedRect.bottom := max(fpeStatus.EditedRect.bottom, fpeCoords.CurY + round(1.05 * fpeBrushStatus.PaintRadius));


   if newx - oldX <> 0 then
    ratio := (newy - oldY) /
      (newx - oldX)
  else
    ratio := 1;


   // Calculate the x and y intervals between last coord and new coord
   // also calculates the Rectangle that must be refreshed in real time on screen
  xinterval := (fpeCoords.memx - fpeCoords.mem1x) / fpeStatus.NStrokes;
  yinterval := (fpeCoords.memy - fpeCoords.mem1y) / fpeStatus.NStrokes;


  for i := 1 to fpeStatus.NStrokes do
  begin
    if (newX - oldX <> 0) and
      (newY - oldY <> 0) then
    begin
      if abs(newX - oldX) >
        abs(newY - oldY) then
      begin
        fpeCoords.CurX := oldX + round(i * xinterval);
        fpeCoords.CurY :=
          round(ratio * (fpeCoords.CurX - oldX)) +  oldY;
      end
      else
      begin
        fpeCoords.CurY := oldY + round(i * yinterval);
        fpeCoords.CurX :=
          round(1 / ratio * (fpeCoords.CurY - oldY)) +
          oldX;
      end;
    end
    else
    begin
      fpeCoords.CurX := oldX + round(i * xinterval);
      fpeCoords.CurY := oldY + round(i * yinterval);
    end;

    fpeStatus.xret1 := fpeCoords.CurX - fpeBrushStatus.PaintRadius;
    fpeStatus.yret1 := fpeCoords.CurY - fpeBrushStatus.PaintRadius;
    if fpeBrushStatus.PaintRadius = 0 then
    begin
      fpeStatus.xret2 := fpeStatus.xret1;
      fpeStatus.yret2 := fpeStatus.yret1;
    end
    else
    begin
      fpeStatus.xret2 := fpeStatus.xret1 + 2 *
        fpeBrushStatus.PaintRadius - 1;
      fpeStatus.yret2 := fpeStatus.yret1 + 2 *
        fpeBrushStatus.PaintRadius - 1;
    end;

    fpeBrushStatus.OffSetX := 0;
    fpeBrushStatus.OffSetY := 0;
    if fpeStatus.xret1 < 0 then
    begin
      fpeBrushStatus.OffSetX := -fpeStatus.xret1;
      fpeStatus.xret1 := 0;
    end;
    if fpeStatus.yret1 < 0 then
    begin
      fpeBrushStatus.OffSetY := -fpeStatus.yret1;
      fpeStatus.yret1 := 0;
    end;
    if fpeStatus.xret2 > fPeIEViewStatus.BitmapW - 1 then
      fpeStatus.xret2 := fPeIEViewStatus.BitmapW - 1;
    if fpeStatus.yret2 > fPeIEViewStatus.BitmapH - 1 then
      fpeStatus.yret2 := fPeIEViewStatus.BitmapH - 1;

    // ----------------------------
    if (fpeCoords.ret_idx <= fpeCoords.ret_counter - 1) then
    begin

      DoPaint; // Execute the stroke
      if fUpdateMode = umEachStroke then
      begin
          CalcRefreshRect(fpeCoords.CurX, fpeCoords.CurY, fpeCoords.CurX, fpeCoords.CurY, fUpdateMode);
          synchronize(RefreshImageEn); // update current stroke to screen
      end;
    end;
    // ----------------------------
  end; // End  loop on strokes

  if fUpdateMode = umEachLine then
  begin
    CalcRefreshRect(oldx, oldy, newx, newy, fUpdateMode);
    synchronize(RefreshImageEn); // now update all strokes to screen
  end;


end;

procedure TImageEnPaintEngine.DoPaint;
var
aAlphaMap: TPeAlphaMap;
begin

  aAlphaMap := TPeAlphaMap.create;
  try
     aAlphaMap.Rows := nil;
      if (fpeParams_Paint.Mode = pemClone) and
         (length(pCloneAlphaBuf) = fpeParams_Cloning.SrcIeBitmap.height) then
      begin
        aAlphaMap.Rows := pCloneAlphaBuf;

        aAlphaMap.dx := fpeParams_Cloning.SrcPoint.x - fpeParams_Cloning.TgtPoint.x;

        aAlphaMap.dy := fpeParams_Cloning.SrcPoint.y - fpeParams_Cloning.TgtPoint.y;
        aAlphaMap.Width := fpeParams_Cloning.SrcIeBitmap.width;
        aAlphaMap.Height := fpeParams_Cloning.SrcIeBitmap.height;
      end;

    if fpeStatus.UseBuffer then
    begin
      case fpeParams_Paint.Mode of
        pemhistory:
          Paint_HistoryWithBuffer;
        pemcolor:
          Paint_AirbrushWithBuffer;
        pemclone:
          Paint_CloneWithBuffer(aAlphaMap);
        pemtexture:
          Paint_TextureWithBuffer;

        pemEraseLayer:
          Paint_EraseAlphaWithBuffer;
        pemRestoreLayer:
          Paint_onAlphaChannelWithBuffer(aAlphaMap);
        pemRetouch:
          begin
            case fpeParams_Retouch.Kind of
              rk_blur, rk_Sharpen:
                Paint_ConvolutionWithBuffer;
              rk_dodge, rk_burn, rk_Lighten, rk_Darken, rk_Saturate,
                rk_DeSaturate:
                Paint_RetouchwithBuffer;
              rk_Custom:
                Paint_RetouchCustomwithBuffer;
            end;
          end;

        pemObjectStamp:
          Paint_ObjectWithBuffer;
      end;
    end
    else if fpeStatus.UseBuffer_Deform then
    begin
      case fpeParams_Paint.Mode of
        pemDeformations:
          Paint_DeformationWithBuffer;
      end;
    end
    else
    begin
      case fpeParams_Paint.Mode of
        pemhistory:
          Paint_HistoryNoBuffer;
        pemcolor:
          Paint_AirbrushNoBuffer;
        pemclone:
          Paint_CloneNoBuffer(aAlphaMap);
        pemtexture:
          Paint_TextureNobuffer;
        pemEraseLayer:
          Paint_EraseAlphaNoBuffer;
        pemRestoreLayer:
          Paint_onAlphaChannelNoBuffer(aAlphaMap);
        pemRetouch:
          begin
            case fpeParams_Retouch.Kind of
              rk_blur, rk_Sharpen:
                Paint_ConvolutionNoBuffer;
              rk_dodge, rk_burn, rk_Lighten, rk_Darken, rk_Saturate,
                rk_DeSaturate:
                Paint_RetouchNoBuffer;
              rk_Custom:
                Paint_RetouchCustomNoBuffer;
            end;
          end;
      end;
    end;

    
  finally
    aAlphaMap.Free;
  end;


end;

function TImageEnPaintEngine.GetPriorityIndex: integer;
begin
   case fUpdatePriority of
    upHigh: result := 0;
    upMedium: result := 1;
    upLow: result := 2;
    else
      result := 1;
  end;
end;



function TImageEnPaintEngine.ImageEnBgIsNormal(theImageEn:TImageEnView): boolean;
begin
  result := (theImageEn.BackgroundStyle <> iebsChessboard)and(theImageEn.BackgroundStyle <> iebsPhotoLike);
end;

procedure TImageEnPaintEngine.CalcCursorRect;
var
 temprx, tempry, cloneDX, cloneDY: integer;
  xr1clone, yr1clone, xr2clone, yr2clone: integer;
  aPt:TPoint;
begin

    aPt := fpeImageen.screentoclient(mouse.CursorPos);

    fpeCoords.mouse_x := aPt.x;
    fpeCoords.mouse_y := aPt.y;

  //now calculate cursors rects
    temprx := round(max(0.6, fpeBrushStatus.PaintRadius) * fpeImageen.zoom / 100 *
      fpeImageen.Layers[fpeImageen.layerscurrent].width /
      fpeImageen.IEBitmap.width);
    tempry := round(max(0.6, fpeBrushStatus.PaintRadius) * fpeImageen.zoom / 100 *
      fpeImageen.Layers[fpeImageen.layerscurrent].height /
      fpeImageen.IEBitmap.height);


      with fpestatus.CursorRect do
      begin
        Left := fpeCoords.mouse_x - temprx;
        Right := fpeCoords.mouse_x + temprx;
        Top := fpeCoords.mouse_y - tempry;
        Bottom := fpeCoords.mouse_y + tempry;
      end;


      //clone rect
    if fpeParams_Paint.Mode = pemclone then
    begin
      if fpeParams_Cloning.ShowBrush then
      begin

        Case fpeParams_Cloning.SrcType of
        cst_ImageEn, cst_IEBitmap:
            begin
              if assigned(fpeParams_Cloning.SrcImageEn) then
              begin
                if fpeParams_Cloning.SrcImageEn = fpeImageen then
                // Cloning from the same
                // Imageenview as the target
                begin
                  cloneDx := myXBMP2Scr(fpeParams_Cloning.SrcPoint.x) - myXBMP2Scr(fpeParams_Cloning.TgtPoint.x);
                  cloneDy := myYBMP2Scr(fpeParams_Cloning.SrcPoint.y) - myYBMP2Scr(fpeParams_Cloning.TgtPoint.y);

                  with fpestatus.CursorRect_Clone do
                  begin
                    Left := fpeCoords.mouse_x + cloneDx - temprx;
                    Right := fpeCoords.mouse_x + cloneDx + temprx;
                    Top := fpeCoords.mouse_y + cloneDy - tempry;
                    Bottom := fpeCoords.mouse_y + cloneDy + tempry;
                  end;
                end
                else
                begin // source imageenview is different from target
                  temprx := round( 1 * fpeBrushStatus.PaintRadius);
                  tempry :=  round(1 * fpeBrushStatus.PaintRadius);
                  xr1clone := fpeParams_Cloning.SrcImageEn.XBMP2scr
                    (fpeParams_Cloning.SrcPoint.x - fpeParams_Cloning.TgtPoint.x
                    + fpeCoords.CurX - temprx);
                  yr1clone := fpeParams_Cloning.SrcImageEn.YBMP2scr
                    (fpeParams_Cloning.SrcPoint.y - fpeParams_Cloning.TgtPoint.y
                    + fpeCoords.CurY - tempry);
                  xr2clone := fpeParams_Cloning.SrcImageEn.XBMP2scr
                    (fpeParams_Cloning.SrcPoint.x - fpeParams_Cloning.TgtPoint.x
                    + fpeCoords.CurX + temprx);
                  yr2clone := fpeParams_Cloning.SrcImageEn.YBMP2scr
                    (fpeParams_Cloning.SrcPoint.y - fpeParams_Cloning.TgtPoint.y
                    + fpeCoords.CurY + tempry);


                  fpeStatus.CursorRect_Clone := rect(xr1clone, yr1clone, xr2clone, yr2clone);
                end;
              end;
            end;
          cst_IELayer:
            begin

            end;
        end;
      end;
    end;
end;


procedure TImageenpaintEngine.RefreshCursorNP;
function FindControl(theMousePt: TPoint): TWinControl;
begin

  result := FindVCLWindow(theMousePt);
end;
var I:integer;
begin
  if Terminated then EXIT;  //do not remove!!
  if not assigned(fpeimageen) then
    EXIT;

  fpeStatus.Cursor_TickCount := GetTickCount;


  fpeBrushStatus.PaintRadiusFixed := fpeParams_Paint.Radius;
  fpeBrushStatus.PaintRadius := fpeParams_Paint.Radius;
  CalcCursorRect;
  if (FindControl(mouse.CursorPos) = fpeimageen) then
  begin
    fpeNotRunningstatus.Flag_InsideImageEn := true;
    CaptureImageEnDrawCanvas;

      fpeimageen.UpdateRect(fpeStatus.CursorRect);

      for I := fPeCursorList.Count-1 downto 0 do
      begin
        fpeImageen.UpdateRect(tPECursorInfo(fPeCursorList[i]).CursorRect);
        fPeCursorList.Delete(i);
      end;

  end
  else
  begin

    if fpeNotRunningstatus.Flag_InsideImageEn then
    begin
      fpeimageen.Update;
      fpeNotRunningstatus.Flag_InsideImageEn := false;
    end;

  end;

end;



procedure TImageEnPaintEngine.RefreshCursor;



procedure _PrepareCanvas(cv:Tcanvas);
  begin
    with cv do
    begin
      brush.style := bsclear;
      pen.Mode := pmNotXor;
      pen.Color := clred;
      pen.width := 1;
    end;
  end;
var
  I: Integer;

begin
  if (GetTickCount - fpeStatus.Cursor_TickCount <0.3 * fpeStatus.Refresh_Limit) then    //too early for a refresh, exit (wait till next)
  begin
    EXIT; //>>>>EXIT
  end;


  fpeStatus.Cursor_TickCount := GetTickCount;

  CalcCursorRect;


  for I := fPeCursorList.Count-1 downto 0 do
  begin
    myUpdateRect(tPECursorInfo(fPeCursorList[i]).CursorRect);
    //fpeImageen.UpdateRect(tPECursorInfo(fPeCursorList[i]).CursorRect);
    fPeCursorList.Delete(i);
  end;

  for I := fPeCursorcloneList.Count-1 downto 0 do
  begin
    fpeParams_Cloning.SrcImageEn.UpdateRect(tPECursorInfo(fPeCursorCloneList[i]).CursorRect);
    fPeCursorCloneList.Delete(i);
  end;

end;


procedure TImageEnPaintEngine.myUpdateRect(rc:Trect);
var
  waitmsV, waitmsNV: integer;
  pixMask1, pixMask2, pixMask3, pixMask4: integer;
begin


  if fPeIEViewStatus.HasSelection and fPeIEViewStatus.SelVisible then
  begin
  (*
    pixMask1 := fPeIEViewStatus.SelMask.GetPixel(fpeStatus.xret1, fpeStatus.yret1);
    pixMask2 := fPeIEViewStatus.SelMask.GetPixel(fpeStatus.xret2, fpeStatus.yret2);
    pixMask3 := fPeIEViewStatus.SelMask.GetPixel(fpeStatus.xret2, fpeStatus.yret1);
    pixMask4 := fPeIEViewStatus.SelMask.GetPixel(fpeStatus.xret1, fpeStatus.yret2);

    pixMask1 := min(1, pixmask1);
    pixMask2 := min(1, pixmask2);
    pixMask3 := min(1, pixmask3);
    pixMask4 := min(1, pixmask4);

    if (pixmask1 <> pixmask2) or (pixmask3 <> pixmask4) then
    begin
      waitmsNV := 20;
      waitmsV := 100;
    end
    else
    begin
      waitmsNV := 300;
      waitmsV := 100;
    end;
    *)
    //if gettickcount - fpestatus.Sel_TickCount > ord(fpeImageen.VisibleSelection)* waitmsV + ord(not fpeImageen.VisibleSelection)* waitmsNV then
    if gettickcount - fpestatus.Sel_TickCount >  300  then
    begin
      fpeImageen.LockPaint;
      try
        fpeImageen.VisibleSelection := not fpeImageen.VisibleSelection;
        fpestatus.Sel_TickCount := gettickcount;
      finally
        fpeImageen.UnLockPaint;
        fpeimageen.repaint;
      end;
    end;
  end;

  fpeImageen.UpdateRect(rc);
  (*
  if (fPeIEViewStatus.ZoomFilter<>rfNone) and (fPeIEViewStatus.ZoomF <> 1) then
  begin
    if fPeIEViewStatus.BgIsNormal then
      fpeImageen.PaintRect(rc)
    else
      fpeImageen.repaint;
  end;
  *)
end;

procedure TImageEnPaintEngine.RefreshImageEn;
var

  rc: Trect;
  xr1, xr2, yr1, yr2: integer;
  timeLimit_base, timeLimit_UpdatePriority, timeLimit_UpdateMode: double;
  cursorSpeed: double;
//  skewF: double;
  Distx, Disty, ratioX, ratioY: double;
  bEditingLayerAlpha: boolean;
  prIdx: integer;
begin


  bEditingLayerAlpha := fPeIEViewStatus.LayerhasAlpha and
                        fpeParams_Paint.EnableEditAlphaChannel and
                        (fPeIEViewStatus.LayerCount>1);


  Distx := abs(fpeCoords.memx - fpeCoords.mem1x);
  ratioX := DistX / max(1, fpeBrushStatus.PaintRadius);
  Disty := abs(fpeCoords.memy - fpeCoords.mem1y);
  ratioy := Disty / max(1,fpeBrushStatus.PaintRadius);

  cursorSpeed := power(1/9, min(1, ratioX + ratioy));



  timeLimit_base := 5 + 20 * (ord(fpeImageen.ZoomFilter<>rfnone)) + 5 * (1 - sqr(fpeParams_Paint.Precision/100));


  //TPEUpdatePriority = (upHigh, upMedium, upLow);
  prIdx := GetPriorityIndex;
  timeLimit_UpdatePriority :=   8 * (1 + prIdx) * (1 + fpeBrushStatus.PaintRadius / G_CONST_PE_MAXRADIUS);

  if fUpdateMode= umEachLine then
    timeLimit_UpdateMode := 15 * ord(bEditingLayerAlpha)
                            +4 * cursorSpeed * (1 + 7 * fpeBrushStatus.PaintRadius / G_CONST_PE_MAXRADIUS)
  else
    timeLimit_UpdateMode := 15 * ord(bEditingLayerAlpha)
                            + cursorSpeed * fpeBrushStatus.PaintRadius / G_CONST_PE_MAXRADIUS;

  fpeStatus.Refresh_Limit := timeLimit_base + timeLimit_UpdatePriority + timeLimit_UpdateMode;

  

  inc(fpeStatus.CtrRefreshRequests); //for debug only

  if (not IsRectInitialized(fpeStatus.RefreshRect_Sync)) then
  begin
    inc(fpeStatus.CtrRefreshAll); //for debug only
    fpeImageen.Repaint;
    exit; //>>>>EXIT
  end;



  if (GetTickCount - fpeStatus.Refresh_TickCount < fpeStatus.Refresh_Limit) then    //too early for a refresh, exit (wait till next)
  begin
    EXIT; //>>>>EXIT
  end;




  inc(fpeStatus.CtrRefreshDone); //for debug only


    xr1 := myXBMP2Scr(fpeStatus.RefreshRect_Sync.Left);
    yr1 := myYBMP2Scr(fpeStatus.RefreshRect_Sync.Top);
    xr2 := myXBMP2Scr(fpeStatus.RefreshRect_Sync.Right);
    yr2 := myYBMP2Scr(fpeStatus.RefreshRect_Sync.Bottom);


    if fpeStatus.RefreshRect_Sync.Left - fpeBrushStatus.PaintRadius < 0 then
      xr1 := 0;
    if fpeStatus.RefreshRect_Sync.Top - fpeBrushStatus.PaintRadius < 0 then
      yr1 := 0;
    if fpeStatus.RefreshRect_Sync.Right + fpeBrushStatus.PaintRadius > fpeBitmap.width - 1 then
      xr2 := fpeImageen.width;
    if fpeStatus.RefreshRect_Sync.Bottom + fpeBrushStatus.PaintRadius > fpeBitmap.height - 1 then
      yr2 := fpeImageen.height;

    rc := rect(xr1, yr1, xr2, yr2);

   // fpeImageen.UpdateRect(rc);
    myUpdateRect(rc);

   fpeStatus.RefreshRect_Sync := fpeStatus.RefreshRect_Cur;
   fpeStatus.Refresh_TickCount := GetTickCount;   //update refresh tick counter
  


  if assigned(fpeOnPainting) then
    fpeOnPainting(self, fpeCoords.memx, fpeCoords.memy);

end;

 

procedure TImageEnPaintEngine.ReleaseImageEnDrawBackBuffer;
begin
  if fHoldsDrawBackBuffer and assigned(fpeImageen) then
  begin
    fpeImageen.OnDrawBackBuffer := fOldDrawBackBuffer;
    fHoldsDrawBackBuffer := false;
  end;
end;

procedure TImageEnPaintEngine.ReleaseImageEnDrawCanvas;
begin
  if fHoldsDrawCanvas and assigned(fpeImageen) then
  begin
    fpeImageen.OnDrawCanvas := fOldDrawCanvas;
    fHoldsDrawCanvas := false;
  end;
end;

procedure TImageEnPaintEngine.CheckAutoScroll;
var
  testx, testy: boolean;
  deltax, deltay: integer;

  zradius: integer;
  testhscrollbar, testvscrollbar: boolean;
begin
  if fpeParams_Paint.EnableAutoScroll then
  begin

    testhscrollbar := fpeImageen.width -
      round(fpeBitmap.width * fPeIEViewStatus.ZoomF) < 0;
    testvscrollbar := fpeImageen.height -
      round(fpeBitmap.height * fPeIEViewStatus.ZoomF) < 0;

    zradius := round(fpeBrushStatus.PaintRadius * fPeIEViewStatus.ZoomF);

    deltax := fpeCoords.mouse_x + zradius + 20 * ord(testvscrollbar) -
      fpeImageen.width;
    deltay := fpeCoords.mouse_y + zradius + 20 * ord(testhscrollbar) -
      fpeImageen.height;

    testx := (deltax > 0);
    testy := (deltay > 0);

    if not testx then
      deltax := 0;
    if not testy then
      deltay := 0;

    if testx or testy then
    begin
      fpeImageen.SetViewXY(fpeImageen.viewx + deltax,
        fpeImageen.viewy + deltay);
    end
    else
    begin
      deltax := fpeCoords.mouse_x - zradius;
      deltay := fpeCoords.mouse_y - zradius;
      testx := (deltax < 0);
      testy := (deltay < 0);

      if not testx then
        deltax := 0;
      if not testy then
        deltay := 0;

      if testx or testy then
      begin
        fpeImageen.SetViewXY(fpeImageen.viewx + deltax,
          fpeImageen.viewy + deltay);
      end;
    end;

  end;

end;

procedure TImageEnPaintEngine.FinalUpdate;
begin
  fpeImageen.Repaint;
end;

procedure TImageEnPaintEngine.CheckThreadRunningRequisites;
begin
  fpeStatus.HasRunningRequisites := true;

  if not(assigned(fpeImageen)) then
    messagedlg('imageen not assigned', mtinformation, [mbok], 0);

  if fpeBitmap = nil then
    messagedlg('Bitmap not assigned ', mtinformation, [mbok], 0);

  if not((assigned(fpeImageen)) and (fpeBitmap <> nil)) then
    fpeStatus.HasRunningRequisites := false;

  if assigned(fpeParams_Paint.BrushBitmap) then
  begin
    if (fpeParams_Paint.BrushBitmap.width = 0) or
      (fpeParams_Paint.BrushBitmap.height = 0) then
    begin
      fpeStatus.HasRunningRequisites := false;
      messagedlg('Brush Bitmap has one dimension = 0', mtinformation,
        [mbok], 0);
    end;
  end;

  case fpeParams_Paint.Mode of
    pemtexture:
      begin
        fpeStatus.HasRunningRequisites :=
          (assigned(fpeParams_Texture.TextureBitmap)) and
          (fpeParams_Texture.TextureBitmap.pixelformat = fpeBitmap.pixelformat)
          and (fpeParams_Texture.TextureBitmap.width > 0) and
          (fpeParams_Texture.TextureBitmap.height > 0);

          if not fpeStatus.HasRunningRequisites then
            showmessage('Error: Texture Bitmap must be assigned and must have the same pixel format as the current layer.');
      end;
    pemhistory:
      begin
          //necessary to avoid inconsistency.
          //ImageEn creates the alpha channel on the fly when we call the getter of Alphachannel!
          if fpeBitmap.HasAlphaChannel then
          begin
            if not fpeParams_History.HistoryBitmap.HasAlphaChannel then
              fpeParams_History.HistoryBitmap.AlphaChannel.CreateAsAlphaChannel(fpeParams_History.HistoryBitmap.width,
                                                                                fpeParams_History.HistoryBitmap.Height,
                                                                                fpeParams_History.HistoryBitmap.Location);
          end;

          fpeStatus.HasRunningRequisites :=
          (assigned(fpeParams_History.HistoryBitmap)) and
          (fpeParams_History.HistoryBitmap.pixelformat = fpeBitmap.pixelformat)
          and (fpeParams_History.HistoryBitmap.width = fpeBitmap.width) and
          (fpeParams_History.HistoryBitmap.height = fpeBitmap.height) and
          (fpeParams_History.HistoryBitmap.HasAlphaChannel = fpeBitmap.
          HasAlphaChannel);

          if not fpeStatus.HasRunningRequisites then
            showmessage('Error: History Bitmap and the current layer must have the same format: ' +
                        ' pixel format, width, height and alpha channel availability must match.');

      end;
    pemclone:
      begin
        fpeStatus.HasRunningRequisites :=
          (assigned(fpeParams_Cloning.SrcIeBitmap)) and
          (fpeParams_Cloning.SrcIeBitmap.pixelformat = fpeBitmap.pixelformat)
          and (fpeParams_Cloning.SrcIeBitmap.width > 0) and
          (fpeParams_Cloning.SrcIeBitmap.height > 0);

        if not fpeStatus.HasRunningRequisites then
            showmessage('Error: Clone-Source Bitmap must be assigned and must have the same pixel format as the current layer.');
      end;
    pemRetouch:
      begin
        fpeStatus.HasRunningRequisites := (fpeParams_Retouch.Kind <> rk_Custom)
          or assigned(fpeParams_Retouch.RetouchCustom);

        if not fpeStatus.HasRunningRequisites then
            showmessage('Error: Custom Retouch function must be assigned.');
      end;
  end;

end;

procedure TImageEnPaintEngine.CheckStillRunning;
begin
 
  if not fpeImageen.MouseCapture then
    StopPainting;
end;



procedure TImageEnPaintEngine.AcquirePositions;
var
  x, y: integer;
  NPos: integer;
  iPos: integer;
  slpTime: integer;

  Distx, Disty: integer;

  distf, ZigZagF: single;

  aPt: Tpoint;

  sRadiusFact, sStepFact: single;
  bEditingLayerAlpha: boolean;
  dt: integer;
begin
  if Terminated then
    EXIT;


  bEditingLayerAlpha := fPeIEViewStatus.LayerhasAlpha and
                        fpeParams_Paint.EnableEditAlphaChannel and
                        (fPeIEViewStatus.LayerCount>1);

  sRadiusFact := max(0.05, min(1, fpeBrushStatus.PaintRadius /
    G_CONST_PE_MAXRADIUS));

  sStepFact :=  min(1, fpeParams_Paint.Step/(max(1, fpeBrushStatus.PaintRadius)));


  Distx := abs(fpeCoords.memx - fpeCoords.mem2x);
  Disty := abs(fpeCoords.memy - fpeCoords.mem2y);
  distf :=  power(abs(Distx - Disty) / (Distx + Disty + 1), 2);



  ZigZagF := 1 + max(0,
                 min(fPeIEViewStatus.ZoomF * (1 + 7 * sqr(1 - sRadiusFact)),
                 fPeIEViewStatus.ZoomF * 10 * (0.5 - distf)
                 )
                 );


  if fpeParams_Paint.RotateBrush then
  begin
    NPos := 1;
    slpTime := 12
  end
  else
  begin


     NPos :=1;

     if fpeParams_Paint.LArgeSteps  then
     begin
         //the sleep time is a critical factor for the fluidity of painting!!!!!!!!
       // must be calculated very accurately
       slpTime := max(0, round(5
                                + 5 * sRadiusFact
                                + 5 * ord(bEditingLayerAlpha)
                                )
                    );


       dt := GetTickCount - fpeStatus.Paint_TickCount;
     //  if GetTickCount - fpeStatus.Paint_TickCount < 20 then
       begin
         NPos := max(1, min(8, dt div 5));
       end;

     end
     else
     begin
         //the sleep time is a critical factor for the fluidity of painting!!!!!!!!
       // must be calculated very accurately
       slpTime := max(0, round(12
                                + 5 * sStepFact
                                + 15 * sRadiusFact
                                + 5 * ord(bEditingLayerAlpha)
                                - 20 * fpeParams_Paint.Precision / 100
                                - 10 * ZigZagF
                            )
                    );




       if GetTickCount - fpeStatus.Paint_TickCount < ( + 1
                                                       + 3 * (1 - sStepFact) * (1 - sRadiusFact)
                                                       + 2 * fpeParams_Paint.Precision / 100
                                                       - 2.5 * ord(bEditingLayerAlpha)
                                                       - 6.5 * sRadiusFact) * slpTime then
       begin
         NPos := 2;
       end;

     end;





   //statistical counters
   if NPos=1 then
     inc(fpeStatus.CtrAcqPosSingle)
   else
     inc(fpeStatus.CtrAcqPosMulti);


   fpeStatus.Paint_TickCount := GetTickCount;

   if GetTabletActive then
   begin
     slpTime := round(slpTime * 0.8);
   end;
  end;


  if fpeCoords.ret_idx < fpeCoords.ret_counter-1
  then
  begin
    sleep(0);
    aPt := fpeImageen.screentoclient(mouse.CursorPos);
    sleep(0);
    fpeCoords.mouse_x := aPt.x;
    fpeCoords.mouse_y := aPt.y;
  end
  else
  begin

    for iPos := 1 to NPos do
    begin

      sleep(slpTime);
      aPt := fpeImageen.screentoclient(mouse.CursorPos);
      sleep(0);
      x := myXScr2BMP(aPt.x);
      y := myYScr2BMP(aPt.y);

      if high(fpeCoords.ret_array) <= fpeCoords.ret_counter - 1 then
        setlength(fpeCoords.ret_array, length(fpeCoords.ret_array) + 1000);

      fpeCoords.ret_array[fpeCoords.ret_counter].x := x;
      fpeCoords.ret_array[fpeCoords.ret_counter].y := y;
      inc(fpeCoords.ret_counter);


      if(iPos = NPos) then
      begin
        fpeCoords.mouse_x := aPt.x;
        fpeCoords.mouse_y := aPt.y;
      end;

    end;
  end;
end;


procedure TImageEnPaintEngine._getShiftbyReadby(var shiftby, readby: integer;
  pf: tbepixelformat);
begin
  case pf of
    bepf8:
      shiftby := 1;
    bepf16:
      shiftby := 2;
    bepf24:
      shiftby := 3;
    bepf32:
      shiftby := 4;
  end;
  readby := min(2, shiftby - 1);
end;

function TImageEnPaintEngine._averagepixel(pemap: tperowarray; j, i: integer;
  byteperpix: integer; convradius: integer): TbeBGRAbytearray;
var
  k, l, m: integer;
  x, y: integer;
  mlastx, mlasty: integer;
  somma: TbeBGRAintarray;
  Convx, convy: integer;
begin

  mlastx := fPeIEViewStatus.BitmapW - 1;
  mlasty := fPeIEViewStatus.BitmapH - 1;
  for k := 0 to byteperpix - 1 do
    somma[k] := 0;
  try
    for l := -convradius to convradius do
    begin
      y := j + l;
      convy := l + convradius;
      for m := -convradius to convradius do
      begin
        x := i + m;
        Convx := m + convradius;

        if (x >= 0) and (x <= mlastx) and (y >= 0) and (y <= mlasty) then
        begin
          for k := 0 to byteperpix - 1 do
            somma[k] := somma[k] + convcoeffs.convmatrix[convy, Convx] *
              pemap[y, byteperpix * x + k];
        end
        else
        begin
          for k := 0 to byteperpix - 1 do
            somma[k] := somma[k] + convcoeffs.convmatrix[convy, Convx] *
              pemap[j, byteperpix * i + k];
        end;
      end;
    end;
  except
    synchronize(FireOnDebug);

  end;

  for k := 0 to byteperpix - 1 do
    result[k] := max(0, min(255, somma[k] div convcoeffs.convdiv));

end;

procedure TImageEnPaintEngine.Paint_onAlphaChannelNoBuffer(AlphaMap: TPeAlphaMap);
var
  i, j: integer;

  inttras: byte;

 // pp: pbebytearray;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;


  ac, ac_map, ac_new: byte;
  tp:byte;

  bHasMap: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
  if (not fpeBitmap.HasAlphaChannel)then EXIT;

  bHasMap := assigned(AlphaMap.Rows);


  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      if GetThroughMask then
      begin
        ac := pdestalpha[j, i];

        if ac<255 then
        begin
          inttras := GetBrushTras(i, j, tp);
          if bHasMap then
          begin
            ac_map := AlphaMap.GetValue(i, j);
            if ac_map>0 then
              inttras := ((255 - ac_map) * 255 + inttras * ac_map) div 255
            else
              inttras := 255;
          end;

          inttras := 255 - (255 - inttras) * (255 - fpeParams_Paint.Transparence) div 255;
          inttras := GetIntTras_byMask(inttras);

          ac_new :=  (ac * inttras + 255 * (255 - inttras)) div 255;

          pdestalpha[j,i] := ac_new;
        end;
      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_onAlphaChannelWithBuffer(AlphaMap: TPeAlphaMap);
var
  i, j: integer;

  inttras: byte;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  ac,  ac_map: byte;
  tp:byte;
  bHasMap: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
  if (not fpeBitmap.HasAlphaChannel) then EXIT;

   bHasMap := assigned(AlphaMap.Rows);


  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      if GetThroughMask then
      begin
        ac := pdestalpha[j, i];
        if ac<255 then
        begin

          inttras := GetBrushTras(i, j, tp);

          if bHasMap then
          begin
            ac_map := AlphaMap.GetValue(i, j);
            if ac_map>0 then
              inttras := ((255 - ac_map) * 255 + inttras * ac_map) div 255
            else
              inttras := 255;
          end;

          inttras := GetIntTras_byMask(inttras);

        
          if (not fpeStatus.Buffermap[i, j].alpha) then
          begin
            fpeStatus.Buffermap[i, j].alpha := true;
            pBufAlpha[j, i] := min(255, ac + 255 - fpeParams_Paint.Transparence);
          end;

          ac := (ac * inttras + pBufAlpha[j, i] * (255 - inttras)) div 255;

          pdestAlpha[j,i] := ac;
        end;
      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_EraseAlphaNoBuffer;
var
  i, j: integer;

  inttras: byte;

 // pp: pbebytearray;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  ac: byte;
  tp:byte;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  if (not fpeBitmap.HasAlphaChannel) then EXIT;

  tp := GetTabletDynamic_Opacity;
  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      if GetThroughMask then
      begin
        ac := pdestalpha[j, i];

        inttras := GetBrushTras(i, j, tp);
        
        inttras := 255 - (255 - inttras) * (255 - fpeParams_Paint.Transparence) div 255;

        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, fPeIeViewStatus.ShiftBy * i,j);

        pDestAlpha[j,i] := (ac * inttras) div 255;
      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_EraseAlphaWithBuffer;
var
  i, j: integer;

  inttras: byte;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  ac: byte;
  tp:byte;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  if (not fpeBitmap.HasAlphaChannel) then EXIT;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      if GetThroughMask then
      begin
        ac := pdestalpha[j, i];

        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, fPeIeViewStatus.ShiftBy * i,j);


        if (not fpeStatus.Buffermap[i, j].alpha) then
        begin
          fpeStatus.Buffermap[i, j].alpha := true;
          pBufAlpha[j,i] := max(0,  ac - (255 - fpeParams_Paint.Transparence));
        end;

        ac := (ac * inttras + pBufAlpha[j,i] * (255 - inttras)) div 255;

        pdestalpha[j, i] := ac;
      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_AirbrushWithBuffer;

var
  i, j: integer;
  r, g, b: integer;
  tempx: integer;
  inttras, inttrasBlend, inttrasAlpha, inttrasBlend_Buf: byte;

  BGRA: TbeBGRAbytearray;
  shiftby, readby: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;

  tp:byte;
  ac, ac_new: byte;

  bAlphaEditing: boolean;
  ablendmode: tbeblendmode;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
{
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
       pScanMask := fPeIEViewStatus.SelMask.ScanLine[my];
       if fPeIEViewStatus.SelMask.BitsPerPixel <>1 then
         inc(pScanMask, fpeStatus.xret1);
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1:
       begin
         mv := ord( (pbytearray(pScanMask)^[mx shr 3]) and  iebitmask1[mx and $7] <> 0);
        // mv := ord(fPeIEViewStatus.Mask.GetPixel(mx,my)>0);
       end;
       8:
       begin
         mv := pScanMask^;
         inc(pScanMask);
        // mv := fPeIEViewStatus.Mask.GetPixel(mx,my);
       end
       else mv := 255;
     end;

     result := mv > 0;
   end
   else
     result := true;

end;
}
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;
function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;

  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  r := getrvalue(fpeParams_Color.Color);
  g := getgvalue(fpeParams_Color.Color);
  b := getbvalue(fpeParams_Color.Color);

  if fpeParams_Paint.BlendMode = blmredeye then
    fpeBe.SetRedEyeGrayConsts(fpeParams_Color.Color);

  BGRA[0] := b;
  BGRA[1] := g;
  BGRA[2] := r;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
   
    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);


        if bAlphaEditing then
        begin
          ac := pdestalpha[j, i];

          inttrasBlend := BlendToAlphaTable[inttras, ac];
          inttrasBlend_Buf := BlendToAlphaTable[fpeParams_Paint.Transparence, ac];
        end
        else
        begin
          ac := 255;
          inttrasBlend := inttras;
          inttrasBlend_Buf := fpeParams_Paint.Transparence;
        end;

        //Starts rgb editing---------------------------------------------------
        if not fpeStatus.Buffermap[i, j].RGB then
        begin
          fpeStatus.Buffermap[i, j].RGB := true;
          // paint on the buffer to make it available
          if ac = 0 then
            ablendmode := blmnormal
          else
            ablendmode := fpeParams_Paint.BlendMode;
      

          fpebe.BlendDirect(pBuf, tempx, j, BGRA,  inttrasBlend_Buf, ablendmode, readby);
        end;

        fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttrasBlend, blmnormal, readby);
        //ends rgb editing----------------------------------------------------------------------------------

         //Starts alpha editing---------------------------------------------------
        if bAlphaEditing and (ac<255) then
        begin
          inttrasAlpha := PaintToAlphaTable[inttras, ac];

          if (not fpeStatus.Buffermap[i, j].alpha) then
          begin
            fpeStatus.Buffermap[i, j].alpha := true;
            pBufAlpha[j, i] := min(255, ac + 255 - fpeParams_Paint.Transparence);
          end;

          ac_new := (ac * inttrasAlpha + pBufAlpha[j, i] * (255 - inttrasAlpha)) div 255;
          pdestAlpha[j,i] := ac_new;
        end;

         //ends alpha editing---------------------------------------------------

      end;
    end;
  end;
end;






procedure TImageEnPaintEngine.Paint_AirbrushNoBuffer;
var
  i, j: integer;
  r, g, b: integer;
  tempx: integer;
  inttras, inttrasBlend, inttrasAlpha: byte;
  BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac: byte;
  bAlphaEditing: boolean;
  //ppa: pbebytearray;
  ablendmode: tbeblendmode;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;

  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  r := getrvalue(fpeParams_Color.Color);
  g := getgvalue(fpeParams_Color.Color);
  b := getbvalue(fpeParams_Color.Color);

  if fpeParams_Paint.BlendMode = blmredeye then
    fpeBe.SetRedEyeGrayConsts(fpeParams_Color.Color);

  BGRA[0] := b;
  BGRA[1] := g;
  BGRA[2] := r;

  tp := GetTabletDynamic_Opacity;


  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspbySelectivity(inttras, tempx, j);

        if bAlphaEditing then
        begin
          ac := pdestAlpha[j,i];
          if (ac<255) then
          begin
            inttrasAlpha := PaintToAlphaTable[inttras, ac];
            ac := (ac * inttrasAlpha + 255 * (255 - inttrasAlpha)) div 255;
            pdestalpha[j,i] := ac;
          end;
          inttrasBlend := BlendToAlphaTable[inttras, ac];
         end
        else
        begin
          ac := 255;
          inttrasBlend := inttras;
        end;

        if ac = 0 then
          ablendmode := blmnormal
        else
          ablendmode := fpeParams_Paint.BlendMode;


        fpebe.BlendDirect(pDest, tempx, j, BGRA, inttrasBlend, ablendmode, readby);

      end;
    end;
  end;
end;





procedure TImageEnPaintEngine.Paint_TextureWithBuffer;
var
  i, j, k: integer;

  tempx, tempxx: integer;
  inttras, inttrasBlend, inttrasAlpha, inttrasBlend_Buf: byte;

  BGRA: TbeBGRAbytearray;
  pp: pbebytearray;
  shiftby, readby: integer;

  xtexture, ytexture: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac, ac_new: byte;

  bAlphaEditing: boolean;
  ablendmode: tbeblendmode;
  //ppa: pbebytearray;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    ytexture := j mod fpeUtils.TextureH;
    pp := fpeParams_Texture.TextureBitmap.scanline[ytexture];

    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      xtexture := i mod fpeUtils.TextureW;
      if GetThroughMask then
      begin
        tempxx := shiftby * xtexture;

        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);


        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);


        if bAlphaEditing then
        begin
          ac := pdestalpha[j, i];

          inttrasBlend := BlendToAlphaTable[inttras, ac];
          inttrasBlend_Buf := BlendToAlphaTable[fpeParams_Paint.Transparence, ac];
         end
        else
        begin
          ac := 255;
          inttrasBlend := inttras;
          inttrasBlend_Buf := fpeParams_Paint.Transparence;
        end;

        //Starts rgb editing---------------------------------------------------
        if not fpeStatus.Buffermap[i, j].RGB then
        begin

          fpeStatus.Buffermap[i, j].RGB := true;

          for k := 0 to readby do
            BGRA[k] := pp[tempxx + k];

          // paint on the buffer to make it available
          if ac = 0 then
            ablendmode := blmnormal
          else
            ablendmode := fpeParams_Paint.BlendMode;

          fpebe.BlendDirect(pBuf, tempx, j, BGRA,  inttrasBlend_Buf, ablendmode, readby);
        end;

        fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttrasBlend, blmnormal, readby);
        //ends rgb editing----------------------------------------------------------------------------------

        //Starts alpha editing---------------------------------------------------
        if bAlphaEditing and (ac<255) then
        begin

          inttrasAlpha := PaintToAlphaTable[inttras, ac];

          if (not fpeStatus.Buffermap[i, j].alpha) then
          begin
            fpeStatus.Buffermap[i, j].alpha := true;

            pBufAlpha[j, i] := min(255, ac + 255 - fpeParams_Paint.Transparence);
          end;


          ac_new := (ac * inttrasAlpha + pBufAlpha[j, i] * (255 - inttrasAlpha)) div 255;

          pdestAlpha[j,i] := ac_new;
        end;

         //ends alpha editing---------------------------------------------------
       
      end;
    end;
  end;
end;

procedure TImageEnPaintEngine.Paint_TextureNobuffer;
var
  i, j, k: integer;

  tempx, tempxx: integer;
  inttras, inttrasBlend, inttrasAlpha: byte;
  BGRA: TbeBGRAbytearray;
  pp: pbebytearray;
  shiftby, readby: integer;

  xtexture, ytexture: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac: byte;
  bAlphaEditing: boolean;
  //ppa: pbebytearray;
  ablendmode: tbeblendmode;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    ytexture := j mod fpeUtils.TextureH;
    pp := fpeParams_Texture.TextureBitmap.scanline[ytexture];

    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      xtexture := i mod fpeUtils.TextureW;

      if GetThroughMask then
      begin

        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);



        if bAlphaEditing then
        begin
          ac := pdestAlpha[j,i];
          if (ac<255) then
          begin
            inttrasAlpha := PaintToAlphaTable[inttras, ac];
            ac := (ac * inttrasAlpha + 255 * (255 - inttrasAlpha)) div 255;
            pdestalpha[j,i] := ac;
          end;
          inttrasBlend := BlendToAlphaTable[inttras, ac];
        end
        else
        begin
          ac := 255;
          inttrasBlend := inttras;
        end;

        if ac = 0 then
          ablendmode := blmnormal
        else
          ablendmode := fpeParams_Paint.BlendMode;

        tempxx := shiftby * xtexture;

        for k := 0 to readby do
          BGRA[k] := pp[tempxx + k];
        fpebe.BlendDirect(pDest, tempx, j, BGRA, inttrasBlend, ablendmode, readby);

      end;
    end;
  end;
end;


procedure TImageEnPaintEngine.Paint_HistoryWithBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA, bgra1: TbeBGRAbytearray;   // , bgra2

  pHist, pHist_a: pbebytearray;
  shiftby, readby: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac, ac_hist: byte;
  bAlphaEditing: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  ac := 0;
  ac_hist := 0;
  pHist_a := nil;

  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    pHist := fpeParams_History.HistoryBitmap.scanline[j];

    if fpeParams_Paint.EnableEditAlphaChannel and fpeUtils.HistoryHasAlphaChannel then
      pHist_a := fpeParams_History.HistoryBitmap.AlphaChannel.scanline[j];


    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);

        if bAlphaEditing then
        begin
          ac := pDestAlpha[j,i];
          ac_hist := pHist_a[i];
        end;

        if not fpeStatus.Buffermap[i, j].RGB then
        begin
          fpeStatus.Buffermap[i, j].RGB := true;

          for k := 0 to readby do
          begin
            BGRA[k] := pHist[tempx + k];
            bgra1[k] := pBuf[j, tempx + k];
            pBuf[j, tempx + k] :=  fpebe.BlendLut[bgra1[k], BGRA[k]];
          end;
        end;

        for k := 0 to readby do
          bgra1[k] := pDest[j, tempx + k];

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);


        fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttras, blmnormal, readby);

        if bAlphaEditing then
        begin
          if not fpeStatus.Buffermap[i, j].alpha then
          begin
            pBufAlpha[j,i] := (ac_hist * (255 - fpeParams_Paint.Transparence) +
              ac * fpeParams_Paint.Transparence) div 255;
            fpeStatus.Buffermap[i, j].alpha := true;
          end;

          ac := (ac * inttras + pBufAlpha[j,i] * (255 - inttras)) div 255;

          pDestAlpha[j,i] := ac;
        end;

      end;
    end;
  end;

end;

procedure TImageEnPaintEngine.Paint_HistoryNoBuffer;
var
  i, j: integer;

  tempx: integer;
  inttras: byte;

  pHist: pbebytearray;
  //pDest_a: pbebytearray;
  pHist_a: pbebytearray;
  shiftby, readby: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;

  ac, ac_hist: byte;
  bAlphaEditing: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
  ac := 0;
  ac_hist := 0;
  pHist_a := nil;

  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    pHist := fpeParams_History.HistoryBitmap.scanline[j];

    if fpeParams_Paint.EnableEditAlphaChannel and fpeUtils.HistoryHasAlphaChannel then
      pHist_a := fpeParams_History.HistoryBitmap.AlphaChannel.scanline[j];

    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);


        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);

        if bAlphaEditing then
        begin
          ac := pDestAlpha[j,i];
          ac_hist := pHist_a[i];
        end;


        fpebe.BlendDirect(pDest, tempx, j, pHist, tempx, j, inttras, fpeParams_Paint.BlendMode, readby);

        if fpeParams_Paint.EnableEditAlphaChannel and fpeUtils.HistoryHasAlphaChannel
        then
        begin
          ac := (ac * inttras + ac_hist * (255 - inttras)) div 255;
          pDestAlpha[j,i] := ac;
        end;

      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_CloneWithBuffer(theAlphaMap: TPeAlphaMap);
var
  i, j, k: integer;

  tempx, tempxx: integer;
  inttras, inttrasBlend, inttrasAlpha, inttrasBlend_Buf: byte;

  BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;
  xclone, yclone: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac, ac_new, ac_map: byte;

  bAlphaEditing: boolean;
  ablendmode: tbeblendmode;
  //ppa: pbebytearray;

  bCloneSrcHasAlpha: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;
  bCloneSrcHasAlpha := (assigned(theAlphaMap) and assigned(theAlphaMap.Rows));



  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    yclone := j + fpeParams_Cloning.SrcPoint.y - fpeParams_Cloning.TgtPoint.y ;

    if (yclone >= 0) and (yclone < fpeUtils.CloneH) then
    begin
      tempx := shiftby * (fpeStatus.xret1) - shiftby;
      for i := fpeStatus.xret1 to fpeStatus.xret2 do
      begin
        inc(tempx, shiftby);


        if bCloneSrcHasAlpha then
          ac_map := theAlphaMap.GetValue(i, j)
        else
          ac_map := 255;

        if ac_map > 0 then
        begin

          xclone := i + fpeParams_Cloning.SrcPoint.x - fpeParams_Cloning.TgtPoint.x;
          if (xclone >= 0) and (xclone < fpeUtils.CloneW) then
          begin
            if GetThroughMask then
            begin
              tempxx := shiftby * xclone;


              inttras := GetBrushTras(i, j, tp);
              inttras := GetIntTras_byMask(inttras);

              if bCloneSrcHasAlpha then
                 inttras := ((255 - ac_map) * 255 + inttras * ac_map) div 255;


              if fpeParams_Paint.Selective then
                inttras := GetNewTranspBySelectivity(inttras, tempx,j);


              if bAlphaEditing then
              begin
                ac := pdestalpha[j, i];

                inttrasBlend := BlendToAlphaTable[inttras, ac];
                inttrasBlend_Buf := BlendToAlphaTable[fpeParams_Paint.Transparence, ac];
              end
              else
              begin
                ac := 255;
                inttrasBlend := inttras;
                inttrasBlend_Buf := fpeParams_Paint.Transparence;
              end;

              //Starts rgb editing---------------------------------------------------
              if not fpeStatus.Buffermap[i, j].RGB then
              begin
                fpeStatus.Buffermap[i, j].RGB := true;

                for k := 0 to readby do
                  BGRA[k] := pCloneBuf[yclone, tempxx + k];

                // paint on the buffer to make it available
                if ac = 0 then
                  ablendmode := blmnormal
                else
                  ablendmode := fpeParams_Paint.BlendMode;

                fpebe.BlendDirect(pBuf, tempx, j, BGRA,  inttrasBlend_Buf, ablendmode, readby);
              end;


              fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttrasBlend, blmnormal, readby);
              //ends rgb editing----------------------------------------------------------------------------------

              //Starts alpha editing---------------------------------------------------
              if bAlphaEditing and (ac<255) then
              begin
                inttrasAlpha := PaintToAlphaTable[inttras, ac];

                if (not fpeStatus.Buffermap[i, j].alpha) then
                begin
                  fpeStatus.Buffermap[i, j].alpha := true;

                  pBufAlpha[j, i] := min(255, ac + 255 - fpeParams_Paint.Transparence);
                end;

                ac_new := (ac * inttrasAlpha + pBufAlpha[j, i] * (255 - inttrasAlpha)) div 255;

                pdestAlpha[j,i] := ac_new;
              end;

             //ends alpha editing---------------------------------------------------

            end;
          end;
        end;
      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_CloneNoBuffer(theAlphaMap: TPeAlphaMap);
var
  i, j, k: integer;

  tempx, tempxx: integer;
  inttras, inttrasBlend, inttrasAlpha: byte;
   BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;
  xclone, yclone: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac, ac_map: byte;
  bAlphaEditing: boolean;
 // ppa: pbebytearray;
  ablendmode: tbeblendmode;
  bCloneSrcHasAlpha: boolean;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
  bCloneSrcHasAlpha := (assigned(theAlphaMap) and assigned(theAlphaMap.Rows));

  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
    fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    yclone := j + fpeParams_Cloning.SrcPoint.y - fpeParams_Cloning.TgtPoint.y;
    if (yclone >= 0) and (yclone < fpeUtils.CloneH) then
    begin


      tempx := shiftby * (fpeStatus.xret1) - shiftby;
      for i := fpeStatus.xret1 to fpeStatus.xret2 do
      begin
        inc(tempx, shiftby);


        xclone := i + fpeParams_Cloning.SrcPoint.x - fpeParams_Cloning.TgtPoint.x;
        if (xclone >= 0) and (xclone < fpeUtils.CloneW) then
        begin
          if GetThroughMask then
          begin
            inttras := TranspTable[GetBrushTras(i, j, tp)];
            inttras := GetIntTras_byMask(inttras);

            tempxx := shiftby * xclone;
            {
            for k := 0 to readby do
            begin
              bgra1[k] := pDest[j, tempx + k];
            end;
            }
            if fpeParams_Paint.Selective then
              inttras := GetNewTranspBySelectivity(inttras, tempx,j);

            if bCloneSrcHasAlpha then
            begin
              ac_map := theAlphaMap.GetValue(i, j);
              if ac_map>0 then
                inttras := ((255 - ac_map) * 255 + inttras * ac_map) div 255
              else
                inttras := 255;
            end;

              if bAlphaEditing then
              begin
                ac := pdestAlpha[j,i];
                if (ac<255) then
                begin
                  inttrasAlpha := PaintToAlphaTable[inttras, ac];
                  ac := (ac * inttrasAlpha + 255 * (255 - inttrasAlpha)) div 255;
                  pdestalpha[j,i] := ac;
                end;
                inttrasBlend := BlendToAlphaTable[inttras, ac];
              end
              else
              begin
                ac := 255;
                inttrasBlend := inttras;
              end;

              if ac = 0 then
                ablendmode := blmnormal
              else
                ablendmode := fpeParams_Paint.BlendMode;


              for k := 0 to readby do
                BGRA[k] := pCloneBuf[yclone, tempxx + k];
              fpebe.BlendDirect(pDest, tempx, j, BGRA, inttrasBlend, ablendmode, readby);
          end;
        end;
      end;
    end;
  end;
end;


procedure TImageEnPaintEngine.Paint_RetouchwithBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA, newBGRA: TbeBGRAbytearray;

  shiftby, readby: integer;
  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
  
    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);

        if not fpeStatus.Buffermap[i, j].RGB then
        begin
          fpeStatus.Buffermap[i, j].RGB := true;
          for k := 0 to readby do
            BGRA[k] := pBuf[j, tempx + k];

          newBGRA := BGRAFunction(BGRA, readby, fpeParams_Retouch.amount);

          for k := 0 to readby do
            pBuf[j, tempx + k] := fpebe.BlendLut[BGRA[k], newBGRA[k]];
        end;

        fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttras, blmnormal, readby);

      end;
    end;
  end;
end;



procedure TImageEnPaintEngine.Paint_RetouchNoBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin

    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);


        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);

        for k := 0 to readby do
          BGRA[k] := pDest[j, tempx + k];

        BGRA := BGRAFunction(BGRA, readby, fpeParams_Retouch.amount);


        fpebe.BlendDirect(pDest, tempx, j, BGRA, inttras, blmnormal, readby);

      end;
    end;
  end;
end;

procedure TImageEnPaintEngine.Paint_RetouchCustomwithBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA, newBGRA: TbeBGRAbytearray;

  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin
    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := GetBrushTras(i, j, tp);
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);


        if not fpeStatus.Buffermap[i, j].RGB then
        begin

          fpeStatus.Buffermap[i, j].RGB := true;
          for k := 0 to readby do
            BGRA[k] := pBuf[j, tempx + k];

          newBGRA := fpeParams_Retouch.RetouchCustom(BGRA);

          for k := 0 to readby do
            pBuf[j, tempx + k] := fpebe.BlendLut[BGRA[k], newBGRA[k]];
        end;

        fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttras, blmnormal, readby);
      end;
    end;
  end;
end;

procedure TImageEnPaintEngine.Paint_RetouchCustomNoBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
 // ac: byte;
 // bAlphaEditing: boolean;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
//  bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and fPeIEViewStatus.LayerhasAlpha;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin


    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);


        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);


        for k := 0 to readby do
          bgra[k] := pDest[j, tempx + k];

        BGRA := fpeParams_Retouch.RetouchCustom(bgra);

        fpebe.BlendDirect(pDest, tempx, j, BGRA, inttras, blmnormal, readby);

      end;
    end;
  end;
end;

procedure TImageEnPaintEngine.Paint_ConvolutionWithBuffer;
var
  i, j, k: integer;

  tempx: integer;
  inttras: byte;
  BGRA, newBGRA: TbeBGRAbytearray;

  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  try

    tp := GetTabletDynamic_Opacity;

    for j := fpeStatus.yret1 to fpeStatus.yret2 do
    begin
      tempx := shiftby * (fpeStatus.xret1) - shiftby;
      for i := fpeStatus.xret1 to fpeStatus.xret2 do
      begin
        inc(tempx, shiftby);

        if GetThroughMask then
        begin
          inttras := GetBrushTras(i, j, tp);
          inttras := GetIntTras_byMask(inttras);

          if fpeParams_Paint.Selective then
            inttras := GetNewTranspBySelectivity(inttras, tempx,j);


          if not fpeStatus.Buffermap[i, j].RGB then
          begin
            fpeStatus.Buffermap[i, j].RGB := true;
            newBGRA := _averagepixel(pBuf, j, i, shiftby,
              convcoeffs.convradius);
            for k := 0 to readby do
            begin
              BGRA[k] := pBuf[j, tempx + k];
              pBuf[j, tempx + k] := fpebe.BlendLut[BGRA[k], (newBGRA)[k]];
            end;
          end;

          fpebe.BlendDirect(pDest, tempx, j, pBuf, tempx, j, inttras, blmnormal, readby);
        end;
      end;
    end;
  except
    synchronize(FireOnDebug);
  end;
end;

procedure TImageEnPaintEngine.Paint_ConvolutionNoBuffer;
var
  i, j: integer;

  tempx: integer;
  inttras: byte;
  BGRA: TbeBGRAbytearray;

  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;

begin
  InitVars;

  shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

  tp := GetTabletDynamic_Opacity;

  for j := fpeStatus.yret1 to fpeStatus.yret2 do
  begin

    tempx := shiftby * (fpeStatus.xret1) - shiftby;
    for i := fpeStatus.xret1 to fpeStatus.xret2 do
    begin
      inc(tempx, shiftby);

      if GetThroughMask then
      begin
        inttras := TranspTable[GetBrushTras(i, j, tp)];
        inttras := GetIntTras_byMask(inttras);

        if fpeParams_Paint.Selective then
          inttras := GetNewTranspBySelectivity(inttras, tempx,j);

        BGRA := _averagepixel(pDest, j, i, shiftby, convcoeffs.convradius);
       
        fpebe.BlendDirect(pDest, tempx, j, BGRA, inttras, blmnormal, readby);

      end;
    end;
  end;

end;

procedure TImageEnPaintEngine.Paint_DeformationWithBuffer;

var
  i, j, k: integer;

  tempx, inttras: integer;
  bgra1, bgra2, BGRA3, BGRA4: TbeBGRAbytearray;
  shiftby, readby: integer;

  lastj, mx, my: integer; mv:byte; pScanMask: pbyte;
  tp:byte;
  ac: byte;
  bAlphaEditing: boolean;

  i_source_TempX, i_source_TempXX: integer;

  ac1, ac2, ac3, ac4: byte;

  weight_x, weight_y: array [0 .. 1] of single;
  mul1, mul2, mul3, mul4: single;
  i_sourcex, i_sourcey: integer;
  s_sourcex, s_sourcey: single;
  centerPt: Tpoint;
  HalfRadius: integer;



  function funz(fr: double; thedist: double; pow: double): double;
  var
    x: double;
    pcoef: double;
  begin
    x := min(1, thedist / max(1, fpeBrushStatus.PaintRadius));

    pcoef := power(x, pow);
    result := (1 - pcoef);
  end;

  procedure GetDefVal(dist: single; var val_def: single);
  var
    effectval: single;
    R, R1, R2: single;
    dist_norm, R_norm, R2_norm, coef: single;
  begin

    effectval := fpeParams_Warp.amount * fpeParams_Warp.CurrentStep / 255;

    case fpeParams_Warp.Kind of
      dk_WhirlCW:
        begin
          // val_def := effectval * max(0, (1 - sqrt(dist / fpeBrushStatus.PaintRadius)));
          val_def := effectval * funz(0, dist, 1 / 10);
        end;

      dk_WhirlACW:
        begin
          val_def := effectval * funz(0, dist, 1 / 10);
        end;

      dk_Bulge:
        begin
          val_def := effectval * max(0, (HalfRadius - abs(HalfRadius - dist))) /
            fpeBrushStatus.PaintRadius;
        end;
      dk_Pinch:
        begin
          R := Halfradius;
          R1 :=  Halfradius/ 4;
          R2 := Halfradius / 2;
          dist_norm := max(0, dist - R1);
          R_norm := R - R1;
          R2_norm := R2 - R1;

          coef := ( dist_norm/ R2_Norm) * max(0, (1 - dist_norm / R_Norm));
          val_def := effectval * coef;
        end;
    end;
  end;



  procedure GetSourceCoords_WhirlpoolC;
  var
  dist, angle: single;
  val_def: single;
  begin
    dist := sqrt(sqr(i - centerPt.x) + sqr(j - centerPt.y));
    GetDefVal(dist, val_def);
    angle := -val_def / 255 * 6 * pi;
    s_sourcex := (i - centerPt.x) * cos(angle) - (j - centerPt.y) *
      sin(angle) + centerPt.x;
    s_sourcey := (j - centerPt.y) * cos(angle) + (i - centerPt.x) *
      sin(angle) + centerPt.y;
  end;

  procedure GetSourceCoords_WhirlpoolA;
  var
  dist, angle: single;
  val_def: single;
  begin
    dist := sqrt(sqr(i - centerPt.x) + sqr(j - centerPt.y));
    GetDefVal(dist, val_def);
    angle := val_def / 255 * 6 * pi;
    s_sourcex := (i - centerPt.x) * cos(angle) - (j - centerPt.y) *
      sin(angle) + centerPt.x;
    s_sourcey := (j - centerPt.y) * cos(angle) + (i - centerPt.x) *
      sin(angle) + centerPt.y;
  end;

  procedure GetSourceCoords_Bulge;
  var
  amount, dist: single;
  val_def: single;
  arc_tan: single;
  begin
    arc_tan := 0;
    dist := sqrt(sqr(i - centerPt.x) + sqr(j - centerPt.y));
    GetDefVal(dist, val_def);
    amount := dist - val_def;
    if val_def > dist then
      amount := 0;

    if (i - centerPt.x <> 0) and (j - centerPt.y <> 0) then
      arc_tan := abs(arctan((j - centerPt.y) / (i - centerPt.x)))
    else
    begin
      if dist = 0 then
      begin
        s_sourcex := centerPt.x;
        s_sourcey := centerPt.y;
      end
      else
      begin
        if i = centerPt.x then
          arc_tan := pi / 2
        else
          arc_tan := 0;
      end;
    end;

    if j - centerPt.y > 0 then
      s_sourcey := centerPt.y + amount * sin(arc_tan)
    else
      s_sourcey := centerPt.y - amount * sin(arc_tan);

    if i - centerPt.x > 0 then
      s_sourcex := centerPt.x + amount * cos(arc_tan)
    else
      s_sourcex := centerPt.x - amount * cos(arc_tan);
  end;



  procedure GetSourceCoords_Pinch;
  var
  amount, dist: single;
  val_def: single;
  arc_tan: single;

  begin

    dist := sqrt(sqr(i - centerPt.x) + sqr(j - centerPt.y));
    GetDefVal(dist, val_def);
    amount := dist + val_def;

    arc_tan := 0;
    if (i - centerPt.x <> 0) and (j - centerPt.y <> 0) then
      arc_tan := abs(arctan((j - centerPt.y) / (i - centerPt.x)))
    else
    begin
      if dist = 0 then
      begin
        s_sourcex := centerPt.x;
        s_sourcey := centerPt.y;
      end
      else
      begin
        if i = centerPt.x then
          arc_tan := pi / 2
        else
          arc_tan := 0;
      end;
    end;

    if j - centerPt.y > 0 then
      s_sourcey := centerPt.y + amount * sin(arc_tan)
    else
      s_sourcey := centerPt.y - amount * sin(arc_tan);

    if i - centerPt.x > 0 then
      s_sourcex := centerPt.x + amount * cos(arc_tan)
    else
      s_sourcex := centerPt.x - amount * cos(arc_tan);
  end;

procedure InitVars;
begin
  mx := -1;
  my := -1;
  lastj := -1;
  mv := 0;
  pScanMask := nil;
end;
function GetThroughMask:boolean;
begin
   if fPeIEViewStatus.HasSelection then
   begin
     if lastj<>j then
     begin
       lastj := j;
       my :=j;
     end;
     mx := i;

     case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: mv := ord(fPeIEViewStatus.SelMask.GetPixel(mx,my)>0);
       8: mv := fPeIEViewStatus.SelMask.GetPixel(mx,my);
       else mv := 255;
     end;
     result := mv > 0;
   end
   else
     result := true;
end;

function GetIntTras_byMask(value:byte): byte;
begin
  if fPeIEViewStatus.HasSelection then
  begin
    if mv=0 then
      result := 255
    else
    begin
       case fPeIEViewStatus.SelMask.BitsPerPixel of
       1: result := inttras;  //mv = 1
       8: result := ((255 - mv) * 255 + inttras * mv) div 255;
       else result := inttras;
      end;
    end;
  end
  else
    result := value;
end;
begin
  InitVars;
  centerPt := point(fpeCoords.CurX, fpeCoords.CurY);
  HalfRadius := fpeBrushStatus.PaintRadius div 2;

  try

    tp := GetTabletDynamic_Opacity;

    // ------sleeps waiting the righ time interval set by the user-------
    if fpeParams_Warp.CurrentStep > 0 then
      sleep(fpeParams_Warp.StepTime);

    // ------Calculate current step to apply progressive deformation intensities-------
    fpeParams_Warp.CurrentStep :=
      min(255, fpeParams_Warp.CurrentStep + round(tp/255 * fpeParams_Warp.Step)); //fixed v.3.2

    bAlphaEditing := fpeParams_Paint.EnableEditAlphaChannel and
      fPeIEViewStatus.LayerhasAlpha;

    shiftby := fPeIeViewStatus.ShiftBy; readby := fPeIeViewStatus.ReadBy;

    for j := fpeStatus.yret1 to fpeStatus.yret2 do
    begin

      tempx := shiftby * (fpeStatus.xret1) - shiftby;
      for i := fpeStatus.xret1 to fpeStatus.xret2 do
      begin
        inc(tempx, shiftby);

        if GetThroughMask then
        begin

          case fpeParams_Warp.Kind of
            dk_WhirlCW:
              begin
                GetSourceCoords_WhirlpoolC;
              end;
            dk_WhirlACW:
              begin
                GetSourceCoords_WhirlpoolA;
              end;
            dk_Bulge:
              begin
                GetSourceCoords_Bulge;
              end;
            dk_Pinch:
              begin
                GetSourceCoords_Pinch;
              end;
          end;

          i_sourcey := trunc(s_sourcey);
          i_sourcex := trunc(s_sourcex);
          if (i_sourcex > 0) and (i_sourcex < fpeStatus.Buffer.width - 1) and
            (i_sourcey > 0) and (i_sourcey < fpeStatus.Buffer.height - 1) then
          begin
            // tempx := shiftby * i;
            i_source_TempX := shiftby * i_sourcex;
            i_source_TempXX := i_source_TempX + shiftby;


            // fPEStatus.Buffermap8bits[i, j].RGB := val_RGB;

            // Calculate the weights.
            weight_y[1] := s_sourcey - i_sourcey;
            weight_y[0] := 1 - weight_y[1];
            weight_x[1] := s_sourcex - i_sourcex;
            weight_x[0] := 1 - weight_x[1];

            mul1 := weight_x[0] * weight_y[0];
            mul2 := weight_x[0] * weight_y[1];
            mul3 := weight_x[1] * weight_y[0];
            mul4 := weight_x[1] * weight_y[1];

            for k := 0 to readby do
            begin
              bgra1[k] := pBuf[i_sourcey, i_source_TempX + k];
              bgra2[k] := pBuf[i_sourcey + 1, i_source_TempX + k];
              BGRA3[k] := pBuf[i_sourcey, i_source_TempXX + k];
              BGRA4[k] := pBuf[i_sourcey + 1, i_source_TempXX + k];
            end;

            for k := 0 to readby do
            begin
              // BGRA[k] := round(BGRA1[k] * mul1 + BGRA2[k] * mul2 + BGRA3[k] * mul3 + BGRA4[k] * mul4);
              pDest[j, tempx + k] :=
                round(bgra1[k] * mul1 + bgra2[k] * mul2 + BGRA3[k] * mul3 +
                BGRA4[k] * mul4);
            end;

            if bAlphaEditing then
            begin
              ac1 := fpeStatus.Buffer.AlphaChannel.Pixels_ie8
                [i_sourcex, i_sourcey];
              ac2 := fpeStatus.Buffer.AlphaChannel.Pixels_ie8
                [i_sourcex, i_sourcey + 1];
              ac3 := fpeStatus.Buffer.AlphaChannel.Pixels_ie8[i_sourcex + 1,
                i_sourcey];
              ac4 := fpeStatus.Buffer.AlphaChannel.Pixels_ie8[i_sourcex + 1,
                i_sourcey + 1];

              ac := round(ac1 * mul1 + ac2 * mul2 + ac3 * mul3 + ac4 * mul4);

              pDestAlpha[j,i] := ac;
            end;

          end;

        end;
      end;
    end;
  except
    synchronize(FireOnDebug);
  end;

end;

procedure TImageEnPaintEngine.Paint_ObjectWithBuffer;
begin

end;

procedure TImageenPaintEngine.Handle_DrawCanvas(sender:TObject; cv: TCanvas; aRect:TRect);
procedure _PrepareCanvas(cv:Tcanvas);
  begin
    with cv do
    begin
      brush.style := bsclear;
      pen.Mode := pmNotXor;
      pen.Color := clred;
      pen.width := 1;
    end;
  end;
begin
  ReleaseImageEnDrawCanvas;

 // cv.TextOut(aRect.left, aRect.Top, 'Y');

  if fpeParams_Paint.ShowBrushShape then
  begin
    _PrepareCanvas(cv);
     cv.ellipse(fpestatus.CursorRect);
     fPeCursorList.Add(tPECursorInfo.Create(fpeStatus.CursorRect))
  end;

  if assigned(fOldDrawCanvas) then
    fOldDrawCanvas(sender, cv, aRect);

end;

procedure TImageenPaintEngine.Handle_DrawBackBuffer(sender:TObject);
procedure _PrepareCanvas(cv:Tcanvas);
  begin
    with cv do
    begin
      brush.style := bsclear;
      pen.Mode := pmNotXor;
      pen.Color := clred;
      pen.width := 1;
    end;
  end;
begin
  if terminated then
  begin
    ReleaseImageEnDrawBackBuffer;
    EXIT;
  end;


  if assigned(fOldDrawBackBuffer) then
    fOldDrawBackBuffer(fpeimageen);


  if fpeParams_Paint.ShowBrushShape then
  begin
    _PrepareCanvas(fpeImageen.BackBuffer.Canvas);
     fpeImageen.BackBuffer.Canvas.ellipse(fpestatus.CursorRect);
     fPeCursorList.Add(tPECursorInfo.Create(fpeStatus.CursorRect));
  end;

  if fpeParams_Paint.Mode = pemclone then
  begin
    if fpeParams_Cloning.ShowBrush then
    begin

      Case fpeParams_Cloning.SrcType of
      cst_ImageEn, cst_IEBitmap:
          begin
            if assigned(fpeParams_Cloning.SrcImageEn) then
            // added in 3.0.4.1 patch to avoid AV
            begin
              if fpeParams_Cloning.SrcImageEn = fpeImageen then
              // Cloning from the same
              // Imageenview as the target
              begin
                _PrepareCanvas(fpeImageen.BackBuffer.Canvas);
                fpeImageen.BackBuffer.Canvas.ellipse(fpeStatus.CursorRect_Clone);
                fPeCursorList.Add(tPECursorInfo.Create(fpeStatus.CursorRect_Clone));
              end
              else
              begin // source imageenview is different from target
                _PrepareCanvas(fpeParams_Cloning.SrcImageEn.BackBuffer.Canvas);
                fpeParams_Cloning.SrcImageEn.GetCanvas.ellipse(fpeStatus.CursorRect_Clone);
                fPeCursorCloneList.Add(tPECursorInfo.Create(fpeStatus.CursorRect_Clone));
              end;
            end;
          end;
        cst_IELayer:
          begin

          end;

      end;
    end;
  end;
  
end;

procedure TImageEnPaintEngine.FireOnStartedPainting;
begin


  if assigned(fpeOnStartedPainting) then
    fpeOnStartedPainting(self);
end;

procedure TImageEnPaintEngine.FireOnFinishedPainting;
begin
  try
    if assigned(fpeOnFinishedPainting) then
      fpeOnFinishedPainting(self);
  except
    ;
  end;
 {
  showmessage('Upd. Requests: ' + inttostr(fpestatus.CtrRefreshRequests) + #13#10
              + 'UpdRect: ' + inttostr(fpestatus.CtrRefreshDone)+ #13#10
              + 'Updall: ' + inttostr(fpestatus.CtrRefreshAll)+ #13#10
              + 'Acq.Pos. Single: ' + inttostr(fpestatus.CtrAcqPosSingle)+ #13#10
              + 'Acq.Pos. Multi: ' + inttostr(fpestatus.CtrAcqPosMulti)
              );
}
end;

procedure TImageEnPaintEngine.FireOnDebug;
begin
  if assigned(fpeOnDebugging) then
    fpeOnDebugging(self);
end;





end.
