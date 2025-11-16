import 'package:flutter/cupertino.dart';
import 'package:pokemon/features/pokemon/screens/pokemon_list_page.dart';

/// app.dart
///
/// PokemonApp
/// 이 클래스는 앱의 루트 위젯입니다!
/// 말 그대로 앱 전체를 감싸는 최상위 위젯으로, Flutter에서 제공하는 MaterialApp(안드로이드 스타일)이나 CupertinoApp(아이폰 스타일)을 사용할 수 있습니다.
/// 여기서는 CupertinoApp()을 사용했으니 앱 전반에 걸쳐 아이폰 스타일의 UI가 적용될 것임을 알 수 있습니다!
///
/// 그럼 앱의 첫 화면인 PokemonListPage()로 이동해보겠습니다!
/// tip) 커맨드(윈도우는 컨트롤)키를 누르며 코드의 PokemonListPage()를 클릭하면 해당 파일로 이동합니다!
class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: "Pokémon", // 앱 이름입니다!
      theme: CupertinoThemeData(
        primaryColor: Color(0xFF222222),
      ), // 이 부분은 앱의 전반의 테마를 지정하는 방법입니다! 여기서는 글씨 색을 커스텀했습니다!
      home: PokemonListPage(), // 첫 홈 화면을 이렇게 지정해줄 수 있습니다!
    );
  }
}
