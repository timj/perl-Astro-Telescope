package Astro::Telescope;

=head1 NAME

Astro::Telescope - object oriented interface to telescope constants

=head1 SYNOPSIS

  use Astro::Telescope;

  $Tel = new Astro::Telescope();
  $Tel = new Astro::Telescope('JCMT');
  $lat  =     $Tel->lat_by_deg();
  $lat  =     $Tel->lat_by_rad();
  $long =     $Tel->long_by_deg();
  $long =     $Tel->long_by_rad();
  $alt  =     $Tel->alt();
  $diameter = $Tel->diameter();

=head1 DESCRIPTION

This class provides the basic Telescope parameters.
For the specified telescope information can be requested on 
telescope position and altitude.

A wrapper around L<Astro::SLA/slaObs>.

=cut


use 5.004;
use Carp;
use strict;
use vars qw/$VERSION/;

$VERSION = undef; # -w protection
$VERSION = '0.11';

# Load for the rad/deg conversions
use Math::Trig;

#load the telescope names
use Astro::SLA;

=head1 EXTERNAL MODULES

  Math::Trig
  Astro::SLA

=cut

=head1 PUBLIC METHODS

These are the methods avaliable in this class:

=over 4

=item new

Create a new instance of Astro::Telescope object.  This method takes
an optional telescope name argument and returns a Telescope object.

  $Tel = new Astro::Telescope;
  $Tel = new Astro::Telescope('UKIRT');

Default telescope is 'JCMT'.

=cut


sub new {

  my $proto = shift;
  my $class = ref($proto) || $proto;

  my $Telescope = {};  # Anon hash

  $Telescope->{LAT} = undef;
  $Telescope->{LONG} = undef;
  $Telescope->{ALT} = undef;
  $Telescope->{DIAMETER} = undef;
  $Telescope->{TEL_LIST} = {};
  $Telescope->{CURRENT} = 'JCMT';
  $Telescope->{CURRENT} = shift if @_;
  

  my $i = 1;
  my $name2 = '';
  while ($name2 ne '?') {
    my @stats;
    my ($name);
    my ($w, $p, $h);
    &slaObs($i, $name, $name2, $w, $p, $h);
    $w *=-1;
    @stats = ($p, $w, $h);
    $Telescope->{TEL_LIST}->{$name} = \@stats if ($name2 ne '?');
    $i++;
  }

  bless($Telescope, $class);

  return $Telescope;
}

=item name

Returns and sets the current telescope name

  $name = $Tel->name();
  $Tel->name('JCMT');

=cut

sub name {
  my $self = shift;
  $self->{CURRENT} = shift if @_;
  return $self->{CURRENT};
}

=item telNames

Returns a sorted list of all the telescope names avaliable.

  @tel = $Tel->telNames();

=cut

sub telNames {
  my $self = shift;
  return (sort keys %{$self->{TEL_LIST}}); 
}

=item lat_by deg

Retrieves the latitude of the telescope in degrees.

  $lat = $Tel->lat_by_deg();

=cut

sub lat_by_deg {
  my $self = shift;
  my $lat = $self->{TEL_LIST}->{$self->name()}[0];
  return rad2deg($lat);
}

=item lat_by_rad

Retrieves the latitude of the telescope in radians.

  $lat = $Tel->lat_by_rad();

=cut

sub lat_by_rad {
  my $self = shift;
  my $lat = $self->{TEL_LIST}->{$self->name()}[0];
  return $lat;
}

=item long_by_deg

Retrieves the longitude of the telescope in degrees.

  $long = $Tel->long_by_deg();

=cut

sub long_by_deg {
  my $self = shift;
  my $long = $self->{TEL_LIST}->{$self->name()}[1];
  return rad2deg($long);
}

=item long_by_rad

Retrieves the longitude of the telescope in radians.

  $long = $Tel->long_by_rad();

=cut

sub long_by_rad {
  my $self = shift;
  my $long = $self->{TEL_LIST}->{$self->name()}[1];
  return $long;
}

=item alt

Retrieves the altitude of the telescope in meters.

  $alt = $Tel->alt();

=cut

sub alt {
  my $self = shift;
  my $alt = $self->{TEL_LIST}->{$self->name()}[2];
  return $alt;
}

=item diameter

Retrieves the diameter of the telescope dish in meters.  Not
implemented yet.

  $diameter = $Tel->diameter();

=cut

sub diameter {
  my $self = shift;
  return $self->{DIAMETER};
}

=back

=head1 SEE ALSO

L<Astro::SLA>,
L<Astro::Instrument::SCUBA::Array>

=head1 AUTHOR

Casey Best, with help from Tim Jenness.

=head1 COPYRIGHT

Copyright (C) 1998-2000 Particle Physics and Astronomy Research Council.
All Rights Reserved.

=cut

1;
