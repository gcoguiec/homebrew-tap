class Ecpprog < Formula
  desc 'A basic driver for FTDI based JTAG probes (FT232H, FT2232H, FT4232H), to program Lattice ECP5/Nexus FPGAs'
  homepage 'https://github.com/gcoguiec/ecpprog'
  version '20220808'
  license 'ISC Licence'
  url 'https://github.com/gcoguiec/ecpprog/archive/7285c4b1aa38956b4b55a51c98d54c8e0e6de1d2.tar.gz'
  sha256 'f8cf1e88aaa2cdd95bf2473d7a1d2a081e57f82c2e97eca1be98c18d897a5e15'
  head 'https://github.com/gcoguiec/ecpprog.git'

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
