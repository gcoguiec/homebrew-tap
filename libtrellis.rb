class Libtrellis < Formula
  desc 'Open-source flow library for Lattice ECP5/ECP5-5G FPGA family'
  homepage 'https://github.com/YosysHQ/prjtrellis'
  version '1.2.1'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.2.1.tar.gz'
  sha256 '561f7881dc6d39c7ac47721e19aed533c230b47a684aa9a0c3dae08cdc3d8dbb'
  head 'https://github.com/YosysHQ/prjtrellis.git'

  option 'without-python', 'Compile with no python support'
  option 'without-shared', 'Without libtrellis shared library'
  option 'with-static', 'Statically compile all binaries'

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'boost' => :build
  depends_on 'python' => :recommended
  depends_on 'boost-python3' => [:build, :recommended]

  resource 'prjtrellis-db' do
    url 'https://github.com/YosysHQ/prjtrellis-db/archive/35d900a94ff0db152679a67bf6e4fbf40ebc34aa.tar.gz'
    sha256 '83dd2975860f94ece1003426add37f5d99eff62d2ba764a14d9a358d9880ecd0'
  end unless build.head?

  resource 'prjtrellis-db' do
    url 'https://github.com/YosysHQ/prjtrellis-db/archive/refs/heads/master.tar.gz'
  end if build.head?

  def install
    (buildpath/'database').install resource('prjtrellis-db')
    args = ['-DBoost_NO_BOOST_CMAKE=ON', "-DCURRENT_GIT_VERSION=#{version}"]
    cd 'libtrellis' do
      system 'cmake', '-GNinja', *std_cmake_args, *args, '.'
      system 'ninja', "-j#{Hardware::CPU.cores}"
      system "ninja", "install"
    end
  end

  test do
    system 'ecpbram', '-h'
    system 'ecpmulti', '-h'
    system 'ecppack', '-h'
    system 'ecpunpack', '-h'
    system 'ecppll', '-h'
  end
end
