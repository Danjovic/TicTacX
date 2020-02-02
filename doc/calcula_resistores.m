voh=4.7
vol=0.6
rl=75
vsync=0.6
vblack=0.3+vsync
vwhite=0.7+vblack

A= {
voh-vwhite    voh-vwhite    -vwhite ;
voh-vblack    vol-vblack    -vblack ;
vol-vsync     vol-vsync     -vsync  ;
voh-2*vwhite  voh-2*vwhite  -2*vwhite ;
voh-2*vblack  vol-2*vblack  -2*vblack ;
vol-2*vsync   vol-2*vsync   -2*vsync  }


b={ vwhite/rl ; vblack/rl ; vsync/rl ; 0 ; 0; 0}

x=A\b

y=x.^-1