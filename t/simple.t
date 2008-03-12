#!perl
# Simple test for Astro::Telescope
# to test constructor

use strict;
use Test::More tests => 36;

require_ok("Astro::Telescope");

# Test unknown telescope
my $tel = new Astro::Telescope( "blah" );
is( $tel, undef, "check unknown telescope" );

# Now a known telescope
$tel = new Astro::Telescope( "JCMT" );

# Compare and contrast. This all assumes slaObs is not updated.
is($tel->name, "JCMT","compare short name");
is($tel->fullname, "JCMT 15 metre","compare long name");
is($tel->lat("s"), "19 49 22.11","compare lat");
is($tel->long("s"), "-155 28 37.20","compare long");
is($tel->alt, 4111,"compare alt");
is($tel->obscode, 568,"compare obs code");

# Change telescope to something wrong
$tel->name("blah");
is($tel->name, "JCMT","compare shortname to unknown");

# To something valid
$tel->name("JODRELL1");
is($tel->name, "JODRELL1","switch to Jodrell");
is($tel->obscode, undef,"no obs code");

# Full list of telescope names
my @list = Astro::Telescope->telNames;
ok(scalar(@list),"Count names");

# Check limits of JCMT
$tel->name( 'JCMT' );
my %limits = $tel->limits;

is( $limits{type}, "AZEL","Mount type");
ok(exists $limits{el}{max},"Have max el" );
ok(exists $limits{el}{min},"Have min el" );

# Switch telescope
$tel->name( "UKIRT" );
is( $tel->name, "UKIRT","switch to UKIRT");
is( $tel->fullname, "UK Infra Red Telescope","Long UKIRT name");
is( sprintf("%.9f", $tel->geoc_lat), sprintf("%.9f", "0.343830843"),"UKIRT Geocentric Lat" );
is( $tel->geoc_lat("s"), "19 42 0.20","compare string form of Geo lat");

%limits = $tel->limits;
is( $limits{type}, "HADEC","Mount type");
ok(exists $limits{ha}{max},"Max ha" );
ok(exists $limits{ha}{min},"Min HA" );
ok(exists $limits{dec}{max},"Max dec" );
ok(exists $limits{dec}{min},"Min dec" );

# test constructor that takes a hash
my $new = new Astro::Telescope( Name => $tel->name,
				Long => $tel->long,
				Lat  => $tel->lat,
				Alt => 0,
			      );
ok($new,"Created from long/lat");

is($new->name, $tel->name,"compare name");
is($new->long, $tel->long,"compare long");
is($new->lat,  $tel->lat,"compare lat");

# Switch telescope using MPC observatory code.
$tel->obscode("011");
is( $tel->name, "Wetzikon","construct from obscode" );
my %parallax = $tel->parallax;
is( sprintf("%.9f",$parallax{Par_S}), sprintf("%.9f","0.6791"), "parallax");
is( sprintf("%.4f", $tel->long), "0.1535", "longitude in radians");

# make sure we have limits
%limits = $tel->limits;
is( $limits{type}, "AZEL", "Default limit type");
is( $limits{el}->{min}, 0.0, "Above horizon");

# Override limits
$tel->setlimits( type => "HADEC",
	         ha => { min => 0 },
	         dec => { min => 0 } );
%limits = $tel->limits;
is( $limits{type}, "HADEC", "Override limit type");

# reset obscode and check that limits have reset
$tel->obscode( "011" );
%limits = $tel->limits;
is( $limits{type}, "AZEL", "Default limit type");
is( $limits{el}->{min}, 0.0, "Above horizon");
