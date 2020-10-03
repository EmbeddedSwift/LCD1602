# LCD1602

Library for LCD1602 display

## Dependencies

- [MadMachine SDK & CLI](https://github.com/EmbeddedSwift/MadMachine)
- [SwiftIO](https://github.com/EmbeddedSwift/SwiftIO)

## Build & install

To install LCD1602 as a system-wide library just run the following commands:

```sh
git clone https://github.com/EmbeddedSwift/LCD1602
cd LCD1602
make install
```

Alternatively you can build LCD1602 by hand with the help of the `mm` command:

```sh
mm build --name LCD1602 --input . --output ./LCD1602
```

Then you can use the library through the `--import-search-paths` argument or install it as a system lib.

```sh
mm library --install ./LCD1602
```

From now on you can build other MadMachine libraries or executables that depend on LCD1602.


## Pre-built releases

You can download the pre-built LCD1602 library using the [releases](https://github.com/EmbeddedSwift/LCD1602/releases) menu.

