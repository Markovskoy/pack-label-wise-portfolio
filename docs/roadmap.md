# Roadmap

The current repository already covers the core delivery story, but there are a few obvious places to push it further without turning the portfolio into noise.

The first is stronger operational evidence. The next iteration should include restore-drill notes, an example incident write-up, and a more concrete synthetic monitoring path. Those additions would make the SRE section feel less like intent and more like a documented operating habit.

The second is infrastructure evolution. If the application grows, the main architectural pressure point is PostgreSQL on a single EC2 host. When availability, maintenance overhead, or recovery requirements start to dominate, the right next artifact for this repo would be an ADR that explains when and why to move to RDS.

The third is portfolio polish. More redacted screenshots, a short deployment sequence diagram, and a few sharper before/after examples from CI/CD maturity would make the public presentation even stronger while staying safely sanitized.
