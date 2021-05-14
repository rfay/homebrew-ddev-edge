class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.18.0-a6.tar.gz"
  sha256 "7208c3b45b3f4470ad327bccdcb43e824fd452c3b0b3463a409035f4da9fe9fd"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.18.0-a6/"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8573679e3c50b23ea8ab2549edcae94495aaf66e2b4b7a07add7781edbf8934e"
    sha256 cellar: :any_skip_relocation, high_sierra: "2b74535740ebde27b4a9da2a686caf76120177bb01e59de9b5969abc208f599a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f39e6e64754a5748e4e4cebd9b444d64fd90ee3f774d179d4d58a3045628a051"
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
