
{.$DEFINE STANDALONE_MULTIPROC}  //standalone version of the TIEMultiProc_EX


//-----------IMAGEEN VERSION-------------------------------------------------------
{$IFDEF STANDALONE_MULTIPROC}
       {$DEFINE IMAGEEN_5_0_LATER}  //must be defined for imageEn versions >= 5.0
       {$DEFINE IMAGEEN_5_2_LATER}  //must be defined for imageEn versions >= 5.2 
       {$DEFINE IMAGEEN_6_2_LATER}  //must be defined for imageEn versions >= 6.2
       {$DEFINE IMAGEEN_6_2_2_LATER}  //must be defined for imageEn versions >= 6.2.2
       {$DEFINE IMAGEEN_6_3_0_LATER}  //must be defined for imageEn versions >= 6.3.0
{$ENDIF}