# Platform Backlog

`platform/backlog/` is the intake queue for new platform capabilities.

New platform work begins here.
The intended capability type may be unknown when the item is first added.

Promote an item from here once its primary type is clear:

```text
platform/backlog/<candidate> -> platform/<type>/<name>
```

Valid target categories are:

- `core`
- `service`
- `skill`
- `plugin`

Optional tagging is allowed if the intended type is already known, but classification is not required until promotion.

Go next:

- Use [Roadmap](../../roadmap/README.md) if the work is still an idea or epic.
- Use [Platform Registry](../README.md) for the active capability lifecycle.
- Use [Platform Template](../_template/README.md) once the item is ready to become a full platform bundle.
