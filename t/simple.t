
# Simple test for Astro::Telescope
# to test constructor

use strict;
use Test;

BEGIN { plan tests => 1 }

use Astro::Telescope;

my $tel = new Astro::Telescope;

defined $tel ? ok(1) : ok(0);


exit;
