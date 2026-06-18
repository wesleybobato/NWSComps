program Demo_PE;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Simple_PE_Editor};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TSimple_PE_Editor, Simple_PE_Editor);
  Application.Run;
end.
