unit umain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, syncobjs,
  hyiedefs, hyieutils, iesettings, iexBitmaps, ImageEnIO, ieopensavedlg, iexwindowsfunctions,
  NWSComps_StyleEngine, NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs,
  NWSComps_ThumbsBrowser_Utils_Types, Vcl.Buttons, iemio, iemview;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    TB1: TThumbsBrowser;
    ButtonOpen: TBitBtn;
    Panel2: TPanel;
    btnDeleteRec: TBitBtn;
    btnInsertRecord: TBitBtn;
    OpenImageEnDialog1: TOpenImageEnDialog;
    rgpAsync: TRadioGroup;
    ButtonSave: TBitBtn;
    SaveImageEnDialog1: TSaveImageEnDialog;
    ProgressBar1: TProgressBar;
    IOVideo1: TImageEnIO;
    LabelFrameSize: TLabel;
    rgpWantOrigSize: TRadioGroup;
    LabelFileType: TLabel;
    LabelLoadingstatus: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TB1ThumbLoadDemand(theThumb: TThumbEx; const Idx: Integer);
    procedure TB1ThumbLoadDemandAsync(Sender: TThread; theThumb: TThumbEx);
    procedure ButtonOpenClick(Sender: TObject);
    procedure rgpAsyncClick(Sender: TObject);
    procedure btnDeleteRecClick(Sender: TObject);
    procedure btnInsertRecordClick(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure TB1Progress(Sender: TObject; per: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure TB1ThumbBufferLoaded(theThumb: TThumbEx; const bufWidth, bufHeight: Integer; var bResizeBuffer: Boolean;
      var newbufWidth, newbufHeight: Integer);
    procedure rgpWantOrigSizeClick(Sender: TObject);
    procedure TB1finishedLoading(Sender: TObject);
    procedure TB1StartedLoading(Sender: TObject);
    procedure TB1ThumbLoaded(theThumb: TThumbEx; const Idx: Integer);

  private
    fOriginalSize: Boolean;
    fFileIsVideo: Boolean;
    fFilename: string;
    fFileType: Integer;
    fVideoCS: TCriticalSection;
    fFrameSize: TSize;
    fLoadedCount: integer;
    procedure OpenMultipicFile;
    procedure GetFrame(theThumb: TThumbEx);
    procedure SetAsyncMode;
    function GimmeStoreType: TTB_Thumb_StoreType;
    procedure UpdateLoadingLabel;

    { Private declarations }

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses NWSComps_Thumbsbrowser_Shell_Utils, shlobj;

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  fVideoCS := TCriticalSection.create;
  SetAsyncMode;
  fFilename := '';
  fFileType := ioUnknown;
  fOriginalSize := bool(rgpWantOrigSize.itemindex);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fVideoCS.free;
  IOVideo1.CloseAVIFile;
  IOVideo1.CloseMediaFile;
end;

procedure TMainForm.ButtonOpenClick(Sender: TObject);
begin
  OpenImageEnDialog1.Options := OpenImageEnDialog1.Options - [ofAllowMultiSelect];
  if OpenImageEnDialog1.Execute then
  begin
    fFilename := OpenImageEnDialog1.filename;
    OpenMultipicFile; // fill thumbsbrowser with frames from file
  end;
  OpenImageEnDialog1.Options := OpenImageEnDialog1.Options + [ofAllowMultiSelect];
end;

procedure TMainForm.ButtonSaveClick(Sender: TObject);
begin
  if (TB1.ThumbsCount = 0) then
    raise Exception.create('No File to Save');

  if not SaveImageEnDialog1.Execute then
    EXIT;

  TB1.ExportToMultiFileFormat(IfNo_condition, SaveImageEnDialog1.filename, false, TB1Progress);
end;

procedure TMainForm.OpenMultipicFile;
var
  aThumb: TBrowserThumb;
  NFrames: Integer;
  I: Integer;
begin
  TB1.ClearThumbs;
  TB1.LockUpdate; // lock update otherwise adding thousands of thumbs will be very slow
  fVideoCS.Enter;
  try
    IOVideo1.CloseMediaFile;
    IOVideo1.CloseAVIFile;

    fFileType := FindFileFormat(fFilename, ffFallbackToExtension);
    if fFileType = ioUnknown then
    begin
      if comparetext(extractfileext(fFilename), '.wmv') = 0 then // if is not listed in imageen formats
        fFileType := ioWMV
      else if comparetext(extractfileext(fFilename), '.mpg') = 0 then // if is not listed in imageen formats
        fFileType := ioMPEG
      else if comparetext(extractfileext(fFilename), '.wmf') = 0 then // if is not listed in imageen formats
        fFileType := ioWMF
      else
        raise Exception.create('Unknown Format');
    end;

    case fFileType of
      ioWMF, ioAVI, ioWMV, ioMPEG:
        fFileIsVideo := TRUE;
    else
      fFileIsVideo := false;
    end;

    if fFileIsVideo then
      LabelFileType.Caption := '[VIDEO]'
    else
      LabelFileType.Caption := '[MULTI-PIC]';

    LabelFileType.Caption := LabelFileType.Caption + ' - ' + extractfileext(fFilename);

    if fFileIsVideo then
      IOVideo1.OpenMediaFile(fFilename);

    fFrameSize.cx := 0;
    fFrameSize.cy := 0;
    NFrames := IEGetFileFramesCount(fFilename); // get number of frames
    for I := 0 to NFrames - 1 do // add each frame as a thumb to browser
      with TB1.Add_a_Thumb do
      begin
        UserTag := I;
        StoreType := GimmeStoreType;
        Captions.SetCaption('Frame ' + inttostr(I), cap_other1);
      end;
  finally
    fVideoCS.leave;
    TB1.UnlockUpdateEX;
    TB1.ReloadThumbs; // reload .. (needed in case of async loading)
    TB1.Update;
  end;

end;

function TMainForm.GimmeStoreType: TTB_Thumb_StoreType;
begin
  if rgpWantOrigSize.itemindex = 0 then
    result := tbstore_Thumb // if we want to store a resized image of the frame
  else
    result := tbstore_FullImage; // if we want to store the full frame image
end;

procedure TMainForm.GetFrame(theThumb: TThumbEx);
var
  ms: TMemoryStream;
  aIo: TImageEnIO;
  Idx: Integer;
begin
  if theThumb.Adjourned then
    EXIT;

  Idx := theThumb.UserTag;
  if Idx < 0 then
    EXIT; // frame was added through insert

  if fFileIsVideo then
  begin
    //in case of video we use just one TImageenio and a Critical Section
    fVideoCS.Enter;   //enter the Critical Section
    IOVideo1.AttachedIEBitmap := theThumb.IEBitmap;
    try
      assert(fFileIsVideo);
      IOVideo1.LoadFromMediaFile(Idx);  //load the frame at index Idx
    finally
      fVideoCS.leave;  //leave the Critical Section
    end;
    theThumb.RetrieveFromIEBitmap(theThumb.IEBitmap); //retrieve the thumb from its own IEBitmap
  end
  else
  begin
    //if not a video we create a separate TImageenio for each frame to load
    aIo := TImageEnIO.create(nil);
    aIo.AttachedIEBitmap := theThumb.IEBitmap;
    try
      aIo.Params.ImageIndex := Idx;
      aIo.LoadFromFile(fFilename); //load the frame at index Idx
      theThumb.RetrieveFromIEBitmap(theThumb.IEBitmap); //retrieve the thumb from its own IEBitmap
    finally
      aIo.free;
    end;
  end;
end;


  // in case of videos we handle this event so that when we add new frames
  // they will be adapted to the frame size of the video automatically
procedure TMainForm.TB1ThumbBufferLoaded(theThumb: TThumbEx; const bufWidth, bufHeight: Integer;
  var bResizeBuffer: Boolean; var newbufWidth, newbufHeight: Integer);
var
  copyBmp: TIEBitmap;
  w, h: Integer;
  src, dest: TIERectangle;
begin
  if not fFileIsVideo then
    EXIT;   //if not a video we do not need to do this
  if theThumb.UserTag <> -1 then   // if frame belongs to original video exit (nothing to do)
    EXIT;

  if (bufWidth = newbufWidth) and (bufHeight = newbufHeight) then
    EXIT;   //if frame already of desired dimensions then exit

  bResizeBuffer := false;

  copyBmp := TIEBitmap.create(theThumb.IEBitmap);
  theThumb.IEBitmap.Resize(newbufWidth, newbufHeight, 0); //resize
  theThumb.IEBitmap.fill(rgb(0, 0, 0));   //and fill the frame with black background
  try
    if copyBmp.width / copyBmp.height > newbufWidth / newbufHeight then
    begin
      w := newbufWidth;
      h := round(copyBmp.height / copyBmp.width * w);
    end
    else
    begin
      h := newbufHeight;
      w := round(copyBmp.width / copyBmp.height * h);
    end;
    src := ierectangle(0, 0, copyBmp.width, copyBmp.height);
    dest := ierectangle((newbufWidth - w) div 2, (newbufHeight - h) div 2, w, h);
    copyBmp.DrawToTIEBitmap(theThumb.IEBitmap, dest, src);  //copy frame to destination rect
  finally
    copyBmp.free;
  end;
end;


// Get the Frame from the LoadDemand event (sync mode)
procedure TMainForm.TB1ThumbLoadDemand(theThumb: TThumbEx; const Idx: Integer);
begin
  GetFrame(theThumb);
end;

// Get the Frame from the LoadDemand event (Async mode)
procedure TMainForm.TB1ThumbLoadDemandAsync(Sender: TThread; theThumb: TThumbEx);
begin
  if TThumbsBrowser_Thumb_LoadThread(Sender).aborted then
    EXIT;

  GetFrame(theThumb);
end;

procedure TMainForm.TB1ThumbLoaded(theThumb: TThumbEx; const Idx: Integer);
begin
 if (fFrameSize.cx <> theThumb.IEBitmap.width) or (fFrameSize.cy <> theThumb.IEBitmap.height) then // saves frame size
  begin
    fFrameSize.cx := theThumb.IEBitmap.width;
    fFrameSize.cy := theThumb.IEBitmap.height;
    if fOriginalSize then
      LabelFrameSize.Color := clgreen
    else
      LabelFrameSize.Color := clYellow;
    LabelFrameSize.Caption := 'Frame Size: ' + #13#10 + inttostr(fFrameSize.cx) + ' X ' + inttostr(fFrameSize.cy);
  end;
  inc(fLoadedCount);
  UpdateLoadingLabel;
end;

// set which mode we want for loading the file
procedure TMainForm.SetAsyncMode;
begin
  TB1.StopBrowsing;
  TB1.OnThumbLoadDemandAsync := nil;
  TB1.OnThumbLoadDemand := nil;
  if rgpAsync.itemindex = 0 then
  begin
    TB1.OnThumbLoadDemand := TB1ThumbLoadDemand; // sync mode
    TB1.RefreshDisplay; // refresh display will trigger the sync loading
  end
  else
  begin
    TB1.OnThumbLoadDemandAsync := TB1ThumbLoadDemandAsync; // async mode
    TB1.ReloadThumbs; // reloadthumbs will trigger async loading
  end;
end;

procedure TMainForm.rgpAsyncClick(Sender: TObject);
begin
  SetAsyncMode;
end;

procedure TMainForm.rgpWantOrigSizeClick(Sender: TObject);
var
  I: Integer;
begin
  if fOriginalSize <> bool(rgpWantOrigSize.itemindex) then
  begin
   fOriginalSize := bool(rgpWantOrigSize.itemindex);
    if fFilename <> '' then
    begin
      TB1.StopBrowsing;
      fLoadedCount := 0;
      fFrameSize.cx := 0;
      fFrameSize.cy := 0;

      TB1.LockUpdate;
      try
        for I := 0 to TB1.ThumbsCount - 1 do
          TB1.Thumbat(I).StoreType := GimmeStoreType; // change store type for all thumbs
      finally
        TB1.UnlockUpdateEX;
        TB1.ReloadThumbs; // reload ..
        TB1.Update;
      end;
    end;
  end;
end;



procedure TMainForm.btnDeleteRecClick(Sender: TObject);
begin
  TB1.ClearThumbs_Selected;
end;

procedure TMainForm.btnInsertRecordClick(Sender: TObject);
var
  sName: string;
  Idx: Integer;
  aThumb: TBrowserThumb;
  I: Integer;
begin
  if OpenImageEnDialog1.Execute = false then
    EXIT;

  TB1.LockLoading; // this ensure the loading will not occur until we add all frames
  TB1.LockUpdate;
  try
    for I := 0 to OpenImageEnDialog1.Files.count - 1 do
    begin
      // Add thumb to Browser
      aThumb := TB1.Add_a_Thumb(OpenImageEnDialog1.Files[I], nil, TB1.SelectedIndex); // added always in async mode
      aThumb.UserTag := -1; // this means the frame is not in the original multipic file

      if fFileIsVideo and (not fFrameSize.IsZero) then
      begin
        aThumb.StoreType := tbstore_Thumb;
        aThumb.SizeOffScreenW := fFrameSize.cx;
        aThumb.SizeOffScreenH := fFrameSize.cy;
      end
      else if (rgpWantOrigSize.itemindex = 0) then
        aThumb.StoreType := tbstore_Thumb
      else
        aThumb.StoreType := tbstore_FullImage;

      // Assign a name
      sName := ChangeFileExt(ExtractFilename(OpenImageEnDialog1.Files[I]), '');
      aThumb.Captions.SetCaption(sName, cap_General);
      aThumb.Captions.SetCaption('New Frame', cap_other1);
      if I = OpenImageEnDialog1.Files.count - 1 then
        TB1.GotoThumb(aThumb, false); // goto last inserted thumb
    end;
  finally
    TB1.UnlockUpdate;
    TB1.UnLockLoading;
  end;

  TB1.ReloadThumbs; // this will start loading the thumb just added
end;


procedure TMainForm.TB1finishedLoading(Sender: TObject);
begin
  LabelLoadingstatus.caption := 'FINISHED: All Frames Loaded (' + inttostr(tb1.thumbscount) + ' Frames)';
end;

procedure TMainForm.TB1Progress(Sender: TObject; per: Integer);
begin
  ProgressBar1.Position := per;
end;

procedure TMainForm.UpdateLoadingLabel;
begin
  if tb1.ThumbsCount = 0 then
    LabelLoadingstatus.caption := ''
  else
    LabelLoadingstatus.caption := 'Loaded '+ inttostr(fLoadedCount) + ' of ' + inttostr(tb1.thumbscount) + ' Frames...';

  LabelLoadingstatus.Update;
end;

procedure TMainForm.TB1StartedLoading(Sender: TObject);
begin
  fLoadedCount := 0;
  UpdateLoadingLabel;
end;

end.
