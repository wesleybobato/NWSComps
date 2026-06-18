unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, hyieutils, iexBitmaps, hyiedefs,
  iesettings, ieopensavedlg, Vcl.StdCtrls, ieview, imageenview, Vcl.Buttons,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.ComCtrls, NWSComps_MultithreadProc,
  iexLayers, iexRulers;

type
  TFormMain = class(TForm)
    ImageEnView1: TImageEnView;
    OpenImageEnDialog1: TOpenImageEnDialog;
    Panel1: TPanel;
    btnLoad: TButton;
    SaveImageEnDialog1: TSaveImageEnDialog;
    Button1: TButton;
    Panel2: TPanel;
    GroupBox_Multi: TGroupBox;
    Label1: TLabel;
    btnProcessMulti: TBitBtn;
    SpinEditThreadsCount: TSpinEdit;
    LabelProcTime_Multi: TLabel;
    rgOverlapMethod: TRadioGroup;
    GroupBox1: TGroupBox;
    GroupBox_Single: TGroupBox;
    btnProcess_Single: TBitBtn;
    LabelProcTime_Single: TLabel;
    GroupBox2: TGroupBox;
    btnResetPic: TBitBtn;
    cbFilter: TComboBox;
    pnGBlur: TPanel;
    SpinEditGBlur: TSpinEdit;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    btnMultiAbort: TBitBtn;
    Label3: TLabel;
    procedure btnLoadClick(Sender: TObject);
    procedure btnProcessMultiClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbFilterClick(Sender: TObject);
    procedure btnProcess_SingleClick(Sender: TObject);
    procedure btnResetPicClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnMultiAbortClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    fMProc: TIEMultiProc_EX;
    fCurFilter: integer;
    fGBlurAmt: integer;
    procedure SetFilter;
    procedure DoProcess(sender:TObject; theIEBitmap: TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent);
    procedure HandleFilterProgress(sender: TObject; per:integer);
    procedure DisableImageenIO;
    procedure EnableImageEnIO;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
  uses math, imageenproc;

var
 FILTER_COLORIZE, FILTER_HSL, FILTER_GBLUR, FILTER_USM, FILTER_MEDIANSHARPEN, FILTER_AUTOSHARPEN, FILTER_WALLIS,
 FILTER_AUTOENHANCE2, FILTER_AUTOENHANCE3, FILTER_SHENCASTAN, FILTER_MEDIANFILTER,
  FILTER_PENCILSKETCH, FILTER_REMOVENOISE: integer;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  fMProc := TIEMultiProc_EX.create;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  fMProc.free;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  cbFilter.items.clear;
  FILTER_COLORIZE := cbFilter.Items.Add('Colorize');
  FILTER_HSL := cbFilter.Items.Add('HSL Variation');
  FILTER_GBLUR := cbFilter.Items.Add('Gaussian Blur');
  FILTER_USM := cbFilter.Items.Add('Unsharp Mask; Radius = 35');
  FILTER_AUTOSHARPEN := cbFilter.Items.Add('AutoSharpen');
  FILTER_MEDIANSHARPEN := cbFilter.Items.Add('Median - Sharpen');
  FILTER_WALLIS := cbFilter.Items.Add('Wallis Filter');
  FILTER_AUTOENHANCE2 := cbFilter.Items.Add('Auto Enhance 2');
  FILTER_AUTOENHANCE3 := cbFilter.Items.Add('Auto Enhance 3');
  FILTER_SHENCASTAN := cbFilter.Items.Add('Shen Castan (Filter Window = 15)');
  FILTER_MEDIANFILTER := cbFilter.Items.Add('Median (Filter Window = 10)');
  FILTER_PENCILSKETCH := cbFilter.Items.Add('Pencil Sketch');
  cbFilter.ItemIndex := FILTER_GBLUR;
  SetFilter;
end;

procedure TFormMain.btnMultiAbortClick(Sender: TObject);
begin
  fMProc.abort;
end;

procedure TFormMain.btnProcessMultiClick(Sender: TObject);
var

  tk: integer;
  bAutoRegulateOverlap: boolean;
  overlap: integer;
  ovMethod: TIEMultiProc_EX_OverlapMethod;
begin
  SetFilter;
  ImageEnView1.Proc.SaveUndo;

  overlap := 0;

  fMProc.OnProgress := HandleFilterProgress;
  try
    ovMethod := TIEMultiProc_EX_OverlapMethod(rgOverlapMethod.itemindex);
    if fCurFilter = FILTER_COLORIZE then
    begin
      overlap := 0;  //all filters that calculate the value of the output pixel
                     //only on the base of the value of a single input pixel do not need any overlap.
                     //for example all filters that manipulate color, contrast, brightness, gamma, etc..
                     //using a 1 -> 1 relation between input pixels and output pixels
                     //they do not need overlap
                     // you can use the above params also for filter such as:
                     //***  proc.HSVvar
                     //proc.IntensityRGBAll
                     //proc.Intensity
                     //proc.GammaCorrect
                     //proc.Contrast
                     //*** proc.MatchHSVRange
                     //proc.ConvertTo
                     //proc.ConvertToBWThreshold
                     //proc.ConvertToGray
                     //proc.CastColorRange
                     //proc.ConvertToSepia
                     //proc.Negative
                     //and others...
                     //the ones marked by *** should gain significant speed advantage in multi-threading
                     //you will get advantage also when processing big images and with more cpu cores
      bAutoRegulateOverlap := false;
    end
    else if fCurFilter = FILTER_HSL then
    begin
      overlap := 0;
      bAutoRegulateOverlap := false;
    end
    else if fCurFilter = FILTER_GBLUR then
    begin
      overlap := round(SpinEditGBlur.value * 1.1);
      //gaussian blur needs overlap, because calculates the value of each pixel
      //based on the values of all surrounding pixels in a given radius
      //the overlap can be fairly estimated as a percent of the radius
      //should be at least 100% of the radius in order to give always reliable results
      //please consider that the bigger the overlap the more slow will be the computation
      bAutoRegulateOverlap := true;
      //this tells the multi-processing algorithm to reduce the overlap
      //internally according to the number of threads used
    end
    else if fCurFilter = FILTER_USM then
    begin
      overlap := 35; //same as the radius we want to apply
      bAutoRegulateOverlap := true;
    end
    else if fCurFilter = FILTER_AUTOSHARPEN then
    begin
      overlap := 4; //4 pixels overlap: You can also increase this value, but 4 should be enough for this filter
                    //because I think it does not look in a radius bigger than 2 pixels
      bAutoRegulateOverlap := false;
    end
    else if fCurFilter = FILTER_WALLIS then
    begin
      overlap := 8;  //8 pixels overlap
      bAutoRegulateOverlap := false;
    end
    else if fCurFilter = FILTER_AUTOENHANCE2 then
    begin
      overlap := max(10, (imageenview1.IEBitmap.width + imageenview1.IEBitmap.Height) div 30);
                 //the autoenhance filters will not give identical results when running in single-thread or in multithread
                 //this is because of the nature of the filter that will need to do certain calculation on the whole image
                 //depending on the type of image the results may be more or less discordant
                 //from the tests done the results were quite similar
      bAutoRegulateOverlap := true;
    end
    else if fCurFilter = FILTER_AUTOENHANCE3 then
    begin
      overlap := max(10, (imageenview1.IEBitmap.width + imageenview1.IEBitmap.Height) div 50);
      bAutoRegulateOverlap := true;
                 //the autoenhance filters will not give identical results when running in single-thread or in multithread
                 //this is because of the nature of the filter that will need to do certain calculation on the whole image
                 //depending on the type of image the results may be more or less discordant
                 //from the tests done the results were quite similar
    end
    else if fCurFilter = FILTER_SHENCASTAN then
    begin
      overlap := 20;  //20 pixels overlap - if you increase the window parameter then this should also increase
      bAutoRegulateOverlap := false;
    end
    else if (fCurFilter = FILTER_MEDIANFILTER)or(fCurFilter = FILTER_MEDIANSHARPEN) then
    begin
      overlap := 25;  //25 pixels overlap for a window filter = 10 - if you increase the window parameter then this should also increase
      bAutoRegulateOverlap := false;
    end
    else if fCurFilter = FILTER_PENCILSKETCH then
    begin
      overlap := max(10, (imageenview1.IEBitmap.width + imageenview1.IEBitmap.Height) div 40);
      bAutoRegulateOverlap := false;
    end;

    DisableImageenIO;  //disable inside here anything in the GUI that can modify the ImageEn content while waiting the filter to finish
                       //NOTICE: this is only needed if you intent the user to be able to abort the process
    screen.Cursor := crhourglass;
    tk := gettickcount;
    //---Multi Thread Processing--------------------------------------------------------------------------------------------------------------
    fMProc.ProcessMessagesWhileInProgress := TRUE; //this allows the user to be able to press the Abort button
    fMProc.Run(SpinEditThreadsCount.Value, imageenview1.IEBitmap, rect(0,0,imageenview1.IEBitmap.width-1, imageenview1.IEBitmap.height-1),
               DoProcess, overlap ,ovMethod, bAutoRegulateOverlap);
    //-----------------------------------------------------------------------------------------------------------------

    LabelProcTime_Multi.caption := 'Process completed in ' + inttostr(gettickcount - tk) + ' ms';
    imageenview1.Update;
  finally
    Screen.Cursor := crdefault;
    EnableImageEnIO; //reenable the gui io for imageen  //NOTICE: this is only needed if you intent the user to be able to abort the process
  end;
end;

procedure TFormMain.DisableImageenIO;
begin
   //disable inside here anything in the GUI that can modify the ImageEn content while waiting the filter to finish
   //NOTICE: this is only needed if you intent the user to be able to abort the process
   btnLoad.Enabled := false;
   btnResetPic.Enabled := false;
   btnProcess_Single.Enabled := false;
   btnProcessMulti.Enabled := false;

end;

procedure TFormMain.EnableImageEnIO;
begin
   //reenable the gui io for imageen
   btnLoad.Enabled := true;
   btnResetPic.Enabled := true;
   btnProcess_Single.Enabled := true;
   btnProcessMulti.Enabled := true;
end;

procedure TFormMain.btnProcess_SingleClick(Sender: TObject);
var
  tk: integer;
begin
  SetFilter;
  ImageEnView1.Proc.SaveUndo;
   try
    screen.Cursor := crhourglass;
    tk := gettickcount;
    DoProcess(nil, ImageEnView1.IEBitmap, rect(0,0, ImageEnView1.IEBitmap.width - 1, ImageEnView1.IEBitmap.Height - 1), HandleFilterProgress);
    LabelProcTime_Single.caption := 'Process completed in ' + inttostr(gettickcount - tk) + ' ms';
    imageenview1.Update;
  finally
    Screen.Cursor := crdefault;
  end;


end;

procedure TFormMain.HandleFilterProgress(sender: TObject; per:integer);
begin
  ProgressBar1.Position := per;
end;

procedure TFormMain.btnResetPicClick(Sender: TObject);
begin
  ImageEnView1.Proc.Undo;
  ProgressBar1.Position := 0;
end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  if SaveImageEnDialog1.Execute then
    ImageEnView1.IO.SaveToFile(SaveImageEnDialog1.FileName);
end;

procedure TFormMain.cbFilterClick(Sender: TObject);
begin
  SetFilter;
  LabelProcTime_Multi.caption := '';
  LabelProcTime_Single.caption := '';
end;

procedure TFormMain.SetFilter;
begin
  fCurFilter := cbFilter.ItemIndex;
  fGBlurAmt := SpinEditGBlur.value;
  pnGBlur.visible := fCurFilter = FILTER_GBLUR;
  
end;



procedure TFormMain.btnLoadClick(Sender: TObject);
begin
   if OpenImageEnDialog1.Execute then
   begin
     ImageEnView1.IO.LoadFromFile(OpenImageEnDialog1.FileName);
     imageenview1.Fit;
   end;

end;




procedure TFormMain.DoProcess(sender:TObject; theIEBitmap:TIEBitmap; EditRect: Trect; FilterProgress: TIEProgressEvent);
var
proc: TImageenproc;
begin

  proc := TImageenproc.create(nil);
  try
    proc.AutoUndo := false;
    proc.AttachedIEBitmap := theIEBitmap;
    proc.OnProgress := FilterProgress;
    if fCurFilter = FILTER_Colorize then
    begin
      proc.Colorize(130, 70, 1.08);
    end
    else if fCurFilter = FILTER_HSL then
    begin
      proc.HSLvar(-30, 10, 20);
    end
    else if fCurFilter = FILTER_GBLUR then
    begin
      proc.Blur(fGBlurAmt);
    end
    else if fCurFilter = FILTER_USM then
    begin
      proc.UnsharpMask(35, 0.7, 0.0);
    end
    else if fCurFilter = FILTER_AUTOSHARPEN then
    begin
      proc.AutoSharp;
    end
    else if fCurFilter = FILTER_WALLIS then
    begin
      proc.WallisFilter;
    end
    else if fCurFilter = FILTER_AUTOENHANCE2 then
    begin
      proc.AutoImageEnhance2;
    end
    else if fCurFilter = FILTER_AUTOENHANCE3 then
    begin
      proc.AutoImageEnhance3;
    end
    else if fCurFilter = FILTER_SHENCASTAN then
    begin
      proc.EdgeDetect_ShenCastan(0.99, 0.9, 15, 0, true);
      proc.ConvertTo24Bit;
    end
    else if fCurFilter = FILTER_MEDIANFILTER then
    begin
      proc.MedianFilter(10, 10);
    end
    else if fCurFilter = FILTER_MEDIANSHARPEN then
    begin
      proc.MedianFilter(10, 10, 50, 50, 25, 50, mfSharpen);
    end
    else if fCurFilter = FILTER_PENCILSKETCH then
    begin
      proc.PencilSketch(true,2,MAXINT, 4, 0.5, 2);
    end;


  finally
    proc.free;

  end;
 end;



initialization

finalization
//ReportMemoryLeaksOnShutdown := true;

end.
