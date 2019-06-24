class Ddev < Formula
  desc "ddev: a local development environment management system"
  homepage "https://ddev.readthedocs.io/en/stable/"
  url "https://github.com/drud/ddev/archive/v1.9.0-rc1.tar.gz"
  sha256 "d014f2d8841e284855b346be1ee48d4fd156befe53ec809795baf195cb8ce5d5"

  # depends_on "docker" => :run
  # depends_on "docker-compose" => :run
  depends_on "docker" => :build
  depends_on "go" => :build
  depends_on "mkcert" => :run
  depends_on "nss" => :run

  bottle do
    root_url "https://github.com/drud/ddev/releases/download/v1.9.0-rc1/"
    cellar :any_skip_relocation
    sha256 "d6d40f98f32329609bc688b119ab34d94a1f9d6700532d525a8b489577907f36" => :x86_64_linux
    sha256 "dd7e655e6b560b01ac378b39ed6c6ffaba5f883b02c2d2757ea5f42b4daf0304" => :sierra
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
PLEASE MAKE SURE to do `mkcert -install`, which may require your sudo password.

ddev requires docker and docker-compose.
Docker installation instructions at https://ddev.readthedocs.io/en/stable/users/docker_installation/
  EOS
  end

end


