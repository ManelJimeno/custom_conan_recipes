from conan import ConanFile
from conan.tools.files import copy, get, mkdir, rename
from conan.tools.layout import basic_layout
from conan.tools.build import check_min_cppstd

import os

required_conan_version = ">=2.0.5"


class GStreamerCppHelpersConan(ConanFile):
    name = "gstreamercpphelpers"
    description = "Headers to simplify GStreamer usage from C++."
    homepage = "https://github.com/nachogarglez/GStreamerCppHelpers"
    url = "https://github.com/nachogarglez/GStreamerCppHelpers"
    license = "LGPL-3.0"
    topics = ("gstreamer", "c++")
    package_type = "header-library"
    no_copy_source = True
    settings = "os", "arch", "compiler", "build_type"

    def layout(self):
        pass

    def package_id(self):
        del self.info.settings.compiler
        del self.info.settings.build_type

    def validate(self):
        if self.settings.compiler.cppstd:
            check_min_cppstd(self, 17)

    def source(self):
        pass

    def build(self):
        get(self, **self.conan_data["sources"][self.version], strip_root=True)

    def package(self):
        copy(self, pattern="LICENSE", src=self.source_folder, dst=os.path.join(self.package_folder, "licenses"))
        copy(
            self,
            pattern="*.h",
            src=os.path.join(self.build_folder, "GstPtr"),
            dst=os.path.join(self.package_folder, "include"),
        )

    def package_info(self):
        self.cpp_info.bindirs = []
        self.cpp_info.libdirs = []
