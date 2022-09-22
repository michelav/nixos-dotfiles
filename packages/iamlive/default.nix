{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "iamlive";
  version = "0.49.0";
  src = fetchFromGitHub {
    owner = "iann0036";
    repo = "iamlive";
    rev = "v${version}";
    sha256 = "sha256-qjnLIKOYhRRgjyGXSGdUI2vroNSnbPrjyUf3uQ9wMFM=";
  };
  vendorSha256 = null;
  meta = {
    description =
      "Generate an IAM policy from AWS calls using client-side monitoring (CSM) or embedded proxy";
    homepage = "https://github.com/iann0036/iamlive";
    license = lib.licenses.mit;
  };
}
