unit frmMain;

interface

{$I Demo_TB_Layout.inc}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Samples.Spin,
  NWSComps_ThumbsBrowser, NWSComps_ThumbsBrowser_Thumbs, NWSComps_ThumbsBrowser_Utils_Types, Vcl.CheckLst,
  Vcl.Menus, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  NWSComps_StyleEngine;

type
  TFormMain = class(TForm)
    PopupMenu1: TPopupMenu;
    ab1: TMenuItem;
    cde1: TMenuItem;
    Panel2: TPanel;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    CheckListBox1: TCheckListBox;
    Panel_VCLStyles: TPanel;
    Label4: TLabel;
    ComboBox_VCLStyles: TComboBox;
    GroupBox1: TGroupBox;
    CheckBox_showCheckboxes: TCheckBox;
    CheckBox_InfoBox: TCheckBox;
    CheckBox_ShowHint: TCheckBox;
    CheckBox_RotateBtns: TCheckBox;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    GroupBox2: TGroupBox;
    CheckBox_DropShadow: TCheckBox;
    CheckBox_CaptionsInFrame: TCheckBox;
    CheckBox_BgGradient: TCheckBox;
    Label1: TLabel;
    Panel4: TPanel;
    tb1: TThumbsBrowser;
    Panel_Lang: TPanel;
    Label2: TLabel;
    cbLang: TComboBox;
    procedure RadioGroup1Click(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure ComboBox_VCLStylesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox_CaptionsInFrameClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure tb1CaptionsOrderChanged(Sender: TObject);
    procedure CheckBox_ShowHintClick(Sender: TObject);
    procedure CheckBox_InfoBoxClick(Sender: TObject);
    procedure CheckBox_RotateBtnsClick(Sender: TObject);
    procedure CheckBox_showCheckboxesClick(Sender: TObject);
    procedure CheckBox_DropShadowClick(Sender: TObject);
    procedure CheckBox_BgGradientClick(Sender: TObject);
    procedure tb1ThumbLoaded(theThumb: TThumbEx; const Idx: Integer);
    procedure tb1ThumbLayoutAssigned(theThumb: TThumbEx; const Idx: Integer);
    procedure cbLangClick(Sender: TObject);
  private
    { Private declarations }

    procedure ChangeLayout;
    procedure LoadListofCaptions;
    procedure ApplyCaptions;
    procedure ReflectTBProperties;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses themes,  NWSComps_Types;
{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
begin
  tb1.ClearThumbs;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  tb1.PromptForFolder;
end;

procedure TFormMain.cbLangClick(Sender: TObject);
begin
  case cblang.ItemIndex of
    0: NWSCOMPS.Language := nwsLng_EN;
    1: NWSCOMPS.Language := nwsLng_DE;
    2: NWSCOMPS.Language := nwsLng_IT;
    3: NWSCOMPS.Language := nwsLng_ES;
  end;
end;

procedure TFormMain.ChangeLayout;
begin

  tb1.LockLayout;
  try

    case RadioGroup1.itemindex of
      0:
        begin
          tb1.SetStyleEx(tbStyle_ThumbsV);
          Panel_Lang.Visible := false;
          // or you can set   tb1.StyleOptions.BrowserStyle := tbStyle_ThumbsV;
          { SetStyleEx(const theStyle: TTB_Browser_Style;  //the style you desire
            const theCaptions: TTB_Thumb_CaptionsSettings = []; //the captions (if you want to change the ones that are already displayed)
            dbThumbZoom: double = -1; //the zoom of the picture thumb respect to the Buffer_ThumbSize (for ex. 50, 70, 100 percent)
            //if value is < 0 default value will be used for the zoom according to the style
            //if storetype is tbstore_fullimage the zoom will be calculated using a default thumb size
            const bAdjustSpacing: boolean = True; //if true will adjust the spacing of the thumbnails
            const bAdjustStyle: boolean = True  //if true will adjust some style elements such as size of frame border, etc..
            ); }
          { //you can achieve styles also manually by setting the params below
            tb1.MaxCols := -1;
            tb1.MaxRows := -1;
            tb1.ThumbSizeW := 140;
            tb1.ThumbSizeH := 120;
            tb1.BrowsingOrientation := tbo_vert;
            tb1.ThumbLayoutType := ltVertical;
            tb1.StyleOptions.CaptionsOptions.Style := capSt_RowsCentered;
            tb1.ThumbsSpacing := 4;
          }
        end;
      1:
        begin
          tb1.SetStyleEx(tbStyle_ThumbsH);

          Panel_Lang.Visible := false;
          // or you can set   tb1.StyleOptions.BrowserStyle := tbStyle_ThumbsH;
          { //you can achieve styles also manually by setting the params below
            tb1.MaxCols := -1;   //it tells we do not want any limit on the columns
            tb1.MaxRows := -1;   //it tells we do not want any limit on the rows
            tb1.ThumbSizeW := 140;
            tb1.ThumbSizeH := 120;
            tb1.BrowsingOrientation := tbo_vert; //vertical browsing
            tb1.ThumbLayoutType := ltVertical;  //thumb has caption at the bottom
            tb1.StyleOptions.CaptionsOptions.Style := capSt_RowsCentered;  //captions are in row and are centered
            tb1.ThumbsSpacing := 4;
          }
        end;
      2:
        begin
          tb1.SetStyleEx(tbStyle_DetailsV);
          Panel_Lang.Visible := false;
          // or you can set   tb1.StyleOptions.BrowserStyle := tbStyle_DetailsV;
          { //you can achieve styles also manually by setting the params below
            tb1.MaxCols := -1;
            tb1.MaxRows := -1;
            tb1.Centered := false;
            tb1.BrowsingOrientation := tbo_vert;
            tb1.ThumbLayoutType := ltHorizontal;
            tb1.StyleOptions.CaptionsOptions.SizePerc_HorzLayout := 200;
            tb1.StyleOptions.CaptionsOptions.Style := capSt_Rows;
            tb1.ThumbsSpacingX := 6;
            tb1.ThumbsSpacingY := 6;
          }
        end;
      3:
        begin
          tb1.SetStyleEx(tbStyle_DetailsH);
          tb1.StyleOptions.CaptionsOptions.SizePerc_HorzLayout := 180;
          Panel_Lang.Visible := false;
          // or you can set   tb1.StyleOptions.BrowserStyle := tbStyle_DetailsH;
          { //you can achieve styles also manually by setting the params below
            tb1.MaxCols := -1;
            tb1.MaxRows := -1;
            tb1.Centered := false;
            tb1.BrowsingOrientation := tbo_horz;
            tb1.ThumbLayoutType := ltHorizontal;
            tb1.StyleOptions.CaptionsOptions.SizePerc_HorzLayout := 200;
            tb1.StyleOptions.CaptionsOptions.Style := capSt_Rows;
            tb1.ThumbsSpacingX := 6;
            tb1.ThumbsSpacingY := 6;
          }
        end;
      4:
        begin
          tb1.SetStyleEx(tbStyle_Columns);
          tb1.ThumbCaptionIncludeInFrame := true;
          Panel_Lang.Visible := true;
          // or you can set   tb1.StyleOptions.BrowserStyle := tbStyle_Columns;
          { //you can achieve styles also manually by setting the params below
            tb1.MaxCols := 1;
            tb1.MaxRows := -1;
            tb1.Centered := false;
            tb1.ThumbSizeW := round(SpinEdit_ThumbWidth.Value * SpinEdit_Zoom.value / 100);
            tb1.ThumbSizeH := round(SpinEdit_ThumbHeight.Value * SpinEdit_Zoom.value / 100);
            tb1.BrowsingOrientation := tbo_vert;
            tb1.ThumbLayoutType := ltHorizontal;
            tb1.BrowserStyleOptions.CaptionStyle.SizePerc_HorzLayout := round(((tb1.DisplayRect.Right - tb1.DisplayRect.Left) -  tb1.ThumbSizeW - 20 ) /  tb1.ThumbSizeW * 100);
            tb1.BrowserStyleOptions.CaptionStyle.Style := capSt_Cols;
            tb1.ThumbsSpacingX := 8;
            tb1.ThumbsSpacingY := 0;
          }
        end;
    end;

  finally
    tb1.UnlockLayout;
  end;

  ReflectTBProperties;
end;

procedure TFormMain.ReflectTBProperties;
begin
  CheckBox_CaptionsInFrame.Checked := tb1.ThumbCaptionIncludeInFrame;
  CheckBox_showCheckboxes.Checked := tb1.ShowCheckBoxes;
  CheckBox_ShowHint.Checked := tb1.ShowThumbnailHint;
  CheckBox_InfoBox.Checked := tb1.ShowInfoButton;
  CheckBox_RotateBtns.Checked := tb1.ShowRotateButtons;
  CheckBox_DropShadow.Checked := tb1.ThumbDropShadow.Enabled;
  CheckBox_BgGradient.Checked := tb1.BackgroundType = tbbgt_GradientV;
end;

procedure TFormMain.LoadListofCaptions;
var
  i: Integer;
  cap: TTB_Thumb_CaptionsSetting;
  s: string;
begin
  // the order of the captions is defined by the ThumbCaptionOrder property
  // you can change the order by code for example:
  // tb1.ThumbCaptionOrder[1] := ord(cap_ShowRating); //this will move the cap_ShowRating caption to the 2nd position
  // the order can also be changed by dragging the header columns by mouse when style is tbStyle_Columns

  CheckListBox1.Items.BeginUpdate;
  CheckListBox1.clear;
  for i := ord(Low(TTB_Thumb_CaptionsSetting)) to ord(High(TTB_Thumb_CaptionsSetting)) do
  begin
    cap := TTB_Thumb_CaptionsSetting(tb1.ThumbCaptionOrder[i]);
    case cap of
      cap_ShowFileName:
        s := 'File Name';
      cap_ShowDateTime:
        s := 'File Date-Time';
      cap_ShowFileSize:
        s := 'File Size';
      cap_ShowDimensions:
        s := 'Picture Dimensions';
      cap_ShowEXIFDateTime:
        s := 'File Exif Date-Time';
      cap_ShowEXIF_XPAuthor:
        s := 'File Exif Windows Author';
      cap_ShowEXIF_XPTitle:
        s := 'File Exif Windows Title';
      cap_ShowEXIF_XPSubject:
        s := 'File Exif Windows Subject';
      cap_ShowEXIF_XPComment:
        s := 'File Exif Windows Comment';
      cap_ShowEXIF_XPKeywords:
        s := 'File Exif Windows Keywords';
      cap_ShowEXIF_XPRating:
        s := 'File Exif Windows Rating';
      cap_ShowKeywords:
        s := 'Keywords';
      cap_ShowRating:
        s := 'Rating';
      cap_ShowFileNameWithoutExtension:
        s := 'File Name without extension';
      cap_ShowFilePath:
        s := 'File Path';
      cap_ShowFileDimensionsAndSize:
        s := 'File Dimensions and Size';
      cap_ShowCreateDate:
        s := 'File Create Date';
      cap_ShowCreateDateAndTime:
        s := 'File Create Date-Time';
      cap_ShowEditDate:
        s := 'File Modified Date';
      cap_ShowEditDateAndTime:
        s := 'File Modified Date-Time';
      cap_ShowFileType:
        s := 'File Type';
      cap_ShowTopTitle:
        s := 'Top Title';
      cap_ShowBottomTitle:
        s := 'Bottom Title';
      cap_ShowCustomMetaData:
        s := 'Custom Meta Data';
      cap_General:
        s := 'General Caption';
      cap_Empty:
      s := 'Empty';
    else
      s := 'Other';
    end;
    CheckListBox1.Items.Add(s);

    if (cap in tb1.ThumbCaption_Settings) then
      CheckListBox1.Checked[CheckListBox1.Items.count - 1] := true
    else
      CheckListBox1.Checked[CheckListBox1.Items.count - 1] := false;
  end;
  CheckListBox1.Items.EndUpdate;

  ApplyCaptions;
end;

procedure TFormMain.ApplyCaptions;
var
  i: Integer;
  caps: TTB_Thumb_CaptionsSettings;
begin
  caps := [];
  for i := 0 to CheckListBox1.Items.count - 1 do
  begin
    if CheckListBox1.Checked[i] then
    begin
      caps := caps + [TTB_Thumb_CaptionsSetting(tb1.ThumbCaptionOrder[i])];
    end;
  end;
  tb1.ThumbCaption_Settings := caps;
end;

procedure TFormMain.CheckBox_BgGradientClick(Sender: TObject);
begin
  if CheckBox_BgGradient.Checked then
    tb1.BackgroundType := tbbgt_GradientV
  else
    tb1.BackgroundType := tbbgt_SolidColor;
end;

procedure TFormMain.CheckBox_CaptionsInFrameClick(Sender: TObject);
begin
  tb1.ThumbCaptionIncludeInFrame := CheckBox_CaptionsInFrame.Checked;
end;

procedure TFormMain.CheckBox_DropShadowClick(Sender: TObject);
begin
  tb1.ThumbDropShadow.Enabled := CheckBox_DropShadow.Checked;
end;

procedure TFormMain.CheckBox_InfoBoxClick(Sender: TObject);
begin
  tb1.ShowInfoButton := CheckBox_InfoBox.Checked;
end;

procedure TFormMain.CheckBox_RotateBtnsClick(Sender: TObject);
begin
  tb1.ShowRotateButtons := CheckBox_RotateBtns.Checked;
end;

procedure TFormMain.CheckBox_showCheckboxesClick(Sender: TObject);
begin
  tb1.ShowCheckBoxes := CheckBox_showCheckboxes.Checked;
end;

procedure TFormMain.CheckBox_ShowHintClick(Sender: TObject);
begin
  tb1.ShowThumbnailHint := CheckBox_ShowHint.Checked;
end;

procedure TFormMain.CheckListBox1ClickCheck(Sender: TObject);
begin
  ApplyCaptions;
end;

procedure TFormMain.ComboBox_VCLStylesClick(Sender: TObject);
begin
{$IFDEF VCLSTYLES}
  TStyleManager.TrySetStyle(ComboBox_VCLStyles.Items[ComboBox_VCLStyles.itemindex]);
{$ENDIF}
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // tb1.Add_File()
{$IFDEF VCLSTYLES}
  for i := 0 to high(TStyleManager.StyleNames) do
    if TStyleManager.StyleNames[i] <> 'Windows' then
      ComboBox_VCLStyles.Items.Add(TStyleManager.StyleNames[i]);

  // StyleServices.Theme
{$ELSE}
  Panel_VCLStyles.visible := false;
{$ENDIF}


  tb1.ThumbCaptionOrder[0] := ord(cap_ShowFileName);
  tb1.ThumbCaptionOrder[1] := ord(cap_ShowDimensions);
  tb1.ThumbCaptionOrder[2] := ord(cap_ShowFileSize);
  tb1.ThumbCaptionOrder[3] := ord(cap_ShowDateTime);
  tb1.ThumbCaptionOrder[4] := ord(cap_Empty); //added to keep the columns close to each other in report view
  tb1.ThumbCaption_Settings := [cap_ShowFileName, cap_ShowDimensions, cap_ShowFileSize, cap_ShowDateTime, cap_Empty];
  tb1.ThumbCaptionColumnPercWidth[0] := 25;
  tb1.ThumbCaptionColumnPercWidth[1] := 15;
  tb1.ThumbCaptionColumnPercWidth[2] := 10;
  tb1.ThumbCaptionColumnPercWidth[3] := 20;
  tb1.ThumbCaptionColumnPercWidth[4] := 30;
  LoadListofCaptions;
  ChangeLayout;
  ReflectTBProperties;
end;

procedure TFormMain.RadioGroup1Click(Sender: TObject);
begin
  ChangeLayout;
end;

procedure TFormMain.tb1CaptionsOrderChanged(Sender: TObject);
begin
  LoadListofCaptions;
end;

procedure TFormMain.tb1ThumbLayoutAssigned(theThumb: TThumbEx; const Idx: Integer);
begin
  if (theThumb.SourceType = st_Folder) or (theThumb.SourceType = st_FolderNav) then
    if theThumb.FrameBgColor <> tb1.ThumbsCaptionBackColor then
      theThumb.FrameBgColor := tb1.ThumbsCaptionBackColor;
end;

procedure TFormMain.tb1ThumbLoaded(theThumb: TThumbEx; const Idx: Integer);
begin
  if (theThumb.SourceType = st_Folder) or (theThumb.SourceType = st_FolderNav) then
    if theThumb.FrameBgColor <> tb1.ThumbsCaptionBackColor then
      theThumb.FrameBgColor := tb1.ThumbsCaptionBackColor;
end;

end.
