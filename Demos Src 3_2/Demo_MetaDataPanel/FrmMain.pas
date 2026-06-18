unit FrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,  Vcl.StdCtrls,
  Vcl.ExtCtrls, ieview, imageenview, Vcl.Grids, Vcl.ComCtrls, Vcl.Buttons,
  hyieutils, iexBitmaps, hyiedefs, imageenio, iesettings, ieopensavedlg,
  NWSComps_ThumbsBrowser_ExifIptc, NWSComps_ThumbsBrowser_Utils_Types, NWSComps_Types;

type
  TFormMain = class(TForm)
    ImageEnView1: TImageEnView;
    Panel1: TPanel;
    ListBox1: TListBox;
    OpenImageEnDialog1: TOpenImageEnDialog;
    Panel2: TPanel;
    Panel3: TPanel;
    btnLoadFiles1: TButton;
    btnLoadFiles2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    metadataPanel1: TThumbsBrowser_ExifIptcPanel;
    rgTags: TRadioGroup;
    btnDefineCustomTags: TButton;
    Panel4: TPanel;
    btnSaveMeta: TButton;
    btnAddExif: TButton;
    btnAddIptc: TButton;
    Panel5: TPanel;
    ComboBox_Language: TComboBox;
    Label1: TLabel;
    procedure btnLoadFiles1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure metadataPanel1Modified(sender: TObject;
      theField: TThumbsbrowser_MetaData_Field);
    procedure metadataPanel1FileInfoSaved(sender: TObject;
      theFileRcd: TThumbsbrowser_MetaData_FileRcd);
    procedure btnSaveMetaClick(Sender: TObject);
    procedure btnAddExifClick(Sender: TObject);
    procedure btnAddIptcClick(Sender: TObject);
    procedure btnLoadFiles2Click(Sender: TObject);
    procedure rgTagsClick(Sender: TObject);

    procedure btnDefineCustomTagsClick(Sender: TObject);
    procedure ComboBox_LanguageClick(Sender: TObject);
  private
    fCustomTags: TThumbsbrowser_MetaTags;
    fFileRcds: TThumbsbrowser_MetaData_FileRcds;
    fcurIdx: integer;

    procedure ReadMetaData(idx: integer);
    procedure GUI_Reset;
    procedure FillLanguages;

    procedure LanguageToCb;
    procedure CBToLanguage;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses FrmCustomTags;
procedure TFormMain.FormCreate(Sender: TObject);
begin

 fcurIdx := -1;
 fFileRcds := TThumbsbrowser_MetaData_FileRcds.create;
 fCustomTags := TThumbsbrowser_MetaTags.Create(true); //create the custom tags auto-filling them

 FillLanguages;
 LanguageToCb;

end;

procedure TFormMain.FillLanguages;
var
  lng: TNWSCompsLanguage;
begin
  ComboBox_Language.clear;
  for lng := Low(TNWSCompsLanguage) to High(TNWSCompsLanguage) do
  begin
    case lng of
      nwsLng_EN: ComboBox_Language.Items.Add('English');
      nwsLng_IT: ComboBox_Language.Items.Add('Italiano');
      nwsLng_ES: ComboBox_Language.Items.Add('Español');
      nwsLng_DE: ComboBox_Language.Items.Add('Deutsch');
    end;
  end;

end;

procedure TFormMain.LanguageToCb;
begin
  ComboBox_Language.ItemIndex := ord(metadataPanel1.Language);
end;

procedure TFormMain.CBToLanguage;
begin
  metadataPanel1.Language := TNWSCompsLanguage(ComboBox_Language.ItemIndex);
end;

procedure TFormMain.ComboBox_LanguageClick(Sender: TObject);
begin
  CBToLanguage;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  fFileRcds.free;
  fCustomTags.free;
end;


procedure TFormMain.btnLoadFiles1Click(Sender: TObject);
var
  I: Integer;
  aIo:TImageenio;
begin

  if OpenImageEnDialog1.Execute then
  begin

    fFileRcds.clear;

    aIo := TImageenio.create(nil);
    listbox1.clear;
    ListBox1.Items.BeginUpdate;
    try
      ListBox1.Items.Add('[All Files]'); //we add an item to edit all files
      for I := 0 to OpenImageEnDialog1.Files.count-1 do
      begin
         aIo.ParamsFromFile(OpenImageEnDialog1.Files[i]);
          //using this method is slower in loading (because will load all the metadata for each file now)
         //but allows consistency checks when editing the metadata of all files
         listbox1.items.Add(OpenImageEnDialog1.Files[i]);

         //we add the file records to our collection
         fFileRcds.Add(TThumbsbrowser_MetaData_FileRcd.Create(OpenImageEnDialog1.Files[i], aIo.Params));
         // constructor takes file name and IO parameters
      end;
    finally

      ListBox1.items.EndUpdate;
      aIo.free;
    end;
  end;

    //below we assign the data to the metadata panel in order to make it work
   metadataPanel1.AssignFiles(fFileRcds);

  if listbox1.count> 0 then
  begin
    ListBox1.ItemIndex := 0;
    ReadMetaData(listbox1.itemindex);
  end;
end;

procedure TFormMain.btnLoadFiles2Click(Sender: TObject);
var
  I: Integer;
begin
  if OpenImageEnDialog1.Execute then
  begin
      //using method 2 this is faster in loading because no metadata is loaded now
      //but looses the logical checks when editing the metadata for all files
      //until all metadata for all files will have been retrieved
    fFileRcds.clear;

    listbox1.clear;
    ListBox1.Items.BeginUpdate;
    try
      ListBox1.Items.Add('[All Files]'); //we add an item to edit all files
      for I := 0 to OpenImageEnDialog1.Files.count-1 do
      begin
          listbox1.items.Add(OpenImageEnDialog1.Files[i]);

         //we add the file records to our collection
         fFileRcds.Add(TThumbsbrowser_MetaData_FileRcd.Create(OpenImageEnDialog1.Files[i]));
         // constructor takes only file name
      end;
    finally
      ListBox1.items.EndUpdate;
    end;
  end;

  //below we assign the data to the metadata panel in order to make it work
  metadataPanel1.AssignFiles(fFileRcds);

  if listbox1.count> 0 then
  begin
    ListBox1.ItemIndex := 0;
    ReadMetaData(listbox1.itemindex);
  end;

end;

procedure TFormMain.btnAddExifClick(Sender: TObject);
begin
  if metadataPanel1.ForceExif then
    btnAddExif.Enabled := false;
end;

procedure TFormMain.btnAddIptcClick(Sender: TObject);
begin
  if metadataPanel1.ForceIptc then
    btnAddIptc.Enabled := false;
end;

procedure TFormMain.btnSaveMetaClick(Sender: TObject);
begin
  metadataPanel1.SaveModifiedInfo;
end;

procedure TFormMain.btnDefineCustomTagsClick(Sender: TObject);
begin

  FormCustomTags := TFormCustomTags.create(nil, fCustomTags);
  if FormCustomTags.ShowModal = mrOk then
  begin
    FormCustomTags.GivemeTags(fCustomTags);
    metadataPanel1.AssignTags(fCustomTags);
  end;
  freeandnil(FormCustomTags);

end;

procedure TFormMain.ListBox1Click(Sender: TObject);
begin
  ReadMetaData(listbox1.itemindex);
end;

procedure Tformmain.ReadMetaData(idx:integer);
var
aIo:TImageenio;
begin
  if idx = -1 then EXIT;

  fcurIdx := idx - 1;

   if fcurIdx = -1 then
   begin
     metadataPanel1.SetCurrentFile(-1); //switch to All files mode in the metadata panel

     imageenview1.Clear;
   end
   else
   begin
      metadataPanel1.SetCurrentFile(fcurIdx);  //switch to current file mode in the metadata panel

      imageenview1.IO.Params.RAW_QuickInterpolate := true; //to speed up reading of raw files
      imageenview1.IO.loadfromfile(fFileRcds[fcurIdx].FileName);
      imageenview1.Fit;
   end;

   GUI_Reset;
end;

procedure TFormMain.rgTagsClick(Sender: TObject);
begin
 btnDefineCustomTags.Enabled := rgTags.ItemIndex = 1;
 if rgTags.ItemIndex = 0 then
   metadataPanel1.AssignTags(nil)       //this will reset to default tags
 else
   metadataPanel1.AssignTags(fCustomTags);  //this assigns our custom tags
end;









procedure TFormMain.GUI_Reset;
begin
  btnSaveMeta.Enabled := false;
  if fcurIdx = -1 then
  begin
    btnAddExif.Enabled := (not metadataPanel1.HasExif);
    btnAddIptc.Enabled := (not metadataPanel1.HasIptc);
    btnSaveMeta.Caption := 'Save Changes to All Files';
  end
  else
  begin
    btnAddExif.Enabled := fFileRcds[fcurIdx].ExifEditable and (not metadataPanel1.HasExif);
    btnAddIptc.Enabled := fFileRcds[fcurIdx].IptcEditable and (not metadataPanel1.HasIptc);
    btnSaveMeta.Caption := 'Save Changes to Current File';
  end;
end;

procedure TFormMain.metadataPanel1FileInfoSaved(sender: TObject;
  theFileRcd: TThumbsbrowser_MetaData_FileRcd);
begin
  GUI_Reset;
end;

procedure TFormMain.metadataPanel1Modified(sender: TObject;
  theField: TThumbsbrowser_MetaData_Field);
begin
  btnSaveMeta.Enabled := true;
end;



end.
