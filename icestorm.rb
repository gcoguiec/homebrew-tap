class Icestorm < Formula
  desc 'A project to document the Lattice iCE40 FPGA bitstream and internal architecture'
  homepage 'https://github.com/YosysHQ/icestorm'
  version '20230201'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/icestorm/archive/8649e3e0bd0e09429898d2569ef65cc9fd3eafd7.tar.gz'
  sha256 '18ca5d14a037c7315469af1f2b381fdbb562f4e711f9349eb0cbcd3ac7d05bae'
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
