unit frmPE_BasicEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Controls, Forms, Dialogs, ExtCtrls,  Buttons,
  StdCtrls, hyieutils, iexBitmaps, hyiedefs,
  iesettings, imageenproc, ComCtrls, ImgList, ToolWin, ieview, imageenview,
  NWSComps_IEPaintengine_Manager, NWSComps_IEPaintengine_Types, NWSComps_IEPaintengine_Utils, JH_WinTab, ieopensavedlg,
  iexLayers, iexRulers;

type
  TFormPE_BasicEditor = class(TForm)
    ImageEnView1: TImageEnView;
    il1: TImageList;
    PEM1: TImageEnPaintEngineManager;
    Panel1: TPanel;
    Shape1: TShape;
    ColorDialog1: TColorDialog;
    tbRadius: TTrackBar;
    Label1: TLabel;
    JanHWinTab1: TJanHWinTab;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    tbPanZoom: TToolButton;
    TBPaint: TToolButton;
    TBPaintUndo: TToolButton;
    TBSelect: TToolButton;
    il2: TImageList;
    Panel3: TPanel;
    btnUndo: TBitBtn;
    btnRedo: TBitBtn;
    btnLoad: TBitBtn;
    OpenImageEnDialog1: TOpenImageEnDialog;
    Label2: TLabel;
    tbOpacity: TTrackBar;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    CheckBox_TabletRadius: TCheckBox;
    CheckBox_TabletOpacity: TCheckBox;
    ComboBox_BlendMode_Color: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Shape1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);

    procedure btnLoadClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure tbRadiusChange(Sender: TObject);
  private
    { Private declarations }
    fpeHistoryBMP: TIEBitmap;
    fPeModePaint: boolean;

    procedure TBClick(Sender: TObject);
    procedure SetEditorMode;

    procedure SaveUndo;

  public
    { Public declarations }

  end;

var
  FormPE_BasicEditor: TFormPE_BasicEditor;

implementation
  uses math;
{$R *.dfm}



procedure TFormPE_BasicEditor.FormCreate(Sender: TObject);
var
  I: Integer;
begin

  for I := 0 to ToolBar1.ButtonCount-1 do
    toolbar1.Buttons[i].OnClick := TBClick;


  Imageenview1.Proc.UndoLocation := ieMemory;
  Imageenview1.Proc.UndoLimit := 20;
 // imageenview1.LayersSync := false;
  ImageEnView1.IEBitmap.width := 1250;
  ImageEnView1.IEBitmap.height := 1250;
  imageenview1.IEBitmap.FillRect(0,0, 1250, 1250, rgb(255, 255, 255));
  imageenview1.IEBitmap.AlphaChannel.FillRect(0,0, 1250, 1250, rgb(0, 0, 0));

  fpeHistoryBMP := tIEbitmap.create;
  fpeHistoryBMP.assign(Imageenview1.IEBitmap);
  PEM1.Params_History.Historybitmap := fpeHistoryBMP;

  SetEditorMode;


end;

procedure TFormPE_BasicEditor.FormDestroy(Sender: TObject);
begin
  fpeHistoryBMP.free;
  PEM1.StopCursorNoPaint;
end;

procedure TFormPE_BasicEditor.ImageEnView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if fPeModePaint then
  begin
    SaveUndo;

   if TBPaint.Down then
   begin
      pem1.Params_Paint.BlendMode := tbeBlendMode(ComboBox_BlendMode_Color.itemindex);
   end
   else if TBPaintUndo.Down then  //for history tool (eraser tool) set always normal blendmode
   begin
      pem1.Params_Paint.BlendMode := blmnormal;
   end;

  if pem1.Params_Paint.BlendMode = blmnormal then
    pem1.Params_Paint.SessionMode := sm_IgnoreSessionMemory
  else
    pem1.Params_Paint.SessionMode := sm_KeepSessionMemory_UntilNext;

    pem1.Params_Paint.ContinuousPainting := false;
    pem1.Params_Tablet.PressureSensitive := true;
    pem1.Params_Tablet.PressureDynamics := [];
    if CheckBox_TabletOpacity.Checked then
      pem1.Params_Tablet.PressureDynamics := pem1.Params_Tablet.PressureDynamics + [pdBrushOpacity];
    if CheckBox_TabletRadius.Checked then
      pem1.Params_Tablet.PressureDynamics := pem1.Params_Tablet.PressureDynamics + [pdBrushRadius];

    pem1.Params_Color.Color := shape1.Brush.color;
    pem1.Params_Paint.Radius := tbRadius.Position;
    pem1.Params_Paint.Transparence := 255 - tbOpacity.Position;
    pem1.Params_Paint.Step := round((0.1 + tbRadius.Position/1300) * tbRadius.Position);

    if pem1.Params_Paint.SessionMode = sm_IgnoreSessionMemory then //increase the step to enhance transparency effect
        pem1.Params_Paint.Step := round(pem1.Params_Paint.Step * (1 + 2 * max(0, (1 - pem1.Params_Paint.Radius/50)) * sqrt(pem1.Params_Paint.Transparence/255)));
    pem1.StartPainting; //commands the pe to start painting
  end;
end;

procedure TFormPE_BasicEditor.ImageEnView1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if pem1.IsRunning then
  begin
    pem1.StopPainting; //commands the pe to stop
  end;
end;



procedure TFormPE_BasicEditor.btnUndoClick(Sender: TObject);
begin
  imageenview1.Proc.SaveRedo;
  imageenview1.Proc.Undo;
  imageenview1.Proc.ClearUndo;
end;

procedure TFormPE_BasicEditor.btnRedoClick(Sender: TObject);
begin
  imageenview1.Proc.SaveUndo;
  imageenview1.Proc.Redo;
  imageenview1.Proc.ClearRedo;
end;

procedure TFormPE_BasicEditor.SaveUndo;
begin
  imageenview1.Proc.SaveUndo;
  imageenview1.Proc.ClearAllRedo;
end;


procedure TFormPE_BasicEditor.TBClick(Sender: TObject);
begin
  SetEditorMode;
end;

procedure TFormPE_BasicEditor.SetEditorMode;
begin
  if tbPanZoom.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [miZoom, miScroll];
    fPeModePaint := false;
  end
  else if TBPaint.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [];
    pem1.Init(imageenview1, pemColor);
    fPeModePaint := true;
  end
  else if TBPaintUndo.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [];
    pem1.Init(imageenview1, pemHistory);
    fPeModePaint := true;
  end
  else if TBSelect.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [miSelectLasso];
    fPeModePaint := false;
  end;

  if fPeModePaint then
    pem1.StartCursorNoPaint(imageenview1, tbRadius.Position)
  else
    pem1.StopCursorNoPaint;
end;

procedure TFormPE_BasicEditor.Shape1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ColorDialog1.execute then
    shape1.Brush.color := ColorDialog1.color;
end;

procedure TFormPE_BasicEditor.tbRadiusChange(Sender: TObject);
begin
  PEM1.Params_Paint.Radius := tbRadius.position;
  if fPeModePaint then
    pem1.StartCursorNoPaint(imageenview1, tbRadius.Position);
end;

procedure TFormPE_BasicEditor.TrackBar1Change(Sender: TObject);
begin
  imageenview1.Zoom := TrackBar1.Position;
  imageenview1.refresh;
end;


procedure TFormPE_BasicEditor.btnLoadClick(Sender: TObject);
begin
  if OpenImageEnDialog1.execute then
  begin
    imageenview1.IO.LoadFromFileAuto(OpenImageEnDialog1.FileName);
    imageenview1.Fit;
    TrackBar1.Position := round(ImageEnView1.Zoom);

    fpeHistoryBMP.Assign(imageenview1.iebitmap);
    PEM1.Params_History.Historybitmap := fpeHistoryBMP;
    PEM1.Session_Reset;
  end;
end;

initialization

finalization
 ReportMemoryLeaksOnShutdown := true;
end.
