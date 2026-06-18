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
unit NWSComps_IEUtils_Previews;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}
{$I ..\_inc\NWSComps_RGBCurves.inc}

uses Windows, Messages, SysUtils, Classes,graphics, controls, Forms, math,
  imageenview, hyiedefs, hyieutils {$IFDEF IMAGEEN_6_2_LATER} , iexBitmaps {$ENDIF}
  {$IFDEF IMAGEEN_7_0_0_LATER} , iexLayers {$ENDIF};

const
 GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
type

  TIEUtils_IEPreviewEvent = procedure(previewID: TGUID;  linkToFullBmp:boolean; theiebitmap: TIEbitmap;
                                      mask: TIEMask;
                                      EditedRect: TRect; const bUseMask: boolean) of object;


  TIEUtils_IEPreview_Mode = (pm_FullUpdate, pm_Flat, pm_Auto);
  TIEUtils_IEPreview_Kind = (pk_FullUpdate, pk_Flat);


  TIEUtils_IEPreview_AssignedBuffersRcd = Record

    Buf25p: boolean;
    Buf50p: boolean;
    Buf75p:boolean;
  end;

  TIEUtils_IEPreview  = class(TPersistent)

    private

      fAttachedIEView: Timageenview;
      fPreview_Kind: TIEUtils_IEPreview_Kind;
      fUseFastPreview: boolean;

      fPreviewCount: integer;

      fBuffer_LayGUID: TGUID;
      fBuffer: TIEBitmap;
      fBuffer_25p: TIEBitmap;
      fBuffer_50p: TIEBitmap;
      fBuffer_75p: TIEBitmap;
      fBuffer_Orig: TIEBitmap;

    //  fPreviewInterval: integer;
      fFullUpdateInitialized: boolean;
      fPreviewGUID: TGuid;

      procedure setUseFastPreview(theValue: boolean);
      procedure SetPreview_Kind(theValue: TIEUtils_IEPreview_Kind);



     protected

      OnApplyChanges: TIEUtils_IEPreviewEvent;

      AssignedBuffers: TIEUtils_IEPreview_AssignedBuffersRcd;

      Property Preview_Kind: TIEUtils_IEPreview_Kind read fPreview_Kind write SetPreview_Kind;
      Property UseFastPreview: boolean read fUseFastPreview write SetUseFastPreview;

      property AttachedIEView: Timageenview read fAttachedIEView write fAttachedIEView;

      procedure GetPreviewBuffer;

      procedure InitFullUpdate(bResetBuffers: boolean);
      procedure FinalizeFullUpdate;   overload;
      procedure FinalizeFullUpdate(layIdx:integer); overload;

      procedure EmptyPreviewBuffer;

      procedure DoPreview(bToggleOn: boolean);
      procedure DoPreview_FULL_UPDATE(bToggleOn: boolean);
      procedure DoPreview_FLAT(bToggleOn: boolean);
      procedure DoPreview_FLAT_AccountMaskAndLayerAC(thePreview_Orig, thePreview_Edited: TIEBitmap;
                                                      theMask: TIEMask);
      procedure DoPreview_ApplyChangesDirect(theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean);

      procedure DoPreview_ApplyChangesBySmallBuffer(theiebitmap, theBuffer: TIEbitmap;
                                                    mask: TIEMask;
                                                    EditedRect: TRect;
                                                    const bUseMask: boolean);

    public

      Busy:boolean;

      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure NewGuid;
      property PreviewGUID: TGuid read fPreviewGUID;

      function CheckCanPreview: boolean;

  end;

  TIEUtils_IEPreviewEventsHandler = class(TPersistent)
  private
    fPreviewRegistered: boolean;

    fSelectionChanging: boolean;

    flagMouseDown: boolean;


    fPreviewMode: TIEUtils_IEPreview_Mode;
    fPreviewToggleOn: boolean;

    fPreview: TIEUtils_IEPreview;
    fAttachedIEView: Timageenview;
    fOnUpdateNeeded: TNotifyEvent;
    fOnUpdateBufferNeeded: TNotifyEvent;

    fOldMouseDown, fOldMouseUp: TMouseEvent;
    fOLDSelectionChange, fOLDSelectionChanging: TNotifyEvent;
    fOLDDrawCanvas: TIEOnDrawCanvas;
    fOLDImageChange: TNotifyEvent;
    fOLDViewChange:  TViewchangeEvent;
    fOldLayerNotify: TIELayerNotify;

    fLockCount: integer;

    procedure SetAttachedIeView(theIeview: Timageenview);
    function GetUSeFastPreview: boolean;
    procedure SetUseFastPreview(theValue: boolean);
    procedure SetPreviewMode(theValue: TIEUtils_IEPreview_Mode);

    procedure GetimageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GetimageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GetimageSelectionChange(Sender: TObject);
    procedure GetimageSelectionChanging(Sender: TObject);
    procedure GetimageLayerNotify(Sender:TObject; layer:integer; event:TIELayerEvent);
    procedure GetimageDrawCanvas(Sender: TObject; ACanvas: TCanvas; ARect: TRect);
    procedure GetImageChange(Sender: TObject);
    procedure GetImageViewChange(Sender: TObject; Change:integer);

    procedure GetEventsfromIEView(theIeview: Timageenview);
    procedure ReleaseEventstoIEView(theIeview: Timageenview);

  protected



  public

    OnBeforePreview: TNotifyEvent;
    OnAfterPreview: TNotifyEvent;

    Property UseFastPreview: boolean read GetUSeFastPreview write SetUseFastPreview;
    property Preview: TIEUtils_IEPreview read fPreview write fPreview;
    property PreviewMode: TIEUtils_IEPreview_Mode read fPreviewMode write SetPreviewMode;
    property PreviewRegistered: boolean read fPreviewRegistered;
    property OnUpdateNeeded: TNotifyEvent read fOnUpdateNeeded write fOnUpdateNeeded;
    property OnUpdateBufferNeeded: TNotifyEvent read fOnUpdateBufferNeeded write fOnUpdateBufferNeeded;

    property LockCount: integer read fLockCount;


    procedure RegisterIEView(theIEView: Timageenview; theOnApplyChanges: TIEUtils_IEPreviewEvent);
    procedure UnregisterIEView;

    procedure LockPreview;
    procedure UnlockPreview(bResetBuffers: boolean);
    procedure TogglePreview(const bPreviewIsOn: boolean);

    procedure RefreshPreview;
    procedure ApplyPreview;
 

    constructor Create(theIeView: Timageenview); reintroduce;
    destructor Destroy; override;

    procedure FireUpdateNeeded;
    procedure FireBufferNeeded;

  end;




implementation
  uses activex, imageenproc;



function myXScr2LAY(x: integer; imageen: TimageenView): integer;
begin
  with imageen do
    result := trunc((XScr2Bmp(X) - Layers[imageen.layerscurrent].PosX) * IEBitmap.Width / Layers[imageen.layerscurrent].Width);
end;

function myYScr2LAY(y: integer; imageen: TimageenView): integer;
begin
  with imageen do
    result := trunc((YScr2Bmp(Y) - Layers[imageen.layerscurrent].PosY) * IEBitmap.Height / Layers[imageen.layerscurrent].Height);
end;

//---------------------------Class TIEUtils_IEPreview----------START


constructor TIEUtils_IEPreview.Create;
begin
   inherited Create;
    NewGuid;
    Busy := false;
    fBuffer_25p := TIEBitmap.Create;
    fBuffer_50p := TIEBitmap.Create;
    fBuffer_75p := TIEBitmap.Create;
    fBuffer_Orig := TIEBitmap.Create;

    fPreview_Kind := pk_FullUpdate;
    fUseFastPreview := TRUE;

    fPreviewCount := 0;
end;


destructor TIEUtils_IEPreview.Destroy;
begin
   fBuffer_25p.Free;
   fBuffer_50p.Free;
   fBuffer_75p.Free;
   fBuffer_Orig.Free;

   inherited;
end;


procedure TIEUtils_IEPreview.setUseFastPreview(theValue: boolean);
begin
  if fUseFastPreview <> theValue then
  begin
    fUseFastPreview := theValue;

    if assigned(fAttachedIEView) then
      fAttachedIEView.Refresh;

  end;
end;


procedure TIEUtils_IEPreview.SetPreview_Kind(theValue: TIEUtils_IEPreview_Kind);
begin

  if thevalue = fPreview_Kind  then EXIT;

  case theValue of
    pk_FullUpdate:
      begin
        InitFullUpdate(true);
      end;
    pk_Flat:
      begin
        FinalizeFullUpdate;
      end;
  end;


  //Set this only in the end-----
  fPreview_Kind := theValue;
  //-----------------------------


end;


procedure TIEUtils_IEPreview.GetPreviewBuffer;
function DoResample(const ratio: double; aBMP: TIEBitmap): boolean;
var
  ieproc: TImageenproc;
begin
result := TRUE;
  ieproc := TImageenproc.Create(nil);
      try
        try
        ieproc.AttachedIEBitmap := fBuffer_Orig;
        ieproc.ResampleTo(aBMP, round(ratio * fBuffer_Orig.Width),
                                               round(ratio * fBuffer_Orig.Height),
                                               rflinear);
        finally
          ieproc.Free;
        end;
      except
        result := False;
      end;
end;


begin
  if not assigned(fAttachedIEView) then EXIT;

  if not fUseFastPreview then
  begin
    fBuffer := fBuffer_Orig;
    EXIT;  //>>>> EXIT
  end;

  fBuffer := fBuffer_Orig;
 

  if fAttachedIEView.Zoom >= 75 then
  begin
    fBuffer := fBuffer_Orig;
  end
  else if fAttachedIEView.Zoom >= 50 then
  begin
    if AssignedBuffers.Buf75p then
      fBuffer := fBuffer_75p
    else
    begin
      if DoResample(0.75, fBuffer_75p) then
      begin
        AssignedBuffers.Buf75p := TRUE;
        fBuffer := fBuffer_75p;
      end;
    end;
  end
  else if fAttachedIEView.Zoom >= 25 then
  begin
    if AssignedBuffers.Buf50p then
      fBuffer := fBuffer_50p
    else
    begin
      if DoResample(0.5, fBuffer_50p) then
      begin
        AssignedBuffers.Buf50p := TRUE;
        fBuffer := fBuffer_50p;
      end;
    end;
  end
  else //0- 25
  begin
    if AssignedBuffers.Buf25p then
    begin
      fBuffer := fBuffer_25p;
    end
    else
    begin
      if DoResample(0.25, fBuffer_25p) then
      begin
        AssignedBuffers.Buf25p := TRUE;
        fBuffer := fBuffer_25p;
      end;
    end;
  end;

end;


procedure TIEUtils_IEPreview.InitFullUpdate(bResetBuffers: boolean);
begin
  if not assigned(fAttachedIEView) then EXIT;
  if fPreview_Kind <> pk_FullUpdate then EXIT;

  fPreviewCount := 0;
  if (not bResetBuffers) and fFullUpdateInitialized then EXIT;



   if (bResetBuffers)  //if explicit reset
    or (not CompareGUID(fBuffer_LayGUID, fAttachedIEView.CurrentLayer.GUID)) then  //or if the GUID of the layer is different from that of the buffer
   begin
     //reset buffers
     with AssignedBuffers do
     begin
       Buf25p := False;
       Buf50p := False;
       Buf75p := False;
     end;

     fBuffer_LayGUID := fAttachedIEView.CurrentLayer.GUID;
     fBuffer_Orig.assign(fAttachedIEView.CurrentLayer.Bitmap);

     NewGuid; //preview gets a new guid as well (for some filters rely on cache based on guid)
   end;
   fFullUpdateInitialized := true;
end;

procedure TIEUtils_IEPreview.NewGuid;
begin
  CoCreateGuid(fPreviewGUID);
end;

procedure TIEUtils_IEPreview.FinalizeFullUpdate;
begin
  if not assigned(fAttachedIEView) then EXIT;
  if fPreview_Kind <> pk_FullUpdate then EXIT;
  if not fFullUpdateInitialized then EXIT;

  fPreviewCount := 0;
  if CompareGUID(fBuffer_LayGUID, fAttachedIEView.CurrentLayer.GUID) then
    fAttachedIEView.CurrentLayer.Bitmap.assign(fBuffer_Orig);

  fFullUpdateInitialized := false;
end;

procedure TIEUtils_IEPreview.FinalizeFullUpdate(layIdx:integer);
begin
  if not assigned(fAttachedIEView) then EXIT;
  if fPreview_Kind <> pk_FullUpdate then EXIT;
  if not fFullUpdateInitialized then EXIT;

  fPreviewCount := 0;
  fAttachedIEView.Layers[Layidx].Bitmap.assign(fBuffer_Orig);

  fFullUpdateInitialized := false;
end;

procedure TIEUtils_IEPreview.EmptyPreviewBuffer;
begin
  if assigned(fBuffer) then
  begin
    fBuffer_Orig.Width := 0;
    fBuffer_Orig.Height := 0;
  end;

  if assigned(fBuffer_25p) then
  begin
    fBuffer_25p.Width := 0;
    fBuffer_25p.Height := 0;
  end;

  if assigned(fBuffer_50p) then
  begin
    fBuffer_50p.width := 0;
    fBuffer_50p.height := 0;
  end;

  if assigned(fBuffer_75p) then
  begin
    fBuffer_75p.width := 0;
    fBuffer_75p.height := 0;
  end;
end;



procedure TIEUtils_IEPreview.DoPreview(bToggleOn: boolean);
begin
  if AttachedIEView.CurrentLayer.Kind <> ielkImage then
    EXIT;

  if fPreview_Kind = pk_FullUpdate then
      DoPreview_FULL_UPDATE(bToggleOn)
    else
      DoPreview_FLAT(bToggleOn);
end;

function TIEUtils_IEPreview.CheckCanPreview: boolean;
begin
  result :=  assigned(fAttachedIEView) and assigned(OnApplyChanges);
end;

procedure TIEUtils_IEPreview.DoPreview_FULL_UPDATE(bToggleOn: boolean);
var
  x1, y1, x2, y2: integer;
  x1l, y1l, x2l, y2l: integer;
  x1d, y1d, x2d, y2d: integer;
  EditedRect: TRect;
  aLayer: TIELayer;
begin

  if not CheckCanPreview then EXIT;

  if not fFullUpdateInitialized then
    EXIT;

  if fPreviewCount>0 then
  begin
    dec(fPreviewCount);
    EXIT;
  end;

  inc(fPreviewCount);

  if not CompareGUID(fBuffer_LayGUID, fAttachedIEView.CurrentLayer.GUID) then EXIT;

  fAttachedIEView.LockUpdate;

  GetPreviewBuffer;

  aLayer := fAttachedIEView.CurrentLayer;
  try
    x1l := 0;
    y1l := 0;
    x2l := aLayer.Bitmap.Width - 1;
    y2l := aLayer.Bitmap.Height- 1;

    x1d := 0;
    y1d := 0;
    x2d := 2* fAttachedIEView.OffsetX + fAttachedIEView.ExtentX - 1;
    y2d := 2 * fAttachedIEView.OffsetY + fAttachedIEView.ExtentY - 1;

    x1 := max(x1l, myXScr2LAY(x1d, fAttachedIEView));
    y1 := max(y1l, myYScr2LAY(y1d, fAttachedIEView));
    x2 := min(x2l, myXScr2LAY(x2d, fAttachedIEView));
    y2 := min(y2l, myYScr2LAY(y2d, fAttachedIEView));
    EditedRect := rect(x1, y1, x2, y2);

    if bToggleOn then
    begin
      if fUseFastPreview then
      begin
        DoPreview_ApplyChangesBySmallBuffer(aLayer.Bitmap, fBuffer,
                                              fAttachedIEView.SelectionMask,
                                            EditedRect, (assigned(fAttachedIEView.SelectionMask) and (not fAttachedIEView.SelectionMask.IsEmpty)));
      end
      else
      begin
        aLayer.Bitmap.assign(fBuffer_Orig);
        DoPreview_ApplyChangesDirect(aLayer.Bitmap, fAttachedIEView.SelectionMask, EditedRect,
                              (assigned(fAttachedIEView.SelectionMask) and (not fAttachedIEView.SelectionMask.IsEmpty)));
      end;
    end
    else
      aLayer.Bitmap.assign(fBuffer_Orig);


  finally
 

    fAttachedIEView.UnLockUpdateEx;

    fAttachedIEView.UpdateNoPaint;

    fAttachedIEView.repaint;
  end;

end;





procedure TIEUtils_IEPreview.DoPreview_FLAT(bToggleOn: boolean);
var
  EditedRect: TRect;

  previewFrame_bmp: tbitmap;
  previewFrame, previewFrame_Edited: TIEBitmap;
begin
  if not CheckCanPreview then EXIT;

  if not bToggleOn then
  begin
    fAttachedIEView.Invalidate;
    EXIT;
  end;

  previewFrame := TIEBitmap.Create;
  previewFrame_Edited := TIEBitmap.Create;

  previewFrame_bmp := TBitmap.Create;
  previewFrame_bmp.PixelFormat := pf24bit;
  try

    previewFrame.EncapsulateTBitmap(previewFrame_bmp, false);

    with fAttachedIEView do
    begin
      previewFrame.Width := ExtentX;
      previewFrame.Height := Extenty;
      DrawTo(previewFrame.canvas);
    end;

    EditedRect := rect(0, 0, previewFrame.Width - 1, previewFrame.Height - 1);
    previewFrame_Edited.AssignImage(previewFrame);

    DoPreview_ApplyChangesDirect(previewFrame_Edited, nil,  EditedRect,False);
    DoPreview_FLAT_AccountMaskAndLayerAC(previewFrame, previewFrame_Edited, fAttachedIEView.SelectionMask);

    fAttachedIEView.getcanvas.CopyRect(rect(fAttachedIEView.offsetx,
                                            fAttachedIEView.offsety,
                                            fAttachedIEView.offsetx + previewFrame.Width + 1,
                                            fAttachedIEView.offsety + previewFrame.Height + 1),
                                       previewFrame.Canvas,
                                       rect(0,
                                            0,
                                            previewFrame.Width + 1,
                                            previewFrame.Height + 1)
                                       );

    

    finally

    previewFrame_Edited.Free;
    previewFrame.free;
    previewFrame_bmp.Free;
  end;



end;


procedure TIEUtils_IEPreview.DoPreview_FLAT_AccountMaskAndLayerAC(thePreview_Orig, thePreview_Edited: TIEBitmap;
                                                      theMask: TIEMask);



 function myXScr2BMP(x: integer; imageen: TimageenView): integer;
 begin

    with imageen do
    begin
      if layerscurrent = 0 then
        result := XScr2Bmp(offsetx + x)
      else
        result := trunc((XScr2Bmp(offsetx + x) - Layers[layerscurrent].PosX)
            * IEBitmap.Width / Layers[layerscurrent].Width);
    end;
  end;

  function myYScr2BMP(Y: integer; imageen: TimageenView): integer;
  begin
    with imageen do
    begin
      if layerscurrent = 0 then
        result := YScr2Bmp(offsety + Y)
      else
        result := trunc((YScr2Bmp(offsety + Y) - Layers[layerscurrent].PosY)
            * IEBitmap.Height / Layers[layerscurrent].Height);
    end;
  end;


var
  i, j, m: integer;

  r_orig, g_orig, b_orig: byte;
  r_edited, g_edited, b_edited: byte;

  xlay1, ylay1, xlay2, ylay2, xl, yl: integer;

  lcurrent: integer;

  tempx: integer;
  shiftby: integer;
  PixelP_Orig, PixelP_edited: PByteArray;

  bTestEdit: boolean;
  bTestEdit_mask, bTestEdit_layer: boolean;

  theLayer: TIELayer;
  theLayerBMP: TIEBitmap;
  lRect: array of TRect;
  mask_value, alpha_value: byte;

  function TestPointInLayer(x, Y: integer): boolean;
  var
    m: integer;
    axl, ayl: integer;
  begin
    axl := x + xlay1;
    ayl := Y + ylay1;
    result := true;
    for m := lcurrent + 1 to high(lrect) do
    begin
      if (axl >= lrect[m].Left) and (ayl >= lrect[m].Top) and
        (axl <= lrect[m].Right) and (ayl <= lrect[m].bottom) then
      begin
        result := false;
        break;
      end;
    end;

    result := result and
              (axl >= xlay1) and
              (ayl >= ylay1) and
              (axl <= xlay2) and
              (ayl <= ylay2);

  end;


begin
  lcurrent := fAttachedIEView.layerscurrent;
  theLayer :=  fAttachedIEView.Layers[lcurrent];
  theLayerBMP := theLayer.Bitmap;
  xlay1 := theLayer.PosX;
  ylay1 := theLayer.PosY;
  xlay2 := xlay1 + theLayerBMP.Width-1;
  ylay2 := ylay1 + theLayerBMP.Height-1;


  setlength(lrect, fAttachedIEView.LayersCount);
  for m := 0 to high(lrect) do
  begin
    with lrect[m] do
    begin
      Left := fAttachedIEView.Layers[m].PosX;
      Top := fAttachedIEView.Layers[m].PosY;
      Right := Left + fAttachedIEView.Layers[m].Width;
      bottom := Top + fAttachedIEView.Layers[m].Height;
    end;
  end;



  shiftby := 3;
  for j := 0 to thePreview_Orig.Height - 1 do
  begin
    PixelP_Orig := thePreview_Orig.scanline[j];
    PixelP_edited := thePreview_edited.scanline[j];
    yl := myYScr2BMP(j, fAttachedIEView);
    for i := 0 to thePreview_Orig.Width - 1 do
    begin
      xl := myXScr2BMP(i, fAttachedIEView);

      alpha_value := 255;

      bTestEdit_mask := TRUE;
      if not themask.IsEmpty then
      begin
        mask_value := themask.getpixel(xl, yl);
        bTestEdit_mask := mask_value  > 0;
      end;

      bTestEdit_Layer := TestPointInLayer(xl, yl);
      if theLayerBMP.HasAlphaChannel then
      begin
        alpha_value := theLayerBMP.Alpha[xl, yl];
        bTestEdit_Layer := alpha_value > 0;
      end;

      bTestEdit := bTestEdit_mask and bTestEdit_layer;

      if bTestEdit then
      begin
        tempx := shiftby * i;

        R_Orig := PixelP_Orig[tempx + 2];
        G_Orig := PixelP_Orig[tempx + 1];
        B_Orig := PixelP_Orig[tempx + 0];

        R_Edited := PixelP_Edited[tempx + 2];
        G_Edited := PixelP_Edited[tempx + 1];
        B_Edited := PixelP_Edited[tempx + 0];
      
        if alpha_value > 0 then
        begin
          R_Edited := (alpha_value * R_Edited + (255 - alpha_value) * R_orig) div 255;
          G_Edited := (alpha_value * G_Edited + (255 - alpha_value) * G_orig) div 255;
          B_Edited := (alpha_value * B_Edited + (255 - alpha_value) * B_orig) div 255;
        end;

        if themask.BitsPerPixel = 8 then
        begin
          if mask_value > 0 then
          begin
            R_Edited := (mask_value * R_Edited + (255 - mask_value) * R_orig) div 255;
            G_Edited := (mask_value * G_Edited + (255 - mask_value) * G_orig) div 255;
            B_Edited := (mask_value * B_Edited + (255 - mask_value) * B_orig) div 255;
          end;
        end;

        PixelP_Orig[tempx + 2] := R_Edited;
        PixelP_Orig[tempx + 1] := G_Edited;
        PixelP_Orig[tempx] := B_Edited;
      end;
    end;
  end;
end;




procedure TIEUtils_IEPreview.DoPreview_ApplyChangesDirect(theiebitmap: TIEbitmap; mask: TIEMask;
                                       EditedRect: TRect; const bUseMask: boolean);
begin
   if not assigned(OnApplyChanges) then EXIT;

   OnApplyChanges(fPreviewGUID, false, theiebitmap, mask,  EditedRect,
                            (assigned(mask) and (not mask.IsEmpty)))

end;

procedure TIEUtils_IEPreview.DoPreview_ApplyChangesBySmallBuffer(theiebitmap, theBuffer: TIEbitmap;
                                                    mask: TIEMask;
                                                    EditedRect: TRect;
                                                    const bUseMask: boolean);
var
  bufferRect: TRect;
  buffercopy: TIEBitmap;
  i, j: integer;
  bufferPixel24,resultPixel24: TRGB;
  bufferPixel8, resultPixel8: byte;
  aMaskPixel: byte;
  pf: tiepixelformat;

  x1, y1, x2, y2: integer;
  i_rgb, ibuffer_rgb: integer;
  PixelP, PixelBufferP, PixelBufferCopyP: PByteArray;

  rbuffer_H, rbuffer_w:double;
begin
  if not assigned(theiebitmap) then
    exit;

  if not assigned(theBuffer) then
    exit;

  pf := theiebitmap.pixelformat;
  case pf of
    ie8g:
      begin
        ;// OK
      end;
    ie24RGB:
      begin
        ;// OK
      end;
  else
    exit; // >>>> EXIT
  end;

  if pf <> thebuffer.PixelFormat then EXIT; // >>>> EXIT

  rbuffer_H := thebuffer.Height / theiebitmap.Height;
  rbuffer_w := thebuffer.Width / theiebitmap.Width;
  bufferRect.Left := max(0, round(EditedRect.Left * rbuffer_w));
  bufferRect.Top := max(0, round(EditedRect.Top * rbuffer_H));
  bufferRect.Right := min(thebuffer.Width-1, round(EditedRect.Right * rbuffer_w));
  bufferRect.Bottom := min(theBuffer.Height -1, round(EditedRect.Bottom * rbuffer_H));




  buffercopy := TIEBitmap.Create;
  try
    buffercopy.Assign(thebuffer);


   OnApplyChanges(fPreviewGUID, True, buffercopy, nil, bufferRect, false);


    x1 := max(0, EditedRect.Left);
    y1 := max(0, EditedRect.Top);
    x2 := min(theiebitmap.Width - 1, EditedRect.Right);
    y2 := min(theiebitmap.height - 1, EditedRect.Bottom);


    for j := y1 to y2 do
    begin
      PixelP := theiebitmap.ScanLine[j];
      PixelBufferCopyP := buffercopy.ScanLine[trunc(rbuffer_H * j)];
      if buseMask  and (not mask.IsEmpty) and (mask.BitsPerPixel=8) then
         PixelBufferP := theBuffer.ScanLine[trunc(rbuffer_H * j)];
    for i := x1 to x2 do
    begin
      if (bUseMask = false) or mask.IsEmpty or (mask.getpixel(i, j) > 0) then
      begin
        case pf of
          ie8g:
            begin

              resultPixel8 := PixelBufferCopyP[trunc(rbuffer_W * i)];

              if bUseMask and (not mask.IsEmpty) then
              begin

                case mask.BitsPerPixel of
                  8:
                  begin
                    aMaskPixel := mask.getpixel(i, j);
                    bufferPixel8 := PixelBufferP[trunc(rbuffer_W * i)];
                  end
                  else aMaskPixel := 255;
                end;
                if aMaskPixel<>255 then
                  resultPixel8 := (aMaskPixel * resultPixel8 + (255 - aMaskPixel) * bufferPixel8) div 255;

              end;

              PixelP[i] := resultPixel8;
            end;
          ie24RGB:
            begin
              i_rgb := 3 * i;
              ibuffer_rgb := 3 * trunc(rbuffer_W * i);

              resultPixel24.r := PixelBufferCopyP[ibuffer_rgb + 2];
              resultPixel24.g := PixelBufferCopyP[ibuffer_rgb + 1];
              resultPixel24.b := PixelBufferCopyP[ibuffer_rgb];


              if bUseMask and (not mask.IsEmpty) then
              begin

                case mask.BitsPerPixel of
                  8:
                  begin
                    aMaskPixel := mask.getpixel(i, j);
                    bufferPixel24.r := PixelBufferP[ibuffer_rgb + 2];
                    bufferPixel24.g := PixelBufferP[ibuffer_rgb + 1];
                    bufferPixel24.b := PixelBufferP[ibuffer_rgb];
                  end
                  else aMaskPixel := 255;
                end;
                if aMaskPixel<>255 then
                begin
                  resultPixel24.r := (aMaskPixel * resultPixel24.r + (255 - aMaskPixel) * bufferPixel24.r) div 255;
                  resultPixel24.g := (aMaskPixel * resultPixel24.g + (255 - aMaskPixel) * bufferPixel24.g) div 255;
                  resultPixel24.b := (aMaskPixel * resultPixel24.b + (255 - aMaskPixel) * bufferPixel24.b) div 255;
                end;
              end;

              PixelP[i_rgb + 2] := resultPixel24.r;
              PixelP[i_rgb + 1] := resultPixel24.g;
              PixelP[i_rgb] := resultPixel24.b;

            end;
        end;

      end;

    end;
  end;


  finally
    buffercopy.Free;
  end;


// deltaProf := GetTickCount - prof;


end;


//---------------------------Class TIEUtils_IEPreview----------END



//--------------------------Class TIEUtils_IEPreviewEventsHandler----------START


constructor TIEUtils_IEPreviewEventsHandler.Create(theIeView: Timageenview);
begin
   inherited Create;
   fLockCount := 0;
   fPreviewToggleOn := TRUE;
   fSelectionChanging := false;
   flagMouseDown := false;
   fPreviewRegistered := false;

   fPreview := TIEUtils_IEPreview.Create;

   SetPreviewMode(pm_Auto);

   SetAttachedIeView(theIEView);
end;


destructor TIEUtils_IEPreviewEventsHandler.Destroy;
begin
   fPreview.Free;
   inherited;
end;


procedure TIEUtils_IEPreviewEventsHandler.FireUpdateNeeded;
begin
  if not fPreviewRegistered then EXIT;
  if fLockCount>0 then EXIT;

  if assigned(OnBeforePreview) then
     OnBeforePreview(self);

  //--------------------------------------
  fPreview.DoPreview(fPreviewToggleOn);
  //--------------------------------------

  if assigned(OnAfterPreview) then
     OnAfterPreview(self);

  if assigned(fOnUpdateNeeded) then
    fOnUpdateNeeded(self);
end;

procedure TIEUtils_IEPreviewEventsHandler.FireBufferNeeded;
begin
  if not fPreviewRegistered then EXIT;

  fPreview.NewGuid;

  SetPreviewMode(fPreviewMode); //check here whether to switch mode if preview mode is auto
  fPreview.InitFullUpdate(true);


  if assigned(fOnUpdateBufferNeeded) then
    fOnUpdateBufferNeeded(self);
end;



procedure TIEUtils_IEPreviewEventsHandler.RegisterIEView(theIEView: Timageenview; theOnApplyChanges: TIEUtils_IEPreviewEvent);
begin
  UnregisterIEView;

  fLockCount := 0;
  fAttachedIEView := theIEView;
  SetPreviewMode(fPreviewMode);

  fPreview.AttachedIEView := theIEView;
  fPreview.OnApplyChanges := theOnApplyChanges;
  GetEventsfromIEView(fAttachedIEView);
  //--------------------------------
  fPreviewRegistered := true;
  //--------------------------------
  FireBufferNeeded;
  FireUpdateNeeded;   //05/08/2011
end;

procedure TIEUtils_IEPreviewEventsHandler.UnregisterIEView;
begin
  if not fPreviewRegistered then
    EXIT;

  if not assigned(fAttachedIEView) then
  begin
    fPreviewRegistered := false;
    EXIT;
  end;

  fPreview.FinalizeFullUpdate;

  ReleaseEventstoIEView(fAttachedIEView);
  //--------------------------------------
  fPreviewRegistered := false;
  //--------------------------------------
  fPreview.EmptyPreviewBuffer;

  fAttachedIEView.Refresh;
end;

procedure TIEUtils_IEPreviewEventsHandler.LockPreview;
begin
   if not fPreviewRegistered then
    EXIT;

   inc(fLockCount);

   fPreview.FinalizeFullUpdate;

end;


procedure TIEUtils_IEPreviewEventsHandler.UnlockPreview(bResetBuffers: boolean);
begin
  if not fPreviewRegistered then
    EXIT;

 if fLockCount>0 then
   dec(fLockCount);

  if assigned(fAttachedIEView) and (fAttachedIEView.CurrentLayer.Kind <> ielkImage) then
    EXIT;


 if fLockCount=0 then
 begin
  if bResetBuffers then
    FireBufferNeeded
  else
    fPreview.InitFullUpdate(false);
  if assigned(fAttachedIEView) then
    fAttachedIEView.Repaint;
 end;
end;

procedure TIEUtils_IEPreviewEventsHandler.TogglePreview(const bPreviewIsOn: boolean);
begin
  if not fPreviewRegistered then
    EXIT;

  fPreviewToggleOn := bPreviewIsOn;
  FireUpdateNeeded;
end;


procedure TIEUtils_IEPreviewEventsHandler.RefreshPreview;
begin
  if not fPreviewRegistered then
    EXIT;

  FireUpdateNeeded;
end;

procedure TIEUtils_IEPreviewEventsHandler.ApplyPreview;
begin
  if not fPreviewRegistered then
    EXIT;

  if not fPreview.CheckCanPreview then EXIT;


    LockPreview;
    try
      fPreview.OnApplyChanges(GUID_NULL, False, fAttachedIEView.IEBitmap,
                               fAttachedIEView.SelectionMask,
                              rect(0,0, fAttachedIEView.IEBitmap.Width-1, fAttachedIEView.IEBitmap.Height-1),
                               assigned(fAttachedIEView.SelectionMask) and (not fAttachedIEView.SelectionMask.IsEmpty));

      FireBufferNeeded;
    finally
      UnlockPreview(true);
    end;

end;





procedure TIEUtils_IEPreviewEventsHandler.SetAttachedIeView(theIeview: Timageenview);
begin
  fAttachedIEView := theieview;
end;


function TIEUtils_IEPreviewEventsHandler.GetUSeFastPreview: boolean;
begin
  result := fPreview.USeFastPreview;
end;

procedure TIEUtils_IEPreviewEventsHandler.SetUseFastPreview(theValue: boolean);
begin
  fPReview.UseFastPreview := theValue;
end;

procedure TIEUtils_IEPreviewEventsHandler.SetPreviewMode(theValue: TIEUtils_IEPreview_Mode);
begin
  fPreviewMode := thevalue;

  if not Assigned(fAttachedIEView) then EXIT;


  case theValue of
    pm_FullUpdate: fPreview.Preview_Kind := pk_FullUpdate;
    pm_Flat: fPreview.Preview_Kind := pk_Flat;
    pm_Auto:
      begin
        if (fAttachedIEView.LayersCount>1) or
         (fAttachedIEView.IEBitmap.HasAlphaChannel) then
          fPreview.Preview_Kind := pk_FullUpdate
        else
          fPreview.Preview_Kind := pk_Flat;
      end;
  end;

end;

procedure TIEUtils_IEPreviewEventsHandler.GetEventsfromIEView(theIeview: Timageenview);
begin
  if fPreviewRegistered then exit;   //Already Registered therefore there are no events to record
  if not assigned(theIeview) then exit;


  fOldMouseDown := theIeview.OnMouseDown;
  fOldMouseUp := theIeview.OnMouseUp;
  fOLDSelectionChange := theIeview.OnSelectionChange;
  fOLDSelectionChanging := theIeview.OnSelectionChanging;
  fOldLayerNotify := theIeview.OnLayerNotify;
  fOLDDrawCanvas := theIeview.OnDrawCanvas;
  fOLDImageChange := theIeView.OnImageChange;
  fOLDViewChange := theIeView.OnViewChange;

 // fOldDrawBackBuffer := theIeview.OnDrawBackBuffer;

  theIeview.OnMouseDown := GetimageMouseDown;
  theIeview.OnMouseUp := GetimageMouseUp;
  theIeview.OnSelectionChange := GetimageSelectionChange;
  theIeview.OnSelectionChanging := GetimageSelectionChanging;
  theIeview.OnLayerNotify := GetimageLayerNotify;
  theIeview.OnDrawCanvas := GetimageDrawCanvas;
  theIEView.OnImageChange := GetImageChange;
  theIEView.OnViewChange := GetImageViewChange;
end;


procedure TIEUtils_IEPreviewEventsHandler.ReleaseEventstoIEView(theIeview: Timageenview);
begin
  if not assigned(theIeview) then exit;
  if not fPreviewRegistered then exit;

  theIeview.OnMouseDown := fOldMouseDown;
  theIeview.OnMouseUp := fOldMouseUp;

  theIeview.OnSelectionChange := fOLDSelectionChange;
  theIeview.OnSelectionChanging := fOLDSelectionChanging;
  theIeview.OnDrawCanvas := fOLDDrawCanvas;
  theIeview.OnLayerNotify := fOldLayerNotify;
  theIeview.OnImageChange := fOLDImageChange;
  theIEView.OnViewChange := foldViewChange;
end;


procedure TIEUtils_IEPreviewEventsHandler.GetimageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if not assigned(fAttachedIEView) then exit;

  flagMouseDown := true;
  LockPreview;

  if assigned(fOldMouseDown) then
    fOldMouseDown(sender, button, shift, x, y);
end;


procedure TIEUtils_IEPreviewEventsHandler.GetimageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  flagMouseDown := false;

  UnlockPreview(false);

  if assigned(fOldMouseUp) then fOldMouseUP(sender, button, shift, x, y);
end;


procedure TIEUtils_IEPreviewEventsHandler.GetimageSelectionChange(Sender: TObject);
begin
  if fSelectionChanging then
    UnlockPreview(false);

  fSelectionChanging := false;

  if assigned(fOldSelectionchange) then fOldSelectionchange(sender);
end;

procedure TIEUtils_IEPreviewEventsHandler.GetimageSelectionChanging(Sender: TObject);
begin
  if not fSelectionChanging then
    LockPreview;


  fSelectionChanging := true;

  if assigned(fOldSelectionchanging) then fOldSelectionchanging(sender);
end;


procedure TIEUtils_IEPreviewEventsHandler.GetImageViewChange(Sender: TObject; Change:integer);
begin
  fPreview.NewGuid;

  if assigned(fOLDViewChange) then
    fOldViewChange(sender, Change);
end;

procedure TIEUtils_IEPreviewEventsHandler.GetimageLayerNotify(Sender:TObject; layer:integer; event:TIELayerEvent);
var
  I: Integer;
begin
  case event of

    ielSelected:
      begin
         if not CompareGUID(fPreview.fBuffer_LayGUID, fAttachedIEView.CurrentLayer.GUID) then
         begin
          if (fLockCount=0)and(fPreview.Preview_Kind = pk_FullUpdate ) then
          begin
            for I := 0 to fAttachedIEView.LayersCount-1 do
               if CompareGUID(fPreview.fBuffer_LayGUID, fAttachedIEView.Layers[i].Guid) then
               begin
                 fpreview.FinalizeFullUpdate(i);
                 break;
               end;

          end;
          FireBufferNeeded;
          FireUpdateNeeded;

         end;
      end;
  end;

  if assigned(fOldLayerNotify) then fOldLayerNotify(sender,layer,event);
end;





procedure TIEUtils_IEPreviewEventsHandler.GetimageDrawCanvas(Sender: TObject; ACanvas: TCanvas; ARect: TRect);
begin
  
  FireUpdateNeeded;


  if assigned(fOldDrawCanvas) then fOldDrawCanvas(sender, acanvas, arect);
end;



procedure TIEUtils_IEPreviewEventsHandler.GetImageChange(Sender: TObject);
begin

  if assigned(fOldimageChange) then fOldimageChange(sender);
end;



//--------------------------Class TIEUtils_IEPreviewEventsHandler----------END


end.


