# Publishing
.PHONY: dry_run publish

dry_run:
	dart pub publish --dry-run

publish:
	dart pub publish

# Localization
.PHONY

gen_l10n:
	flutter gen_l10n
