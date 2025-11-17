import 'package:flutter/cupertino.dart';
import 'package:pokemon/features/pokemon/api/pokemon_api.dart';
import 'package:pokemon/features/pokemon/components/pokemon_list_item.dart';
import 'package:pokemon/features/pokemon/model/pokemon_model.dart';

/// pokemon_list_page.dart
///
/// PokemonListPage
///
/// 이 부분은 앱의 첫 화면인 포켓몬 리스트를 보여주는 화면입니다!
/// 자세히 보면 StatefulWidget을 implement하고 있으므로, 데이터가 변하는 위젯이라고 생각할 수 있습니다!
/// 아래 코드 주석을 이어서 살펴보아요.
class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  bool isLoading = true;
  String? errorMessage;
  List<Pokemon> pokemons = [];
  // Step1. 검색 결과를 담아줄 리스트를 만들어주기
  List<Pokemon> filteredPokemons = []; // 검색 결과 리스트

  /// Step 2: API 호출
  /// initState()는 StatefulWidget이 처음 생성될 때 단 한 번 실행되는 함수입니다.
  /// loadPokemons()를 통해 화면이 보여지자마자 포켓몬 API를 불러옴을 알 수 있습니다!
  @override
  void initState() {
    super.initState();
    loadPokemons();
  }

  /// Step 3: 포켓몬 API 사용
  /// loadPokemons()에서는 포켓몬 API로부터의 결과를 처음에 선언한 변수에 저장하는 역할을 합니다!
  /// setState()를 이용해서 데이터를 변경하면서 동시에 화면도 갱신하도록 할 수 있습니다!
  Future<void> loadPokemons() async {
    try {
      final list = await PokemonApi.fetchPokemonList(limit: 20);
      setState(() {
        pokemons = list;
        filteredPokemons = list; // 🔹 초기에는 전체 리스트 보여줌
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "포켓몬 목록을 불러오지 못했습니다.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Pokémon")),
      // SafeArea: UI가 기기 영역에 가려지지 않도록 패딩 잡아줌
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : errorMessage != null
            ? Center(child: Text(errorMessage!))
            : Column(
                children: [
                  // Step 3. 리스트 상단에 SearchBar 삽입
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CupertinoSearchTextField(
                      placeholder: "포켓몬 이름 검색",
                      onChanged: (query) {
                        setState(() {
                          filteredPokemons = pokemons
                              .where(
                                (p) =>
                                    p.nameKo.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ) ||
                                    p.nameEn.toLowerCase().contains(
                                      query.toLowerCase(),
                                    ),
                              )
                              .toList();
                        });
                      },
                    ),
                  ),
                  // 🔹 리스트
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredPokemons.length,
                      itemBuilder: (context, index) {
                        final p = filteredPokemons[index];
                        return PokemonListItem(pokemon: p);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
