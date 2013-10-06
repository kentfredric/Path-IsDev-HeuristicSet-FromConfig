use strict;
use warnings;

package Path::IsDev::HeuristicSet::FromConfig;

# ABSTRACT: A Custom Heuristic Set from a configuration file

=head1 SYNOPSIS

    export PATH_ISDEV_DEFAULT_SET="FromConfig";
    # Whee, is_dev() and friends now seriously different everywhere

By default, it will try to read a configuration file in one of the following paths:

    $HOME/.local/share/.path_isdev_heuristicset_fromconfig/config.json
    $HOME/.path_isdev_heuristicset_fromconfig/config.json

Which ever one it is unfortunately dependent on the sort of mood File::HomeDir is in, and whether or not
you have C<xdg-user-dir> in your C<$PATH>

Either way, if such a path does not exist the first time you use this module, it will be created
for you from the default template in the distributions share directory.

Edit it to your liking.

If you mess it up, just delete it, run the code  again, and its back! :D

In fact, its so aggressive at this, I had to put a bit of code in the tests to stop it
creating those directories during tests >_>.

Pester File::UserConfig if you want this logic improved.

=cut

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::FromConfig",
    "interface":"single_class",
    "does":"Path::IsDev::Role::HeuristicSet::Simple"
}

=end MetaPOD::JSON

=cut

use Role::Tiny::With;

with 'Path::IsDev::Role::HeuristicSet::Simple';

require Path::IsDev::HeuristicSet::FromConfig::Loader;

my $loader = Path::IsDev::HeuristicSet::FromConfig::Loader->new();

=method C<heuristics>

Satisfies the role L<< C<HeuristicSet::Simple>|Path::IsDev::Role::HeuristicSet::Simple/heuristics >>

Returns the values in the configuration file in the field C<heuristics>

=cut

sub heuristics {
  return @{ $loader->heuristics() };
}

=method C<negative_heuristics>

Satisfies the role L<< C<HeuristicSet::Simple>|Path::IsDev::Role::HeuristicSet::Simple/negative_heuristics >>

Returns the values in the configuration file in the field C<negative_heuristics>

=cut

sub negative_heuristics {
  return @{ $loader->negative_heuristics() };
}

1;
