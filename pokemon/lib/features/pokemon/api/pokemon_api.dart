import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon/features/pokemon/model/pokemon_model.dart';

/// pokemon_api.dart
///
/// PokemonApi
///
/// Pokemon API에서 포켓몬 리스트와 정보를 불러오는 메소드를 정의하는 부분입니다!
/// 네트워킹은 다음 세션에서 알아봐요.
class PokemonApi {
  static Future<List<Pokemon>> fetchPokemonList({int limit = 20}) async {
    final url = Uri.parse("https://pokeapi.co/api/v2/pokemon?limit=$limit");
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("failed to fetchPokemonList");
    }

    final data = json.decode(response.body);
    final results = data['results'] as List;

    // 병렬 처리: 모든 포켓몬 정보를 동시에 요청
    final futures = List.generate(results.length, (i) async {
      final enName = results[i]['name'];
      final id = i + 1;
      final imageUrl =
          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png";

      try {
        // 개별 포켓몬 API와 species API를 동시에 요청
        final pokemonUrl = "https://pokeapi.co/api/v2/pokemon/$id";
        final speciesUrl = "https://pokeapi.co/api/v2/pokemon-species/$id";

        // Future.wait: 두 요청을 병렬로 실행
        final responses = await Future.wait([
          http.get(Uri.parse(pokemonUrl)),
          http.get(Uri.parse(speciesUrl)),
        ]);

        final pokemonRes = responses[0];
        final speciesRes = responses[1];

        // 타입과 능력치 추출
        List<String> types = [];
        List<PokemonStat> stats = [];
        if (pokemonRes.statusCode == 200) {
          final pokemonData = json.decode(pokemonRes.body);

          // 타입 추출
          final typesData = pokemonData['types'] as List;
          types = typesData.map((t) => t['type']['name'] as String).toList();

          // 능력치 추출
          final statsData = pokemonData['stats'] as List;
          stats = statsData
              .map((s) {
                final statName = s['stat']['name'] as String;
                final baseStat = s['base_stat'] as int;
                // 능력치 이름 변환 (hp, attack, defense, speed만)
                String displayName;
                switch (statName) {
                  case 'hp':
                    displayName = 'HP';
                    break;
                  case 'attack':
                    displayName = 'Attack';
                    break;
                  case 'defense':
                    displayName = 'Defense';
                    break;
                  case 'speed':
                    displayName = 'Speed';
                    break;
                  default:
                    return null; // special-attack, special-defense는 제외
                }
                return PokemonStat(name: displayName, value: baseStat);
              })
              .whereType<PokemonStat>()
              .toList();
        }

        // 한글 이름 가져오기
        String koName = enName;
        if (speciesRes.statusCode == 200) {
          final speciesData = json.decode(speciesRes.body);
          final names = speciesData['names'] as List;
          final koEntry = names.firstWhere(
            (n) => n['language']['name'] == 'ko',
            orElse: () => {"name": enName},
          );
          koName = koEntry['name'];
        }

        return Pokemon(
          id: id,
          nameEn: enName,
          nameKo: koName,
          imageUrl: imageUrl,
          types: types,
          stats: stats,
        );
      } catch (e) {
        // 에러 발생 시 기본 데이터 반환
        return Pokemon(
          id: id,
          nameEn: enName,
          nameKo: enName,
          imageUrl: imageUrl,
        );
      }
    });

    // 모든 Future가 완료될 때까지 대기 (병렬 실행)
    final pokemons = await Future.wait(futures);

    return pokemons;
  }
}
