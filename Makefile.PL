
use strict;
use ExtUtils::MakeMaker;
use File::Spec;

# Automatically create Telescope/MPC.pm.
print "Automatically generating MPC lookup table module...\n";


# Locations of input and output files
my $mpc_stub = File::Spec->catfile("tmpl", "MPC.pm.stub");
my $mpc_data = File::Spec->catfile("tmpl", "MPC.dat");
my $mpc_pm   = File::Spec->catfile("Telescope", "MPC.pm");

# Create output directory
if ( !-d "Telescope") {
  mkdir "Telescope"
    or die "Error creating MPC module. Unable to make directory Telescope: $!";
}


# Open the input and output handles
open(my $mpc_stub_fh, $mpc_stub) ||
  die "Unable to open MPC stub file $mpc_stub : $!\n";
open(my $mpc_data_fh, $mpc_data) ||
  die "Unable to open MPC stub file $mpc_data : $!\n";
open(my $mpc_pm_fh, ">$mpc_pm") ||
  die "Unable to open MPC stub file $mpc_pm : $!\n";

print $mpc_pm_fh "# This file has been generated automatically by the\n";
print $mpc_pm_fh "# Astro::Telescope build system. Do not edit directly.\n";
print $mpc_pm_fh "# Edit MPC.pm.stub instead.\n";

while(<$mpc_stub_fh>) {
  print $mpc_pm_fh $_;
}
close $mpc_stub_fh || die "Error closing stub input file: $!";
while(<$mpc_data_fh>) {
  print $mpc_pm_fh $_;
}
close $mpc_data_fh || die "Error closing data input file: $!";
close $mpc_pm_fh   || die "Error closing output module: $!";

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile being created.
WriteMakefile(
        'NAME' => 'Astro::Telescope',
        'VERSION_FROM' => 'Telescope.pm',
        'PREREQ_PM' => {
			'Astro::SLA' => 0.93,
		       },
	clean => { FILES => "$mpc_pm Telescope" },
	($] >= 5.005 ?    ## Add these new keywords supported since 5.005
	 (ABSTRACT_FROM => 'Telescope.pm',
	  AUTHOR     => 'Tim Jenness <t.jenness@jach.hawaii.edu>') : ()),
        'dist'   => {COMPRESS=>'gzip -9f', SUFFIX=>'gz'},
);
