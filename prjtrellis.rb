class Prjtrellis < Formula
  desc 'Open-source flow library for Lattice ECP5/ECP5-5G FPGA family'
  homepage 'https://github.com/YosysHQ/prjtrellis'
  version '1.4'
  license 'ISC Licence'
  url 'https://github.com/YosysHQ/prjtrellis/archive/refs/tags/1.4.tar.gz'
  sha256 '46fe9d98676953e0cccf1d6332755d217a0861e420f1a12dabfda74d81ccc147'
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
    url 'https://github.com/YosysHQ/prjtrellis/releases/download/1.4/prjtrellis-db-1.4.zip'
    sha256 '4f8a8a5344f85c628fb3ba3862476058c80bcb8ffb3604c5cca84fede11ff9f0'
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
