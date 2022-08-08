class Prjoxide < Formula
  desc 'A project to document the Lattice Nexus (28nm) devices bitstream and internal architecture'
  homepage 'https://github.com/gatecat/prjoxide'
  version '20220808'
  url 'https://github.com/gatecat/prjoxide/archive/c2186112a678d20c67547cf72f8d43c704b9dad4.tar.gz'
  sha256 'd4509d98d3ab39542b4a06bdf7d0c233a356b77916a9255ae780a84cf54d5303'
  head 'https://github.com/gatecat/prjoxide.git'

  depends_on 'rust' => :build

  resource 'prjoxide-db' do
    url 'https://github.com/gatecat/prjoxide-db/archive/1566e0d8af245c4d52f4c5ec04667e5a4f0f01e2.tar.gz'
    sha256 '2d840947247a91daeb8c058448cb3cd3fe2c0b949ecc8eb5df21b48cc38f37f5'
  end unless build.head?

  resource 'prjoxide-db' do
    url 'https://github.com/gatecat/prjoxide-db/archive/refs/heads/master.tar.gz'
  end if build.head?

  def install
    (buildpath/'database').install resource('prjoxide-db')

    cd 'libprjoxide/prjoxide' do
      system 'cargo', 'install', *std_cargo_args
    end
  end

  test do
    system "#{bin}/prjoxide", '-h'
  end
end
