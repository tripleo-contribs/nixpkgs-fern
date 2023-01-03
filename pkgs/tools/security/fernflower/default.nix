{ lib, stdenv, fetchgit, jre, gradle }:

let
  pname = "fernflower";
  version = "unstable-2022-12-30";
in stdenv.mkDerivation rec {
  inherit pname version;
  
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://github.com/fesh0r/fernflower";
    rev = "25df654fb5cc76d4e05e0c801d44f65c73fcee26";
    hash = "sha256-43srhW4UzyL5HdqfAluvheZJ5CW6W9VimlnOPeI3qns=";
  };
  
  nativeBuildInputs = [ gradle ];

  buildInputs = [ jre ];

  buildPhase = ''
  '';

  installPhase = ''
  '';

  meta = with lib; {
    description = "An analytical decompiler for Java";
    longDescription = "Fernflower is the first actually working analytical decompiler for Java and probably for a high-level programming language in general.";
    homepage = "https://github.com/JetBrains/intellij-community/tree/master/plugins/java-decompiler/engine";
    downloadPage = "https://github.com/fesh0r/fernflower";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
