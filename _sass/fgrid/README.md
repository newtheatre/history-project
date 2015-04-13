# fGrid · Sass Responsive Grid System
[![Build Status](https://travis-ci.org/fullaf/fGrid.svg?branch=master)](https://travis-ci.org/fullaf/fGrid) [![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/fullaf/fgrid?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

fGrid is a responsive and customisable grid system for Sass styled websites. It's built to be flexible and small and is suitable for a wide range of projects.

Please Note: We're currently specifying and building fGrid, docs are sparse and there's probably some nasty bugs. If you spot issues please report them!

See http://fgrid.fullaf.com for more details.

## Dependencies
Some of the fancy bits of fGrid need [Bourbon](http://bourbon.io/), and frankly if you're using fGrid you should use Bourbon, it's awesome!

Ensure Bourbon is included in your Sass files before fGrid and everything should work.

## Usage

The easiest way to get fGrid is with [Bower](http://bower.io/), simply run `bower install fgrid` in your project directory and add `@import "bower_components/fgrid/fgrid"` below your bourbon include line.

Importing Bourbon is up to you. If you've installed fGrid using Bower putting this line above the fGrid import line will do the trick: `@import "bower_components/bourbon/dist/bourbon"`

So now your main Sass file looks like:

```sass
@import "bower_components/bourbon/dist/bourbon"
@import "bower_components/fgrid/fgrid"

# All your styling below here
```

## Testing

fGrid testing comprises installing dependencies and compiling the project to ensure building is successful. We use Travis for this.

## Default Behaviour

The left and right padding of an fGrid page and the grid gutter sizes is specified as a setting for each breakpoint. See `_settings.sass`.

### Border-Box

We use the border-box box model when we build sites, so fGrid has this set on all elements (See `core/_border_box.sass`).

The border-box model (see [this CSS Tricks article](http://css-tricks.com/box-sizing/)) changes the default behaviour of padding applied to elements.

In a nutshell in the default **context-box** model the rendered width of an element is the sum of the defined width, the width of the elements padding and the width of the elements borders. This applies in the same way to the height. This means if you want to increase the padding on an element you have to recalculate the padding and borders.

If this sounds silly, lets propose the **border-box** model. The defined width will be the rendered width. Padding and borders will compress the content inside this defined width.

Consider the following:

```sass
width: 200px
border: 1px solid
padding: 20px
```

With the context-box model the width of an element with the above styles will have a rendered width of `200 + 1*2 + 20*2 = 242px`. With border-box the width will be **200px**, the padding and border will happen inside this width. Much better!

**border-box** is [universally supported](http://caniuse.com/#search=border-box) on modern browsers.

### Breakpoint Transitions

When a fGrid webpage is resized and a breakpoint is reached the changes will transist. Settings `$transition-enable` and `$transition-option` allow turning off this behaviour or modification of the transition.

## Documentation

Examples given will be in SASS, SCSS may be useful to add later. Converting to SCSS essentially means adding curly braces to selectors and semicolons at the end of lines.

### Introduction

The two main components of fGrid are the grid system and the responsive mixins. Bits we find useful when building fGrid powered sites are likely to be included as well.

fGrid can be customised by editing the `_settings.sass` file.

### Basics of the grid system

By default fGrid implements a 12 column grid system. You can use the class `grid-n` where n is the number of columns. Each row is cleared and given padding by using `grid-row`, finally the grid system is sized on the page by being inside `grid-wrap`.

#### Example

```html
<div class="grid-wrap">
  <div class="grid-row demo-grid">
    <div class="grid-3">
      <div class="demo-inner">
        .grid-3
      </div>
    </div>
    <div class="grid-3">
      <div class="demo-inner">
        .grid-3
      </div>
    </div>
    <div class="grid-6">
      <div class="demo-inner">
        .grid-6
      </div>
    </div>
  </div>
</div>
```

### Grid Mixins

While using the built-in classes will work, it's not semantic as it dirties your code with meaningless classes. Instead it is recommended to use the grid mixins.

```sass
header, div.wrapper, footer
    @include grid-wrap

div.row
    @include grid-row

article
    # Emulate .grid-8
    @include grid-x-col(8)

aside
    # Emulate .grid-4
    @include grid-x-col(4)

div.weird-grid
    # We also can do a grid element using an arbritary percentage
    @include grid-x-percent(43.7%)

```

### Responsive Mixins

fGrid defines six responsive breakpoints:

- `mob-port` Mobile portrait (320px)
- `mob-land` Mobile landscape (480px)
- `tab-port` Tablet portrait (768px)
- `tab-land` Tablet landscape (1024px)
- `med-desk` Medium desktop (1200px)
- `widescreen` Widescreen desktop (1490px)

The mobile and tablet breakpoints by default have no restriction on device they will activate on small desktop as for the enviroment this will likely give the best experience.

Three mixins are available for using these breakpoints:

- `@include respond-up(<BREAKPOINT>)` Will match this size and above
- `@include respond-down(<BREAKPOINT>)` Will match this size and below
- `@include respond-to(<BREAKPOINT>)` Will match this size only

If you are following a mobile first methodology you'll probably only want to use `respond-down` when adding mobile only styling.

#### Example
The following will give a multi-line nav on mobile and single-line on tab-port and above. When mob-land only we increase the font-size.

```sass
header
    li
        font-size: 16px
        @include respond-to(mob-land)
            font-size: 20px
        @include respond-up(tab-port)
            display: inline-block
```

### Retina Detection

Devices that have a minimum pixel ratio of 2, i.e. mobile high res retina screens can be selected with `@include respond-to(retina)`. This selector only works with respond-to and not -up and -down.

#### Example
The following element is given a 500px wide background, when on a retina device a 1000px background is given and scaled to half size to give a high-res background.

```sass
element
    background: url('500px-wide.png')
    @include respond-to(retina)
      background: url('1000px-wide.png')
      background-size: 500px auto
```
