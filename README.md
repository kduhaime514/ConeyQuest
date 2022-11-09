## Addon Notes:

### Generate Blizzard code
1. Run `open /Applications/World\ of\ Warcraft/_retail_/World\ of\ Warcraft.app --args -console`
2. Open the console in wow with `
3. Type `ExportInterfaceFiles code` then `ExportInterfaceFiles art`
4. They'll be written to `wow/_retail_/BlizzardInterfaceArt` and `wow/_retail_/BlizzardInterfaceCode`

`BlizzardInterfaceCode` is especially important because you can find XML templates there (anything marked as `virtual`) that you can use

### XML nuances

#### "name" attribute
This thing actually creates a global variable that you can reference in code. Here's an example of a weird one:
```
<Texture name="$parentTitleBG" file="Interface\PaperDollInfoFrame\UI-GearManager-Title-Background">
    <Anchors>
        <Anchor point="TOPLEFT" x="8" y="-7"/>
        <Anchor point="BOTTOMRIGHT" relativePoint="TOPRIGHT" x="-8" y="-24"/>
    </Anchors>
</Texture>
```

This actually creates a variable with string concatenation. `$parent` refers to whatever you named your extension of the template, then it just concatenates `TitleBG` to the end of it. For example...

```
MyCustomFrame = CreateFrame("Frame", "MyCustomFrameName", UIParent, "UIPanelDialogTemplate");
```

In the above case, if the template `UIPanelDialogTemplate` had that above Texture, you could access it with the variable `MyCustomFrameNameTitleBG`

### Frame Layers
Frames are drawn on 5 layers, from furthest back to furthest forward, they are:
* BACKGROUND
* BORDER
* ARTWORK
* OVERLAY
* HIGHLIGHT
