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
unit NWSComps_ThumbsBrowser_info;

interface
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, ComCtrls, contnrs, Buttons,
  hyieutils, hyiedefs,
  iexBitmaps, // {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF}
              //the Delphi IDE keeps adding its own clause despite the directive.
              //please comment-out iexBitmaps manually if you encounter an error here
              // (with ie version < 6.2)
  iesettings, ieview, imageenview,
  imageenio, iewia,
  {$IFDEF TB_PORTABLEDEVICE}
  iexWPD,
  {$ENDIF}
  NWSComps_ThumbsBrowser_Thumbs, NWSComps_ThumbsBrowser_LoadPicThread,
  NWSComps_ThumbsBrowser_Utils_Types,
  NWSComps_ThumbsBrowser_ExifIptc;



   {$IFNDEF IMAGEEN_6_2_LATER}
   type
   TIOParams =  TIOParamsVals;
   {$ENDIF}


  type
  TThumbsbrowser_InfoForm_Status = record
   W, H, SplitInfoWidth: integer;
   Defined: boolean;
  end;

  TThumbsbrowser_InfoForm = class(TForm)
    Panel_Form: TPanel;
    Panel3: TPanel;
    Panel_Fileinfo: TPanel;
    Bevel1: TBevel;
    Label_Location: TLabel;
    Panel2: TPanel;
    Label_FSize: TLabel;
    Label_FDate: TLabel;
    Panel_save: TPanel;
    Button_save: TBitBtn;
    Panel_EditName: TPanel;
    Edit_FileName: TEdit;
    Panel1: TPanel;
    Panel4: TPanel;
    PageControl_MultiPics: TPageControl;
    button_AddMetaTags_Exif: TBitBtn;
    button_AddMetaTags_Iptc: TBitBtn;
    PanelBottom: TPanel;
    Panel_info: TPanel;
    Panel_exif: TPanel;
    ExifIptcPanel1: TThumbsBrowser_ExifIptcPanel;
    Panel_preview: TPanel;
    IEPreview: TImageEnView;
    ProgressBar1: TProgressBar;
    Splitter1: TSplitter;
    Bevel2: TBevel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_saveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit_FileNameChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ExifIptcPanel1Modified(sender: TObject;
      theField: TThumbsbrowser_MetaData_Field);
    procedure button_AddMetaTags_ExifClick(Sender: TObject);
    procedure button_AddMetaTags_IptcClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ExifIptcPanel1FileInfoSaved(sender: TObject;
      theFileRcd: TThumbsbrowser_MetaData_FileRcd);
    procedure btnVideoPlayClick(Sender: TObject);
    procedure IEPreviewDShowNewFrame(Sender: TObject);
    procedure IEPreviewMouseEnter(Sender: TObject);
    procedure IEPreviewMouseLeave(Sender: TObject);
    procedure IEPreviewDShowEvent(Sender: TObject);
  private
    { Private declarations }



    fColor_Disabled, fColor_Enabled: TColor;

    //fReadingSettings: boolean;
    fGuiLocked: integer;

    fItemidx: integer;
    fFileName: string;
    fFileIO: TImageEnio;
    fIsWIA: boolean;
    fIsWPD: boolean;
    fIsUrl: boolean;

    fBrowserWIA_IO: TImageEnio;
    fWIA_Item: TIEWIAItem;
    fWPDObjID: string;

    {$IFDEF TB_PORTABLEDEVICE}
    fBrowserWPD: TIEPortableDevices;
    {$ENDIF}

    fISVideo: boolean;

    fLoading: boolean;

    fEditStatus: TTB_Browser_InfoDlg_EditStatus;
    fmode: TTB_Browser_InfoDlg_Mode;

    fFiles: TThumbsbrowser_MetaData_FileRcds;
    fMetaOptions: TThumbsbrowser_MetaData_Options;
    floadThread: TThumbsBrowser_LoadPicThread;

    procedure AbortLoadingPic;

    procedure Handle_PageControl_MultiPics_Change(sender: TObject);
    procedure Handle_PicLoaded(theiebitmap:tiebitmap;thefilename:string);
    procedure Handle_Progress(Sender: TObject; per: integer);

    procedure CurrentFile_Preview;

    procedure CurrentFile_Preview_PC;
    procedure CurrentFile_Preview_WIA;



    procedure CurrentFile_GetInfo;
    procedure CurrentFile_GetInfo_PC;
    procedure CurrentFile_GetInfo_WIA;

    {$IFDEF TB_PORTABLEDEVICE}
     procedure CurrentFile_Preview_WPD;
     procedure CurrentFile_GetInfo_WPD;
    {$ENDIF}


    procedure DoSave;
    procedure CurrentFile_DoRename;
    procedure CurrentFile_DoSave_Exif;

    procedure CurrentFile_Get(bGetInfo, bGetPic: boolean);
    procedure CurrentFile_GetInfo_General;

    function GUILocked: boolean;
    procedure GUI_Reset;
    procedure GUI_Check;
    procedure GUI_Lock;
    procedure GUI_UnLock;

    function GetFileRcd(idx: integer): TThumbsbrowser_MetaData_FileRcd;
    function GetCurRcd: integer;

    function MyExtractFileName(theFileName: string): string;
    procedure FitPic;
    function IsMultiPic: boolean;
    procedure CreateTabs;
    procedure VideoTogglePlay;
    procedure VideoDisconnect;
    procedure InitLoading;

    property FileRcd[idx:integer]: TThumbsbrowser_MetaData_FileRcd read GetFileRcd;
    property CurRcd: integer read GetCurRcd;
  public
    { Public declarations }
    OnSaveFileMetadata: TTB_Browser_OnFileModified;
    OnAcceptFilenameChange: TTB_Browser_OnItemFileNameChanged;
    OnClose: TnotifyEvent;

    FormStatus: TThumbsbrowser_InfoForm_Status;

    property Mode: TTB_Browser_InfoDlg_Mode read fmode;

    procedure Launch_FromSingleFile(theFileName: string;
      theTags: TThumbsbrowser_MetaTags;
      theMetaOptions: TThumbsbrowser_MetaData_Options;
      HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);

    procedure Launch_FromMultipleFiles(theFileList: TStringlist;
      theTags: TThumbsbrowser_MetaTags;
      theMetaOptions: TThumbsbrowser_MetaData_Options;
      HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);

    procedure Launch_Single(theThumb:TThumbEX;
                     idx: integer;
                     theWIAIO: TObject;  //object reference to the wia Timageenio in the browser
                     theWPD: TObject;    //object reference to the WPD TIEPortabledevices in the browser
                     theTags: TThumbsbrowser_MetaTags;
                     theMetaOptions: TThumbsbrowser_MetaData_Options;
                     HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);

    procedure Launch_Multi(theThumbs: TList;
                           theWIAIO: TObject; //object reference to the wia Timageenio in the browser
                           theWPD: TObject;   //object reference to the WPD TIEPortabledevices in the browser
                          theTags: TThumbsbrowser_MetaTags;
                     theMetaOptions: TThumbsbrowser_MetaData_Options;
                     HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);

    procedure ApplyFormStatus(value: TThumbsbrowser_InfoForm_Status);
  end;

implementation

uses filectrl, ieds, NWSComps_ThumbsBrowser_Shell_Utils,
    NWSComps_ThumbsBrowser_utils, NWSComps_ThumbsBrowser_RES, NWSComps_ThumbsBrowser_RES_CONST;


{$R *.DFM}

procedure TThumbsbrowser_InfoForm.FormCreate(Sender: TObject);
begin
  FormStatus.Defined := False;
  fColor_Disabled := rgb(232,232,232);
  fColor_Enabled := rgb(255,255,255);
  button_AddMetaTags_Exif.ShowHint := true;
  button_AddMetaTags_Exif.Hint := TBResStr[IDRS_INFOFORM_HINT_ADDEXIFINFO];
  button_AddMetaTags_Iptc.ShowHint := true;
  button_AddMetaTags_Iptc.Hint := TBResStr[IDRS_INFOFORM_HINT_ADDIPTCINFO];


  //fReadingSettings := False;
  fGuiLocked := 0;

  fFiles := TThumbsbrowser_MetaData_FileRcds.create;

  fItemidx := -1;
  fFileName := '';
  fFileIO := TImageenio.Create(nil);
  fLoading := false;

  fmode := [tbi_editname, tbi_info, tbi_preview];
  fEditStatus := [];

  Button_save.Caption := TBResStr[IDRS_INFOFORM_BTNSAVE];
  button_AddMetaTags_Exif.Caption := TBResStr[IDRS_INFOFORM_BTNADDEXIF];
  button_AddMetaTags_Iptc.Caption  := TBResStr[IDRS_INFOFORM_BTNADDIPTC];
end;


procedure TThumbsbrowser_InfoForm.FormDestroy(Sender: TObject);
begin
  AbortLoadingPic;
  freeandnil(fFiles);
  freeandnil(fFileIO);

end;


procedure TThumbsbrowser_InfoForm.CurrentFile_DoSave_Exif;
begin
   ExifIptcPanel1.SaveModifiedInfo;
end;





procedure TThumbsbrowser_InfoForm.CurrentFile_DoRename;
var
newname:string;
begin
  if not (tbiEdited_FileName in fEditStatus) then  EXIT;


    newname :=  extractfilepath(fFileName)+ changefileext(Edit_FileName.text,'')+ extractfileext(fFilename);
    if newname<>ffilename then
    begin
      renamefile(ffilename,newname);

      if assigned(OnAcceptFilenameChange) then
        OnAcceptFilenameChange(ffilename, newname);

      ffilename := newname;
      FileRcd[CurRcd].RenameFile(newname);
      if currcd>=0 then
        PageControl_MultiPics.pages[PageControl_MultiPics.ActivePageIndex].Caption := MyExtractFileName(newname);

    end;

end;

procedure TThumbsbrowser_InfoForm.IEPreviewDShowEvent(Sender: TObject);
var
  event: integer;
begin
  with iepreview.IO.DShowParams do
    if Connected then
      while GetEventCode(event) do
        case event of
          IEEC_COMPLETE:
            Disconnect;
        end;

end;

procedure TThumbsbrowser_InfoForm.IEPreviewDShowNewFrame(Sender: TObject);
begin
  with iepreview do
  begin
    IO.DShowParams.GetSample(IEBitmap);
    Update;
  end;
end;

procedure TThumbsbrowser_InfoForm.IEPreviewMouseEnter(Sender: TObject);
begin
  if fISVideo then
  begin
    if IEPreview.IO.DShowParams.State <> gsRunning then
      VideoTogglePlay;
  end;
end;

procedure TThumbsbrowser_InfoForm.IEPreviewMouseLeave(Sender: TObject);
begin
  if fISVideo then
  begin
    if IEPreview.IO.DShowParams.State = gsRunning then
      VideoTogglePlay;
  end;
end;

procedure TThumbsbrowser_InfoForm.InitLoading;
begin
  if fLoading then
    AbortLoadingPic;
end;

function TThumbsbrowser_InfoForm.IsMultiPic: boolean;
begin
  result := ffiles.Count>1;
end;




procedure TThumbsbrowser_InfoForm.DoSave;
begin

    CurrentFile_DoSave_Exif;

    if CurRcd >=0 then
      CurrentFile_DoRename;

    fEditStatus := [];
    CurrentFile_Get(true, false);
    GUI_Check;


end;

procedure TThumbsbrowser_InfoForm.AbortLoadingPic;
begin

  if assigned(floadThread) then
    floadThread.abort;

  fLoading := false;
end;



procedure TThumbsbrowser_InfoForm.btnVideoPlayClick(Sender: TObject);
begin
  VideoTogglePlay;
  GUI_Check;
end;

procedure TThumbsbrowser_InfoForm.button_AddMetaTags_ExifClick(Sender: TObject);
var
  aio:TImageenio;
begin
 if CurRcd=-1 then EXIT;

 aIo := timageenio.Create(nil);
 try
   aio.ParamsFromFile(ffilename);
   if TBMetadataCanWriteToFile(ffilename, aio.params, true) then
   begin
     aio.Params.EXIF_HasEXIFData := true;
     if tbs_FileExtIsJPG(extractfileext(ffilename)) then
     begin
       if aio.InjectJpegEXIF(ffilename) then
         FileRcd[currcd].HasExif := true; // aio.Params.EXIF_HasEXIFData;
     end
     else if tbs_FileExtIsTif(extractfileext(ffilename)) then
     begin
       if aio.InjectTIFFEXIF(ffilename) then
         FileRcd[currcd].HasExif := true;
     end;
   end
   else
   begin
     ShowMessage(TBResStr[IDRS_INFOFORM_ERROR_CANNOTWRITEMETA]);
     EXIT;
   end;


 finally
   aIo.free;
 end;
 CurrentFile_Get(true, false);
 GUI_Check;

end;

procedure TThumbsbrowser_InfoForm.button_AddMetaTags_IptcClick(Sender: TObject);
begin
 if CurRcd=-1 then EXIT;

 GetFileRcd(currcd).HasIptc := true;
 ExifIptcPanel1.UpdateInfo;
 GUI_Check;
end;

procedure TThumbsbrowser_InfoForm.CurrentFile_Get(bGetInfo, bGetPic: boolean);
begin

    fItemidx := -1;

    fIsWIA := false;
    fWIA_Item := nil;

    fIsWPD := false;


    fIsVideo := false;

    if IsmultiPic and (PageControl_MultiPics.ActivePageIndex = 0) then
    begin
      fEditStatus := [];
      ffilename := '';
    end
    else
    begin
      fEditStatus := fEditStatus - [tbiEdited_FileName];
      ffilename := Filercd[CurRcd].FileName;
      fIsWia := Filercd[CurRcd].IsWia;
      fIsWPD := Filercd[CurRcd].IsWPD;
      fWIA_Item := Filercd[CurRcd].WiaItem;
      fWPDObjID := Filercd[CurRcd].WPDObjectID;
      fIsUrl := Filercd[CurRcd].IsUrl;
      fIsVideo := tbs_FileExtIsVIDEO(extractfileext(fFileName));
    end;

    if bgetinfo then
      CurrentFile_GetInfo;

    if bgetpic then
      CurrentFile_Preview;


  GUI_Check;
end;

function TThumbsbrowser_InfoForm.MyExtractFileName(theFileName:string):string;
begin
  if tbs_UrlIsValidUrl(thefilename) then
    result := tbs_UrlExtractFilename(theFilename, true)
  else
    result := ExtractFileName(thefilename);
end;


procedure TThumbsbrowser_InfoForm.Launch_FromSingleFile(theFileName:string;
                                                        theTags: TThumbsbrowser_MetaTags;
                                                        theMetaOptions: TThumbsbrowser_MetaData_Options;
                                                        HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);
var
aIo:TImageenio;
aRcd: TThumbsbrowser_MetaData_FileRcd;
begin
  InitLoading;
  fMetaOptions := theMetaOptions;
  fFiles.clear;
  aIo := TImageenio.create(nil);
  try
    aIo.ParamsFromFile(theFilename);
    aRcd := TThumbsbrowser_MetaData_FileRcd.create(theFileName,
                                                   false,
                                                   false,
                                                   false,
                                                   aio.Params.EXIF_HasEXIFData,
                                                   aio.Params.IPTC_Info.Count > 0,
                                                   aio.Params.DICOM_Tags.Count > 0,
                                                   aio.Params.XMP_Info <>'',
                                                   aio.Params.EXIF_Orientation,
                                                   nil, '');
    fFiles.Add(aRcd);
  finally
    aIo.free;
  end;



  ExifIptcPanel1.OnMetadataVisibility := HandleMetadataVisibility;
  ExifIptcPanel1.AssignData(theTags, fFiles);
  CreateTabs;

  if self.visible then
    self.BringToFront
  else
    show;

  CurrentFile_Get(true, true);
end;


procedure TThumbsbrowser_InfoForm.Launch_FromMultipleFiles(theFileList: TStringlist;
                                                        theTags: TThumbsbrowser_MetaTags;
                                                        theMetaOptions: TThumbsbrowser_MetaData_Options;
                                                        HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);
var
aIo:TImageenio;
aRcd: TThumbsbrowser_MetaData_FileRcd;
  I: Integer;
begin
  InitLoading;
  fMetaOptions := theMetaOptions;
  fFiles.clear;
  aIo := TImageenio.create(nil);
  try
    for I := 0 to theFilelist.count-1 do
    begin
      aIo.ParamsFromFile(theFilelist[i]);
      aRcd := TThumbsbrowser_MetaData_FileRcd.create(theFilelist[i],
                                                     false,
                                                     false,
                                                     false,
                                                     aio.Params.EXIF_HasEXIFData,
                                                     aio.Params.IPTC_Info.count>0,
                                                     aio.Params.DICOM_Tags.Count > 0,
                                                     aio.Params.XMP_Info <>'',
                                                     aio.Params.EXIF_Orientation,
                                                     nil, '');
      fFiles.Add(aRcd);
    end;
  finally
    aIo.free;
  end;

  ExifIptcPanel1.OnMetadataVisibility := HandleMetadataVisibility;
  ExifIptcPanel1.AssignData(theTags, fFiles);
  CreateTabs;

  if self.visible then
    self.BringToFront
  else
    show;

  CurrentFile_Get(true, true);
end;


procedure TThumbsbrowser_InfoForm.Launch_Single(theThumb:TThumbEX;
                                         idx: integer;
                                         theWIAIO: TObject;
                                         theWPD: TObject;
                                         theTags: TThumbsbrowser_MetaTags;
                                         theMetaOptions: TThumbsbrowser_MetaData_Options;
                                         HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);
var
wpdObjId: string;
begin
  InitLoading;
  fMetaOptions := theMetaOptions;
  fBrowserWIA_IO := TImageenio(theWiaIo);
  {$IFDEF TB_PORTABLEDEVICE}
    fBrowserWPD := TIEPortableDevices(theWPD);
    wpdObjId := theThumb.AttachedWPDInfo.Rcd.id;
  {$ELSE}
     wpdObjId := '';
  {$ENDIF}
  fFiles.clear;
  fFiles.Add(TThumbsbrowser_MetaData_FileRcd.create(theThumb.SourceFileName,
                                                   theThumb.SourceType = st_URL,
                                                   theThumb.SourceType = st_WIA,
                                                   theThumb.SourceType = st_WPDFile,
                                                   theThumb.SourceHasExif,
                                                   theThumb.SourceHasIPTC,
                                                   theThumb.SourceHasDICOM,
                                                   theThumb.SourceHasXmp,
                                                   theThumb.SourceExif_Orientation,
                                                   theThumb.AttachedWIAItem, wpdObjId,
                                                   (theThumb.StoreType = tbstore_FullImage) and (theThumb.Adjourned),
                                                   theThumb.IeBitmap));

  ExifIptcPanel1.OnMetadataVisibility := HandleMetadataVisibility;
  ExifIptcPanel1.AssignData(theTags, fFiles);
  CreateTabs;

  if self.visible then
    self.BringToFront
  else
    show;

  CurrentFile_Get(true, true);
end;



procedure TThumbsbrowser_InfoForm.Launch_Multi(theThumbs: TList;
                                               theWIAIO: TObject;
                                               theWPD: TObject;
                                               theTags: TThumbsbrowser_MetaTags;
                                               theMetaOptions: TThumbsbrowser_MetaData_Options;
                                               HandleMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent = nil);
var
i: integer;
aThumb:TThumbEX;
wpdObjId: string;
begin
  InitLoading;
  fMetaOptions := theMetaOptions;
  fBrowserWIA_IO := TImageenio(theWiaIo);


  {$IFDEF TB_PORTABLEDEVICE}
  fBrowserWPD := TIEPortableDevices(theWPD);
  {$ENDIF}

  fFiles.clear;
  for I := 0 to theThumbs.Count-1 do
  begin

    aThumb := TThumbEX(theThumbs[i]);
    {$IFDEF TB_PORTABLEDEVICE}
    wpdObjId := aThumb.AttachedWPDInfo.Rcd.id;
    {$ELSE}
     wpdObjId := '';
    {$ENDIF}

    fFiles.Add(TThumbsbrowser_MetaData_FileRcd.create(aThumb.SourceFileName,
                                                     aThumb.SourceType = st_URL,
                                                     aThumb.SourceType = st_WIA,
                                                     aThumb.SourceType = st_WPDFile,
                                                     aThumb.SourceHasExif,
                                                     aThumb.SourceHasIPTC,
                                                     aThumb.SourceHasDICOM,
                                                     aThumb.SourceHasXmp,
                                                     aThumb.SourceExif_Orientation,
                                                     aThumb.AttachedWIAItem,
                                                     wpdObjId,
                                                     (aThumb.StoreType = tbstore_FullImage) and (aThumb.Adjourned),
                                                     aThumb.IeBitmap
                                                    )
                                                    );



  end;
  ExifIptcPanel1.OnMetadataVisibility := HandleMetadataVisibility;
  ExifIptcPanel1.AssignData(theTags, fFiles);

  CreateTabs;

  if self.visible then
    self.BringToFront
  else
    show;



  CurrentFile_Get(true, true);

end;

procedure TThumbsbrowser_InfoForm.ApplyFormStatus(value:TThumbsbrowser_InfoForm_Status);
begin
  if value.Defined then
  begin
    FormStatus := value;
   // self.Left := value.x;
   // self.Top := value.y;
    self.Width := value.w;
    self.Height := value.h;
    self.Panel_info.width := value.SplitInfoWidth;
  end;
end;


procedure TThumbsbrowser_InfoForm.CreateTabs;
var
i: integer;
anewTab: TTabsheet;
begin

  PageControl_MultiPics.Visible := true;
  for I := PageControl_MultiPics.PageCount-1 downto 0 do
  begin
    PageControl_MultiPics.Pages[i].free;
  end;

  if IsMultiPic then
  begin
    //add general tab
    anewTab := TTabsheet.create(PageControl_MultiPics);
    anewTab.PageControl := PageControl_MultiPics;

    with anewTab do
    begin
        Caption := '[Selected Files]';
        PArent := PageControl_MultiPics;
        visible := true;
        TabVisible := True;
    end;
  end;

  //add tabs for each file
  for i := 0 to fFiles.count-1 do
  begin
    anewTab := TTabsheet.create(PageControl_MultiPics);
    anewTab.PageControl := PageControl_MultiPics;

    with anewTab do
    begin
      Caption := MyExtractFileName(Filercd[i].FileName);
      PArent := PageControl_MultiPics;
      visible := true;
      TabVisible := True;
    end;
  end;

  PageControl_MultiPics.ActivePageIndex := PageControl_MultiPics.PageCount-1;
  PageControl_MultiPics.Repaint;
    //this force correct repaint of pagecontrol when using VCLSKIN
  if self.visible then
    SendMessage(self.Handle, WM_SYSCOMMAND, SC_RESTORE, 0);
end;

procedure TThumbsbrowser_InfoForm.GUI_Lock;
begin
  inc(fGuiLocked);
end;

procedure TThumbsbrowser_InfoForm.GUI_UnLock;
begin
  dec(fGuiLocked);
end;

procedure TThumbsbrowser_InfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 //  FormStatus.x := self.left;
 //  FormStatus.y := self.top;
   FormStatus.w := self.Width;
   FormStatus.h := self.Height;
   FormStatus.SplitInfoWidth := self.Panel_info.width;
   FormStatus.Defined := true;

  VideoDisconnect;

  if assigned(Onclose) then Onclose(self);

  Action := caFree;
end;


procedure TThumbsbrowser_InfoForm.Handle_PageControl_MultiPics_Change(sender: TObject);
begin
  CurrentFile_Get(true, true);
end;

procedure TThumbsBrowser_InfoForm.GUI_Reset;
begin
  GUI_Lock;
  try
    Button_save.Enabled := False;
    IEPreview.IEBitmap.width := 1;
    IEPreview.IEBitmap.height := 0;
   // IEPreview.fit;
    IEPreview.ClearAll;
    IEPreview.Refresh;
    VideoDisconnect;
    Edit_FileName.text := '';


    finally
      GUI_UnLock;
    end;
end;

procedure TThumbsbrowser_InfoForm.GUI_Check;
begin

   if CurRcd = -1 then
   begin
      fmode := [tbi_info];
   end
   else
   begin
      if fIsUrl or fIsWIA or fIsWPD then
      fmode := [tbi_info, tbi_preview]
      else
      fmode := [tbi_editname, tbi_info, tbi_preview];
    end;



   
   Edit_FileName.ReadOnly := not (tbi_editname in fmode);

   Panel_save.visible := (not fIsurl) and (not fIsWia) and (not fIsWPD);
   Panel_info.visible := ExifIptcPanel1.HasInfo;

   if CurRcd = -1 then
   begin
     button_AddMetaTags_Exif.Enabled := false;
     button_AddMetaTags_Iptc.Enabled := false;
   end
   else
   begin
     button_AddMetaTags_Exif.Enabled := (not ExifIptcPanel1.HasExif) and FileRcd[currcd].ExifEditable;
     button_AddMetaTags_Iptc.Enabled := (not ExifIptcPanel1.HasIptc)and FileRcd[currcd].IptcEditable;
   end;


   button_save.Enabled := fEditStatus <> [];
    if tbiEdited_filename in fEditstatus then
    begin
      if tbiEdited_MetaInfo in fEditstatus then
        Button_save.Caption := TBResStr[IDRS_INFOFORM_BTNSAVERENAME]
      else
        Button_save.Caption := TBResStr[IDRS_INFOFORM_BTNRENAME];
    end
    else
    begin
      Button_save.Caption := TBResStr[IDRS_INFOFORM_BTNSAVE];
    end;

end;



procedure TThumbsBrowser_InfoForm.VideoTogglePlay;
begin
  with IEPreview.IO.DShowParams do
  begin
    if State = gsRunning then
    begin
      Pause;
    end
    else
    begin
      if not connected then
      begin
        FileInput := fFileName;
        EnableSampleGrabber := true;
        RenderAudio := true;
        Connect;
        Position := 0;
      end;

      Run;
    end;

  end;
end;

procedure TThumbsBrowser_InfoForm.VideoDisconnect;
begin
  with IEPreview.IO.DShowParams do
  begin
    if Connected then
    begin
      Stop;
      Disconnect;
    end;
  end;
end;

procedure TThumbsbrowser_InfoForm.CurrentFile_Preview;
begin
 GUI_Reset;

 if ((CurRcd <> -1) and (GetFileRcd(CurRcd).ThumbImg <> nil)) then
 begin
   if fLoading then
    AbortLoadingPic;

   IEPreview.IEBitmap.Assign(GetFileRcd(CurRcd).ThumbImg);
   IEPreview.UpdateNoPaint;
   fitPic;
   if (GetFileRcd(CurRcd).ThumbHasFullImg) then  //We have already Full image
     EXIT; //>>>EXIT
 end;

 if fIsWIA then
   CurrentFile_Preview_WIA
   {$IFDEF TB_PORTABLEDEVICE}
  else if fIsWPD then
    CurrentFile_Preview_WPD
  {$ENDIF}
 else
   CurrentFile_Preview_PC;

end;


procedure TThumbsbrowser_InfoForm.CurrentFile_Preview_PC;
begin
  if ffilename='' then EXIT;


  if fLoading then
    AbortLoadingPic;

  floadThread := TThumbsBrowser_LoadPicThread.create;

  with floadThread do
  begin
    threadTerminatedEvent := Handle_PicLoaded;
    threadProgressEvent := Handle_Progress;
    floading := true;
    Launch(fFilename);
   end;
end;

procedure TThumbsbrowser_InfoForm.CurrentFile_Preview_WIA;
begin
  if not assigned(fBrowserWIA_IO) then EXIT;
  if not assigned(fWIA_Item) then EXIT;

  CurrentFile_GetInfo_WIA;

  screen.cursor := crhourglass;
  try
     fBrowserWIA_IO.WIAParams.TakePicture := FALSE;
    fBrowserWIA_IO.WIAParams.DeleteTakenPicture := FALSE;
    fBrowserWIA_IO.WIAParams.TransferFormat := ietfDefault;
    fBrowserWIA_IO.WIAParams.ProcessingBitmap := IEPreview.IEBitmap;
    fBrowserWIA_IO.WIAParams.Transfer(fWIA_Item, False);
  finally
    screen.cursor := crdefault;
  end;

  IEPreview.Refresh;
  FitPic;
end;


{$IFDEF TB_PORTABLEDEVICE}
procedure TThumbsbrowser_InfoForm.CurrentFile_Preview_WPD;
var
 aMemStream : TMemoryStream;
begin
  if not assigned(fBrowserWPD) then EXIT;
  if fWPDObjID = '' then EXIT;

  CurrentFile_GetInfo_WPD;

  screen.cursor := crhourglass;
  try
    if (IsKnownFormat(fFilename)) and  //try to load only known format
    (not tbs_FileExtIsVIDEO(extractfileext(fFilename))) then   //but do not include videos
    begin
      // Retrieve the image from the device
      aMemStream := TMemoryStream.create;
      try
        if fBrowserWPD.CopyStreamFromDevice(fBrowserWPD.ActiveDeviceID, fWPDObjID, aMemStream ) then  //inside here use the CS
        begin
          IEPreview.IEBitmap.Read(aMemStream);  //outside the CS is not needed
          IEPreview.Update;
        end;
      finally
        aMemStream.free;
      end;
    end;

  finally
    screen.cursor := crdefault;
  end;

  IEPreview.Refresh;
  FitPic;
end;
 {$ENDIF}


procedure TThumbsbrowser_InfoForm.CurrentFile_GetInfo;

begin
  if fFileName = '' then
    GUI_Reset;

   ExifIptcPanel1.SetCurrentFile(CurRcd);


  if fIswia then
    CurrentFile_GetInfo_WIA
  {$IFDEF TB_PORTABLEDEVICE}
  else if fIsWPD then
    CurrentFile_GetInfo_WPD
  {$ENDIF}
  else
    CurrentFile_GetInfo_PC;
end;

procedure TThumbsBrowser_InfoForm.CurrentFile_GetInfo_General;
begin
   GUI_Lock;
  try

    caption := 'Info Picture';

    if fitemidx >= 0 then
      caption := caption + ': n° ' + inttostr(fItemidx + 1);

    Edit_FileName.text := MyExtractFileName(fFileName);
    Edit_FileName.Hint := fFileName;


  finally
    GUI_UnLock;
  end;
end;

procedure TThumbsbrowser_InfoForm.CurrentFile_GetInfo_PC;
begin
  if fLoading then EXIT;
  if fFileName = '' then EXIT;


  CurrentFile_GetInfo_General;

  GUI_Lock;
  try
    if fIsUrl then
    begin
      Label_Location.caption := minimizename(tbs_UrlExtractPath(fFileName, true), self.canvas, Round(0.75 * Label_Location.width));
      Label_Location.Hint := tbs_UrlExtractPath(fFileName, true);
    end
    else
    begin
      fFileIO.ParamsFromFile(fFileName);
  
      Label_Location.caption := minimizename(extractfilepath(fFileName), self.canvas, Round(0.75 * Label_Location.width));
      Label_Location.Hint := extractfilepath(fFileName);
      Label_FDate.caption := TBResStr[IDRS_INFOFORM_FDate] + datetimetostr(tbs_getfiledate(fFilename));

     if fIsVideo then
     begin
        Label_FSize.caption := '';
        Label_FDate.caption := TBResStr[IDRS_INFOFORM_FDate] + datetimetostr(tbs_getfiledate(fFilename));
     end
     else
       Label_FSize.caption := TBResStr[IDRS_INFOFORM_FSize] + inttostr(fFileIO.params.width) + ' x ' + inttostr(fFileIO.params.height)
        + ' ' + inttostr(fFileIO.params.Dpi) + ' dpi';
    end;

    ExifIptcPanel1.SetCurrentFile(CurRcd);



  finally
    GUI_UnLock;
  end;

  GUI_Check;
end;


procedure TThumbsbrowser_InfoForm.CurrentFile_GetInfo_WIA;
var
  iw, ih: integer;
  aDT, aDate, aTime: TDateTime;
  adt_array: array of dword;
begin
 if fFileName = '' then EXIT;
 if fBrowserWIA_IO=nil then EXIT;


 CurrentFile_GetInfo_General;

 GUI_Lock;
 try

// iSize := fBrowserWIA_IO.WIAParams.getitemproperty(WIA_IPA_ITEM_SIZE, fWIA_Item);
 aDT := now;
  try
    adt_array := fBrowserWIA_IO.WIAParams.getitemproperty(WIA_IPA_ITEM_TIME, fWIA_Item);
    if adt_array[0] <> 0 then
    begin
      aDate := EncodeDate(adt_array[0], adt_array[1], adt_array[3]);
      aTime := EncodeTime(adt_array[4], adt_array[5], adt_array[6], adt_array[7]);
      aDT := TBDateTimeAddTime(aDate, aTime);
    end;
  except
    ;
  end;

  iw := fBrowserWIA_IO.WIAParams.getitemproperty(WIA_IPA_PIXELS_PER_LINE, fWIA_Item);
  ih := fBrowserWIA_IO.WIAParams.getitemproperty(WIA_IPA_NUMBER_OF_LINES, fWIA_Item);

  Label_Location.caption := '';
  Label_Location.Hint := '';
  Label_FDate.caption := TBResStr[IDRS_INFOFORM_FDate] + datetimetostr(aDT);

  Label_FSize.caption := TBResStr[IDRS_INFOFORM_FSize] + inttostr(iw) + ' x ' + inttostr(ih)
      + ' ';

  finally
    GUI_UnLock;
  end;

  GUI_Check;
end;


 {$IFDEF TB_PORTABLEDEVICE}
procedure TThumbsbrowser_InfoForm.CurrentFile_GetInfo_WPD;
var
  props: TIEWPDObjectAdvancedProps;
begin
  if not assigned(fBrowserWPD) then EXIT;
  if fWPDObjID = '' then EXIT;

 CurrentFile_GetInfo_General;

 GUI_Lock;
 try
   if fBrowserWPD.GetObjectAdvancedProps(fwpdobjId, props) then
   begin
     Label_Location.caption := minimizename(extractfilepath(fFileName), self.canvas, Round(0.75 * Label_Location.width));
     Label_Location.Hint := extractfilepath(fFileName);
     Label_FDate.caption := TBResStr[IDRS_INFOFORM_FDate] + datetimetostr(props.DateModified);
   end;

  finally
    GUI_UnLock;
  end;

  GUI_Check;


end;
{$ENDIF}


function TThumbsbrowser_InfoForm.GetCurRcd: integer;
begin
  if IsMultiPic then
    result := PageControl_MultiPics.ActivePageIndex-1
  else
    result := 0;
end;

function TThumbsbrowser_InfoForm.GetFileRcd(
  idx: integer): TThumbsbrowser_MetaData_FileRcd;
begin
  if idx = -1 then
    result := nil
  else
  result := TThumbsbrowser_MetaData_FileRcd(ffiles[idx]);
end;

function TThumbsbrowser_InfoForm.GUILocked:boolean;
begin
  result := fGuiLocked > 0;
end;

procedure TThumbsbrowser_InfoForm.Button_saveClick(Sender: TObject);
begin
  DoSave;
end;


procedure TThumbsbrowser_InfoForm.Handle_PicLoaded(theiebitmap:tiebitmap;thefilename:string);
begin
  if thefilename <> ffilename then exit;

  try
    if assigned(fMetaOptions) and fMetaOptions.UseExifOrientationForThumbs then
    begin
      if (comparetext(fFileIO.Params.FileName, fFileName)=0)and
         (fFileio.Params.EXIF_HasEXIFData) and
         (fFileio.Params.EXIF_Orientation>1) then
      begin
       // if TBDetectSameOrientation(fFileIo, fFilename, false, theIebitmap) then
         TBAdjustEXIFOrientation(theIebitmap, GetFileRcd(GetCurRcd).ThumbOrientation);
      end;
    end;

    IEPreview.IEBitmap.Assign(theiebitmap);
    IEPreview.UpdateNoPaint;
    FitPic;
  finally
    floadThread := nil;
    floading := false;

    ProgressBar1.Position :=0;
    ProgressBar1.Visible := false;
  end;

  CurrentFile_GetInfo_PC;
end;

procedure TThumbsbrowser_Infoform.FitPic;
begin
  if (IEPreview.IEBitmap.width > IEPreview.width) or
      (IEPreview.IEBitmap.height > IEPreview.height) then
      IEPreview.Fit
    else
      IEPreview.Zoom := 100;

    IEPreview.Update;
end;


procedure TThumbsbrowser_InfoForm.Handle_Progress(Sender: TObject; per: integer);
begin
  if per mod 10 = 0 then
  begin
    ProgressBar1.Visible := per<>100;
    ProgressBar1.Position := per;
  end;

end;



procedure TThumbsbrowser_InfoForm.Edit_FileNameChange(Sender: TObject);
begin
  if GUILocked then EXIT;

  if Edit_FileName.Focused then
  begin
    fEditStatus := fEditStatus + [tbiEdited_FileName];
    GUI_Check;
  end;
end;

procedure TThumbsbrowser_InfoForm.ExifIptcPanel1FileInfoSaved(sender: TObject;
  theFileRcd: TThumbsbrowser_MetaData_FileRcd);
begin
 if Assigned(OnSaveFileMetadata) then
    OnSaveFileMetadata(theFileRcd.FileName);

end;

procedure TThumbsbrowser_InfoForm.ExifIptcPanel1Modified(sender: TObject;
  theField: TThumbsbrowser_MetaData_Field);
begin
  if GUILocked then EXIT;

  fEditStatus := fEditStatus + [tbiEdited_MetaInfo];
  GUI_Check;
end;

procedure TThumbsbrowser_InfoForm.FormResize(Sender: TObject);
begin
  Button_save.left := (Panel_save.width - Button_save.width) div 2;
end;

procedure TThumbsbrowser_InfoForm.FormShow(Sender: TObject);
begin
  PageControl_MultiPics.OnChange := Handle_PageControl_MultiPics_Change;
  PageControl_MultiPics.Invalidate;
  PageControl_MultiPics.Repaint;
end;

end.
