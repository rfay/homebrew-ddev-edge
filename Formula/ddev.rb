class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.18.0-alpha7.tar.gz"
  sha256 "13f7676bdc896cee49f6800b3a4eb931700012effdad545bf6d223b0295b7002"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.18.0-alpha7/"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f50c1ae179a6e3b91eb071901668a1125f7784071b8a9c1d21c3214634d224d5"
    sha256 cellar: :any_skip_relocation, high_sierra: "06e062ca6696d419a76dbc68ad6e8aad7a5960adf2b13af73a3573656a3eb9a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cb60b8fdc4e35a823a86411a30954e4cfcf4c24672759ed256821aa9f7156a54"
  end
  def install
    system "make", "VERSION=v#{version}", "COMMIT=v#{version}"
    system "mkdir", "-p", "#{bin}"
    if OS.mac?
      system "cp", ".gotmp/bin/darwin_amd64/ddev", "#{bin}/ddev"
      system ".gotmp/bin/darwin_amd64/ddev_gen_autocomplete"
    else
      system "cp", ".gotmp/bin/ddev", "#{bin}/ddev"
      system ".gotmp/bin/ddev_gen_autocomplete"
    end
    bash_completion.install ".gotmp/bin/ddev_bash_completion.sh" => "ddev"
    zsh_completion.install ".gotmp/bin/ddev_zsh_completion.sh" => "ddev"
    fish_completion.install ".gotmp/bin/ddev_fish_completion.sh" => "ddev"
  end

  def caveats
    <<~EOS
            Make sure to do a 'mkcert -install' if you haven't done it before, it may require your sudo password.
      #{"      "}
            ddev requires docker and docker-compose.
            Docker installation instructions at https://ddev.readthedocs.io/en/stable/users/docker_installation/
    EOS
  end

  test do
    system "#{bin}/ddev", "--version"
  end
end
