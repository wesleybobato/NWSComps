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
unit NWSComps_ThumbsBrowser_ExifIptc;
{$R-}
{$Q-}
interface
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}


{$IFDEF IMAGEEN_5_2_LATER}
  {$IFDEF NWSCOMPS_DELPHI2005_UPPER}
    {$DEFINE NWSCOMPS_TB_METADATA_USEHELPERS}
  {$ENDIF}
{$ENDIF}

uses
  SysUtils, Classes, Controls, stdctrls, extctrls, ComCtrls, contnrs, dialogs,
  Grids, NWSComps_Thumbsbrowser_Thumbs,
  NWSComps_Thumbsbrowser_utils_Types,
  NWSComps_Thumbsbrowser_utils, NWSComps_Types,
  hyiedefs, hyieutils, IEWia,
  {$IFDEF IMAGEEN_6_2_LATER}  iexBitmaps, {$ENDIF}
  imageenio;


 type

   {$IFNDEF IMAGEEN_6_2_LATER}
   TIOParams =  TIOParamsVals;
   {$ENDIF}



  TThumbsBrowser_ExifIptcPanel = class(TCustomControl)
  private
    { Private declarations }

    fFiles: TThumbsbrowser_MetaData_FileRcds;
    fCurrentIdx: integer;

    fAllPicsRcd: TThumbsbrowser_MetaData_FileRcd;

    ftmpParams: TIOParams;

    pgCtrl: TPageControl;


    fcomboDisplayType_Common, fcomboDisplayType_Exif, fcomboDisplayType_Iptc, fcomboDisplayType_Dicom, fcomboDisplayType_Xmp: TComboBox;
    fPanelOptions_Common, fPanelOptions_Exif, fPanelOptions_Iptc, fPanelOptions_Dicom, fPanelOptions_Xmp: TPanel;
    fGridCommon, fGridExif, fGridIptc, fGridDicom, fGridXmp: TStringGrid;

    fedFields: TThumbsbrowser_MetaData_FieldsList;

    TabCommon, TabExif, tabIptc, tabDicom, tabXmp: TTabSheet;
    fOnModified: TThumbsbrowser_MetaData_Field_ModifiedEvent;
    fTabPosition: TTabPosition;

   

    fShowExif: boolean;
    fShowIPTC: boolean;
    fShowDICOM: boolean;
    fShowXmp: boolean;
    fOnFileInfoSaved: TThumbsbrowser_MetaData_FileEvent;



    fTags: TThumbsbrowser_MetaTags;
    fOwnTags:boolean;
    fDicomIncludeOptions: TTBDicomTagsIncludeOptions;
    fOnMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent;
    fLanguage: TNWSCompsLanguage;

    function gridIdxToFieldIdx(grid: Tstringgrid; idx: integer): integer;

    procedure RecreateTabs;
    procedure UpdateCurrentTab;

    function GetFileRcd(idx: integer): TThumbsbrowser_MetaData_FileRcd;
    function CurFileRcd: TThumbsbrowser_MetaData_FileRcd;
   
    procedure FillGrids(tab: TTabsheet);

    procedure LoadInfo;

    function CurFileEdited: boolean;
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure SaveInfoToFile(theFileIdx: integer);

    procedure SetTabPosition(const Value: TTabPosition);
    function GetHasInfo: boolean;
    function GetHasDicom: boolean;
    function GetHasExif: boolean;
    function GetHasIptc: boolean;

    procedure Handle_PageChange(sender: TObject);
    procedure SetShowDICOM(const Value: boolean);
    procedure SetShowExif(const Value: boolean);
    procedure SetShowIPTC(const Value: boolean);

    procedure SetTags(const Value: TThumbsbrowser_MetaTags; const bUpdateTabs: boolean);
    procedure SetFiles(const Value: TThumbsbrowser_MetaData_FileRcds; const bUpdateTabs: boolean);

    function FindIptcIdxInParams(theParams: TIOParams; rec, dset: integer): integer;
    function GetHasXmp: boolean;
    procedure SetShowXmp(const Value: boolean);

    function GetHasCommon: boolean;

    function GridFieldEditable(grid: Tstringgrid; const idx: integer): boolean;
    procedure SetDicomIncludeOptions(const Value: TTBDicomTagsIncludeOptions);
    procedure HandleCbDisplayModeChange(sender: TObject);
    procedure CheckPendingChanges;
    procedure SetLanguage(const Value: TNWSCompsLanguage);
    procedure HandleGlobalNotification(sender: TObject;
      notType: TNWSCompsNotificationType);

    property FileRcd[idx:integer]:TThumbsbrowser_MetaData_FileRcd read GetFileRcd;
  protected
    { Protected declarations }
  public
    { Public declarations }

    property Files: TThumbsbrowser_MetaData_FileRcds read fFiles;

    property HasInfo: boolean read GetHasInfo;
    property HasCommon: boolean read GetHasCommon;
    property HasExif: boolean read GetHasExif;
    property HasIptc: boolean read GetHasIptc;
    property HasDicom: boolean read GetHasDicom;

    property HasXmp: boolean read GetHasXmp;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Loaded; override;

    procedure SetCurrentFile(idx:integer);
    procedure UpdateInfo;
    procedure SaveModifiedInfo;

    function ForceExif: boolean;
    function ForceIptc:boolean;


    procedure AssignData(theTags:TThumbsbrowser_MetaTags; theFiles: TThumbsbrowser_MetaData_FileRcds);
    procedure AssignFiles(theFiles: TThumbsbrowser_MetaData_FileRcds);
    procedure AssignTags(theTags: TThumbsbrowser_MetaTags);

  published
    { Published declarations }

    property Align;
    property Anchors;
    property AutoSize;
    property BorderWidth;
    property Color;
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

    property Language: TNWSCompsLanguage read fLanguage write SetLanguage;

    property TabPosition: TTabPosition read fTabPosition write SetTabPosition;
    
    property DicomIncludeOptions: TTBDicomTagsIncludeOptions read fDicomIncludeOptions write SetDicomIncludeOptions;

    property ShowExif: boolean read fShowExif write SetShowExif;
    property ShowIPTC: boolean read fShowIPTC write SetShowIPTC;
    property ShowDICOM: boolean read fShowDICOM write SetShowDICOM;
    property ShowXmp: boolean read fShowXmp write SetShowXmp;


    property OnModified: TThumbsbrowser_MetaData_Field_ModifiedEvent read fOnModified write fOnModified;
    property OnFileInfoSaved: TThumbsbrowser_MetaData_FileEvent read fOnFileInfoSaved write fOnFileInfoSaved;
    property OnMetadataVisibility: TThumbsBrowser_MetadataVisibilityEvent read fOnMetadataVisibility write fOnMetadataVisibility;
  end;


implementation
uses math,{$IFDEF IMAGEEN_8_0_0_LATER}ieDicomTags,  {$ENDIF}
NWSComps_ThumbsBrowser_RES, NWSComps_ThumbsBrowser_RES_CONST;
{ TThumbsBrowser_ExifIptcPanel }

procedure TThumbsBrowser_ExifIptcPanel.AssignData(theTags:TThumbsbrowser_MetaTags; theFiles: TThumbsbrowser_MetaData_FileRcds);
begin

  SetTags(theTags, false);
  SetFiles(theFiles, false);
  UpdateInfo;
end;

procedure TThumbsBrowser_ExifIptcPanel.AssignFiles(
  theFiles: TThumbsbrowser_MetaData_FileRcds);
begin
  SetFiles(theFiles, true);
end;

procedure TThumbsBrowser_ExifIptcPanel.AssignTags(
  theTags: TThumbsbrowser_MetaTags);
begin
  SetTags(theTags, true);
end;

constructor TThumbsBrowser_ExifIptcPanel.Create(AOwner: TComponent);
begin
  inherited;
  NWSCOMPS.Subscribe(HandleGlobalNotification);
  fTags := TThumbsbrowser_MetaTags.create(true);
  fOwnTags := true;

  fLanguage := NWSCOMPS.Language;

  fShowExif := true;
  fShowIPTC := true;
  fShowDICOM := true;
  fShowXmp := true;

  ftmpParams := TIOParams.create(nil);
  fFiles := nil;
  fCurrentIdx := -1;

  fAllPicsRcd := TThumbsbrowser_MetaData_FileRcd.Create('');

  fTabPosition := tpBottom;

  pgCtrl := TPagecontrol.create(self);
  pgCtrl.Parent := self;
  pgCtrl.Visible := true;
  pgCtrl.Align := alClient;
  pgctrl.TabPosition := fTabPosition;

  fGridCommon := TStringGrid.Create(self);
  fGridCommon.OnSelectCell := GridSelectCell;
  fGridCommon.OnSetEditText := GridSetEditText;


  fGridExif := TStringGrid.Create(self);
  fGridExif.OnSelectCell := GridSelectCell;
  fGridExif.OnSetEditText := GridSetEditText;

  fGridIptc := TStringGrid.Create(self);
  fGridIptc.OnSelectCell := GridSelectCell;
  fGridIptc.OnSetEditText := GridSetEditText;

  fGridDicom := TStringGrid.Create(self);
  fGridDicom.OnSelectCell := GridSelectCell;
  fGridDicom.OnSetEditText := GridSetEditText;

  fGridXmp := TStringGrid.Create(self);
  fGridXmp.OnSelectCell := GridSelectCell;
  fGridXmp.OnSetEditText := GridSetEditText;

  fPanelOptions_Exif := TPanel.create(self);
  fPanelOptions_Iptc := TPanel.create(self);
  fPanelOptions_Common := TPanel.create(self);
  fPanelOptions_Xmp := TPanel.create(self);
  fPanelOptions_Dicom := TPanel.create(self);

  fcomboDisplayType_Exif := TCombobox.create(self);
  fcomboDisplayType_Iptc := TCombobox.create(self);
  fcomboDisplayType_Common := TCombobox.create(self);
  fcomboDisplayType_Xmp := TCombobox.create(self);
  fcomboDisplayType_Dicom := TCombobox.create(self);


  fedFields := TThumbsbrowser_MetaData_FieldsList.Create(fTags, ftmpParams);
  fDicomIncludeOptions := [DIn_Deprecated, DIn_Proprietary, DIn_Children, DIn_Unknown];
  

end;

procedure TThumbsBrowser_ExifIptcPanel.Handle_PageChange(sender: TObject);
begin
   UpdateCurrentTab;
end;

function TThumbsBrowser_ExifIptcPanel.CurFileRcd: TThumbsbrowser_MetaData_FileRcd;
begin
  //result := FileRcd[fCurrentIdx];
  result := GetFileRcd(fCurrentIdx);
end;


procedure TThumbsBrowser_ExifIptcPanel.HandleGlobalNotification(sender: TObject;
  notType: TNWSCompsNotificationType);
begin
  case notType of
    nwsNotTyp_Lang:
begin
      SetLanguage(NWSCOMPS.Language);
    end;
  end;

end;

destructor TThumbsBrowser_ExifIptcPanel.Destroy;
begin
  NWSCOMPS.UNSubscribe(HandleGlobalNotification);
  ftmpParams.free;
  fAllPicsRcd.free;

  fedFields.free;
  if fOwnTags and assigned(fTags) then
    fTags.free;

 
  inherited;
end;

function TThumbsBrowser_ExifIptcPanel.GetFileRcd(
  idx: integer): TThumbsbrowser_MetaData_FileRcd;
begin
  result := nil;
  if not assigned(ffiles) then EXIT;

  if (idx>=0) and (idx<ffiles.count) then
    result := TThumbsbrowser_MetaData_FileRcd(ffiles[idx])
  else if idx=-1 then
    result := fAllPicsRcd;

end;

function TThumbsBrowser_ExifIptcPanel.GetHasCommon: boolean;
begin
  result := tabCommon.TabVisible;
end;

function TThumbsBrowser_ExifIptcPanel.GetHasDicom: boolean;
begin
  result := tabDicom.TabVisible;
end;

function TThumbsBrowser_ExifIptcPanel.GetHasExif: boolean;
begin
  result := TabExif.TabVisible;
end;

function TThumbsBrowser_ExifIptcPanel.GetHasInfo: boolean;
begin
  result := pgCtrl.PageCount>0;
end;

function TThumbsBrowser_ExifIptcPanel.GetHasIptc: boolean;
begin
  result := tabIptc.TabVisible;
end;

function TThumbsBrowser_ExifIptcPanel.GetHasXmp: boolean;
begin
  result := tabXmp.TabVisible;
end;

function TThumbsBrowser_ExifIptcPanel.gridIdxToFieldIdx(grid: Tstringgrid;
  idx: integer): integer;
begin
  result := strtoint(grid.Cells[2,idx]);

end;

function TThumbsBrowser_ExifIptcPanel.GridFieldEditable(grid: Tstringgrid; const idx:integer):boolean;
begin
  result :=  strtoint(grid.Cells[3,idx]) <> 0;
end;

procedure TThumbsBrowser_ExifIptcPanel.HandleCbDisplayModeChange(sender:TObject);
var
 dmode: TThumbsbrowser_MetaData_DisplayMode;
 cb:TCombobox;
begin
  if CurFileRcd = nil then Exit;

  dmode := mdm_NonEmpty;
  cb := TCombobox(sender);
  if cb.ItemIndex = 0 then
    dmode := mdm_NonEmpty
  else if cb.ItemIndex = 1 then
    dmode := mdm_All
  else if cb.ItemIndex = 2 then
    dmode := mdm_GroupedByCore;



  if pgCtrl.ActivePage = TabCommon then
     CurFileRcd.DisplayMode_Common := dmode
   else if pgCtrl.ActivePage = TabExif then
     CurFileRcd.DisplayMode_Exif := dmode
   else if pgCtrl.ActivePage = TabDicom then
     CurFileRcd.DisplayMode_Dicom := dmode
   else if pgCtrl.ActivePage = TabIptc then
     CurFileRcd.DisplayMode_Iptc := dmode
   else if pgCtrl.ActivePage = TabXmp then
     CurFileRcd.DisplayMode_Xmp := dmode;


  FillGrids(pgCtrl.ActivePage);
end;

procedure TThumbsBrowser_ExifIptcPanel.RecreateTabs;
  procedure makeVisibleTab(tab:TTabSheet; bVisible: boolean);
  begin
 
    if bVisible then
    begin
      with tab do
      begin
        PageControl := pgCtrl;
        Parent := pgCtrl;
        visible := true;
        TabVisible := True;
      end;
    end
    else
    begin
      with tab do
      begin
        PageControl := nil;
        Parent := nil;
        visible := false;
        TabVisible := false;
      end;
    end;

  end;

  procedure arrangeTabCtrls(tab:TTabSheet; grid:TStringgrid; pnOptions: TPanel; cbDisplayMode: TCombobox);
  begin
    pnOptions.Parent := tab;
    pnOptions.width := 100;
    pnOptions.Height := 30;
    pnOptions.visible := true;
    pnOptions.Align := alTop;
    cbDisplayMode.parent := pnOptions;
    cbDisplayMode.width := 140;
    cbDisplayMode.Height := 25;
    cbDisplayMode.visible := true;
    cbDisplayMode.left := 4;
    cbDisplayMode.top := 2;

  
    grid.Parent := tab;
    grid.Visible := true;
    grid.Align := alclient;
  end;
var
fr:TThumbsbrowser_MetaData_FileRcd;
begin
//
  if not assigned(tabCommon) then
  begin
    tabCommon := TTabSheet.Create(pgctrl);
    tabCommon.Caption := TBGetResStr(fLanguage, IDRS_METAPN_TABCOMMON);
  end;

  if not assigned(TabExif) then
  begin
    TabExif := TTabSheet.Create(pgctrl);
    TabExif.Caption := 'Exif';
  end;

  if not assigned(TabIptc) then
  begin
    TabIptc := TTabSheet.Create(pgctrl);
    tabIptc.Caption := 'Iptc';
  end;

  if not assigned(TabDicom) then
  begin
    TabDicom := TTabSheet.Create(pgctrl);
    tabDicom.Caption := 'Dicom';
  end;

  if not assigned(TabXmp) then
  begin
    TabXmp := TTabSheet.Create(pgctrl);
    TabXmp.Caption := 'Xmp';
  end;

  fr := CurFileRcd;

  if fr <>nil then
  begin
    makeVisibleTab(TabExif, fShowExif and fr.HasExif);
    makeVisibleTab(TabIptc, fShowIPTC and fr.HasIptc);
    makeVisibleTab(TabDicom, fShowDICOM and fr.HasDicom);
   {$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
   makeVisibleTab(TabXmp, fShowXmp and fr.HasXmp);   //xmp was not supported before the metahelpers
   {$ENDIF}
  end
  else
  begin
    makeVisibleTab(TabExif, false);
    makeVisibleTab(TabIptc, false);
    makeVisibleTab(TabDicom, false);
    {$IFDEF NWSCOMPS_TB_METADATA_USEHELPERS}
    makeVisibleTab(TabXmp, false);   //xmp was not supported before the metahelpers
    {$ENDIF}
  end;

  makeVisibleTab(tabCommon, HasExif or HasIptc);  //make visible this only if exif or iptc are present
  if tabCommon.TabVisible then
    tabCommon.PageIndex := 0;

  arrangeTabCtrls(tabCommon, fGridCommon, fPanelOptions_Common, fcomboDisplayType_Common);
  arrangeTabCtrls(tabExif, fGridExif, fPanelOptions_Exif, fcomboDisplayType_Exif);
  arrangeTabCtrls(tabIptc, fGridIptc, fPanelOptions_Iptc, fcomboDisplayType_Iptc);
  arrangeTabCtrls(tabXmp, fGridXmp, fPanelOptions_Xmp, fcomboDisplayType_Xmp);
  arrangeTabCtrls(tabDicom, fGridDicom, fPanelOptions_Dicom, fcomboDisplayType_Dicom);



    //trick to solve a refresh problem
  pgctrl.SelectNextPage(true, true);
  pgctrl.SelectNextPage(false, true);
    //trick to solve a refresh problem
end;

procedure TThumbsBrowser_ExifIptcPanel.SetCurrentFile(idx: integer);
begin
  if (idx<>-1) and (GetFileRcd(idx) = nil) then
    EXIT;

  CheckPendingChanges;

  fCurrentIdx := idx;
  UpdateInfo;
end;

procedure TThumbsBrowser_ExifIptcPanel.CheckPendingChanges;
var
  sMsg: string;
begin
  if CurFileEdited then
  begin
    if CurFileRcd = fAllPicsRcd then
     sMsg := TBGetResStr(fLanguage,IDRS_METAPN_PENDINGCHANGES_MULTI)
    else
     sMsg := TBGetResStr(fLanguage,IDRS_METAPN_PENDINGCHANGES_SINGLE);

    if messagedlg(sMsg, mtconfirmation , [mbyes, mbno],0)=mryes then
    begin
      SaveModifiedInfo;
    end;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetDicomIncludeOptions(
  const Value: TTBDicomTagsIncludeOptions);
begin
  if fDicomIncludeOptions = Value then EXIT;

  fDicomIncludeOptions := Value;

  if csDesigning in ComponentState then EXIT;
  if csLoading in ComponentState then EXIT;


  UpdateInfo;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetFiles(const Value: TThumbsbrowser_MetaData_FileRcds; const bUpdateTabs: boolean);
begin

  fFiles := Value;
  fAllPicsRcd.UnForceMetaInfo(true, true, true, true);
  if not assigned(Value) then
  begin
    fCurrentIdx := -1;
  end
  else
  begin
    fCurrentIdx := ffiles.Count-1;
  end;
  if bUpdateTabs then
    UpdateInfo;
end;



procedure TThumbsBrowser_ExifIptcPanel.SetLanguage(
  const Value: TNWSCompsLanguage);
begin
  fLanguage := Value;

  if not (csloading in ComponentState) then
  begin
    fTags.SetLanguage(fLanguage);
    RecreateTabs;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetTags(const Value: TThumbsbrowser_MetaTags; const bUpdateTabs: boolean);
begin
  if not assigned(value) then  //nil value passed -> it means we want to have or revert to own tags
  begin
      //if already fowntags nothing todo
      if not fOwnTags then
      begin
        fTags := nil;
        fTags := TThumbsbrowser_MetaTags.create(true);
        fOwnTags := true;
      end;
  end
  else
  begin  //a value was passed -> it means we want to use external custom tags

    if fOwnTags and assigned(fTags) then
      fTags.free;

    fOwnTags := false;
    fTags := Value;

    fTags.SetLanguage(fLanguage);

  end;

  if assigned(fedFields) then
    fedFields.Free;

  fedFields := TThumbsbrowser_MetaData_FieldsList.Create(fTags, ftmpParams);

  if bUpdateTabs then
    UpdateInfo;
end;



procedure TThumbsBrowser_ExifIptcPanel.SetShowDICOM(const Value: boolean);
begin
  fShowDICOM := Value;
  if not (csloading in ComponentState) then
  begin
    RecreateTabs;
    UpdateCurrentTab;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetShowExif(const Value: boolean);
begin
  fShowExif := Value;
  if not (csloading in ComponentState) then
  begin
    RecreateTabs;
    UpdateCurrentTab;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetShowIPTC(const Value: boolean);
begin
  fShowIPTC := Value;
  if not (csloading in ComponentState) then
  begin
    RecreateTabs;
    UpdateCurrentTab;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetShowXmp(const Value: boolean);
begin
  fShowXmp := Value;
  if not (csloading in ComponentState) then
  begin
    RecreateTabs;
    UpdateCurrentTab;
  end;
end;

procedure TThumbsBrowser_ExifIptcPanel.SetTabPosition(
  const Value: TTabPosition);
begin
  fTabPosition := Value;
  pgCtrl.TabPosition := fTabPosition;
end;



function TThumbsBrowser_ExifIptcPanel.CurFileEdited:boolean;
begin
  result := (fedFields.Count>0);
end;
procedure TThumbsBrowser_ExifIptcPanel.Loaded;
begin
  inherited;
  RecreateTabs;

  pgctrl.OnChange := Handle_PageChange;
  SetLanguage(fLanguage);
end;

procedure TThumbsBrowser_ExifIptcPanel.LoadInfo;
var
 aio:TImageenio;
  I: Integer;

begin
  if CurFileRcd = nil then EXIT;

  fedFields.Clear;
  if CurFileRcd = fAllPicsRcd then
  begin
    ftmpParams.ResetInfo;
    ftmpparams.IPTC_Info.Clear;
    ftmpparams.XMP_Info := '';
    ftmpParams.DICOM_Tags.Clear;
    fAllPicsRcd.HasExif := true;
    fAllPicsRcd.HasIptc := true;
    fAllPicsRcd.HasDicom := true;
    fAllPicsRcd.HasXmp := true;
    for I := 0 to ffiles.count-1 do
    begin
      if fileRcd[i].MetaInitialized then
      begin
        fAllPicsRcd.HasExif := fAllPicsRcd.HasExif and FileRcd[i].HasExif;
        fAllPicsRcd.HasIptc := fAllPicsRcd.HasIptc and FileRcd[i].HasIptc;
        fAllPicsRcd.HasDicom := fAllPicsRcd.HasDicom and FileRcd[i].HasDicom;
        fAllPicsRcd.HasXmp := fAllPicsRcd.HasXmp and FileRcd[i].HasXmp;
      end
      else
      begin
        fAllPicsRcd.HasExif := true;
        fAllPicsRcd.HasIptc := true;
        fAllPicsRcd.HasDicom := true;
        fAllPicsRcd.HasXmp := true;
        break;
      end;
    end;
  end
  else
  begin
      aio := TImageenio.create(nil);
      try
        aio.ParamsFromFile(CurFileRcd.FileName);
        ftmpParams.Assign(aio.Params);
        if not CurFileRcd.MetaInitialized then
          CurFileRcd.InitMeta(aio.Params.EXIF_HasEXIFData, aio.Params.IPTC_Info.Count>0,
                              aio.Params.DICOM_Tags.count>0, aio.Params.XMP_Info <> '');
      finally
        aio.free;
      end;
  end;
end;




procedure TThumbsBrowser_ExifIptcPanel.SaveInfoToFile(theFileIdx: integer);
var
 fr: TThumbsbrowser_MetaData_FileRcd;
begin

  fr := FileRcd[theFileIdx];

  if fr.IsWia then Exit;  //nothing to save
  if fr.IsUrl then Exit;  //nothing to save

  TBMetadataInjectToFile(fr.FileName, fr.HasExif, fr.HasIptc, fedFields);

  if assigned(fOnFileInfoSaved) then
    fOnFileInfoSaved(self, fr);
end;

procedure TThumbsBrowser_ExifIptcPanel.SaveModifiedInfo;
var
  I: Integer;
begin
  if CurFileRcd = fAllPicsRcd then
  begin
    for I := 0 to fFiles.count-1 do
      SaveInfoToFile(i);
  end
  else
  begin
    SaveInfoToFile(fCurrentIdx);


  end;

  fedFields.Clear;
end;



procedure TThumbsBrowser_ExifIptcPanel.UpdateCurrentTab;
begin
  FillGrids(pgctrl.activepage);

end;

procedure TThumbsBrowser_ExifIptcPanel.UpdateInfo;
begin
  LoadInfo;
  RecreateTabs;
  UpdateCurrentTab;

end;




function TThumbsBrowser_ExifIptcPanel.FindIptcIdxInParams(theParams: TIOParams; rec, dset: integer):integer;
var
i:integer;
begin
  result := -1;
  for i := 0 to theParams.IPTC_Info.Count-1 do
  begin
    if (theParams.IPTC_Info.RecordNumber[i] = rec) and (theParams.IPTC_Info.DataSet[i] = dset) then
    begin
      result := i;
      break;
    end;

  end;

end;

function TThumbsBrowser_ExifIptcPanel.ForceExif: boolean;
var
  I: Integer;
begin
  result := false;
  if fCurrentIdx = -1 then
  begin
    fAllPicsRcd.ForceMetaInfo(true, false, false, false);
    for I := 0 to fFiles.count-1 do
    begin
      // if fFiles[i].ExifEditable then
        fFiles[i].ForceMetaInfo(true, false, false, false);
    end;
  end
  else
  begin
   // if CurFileRcd.ExifEditable then
      CurFileRcd.ForceMetaInfo(true, false, false, false);
  end;
  result := true;
  UpdateInfo;

end;

function TThumbsBrowser_ExifIptcPanel.ForceIptc:boolean;
var
  I: Integer;
begin
  result := false;

  if fCurrentIdx = -1 then
  begin
    fAllPicsRcd.ForceMetaInfo(false, true, false, false);
    for I := 0 to fFiles.count-1 do
    begin
     // if fFiles[i].IptcEditable then
        fFiles[i].ForceMetaInfo(false, true, false, false);
    end;
  end
  else
  begin
    //if CurFileRcd.IptcEditable then
      CurFileRcd.ForceMetaInfo(false, true, false, false);
  end;
  result := true;
  UpdateInfo;
end;

procedure TThumbsBrowser_ExifIptcPanel.FillGrids(tab:TTabsheet);
procedure AutoSizeCol(Grid: TStringGrid; Column: integer; defW:integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to (Grid.RowCount - 1) do begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := max(defW, WMax + 6);
end;


procedure ParseDicomTag(aGrid: TStringgrid; DicomTags: TIEDicomTags; const idx: integer; recursionLevel:integer; var DicomRowCtr: integer);
var
  DicomValue, DicomDescr:string;
  DicomTag:PIEDicomTag;
  aTagSource: TIEDicomTagSource;
  k, m, rl: Integer;
  bAllow: boolean;
  begin
      DicomTag := DicomTags.GetTag(idx);
      DicomValue := Trim(Dicomtags.GetTagString(idx));
      {$IFDEF IMAGEEN_8_0_0_LATER}
          DicomDescr := trim(IEGetDicomTagDescription(DicomTags, idx, aTagSource));
       {$ELSE}
          DicomDescr := trim(DicomTags.GetTagDescription(idx, aTagSource));
      {$ENDIF}




      bAllow := True;
      if (aTagSource = dsDeprecated) and (not (din_Deprecated in fDicomIncludeOptions)) then
        bAllow := False
      else if (aTagSource = dsProprietary) and (not (din_Proprietary in fDicomIncludeOptions)) then
        bAllow := False;

      if (DicomDescr = '') then
      begin
        if not(din_Unknown in fDicomIncludeOptions)  then
          bAllow := False
        else
          DicomDescr := 'Unknown';
      end;


      if bAllow and (DicomValue<>'') then
      begin
        if recursionLevel>0 then
          DicomDescr := '> ' + DicomDescr;   //arrow to the left of description indicating a child tag

        for rl  := 0 to recursionLevel-1 do
          DicomDescr := '  ' + DicomDescr;  //space to the left to indicate a child tag

        aGrid.cells[0,DicomRowCtr] := DicomDescr;
        aGrid.cells[1,DicomRowCtr] := DicomValue;
        if recursionLevel = 0 then
          aGrid.cells[2,DicomRowCtr] := inttostr(idx) //save index of the field
        else
          aGrid.cells[2,DicomRowCtr] := inttostr(-1); //save index of the field
        aGrid.cells[3,DicomRowCtr] := inttostr(0); //save info whether field is editable 0 = false 1 = true
        inc(DicomRowCtr);
        if DicomRowCtr>aGrid.RowCount then
          aGrid.RowCount := aGrid.RowCount + 50;

        if (DIn_Children in fDicomIncludeOptions)  then
        begin
          if DicomTag.Children<>nil then
          begin
            for k := 0 to DicomTag.Children.count-1 do
            begin
              for m := 0 to TIEDicomTags(DicomTag.Children[k]).count-1 do
                ParseDicomTag(aGrid, TIEDicomTags(DicomTag.Children[k]), m, recursionLevel + 1, DicomRowctr);
            end;
          end;
        end;
      end;
end;

procedure ParseTag(aGrid: TStringgrid; dataType: TThumbsbrowser_MetaData_Type; const idx: integer; var RowCtr: integer);
var
value, descr:string;
bAllowTag: boolean;
aFld:TThumbsbrowser_MetaData_Field;
begin

  bAllowTag := true;
  value :=  TBMetaDataReadFieldAsStr(ftmpparams, dataType, idx, fTags);

  if assigned(fOnMetadataVisibility) then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(idx, dataType, Value, mdum_Replace);
    try
       fOnMetadataVisibility(aFld, bAllowTag);
    finally
      if assigned(aFld) then
        aFld.free;
    end;
  end;




  if (dataType = mdft_Common) then
  begin
    if (value = '') and (CurFileRcd.DisplayMode_Common = mdm_NonEmpty) then
      bAllowTag := false;
  end
  else if (dataType = mdft_Exif) then
  begin
    if (value = '') and (CurFileRcd.DisplayMode_Exif = mdm_NonEmpty) then
      bAllowTag := false;
  end
  else if (dataType = mdft_Iptc) then
  begin
    if (value = '') and (CurFileRcd.DisplayMode_Iptc = mdm_NonEmpty) then
      bAllowTag := false;
  end
  else if (dataType = mdft_Xmp) then
  begin
    if (value = '') and (CurFileRcd.DisplayMode_Xmp = mdm_NonEmpty) then
      bAllowTag := false;
  end;


  if bAllowTag then
  begin
    case dataType of
      mdft_Common:
        begin
          descr := fTags.CommonTags[idx].Desc;
        end;
      mdft_Exif:
        begin
          descr := fTags.ExifTags[idx].Desc;
        end;
      mdft_Iptc:
        begin
          descr := fTags.IptcTags[idx].Desc;
        end;
      mdft_Xmp:
        begin
          descr := fTags.XmpTags[idx].Desc;
        end;
    end;
    aGrid.cells[0, RowCtr] := descr;
    aGrid.cells[1, RowCtr] := value;
    aGrid.cells[2, RowCtr] := inttostr(idx); //save index of the field
    aGrid.cells[3, RowCtr] := inttostr(1); //save info whether field is editable 0 = false 1 = true
    inc(RowCtr);
    if RowCtr>aGrid.RowCount then
      aGrid.RowCount := aGrid.RowCount + 50;
  end;
end;

procedure UpdateOptionsPanel(dataType: TThumbsbrowser_MetaData_Type);
var
  cbDisplayMode: TCombobox;
  dmode: TThumbsbrowser_MetaData_DisplayMode;
  bHasGroupByCoreOption: boolean;
begin

  case dataType of
    mdft_Common:
      begin
        cbDisplayMode := fcomboDisplayType_Common;
        dmode := CurFileRcd.DisplayMode_Common;
        fPanelOptions_Common.Visible := false;
        bHasGroupByCoreOption := false;
      end;
    mdft_Exif:
      begin
        cbDisplayMode := fcomboDisplayType_Exif;
        dmode := CurFileRcd.DisplayMode_Exif;
        fPanelOptions_Exif.Visible := true;
        bHasGroupByCoreOption := false;
      end;
    mdft_Iptc:
      begin
        cbDisplayMode := fcomboDisplayType_Iptc;
        dmode := CurFileRcd.DisplayMode_Iptc;
        fPanelOptions_Iptc.Visible := true;
        bHasGroupByCoreOption := false;
      end;
    mdft_Dicom:
      begin
        cbDisplayMode := fcomboDisplayType_Dicom;
        dmode := CurFileRcd.DisplayMode_Dicom;
        fPanelOptions_Dicom.Visible := false;
        bHasGroupByCoreOption := false;
      end;
    mdft_Xmp:
      begin
        cbDisplayMode := fcomboDisplayType_Xmp;
        dmode := CurFileRcd.DisplayMode_Xmp;
        fPanelOptions_Xmp.Visible := true;
        bHasGroupByCoreOption := false;
      end
      else
        EXIT;
  end;

  if cbDisplayMode.Items.count = 0 then
  begin
    cbDisplayMode.Items.add(TBGetResStr(fLanguage,IDRS_METAPN_DISPLAYMODE_NONEMPTY));
    cbDisplayMode.Items.add(TBGetResStr(fLanguage,IDRS_METAPN_DISPLAYMODE_ALL));
    if bHasGroupByCoreOption then
      cbDisplayMode.Items.add(TBGetResStr(fLanguage,IDRS_METAPN_DISPLAYMODE_GROUPED));

    cbDisplayMode.Style := csDropDownList;
    cbDisplayMode.OnChange := HandleCbDisplayModeChange;
//      cbDisplayMode.Items.add('Display All');
  end
  else
  begin
    cbDisplayMode.OnChange := nil;
    try
      if dmode = mdm_NonEmpty then
        cbDisplayMode.ItemIndex := 0
      else if dmode = mdm_All then
        cbDisplayMode.itemindex := 1;
    finally
      cbDisplayMode.OnChange := HandleCbDisplayModeChange;
    end;


  end;
end;
var
  aGrid:TStringgrid;
  I:integer;

  RowCtr, NRows: integer;
  bEditable:boolean;
  dataType: TThumbsbrowser_MetaData_Type;
begin
  if tab = nil then EXIT;

  if CurFileRcd = nil then EXIT;



  if tab = TabCommon then
  begin
    dataType := mdft_Common;
    aGrid := fGridCommon;
    NRows := ftags.CommonTags.Count;
    bEditable := (not curfilercd.MetaInitialized) or (curfilercd.CommonEditable);
  end
  else if tab = tabExif then
  begin
    dataType := mdft_Exif;
    aGrid := fGridExif;
    NRows := ftags.ExifTags.Count;
    bEditable := (not curfilercd.MetaInitialized) or (curfilercd.ExifEditable);
  end
  else if tab = tabIptc then
  begin
    dataType := mdft_Iptc;
    aGrid := fGridIptc;
    NRows := ftags.IptcTags.Count;
    bEditable := (not curfilercd.MetaInitialized) or (curfilercd.IptcEditable);
  end
  else if tab = tabXmp then
  begin
    dataType := mdft_Xmp;
    aGrid := fGridXmp;
    NRows := ftags.XmpTags.Count;
    bEditable := (not curfilercd.MetaInitialized) or (curfilercd.XmpEditable);
  end
  else if tab = tabDicom then
  begin
    dataType := mdft_Dicom;
    aGrid := fGridDicom;
    NRows := ftmpparams.DICOM_Tags.Count;
    bEditable := (not curfilercd.MetaInitialized) or (curfilercd.DicomEditable);
  end
  else
    EXIT;

  UpdateOptionsPanel(dataType);

  aGrid.ColCount := 4;
  aGrid.FixedCols := 1;
  aGrid.FixedRows := 0;
  aGrid.ColWidths[0] := round(0.4 * aGrid.width);
  aGrid.ColWidths[1] := round(0.60 * aGrid.width);
  aGrid.ColWidths[2] := 0;
  aGrid.ColWidths[3] := 0;


  aGrid.RowCount := NRows;
  RowCtr := 0;
  for I := 0 to NRows-1 do
  begin
    if tab = tabDicom then
    begin
      ParseDicomTag(aGrid, ftmpparams.DICOM_Tags, i, 0, RowCtr);
    end
    else
    begin
      ParseTag(aGrid, dataType, i, RowCtr);
    end;
  end;

  aGrid.RowCount := RowCtr;

  if bEditable then
   aGrid.Options := aGrid.Options + [goEditing]
  else
   aGrid.Options := aGrid.Options - [goEditing];

  AutoSizeCol(aGrid, 0, aGrid.ColWidths[0]);
  AutoSizeCol(aGrid, 1, aGrid.ColWidths[1]);



end;








procedure TThumbsBrowser_ExifIptcPanel.GridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  bEditEnabled: boolean;
  aGrid: TStringgrid;
  I: Integer;
begin
  if CurFileRcd = nil then EXIT;

  if CurfileRcd = fAllPicsRcd then
  begin
    bEditEnabled := true;
    for I := 0 to files.Count-1 do
    begin
      if (sender = fGridCommon) then
        bEditEnabled := (not GetFileRcd(i).MetaInitialized) or (GetFileRcd(i).CommonEditable)
      else if (sender = fGridExif) then
        bEditEnabled := (not GetFileRcd(i).MetaInitialized) or (GetFileRcd(i).ExifEditable)
      else if (sender = fGridIptc) then
        bEditEnabled := (not GetFileRcd(i).MetaInitialized) or (GetFileRcd(i).IptcEditable)
      else if (sender = fGridDicom) then
        bEditEnabled := (not GetFileRcd(i).MetaInitialized) or (GetFileRcd(i).DicomEditable)
      else if (sender = fGridXmp) then
        bEditEnabled := (not GetFileRcd(i).MetaInitialized) or (GetFileRcd(i).XmpEditable);

      if not bEditEnabled then
        break;

    end;
  end
  else
  begin
    bEditEnabled := ((sender = fGridCommon) and CurFileRcd.CommonEditable) or
                    ((sender = fGridExif) and CurFileRcd.ExifEditable) or
                    ((sender = fGridIptc) and CurFileRcd.IptcEditable) or
                    ((sender = fGridXmp) and CurFileRcd.XmpEditable) or
                    ((sender = fGridDicom) and CurFileRcd.DicomEditable);

  end;

  aGrid := TStringgrid(sender);

  bEditEnabled := bEditEnabled and GridFieldEditable(aGrid, aRow);

  if bEditEnabled then
    aGrid.Options := aGrid.Options + [goEditing]
  else
    aGrid.Options := aGrid.Options - [goEditing];

end;

procedure TThumbsBrowser_ExifIptcPanel.GridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
var
  aGrid: TStringgrid;
  aFld:TThumbsbrowser_MetaData_Field;
begin
  aGrid := TStringgrid(sender);
  if aGrid = fGridCommon then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(gridIdxToFieldIdx(aGrid, aRow), mdft_Common, Value, mdum_Replace);
    fedFields.AddField(aFld)
  end
  else
  if aGrid = fGridExif then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(gridIdxToFieldIdx(aGrid, aRow), mdft_Exif, Value, mdum_Replace);
    fedFields.AddField(aFld)
  end
  else if aGrid = fGridIptc then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(gridIdxToFieldIdx(aGrid, aRow),mdft_Iptc, Value, mdum_Replace);
    fedFields.AddField(aFld)
  end
  else if aGrid = fGridXmp then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(gridIdxToFieldIdx(aGrid, aRow),mdft_Xmp, Value, mdum_Replace);
    fedFields.AddField(aFld)
  end
  else if aGrid = fGridDicom then
  begin
    aFld := TThumbsbrowser_MetaData_Field.Create(gridIdxToFieldIdx(aGrid, aRow),mdft_Dicom, Value, mdum_Replace);
    fedFields.AddField(aFld);
  end
  else
    EXIT;

  if assigned(fOnModified) then
    fOnModified(self, aFld);
end;






end.
