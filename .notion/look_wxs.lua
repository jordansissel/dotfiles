--
-- Look_cleanviolet for Ion's default drawing engine. 
-- Based on look-clean and look-violetgrey.
-- 

if not gr.select_engine("de") then
    return
end

-- Clear existing styles from memory.
de.reset()

-- Base style
de.defstyle("*", {
    -- Gray background
    highlight_colour = "#eeeeee",
    shadow_colour = "#eeeeee",
    background_colour = "#000000",
    foreground_colour = "#FFFFFF",
    
    shadow_pixels = 1,
    highlight_pixels = 1,
    padding_pixels = 1,
    spacing = 0,
    border_style = "elevated",
    
    font = "suxus",
    text_align = "center",
})


de.defstyle("frame", {
    based_on = "*",
    background_colour = "#000000",
    transparent_background = false,

    de.substyle("active", {
        shadow_colour = "grey",
        highlight_colour = "grey",
        padding_colour = "#AAAA44",
        background_colour = "red",
    }),

})


de.defstyle("frame-tiled", {
    based_on = "frame",
    shadow_pixels = 0,
    highlight_pixels = 0,
    padding_pixels = 1,
    spacing = 0,
})

de.defstyle("tab", {
    based_on = "*",
    font = "suxus",


    
    de.substyle("active-selected", {
        -- Slightly lighter than black
        highlight_colour = "#DDDDFF",
        shadow_colour = "#DDDDFF",
        background_colour = "#7F7F44",
        foreground_colour = "#FFFFFF",
    }),

    de.substyle("inactive-unselected", {
        -- Slightly lighter than black
        highlight_colour = "#DDDDFF",
        shadow_colour = "#DDDDFF",
        background_colour = "#000000",
        foreground_colour = "#DDDDDD",
    }),

    de.substyle("inactive-selected", {
        -- Black tab
        highlight_colour = "#BBBBDD",
        shadow_colour = "#BBBBDD",
        background_colour = "#3A3A16",
        foreground_colour = "#DDDDDD",
    }),
})


de.defstyle("tab-frame", {
    based_on = "tab",

    de.substyle("*-*-*-*-activity", {
        -- Red tab
        highlight_colour = "#eeeeff",
        shadow_colour = "#eeeeff",
        background_colour = "#990000",
        foreground_colour = "#eeeeee",
    }),
})


de.defstyle("tab-frame-tiled", {
    based_on = "tab-frame",
    spacing = 1,
    bar_inside_frame = true,
})


de.defstyle("tab-menuentry", {
    based_on = "tab",
    text_align = "left",
    spacing = 0,
})


de.defstyle("tab-menuentry-big", {
    based_on = "tab-menuentry",
    --font = "-*-helvetica-medium-r-normal-*-17-*-*-*-*-*-*-*",
    padding_pixels = 4,
})


de.defstyle("input", {
    based_on = "*",
    text_align = "left",
    spacing = 1,
    -- Black background
    --highlight_colour = "#
    --shadow_colour = "#eeeeff",
    --background_colour = "#",
    --foreground_colour = "#000000",
    
    de.substyle("*-selection", {
        background_colour = "#777799",
        foreground_colour = "#000000",
    }),

    de.substyle("*-cursor", {
        background_colour = "#000000",
        foreground_colour = "#9999aa",
    }),
})

de.defstyle("stdisp", {
    based_on = "*",
    shadow_pixels = 0,
    highlight_pixels = 0,
    text_align = "left",
    background_colour = "#000000",
    foreground_colour = "grey",
    font="fixed",
})
    
-- Refresh objects' brushes.
gr.refresh()
