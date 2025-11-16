import 'package:flutter/cupertino.dart';
import 'package:pokemon/features/pokemon/model/pokemon_model.dart';

/// pokemon_detail_page.dart
///
/// PokemonDetailPage (3회차 세션 확장 버전)
///
/// 이 화면은 리스트 항목을 눌렀을 때 보여지는 새로운 화면입니다!
/// 3회차 세션에서는 타입 배지, 능력치 게이지, 약점 표시 기능을 추가했습니다.
class PokemonDetailPage extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(pokemon.nameKo),
        previousPageTitle: "뒤로",
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1️⃣ 포켓몬 이미지
              _buildPokemonImage(),
              const SizedBox(height: 24),

              // 2️⃣ 포켓몬 이름
              Text(
                pokemon.nameKo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // 3️⃣ 타입 배지들
              _buildTypeSection(),
              const SizedBox(height: 24),

              // 4️⃣ 능력치 게이지
              _buildStatsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 포켓몬 이미지
  Widget _buildPokemonImage() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(pokemon.imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }

  /// 타입 배지 섹션
  Widget _buildTypeSection() {
    if (pokemon.types.isEmpty) {
      return const SizedBox.shrink(); // 타입이 없으면 안 보여줌
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8, // 가로 간격
      runSpacing: 8, // 세로 간격 (줄바꿈 됐을 때)
      children: pokemon.types.map((type) {
        return _buildTypeBadge(type);
      }).toList(),
    );
  }

  /// 타입 배지 하나
  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getTypeColor(type),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getTypeColor(type).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        _getTypeKorean(type),
        style: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  /// 능력치 게이지 섹션
  Widget _buildStatsSection() {
    if (pokemon.stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          const Text(
            '능력치',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // 능력치 게이지들
          ...pokemon.stats.map((stat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildStatBar(stat),
              )),
        ],
      ),
    );
  }

  /// 능력치 게이지 하나
  Widget _buildStatBar(PokemonStat stat) {
    // 0~255 값을 0.0~1.0으로 정규화
    final double percentage = stat.value / 255.0;

    // 값에 따라 색상 변경 (높을수록 파랑, 낮을수록 빨강)
    Color barColor;
    if (stat.value >= 80) {
      barColor = const Color(0xFF00D2FF); // 높음: 파랑
    } else if (stat.value >= 50) {
      barColor = const Color(0xFF6BCF7F); // 중간: 초록
    } else {
      barColor = const Color(0xFFFF6B6B); // 낮음: 빨강
    }

    return Row(
      children: [
        // 능력치 이름
        SizedBox(
          width: 70,
          child: Text(
            stat.name,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),

        // 프로그레스 바
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 20,
              child: Stack(
                children: [
                  // 배경
                  Container(
                    color: const Color(0xFFE0E0E0),
                  ),
                  // 진행 바
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 숫자 값
        SizedBox(
          width: 40,
          child: Text(
            '${stat.value}',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// 타입별 색상
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFF6B6B);
      case 'water':
        return const Color(0xFF4ECDC4);
      case 'grass':
        return const Color(0xFF95E1D3);
      case 'electric':
        return const Color(0xFFFECA57);
      case 'ice':
        return const Color(0xFF74B9FF);
      case 'fighting':
        return const Color(0xFFFF7979);
      case 'poison':
        return const Color(0xFFA29BFE);
      case 'ground':
        return const Color(0xFFDFB57B);
      case 'flying':
        return const Color(0xFF81ECEC);
      case 'psychic':
        return const Color(0xFFFD79A8);
      case 'bug':
        return const Color(0xFF6BCF7F);
      case 'rock':
        return const Color(0xFFB8A38A);
      case 'ghost':
        return const Color(0xFF6C5CE7);
      case 'dragon':
        return const Color(0xFF0984E3);
      case 'dark':
        return const Color(0xFF2D3436);
      case 'steel':
        return const Color(0xFFB2BEC3);
      case 'fairy':
        return const Color(0xFFFDCB6E);
      case 'normal':
        return const Color(0xFFDFE6E9);
      default:
        return const Color(0xFF999999);
    }
  }

  /// 타입 한글 변환
  String _getTypeKorean(String typeEn) {
    const typeMap = {
      'fire': '불꽃',
      'water': '물',
      'grass': '풀',
      'electric': '전기',
      'ice': '얼음',
      'fighting': '격투',
      'poison': '독',
      'ground': '땅',
      'flying': '비행',
      'psychic': '에스퍼',
      'bug': '벌레',
      'rock': '바위',
      'ghost': '고스트',
      'dragon': '드래곤',
      'dark': '악',
      'steel': '강철',
      'fairy': '페어리',
      'normal': '노말',
    };
    return typeMap[typeEn.toLowerCase()] ?? typeEn;
  }
}
