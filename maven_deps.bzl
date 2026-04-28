load("@rules_java//toolchains:remote_java_repository.bzl", "remote_java_repository")

def __setup_jdk_dependencies(mctx):
    remote_java_repository(
        name = "roboriojdk_linux",
        prefix = "roboriojdk",
        version = "25",
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        sha256 = "987387933b64b9833846dee373b640440d3e1fd48a04804ec01a6dbf718e8ab8",
        urls = ["https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_x64_linux_hotspot_25.0.2_10.tar.gz"],
        strip_prefix = "jdk-25.0.2+10",
    )

    remote_java_repository(
        name = "roboriojdk_linux_arm64",
        prefix = "roboriojdk",
        version = "25",
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:arm64",
        ],
        sha256 = "a9d73e711d967dc44896d4f430f73a68fd33590dabc29a7f2fb9f593425b854c",
        urls = ["https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_aarch64_linux_hotspot_25.0.2_10.tar.gz"],
        strip_prefix = "jdk-25.0.2+10",
    )

    remote_java_repository(
        name = "roboriojdk_mac",
        prefix = "roboriojdk",
        version = "25",
        target_compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
        sha256 = "7caddeb2d1d06a21487fdf55198349f122ba7b24bfc613b8923a42a133a92dc5",
        urls = ["https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_x64_mac_hotspot_25.0.2_10.tar.gz"],
        strip_prefix = "jdk-25.0.2+10/Contents/Home",
    )

    remote_java_repository(
        name = "roboriojdk_mac_arm64",
        prefix = "roboriojdk",
        version = "25",
        target_compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
        sha256 = "74ff6e892924a49767c35eb61251b1969c03213819d51065d9b8f9e0238c4f97",
        urls = ["https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_aarch64_mac_hotspot_25.0.2_10.tar.gz"],
        strip_prefix = "jdk-25.0.2+10/Contents/Home",
    )

    runtime_files = [
        "concrt140.dll",
        "msvcp140.dll",
        "msvcp140_1.dll",
        "msvcp140_2.dll",
        "msvcp140_atomic_wait.dll",
        "msvcp140_codecvt_ids.dll",
        "vccorlib140.dll",
        "vcruntime140.dll",
        "vcruntime140_1.dll",
        "vcruntime140_threads.dll",
    ]

    runtime_labels = [Label("@msvc_runtime2//:" + f) for f in runtime_files]
    print(runtime_labels)
    win_patch_cmds = ["cp ../msvc_runtime2++setup_msvc_deps+bazelrio_msvc_runtime/" + lbl.name + " bin/" + lbl.name for lbl in runtime_labels]
    for x in win_patch_cmds:
        print(x)

    remote_java_repository(
        name = "roboriojdk_windows",
        prefix = "roboriojdk",
        version = "25",
        target_compatible_with = [
            "@platforms//os:windows",
            # Assume JDK works for any CPU,
        ],
        sha256 = "06ac5f5444a1269dd11d11cbb7ab6ebaecedc60dc1caca82cdb56f29100b7b8c",
        urls = ["https://github.com/adoptium/temurin25-binaries/releases/download/jdk-25.0.2%2B10/OpenJDK25U-jdk_x64_windows_hotspot_25.0.2_10.zip"],
        strip_prefix = "jdk-25.0.2+10",
        patch_cmds = win_patch_cmds
    )

def setup_legacy_setup_jdk_dependencies():
    __setup_jdk_dependencies(None)

    REMOTE_JDK_REPOS = [
        "roboriojdk_linux",
        "roboriojdk_linux_arm64",
        "roboriojdk_mac",
        "roboriojdk_mac_arm64",
        "roboriojdk_windows",
    ]
    [native.register_toolchains("@" + name + "_toolchain_config_repo//:all") for name in REMOTE_JDK_REPOS]

deps = module_extension(
    __setup_jdk_dependencies,
)
