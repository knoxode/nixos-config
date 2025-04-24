{ stdenv, fetchgit }:

let
  gradle2nix = import (fetchTarball "https://github.com/tadfisher/gradle2nix/archive/master.tar.gz") {};
  nextflow_ls_src = fetchGit {
    url = "https://github.com/nextflow-io/language-server";
    ref = "refs/tags/v24.10.3";
  };
in

gradle2nix.passthru.buildGradlePackage {
  pname = "nextflow_ls";
  version = "24.10.3";
  src = nextflow_ls_src;
  lockFile = ./gradle.lock;
  gradleInstallFlags = [ "installDist" ];
}

