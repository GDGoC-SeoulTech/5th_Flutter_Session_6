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
  /// Step 1: 상태 변수 정의
  /// 여기서는 포켓몬 API를 사용하는 데에 필요한 로딩 상태, 에러 메시지, 불러온 포켓몬 리스트를 정의했습니다!
  bool isLoading = true;
  String? errorMessage;
  List<Pokemon> pokemons = [];

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
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "포켓몬 목록을 불러오지 못했습니다.";
        isLoading = false;
      });
    }
  }

  /// Step 4: 리스트 화면 UI
  /// build()를 통해 화면을 그리는 부분입니다!
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Pokémon"),
      ), // 상단 네비게이션 바 중앙에 타이틀을 지정한 부분입니다!
      child: SafeArea(
        // SafeArea는 카메라 영역이나 화면 하단 제스처 영역을 제외한 영역을 의미합니다!
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator()) // 로딩 아이콘
            : errorMessage != null
            ? Center(child: Text(errorMessage!)) // 에러 메시지 발생 시 텍스트 보여줌
            : ListView.builder(
                // 데이터를 정상적으로 불러온 경우 -> 리스트 뷰를 보여붑니다!
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  final p = pokemons[index];
                  return PokemonListItem(
                    pokemon: p,
                  ); // 리스트 아이템을 따로 정의한 부분입니다! 커맨드 클릭해서 이동해주세요.
                },
              ),
      ),
    );
  }
}
