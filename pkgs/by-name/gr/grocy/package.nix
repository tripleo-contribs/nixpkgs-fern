{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  php,
  yarn,
  fixup-yarn-lock,
  nixosTests,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grocy";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "grocy";
    repo = "grocy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jIlFQFXtxZ/rrPs9iSCn32scXPgi1ed4o8qXKm/WrrQ=";
  };

  vendorHash = "sha256-cKKJFsDoQqiW7qicZi2sZ6Fmymg/4oU45PWJ0NsjjtY=";

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-iym+kdnjkcQtIIe800Q4BYR7/vLl63XT62FtDJnjqkw=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
  ];

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;

  # NOTE: if patches are created from a git checkout, those should be modified
  # with `unix2dos` to make sure those apply here.
  patches = [
    ./0001-Define-configs-with-env-vars.patch
    ./0002-Remove-check-for-config-file-as-it-s-stored-in-etc-g.patch
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --no-progress --non-interactive

    runHook postConfigure
  '';

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/grocy/* $out
    rm -r $out/share
  '';

  passthru.tests = { inherit (nixosTests) grocy; };

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    description = "ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home";
    homepage = "https://grocy.info/";
  };
})
