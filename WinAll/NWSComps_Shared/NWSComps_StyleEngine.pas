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
unit NWSComps_StyleEngine;
{$R-}
{$Q-}
interface

{$I ..\_inc\NWSComps_Shared.inc}
 // {$UNDEF NWSCOMPS_VCLSTYLES}
uses
  Classes, Forms, Messages, Controls, Windows,
{$IFDEF NWSCOMPS_DELPHI7_UPPER}
  Themes,
{$ENDIF}
  Graphics;

 type
   TNWSCompsStyleElement = (nwsStyleEl_CheckBoxChecked,
                            nwsStyleEl_CheckBoxUnChecked,
                            nwsStyleEl_InfoButton,
                            nwsStyleEl_InfoButtonDown,
                            nwsStyleEl_RotateButtonRight,
                            nwsStyleEl_RotateButtonRightDown,
                            nwsStyleEl_RotateButtonLeft,
                            nwsStyleEl_RotateButtonLeftDown);

{$IFDEF NWSCOMPS_VCLSTYLES}
type
  TNWSCompsStyleHook = class(TStyleHook)
  public
    constructor Create(AControl: TWinControl); override;
    procedure UpdateColors;
  end;
{$ENDIF}

TNWSCompsStyledControl = class(TCustomControl)
   private
      fBorderStyle: TBorderStyle;
    fCursorDrag: TCursor;
    fCursorPointed: TCursor;

   {$IFDEF NWSCOMPS_VCLSTYLES}
    class constructor Create;
    class destructor destroy;
    {$ENDIF}

      procedure SetBorderStyle(Value: TBorderStyle);
      function GetCtl3D: boolean;

      procedure SetCtl3D(value: boolean);

  protected
      procedure UpdateVCLStyle; virtual;
      procedure InitVCLStyle; virtual;

      procedure CreateParams(var Params: TCreateParams); override;
      procedure Paint; override;
   public
      Constructor Create(AOwner: TComponent); override;
      Destructor Destroy; override;

      property CursorPointed:TCursor read fCursorPointed write fCursorPointed;
      property CursorDrag:TCursor read fCursorDrag write fCursorDrag;
   published

      property Align;
      property Anchors;
      property AutoSize;
      property BorderWidth;
      property BorderStyle: TBorderStyle read fBorderStyle write SetBorderStyle;
      property Ctl3d: boolean read GetCtl3d write SetCtl3d;

      property Constraints;
      property DragKind;
      property DragCursor;
      property DragMode;
      property Font;

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
end;

  function NwscompsStyle_GetElementSize(element:TNWSCompsStyleElement;  cv: TCanvas): TSize;
  function NwscompsStyle_GetColor(theColor: TColor): TColor;
  procedure NWScompsStyle_DrawThemeElement(element:TNWSCompsStyleElement; cv: TCanvas; destRect:Trect);

  procedure NWSCompsStyle_DrawChevronUp(cv: TCanvas; destRect: Trect;  chevronW, chevronH: integer;fgColor, fgColorHi: TColor);
  procedure NWSCompsStyle_DrawChevronDown(cv: TCanvas; destRect: Trect;  chevronW, chevronH: integer;fgColor, fgColorHi: TColor);

  procedure NWSCompsStyle_DrawRotateArrowRight(cv: TCanvas; destRect: Trect;   arrowW, arrowH: integer; fgColor, fgColorHi: TColor);
  procedure NWSCompsStyle_DrawRotateArrowLeft(cv: TCanvas; destRect: Trect;  arrowW, arrowH: integer;fgColor, fgColorHi: TColor);
implementation


  {$IFDEF NWSCOMPS_DELPHI7_UPPER}
    function NWSCompsStyleServices: {$IFDEF NWSCOMPS_DXE2_UPPER} TCustomStyleServices; {$ELSE} TThemeServices; {$ENDIF}
    begin
      {$IFDEF NWSCOMPS_DXE2_UPPER}
      Result := StyleServices;
      {$ELSE}
      Result := ThemeServices;
      {$ENDIF}
    end;
  {$ENDIF}

   {$IFDEF NWSCOMPS_DELPHI7_UPPER}
    function NWSCompsStyleServices_Enabled: boolean;
    begin
      {$IFDEF NWSCOMPS_DXE2_UPPER}
      Result := StyleServices.Enabled;
      {$ELSE}
      Result := ThemeServices.ThemesEnabled;
      {$ENDIF}
    end;
  {$ENDIF}

    {$IFDEF NWSCOMPS_DELPHI7_UPPER}
    function NWSCompsStyleServices_IsSystemStyle: boolean;
    begin
      {$IFDEF NWSCOMPS_DXE2_UPPER}
      Result := (not NWSCompsStyleServices_Enabled) or (StyleServices.IsSystemStyle);
      {$ELSE}
      Result := not NWSCompsStyleServices_Enabled;
      {$ENDIF}
    end;
  {$ENDIF}


   function NwscompsStyle_GetColor(theColor: TColor): TColor;
   begin
       result := theColor;

       {$IFDEF NWSCOMPS_DXE2_UPPER}  //only VCLStyle support GetStylecolor and getSystemColor
       if NWSCompsStyleServices_Enabled then
       begin
          result := NWSCompsStyleServices.GetSystemColor(theColor);
       end;
       {$ENDIF}

       if result < 0 then
         Result := GetSysColor(Result and $000000FF);
   end;

   function NwscompsStyle_GetElementSize(element:TNWSCompsStyleElement;  cv: TCanvas): TSize;
   {$IFDEF NWSCOMPS_DXE_UPPER}
   var
   elementDetails: TThemedElementDetails;
   elementSize: TElementSize;
   {$ENDIF}
   begin
        case element of
           nwsStyleEl_CheckBoxChecked, nwsStyleEl_CheckBoxUnChecked:
           begin
             result.cx := GetSystemMetrics(SM_CXMENUCHECK);
             result.cy := GetSystemMetrics(SM_CYMENUCHECK);
           end;
           nwsStyleEl_InfoButton, nwsStyleEl_InfoButtonDown:
           begin
             result.cx := GetSystemMetrics(SM_CXMENUCHECK);
             result.cy := GetSystemMetrics(SM_CYMENUCHECK);
           //  result.cy := result.cy + round(0.2 * result.cy);
           end;
           nwsStyleEl_RotateButtonRight, nwsStyleEl_RotateButtonRightDown, nwsStyleEl_RotateButtonLeft, nwsStyleEl_RotateButtonLeftDown:
           begin
             result.cx := GetSystemMetrics(SM_CXMENUCHECK) + 6;
             result.cy := GetSystemMetrics(SM_CYMENUCHECK) + 6;
           //  result.cy := result.cy + round(0.2 * result.cy);
           end;
           else
           begin
             result.cx := GetSystemMetrics(SM_CXMENUCHECK);
             result.cy := GetSystemMetrics(SM_CYMENUCHECK);
           end;
        end;



       {$IFDEF NWSCOMPS_DXE_UPPER}
         if NWSCompsStyleServices_IsSystemStyle then EXIT; //we do not check the dimensions from VCL style because it can give wrong result

         if NWSCompsStyleServices_Enabled then
         begin
           case element of
           nwsStyleEl_CheckBoxChecked: elementDetails := NWSCompsStyleServices.GetElementDetails(tbCheckBoxCheckedNormal);
           nwsStyleEl_CheckBoxUnChecked: elementDetails := NWSCompsStyleServices.GetElementDetails(tbCheckBoxUnCheckedNormal);
           else
             EXIT; //>>>> EXIT
           end;
           NWSCompsStyleServices.GetElementSize(cv.Handle, elementDetails, elementSize, result);
         end;
       {$ENDIF}

   end;


// NWScompsStyle_DrawThemeElement(nwsStyleEl_CheckBoxChecked, nil, rect(0,0,0,0));
procedure NWScompsStyle_DrawThemeElement(element:TNWSCompsStyleElement; cv: TCanvas; destRect:Trect  );
procedure DrawExtras;
begin
  case element of
     nwsStyleEl_CheckBoxChecked: ;
     nwsStyleEl_CheckBoxUnChecked: ;
     nwsStyleEl_InfoButton, nwsStyleEl_InfoButtonDown:
     begin
        NWSCompsStyle_DrawChevronDown(cv, destRect, 6, 3, NwscompsStyle_GetColor(clBtnText), NwscompsStyle_GetColor(clBtnHighlight));
     end;
     nwsStyleEl_RotateButtonRight:
     begin
       NWSCompsStyle_DrawRotateArrowRight(cv, destRect, 6, 8, NwscompsStyle_GetColor(clBtnText), NwscompsStyle_GetColor(clBtnShadow));
     end;
     nwsStyleEl_RotateButtonRightDown:
     begin
       NWSCompsStyle_DrawRotateArrowRight(cv, destRect, 6, 8, NwscompsStyle_GetColor(clBtnHighlight), NwscompsStyle_GetColor(clBtnShadow));
     end;
     nwsStyleEl_RotateButtonLeft:
     begin
       NWSCompsStyle_DrawRotateArrowLeft(cv, destRect, 6, 8, NwscompsStyle_GetColor(clBtnText), NwscompsStyle_GetColor(clBtnShadow));
     end;
     nwsStyleEl_RotateButtonLeftDown:
     begin
       NWSCompsStyle_DrawRotateArrowLeft(cv, destRect, 6, 8, NwscompsStyle_GetColor(clBtnHighlight), NwscompsStyle_GetColor(clBtnShadow));
     end;
   end;
end;

   {$IFDEF NWSCOMPS_DELPHI7_UPPER}
   var
   elementDetails: TThemedElementDetails;
   {$ENDIF}
begin
    (*   *)
  {$IFDEF NWSCOMPS_DELPHI7_UPPER}
       if NWSCompsStyleServices_Enabled then
       begin
         case element of
           nwsStyleEl_CheckBoxChecked: elementDetails := NWSCompsStyleServices.GetElementDetails(tbCheckBoxCheckedNormal);
           nwsStyleEl_CheckBoxUnChecked: elementDetails := NWSCompsStyleServices.GetElementDetails(tbCheckBoxUnCheckedNormal);
           nwsStyleEl_InfoButton: elementDetails := NWSCompsStyleServices.GetElementDetails(tbPushButtonNormal);
           nwsStyleEl_InfoButtonDown: elementDetails := NWSCompsStyleServices.GetElementDetails(tbPushButtonPressed);
           nwsStyleEl_RotateButtonRight, nwsStyleEl_RotateButtonLeft: elementDetails := NWSCompsStyleServices.GetElementDetails(tbPushButtonNormal);
           nwsStyleEl_RotateButtonRightDown, nwsStyleEl_RotateButtonLeftDown: elementDetails := NWSCompsStyleServices.GetElementDetails(tbPushButtonPressed);
           else
            EXIT;//>>>>EXIT
         end;
         NWSCompsStyleServices.DrawElement(cv.Handle,elementDetails, destRect);
         DrawExtras;
         EXIT; //>>>>EXIT
       end;
  {$ENDIF}
      case element of
       nwsStyleEl_CheckBoxChecked: DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_CHECKED);
       nwsStyleEl_CheckBoxUnChecked: DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_BUTTONCHECK);
       nwsStyleEl_InfoButton:  DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_BUTTONPUSH);
       nwsStyleEl_InfoButtonDown:  DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_PUSHED);
       nwsStyleEl_RotateButtonRight, nwsStyleEl_RotateButtonLeft:  DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_BUTTONPUSH);
       nwsStyleEl_RotateButtonRightDown, nwsStyleEl_RotateButtonLeftDown:  DrawFrameControl(cv.Handle, destRect, DFC_BUTTON, DFCS_PUSHED);
     end;
     DrawExtras;
end;

  procedure NWSCompsStyle_DrawChevronUp(cv: TCanvas; destRect: Trect; chevronW, chevronH: integer; fgColor, fgColorHi: TColor);
  var
  poly: array of TPoint;
  chevronLeft, chevronTop: integer;
  shiftx, shifty: integer;
  I: Integer;
  begin
     chevronLeft := destrect.left + (destrect.right - destrect.left + 1 - chevronW) div 2;
     chevronTop := destrect.Top + (destrect.bottom - destrect.top + 1 - chevronH) div 2;

     cv.Pen.Width := 0;
     cv.Brush.Style := bssolid;
     setlength(poly, 3);
     i := 0;
     while i < 2 do
     begin
       if i = 0 then
       begin
         cv.Brush.Color := fgColorHi;
         cv.Pen.color := fgColorHi;
         shiftx := 1;
         shifty := 1;
       end
       else
       begin
         cv.Brush.Color := fgColor;
         cv.Pen.color := fgColor;
         shiftx := 0;
         shifty := 0;
       end;
       poly[0] := point(chevronLeft + shiftx, chevronTop + chevronH + shifty);
       poly[1] := point(chevronLeft + shiftx + chevronW, chevronTop + chevronH + shifty);
       poly[2] := point(chevronLeft + shiftx +  chevronW div 2, chevronTop + shifty);

       cv.Polygon(poly);
       inc(i);
     end;
  end;

  procedure NWSCompsStyle_DrawChevronDown(cv: TCanvas; destRect: Trect; chevronW, chevronH: integer; fgColor, fgColorHi: TColor);
  var
  poly: array of TPoint;
  chevronLeft, chevronTop: integer;
  shiftx, shifty: integer;
  I: Integer;
  begin


     chevronLeft := destrect.left + (destrect.right - destrect.left + 1 - chevronW) div 2;
     chevronTop := destrect.Top + (destrect.bottom - destrect.top + 1 - chevronH) div 2;

     cv.Pen.Width := 0;
     cv.Brush.Style := bssolid;

     setlength(poly, 3);

     i := 0;
     while i < 2 do
     begin
       if i = 0 then
       begin
         cv.Brush.Color := fgColorHi;
         cv.Pen.color := fgColorHi;
         shiftx := 1;
         shifty := 1;
       end
       else
       begin
         cv.Brush.Color := fgColor;
         cv.Pen.color := fgColor;
         shiftx := 0;
         shifty := 0;
       end;
       poly[0] := point(chevronLeft + shiftx, chevronTop + shifty);
       poly[1] := point(chevronLeft + shiftx + chevronW, chevronTop + shifty);
       poly[2] := point(chevronLeft + shiftx +  chevronW div 2, chevronTop + shifty + chevronH);
       cv.Polygon(poly);
       inc(i);
     end;


  end;

  procedure NWSCompsStyle_DrawRotateArrowRight(cv: TCanvas; destRect: Trect;  arrowW, arrowH: integer;fgColor, fgColorHi: TColor);
  var
  poly: array of TPoint;
  arrowLeft, arrowBottom, arrowThick, arrowCapW, arrowCapH: integer;
  shiftx, shifty: integer;
  I: Integer;
  begin
     arrowCapW := ((arrowW div 3 + 3) div 2) * 2 ;   //this ensures an even number
     arrowCapH := ((arrowW div 2 + 6) div 2) * 2; //this ensures an even number

     arrowThick := 1 + (arrowW + arrowH) div 40;
     arrowLeft := destrect.left + (destrect.right - destrect.left + 1 - arrowW - arrowCapW) div 2;
     arrowBottom := destrect.bottom - (destrect.bottom - destrect.top + 1 - arrowH - arrowCapH div 2) div 2;

     cv.Pen.Width := 0;
     cv.Brush.Style := bssolid;
     cv.Pen.Style := psClear;

     i := 0;
     while i < 2 do
     begin
       if i = 0 then
       begin
         cv.Brush.Color := fgColorHi;
         cv.Pen.color := fgColorHi;
         shiftx := -1;
         shifty := 1;
       end
       else
       begin
         cv.Brush.Color := fgColor;
         cv.Pen.color := fgColor;
         shiftx := 0;
         shifty := 0;
       end;

       setlength(poly, 10);
       poly[0] := point(arrowLeft - arrowThick + shiftx , arrowBottom + shifty);
       poly[1] := point(arrowLeft - arrowThick + shiftx , arrowBottom - arrowH - arrowThick + shifty);
       poly[2] := point(arrowLeft + arrowW + shiftx , arrowBottom - arrowH - arrowThick + shifty);
       poly[3] := point(arrowLeft + arrowW + shiftx, arrowBottom - arrowH - arrowCapH div 2 + shifty);
       poly[4] := point(arrowLeft + arrowW + arrowCapW + shiftx, arrowBottom - arrowH + shifty);
       poly[5] := point(arrowLeft + arrowW + shiftx, arrowBottom - arrowH + arrowCapH div 2 + shifty);
       poly[6] := point(arrowLeft + arrowW + shiftx, arrowBottom - arrowH + arrowThick + shifty);
       poly[7] := point(arrowLeft + arrowThick + shiftx, arrowBottom - arrowH + arrowThick + shifty);
       poly[8] := point(arrowLeft + arrowThick + shiftx, arrowBottom + shifty);
       poly[9] := point(arrowLeft - arrowThick + shiftx , arrowBottom + shifty);


       cv.Polygon(poly);
       inc(i);
     end;

  end;


  procedure NWSCompsStyle_DrawRotateArrowLeft(cv: TCanvas; destRect: Trect;  arrowW, arrowH: integer;fgColor, fgColorHi: TColor);
  var
  poly: array of TPoint;
  arrowRight, arrowBottom, arrowThick, arrowCapW, arrowCapH: integer;
  shiftx, shifty: integer;
  I: Integer;
  begin
     arrowCapW := ((arrowW div 3 + 3) div 2) * 2 ; //this ensures an even number
     arrowCapH := ((arrowW div 2 + 6) div 2) * 2; //this ensures an even number

     arrowThick := 1 + (arrowW + arrowH) div 40;
     arrowRight := destrect.right - (destrect.right - destrect.left + 1 - arrowW - arrowCapW) div 2;
     arrowBottom := destrect.bottom - (destrect.bottom - destrect.top + 1 - arrowH - arrowCapH div 2) div 2;

     cv.Pen.Width := 0;
     cv.Brush.Style := bssolid;
     cv.Pen.Style := psClear;

     i := 0;
     while i < 2 do
     begin
       if i = 0 then
       begin
         cv.Brush.Color := fgColorHi;
         cv.Pen.color := fgColorHi;
         shiftx := 1;
         shifty := 1;
       end
       else
       begin
         cv.Brush.Color := fgColor;
         cv.Pen.color := fgColor;
         shiftx := 0;
         shifty := 0;
       end;

       setlength(poly, 10);
       poly[0] := point(arrowRight + arrowThick + shiftx , arrowBottom + shifty);
       poly[1] := point(arrowRight + arrowThick + shiftx , arrowBottom - arrowH - arrowThick + shifty);
       poly[2] := point(arrowRight - arrowW + shiftx , arrowBottom - arrowH - arrowThick + shifty);
       poly[3] := point(arrowRight - arrowW + shiftx, arrowBottom - arrowH - arrowCapH div 2 + shifty);
       poly[4] := point(arrowRight - arrowW - arrowCapW + shiftx, arrowBottom - arrowH + shifty);
       poly[5] := point(arrowRight - arrowW + shiftx, arrowBottom - arrowH + arrowCapH div 2 + shifty);
       poly[6] := point(arrowRight - arrowW + shiftx, arrowBottom - arrowH + arrowThick + shifty);
       poly[7] := point(arrowRight - arrowThick + shiftx, arrowBottom - arrowH + arrowThick + shifty);
       poly[8] := point(arrowRight - arrowThick + shiftx, arrowBottom + shifty);
       poly[9] := point(arrowRight + arrowThick + shiftx , arrowBottom + shifty);


       cv.Polygon(poly);
       inc(i);
     end;

  end;

  {$IFDEF NWSCOMPS_VCLSTYLES}
  { TNWSCompsStyleHook }
  constructor TNWSCompsStyleHook.Create(AControl: TWinControl);
  begin
    inherited;
    OverridePaint := false;
    OverridePaintNC := FALSE;
    OverrideEraseBkgnd := FALSE;

    UpdateColors;
  end;

  procedure TNWSCompsStyleHook.UpdateColors;
  begin
    TNWSCompsStyledControl(Control).UpdateVCLStyle;
    
  end;
  {$ENDIF}




  { TNWSCompsStyledControl }
  procedure TNWSCompsStyledControl.SetBorderStyle(Value: TBorderStyle);
  begin
    if fBorderStyle <> Value then
    begin
      fBorderStyle := Value;
      RecreateWnd;
    end;
  end;

  function TNWSCompsStyledControl.GetCtl3D: boolean;
  begin
    result := inherited Ctl3D;
  end;

  procedure TNWSCompsStyledControl.SetCtl3D(value: boolean);
  begin
    {$IFDEF NWSCOMPS_VCLSTYLES}
    ParentCtl3D := False;
    value := False;
    {$ENDIF}

    if value <> (inherited Ctl3D) then
    begin
      inherited Ctl3D := value;
      RecreateWnd;
    end;
  end;

   procedure TNWSCompsStyledControl.UpdateVCLStyle;
   begin
     //reserved for descendant classes
   end;

  procedure TNWSCompsStyledControl.InitVCLStyle;
  begin
    {$IFDEF NWSCOMPS_VCLSTYLES}
       ParentCtl3D := False;
       Ctl3D := False;
    {$ELSE}
        Ctl3D := true;
    {$ENDIF}
    fBorderStyle := bsSingle;

       ControlStyle := ControlStyle + [csOpaque, csAcceptsControls, csReplicatable, csNeedsBorderPaint];

      if not NewStyleControls then
        ControlStyle := ControlStyle + [csFramed];

  end;



  procedure TNWSCompsStyledControl.CreateParams(var Params: TCreateParams);
  begin
   inherited CreateParams(Params);
    with Params do
    begin
      if fBorderStyle = bsSingle then
         Style := Style or WS_BORDER;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
  end;

  procedure TNWSCompsStyledControl.Paint;
  begin
    inherited;

  end;

  {$IFDEF NWSCOMPS_VCLSTYLES}
  class constructor TNWSCompsStyledControl.Create;
  begin
     TCustomStyleEngine.RegisterStyleHook(TNWSCompsStyledControl, TNWSCompsStyleHook);
  end;
  {$ENDIF}

    {$IFDEF NWSCOMPS_VCLSTYLES}
  class Destructor TNWSCompsStyledControl.Destroy;
  begin
    if DebugHook <> 0 then EXIT; //if debugging do not unregister at all

       //this is needed in order to install / uninstall the package (otherwise Delphi complains that class is already registered
       //but it can cause an abstract error that's why we avoid coming here if in debug mode
      try  //do not remove try..except this is only way to avoid problems
        TCustomStyleEngine.UnRegisterStyleHook(TNWSCompsStyledControl, TNWSCompsStyleHook);
      except
       ;
      end;
  end;
  {$ENDIF}

  constructor TNWSCompsStyledControl.Create(AOwner: TComponent);
  begin
    inherited Create(aOwner);

    width := 100;
    height := 100;
    fCursorPointed := crHandPoint;
    fCursorDrag := crMultiDrag;
    InitVCLStyle;
  end;


  destructor TNWSCompsStyledControl.Destroy;
  begin

    inherited;
  end;


end.
