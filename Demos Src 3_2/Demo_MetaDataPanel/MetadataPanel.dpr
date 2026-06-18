program MetadataPanel;

uses
  Vcl.Forms,
  FrmMain in 'FrmMain.pas' {FormMain},
  FrmCustomTags in 'FrmCustomTags.pas' {FormCustomTags};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
