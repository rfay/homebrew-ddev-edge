class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.17.1.tar.gz"
  sha256 "c4e1d0689ef380eabca3e28d6aafd87f2eeabc2df3f6e7dfc6944db9ed3fc0c8"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.17.1/"
    cellar :any_skip_relocation
    sha256 cellar: :any_skip_relocation, x86_64_linux: "09b0de530c9a729b4588a568300cf8053759799cc3317e0f96f5c6f4004a6225"
    sha256 cellar: :any_skip_relocation, high_sierra: "97e78e11ca89d6f48400ee3e669dbba86d5f84c7ec22da629dbc1a08736e07cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f93699f3f381898f0ffb09d87ff1e93a870ba279e06921df64d5204562cbe9f6"
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
