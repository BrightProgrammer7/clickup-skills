# How to Contribute

We'd love to accept your patches and contributions to this project. There are just a few small guidelines you need to follow.

## Before you begin

### Review our community guidelines

This project follows standard open source community guidelines. Be respectful, constructive, and collaborative.

## Contribution process

### Small fixes

Small fixes (typos, documentation improvements) can be submitted directly as a pull request.

### Larger changes

For larger changes, please open an issue first to discuss the proposed change before submitting a pull request.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-new-skill`)
3. Commit your changes (`git commit -m 'Add new skill'`)
4. Push to the branch (`git push origin feature/my-new-skill`)
5. Create a new Pull Request

## Adding a new skill

When adding a new skill, follow the standard structure:

```text
skills/[skill-name]/
├── SKILL.md           — Agent instructions (required)
├── scripts/           — Executable helpers and utilities
├── resources/         — Knowledge base (checklists, guides)
└── examples/          — Reference implementations
```

### SKILL.md requirements

Every `SKILL.md` must include:
- YAML frontmatter with `name` and `description`
- Clear setup instructions
- API reference or usage guide
- Common workflows and examples
- Error handling guidance

## Code style

- Shell scripts should pass `shellcheck`
- Use descriptive variable names
- Include error handling in scripts
- Add comments for non-obvious logic

## License

By contributing, you agree that your contributions will be licensed under the [Apache 2.0 License](LICENSE).
