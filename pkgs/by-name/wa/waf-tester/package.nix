{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  waf-tester,
}:

buildGoModule rec {
  pname = "waf-tester";
  version = "0.6.13";

  src = fetchFromGitHub {
    owner = "jreisinger";
    repo = "waf-tester";
    tag = "v${version}";
    hash = "sha256-UPviooQNGRVwf/bTz9ApedJDAGeCvh9iD1HXFOQXPcw=";
  };

  vendorHash = "sha256-HOYHrR1LtVcXMKFHPaA7PYH4Fp9nhqal2oxYTq/i4/8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = waf-tester;
    command = "waf-tester -version";
    version = "waf-tester ${version}, commit none, built at unknown by unknown";
  };

  meta = {
    description = "Tool to test Web Application Firewalls (WAFs)";
    mainProgram = "waf-tester";
    homepage = "https://github.com/jreisinger/waf-tester";
    changelog = "https://github.com/jreisinger/waf-tester/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
