class Icestorm < Formula
  desc 'A project to document the Lattice iCE40 FPGA bitstream and internal architecture'
  homepage 'https://github.com/YosysHQ/icestorm'
  version '20220109'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/icestorm/archive/a545498d6fd0a28a006976293917115037d4628c.tar.gz'
  sha256 '58c7087e94383ac7cfeeb93618d08eb62383e0f867ab298f33d9e734ddb60cd4'
  head 'https://github.com/YosysHQ/icestorm.git'

  depends_on 'pkg-config' => :build
  depends_on 'libftdi0'
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
