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
unit NWSComps_ThumbsBrowser_Database_Utils;
{$R-}
{$Q-}
interface
{$I ..\_inc\NWSComps_ThumbsBrowser.inc}


  uses sysutils;

  CONST

    TBCONST_DBKind = 'TThumbBrowser DB';
    TBCONST_DBVersion = 3.0;
    TBCONST_DBPassword = 'TB_Restructure_PW';


    TBCONST_MAXLEN_IDSTRING = 800;

    TB_TABLE_FIELD_DBKIND = 'DBKind';
    TB_TABLE_FIELD_DBVERSION = 'DBVersion';
    TB_TABLE_FIELD_DICTIONARY = 'Dictionary';


   TB_TABLE_FIELD_REC = 'Rec';
   TB_TABLE_FIELD_IDSTRING = 'IDString';
   TB_TABLE_FIELD_PATH = 'Path';
   TB_TABLE_FIELD_FILENAME_FULL = 'FileName_Full';
   TB_TABLE_FIELD_FILEDATE = 'FileDate';

   TB_TABLE_FIELD_EXIF_FILEDATE = 'ExifFileDate';
   TB_TABLE_FIELD_EXIF_XPTITLE = 'ExifXPTitle';
   TB_TABLE_FIELD_EXIF_XPAUTHOR = 'ExifXPAuthor';
   TB_TABLE_FIELD_EXIF_XPCOMMENTS = 'ExifXPComments';

   //v.3.0 start
   TB_TABLE_FIELD_EXIF_ORIENTATION = 'ExifOrientation';

   TB_TABLE_FIELD_HASH_MD5 = 'HashMD5';
   TB_TABLE_FIELD_METATAGS_VERSION = 'MetaTagsVersion';
   TB_TABLE_FIELD_KEYWORDS = 'Keywords';
   TB_TABLE_FIELD_RATING = 'Rating';
   TB_TABLE_FIELD_TOPTITLE = 'TopTitle';
   TB_TABLE_FIELD_BOTTOMTITLE = 'BottomTitle';

   TB_TABLE_FIELD_HASEXIF = 'HasExif';
   TB_TABLE_FIELD_HASIPTC = 'HasIptc';
   TB_TABLE_FIELD_HASDICOM = 'HasDicom';
   TB_TABLE_FIELD_HASXMP = 'HasXmp';

   TB_TABLE_METADATA_SAVED = 'MetaDataSaved';
   TB_TABLE_SYNCFIELDS_SAVED = 'SyncFieldsSaved';
   //v.3.0 end

   //v.3.1 start
   TB_TABLE_FIELD_FILEDRIVETYPE = 'FileDriveType';
   TB_TABLE_FIELD_FILEDRIVEVOLUMELABEL = 'FileDriveVolumeLabel';
   TB_TABLE_FIELD_FILEIMPORTED = 'FileImported';
   {
     DRIVE_UNKNOWN 0 The drive type cannot be determined.
     DRIVE_NO_ROOT_DIR 1 The root path is invalid; for example, there is no volume mounted at the specified path.
     DRIVE_REMOVABLE 2 The drive has removable media; for example, a floppy drive, thumb drive, or flash card reader.
     DRIVE_FIXED 3 The drive has fixed media; for example, a hard disk drive or flash drive.
     DRIVE_REMOTE 4 The drive is a remote (network) drive.
     DRIVE_CDROM 5 The drive is a CD-ROM drive.
   }
   //v.3.1 end

   TB_TABLE_FIELD_FILESIZE = 'FileSize';
   TB_TABLE_FIELD_PICTURE_RES = 'Picture_Res';
   TB_TABLE_FIELD_PICTURE_WIDTH = 'Picture_Width';
   TB_TABLE_FIELD_PICTURE_HEIGHT = 'Picture_Height';
   TB_TABLE_FIELD_THUMB_SIZE = 'ThumbSize';
   TB_TABLE_FIELD_THUMB = 'Thumb';




  type
    TTB_Browser_DB_Mode = (dbmEdit, dbmInsert);
    TTB_Browser_DB_ExistsMatchType = (DBDoesntExist, DBExistsOldversion, DBExists);

    TTBThumbExistMatchType = (TERcdDoesntExist, TERcdExistsOld, TERcdExistsWithOldParams, TERcdExists, TEUnknown);

    TTB_DB_ThumbExistResult =
    record
    Index: integer;
    MatchType: TTBThumbExistMatchType;
    MatchedThumb: TObject;
  end;


implementation





end.
