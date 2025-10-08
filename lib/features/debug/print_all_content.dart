// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kothai_app/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
// import 'package:kothai_app/features/typing_session/presentation/providers/content/text_providers.dart';
// import 'package:kothai_app/features/typing_session/presentation/providers/practice/practise_config_provider.dart';
//
// class PrintAllContent extends ConsumerStatefulWidget {
//     const PrintAllContent({super.key});
//
//     @override
//     ConsumerState<PrintAllContent> createState() => _PrintAllContentState();
// }
//
// class _PrintAllContentState extends ConsumerState<PrintAllContent> {
//     List<TextParagraph> textContents = [];
//     bool isLoading = true;
//
//     @override
//     void initState() {
//         super.initState();
//         _loadContent();
//     }
//
//     Future<void> _loadContent() async {
//         // Read the repository provider
//         final repo = ref.read(textRepositoryProvider);
//         final contents = await repo.getRandomizedTexts(DifficultyEnum.hard);
//
//         if (mounted) {
//             setState(() {
//                     textContents = contents;
//                     isLoading = false;
//                 });
//         }
//     }
//
//     @override
//     Widget build(BuildContext context) {
//         if (isLoading) {
//             return const Center(child: CircularProgressIndicator());
//         }
//
//         return Scaffold(
//             appBar: AppBar(title: const Text("All Text Contents")),
//             body: ListView.builder(
//                 itemCount: textContents.length,
//                 itemBuilder: (context, index) {
//                     final content = textContents[index];
//                     return ListTile(
//                         leading: Text(index.toString()),   // index on the left
//                         title: Text('${content.difficulty} - ${content.content}')      // content text
//                     );
//                 }
//             )
//         );
//     }
// }
