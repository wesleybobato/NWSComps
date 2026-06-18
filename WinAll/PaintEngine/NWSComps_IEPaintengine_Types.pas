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
unit NWSComps_IEPaintengine_Types;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_IEPaintEngine.inc}



  uses  Windows, Classes, sysutils, controls, math,
  ImageEnview, hyiedefs, hyieutils,
  {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF}
  {$IFDEF IMAGEEN_7_0_0_LATER}  iexLayers, {$ENDIF}
  NWSComps_DataParser,
  NWSComps_IEPaintEngine_Const, NWSComps_IEPaintEngine_utils,
  NWSComps_IEPaintEngine_color
  {$IFDEF USE_JANTAB}
   ,JH_WinTab, JH_WinTab_Const
  {$ENDIF}
  ,graphics;

 type

 tpemode = (pemColor, pemRetouch, pemHistory, pemClone,
            pemTexture, pemDeformations, pemEraseLayer, pemRestoreLayer,
            pemObjectStamp);

 tpeNotifyEvent = procedure(sender: Tobject; var x, y: integer) of object;

 tpeNewSessionRequest = (ns_Needed, ns_NotNeeded, ns_AskUser);
 tPeParamsChangedEvent = procedure (Sender: TObject; bNewSession: tpeNewSessionRequest) of object;

 tPeCustomParams = class(TPersistent)
    Public

      OnChanged: tPeParamsChangedEvent;

      procedure SaveToDataParser(dp: TNWSComps_DataParser); virtual;
      procedure LoadFromDataParser(dp: TNWSComps_DataParser); virtual;
  end;

  tPeSessionMode = (sm_IgnoreSessionMemory, sm_KeepSessionMemory_UntilNext,
                    sm_KeepSessionMemory_UntilManualReset);
{
sm_IgnoreSessionMemory: in this mode the engine always build up strokes
sm_KeepSessionMemory_UntilNext: in this mode during the current painting session strokes are not build up, but in the next painting session, strokes will be build up on top of the previous painting
sm_KeepSessionMemory_UntilManualReset: in this mode strokes are not build up until you reset the session manually using the Session_Reset method
}

 TPESession = class;
 tPeParamsSessionEvent = procedure(ChangedParams: tPeCustomParams; Session: TPeSession) of object;
 tPeGetRadiusEvent = procedure(var radius:cardinal) of object;
 TPESession = class(TPersistent)
   private
     fNew: boolean;
     fFlags: TStringList;
     fLastFlag: string;

     procedure SetNew(thevalue:boolean);
   public

     property New: boolean read fNew write SetNew;
     property LastFlag: string read fLastFlag write fLastFlag;
     property Flags: TStringList read fFlags write fFlags;

     constructor Create; reintroduce;
     destructor Destroy; override;

     procedure Assign(Source: TObject); reintroduce;
   published

 end;


 TPETabletPressureDynamic = (pdBrushOpacity, pdBrushRadius);
 TPETabletPressureDynamics = set of TPETabletPressureDynamic;

 TPETabletPressureMode = (pmLinear, pmUnlinear);
 {$IFDEF USE_JANTAB}
 tPeTabletParams = class(tPeCustomParams)

   private


    fTablet: TJanHWinTab;
    fTablet_PressureVar: integer;
    fTablet_PressureSensitive: boolean;
    fTablet_PressureMode: TPETabletPressureMode;
    fTablet_PressureUnlinearStrength: cardinal;
    fPressureDynamics: TPETabletPressureDynamics;

    procedure SetTablet(theTablet: TJanHWinTab);
    procedure SetTabletPressureVariation(thevalue: integer);
    procedure SetTabletPressureUnlinearStrength(thevalue: cardinal);
    procedure SetTablet_PressureSensitive(thevalue: boolean);
    procedure SetTablet_PressureMode(thevalue: TPETabletPressureMode);
    procedure SetTablet_PressureDynamics(thevalue: TPETabletPressureDynamics);

    public

    published

    property Tablet: TJanHWinTab read fTablet write SetTablet;
    property PressureVar: integer read fTablet_PressureVar write SetTabletPressureVariation;
    property PressureUnlinearStrength: cardinal read fTablet_PressureUnlinearStrength write SetTabletPressureUnlinearStrength;
    property PressureSensitive: boolean read fTablet_PressureSensitive write SetTablet_PressureSensitive;
    property PressureMode: TPETabletPressureMode read fTablet_PressureMode write SetTablet_PressureMode;

    property PressureDynamics: TPETabletPressureDynamics read fPressureDynamics write SetTablet_PressureDynamics;

    constructor Create; reintroduce;
    procedure Assign(Source: TObject); reintroduce;

    procedure SaveToDataParser(dp: TNWSComps_DataParser); override;
    procedure LoadFromDataParser(dp: TNWSComps_DataParser); override;


 end;
 {$ENDIF}





 tPePaintParams = class(tPeCustomParams)
    private
      fMode: tpemode;
      fShowBrushShape: boolean;
      fPrecision: cardinal;
      fStep: cardinal;
      fEnableEditAlphaChannel: boolean;
      fTransp: byte;
      fRadius: cardinal;
      fFeather: cardinal;
      fDithering: cardinal;
      fBlendMode: tbeblendmode;
      fEnableAutoScroll: boolean;
      fLargeSteps: boolean;
      fSelective: boolean;
      fSelTolerance: integer;
      fRotateBrush: boolean;
      fContinuousPainting: boolean;
 
      fBrushBitmap: tIEbitmap;
      FSessionMode: tPeSessionMode;
      fGradation: cardinal;
      fShowBrushWhenNotRunning: boolean;
      fSprayEffect: cardinal;


      procedure SetMode(TheMode: TPEmode);
      procedure SetBlendmode(theblendmode: tbeblendmode);
      procedure SetRadius(theRadius: cardinal);
      procedure SetEnableEditAlphaChannel(thevalue:boolean);
//      procedure SetColor(theColor: Tcolor);
      procedure SetTransp(theTransp: byte);
      procedure SetFeather(Thefeather: cardinal);
      procedure SetDithering(Thedithering: cardinal);

      procedure SetPrecision(Thevalue: cardinal);

      procedure Setbrushbitmap(thebitmap: tIEbitmap);
      procedure SetSessionMode(const Value: tPeSessionMode);
      procedure SetGradation(const Value: cardinal);
      procedure SetSelTolerance(const Value: integer);
      procedure SetStep(const Value: cardinal);
      procedure SetSprayEffect(const Value: cardinal);

    Public

      property ShowBrushWhenNotRunning: boolean read fShowBrushWhenNotRunning write fShowBrushWhenNotRunning;

      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;


    published

      property Mode: TPemode read fMode write SetMode;

      property SessionMode: tPeSessionMode read FSessionMode write SetSessionMode;

      property ShowBrushShape: boolean read fShowBrushShape write fShowBrushShape;

      property Precision: cardinal read fPrecision write SetPrecision;

      property Step: cardinal read fStep write SetStep;
      property EnableEditAlphaChannel: boolean read fEnableEditAlphaChannel write SetEnableEditAlphaChannel;
      property Transparence: byte read fTransp write SetTransp;
      property Radius: cardinal read fRadius write SetRadius;
      property Feather: cardinal read fFeather write SetFeather;
      property Gradation: cardinal read fGradation write SetGradation;
      property Dithering: cardinal read fDithering write SetDithering;
      property SprayEffect: cardinal read fSprayEffect write SetSprayEffect;
      property BlendMode: tbeblendmode read fBlendMode write SetBlendmode;
      property EnableAutoScroll: boolean read fEnableAutoScroll write fEnableAutoScroll;
      property LargeSteps: boolean read fLargeSteps write fLargeSteps;
      property Selective: boolean read fSelective write fSelective;
      property SelTolerance: integer read fSelTolerance write SetSelTolerance;
      property RotateBrush: boolean read fRotateBrush write fRotateBrush;
      property ContinuousPainting: boolean read fContinuousPainting write fContinuousPainting;
      //property PaintOnlyOnce: boolean read fPaintOnlyOnce write Setpaintonlyonce;

      property BrushBitmap: tIEbitmap read fBrushBitmap write Setbrushbitmap;

 end;


  tPeColorParams = class(tPeCustomParams)
    private
   //   fBlendMode: tbeblendmode;
      fColor: tcolor;

      procedure SetColor(theColor: Tcolor);
    Public


      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;

    published
      property Color: tcolor read fColor write SetColor;

 end;

 tPeTextureParams = class(tPeCustomParams)
    private

       fTextureBitmap: TIEbitmap;

       procedure SetTexturebitmap(thebitmap: tIEbitmap);

    Public



      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;

    published
      property TextureBitmap: TIEbitmap read fTextureBitmap write SetTexturebitmap;

 end;


 tPeHistoryParams = class(tPeCustomParams)
    private
      fHistoryBitmap: tIEBitmap;

      procedure SetHistorybitmap(thebitmap: tIEbitmap);

    Public


      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;

    published
      property HistoryBitmap: tIEBitmap read fHistoryBitmap write SetHistorybitmap;

 end;


 tPeEditLayerAlphaParams = class(tPeCustomParams)
    private


    Public


      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;

    published

 end;



  tPeObjectStampParams = class(tPeCustomParams)
    private

      fObjectBitmap: TIEbitmap;

      procedure SetObjectbitmap(thebitmap: tIEbitmap);


    Public


      constructor Create; reintroduce;
      destructor Destroy; override;
      procedure Assign(Source: TObject);  reintroduce;

    published


      property ObjectBitmap: TIEbitmap read fObjectBitmap write SetObjectbitmap;

 end;



 tpeCloneSrcType = (cst_ImageEn, cst_IELayer, cst_IEBitmap);
 tPeCloningParams = class(tPeCustomParams)
    private

    fShowBrush: boolean;
    fSrcPoint, fTgtPoint: tpoint;
    fIsSrcPointAssigned, fIsTgtPointAssigned: boolean;
    fSrcImageEn: TImageenview;
    fSrcImageLayer: TIELayer;
    fSrcType: TpeCloneSrcType;
    fSrcIeBitmap: tIEbitmap;
    fSrcLayerPos_X: integer;
    fSrcLayerPos_Y: integer;
 //   fCloneImageEnview: TImageEnView;


    procedure SetSrcPoint(thepoint: Tpoint);
    procedure SetTgtPoint(thepoint: Tpoint);
    procedure SetSourcebitmap(theIeBitmap: TIebitmap);
    procedure SetSourceImageenView(theImageen: TImageenview);
  {  procedure SetSourceImageEnLayer(theImageEnLayer: tIELayer;
                                   theImageEnView: tImageEnView);
   }
    Public

     // OnChanged: tPeParamsChangedEvent;
      property IsSrcPointAssigned: boolean read fIsSrcPointAssigned;
      property IsTgtPointAssigned: boolean read fIsTgtPointAssigned;

      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure Assign(Source: TObject);  reintroduce;



    published

    property ShowBrush: boolean read fShowBrush write fShowBrush;
    property SrcPoint: tpoint read fSrcPoint write SetSrcPoint;
    property TgtPoint: tpoint read fTgtPoint write SetTgtPoint;


    property SrcType: TpeCloneSrcType read fSrcType;

    property SrcIeBitmap: tIEbitmap read fSrcIeBitmap write SetSourcebitmap;
    property SrcImageEn: TImageEnView read fSrcImageEn write SetSourceImageenView;
    property SrcImageLayer: TIELayer read fSrcImageLayer;

    property SrcLayerPos_X: integer read fSrcLayerPos_X;
    property SrcLayerPos_Y: integer read fSrcLayerPos_Y;
 end;

 TpeDeformationKind = (dk_WhirlCW, dk_WhirlACW, dk_Bulge, dk_Pinch);
 TPeDeformationParams = class(tPeCustomParams)
   private
    fKind: TpeDeformationKind;
    fStep: byte;
    fStepTime: cardinal;
    fCurrentStep: byte;
    fAmount: integer;

    public

  //  OnChanged: tPeParamsChangedEvent;

    procedure SetKind(theValue: TpeDeformationKind);
    procedure SetStep(theValue: byte);
    procedure SetStepTime(theValue: cardinal);
    procedure SetAmount(theValue: integer);

    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TObject); reintroduce;

    property CurrentStep: byte read fCurrentStep write fCurrentStep;

    published

    property Kind: TpeDeformationKind read fKind write SetKind;
    property Step: byte read fStep write SetStep;
    property StepTime: cardinal read fStepTime write SetStepTime;
    property Amount: integer read fAmount write SetAmount;
 end;


 TPERetouchCustomFunction = function(const inputBGRA: TbeBGRAbytearray): TbeBGRAbytearray of object;
 TpeRetouchKind = (rk_blur, rk_Sharpen, rk_dodge,
                  rk_burn, rk_Lighten, rk_Darken,
                  rk_Saturate, rk_Desaturate, rk_Custom);
 TPeRetouchParams = class(tPeCustomParams)
   private
    fKind: TpeRetouchKind;
    fAmount: integer;
    fRetouchCustom: TPERetouchCustomFunction;

    public

    procedure SetKind(theValue: TpeRetouchKind);
    procedure SetAmount(theValue: integer);
    procedure SetRetouchCustom(theValue: TPERetouchCustomFunction);


    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Assign(Source: TObject); reintroduce;



    published

    property Kind: TpeRetouchKind read fKind write SetKind;
    property Amount: integer read fAmount write SetAmount;
    property RetouchCustom: TPERetouchCustomFunction read fRetouchCustom write SetRetouchCustom;

 end;



implementation


constructor TPeSession.Create;
begin
  inherited create;

  fNew := True;
  fFlags := TStringList.Create;
  fLastFlag := G_CONST_PE_FLAG_NONE;
end;

destructor TPeSession.Destroy;
begin
  fFlags.Free;
end;

procedure TPeSession.Assign(Source: TObject);
var
  aSession: TPesession;
begin
  if not (source is TPeSession) then Exit;

  aSession := TPeSession(source);

  fNew := aSession.New;
  fFlags.Assign(aSession.flags);
  fLastFlag := aSession.LastFlag;
end;

procedure TPeSession.SetNew(thevalue:boolean);
begin
  fNew := thevalue;
end;

procedure tPeCustomParams.SaveToDataPArser(dp: TNWSComps_DataParser);
begin
end;

procedure tPeCustomParams.LoadFromDataPArser(dp: TNWSComps_DataParser);
begin

end;

{$IFDEF USE_JANTAB}
constructor tPeTabletParams.Create;
begin
  inherited create;

  fTablet := nil;
  fTablet_PressureVar := 800;
  fTablet_PressureSensitive := true;
  fTablet_PressureMode := pmLinear;
  fTablet_PressureUnlinearStrength := 20;
  fPressureDynamics := [pdBrushOpacity, pdBrushRadius];
end;
{$ENDIF}

{$IFDEF USE_JANTAB}
procedure tPeTabletParams.Assign(Source: TObject);
var
  aTabletInfo: tPeTabletParams;
begin
  if not (source is tPeTabletParams) then EXIT;

  aTabletInfo := tPeTabletParams(source);

  fTablet := aTabletInfo.tablet;
  fTablet_PressureVar := aTabletInfo.PressureVar;
  fTablet_PressureSensitive := aTabletInfo.PressureSensitive;
  fTablet_PressureMode := aTabletInfo.PressureMode;
  fTablet_PressureUnlinearStrength := aTabletInfo.PressureUnlinearStrength;
  fPressureDynamics := aTabletInfo.PressureDynamics;
end;
{$ENDIF}
//procedure Assign(Source: TObject);


{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTablet(theTablet: TJanHWinTab);
begin
  fTablet := theTablet;
  if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);

end;
{$ENDIF}

{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTabletPressureVariation(thevalue: integer);
begin
  fTablet_PressureVar := max(100, min(1000, thevalue));
  if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);
end;
{$ENDIF}


{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTabletPressureUnlinearStrength(thevalue: cardinal);
begin
  fTablet_PressureUnlinearStrength := max(0, min(100, thevalue));
    if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);
end;
{$ENDIF}

{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTablet_PressureSensitive(thevalue: boolean);
begin
  fTablet_PressureSensitive := thevalue;
    if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);
end;
{$ENDIF}

{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTablet_PressureMode(thevalue: TPETabletPressureMode);
begin
  fTablet_PressureMode := theValue;
    if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);
end;
{$ENDIF}

{$IFDEF USE_JANTAB}
procedure tPeTabletParams.SetTablet_PressureDynamics(thevalue: TPETabletPressureDynamics);
begin
  fPressureDynamics := theValue;
    if assigned(OnChanged) then
    OnChanged(self, ns_NotNeeded);
end;
{$ENDIF}


{$IFDEF USE_JANTAB}
    procedure tPeTabletParams.SaveToDataParser(dp: TNWSComps_DataParser);
    begin
      inherited;
      dp.AddOpenTag(G_CONST_PE_FILE_TAG_PARAMS_TABLET);
      try
        //dp.AddValue(floattostr(fPoints_RGB.data[i].x) + G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE + floattostr(fPoints_RGB.data[i].Y));
      finally
        dp.AddCloseTag(G_CONST_PE_FILE_TAG_PARAMS_TABLET);
      end;

    end;
{$ENDIF}

{$IFDEF USE_JANTAB}
    procedure tPeTabletParams.LoadFromDataParser(dp: TNWSComps_DataParser);
    begin
      inherited;
    end;
{$ENDIF}






{
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
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_DECSEP, sysutils.DecimalSeparator);
  //Separator for X and Y Coordinates of Point in the Point String Value
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_POINTCOORDSSEP, G_CONST_RGBCURVES_FILE_POINTCOORDSSEP_VALUE);
  // Separator between name of property and its value
  dp.AddTag(G_CONST_RGBCURVES_FILE_TAG_PROPERTYSEP, G_CONST_RGBCURVES_FILE_PROPERTYSEP_VALUE);




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
end;

procedure TRGBCurves.ReadImport(dp: TNWSComps_DataParser);

var
  sparsedStr: string;
  bOk: boolean;

  sReadGuid: string;
  sReadTitle: string;
  sReadVersion: string;
  sReadDecSep: string;
  sReadPointCoordsSep: string;
  sReadPropSep: string;
  sReadAlgorithm: string;
  sReadInterpMin: string;
  sReadInterpMax: string;

  sPArsedStr_PropId, sPArsedStr_PropValue: string;

  NRGB, NRed, NGreen, NBlue: integer;
  i, k: integer;

  aPoint: TRGBCurves_doublePoint;
  aTag: string;

  procedure DataStrToPoint(const dataStr: string; var thePoint: TRGBCurves_doublePoint);
  var
    apos: integer;
    sX, sY: string;
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
    sX, sY: string;
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
    DecimalSeparator := sReadDecSep[1];
    fInterpLinear_Min := strtoint(sReadInterpMin);
    fInterpLinear_Max := strtoint(sReadInterpMax);
    RGBCurves_InterpAlgorithm := sReadAlgorithm;
    // -----------------------------------

    bOk := dp.ParseTag(G_CONST_RGBCURVES_FILE_TAG_RGBPOINTS_COUNT, sParsedStr);
    if bOk then
    begin
      NRGB := strtoint(sParsedStr);
    end
    else
      NRGB := 0;


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



  finally
    fReadingFromFile := False;
  end;
end;

}

















//-------------------------------------------------

constructor tPePaintParams.Create;
begin
  inherited create;


   // fHistoryBitmap := nil;
    fBrushBitmap := nil;

    fMode := pemColor;
    fShowBrushShape := true;
    fShowBrushWhenNotRunning := false;
    fPrecision := 50;

    fStep := 10;
    fContinuousPainting := false;

    //fPaintOnlyOnce := true;
    FSessionMode := sm_KeepSessionMemory_UntilNext;

    fEnableEditAlphaChannel := true;
    fTransp := 0;
    fRadius := 10;
    fFeather := 20;
    fGradation := 50;
    fDithering := 100;
    fEnableAutoScroll := false;
    fLargeSteps := false;
    fSelective := false;
    fSelTolerance := 20;
    fRotateBrush := false;
    fSprayEffect := 0;
 //   fColor := rgb(0, 0, 0);
 //   fEffectAmount := 127;
    fBlendMode := blmnormal;



end;

destructor tPePaintParams.Destroy;
begin


  inherited;
end;

procedure tPePaintParams.Assign(Source: TObject);
var
  thepaintInfo: tPePaintParams;
begin
  if Source is tPePaintParams then
  begin
    thepaintInfo := tPePaintParams(Source);

    fMode := thepaintInfo.Mode;
    fShowBrushShape := thepaintInfo.showbrushshape;
    fShowBrushWhenNotRunning := thepaintInfo.ShowBrushWhenNotRunning;
    fStep := thepaintInfo.step;
    fEnableEditAlphaChannel := thepaintInfo.EnableEditAlphaChannel;
    fTransp := thepaintInfo.Transparence;
    fPrecision := thepaintInfo.Precision;
    fRadius := thepaintInfo.Radius;
    fFeather :=  thepaintInfo.Feather;
    fGradation :=  thepaintInfo.Gradation;
    fDithering := thepaintInfo.Dithering;
//    fEffectAmount := thepaintInfo.EffectAmount;
    fBlendMode := thepaintInfo.blendmode;
    fEnableAutoScroll := thepaintInfo.EnableAutoScroll;
    fLargeSteps := thepaintInfo.largesteps;
    fSelective := thepaintInfo.Selective;
    fSelTolerance := thepaintInfo.SelTolerance;
    fRotateBrush := thepaintInfo.RotateBrush;
    fContinuousPainting := thepaintInfo.ContinuousPainting;
    fSprayEffect := thepaintInfo.SprayEffect;
    //fPaintOnlyOnce := thepaintInfo.paintonlyonce;
    FSessionMode := thepaintInfo.SessionMode;

 //   fColor := thepaintInfo.Color;
    {
    fHistoryBitmap := thepaintInfo.HistoryBitmap;
    fTextureBitmap := thepaintInfo.TextureBitmap;
    fObjectbitmap := thepaintInfo.ObjectBitmap;
    }
    fBrushBitmap := thepaintInfo.BrushBitmap;

  end;
end;



procedure tPePaintParams.SetMode(TheMode: TPEmode);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fMode <> TheMode);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;


  fMode := themode;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;

procedure tPePaintParams.SetBlendmode(theblendmode: tbeblendmode);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fBlendMode <> theblendmode);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fBlendMode := theblendmode;

  if assigned(OnChanged) then
     OnChanged(self, nsRequest);

end;

procedure tPePaintParams.SetRadius(theRadius: cardinal);
begin
  fRadius := min(G_CONST_PE_MAXRADIUS, theRadius);

  if assigned(OnChanged) then OnChanged(self, ns_NotNeeded);
end;

procedure tPePaintParams.SetSelTolerance(const Value: integer);
begin
  fSelTolerance := Max(0, min(255, Value));
end;

procedure tPePaintParams.SetSessionMode(const Value: tPeSessionMode);
begin
  if fSessionMode = Value then EXIT;

  FSessionMode := Value;

  if assigned(OnChanged) then
   OnChanged(self, ns_Needed);
end;

procedure tPePaintParams.SetSprayEffect(const Value: cardinal);
begin
  fSprayEffect := Min(100, Value);
end;

procedure tPePaintParams.SetStep(const Value: cardinal);
begin
  fStep := Max(1, Value);
end;

procedure tPePaintParams.SetEnableEditAlphaChannel(thevalue:boolean);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fEnableEditAlphaChannel <> thevalue);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fEnableEditAlphaChannel := thevalue;

  if assigned(OnChanged) then
     OnChanged(self, nsRequest);
end;



procedure tPePaintParams.SetTransp(theTransp: byte);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fTransp <> Thetransp);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fTransp := Thetransp;

  if assigned(OnChanged) then
     OnChanged(self, nsRequest);
end;

procedure tPePaintParams.SetFeather(Thefeather: cardinal);
begin
  Thefeather := max(0, min(100, Thefeather));

  fFeather := theFeather;

  if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);
end;

procedure tPePaintParams.SetGradation(const Value: cardinal);
begin
  fGradation := max(0, min(100, Value));
  if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);
end;

procedure tPePaintParams.SetDithering(Thedithering: cardinal);
begin
  TheDithering := max(0, min(100, TheDithering));

  fDithering := TheDithering;

  if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);

end;





procedure tPePaintParams.SetPrecision(Thevalue: cardinal);
begin
  fPrecision := max(0, min(100, Thevalue));

 if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);
end;

procedure tPePaintParams.Setbrushbitmap(thebitmap: tIEbitmap);
begin
  fBrushBitmap := thebitmap;

 if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);
end;

//---------------------------------------------------


constructor tPeColorParams.Create;
begin
  inherited create;

  fColor := rgb(0, 0, 0);
end;

destructor tPeColorParams.Destroy;
begin


  inherited;
end;

procedure tPeColorParams.Assign(Source: TObject);
var
  theInfo: tPeColorParams;
begin
  if Source is tPeColorParams then
  begin
    theInfo := tPeColorParams(Source);
    fColor := theInfo.Color;
  end;
end;


procedure tPeColorParams.SetColor(theColor: Tcolor);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fColor <> theColor);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fColor := theColor;

  if assigned(OnChanged) then
     OnChanged(self, nsRequest);

end;

//---------------------------------------------------


constructor tPeTextureParams.Create;
begin
  inherited create;
  fTextureBitmap := nil;
end;

destructor tPeTextureParams.Destroy;
begin


  inherited;
end;

procedure tPeTextureParams.Assign(Source: TObject);
var
  theInfo: tPeTextureParams;
begin
  if Source is tPeTextureParams then
  begin
    theInfo := tPeTextureParams(Source);
    fTextureBitmap := theInfo.TextureBitmap;
  end;
end;


procedure tPeTextureParams.SetTexturebitmap(thebitmap: tIEbitmap);
begin
  fTextureBitmap := thebitmap;

 if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);

end;


//---------------------------------------------------


constructor tPeHistoryParams.Create;
begin
  inherited create;
  fHistoryBitmap := nil;

end;

destructor tPeHistoryParams.Destroy;
begin


  inherited;
end;

procedure tPeHistoryParams.Assign(Source: TObject);
var
  theInfo: tPeHistoryParams;
begin
  if Source is tPeHistoryParams then
  begin
    theInfo := tPeHistoryParams(Source);
    fHistoryBitmap := theInfo.HistoryBitmap;
  end;
end;

procedure tPeHistoryParams.SetHistorybitmap(thebitmap: tIEbitmap);
begin
  fHistoryBitmap := thebitmap;

 if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);

end;

//---------------------------------------------------


constructor tPeEditLayerAlphaParams.Create;
begin
  inherited create;

end;

destructor tPeEditLayerAlphaParams.Destroy;
begin


  inherited;
end;

procedure tPeEditLayerAlphaParams.Assign(Source: TObject);
begin
  if Source is tPeEditLayerAlphaParams then
  begin


  end;
end;


//---------------------------------------------------




constructor tPeObjectStampParams.Create;
begin
  inherited create;


    fObjectBitmap := nil;

end;

destructor tPeObjectStampParams.Destroy;
begin


  inherited;
end;

procedure tPeObjectStampParams.Assign(Source: TObject);
var
  theInfo: tPeObjectStampParams;
begin
  if Source is tPeObjectStampParams then
  begin
    theInfo := tPeObjectStampParams(Source);

    fObjectbitmap := theInfo.ObjectBitmap;

  end;
end;




procedure tPeObjectStampParams.SetObjectbitmap(thebitmap: tIEbitmap);
begin
  fObjectBitmap := thebitmap;

 if assigned(OnChanged) then
     OnChanged(self, ns_NotNeeded);

end;















//------------------------------------------------

constructor tPeCloningParams.Create;
begin
  inherited create;

  fShowBrush := False;
  fIsSrcPointAssigned := false;
  fIsTgtPointAssigned := false;
  fSrcPoint := point(0, 0);
  fTgtPoint := point(0, 0);
  fSrcImageEn := nil;
  fSrcImageLayer := nil;
  fSrcType := cst_IEBitmap;
  fSrcIeBitmap := nil;
  fSrcLayerPos_X := 0;
  fSrcLayerPos_Y := 0;
end;

destructor tPeCloningParams.Destroy;
begin


  inherited;
end;

procedure tPeCloningParams.Assign(Source: TObject);
var
  thecloneInfo: tPeCloningParams;
begin
  if Source is tPeCloningParams then
  begin
    theCloneInfo := tPeCloningParams(Source);
    fIsSrcPointAssigned := theCloneInfo.IsSrcPointAssigned;
    fIsTgtPointAssigned := theCloneInfo.IsTgtPointAssigned;
    fSrcPoint := theCloneInfo.SrcPoint;
    fTgtPoint := theCloneInfo.TgtPoint;
    fSrcType := theCloneInfo.SrcType;
    fSrcImageEn := theCloneInfo.SrcImageEn;
    fSrcImageLayer := theCloneInfo.SrcImageLayer;
    fSrcIeBitmap := theCloneInfo.SrcIeBitmap;
    fSrcLayerPos_X := theCloneInfo.SrcLayerPos_X;
    fSrcLayerPos_Y := theCloneInfo.SrcLayerPos_Y;
  end;
end;


procedure tPeCloningParams.SetSrcPoint(thepoint: Tpoint);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fSrcPoint.x <> thepoint.x) or
              (fSrcPoint.y <> thepoint.y) or
              (not IsSrcPointAssigned);

  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;


  fSrcPoint := thepoint;
  fIsSrcPointAssigned := true;

  if assigned(OnChanged) then
    OnChanged(self, nsRequest);

end;

procedure tPeCloningParams.SetTgtPoint(thepoint: Tpoint);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (fTgtPoint.x <> thepoint.x) or
              (fTgtPoint.y <> thepoint.y) or
              (not fIsTgtPointAssigned);

  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fTgtPoint := thepoint;
  fIsTgtPointAssigned := true;

  if assigned(OnChanged) then
    OnChanged(self, nsRequest);

end;


procedure tPeCloningParams.SetSourcebitmap(theIeBitmap: TIebitmap);
begin

  fSrcIeBitmap := theIEbitmap;
  fSrcImageEn := nil;
  fSrcImageLayer := nil;
  fSrcType := cst_IEBitmap;
  fSrcLayerPos_X := 0;
  fSrcLayerPos_Y := 0;

  if assigned(OnChanged) then
    OnChanged(self, ns_AskUser);
end;

procedure tPeCloningParams.SetSourceImageenView(theImageen: TImageenview);
var
  bNewSession: boolean;
begin
  if not assigned(theImageen) then EXIT;

  bNewSession := (fSrcImageEn <> theImageEn)or(fSrcIeBitmap <> theImageen.CurrentLayer.Bitmap);

  fSrcImageEn := theImageEn;
  fSrcIeBitmap := nil;
  fSrcImageLayer := nil;
  fSrcType := cst_ImageEn;

  fSrcIeBitmap := SrcImageEn.IEBitmap;
  fSrcLayerPos_X := SrcImageEn.CurrentLayer.PosX;
  fSrcLayerPos_Y := SrcImageEn.CurrentLayer.PosY;

  if assigned(OnChanged) then
  begin
    if bNewSession then
      OnChanged(self, ns_Needed)
      else
      OnChanged(self, ns_AskUser);
  end;

end;

(*
procedure tPeCloningParams.SetSourceImageEnLayer(theImageEnLayer: tIELayer;
                                   theImageEnView: tImageEnView);
begin

  fSrcImageLayer := theImageEnLayer;
  fSrcImageEn := theImageEnView;
  fSrcIeBitmap := theImageEnLayer.Bitmap;

  fSrcType := cst_IELayer;
  fSrcIeBitmap := fSrcImageEn.IEBitmap;

  if assigned(OnChanged) then
     OnChanged(self, ns_AskUser);
end;
  *)

//-------------------------------------------------------------------------
procedure TPeDeformationParams.SetKind(theValue: TpeDeformationKind);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := fKind <> theValue;
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fKind := theValue;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;

procedure TPeDeformationParams.SetStep(theValue: byte);
begin
  fStep := theValue;
  if assigned(OnChanged) then OnChanged(self, ns_NotNeeded);
end;

procedure TPeDeformationParams.SetStepTime(theValue: cardinal);
begin
  fStepTime := theValue;
  if assigned(OnChanged) then OnChanged(self, ns_NotNeeded);
end;

constructor TPeDeformationParams.Create;
begin
  inherited create;

  fKind := dk_WhirlCW;
  fStep := 10;
  fStepTime := 100;
  fCurrentStep := 0;
  fAmount := 0;

end;

destructor TPeDeformationParams.Destroy;
begin


  inherited;
end;

procedure TPeDeformationParams.Assign(Source: TObject);
var
  aDefInfo: TPeDeformationParams;
begin
  if not (source is TPeDeformationParams) then EXIT;

  aDefInfo := TPeDeformationParams(source);
  fKind := aDefInfo.Kind;
  fStep := aDefInfo.Step;
  fStepTime := aDefInfo.StepTime;
  fAmount := aDefInfo.Amount;
end;


procedure TPeDeformationParams.SetAmount(theValue: integer);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := fAmount <> theValue;
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fAmount := theValue;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;



//-------------------------------------------------------------

procedure TPeRetouchParams.SetKind(theValue: TpeRetouchKind);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := fKind <> theValue;
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fKind := theValue;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;


procedure TPeRetouchParams.SetAmount(theValue: integer);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := fAmount <> theValue;
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fAmount := theValue;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;


procedure TPeRetouchParams.SetRetouchCustom(theValue: TPERetouchCustomFunction);
var
  bChanged: boolean;
  nsRequest: tpeNewSessionRequest;
begin
  bChanged := (@fRetouchCustom <> @theValue);
  if bChanged then
    nsRequest := ns_Needed
  else
    nsRequest := ns_NotNeeded;

  fRetouchCustom := theValue;
  if assigned(OnChanged) then OnChanged(self, nsRequest);
end;

constructor TPeRetouchParams.Create;
begin
  inherited create;
  fRetouchCustom := nil;
  fAmount := 0;
  fKind := rk_Custom;
end;

destructor TPeRetouchParams.Destroy;
begin


  inherited;
end;

procedure TPeRetouchParams.Assign(Source: TObject);
var
  aRetInfo: TPeRetouchParams;
begin
  if not (source is TPeRetouchParams) then EXIT;

  aRetInfo := TPeRetouchParams(source);

  fRetouchCustom := aRetInfo.RetouchCustom;
  fKind := aRetInfo.Kind;
  fAmount := aRetInfo.Amount;

end;






end.
