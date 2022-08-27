
{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, sassc
, gtk3
, inkscape
, optipng
, gtk-engine
, gtk-engine-murrine
, gdk-pixbuf
, librsvg
, python3
}:

stdenv.mkDerivation rec {
  pname = "";
  version = "2021-08-19";

  src = fetchFromGitHub {
    owner = "yad-tahir";
    repo = "whiplash-themes";
    rev = "7f83759868350d5f0c04e14e865a73a9da6687d7";
   # sha256 = "16h03x2m4j4hfwp7pdmw1navcy5q7di38jvigfgf263wajyxbznr";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
    gtk3
    inkscape
    optipng
    python3
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  postPatch = ''
    patchShebangs .
    for file in $(find -name render-\*.sh); do
      substituteInPlace "$file" \
        --replace 'INKSCAPE="/usr/bin/inkscape"' \
                  'INKSCAPE="${inkscape}/bin/inkscape"' \
        --replace 'OPTIPNG="/usr/bin/optipng"' \
                  'OPTIPNG="${optipng}/bin/optipng"'
    done
  '';

  meta = with lib; {
    description = "Whiplash GTK+ Theme";
    homepage = "https://github.com/yad-tahir/whiplash-themes";
    license = with licenses; [ gpl3 lgpl21 cc-by-sa-40 ];
    platforms = platforms.linux;
   # maintainers = with maintainers; [ elyhaka ];
  };
}
