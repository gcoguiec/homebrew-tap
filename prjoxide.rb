class Prjoxide < Formula
  desc 'A project to document the Lattice Nexus (28nm) devices bitstream and internal architecture'
  homepage 'https://github.com/gatecat/prjoxide'
  version '20230831'
  license 'ISC Licence'
  url 'https://github.com/gatecat/prjoxide/archive/30712ff988a3ea7700fa11b87ae2d77e55c7c468.tar.gz'
  sha256 '657c48fa0408ac5bc80d2da8e85a560dfef48eac3f0469654ca46a4c2a925736'
  head 'https://github.com/gatecat/prjoxide.git'

  depends_on 'rust' => :build

  resource 'prjoxide-db' do
    url 'https://github.com/gatecat/prjoxide-db/archive/dff1db406022251c2e6fa0969a807db4bd610a0a.tar.gz'
    sha256 '43ba913c0333a1048e52997aec29d6258f3a60fa486fc731fba0f3e168671b7b'
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
