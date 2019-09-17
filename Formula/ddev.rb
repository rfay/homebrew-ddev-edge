class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.11.0-rc1.tar.gz"
  sha256 "231980712bc37f9d57b91cf6a783072bd3ffcbab214e6fbcf360ee415f514ab1"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.11.0-rc1/"
    cellar :any_skip_relocation
    sha256 "70f79ad87cb0d1698890275ffa69652a6d5435d9e61eb569ca63473000531da2" => :x86_64_linux
    sha256 "294f9cbab33e793f49ddca9c8e4c7e903e0ff865028a54ba5d1ac0125302b3ec" => :sierra
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
  end

  test do
    system "#{bin}/ddev", "version"
  end

  def caveats
  <<~EOS
Make sure to do a `mkcert -install` if you haven't done it before, it may require your sudo password.

ddev requires docker and docker-compose.
Docker installation instructions at https://ddev.readthedocs.io/en/stable/users/docker_installation/
  EOS
  end

end


