class Ecpprog < Formula
  desc 'A basic driver for FTDI based JTAG probes (FT232H, FT2232H, FT4232H), to program Lattice ECP5/Nexus FPGAs'
  homepage 'https://github.com/gregdavill/ecpprog'
  version '20220913'
  license 'ISC Licence'
  url 'https://github.com/gregdavill/ecpprog/archive/8af8863855599f4b8ef8f46a336408b1aba60e9d.tar.gz'
  sha256 'b88d49ec086e425e83b27e23dd1f48e4a82ad3bc2618c0c91b0e658d5063498e'
  head 'https://github.com/gregdavill/ecpprog.git'

  depends_on 'libftdi0' => :build
  depends_on 'libusb-compat' => :build

  def install
    cd 'ecpprog' do
      system 'make'
      bin.install 'ecpprog'
    end
  end

  test do
    system "#{bin}/ecpprog"
  end
end
