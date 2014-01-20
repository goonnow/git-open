use strict;
use warnings;
package Git::Open;

# ABSTRACT: a totally cool way to open repository page, sometime it's hard to remember.

=head1 USAGE

    git open # it will open homepage of your repository

    git open --compare # it will open compare page

    git open --compare master-develop # Open compare page with branch diff

    Tip: -c is a shorthand for --compare

=cut

sub _remote_url {
    my $git_url = `git ls-remote --get-url`;

    $git_url =~ s/\n//;
    $git_url =~ s/:/\//; # Change : to /
    $git_url =~ s/^git@/http:\/\//; # Change protocal to http
    $git_url =~ s/\.git$//; # Remove .git at the end
    return $git_url;
}

sub _current_branch {
    my $current_branch = `git symbolic-ref --short HEAD`;
    return $current_branch;
}

sub url {
    my ( $opts ) = @_;

    my $url = Git::Open::_remote_url();

    if( exists $opts->{compare} ) {
        $url = "$url/compare";

        my $diff = $opts->{compare}->{diff};

        if ( $diff ) {
            $diff =~ s/-/\.\.\./g; # Replace dash(-) to triple dot(...) as github uses
            $url = "$url/$diff";
        }
    }

    return $url;
}

1;
