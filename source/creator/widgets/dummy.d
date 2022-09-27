/*
    Copyright © 2020, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/
module creator.widgets.dummy;
import creator.widgets;
import std.math : abs;

/**
    More advanced dummy widget
*/
void incDummy(ImVec2 size = ImVec2(0, 0)) {
    ImVec2 avail = incAvailableSpace();
    if (size.x <= 0) size.x = avail.x - abs(size.x);
    if (size.y <= 0) size.y = avail.y - abs(size.y);
    igDummy(size);
}

/**
    A dummy with a label over it.
*/
void incDummyLabel(string text, ImVec2 area=ImVec2(0, 0)) {
    ImVec2 avail = incAvailableSpace();
    ImVec2 size = area;
    if (size.x <= 0) size.x = avail.x;
    if (size.y <= 0) size.y = avail.y;
    incLabelOver(text, size);
    incDummy(size);
}

/**
    Darkens an area and puts a label over it
*/
void incLabelOver(string text, ImVec2 size = ImVec2(0, 0), bool entireWindow=false) {
    auto window = igGetCurrentWindow();
    auto dlist = igGetWindowDrawList();
    auto style = igGetStyle();
    ImVec2 origin;
    ImVec2 textSize;

    igGetCursorScreenPos(&origin);
    textSize = incMeasureString(text);
    float xPadding = style.FramePadding.x;
    float yPadding = style.FramePadding.y;

    if (entireWindow) { origin = window.ClipRect.Max; }
    if (size.x <= 0) size.x = window.WorkRect.Min.x-origin.x;
    if (size.y <= 0) size.y = window.WorkRect.Min.y-origin.y;

    ImDrawList_AddRectFilled(dlist, origin, ImVec2(origin.x+size.x, origin.y+size.y), igGetColorU32(ImVec4(0, 0, 0, 0.15f)), style.WindowRounding*0.5);
    ImDrawList_AddRectFilled(dlist, 
        ImVec2(
            origin.x+((size.x-(xPadding+textSize.x))*0.5), 
            origin.y+((size.y-(yPadding+textSize.y))*0.5)
        ),
        ImVec2(
            origin.x+((size.x+(xPadding+textSize.x))*0.5), 
            origin.y+((size.y+(yPadding+textSize.y))*0.5)
        ),
        igGetColorU32(ImGuiCol.WindowBg),
        4
    );

    ImDrawList_AddText(dlist, 
        ImVec2(
            origin.x+((size.x-textSize.x)*0.5),
            origin.y+((size.y-textSize.y)*0.5),
        ),
        igGetColorU32(ImGuiCol.Text),
        text.ptr,
        text.ptr+text.length
    );
}

/**
    A same-line spacer
*/
void incSpacer(ImVec2 size) {
    igSameLine(0, 0);
    incDummy(size);
}

/**
    Gets available space
*/
ImVec2 incAvailableSpace() {
    ImVec2 avail;
    igGetContentRegionAvail(&avail);
    return avail;
}

/**
    Measures a string in pixels
*/
ImVec2 incMeasureString(string text) {
    ImVec2 strLen;
    igCalcTextSize(&strLen, text.ptr, text.ptr+text.length);
    return strLen;
}