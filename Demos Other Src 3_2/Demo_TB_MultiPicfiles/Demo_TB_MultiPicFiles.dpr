program Demo_TB_MultiPicFiles;

uses
  Forms,
  umain in 'umain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ThumbsBrowser MultiPic Files Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
