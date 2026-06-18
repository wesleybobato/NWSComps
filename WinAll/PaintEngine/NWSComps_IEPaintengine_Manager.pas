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

unit NWSComps_IEPaintengine_Manager;
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


{$DEFINE USE_JANTAB}

uses
  Windows, Classes, sysutils, controls, extctrls, math,
  ImageEnview, hyiedefs, hyieutils, NWSComps_IEPaintEngine, NWSComps_IEPaintEngine_Utils, NWSComps_IEPaintEngine_color,
  NWSComps_IEPaintEngine_Const, NWSComps_IEPaintEngine_Types,
  graphics, dialogs, syncobjs
  {$IFDEF USE_JANTAB}
   ,JH_WinTab, JH_WinTab_Const
  {$ENDIF}
  ;

type




  tpeNotifyEvent = procedure(sender: Tobject; var x, y: integer) of object;



  TImageEnPaintEngineManager = class(TComponent)
  private
    fPe: TImageenPAintEngine;

    function GetIsRunning: boolean;
    function GetpeParams_Paint: tPePaintParams;

    function GetpeParams_Color: tPeColorParams;
    function GetpeParams_Texture: tPeTextureParams;
    function GetpeParams_History: tPeHistoryParams;
    function GetpeParams_Cloning: tPeCloningParams;
    function GetpeParams_Warp: TPeDeformationParams;
    function GetpeParams_Retouch: TPeRetouchParams;

  //  function GetpeParams_Other: tPeOtherParams;

   {$IFDEF USE_JANTAB}
    function GetpeParams_Tablet: tPeTabletParams;
   {$ENDIF}


    procedure SetpeParams_Paint(theValue: tPePaintParams);

    procedure SetpeParams_Color(theValue: tPeColorParams);
    procedure SetpeParams_Texture(theValue: tPeTextureParams);
    procedure SetpeParams_History(theValue: tPeHistoryParams);

    procedure SetpeParams_Cloning(theValue: tPeCloningParams);
    procedure SetpeParams_Warp(theValue: TPeDeformationParams);
    procedure SetpeParams_Retouch(theValue: TPeRetouchParams);
//    procedure SetpeParams_Other(theValue: tPeOtherParams);

   {$IFDEF USE_JANTAB}
    procedure SetpeParams_Tablet(theValue: tPeTabletParams);
   {$ENDIF}

    function Session_FindFlag(const theFlagName: string): integer;


    function GetEditedRect: TRect;

    Function GetOnStartedPainting: TNotifyEvent;
    procedure SetOnStartedPainting(theValue: TNotifyEvent);
    Function GetOnPainting: tpeNotifyEvent;
    procedure SetOnPainting(theValue: tpeNotifyEvent);
    Function GetOnFinishedPainting: TNotifyEvent;
    procedure SetOnFinishedPainting(theValue: TNotifyEvent);
    Function GetOnSessionEvent: TpeparamsSessionEvent;
    procedure SetOnSessionEvent(theValue: TpeparamsSessionEvent);

    function Session_HasFlag(const theFlagName: string): boolean;
    function GetUpdatePriority: TPEUpdatePriority;
    procedure SetUpdatePriority(const Value: TPEUpdatePriority);
    function GetUpdateMode: TPEUpdateMode;
    procedure SetUpdateMode(const Value: TPEUpdateMode);

   
  protected



  public

  //  property Session_CurrentFlag: string read fpeSession_CurrentFlag;
    property IsRunning: boolean read GetIsRunning;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BeforeDestruction; override;

    procedure StartCursorNoPaint(theimageen:TImageenview; radius: cardinal);
    procedure StopCursorNoPaint;
    procedure Init(theImageEn: TImageenview; theMode: tpemode);
    procedure CleanUp;
    procedure StartPainting(ForceNewSession: boolean); overload;
    procedure StartPainting; overload;


    procedure StopPainting;

    procedure Session_Reset;
    procedure Session_AddFlag(const theFlagName: string);
    procedure Session_RemoveFlag(const theFlagName: string);

   published


   {$IFDEF USE_JANTAB}
    property Params_Tablet: tPeTabletParams read GetpeParams_Tablet write SetpeParams_Tablet;
    {$ENDIF}
    property Params_Paint: tPePaintParams read GetpeParams_Paint write SetpeParams_Paint;
    property Params_Color: tPeColorParams read GetpeParams_Color write SetpeParams_Color;
    property Params_Texture: tPeTextureParams read GetpeParams_Texture write SetpeParams_Texture;
    property Params_History: tPeHistoryParams read GetpeParams_History write SetpeParams_History;

    property Params_Cloning: tPeCloningParams read GetpeParams_Cloning write SetpeParams_Cloning;
    property Params_Warp: TPeDeformationParams read GetpeParams_Warp write SetpeParams_Warp;
    property Params_Retouch: TPeRetouchParams read GetpeParams_Retouch write SetpeParams_Retouch;

    property UpdateMode: TPEUpdateMode read GetUpdateMode write SetUpdateMode;
    property UpdatePriority: TPEUpdatePriority read GetUpdatePriority write SetUpdatePriority;


    property EditedRect: Trect read GetEditedRect;
    property OnStartedPainting: TNotifyEvent read GetOnStartedPainting write SetOnStartedPainting;
    property OnPainting: tpeNotifyEvent read GetOnPainting write SetOnPainting;
    property OnFinishedPainting: TNotifyEvent read GetOnFinishedPainting write SetOnFinishedPainting;
    property OnSessionEvent: tPeParamsSessionEvent read GetOnSessionEvent write SetOnSessionEvent;
   // property OnGetRadiusValue: tPeGetRadiusEvent read GetOnGetRadiusValue write SetOnGetRadiusValue;

  end;



implementation




function TImageEnPaintEngineManager.GetIsRunning: boolean;
begin
  result := fpe.IsRunning;
end;

function TImageEnPaintEngineManager.GetpeParams_Paint: tPePaintParams;
begin
  result := fpe.Params_Paint;
end;

function TImageEnPaintEngineManager.GetpeParams_Color: tPeColorParams;
begin
  result := fpe.Params_Color;
end;

function TImageEnPaintEngineManager.GetpeParams_Texture: tPeTextureParams;
begin
  result := fpe.Params_Texture;
end;

function TImageEnPaintEngineManager.GetpeParams_History: tPeHistoryParams;
begin
  result := fpe.Params_History;
end;


function TImageEnPaintEngineManager.GetpeParams_Cloning: tPeCloningParams;
begin
  result := fpe.Params_Cloning;
end;

function TImageEnPaintEngineManager.GetpeParams_Warp: TPeDeformationParams;
begin
  result := fpe.Params_Warp;
end;

function TImageEnPaintEngineManager.GetUpdateMode: TPEUpdateMode;
begin
  result := fpe.UpdateMode;
end;

function TImageEnPaintEngineManager.GetUpdatePriority: TPEUpdatePriority;
begin
   result := fpe.UpdatePriority;
end;

function TImageEnPaintEngineManager.GetpeParams_Retouch: TPeRetouchParams;
begin
  result := fpe.Params_Retouch;
end;

{
function TImageEnPaintEngineManager.GetpeParams_Other: tPeOtherParams;
begin
  result := fpe.Params_Other;
end;
}

{$IFDEF USE_JANTAB}
function TImageEnPaintEngineManager.GetpeParams_Tablet: tPeTabletParams;
begin
  result := fpe.PArams_Tablet;
end;
{$ENDIF}


procedure TImageEnPaintEngineManager.SetpeParams_Paint(theValue: tPePaintParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Paint.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetpeParams_Color(theValue: tPeColorParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Color.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetpeParams_Texture(theValue: tPeTextureParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Texture.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetpeParams_History(theValue: tPeHistoryParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_History.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetpeParams_Cloning(theValue: tPeCloningParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Cloning.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetpeParams_Warp(theValue: TPeDeformationParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Warp.Assign(theValue);
end;

procedure TImageEnPaintEngineManager.SetUpdateMode(const Value: TPEUpdateMode);
begin
  if fpe.IsRunning then EXIT;
  fpe.UpdateMode := Value;
end;

procedure TImageEnPaintEngineManager.SetUpdatePriority(
  const Value: TPEUpdatePriority);
begin
  if fpe.IsRunning then EXIT;
  fpe.UpdatePriority := Value;
end;

procedure TImageEnPaintEngineManager.SetpeParams_Retouch(theValue: TPeRetouchParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.Params_Retouch.Assign(theValue);
end;

{
procedure TImageEnPaintEngineManager.SetpeParams_Other(theValue: tPeOtherParams);
begin
  fpe.Params_Other.Assign(theValue);
end;
}

{$IFDEF USE_JANTAB}
procedure TImageEnPaintEngineManager.SetpeParams_Tablet(theValue: tPeTabletParams);
begin
  if fpe.IsRunning then EXIT;
  fpe.PArams_Tablet.Assign(theValue);
end;
{$ENDIF}




function TImageEnPaintEngineManager.GetEditedRect: TRect;
begin
  result := fPe.EditedRect;
end;


Function TImageEnPaintEngineManager.GetOnStartedPainting: TNotifyEvent;
begin
  result := fpe.OnStartedPainting;
end;

procedure TImageEnPaintEngineManager.SetOnStartedPainting(theValue: TNotifyEvent);
begin
  fpe.OnStartedPainting := theValue;
end;

Function TImageEnPaintEngineManager.GetOnPainting: tpeNotifyEvent;
begin
  result := fpe.OnPainting;
end;

procedure TImageEnPaintEngineManager.SetOnPainting(theValue: tpeNotifyEvent);
begin
  fpe.OnPainting := theValue;
end;

Function TImageEnPaintEngineManager.GetOnFinishedPainting: TNotifyEvent;
begin
  result := fpe.OnFinishedPainting;
end;


procedure TImageEnPaintEngineManager.SetOnFinishedPainting(theValue: TNotifyEvent);
begin
  fpe.OnFinishedPainting := theValue;
end;


Function TImageEnPaintEngineManager.GetOnSessionEvent: TpeparamsSessionEvent;
begin
  result := fpe.OnSessionEvent;
end;


procedure TImageEnPaintEngineManager.SetOnSessionEvent(theValue: TpeparamsSessionEvent);
begin
  fpe.OnSessionEvent := theValue;
end;



procedure TImageEnPaintEngineManager.CleanUp;
begin
  if assigned(fpe) then
  begin
    fpe.Terminate;
    fpe.WaitFor;
    freeandnil(fpe);
    //sleep(100);    //give time to pe to clean-up (to avoid control has no parent window error)
  end;
end;

constructor TImageEnPaintEngineManager.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  fpe := TImageenpaintengine.create(not (csDesigning in ComponentState));

end;

procedure TImageEnPaintEngineManager.BeforeDestruction;
begin

  CleanUp;
  inherited;
end;

destructor TImageEnPaintEngineManager.Destroy;
begin

  inherited;
end;



procedure TImageEnPaintEngineManager.Init(theImageEn: TImageenview; theMode: tpemode);
begin
  fpe.Params_Paint.Mode := theMode;

  fPe.Init(theImageEn, theMode);
end;


procedure TImageEnPaintEngineManager.StartCursorNoPaint(theimageen: TImageenview;
  radius: cardinal);
begin
  fpe.Init(theImageEn);
  Params_Paint.Radius := radius;
  Params_Paint.ShowBrushWhenNotRunning := true;
end;

procedure TImageEnPaintEngineManager.StopCursorNoPaint;
begin
  Params_Paint.ShowBrushWhenNotRunning := false;
end;

procedure TImageEnPaintEngineManager.StartPainting(ForceNewSession: boolean);
begin
  fpe.StartPainting(ForceNewSession);
end;

procedure TImageEnPaintEngineManager.StartPainting;
begin
   case Params_Paint.SessionMode of
     sm_IgnoreSessionMemory: fpe.StartPainting(true);
     sm_KeepSessionMemory_UntilNext: fpe.StartPainting(true);
     sm_KeepSessionMemory_UntilManualReset:
     begin
       fpe.StartPainting(fpe.Session.new);
     end;
   end;


end;

procedure TImageEnPaintEngineManager.StopPainting;
begin
  fpe.StopPainting;
end;


function TImageEnPaintEngineManager.Session_FindFlag(const theFlagName: string): integer;
var
  i: integer;
  bFound:boolean;
begin
  bFound := false;

  for i  := 0 to fpe.Session.Flags.Count-1 do
  begin
    if comparestr(theFlagName, fpe.Session.Flags[i])=0 then
    begin
      bFound := true;
      break;
    end;
  end;
  if bFound then
    result := i
  else
    result := -1;
end;


procedure TImageEnPaintEngineManager.Session_Reset;
begin
  if fpe.IsRunning then Exit;

  fpe.Session.New := True;
end;

procedure TImageEnPaintEngineManager.Session_AddFlag(const theFlagName: string);
begin
  if Session_FindFlag(theFlagName)<>-1 then
    fpe.Session.Flags.Add(theFlagName);

  fpe.Session.LastFlag := theFlagName;
end;

procedure TImageEnPaintEngineManager.Session_RemoveFlag(const theFlagName: string);
var
delidx: integer;
begin
  delidx := Session_FindFlag(theFlagName);

  if delidx<>-1 then
  begin
    fpe.Session.Flags.Delete(delidx);
    fpe.Session.LastFlag := G_CONST_PE_FLAG_NONE;
  end;
end;

function TImageEnPaintEngineManager.Session_HasFlag(const theFlagName: string): boolean;
begin
   result := Session_FindFlag(theFlagName) <>-1;
end;




end.