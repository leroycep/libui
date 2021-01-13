const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("libui-test", "main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    exe.linkLibC();
    exe.addIncludeDir("./");
    exe.linkSystemLibrary("gtk+-3.0");

    exe.addCSourceFiles(common_c_files, &[_][]const u8{});
    if (target.isWindows()) {
        exe.linkSystemLibrary("c++");
        exe.addCSourceFiles(windows_c_files, &[_][]const u8{});
    } else if (target.isLinux()) {
        exe.addCSourceFiles(unix_c_files, &[_][]const u8{});
    }

    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}

const common_c_files = &[_][]const u8{
    "common/attribute.c",
    "common/attrlist.c",
    "common/attrstr.c",
    "common/areaevents.c",
    "common/control.c",
    "common/debug.c",
    "common/matrix.c",
    "common/opentype.c",
    "common/shouldquit.c",
    "common/tablemodel.c",
    "common/tablevalue.c",
    "common/userbugs.c",
    "common/utf.c",
};

const unix_c_files = &[_][]const u8{
    "unix/alloc.c",
    "unix/area.c",
    "unix/attrstr.c",
    "unix/box.c",
    "unix/button.c",
    "unix/cellrendererbutton.c",
    "unix/checkbox.c",
    "unix/child.c",
    "unix/colorbutton.c",
    "unix/combobox.c",
    "unix/control.c",
    "unix/datetimepicker.c",
    "unix/debug.c",
    "unix/draw.c",
    "unix/drawmatrix.c",
    "unix/drawpath.c",
    "unix/drawtext.c",
    "unix/editablecombo.c",
    "unix/entry.c",
    "unix/fontbutton.c",
    "unix/fontmatch.c",
    "unix/form.c",
    "unix/future.c",
    "unix/graphemes.c",
    "unix/grid.c",
    "unix/group.c",
    "unix/image.c",
    "unix/label.c",
    "unix/main.c",
    "unix/menu.c",
    "unix/multilineentry.c",
    "unix/opentype.c",
    "unix/progressbar.c",
    "unix/radiobuttons.c",
    "unix/separator.c",
    "unix/slider.c",
    "unix/spinbox.c",
    "unix/stddialogs.c",
    "unix/tab.c",
    "unix/table.c",
    "unix/tablemodel.c",
    "unix/text.c",
    "unix/util.c",
    "unix/window.c",
};

const windows_libs = &[_][]const u8{
    "user32",
    "kernel32",
    "gdi32",
    "comctl32",
    "uxtheme",
    "msimg32",
    "comdlg32",
    "d2d1",
    "dwrite",
    "ole32",
    "oleaut32",
    "oleacc",
    "uuid",
    "windowscodecs",
};

const windows_c_files = &[_][]const u8{
    "windows/alloc.cpp",
    "windows/area.cpp",
    "windows/areadraw.cpp",
    "windows/areaevents.cpp",
    "windows/areascroll.cpp",
    "windows/areautil.cpp",
    "windows/attrstr.cpp",
    "windows/box.cpp",
    "windows/button.cpp",
    "windows/checkbox.cpp",
    "windows/colorbutton.cpp",
    "windows/colordialog.cpp",
    "windows/combobox.cpp",
    "windows/container.cpp",
    "windows/control.cpp",
    "windows/d2dscratch.cpp",
    "windows/datetimepicker.cpp",
    "windows/debug.cpp",
    "windows/draw.cpp",
    "windows/drawmatrix.cpp",
    "windows/drawpath.cpp",
    "windows/drawtext.cpp",
    "windows/dwrite.cpp",
    "windows/editablecombo.cpp",
    "windows/entry.cpp",
    "windows/events.cpp",
    "windows/fontbutton.cpp",
    "windows/fontdialog.cpp",
    "windows/fontmatch.cpp",
    "windows/form.cpp",
    "windows/graphemes.cpp",
    "windows/grid.cpp",
    "windows/group.cpp",
    "windows/image.cpp",
    "windows/init.cpp",
    "windows/label.cpp",
    "windows/main.cpp",
    "windows/menu.cpp",
    "windows/multilineentry.cpp",
    "windows/opentype.cpp",
    "windows/parent.cpp",
    "windows/progressbar.cpp",
    "windows/radiobuttons.cpp",
    "windows/separator.cpp",
    "windows/sizing.cpp",
    "windows/slider.cpp",
    "windows/spinbox.cpp",
    "windows/stddialogs.cpp",
    "windows/tab.cpp",
    "windows/table.cpp",
    "windows/tabledispinfo.cpp",
    "windows/tabledraw.cpp",
    "windows/tableediting.cpp",
    "windows/tablemetrics.cpp",
    "windows/tabpage.cpp",
    "windows/text.cpp",
    "windows/utf16.cpp",
    "windows/utilwin.cpp",
    "windows/window.cpp",
    "windows/winpublic.cpp",
    "windows/winutil.cpp",
};
