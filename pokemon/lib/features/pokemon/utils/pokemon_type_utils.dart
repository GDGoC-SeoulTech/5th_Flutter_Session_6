import 'package:flutter/cupertino.dart';

class PokemonTypeUtils {
  static Color getTypeColor(String type) {
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

  static String getTypeKorean(String typeEn) {
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

  // 칩 리스트 출력을 위한 타입 목록
  static final pokemonTypes = [
    {"label": "전체", "type": null},
    {"label": "불꽃", "type": "fire"},
    {"label": "물", "type": "water"},
    {"label": "풀", "type": "grass"},
    {"label": "전기", "type": "electric"},
    {"label": "얼음", "type": "ice"},
    {"label": "격투", "type": "fighting"},
    {"label": "독", "type": "poison"},
    {"label": "땅", "type": "ground"},
    {"label": "비행", "type": "flying"},
    {"label": "에스퍼", "type": "psychic"},
    {"label": "벌레", "type": "bug"},
    {"label": "바위", "type": "rock"},
    {"label": "고스트", "type": "ghost"},
    {"label": "드래곤", "type": "dragon"},
    {"label": "악", "type": "dark"},
    {"label": "강철", "type": "steel"},
    {"label": "페어리", "type": "fairy"},
    {"label": "노말", "type": "normal"},
  ];
}
