class Iceworx < Formula
  desc 'Flasher utility for the iceWerx iCE40 FPGA boards'
  homepage 'https://github.com/gcoguiec/iceworx'
  version '0.3.0'
  license 'BSD 2-Clause'
  url 'https://github.com/gcoguiec/iceworx/releases/download/v0.3.0/iceworx-v0.3.0-aarch64-apple-darwin.zip'
  sha256 '439507a0ae9e46b660e1ad15cb63621a8906b98fe18989b3ad4c5a457b78b685'
  head 'https://github.com/gcoguiec/iceworx.git'

  def install
    bin.install 'iceworx'
  end

  test do
    system "#{bin}/iceworx", '--help'
  end
end
