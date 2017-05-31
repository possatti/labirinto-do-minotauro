use Image::PBMlib;

... open(PPM, "< 20x20.bmp")...

my $ref = readppmheader(\*PPM);

my @pixels = readpixels_raw(\*PPM, $$ref{type}, 
($$ref{width} * $$ref{height}) );

my @pixels = readpixels_dec(\*PPM, $$ref{type}, 
($$ref{width} * $$ref{height}) );

my @rgb = hextriplettoraw("F00BA4");

my @rgb = dectriplettoraw("17:34:51");

my $header = makeppmheader($ref);