import 'package:flutter/cupertino.dart';
import 'package:pokemon/features/pokemon/model/pokemon_model.dart';
import 'package:pokemon/features/pokemon/screens/pokemon_detail_page.dart';

/// pokemon_list_item.dart
///
/// PokemonListItem
///
/// 이 위젯은 첫 화면 리스트에서 하나의 항목을 그리는 부분입니다!
class PokemonListItem extends StatelessWidget {
  final Pokemon pokemon;

  // 여기서 상위 뷰로부터 pokemon 값을 전달받을 수 있습니다!
  const PokemonListItem({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      // 아이폰 스타일 버튼입니다!
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onPressed: () {
        // 버튼을 눌렀을 때 DetailPage로 이동하도록 아래와 같이 구현할 수 있습니다!
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => PokemonDetailPage(pokemon: pokemon),
          ),
        );
      },
      child: Row(
        // 여기서부터 항목 UI입니다
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // 아래 두 덩어리를 좌우로 최대한 벌려놓았습니다
        children: [
          Row(
            // 덩어리 1: 포켓몬 이미지 + 이름
            spacing: 8,
            children: [
              Image.network(pokemon.imageUrl, height: 32),
              Text(pokemon.nameKo, style: const TextStyle(fontSize: 18)),
            ],
          ),
          // 덩어리 2: 꺽쇠 아이콘
          const Icon(CupertinoIcons.forward, size: 18),
        ],
      ),

      /// 이제 PokemonDetailPage로 이동해봐요.
    );
  }
}
