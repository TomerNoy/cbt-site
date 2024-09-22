import 'dart:convert';
import 'dart:developer';

import 'package:cbt_inbal/app/models/doc.dart';
import 'package:cbt_inbal/app/services/services.dart';
import 'package:cbt_inbal/constants.dart';
import 'package:cbt_inbal/log_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final docsProvider = ChangeNotifierProvider((ref) => docController);

typedef RemoteCandidate = ({String name, String sha, DocType type});
typedef RemoteCandidateList = List<RemoteCandidate>;

class DocsController with ChangeNotifier {
  DocsController() {
    _init();
  }

  Future<void> _init() async {
    _fetchLocalDocs();
    await fetchDocs();
  }

  Map<String, Doc> _docs = {};

  var _isHover = false;

  set isHover(value) {
    _isHover = value;
    notifyListeners();
  }

  var _hoveredIndex = -1;

  Map<String, Doc> get docs => _docs;

  set docs(Map<String, Doc> value) {
    _docs = value;
  }

  void _fetchLocalDocs() {
    try {
      final rawDocs = storageService.readDocs();

      if (rawDocs.isEmpty) {
        logWarning('raw docs were empty');
        return;
      }

      final Map<String, dynamic> docs = json.decode(rawDocs);

      final parsedDocs = docs.map(
        (key, value) {
          final Map<String, dynamic> parsedDoc = jsonDecode(value);

          final doc = Doc.fromMap(parsedDoc);
          return MapEntry(key, doc);
        },
      );

      logDebug('parsed docs: ${parsedDocs.keys.toList()}');

      _docs = parsedDocs;

      logDebug('setting up docs: ${_docs.keys.toList()}');
    } catch (e, st) {
      logError('parsing docs from local failed: $e, st: $st');
    }
  }

  List<Doc> get articles {
    final docsAsList = _docs.values.toList();
    final articles =
        docsAsList.where((e) => e.type == DocType.article).toList();
    return articles;
  }

  List<String> get articlesName => articles.map((e) => e.name).toList();

  Doc? get cbt => _docs['CBT'];
  Doc? get about => _docs['about'];

  Doc? docByName(String name) => _docs[name];

  Future<void> fetchDocs() async {
    final rawCandidates = await _getRemoteCandidates();
    final parsedCandidates = _parseCandidates(rawCandidates);
    final verifiedCandidates = _filterAlreadyUpdated(parsedCandidates);
    logDebug('candidates found: $verifiedCandidates');
    await _fetchContent(verifiedCandidates);
    logDebug('fetch content: ${_docs.keys.toList()}');
    _cleanup(verifiedCandidates);
    logDebug('cleanup and notify ${_docs.keys.toList()}');

    notifyListeners();
    _saveDocsToStorage();
  }

  Future<List<dynamic>> _getRemoteCandidates() async {
    try {
      final res = await http.get(Uri.parse(Constants.gitApiUrl));

      final code = res.statusCode;

      if (code != 200) {
        logError('error no $code fetching docs: ${res.body}');
        return [];
      }

      final body = json.decode(res.body);
      return body['tree'];
    } catch (e) {
      logError('error fetching from remote $e');
      return [];
    }
  }

  RemoteCandidateList _filterAlreadyUpdated(RemoteCandidateList candidates) {
    try {
      final filtered = candidates.where(
        (e) {
          final localVersion = _docs[e.name];
          return localVersion == null || localVersion.sha != e.sha;
        },
      ).toList();

      return filtered;
    } catch (e) {
      logError('filter updated error $e');
      return [];
    }
  }

  Future _fetchContent(RemoteCandidateList verifiedCandidates) async {
    await Future.wait(
      verifiedCandidates.map(
        (candidate) async {
          try {
            final isArticle = candidate.type == DocType.article;

            final url = '${Constants.githubusercontentUrl}'
                '${isArticle ? '/articles' : ''}/${candidate.name}.html';

            final res = await http.get(Uri.parse(url));

            if (res.statusCode == 200) {
              final doc = Doc(
                content: res.body,
                sha: candidate.sha,
                name: candidate.name,
                type: candidate.type,
              );
              logDebug('adding doc ${doc.name} to memory');
              _docs[doc.name] = doc;
            }
          } catch (e) {
            logError('failed fetching doc $candidate from repo: $e');
          }
        },
      ).toList(),
    );
  }

  RemoteCandidateList _parseCandidates(List<dynamic> tree) {
    final RemoteCandidateList candidates = [];

    try {
      for (final file in tree) {
        if (file?['type'] != 'blob') continue;

        final String path = file?['path'] ?? '';

        final name = path.split('/').last.split('.').first;
        final sha = '${file?['sha']}';
        final type =
            path.startsWith('articles') ? DocType.article : DocType.other;

        candidates.add((name: name, sha: sha, type: type));
      }
      return candidates;
    } catch (e) {
      logError('error parsing remote candidates $e');
      return [];
    }
  }

  void _cleanup(RemoteCandidateList verifiedCandidates) {
    final validNames = verifiedCandidates.map((e) => e.name).toList();
    final keys = List<String>.from(_docs.keys);
    for (var name in keys) {
      if (!validNames.contains(name)) {
        _docs.remove(name);
      }
    }
  }

  void _saveDocsToStorage() {
    final docsAsJson = jsonEncode(_docs.map(
      (key, value) => MapEntry(
        key,
        jsonEncode(value.toMap()),
      ),
    ));

    storageService.writeDocs(docsAsJson);
  }

  bool get isHover => _isHover;

  int get hoveredIndex => _hoveredIndex;

  set hoveredIndex(int value) {
    _hoveredIndex = value;
    notifyListeners();
  }
}
