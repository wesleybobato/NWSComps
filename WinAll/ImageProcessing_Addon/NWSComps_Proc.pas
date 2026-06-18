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
unit NWSComps_Proc;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}

uses
  Windows, SysUtils, Classes, forms, Graphics, math, messages, dialogs, syncobjs,
  hyiedefs, hyieutils,{$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps ,{$ENDIF} imageenproc, imageenview,
  NWSComps_RGBCurves_Math, NWSComps_RGBCurves_Types, NWSComps_IEUtils_Previews,
  NWSComps_Proc_Filter_Types,  NWSComps_Proc_Filter_Lib_Const,
  NWSComps_Proc_Engine, NWSComps_MultiThreadProc;

 type
 






   TIEProc_EX_ProgressRcd = Record
      Progress: integer;
      FilterIdx: integer;
      FilterTot: integer;
      Enabled: boolean;
   end;

   TIEProc_EX = class(TImageenproc)
     private

       fMTCS: TCriticalSection;
       fProgressRcd: TIEProc_EX_ProgressRcd;

       fBE: TBE;
       fPreviewApplyCtr: integer;

       fPreviewHandler: TIEUtils_IEPreviewEventsHandler;
       fIEViewDisplay: TImageenview;

       fPreviewFilter: TIEProc_EX_Filter;
       fPreviewFilterList: TIEProc_EX_Filter_Collection;

       fOnFilter_Progress: TIEProgressEvent;
       fOnFilter_FinishWork: TNotifyEvent;


       procedure HandleInternalProgress(Sender: TObject; per: integer);
       procedure HandleInternalFinishWork(Sender: TObject);

       procedure EnableOnProgress;
       procedure DisableOnProgress;

       procedure SetAttached_Custom(attObject: TObject);

       procedure Handle_FilterUpdate(sender:TObject);

       function GetUseFastPreview: boolean;
       procedure SetUseFastPreview(bValue: boolean);



      procedure Process_DoApply(const bApplyForPreview: boolean; theFilter: TIEProc_EX_Filter; const iFilter, iTot: integer);

      procedure Process_Apply(const bApplyForPreview: boolean; theFilter: TIEProc_EX_Filter);  overload;
      procedure Process_Apply(const bApplyForPreview: boolean; theFilterList: TIEProc_EX_Filter_Collection); overload;
      procedure Process_ApplyCurrent(const bApplyForPreview: boolean); overload;

      function GetPreviewMode: TIEUtils_IEPreview_Mode;
      procedure SetPreviewMode(const Value: TIEUtils_IEPreview_Mode);
      function GetMultiThreadEnabled: boolean;
      procedure SetMultiThreadEnabled(const Value: boolean);

      procedure SetOnFilter_Progress(const Value: TIEProgressEvent);
      function GetOnProgress: TIEProgressEvent;
      procedure SetOnFilter_FinishWork(const Value: TNotifyEvent);
      function GetOnFinishWork: TNotifyEvent;
    function GetMultiThreadNrThreads: cardinal;
    procedure SetMultiThreadNrThreads(const Value: cardinal);
    function GetOnFilter_CustomMultiThreadInfo: TIEProc_Ex_CustomMultiThreadInfoEvent;
    procedure SetOnFilter_CustomMultiThreadInfo(
      const Value: TIEProc_Ex_CustomMultiThreadInfoEvent);
    function GetMultiThreadDefOverlapMethod: TIEMultiProc_EX_OverlapMethod;
    procedure SetMultiThreadDefOverlapMethod(
      const Value: TIEMultiProc_EX_OverlapMethod);
    function GetPreviewLockCount: integer;
    function GetPreviewRegistered: boolean;


     protected

       procedure ApplyChanges_byFilter(previewID: TGUID;  theFilter: TIEProc_EX_Filter;
                                        theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean;
                                       const bLinkToFullSize: boolean;
                                       const bFinal: boolean);
       procedure ApplyChanges(previewID: TGUID;  theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean;
                                       const bLinkToFullSize: boolean;
                                       const bFinal: boolean);
       procedure Handle_ApplyChanges_Display(previewID: TGUID; linkToFullBmp:boolean;
                                        theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean);


     public
       OnDebug: TNotifyEvent;


       constructor Create(Owner: TComponent); override;
       Destructor Destroy; override;

       //These methods register a TImageEnview or any descendant (TimageEnVect) in order to display the changes
       //for the filter or the filter collection passed as parameter
       //Whenever the TImageEnview changes the display the filter or the list of filter is previewed
       //also when the Filter or the list of filter is updated (using the update method,
       //for example after changing the parameters by a slider) the preview is also refreshed automatically
       //therefore the TIEProc_EX, the TImageEnView and the TIEPROC_EX_Filter (or TIEProc_EX_Filter_Collection)
       //are all linked and working as one body
       procedure Preview_Register(theIEView: Timageenview; theFilter: TIEProc_EX_Filter);overload;
       procedure Preview_Register(theIEView: Timageenview; theFilterList: TIEProc_EX_Filter_Collection);overload;


       //Call this method once you are done with the preview and you have applied or canceled the filter
       procedure Preview_Unregister;

       //This applies the filter to the TImageEnview while in preview mode
       //it has the same effect as Process_Apply, but it works while we are still in preview mode
       procedure Preview_Apply;

       //These two methods lock and unlock the preview (while in preview mode)
       //in order to change the content of the TImageenview, for example loading a new picture or layer)
       procedure Preview_Lock;
       procedure Preview_Unlock;

       //this method allows to switch on/off the preview while in preview mode
       //in order to see the picture as it was in original and as it is with the filter applied
       procedure Preview_Toggle(const bPreviewIsOn: boolean);

       //Call these methods to apply any Filter or filter collection
       //to the attached TIEBitmap / TBitmap / TImageEnview but without any preview
       procedure Process_Apply(theFilter: TIEProc_EX_Filter);  overload;
       procedure Process_Apply(theFilterList: TIEProc_EX_Filter_Collection); overload;
       procedure Process_ApplyCurrent; overload;


        //list of methods that replace TImageEnProc native ones in order to support multithreading

        procedure AutoSharp(Intensity: Integer=68; rate: Double = 0.035); reintroduce;
        procedure WhiteBalance_AutoWhite; reintroduce;
        procedure WhiteBalance_GrayWorld; reintroduce;
        procedure AdjustBrightnessContrastSaturation(Brightness, Contrast, Saturation: Integer); reintroduce;
        procedure AdjustLumSatHistogram(Saturation, Luminance: Double); reintroduce;
        procedure AdjustSaturation(Amount: Integer); reintroduce;
        procedure AdjustTemperature(temperature: Integer); reintroduce;
        procedure AdjustTint(Amount: Integer); reintroduce;
        procedure Contrast(vv: extended); reintroduce;
        procedure Contrast2(Amount: double); reintroduce;
        procedure Contrast3(Change, Midpoint: Integer; DoRed, DoGreen, DoBlue: Boolean); reintroduce;
        procedure GammaCorrect(Gamma: Double; Channel: TIEChannels = [iecRed, iecGreen, iecBlue]); reintroduce;
        procedure HSLvar(oHue, oSat, oLum: Integer); reintroduce;
        procedure HSVvar(oHue, oSat, oVal: Integer); reintroduce;
        procedure IntensityRGBAll(r, g, b: Integer); reintroduce;
        procedure Intensity(LoLimit, HiLimit, Change: Integer; UseAverageRGB: Boolean; DoRed, DoGreen, DoBlue: Boolean); reintroduce;
        procedure Negative; reintroduce;
        procedure WhiteBalance_coef(Red, Green, Blue: Double); reintroduce;
        procedure WhiteBalance_WhiteAt(WhiteX, WhiteY: Integer); reintroduce;
        procedure Blur(radius: Double); reintroduce;
        procedure UnsharpMask(Radius: Double = 4.0; Amount: Double = 1.0; Threshold: Double = 0.05); reintroduce;
        procedure AutoImageEnhance1(SubsampledSize: Integer = 60; Slope: Integer = 20; Cut: Integer = 25; Neighbour: Integer = 2); reintroduce;
        procedure AutoImageEnhance2(ScaleCount: Integer = 3; ScaleCurve: Integer = 2; Variance: Double = 1.8; ScaleHigh: Integer = 200; Luminance: Boolean = True); reintroduce;
        procedure AutoImageEnhance3(Gamma: Double = 0.35; Saturation: Integer=80); reintroduce;
        procedure MedianSharpen(Window: integer = 4; Multiplier: integer = 1); reintroduce;
        procedure Median(Window: integer = 4; Threshold: integer = 50); reintroduce;
        procedure Sharpen(Intensity: Integer = 10; Neighbourhood: Integer = 4); reintroduce;
        procedure FindEdges(KernelSize:TIEProc_EX_Filter_Kernelsize);
        procedure Smooth(Amount:integer);
        procedure SmartFlash(Amount: byte; Radius: integer); reintroduce;
        procedure ReduceHighlights(Amount: byte; Radius: integer); reintroduce;
        procedure FillBackLight(AmountFill, AmountBack: byte; Radius: integer); reintroduce;
        procedure SmartContrast(Amount: byte; Radius: integer); reintroduce;
        Procedure RGBBalance(Uniform:boolean; ShadowRed, ShadowGreen, ShadowBlue, MidRed,MidGreen,MidBlue, HiRed, HiGreen,HiBlue, AllRed, AllGreen, AllBlue:integer); reintroduce;
        Procedure AutoColor(Strength:byte); reintroduce;
        procedure ColorFilter(Color:TColor; BlendMode: TIEProc_EX_Filter_Blendmode; Amount:byte); reintroduce;
        procedure Bilateral(Radius, SigmaI, SigmaD:Integer); reintroduce;

        property PreviewLockCount:integer read GetPreviewLockCount;
        property PreviewRegistered: boolean read GetPreviewRegistered;
        published

       property MultiThreadEnabled: boolean read GetMultiThreadEnabled write SetMultiThreadEnabled;
       property MultiThreadNrThreads: cardinal read  GetMultiThreadNrThreads write SetMultiThreadNrThreads;
       property MultiThreadDefOverlapMethod: TIEMultiProc_EX_OverlapMethod read GetMultiThreadDefOverlapMethod write SetMultiThreadDefOverlapMethod;

       property UseFastPreview: boolean read GetUseFastPreview write SetUseFastPreview;
       property PreviewMode: TIEUtils_IEPreview_Mode read GetPreviewMode write SetPreviewMode;

       property OnFinishWork: TNotifyEvent read GetOnFinishWork write SetOnFilter_FinishWork;
       property OnProgress: TIEProgressEvent read GetOnProgress write SetOnFilter_Progress;
       property OnFilter_Progress: TIEProgressEvent read fOnFilter_Progress write SetOnFilter_Progress;
       property OnFilter_FinishWork: TNotifyEvent read fOnFilter_FinishWork write SetOnFilter_FinishWork;
       property OnFilter_CustomMultiThreadInfo: TIEProc_Ex_CustomMultiThreadInfoEvent read GetOnFilter_CustomMultiThreadInfo write SetOnFilter_CustomMultiThreadInfo;
   end;



implementation
    uses ieview, NWSComps_Proc_Filter_Lib;





constructor TIEProc_EX.Create(Owner: TComponent);
begin
   inherited Create(Owner);
   fMTCS := TCriticalSection.create;

   fBE := TBE.create;
   fPreviewHandler := TIEUtils_IEPreviewEventsHandler.create(nil);

   DisableOnProgress;
   fPreviewApplyCtr := 0;

end;

Destructor TIEProc_EX.Destroy;
begin
  fMTCS.free;
  freeandnil(fBE);
  freeandnil(fPreviewHandler);
  inherited;
end;

procedure TIEProc_EX.ApplyChanges_byFilter(previewID: TGUID;  theFilter: TIEProc_EX_Filter;
                                       theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean;
                                       const bLinkToFullSize: boolean;
                                       const bFinal: boolean);
 //in case the preview is performed on a scaled down copy of the layer
  // we calculate the scale factor. This can be used to adjust those parameters
  //that depend on the size of the picture or other geometric factor, such as radius etc..

function GetPreviewScaleF: double;
begin
  if bFinal then
     result := 1
  else if bLinkToFullSize then// and assigned(fIEViewDisplay) and (fIEViewDisplay.CurrentLayer.Width>0) then
    result := theiebitmap.width / max(1, fIEViewDisplay.CurrentLayer.Width)
  else
    result :=  fIEViewDisplay.Zoom/100;
end;

function GetPreviewCoordX(x:integer):integer;
begin
  if bFinal then
    result := x
  else if bLinkToFullSize then
  begin
    result := round(x * GetPreviewScaleF);
  end
  else
  begin
    result := fIEViewDisplay.XBmp2Scr(x) - fIEViewDisplay.offsetx;
  end;
end;

function GetPreviewCoordY(y:integer):integer;
begin
  if bFinal then
    result := y
  else if bLinkToFullSize then
  begin
    result := round(y * GetPreviewScaleF);
  end
  else
  begin
    result := fIEViewDisplay.YBmp2Scr(y) - fIEViewDisplay.offsety;
  end;
end;



function GetScaledParam_Int(v:integer): integer;
begin
  result := round(v * GetPreviewScaleF);
end;

function GetScaledParam_float(v:double): double;
begin
  result := v * GetPreviewScaleF;
end;


var
 bemask: TBemask;
 origBmp: TIeBitmap;
 bFullApply: boolean;
 origParams: TIEProc_EX_Filter_Params;
 aPt:TPoint;
  I: Integer;
  iMin, iMax, iValue:integer;
  dMin,dMax, dValue: double;
begin
  if not assigned(theFilter) then EXIT;
  if not theFilter.Active then EXIT;


   if assigned(OnDebug) then OnDebug(theFilter);


  bFullApply := (bFinal or (fPreviewApplyCtr>0));

  bemask := nil;
  origBmp := nil;
  if bFullApply and bUseMAsk then
  begin
    bemask := TBemask.create;
    origBmp := TIEBitmap.create;

    bemask.DefineFromIeMask(Mask);

    origBMP.AssignImage(theiebitmap);

    EditedRect.left := max(EditedRect.left, mask.X1);
    EditedRect.Top := max(EditedRect.Top, mask.Y1);
    EditedRect.Right := min(EditedRect.Right, mask.X2);
    EditedRect.Bottom := min(EditedRect.Bottom, mask.Y2);
      //save original IeBitmap to memory
      //Convert IEMask to TBEMask
  end;

  origParams := TIEProc_EX_Filter_Params.create;
  origParams.Assign(theFilter.Params);
  theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_FULLAPPLY).SetValue(bFullApply, IEPROC_EX_FLAGS_FULLAPPLY_VTYPE);
  theFilter.Params.Param_Byname(IEPROC_EX_FLAGS_PREVIEWID).SetValue(GUIDToString(previewID), IEPROC_EX_FLAGS_PREVIEWID_VTYPE);
  try


      for I := 0 to theFilter.Params.Count-1 do
      begin
        with theFilter do
        begin
           if Params[i].IsFlag then continue;

           if Params[i].IsScalable then
           begin
              case Params[i].ValueType of
                pt_Int, pt_Cardinal:
                begin
                  iValue := Params[i].GetValue_int;
                  iValue := GetScaledParam_Int(iValue);
                  iValue := max(Params[i].GetValue_int(qt_Min), iValue);
                  iValue := min(Params[i].GetValue_int(qt_Max), iValue);
                  Params[i].SetValue(iValue);
                end;
                pt_single, pt_double:
                begin
                  dValue := Params[i].GetValue_double;
                  dValue := GetScaledParam_float(dValue);
                  dValue := max(Params[i].GetValue_double(qt_Min), dValue);
                  dValue := min(Params[i].GetValue_double(qt_Max), dValue);
                  Params[i].SetValue(dValue);
                end;
              end;

           end;

           if Params[i].IsCoordinateX then
           begin
               case Params[i].ValueType of
               pt_Int:
                  begin
                    iValue := Params[i].GetValue_int;
                    iValue := GetPreviewCoordX(iValue);
                    Params[i].SetValue(iValue);
                  end;
                end;
           end;
           if Params[i].IsCoordinateY then
           begin
               case Params[i].ValueType of
               pt_Int:
                  begin
                    iValue := Params[i].GetValue_int;
                    iValue := GetPreviewCoordY(iValue);
                    Params[i].SetValue(iValue);
                  end;
               end;
           end;


        end;
      end;



    //-------execute filter-----------------------------------------------
    fBe.ExecFilter(self, theFilter, theiebitmap, EditedRect);
    //------------------------------------------------------
  finally
    theFilter.Params.Assign(origParams);
    origParams.free;
  end;

  if bFullApply and bUseMAsk then
  begin

    bemask.CopyBitmap(theIEBitmap, origBmp, 255, false, true);
      //apply back original using inverted mask
    bemask.free;
    origbmp.free;
  end;

end;


procedure TIEProc_EX.ApplyChanges(previewID: TGUID;  theiebitmap: TIEbitmap;
                                       mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean;
                                       const bLinkToFullSize: boolean;
                                       const bFinal: boolean);
var
i: integer;
begin
  if fPreviewFilter<>nil then
  begin
     ApplyChanges_byFilter(previewID, fPreviewFilter, theiebitmap, mask, Editedrect, bUseMask, bLinkToFullSize, bFinal);
  end
  else if fPreviewFilterList<> nil then
  begin
    for i := 0 to  fPreviewFilterList.count-1 do
    begin
        ApplyChanges_byFilter(PreviewID, fPreviewFilterList.Filter[i], theiebitmap, mask, Editedrect, bUseMask, bLinkToFullSize, bFinal)
    end;
  end;
end;

procedure TIEProc_EX.Handle_ApplyChanges_Display(previewID: TGUID;  linkToFullBmp:boolean;
                                       theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean);
begin
  if fPreviewApplyCtr>0 then EXIT; //currently applying preview, cannot handle any other preview changes

  ApplyChanges(previewID, theiebitmap, mask, EditedRect, bUseMask, linkToFullBmp, False);

end;


procedure TIEProc_EX.Process_DoApply(const bApplyForPreview: boolean; theFilter: TIEProc_EX_Filter; const iFilter, iTot: integer);
procedure ApplyToTBitmap(theBitmap:TBitmap);
var
aIEBitmap:TIEBitmap;
begin
 aIEBitmap := TIEBitmap.create;
    try
      aIEBitmap.CopyFromTBitmap(theBitmap);
      ApplyChanges_byFilter(GUID_NULL, theFilter, AIEBitmap,nil, rect(0,0, AttachedIEBitmap.Width-1, AttachedIEBitmap.Height-1),false, False, True);
    finally
      aIEBitmap.CopyToTBitmap(theBitmap);
      aIEBitmap.free;
    end;
end;
procedure ApplyToImageEnView(theIEView: TImageEnView);
begin
   ApplyChanges_byFilter(GUID_NULL, theFilter, theIEView.IEBitmap , theIEView.SelectionMask,
                          rect(0,0, theIEView.IEBitmap.Width-1, theIEView.IEBitmap.Height-1),
                          (not theIEView.SelectionMask.IsEmpty), False, True);

end;
var
attIEView: TImageEnView;

begin

  try

    if bApplyForPreview then
    begin
       if (not assigned(fIEViewDisplay)) then
        EXIT;

      ApplyToImageEnView(fIEViewDisplay);
    end
    else
    if Assigned(AttachedImageEn) then
    begin
         if (not (attachedImageEn is TImageEnview)) then
        EXIT;
      attIEView := TImageEnview(AttachedImageEn);
      ApplyToImageEnView(attIEView);
    end
    else
    if Assigned(AttachedIEBitmap) then
    begin
      ApplyChanges_byFilter(GUID_NULL, theFilter, AttachedIEBitmap,
                            nil,  rect(0,0, AttachedIEBitmap.Width-1, AttachedIEBitmap.Height-1),false, False, True);
    end
    else if Assigned(AttachedBitmap) then
    begin
      ApplyToTBitmap(AttachedBitmap);
    end
    else
    if Assigned(AttachedTImage) then
    begin
      ApplyToTBitmap(AttachedTImage.Picture.Bitmap);
    end;
  finally

    if (iFilter=iTot) and (assigned(fOnFilter_FinishWork)) then
      OnFilter_FinishWork(self);
  end;

end;

procedure TIEProc_EX.Process_Apply(const bApplyForPreview: boolean; theFilter: TIEProc_EX_Filter);
begin
  if self.autoundo then
    self.SaveUndoCaptioned(theFilter.UserCaption);


  if thefilter.Active then
  begin
     fProgressRcd.FilterIdx := 1;
     fProgressRcd.FilterTot := 1;
     EnableOnProgress;
  end;
  try
    process_DoApply(bApplyForPreview, theFilter, 1,1);
  finally
    DisableOnProgress;
  end;
end;

procedure TIEProc_EX.Process_Apply(const bApplyForPreview: boolean; theFilterList: TIEProc_EX_Filter_Collection);
var
i:integer;
begin
 if self.autoundo then
 begin
    self.SaveUndoCaptioned(theFilterList.UserCaption);
 end;

 fProgressRcd.FilterTot := fPreviewFilterList.ActiveCount;
 fProgressRcd.FilterIdx := 0;
 try
    if fProgressRcd.FilterTot>0 then
      EnableOnProgress;
    for i := 0 to  fPreviewFilterList.count-1 do
    begin
      if fPreviewFilterList.Filter[i].Active then
        inc(fProgressRcd.FilterIdx);
      process_DoApply(bApplyForPreview, fPreviewFilterList.Filter[i], (i+1), fPreviewFilterList.count);
    end;
 finally
    DisableOnProgress;
 end;


end;


procedure TIEProc_EX.Process_Apply(theFilter: TIEProc_EX_Filter);
begin
  Process_Apply(false, theFilter);

end;

procedure TIEProc_EX.Process_Apply(theFilterList: TIEProc_EX_Filter_Collection);
begin
  Process_Apply(false, theFilterList);

end;


procedure TIEProc_EX.Process_ApplyCurrent(const bApplyForPreview: boolean);
begin
  if fPreviewFilter<>nil then
   Process_Apply(bApplyForPreview, fPreviewFilter)
  else if fPreviewFilterList<> nil then
    Process_Apply(bApplyForPreview, fPreviewFilterList);
end;

procedure TIEProc_EX.Process_ApplyCurrent;
begin
  Process_ApplyCurrent(false);
end;

procedure TIEProc_EX.Preview_Register(theIEView: Timageenview; theFilter: TIEProc_EX_Filter);
begin

  fPreviewFilterList := nil;
  fPreviewFilter := theFilter;
  fPreviewFilter.OnFilterUpdate := Handle_FilterUpdate;
  fIEViewDisplay := theIEView;
  fpreviewhandler.RegisterIEView(theIEView, Handle_ApplyChanges_Display);
  //attach also to inherited TImageEnproc
  SetAttached_Custom(theIEView);
end;

procedure TIEProc_EX.Preview_Register(theIEView: Timageenview; theFilterList: TIEProc_EX_Filter_Collection);
begin
  fPreviewFilter := nil;
  fPreviewFilterList := theFilterList;
  fPreviewFilterList.OnFilterUpdate := Handle_FilterUpdate;
  fIEViewDisplay := theIEView;
 // fPreviewHandler.PreviewMode := pm_FullUpdate;
  fpreviewhandler.RegisterIEView(theIEView, Handle_ApplyChanges_Display);
  //attach also to inherited TImageEnproc
  SetAttached_Custom(theIEView);
end;

procedure TIEProc_EX.Preview_Unregister;
begin
  fPreviewFilter := nil;
  fPreviewFilterList := nil;
  fPreviewHandler.UnregisterIEView;
end;

procedure TIEProc_EX.Preview_Apply;
begin
  if not assigned(fIEViewDisplay) then
    raise Exception.Create('No Display for Preview is Attached');


  inc(fPreviewApplyCtr);
  try
    Process_ApplyCurrent(true);

    fPreviewHandler.FireBufferNeeded;  //this is very important in order to update the preview buffer

  finally
    dec(fPreviewApplyCtr);

  end;

end;

procedure TIEProc_EX.Preview_Lock;
begin
  fPreviewHandler.LockPreview;
end;

procedure TIEProc_EX.Preview_Unlock;
begin
   fPreviewHandler.UnLockPreview(true);
end;

procedure TIEProc_EX.Preview_Toggle(const bPreviewIsOn: boolean);
begin
  fPreviewHandler.TogglePreview(bPreviewIsOn);
end;

procedure TIEProc_EX.HandleInternalProgress(Sender: TObject; per: integer);
begin
  if not fProgressRcd.Enabled then EXIT;

  fMTCS.enter;
  try

  fProgressRcd.Progress := (fProgressRcd.FilterIdx -1) * (100 div fProgressRcd.FilterTot) + per div fProgressRcd.FilterTot;
  if Assigned(fOnFilter_Progress) then
    fOnFilter_Progress(self, fProgressRcd.Progress);

  finally
    fMTCs.Leave;
  end;
end;

procedure TIEProc_EX.HandleInternalFinishWork(Sender: TObject);
begin

end;

procedure TIEProc_EX.EnableOnProgress;
begin
  fProgressRcd.Enabled := True;
  fBE.OnProgress := HandleInternalProgress;
  fBE.OnFinishWork := HandleInternalFinishWork;
end;
procedure TIEProc_EX.DisableOnProgress;
begin
  fProgressRcd.Enabled := False;
  fBE.OnProgress := nil;
  fBE.OnFinishWork := nil;
end;

procedure TIEProc_EX.SetAttached_Custom(attObject: TObject);
begin
  if (attObject is TIEView) then
    AttachedImageEn := TIEView(attObject)
  else if (attObject is TIEBitmap) then
     AttachedIEBitmap := TIEBitmap(attObject)
     else if (attObject is TBitmap) then
     AttachedBitmap := TBitmap(attObject);
end;



procedure TIEProc_EX.SetMultiThreadDefOverlapMethod(
  const Value: TIEMultiProc_EX_OverlapMethod);
begin
  fBe.MultiThreadDefOverlapMethod := Value;
end;

procedure TIEProc_EX.SetMultiThreadEnabled(const Value: boolean);
begin
  fBE.MultiThreadEnabled := Value;
end;

procedure TIEProc_EX.SetMultiThreadNrThreads(const Value: cardinal);
begin
  fBE.MultiThreadNrThreads := Value;
end;

procedure TIEProc_EX.SetOnFilter_CustomMultiThreadInfo(
  const Value: TIEProc_Ex_CustomMultiThreadInfoEvent);
begin
  fBE.OnFilter_CustomMultiThreadInfo := value;
end;

procedure TIEProc_EX.SetOnFilter_FinishWork(const Value: TNotifyEvent);
begin
  fOnFilter_FinishWork := Value;
  inherited OnFinishWork := Value;
end;

procedure TIEProc_EX.SetOnFilter_Progress(const Value: TIEProgressEvent);
begin
  fOnFilter_Progress := Value;
  inherited OnProgress := Value;  // inherited from Imageenproc
end;

procedure TIEProc_EX.Handle_FilterUpdate(sender:TObject);
begin
  fPreviewHandler.RefreshPReview;
end;


function TIEProc_EX.GetUseFastPreview: boolean;
begin
  result := fPreviewHandler.UseFastPreview;
end;

procedure TIEProc_EX.SetUseFastPreview(bValue: boolean);
begin
  fPreviewHandler.UseFastPreview := bvalue;
end;



function TIEProc_EX.GetMultiThreadDefOverlapMethod: TIEMultiProc_EX_OverlapMethod;
begin
  result := fBE.MultiThreadDefOverlapMethod;
end;

function TIEProc_EX.GetMultiThreadEnabled: boolean;
begin
  result := fBE.MultiThreadEnabled;
end;

function TIEProc_EX.GetMultiThreadNrThreads: cardinal;
begin
   result := fBE.MultiThreadNrThreads;
end;

function TIEProc_EX.GetOnFilter_CustomMultiThreadInfo: TIEProc_Ex_CustomMultiThreadInfoEvent;
begin
  result := fBE.OnFilter_CustomMultiThreadInfo;
end;

function TIEProc_EX.GetOnFinishWork: TNotifyEvent;
begin
  result := fOnFilter_FinishWork;
end;

function TIEProc_EX.GetOnProgress: TIEProgressEvent;
begin
  result := inherited OnProgress;
end;

function TIEProc_EX.GetPreviewLockCount: integer;
begin
  result := fPreviewHandler.LockCount;
end;

function TIEProc_EX.GetPreviewMode: TIEUtils_IEPreview_Mode;
begin
  result := fPreviewHandler.PreviewMode;
end;

function TIEProc_EX.GetPreviewRegistered: boolean;
begin
  result := fPreviewHandler.PreviewRegistered;
end;

procedure TIEProc_EX.SetPreviewMode(const Value: TIEUtils_IEPreview_Mode);
begin
   fPreviewHandler.PreviewMode := Value;
end;

procedure TIEProc_EX.Contrast(vv: extended);
var
aFilter: TIEProc_EX_Filter_IE_Contrast;
begin
   aFilter := TIEProc_EX_Filter_IE_Contrast.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST_AMOUNT, vv);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.Contrast2(Amount: double);
var
aFilter: TIEProc_EX_Filter_IE_Contrast2;
begin
   aFilter := TIEProc_EX_Filter_IE_Contrast2.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST2_AMOUNT, Amount);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.Contrast3(Change, Midpoint: Integer; DoRed, DoGreen, DoBlue: Boolean);
var
aFilter: TIEProc_EX_Filter_IE_Contrast3;
begin
   aFilter := TIEProc_EX_Filter_IE_Contrast3.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST3_CHANGE, Change);
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST3_MIDPOINT, Midpoint);
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST3_DORED, DoRed);
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST3_DOGREEN, DoGreen);
     aFilter.SetParamValue(IEPROC_EX_IE_CONTRAST3_DOBLUE, DoBlue);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;


procedure TIEProc_EX.GammaCorrect(Gamma: Double; Channel: TIEChannels = [iecRed, iecGreen, iecBlue]);
var
aFilter: TIEProc_EX_Filter_IE_GammaCorrect;
begin
   aFilter := TIEProc_EX_Filter_IE_GammaCorrect.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_GAMMACORRECT_GAMMA, Gamma);
     aFilter.SetParamValue(IEPROC_EX_IE_GAMMACORRECT_DORED, iecRed in Channel);
     aFilter.SetParamValue(IEPROC_EX_IE_GAMMACORRECT_DOGREEN, iecGreen in Channel);
     aFilter.SetParamValue(IEPROC_EX_IE_GAMMACORRECT_DOBLUE, iecBlue in Channel);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.UnsharpMask(Radius: Double = 4.0; Amount: Double = 1.0; Threshold: Double = 0.05);
var
aFilter: TIEProc_EX_Filter_IE_UnsharpMask;
begin
   aFilter := TIEProc_EX_Filter_IE_UnsharpMask.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_UNSHARPMASK_RADIUS, Radius);
     aFilter.SetParamValue(IEPROC_EX_IE_UNSHARPMASK_AMOUNT, Amount);
     aFilter.SetParamValue(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD, Threshold);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.WhiteBalance_AutoWhite;
var
aFilter: TIEProc_EX_Filter_IE_WhiteBalance_AutoWhite;
begin
   aFilter := TIEProc_EX_Filter_IE_WhiteBalance_AutoWhite.Create;
   try
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.WhiteBalance_coef(Red, Green, Blue: Double);
var
aFilter: TIEProc_EX_Filter_IE_WhiteBalance_coef;
begin
   aFilter := TIEProc_EX_Filter_IE_WhiteBalance_coef.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_WHITEBALANCE_COEF_RED, Red);
     aFilter.SetParamValue(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN, Green);
     aFilter.SetParamValue(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE, Blue);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.WhiteBalance_GrayWorld;
var
aFilter: TIEProc_EX_Filter_IE_WhiteBalance_Grayworld;
begin
   aFilter := TIEProc_EX_Filter_IE_WhiteBalance_Grayworld.Create;
   try
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.WhiteBalance_WhiteAt(WhiteX, WhiteY: Integer);
var
aFilter: TIEProc_EX_Filter_IE_WhiteBalance_WhiteAt;
begin
   aFilter := TIEProc_EX_Filter_IE_WhiteBalance_WhiteAt.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX, WhiteX);
     aFilter.SetParamValue(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY, WhiteY);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.HSLvar(oHue, oSat, oLum: Integer);
var
aFilter: TIEProc_EX_Filter_IE_HSLvar;
begin
   aFilter := TIEProc_EX_Filter_IE_HSLvar.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_HSLVAR_HUE, oHue);
     aFilter.SetParamValue(IEPROC_EX_IE_HSLVAR_SAT, oSat);
     aFilter.SetParamValue(IEPROC_EX_IE_HSLVAR_LUM, oLum);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.HSVvar(oHue, oSat, oVal: Integer);
var
aFilter: TIEProc_EX_Filter_IE_HSVvar;
begin
   aFilter := TIEProc_EX_Filter_IE_HSVvar.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_HSVVAR_HUE, oHue);
     aFilter.SetParamValue(IEPROC_EX_IE_HSVVAR_SAT, oSat);
     aFilter.SetParamValue(IEPROC_EX_IE_HSVVAR_VALUE, oVal);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.Intensity(LoLimit, HiLimit, Change: Integer; UseAverageRGB: Boolean; DoRed, DoGreen, DoBlue: Boolean);
var
aFilter: TIEProc_EX_Filter_IE_Intensity;
begin
   aFilter := TIEProc_EX_Filter_IE_Intensity.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_LOLIMIT, LoLimit);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_HILIMIT, HiLimit);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_CHANGE, Change);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB, UseAverageRGB);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_DORED, DoRed);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_DOGREEN, DoGreen);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITY_DOBLUE, DoBlue);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.IntensityRGBAll(r, g, b: Integer);
var
aFilter: TIEProc_EX_Filter_IE_IntensityRGBAll;
begin
   aFilter := TIEProc_EX_Filter_IE_IntensityRGBAll.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED, r);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN, g);
     aFilter.SetParamValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE, b);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.Median(Window, Threshold: integer);
var
aFilter: TIEProc_EX_Filter_IE_Median;
begin
   aFilter := TIEProc_EX_Filter_IE_Median.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_MEDIAN_WINDOW, Window);
     aFilter.SetParamValue(IEPROC_EX_IE_MEDIAN_THRESHOLD, Threshold);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.MedianSharpen(Window, Multiplier: integer);
var
aFilter: TIEProc_EX_Filter_IE_Median_Sharpen;
begin
   aFilter := TIEProc_EX_Filter_IE_Median_Sharpen.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW, Window);
     aFilter.SetParamValue(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER, Multiplier);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.Sharpen(Intensity: Integer = 10; Neighbourhood: Integer = 4);
var
aFilter: TIEProc_EX_Filter_IE_Sharpen;
begin
   aFilter := TIEProc_EX_Filter_IE_Sharpen.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_SHARPEN_AMOUNT, Intensity);
     aFilter.SetParamValue(IEPROC_EX_IE_SHARPEN_WINDOW, Neighbourhood);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.FindEdges(KernelSize:TIEProc_EX_Filter_Kernelsize);
var
aFilter: TIEProc_EX_Filter_IE_FindEdges;
begin
   aFilter := TIEProc_EX_Filter_IE_FindEdges.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_FINDEDGES_KERNELSIZE, KernelSize);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.Negative;
var
aFilter: TIEProc_EX_Filter_IE_Negative;
begin
   aFilter := TIEProc_EX_Filter_IE_Negative.Create;
   try
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AdjustBrightnessContrastSaturation(Brightness, Contrast, Saturation: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AdjustBrightnessContrastSaturation;
begin
   aFilter := TIEProc_EX_Filter_IE_AdjustBrightnessContrastSaturation.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS, Brightness);
     aFilter.SetParamValue(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST, Contrast);
     aFilter.SetParamValue(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT, Saturation);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AdjustLumSatHistogram(Saturation, Luminance: Double);
var
aFilter: TIEProc_EX_Filter_IE_AdjustLumSatHistogram;
begin
   aFilter := TIEProc_EX_Filter_IE_AdjustLumSatHistogram.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM, Luminance);
     aFilter.SetParamValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT, Saturation);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AdjustSaturation(Amount: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AdjustSaturation;
begin
   aFilter := TIEProc_EX_Filter_IE_AdjustSaturation.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT, Amount);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AdjustTemperature(temperature: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AdjustTemperature;
begin
   aFilter := TIEProc_EX_Filter_IE_AdjustTemperature.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT, temperature);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AdjustTint(Amount: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AdjustTint;
begin
   aFilter := TIEProc_EX_Filter_IE_AdjustTint.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_ADJUST_TINT_AMOUNT, Amount);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;


procedure TIEProc_EX.AutoImageEnhance1(SubsampledSize, Slope, Cut,
  Neighbour: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AutoImageEnhance1;
begin
   aFilter := TIEProc_EX_Filter_IE_AutoImageEnhance1.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE, SubsampledSize );
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE, Slope);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT, Cut);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR, Neighbour );
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AutoImageEnhance2(ScaleCount, ScaleCurve: Integer;
  Variance: Double; ScaleHigh: Integer; Luminance: Boolean);
var
aFilter: TIEProc_EX_Filter_IE_AutoImageEnhance2;
begin
   aFilter := TIEProc_EX_Filter_IE_AutoImageEnhance2.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT, ScaleCount);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE, ScaleCurve);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE, Variance);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH, ScaleHigh);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE, Luminance);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AutoImageEnhance3(Gamma: Double; Saturation: Integer);
var
aFilter: TIEProc_EX_Filter_IE_AutoImageEnhance3;
begin
   aFilter := TIEProc_EX_Filter_IE_AutoImageEnhance3.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA, Gamma);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION, Saturation);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.AutoSharp(Intensity: Integer=68; rate: Double = 0.035);
var
aFilter: TIEProc_EX_Filter_IE_AutoSharp;
begin
   aFilter := TIEProc_EX_Filter_IE_AutoSharp.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOSHARP_INTENSITY, Intensity);
     aFilter.SetParamValue(IEPROC_EX_IE_AUTOSHARP_RATE, rate);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.Blur(radius: Double);
var
aFilter: TIEProc_EX_Filter_IE_Blur;
begin
   aFilter := TIEProc_EX_Filter_IE_Blur.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_IE_BLUR_RADIUS, radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;


procedure TIEProc_EX.SmartFlash(Amount: byte; Radius: integer);
var
aFilter: TIEProc_EX_Filter_SmartFlash;
begin
   aFilter := TIEProc_EX_Filter_SmartFlash.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_SMARTFLASH_AMOUNT, Amount);
     aFilter.SetParamValue(IEPROC_EX_SMARTFLASH_RADIUS, Radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.Smooth(Amount: integer);
var
aFilter: TIEProc_EX_Filter_Smooth;
begin
   aFilter := TIEProc_EX_Filter_Smooth.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_SMOOTHFILTER_AMOUNT, Amount);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.ReduceHighlights(Amount: byte; Radius: integer);
var
aFilter: TIEProc_EX_Filter_ReduceHighlights;
begin
   aFilter := TIEProc_EX_Filter_ReduceHighlights.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT, Amount);
     aFilter.SetParamValue(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS, Radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.FillBackLight(AmountFill, AmountBack: byte; Radius: integer);
var
aFilter: TIEProc_EX_Filter_FillBackLight;
begin
   aFilter := TIEProc_EX_Filter_FillBackLight.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT, AmountFill);
     aFilter.SetParamValue(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT, AmountBack);
     aFilter.SetParamValue(IEPROC_EX_FILLBACKLIGHT_RADIUS, Radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.SmartContrast(Amount: byte; Radius: integer);
var
aFilter: TIEProc_EX_Filter_SmartContrast;
begin
   aFilter := TIEProc_EX_Filter_SmartContrast.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_SMARTCONTRAST_AMOUNT, Amount);
     aFilter.SetParamValue(IEPROC_EX_SMARTCONTRAST_RADIUS, Radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

Procedure TIEProc_EX.RGBBalance(Uniform:boolean; ShadowRed, ShadowGreen, ShadowBlue, MidRed,MidGreen,MidBlue, HiRed, HiGreen,HiBlue, AllRed, AllGreen, AllBlue:integer);
var
aFilter: TIEProc_EX_Filter_RGBBalance;
begin
   aFilter := TIEProc_EX_Filter_RGBBalance.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_UNIFORM, Uniform);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED, ShadowRed);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN, ShadowGreen);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE, ShadowBlue);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED, MidRed);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN, MidGreen);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE, MidBlue);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED, HiRed);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN, HiGreen);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE, HiBlue);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED, AllRed);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN, AllGreen);
     aFilter.SetParamValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE, AllBlue);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

Procedure TIEProc_EX.AutoColor(Strength:byte);
var
aFilter: TIEProc_EX_Filter_AutoColor;
begin
   aFilter := TIEProc_EX_Filter_AutoColor.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_AUTOCOLOR_STRENGTH, Strength);

     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

procedure TIEProc_EX.ColorFilter(Color:TColor; BlendMode: TIEProc_EX_Filter_Blendmode; Amount:byte);
var
aFilter: TIEProc_EX_Filter_ColorFilter;
begin
   aFilter := TIEProc_EX_Filter_ColorFilter.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_COLORFILTER_AMOUNT, Amount);
     aFilter.SetParamValue(IEPROC_EX_COLORFILTER_COLOR, Color);
     aFilter.SetParamValue(IEPROC_EX_COLORFILTER_BLENDMODE, BlendMode);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;
end;

procedure TIEProc_EX.Bilateral(Radius, SigmaI, SigmaD:Integer);
var
aFilter: TIEProc_EX_Filter_BilateralFilter;
begin
   aFilter := TIEProc_EX_Filter_BilateralFilter.Create;
   try
     aFilter.SetParamValue(IEPROC_EX_BILATERALFILTER_SIGMA, SigmaI);
     aFilter.SetParamValue(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE, SigmaD);
     aFilter.SetParamValue(IEPROC_EX_BILATERALFILTER_RADIUS, Radius);
     Process_Apply(aFilter);
   finally
     aFilter.Free;
   end;

end;

end.


