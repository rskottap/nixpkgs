{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytestCheckHook
, mmry
}:

buildPythonPackage rec {
  pname = "mmry";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notarealdeveloper";
    repo = "mmry";
    rev = "8cdbdaec6f07dd6bfd088c240c2dad02c2fa1c94";
    hash = "sha256-55RySLnw4sgRN0ELR11fjNl6TlFGpOzQYSwM8+cjE0c=";

  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "mmry" ];
  # mmry needs $HOME
  # inside builds $HOME is set to /homeless-shelter which is not writable, so tests fail
  preCheck = ''
    export HOME="$TMPDIR"
  '';
  passthru.tests.pytest = mmry.overridePythonAttrs { doCheck = true; };

  meta = with lib; {
    description = "Unix disk cache for software 2.0";
    homepage    = "https://github.com/notarealdeveloper/mmry";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ rskottap ];
  };
}
