# Azure Database for PostgreSQL Compatibility
# Azure managed PostgreSQL doesn't allow users to create certain extensions like plpgsql
# This is not a problem as the extensions are already available; we just skip creation

# Note: Rails 7.1+ has better support for this, but we handle schema load errors gracefully
# by using db:migrate instead of db:prepare in the entrypoint script
