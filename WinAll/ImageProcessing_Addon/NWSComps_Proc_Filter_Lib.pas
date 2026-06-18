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
unit NWSComps_Proc_Filter_Lib;
{$R-}
{$Q-}
interface

uses
  Windows, SysUtils, Classes, forms, Graphics, math, messages,
  NWSComps_Proc_Filter_Types, NWSComps_Proc_Filter_Lib_Const;

type
  // all custom filters should inherit from this class
  TIEProc_EX_Filter_Custom = class(TIEProc_EX_Filter_BaseCustom)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_SmartFlash = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_ReduceHighlights = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_FillBackLight = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_SmartContrast = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_RGBBalance = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_AutoColor = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_ColorFilter = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_BilateralFilter = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_Smooth = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_LightFx_Ellipse = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_LightFx_Beam = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_LightFx_DoubleBeam = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_UnsharpMask = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Blur = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_HSLVar = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_HSVVar = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Negative = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_IntensityRGBAll = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Intensity = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Contrast = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Contrast2 = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Contrast3 = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_GammaCorrect = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AutoSharp = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Colorize = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AdjustBrightnessContrastSaturation = class
    (TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AdjustTint = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AdjustSaturation = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AdjustTemperature = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AdjustLumSatHistogram = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_WhiteBalance_coef = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_WhiteBalance_Grayworld = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_WhiteBalance_WhiteAt = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_WhiteBalance_AutoWhite = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AutoImageEnhance1 = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AutoImageEnhance2 = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_AutoImageEnhance3 = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Median_Sharpen = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Median = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_Sharpen = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

  TIEProc_EX_Filter_IE_FindEdges = class(TIEProc_EX_Filter)
  public
    Constructor Create; override;
  end;

implementation

Constructor TIEProc_EX_Filter_SmartFlash.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_SMARTFLASH;
    UserCaption := name;
    ID := IEPROC_EX_SMARTFLASH_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_SMARTFLASH_AMOUNT,
      IEPROC_EX_SMARTFLASH_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_SMARTFLASH_AMOUNT_DEFAULT,
      IEPROC_EX_SMARTFLASH_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_SMARTFLASH_AMOUNT_MIN,
        IEPROC_EX_SMARTFLASH_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_SMARTFLASH_AMOUNT_MAX,
        IEPROC_EX_SMARTFLASH_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_SMARTFLASH_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_SMARTFLASH_RADIUS,
      IEPROC_EX_SMARTFLASH_RADIUS_VTYPE);
    aPAram.SetValue(IEPROC_EX_SMARTFLASH_RADIUS_DEFAULT,
      IEPROC_EX_SMARTFLASH_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_SMARTFLASH_RADIUS_MIN,
        IEPROC_EX_SMARTFLASH_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_SMARTFLASH_RADIUS_MAX,
        IEPROC_EX_SMARTFLASH_RADIUS_VTYPE);
    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------
    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

Constructor TIEProc_EX_Filter_ReduceHighlights.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_REDUCEHIGHLIGHTS;
    UserCaption := name;
    ID := IEPROC_EX_REDUCEHIGHLIGHTS_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT,
      IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_DEFAULT,
      IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_MIN,
        IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_MAX,
        IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_REDUCEHIGHLIGHTS_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS,
      IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_VTYPE);

    aPAram.SetValue(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_DEFAULT,
      IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_MIN,
        IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_MAX,
        IEPROC_EX_REDUCEHIGHLIGHTS_RADIUS_VTYPE);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

{ TIEProc_EX_Filter_FillBackLight }

constructor TIEProc_EX_Filter_FillBackLight.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_FILLBACKLIGHT;
    UserCaption := name;
    ID := IEPROC_EX_FILLBACKLIGHT_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT,
      IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_DEFAULT,
      IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_MIN,
        IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_MAX,
        IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_FILLBACKLIGHT_FILLLIGHTAMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT,
      IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_DEFAULT,
      IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_MIN,
        IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_MAX,
        IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_FILLBACKLIGHT_BACKLIGHTAMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_FILLBACKLIGHT_RADIUS,
      IEPROC_EX_FILLBACKLIGHT_RADIUS_VTYPE);

    aPAram.SetValue(IEPROC_EX_FILLBACKLIGHT_RADIUS_DEFAULT,
      IEPROC_EX_FILLBACKLIGHT_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_FILLBACKLIGHT_RADIUS_MIN,
        IEPROC_EX_FILLBACKLIGHT_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_FILLBACKLIGHT_RADIUS_MAX,
        IEPROC_EX_FILLBACKLIGHT_RADIUS_VTYPE);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 2);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

Constructor TIEProc_EX_Filter_SmartContrast.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_SMARTCONTRAST;
    UserCaption := name;
    ID := IEPROC_EX_SMARTCONTRAST_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_SMARTCONTRAST_AMOUNT,
      IEPROC_EX_SMARTCONTRAST_AMOUNT_VTYPE);
    aPAram.SetValue(IEPROC_EX_SMARTCONTRAST_AMOUNT_DEFAULT,
      IEPROC_EX_SMARTCONTRAST_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_SMARTCONTRAST_AMOUNT_MIN,
        IEPROC_EX_SMARTCONTRAST_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_SMARTCONTRAST_AMOUNT_MAX,
        IEPROC_EX_SMARTCONTRAST_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_SMARTCONTRAST_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_SMARTCONTRAST_RADIUS,
      IEPROC_EX_SMARTCONTRAST_RADIUS_VTYPE);
    aPAram.SetValue(IEPROC_EX_SMARTCONTRAST_RADIUS_DEFAULT,
      IEPROC_EX_SMARTCONTRAST_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_SMARTCONTRAST_RADIUS_MIN,
        IEPROC_EX_SMARTCONTRAST_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_SMARTCONTRAST_RADIUS_MAX,
        IEPROC_EX_SMARTCONTRAST_RADIUS_VTYPE);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;


{ TIEProc_EX_Filter_RGBBalance }

constructor TIEProc_EX_Filter_RGBBalance.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_RGBBALANCE;
    UserCaption := name;
    ID := IEPROC_EX_RGBBALANCE_ID;


     aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_UNIFORM,
      IEPROC_EX_RGBBALANCE_UNIFORM_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_UNIFORM_DEFAULT,
      IEPROC_EX_RGBBALANCE_UNIFORM_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_UNIFORM_MIN,
        IEPROC_EX_RGBBALANCE_UNIFORM_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_UNIFORM_MAX,
        IEPROC_EX_RGBBALANCE_UNIFORM_VTYPE);


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_RED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_GREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_SH_BLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_RED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_GREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_MID_BLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


   aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_RED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_GREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_HI_BLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_RED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_GREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_DEFAULT,
      IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_MIN,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_MAX,
        IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_RGBBALANCE_AMOUNT_ALL_BLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------


    // -------------------------------
    Assert(listDefNoChg.count = 12);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;

end;


{ TIEProc_EX_Filter_AutoColor }

constructor TIEProc_EX_Filter_AutoColor.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
    name := IEPROC_EX_AUTOCOLOR;
    UserCaption := name;
    ID := IEPROC_EX_AUTOCOLOR_ID;

     aPAram := self.Params.AddParam(IEPROC_EX_AUTOCOLOR_STRENGTH,
      IEPROC_EX_AUTOCOLOR_STRENGTH_VTYPE);

    aPAram.SetValue(IEPROC_EX_AUTOCOLOR_STRENGTH_DEFAULT,
      IEPROC_EX_AUTOCOLOR_STRENGTH_VTYPE);

      aPAram.SetMin(IEPROC_EX_AUTOCOLOR_STRENGTH_MIN,
        IEPROC_EX_AUTOCOLOR_STRENGTH_VTYPE);

      aPAram.SetMax(IEPROC_EX_AUTOCOLOR_STRENGTH_MAX,
        IEPROC_EX_AUTOCOLOR_STRENGTH_VTYPE);
end;


{ TIEProc_EX_Filter_ColorFilter }

constructor TIEProc_EX_Filter_ColorFilter.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try

    name := IEPROC_EX_COLORFILTER;
    UserCaption := name;
    ID := IEPROC_EX_COLORFILTER_ID;

     aPAram := self.Params.AddParam(IEPROC_EX_COLORFILTER_AMOUNT,
      IEPROC_EX_COLORFILTER_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_COLORFILTER_AMOUNT_DEFAULT,
      IEPROC_EX_COLORFILTER_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_COLORFILTER_AMOUNT_MIN,
        IEPROC_EX_COLORFILTER_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_COLORFILTER_AMOUNT_MAX,
        IEPROC_EX_COLORFILTER_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_COLORFILTER_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_COLORFILTER_COLOR,
      IEPROC_EX_COLORFILTER_COLOR_VTYPE);

    aPAram.SetValue(IEPROC_EX_COLORFILTER_COLOR_DEFAULT,
      IEPROC_EX_COLORFILTER_COLOR_VTYPE);

      aPAram.SetMin(IEPROC_EX_COLORFILTER_COLOR_MIN,
        IEPROC_EX_COLORFILTER_COLOR_VTYPE);

      aPAram.SetMax(IEPROC_EX_COLORFILTER_COLOR_MAX,
        IEPROC_EX_COLORFILTER_COLOR_VTYPE);
    //--------------------------------------
    aPAram.UIRepresentation := UIColor;
    //--------------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_COLORFILTER_BLENDMODE,
      IEPROC_EX_COLORFILTER_BLENDMODE_VTYPE);

    aPAram.SetValue(IEPROC_EX_COLORFILTER_BLENDMODE_DEFAULT,
      IEPROC_EX_COLORFILTER_BLENDMODE_VTYPE);

      aPAram.SetMin(IEPROC_EX_COLORFILTER_BLENDMODE_MIN,
        IEPROC_EX_COLORFILTER_BLENDMODE_VTYPE);

      aPAram.SetMax(IEPROC_EX_COLORFILTER_BLENDMODE_MAX,
        IEPROC_EX_COLORFILTER_BLENDMODE_VTYPE);


    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
     listDefNoChg.free;
  end;

end;

{ TIEProc_EX_Filter_BilateralFilter }

constructor TIEProc_EX_Filter_BilateralFilter.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;

    name := IEPROC_EX_BILATERALFILTER;
    UserCaption := name;
    ID := IEPROC_EX_BILATERALFILTER_ID;

     aPAram := self.Params.AddParam(IEPROC_EX_BILATERALFILTER_SIGMA,
      IEPROC_EX_BILATERALFILTER_SIGMA_VTYPE);

    aPAram.SetValue(IEPROC_EX_BILATERALFILTER_SIGMA_DEFAULT,
      IEPROC_EX_BILATERALFILTER_SIGMA_VTYPE);

      aPAram.SetMin(IEPROC_EX_BILATERALFILTER_SIGMA_MIN,
        IEPROC_EX_BILATERALFILTER_SIGMA_VTYPE);

      aPAram.SetMax(IEPROC_EX_BILATERALFILTER_SIGMA_MAX,
        IEPROC_EX_BILATERALFILTER_SIGMA_VTYPE);


     aPAram := self.Params.AddParam(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE,
      IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_VTYPE);

    aPAram.SetValue(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_DEFAULT,
      IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_VTYPE);

      aPAram.SetMin(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_MIN,
        IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_VTYPE);

      aPAram.SetMax(IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_MAX,
        IEPROC_EX_BILATERALFILTER_SIGMA_DISTANCE_VTYPE);


    aPAram := self.Params.AddParam(IEPROC_EX_BILATERALFILTER_RADIUS,
      IEPROC_EX_BILATERALFILTER_RADIUS_VTYPE);

    aPAram.SetValue(IEPROC_EX_BILATERALFILTER_RADIUS_DEFAULT,
      IEPROC_EX_BILATERALFILTER_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_BILATERALFILTER_RADIUS_MIN,
        IEPROC_EX_BILATERALFILTER_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_BILATERALFILTER_RADIUS_MAX,
        IEPROC_EX_BILATERALFILTER_RADIUS_VTYPE);

      //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

end;

{ TIEProc_EX_Filter_SmoothFilter }

constructor TIEProc_EX_Filter_Smooth.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;

    name := IEPROC_EX_SMOOTHFILTER;
    UserCaption := name;
    ID := IEPROC_EX_SMOOTHFILTER_ID;

     aPAram := self.Params.AddParam(IEPROC_EX_SMOOTHFILTER_AMOUNT,
      IEPROC_EX_SMOOTHFILTER_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_SMOOTHFILTER_AMOUNT_DEFAULT,
      IEPROC_EX_SMOOTHFILTER_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_SMOOTHFILTER_AMOUNT_MIN,
        IEPROC_EX_SMOOTHFILTER_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_SMOOTHFILTER_AMOUNT_MAX,
        IEPROC_EX_SMOOTHFILTER_AMOUNT_VTYPE);

      //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

end;


{ TIEProc_EX_LIGHTFX_ELLIPSE }

constructor TIEProc_EX_LightFX_Ellipse.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_LIGHTFX_ELLIPSE;
  UserCaption := name;
  ID := IEPROC_EX_LIGHTFX_ELLIPSE_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_COLOR,
    IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_VTYPE);

  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_COLOR_VTYPE);
    //----------------------------------------------
    aPAram.UIRepresentation := UIColor;
    //----------------------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT,
    IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_LIGHTAMT_VTYPE);

   aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR,
    IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMINOR_VTYPE);
  //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR,
    IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_ELLIPSEMAJOR_VTYPE);
  //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE,
    IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_ANGLE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX,
    IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_CENTERX_VTYPE);

    //----------------------------------
    aParam.IsCoordinateX := true;
    //----------------------------------

   aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY,
    IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_DEFAULT,
    IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_MIN,
      IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_MAX,
      IEPROC_EX_LIGHTFX_ELLIPSE_CENTERY_VTYPE);
  //----------------------------------
    aParam.IsCoordinateY := true;
    //----------------------------------
end;

{ TIEProc_EX_LightFx_Beam }

constructor TIEProc_EX_LightFx_Beam.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_LIGHTFX_BEAM;
  UserCaption := name;
  ID := IEPROC_EX_LIGHTFX_BEAM_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_COLOR,
    IEPROC_EX_LIGHTFX_BEAM_COLOR_VTYPE);

  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_COLOR_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_COLOR_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_COLOR_MIN,
      IEPROC_EX_LIGHTFX_BEAM_COLOR_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_COLOR_MAX,
      IEPROC_EX_LIGHTFX_BEAM_COLOR_VTYPE);
    //----------------------------------------------
    aPAram.UIRepresentation := UIColor;
    //----------------------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT,
    IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_MIN,
      IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_MAX,
      IEPROC_EX_LIGHTFX_BEAM_LIGHTAMT_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE,
    IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_MIN,
      IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_MAX,
      IEPROC_EX_LIGHTFX_BEAM_BEAMSIZE_VTYPE);
  //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------


  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_ANGLE,
    IEPROC_EX_LIGHTFX_BEAM_ANGLE_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_ANGLE_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_ANGLE_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_ANGLE_MIN,
      IEPROC_EX_LIGHTFX_BEAM_ANGLE_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_ANGLE_MAX,
      IEPROC_EX_LIGHTFX_BEAM_ANGLE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_CENTERX,
    IEPROC_EX_LIGHTFX_BEAM_CENTERX_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_CENTERX_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_CENTERX_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_CENTERX_MIN,
      IEPROC_EX_LIGHTFX_BEAM_CENTERX_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_CENTERX_MAX,
      IEPROC_EX_LIGHTFX_BEAM_CENTERX_VTYPE);
    //----------------------------------
    aParam.IsCoordinateX := true;
    //----------------------------------

   aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_BEAM_CENTERY,
    IEPROC_EX_LIGHTFX_BEAM_CENTERY_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_BEAM_CENTERY_DEFAULT,
    IEPROC_EX_LIGHTFX_BEAM_CENTERY_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_BEAM_CENTERY_MIN,
      IEPROC_EX_LIGHTFX_BEAM_CENTERY_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_BEAM_CENTERY_MAX,
      IEPROC_EX_LIGHTFX_BEAM_CENTERY_VTYPE);
   //----------------------------------
    aParam.IsCoordinateY := true;
    //----------------------------------
end;

{ TIEProc_EX_LightFx_DoubleBeam }

constructor TIEProc_EX_LightFx_DoubleBeam.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_LIGHTFX_DOUBLEBEAM;
  UserCaption := name;
  ID := IEPROC_EX_LIGHTFX_DOUBLEBEAM_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_VTYPE);

  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_COLOR_VTYPE);
    //----------------------------------------------
    aPAram.UIRepresentation := UIColor;
    //----------------------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_LIGHTAMT_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_BEAMSIZE_VTYPE);
   //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_OPENING_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_ANGLE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERX_VTYPE);
    //----------------------------------
    aParam.IsCoordinateX := true;
    //----------------------------------

   aPAram := self.Params.AddParam(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_VTYPE);
  aPAram.SetValue(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_DEFAULT,
    IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_VTYPE);
    aPAram.SetMin(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_MIN,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_VTYPE);
    aPAram.SetMax(IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_MAX,
      IEPROC_EX_LIGHTFX_DOUBLEBEAM_CENTERY_VTYPE);
    //----------------------------------
    aParam.IsCoordinateY := true;
    //----------------------------------

end;

constructor TIEProc_EX_Filter_IE_UnsharpMask.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_UNSHARPMASK;
    UserCaption := name;
    ID := IEPROC_EX_IE_UNSHARPMASK_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_UNSHARPMASK_AMOUNT,
      IEPROC_EX_IE_UNSHARPMASK_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_UNSHARPMASK_AMOUNT_DEFAULT,
      IEPROC_EX_IE_UNSHARPMASK_AMOUNT_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_UNSHARPMASK_AMOUNT_MIN,
        IEPROC_EX_IE_UNSHARPMASK_AMOUNT_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_UNSHARPMASK_AMOUNT_MAX,
        IEPROC_EX_IE_UNSHARPMASK_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_UNSHARPMASK_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_UNSHARPMASK_RADIUS,
      IEPROC_EX_IE_UNSHARPMASK_RADIUS_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_UNSHARPMASK_RADIUS_DEFAULT,
      IEPROC_EX_IE_UNSHARPMASK_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_UNSHARPMASK_RADIUS_MIN,
        IEPROC_EX_IE_UNSHARPMASK_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_UNSHARPMASK_RADIUS_MAX,
        IEPROC_EX_IE_UNSHARPMASK_RADIUS_VTYPE);
    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------


    aPAram := self.Params.AddParam(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD,
      IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_DEFAULT,
      IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_MIN,
        IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_MAX,
        IEPROC_EX_IE_UNSHARPMASK_THRESHOLD_VTYPE);

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;

end;

constructor TIEProc_EX_Filter_IE_Blur.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_BLUR;
    UserCaption := name;
    ID := IEPROC_EX_IE_BLUR_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_BLUR_RADIUS,
      IEPROC_EX_IE_BLUR_RADIUS_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_BLUR_RADIUS_DEFAULT,
      IEPROC_EX_IE_BLUR_RADIUS_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_BLUR_RADIUS_MIN,
        IEPROC_EX_IE_BLUR_RADIUS_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_BLUR_RADIUS_MAX,
        IEPROC_EX_IE_BLUR_RADIUS_VTYPE);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_BLUR_RADIUS_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_Negative.Create;
begin
  inherited;
  name := IEPROC_EX_IE_NEGATIVE;
  UserCaption := name;
  ID := IEPROC_EX_IE_NEGATIVE_ID;
end;

constructor TIEProc_EX_Filter_IE_HSLVar.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_HSLVAR;
    UserCaption := name;
    ID := IEPROC_EX_IE_HSLVAR_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSLVAR_HUE,
      IEPROC_EX_IE_HSLVAR_HUE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSLVAR_HUE_DEFAULT,
      IEPROC_EX_IE_HSLVAR_HUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSLVAR_HUE_MIN, IEPROC_EX_IE_HSLVAR_HUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSLVAR_HUE_MAX, IEPROC_EX_IE_HSLVAR_HUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSLVAR_HUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSLVAR_SAT,
      IEPROC_EX_IE_HSLVAR_SAT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSLVAR_SAT_DEFAULT,
      IEPROC_EX_IE_HSLVAR_SAT_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSLVAR_SAT_MIN, IEPROC_EX_IE_HSLVAR_SAT_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSLVAR_SAT_MAX, IEPROC_EX_IE_HSLVAR_SAT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSLVAR_SAT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSLVAR_LUM,
      IEPROC_EX_IE_HSLVAR_LUM_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSLVAR_LUM_DEFAULT,
      IEPROC_EX_IE_HSLVAR_LUM_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSLVAR_LUM_MIN, IEPROC_EX_IE_HSLVAR_LUM_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSLVAR_LUM_MAX, IEPROC_EX_IE_HSLVAR_LUM_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSLVAR_LUM_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 3);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_HSVVar.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_HSVVAR;
    UserCaption := name;
    ID := IEPROC_EX_IE_HSVVAR_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSVVAR_HUE,
      IEPROC_EX_IE_HSVVAR_HUE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSVVAR_HUE_DEFAULT,
      IEPROC_EX_IE_HSVVAR_HUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSVVAR_HUE_MIN, IEPROC_EX_IE_HSVVAR_HUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSVVAR_HUE_MAX, IEPROC_EX_IE_HSVVAR_HUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSVVAR_HUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSVVAR_SAT,
      IEPROC_EX_IE_HSVVAR_SAT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSVVAR_SAT_DEFAULT,
      IEPROC_EX_IE_HSVVAR_SAT_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSVVAR_SAT_MIN, IEPROC_EX_IE_HSVVAR_SAT_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSVVAR_SAT_MAX, IEPROC_EX_IE_HSVVAR_SAT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSVVAR_SAT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_HSVVAR_VALUE,
      IEPROC_EX_IE_HSVVAR_VALUE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_HSVVAR_VALUE_DEFAULT,
      IEPROC_EX_IE_HSVVAR_VALUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_HSVVAR_VALUE_MIN,
        IEPROC_EX_IE_HSVVAR_VALUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_HSVVAR_VALUE_MAX,
        IEPROC_EX_IE_HSVVAR_VALUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_HSVVAR_VALUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 3);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_IntensityRGBAll.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_INTENSITYRGBALL;
    UserCaption := name;
    ID := IEPROC_EX_IE_INTENSITYRGBALL_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_DEFAULT,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_MIN,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_MAX,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYRED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_DEFAULT,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_MIN,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_MAX,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYGREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_DEFAULT,
      IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_VTYPE);

      aPAram.SetMin(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_MIN,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_VTYPE);

      aPAram.SetMax(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_MAX,
        IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_INTENSITYRGBALL_INTENSITYBLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 3);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;



constructor TIEProc_EX_Filter_IE_Intensity.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_INTENSITY;
  UserCaption := name;
  ID := IEPROC_EX_IE_INTENSITY_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_LOLIMIT,
    IEPROC_EX_IE_INTENSITY_LOLIMIT_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_LOLIMIT_DEFAULT,
    IEPROC_EX_IE_INTENSITY_LOLIMIT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_LOLIMIT_MIN,
      IEPROC_EX_IE_INTENSITY_LOLIMIT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_INTENSITY_LOLIMIT_MAX,
      IEPROC_EX_IE_INTENSITY_LOLIMIT_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_HILIMIT,
    IEPROC_EX_IE_INTENSITY_HILIMIT_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_HILIMIT_DEFAULT,
    IEPROC_EX_IE_INTENSITY_HILIMIT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_HILIMIT_MIN,
      IEPROC_EX_IE_INTENSITY_HILIMIT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_INTENSITY_HILIMIT_MAX,
      IEPROC_EX_IE_INTENSITY_HILIMIT_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_CHANGE,
    IEPROC_EX_IE_INTENSITY_CHANGE_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_CHANGE_DEFAULT,
    IEPROC_EX_IE_INTENSITY_CHANGE_VTYPE);
  aPAram.SetMin(IEPROC_EX_IE_INTENSITY_CHANGE_MIN,
      IEPROC_EX_IE_INTENSITY_CHANGE_VTYPE);
  aPAram.SetMax(IEPROC_EX_IE_INTENSITY_CHANGE_MAX,
      IEPROC_EX_IE_INTENSITY_CHANGE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB,
    IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_DEFAULT,
    IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_VTYPE);
  aPAram.SetMin(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_MIN,
  IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_VTYPE);
  aPAram.SetMax(IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_MAX,
  IEPROC_EX_IE_INTENSITY_USEAVERAGERGB_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DORED,
    IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DORED_DEFAULT,
    IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
  aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DORED_MIN,
  IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
  aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DORED_MAX,
  IEPROC_EX_IE_INTENSITY_DORED_VTYPE);


  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DOGREEN,
    IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DOGREEN_DEFAULT,
    IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DOGREEN_MIN,
  IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);
  aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DOGREEN_MAX,
  IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DOBLUE,
    IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
  aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DOBLUE_DEFAULT,
    IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DOBLUE_MIN,
  IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
  aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DOBLUE_MAX,
  IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
end;

constructor TIEProc_EX_Filter_IE_Contrast.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_CONTRAST;
    UserCaption := name;
    ID := IEPROC_EX_IE_CONTRAST_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_CONTRAST_AMOUNT,
      IEPROC_EX_IE_CONTRAST_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_CONTRAST_AMOUNT_DEFAULT,
      IEPROC_EX_IE_CONTRAST_AMOUNT_VTYPE);
       aPAram.SetMin(IEPROC_EX_IE_CONTRAST_AMOUNT_MIN,
        IEPROC_EX_IE_CONTRAST_AMOUNT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_CONTRAST_AMOUNT_MAX,
        IEPROC_EX_IE_CONTRAST_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_CONTRAST_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_Contrast2.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_CONTRAST2;
    UserCaption := name;
    ID := IEPROC_EX_IE_CONTRAST2_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_CONTRAST2_AMOUNT,
      IEPROC_EX_IE_CONTRAST2_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_CONTRAST2_AMOUNT_DEFAULT,
      IEPROC_EX_IE_CONTRAST2_AMOUNT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_CONTRAST2_AMOUNT_MIN,
        IEPROC_EX_IE_CONTRAST2_AMOUNT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_CONTRAST2_AMOUNT_MAX,
        IEPROC_EX_IE_CONTRAST2_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_CONTRAST2_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_Contrast3.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_CONTRAST3;
    UserCaption := name;
    ID := IEPROC_EX_IE_CONTRAST3_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_CONTRAST3_CHANGE,
      IEPROC_EX_IE_CONTRAST3_CHANGE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_CONTRAST3_CHANGE_DEFAULT,
      IEPROC_EX_IE_CONTRAST3_CHANGE_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_CONTRAST3_CHANGE_MIN,
        IEPROC_EX_IE_CONTRAST3_CHANGE_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_CONTRAST3_CHANGE_MAX,
        IEPROC_EX_IE_CONTRAST3_CHANGE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_CONTRAST3_CHANGE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_CONTRAST3_MIDPOINT,
      IEPROC_EX_IE_CONTRAST3_MIDPOINT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_CONTRAST3_MIDPOINT_DEFAULT,
      IEPROC_EX_IE_CONTRAST3_MIDPOINT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_CONTRAST3_MIDPOINT_MIN,
        IEPROC_EX_IE_CONTRAST3_MIDPOINT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_CONTRAST3_MIDPOINT_MAX,
        IEPROC_EX_IE_CONTRAST3_MIDPOINT_VTYPE);

    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DORED,
      IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DORED_DEFAULT,
      IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DORED_MIN,
        IEPROC_EX_IE_INTENSITY_DORED_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DORED_MAX,
        IEPROC_EX_IE_INTENSITY_DORED_VTYPE);

    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DOGREEN,
      IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DOGREEN_DEFAULT,
      IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DOGREEN_MIN,
        IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DOGREEN_MAX,
        IEPROC_EX_IE_INTENSITY_DOGREEN_VTYPE);


    aPAram := self.Params.AddParam(IEPROC_EX_IE_INTENSITY_DOBLUE,
      IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_INTENSITY_DOBLUE_DEFAULT,
      IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_INTENSITY_DOBLUE_MIN,
        IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_INTENSITY_DOBLUE_MAX,
        IEPROC_EX_IE_INTENSITY_DOBLUE_VTYPE);

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_GammaCorrect.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_GAMMACORRECT;
    UserCaption := name;
    ID := IEPROC_EX_IE_GAMMACORRECT_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_GAMMACORRECT_GAMMA,
      IEPROC_EX_IE_GAMMACORRECT_GAMMA_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_GAMMACORRECT_GAMMA_DEFAULT,
      IEPROC_EX_IE_GAMMACORRECT_GAMMA_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_GAMMACORRECT_GAMMA_MIN,
        IEPROC_EX_IE_GAMMACORRECT_GAMMA_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_GAMMACORRECT_GAMMA_MAX,
        IEPROC_EX_IE_GAMMACORRECT_GAMMA_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_GAMMACORRECT_GAMMA_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_GAMMACORRECT_DORED,
      IEPROC_EX_IE_GAMMACORRECT_DORED_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_GAMMACORRECT_DORED_DEFAULT,
      IEPROC_EX_IE_GAMMACORRECT_DORED_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_GAMMACORRECT_DORED_MIN,
        IEPROC_EX_IE_GAMMACORRECT_DORED_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_GAMMACORRECT_DORED_MAX,
        IEPROC_EX_IE_GAMMACORRECT_DORED_VTYPE);

    aPAram := self.Params.AddParam(IEPROC_EX_IE_GAMMACORRECT_DOGREEN,
      IEPROC_EX_IE_GAMMACORRECT_DOGREEN_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_GAMMACORRECT_DOGREEN_DEFAULT,
      IEPROC_EX_IE_GAMMACORRECT_DOGREEN_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_GAMMACORRECT_DOGREEN_MIN,
        IEPROC_EX_IE_GAMMACORRECT_DOGREEN_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_GAMMACORRECT_DOGREEN_MAX,
        IEPROC_EX_IE_GAMMACORRECT_DOGREEN_VTYPE);

    aPAram := self.Params.AddParam(IEPROC_EX_IE_GAMMACORRECT_DOBLUE,
      IEPROC_EX_IE_GAMMACORRECT_DOBLUE_VTYPE);
    aPAram.SetValue(IEPROC_EX_IE_GAMMACORRECT_DOBLUE_DEFAULT,
      IEPROC_EX_IE_GAMMACORRECT_DOBLUE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_GAMMACORRECT_DOBLUE_MIN,
        IEPROC_EX_IE_GAMMACORRECT_DOBLUE_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_GAMMACORRECT_DOBLUE_MAX,
        IEPROC_EX_IE_GAMMACORRECT_DOBLUE_VTYPE);

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_AutoSharp.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_AUTOSHARP;
  UserCaption := name;
  ID := IEPROC_EX_IE_AUTOSHARP_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOSHARP_INTENSITY,
    IEPROC_EX_IE_AUTOSHARP_INTENSITY_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOSHARP_INTENSITY_DEFAULT,
    IEPROC_EX_IE_AUTOSHARP_INTENSITY_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOSHARP_INTENSITY_MIN,
      IEPROC_EX_IE_AUTOSHARP_INTENSITY_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOSHARP_INTENSITY_MAX,
      IEPROC_EX_IE_AUTOSHARP_INTENSITY_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOSHARP_RATE,
    IEPROC_EX_IE_AUTOSHARP_RATE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOSHARP_RATE_DEFAULT,
    IEPROC_EX_IE_AUTOSHARP_RATE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOSHARP_RATE_MIN,
      IEPROC_EX_IE_AUTOSHARP_RATE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOSHARP_RATE_MAX,
      IEPROC_EX_IE_AUTOSHARP_RATE_VTYPE);
end;

constructor TIEProc_EX_Filter_IE_Colorize.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_COLORIZE;
  UserCaption := name;
  ID := IEPROC_EX_IE_COLORIZE_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_COLORIZE_HUE,
    IEPROC_EX_IE_COLORIZE_HUE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_COLORIZE_HUE_DEFAULT,
    IEPROC_EX_IE_COLORIZE_HUE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_COLORIZE_HUE_MIN,
      IEPROC_EX_IE_COLORIZE_HUE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_COLORIZE_HUE_MAX,
      IEPROC_EX_IE_COLORIZE_HUE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_COLORIZE_SAT,
    IEPROC_EX_IE_COLORIZE_SAT_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_COLORIZE_SAT_DEFAULT,
    IEPROC_EX_IE_COLORIZE_SAT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_COLORIZE_SAT_MIN,
      IEPROC_EX_IE_COLORIZE_SAT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_COLORIZE_SAT_MAX,
      IEPROC_EX_IE_COLORIZE_SAT_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_COLORIZE_LUM,
    IEPROC_EX_IE_COLORIZE_LUM_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_COLORIZE_LUM_DEFAULT,
    IEPROC_EX_IE_COLORIZE_LUM_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_COLORIZE_LUM_MIN,
      IEPROC_EX_IE_COLORIZE_LUM_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_COLORIZE_LUM_MAX,
      IEPROC_EX_IE_COLORIZE_LUM_VTYPE);
end;

constructor TIEProc_EX_Filter_IE_AdjustBrightnessContrastSaturation.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION;
    UserCaption := name;
    ID := IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_ID;

    aPAram := self.Params.AddParam
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_VTYPE);

    aPAram.SetValue
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_DEFAULT,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_MIN,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_MAX,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_BRIGHTNESS_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_VTYPE);

    aPAram.SetValue
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_DEFAULT,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_MIN,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_MAX,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_CONTRAST_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam
      (IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_DEFAULT,
      IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_MIN,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_MAX,
        IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_BRIGHTNESS_CONTRAST_SATURATION_SAT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 3);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_AdjustTint.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_ADJUST_TINT;
    UserCaption := name;
    ID := IEPROC_EX_IE_ADJUST_TINT_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_ADJUST_TINT_AMOUNT,
      IEPROC_EX_IE_ADJUST_TINT_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_ADJUST_TINT_AMOUNT_DEFAULT,
      IEPROC_EX_IE_ADJUST_TINT_AMOUNT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_ADJUST_TINT_AMOUNT_MIN,
        IEPROC_EX_IE_ADJUST_TINT_AMOUNT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_ADJUST_TINT_AMOUNT_MAX,
        IEPROC_EX_IE_ADJUST_TINT_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_ADJUST_TINT_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_AdjustSaturation.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_ADJUST_SATURATION;
    UserCaption := name;
    ID := IEPROC_EX_IE_ADJUST_SATURATION_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT,
      IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_DEFAULT,
      IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_MIN,
        IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_MAX,
        IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_ADJUST_SATURATION_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_AdjustTemperature.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_ADJUST_TEMPERATURE;
    UserCaption := name;
    ID := IEPROC_EX_IE_ADJUST_TEMPERATURE_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT,
      IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_DEFAULT,
      IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_MIN,
        IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_MAX,
        IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_ADJUST_TEMPERATURE_AMOUNT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 1);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

constructor TIEProc_EX_Filter_IE_AdjustLumSatHistogram.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM;
    UserCaption := name;
    ID := IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM,
      IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_DEFAULT,
      IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_MIN,
        IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_MAX,
        IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT,
      IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_LUM_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_DEFAULT,
      IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_MIN,
        IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_MAX,
        IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_ADJUST_LUM_SAT_HISTOGRAM_SAT_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 2);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

Constructor TIEProc_EX_Filter_IE_WhiteBalance_coef.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
  listDefNoChg: TList;
begin
  inherited;

  listDefNoChg := TList.Create;
  try
    name := IEPROC_EX_IE_WHITEBALANCE_COEF;
    UserCaption := name;
    ID := IEPROC_EX_IE_WHITEBALANCE_COEF_ID;

    aPAram := self.Params.AddParam(IEPROC_EX_IE_WHITEBALANCE_COEF_RED,
      IEPROC_EX_IE_WHITEBALANCE_COEF_RED_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_WHITEBALANCE_COEF_RED_DEFAULT,
      IEPROC_EX_IE_WHITEBALANCE_COEF_RED_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_WHITEBALANCE_COEF_RED_MIN,
        IEPROC_EX_IE_WHITEBALANCE_COEF_RED_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_WHITEBALANCE_COEF_RED_MAX,
        IEPROC_EX_IE_WHITEBALANCE_COEF_RED_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_WHITEBALANCE_COEF_RED_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN,
      IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_DEFAULT,
      IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_MIN,
        IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_MAX,
        IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_WHITEBALANCE_COEF_GREEN_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE,
      IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_VTYPE);

    aPAram.SetValue(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_DEFAULT,
      IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_VTYPE);
      aPAram.SetMin(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_MIN,
        IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_VTYPE);
      aPAram.SetMax(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_MAX,
        IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_VTYPE);

    // ---------add to def no change-----------
    aPAram.SetDefValue(IEPROC_EX_IE_WHITEBALANCE_COEF_BLUE_DEFAULT);
    listDefNoChg.Add(aPAram);
    // ----------------------------------------

    // -------------------------------
    Assert(listDefNoChg.count = 3);
    // this is for the programmer to make sure he really knows what he is doing
    self.Params.DefineDefNoChangesParams(listDefNoChg);
    // add the def no change params
    // -------------------------------
  finally
    listDefNoChg.free;
  end;
end;

Constructor TIEProc_EX_Filter_IE_WhiteBalance_Grayworld.Create;
begin
  inherited;
  name := IEPROC_EX_IE_WHITEBALANCE_GRAYWORLD;
  UserCaption := name;
  ID := IEPROC_EX_IE_WHITEBALANCE_GRAYWORLD_ID;
  // no params
end;

Constructor TIEProc_EX_Filter_IE_WhiteBalance_WhiteAt.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_WHITEBALANCE_WHITEAT;
  UserCaption := name;
  ID := IEPROC_EX_IE_WHITEBALANCE_WHITEAT_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX,
    IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_DEFAULT,
    IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_MIN,
      IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_MAX,
      IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEX_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY,
    IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_DEFAULT,
    IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_MIN,
      IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_MAX,
      IEPROC_EX_IE_WHITEBALANCE_WHITEAT_WHITEY_VTYPE);

end;

Constructor TIEProc_EX_Filter_IE_WhiteBalance_AutoWhite.Create;
begin
  inherited;
  name := IEPROC_EX_IE_WHITEBALANCE_AUTOWHITE;
  UserCaption := name;
  ID := IEPROC_EX_IE_WHITEBALANCE_AUTOWHITE_ID;
  // no params
end;

Constructor TIEProc_EX_Filter_IE_AutoImageEnhance1.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_AUTOIMAGEENHANCE1;
  UserCaption := name;
  ID := IEPROC_EX_IE_AUTOIMAGEENHANCE1_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_SUBSAMPLEDSIZE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_SLOPE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_CUT_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE1_NEIGHBOUR_VTYPE);

end;

Constructor TIEProc_EX_Filter_IE_AutoImageEnhance2.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_AUTOIMAGEENHANCE2;
  UserCaption := name;
  ID := IEPROC_EX_IE_AUTOIMAGEENHANCE2_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECOUNT_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALECURVE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_VARIANCE_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_SCALEHIGH_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE2_LUMINANCE_VTYPE);

end;

Constructor TIEProc_EX_Filter_IE_AutoImageEnhance3.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_AUTOIMAGEENHANCE3;
  UserCaption := name;
  ID := IEPROC_EX_IE_AUTOIMAGEENHANCE3_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA,
    IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE3_GAMMA_VTYPE);

  aPAram := self.Params.AddParam(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION,
    IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_DEFAULT,
    IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_MIN,
      IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_MAX,
      IEPROC_EX_IE_AUTOIMAGEENHANCE3_SATURATION_VTYPE);

end;


{ TIEProc_EX_Filter_IE_Median_Sharpen }

constructor TIEProc_EX_Filter_IE_Median_Sharpen.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_MEDIANSHARPEN;
  UserCaption := name;
  ID := IEPROC_EX_IE_MEDIANSHARPEN_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW,
    IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_DEFAULT,
    IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_MIN,
      IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_MAX,
      IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_MEDIANSHARPEN_WINDOW_DEFAULT);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------



    aPAram := self.Params.AddParam(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER,
    IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_DEFAULT,
    IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_MIN,
      IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_MAX,
      IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_MEDIANSHARPEN_MULTIPLIER_DEFAULT);

end;


{ TIEProc_EX_Filter_IE_Median }

constructor TIEProc_EX_Filter_IE_Median.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_MEDIAN;
  UserCaption := name;
  ID := IEPROC_EX_IE_MEDIAN_ID;

  aPAram := self.Params.AddParam(IEPROC_EX_IE_MEDIAN_WINDOW,
    IEPROC_EX_IE_MEDIAN_WINDOW_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_MEDIAN_WINDOW_DEFAULT,
    IEPROC_EX_IE_MEDIAN_WINDOW_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_MEDIAN_WINDOW_MIN,
      IEPROC_EX_IE_MEDIAN_WINDOW_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_MEDIAN_WINDOW_MAX,
      IEPROC_EX_IE_MEDIAN_WINDOW_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_MEDIAN_WINDOW_DEFAULT);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

    aPAram := self.Params.AddParam(IEPROC_EX_IE_MEDIAN_THRESHOLD,
    IEPROC_EX_IE_MEDIAN_THRESHOLD_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_MEDIAN_THRESHOLD_DEFAULT,
    IEPROC_EX_IE_MEDIAN_THRESHOLD_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_MEDIAN_THRESHOLD_MIN,
      IEPROC_EX_IE_MEDIAN_THRESHOLD_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_MEDIAN_THRESHOLD_MAX,
      IEPROC_EX_IE_MEDIAN_THRESHOLD_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_MEDIAN_THRESHOLD_DEFAULT);

end;

{ TIEProc_EX_Filter_IE_Sharpen }

constructor TIEProc_EX_Filter_IE_Sharpen.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_SHARPEN;
  UserCaption := name;
  ID := IEPROC_EX_IE_SHARPEN_ID;


  aPAram := self.Params.AddParam(IEPROC_EX_IE_SHARPEN_AMOUNT,
    IEPROC_EX_IE_SHARPEN_AMOUNT_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_SHARPEN_AMOUNT_DEFAULT,
    IEPROC_EX_IE_SHARPEN_AMOUNT_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_SHARPEN_AMOUNT_MIN,
      IEPROC_EX_IE_SHARPEN_AMOUNT_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_SHARPEN_AMOUNT_MAX,
      IEPROC_EX_IE_SHARPEN_AMOUNT_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_SHARPEN_AMOUNT_DEFAULT);


  aPAram := self.Params.AddParam(IEPROC_EX_IE_SHARPEN_WINDOW,
    IEPROC_EX_IE_SHARPEN_WINDOW_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_SHARPEN_WINDOW_DEFAULT,
    IEPROC_EX_IE_SHARPEN_WINDOW_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_SHARPEN_WINDOW_MIN,
      IEPROC_EX_IE_SHARPEN_WINDOW_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_SHARPEN_WINDOW_MAX,
      IEPROC_EX_IE_SHARPEN_WINDOW_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_SHARPEN_WINDOW_DEFAULT);

    //----------------------------------
    aParam.IsScalable := true;
    //----------------------------------

end;

{ TIEProc_EX_Filter_IE_FindEdges }

constructor TIEProc_EX_Filter_IE_FindEdges.Create;
var
  aPAram: TIEProc_EX_Filter_PAram;
begin
  inherited;
  name := IEPROC_EX_IE_FINDEDGES;
  UserCaption := name;
  ID := IEPROC_EX_IE_FINDEDGES_ID;


  aPAram := self.Params.AddParam(IEPROC_EX_IE_FINDEDGES_KERNELSIZE,
    IEPROC_EX_IE_FINDEDGES_KERNELSIZE_VTYPE);

  aPAram.SetValue(IEPROC_EX_IE_FINDEDGES_KERNELSIZE_DEFAULT,
    IEPROC_EX_IE_FINDEDGES_KERNELSIZE_VTYPE);
    aPAram.SetMin(IEPROC_EX_IE_FINDEDGES_KERNELSIZE_MIN,
      IEPROC_EX_IE_FINDEDGES_KERNELSIZE_VTYPE);
    aPAram.SetMax(IEPROC_EX_IE_FINDEDGES_KERNELSIZE_MAX,
      IEPROC_EX_IE_FINDEDGES_KERNELSIZE_VTYPE);
    aPAram.SetDefValue(IEPROC_EX_IE_FINDEDGES_KERNELSIZE_DEFAULT);

end;


{ TIEProc_EX_Filter_Custom }
// all custom filters should inherit from this class
constructor TIEProc_EX_Filter_Custom.Create;
begin
  inherited;
  ID := IEPROC_EX_CUSTOMFILTER_ID;
  name := 'Custom Filter';
  UserCaption := name;
end;






 { //filters still to be implemented
  Automatic Image Enhancement
  AdjustGainOffset
  HistAutoEqualize

  Color Adjustment
  CastColorRange
  Closing
  Minimum
  Opening
  ConvertToBW_FloydSteinberg
  ConvertToBWLocalThreshold
  ConvertToBWOrdered
  ConvertToBWThreshold
  ConvertToGray
  ConvertToPalette
  ConvertToSepia
  ConvertTo
  EdgeDetect_ShenCastan
  EdgeDetect_Sobel
  HistEqualize
  MapGrayToColor
  Maximum
  MedianFilter
  MatchHSVRange
  
  Threshold
  Threshold2
  WallisFilter



  Pixel Adjustment
  ApplyFilterPreset
  ApplyFilter
  BumpMapping
  Convolve
  Lens
  RemoveRedEyes
  Sharpen

  Noise
  RemoveIsolatedPixels
  RemoveNoise
}
















end.


