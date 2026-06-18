program Demo_TB_Database;

uses
  Forms,
  umain in 'umain.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ImageEn DB Demo';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
