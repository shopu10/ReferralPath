# Database

`referral_path.sql` is a full `mysqldump` export of the `referralpath` database: schema, views, stored procedures and sample data.

## Import

Create the database, then import the file as the MySQL `root` user (views and procedures are defined with `DEFINER=root@localhost`):

```bash
mysql -u root -p -e "CREATE DATABASE referralpath CHARACTER SET utf8mb4;"
mysql -u root -p referralpath < database/referral_path.sql
```

Prefer a GUI? In MySQL Workbench use **Server > Data Import**, choose *Import from Self-Contained File*, and set the default target schema to `referralpath`.

## Re-export after changing the schema

The `--routines` flag is required. Without it `mysqldump` leaves out the stored procedures and the app's booking, referral, queue and attendance actions fail.

```bash
mysqldump -u root -p --routines referralpath > database/referral_path.sql
```

See [../docs/DATABASE.md](../docs/DATABASE.md) for the schema reference and [../docs/ERD.md](../docs/ERD.md) for the diagram.
