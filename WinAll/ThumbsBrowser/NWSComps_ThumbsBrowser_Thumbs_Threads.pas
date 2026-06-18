unit NWSComps_ThumbsBrowser_Thumbs_Threads;

interface

uses
  windows, Classes, forms, graphics, messages, hyiedefs, hyieutils, imageenio;


  const
  WM_THUMB_RECEIVED = WM_USER + 100;
type

 // PThumbPointer:

  TThumbsBrowser_Thumb_LoadThread = class(TThread)
  private
    { Private declarations }

    fCriticalSession: TRTLCriticalSection;
    fThumbPointer: Pointer;
    fReceiver: THandle;
    ffilename: string;
    fiebmp: tiebitmap;
    fio: TImageenio;
    fper: integer;

 
    procedure FireTerminate;
    procedure GetIOProgress(Sender: TObject; per: integer);
    procedure FireProgress;

    procedure GetAnswer_FromReceiver(var message: TMessage); message WM_THUMB_RECEIVED;
    procedure SendMessage_Finished_ToReceiver;

  protected


    procedure Execute; override;
  public
   
    constructor Create;
    destructor Destroy; override;
    procedure AssignLoadingParams(theparams: TIOParamsVals);
    procedure Launch(TheFileName: string;
                     TheThumbPointer: Pointer;
                     TheReceiver: THandle);


  end;

implementation

uses sysutils, NWSComps_ThumbsBrowser_Utils;

{ TThumbsBrowser_Thumb_LoadThread  }

constructor TThumbsBrowser_Thumb_LoadThread.Create;
begin
  inherited create(true);

  Priority := tpLower;
  fiebmp := tiebitmap.create;
 // fiebmp.Location := iefile;
  fio := TImageenio.create(nil);
  fio.AttachedIEBitmap := fiebmp;
  fio.OnProgress := GetIOProgress;
  with fio.Params do
  begin
    RAW_Gamma := 0.6;
    RAW_Bright := 1.0;
    RAW_RedScale := 1.0;
    RAW_BlueScale := 1.0;
    RAW_QuickInterpolate := TRUE;
    RAW_UseAutoWB := false;
    RAW_UseCameraWB := true;
    RAW_FourColorRGB := false;
    RAW_AutoAdjustColors := false;
  end;
  FreeOnTerminate := true;
end;

destructor TThumbsBrowser_Thumb_LoadThread.Destroy;
begin
  fiebmp.free;
  fio.free;
  inherited;
end;

procedure TThumbsBrowser_Thumb_LoadThread.AssignLoadingParams(theparams: TIOParamsVals);
begin
  fio.Params.assign(theparams);

  resume;
end;

procedure TThumbsBrowser_Thumb_LoadThread.Launch(TheFileName: string;
                                                 TheThumbPointer: Pointer;
                                                 TheReceiver: THandle);
begin
  fThumbPointer := TheThumbPointer;
  ffilename := TheFileName;
  fReceiver := TheReceiver;

  resume;
end;


procedure TThumbsBrowser_Thumb_LoadThread.Execute;
var
 fc: integer;
begin
  { Place thread code here }
  EnterCriticalSection(fCriticalSession);
  try
    if TBFileExtIsVIDEO(extractfileext(ffilename)) then
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
      fio.loadfromfile(ffilename);
    end;

    FireTerminate;
  finally
    LeaveCriticalSection(fCriticalSession);
  end;


end;


procedure TThumbsBrowser_Thumb_LoadThread.GetIOProgress(Sender: TObject; per: integer);
begin
  fper := per;
  synchronize(FireProgress);
end;

procedure TThumbsBrowser_Thumb_LoadThread.FireProgress;
begin

end;

procedure TThumbsBrowser_Thumb_LoadThread.FireTerminate;
begin

end;


procedure TThumbsBrowser_Thumb_LoadThread.GetAnswer_FromReceiver(var message: TMessage);
begin
// if message.WParam = THREAD_ID_SAVEINITIAL_BMP then

end;

procedure TThumbsBrowser_Thumb_LoadThread.SendMessage_Finished_ToReceiver;
begin

end;

end.
