part of '../../invoices_imports.dart';

/// Placeholder tab — the real invoices browse/search/filter flow isn't
/// shipped yet. Keeps the [HomeAppBar] at the top so this tab matches the
/// look of the home / reports tabs, and shows the shared
/// [UnderConstructionScreen] in the rest of the screen.
///
/// When the real flow lands, restore the previous `BlocBuilder<InvoicesBloc>`
/// implementation (CustomScrollView with search bar / filter / stats /
/// list). Until then we deliberately avoid dispatching `FetchInvoices` so
/// no network round-trip happens for a non-existent feature.
class InvoicesTab extends StatelessWidget {
  const InvoicesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F2F8),
      body: CustomScrollView(
        slivers: [
          HomeAppBar(isOnline: context.read<HomeBloc>().isOnline),
          const SliverFillRemaining(
            hasScrollBody: false,
            child: UnderConstructionScreen(),
          ),
        ],
      ),
    );
  }
}
