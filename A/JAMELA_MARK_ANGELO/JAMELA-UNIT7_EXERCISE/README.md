# jamela_unit7_exercise

CC 207B Unit 7 Exercise
Mark Angelo A. Jamela, BSIT 3-A

## Configure API keys

Edit `env.json` in the project root and replace the placeholder values:

- `CONTENTFUL_SPACE_ID`: your Contentful space ID
- `CONTENTFUL_ENVIRONMENT`: your Contentful environment ID (usually `master`)
- `CONTENTFUL_DELIVERY_TOKEN`: your Content Delivery API (CDA) token
- `OMDB_KEY`: your OMDb API key

`env.json` is ignored by Git so your local values are not committed. Do not put
a Contentful Management API token here. Dart defines are included in the
compiled app, so this is convenient for a class project but does not keep keys
secret from someone who obtains the app.

## Run

From this project folder:

```powershell
flutter pub get
flutter run --dart-define-from-file=env.json
```

You can optionally add a device selector, for example:

```powershell
flutter run -d chrome --dart-define-from-file=env.json
```
