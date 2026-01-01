import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Supabase 초기화
  await Supabase.initialize(
    url: 'https://your-project-url.supabase.co',
    anonKey: 'your-anon-key',
  );
  
  // Hive 초기화
  await Hive.initFlutter();
  
  // TODO: 의존성 주입 초기화 (configureDependencies)
  
  runApp(const ManpasikApp());
}
