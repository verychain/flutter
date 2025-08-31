import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bank {
  final String code; // 서버와 주고받을 코드 (예: '004' 등으로 교체 가능)
  final String name;
  final String asset; // SVG 경로
  const Bank({required this.code, required this.name, required this.asset});
}

const banks = <Bank>[
  Bank(code: 'KB', name: '국민은행', asset: 'assets/banks/kb.svg'),
  Bank(code: 'WR', name: '하나은행', asset: 'assets/banks/hana.svg'),
];

/// 필드: 전체 폭 차지하는 ‘선택 영역’을 탭하면 바텀시트가 위로 펼쳐짐.
class BankPickerField extends StatelessWidget {
  final Bank? value;
  final ValueChanged<Bank>? onChanged;
  final String label;
  const BankPickerField({
    super.key,
    this.value,
    this.onChanged,
    this.label = '은행 선택',
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final picked = await showBankPicker(context, initial: value);
        if (picked != null) onChanged?.call(picked);
      },
      child: InputDecorator(
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          hintText: '은행을 선택해줘',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: value == null
              ? const Icon(Icons.account_balance_outlined)
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: value!.asset.endsWith('.svg')
                      ? SvgPicture.asset(value!.asset, width: 24, height: 24)
                      : Image.asset(value!.asset, width: 24, height: 24),
                ),
          suffixIcon: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            value?.name ?? '',
            style: TextStyle(
              color: value == null ? scheme.outline : scheme.onSurface,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

/// 바텀시트를 띄우는 함수. 아이템 탭하면 즉시 선택값을 pop해서 반환.
Future<Bank?> showBankPicker(BuildContext context, {Bank? initial}) {
  return showModalBottomSheet<Bank>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent, // 둥근 상단 모서리를 위해 투명 처리
    builder: (context) {
      return _BankPickerSheet(initial: initial);
    },
  );
}

class _BankPickerSheet extends StatefulWidget {
  final Bank? initial;
  const _BankPickerSheet({required this.initial});

  @override
  State<_BankPickerSheet> createState() => _BankPickerSheetState();
}

class _BankPickerSheetState extends State<_BankPickerSheet> {
  final TextEditingController _search = TextEditingController();
  late List<Bank> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = banks;
    _search.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _search.text.trim();
    setState(() {
      _filtered = q.isEmpty
          ? banks
          : banks
                .where(
                  (b) =>
                      b.name.contains(q) ||
                      b.code.toLowerCase().contains(q.toLowerCase()),
                )
                .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.7, 0.95],
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(blurRadius: 12, color: Colors.black.withOpacity(0.2)),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // 그랩 핸들
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: '은행명 검색',
                    filled: true,
                    fillColor: scheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: scheme.outlineVariant),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 화면 크기에 맞춰 조절하고 싶으면 LayoutBuilder로 분기
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final bank = _filtered[index];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop(bank);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: scheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(bank.asset, width: 32, height: 32),
                            const SizedBox(height: 8),
                            Text(
                              bank.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              bank.code,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: scheme.onPrimaryContainer.withOpacity(
                                  0.7,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
