const std = @import("std");
const c = @cImport({
    @cInclude("ui.h");
});

var e: *c.uiMultilineEntry = undefined;

pub fn main() void {
    var o: c.uiInitOptions = std.mem.zeroes(c.uiInitOptions);
    var w: *c.uiWindow = undefined;
    var b: *c.uiBox = undefined;
    var btn: *c.uiButton = undefined;

    if (c.uiInit(&o) != null) {
        return;
    }

    w = c.uiNewWindow("Hello", 320, 240, 0).?;
    c.uiWindowSetMargined(w, 1);

    b = c.uiNewVerticalBox().?;
    c.uiBoxSetPadded(b, 1);
    c.uiWindowSetChild(w, @ptrCast(*c.uiControl, @alignCast(8, b)));

    e = c.uiNewMultilineEntry().?;
    c.uiMultilineEntrySetReadOnly(e, 1);

    btn = c.uiNewButton("Say Something").?;
    c.uiButtonOnClicked(btn, saySomething, null);
    c.uiBoxAppend(b, @ptrCast(*c.uiControl, @alignCast(8, btn)), 0);

    c.uiBoxAppend(b, @ptrCast(*c.uiControl, @alignCast(8, e)), 1);

    c.uiTimer(1000, sayTime, null);

    c.uiWindowOnClosing(w, onClosing, null);
    c.uiControlShow(@ptrCast(*c.uiControl, @alignCast(8, w)));
    c.uiMain();
}

fn saySomething(b: ?*c.uiButton, data: ?*c_void) callconv(.C) void {
    c.uiMultilineEntryAppend(e, "Saying something\n");
}

fn sayTime(data: ?*c_void) callconv(.C) c_int {
    const time = std.time.timestamp();
    var buf: [1000]u8 = undefined;
    const time_string = std.fmt.bufPrint(&buf, "time: {}\n\x00", .{time}) catch unreachable;
    c.uiMultilineEntryAppend(e, time_string.ptr);
    return 1;
}

fn onClosing(w: ?*c.uiWindow, data: ?*c_void) callconv(.C) c_int {
    c.uiQuit();
    return 1;
}
