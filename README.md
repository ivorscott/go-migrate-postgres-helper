# go-migrate postgres helper

[Documentation](https://github.com/golang-migrate/migrate/blob/master/GETTING_STARTED.md)

Requirements:

- `docker`
- `docker-compose`

File Preview:

```
├── Makefile
├── README.md
├── docker-compose.yml
├── migrations
│   ├── 000001_create_users_table.down.sql
│   └── 000001_create_users_table.up.sql
└── secrets.env

```

## Usage

Start the postgres database

```
docker-compose up -d
```

Create a migration

```
make migration <migration_name>
```

Then add SQL to both up & down migrations files.

For example:

```sql
-- 000001_create_users_table.up.sql

CREATE TABLE users (
    name varchar(50)
)
```

```sql
-- 000001_create_users_table.down.sql
DROP TABLE users;
```

Migrate to latest migration

```
make up
```

Migrate up a number

```
make up <number>
```

Migrate down 1

```
make down
```

Migrate down a number

```
make down <number>
```

![Minion](./docs/carbon.png)
