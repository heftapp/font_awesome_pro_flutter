# font_awesome_pro_flutter

Builds FontAwesome Pro icons in your flutter project. No repo cloning is needed!

## Setup

Add `font_awesome_pro_flutter: <latest version>` to your `dev_dependencies`. 
It is a builder, so you'll need to set up `build_runner`. Read more [here](https://pub.dev/packages/build_runner).

Then you need to install the fonts you'd like:

```yaml
# pubspec.yaml
  fonts:
    - family: FontAwesomeRegular
      fonts:
        - asset: fonts/fa-regular-400.ttf
    - family: FontAwesomeSolid
      fonts:
        - asset: fonts/fa-solid-900.ttf
    - family: FontAwesomeLight
      fonts:
        - asset: fonts/fa-light-300.ttf
    - family: FontAwesomeThin
      fonts:
        - asset: fonts/fa-thin-100.ttf
    - family: FontAwesomeBrands
      fonts:
        - asset: fonts/fa-brands-400.ttf
```

These can be downloaded at [FontAwesome](https://fontawesome.com/download).

The currently supported version is `6.1.1`.

## Future work

* The generated files are MASSIVE. The next step will be to allow configuring which styles to generate.
* Duotone is NOT yet supported.
