class Smriti < Formula
  desc "Fully-offline, Google-Photos-style library for your local photos"
  homepage "https://github.com/jadonharsh109/smriti.photos"
  url "https://github.com/jadonharsh109/smriti.photos/releases/download/v0.1.0/smriti_photos-0.1.0.tar.gz"
  sha256 "df80c7121a320a68ab148b7a1d8435feb4ea2e834904a2630a8cbda007732401"

  depends_on "ffmpeg"
  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    # plain venv (with pip): deps install as prebuilt wheels from PyPI —
    # onnxruntime & friends must never be compiled here
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "--quiet", "pip"
    system libexec/"bin/pip", "install", "--no-cache-dir", buildpath
    bin.install_symlink libexec/"bin/smriti"
  end

  service do
    run [opt_bin/"smriti", "--no-browser"]
    keep_alive true
    log_path var/"log/smriti.log"
    error_log_path var/"log/smriti.log"
  end

  test do
    assert_match "smriti", shell_output("#{bin}/smriti --help")
  end
end
