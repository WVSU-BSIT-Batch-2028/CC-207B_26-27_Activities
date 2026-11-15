$ErrorActionPreference = 'Stop'

$mainPath = Join-Path $PSScriptRoot 'lib\main.dart'
if (-not (Test-Path -LiteralPath $mainPath)) {
    Write-Host 'Could not find lib\main.dart.' -ForegroundColor Red
    Write-Host 'Copy both fix files beside pubspec.yaml in tacluyan_unit7_exercise.'
    exit 1
}

$content = [System.IO.File]::ReadAllText($mainPath)

$moviesStartMarker = 'class _MoviesTabState extends State<MoviesTab> {'
$coverStartMarker = 'class _CoverThumbnail extends StatelessWidget {'
$moviesStart = $content.IndexOf($moviesStartMarker, [System.StringComparison]::Ordinal)
if ($moviesStart -lt 0) {
    Write-Host 'Could not find the expected Movies search code in lib\main.dart.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}
$coverStart = $content.IndexOf($coverStartMarker, $moviesStart, [System.StringComparison]::Ordinal)
if ($coverStart -lt 0) {
    Write-Host 'Could not find the cover widget after Movies search code.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}

$moviesReplacement = @'
class _MoviesTabState extends State<MoviesTab> {
  final OmdbApi _api = const OmdbApi(omdbKey);
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Future<List<Movie>>? _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChange);
  }

  void _handleSearchChange() {
    _debounce?.cancel();
    final query = _searchController.text.trim();

    setState(() {
      _query = query;
      _future = null;
    });

    if (query.length < 3 || omdbKey.trim().isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        _future = _api.search(query);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _copyId(Movie movie) {
    Clipboard.setData(ClipboardData(text: movie.imdbId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${movie.imdbId}')),
    );
  }

  Widget _movieResults() {
    if (omdbKey.trim().isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'To search movies, add your free OMDb API key to omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_future == null) {
      return Center(
        child: Text(
          _query.length < 3
              ? 'Enter at least 3 letters to search for movies.'
              : 'Waiting to search...',
        ),
      );
    }

    return FutureBuilder<List<Movie>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('${snapshot.error}', textAlign: TextAlign.center),
            ),
          );
        }

        final movies = snapshot.data ?? const <Movie>[];
        if (movies.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }

        return ListView.separated(
          itemCount: movies.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final movie = movies[index];
            return ListTile(
              leading: _CoverThumbnail(
                imageUrl: movie.poster,
                fallback: Icons.movie,
              ),
              title: Text(
                movie.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(movie.year),
              trailing: IconButton(
                tooltip: 'Copy IMDb ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(movie),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search movies',
              hintText: 'Enter at least 3 letters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _movieResults()),
      ],
    );
  }
}
'@

$omdbStartMarker = 'class OmdbApi {'
$pickStartMarker = 'class Pick {'
$omdbStart = $content.IndexOf($omdbStartMarker, [System.StringComparison]::Ordinal)
if ($omdbStart -lt 0) {
    Write-Host 'Could not find the OMDb API class in lib\main.dart.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}
$pickStart = $content.IndexOf($pickStartMarker, $omdbStart, [System.StringComparison]::Ordinal)
if ($pickStart -lt 0) {
    Write-Host 'Could not find the Pick model after the OMDb API class.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}

$omdbReplacement = @'
class OmdbApi {
  final String apiKey;

  const OmdbApi(this.apiKey);

  Map<String, dynamic> _decodeResponse(http.Response response, String action) {
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        json = decoded;
      } else if (decoded is Map) {
        json = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      json = null;
    }

    if (response.statusCode != 200) {
      final message = json?['Error'] as String?;
      throw ApiException(
        message ?? 'OMDb $action failed (${response.statusCode}).',
      );
    }

    if (json == null) {
      throw ApiException('OMDb returned an unreadable response for $action.');
    }

    return json;
  }

  Future<List<Movie>> search(String query) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Add your key in omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey.trim(),
      's': query,
      'type': 'movie',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'search');

    if (json['Response'] == 'False') {
      final error = json['Error'] as String? ?? 'OMDb error';
      if (error == 'Movie not found!') return const [];
      throw ApiException(error);
    }

    final results = json['Search'];
    if (results is! List) return const [];
    return results
        .whereType<Map>()
        .map((item) => Movie.fromJson(Map<String, dynamic>.from(item)))
        .where((movie) => movie.imdbId.isNotEmpty)
        .toList();
  }

  Future<MediaDetails> details(String imdbId) async {
    if (apiKey.trim().isEmpty) {
      throw const ApiException(
        'OMDb API key is missing. Add your key in omdb-key.txt and run RUN_UNIT7_EXERCISE.cmd.',
      );
    }

    final uri = Uri.https('www.omdbapi.com', '/', {
      'apikey': apiKey.trim(),
      'i': imdbId,
      'plot': 'short',
    });
    final response = await http.get(uri);
    final json = _decodeResponse(response, 'details');

    if (json['Response'] == 'False') {
      throw ApiException(json['Error'] as String? ?? 'OMDb error');
    }

    final rawPoster = json['Poster'] as String?;
    return MediaDetails(
      title: json['Title'] as String? ?? 'Movie details',
      year: json['Year'] as String? ?? 'Year unavailable',
      summary: json['Plot'] as String? ?? 'No summary available.',
      imageUrl: rawPoster == null || rawPoster == 'N/A' ? null : rawPoster,
    );
  }
}
'@

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = Join-Path $env:TEMP "unit7_main_before_movies_omdb_fix_$timestamp.dart"
Copy-Item -LiteralPath $mainPath -Destination $backupPath

# Apply replacements using offsets in the original content, from bottom to top.
$updated = $content.Substring(0, $omdbStart) + $omdbReplacement.TrimEnd() + "`r`n`r`n" + $content.Substring($pickStart)
$moviesStart2 = $updated.IndexOf($moviesStartMarker, [System.StringComparison]::Ordinal)
$coverStart2 = $updated.IndexOf($coverStartMarker, $moviesStart2, [System.StringComparison]::Ordinal)
$updated = $updated.Substring(0, $moviesStart2) + $moviesReplacement.TrimEnd() + "`r`n`r`n" + $updated.Substring($coverStart2)

$encoding = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($mainPath, $updated, $encoding)

Write-Host ''
Write-Host 'Movies search and OMDb diagnostics fix applied successfully.' -ForegroundColor Green
Write-Host 'Books, My Picks, Profile, My Pet, and Gallery code were left unchanged.'
Write-Host "A backup of the previous main.dart was saved here: $backupPath"
Write-Host 'Now run RUN_UNIT7_EXERCISE.cmd from this same project folder.'
