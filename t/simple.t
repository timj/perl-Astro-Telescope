
# Simple test for Astro::Telescope
# to test constructor

use strict;
use Test;

BEGIN { plan tests => 9 }

use Astro::Telescope;

# Test unknown telescope
my $tel = new Astro::Telescope( "blah" );
ok( $tel, undef);

# Now a known telescope
$tel = new Astro::Telescope( "JCMT" );

# Compare and contrast. This all assumes slaObs is not updated.
ok($tel->name, "JCMT");
ok($tel->fullname, "JCMT 15 metre");
ok($tel->lat("s"), "19 49 22.11");
ok($tel->long("s"), "-155 28 37.20");
ok($tel->alt, 4111);

# Change telescope to something wrong
$tel->name("blah");
ok($tel->name, "JCMT");

# To something valid
$tel->name("JODRELL1");
ok($tel->name, "JODRELL1");

# Full list of telescope names
my @list = Astro::Telescope->telNames;
ok(scalar(@list));

exit;
