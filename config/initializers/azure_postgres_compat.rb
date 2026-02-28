# Azure Database for PostgreSQL Compatibility
# Suppress errors for extensions that aren't allowed
require 'pg'

# Monkey-patch the schema load to handle Azure restrictions
module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      # Override the create_database method to suppress extension errors on Azure
      alias_method :original_execute, :execute

      def execute(sql, name = nil, &block)
        # Skip plpgsql extension creation on Azure
        if sql&.include?('plpgsql') && sql&.include?('CREATE EXTENSION')
          begin
            original_execute(sql, name, &block)
          rescue PG::Error => e
            if e.message.include?('plpgsql') && e.message.include?('not allow-listed')
              Rails.logger.warn("Azure PostgreSQL: Skipping plpgsql extension (not allowed in Azure). Error: #{e.message}")
              nil
            else
              raise
            end
          end
        else
          original_execute(sql, name, &block)
        end
      end
    end
  end
end
