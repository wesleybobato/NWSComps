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
unit NWSComps_ThumbsBrowser_RES_ES;


interface

  uses NWSComps_ThumbsBrowser_RES_CONST;

  type
    TTBTranslateMemory_ES = class(TTBTranslateMemory)
      public
      Constructor Create; reintroduce;
    end;

implementation


{ TTBTranslateMemory_ES }

constructor TTBTranslateMemory_ES.Create;
begin
  FRS_TBSORT_NameA := 'Nombre ->';
  FRS_TBSORT_NameD := 'Nombre <-';
  FRS_TBSORT_DateA := 'Fecha ->';
  FRS_TBSORT_DateD :=  'Fecha <-';
  FRS_TBSORT_ExifDateA :=  'Fecha (Exif) ->';
  FRS_TBSORT_ExifDateD :=  'Fecha (Exif) <-';
  FRS_TBSORT_SizeA :=  'Tamaño ->';
  FRS_TBSORT_SizeD := 'Tamaño <-';
  FRS_TBSORT_FolderA := 'Carpeta ->';
  FRS_TBSORT_FolderD :=  'Carpeta <-';
  FRS_TBSORT_FileTypeA :=  'Tipo de Archivo ->';
  FRS_TBSORT_FileTypeD :=  'Tipo de Archivo <-';
  FRS_TBSORT_NameNaturalA := 'Nombre ->';
  FRS_TBSORT_NameNaturalD := 'Nombre <-';
  FRS_TBSORT_FolderNaturalA := 'Carpeta ->';
  FRS_TBSORT_FolderNaturalD :=  'Carpeta <-';

FRS_METAHLP_Index := '. No';
  FRS_METAHLP_Field := 'campo';
  FRS_METAHLP_ErrorParsingWrongGridFormat := 'Error Análisis: formato de cuadrícula no válido';

  FRS_METAPN_DISPLAYMODE_NONEMPTY := 'Mostrar no vacía';
  FRS_METAPN_DISPLAYMODE_All := 'Mostrar todos';
  FRS_METAPN_DISPLAYMODE_GROUPED := 'Mostrar agrupados por Core';
  FRS_METAPN_PENDINGCHANGES_SINGLE := 'Información para el archivo actual modificado. Guardar los cambios? ';
  FRS_METAPN_PENDINGCHANGES_MULTI :=  'Para más archivos de información han cambiado. Guardar los cambios? ';
  FRS_METAPN_TABCOMMON := 'Común';

  FRS_SH_OP_DELETINGFILES := 'Eliminación de archivos en curso .. ';
  FRS_SH_OP_RECYCLINGFILES := 'Archivos de reciclaje en curso ..';
  FRS_SH_OP_MOVINGFILES := 'Mover archivos en curso ..';
  FRS_SH_OP_COPYINGFILES := 'Copiar archivos en curso ..';
  FRS_SH_OP_SAVINGFILES := 'Cómo guardar los archivos en curso ..';
  FRS_SH_OP_CORRECTINGORIENTATION := 'Archivos de corrección de la orientación (EXIF) en curso ..';
  FRS_SH_OP_ROTATINGFILES := 'Archivos de rotación en curso ..';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WPD := 'Atención! No se permite reciclar %s '+
    'Archivos porque son dispositivos portátiles.' +
    'En lugar de que deseas eliminarlos? (Esto no se puede deshacer!) ';
  FRS_SH_OP_WARNING_RECYCLE_NOTALLOWED_WIA := 'Atención! El reciclaje no permitida para %s ' +
  'Archivos porque están en una conexión WIA.' +
    'En lugar de que deseas eliminarlos? (Esto no se puede deshacer!) ';
  FRS_SH_OP_WARNING_INTERNETFILE_CANNOTBEMOVED :=
    'Hay archivos de Internet, por lo que sólo una copia es posible. ' +
    'Quieres transferir todos modos?';

  FRS_INFOFORM_FDate := 'Fecha: ';
  FRS_INFOFORM_FSize := 'Tamaño: ';
  FRS_INFOFORM_HINT_ADDEXIFINFO := 'Añadir información Exif';
  FRS_INFOFORM_HINT_ADDIPTCINFO := 'Añadir información IPTC';
  FRS_INFOFORM_ERROR_CANNOTWRITEMETA := 'No se puede escribir metadatos para el archivo';
  FRS_INFOFORM_BTNSAVE := 'Guardar';
  FRS_INFOFORM_BTNSAVERENAME := 'Guardar / Cambiar nombre ';
  FRS_INFOFORM_BTNRENAME := 'Cambiar nombre';
  FRS_INFOFORM_BTNADDEXIF := 'Añadir Exif ';
  FRS_INFOFORM_BTNADDIPTC := 'Añadir IPTC ';

  FRS_CAP_SHOWFILENAME := 'Nombre';
  FRS_CAP_SHOWFILEDATE := 'Fecha';
  FRS_CAP_SHOWFILESIZE := 'Tamaño';
  FRS_CAP_SHOWFILEDIMS := 'Tamaño de la imagen';
  FRS_CAP_SHOWEXIFDATETIME := 'Exif Fecha-Hora';
  FRS_CAP_SHOWEXIFAUTHOR := 'Exif Autor';
  FRS_CAP_SHOWEXIFTITLE := 'Exif Título';
  FRS_CAP_SHOWEXIFSUBJECT := 'Exif Sujeto';
  FRS_CAP_SHOWEXIFCOMMENT := 'Exif Comentario';
  FRS_CAP_SHOWEXIFKEYWORDS := 'Exif Palabras Clave' ;
  FRS_CAP_SHOWEXIFRATING := 'Exif Valoración';
  FRS_CAP_SHOWKEYWORDS := 'Palabras-Clave';
  FRS_CAP_SHOWRATING := 'Valoración';
  FRS_CAP_SHOWFILENAMEWITHOUT := 'Nombre';
  FRS_CAP_SHOWFILEPATH := 'Camino';
  FRS_CAP_SHOWFILEDIMSSIZE := 'Tamaño imagen y archivo';
  FRS_CAP_SHOWFILECREATEDATE := 'Fecha de creación';
  FRS_CAP_SHOWFILECREATEDATETIME := 'Fecha-Hora de creación';
  FRS_CAP_SHOWFILEEDITDATE := 'Fecha de modificación';
  FRS_CAP_SHOWFILEEDITDATETIME := 'Fecha-Tiempo de redacción';
  FRS_CAP_SHOWFILETYPE := 'Tipo de archivo';
  FRS_CAP_SHOWTOPTITLE := 'Título superior';
  FRS_CAP_SHOWBOTTOMTITLE := 'Título inferior';
  FRS_CAP_SHOWGENERAL := 'Info';
  FRS_CAP_SHOWOTHER1 := 'Otro';
  FRS_CAP_SHOWOTHER2 := 'Otro';
  FRS_CAP_SHOWOTHER3 := 'Otro';
  FRS_CAP_SHOWOTHER4 := 'Otro';

  FRS_IPTCTAG_PS_Title := 'Título';
  FRS_IPTCTAG_PS_Caption := 'Leyenda';
  FRS_IPTCTAG_PS_Keywords := 'Las palabras-clave';
  FRS_IPTCTAG_PS_Instructions := 'Instrucciones especiales';

  FRS_IPTCTAG_PS_Date_Created := 'Fecha de creación (AAAAMMDD)';
  FRS_IPTCTAG_PS_Time_Created := 'Hora de creación (HHMMSS ± HHMM)';
  FRS_IPTCTAG_PS_ByLine1 := 'Por línea 1';
  FRS_IPTCTAG_PS_ByLine2 := 'Por línea 2';
  FRS_IPTCTAG_PS_City := 'Ciudad';
  FRS_IPTCTAG_PS_State := 'Estado / Provincia';
  FRS_IPTCTAG_PS_Country_Code := 'Código de País / Región';
  FRS_IPTCTAG_PS_Country_Name := 'Nombre País / Región';
  FRS_IPTCTAG_PS_TransmissionRef := 'Ref. Transmisión';
  FRS_IPTCTAG_PS_Credit := 'Créditos';
  FRS_IPTCTAG_PS_Editor := 'Editor';
  FRS_IPTCTAG_PS_EditStatus := 'Estado de edición';
  FRS_IPTCTAG_PS_Urgency := 'Urgencia';
  FRS_IPTCTAG_PS_Category := 'Categoría';
  FRS_IPTCTAG_PS_SupplCategory := 'Categoría adicional';
  FRS_IPTCTAG_PS_FixtureID := 'ID Fixture';
  FRS_IPTCTAG_PS_ReleaseDate := 'Fecha de emisión (AAAAMMDD)';
  FRS_IPTCTAG_PS_ReleaseTime := 'Hora de emisión (HHMMSS ± HHMM)';
  FRS_IPTCTAG_PS_ReferenceService := 'Servicio Referencia';
  FRS_IPTCTAG_PS_ReferenceDate := 'Fecha de referencia (AAAAMMDD)';
  FRS_IPTCTAG_PS_ReferenceNumber := 'Número de referencia';
  FRS_IPTCTAG_PS_OrigProgram := 'Programa originarios';
  FRS_IPTCTAG_PS_ProgVersion := 'versión del programa';
  FRS_IPTCTAG_PS_ObjectCycle := 'Ciclo de sujeto (A := AM, PM := b, c := ambos)';
  FRS_IPTCTAG_PS_ImageType := 'Tipo de imagen';
  FRS_IPTCTAG_PS_CopyrightNotice := 'Derechos de Autor';



  FRS_XMP_Aux_ApproximateFocusDistance := 'Distancia focal';
  FRS_XMP_Aux_Firmware := 'Firmware';
  FRS_XMP_Aux_FlashCompensation := 'Flash de relleno';
  FRS_XMP_Aux_ImageNumber := 'Número de imagen';
  FRS_XMP_Aux_Lens := 'Lente';
  FRS_XMP_Aux_LensID := 'Lente ID';
  FRS_XMP_Aux_LensInfo := 'Lente Info';
  FRS_XMP_Aux_LensSerialNumber := 'Número de serie de la lente';
  FRS_XMP_Aux_OwnerName := 'Nombre del propietario';
  FRS_XMP_Aux_SerialNumber := 'Número de Serie';
  FRS_XMP_CC_AttributionName := 'Nombre Atribución';
  FRS_XMP_CC_AttributionURL := 'URL Atribución';
  FRS_XMP_CC_DeprecatedOn := 'desaprobado - a su vez';
  FRS_XMP_CC_Jurisdiction := 'Jurisdicción';
  FRS_XMP_CC_LegalCode := 'Texto Legal';
  FRS_XMP_CC_License := 'Licencia';
  FRS_XMP_CC_MorePermissions := 'Otros Permisos';
  FRS_XMP_CC_Permits := 'Permisos';
  FRS_XMP_CC_Prohibits := 'Prohibiciones';
  FRS_XMP_CC_Requires := 'Requerir';
  FRS_XMP_CC_UseGuidelines := 'Uso Directrices';

  FRS_XMP_DC_Contributor := 'Personal';
  FRS_XMP_DC_Coverage := 'Portada';
  FRS_XMP_DC_Creator := 'Creador';
  FRS_XMP_DC_Date := 'Fecha';
  FRS_XMP_DC_Description := 'Descripción';
  FRS_XMP_DC_Format := 'Formato';
  FRS_XMP_DC_Identifier := 'ID';
  FRS_XMP_DC_Language := 'Idioma';
  FRS_XMP_DC_Publisher := 'Editorial';
  FRS_XMP_DC_Relation := 'Informe';
  FRS_XMP_DC_Rights := 'derechos';
  FRS_XMP_DC_Source := 'fuente';
  FRS_XMP_DC_Subject := 'Sujeto';
  FRS_XMP_DC_Title := 'Título';
  FRS_XMP_DC_Type := 'Tipo';

  FRS_XMP_Photoshop_AuthorsPosition := 'Posición de los autores';
  FRS_XMP_Photoshop_CaptionWriter := 'Escritor Leyenda';
  FRS_XMP_Photoshop_Category := 'Categoría';
  FRS_XMP_Photoshop_City := 'City';
  FRS_XMP_Photoshop_ColorMode := 'Modo de color';
  FRS_XMP_Photoshop_Country := 'País';
  FRS_XMP_Photoshop_Credit := 'Créditos';
  FRS_XMP_Photoshop_DateCreated := 'Fecha de creación';
  FRS_XMP_Photoshop_DocumentAncestorID := 'documento de identidad antepasado';
  FRS_XMP_Photoshop_Headline := 'Título';
  FRS_XMP_Photoshop_History := 'Historia';
  FRS_XMP_Photoshop_ICCProfileName := 'Perfil ICC';
  FRS_XMP_Photoshop_Instructions := 'instrucciones';
  FRS_XMP_Photoshop_Source := 'Fuente';
  FRS_XMP_Photoshop_State := 'Estado';
  FRS_XMP_Photoshop_SupplementalCategories := 'Otras categorías';
  FRS_XMP_Photoshop_TextLayerName := 'Nombre de la capa de texto';
  FRS_XMP_Photoshop_TextLayerText := 'capa de texto texto';
  FRS_XMP_Photoshop_TransmissionReference := 'Referencia Transmisión';
  FRS_XMP_Photoshop_Urgency := 'Urgencia';

  FRS_XMP_Advisory := 'Consultivo';
  FRS_XMP_Author := 'Autor';
  FRS_XMP_BaseURL := 'Base URL';
  FRS_XMP_CreateDate := 'Fecha de creación';
  FRS_XMP_CreatorTool := 'Herramienta de creación';
  FRS_XMP_Description := 'Descripción';
  FRS_XMP_Format := 'Formato';
  FRS_XMP_Identifier := 'ID';
  FRS_XMP_Keywords := 'Palabras-clave';
  FRS_XMP_Label := 'Etiqueta';
  FRS_XMP_MetadataDate := 'Fecha de los metadatos';
  FRS_XMP_ModifyDate := 'Fecha de modificación';
  FRS_XMP_Nickname := 'Alias';
  FRS_XMP_Rating := 'Valoración';
  FRS_XMP_Title := 'Título';

  FRS_EXIF_UserComment := 'Comentario del usuario';
  FRS_EXIF_ImageDescription := 'Descripción de la Imagen';
  FRS_EXIF_CameraMake := 'Marca de la cámara';
  FRS_EXIF_CameraModel := 'Modelo de cámara';
  FRS_EXIF_XResolution := 'Resolución X';
  FRS_EXIF_YResolution := 'Resolución Y';
  FRS_EXIF_DateTime := 'Fecha-Hora';
  FRS_EXIF_DateTimeOriginal := 'Fecha-Hora de Origen';
  FRS_EXIF_DateTimeDigitized := 'Fecha-Hora Digitalizada';
  FRS_EXIF_Copyright := 'Derechos de Autor';
  FRS_EXIF_Orientation := 'Orientación';
  FRS_EXIF_ExposureTime := 'Tiempo de exposición';
  FRS_EXIF_FNumber := 'F-Número';
  FRS_EXIF_ExposureProgram := 'Programa de exposición';
  FRS_EXIF_ISOSpeedRatings := 'Sensibilidad ISO';
  FRS_EXIF_ShutterSpeedValue := 'Velocidad de obturación';
  FRS_EXIF_ApertureValue := 'Apertura';
  FRS_EXIF_BrightnessValue := 'Brillo';
  FRS_EXIF_ExposureBiasValue := 'Exposición Bias';
  FRS_EXIF_MaxApertureValue := 'Apertura';
  FRS_EXIF_SubjectDistance := 'Distancia al Sujeto';
  FRS_EXIF_MeteringMode := 'Modo de medición';
  FRS_EXIF_LightSource := 'Fuente de luz';
  FRS_EXIF_Flash := 'Flash';
  FRS_EXIF_FocalLength := 'Distancia Focal';
  FRS_EXIF_FlashPixVersion := 'FlashPix V.';
  FRS_EXIF_ColorSpace := 'Espacio de Color';
  FRS_EXIF_ExifImageWidth := 'Ancho de la imagen';
  FRS_EXIF_ExifImageHeight := 'Altura de la imagen';
  FRS_EXIF_RelatedSoundFile := 'Archivo de audio relacionado';
  FRS_EXIF_FocalPlaneXResolution := 'Resolución X plano focal';
  FRS_EXIF_FocalPlaneYResolution := 'Resolución Y plano focal ';
  FRS_EXIF_ExposureIndex := 'Indice de exposición';
  FRS_EXIF_SensingMethod := 'Método de detección';
  FRS_EXIF_FileSource := 'Archivos de origen';
  FRS_EXIF_SceneType := 'Tipo de escena';
  FRS_EXIF_YCbCrPositioning := 'YCbCr posicionamiento';
  FRS_EXIF_ExposureMode := 'Modo de Exposición';
  FRS_EXIF_WhiteBalance := 'Balance de Blancos';
  FRS_EXIF_DigitalZoomRatio := 'Proporción de zoom digital';
  FRS_EXIF_FocalLengthIn35mmFilm := 'Longitud focal de 35 mm. equiv. ';
  FRS_EXIF_SceneCaptureType := 'Tipo de captura de escenas';
  FRS_EXIF_GainControl := 'Control de Ganancia';
  FRS_EXIF_Contrast := 'Contraste';
  FRS_EXIF_Saturation := 'Saturación';
  FRS_EXIF_Sharpness := 'Nitidez';
  FRS_EXIF_SubjectDistanceRange := 'Rango de distancia del Sujeto';
  FRS_EXIF_GPSLatitude := 'GPS Latitud';
  FRS_EXIF_GPSLongitude := 'GPS Longitud';
  FRS_EXIF_GPSAltitude := 'GPS Altitud';
  FRS_EXIF_GPSImageDirection := 'GPS Dirección Imagen';
  FRS_EXIF_GPSTrack := 'Localización por GPS';
  FRS_EXIF_GPSSpeed := 'Velocidad GPS';
  FRS_EXIF_GPSDateAndTime := 'Fecha y hora GPS';
  FRS_EXIF_GPSSatellites := 'Satélites GPS';
  FRS_EXIF_GPSVersionID := 'GPS Versión ID';
  FRS_EXIF_Artist := 'Artista';
  FRS_EXIF_XPTitle := 'Título (Windows)';
  FRS_EXIF_XPComment := 'Comentarios (Windows)';
  FRS_EXIF_XPAuthor := 'Autor (Windows)';
  FRS_EXIF_XPKeywords := 'Palabras-clave (Windows)';
  FRS_EXIF_XPSubject := 'Sujeto (Windows)';
  FRS_EXIF_XPRating := 'Valoración (Windows)';
  FRS_EXIF_InteropVersion := 'Versión de interoperabilidad';
  FRS_EXIF_CameraOwnerName := 'Nombre del propietario de la cámara';
  FRS_EXIF_BodySerialNumber := 'Número de Serie Cuerpo de cámara';
  FRS_EXIF_LensMake := 'Fabricante lente';
  FRS_EXIF_LensModel := 'Modelo lente';
  FRS_EXIF_LensSerialNumber := 'Número de Serie Objetivo';
  FRS_EXIF_Gamma := 'Gamma';
  FRS_EXIF_SubjectArea := 'Area de la foto';
  FRS_EXIF_SubjectLocation := 'Ubicacion de la foto';
end;


end.
