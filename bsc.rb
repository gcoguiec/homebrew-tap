class Bsc < Formula
  desc 'Bluespec Compiler (BSC)'
  homepage 'https://github.com/B-Lang-org/bsc'
  version '2023.01'
  license 'BSD-3-Clause'
  url 'https://github.com/B-Lang-org/bsc.git', tag: '2023.07'
  sha256 '692b22d980523b23e9bda95362808e25ff231d9838715ce8c9d9489a07bce1a8'
  head 'https://github.com/B-Lang-org/bsc.git', branch: 'main'

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
      'MACOSX_DEPLOYMENT_TARGET=14.1'
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
