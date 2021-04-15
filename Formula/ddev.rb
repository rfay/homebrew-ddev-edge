class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.17.1-a3.tar.gz"
  sha256 "3af3d9cef5947223eaf647c812e5f89cdfe967f08e94f78deeac7a5bd43181d8"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.17.1-a3/"
    cellar :any_skip_relocation
    sha256 cellar: :any_skip_relocation, x86_64_linux: "871bcd5256406b5dea4a78232b002ca52318e886af4042d5b5de38cfa660dad4"
    sha256 cellar: :any_skip_relocation, high_sierra: "4b647b6843bbefce16f2ccf958823daebcae2174e82f7603c4ba17acd060c458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65d3e8b7ed79778d206e8c788620366a76c437924d0f9385714125e04313b144"
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
