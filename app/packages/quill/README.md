# Quill
This is an official subpackage for the super awesome Orion CMS framework. This is not a standalone app you must use as part of the framework.
[Website](http://Orionjs.org) has all the guides and hand holding you need to build simple and complex apps on meteor.

Orion is the first and perhaps the only structurally organized framework for meteor that takes care of security, scaling, support and performance. It is a plug and play solution backed by a core team of seasoned developers. Code examples, tutorial and documentation makes Orionjs the definite framework to use for your next project.

## Installation
```bash
meteor add mquandalle:stylus orionjs:quill
```

## Import and customize the theme
0. Create a theme file `client/styles/main.styl`
0. Import the style
  ```stylus
  @import '.meteor/local/build/programs/web.browser/packages/orionjs_quill/styles/quill'
  ```
0. Adjust your colors and create the style
  ```stylus
  bgColor = white
  textColor = black
  borderRadius = 2px
  quill(bgColor, textColor, borderRadius)
  ```

## FAQ
### Isobuild report a file not found
Restart Meteor.
### Display is weird on browser except Chrome
This package targets Chrome only.

Please PR if you need additional browser support.
