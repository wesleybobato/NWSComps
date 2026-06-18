unit NWSComps_FiltersPanel;

interface
  uses windows, classes, sysutils, forms,controls, extctrls, contnrs, stdctrls, comctrls,  NWSComps_Proc_Filter_Types;
   type

     TIEProc_EX_FiltersPanelCustomInsertEvent = procedure (Filter:TIEProc_EX_Filter; var ControlToInsert:TControl) of object;
     TIEProc_EX_FiltersPanelAddParamEvent = procedure (Filter:TIEProc_EX_Filter; Param:TIEProc_EX_Filter_Param; var bCanAdd:boolean) of object;

     TIEProc_EX_FiltersPanelParam = class
  private
      fParamName:string;
      fControl: TControl;
      fFilter: TIEProc_EX_Filter;
        public
          property ParamName:string read fParamName write fParamName;
          property Filter:TIEProc_EX_Filter read fFilter write fFilter;
          property Control: TControl read fControl write fControl;
        Constructor Create( theFilter: TIEProc_EX_Filter; theParamName:string; theControl:TControl);
     end;

     TIEProc_EX_FiltersPanelActive = class
        public
          Filter:TIEProc_EX_Filter;
          CheckBox: TCheckBox;
        Constructor Create( theFilter: TIEProc_EX_Filter; theCheckBox:TCheckbox);
     end;


     TIEProc_EX_FiltersPanel = class(TScrollbox)
         private
         fFilterList: TIEProc_EX_Filter_Collection;
         fFilterParamInfoList:TObjectList;
         fFilterActiveList:TObjectList;
         fCustomControlsList: TList;
         procedure SetFilterList(value:TIEProc_EX_Filter_Collection);
         procedure BuildFiltersPanels;
         procedure HandleParamChanged(sender:TObject);
         procedure HandleFilterActiveClick(sender:TObject);
         public

         OnCustomInsert: TIEProc_EX_FiltersPanelCustomInsertEvent;
         OnAddFilterParam: TIEProc_EX_FiltersPanelAddParamEvent;
         property FilterList: TIEProc_EX_Filter_Collection read fFilterList write SetFilterList ;

         Constructor Create(AOwner: TComponent); override;
         Destructor Destroy; override;

         procedure UpdateFromFilters;
     end;
implementation
    uses graphics, hsvbox, dialogs, NWSComps_Proc_Filter_Lib_Const;
      Constructor TIEProc_EX_FiltersPanelParam.Create(theFilter: TIEProc_EX_Filter; theParamName:string; theControl:TControl);
      begin
        fParamName := theParamName;
        fFilter := theFilter;
        fControl := theControl;
      end;

      Constructor TIEProc_EX_FiltersPanelActive.Create(theFilter: TIEProc_EX_Filter; theCheckBox:TCheckbox);
      begin
        Filter := theFilter;
        CheckBox := theCheckBox;
      end;


      Constructor TIEProc_EX_FiltersPanel.Create(AOwner: TComponent);
      begin
         inherited;
         DoubleBuffered := true;
         VertScrollBar.Tracking := true;
         VertScrollBar.Smooth := true;
         fFilterParamInfoList := TObjectList.Create;
         fFilterActiveList := TObjectList.Create;
         fCustomControlsList := TList.Create;
      end;

     Destructor TIEProc_EX_FiltersPanel.Destroy;
     begin

         fFilterParamInfoList.Free;
         fFilterActiveList.Free;
         fCustomControlsList.Free;
         inherited;

      end;



      procedure TIEProc_EX_FiltersPanel.SetFilterList(value:TIEProc_EX_Filter_Collection);
      begin
         fFilterList := nil;
         fFilterList := value;
         BuildFiltersPanels;
      end;


      procedure TIEProc_EX_FiltersPanel.HandleFilterActiveClick(sender:TObject);
      var
        I: Integer;
        fa: TIEProc_EX_FiltersPanelActive;
      begin
        fa := nil;
        for I := 0 to fFilterActiveList.Count-1 do
        begin
          fa := TIEProc_EX_FiltersPanelActive(fFilterActiveList[i]) ;
          if fa.CheckBox = sender then
          break;
        end;
        if not assigned(fa) then EXIT;


        fa.Filter.Active := fa.CheckBox.Checked;
        fFilterList.Update;
      end;

      procedure TIEProc_EX_FiltersPanel.HandleParamChanged(sender:TObject);
      var
      I: Integer;
      pInfo:TIEProc_EX_FiltersPanelParam;
      param: TIEProc_EX_Filter_Param;
      begin
         if fFilterList.Locked then
           EXIT;

         pInfo := nil;
         for I := 0 to fFilterParamInfoList.Count-1 do
         begin
           pInfo := TIEProc_EX_FiltersPanelParam(fFilterParamInfoList[i]) ;
           if pinfo.Control = sender then break;
         end;

         if not assigned(pInfo) then EXIT;


         pinfo.Filter.Active := true;
         for I := 0 to fFilterActiveList.Count-1 do
         begin
           if TIEProc_EX_FiltersPanelActive(fFilterActiveList[i]).Filter = pinfo.Filter then
           begin
             TIEProc_EX_FiltersPanelActive(fFilterActiveList[i]).CheckBox.Checked := true;
             break;
           end;
         end;


         param := pinfo.Filter.Params.Param_Byname(pinfo.ParamName);
         if sender is THSVBox then
            pinfo.Filter.SetParamValue(param.Name,THSVBox(sender).Color)
         else
         if sender is TCheckBox then
           pinfo.Filter.SetParamValue(Param.Name,TCheckBox(sender).Checked)
         else if sender is TTrackbar then
         begin
           if (param.ValueType = pt_byte)
                or (param.ValueType = pt_Int)
                or (param.ValueType = pt_Cardinal) then
           begin
              pinfo.Filter.SetParamValue(Param.Name, TTrackbar(sender).Position);
              TTrackBar(sender).Hint := IntToStr(TTrackBar(sender).Position);
              TTrackBar(sender).ShowHint := true;
           end
           else
           begin
             pinfo.Filter.SetParamValue(Param.Name, TTrackbar(sender).Position/100);
             TTrackBar(sender).Hint := FormatFloat('0.00',TTrackBar(sender).Position/100);
             TTrackBar(sender).ShowHint := true;
           end;

         end
         else if sender is TEdit then
           pinfo.Filter.SetParamValue(Param.Name,TEdit(sender).Text);

         fFilterList.Update;
      end;

      procedure TIEProc_EX_FiltersPanel.UpdateFromFilters;
      var
      I:integer;
      fa : TIEProc_EX_FiltersPanelActive;
      fp:TIEProc_EX_FiltersPanelParam;
      param: TIEPROC_EX_Filter_Param;
      begin
          if not assigned(fFilterlist) then exit;

          fFilterList.Update_Lock;    //this temporarily suspends any update of the filters
                                       // to allow the sliders to be reset without updating the preview
          try

            for I := 0 to fFilterActiveList.Count-1 do
            begin
              fa := TIEProc_EX_FiltersPanelActive(fFilterActiveList[i]);
              fa.CheckBox.Checked := fa.Filter.Active;
            end;

            for I := 0 to fFilterParamInfoList.Count-1 do
            begin
              fp := TIEProc_EX_FiltersPanelParam(fFilterParamInfoList[i]);
              param := fp.Filter.Params.Param_Byname(fp.ParamName);
              if fp.Control is THSVBox then
              begin
                THSVBox(fp.Control).SetColor(param.GetValue_int);
              end
              else
              if fp.Control is TTrackbar then
              begin
                if (param.ValueType = pt_byte)
                or (param.ValueType = pt_Int)
                or (param.ValueType = pt_Cardinal) then
                begin
                    TTrackbar(fp.Control).Position := param.GetValue_int;
                    TTrackbar(fp.Control).Min := param.GetValue_int(qt_Min);
                    TTrackbar(fp.Control).Max := param.GetValue_int(qt_Max);
                end
                else
                begin
                  TTrackBar(fp.Control).Position := round(100 * param.GetValue_double);
                  TTrackBar(fp.Control).Min := round(100 * param.GetValue_double(qt_Min));
                  TTrackBar(fp.Control).Max := round(100 * param.GetValue_double(qt_Max));
                end;

                TTrackBar(fp.Control).Hint := IntToStr(TTrackBar(fp.Control).Position);
                TTrackBar(fp.Control).ShowHint := true;
              end
              else if fp.Control is TCheckbox then
                TCheckBox(fp.Control).Checked := param.GetValue_bool
              else if fp.Control is TEdit then
                   TEdit(fp.Control).Text := param.GetValue_string;
            end;

          finally
             fFilterList.Update_UnLock(false);
          end;
      end;

      procedure TIEProc_EX_FiltersPanel.BuildFiltersPanels;
      var
         I: Integer;
         filter:TIEProc_EX_Filter;
         param: TIEProc_EX_Filter_Param;
         j: integer;
         gb:TGroupBox; tb:TTrackbar; cb, cbActive:TCheckbox;
         colorBox : THSVBox;
         lb:TLabel; pn, pnActive:TPanel;
         HandlerCtrl:TControl;
         eb:TEdit;
         pfMin, pfMax:double;
         piMin,piMax:integer;
         bSuccess, bCanAddParam, bVisible:boolean;
         controlToInsert: TControl;
      begin
        fFilterParamInfoList.Clear;
        fFilterActiveList.Clear;
        for I := 0 to fCustomControlsList.Count-1 do
        begin
          TControl(fCustomControlsList[i]).Parent := self.Parent;  //detach external controls
          TControl(fCustomControlsList[i]).Visible := false;
        end;
        fCustomControlsList.Clear;

        bVisible := Visible;
        Visible := false;

        try
        for I := ComponentCount-1 downto 0 do
           Components[i].Free;


        if fFilterList = nil then
          EXIT;

        for I := 0 to fFilterList.Count-1 do
        begin
          filter := fFilterList.Filter[i];
          gb := TGroupbox.Create(self);
          gb.Parent := self;
          gb.Caption := filter.UserCaption;
          gb.Font.Style := [fsBold];
          gb.Height := 10;
          gb.Align := altop;
          gb.Top := 50000;

          pnActive := TPanel.Create(gb);
          pnActive.Parent := gb;
          pnActive.BevelInner := bvnone;
          pnActive.BevelOuter := bvnone;
          pnActive.Align := alTop;
          pnActive.Height := 26;
          gb.Height := gb.Height + pnActive.Height;
          cbActive := TCheckBox.Create(pnActive);
          cbActive.Caption := 'Active';
          cbActive.Align := alTop;
          cbActive.ParentFont := false;
          cbActive.Parent := pnActive;
          cbActive.Visible := true;
          cbActive.Checked := filter.Active;
          fFilterActiveList.Add(TIEProc_EX_FiltersPanelActive.Create(filter, cbActive));
          cbActive.OnClick := HandleFilterActiveClick;

          if assigned(OnCustomInsert) then
          begin
             controlToInsert := nil;
             OnCustomInsert(filter, controlToInsert);
             if assigned(controlToInsert) then
             begin
                fCustomControlsList.Add(controlToInsert);
                gb.Height := gb.Height + controlToInsert.Height;
                controlToInsert.Parent := gb;
                controlToInsert.Align := altop;
                controlToInsert.Visible := true;
                controlToInsert.Top := 50000; //make sure it goes last
             end;
          end;


          for j := 0 to filter.Params.Count-1 do
          begin
            param := filter.Params[j];

            if param.IsFlag then continue;


            bCanAddParam := true;
            if assigned(OnAddFilterParam) then
              OnAddFilterParam(filter, param, bCanAddParam);
            if not bCanAddParam then
              continue;
            pn := TPanel.Create(gb);
            pn.ParentFont := false;
            pn.Parent := gb;
            pn.BevelInner := bvnone;
            pn.BevelOuter := bvnone;
            pn.Align := alTop;
            pn.Height := 40;
            pn.Top := 50000;

            lb := TLabel.Create(pn);
            lb.Parent := pn;
            lb.Align := altop;
            lb.Caption := param.Name;

            lb.Visible := true;
            lb.Top := 50000;

            HandlerCtrl := nil;
            if (param.ValueType = pt_int) and (param.UIRepresentation = UIColor) then
            begin
              colorBox := THSVBox.Create(pn);
              colorBox.Parent := pn;
              colorBox.Align := altop;
              colorBox.Visible := true;
              pn.Height := 80;
              colorBox.Height := 60;
              colorBox.Top := 50000;
              HandlerCtrl := colorBox;

              colorBox.OnChange := HandleParamChanged;
            end
            else if param.ValueType = pt_boolean then
            begin
              lb.Alignment := taLeftJustify;
              cb := TCheckbox.Create(pn);
              cb.Checked := Param.GetValue_bool;
              cb.Parent := pn;
              cb.Align := altop;
              cb.Visible := true;
              cb.Top := 50000;
              HandlerCtrl := cb;

              cb.OnClick := HandleParamChanged;
            end
            else  if (param.ValueType = pt_byte)
                or (param.ValueType = pt_Int)
                or (param.ValueType = pt_Cardinal)
                or (param.ValueType = pt_single)
                or (param.ValueType = pt_double)then
            begin
                lb.Alignment := taCenter;
                tb := TTrackBar.Create(pn);
                tb.ThumbLength := 20;
                tb.Height := 20;
                if (param.ValueType = pt_single)
                 or (param.ValueType = pt_double)then
                 begin
                    param.GetMinMax_double(pfMin, pfMax, bSuccess);
                    tb.Min := round(pfMin * 100);
                    tb.Max := round(pfMax * 100);
                    tb.Position := round(param.GetValue_double *100);
                 end
                 else
                 begin
                   param.GetMinMax_int(piMin, piMax, bSuccess);
                   tb.Min := piMin;
                   tb.Max := piMax;
                   tb.Position := param.GetValue_int;
                 end;
                tb.Parent := pn;
                tb.Align := alTop;
                tb.Orientation := trHorizontal;
                tb.Visible := true;
                tb.Top := 50000;
                HandlerCtrl := tb;

                tb.OnChange := HandleParamChanged;

            end
            else if (param.ValueType = pt_string)then
            begin
              lb.Alignment := taCenter;
              eb := TEdit.Create(pn);
              eb.Text := param.GetValue_string;
              eb.Parent := pn;
              eb.Align := alTop;
              eb.Visible := true;
              eb.Top := 50000;
              HandlerCtrl := eb;
              eb.OnChange := HandleParamChanged;
            end;
            gb.Height := gb.Height + pn.Height;

            if assigned(HandlerCtrl) then
               fFilterParamInfoList.Add(TIEProc_EX_FiltersPanelParam.Create(filter, param.Name, HandlerCtrl));
            
          end;  //end j loop

        end; //end i loop
        finally
           Visible := bVisible;
        end;
      end;


end.
