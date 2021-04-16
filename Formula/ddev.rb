class Ddev < Formula
  desc "Local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/rfay/ddev/archive/v1.17.2.tar.gz"
  sha256 "bbdafeddc4ca8e0f63894a3217667d1993f61ee1b11887edf594e47a38c539bb"

  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/rfay/ddev/releases/download/v1.17.2/"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "187b5007b171ffa89fcc8563db7e35659b12b98e2d0fda8d46c71c83c0c3f62e"
    sha256 cellar: :any_skip_relocation, high_sierra: "b2cf3301fce847fc1fc9ef2bddcce1d045a7ffcd5382246b6e813ba3493eb50f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c43158f531666994e752e627094223d12a50124303ddd2cbea682dbf1f56f5b7"
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
