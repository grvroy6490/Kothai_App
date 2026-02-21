

import 'package:visai/core/constants/typing_session_constants.dart';
import 'package:visai/features/typing_session/domain/contracts/content/text_content_fetcher.dart';
import 'package:visai/features/typing_session/domain/entities/content/text_content.dart';
import 'package:visai/features/typing_session/domain/enums/difficulty/difficulty_enum.dart';
import 'package:visai/features/typing_session/domain/repositories/content/text_content_repo.dart';
import 'package:visai/features/typing_session/usecases/content/text_content_cache.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TextContentRepoImpl implements TextContentRepository{
    final TextContentFetcher fetcher;
    final TextContentCache cache;
    final _logger = Logger();

    TextContentRepoImpl({
        required this.fetcher,
        required this.cache
    });

    @override
    Future<List<TextContent>> getPreloadedTexts() async {
        return cache.read();
    }


    @override
    Future<List<TextContent>> randomizedTexts(DifficultyEnum difficulty) async {
        final allContent = List<TextContent>.from(cache.read());
        final filterContent = allContent.where((element) => element.difficulty.name.toLowerCase() == difficulty.name.toLowerCase()).toList();

        filterContent.shuffle();

        // _logger.i(filterContent);
        return filterContent;
    }


    @override
    Future<void> preloadInitialTexts() async {

        final allContent = await fetcher.fetch();

        await cache.write(allContent);

        /* TODO: Debug Print */
        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // _logger.f(prefs.getString(kPreloadedTextsPrefsKey));
    }


}