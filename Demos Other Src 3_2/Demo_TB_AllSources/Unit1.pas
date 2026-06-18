unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ImgList,
  iemio, iexBitmaps, iexWPD,
  NWSComps_StyleEngine,
  NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs,
  NWSComps_ThumbsBrowser_Utils_Types, NWSComps_ThumbsBrowser_Shell_Utils,
  hyieutils, hyiedefs, iemview, iesettings, ieopensavedlg;
type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabBrowsePC: TTabSheet;
    TabBrowseWia: TTabSheet;
    TabScanner: TTabSheet;
    TabBrowseWPD: TTabSheet;
    tb1: TThumbsBrowser;
    beFolder: TButtonedEdit;
    ImageList1: TImageList;
    cmbWIADevices: TComboBox;
    btnRefreshWiaDevices: TButton;
    cmbWPDDevices: TComboBox;
    btnRefreshWPDDevices: TButton;
    pgBarWPD: TProgressBar;
    pgBarWIA: TProgressBar;
    pnWiaCommands: TPanel;
    btnBrowseWia: TButton;
    pnWPDCommands: TPanel;
    btnBrowseWPD: TButton;
    btnSearchWPD: TButton;
    EditSearchWPD: TEdit;
    cmbScannerDevices: TComboBox;
    btnRefreshScannerDevices: TButton;
    pnScannerComands: TPanel;
    btnAcquire: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    pnScannerParams: TPanel;
    chkFeederEnabled: TCheckBox;
    chkAutoFeed: TCheckBox;
    chkDuplexEnabled: TCheckBox;
    Label6: TLabel;
    edtResY: TEdit;
    edtResX: TEdit;
    Label5: TLabel;
    cmbColors: TComboBox;
    chkShowScannerDialog: TCheckBox;
    PgBarScanner: TProgressBar;
    pnBottom: TPanel;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    trbCompression: TTrackBar;
    Label7: TLabel;
    rbtBW: TRadioButton;
    rbtGrayscale: TRadioButton;
    rbtFullColor: TRadioButton;
    ProgressBar1: TProgressBar;
    SaveImageEnDialog1: TSaveImageEnDialog;
    chkOnlyThumbnails: TCheckBox;
    procedure beFolderRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnRefreshWiaDevicesClick(Sender: TObject);
    procedure btnBrowseWiaClick(Sender: TObject);
    procedure btnRefreshWPDDevicesClick(Sender: TObject);
    procedure btnBrowseWPDClick(Sender: TObject);
    procedure btnSearchWPDClick(Sender: TObject);
    procedure cmbWIADevicesClick(Sender: TObject);
    procedure cmbWPDDevicesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbWPDDevicesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbScannerDevicesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnRefreshScannerDevicesClick(Sender: TObject);
    procedure btnAcquireClick(Sender: TObject);
    procedure cmbScannerDevicesClick(Sender: TObject);
    procedure chkShowScannerDialogClick(Sender: TObject);
    procedure tb1ThumbSelectionChange(theThumb: TThumbEx;
      const Idx: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fScannerMIO: TImageenMio;

    procedure GetConnectedWiaDevices;
    procedure BrowseWia;
    procedure HandleThumbsFilter(thethumb: tthumbex; idx: integer;
      var compareresult: boolean);
    procedure GetConnectedWPDDevices;
    procedure BrowseWPD;

    procedure SearchWPD;
    procedure HandleWIAProgress(sender: TObject; const Pos, minPos,
      maxPos: integer);
    procedure HandleWPDProgress(sender: TObject; const Pos, minPos,
      maxPos: integer);
    procedure CheckGui;
    procedure GetConnectedScannerDevices;
    procedure SetMode;
    procedure HandleAcquireBitmap(Sender: TObject; ABitmap: TIEBitmap; DpiX,
      DpiY: Integer; var Handled: boolean);
    procedure GetScannerSource;
    procedure HandleScanProgress(sender: TObject; per: integer);
    function GiveMeParams: TIOMultiParams;
    procedure HandleProgress(sender: TObject; per: integer);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses iexacquire;

procedure TForm1.GetConnectedScannerDevices;
begin
  fScannerMIO.AcquireParams.FillListWithSources(cmbScannerDevices.Items, [ieaTwain, ieaWIA]);

  if cmbScannerDevices.Items.Count > 0 then
  begin
     cmbScannerDevices.itemindex := 0;
     GetScannerSource;
  end;
  CheckGui;
end;

procedure TForm1.GetConnectedWiaDevices;
begin
  tbs_WIAFillDevices(cmbWIADevices.Items);

  if cmbWIADevices.Items.Count > 0 then
     cmbWIADevices.itemindex := 0;

  CheckGui;
end;

procedure TForm1.GetConnectedWPDDevices;
begin
  tbs_WPDFillDevices(cmbWPDDevices.Items);

  if cmbWPDDevices.Items.Count > 0 then
     cmbWPDDevices.itemindex := 0;

  CheckGui;
end;

procedure TForm1.BrowseWia;
begin
  if cmbWIADevices.itemindex < 0 then Exit;

  tb1.ClearThumbs;
  tb1.StartBrowsing_WIA(cmbWIADevices.itemindex); //use directly the index of WIA device - only WIA devices must be listed here
end;

procedure TForm1.BrowseWPD;
begin
  if cmbWPDDevices.itemindex < 0 then Exit;

  tb1.ClearThumbs;
  tb1.NavigateToWPDFolder(tbs_WPDDecodeDevID(cmbWPDDevices.items[cmbWPDDevices.ItemIndex]), ''); //decode the ID of Device from name in Combobox
end;

procedure TForm1.SearchWPD;
begin
  if cmbWPDDevices.itemindex < 0 then Exit;

  tb1.ClearThumbs;
  tb1.StartBrowsing_WPD(tbs_WPDDecodeDevID(cmbWPDDevices.items[cmbWPDDevices.ItemIndex]), '', true, EditSearchWPD.text, [iewFile]);
end;

procedure TForm1.SetMode;
begin
  tb1.StopBrowsing;

  if pagecontrol1.ActivePage = TabBrowseWia then
  begin
    if cmbWIADevices.Items.count = 0 then
      GetConnectedWiaDevices;
  end
  else if pagecontrol1.ActivePage = TabBrowseWPD then
  begin
    if cmbWPDDevices.Items.count = 0 then
      GetConnectedWPDDevices;
  end
  else if pagecontrol1.ActivePage = TabScanner then
  begin
    if cmbScannerDevices.Items.count = 0 then
      GetConnectedScannerDevices;
  end;

  tb1.OnItemSearchCompare := HandleThumbsFilter; //this specifies how we filter the thumbs
  tb1.FilterThumbs; //this will hide the thumbs that do not belong to the current View

  CheckGui;
end;

procedure TForm1.tb1ThumbSelectionChange(theThumb: TThumbEx;
  const Idx: Integer);
begin
  CheckGui;
end;

procedure TForm1.GetScannerSource;
const
  Acquire_PixelType: array [ ieapMonochrome .. ieapOther ] of string = ( 'B/W 1 Bit', '8 bit GrayScale', '16 bit GrayScale', 'Full Color', '16 bit Full Color', 'Other' );
var
i:integer;
begin
  fScannerMIO.AcquireParams.SetSourceByStr(cmbScannerDevices.Items[cmbScannerDevices.ItemIndex]);
  if fScannerMIO.AcquireParams.SelectedSource.API <> ieaNone then
  begin
    if cmbColors.Items.Count = 0 then
      for I := ord( Low( Acquire_PixelType )) to ord( High( Acquire_PixelType )) do
       cmbColors.Items.Add( Acquire_PixelType[ TIEAcquirePixelType( i ) ] );

    with fScannerMIO do
    begin
      edtResX.Text := FloatToStr( AcquireParams.XResolution );
      edtResY.Text := FloatToStr( AcquireParams.YResolution );
      cmbColors.ItemIndex      := ord( AcquireParams.PixelType );
      chkFeederEnabled.Checked := AcquireParams.FeederEnabled;
      chkAutoFeed.Checked      := AcquireParams.AutoFeed;
      chkDuplexEnabled.Checked := AcquireParams.DuplexEnabled;
      chkDuplexEnabled.Enabled := AcquireParams.DuplexSupported;
    end;
  end;
end;

procedure TForm1.HandleAcquireBitmap(Sender: TObject; ABitmap: TIEBitmap; DpiX, DpiY: Integer; var Handled: boolean);
begin
  Handled := TRUE;
  tb1.Add_a_Thumb(ABitmap, 'Scanner Capture' + inttostr(tb1.ThumbsCount + 1), nil, -1, tbstore_FullImage);  //add the image to TB (as Full Image)
  PgBarScanner.Position := 0; //reset progress bar (because it does not reach the end in progress event)
end;

procedure Tform1.HandleThumbsFilter(thethumb: tthumbex; idx: integer; var compareresult: boolean);
begin
  if pagecontrol1.ActivePage = TabBrowsePc then  //if browsing PC show only pc-type thumbs
    compareresult := (theThumb.SourceType = st_File) or (theThumb.SourceType = st_Folder) or (theThumb.SourceType = st_FolderNav)
  else if pagecontrol1.ActivePage = TabBrowseWia then  //if browsing WIA show only wia-type thumbs
    compareresult := (theThumb.SourceType = st_Wia)
  else if pagecontrol1.ActivePage = TabBrowseWPD then  //if browsing Portable Device show only WPD-type thumbs
    compareresult := (theThumb.SourceType = st_WPDFile) or (theThumb.SourceType = st_WPDFolder) or (theThumb.SourceType = st_WPDFolderNav)
  else if pagecontrol1.ActivePage = TabScanner then  //if Scanner
    compareresult := (theThumb.SourceType = st_General);

end;

procedure TForm1.HandleWIAProgress(sender:TObject; const Pos, minPos, maxPos: integer);
begin
  if (Pos = maxPos) or (maxPos = minPos) then
    pgBarWIA.Position := 0
  else
    pgBarWIA.Position := round(100 * (Pos - minPos) / (maxPos - minPos));
end;

procedure TForm1.HandleWPDProgress(sender:TObject; const Pos, minPos, maxPos: integer);
begin
  if (Pos = maxPos) or (maxPos = minPos) then
    pgBarWPD.Position := 0
  else
    pgBarWPD.Position := round(100 * (Pos - minPos) / (maxPos - minPos));
end;

procedure TForm1.HandleScanProgress(sender:TObject; per: integer);
begin
  PgBarScanner.Position := per;
end;

procedure TForm1.HandleProgress(sender:TObject; per: integer);
begin
  ProgressBar1.Position := per;
end;

procedure TForm1.CheckGui;
begin
  pnWiaCommands.Enabled := cmbWIADevices.ItemIndex>=0;
  pnWPDCommands.Enabled := cmbWPDDevices.ItemIndex >= 0;
  pnScannerComands.Enabled := cmbScannerDevices.ItemIndex >= 0;
  pnScannerParams.Visible := not chkShowScannerDialog.checked;

  pnBottom.Enabled := tb1.SelectedCount > 0;
end;

procedure TForm1.btnRefreshWiaDevicesClick(Sender: TObject);
begin
  GetConnectedWiaDevices;
  BrowseWia;
end;

procedure TForm1.btnRefreshWPDDevicesClick(Sender: TObject);
begin
  GetConnectedWPDDevices;
  BrowseWPD;
end;

procedure TForm1.btnAcquireClick(Sender: TObject);
begin
  if fScannerMIO.AcquireParams.SelectedSource.API = ieaNone then
    raise Exception.Create('No Scanner Source Selected');

  with fScannerMIO do
  begin
    AcquireParams.XResolution := strtoFloat(edtResX.Text);
    AcquireParams.YResolution := strToFloat(edtResY.Text);
    AcquireParams.PixelType := TIEAcquirePixelType(cmbColors.ItemIndex);
    AcquireParams.FeederEnabled := chkFeederEnabled.Checked;
    AcquireParams.AutoFeed := chkAutoFeed.Checked;
    AcquireParams.DuplexEnabled := chkDuplexEnabled.Checked;
    AcquireParams.VisibleDialog := chkShowScannerDialog.checked;
  end;
  fScannerMIO.OnProgress := HandleScanProgress;
  fScannerMIO.OnAcquireBitmap := HandleAcquireBitmap;  //set the event to receive the images (this allows multiple acquisition)
  fScannerMIO.Acquire;
end;

procedure TForm1.btnBrowseWiaClick(Sender: TObject);
begin
  BrowseWia;
end;

procedure TForm1.btnBrowseWPDClick(Sender: TObject);
begin
  BrowseWPD;
end;

procedure TForm1.btnSearchWPDClick(Sender: TObject);
begin
  SearchWPD;
end;

procedure TForm1.btnRefreshScannerDevicesClick(Sender: TObject);
begin
  GetConnectedScannerDevices;
end;


function TForm1.GiveMeParams: TIOMultiParams;
var
  I: Integer;
begin
  result := TIOMultiParams.create;
  result.Allocate(tb1.SelectedCount);
  for I := 0 to result.Count-1 do
  begin
    if rbtBW.Checked then
    begin
      result.Params[i].SamplesPerPixel := 1;
      result.Params[i].BitsPerSample := 1;
    end
    else if rbtGrayscale.Checked then
    begin
      result.Params[i].SamplesPerPixel := 1;
      result.Params[i].BitsPerSample := 8;
    end
    else if rbtFullColor.Checked then
    begin
      result.Params[i].SamplesPerPixel := 3;
      result.Params[i].BitsPerSample := 8;
    end;
    result.Params[i].TIFF_Compression := TIOTIFFCompression(trbCompression.Position);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
mview: TImageenmview;
mb: TIEMultiBitmap;
frm:TForm;
begin
  mb := TIEMultiBitmap.Create;
  frm := TForm.create(nil);
  try
    tb1.ExportToMultiBitmap(IfSelected, mb, not chkOnlyThumbnails.checked);

   // frm.FormStyle := fsStayOnTop;
    frm.width := 800;
    frm.height := 600;
    frm.Position := poScreenCenter;

    mview := TImageenmview.Create(frm);
    with mview do
    begin
      parent := frm;
      visible := true;
      Background := clred;
      align := alclient;
      AssignEx(mb);
      Update;
    end;
    frm.caption := 'MultiBitmap Previewed in ' + TImageenmview.classname + ' v. ' + mview.ImageEnVersion;
    frm.ShowModal;
  finally
    frm.free;
    mb.free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 IOParams:  TIOMultiParams;
begin
   if SaveImageEnDialog1.Execute then
   begin
     IOParams := GiveMeParams;
     tb1.ExportToMultiFileFormat(IfSelected, SaveImageEnDialog1.FileName, not chkOnlyThumbnails.checked, IOParams);
     IOParams.free;
   end;
end;

procedure TForm1.beFolderRightButtonClick(Sender: TObject);
begin
  if tb1.PromptForFolder then
     beFolder.Text := tb1.FolderCurrent;
end;

procedure TForm1.chkShowScannerDialogClick(Sender: TObject);
begin
  CheckGui;
end;

procedure TForm1.cmbWIADevicesClick(Sender: TObject);
begin
  BrowseWIA;
end;

procedure TForm1.cmbWPDDevicesClick(Sender: TObject);
begin
  BrowseWPD;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fScannerMIO := TImageenMio.Create(nil);
  beFolder.Text := tb1.FolderCurrent;
  tb1.OnWIAProgress := HandleWIAProgress;
  tb1.OnWPDProgress := HandleWPDProgress;
  tb1.OnProgress := HandleProgress;
  SetMode;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  fScannerMIO.free;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  SetMode;
end;

procedure TForm1.cmbWPDDevicesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  cmbWPDDevices.Canvas.TextRect(Rect, Rect.left, Rect.top, tbs_WPDDecodeDevName(cmbWPDDevices.items[Index]));
end;

procedure TForm1.cmbScannerDevicesClick(Sender: TObject);
begin
  GetScannerSource;
end;

procedure TForm1.cmbScannerDevicesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  DrawAcquireComboListBoxItem( Control, Rect, cmbScannerDevices.Items[Index]);
end;

end.
