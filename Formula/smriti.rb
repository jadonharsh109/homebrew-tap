class Smriti < Formula
  desc "Fully-offline, Google-Photos-style library for your local photos"
  homepage "https://github.com/jadonharsh109/smriti.photos"
  url "https://github.com/jadonharsh109/smriti.photos/releases/download/v0.1.1/smriti_photos-0.1.1.tar.gz"
  sha256 "4f9b1603677ff5efb03bacef6da449d56b8d5353836e32ed742a8dd033b1cd15"

  depends_on "ffmpeg"
  depends_on "python@3.12"

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
    # plain venv (with pip): deps install as prebuilt wheels from PyPI —
    # onnxruntime & friends must never be compiled here
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "--quiet", "pip"
    ohai "Downloading Python dependencies (~250 MB from PyPI) — this can take a few minutes; " \
         "run with --verbose to watch progress"
    # natives must come as wheels or fail fast — never a silent hour-long source build
    system libexec/"bin/pip", "install", "--no-cache-dir",
           "--only-binary", "onnxruntime,numpy,scipy,scikit-learn,pillow,pillow-heif",
           buildpath
    bin.install_symlink libexec/"bin/smriti"
  end

  def caveats
    <<~EOS
      Start Smriti with:
        smriti                      # serves your library at http://localhost:8000

      One-time extras:
        smriti models               # ~280 MB face models — enables People
        brew services start smriti  # keep it running in the background

      Your library index lives in ~/.smriti (originals are never modified).
    EOS
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
