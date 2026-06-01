# Database

PostgreSQL 16 is documented here as part of the application runtime on EC2, running privately inside Docker Compose with persistent storage on the host. That is a deliberate trade-off. For a platform of this size, keeping the database close to the application reduces infrastructure overhead and makes deployment and maintenance easier to explain.

The important part is not pretending this is the final form of the system. The important part is that the operational boundaries are still clear. PostgreSQL is not exposed publicly, the application reaches it over the internal runtime network, and schema changes are treated as a separate stage rather than an invisible side effect of an app deploy.

## Migration Handling

The migration strategy is intentionally conservative. Before touching production data, the release process should validate naming, order, and basic correctness of migration files. Execution then happens as its own controlled step. That keeps rollback discussions honest, because a successful app deploy is not the same thing as a reversible schema change.

The sample migration under [`db/migrations-sample/001_init_schema_sample.sql`](https://github.com/Markovskoy/pack-label-wise-portfolio/blob/main/db/migrations-sample/001_init_schema_sample.sql) is included mostly to show repository shape. The real migration history remains private with the application code.

## Backups And Restore Story

Backups are treated as a separate concern from runtime storage. Logical dumps are the baseline, object storage is the long-lived destination, and retention should be managed with explicit lifecycle rules. Just as importantly, restore validation belongs in the process. A backup policy that has never been tested is not enough for a serious production conversation.

For that reason, the documented plan includes recurring restore drills into an isolated environment, basic smoke validation after restore, and recording how long recovery takes. Even in a sanitized portfolio repo, that is worth stating clearly because it shows the difference between having data dumps and having an actual recovery posture.

## Growth Path

When the platform outgrows a single-host database, the next move is not “add complexity everywhere”. It is to define the reason first: availability requirements, write pressure, backup pain, operational toil, or stronger isolation needs. At that point, RDS becomes the natural next step, and the repo already frames the current setup as a stepping stone rather than a permanent destination.
