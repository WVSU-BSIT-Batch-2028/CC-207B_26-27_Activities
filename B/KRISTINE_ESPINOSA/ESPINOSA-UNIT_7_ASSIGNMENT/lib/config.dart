import 'package:http/http.dart' as http;

import 'data/cms/contentful_source.dart';
import 'data/cms/sanity_source.dart';
import 'data/cms/strapi_source.dart';
import 'data/event_source.dart';
import 'data/sample_events.dart';

const cmsName = String.fromEnvironment('CMS');
const cmsUrl = String.fromEnvironment('CMS_URL');
const cmsSpace = String.fromEnvironment('CMS_SPACE');
const cmsProject = String.fromEnvironment('CMS_PROJECT');
const cmsDataset = String.fromEnvironment(
  'CMS_DATASET',
  defaultValue: 'production',
);
const cmsToken = String.fromEnvironment('CMS_TOKEN');

EventSource createEventSource(http.Client client) {
  return switch (cmsName) {
    'strapi' => StrapiEventSource(client, baseUrl: cmsUrl, token: cmsToken),
    'contentful' => ContentfulEventSource(
      client,
      spaceId: cmsSpace,
      token: cmsToken,
    ),
    'sanity' => SanityEventSource(
      client,
      projectId: cmsProject,
      dataset: cmsDataset,
      token: cmsToken,
    ),
    _ => SampleEventSource(),
  };
}
