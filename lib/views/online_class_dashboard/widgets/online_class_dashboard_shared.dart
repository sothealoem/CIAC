part of 'online_class_dashboard_widget.dart';

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _onlineClassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _onlineClassAccent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.mediumPrimaryBold.copyWith(
                    color: _onlineClassAccent,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: AppTextStyle.normalPrimaryRegular.copyWith(
                    color: const Color(0xFF486176),
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.value,
    required this.label,
    this.icon,
    this.accentColor = _onlineClassAccent,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF305B8D).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  icon == null
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyle.mediumPrimaryBold.copyWith(
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: AppTextStyle.smallPrimaryRegular,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    this.isPrimary = false,
    this.isSelected = false,
    this.onTap,
  });

  final _DashboardAction action;
  final bool isPrimary;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isFilled = isPrimary && isSelected;

    return Material(
      color: isFilled ? _onlineClassAccent : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(isPrimary ? 14 : 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _onlineClassAccent : _onlineClassBorder,
              width: isSelected ? 1.4 : 1,
            ),
          ),
          child:
              isPrimary
                  ? _primaryContent(isFilled: isFilled)
                  : _compactContent(),
        ),
      ),
    );
  }

  Widget _primaryContent({required bool isFilled}) {
    return Row(
      children: [
        _IconBox(
          icon: action.icon,
          backgroundColor:
              isFilled
                  ? Colors.white.withOpacity(0.14)
                  : _onlineClassAccentSoft,
          iconColor: isFilled ? Colors.white : _onlineClassAccent,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                action.titleKey.tr,
                style:
                    isFilled
                        ? AppTextStyle.mediumWhiteSemiBold
                        : AppTextStyle.mediumPrimaryBold.copyWith(
                          color: _onlineClassAccent,
                        ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                action.subtitleKey.tr,
                style:
                    isFilled
                        ? AppTextStyle.normalWhiteRegular
                        : AppTextStyle.smallGreyRegular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: isFilled ? Colors.white : AppColor.darkGrey,
        ),
      ],
    );
  }

  Widget _compactContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBox(
          icon: action.icon,
          backgroundColor:
              isSelected ? _onlineClassAccent : const Color(0xFFF0F6FF),
          iconColor: isSelected ? Colors.white : _onlineClassAccent,
        ),
        const Spacer(),
        Text(
          action.titleKey.tr,
          style: AppTextStyle.normalPrimaryBold.copyWith(fontSize: 13),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          action.subtitleKey.tr,
          style: AppTextStyle.smallGreyRegular.copyWith(fontSize: 11),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _WideActionTile extends StatelessWidget {
  const _WideActionTile({required this.action});

  final _DashboardAction action;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _onlineClassBorder),
            ),
            child: Row(
              children: [
                _IconBox(icon: action.icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.titleKey.tr,
                        style: AppTextStyle.normalPrimaryBold,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        action.subtitleKey.tr,
                        style: AppTextStyle.smallGreyRegular,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.darkGrey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _onlineClassAccentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _onlineClassBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF305B8D).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.mediumPrimaryBold.copyWith(
              color: _onlineClassAccent,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _onlineClassAccent, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyle.normalPrimarySemiBold),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyle.smallGreyRegular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppColor.darkGrey),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    this.backgroundColor = _onlineClassAccentSoft,
    this.iconColor = _onlineClassAccent,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 23),
    );
  }
}

class _DashboardAction {
  const _DashboardAction(this.icon, this.titleKey, this.subtitleKey);

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
}
