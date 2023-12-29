from bazelrio_gentool.deps.sha256_helper import get_hash


def get_toolchain_dependencies():
    class PlatformConfig:
        def __init__(self, repo_os, platforms_os, strip_prefix, suffix):
            self.repo_os = repo_os
            self.platforms_os = platforms_os
            self.strip_prefix = strip_prefix
            self.suffix = suffix

        def get_sha256(self):
            return get_hash(self.get_url(), fail_on_miss=True)

        def get_url(self):
            return f"https://github.com/adoptium/temurin17-binaries/releases/download/jdk-{escaped_version}/OpenJDK17U-jdk_x64_{self.repo_os}_hotspot_{underscore_version}.{self.suffix}"

    class JavaToolchainConfig:
        def __init__(
            self,
            repo_name,
            platforms,
            jdk_version,
            escaped_version,
            underscore_version,
            jre_version,
        ):
            self.repo_name = repo_name
            self.platforms = platforms
            self.jdk_version = jdk_version
            self.escaped_version = escaped_version
            self.underscore_version = underscore_version
            self.jre_version = jre_version
            self.version = jdk_version
            self.sanitized_version = self.version.replace("+", "-")
            self.patch = ""
            self.year = "2024"

    platforms = []

    jdk_version = "17.0.8+7"
    underscore_version = jdk_version.replace("+", "_")
    escaped_version = jdk_version.replace("+", "%2B")

    platforms.append(
        PlatformConfig(
            repo_os="linux",
            platforms_os="linux",
            strip_prefix="jdk-" + jdk_version,
            suffix="tar.gz",
        )
    )
    platforms.append(
        PlatformConfig(
            repo_os="mac",
            platforms_os="macos",
            strip_prefix="jdk-" + jdk_version + "/Contents/Home",
            suffix="tar.gz",
        )
    )
    platforms.append(
        PlatformConfig(
            repo_os="windows",
            platforms_os="windows",
            strip_prefix="jdk-" + jdk_version,
            suffix="zip",
        )
    )

    output = JavaToolchainConfig(
        repo_name="rules_bzlmodrio_jdk",
        platforms=platforms,
        jdk_version=jdk_version,
        escaped_version=escaped_version,
        underscore_version=underscore_version,
        jre_version=17,
    )

    return output
