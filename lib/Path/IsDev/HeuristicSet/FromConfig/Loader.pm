
use strict;
use warnings;

package Path::IsDev::HeuristicSet::FromConfig::Loader;
BEGIN {
  $Path::IsDev::HeuristicSet::FromConfig::Loader::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::HeuristicSet::FromConfig::Loader::VERSION = '0.1.0';
}

sub _path {
  require Path::Tiny;
  goto \&Path::Tiny::path;
}


use Class::Tiny {
  dist             => sub { 'Path-IsDev-HeuristicSet-FromConfig' },
  module           => sub { 'Path::IsDev::HeuristicSet::FromConfig' },
  config_file      => sub { 'config.json' },
  config_file_full => sub { _path( $_[0]->config->configdir )->child( $_[0]->config_file ) },
  config           => sub {
    require File::UserConfig;
    return File::UserConfig->new(
      dist   => $_[0]->dist,
      module => $_[0]->module,
    );
  },
  decoder => sub {
    require JSON;
    return JSON->new();
  },
  data => sub {
    $_[0]->decoder->decode( $_[0]->config_file_full->slurp_utf8 );
  },
  heuristics => sub {
    return $_[0]->data->{heuristics} || [];
  },
  negative_heuristics => sub {
    return $_[0]->data->{negative_heuristics} || [];
  },
};

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::HeuristicSet::FromConfig::Loader

=head1 VERSION

version 0.1.0

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::FromConfig::Loader",
    "interface":"class",
    "inherits":"Class::Tiny::Object"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
