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
unit NWSComps_ThumbsBrowser_RES_DE;


interface
    uses NWSComps_ThumbsBrowser_RES_CONST;

    type
    TTBTranslateMemory_DE = class(TTBTranslateMemory)
      public
      Constructor Create; reintroduce;
    end;


implementation


{ TTBTranslateMemory_DE }

constructor TTBTranslateMemory_DE.Create;
begin
  FRS_TBSORT_NameA := 'Name ->';
  FRS_TBSORT_NameD :=  'Name <-';
  FRS_TBSORT_DateA :=  'Datum ->';
  FRS_TBSORT_DateD :=  'Datum <-';
  FRS_TBSORT_ExifDateA :=  'Datum (Exif)  ->';
  FRS_TBSORT_ExifDateD :=  'Datum (Exif) <-';
  FRS_TBSORT_SizeA := 'Größe ->';
  FRS_TBSORT_SizeD := 'Größe <-';
  FRS_TBSORT_FolderA := 'Pfad ->';
  FRS_TBSORT_FolderD := 'Pfad <-';
  FRS_TBSORT_FileTypeA := 'Dateityp ->';
  FRS_TBSORT_FileTypeD := 'Dateityp <-';
  FRS_TBSORT_NameNaturalA := 'Name ->';
  FRS_TBSORT_NameNaturalD := 'Name <-';
  FRS_TBSORT_FolderNaturalA := 'Pfad ->';
  FRS_TBSORT_FolderNaturalD := 'Pfad <-';

  FRS_METAHLP_Index := 'Nr.';
  FRS_METAHLP_Field := 'Feld';
  FRS_METAHLP_ErrorParsingWrongGridFormat:= 'Parsing Fehler: Falsches Rasterformat';

  FRS_METAPN_DISPLAYMODE_NONEMPTY := 'Nicht leer anzeigen';
  FRS_METAPN_DISPLAYMODE_All := 'Alle anzeigen';
  FRS_METAPN_DISPLAYMODE_GROUPED := 'Gruppiert nach Core';
  FRS_METAPN_PENDINGCHANGES_SINGLE :=
    'Infos für die aktuelle Datei wurden geändert. Speichern Sie die Änderungen? ';
  FRS_METAPN_PENDINGCHANGES_MULTI :=
    'Infos für mehrere Dateien wurden geändert. Speichern Sie die Änderungen? ';
  FRS_METAPN_TABCOMMON := 'Allgemein';

  FRS_SH_OP_DELETINGFILES := 'Dateien werden gelöscht..';
  FRS_SH_OP_RECYCLINGFILES := 'Dateien werden in Papierkorb verschoben..';
  FRS_SH_OP_MOVINGFILES := 'Dateien werden verschoben..';
  FRS_SH_OP_COPYINGFILES := 'Dateien werden kopiert..';
  FRS_SH_OP_SAVINGFILES := 'Dateien werden gespeichert..';
  FRS_SH_OP_CORRECTINGORIENTATION := 'Korrektur von Dateien Orientierung (EXIF)..';
  FRS_SH_OP_ROTATINGFILES := 'Dateien werden gedreht..';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD :=
    'Warnung! Es ist nicht erlaubt %s Dateien in Papierkorb zu Verschieben '+
    'da sie auf tragbarem Gerät sind.' +
    'Stattdessen wollen Sie sie löschen? (Das kann nicht rückgängig gemacht werden!)';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA :=
    'Warnung! Es ist nicht erlaubt %s Dateien in Papierkorb zu Verschieben '+
    'da sie auf einer WIA-Verbindung abgerufen werden.' +
    'Stattdessen wollen Sie sie löschen? (Das kann nicht rückgängig gemacht werden!)';
  FRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED :=
    'Es gibt Internet-Dateien, für die nur eine Kopie möglich ist.' +
    'Wollen Sie sie trotzdem übertragen?';

  FRS_INFOFORM_FDate := 'Datum: ';
  FRS_INFOFORM_FSize := 'Größe: ';
  FRS_INFOFORM_HINT_ADDEXIFINFO := 'Exif-Info hinzufügen';
  FRS_INFOFORM_HINT_ADDIPTCINFO := 'IPTC-Info hinzufügen';
  FRS_INFOFORM_ERROR_CANNOTWRITEMETA := 'Metadaten können nicht in diese Datei geschrieben werden';
  FRS_INFOFORM_BTNSAVE := 'Speichern';
  FRS_INFOFORM_BTNSAVERENAME := 'Speichern / Umbenennen';
  FRS_INFOFORM_BTNRENAME := 'Umbenennen';
  FRS_INFOFORM_BTNADDEXIF := 'Exif hinzufügen';
  FRS_INFOFORM_BTNADDIPTC := 'Iptc hinzufügen';

  FRS_CAP_SHOWFILENAME := 'Name';
  FRS_CAP_SHOWFILEDATE := 'Datum';
  FRS_CAP_SHOWFILESIZE := 'Größe';
  FRS_CAP_SHOWFILEDIMS := 'Bildgröße';
  FRS_CAP_SHOWEXIFDATETIME := 'Exif Datum-Uhrzeit';
  FRS_CAP_SHOWEXIFAUTHOR := 'Exif Autor';
  FRS_CAP_SHOWEXIFTITLE := 'Exif Titel';
  FRS_CAP_SHOWEXIFSUBJECT := 'Exif Thema';
  FRS_CAP_SHOWEXIFCOMMENT := 'Exif Kommentar';
  FRS_CAP_SHOWEXIFKEYWORDS := 'Exif Schlüsselwörter';
  FRS_CAP_SHOWEXIFRATING := 'Exif Bewertung';
  FRS_CAP_SHOWKEYWORDS := 'Schlüsselwörter';
  FRS_CAP_SHOWRATING := 'Bewertung';
  FRS_CAP_SHOWFILENAMEWITHOUT := 'Name';
  FRS_CAP_SHOWFILEPATH := 'Pfad';
  FRS_CAP_SHOWFILEDIMSSIZE := 'Bildgröße und Größe';
  FRS_CAP_SHOWFILECREATEDATE := 'Erstellungsdatum';
  FRS_CAP_SHOWFILECREATEDATETIME := 'Erstellungsdatum - Uhrzeit';
  FRS_CAP_SHOWFILEEDITDATE := 'BearbeitungsDatum';
  FRS_CAP_SHOWFILEEDITDATETIME := 'BearbeitungsDatum - Uhrzeit';
  FRS_CAP_SHOWFILETYPE := 'Dateityp';
  FRS_CAP_SHOWTOPTITLE := 'Oberer Titel';
  FRS_CAP_SHOWBOTTOMTITLE := 'Unterer Titel';
  FRS_CAP_SHOWGENERAL := 'Info';
  FRS_CAP_SHOWOTHER1 := 'Andere';
  FRS_CAP_SHOWOTHER2 := 'Andere';
  FRS_CAP_SHOWOTHER3 := 'Andere';
  FRS_CAP_SHOWOTHER4 := 'Andere';

  FRS_IPTCTAG_PS_Title := 'Titel';
  FRS_IPTCTAG_PS_Caption := 'Beschriftung';
  FRS_IPTCTAG_PS_Keywords := 'Schlüsselwörter';
  FRS_IPTCTAG_PS_Instructions := 'Besondere Hinweise';

  FRS_IPTCTAG_PS_Date_Created := 'Erstellungsdatum (JJJJMMTT)';
  FRS_IPTCTAG_PS_Time_Created := 'Erstellungsdatum-Uhrzeit (HHMMSS ± HHMM)';
  FRS_IPTCTAG_PS_ByLine1 := 'By-line 1';
  FRS_IPTCTAG_PS_ByLine2 := 'By-line 2';
  FRS_IPTCTAG_PS_City := 'Stadt';
  FRS_IPTCTAG_PS_State := 'Staat/Provinz';
  FRS_IPTCTAG_PS_Country_Code := 'Land / Ortskennzahl';
  FRS_IPTCTAG_PS_Country_Name := 'Land/ Standortname';
  FRS_IPTCTAG_PS_TransmissionRef := 'Originalübertragungsreferenz';
  FRS_IPTCTAG_PS_Credit := 'Gutschrift';
  FRS_IPTCTAG_PS_Editor := 'Editor';
  FRS_IPTCTAG_PS_EditStatus := 'BearbeitungsStatus';
  FRS_IPTCTAG_PS_Urgency := 'Dringlichkeit';
  FRS_IPTCTAG_PS_Category := 'Kategorie';
  FRS_IPTCTAG_PS_SupplCategory := 'Zusatzkategorie';
  FRS_IPTCTAG_PS_FixtureID := 'Fixture Identifier';
  FRS_IPTCTAG_PS_ReleaseDate := 'Veröffentlichungsdatum (JJJJMMTT)';
  FRS_IPTCTAG_PS_ReleaseTime := 'Veröffentlichungsdatum-Uhrzeit (HHMMSS ± HHMM)';
  FRS_IPTCTAG_PS_ReferenceService := 'Referenzdienst';
  FRS_IPTCTAG_PS_ReferenceDate := 'Referenzdatum (JJJJMMTT)';
  FRS_IPTCTAG_PS_ReferenceNumber := 'Referenznummer';
  FRS_IPTCTAG_PS_OrigProgram := 'Ursprungsprogramm';
  FRS_IPTCTAG_PS_ProgVersion := 'Programmversion';
  FRS_IPTCTAG_PS_ObjectCycle := 'Objektzyklus (a := AM, b := PM, c := beide)';
  FRS_IPTCTAG_PS_ImageType := 'Bildtyp';
  FRS_IPTCTAG_PS_CopyrightNotice := 'Urheberrechtsvermerk';


FRS_XMP_Aux_ApproximateFocusDistance := 'Fokusabstand';
  FRS_XMP_Aux_Firmware := 'Firmware';
  FRS_XMP_Aux_FlashCompensation := 'Flash-Kompensation';
  FRS_XMP_Aux_ImageNumber := 'Bildnummer';
  FRS_XMP_Aux_Lens := 'Linse';
  FRS_XMP_Aux_LensID := 'Objektiv-ID';
  FRS_XMP_Aux_LensInfo := 'Lens Info';
  FRS_XMP_Aux_LensSerialNumber := 'Objektiv-Seriennummer';
  FRS_XMP_Aux_OwnerName := 'Besitzername';
  FRS_XMP_Aux_SerialNumber := 'Seriennummer';
  FRS_XMP_CC_AttributionName := 'Namensnennung';
  FRS_XMP_CC_AttributionURL := 'Attributions-URL';
  FRS_XMP_CC_DeprecatedOn := 'Veraltete Ein';
  FRS_XMP_CC_Jurisdiction := 'Zuständigkeit';
  FRS_XMP_CC_LegalCode := 'Gesetzlicher Code';
  FRS_XMP_CC_License := 'Lizenz';
  FRS_XMP_CC_MorePermissions := 'Weitere Berechtigungen';
  FRS_XMP_CC_Permits := 'Berechtigungen';
  FRS_XMP_CC_Prohibits := 'Verboten';
  FRS_XMP_CC_Requires := 'Erfordert';
  FRS_XMP_CC_UseGuidelines := 'Richtlinien benutzen';

  FRS_XMP_DC_Contributor := 'Beitragende';
  FRS_XMP_DC_Coverage := 'Abdeckung';
  FRS_XMP_DC_Creator := 'Ersteller';
  FRS_XMP_DC_Date := 'Datum';
  FRS_XMP_DC_Description := 'Beschreibung';
  FRS_XMP_DC_Format := 'Format';
  FRS_XMP_DC_Identifier := 'Bezeichner';
  FRS_XMP_DC_Language := 'Sprache';
  FRS_XMP_DC_Publisher := 'Publisher';
  FRS_XMP_DC_Relation := 'Beziehung';
  FRS_XMP_DC_Rights := 'Rechte';
  FRS_XMP_DC_Source := 'Quelle';
  FRS_XMP_DC_Subject := 'Betreff';
  FRS_XMP_DC_Title := 'Titel';
  FRS_XMP_DC_Type := 'Typ';

  FRS_XMP_Photoshop_AuthorsPosition := 'Autorenposition';
  FRS_XMP_Photoshop_CaptionWriter := 'Beschriftungs-Writer';
  FRS_XMP_Photoshop_Category := 'Kategorie';
  FRS_XMP_Photoshop_City := 'Stadt';
  FRS_XMP_Photoshop_ColorMode := 'Farbmodus';
  FRS_XMP_Photoshop_Country := 'Land';
  FRS_XMP_Photoshop_Credit := 'Gutschrift';
  FRS_XMP_Photoshop_DateCreated := 'Erstellungsdatum';
  FRS_XMP_Photoshop_DocumentAncestorID := 'Dokument Ancestor ID';
  FRS_XMP_Photoshop_Headline := 'Überschrift';
  FRS_XMP_Photoshop_History := 'Geschichte';
  FRS_XMP_Photoshop_ICCProfileName := 'ICC-Profilname';
  FRS_XMP_Photoshop_Instructions := 'Anweisungen';
  FRS_XMP_Photoshop_Source := 'Quelle';
  FRS_XMP_Photoshop_State := 'Zustand';
  FRS_XMP_Photoshop_SupplementalCategories := 'Ergänzende Kategorien';
  FRS_XMP_Photoshop_TextLayerName := 'Text-Layer-Name';
  FRS_XMP_Photoshop_TextLayerText := 'Text-Layer-Text';
  FRS_XMP_Photoshop_TransmissionReference := 'Übertragungsreferenz';
  FRS_XMP_Photoshop_Urgency := 'Dringlichkeit';

  FRS_XMP_Advisory := 'Beratend';
  FRS_XMP_Author := 'Autor';
  FRS_XMP_BaseURL := 'BaseURL';
  FRS_XMP_CreateDate := 'Erstellungsdatum';
  FRS_XMP_CreatorTool := 'Erstellungsprogramm';
  FRS_XMP_Description := 'Beschreibung';
  FRS_XMP_Format := 'Format';
  FRS_XMP_Identifier := 'Bezeichner';
  FRS_XMP_Keywords := 'Schlüsselwörter';
  FRS_XMP_Label := 'Label';
  FRS_XMP_MetadataDate := 'Metadaten-Datum';
  FRS_XMP_ModifyDate := 'Bearbeitungsdatum';
  FRS_XMP_Nickname := 'Nickname';
  FRS_XMP_Rating := 'Bewertung';
  FRS_XMP_Title := 'Titel';


  FRS_EXIF_UserComment := 'Benutzerkommentar';
  FRS_EXIF_ImageDescription := 'BildsBeschreibung';
  FRS_EXIF_CameraMake := 'kamerahersteller';
  FRS_EXIF_CameraModel := 'Kameramodell';
  FRS_EXIF_XResolution := 'X Auflösung';
  FRS_EXIF_YResolution := 'Y Auflösung';
  FRS_EXIF_DateTime := 'Datum-Uhrzeit';
  FRS_EXIF_DateTimeOriginal := 'Datum-Uhrzeit Original';
  FRS_EXIF_DateTimeDigitized := 'Datum-Uhrzeit Digitized';
  FRS_EXIF_Copyright := 'Urheberrecht';
  FRS_EXIF_Orientation := 'Orientierung';
  FRS_EXIF_ExposureTime := 'Belichtungszeit';
  FRS_EXIF_FNumber := 'F-Zahl';
  FRS_EXIF_ExposureProgram := 'Belichtungsprogramm';
  FRS_EXIF_ISOSpeedRatings := 'ISO Geschwindigkeitsbewertungen';
  FRS_EXIF_ShutterSpeedValue := 'Verschlusszeitwert';
  FRS_EXIF_ApertureValue := 'Aperture';
  FRS_EXIF_BrightnessValue := 'Helligkeit';
  FRS_EXIF_ExposureBiasValue := 'Belichtungsvorgabe';
  FRS_EXIF_MaxApertureValue := 'Max. Blendenöffnung';
  FRS_EXIF_SubjectDistance := 'Objektentfernung';
  FRS_EXIF_MeteringMode := 'Messmodus';
  FRS_EXIF_LightSource := 'Lichtquelle';
  FRS_EXIF_Flash := 'Flash';
  FRS_EXIF_FocalLength := 'Brennweite';
  FRS_EXIF_FlashPixVersion := 'FlashPix V.';
  FRS_EXIF_ColorSpace := 'Farbraum';
  FRS_EXIF_ExifImageWidth := 'Bildbreite';
  FRS_EXIF_ExifImageHeight := 'Bildhöhe';
  FRS_EXIF_RelatedSoundFile := 'Ähnliche Sound-Datei';
  FRS_EXIF_FocalPlaneXResolution := 'Fokalebene XRes';
  FRS_EXIF_FocalPlaneYResolution := 'Fokalebene YRes';
  FRS_EXIF_ExposureIndex := 'Belichtungsindex';
  FRS_EXIF_SensingMethod := 'Erfassungsmethode';
  FRS_EXIF_FileSource := 'Dateiquelle';
  FRS_EXIF_SceneType := 'Szene-Typ';
  FRS_EXIF_YCbCrPositioning := 'YCbCr Positionierung';
  FRS_EXIF_ExposureMode := 'Belichtungsmodus';
  FRS_EXIF_WhiteBalance := 'Weißabgleich';
  FRS_EXIF_DigitalZoomRatio := 'Digital-Zoom-Verhältnis';
  FRS_EXIF_FocalLengthIn35mmFilm := 'Brennweite 35mm eq.';
  FRS_EXIF_SceneCaptureType := 'Art der Szenenaufnahme';
  FRS_EXIF_GainControl := 'Zunahme';
  FRS_EXIF_Contrast := 'Kontrast';
  FRS_EXIF_Saturation := 'Sättigung';
  FRS_EXIF_Sharpness := 'Schärfe';
  FRS_EXIF_SubjectDistanceRange := 'Entfernungsbereich';
  FRS_EXIF_GPSLatitude := 'GPS-Breite';
  FRS_EXIF_GPSLongitude := 'GPS-Länge';
  FRS_EXIF_GPSAltitude := 'GPS-Höhe';
  FRS_EXIF_GPSImageDirection := 'GPS-Bildrichtung';
  FRS_EXIF_GPSTrack := 'GPS-Track';
  FRS_EXIF_GPSSpeed := 'GPS-Geschwindigkeit';
  FRS_EXIF_GPSDateAndTime := 'GPS Datum und Uhrzeit';
  FRS_EXIF_GPSSatellites := 'GPS Satelliten';
  FRS_EXIF_GPSVersionID := 'GPS VersionID';
  FRS_EXIF_Artist := 'Künstler';
  FRS_EXIF_XPTitle := 'Titel (Windows)';
  FRS_EXIF_XPComment := 'Kommentar (Windows)';
  FRS_EXIF_XPAuthor := 'Autor (Windows)';
  FRS_EXIF_XPKeywords := 'Schlüsselwörter (Windows)';
  FRS_EXIF_XPSubject := 'Betreff (Windows)';
  FRS_EXIF_XPRating := 'Bewertung (Windows)';
  FRS_EXIF_InteropVersion := 'Interop-Version';
  FRS_EXIF_CameraOwnerName := 'Besitzer-Name';
  FRS_EXIF_BodySerialNumber := 'Kameragehäuse-Seriennummer';
  FRS_EXIF_LensMake := 'Objektivhersteller';
  FRS_EXIF_LensModel := 'Objektivmodell';
  FRS_EXIF_LensSerialNumber := 'Objektiv-Seriennummer';
  FRS_EXIF_Gamma := 'Gamma';
  FRS_EXIF_SubjectArea := 'Gebiet der Aufnahme';
  FRS_EXIF_SubjectLocation := 'Ort der Aufnahme';
end;



end.
