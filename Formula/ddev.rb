class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.16.0-rc2.tar.gz"
  sha256 "f55ea72c2ae99629ddabea011bf5f446e575c180e19409db5b400d6253cebef5"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.16.0-rc2/"
    cellar :any_skip_relocation
    sha256 "87b3b60b00b32c91d9e7eb63d232787d471da7f54035348e515a8f3d8c7aef4d" => :x86_64_linux
    sha256 "c97c8a1fb54730d82e38cfda1b41ea58a6ad109b97725017509ead87c7e54241" => :high_sierra
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
