program ImgProc;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  myCustomFilters in 'myCustomFilters.pas',
  NWSComps_FiltersPanel in '..\..\..\WinAll\ImageProcessing_Addon\NWSComps_FiltersPanel.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'NWSComps Proc Filter Library Demo';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
