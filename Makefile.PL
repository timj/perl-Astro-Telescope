
use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile being created.
WriteMakefile(
        'NAME' => 'Astro::Telescope',
        'DISTNAME' => 'Astro-Telescope',
        'VERSION_FROM' => 'Telescope.pm',
        'PREREQ_PM' => {
			Astro::SLA => 0.93,
		       },
        'dist'   => {COMPRESS=>'gzip -9f', SUFFIX=>'gz'},
);
