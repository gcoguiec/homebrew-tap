class NextpnrIce40 < Formula
  desc 'Portable FPGA place and route toolkit for Lattice iCE40 LP/HX FPGA family'
  homepage 'https://github.com/YosysHQ/nextpnr'
  version '0.5'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.5.tar.gz'
  sha256 '2e3485753123f1505351a37adec37ce47a3a96d3f67bbcaf59ec390c8ffc1cdd'
  head 'https://github.com/YosysHQ/nextpnr.git'

  option 'without-python', 'Without python integration'
  option 'without-heap', 'Without HeAP analytic placer'
  option 'with-openmp', 'Use OpenMP to accelerate analytic placer'
  option 'with-static', 'Create a static build'
  option 'with-chipdb', 'Create build with pre-built chipdb binaries'
  option 'with-profiler', 'Link against libprofiler'
  option 'without-ipo', 'Compile nextpnr without IPO'

  depends_on 'cmake' => :build
  depends_on 'ninja' => :build
  depends_on 'boost' if build.without? 'static'
  depends_on 'boost' => :build if build.with? 'static'
  depends_on 'eigen' if build.without? 'static'
  depends_on 'eigen' => :build if build.with? 'static'
  depends_on 'python@3.11' unless build.without? 'python'
  depends_on 'icestorm'

  resource 'fpga-interchange-schema' do
    url 'https://github.com/chipsalliance/fpga-interchange-schema/archive/c985b4648e66414b250261c1ba4cbe45a2971b1c.tar.gz'
    sha256 'c1c7ef5a5d38d740b97971d91a25d1099c58cef007e654b4fbceaa1538f757bf'
  end unless build.head?

  resource 'fpga-interchange-schema' do
    url 'https://github.com/chipsalliance/fpga-interchange-schema/archive/refs/heads/main.tar.gz'
  end if build.head?

  def install
    (buildpath/'3rdparty/fpga-interchange-schema')
      .install(resource('fpga-interchange-schema'))

    args = [
      "-DICESTORM_INSTALL_PREFIX=#{Formula["icestorm"].opt_prefix}",
      '-DARCH=ice40'
    ]

    if build.with? 'python'
      `python3.11-config --includes`.chomp.split.each do |entry|
        include_path = entry[2..]
        args << "-DPYTHON3_INCLUDE_DIR=#{include_path}" if File.directory? include_path
      end
    end

    args << '-DBUILD_PYTHON=OFF' if build.without? 'python'
    args << '-DBUILD_HEAP=OFF' if build.without? 'heap'
    args << '-DUSE_OPENMP=ON' if build.with? 'openmp'
    args << '-DSTATIC_BUILD=ON' if build.with? 'static'
    args << '-DEXTERNAL_CHIPDB=ON' if build.with? 'chipdb'
    args << '-DPROFILER=ON' if build.with? 'profiler'
    args << '-DUSE_IPO=ON' if build.with? 'ipo'
    args << "-DCURRENT_GIT_VERSION=#{version}" unless build.head?
    args << "-DCURRENT_GIT_VERSION=#{head.version.commit}" if build.head?

    system 'cmake', '-GNinja', *std_cmake_args, *args, '.'
    system 'ninja', "-j#{Hardware::CPU.cores}"
    system 'ninja', 'install'
  end

  test do
    system "#{bin}/nextpnr-ice40", '-h'
  end
end
