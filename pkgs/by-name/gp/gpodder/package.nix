{
  lib,
  fetchFromGitHub,
  gitUpdater,
  adwaita-icon-theme,
  gobject-introspection,
  gtk3,
  intltool,
  python3Packages,
  wrapGAppsHook3,
  xdg-utils,
}:

python3Packages.buildPythonApplication rec {
  pname = "gpodder";
  version = "3.11.5";
  format = "other";

  src = fetchFromGitHub {
    owner = "gpodder";
    repo = "gpodder";
    rev = version;
    hash = "sha256-Hhk9JeHMg+FrekiNXP6Q8loCtst+FHT4EJTnh64VOhc=";
  };

  patches = [
    ./disable-autoupdate.patch
  ];

  postPatch = ''
    sed -i -re 's,^( *gpodder_dir *= *).*,\1"'"$out"'",' bin/gpodder
  '';

  build-system = with python3Packages; [
    setuptools
    build
    installer
    wheel
  ];

  nativeBuildInputs = [
    intltool
    wrapGAppsHook3
    gobject-introspection
    python3Packages.distutils
  ];

  buildInputs = [
    gtk3
    adwaita-icon-theme
  ];

  nativeCheckInputs = with python3Packages; [
    minimock
    pytest
    pytest-httpserver
    pytest-cov-stub
  ];

  doCheck = true;

  propagatedBuildInputs = with python3Packages; [
    feedparser
    dbus-python
    mygpoclient
    requests
    pygobject3
    eyed3
    podcastparser
    html5lib
    mutagen
    yt-dlp # for use by gpodder's builtin "youtube-dl" extension
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "share/applications/gpodder-url-handler.desktop"
    "share/applications/gpodder.desktop"
    "share/dbus-1/services/org.gpodder.service"
  ];

  installCheckPhase = ''
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest --ignore=tests --ignore=src/gpodder/utilwin32ctypes.py --doctest-modules src/gpodder/util.py src/gpodder/jsonconfig.py
    LC_ALL=C PYTHONPATH=src/:$PYTHONPATH pytest tests --ignore=src/gpodder/utilwin32ctypes.py --ignore=src/mygpoclient --cov=gpodder
  '';

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}" ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mic92 ];
  };
}
