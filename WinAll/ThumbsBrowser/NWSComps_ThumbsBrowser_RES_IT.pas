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
unit NWSComps_ThumbsBrowser_RES_IT;


interface

  uses NWSComps_ThumbsBrowser_RES_CONST;

  type
    TTBTranslateMemory_IT = class(TTBTranslateMemory)
      public
      Constructor Create; reintroduce;
    end;

implementation


{ TTBTranslateMemory_IT }

constructor TTBTranslateMemory_IT.Create;
begin
  FRS_TBSORT_NameA := 'Nome ->';
  FRS_TBSORT_NameD :=  'Nome <-';
  FRS_TBSORT_DateA :=  'Data ->';
  FRS_TBSORT_DateD :=  'Data <-';
  FRS_TBSORT_ExifDateA :=  'Data (Exif) ->';
  FRS_TBSORT_ExifDateD :=  'Data (Exif) <-';
  FRS_TBSORT_SizeA := 'Dimensione ->';
  FRS_TBSORT_SizeD := 'Dimensione <-';
  FRS_TBSORT_FolderA := 'Cartella ->';
  FRS_TBSORT_FolderD := 'Cartella <-';
  FRS_TBSORT_FileTypeA := 'Tipo File ->';
  FRS_TBSORT_FileTypeD := 'Tipo File <-';
  FRS_TBSORT_NameNaturalA := 'Nome ->';
  FRS_TBSORT_NameNaturalD := 'Nome <-';
  FRS_TBSORT_FolderNaturalA := 'Cartella ->';
  FRS_TBSORT_FolderNaturalD := 'Cartella <-';

  FRS_METAHLP_Index := 'Nr.';
  FRS_METAHLP_Field := 'campo';
  FRS_METAHLP_ErrorParsingWrongGridFormat := 'Errore durante analisi: Formato Griglia Sbagliato';

  FRS_METAPN_DISPLAYMODE_NONEMPTY := 'Mostra non vuoti';
  FRS_METAPN_DISPLAYMODE_All := 'Mostra tutti';
  FRS_METAPN_DISPLAYMODE_GROUPED := 'Mostra raggruppati per Core';
  FRS_METAPN_PENDINGCHANGES_SINGLE :=
    'Informazioni per il file corrente modificate. Salvare le modifiche? ';
  FRS_METAPN_PENDINGCHANGES_MULTI :=
    'Informazioni per più file sono state modificate. Salvare le modifiche? ';
  FRS_METAPN_TABCOMMON := 'Comuni';

  FRS_SH_OP_DELETINGFILES :='Eliminazione files in corso..';
  FRS_SH_OP_RECYCLINGFILES := 'Riciclo files in corso..' ;
  FRS_SH_OP_MOVINGFILES := 'Spostamento files in corso..';
  FRS_SH_OP_COPYINGFILES := 'Copia files in corso..';
  FRS_SH_OP_SAVINGFILES := 'Salvataggio files in corso..';
  FRS_SH_OP_CORRECTINGORIENTATION := 'Correzione Orientazione Files (EXIF) in corso..';
  FRS_SH_OP_ROTATINGFILES := 'Rotazione files in corso..' ;
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD :=
    'Avvertimento! Riciclo non consentito per %s '+
    'Files perché sono su dispositivi portatili.' +
    'Invece vuoi eliminarli? (Questo non può essere annullato!) ';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA :=
    'Avvertimento! Riciclaggio non consentito per %s '+
    'Files perché sono su una connessione WIA.' +
    'Invece vuoi eliminarli? (Questo non può essere annullato!) ';
  FRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED :=
    'Ci sono files di Internet, per cui solo una copia è possibile.' +
    'Vuoi trasferirli comunque?';

  FRS_INFOFORM_FDate := 'Data:';
  FRS_INFOFORM_FSize := 'Dimensione: ';
  FRS_INFOFORM_HINT_ADDEXIFINFO := 'Aggiungi Info Exif';
  FRS_INFOFORM_HINT_ADDIPTCINFO := 'Aggiungi Info IPTC';
  FRS_INFOFORM_ERROR_CANNOTWRITEMETA := 'Impossibile scrivere i metadati per questo file';
  FRS_INFOFORM_BTNSAVE := 'Salva';
  FRS_INFOFORM_BTNSAVERENAME := 'Salva/Rinomina';
  FRS_INFOFORM_BTNRENAME := 'Rinomina';
  FRS_INFOFORM_BTNADDEXIF := 'Agg. Exif';
  FRS_INFOFORM_BTNADDIPTC := 'Agg. Iptc';

  FRS_CAP_SHOWFILENAME := 'Nome';
  FRS_CAP_SHOWFILEDATE := 'Data';
  FRS_CAP_SHOWFILESIZE := 'Dimensione';
  FRS_CAP_SHOWFILEDIMS := 'Dim. Immagine';
  FRS_CAP_SHOWEXIFDATETIME := 'Exif data-ora';
  FRS_CAP_SHOWEXIFAUTHOR := 'Exif Autore';
  FRS_CAP_SHOWEXIFTITLE := 'Exif titolo';
  FRS_CAP_SHOWEXIFSUBJECT := 'Exif Soggetto';
  FRS_CAP_SHOWEXIFCOMMENT := 'Exif commento';
  FRS_CAP_SHOWEXIFKEYWORDS := 'Exif Parole-Chiave';
  FRS_CAP_SHOWEXIFRATING := 'Exif Valutazione';
  FRS_CAP_SHOWKEYWORDS := 'Parole-Chiave';
  FRS_CAP_SHOWRATING := 'Valutazione';
  FRS_CAP_SHOWFILENAMEWITHOUT := 'Nome';
  FRS_CAP_SHOWFILEPATH := 'Percorso';
  FRS_CAP_SHOWFILEDIMSSIZE := 'Dim. immagine e file';
  FRS_CAP_SHOWFILECREATEDATE := 'Data Creazione';
  FRS_CAP_SHOWFILECREATEDATETIME := 'Data-Ora Creazione';
  FRS_CAP_SHOWFILEEDITDATE := 'Data Modifica';
  FRS_CAP_SHOWFILEEDITDATETIME := 'Data-Ora Modifica';
  FRS_CAP_SHOWFILETYPE := 'Tipo di file';
  FRS_CAP_SHOWTOPTITLE := 'Titolo di sopra';
  FRS_CAP_SHOWBOTTOMTITLE := 'Titolo di fondo';
  FRS_CAP_SHOWGENERAL := 'Info';
    FRS_CAP_SHOWOTHER1 := 'Altro';
  FRS_CAP_SHOWOTHER2 := 'Altro';
  FRS_CAP_SHOWOTHER3 := 'Altro';
  FRS_CAP_SHOWOTHER4 := 'Altro';

  FRS_IPTCTAG_PS_Title := 'Titolo'; // Nome oggetto
  FRS_IPTCTAG_PS_Caption := 'Didascalia'; // Didascalia / Estratto
  FRS_IPTCTAG_PS_Keywords := 'Parole-Chiave';
  FRS_IPTCTAG_PS_Instructions := 'Istruzioni speciali';

  FRS_IPTCTAG_PS_Date_Created := 'Data Creazione (AAAAMMGG)';
  FRS_IPTCTAG_PS_Time_Created := 'Ora Creazione (HHMMSS ± OOMM)';
  FRS_IPTCTAG_PS_ByLine1 := 'In-lines 1';
  FRS_IPTCTAG_PS_ByLine2 := 'In-linea 2';
  FRS_IPTCTAG_PS_City := 'Città';
  FRS_IPTCTAG_PS_State := 'Stato / Provincia';
  FRS_IPTCTAG_PS_Country_Code := 'Codice Paese/Regione';
  FRS_IPTCTAG_PS_Country_Name := 'Nome Paese/Regione';
  FRS_IPTCTAG_PS_TransmissionRef := 'Rif. Trasmissione';
  FRS_IPTCTAG_PS_Credit := 'Crediti';
  FRS_IPTCTAG_PS_Editor := 'Editore';
  FRS_IPTCTAG_PS_EditStatus := 'Stato Modifica';
  FRS_IPTCTAG_PS_Urgency := 'Urgenza';
  FRS_IPTCTAG_PS_Category := 'Categoria';
  FRS_IPTCTAG_PS_SupplCategory := 'Categoria supplementare';
  FRS_IPTCTAG_PS_FixtureID := 'Identificativo Fisso';
  FRS_IPTCTAG_PS_ReleaseDate := 'Data di rilascio (AAAAMMGG)';
  FRS_IPTCTAG_PS_ReleaseTime := 'Ora di rilascio (HHMMSS ± OOMM)';
  FRS_IPTCTAG_PS_ReferenceService := 'Servizio di riferimento';
  FRS_IPTCTAG_PS_ReferenceDate := 'Data di Riferimento (AAAAMMGG)';
  FRS_IPTCTAG_PS_ReferenceNumber := 'Numero di riferimento';
  FRS_IPTCTAG_PS_OrigProgram := 'Programma Originario';
  FRS_IPTCTAG_PS_ProgVersion := 'Versione del Programma';
  FRS_IPTCTAG_PS_ObjectCycle := 'Ciclo Oggetto (a := AM, PM := b, c := entrambe)';
  FRS_IPTCTAG_PS_ImageType := 'Tipo di immagine';
  FRS_IPTCTAG_PS_CopyrightNotice := 'Copyright';

  FRS_XMP_Aux_ApproximateFocusDistance := 'Distanza Focale';
  FRS_XMP_Aux_Firmware := 'Firmware';
  FRS_XMP_Aux_FlashCompensation := 'Compensazione flash';
  FRS_XMP_Aux_ImageNumber := 'Codice Immagine';
  FRS_XMP_Aux_Lens := 'Lente';
  FRS_XMP_Aux_LensID := 'Lente ID';
  FRS_XMP_Aux_LensInfo := 'Lente Info';
  FRS_XMP_Aux_LensSerialNumber := 'Numero di serie Obiettivo';
  FRS_XMP_Aux_OwnerName := 'Nome proprietario';
  FRS_XMP_Aux_SerialNumber := 'Numero di serie';
  FRS_XMP_CC_AttributionName := 'Attribuzione Nome';
  FRS_XMP_CC_AttributionURL := 'Attribuzione URL';
  FRS_XMP_CC_DeprecatedOn := 'Deprecato - attivare';
  FRS_XMP_CC_Jurisdiction := 'Giurisdizione';
  FRS_XMP_CC_LegalCode := 'Codice Legale';
  FRS_XMP_CC_License := 'Licenza';
  FRS_XMP_CC_MorePermissions := 'Più autorizzazioni';
  FRS_XMP_CC_Permits := 'Permessi';
  FRS_XMP_CC_Prohibits := 'Proibizioni';
  FRS_XMP_CC_Requires := 'Richiede';
  FRS_XMP_CC_UseGuidelines := 'Usa Linee Guida';

  FRS_XMP_DC_Contributor := 'Collaboratore';
  FRS_XMP_DC_Coverage := 'Copertura';
  FRS_XMP_DC_Creator := 'Creatore';
  FRS_XMP_DC_Date := 'Data';
  FRS_XMP_DC_Description := 'Descrizione';
  FRS_XMP_DC_Format := 'Formato';
  FRS_XMP_DC_Identifier := 'Identificativo';
  FRS_XMP_DC_Language := 'Lingua';
  FRS_XMP_DC_Publisher := 'Editore';
  FRS_XMP_DC_Relation := 'Rapporto';
  FRS_XMP_DC_Rights := 'Diritti';
  FRS_XMP_DC_Source := 'Sorgente';
  FRS_XMP_DC_Subject := 'Soggetto';
  FRS_XMP_DC_Title := 'Titolo';
  FRS_XMP_DC_Type := 'Tipo';

  FRS_XMP_Photoshop_AuthorsPosition := 'Posizione Autori';
  FRS_XMP_Photoshop_CaptionWriter := 'Didascalia Scrittore';
  FRS_XMP_Photoshop_Category := 'Categoria';
  FRS_XMP_Photoshop_City := 'Città';
  FRS_XMP_Photoshop_ColorMode := 'Modo colore';
  FRS_XMP_Photoshop_Country := 'Paese';
  FRS_XMP_Photoshop_Credit := 'Crediti';
  FRS_XMP_Photoshop_DateCreated := 'Data di Creazione';
  FRS_XMP_Photoshop_DocumentAncestorID := 'ID Documento Antenato';
  FRS_XMP_Photoshop_Headline := 'Titolo';
  FRS_XMP_Photoshop_History := 'Storia';
  FRS_XMP_Photoshop_ICCProfileName := 'Profilo ICC';
  FRS_XMP_Photoshop_Instructions := 'Istruzioni';
  FRS_XMP_Photoshop_Source := 'Sorgente';
  FRS_XMP_Photoshop_State := 'Stato';
  FRS_XMP_Photoshop_SupplementalCategories := 'Altre Categorie';
  FRS_XMP_Photoshop_TextLayerName := 'Nome Layer di Testo';
  FRS_XMP_Photoshop_TextLayerText := 'Testo Layer di Testo';
  FRS_XMP_Photoshop_TransmissionReference := 'Riferimento Trasmissione';
  FRS_XMP_Photoshop_Urgency := 'Urgenza';

  FRS_XMP_Advisory := 'Consultivo';
  FRS_XMP_Author := 'Autore';
  FRS_XMP_BaseURL := 'URL Base';
  FRS_XMP_CreateDate := 'Data Creazione';
  FRS_XMP_CreatorTool := 'Strumento Creazione';
  FRS_XMP_Description := 'Descrizione';
  FRS_XMP_Format := 'Formato';
  FRS_XMP_Identifier := 'Identificativo';
  FRS_XMP_Keywords := 'Parole-Chiave';
  FRS_XMP_Label := 'Etichetta';
  FRS_XMP_MetadataDate := 'Data metadati';
  FRS_XMP_ModifyDate := 'Data modifica';
  FRS_XMP_Nickname := 'Nickname';
  FRS_XMP_Rating := 'Valutazione';
  FRS_XMP_Title := 'Titolo';

  FRS_EXIF_UserComment := 'Commento Utente';
  FRS_EXIF_ImageDescription := 'Descrizione Immagine';
  FRS_EXIF_CameraMake := 'Marca fotocamera';
  FRS_EXIF_CameraModel := 'Modello di fotocamera';
  FRS_EXIF_XResolution := 'X Risoluzione';
  FRS_EXIF_YResolution := 'Y Risoluzione';
  FRS_EXIF_DateTime := 'Data-Ora';
  FRS_EXIF_DateTimeOriginal := 'Data-Ora originale';
  FRS_EXIF_DateTimeDigitized := 'Data-Ora digitalizzato';
  FRS_EXIF_Copyright := 'Copyright';
  FRS_EXIF_Orientation := 'Orientamento';
  FRS_EXIF_ExposureTime := 'Tempo di esposizione';
  FRS_EXIF_FNumber := 'fnumber';
  FRS_EXIF_ExposureProgram := 'Programma Esposizione';
  FRS_EXIF_ISOSpeedRatings := 'ISO velocità';
  FRS_EXIF_ShutterSpeedValue := 'Velocità Otturatore';
  FRS_EXIF_ApertureValue := 'Aperture';
  FRS_EXIF_BrightnessValue := 'Luminosità';
  FRS_EXIF_ExposureBiasValue := 'Bias Esposizione';
  FRS_EXIF_MaxApertureValue := 'Apertura Massima';
  FRS_EXIF_SubjectDistance := 'Distanza Soggetto';
  FRS_EXIF_MeteringMode := 'Modalità Misurazione';
  FRS_EXIF_LightSource := 'Sorgente di luce';
  FRS_EXIF_Flash := 'Flash';
  FRS_EXIF_FocalLength := 'Lunghezza focale';
  FRS_EXIF_FlashPixVersion := 'FlashPix V.';
  FRS_EXIF_ColorSpace := 'Spazio colore';
  FRS_EXIF_ExifImageWidth := 'Larghezza immagine';
  FRS_EXIF_ExifImageHeight := 'Altezza immagine';
  FRS_EXIF_RelatedSoundFile := 'File audio correlati';
  FRS_EXIF_FocalPlaneXResolution := 'Risoluzione X piano focale';
  FRS_EXIF_FocalPlaneYResolution := 'Risoluzione Y piano focale';
  FRS_EXIF_ExposureIndex := 'Indice di Esposizione';
  FRS_EXIF_SensingMethod := 'Metodo di Rilevazione';
  FRS_EXIF_FileSource := 'Origine file';
  FRS_EXIF_SceneType := 'Tipo di Scena';
  FRS_EXIF_YCbCrPositioning := 'YCbCr posizionamento';
  FRS_EXIF_ExposureMode := 'Modalità Esposizione';
  FRS_EXIF_WhiteBalance := 'Bilanciamento del Bianco';
  FRS_EXIF_DigitalZoomRatio := 'Rapporto Zoom Digitale';
  FRS_EXIF_FocalLengthIn35mmFilm := 'Lunghezza focale 35 mm. equiv.';
  FRS_EXIF_SceneCaptureType := 'Tipo Cattura Scena';
  FRS_EXIF_GainControl := 'Guadagno Controllo';
  FRS_EXIF_Contrast := 'Contrasto';
  FRS_EXIF_Saturation := 'Saturazione';
  FRS_EXIF_Sharpness := 'Nitidezza';
  FRS_EXIF_SubjectDistanceRange := 'Range Distanza Soggetto';
  FRS_EXIF_GPSLatitude := 'GPS Latitudine';
  FRS_EXIF_GPSLongitude := 'GPS Longitudine';
  FRS_EXIF_GPSAltitude := 'GPS Altitudine';
  FRS_EXIF_GPSImageDirection := 'GPS Direzione Immagine';
  FRS_EXIF_GPSTrack := 'GPS Traccia';
  FRS_EXIF_GPSSpeed := 'GPS Velocità ';
  FRS_EXIF_GPSDateAndTime := 'GPS Data e Ora ';
  FRS_EXIF_GPSSatellites := 'Satelliti GPS';
  FRS_EXIF_GPSVersionID := 'GPS ID Versione';
  FRS_EXIF_Artist := 'Artista';
  FRS_EXIF_XPTitle := 'Titolo (Windows)';
  FRS_EXIF_XPComment := 'Commento (Windows)';
  FRS_EXIF_XPAuthor := 'Autore (Windows)';
  FRS_EXIF_XPKeywords := 'Parole-Chiave (Windows)';
  FRS_EXIF_XPSubject := 'Soggetto (Windows)';
  FRS_EXIF_XPRating := 'Valutazione (Windows)';
  FRS_EXIF_InteropVersion := 'Versione Interop';
  FRS_EXIF_CameraOwnerName := 'Nome Proprietario Fotocamera';
  FRS_EXIF_BodySerialNumber := 'Numero di Serie Corpo-Macchina';
  FRS_EXIF_LensMake := 'Costruttore Lente';
  FRS_EXIF_LensModel := 'Modello Lente';
  FRS_EXIF_LensSerialNumber := 'Numero di Serie Obiettivo';
  FRS_EXIF_Gamma := 'Gamma';
  FRS_EXIF_SubjectArea := 'Area della Ripresa';
  FRS_EXIF_SubjectLocation := 'Località della Ripresa';
end;


end.
