{.$define TB_USEDB}
{$define TB_TOUCH}
{$define TB_GDIPLUS}
{$define TB_PORTABLEDEVICE}
{.$define TB_NATIVEDRAGDROP_TOIMAGEEN}  //if you enable this, dragdrop to Imageen components is handled natively
                                        //otherwise you have to handle yourself the ondragdrop event
                                        //the advantage of having it disabled is that 
                                       //the compile will exclude both imageenview and iemview units
                                        //thus reducing the size of the exe and the compiling time
                                        //also you will still be able to handle drag-drop to Imageen manually 