#!perl
# Simple test for Astro::Telescope
# to test constructor

use strict;
use Test::More tests => 30;

require_ok("Astro::Telescope");

# Test unknown telescope
my $tel = new Astro::Telescope( "blah" );
is( $tel, undef );

# Now a known telescope
$tel = new Astro::Telescope( "JCMT" );

# Compare and contrast. This all assumes slaObs is not updated.
is($tel->name, "JCMT");
is($tel->fullname, "JCMT 15 metre");
is($tel->lat("s"), "19 49 22.11");
is($tel->long("s"), "-155 28 37.20");
is($tel->alt, 4111);
is($tel->obscode, 568);

# Change telescope to something wrong
$tel->name("blah");
is($tel->name, "JCMT");

# To something valid
$tel->name("JODRELL1");
is($tel->name, "JODRELL1");
is($tel->obscode, undef);

# Full list of telescope names
my @list = Astro::Telescope->telNames;
ok(scalar(@list));

# Check limits of JCMT
$tel->name( 'JCMT' );
my %limits = $tel->limits;

is( $limits{type}, "AZEL");
ok(exists $limits{el}{max} );
ok(exists $limits{el}{min} );

# Switch telescope
$tel->name( "UKIRT" );
is( $tel->name, "UKIRT");
is( $tel->fullname, "UK Infra Red Telescope");
is( sprintf("%.9f", $tel->geoc_lat), sprintf("%.9f", "0.343830843") );
is( $tel->geoc_lat("s"), "19 42 0.20");

%limits = $tel->limits;
is( $limits{type}, "HADEC");
ok(exists $limits{ha}{max} );
ok(exists $limits{ha}{min} );
ok(exists $limits{dec}{max} );
ok(exists $limits{dec}{min} );

# test constructor that takes a hash
my $new = new Astro::Telescope( Name => $tel->name,
				Long => $tel->long,
				Lat  => $tel->lat,
				Alt => 0,
			      );
ok($new);

is($new->name, $tel->name);
is($new->long, $tel->long);
is($new->lat,  $tel->lat);

# Switch telescope using MPC observatory code.
$tel->obscode("011");
is( $tel->name, "Wetzikon" );
my %parallax = $tel->parallax;
is( sprintf("%.9f",$parallax{Par_S}), sprintf("%.9f","0.680") );
