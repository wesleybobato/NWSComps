program Demo_RemoveBg;

uses
  Vcl.Forms,
  frmPE_BasicEditor in 'frmPE_BasicEditor.pas' {FormPE_BasicEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormPE_BasicEditor, FormPE_BasicEditor);
  Application.Run;
end.
