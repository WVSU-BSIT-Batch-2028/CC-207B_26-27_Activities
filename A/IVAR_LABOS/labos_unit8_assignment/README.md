# CICT Org Fair App

**Live site:** https://astreacero.github.io/org-fair/

Releases: every push to `main` is tested, built and published to GitHub Pages
(`.github/workflows/deploy.yml`); every pull request is checked by
`.github/workflows/ci.yml`. Version 1.1.0 (build 2).

To run it, copy `cms.example.json` to `cms.json`, fill it in, then:
`flutter run --dart-define-from-file=cms.json`

---

# CICT Org Fair App (Part 3): Contentful CMS

## CMS used

**Contentful** (hosted headless CMS, free plan).