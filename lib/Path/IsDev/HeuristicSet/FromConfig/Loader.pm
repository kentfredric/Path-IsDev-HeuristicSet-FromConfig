
use strict;
use warnings;

package Path::IsDev::HeuristicSet::FromConfig::Loader;

# ABSTRACT: Configuration loader and decoder for C<::FromConfig>

sub _path {
  require Path::Tiny;
  goto \&Path::Tiny::path;
}

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::HeuristicSet::FromConfig::Loader",
    "interface":"class",
    "inherits":"Class::Tiny::Object"
}

=end MetaPOD::JSON

=cut

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

=attr C<dist>

The name of the C<dist> for C<sharedir> mechanics and C<config> paths.

    Path-IsDev-HeuristicSet-FromConfig

=cut

=attr C<module>

The name of the C<module> for C<sharedir> mechanics and C<config> paths.

    Path::IsDev::HeuristicSet::FromConfig

=cut

=attr C<config_file>

The name of the file relative to the configuration C<dir>

    config.json

=cut

=attr C<config_file_full>

The full path to the C<config> file.

If not specified, combined from C<config> and C<config_file> wrapped in a C<Path::Tiny>

=cut

=attr C<config>

Returns a C<File::UserConfig> object preconfigured with a few things ( namely, C<dist> and C<module> )

=attr C<decoder>

Returns a C<JSON> object to perform decoding with

=attr C<data>

Returns decoded data by slurping C<config_file_full> and throwing it in C<decoder>

=cut

=attr C<heuristics>

Proxy for C<< data->{heuristics} >>

=cut

=attr C<negative_heuristics>

Proxy for C<< data->{negative_heuristics} >>

=cut

1;
