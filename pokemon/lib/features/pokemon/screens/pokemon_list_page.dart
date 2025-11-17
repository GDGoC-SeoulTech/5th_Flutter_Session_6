import 'package:flutter/cupertino.dart';
import 'package:pokemon/features/pokemon/api/pokemon_api.dart';
import 'package:pokemon/features/pokemon/components/pokemon_list_item.dart';
import 'package:pokemon/features/pokemon/model/pokemon_model.dart';
import 'package:pokemon/features/pokemon/utils/pokemon_type_utils.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  bool isLoading = true;
  String? errorMessage;
  List<Pokemon> pokemons = [];
  // Step A-1. 검색 결과를 담아줄 리스트를 만들어주기
  List<Pokemon> filteredPokemons = []; // 검색 결과 리스트

  // Step B-1. 필터 기능 합치기(텍스트 검색 + 타입 필터링)
  String searchQuery = "";
  String? selectedType;

  @override
  void initState() {
    super.initState();
    loadPokemons();
  }

  Future<void> loadPokemons() async {
    try {
      final list = await PokemonApi.fetchPokemonList(limit: 20);
      setState(() {
        pokemons = list;
        filteredPokemons = list; // 초기에는 전체 리스트 보여줌
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "포켓몬 목록을 불러오지 못했습니다.";
        isLoading = false;
      });
    }
  }

  // Step B-2. 필터 적용 함수(검색어 변경, 속성에 따른 필터링 관리)
  void applyFilters() {
    setState(() {
      filteredPokemons = pokemons.where((p) {
        final nameMatch =
            p.nameKo.contains(searchQuery) ||
            p.nameEn.toLowerCase().contains(searchQuery.toLowerCase());

        final typeMatch =
            selectedType == null || p.types.contains(selectedType);

        return nameMatch && typeMatch;
      }).toList();
    });
  }

  Widget _buildTypeChip(String label, String? type) {
    final isSelected = selectedType == type;
    final color = type != null
        ? PokemonTypeUtils.getTypeColor(type)
        : CupertinoColors.systemGrey3;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () {
          selectedType = type;
          applyFilters();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? CupertinoColors.white : CupertinoColors.black,
            ),
          ),
        ),
      ),
    );
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
                  // Step A-2. 리스트 상단에 SearchBar 삽입
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CupertinoSearchTextField(
                      placeholder: "포켓몬 이름 검색",
                      onChanged: (value) {
                        searchQuery = value.trim();
                        applyFilters();
                      },
                    ),
                  ),
                  // Step B-3. 속성 - 가로 스크롤 칩 UI 만들기
                  SizedBox(
                    height: 30,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: PokemonTypeUtils.pokemonTypes.map((t) {
                        return _buildTypeChip(t["label"]!, t["type"]);
                      }).toList(),
                    ),
                  ),
                  // 리스트 부분
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
