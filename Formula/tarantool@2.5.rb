class TarantoolAT25 < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/2.5/src/tarantool-2.5.2.0.tar.gz"
  sha256 "f64b8ef772d42017bd938770912b4a1727ce6302087efcd5c7faac9e425d9ac4"
  license "BSD-2-Clause"
  head "https://github.com/tarantool/tarantool.git", branch: "2.5", shallow: false

  bottle do
    cellar :any
    sha256 "10240e8f72bc8c9a2463e22fbc6ea4033b6b775b50419040f6f1491ae91ef0ff" => :catalina
    sha256 "76d89fbaa6d7a4265051ee2acf5bea261b829041b312335047466f4a8c85723c" => :mojave
    sha256 "35f468f277d8b6d4889199c05462d675bc37f09794ef11a8b657ab13db648c95" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "curl-openssl"
  depends_on "icu4c"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "readline"

  # uses_from_macos "curl"
  # uses_from_macos "ncurses"

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path

    # Necessary for luajit to build on macOS Mojave (see luajit formula)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    # Avoid keeping references to Homebrew's clang/clang++ shims
    inreplace "src/trivia/config.h.cmake",
              "#define COMPILER_INFO \"@CMAKE_C_COMPILER@ @CMAKE_CXX_COMPILER@\"",
              "#define COMPILER_INFO \"/usr/bin/clang /usr/bin/clang++\""

    args = std_cmake_args + %W[
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
      -DCMAKE_INSTALL_MANDIR=#{doc}
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_DIST=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}
      -DREADLINE_ROOT=#{Formula["readline"].opt_prefix}
      -DENABLE_BUNDLED_LIBCURL=OFF
      -DCURL_INCLUDE_DIR=#{Formula["curl-openssl"].opt_include}
      -DCURL_LIBRARY=#{Formula["curl-openssl"].opt_lib}/libcurl.dylib
      -DCURSES_NEED_NCURSES=TRUE
      -DCURSES_NCURSES_INCLUDE_PATH=#{Formula["ncurses"].opt_include}
      -DCURSES_NCURSES_LIBRARY=#{Formula["ncurses"].opt_lib}/libncurses.dylib
      -DICONV_INCLUDE_DIR=#{sdk}/usr/include
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def post_install
    local_user = ENV["USER"]
    inreplace etc/"default/tarantool", /(username\s*=).*/, "\\1 '#{local_user}'"

    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~EOS
      box.cfg{}
      local s = box.schema.create_space("test")
      s:create_index("primary")
      local tup = {1, 2, 3, 4}
      s:insert(tup)
      local ret = s:get(tup[1])
      if (ret[3] ~= tup[3]) then
        os.exit(-1)
      end
      os.exit(0)
    EOS
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end
