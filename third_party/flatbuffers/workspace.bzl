"""Loads the Flatbuffers library, used by TF Lite."""

load("//third_party:repo.bzl", "third_party_http_archive")

def repo():
    third_party_http_archive(
        name = "flatbuffers",
        strip_prefix = "flatbuffers-23.5.8",
        sha256 = "55b75dfa5b6f6173e4abf9c35284a10482ba65db886b39db511eba6c244f1e88",
        urls = [
            "https://github.com/google/flatbuffers/archive/v23.5.8.tar.gz",
            "https://github.com/google/flatbuffers/archive/v23.5.8.tar.gz",
        ],
        build_file = "//third_party/flatbuffers:BUILD.bazel",
        delete = ["build_defs.bzl", "BUILD.bazel"],
        link_files = {
            "//third_party/flatbuffers:build_defs.bzl": "build_defs.bzl",
        },
    )
