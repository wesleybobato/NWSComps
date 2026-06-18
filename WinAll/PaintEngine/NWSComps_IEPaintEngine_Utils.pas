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

unit NWSComps_IEPaintEngine_Utils;
{$R-}
{$Q-}
{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_IEPaintEngine.inc}

interface
uses
  Windows, SysUtils, Classes, forms, Graphics, math, messages, dialogs, extctrls, controls
  , hyieutils, hyiedefs,{$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF} imageenproc, imageenview;


type




   (*
  TbeUndoRedoRecord = record
    Index: integer;
    UndoKind: TIEUndoSource;
    LayerID: integer;
  end;

  TbeUndoRedoRecordArray = array of TbeUndoRedoRecord;
   *)
  TbebitArray = array[0..32767] of boolean;
  pbebitArray = ^TbebitArray;
  TbebyteArray = array[0..32767] of byte;
  pbebyteArray = ^TbebyteArray;
  TbeRGBArray = array[0..32767] of TRGBTriple;
  pbeRGBArray = ^TbeRGBArray;
  TbeRGBQuadArray = array[0..32767] of TRGBQuad;
  pbeRGBQuadArray = ^TbeRGBQuadArray;

  TbeBGRAbytearray = array[0..3] of byte;
  TbeBGRAsinglearray = array[0..3] of single;
  TbeBGRAintarray = array[0..3] of integer;
  TbeBGRAint64array = array[0..3] of int64;

  TbeBGRAGraybytearray = array[0..4] of byte;
  TbeBGRAGraysinglearray = array[0..4] of single;
  TbeBGRAGrayintarray = array[0..4] of integer;
  TbeBGRAGrayint64array = array[0..4] of int64;

  TbeLUT = array[0..255] of byte;
  TbeLUT2x2 = array[0..255] of array[0..255] of byte;

  TbeLUTarray = array[0..3] of TbeLUT;

  TbeHueRangeLUT = array[0..360] of byte;

  Tbebooleanmask = array of array of boolean;

  Tbepixelformat = (bepf8, bepf16, bepf24, bepf32, bepfother);
  Tbebrightmode = (bmShadows, bmMidlights, bmHilights, bmAll);
  Tbeblendmode = (blmnormal, blmaverage, blmColorize,  blmoverlay, blmhardlight, blmmultiply, blmscreen, blmdifference, blmredeye);

  TbeRetouchMode = (rmblur, rmsharpen, rmdodge, rmburn, rmLighten, rmDarken, rmSaturate, rmDesaturate);
  TbeBGRAgrayconsts = array[0..3] of single;





  tpepointarray = array of Tpoint;
  tpebrusharray = array of array of byte;
  tpebrushrow = array [0 .. 0] of byte;
  ppebrushrow = ^tpebrushrow;
  tpebrushrowarray = array of ppebrushrow;
  tperow = array [0 .. 0] of byte;
  pperow = ^tperow;
  tperowarray = array of pperow;

  TPEUpdateMode = (umEachLine, umEachStroke);
  TPEUpdatePriority = (upHigh, upMedium, upLow);

  TPeAlphaMap = class
  public
    Rows: tperowarray;
    dx: integer;
    dy: integer;
    Width: integer;
    Height: integer;

    function GetValue(x, y: integer): byte;
  end;

  TPeBufferBoolean = record
    RGB: boolean;
    alpha: boolean;
  end;

  TPeBufferByte = record
    RGB: byte;
    alpha: byte;
  end;

  tPeNotRunningStatus = record
    Flag_InsideImageEn: boolean;
  end;

  tPeStatus = record
    HasRunningRequisites: boolean;
    EditedRect: Trect;
    UseBuffer: boolean;
    UseBuffer_Deform: boolean;
    UseBuffer_Selectivity: boolean;

    Buffer: TIEbitmap;
    Buffermap: array of array of TPeBufferBoolean;

    Buffer_Sel: TIEbitmap;

    Xmask1, Xmask2, Ymask1, Ymask2: integer;

    RefreshRect_Cur: TRect;
    RefreshRect_Sync: TRect;

    Refresh_Limit: double;
    Refresh_TickCount: cardinal;
    Sel_TickCount: cardinal;
    Paint_TickCount: cardinal;
    Cursor_TickCount: cardinal;
    CtrRefreshRequests: integer;
    CtrRefreshDone: integer;
    CtrRefreshAll: integer;
    CtrAcqPosSingle: integer;
    CtrAcqPosMulti: integer;

    CursorRect_Clone: TRect;
    CursorRect: TRect;

    xret1, yret1, xret2, yret2: integer;

    NStrokes: integer;
  end;

  tPeCoords = record
    mouse_x, mouse_y: integer;

    CurX, CurY, CurPrevX, CurPrevY, memx, memy, mem1x, mem1y, mem2x, mem2y: integer;

    ret_array: array of Tpoint;
    ret_counter: integer;
    ret_idx: integer;
  end;

  TPEBrushStatus = record
    BrushArray, BrushArray_Fixed: tpebrusharray;
    OffSetX, OffSetY: integer;
    PaintRadius: integer;
    PaintRadiusFixed: integer;
  end;

  TPeImageEnStatus = record
    SelMask: Tiemask;
    HasSelection: boolean;
    SelAnimated: boolean;
    SelVisible: boolean;
    ZoomF: double;
    ZoomFilter: TResampleFilter;
    Scrx, Scry: integer;
    BgIsNormal:boolean;
    PixelFmt: tbepixelformat;
    ShiftBy: integer;
    ReadBy: integer;
    BitmapW: integer;
    BitmapH: integer;
    LayerW: integer;
    LayerH: integer;
    LayerX: integer;
    LayerY: integer;
    LayerhasAlpha: boolean;
    LayerCount: integer;
  end;

  TpeUtilsStatus = record

    AverageBGRA: TbeBGRAbytearray;
    AverageBGRAsat, AverageBGRAhue, AverageBGRAlum: single;
    TextureW: integer;
    TextureH: integer;
    CloneW: integer;
    CloneH: integer;
    HistoryW: integer;
    HistoryH: integer;
    HistoryHasAlphaChannel: boolean;
  end;

  tPECursorInfo = class
    CursorRect:TRect;

    constructor Create(theRect:TRect);
  end;


function BE_Brightness(amount, x: single; brightnessmode: TBeBrightmode): single;
procedure BE_Getpixelformat(var thebepf: Tbepixelformat; thebitmap: tbitmap); overload;
procedure BE_Getpixelformat(var thebepf: Tbepixelformat; thebitmap: tIEbitmap); overload;

const
  beRedEyeBGRAGrayconsts_a: TbeBGRAgrayconsts = (0.33, 0.56, 0.11, 0);
  beRedEyeBGRAGrayconsts_b: TbeBGRAgrayconsts = (0.36, 0.52, 0.12, 0);
  beBGRAgrayconsts_a: TbeBGRAgrayconsts = (0.1, 0.55, 0.35, 0);
  beBGRAgrayconsts_b: TbeBGRAgrayconsts = (0.33, 0.34, 0.33, 0);


   // Classes //--------------------------------------------------------------------------



////////////////////////////////////Main Class//////////////////////////////////////////////
type

  TpeBitmapEditor = class(TImageEnProc)
  private
    fbitmap: Tbitmap;
    fBlendLutMode: Tbeblendmode;
    fBlendLutTransp: byte;
    fblendlut: TbeLUT2x2;
    function KeepinRange(Thevalue: integer): byte;
  public

    property EditBitmap: Tbitmap read fbitmap write fbitmap;
    property BlendLut: TbeLUT2x2 read fBlendLut;

    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;

    function BGRAtoColor(TheBGRA: TbeBGRAbytearray): Tcolor;
    function InvertedBGRA(TheBGRA: TbeBGRAbytearray): TbeBGRAbytearray;
    function AmplifyBGRA(TheBGRA: TbeBGRAbytearray): TbeBGRAbytearray;

    procedure SetRedEyeGrayConsts(eyecolor: tcolor);
    procedure CalcBlendLUT(inttras: byte; blendmode: Tbeblendmode);


    function Blendchannel(backchan, forechan, inttras: byte; blendmode: Tbeblendmode): byte;overload;


    function Blendpixel(backBGRA, foreBGRA: TbeBGRAbytearray; inttras: byte;
                        blendmode: Tbeblendmode;
                        readby: integer): TbeBGRAbytearray;




    procedure BlendDirect(pDest:tperowarray; const xDest, yDest: integer;
                          pSrc:tperowarray; const xSrc, ySrc: integer;
                          const inttras: byte;
                          const blendmode: Tbeblendmode;
                          const readby: integer); overload;

    procedure BlendDirect(pDest:tperowarray; const xDest, yDest: integer;
                          pSrc:pbebytearray; const xSrc, ySrc: integer;
                          const inttras: byte;
                          const blendmode: Tbeblendmode;
                          const readby: integer); overload;

    procedure BlendDirect(pDest:tperowarray; const xDest, yDest: integer;
                          srcBGRA: TbeBGRAbytearray;
                          const inttras: byte;
                          const blendmode: Tbeblendmode;
                          const readby: integer); overload;


    procedure GetMaskRect(var X1, Y1, X2, Y2: integer; var mask: TIEMask);

    function GetGrayValue(BGRA: TbeBGRAbytearray; consts: TbeBGRAgrayconsts; readby: integer): byte; overload;
    function GetGrayValue(blm: TBeblendmode; BGRA: TbeBGRAbytearray; readby: integer): byte; overload;
    function GetGrayValue(blm: TBEBlendmode; pRow:tperowarray; x,y: integer; readby: integer): byte; overload;
  published

  end;

///////////////////////////////////////////////////////////////////////////////////////////



implementation

const
  bepstep = 50;

var
  fbeRedEyeconsts: TbeBGRAgrayconsts;

// This works for every Tbitmap with pformat 32,24,16,8 bits
//1 bit bitmap are not supported

function BE_Brightness(amount, x: single; brightnessmode: Tbebrightmode): single;
begin
  result := x;
  if abs(amount) < 0.01 then exit;
  case brightnessmode of
    bmShadows:
      result := x + (255 - x) * amount / 255;
    bmMidlights:
      result := (255 * x + 2 * (255 - x) * amount * x / 255) / 255;
    bmhilights:
      result := x + x * amount / 255;
    bmAll:
      result := x + amount;
  end;
end;


procedure BE_Get_Shiftby_Readby_Values(var Shiftby, Readby: integer;
  bepf: Tbepixelformat; preservealpha: boolean);
begin
  case bepf of
    bepf8: shiftby := 1;
    bepf16: shiftby := 2;
    bepf24: shiftby := 3;
    bepf32: shiftby := 4;
  end;
  readby := shiftby - 1;
  if preservealpha and (bepf = bepf32) then readby := 2; //add this if you want to preserve the alpha channel from changing in 32bit mode
end;


procedure BE_Getpixelformat(var thebepf: Tbepixelformat; thebitmap: tbitmap);
begin
  with thebitmap do
  begin
    case pixelformat of
      pf8bit:
        thebepf := bepf8;
      pf16bit:
        thebepf := bepf16;
      pf24bit:
        thebepf := bepf24;
      pf32bit:
        thebepf := bepf32;
    else
      thebepf := bepfother;
    end;
  end;
end;

procedure BE_Getpixelformat(var thebepf: Tbepixelformat; thebitmap: tIEbitmap);
begin
  with thebitmap do
  begin
    case pixelformat of
      ie8p:
        thebepf := bepf8;
      ie24RGB:
        thebepf := bepf24;
    else
      thebepf := bepfother;
    end;
  end;
end;


procedure BE_GetEditCoords(var x1, y1, x2, y2: integer; ERect: Trect; bmpw, bmph: integer);
begin
  x1 := max(0, erect.left);
  y1 := max(0, erect.top);
  x2 := min(bmpw - 1, erect.right);
  y2 := min(bmph - 1, erect.bottom);
end;




//---------------------------- TpeBitmapEditor -----------------------------------------



constructor TpeBitmapEditor.create(Owner: TComponent);
begin
  inherited;
  fBlendLutTransp := 0;
  fBlendLutMode := blmnormal;
end;

destructor TpeBitmapEditor.Destroy;
begin

  inherited;
end;


procedure TpeBitmapEditor.SetRedEyeGrayConsts(eyecolor: tcolor);
var
  r, b: byte;
  ratio: single;
  i: integer;
begin
  r := getrvalue(eyecolor);
  b := getbvalue(eyecolor);
  ratio := b / max(1, b + r);
  for i := 0 to 3 do
    fberedeyeconsts[i] := ratio * beRedEyeBGRAGrayconsts_a[i] + (1 - ratio) * beRedEyeBGRAGrayconsts_b[i];
end;


function TpeBitmapEditor.BGRAtoColor(TheBGRA: TbeBGRAbytearray): Tcolor;
begin
  Result := RGB(TheBGRA[2], TheBGRA[1], TheBGRA[0]);
end;


function TpeBitmapEditor.InvertedBGRA(TheBGRA: TbeBGRAbytearray): TbeBGRAbytearray;
var
  k: integer;
begin
  for k := 0 to 3 do
    Result[k] := 255 - TheBGRA[k];
end;


function TpeBitmapEditor.AmplifyBGRA(TheBGRA: TbeBGRAbytearray): TbeBGRAbytearray;
var
  k: integer;
  maxv: byte;
begin
  maxv := TheBGRA[0];
  for k := 1 to 2 do
    maxv := max(maxv, TheBGRA[k]);

  for k := 0 to 2 do
    if TheBGRA[k] <> maxv then
      Result[k] := round(TheBGRA[k] / 1.5)
    else
      result[k] := min(round(TheBGRA[k] * 1.55), 255);
end;


function TpeBitmapEditor.KeepinRange(Thevalue: integer): byte;
begin
  if Thevalue > 255 then
    Result := 255
  else if Thevalue < 0 then
    Result := 0
  else
    Result := Thevalue;
end;


procedure TpeBitmapEditor.CalcBlendLUT(inttras: byte; blendmode: Tbeblendmode);
var
  iback, ifore: integer;
begin
  fBlendLutMode := blendmode;
  fBlendLutTransp := inttras;
  for iback := 0 to 255 do
    for ifore := 0 to 255 do
      fblendlut[iback, ifore] := blendchannel(iback, ifore, inttras, blendmode);
end;


function TpeBitmapEditor.GetGrayValue(blm: TBEBlendmode; pRow: tperowarray; x, y,
  readby: integer): byte;
var
  BGRA: TbeBGRAbytearray;
  k:integer;
begin
  for k := 0 to readby do
    BGRA[k] := pRow[y,x];

  result := GetGrayValue(blm, BGRA, readby);

end;

function TpeBitmapEditor.GetGrayValue(blm: TBeblendmode; BGRA: TbeBGRAbytearray;
  readby: integer): byte;
begin
  case blm of
    blmColorize: result := GetGrayValue(BGRA, beBGRAgrayconsts_a, readby);
    blmredeye: result := GetGrayValue(BGRA, fbeRedEyeconsts, readby);
    else result := 127;
  end;
end;

function TpeBitmapEditor.GetGrayValue(BGRA: TbeBGRAbytearray; consts: TbeBGRAgrayconsts; readby: integer): byte;
var
k:integer;
begin
   result := 0;
   for k := 0 to readby do
     result := result + round(consts[k] * BGRA[k]);
end;

function TpeBitmapEditor.Blendchannel(backchan, forechan, inttras: byte; blendmode: Tbeblendmode): byte;
var
  temp: byte;
  tempSqr: integer;
  blended: byte;
begin

  case blendmode of
    blmnormal:
      blended := forechan;
    blmaverage:
      blended := (backchan + forechan) div 2;
    
    blmoverlay:
      begin
        tempSqr := backchan * backchan;
        blended := (2 * forechan * backchan - 2 * forechan * tempSqr div 255 + tempSqr) div 255;
      end;
    
    blmdifference:
      blended := abs(backchan - forechan);
    blmmultiply:
      blended := backchan * forechan div 255;
    blmscreen:
      blended := 255 - ((255 - backchan) * (255 - forechan) div 255);
    blmhardlight:
      begin
        temp := backchan * forechan div 255;
        blended := (forechan * (forechan + backchan - temp) + temp * (255 - forechan)) div 255;
      end;
    else
      blended := forechan;
  end;



  if inttras > 0 then
    result := (backchan * inttras + blended * (255 - inttras)) div 255
  else
    result := blended;

end;

procedure TpeBitmapEditor.BlendDirect(pDest:tperowarray; const xDest, yDest: integer;
                          pSrc:tperowarray; const xSrc, ySrc: integer;
                          const inttras: byte;
                          const blendmode: Tbeblendmode;
                          const readby: integer);
var
  k: integer;
  foreBGRA, backBGRA, BGRA: TbeBGRAbytearray;
begin
  case blendmode of
    blmColorize, blmredeye:
    begin
      for k := 0 to readby do
      begin
        foreBGRA[k] := pSrc[ySrc, xSrc + k];
        backBGRA[k] := pDest[yDest, xDest + k];
      end;
      BGRA := Blendpixel(backBGRA, foreBGRA, inttras, blendmode, readby);

      for k := 0 to readby do
        pDest[yDest, xDest + k] := BGRA[k];

      EXIT; //>>>>EXIT
    end;
  end;


  if (inttras = fBlendLutTransp) and (blendmode = fBlendLutMode) then
  begin
    for k := 0 to readby do
      pDest[yDest, xDest + k] := fblendlut[pDest[yDest, xDest + k], pSrc[ySrc, xSrc + k]];
    EXIT; //>>>>EXIT
  end;

    //else normal blending
     for k := 0 to readby do
      pDest[yDest, xDest + k] := Blendchannel(pDest[yDest, xDest + k], pSrc[ySrc, xSrc + k], inttras, blendmode);

end;

procedure TpeBitmapEditor.BlendDirect(pDest: tperowarray; const xDest,
                                    yDest: integer; pSrc: pbebytearray; const xSrc, ySrc: integer;
                                    const inttras: byte; const blendmode: Tbeblendmode; const readby: integer);
var
  k: integer;
   foreBGRA, backBGRA, BGRA: TbeBGRAbytearray;
begin
    case blendmode of
    blmColorize, blmredeye:
    begin
      for k := 0 to readby do
      begin
        foreBGRA[k] := pSrc[xSrc + k];
        backBGRA[k] := pDest[yDest, xDest + k];
      end;
      BGRA := Blendpixel(backBGRA, foreBGRA, inttras, blendmode, readby);

      for k := 0 to readby do
        pDest[yDest, xDest + k] := BGRA[k];

      EXIT; //>>>>EXIT
    end;
  end;

  if (inttras = fBlendLutTransp) and (blendmode = fBlendLutMode) then
  begin
    for k := 0 to readby do
      pDest[yDest, xDest + k] := fblendlut[pDest[yDest, xDest + k], pSrc[xSrc + k]];
    EXIT; //>>>>EXIT
  end;

    //else normal blending
  for k := 0 to readby do
    pDest[yDest, xDest + k] := Blendchannel(pDest[yDest, xDest + k], pSrc[xSrc + k], inttras, blendmode);
end;

procedure TpeBitmapEditor.BlendDirect(pDest:tperowarray; const xDest, yDest: integer;
                          srcBGRA: TbeBGRAbytearray;
                          const inttras: byte;
                          const blendmode: Tbeblendmode;
                          const readby: integer);
var
  k: integer;  foreBGRA, backBGRA, BGRA: TbeBGRAbytearray;
begin
  case blendmode of
    blmColorize, blmredeye:
    begin
      foreBGRA := srcBGRA;
      for k := 0 to readby do
      begin
        backBGRA[k] := pDest[yDest, xDest + k];
      end;
      BGRA := Blendpixel(backBGRA, foreBGRA, inttras, blendmode, readby);

      for k := 0 to readby do
        pDest[yDest, xDest + k] := BGRA[k];

      EXIT; //>>>>EXIT
    end;
  end;

  if (inttras = fBlendLutTransp) and (blendmode = fBlendLutMode) then
  begin
    for k := 0 to readby do
      pDest[yDest, xDest + k] := fblendlut[pDest[yDest, xDest + k], srcBGRA[k]];
    EXIT; //>>>>EXIT
  end;

  //else normal blending
  for k := 0 to readby do
    pDest[yDest, xDest + k] := Blendchannel(pDest[yDest, xDest + k], srcBGRA[k], inttras, blendmode);

end;







function TpeBitmapEditor.Blendpixel(backBGRA, foreBGRA: TbeBGRAbytearray; inttras: byte;
                                  blendmode: Tbeblendmode;
                                  readby: integer): TbeBGRAbytearray;
var
  k: integer;
  grayBG: byte;
  temp: byte;
begin
  result := backBGRA;

  case blendmode of
    blmColorize:
    begin
       grayBG := GetGrayValue(backBGRA, beBGRAgrayconsts_a, readby);
        for k := 0 to readby do
        begin
          temp := (foreBGRA[k] * grayBG) div 255;
          result[k] := (grayBG * (foreBGRA[k] + grayBG - temp) + (255 - grayBG) * temp) div 255;
          result[k] := (backBGRA[k] * inttras + result[k] * (255 - inttras)) div 255;
        end;
    end;
    blmredeye:
    begin
        grayBG := GetGrayValue(backBGRA, fbeRedEyeconsts, readby);
        for k := 0 to readby do
        begin
          temp := (foreBGRA[k] * grayBG) div 255;
          result[k] := (grayBG * (foreBGRA[k] + grayBG - temp) + (255 - grayBG) * temp) div 255;
          result[k] := (backBGRA[k] * inttras + result[k] * (255 - inttras)) div 255;
        end;
    end
    else
    begin
      for k := 0 to readby do
      begin
        result[k] := blendchannel(backBGRA[k], foreBGRA[k], inttras, blendmode);
      end;
    end;
  end;

end;



procedure TpeBitmapEditor.GetMaskRect(var X1, Y1, X2, Y2: integer; var mask: TIEMask);
var

//  ImageEnView: TImageEnView;
  fPolyS: PPointArray;
  fPolySCount: integer;
begin
  GetReSel(x1, y1, x2, y2, fPolyS, fPolySCount, mask);
end;


{ TPeAlphaMap }

function TPeAlphaMap.GetValue(x, y: integer): byte;
begin
   if (y + dy >= 0) and (y + dy < Height)
        and (x + dx >= 0) and (x + dx < Width) then
          result := Rows[y + dy, x + dx]
        else
          result := 0;
end;


{ tPECursorInfo }

constructor tPECursorInfo.Create(theRect: TRect);
begin
  CursorRect := theRect;
end;

initialization
  fbeRedEyeconsts[0] := beRedEyeBGRAGrayconsts_a[0];
  fbeRedEyeconsts[1] := beRedEyeBGRAGrayconsts_a[1];
  fbeRedEyeconsts[2] := beRedEyeBGRAGrayconsts_a[2];
  fbeRedEyeconsts[3] := beRedEyeBGRAGrayconsts_a[3];


end.
