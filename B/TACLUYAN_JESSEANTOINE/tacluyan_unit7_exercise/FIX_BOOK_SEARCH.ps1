$ErrorActionPreference = 'Stop'

$mainPath = Join-Path $PSScriptRoot 'lib\main.dart'
if (-not (Test-Path -LiteralPath $mainPath)) {
    Write-Host 'Could not find lib\main.dart.' -ForegroundColor Red
    Write-Host 'Put this fix file beside pubspec.yaml in tacluyan_unit7_exercise.'
    exit 1
}

$content = [System.IO.File]::ReadAllText($mainPath)
$startMarker = 'class _BooksTabState extends State<BooksTab> {'
$endMarker = 'class MoviesTab extends StatefulWidget {'
$start = $content.IndexOf($startMarker, [System.StringComparison]::Ordinal)
if ($start -lt 0) {
    Write-Host 'Could not find the expected Books search code in lib\main.dart.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}
$end = $content.IndexOf($endMarker, $start, [System.StringComparison]::Ordinal)
if ($end -lt 0) {
    Write-Host 'Could not find the MoviesTab section after the Books search code.' -ForegroundColor Red
    Write-Host 'No changes were made.'
    exit 1
}

$replacement = @'
class _BooksTabState extends State<BooksTab> {
  final OpenLibraryApi _api = OpenLibraryApi();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  Future<List<Book>>? _future;
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

    if (query.length < 3) return;

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

  void _copyId(Book book) {
    Clipboard.setData(ClipboardData(text: book.workId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied ${book.workId}')),
    );
  }

  Widget _bookResults() {
    if (_future == null) {
      return Center(
        child: Text(
          _query.length < 3
              ? 'Enter at least 3 letters to search for books.'
              : 'Waiting to search...',
        ),
      );
    }

    return FutureBuilder<List<Book>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final books = snapshot.data ?? const <Book>[];
        if (books.isEmpty) {
          return const Center(child: Text('Nothing found.'));
        }

        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final book = books[index];
            final author = book.authors.isEmpty
                ? 'Author unavailable'
                : book.authors.first;
            final year = book.year?.toString() ?? 'Year unavailable';

            return ListTile(
              leading: _CoverThumbnail(
                imageUrl: book.coverId == null
                    ? null
                    : 'https://covers.openlibrary.org/b/id/${book.coverId}-M.jpg',
                fallback: Icons.menu_book,
              ),
              title: Text(
                book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('$author • $year'),
              trailing: IconButton(
                tooltip: 'Copy Open Library ID',
                icon: const Icon(Icons.copy),
                onPressed: () => _copyId(book),
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
              labelText: 'Search books',
              hintText: 'Enter at least 3 letters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _bookResults()),
      ],
    );
  }
}
'@

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$backupPath = Join-Path $env:TEMP "unit7_main_before_books_search_fix_$timestamp.dart"
Copy-Item -LiteralPath $mainPath -Destination $backupPath
$updated = $content.Substring(0, $start) + $replacement.TrimEnd() + "`r`n`r`n" + $content.Substring($end)
$encoding = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($mainPath, $updated, $encoding)

Write-Host ''
Write-Host 'Books search fix applied successfully.' -ForegroundColor Green
Write-Host 'Your profile, pet, gallery, Movies tab, and other app code were left unchanged.'
Write-Host "A backup of your original main.dart was saved here: $backupPath"
Write-Host 'Now run RUN_UNIT7_EXERCISE.cmd from this same project folder.'
