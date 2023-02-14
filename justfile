_default:
  @just --list

# Lint the content for any discrepancies.
lint:
  dprint check

# Format the content.
fmt:
  dprint fmt
