/// Pokemon
///
/// 이 부분은 코드에서 포켓몬 이름과 이미지 주소를 쉽게 사용하기 위해 따로 모델을 정의한 부분입니다!
/// Pokemon 데이터가 자주 재사용되므로, 아래와 같이 새로운 타입으로 사용하는 것이 바람직합니다~
class Pokemon {
  final int id;
  final String nameEn;
  final String nameKo;
  final String imageUrl;

  // 3회차 세션에서 추가되는 필드들
  final List<String> types;           // 포켓몬 타입 ["electric"] 또는 ["grass", "poison"]
  final List<PokemonStat> stats;      // 능력치들
  final List<String> abilities;       // 특성들 ["blaze", "solar-power"]

  const Pokemon({
    required this.id,
    required this.nameEn,
    required this.nameKo,
    required this.imageUrl,
    this.types = const [],
    this.stats = const [],
    this.abilities = const [],
  });
}

/// PokemonStat
///
/// 포켓몬의 개별 능력치를 나타내는 클래스
/// HP, Attack, Defense, Speed 등의 정보를 담습니다
class PokemonStat {
  final String name;     // "HP", "Attack", "Defense", "Speed" 등
  final int value;       // 0~255 사이의 값

  const PokemonStat({
    required this.name,
    required this.value,
  });
}
