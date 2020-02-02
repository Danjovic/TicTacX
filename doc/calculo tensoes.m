r1=470
r2=220
r3=180
rl=75
voh=4.7
vol=0.6


vwhite_loaded=(voh/r1+voh/r2) / (1/r1 +1/r2 +1/r3 +1/rl);
vblack_loaded=(voh/r1+vol/r2) / (1/r1 +1/r2 +1/r3 +1/rl);
vsync_loaded=(vol/r1+vol/r2) / (1/r1 +1/r2 +1/r3 +1/rl);


vwhite_unloaded=(voh/r1+voh/r2) / (1/r1 +1/r2 +1/r3);
vblack_unloaded=(voh/r1+vol/r2) / (1/r1 +1/r2 +1/r3);
vsync_unloaded=(vol/r1+vol/r2) / (1/r1 +1/r2 +1/r3 );


loaded = { vwhite_loaded vwhite_unloaded  vwhite_unloaded/vwhite_loaded;
           vblack_loaded vblack_unloaded  vblack_unloaded/vblack_loaded;
		   vsync_loaded  vsync_unloaded   vsync_unloaded/vsync_loaded;
}


vwhite_loaded-vblack_loaded
vblack_loaded-vsync_loaded
