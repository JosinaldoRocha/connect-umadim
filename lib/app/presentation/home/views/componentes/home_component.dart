import 'dart:math';

import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/data/models/verse_model.dart';
import 'package:connect_umadim_app/app/presentation/home/provider/home_provider.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/birthdays_compact_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/home_app_bar_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/umadim_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../event/views/widgets/next_event_widget.dart';
import '../../../post/views/widgets/post_feed_widget.dart';
import '../../../story/views/widgets/stories_row_widget.dart';
import '../../../user/providers/user_provider.dart';
import '../widgets/verse_card_widget.dart';

class HomeComponent extends ConsumerWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(getUserProvider);
    final verseState = ref.watch(getAllVersesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return userState.maybeWhen(
      loadInProgress: () => _buildLoading(),
      loadFailure: (_) => _buildError(context),
      loadSuccess: (user) => _buildContent(
        context,
        ref,
        user,
        verseState,
        isDark,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    dynamic verseState,
    bool isDark,
  ) {
    // Seleciona versículo aleatório
    final VerseModel? verse = verseState.maybeWhen(
      loadSuccess: (verses) => (verses as List<VerseModel>).isNotEmpty
          ? verses[Random().nextInt(verses.length)]
          : null,
      orElse: () => null,
    );

    // Detecta aniversário do usuário
    final isBirthday = user.birthDate != null &&
        user.birthDate!.day == DateTime.now().day &&
        user.birthDate!.month == DateTime.now().month;

    return Stack(
      children: [
        // ── Conteúdo principal ──────────────────────────────
        Container(
          color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
          decoration: isBirthday
              ? const BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.08,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment(0, 0.8),
                    image: AssetImage('assets/images/birthday_cake.png'),
                  ),
                )
              : null,
          child: Column(
            children: [
              // AppBar
              HomeAppBarWidget(user: user),

              // Feed scrollável
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 72),
                  children: [
                    // Stories
                    const StoriesRowWidget(),

                    // Diretoria UMADIM (expansível)
                    const UmadimBoardWidget(),

                    const SizedBox(height: 14),

                    // Aniversariantes compactos
                    const BirthdaysCompactWidget(),

                    // Cabeçalho do feed
                    _buildFeedHeader(context),

                    // Próximos eventos
                    const NextEventWidget(),

                    // Feed de posts
                    const PostFeedWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── FAB do versículo (sobrepõe tudo) ─────────────────
        if (verse != null)
          Positioned.fill(
            child: VerseFabWidget(verse: verse),
          ),
      ],
    );
  }

  Widget _buildFeedHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Feed', style: AppText.headlineSmall(context)),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Todas ',
                  style: AppText.labelSmall(context)
                      .copyWith(color: AppColor.orange400),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 16, color: AppColor.orange400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(
        child: SizedBox(
          height: 8,
          width: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: const [AppColor.orange500],
          ),
        ),
      );

  Widget _buildError(BuildContext context) => Center(
        child: Text(
          'Houve um erro ao carregar os dados,\ntente novamente!',
          textAlign: TextAlign.center,
          style: AppText.bodyMedium(context),
        ),
      );
}
