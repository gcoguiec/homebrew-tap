class NextpnrNexus < Formula
  desc 'Portable FPGA place and route toolkit for Lattice Nexus FPGA family'
  homepage 'https://github.com/YosysHQ/nextpnr'
  version '0.3'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/nextpnr/archive/refs/tags/nextpnr-0.3.tar.gz'
  sha256 '6dda678d369a73ca262896b672958eebeb2e6817f60afb411db31abeff191c4a'
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
  depends_on 'prjoxide' if build.without? 'static'
  depends_on 'prjoxide' => :build if build.with? 'static'
  depends_on 'boost' if build.without? 'static'
  depends_on 'boost' => :build if build.with? 'static'
  depends_on 'eigen' if build.without? 'static'
  depends_on 'eigen' => :build if build.with? 'static'
  depends_on 'python' unless build.without? 'python'

  resource 'fpga-interchange-schema' do
    url 'https://github.com/chipsalliance/fpga-interchange-schema/archive/9a48ae4d37b260e5d263287ce84e618b8e2d7f55.tar.gz'
    sha256 'fb2190720b6caf52fd0559476b3e7b6ccf3ecd5c177f0da4e10b6d5d8985a8e5'
  end unless build.head?

  resource 'fpga-interchange-schema' do
    url 'https://github.com/chipsalliance/fpga-interchange-schema/archive/refs/heads/main.tar.gz'
  end if build.head?

  def install
    (buildpath/'3rdparty/fpga-interchange-schema')
      .install(resource('fpga-interchange-schema'))

    args = [
      "-DOXIDE_INSTALL_PREFIX=#{Formula["prjoxide"].opt_prefix}",
      '-DARCH=nexus'
    ]
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
    system "#{bin}/nextpnr-nexus", '-h'
  end
end
