unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  NWSComps_StyleEngine, NWSComps_ThumbsBrowser, Vcl.ExtCtrls,
  NWSComps_ThumbsBrowser_Shell, hyieutils, iexBitmaps, hyiedefs, iesettings,
  ieview, imageenview, iemview;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    PageControl1: TPageControl;
    Tab1: TTabSheet;
    Tab2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    ShProc1: TThumbsBrowserShellProcessor;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    CheckBoxFolderMonitor: TCheckBox;
    ListBox1: TListBox;
    Panel4: TPanel;
    Splitter1: TSplitter;
    Panel6: TPanel;
    ThumbsBrowser2: TThumbsBrowser;
    Panel7: TPanel;
    LabelTb2: TLabel;
    btnFolder2: TButton;
    Panel8: TPanel;
    ThumbsBrowser1: TThumbsBrowser;
    Panel9: TPanel;
    LabelTB1: TLabel;
    btnFolder1: TButton;
    Label1: TLabel;
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ImageEnView1: TImageEnView;
    ImageEnMView1: TImageEnMView;
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure btnFolder1Click(Sender: TObject);
    procedure CheckBoxFolderMonitorClick(Sender: TObject);
    procedure OtherCompDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    procedure SetScenario;
    procedure SetTransferMode;


    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses shlobj, NWSComps_ThumbsBrowser_Shell_Utils;

procedure TForm1.btnFolder1Click(Sender: TObject);
begin
  if sender = btnFolder1 then
    ThumbsBrowser1.PromptForFolder
  else
    ThumbsBrowser2.PromptForFolder;

  labelTB1.Caption := ThumbsBrowser1.folderCurrent;
  labelTB2.Caption := ThumbsBrowser2.folderCurrent;

end;

procedure TForm1.CheckBoxFolderMonitorClick(Sender: TObject);
begin
  ThumbsBrowser1.FolderMonitor_Active := CheckBoxFolderMonitor.Checked;
  ThumbsBrowser2.FolderMonitor_Active := CheckBoxFolderMonitor.Checked;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetScenario;
end;



procedure TForm1.PageControl1Change(Sender: TObject);
begin
  SetScenario;
end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  SetTransferMode;
end;

procedure TForm1.RadioGroup2Click(Sender: TObject);
begin
  SetTransferMode;
end;

procedure TForm1.SetTransferMode;
begin
  if PageControl1.ActivePage = Tab1 then
  begin
    ThumbsBrowser1.DragDropOptions.DropBehavior := ddb_Thumbs;
    ThumbsBrowser2.DragDropOptions.DropBehavior := ddb_Thumbs;
    if RadioGroup1.ItemIndex = 0 then
    begin
      ThumbsBrowser1.DragDropOptions.TransferMode_TB := dd_Copy;
      ThumbsBrowser1.DragDropOptions.TransferMode_Exp := dd_Copy;
      ThumbsBrowser2.DragDropOptions.TransferMode_TB := dd_Copy;
      ThumbsBrowser2.DragDropOptions.TransferMode_Exp := dd_Copy;
    end
    else
    begin
      ThumbsBrowser1.DragDropOptions.TransferMode_TB := dd_Move;
      ThumbsBrowser1.DragDropOptions.TransferMode_Exp := dd_Move;
      ThumbsBrowser2.DragDropOptions.TransferMode_TB := dd_Move;
      ThumbsBrowser2.DragDropOptions.TransferMode_Exp := dd_Move;
    end;
  end
  else if PageControl1.ActivePage = Tab2 then
  begin
    ThumbsBrowser1.DragDropOptions.DropBehavior := ddb_Files;
    ThumbsBrowser2.DragDropOptions.DropBehavior := ddb_Files;
    if RadioGroup2.ItemIndex = 0 then
    begin
      ThumbsBrowser1.DragDropOptions.TransferMode_TB := dd_Copy;
      ThumbsBrowser1.DragDropOptions.TransferMode_Exp := dd_Copy;
      ThumbsBrowser2.DragDropOptions.TransferMode_TB := dd_Copy;
      ThumbsBrowser2.DragDropOptions.TransferMode_Exp := dd_Copy;
    end
    else
    begin
      ThumbsBrowser1.DragDropOptions.TransferMode_TB := dd_Move;
      ThumbsBrowser1.DragDropOptions.TransferMode_Exp := dd_Move;
      ThumbsBrowser2.DragDropOptions.TransferMode_TB := dd_Move;
      ThumbsBrowser2.DragDropOptions.TransferMode_Exp := dd_Move;
    end;
  end;
end;

procedure TForm1.SetScenario;
begin
  SetTransferMode;
  ThumbsBrowser1.ClearThumbs;
  ThumbsBrowser2.ClearThumbs;
  ThumbsBrowser1.DragDropOptions.RegisterTarget(ListBox1);
  ThumbsBrowser2.DragDropOptions.RegisterTarget(ListBox1);
  ThumbsBrowser1.DragDropOptions.RegisterTarget(Imageenview1);
  ThumbsBrowser2.DragDropOptions.RegisterTarget(Imageenview1);
  ThumbsBrowser1.DragDropOptions.RegisterTarget(ImageenMview1);
  ThumbsBrowser2.DragDropOptions.RegisterTarget(ImageenMview1);

  if PageControl1.ActivePage = Tab1 then
  begin
    ThumbsBrowser1.FolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYPICTURES);
    ThumbsBrowser1.DragDropOptions.IS_DragSource_TB := TRUE;
    ThumbsBrowser1.DragDropOptions.IS_DragSource_Explorer := FALSE;
    ThumbsBrowser1.DragDropOptions.IS_DropTarget_TB := TRUE;
    ThumbsBrowser1.DragDropOptions.IS_DropTarget_Explorer := FALSE;

    ThumbsBrowser2.DragDropOptions.IS_DragSource_TB := FALSE;
    ThumbsBrowser2.DragDropOptions.IS_DragSource_Explorer := FALSE;
    ThumbsBrowser2.DragDropOptions.IS_DropTarget_TB := TRUE;
    ThumbsBrowser2.DragDropOptions.IS_DropTarget_Explorer := TRUE;

  end
  else if PageControl1.ActivePage = Tab2 then
  begin
    ThumbsBrowser1.FolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYPICTURES);
    ThumbsBrowser2.FolderCurrent := tbs_GetSpecialFolderPath(CSIDL_MYDOCUMENTS);
    //in this scenario we need custom implementation of DragDrop

    ThumbsBrowser1.DragDropOptions.IS_DragSource_TB := TRUE;
    ThumbsBrowser1.DragDropOptions.IS_DragSource_Explorer := TRUE;
    ThumbsBrowser1.DragDropOptions.IS_DropTarget_TB := TRUE;
    ThumbsBrowser1.DragDropOptions.IS_DropTarget_Explorer := TRUE;

    ThumbsBrowser2.DragDropOptions.IS_DragSource_TB := TRUE;
    ThumbsBrowser2.DragDropOptions.IS_DragSource_Explorer := TRUE;
    ThumbsBrowser2.DragDropOptions.IS_DropTarget_TB := TRUE;
    ThumbsBrowser2.DragDropOptions.IS_DropTarget_Explorer := TRUE;

  end;

  labelTB1.Caption := ThumbsBrowser1.folderCurrent;
  labelTB2.Caption := ThumbsBrowser2.folderCurrent;
  btnFolder1.Visible := ThumbsBrowser1.FolderCurrent <> '';
  btnFolder2.Visible := ThumbsBrowser2.FolderCurrent <> '';
  ListBox1.visible := PageControl1.ActivePage = Tab1;
end;



procedure TForm1.OtherCompDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  I: integer;
begin
  if not (Source is TThumbsBrowser) then EXIT;

  with Source as TThumbsbrowser do
  begin
    if sender is Tlistbox then
    begin
       for I := 0 to SelectedCount-1 do
         Tlistbox(sender).Items.add(getselected(i).SourceFileNameShort);
    end
    else if sender is TImageEnview then
    begin
      TImageEnview(sender).IO.loadfromfile(getselected(0).SourceFileName);
      TImageEnview(sender).Update;
    end
    else if sender is TImageEnMview then
    begin
      for I := 0 to SelectedCount-1 do
        TImageEnMView(sender).InsertImage(0, getselected(i).SourceFileName);

      TImageEnMView(sender).Update;
    end;

    if DragDropOptions.TransferMode_TB = dd_Move then
    begin
      LockUpdate;
      try
        for I := SelectedCount-1 downto 0 do
        begin
          Delete_a_Thumb(getselected(i));;
        end;
      finally
        UnlockUpdate;
      end;
    end;
  end;
end;

end.
