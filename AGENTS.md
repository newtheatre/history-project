# AGENTS.md

Jekyll site holding the New Theatre history archive. Content is YAML front matter + optional Markdown body.

## Where content lives

- `_shows/<YY_YY>/<show_name>.md` — one file per show, in academic-year folders (e.g. `_shows/73_74/macbeth.md`).
- `_committees/<YY_YY>.md` — one file per year's committee.
- `_people/<first_last>.md` — one file per person; `title` must match the filename.
- `_venues/<venue-name>.md` — venues referenced by shows.
- `_content/` — static pages and editing docs.

## Field definitions

`_data/defs/*.yaml` is the authoritative schema for each record type: `show.yaml`, `committee.yaml`, `person.yaml`, `venue.yaml`, `year.yaml`, plus shared shapes `person-list.yaml`, `link-list.yaml`, `trivia-list.yaml`, `key-events.yaml`, `assets.yaml`.

Read the relevant def before adding or changing a field. Attrs marked `generated: true` are produced at build time — never write them into a file.

Human-readable versions of the same docs are in `_content/docs/`.

## Conventions

- Names: `Firstname Lastname`, spelled identically everywhere; `unknown` where not known.
- Cast/crew/committee entries use the person-list shape: `role`, `name`, optional `note`, `person: false` for non-NT entities (companies, departments).
- Dates: `YYYY-MM-DD`. Years: `YY_YY`.
- Markdown body after the front matter is free-text notes about the record.
