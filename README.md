# masonx

[![masion_from][actions_badge]][actions_link]  [![pub package][pub_badge]][pub_link]
[![style: analysis][analysis_badge]][analysis_link]

[![License: MIT][license_badge]][license_link]

A mason switch tool created by HZ.

you can get a [brick](https://github.**com**/felangel/mason) from `bundle`( json file )

<!-- [coverage_link]: coverage/report/index.html -->
<!-- [coverage_badge]: coverage_badge.svg -->
[coverage_badge]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[analysis_badge]: https://img.shields.io/badge/style-romantic__analysis-purple
[analysis_link]: https://github.com/RomanticEra/romantic_analysis
[actions_badge]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml/badge.svg
[actions_link]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml
[pub_badge]:https://img.shields.io/pub/v/masonx.svg
[pub_link]:https://pub.dartlang.org/packages/masonx

## Usage
* make brick-template from bundle
```sh
masonx bf example/core.json output
```
* gen all var of brick
```sh
masonx gc bundlePath
```
* patch some variable from brick to a new brick
```sh
masonx patch somebrick output -c config
```
> hint: var in config, can't be as option argument. Example:
> + ban:
> $ masonx patch somebrick output --name xxx

> hint: somebrick is not brickDir,please mason add it first
