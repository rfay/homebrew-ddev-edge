class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.16.0-alpha3.tar.gz"
  sha256 "68a1e4f8c3e189d322dfcfa7e3d741ef6c1f4af127a1aedc1d43833fb7348674"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.16.0-alpha3/"
    cellar :any_skip_relocation
    sha256 "c484d8da5f9e5b16a49df9c6129230ac3ea8b53f9e3e64b941b64f91a3ab0d21" => :x86_64_linux
    sha256 "5dd02f9ceb445858247a12833e9af307c12a511429764c3063022d586208b083" => :high_sierra
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
