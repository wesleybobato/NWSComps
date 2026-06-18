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
    ColorDialog1: TColorDialog;
    tbRadius: TTrackBar;
    Label1: TLabel;
    JanHWinTab1: TJanHWinTab;
    Panel2: TPanel;
    ToolBar1: TToolBar;
    tbPanZoom: TToolButton;
    TBRemoveBg: TToolButton;
    TBSelect: TToolButton;
    il2: TImageList;
    Panel3: TPanel;
    btnUndo: TBitBtn;
    btnRedo: TBitBtn;
    btnLoad: TBitBtn;
    OpenImageEnDialog1: TOpenImageEnDialog;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    CheckBox_TabletRadius: TCheckBox;
    CheckBox_TabletOpacity: TCheckBox;
    Checkbox_Selective: TCheckBox;
    tbTolerance: TTrackBar;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ImageEnView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageEnView1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);

    procedure btnLoadClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure tbRadiusChange(Sender: TObject);
    procedure Button1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure ImageEnView1SelectionChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

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

{$R *.dfm}

procedure TFormPE_BasicEditor.FormCreate(Sender: TObject);
var
  I: Integer;
begin

  for I := 0 to ToolBar1.ButtonCount-1 do
    toolbar1.Buttons[i].OnClick := TBClick;


  Imageenview1.Proc.UndoLocation := ieMemory;
  Imageenview1.Proc.UndoLimit := 20;

  ImageEnView1.IEBitmap.width := 1250;
  ImageEnView1.IEBitmap.height := 1250;
  imageenview1.IEBitmap.FillRect(0,0, 1250, 1250, rgb(255, 255, 255));
  imageenview1.IEBitmap.AlphaChannel.FillRect(0,0, 1250, 1250, rgb(0, 0, 0));
  PEM1.StartCursorNoPaint(imageenview1,tbRadius.Position);

  SetEditorMode;
end;

procedure TFormPE_BasicEditor.ImageEnView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if fPeModePaint then
  begin
    SaveUndo;


    pem1.Params_Paint.BlendMode := blmnormal;
    pem1.Params_Paint.SessionMode := sm_KeepSessionMemory_UntilNext;


    pem1.Params_Paint.ContinuousPainting := false;
    pem1.Params_Tablet.PressureSensitive := true;
    pem1.Params_Tablet.PressureDynamics := [];
    if CheckBox_TabletOpacity.Checked then
      pem1.Params_Tablet.PressureDynamics := pem1.Params_Tablet.PressureDynamics + [pdBrushOpacity];
    if CheckBox_TabletRadius.Checked then
      pem1.Params_Tablet.PressureDynamics := pem1.Params_Tablet.PressureDynamics + [pdBrushRadius];


    pem1.Params_Paint.Radius := tbRadius.Position;
    pem1.Params_Paint.Transparence := 0;
    pem1.Params_Paint.Step := round((0.1 + tbRadius.Position/1000) * tbRadius.Position);

    pem1.Params_Paint.Selective := Checkbox_Selective.checked;
    pem1.Params_Paint.SelTolerance := tbTolerance.Position;

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



procedure TFormPE_BasicEditor.ImageEnView1SelectionChange(Sender: TObject);
begin
  Button2.Enabled := ImageEnView1.Selected;
  Button3.Enabled := ImageEnView1.Selected;

end;

procedure TFormPE_BasicEditor.btnUndoClick(Sender: TObject);
begin
  imageenview1.Proc.SaveRedo;
  imageenview1.Proc.Undo;
  imageenview1.Proc.ClearUndo;
end;

procedure TFormPE_BasicEditor.Button1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ImageEnView1.BackgroundStyle := iebsSolid;
  ImageEnView1.Background := clRed;
end;

procedure TFormPE_BasicEditor.Button1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ImageEnView1.BackgroundStyle := iebsChessboard;
  ImageEnView1.Background := clBtnFace;
end;

procedure TFormPE_BasicEditor.Button2Click(Sender: TObject);
begin
  ImageEnView1.DeSelect;
end;

procedure TFormPE_BasicEditor.Button3Click(Sender: TObject);
begin
  ImageEnView1.InvertSelection;
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
  else if TBRemoveBg.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [];
    pem1.Init(imageenview1, pemEraseLayer);
    fPeModePaint := true;
  end
  else if TBSelect.Down then
  begin
    ImageEnView1.MouseInteractGeneral := [miSelectLasso];
    fPeModePaint := false;
  end;

  pem1.Params_Paint.ShowBrushWhenNotRunning := fPeModePaint;
end;

procedure TFormPE_BasicEditor.tbRadiusChange(Sender: TObject);
begin
  PEM1.Params_Paint.Radius := tbRadius.position;
  PEM1.StartCursorNoPaint(imageenview1,tbRadius.Position);
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
   // imageenview1.Fit;
    TrackBar1.Position := round(ImageEnView1.Zoom);

    if not ImageEnView1.IEBitmap.HasAlphaChannel then  //we need to create one
      ImageEnView1.IEBitmap.AlphaChannel.Fill(255);

    if ImageEnView1.AlphaChannel.Full then
    begin
      //to change the status of ImageEnView1.IEBitmap.AlphaChannel.Full we need this trick..
      //otherwise (because we are editing the background layer)
      // imageen will not take into account the display of the alpha channel when we edit it
      ImageEnView1.IEBitmap.AlphaChannel.Pixels_ie8[0,0] := 254;
      ImageEnView1.IEBitmap.AlphaChannel.Pixels_ie8[0,0] := 255;
    end;


    PEM1.Session_Reset;
  end;
end;

initialization

finalization
 ReportMemoryLeaksOnShutdown := true;
end.
