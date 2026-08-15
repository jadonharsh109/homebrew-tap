class Smriti < Formula
  include Language::Python::Virtualenv

  desc "Fully-offline, Google-Photos-style library for your local photos"
  homepage "https://github.com/jadonharsh109/smriti.photos"
  url "https://github.com/jadonharsh109/smriti.photos/releases/download/v0.1.0/smriti_photos-0.1.0.tar.gz"
  sha256 "df80c7121a320a68ab148b7a1d8435feb4ea2e834904a2630a8cbda007732401"

  depends_on "ffmpeg"
  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
    # deps are prebuilt wheels from PyPI (onnxruntime & friends) — never compiled here
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
