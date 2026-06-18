program Demo_TB_Layout;
{$I Demo_TB_Layout.inc}
uses
  Vcl.Forms,
  Vcl.Themes,
  frmMain in 'frmMain.pas' {FormMain},
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  {$IFDEF VCLSTYLES}
 // TStyleManager.TrySetStyle('Aqua Graphite');    //
  {$ENDIF}

  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
