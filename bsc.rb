class Bsc < Formula
  desc 'Bluespec Compiler (BSC)'
  homepage 'https://github.com/B-Lang-org/bsc'
  version '2022.01'
  license 'BSD-3-Clause'
  url 'https://github.com/B-Lang-org/bsc.git', tag: '2022.01'
  sha256 'eb7b949e43a20269d2badfe5a21c1e0838a2913c80d6be6eaff7460fd7361462'
  head 'https://github.com/B-Lang-org/bsc.git'

  depends_on 'autoconf' => :build
  depends_on 'pkg-config' => :build
  depends_on 'cabal-install'
  depends_on 'gmp'
  depends_on 'gperf'
  depends_on 'icarus-verilog'

  def install
    system 'cabal', 'update'
    system 'cabal', 'v1-install', 'regex-compat', 'syb', 'old-time', 'split'
    system 'make', 'install-src',
      "-j#{Hardware::CPU.cores}",
      "PREFIX=#{libexec}",
      "GHCJOBS=4",
      'GHCRTSFLAGS=+RTS -M5G -A128m -RTS',
      'MACOSX_DEPLOYMENT_TARGET=12.3'
    bin.write_exec_script "#{libexec}/bin/bsc"
    bin.write_exec_script "#{libexec}/bin/bluetcl"
  end

  def caveats
    <<~EOS
      export BLUESPECDIR="#{libexec}/lib"
    EOS
  end

  test do
    system "#{bin}/bsc", '-v'
    system "#{bin}/bluetcl", '-v'
  end
end
