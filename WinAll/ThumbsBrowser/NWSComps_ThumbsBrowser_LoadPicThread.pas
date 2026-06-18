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
unit NWSComps_ThumbsBrowser_LoadPicThread;
{$R-}
{$Q-}
interface
{$I ..\_inc\NWSComps_Shared.inc}
uses
  windows, Classes, forms, graphics, messages, hyiedefs, hyieutils,
  {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF} imageenio;

type

  TThumbsBrowser_LoadPicThreadTerminatedEvent = procedure(theIeBitmap: Tiebitmap; thefilename: string) of object;

  TThumbsBrowser_LoadPicThread = class(TThread)
  private
    { Private declarations }

    fAborted: boolean;
    ffilename: string;
    fiebmp: tiebitmap;
    fio: TImageenio;
    fper: integer;

    fthreadTerminatedEvent: TThumbsBrowser_LoadPicThreadTerminatedEvent;
    fthreadProgressEvent: TIEProgressEvent;

    procedure FireTerminate;
    procedure GetIOProgress(Sender: TObject; per: integer);
    procedure FireProgress;


  protected


    procedure Execute; override;
  public


    property threadTerminatedEvent: TThumbsBrowser_LoadPicThreadTerminatedEvent read fthreadTerminatedEvent write fthreadTerminatedEvent;
    property threadProgressEvent: TIEProgressEvent read fthreadProgressEvent write fthreadProgressEvent;

    constructor Create;
    destructor Destroy; override;
    procedure Launch(fname: string);
    procedure Abort;

  end;

implementation

uses sysutils, NWSComps_ThumbsBrowser_Shell_Utils;

{ TThumbsBrowser_LoadPicThread  }

constructor TThumbsBrowser_LoadPicThread.Create;
begin
  inherited create(true);
  FreeOnTerminate := true;

  fAborted := false;
  fthreadTerminatedEvent := nil;
  fthreadProgressEvent := nil;
  Priority := tpLower;
  fiebmp := tiebitmap.create;
 // fiebmp.Location := iefile;
  fio := TImageenio.create(nil);
  fio.AttachedIEBitmap := fiebmp;
  fio.OnProgress := GetIOProgress;

  with fio.Params do
  begin
  //  RAW_Gamma := 0.8;
  //  RAW_Bright := 1.0;
  //  RAW_RedScale := 1.0;
  //  RAW_BlueScale := 1.0;
    RAW_QuickInterpolate := true;
    RAW_UseAutoWB := false;
    RAW_UseCameraWB := true;
    RAW_FourColorRGB := false;
    RAW_AutoAdjustColors := false;
  end;
end;

destructor TThumbsBrowser_LoadPicThread.Destroy;
begin
  freeandnil(fiebmp);
  freeandnil(fio);
  inherited;
end;


procedure TThumbsBrowser_LoadPicThread.Abort;
begin
  fAborted := true;
end;


procedure TThumbsBrowser_LoadPicThread.Launch(fname: string);
begin
  ffilename := fname;
  {$IFDEF NWSCOMPS_DXE2_UPPER}
  Start;
 {$ELSE}
  resume;
 {$ENDIF}
end;


procedure TThumbsBrowser_LoadPicThread.Execute;
var
 fc: integer;
begin
  { Place thread code here }

  if tbs_FileExtIsVIDEO(extractfileext(ffilename)) then
  begin
    try
     fc := fio.OpenMediaFile(ffilename);
     try
       if fc > 0 then
         fio.LoadFromMediaFile(fc div 2);
     finally
       fio.CloseMediaFile;
     end;
    except
      ;
    end;
  end
  else
  begin
    try
      fio.LoadFromFileAuto(ffilename);
    except
       ;
    end;
  end;
  if not fAborted then
    synchronize(FireTerminate);
end;


procedure TThumbsBrowser_LoadPicThread.GetIOProgress(Sender: TObject; per: integer);
begin
  if fAborted then
  begin
   fio.Aborting := true;
   EXIT;
  end;

  fper := per;
  synchronize(FireProgress);

end;

procedure TThumbsBrowser_LoadPicThread.FireProgress;
begin


  if assigned(fthreadProgressEvent) then
    fthreadProgressEvent(self, fper);
end;

procedure TThumbsBrowser_LoadPicThread.FireTerminate;
begin
    if fAborted then EXIT;

   if assigned(fthreadTerminatedEvent) then
    fthreadTerminatedEvent(fiebmp, ffilename);
end;



end.
