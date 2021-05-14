class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.18.0-a5.tar.gz"
  sha256 "038f9f43db95be5d89c3f80b72d5d152f748ed5d0a5b06f80fba1c7dbd697f9b"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.18.0-a5/"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f1d11681c89bc5dbea0c882963f3c6d8694d0a020acf86e338f6986d38e6543b"
    sha256 cellar: :any_skip_relocation, high_sierra: "c8189e66c48686ed5989a42c7b13a8b7a7625d23c854ca45cad631d638b589d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8494134648ee42ef70daccacedf0178c27fab703489961d755758c2c4f27f81d"
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
