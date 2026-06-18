(*
  Part of NWSComps Bundle
  v. 3
  Copyright (C) Francesco Savastano. All Rights Reserved.

  This software comes without any warranty either implied or expressed.
  In no case shall the author be liable for any damage or unwanted behavior
  of any computer hardware and/or software.

  You cannot DISTRIBUTE THIS SOURCE CODE OR ITS COMPILED .DCU IN ANY FORM.

  This unit cannot be included in any commercial, shareware or freeware DELPHI
  libraries or components.

  email: nws@centurybyte.com
  web site: www.nwscomps.com
*)
unit NWSComps_Types;
{$R-}
{$Q-}
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}
{$I ..\_inc\NWSComps_Shared.inc}

interface
  uses Classes;

  Type
  TNWSCompsNotificationType = (nwsNotTyp_Lang);
  TNWSCompsNotificationEvent = procedure(sender: TObject; notType: TNWSCompsNotificationType) of object;

  TNWSCompsNotificationObject = class
  protected
    FEvent: TNWSCompsNotificationEvent;
  public
    property Event: TNWSCompsNotificationEvent read FEvent;

    Constructor Create(theEvent: TNWSCompsNotificationEvent);
  end;

  TNWSCompsLanguage = (nwsLng_EN
                       {$IFDEF NWSCOMPS_LNG_IT},nwsLng_IT{$ENDIF}
                       {$IFDEF NWSCOMPS_LNG_ES},nwsLng_ES{$ENDIF}
                       {$IFDEF NWSCOMPS_LNG_DE},nwsLng_DE{$ENDIF}
                       );

  TNWSComps = class

      private

      fSubscribers: TList;
      fLanguage: TNWSCompsLanguage;

      Function FindSubscriber(theEvent: TNWSCompsNotificationEvent): TNWSCompsNotificationObject;
      procedure SetLanguage(const Value: TNWSCompsLanguage);
      procedure SendNotification(value: TNWSCompsNotificationType);
      public

      property Language:TNWSCompsLanguage read fLanguage write SetLanguage;

      Constructor Create;
      Destructor Destroy; override;

      procedure Subscribe(NotificationHandle: TNWSCompsNotificationEvent);
      procedure Unsubscribe(NotificationHandle: TNWSCompsNotificationEvent);
    end;

 var NWSCOMPS: TNWSComps;


implementation



{ TNWSComps }

constructor TNWSComps.Create;
begin
  fSubscribers := TList.create;
  fLanguage := nwsLng_EN;
end;

destructor TNWSComps.Destroy;
begin
  fSubscribers.free;
  inherited;
end;

function TNWSComps.FindSubscriber(theEvent: TNWSCompsNotificationEvent): TNWSCompsNotificationObject;
function SameMethod(AMethod1, AMethod2: TNWSCompsNotificationEvent): boolean;
begin
  result := (TMethod(AMethod1).Code = TMethod(AMethod2).Code)
            and (TMethod(AMethod1).Data = TMethod(AMethod2).Data);
end;
var
  I: Integer;
begin
  result := nil;
  for I := 0 to fSubscribers.count-1 do
    if SameMethod(TNWSCompsNotificationObject(fSubscribers[i]).Event, theEvent) then
    begin
      result := TNWSCompsNotificationObject(fSubscribers[i]);
      break;
    end;
end;

procedure TNWSComps.SendNotification(value: TNWSCompsNotificationType);
var
  I: Integer;
begin
  for I := 0 to fSubscribers.count-1 do
  begin
    if assigned(fSubscribers[i]) then
    begin
      if assigned(TNWSCompsNotificationObject(fSubscribers[i]).Event) then
        TNWSCompsNotificationObject(fSubscribers[i]).Event(self, value);
    end;
  end;
end;

procedure TNWSComps.SetLanguage(const Value: TNWSCompsLanguage);
begin
  if fLanguage = Value then Exit;

  fLanguage := Value;
  SendNotification(nwsNotTyp_Lang);
end;

procedure TNWSComps.Subscribe(NotificationHandle: TNWSCompsNotificationEvent);
begin
  if assigned(NotificationHandle) and (FindSubscriber(NotificationHandle) = nil) then
    fSubscribers.add(TNWSCompsNotificationObject.create(NotificationHandle));
end;

procedure TNWSComps.Unsubscribe(NotificationHandle: TNWSCompsNotificationEvent);
var
 sub: TNWSCompsNotificationObject;
begin
  sub := FindSubscriber(NotificationHandle);
  if (sub <> nil) then
  begin
    fSubscribers.remove(sub);
    sub.free;
  end;
end;

{ TNWSCompsNotificationObject }

constructor TNWSCompsNotificationObject.Create(
  theEvent: TNWSCompsNotificationEvent);
begin
  FEvent := theEvent;
end;


initialization

   NWSCOMPS := TNWSComps.Create;

finalization
   NWSCOMPS.free;
end.
