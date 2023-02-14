class Prjtrellis < Formula
  desc 'Open-source flow library for Lattice ECP5/ECP5-5G FPGA family'
  homepage 'https://github.com/YosysHQ/prjtrellis'
  version '1.2.1-dev'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/prjtrellis/archive/b3197851bbd292602f45f51dda3f38d1ca60d23d.tar.gz'
  sha256 '627f7f6dbb56034b407b23a060127f5f58a5d73d685b99f92b113768cfce188d'
  head 'https://github.com/YosysHQ/prjtrellis.git'

  option 'without-python', 'Without python integration'
  option 'without-shared', 'Without libtrellis shared library'
  option 'with-static', 'Create a static build'

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'boost' if build.without? 'static'
  depends_on 'boost' => :build if build.with? 'static'
  depends_on 'python@3.11' if build.with? 'python'
  depends_on 'boost-python3' if build.with? 'python' and build.without? 'static'
  depends_on 'boost-python3' => :build if build.with? 'python' and build.with? 'static'

  resource 'prjtrellis-db' do
    url 'https://github.com/YosysHQ/prjtrellis-db/archive/35d900a94ff0db152679a67bf6e4fbf40ebc34aa.tar.gz'
    sha256 '83dd2975860f94ece1003426add37f5d99eff62d2ba764a14d9a358d9880ecd0'
  end unless build.head?

  resource 'prjtrellis-db' do
    url 'https://github.com/YosysHQ/prjtrellis-db/archive/refs/heads/master.tar.gz'
  end if build.head?

  def install
    (buildpath/'database').install resource('prjtrellis-db')

    args = []

    if build.with? 'python'
      `python3.11-config --includes`.chomp.split.each do |entry|
        include_path = entry[2..]
        args << "-DPYTHON3_INCLUDE_DIR=#{include_path}" if File.directory? include_path
      end
    end

    args << '-DBUILD_PYTHON=OFF' if build.without? 'python'
    args << '-DBUILD_SHARED=OFF' if build.without? 'shared'
    args << '-DSTATIC_BUILD=ON' if build.with? 'static'
    args << "-DCURRENT_GIT_VERSION=#{version}" unless build.head?
    args << "-DCURRENT_GIT_VERSION=#{head.version.commit}" if build.head?

    cd 'libtrellis' do
      system 'cmake', '-GNinja', *std_cmake_args, *args, '.'
      system 'ninja', "-j#{Hardware::CPU.cores}"
      system 'ninja', 'install'
    end
  end

  test do
    system "#{bin}/ecpbram", '-h'
    system "#{bin}/ecpmulti", '-h'
    system "#{bin}/ecppack", '-h'
    system "#{bin}/ecpunpack", '-h'
    system "#{bin}/ecppll", '-h'
  end
end
