class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.17.0-alpha4.tar.gz"
  sha256 "7ca91bc52ef58c6796aee9270c351f1146b88b58180b320a6b5243d5d1525af0"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.17.0-alpha4/"
    cellar :any_skip_relocation
    sha256 "fe37573973a0b3ab07d58a1ae0b18aedfbf35dce1b2de0e5baed1fd8445e79df" => :x86_64_linux
    sha256 "f646d26cc77bf0d8c177f80a6c4fa69f99b836e5a6237ca7d1004102c79eadb8" => :high_sierra
    sha256 "474aaed328d8f88d3c7537481ea577800bf8c7220c4a001d3c30fd950b687dc0" => :arm64_big_sur
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

  test do
    system "#{bin}/ddev", "--version"
  end

  def caveats
  <<~EOS
Make sure to do a 'mkcert -install' if you haven't done it before, it may require your sudo password.

ddev requires docker and docker-compose.
Docker installation instructions at https://ddev.readthedocs.io/en/stable/users/docker_installation/
  EOS
  end
end
