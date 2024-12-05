import 'dart:convert';

import 'package:super_paging/super_paging.dart';
import 'package:http/http.dart' as http;
import 'propriete.model.dart';
import 'propriete.provider.dart';

class ProprietePagingSource extends PagingSource<int, Propriete> {
  final String? token;

  ProprietePagingSource({required this.token});

  @override
  Future<LoadResult<int, Propriete>> load(LoadParams<int> params) async {
    try {
      final page = params.key ?? 1;
      final url = '${ProprieteProvider.domain}partenaire-list/?limit=2&offset=${(page - 1) * 2}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'TOKEN $token',
        },
      );

      if (response.statusCode != 200) {
        return LoadResult.error(Exception("Failed to load properties"));
      }

      final data = PartenaireResponse.fromJson(jsonDecode(response.body));
      final nextPage = data.next != null ? page + 1 : null;

      return LoadResult.page(
        items: data.results,
        nextKey: nextPage,
      );
    } catch (error) {
      return LoadResult.error(error);
    }
  }
}
