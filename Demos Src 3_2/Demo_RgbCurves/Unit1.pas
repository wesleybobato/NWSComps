unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, NWSComps_RGBCurves, NWSComps_RGBCurves_Types, StdCtrls, Buttons, jpeg, ComCtrls, ieview,
  imageenview, imageen, ImgList, ToolWin, ieopensavedlg, GIFImg, Spin, XPMan,
  hyieutils, hyiedefs, iesettings, iexBitmaps, iexLayers, iexRulers;

type
  TForm1 = class(TForm)
    PageControl_Display: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    btnApplyCurves: TButton;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ImageList1: TImageList;
    OpenImageEnDialog1: TOpenImageEnDialog;
    ToolButton3: TToolButton;
    Panel3: TPanel;
    Panel4: TPanel;
    btnLoadTBitmap: TButton;
    Panel5: TPanel;
    SpinEdit_LineSize: TSpinEdit;
    Label1: TLabel;
    CheckBox_UseGDIPlus: TCheckBox;
    Label2: TLabel;
    SpinEdit_PointSize: TSpinEdit;
    Label3: TLabel;
    SpinEdit_PointOpacity: TSpinEdit;
    Label4: TLabel;
    Panel6: TPanel;
    ImageEnView1: TImageEnView;
    CheckBox_UseFastPReview: TCheckBox;
    Label5: TLabel;
    Panel7: TPanel;
    PageControl_PointsOrFormula: TPageControl;
    Tab_CurvesbyPoints: TTabSheet;
    BtnLoadCurves: TButton;
    btnSaveCurves: TButton;
    Button3: TButton;
    RadioGroup_Channel: TRadioGroup;
    TabFunctions: TTabSheet;
    ComboBox_Formula: TComboBox;
    Panel8: TPanel;
    Panel9: TPanel;
    RGBCurves1: TRGBCurves;
    Panel10: TPanel;
    Label_Coords: TLabel;
    Panel11: TPanel;
    btnLoadIni: TButton;
    btnSaveIni: TButton;
    GroupBox_InputLevels: TGroupBox;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    GroupBox_OutputLevels: TGroupBox;
    TrackBar5: TTrackBar;
    TrackBar6: TTrackBar;
    GroupBox_Threshold: TGroupBox;
    TrackBar1: TTrackBar;
    ComboBox1: TComboBox;
    Label6: TLabel;
    btnSaveImage: TButton;
    SaveImageEnDialog1: TSaveImageEnDialog;
    btnLoadPSCurve: TButton;
    OpenDialog_PS: TOpenDialog;
    SaveDialog_PS: TSaveDialog;
    btnSavePSCurve: TButton;
    CheckBoxComplementary: TCheckBox;
    sbToggle: TSpeedButton;
    btnLoadImageBg: TButton;
    btnAddLayer_Transp: TButton;
    btnAddLayer: TButton;
    PaintBox1: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RGBCurves1ChangeCurve(Sender: TObject);
    procedure BtnLoadCurvesClick(Sender: TObject);
    procedure btnSaveCurvesClick(Sender: TObject);
    procedure PageControl_PointsOrFormulaChange(Sender: TObject);
    procedure ComboBox_FormulaChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure PageControl_DisplayChange(Sender: TObject);
    procedure btnApplyCurvesClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure btnAddLayerClick(Sender: TObject);
    procedure btnLoadImageBgClick(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure btnLoadTBitmapClick(Sender: TObject);
    procedure btnAddLayer_TranspClick(Sender: TObject);
    procedure RadioGroup_ChannelClick(Sender: TObject);
    procedure CheckBox_UseGDIPlusClick(Sender: TObject);
    procedure SpinEdit_LineSizeChange(Sender: TObject);
    procedure SpinEdit_PointSizeChange(Sender: TObject);
    procedure SpinEdit_PointOpacityChange(Sender: TObject);
    procedure CheckBox_UseFastPReviewClick(Sender: TObject);
    procedure RGBCurves1IEView_BeforePreview(Sender: TObject);
    procedure RGBCurves1IEView_AfterPreview(Sender: TObject);
    procedure sbToggleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbToggleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox_LabelsFormatClick(Sender: TObject);
    procedure RGBCurves1CustomDraw_Labels_HorzAxis(aCanvas: TCanvas;
      const aValue: Double; var aLabel: string; var aFont: TFont; var MaxWidth,
      MaxHeight: Integer);
    procedure RGBCurves1CustomDraw_Labels_VertAxis(aCanvas: TCanvas;
      const aValue: Double; var aLabel: string; var aFont: TFont; var MaxWidth,
      MaxHeight: Integer);
    procedure RGBCurves1MovePoint(sender: TObject;
      CurrentPoint: TRGBCurves_doublePoint; CurrentPoint_Idx: Integer;
      var CanMove: TRGBCurves_CanMoveType);
    procedure RGBCurves1CustomDraw_Point(aCanvas: TCanvas;
      const thePoint: TRGBCurves_doublePoint; const theIdx: Integer;
      var theOutlineColor, theFillColor: TColor; var theSize,
      theLineSize: Cardinal; var theFillStyle: TBrushStyle);
    procedure RGBCurves1MovingPoint(sender: TObject;
      MovingPoint: TRGBCurves_doublePoint);
    procedure RGBCurves1ChangeRGBMode(Sender: TObject);

    procedure ImageEnView1LayerNotify(Sender: TObject; layer: Integer;
      event: TIELayerEvent);
    procedure TrackBar1Change(Sender: TObject);
    procedure btnLoadIniClick(Sender: TObject);
    procedure btnSaveIniClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure btnSaveImageClick(Sender: TObject);
    procedure btnLoadPSCurveClick(Sender: TObject);
    procedure btnSavePSCurveClick(Sender: TObject);
    procedure CheckBoxComplementaryClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure RGBCurves1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RGBCurves1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);


  private
    { Private declarations }
    fPreviewTime: integer;


    mems: Tmemorystream;
    bmp:Tbitmap;

    function GetMyDocumentsPath: string;

    procedure InitCurvesSettings;
    procedure AddLayer(const Opacity: integer);

    procedure RegisterDisplay;
    procedure SetCurveMode;
    procedure SetMathFunction;

    procedure ResetImages;
    procedure ResetHistoTBitmap;
    procedure ResetHistoIEView;

    function GammaRed(x: single): single;
    function GammaGreen(x: single): single;
    function GammaBlue(x: single): single;

    function ContrastRed(x: single): single;
    function ContrastGreen(x: single): single;
    function ContrastBlue(x: single): single;

    function Threshold(x: single): single;
    function Levels(x: single): single;
    
    procedure MouseInteractChange(miGen: TIEMouseInteract;miLay:TIEMouseInteractLayers);
    function GetInkPerc(aValue: double): integer;
    function GetInkPerc_Float(aValue: double): double;
    procedure DisplayCoords(aPT: TRGBCurves_doublePoint);
    procedure DisplayCoordsasHint(aPT: TRGBCurves_doublePoint);
    procedure CheckRGBorCMYK;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses math,  imageenio, inifiles, activex, shlobj;

{$R *.DFM}

function TForm1.GetMyDocumentsPath: string;
var
  Allocator: IMalloc;
  SpecialDir: PItemIdList;
  FBuf: array[0..MAX_PATH] of Char;
  PerDir: string;
begin
  if SHGetMalloc(Allocator) = NOERROR then
  begin
    SHGetSpecialFolderLocation(Form1.Handle, CSIDL_PERSONAL, SpecialDir);
    SHGetPathFromIDList(SpecialDir, @FBuf[0]);
    Allocator.Free(SpecialDir);
    result := string(FBuf);
  end;
end;

function TForm1.GammaRed(x: single): single;
begin
  result := 255 * power(x / 255, 1.2);
end;

function TForm1.GammaGreen(x: single): single;
begin
  result := 255 * power(x / 255, 0.9);
end;

function TForm1.GammaBlue(x: single): single;
begin
  result := 255 * power(x / 255, 0.7);
end;

function TForm1.ContrastRed(x: single): single;
begin
  result := 1.15 * x;
end;

function TForm1.ContrastGreen(x: single): single;
begin
  result := 1.05 * x;
end;

function TForm1.ContrastBlue(x: single): single;
begin
  result := 0.9 * x;
end;

function TForm1.Threshold(x: single): single;
begin
 if x<=TrackBar1.position then
  result := 0
 else
   result := 255;
end;

function TForm1.Levels(x: single): single;
var
input_min, input_max, output_min, output_max: integer;
Deltay:single;
gamma: single;
begin
  input_min := TrackBar2.Position;
  input_max := TrackBar3.Position;

  output_min := TrackBar5.Position;
  output_max := TrackBar6.Position;

  gamma := trackbar4.position/100;

  //linear levels computation
  if input_max = input_min then
    result := 255 // out of scale
  else
    result := (x - input_min)/(input_max - input_min) * (output_max - output_min) + output_min;

  Deltay := result - x;

  result := deltay + 255 * power(x / 255, gamma);
end;

procedure TForm1.SetMathFunction;
begin
Panel11.Visible := False;
GroupBox_InputLevels.Visible := false;
GroupBox_OutputLevels.Visible := false;
GroupBox_Threshold.Visible := false;

 case ComboBox_Formula.itemindex of
    0:
      begin
        with RGBCurves1 do
        begin
          FormulaCurve_Lum := nil;
          FormulaCurve_Red := nil;
          FormulaCurve_Green := nil;
          FormulaCurve_Blue := nil;
        end;
      end;
    1:
      begin
        with RGBCurves1 do
        begin
          FormulaCurve_Lum := nil;
          FormulaCurve_Red := GammaRed;
          FormulaCurve_Green := GammaGreen;
          FormulaCurve_Blue := GammaBlue;
        end;
      end;
    2:
      begin
        with RGBCurves1 do
        begin
          FormulaCurve_Lum := nil;
          FormulaCurve_Red := ContrastRed;
          FormulaCurve_Green := ContrastGreen;
          FormulaCurve_Blue := ContrastBlue;
        end;
      end;
      3:
      begin
        Panel11.Visible := true;
        GroupBox_Threshold.Visible := true;
        with RGBCurves1 do
        begin
         FormulaCurve_Lum := Threshold;
         FormulaCurve_Red := nil;
         FormulaCurve_Green := nil;
         FormulaCurve_Blue := nil;
        end;
      end;
      4:
      begin
        Panel11.Visible := true;
        GroupBox_InputLevels.Visible := true;
        GroupBox_OutputLevels.Visible := true;
        with RGBCurves1 do
        begin
         FormulaCurve_Lum := Levels;
         FormulaCurve_Red := nil;
         FormulaCurve_Green := nil;
         FormulaCurve_Blue := nil;
        end;
      end;
  end;

  RGBCurves1.Update;
end;


procedure TForm1.ImageEnView1LayerNotify(Sender: TObject; layer: Integer;
  event: TIELayerEvent);
begin
  if event = ielSelected then
    ResetHistoIEView;
end;

procedure TForm1.InitCurvesSettings;
begin
  RGBCurves1.ExportDirectory := 'presets/';
  RGBCurves1.HistogramDisplayMode := HDmTransparent;
  RGBCurves1.HistogramRGBMode := HmAll;
  RGBCurves1.ShowHistogram := False;

  RGBCurves1.Layout.PointSize := SpinEdit_PointSize.Value;
  RGBCurves1.Layout.LineSize := SpinEdit_LineSize.Value;
  RGBCurves1.Layout.PointOpacity := SpinEdit_PointOpacity.Value;

  RGBCurves1.UseFastPreview := CheckBox_UseFastPreview.checked;

  RGBCurves1.OnChangeCurve := RGBCurves1ChangeCurve;

  CheckRGBorCMYK;

end;


procedure TForm1.AddLayer(const Opacity: integer);
begin
  if OpenImageEnDialog1.execute then
  begin
    rgbcurves1.IEView_Preview_Lock;
    try
      imageenview1.LayersCurrent := imageenview1.LayersAdd;
      imageenview1.layers[imageenview1.Layerscurrent].Locked := false;
      imageenview1.layers[imageenview1.Layerscurrent].Transparency := Opacity;

      imageenview1.IO.LoadFromFile(openimageendialog1.filename);
      imageenview1.OnLayerNotify(imageenview1,imageenview1.LayersCurrent, ielSelected);
    finally
      rgbcurves1.IEView_Preview_UnLock;
    end;
  end;
end;


procedure TForm1.RegisterDisplay;
begin
  if PageControl_Display.ActivePageIndex = 0 then //TBITMAP
  begin
    RGBCurves1.IEView_Preview_UnRegister;
    RGBCurves1ChangeCurve(rgbcurves1);
  end
  else
    RGBCurves1.IEView_Preview_Register(ImageEnView1); //TImageenView
end;

procedure TForm1.SetCurveMode;
begin
 if PageControl_PointsOrFormula.ActivePage.PageIndex = 0 then
  begin
    RGBCurves1.CurveMode := cmBuildCurves;
    RGBCurves1.RGBMode := TRGBCurves_rgbmode(max(0,RadioGroup_Channel.itemindex));
  end
  else
  begin
    RGBCurves1.CurveMode := cmFormulaCurves;
    RGBCurves1.RGBMode := cmAll;
  end;
  SetMathFunction;
end;


procedure TForm1.sbToggleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RGBCurves1.IEView_Preview_Toggle(False);
end;

procedure TForm1.sbToggleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  RGBCurves1.IEView_Preview_Toggle(True);
end;

procedure TForm1.SpinEdit_LineSizeChange(Sender: TObject);
begin
  Rgbcurves1.Layout.LineSize := SpinEdit_LineSize.Value;
end;

procedure TForm1.SpinEdit_PointOpacityChange(Sender: TObject);
begin
  RGBCurves1.Layout.PointOpacity := SpinEdit_PointOpacity.Value;
end;

procedure TForm1.SpinEdit_PointSizeChange(Sender: TObject);
begin
  RGBCurves1.Layout.PointSize := SpinEdit_PointSize.Value;
end;

procedure TForm1.RadioGroup_ChannelClick(Sender: TObject);
begin
  case RadioGroup_Channel.itemindex of
    0:
      rgbcurves1.RGBMode := cmall;
    1:
      rgbcurves1.RGBMode := cmred;
    2:
      rgbcurves1.RGBMode := cmgreen;
    3:
      rgbcurves1.RGBMode := cmblue;
  end;
end;

procedure TForm1.RGBCurves1ChangeRGBMode(Sender: TObject);
begin
 case rgbcurves1.RGBMode of
    cmall: RadioGroup_Channel.itemindex := 0;
    cmRed: RadioGroup_Channel.itemindex := 1;
    cmgreen: RadioGroup_Channel.itemindex := 2;
    cmblue: RadioGroup_Channel.itemindex := 3;
  end;
end;

procedure TForm1.ResetImages;
begin
  if PageControl_Display.ActivePage.PageIndex = 0 then
  begin
    mems.seek(0,0);
    bmp.savetostream(mems);
    ResetHistoTBitmap;
  end
  else
  begin
    ResetHistoIEView;
  end;
end;

procedure TForm1.ResetHistoTBitmap;
begin
  RGBCurves1.GetHistogramfromBMP(bmp);
  RGBCurves1.ShowHistogram := True;
end;

procedure TForm1.ResetHistoIEView;
begin
  RGBCurves1.GetHistogramfromIEBMP(ImageEnView1.CurrentLayer.Bitmap);
  RGBCurves1.ShowHistogram := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mems := Tmemorystream.create;
  bmp := TBitmap.create;
  bmp.PixelFormat := pf24bit;

 // imageenview1.LayersSync := false;
  RadioGroup_Channel.itemindex := 0;
  ComboBox_Formula.itemindex := 0;

  InitCurvesSettings;

  ResetImages; //Reset image in memory

  SetCurveMode;

  RegisterDisplay;

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  mems.free;
  bmp.free;
end;







procedure TForm1.RGBCurves1ChangeCurve(Sender: TObject);
begin
  PaintBox1.Invalidate;
end;


function TForm1.GetInkPerc(aValue:double): integer;
begin
  if RGBCurves1.ComplementaryCurves then
    result := round(aValue/255 *100)
  else
    result := 100 - round(aValue/255 *100);
end;

function TForm1.GetInkPerc_Float(aValue:double): double;
begin
  if RGBCurves1.ComplementaryCurves then
    result := aValue/255 *100
  else
    result := 100 - aValue/255 *100;
end;

procedure TForm1.RGBCurves1CustomDraw_Labels_HorzAxis(aCanvas: TCanvas;
  const aValue: Double; var aLabel: string; var aFont: TFont; var MaxWidth,
  MaxHeight: Integer);
begin
  if RGBCurves1.ComplementaryCurves then
  aLabel := inttostr(GetInkPerc(aValue));
end;

procedure TForm1.RGBCurves1CustomDraw_Labels_VertAxis(aCanvas: TCanvas;
  const aValue: Double; var aLabel: string; var aFont: TFont; var MaxWidth,
  MaxHeight: Integer);
begin
  if RGBCurves1.ComplementaryCurves then
    aLabel := inttostr(GetInkPerc(aValue));
end;

procedure TForm1.RGBCurves1CustomDraw_Point(aCanvas: TCanvas;
  const thePoint: TRGBCurves_doublePoint; const theIdx: Integer;
  var theOutlineColor, theFillColor: TColor; var theSize, theLineSize: Cardinal;
  var theFillStyle: TBrushStyle);
begin
   if theIdx = rgbcurves1.GetCurrentPoint_IDX then
   begin
      theOutlineColor := clred;
      theLineSize := theLineSize + 1;
   end;
end;

procedure TForm1.RGBCurves1IEView_AfterPreview(Sender: TObject);
var
tik:cardinal;
begin
  tik := Gettickcount;
  label5.Caption := 'Previewed in ' + inttostr(tik - fPreviewTime) + ' millisecs';
end;

procedure TForm1.RGBCurves1IEView_BeforePreview(Sender: TObject);
begin
  fPreviewTime := GetTickCount;
end;

procedure TForm1.RGBCurves1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DisplayCoordsasHint(RGBCurves1.GetPointAtXY(X,Y));
end;

procedure TForm1.RGBCurves1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DisplayCoords(RGBCurves1.Points.CurrentPoint);
end;

procedure TForm1.RGBCurves1MovePoint(sender: TObject;
  CurrentPoint: TRGBCurves_doublePoint; CurrentPoint_Idx: Integer;
  var CanMove: TRGBCurves_CanMoveType);
begin
  DisplayCoords(CurrentPoint);
end;

procedure TForm1.DisplayCoords(aPT: TRGBCurves_doublePoint);
begin
  if RGBCurves1.ComplementaryCurves then
    Label_Coords.Caption := 'X = ' + formatfloat('0.##', GetInkPerc_Float(aPT.x)) +  ' Y = ' + formatfloat('0.##', GetInkPerc_Float(aPT.y))
  else
    Label_Coords.Caption := 'X = ' + formatfloat('0.##', aPT.x) +  ' Y = ' + formatfloat('0.##', aPT.y)
end;
procedure TForm1.DisplayCoordsAsHint(aPT: TRGBCurves_doublePoint);
begin
  if aPt.x = -1 then
  begin
    Application.CancelHint;
    exit;
  end;
  RGBCurves1.ShowHint := true;
  if RGBCurves1.ComplementaryCurves then
    RGBCurves1.Hint := 'X = ' + formatfloat('0.##', GetInkPerc_Float(aPT.x)) +  ' Y = ' + formatfloat('0.##', GetInkPerc_Float(aPT.y))
  else
    RGBCurves1.Hint := 'X = ' + formatfloat('0.##', aPT.x) +  ' Y = ' + formatfloat('0.##', aPT.y)
end;

procedure TForm1.RGBCurves1MovingPoint(sender: TObject;
  MovingPoint: TRGBCurves_doublePoint);
begin
  DisplayCoords(MovingPoint);
end;

procedure TForm1.PageControl_PointsOrFormulaChange(Sender: TObject);
begin
  SetCurveMode;
end;

procedure TForm1.PageControl_DisplayChange(Sender: TObject);
begin
  RegisterDisplay;
end;


procedure TForm1.PaintBox1Paint(Sender: TObject);
var
r:TRect;
begin
  if not assigned(bmp) then EXIT;
  if (bmp.Width = 0) or(bmp.Height =0) then EXIT;
  if not (csOpaque in PaintBox1.ControlStyle) then
     PaintBox1.ControlStyle := PaintBox1.ControlStyle + [csopaque];   //this removes flickering from paintbox

  if PageControl_Display.ActivePageIndex = 0 then
  begin
      mems.seek(0, 0);
      bmp.LoadFromStream(mems);

      rgbcurves1.ApplyCurvestoBitmap(bmp);

      if (bmp.width > paintbox1.width) or (bmp.Height > PaintBox1.Height) then
      begin
        if bmp.width / bmp.Height > PaintBox1.width / PaintBox1.height then
          r := rect(0, 0, paintbox1.width, round(PaintBox1.width * bmp.height / bmp.width))
        else
          r := rect(0, 0, round(PaintBox1.height * bmp.width / bmp.height), PaintBox1.Height);

        PaintBox1.Canvas.StretchDraw(r, bmp);
      end
      else
        PaintBox1.Canvas.Draw(0,0, bmp);
  end;
end;

procedure TForm1.CheckBoxComplementaryClick(Sender: TObject);
begin
  CheckRGBorCMYK;
end;

procedure TForm1.CheckRGBorCMYK;
begin
  RGBCurves1.ComplementaryCurves := CheckBoxComplementary.Checked;
  DisplayCoords(RGBCurves1.Points.CurrentPoint);

  if RGBCurves1.ComplementaryCurves then
  begin
    RadioGroup_Channel.Items[0] := 'Ink';
    RadioGroup_Channel.Items[1] := 'Cyan';
    RadioGroup_Channel.Items[2] := 'Magenta';
    RadioGroup_Channel.Items[3] := 'Yellow';
  end
  else
  begin
    RadioGroup_Channel.Items[0] := 'Lum.';
    RadioGroup_Channel.Items[1] := 'Red';
    RadioGroup_Channel.Items[2] := 'Green';
    RadioGroup_Channel.Items[3] := 'Blue';
  end;
end;

procedure TForm1.CheckBox_UseFastPReviewClick(Sender: TObject);
begin
  RGBCurves1.UseFastPreview := CheckBox_UseFastPReview.Checked;
end;

procedure TForm1.CheckBox_UseGDIPlusClick(Sender: TObject);
begin
  RGBCurves1.UseGDIPlus := CheckBox_UseGDIPlus.Checked;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if combobox1.ItemIndex=0 then
    RGBCurves1.RGBSpace := csRGB
    else if combobox1.ItemIndex = 1 then
       RGBCurves1.RGBSpace := csMixed
       else
         RGBCurves1.RGBSpace := csLum;
end;

procedure TForm1.ComboBox_FormulaChange(Sender: TObject);
begin
 SetMathFunction;
end;

procedure TForm1.ComboBox_LabelsFormatClick(Sender: TObject);
begin
  rgbcurves1.Refresh;
end;

procedure TForm1.btnLoadPSCurveClick(Sender: TObject);
begin
if opendialog_ps.execute then
  rgbcurves1.PS_LoadCurves_FromFile(opendialog_ps.filename);
end;

procedure TForm1.btnSavePSCurveClick(Sender: TObject);
begin
 if savedialog_ps.execute then
  rgbcurves1.PS_SaveCurves_ToFile(savedialog_ps.filename);
end;

procedure TForm1.BtnLoadCurvesClick(Sender: TObject);
begin
  if rgbcurves1.ImportCurves then
  begin
   CheckBoxComplementary.Checked := RGBCurves1.ComplementaryCurves;
   CheckRGBorCMYK;
  end;
end;

procedure TForm1.btnSaveCurvesClick(Sender: TObject);
begin
  RGBCurves1.ExportCurves;
end;



procedure TForm1.Button3Click(Sender: TObject);
begin
  rgbcurves1.ResetPoints;
end;

procedure TForm1.btnApplyCurvesClick(Sender: TObject);
begin
   rgbcurves1.IEView_Preview_Lock;
    try
      RGBCurves1.IEView_Preview_ApplyChanges;
      ResetHistoIEView;
      ComboBox_Formula.ItemIndex := 0;
      SetMathFunction;
      RGBCurves1.ResetPoints;
    finally
      rgbcurves1.IEView_Preview_UnLock;
    end;
end;

procedure TForm1.btnLoadIniClick(Sender: TObject);
var
f: tInifile;
begin
 if not fileexists(GetMyDocumentsPath + '\filter.ini') then EXIT;

 f := TInifile.Create(GetMyDocumentsPath + '\filter.ini');
 TrackBar1.Position := f.ReadInteger('Threshold', 'Threshold_Value', 127);

 TrackBar2.Position := f.ReadInteger('Levels', 'Input_Min', 0);
 TrackBar3.Position := f.ReadInteger('Levels', 'Input_Max', 255);
 TrackBar4.Position := f.ReadInteger('Levels', 'gamma', 100);
 TrackBar5.Position := f.ReadInteger('Levels', 'Output_Min', 0);
 TrackBar6.Position := f.ReadInteger('Levels', 'Output_Max', 255);
end;

procedure TForm1.btnSaveIniClick(Sender: TObject);
var
f: tInifile;
begin
  f := TInifile.Create(GetMyDocumentsPath + '\filter.ini');
  f.WriteInteger('Threshold', 'Threshold_Value', TrackBar1.Position);

 f.WriteInteger('Levels', 'Input_Min', TrackBar2.Position);
 f.WriteInteger('Levels', 'Input_Max', TrackBar3.Position);
 f.WriteInteger('Levels', 'gamma', TrackBar4.Position);
 f.WriteInteger('Levels', 'Output_Min', TrackBar5.Position);
 f.WriteInteger('Levels', 'Output_Max', TrackBar6.Position);

  showmessage('Saved');
end;

procedure TForm1.btnSaveImageClick(Sender: TObject);
var
  stream: TMemoryStream;
begin
  btnApplyCurves.Click;
  RGBCurves1.IEView_Preview_UnRegister;
  SaveImageEnDialog1.AttachedImageEnIO := imageenview1.IO;

   stream := TMemoryStream.Create;
   try
    Imageenview1.io.SaveToStreamIEN(stream);
    Imageenview1.LayersMergeAll(true);
    if SaveImageEnDialog1.Execute then
      Imageenview1.IO.SaveToFile(SaveImageEnDialog1.FileName);

    finally
      stream.Seek(0,0);
      Imageenview1.IO.LoadFromStreamIEN(stream);
      RGBCurves1.IEView_Preview_Register(imageenview1);
      stream.Free;
    end;
end;

procedure TForm1.MouseInteractChange(miGen: TIEMouseInteract;miLay:TIEMouseInteractLayers);
var
 bReload:boolean;
begin
 bReload :=  miRotateLayers in ImageEnView1.MouseInteractLayers;   //needs to reset the preview because the rotation will be applied
 ImageEnView1.MouseInteractGeneral := miGen;
 ImageEnView1.MouseInteractLayers := miLay;
 if bReload then
 begin
   RGBCurves1.IEView_Preview_UnRegister;
   RGBCurves1.IEView_Preview_Register(imageenview1);
 end;
end;

procedure TForm1.ToolButton1Click(Sender: TObject);
begin
   MouseInteractChange([miZoom, miScroll],[]);
end;

procedure TForm1.ToolButton2Click(Sender: TObject);
begin
  MouseInteractChange([miSelectLasso],[]);
end;

procedure TForm1.ToolButton3Click(Sender: TObject);
begin
  MouseInteractChange([],[miMoveLayers, miResizeLayers]);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  RGBCurves1.Update;
end;

procedure TForm1.btnAddLayerClick(Sender: TObject);
begin
 AddLayer(255);
end;

procedure TForm1.btnAddLayer_TranspClick(Sender: TObject);
begin
  AddLayer(180);
end;

procedure TForm1.btnLoadImageBgClick(Sender: TObject);
begin
  if OpenImageEnDialog1.Execute then
  begin
    rgbcurves1.IEView_Preview_Lock;
    try
    ImageEnView1.LayersCurrent := 0;
    ImageEnView1.IO.loadfromfile(OpenImageEnDialog1.FileName);
    imageenview1.Fit;
    ResetHistoIEView;
    if messagedlg('Convert To Grayscale?', mtinformation, [mbyes, mbno],0)=mryes  then
    begin
      imageenview1.Proc.ConvertToGray;
      ResetHistoIEView;
    end;
     finally
      rgbcurves1.IEView_Preview_UnLock;
    end;
  end;
end;



procedure TForm1.btnLoadTBitmapClick(Sender: TObject);
var
  io: TImageenio;
begin
  if OpenImageEnDialog1.Execute then
  begin
    io := TImageEnIO.Create(nil);
    try
    io.AttachedBitmap := bmp;
    io.LoadFromFile(OpenImageEnDialog1.FileName);
    mems.seek(0,0);
    bmp.savetostream(mems);
    ResetHistoTBitmap;
    PaintBox1.Repaint;
    finally
      io.Free;
    end;
  end;
end;





end.
