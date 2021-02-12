class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.17.0-alpha5.tar.gz"
  sha256 "176b721bb1cfe00609173a734abc977ec71f923017ddfdad0366617c501b4c7e"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.17.0-alpha5/"
    cellar :any_skip_relocation
    sha256 "8135916e84783b45245a06379117be7ecc4eb640d03bd3331415b0f63dc4647a" => :x86_64_linux
    sha256 "b0597289ad99640f1e0d8c1655bf27141f14fea2eeb1202d4eb9fab95b0a84db" => :high_sierra
    sha256 "c6c1c6947136da6c1237f23b4d1682cb0e79b1457c5439a41185132b2b36f0f1" => :arm64_big_sur
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
