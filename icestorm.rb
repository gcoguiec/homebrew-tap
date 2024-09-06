class Icestorm < Formula
  desc 'A project to document the Lattice iCE40 FPGA bitstream and internal architecture'
  homepage 'https://github.com/YosysHQ/icestorm'
  version '20240624'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/icestorm/archive/738af822905fdcf0466e9dd784b9ae4b0b34987f.tar.gz'
  sha256 'c5384f9168a250448e68319434ca6763096ff5439abfd9d3dd06777f309b0004'
  head 'https://github.com/YosysHQ/icestorm.git'

  depends_on 'pkg-config' => :build
  depends_on 'libftdi'
  depends_on 'python'

  def install
    system 'make', 'install', "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/iceprog", '--help'
    system "#{bin}/icetime", '--help'
    system "#{bin}/icepll", '--help'
    system "#{bin}/icepack", '--help'
  end
end
