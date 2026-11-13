# CICT Org Fair

Live site: https://Justin-Ardena.github.io/org-fair/

Find student organizations, view live events from Contentful, and join an org at the CICT Org Fair.

## Run locally

1. Copy `cms.example.json` to `cms.json` and fill in your Contentful Space ID and read-only Content Delivery token:
   ```json
   {
     "CMS": "contentful",
     "CMS_SPACE": "your-space-id",
     "CMS_TOKEN": "your-delivery-token"
   }
   ```
2. Install packages and run:
   ```bash
   flutter pub get
   flutter run --dart-define-from-file=cms.json
   ```
