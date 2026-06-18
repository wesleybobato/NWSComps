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
unit NWSComps_MultiThreadProc;
{$R-}
{$Q-}
interface
{$I ..\_inc\NWSComps_MultiThreadProc.inc}

{$IFNDEF STANDALONE_MULTIPROC}
  {$I ..\_inc\NWSComps_Shared.inc}
{$ENDIF}


 uses
  Windows, Messages, SysUtils,
  {$IFDEF NWSCOMPS_DXE2_UPPER}
  vcl.forms,
  {$ELSE}
  forms,
  {$ENDIF}
  Classes, Graphics, Controls,
  syncobjs, contnrs,
  hyieutils,
  {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF}
  hyiedefs
  {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}, NWSComps_Proc_Filter_Types {$ENDIF};
type
  TIEMultiProc_EX_RunResult = (RunOk, RunAborted, RunAbortedWithError);

  TIEMultiProc_EX_ProcFunction = procedure(sender: TObject; bitmap: TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent);

  TIEMultiProc_EX_ProcMethod = procedure(sender: TObject; bitmap: TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent) of object;

  {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
     TIEMultiProc_EX_ProcFilterMethod = procedure(sender: TObject; theFilter:TIEProc_EX_Filter;
                                                  bitmap: TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent) of object;
  {$ENDIF}

  TIEMultiProc_EX_Overlap = class

    private
    fDestRect: TRect;
    fIEBitmap: TIEBitmap;
    fOwnBmp: boolean;
    fDeltaOv1: integer;
    fDeltaOv2: integer;
    fSrcRect: TRect;
    public
      constructor Create(theIEBitmap:TIebitmap;
                         theDestRect:TRect;
                         theSrcRect:TRect;
                         theDeltaOv1, theDeltaOv2: integer;
                         bOwnBmp: boolean);
      destructor Destroy; override;
      property IEBitmap:TIEBitmap read fIEBitmap;
      property SrcRect:TRect read fSrcRect;
      property DestRect:TRect read fDestRect;
      property DeltaOv1: integer read fDeltaOv1;
      property DeltaOv2: integer read fDeltaOv2;

  end;

  TIEMultiProc_EX_Thread = class(TThread)
  private
    { Private declarations }

    fStartEvent: TEvent;
    fOvObj: TIEMultiProc_EX_Overlap;
    fProcMethod: TIEMultiProc_EX_ProcMethod;
    fProcFunc: TIEMultiProc_EX_ProcFunction;
    {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    fProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
    fFilter: TIEProc_EX_Filter;
    {$ENDIF}
    fOnFinish: TNotifyEvent;
    fOnProgress: TIEProgressEvent;

    procedure Init(theStartEvent:TEvent;
                   theOverlapObject: TIEMultiProc_EX_Overlap;
                   theProcMethod: TIEMultiProc_EX_ProcMethod;
                   theFinishEvent: TNotifyEvent;
                   theProgressEvent: TIEProgressEvent);  overload;

    procedure Init(theStartEvent:TEvent;
                   theOverlapObject: TIEMultiProc_EX_Overlap;
                   theProcFunc: TIEMultiProc_EX_ProcFunction;
                   theFinishEvent: TNotifyEvent;
                   theProgressEvent: TIEProgressEvent); overload;

    {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    procedure Init(theStartEvent:TEvent;
                   theOverlapObject: TIEMultiProc_EX_Overlap;
                   theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
                   theFilter: TIEProc_EX_Filter;
                   theFinishEvent: TNotifyEvent;
                   theProgressEvent: TIEProgressEvent); overload;

    {$ENDIF}

    procedure InitCommon(theStartEvent: TEvent;
      theOverlapObject: TIEMultiProc_EX_Overlap; theFinishEvent: TNotifyEvent;
      theProgressEvent: TIEProgressEvent);



  protected


    procedure Execute; override;
  public

    constructor Create;
    destructor Destroy; override;

    procedure Launch;


    property OvObj: TIEMultiProc_EX_Overlap read fOvObj;
  end;

  TIEMultiProc_EX_OverlapMethod = (omAddExtraPixels, omAddExtraThreads);

  TIEMultiProc_EX_Sender = class
    private
    fPerc: integer;
    fSender: TObject;
    public

    property Sender: TObject read fSender;
    property Perc: integer read fPerc write fPerc;

    Constructor Create(theSender: TObject; thePerc: integer);
  end;

  TIEMultiProc_EX = class

  private
    fOverlapMethod: TIEMultiProc_EX_OverlapMethod;

    fFinishedObjects: TObjectList;

    fStartEvent: TEvent;
    fRunCS, fThreadCS: TCriticalSection;
    fIeBitmap: TIEBitmap;
    fEditRect: TRect;
    {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    fProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
    fFilter: TIEProc_EX_Filter;
    {$ENDIF}
    fProcMethod: TIEMultiProc_EX_ProcMethod;
    fProcFunc: TIEMultiProc_EX_ProcFunction;
    fNThreads: integer;
    fThreadHandles: array of THandle;
    fOverlap: cardinal;
    fOnProgress: TIEProgressEvent;
    fProgressTk: cardinal;
    fCheckAbortTk: cardinal;
    fDoingProgress: boolean;
    fListOfSenders: TObjectList;
    fAborted: boolean;
    fProcessMessagesWhileInProgress: boolean;
    fOnInitialized: TNotifyEvent;
    fOnFinished: TNotifyEvent;

    procedure HandleThreadFinish(sender: TObject);
    procedure HandleThreadProgress(sender: TObject; per: integer);
    function GetOveralPercentProgress: integer;
    procedure AddProgress(theSender: TObject; Perc:integer);
    procedure finishWithOverlaps;
    procedure MergeOverlapsMeth1(ov1, ov2: TIEMultiProc_EX_Overlap);
    procedure MergeOverlapsMeth2_Main(ov1, ov2: TIEMultiProc_EX_Overlap; bIsFirst: boolean);
    procedure MergeOverlapsMeth2_Secondary(ov0, ov1, ov2: TIEMultiProc_EX_Overlap);
    procedure CreateThreadsWithOverlaps(bAutoRegulateOverlap: boolean);

    function Run(NThreads: integer;
                  theIEBitmap: TIEBitmap; theEditRect: TRect;
                  theProcFunc: TIEMultiProc_EX_ProcFunction;
                  theProcMethod: TIEMultiProc_EX_ProcMethod;
                  {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
                  theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
                  theFilter: TIEProc_EX_Filter;
                  {$ENDIF}
                  theProcOverlap: cardinal;
                  theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                  bAutoRegulateOverlap: boolean): TIEMultiProc_EX_RunResult; overload;
    procedure ClearOverlaps;
    procedure DoBlend(srcBmp1, srcBmp2: TIEBitmap; ydestTop,
      ydestBottom, dySrc1, dySrc2, blendDiv: integer);

  public

    constructor Create;
    destructor Destroy; override;

    {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    function Run(NThreads: integer;
                  theIEBitmap: TIEBitmap; theEditRect:TRect;
                  theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
                  theFilter: TIEProc_EX_Filter;
                  theProcOverlap: cardinal;
                  theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                  bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult; overload;
    {$ENDIF}



    function Run(NThreads: integer;
                  theIEBitmap: TIEBitmap; theEditRect:TRect;
                  theProcMethod: TIEMultiProc_EX_ProcMethod;
                  theProcOverlap: cardinal;
                  theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                  bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult; overload;

    function Run(NThreads: integer;
                  theIEBitmap: TIEBitmap; theEditRect:TRect;
                  theProcFunc: TIEMultiProc_EX_ProcFunction;
                  theProcOverlap: cardinal;
                  theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                  bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult; overload;


    procedure Abort;

    function NumberOfProcessors: Integer;

    property ProcessMessagesWhileInProgress: boolean read fProcessMessagesWhileInProgress write fProcessMessagesWhileInProgress;

    property OnProgress: TIEProgressEvent read fOnProgress write fOnProgress;
    property OnInitialized: TNotifyEvent read fOnInitialized write fOnInitialized;
    property OnFinished: TNotifyEvent read fOnFinished write fOnFinished;

  end;

implementation

  uses math, dialogs;



procedure DrawIEBitmapToIeBitmap(src, dest: TIEBitmap; XDest, YDest: integer; srcIERect: TIERectangle);   overload;
var
  xSrc1, xSrc2, ySrc1, ySrc2: integer;
 xdest1, xdest2, ydest1, ydest2: integer;
 ys,I, J, k: integer;
 pbs, pbd: pbytearray;
 bs, bd: integer;
 deltaByte: integer;
begin
   
   {$IFDEF IMAGEEN_6_3_0_LATER}
      src.CopyRectTo(dest, srcIERect.x, srcIERect.y, XDest, YDest, srcIERect.width, srcIERect.height, true);
   {$ELSE}
      src.CopyRectTo(dest, srcIERect.x, srcIERect.y, XDest, YDest, srcIERect.width, srcIERect.height);
   {$ENDIF}

   EXIT;
   //below is our own implementation , which does not copy alpha channel


  if (src.PixelFormat <> dest.PixelFormat) or
     ((src.PixelFormat <> ie32rgb) and (src.PixelFormat <> ie24rgb) and (src.PixelFormat <> ie8g)) then
     raise Exception.Create('Wrong pixel format');

  case src.PixelFormat of
    ie32RGB: deltaByte := 3;
    ie24RGB: deltaByte := 2;
    else deltaByte := 0; //ie8g:
  end;


  xSrc1 := max(0, srcIERect.x);
  xSrc2 := min(src.Width - 1, srcIERect.x + srcIERect.width - 1);
  ySrc1 := max(0, srcIERect.y);
  ySrc2 := min(src.Height - 1, srcIERect.y + srcIERect.Height - 1);

  xDest1 := max(0, XDest);
  yDest1 := max(0, YDest);
  xDest2 := min(dest.width - 1, xDest + srcIERect.width - 1);
  yDest2 := min(dest.Height - 1, yDest + srcIERect.height - 1);

  for j := yDest1 to yDest2 do
  begin
    ys := j - yDest + ySrc1;
    pbd := dest.ScanLine[j];
    pbs := src.ScanLine[ys];

    bd := xDest1 * (deltaByte + 1);
    bs := (xDest1 - xDest + xSrc1) * (deltaByte + 1);
    for i := xDest1 to xDest2 do
    begin
      for k := 0 to deltaByte do
      begin
        pbd[bd] := pbs[bs];
        inc(bd);
        inc(bs);
      end;
    end;
  end;

end;


procedure DrawIEBitmapToIeBitmap(src, dest: TIEBitmap; XDest, YDest: integer); overload;
var
srcIERect: TIERectangle;
begin
  srcIERect.x := 0;
  srcIERect.y := 0;
  srcIERect.width := src.Width;
  srcIERect.height := src.Height;
  DrawIEBitmapToIeBitmap(src, dest, XDest, YDest, srcIERect);
end;


constructor TIEMultiProc_EX_Thread.Create;
begin
  inherited create(true);
  Priority := tpNormal;
  FreeOnTerminate := true;
end;

destructor TIEMultiProc_EX_Thread.Destroy;
begin

  inherited;
end;


procedure TIEMultiProc_EX_Thread.Execute;
begin
  inherited;

  fStartEvent.waitfor(infinite);

  if assigned(fProcFunc) then
    fProcFunc(self, fOvObj.IEBitmap, fOvObj.SrcRect, fOnProgress)
  else if assigned(fProcMethod) then
    fProcMethod(self, fOvObj.IEBitmap, fOvObj.SrcRect, fOnProgress)
   {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
   else if assigned(fProcFilterMethod) then
    fProcFilterMethod(self, fFilter, fOvObj.IEBitmap, fOvObj.SrcRect, fOnProgress)
    {$ENDIF};

  if assigned(fOnFinish) then
    fOnFinish(self);
end;

procedure TIEMultiProc_EX_Thread.Init(theStartEvent: TEvent;
  theOverlapObject: TIEMultiProc_EX_Overlap;
  theProcFunc: TIEMultiProc_EX_ProcFunction; theFinishEvent: TNotifyEvent;
  theProgressEvent: TIEProgressEvent);
begin
  InitCommon(theStartEvent, theOverlapObject, theFinishEvent, theProgressEvent); //call this as first always

  fProcFunc := theProcFunc;
end;

 {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
procedure TIEMultiProc_EX_Thread.Init(theStartEvent:TEvent;
                   theOverlapObject: TIEMultiProc_EX_Overlap;
                   theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
                   theFilter: TIEProc_EX_Filter;
                   theFinishEvent: TNotifyEvent;
                   theProgressEvent: TIEProgressEvent);
begin
  InitCommon(theStartEvent, theOverlapObject, theFinishEvent, theProgressEvent); //call this as first always
  fProcFilterMethod := theProcFilterMethod;
  fFilter := theFilter;
end;
{$ENDIF}

procedure TIEMultiProc_EX_Thread.Init(theStartEvent:TEvent;theOverlapObject:TIEMultiProc_EX_Overlap;
                                      theProcMethod: TIEMultiProc_EX_ProcMethod;
                                      theFinishEvent: TNotifyEvent;
                                      theProgressEvent: TIEProgressEvent);
begin
  InitCommon(theStartEvent, theOverlapObject, theFinishEvent, theProgressEvent); //call this as first always

  fProcMethod := theProcMethod;
end;

procedure TIEMultiProc_EX_Thread.InitCommon(theStartEvent:TEvent;theOverlapObject:TIEMultiProc_EX_Overlap;
                                            theFinishEvent: TNotifyEvent;
                                            theProgressEvent: TIEProgressEvent);
begin
  freeonterminate := True;
  //------------------------
  fStartEvent := theStartEvent;
  fOvObj := theOverlapObject;
  fOnFinish :=  theFinishEvent;
  fOnProgress := theProgressEvent;
  fProcMethod := nil;
  fProcFunc := nil;
  {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
  fProcFilterMethod := nil;
  fFilter := nil;
  {$ENDIF}
end;


procedure TIEMultiProc_EX_Thread.Launch;
begin
 {$IFDEF NWSCOMPS_DXE2_UPPER}
  Start;
 {$ELSE}
  resume;
 {$ENDIF}
end;

{ TMultiProc }



constructor TIEMultiProc_EX.Create;
begin
  fProcessMessagesWhileInProgress := False;
  fOverlapMethod := omAddExtraPixels;
  fStartEvent := TEvent.Create;
  fRunCS := TCriticalSection.create;
  fThreadCS := TCriticalSection.create;

  fFinishedObjects := TObjectList.create;
  fListOfSenders := TObjectList.create;
end;

destructor TIEMultiProc_EX.destroy;
begin
  fListOfSenders.free;
  fFinishedObjects.free;
  fStartEvent.free;
  fThreadCS.free;
  fRunCS.free;
  inherited Destroy;
end;

function TIEMultiProc_EX.Run(NThreads: integer;
                              theIEBitmap: TIEBitmap; theEditRect: TRect;
                              theProcFunc: TIEMultiProc_EX_ProcFunction;
                              theProcMethod:TIEMultiProc_EX_ProcMethod;
                              {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
                              theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
                              theFilter: TIEProc_EX_Filter;
                              {$ENDIF}
                              theProcOverlap: cardinal;
                              theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                              bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult;
procedure CheckDoProgress(bInprogress:boolean);
begin
  if not assigned(fOnProgress) then
  begin
    fDoingProgress := false;
    EXIT;
  end;

   fThreadCS.Enter;
   try
   fDoingProgress := false;
   if bInprogress then
     fOnProgress(self, GetOveralPercentProgress)
   else
     fOnProgress(self, 100);
   finally
     fThreadCS.Leave;
   end;
end;

procedure SetEditRect(theRect:TRect; theBmp: TIEBitmap);
begin
  fEditRect := theEditRect;
  fEditRect.left := max(0, fEditRect.left);
  fEditRect.Top := max(0, fEditRect.top);
  fEditRect.right := min(fEditRect.Right, theBmp.width - 1);
  fEditRect.Bottom := min(fEditRect.Bottom, theBmp.height - 1);
end;
var
  bFinished: boolean;
  bUnkownError: boolean;
  I: integer;
  tempThreadHandles: array of THandle;
  waitResult:cardinal;
  exitCode:cardinal;


  avgFinishTime: integer;
  tkStartCheck: cardinal;
  StartHandlesCount: integer;
  procedure AddFinished;
  begin
     //the thread is finished
     if avgFinishTime = -1 then
       avgFinishTime := (GetTickCount - tkStartCheck)
     else
       avgFinishTime := (avgFinishTime + GetTickCount - tkStartCheck) div 2;
  end;
begin
  result := RunOk;
{
  fRunCS.Enter;  //this critical section protects the code
                 //in case of reentering the running code
                 //from secondary threads
                 //or from another main thread caused by a call to processmessages
                 //the same object can only run once at a time
                 }
  if not fRunCs.TryEnter then
  begin
    Abort;
    fRunCs.Enter;
  end;
  try

      fNThreads := NThreads;
      fIeBitmap := theIEBitmap;
      SetEditRect(theEditRect, theIEBitmap);
      fProcFunc := theProcFunc;
      fProcMethod := theProcMethod;
      {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
      fProcFilterMethod := theProcFilterMethod;
      fFilter := theFilter;
      {$ENDIF}
      fOverlap := theProcOverlap;
      fOverlapMethod := theOverlapMethod;

      if assigned(fOnInitialized) then
        fOnInitialized(self);

      fStartEvent.ResetEvent;

      //--------------------------------------------------------------------------------------
      CreateThreadsWithOverlaps(bAutoRegulateOverlap);  //create the threads, and launch them
      //--------------------------------------------------------------------------------------

      //--------------------------------------------------------------------------------------
      fStartEvent.SetEvent;  //set the event to make the threads start their processing
      //--------------------------------------------------------------------------------------

      fCheckAbortTk := GetTickCount;
      fProgressTk := GetTickCount;
      fDoingProgress := false;
      fListOfSenders.clear;

      fAborted := false;
      bUnkownError := false;
      //wait for the threads to finish

      repeat
         if fDoingProgress then
            CheckDoProgress(true);

         if fProcessMessagesWhileInProgress then
         begin
           if GetTickCount - fCheckAbortTk > 100 then
           begin
              if GetCurrentThreadID = MainThreadID then
              begin
                  // in main thread
                  Application.ProcessMessages; //in order to give the user the ability to abort by the GUI
              end;

             fCheckAbortTk := GetTickCount;
           end;
         end;



         tkStartCheck := gettickcount;
         avgFinishTime := -1;  //initialize to -1
         StartHandlesCount := length(fThreadHandles);
         setlength(tempThreadHandles, 0);
         for I := Low(fThreadHandles) to High(fThreadHandles) do
         begin
           waitResult := WaitForSingleObject(fThreadHandles[i], 0);
           if waitResult = WAIT_TIMEOUT then
           begin
              //thread is not finished
              //double check exit code
              GetExitCodeThread(fThreadHandles[i], exitCode);

              //---------------------------------
              if exitcode = STILL_ACTIVE then   //still active
              begin
                 if (avgFinishTime <> -1) or (length(fThreadHandles) < StartHandlesCount) then     //safety mechanism
                 begin
                   if (GetTickCount - tkStartCheck) > 3 * avgFinishTime then
                   begin
                     //---------------------------------
                      bUnkownError := true;
                      break;
                     //---------------------------------
                   end;
                 end;
                 setlength(tempThreadHandles, length(tempThreadHandles) + 1);
                 tempThreadHandles[high(tempThreadHandles)] := fThreadHandles[i];
              end
              else
              begin   //not active
                AddFinished;
                if WaitForSingleObject(fThreadHandles[i], 0) = WAIT_TIMEOUT then   //recheck timeout
                begin
                   //---------------------------------
                    bUnkownError := true;   //if still timeout (since exit code is not active) we deduce an error
                    break;
                   //---------------------------------
                end;
              end;
           end
           else if (waitresult <> WAIT_FAILED) and (waitresult <> WAIT_OBJECT_0) then
           begin
              //---------------------------------
              bUnkownError := true;
              break;
              //---------------------------------
           end
           else
           begin
              //if (waitresult = WAIT_FAILED) or (waitresult = WAIT_OBJECT_0) then
                AddFinished;
           end;

         end;
         fThreadHandles := nil;
         SetLength(fThreadHandles, length(tempThreadHandles));
         for I := Low(tempThreadHandles) to High(tempThreadHandles) do
             fThreadHandles[i] := tempThreadHandles[i];

         bFinished := length(fThreadHandles) = 0;

      until (fAborted or bFinished or bUnkownError);

      if fAborted then
        result := RunAborted
      else if bUnkownError then
        result := RunAbortedWithError
      else
        result := RunOk;

      fStartEvent.ResetEvent;  //reset the event now that the threads are finished

      if not bUnkownError then
      begin
        CheckDoProgress(false);
        FinishWithOverlaps;  //take the outputs from the various threads and combine them
      end;

      ClearOverlaps;
      setlength(fThreadHandles, 0);


     if assigned(fOnFinished) then
        fOnFinished(self);
  finally
    fRunCS.leave;
  end;
end;



function TIEMultiProc_EX.NumberOfProcessors: Integer;
var
    systemInfo: SYSTEM_INFO;
begin
    GetSystemInfo(systemInfo);
    Result := systemInfo.dwNumberOfProcessors;
end;

function TIEMultiProc_EX.Run(NThreads: integer;
                  theIEBitmap: TIEBitmap; theEditRect:TRect;
                  theProcMethod: TIEMultiProc_EX_ProcMethod;
                  theProcOverlap: cardinal;
                  theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                  bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult;
{$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
var
emptyProcFilterMethod:  TIEMultiProc_EX_ProcFilterMethod;
{$ENDIF}
begin
   {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
      emptyProcFilterMethod := nil;
      result := Run(NThreads, theIeBitmap, theEditRect, nil, theProcMethod, emptyProcFilterMethod, nil, theProcOverlap, theOverlapMethod, bAutoRegulateOverlap);
   {$ELSE}
      result := Run(NThreads, theIeBitmap, theEditRect, nil, theProcMethod, theProcOverlap, theOverlapMethod, bAutoRegulateOverlap);
   {$ENDIF}


end;

function TIEMultiProc_EX.Run(NThreads: integer; theIEBitmap: TIEBitmap; theEditRect:TRect;
                              theProcFunc: TIEMultiProc_EX_ProcFunction; theProcOverlap: cardinal;
                              theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
                              bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult;
var
 emptyProcMethod:  TIEMultiProc_EX_ProcMethod;
{$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
emptyProcFilterMethod:  TIEMultiProc_EX_ProcFilterMethod;
{$ENDIF}
begin
  emptyProcMethod := nil;
  {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    emptyProcFilterMethod := nil;
    result := Run(NThreads, theIeBitmap, theEditRect, theProcFunc, emptyProcMethod, emptyProcFilterMethod, nil, theProcOverlap, theOverlapMethod, bAutoRegulateOverlap);
  {$ELSE}
    result := Run(NThreads, theIeBitmap, theEditRect, theProcFunc, emptyProcMethod, theProcOverlap, theOverlapMethod, bAutoRegulateOverlap);
  {$ENDIF}
end;

{$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
function TIEMultiProc_EX.Run(NThreads: integer;
              theIEBitmap: TIEBitmap; theEditRect:TRect;
              theProcFilterMethod: TIEMultiProc_EX_ProcFilterMethod;
              theFilter: TIEProc_EX_Filter;
              theProcOverlap: cardinal;
              theOverlapMethod: TIEMultiProc_EX_OverlapMethod;
              bAutoRegulateOverlap: boolean):TIEMultiProc_EX_RunResult;
var
 emptyProcMethod:  TIEMultiProc_EX_ProcMethod;
begin
  emptyProcMethod := nil;
  result := Run(NThreads, theIeBitmap, theEditRect, nil, emptyProcMethod, theProcFilterMethod, theFilter, theProcOverlap, theOverlapMethod, bAutoRegulateOverlap);
end;
{$ENDIF}


procedure TIEMultiProc_EX.CreateThreadsWithOverlaps(bAutoRegulateOverlap: boolean);
var
w,h: integer;
x1,y1,x2,y2: integer;

tdH, tdy1, tdy2: integer;
tdRect, tdOverlappedRect: TRect;
tdRects: array of TRect;
tdIEBitmap: TIEBitmap;
I: Integer;
thread: TIEMultiProc_EX_Thread;
 deltaOv1, deltaOv2: integer;


 procedure InitThread(theThread: TIEMultiProc_EX_Thread; theOvObj: TIEMultiProc_EX_Overlap);
 begin
    if assigned(fProcFunc) then
      theThread.Init(fStartEvent, theOvObj, fProcFunc, HandleThreadFinish, HandleThreadProgress)
    else if assigned(fProcMethod) then
      theThread.Init(fStartEvent, theOvObj, fProcMethod, HandleThreadFinish, HandleThreadProgress)
    {$IFDEF NWSCOMPS_INTEGRATED_MULTIPROC}
    else if assigned(fProcFilterMethod) then
      theThread.Init(fStartEvent, theOvObj, fProcFilterMethod, fFilter, HandleThreadFinish, HandleThreadProgress)
    {$ENDIF};
 end;


begin
  setlength(fThreadHandles, 0);
  fFinishedObjects.clear;

  x1 := fEditRect.left;
  x2 := fEditRect.right;
  y1 := fEditRect.Top;
  y2 := fEditRect.Bottom;

  w :=  fEditRect.right - fEditRect.left + 1;
  h :=  fEditRect.Bottom - fEditRect.Top + 1;


  SetLength(fThreadHandles, fNThreads);
  SetLength(tdRects, fNThreads);

  tdH := h div fNThreads;
  if bAutoRegulateOverlap then
    fOverlap := min(round(tdh /3), fOverlap)
  else
    fOverlap := min(round(tdh /2), fOverlap);

  tdy1 := y1;
  tdy2 := tdy1 + tdH - 1;
  for I := 0 to fNThreads-1 do
  begin

    if tdy1 - fOverlap >= y1 then
      deltaOv1 := fOverlap
    else
      deltaOv1 := tdy1;

    if tdy2 + fOverlap <= y2 then
      deltaOv2 := fOverlap
    else
      deltaOv2 := y2 - tdy2;


    tdRect :=  rect(x1, tdy1, x2, tdy2);
    tdRects[i] := tdrect;

    tdOverlappedRect := rect(x1, tdy1 - deltaOv1, x2, tdy2 + deltaOv2);


    if fOverlapMethod = omAddExtraPixels then
      tdIEBitmap := TIEBitmap.Create(fieBitmap, tdOverlappedRect)  //in this overlap mode the bitmaps will contain more pixels than necessary
    else
      tdIEBitmap := TIEBitmap.Create(fieBitmap, tdRect);  //in this overlap mode the bitmaps will contain exactly the pixels for their destination

    tdIEBitmap.Location := ieMemory;


    thread := TIEMultiProc_EX_Thread.Create;

    InitThread(thread, TIEMultiProc_EX_Overlap.create(tdIEBitmap, tdRect, rect(0,0,tdIEBitmap.Width-1, tdIEBitmap.Height-1),
                                                            deltaOv1, deltaOv2, true));

    fThreadHandles[i] := thread.Handle;
    thread.Launch;

    inc(tdy1, tdH);
    if i + 1 = fNThreads-1 then
       tdy2 := y2
    else
      inc(tdy2, tdH);
  end;

  //when the overlap method is omAddExtraThreads we create additional threads
  if (fOverlapMethod = omAddExtraThreads)and (fOverlap > 0) then  //add auxiliary threads for overlaps
  begin

     for I := 0 to high(tdRects) - 1 do
     begin
       tdRect := rect( tdRects[i].left,
                       max(y1, tdRects[i].bottom - fOverlap),
                       tdRects[i].right,
                       min(y2, tdRects[i].bottom + fOverlap)
                       );

       tdIEBitmap := TIEBitmap.Create(fieBitmap, tdRect);  //create the bitmaps for the extra threads
       tdIEBitmap.Location := ieMemory;


       thread := TIEMultiProc_EX_Thread.Create;

       InitThread(thread, TIEMultiProc_EX_Overlap.create(tdIEBitmap, tdRect, rect(0,0,tdIEBitmap.Width-1, tdIEBitmap.Height-1),
                                                               -1, -1, true));

       setlength(fThreadHandles, length(fThreadHandles) + 1);
       fThreadHandles[high(fThreadHandles)] := thread.Handle;
       thread.Launch;
     end;
  end;

end;

function sorting(Item1, Item2: Pointer): Integer;
var
 ov1, ov2: TIEMultiProc_EX_Overlap;
 begin
 ov1 := TIEMultiProc_EX_Overlap(Item1);
 ov2 := TIEMultiProc_EX_Overlap(Item2);

  if ov1.DestRect.Top > ov2.DestRect.Top then
    result := 1
  else if ov1.DestRect.Top = ov2.DestRect.Top then
    result := 0
  else
    result := -1;
end;

procedure TIEMultiProc_EX.finishWithOverlaps;
var
  i: Integer;

  ov0, ov1, ov2: TIEMultiProc_EX_Overlap;

begin
  fFinishedObjects.Sort(sorting);

  if fOverlapMethod = omAddExtraPixels then
  begin
    for i := 0 to fFinishedObjects.count-1 do
    begin
       ov1 := TIEMultiProc_EX_Overlap(fFinishedObjects[i]);
       if i + 1 <= fFinishedObjects.count-1 then
         ov2 := TIEMultiProc_EX_Overlap(fFinishedObjects[i + 1])
       else
         ov2 := nil;

      MergeOverlapsMeth1(ov1, ov2)
    end;
  end
  else
  begin
    for i := 0 to fFinishedObjects.count-1 do
    begin
       ov1 := TIEMultiProc_EX_Overlap(fFinishedObjects[i]);

       if i - 1 >= 0 then
         ov0 := TIEMultiProc_EX_Overlap(fFinishedObjects[i - 1])
       else
         ov0 := nil;

       if i + 1 <= fFinishedObjects.count-1 then
         ov2 := TIEMultiProc_EX_Overlap(fFinishedObjects[i + 1])
       else
         ov2 := nil;

      if ov1.DeltaOv1 < 0 then
        MergeOverlapsMeth2_Secondary(ov0, ov1, ov2)
      else
        MergeOverlapsMeth2_Main(ov1, ov2, i = 0);
    end;
  end;

end;

procedure TIEMultiProc_EX.ClearOverlaps;
begin
  fFinishedObjects.Clear;
end;


procedure TIEMultiProc_EX.DoBlend(srcBmp1, srcBmp2: TIEBitmap; ydestTop, ydestBottom, dySrc1, dySrc2, blendDiv : integer);
var
  x, y: integer;
  blAmt1, blAmt2: byte;
  yt, yb: integer;
  xL, xR: integer;
  pDest, pSrc1, pSrc2: pbytearray;

  bD, bS, k, deltaByte: integer;

  ys1, ys2: integer;

  destBmp:TIEBitmap;
begin
  destBmp := fIEBitmap;

  if destBmp.PixelFormat = ie32RGB then
     deltaByte := 3
  else if destBmp.PixelFormat = ie24RGB then
     deltaByte := 2
  else //if destBmp.PixelFormat = ie8g then
     deltaByte := 0;



  yt := max(fEditRect.top, yDestTop);
  yb := min(yDestBottom , fEditRect.bottom);
  xL := fEditRect.left;
  xR := fEditRect.Right;

  for y := yt to yb do
  begin

    pDest := destBmp.scanline[y];

    ys1 := y + dySrc1;
    ys2 := y + dySrc2;

    {
    if ys1 < 0 then
    begin
      pSrc2 := srcBmp2.scanline[ys2];
      pSrc1 := pSrc2;
    end
    else if ys2 > srcbmp2.Height - 1 then
    begin
      pSrc1 := srcBmp1.scanline[ys1];
      pSrc2 := pSrc1;
    end
    else
    begin
      pSrc1 := srcBmp1.scanline[ys1];
      pSrc2 := srcBmp2.scanline[ys2];
    end;
    }

    if ys1 < 0 then
    begin
      pSrc2 := srcBmp2.scanline[ys2];
      pSrc1 := pSrc2;
    end
    else if ys1 > srcbmp1.Height - 1 then
    begin
      pSrc2 := srcBmp2.scanline[ys2];
      pSrc1 := pSrc2;
    end
    else
    begin
      pSrc1 := srcBmp1.scanline[ys1];
      pSrc2 := srcBmp2.scanline[ys2];
    end;



    blAmt2 := (255 * ys2) div blendDiv;
    blAmt1 := 255 - blAmt2;

    bD := (deltaByte + 1) * xL;
    bS := 0;
    for x := xL to xR do
    begin
       for k := 0 to deltaByte do
       begin
         pDest[bD] := (blAmt2 * pSrc2[bS] + blAmt1 * pSrc1[bS]) div 255;

         inc(bD);
         inc(bS);
       end;
    end;
  end;

end;


procedure TIEMultiProc_EX.MergeOverlapsMeth1(ov1, ov2: TIEMultiProc_EX_Overlap);
var
  yDestTop, yDestBottom: integer;
  dySrc1: integer;
  dySrc2: integer;
  aSrcRect: TIERectangle;
begin


  aSrcRect.x := 0;
  aSrcRect.y := ov1.DeltaOv1;
  aSrcRect.width := ov1.IEBitmap.Width;

  if ov2 = nil then
    aSrcRect.height := ov1.IEBitmap.Height - ov1.DeltaOv1 - ov1.DeltaOv2
  else
    aSrcRect.height := ov1.IEBitmap.Height - ov1.DeltaOv1 - ov1.DeltaOv2 - ov2.DeltaOv1;

  DrawIEBitmapToIeBitmap(ov1.IEBitmap, fIEBitmap, ov1.DestRect.Left, ov1.DestRect.top, aSrcRect);
//  ov1.IEBitmap.DrawToTIEBitmap(fIEBitmap, ov1.DestRect.Left, ov1.DestRect.top, aIERect);



  if ov2 = nil then EXIT;

  //blending
  yDestTop :=   ov1.DestRect.Bottom - ov2.DeltaOv1 + 1; //
  yDestBottom :=  yDestTop + ov2.DeltaOv1 + ov1.DeltaOv2 ;

  dySrc1 := ov1.IEBitmap.height - 1 - ov1.DeltaOv2 - ov2.deltaOv1 - yDestTop + 1; //
  dySrc2 := - yDestTop;


  DoBlend(ov1.IEBitmap, ov2.IEBitmap, yDestTop, yDestBottom, dySrc1, dySrc2, fOverlap);
//  DrawIEBitmapToIeBitmap(ov2.IEBitmap, fIEBitmap, ov2.DestRect.Left,yDestTop);
//   fIEBitmap.FillRect(0, ov1.DestRect.top,  100, ov1.DestRect.top + aIERect.height , clwhite);   //draw blue bands for testing
  // fIEBitmap.FillRect(100, yDestTop,  200, yDestBottom , clwhite);
end;





procedure TIEMultiProc_EX.MergeOverlapsMeth2_Main(ov1, ov2: TIEMultiProc_EX_Overlap; bIsFirst: boolean);
var
 aIERect: TIERectangle;
 dy: integer;
begin
  if bIsFirst then
    dy := 0
  else
    dy := fOverlap;

    aIERect.x := 0;
    aIERect.y := dy;
    aIERect.width := ov1.IEBitmap.Width;
    aIERect.height := max(0, ov1.IEBitmap.height - fOverlap);

    DrawIEBitmapToIeBitmap(ov1.IEBitmap, fIEBitmap, ov1.DestRect.Left, ov1.DestRect.top + dy, aIERect);
   // ov1.IEBitmap.DrawToTIEBitmap(fIEBitmap, ov1.DestRect.Left, ov1.DestRect.top + dy, aIERect);

  //  fIEBitmap.FillRect(0, aIERect.y,  500, aIERect.y + aIERect.height , clblue);   //draw blue bands for testing
end;



procedure TIEMultiProc_EX.MergeOverlapsMeth2_Secondary(ov0, ov1, ov2: TIEMultiProc_EX_Overlap);
var
  yDestTop, yDestBottom: integer;
  dySrc0, dySrc1, dySrc2: integer;
begin

  if ov0 <> nil then
  begin
       //blending
    yDestTop :=   ov0.DestRect.Bottom - fOverlap ;   //  + 1
    yDestBottom :=  ov0.DestRect.Bottom;

    dySrc0 := ov0.IEBitmap.height - 1 - fOverlap - yDestTop;
    dySrc1 := - yDestTop;

    DoBlend(ov0.IEBitmap, ov1.IEBitmap, yDestTop, yDestBottom, dySrc0, dySrc1, fOverlap);

   // fIEBitmap.FillRect(400, yDestTop,  800, yDestBottom, clred);   //draw red bands for testing
   // fIEBitmap.FillRect(1100, yDestTop,  1400, yDestBottom, clred);   //draw red bands for testing
  end;

  if ov2 <> nil then
  begin
     //blending
    yDestTop :=   ov1.DestRect.Bottom - fOverlap + 1;
    yDestBottom :=  ov1.DestRect.Bottom ;

    dySrc1 := ov1.IEBitmap.height  - fOverlap - yDestTop;
    dySrc2 := - yDestTop;

    DoBlend(ov1.IEBitmap, ov2.IEBitmap, yDestTop, yDestBottom, dySrc1, dySrc2, fOverlap);

   // fIEBitmap.FillRect(400, yDestTop,  800, yDestBottom, clyellow); //draw yellow bands for testing
  end;

end;




procedure TIEMultiProc_EX.HandleThreadFinish(sender: TObject);
var
thread: TIEMultiProc_EX_Thread;
begin


  fThreadCS.Enter;
  try

    thread := TIEMultiProc_EX_Thread(sender);

    if fAborted then
    begin
      thread.OvObj.free;
    end
    else
    begin
      if (thread.OvObj.DeltaOv1 = 0) and (thread.OvObj.DeltaOv2 = 0) then   //no overlaps
      begin
        DrawIEBitmapToIeBitmap(thread.OvObj.IEBitmap, fIEBitmap, thread.OvObj.destRect.Left, thread.OvObj.destRect.top);
       // thread.OvObj.IEBitmap.DrawToTIEBitmap(fIEBitmap, thread.OvObj.destRect.Left, thread.OvObj.destRect.top);
        thread.OvObj.free;
      end
      else
        fFinishedObjects.add(thread.OvObj);
    end;
  finally
    fThreadCS.Leave;
  end;
end;


procedure TIEMultiProc_EX.Abort;
begin
  fAborted := true;
end;

procedure TIEMultiProc_EX.AddProgress(theSender: TObject; Perc:integer);
var
  I: Integer;
  bFound: boolean;
begin
  bFound := false;
  for I := 0 to fListOfSenders.count-1 do
  begin
    if TIEMultiProc_EX_Sender(fListOfSenders[i]).sender = theSender then
    begin
      bFound := True;
      TIEMultiProc_EX_Sender(fListOfSenders[i]).perc := perc;
      break;
    end;
  end;

  if bFound then EXIT;

  fListOfSenders.add(TIEMultiProc_EX_Sender.Create(theSender, perc));

end;

function TIEMultiProc_EX.GetOveralPercentProgress: integer;
var
  I: Integer;
begin
  result := 0;
  if fListOfSenders.Count = 0 then EXIT;

  for I := 0 to fListOfSenders.Count-1 do
    result := result + TIEMultiProc_EX_Sender(fListOfSenders[i]).Perc;

  result := result div fListOfSenders.Count;
end;

procedure TIEMultiProc_EX.HandleThreadProgress(sender:TObject; per:integer);
begin
  if Assigned(fOnProgress) and((per = 100)or(GetTickCount - fProgressTk > 100)) then
  begin
    fThreadCS.Enter;
    try
      if fDoingProgress = false then
      begin
        AddProgress(sender, per);
        fDoingProgress := true;
        fProgressTk := GetTickCount;
      end;
    finally
      fThreadCS.Leave;
    end;
  end;

end;

{ TOverlappedIEBitmap }

constructor TIEMultiProc_EX_Overlap.Create(theIEBitmap: TIebitmap;
                                           theDestRect: TRect;
                                           theSrcRect:TRect;
                                           theDeltaOv1, theDeltaOv2: integer;
                                           bOwnBmp: boolean);
begin
  fIEBitmap := theIEBitmap;
  fdestRect := theDestRect;
  fSrcRect := theSrcRect;
  fDeltaOv1 := theDeltaOv1;
  fDeltaOv2 := theDeltaOv2;
  fOwnBmp := bOwnBmp;
end;

destructor TIEMultiProc_EX_Overlap.Destroy;
begin

  if fOwnBmp and assigned(fIEBitmap)  then
    fIEBitmap.free;

    inherited Destroy;
end;

{ TIEMultiProc_EX_Sender }

constructor TIEMultiProc_EX_Sender.Create(theSender: TObject; thePerc: integer);
begin
  fSender := theSender;
  fPerc := thePerc;
end;



end.
