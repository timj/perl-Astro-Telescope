
use ExtUtils::MakeMaker;

# Automatically create Telescope/MPC.pm.
open($mpc_stub_fh, "Telescope/MPC.pm.stub");
open($mpc_dat_fh, "Telescope/MPC.dat");
open($mpc_pm_fh, ">Telescope/MPC.pm");
while(<$mpc_stub_fh>) {
  print $mpc_pm_fh $_;
}
close $mpc_stub_fh;
while(<$mpc_dat_fh>) {
  print $mpc_pm_fh $_;
}
close $mpc_dat_fh;
close $mpc_pm_fh;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile being created.
WriteMakefile(
        'NAME' => 'Astro::Telescope',
        'VERSION_FROM' => 'Telescope.pm',
        'PREREQ_PM' => {
			Astro::SLA => 0.93,
		       },
	($] >= 5.005 ?    ## Add these new keywords supported since 5.005
	 (ABSTRACT_FROM => 'Telescope.pm',
	  AUTHOR     => 'Tim Jenness <t.jenness@jach.hawaii.edu>') : ()),
        'dist'   => {COMPRESS=>'gzip -9f', SUFFIX=>'gz'},
);
