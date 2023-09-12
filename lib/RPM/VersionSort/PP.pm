use strict;
use warnings;
package RPM::VersionSort::PP;
use parent 'Exporter';

our @EXPORT = 'rpmvercmp';

=head1 NAME

RPM::VersionSort::PP - RPM version sorting algorithm in pure Perl

=head1 SYNOPSIS

    use RPM::VersionSort::PP;
    rpmvercmp("2.0", "2.0.1");

=head1 DESCRIPTION

RPM uses a version number sorting algorithm for some of its decisions. It's
useful to get at this sorting algoritm for other nefarious purposes if you are
using RPM at your site.

This is a quick-and-dirty pure Perl reimplementation of Daniel Hagerty's
original XS module L<RPM::VersionSort> that wasn't suitable for some
architecture-independent deployment. It's obviously way slower but should be
fine for comapring the occasional version number.

=head1 AUTHOR

Matthias Bethke <matthias@towiski.de>

=cut

sub rpmvercmp {
    my ($v1, $v2) = @_;
    my ($s1, $s2);
    
    while( length($v1) and length($v2) ) {
        # Remove non-alphanumeric prefix (ASCII only)
        s/^[^0-9a-zA-Z]// for $v1, $v2;


        my $isnum;
        # grab first completely alpha or completely numeric segment
        if( $v1 =~ /^[0-9]/ ) {
            ($s1, $v1) = $v1 =~ /^([0-9]*)(.*)/; 
            ($s2, $v2) = $v2 =~ /^([0-9]*)(.*)/; 
            $isnum = 1;
        } else {
            ($s1, $v1) = $v1 =~ /^([a-zA-Z]*)(.*)/; 
            ($s2, $v2) = $v2 =~ /^([a-zA-Z]*)(.*)/; 
        }

        return -1 if !length( $s1 ) or !length( $s2 ); 
        if( $isnum ) {
            # Throw away leading zeroes
            s/^0+// for ($s1, $s2);
            # whichever number has more digits wins
            return 1  if length( $s1 ) > length( $s2 );
            return -1 if length( $s2 ) > length( $s1 );
        }

        # If segments are different, return their comparison
        return $s1 cmp $s2 if $s1 cmp $s2;
    }

    return 1 if length( $v1 );
    return length( $v2 ) ? -1 : 0;
}

1;
