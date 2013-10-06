
use strict;
use warnings;

package Path::IsDev::HeuristicSet::FromConfig::Loader;

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
