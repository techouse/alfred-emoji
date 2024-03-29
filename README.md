# Alfred Emoji Workflow

![GitHub release](https://img.shields.io/github/release/techouse/alfred-emoji.svg)
![GitHub All Releases](https://img.shields.io/github/downloads/techouse/alfred-emoji/total.svg)
![GitHub](https://img.shields.io/github/license/techouse/alfred-emoji.svg)

This workflow allows you to quickly search for and copy emoji to your clipboard.

<video src="https://user-images.githubusercontent.com/1174328/209026749-ab487a69-40b8-4123-9e42-dbd852b23c36.mp4" type="video/mp4" autoplay muted loop></video>

## Installation

1. [Download the latest version](https://github.com/techouse/alfred-emoji/releases/latest)
2. Install the workflow by double-clicking the `.alfredworkflow` file
3. You can add the workflow to a category, then click "Import" to finish importing. You'll now see the workflow listed in the left sidebar of your Workflows preferences pane.

## Usage

Just type `ej` followed by your search query.

```
ej smile
```

Either press `⌘Y` to Quick Look the result, or press `<enter>` copy it to your clipboard.

### Modifier keys

- <kbd>return</kbd> (↵): Copy the symbol of the selected emoji (e.g. "☕️") directly to your front-most application.
- <kbd>option+return</kbd> (⌥↵): Copy the code of the selected emoji) (e.g. `:coffee:`) to your clipboard.
- <kbd>ctrl+return</kbd> (⌃↵): Copy the hexadecimal HTML Entity of the selected emoji) (e.g. `&#x2615;`) to your clipboard.
- <kbd>shift+return</kbd> (⇧↵): Copy the Python source of the selected emoji) (e.g. `u"\U0002615"`) to your clipboard.
- <kbd>shift+ctrl+return</kbd> (⇧⌃↵): Copy the formal Unicode notation of the selected emoji) (e.g. `U+2615`) to your clipboard.
- <kbd>cmd+return</kbd> (⌘↵): Copy the symbol of the selected emoji (e.g. "☕️") to your clipboard.

### Set skin tone

To change the emoji skin tone of all the emojis that support it, configure the workflow.
Possible values are:

- *no* skin tone 👍,
- *light* skin tone 👍🏻,
- *medium-light* skin tone 👍🏼,
- *medium* skin tone 👍🏽,
- *medium-dark* skin tone 👍🏾,
- *dark* skin tone 👍🏿

### Notes

Kudos to [jsumners/alfred-emoji](https://github.com/jsumners/alfred-emoji) for the initial inspiration.

Emoji index built from [i-Naji/emojis](https://github.com/i-Naji/emojis).

Displayed emoji images from [joypixels/emoji-assets](https://github.com/joypixels/emoji-assets).

Lightning fast search is powered by [Algolia](https://www.algolia.com).
