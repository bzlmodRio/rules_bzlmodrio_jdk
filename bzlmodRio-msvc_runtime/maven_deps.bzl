load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_jar")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def __setup_msvc_deps(mctx):
    maybe(
        http_archive,
        "bazelrio_msvc_runtime",
        url = "https://frcmaven.wpi.edu/artifactory/development-2027/org/wpilib/msvc/runtime/2027.0.0-alpha-4/runtime-2027.0.0-alpha-4-x64.zip",
        sha256 = "b47becf9cfbca25e00fa1d443a5a06d8273a3602aa3f0a0f426f1dcfcdef9061",
        build_file_content = """
exports_files(glob(["*.dll"]))
""",
    )

setup_msvc_deps = module_extension(
    __setup_msvc_deps,
)