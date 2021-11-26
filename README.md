# masonx

[![masion_from][actions_badge]][actions_link]  [![pub package][pub_badge]][pub_link] [![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A mason switch tool created by HZ.

you can get a [brick](https://github.**com**/felangel/mason) from `bundle`( json file )

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ # dart test --coverage converage
derry test
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html

derry get_coverage
```

## Running
```sh
masonx bf example/core.json output
```

<!-- [coverage_link]: coverage/report/index.html -->
<!-- [coverage_badge]: coverage_badge.svg -->
[coverage_badge]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[actions_badge]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml/badge.svg
[actions_link]: https://github.com/huang12zheng/masonx/actions/workflows/main.yaml
[pub_badge]:https://img.shields.io/pub/v/masonx.svg
[pub_link]:https://pub.dartlang.org/packages/masonx