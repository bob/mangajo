module ActiveRecord
  module Tableless
    module ClassMethods
      def connection
        conn = Object.new()
        def conn.quote_table_name(*args)
          ""
        end
        def conn.substitute_at(*args)
          nil
        end
        def conn.schema_cache(*args)
          schema_cache = Object.new()
          def schema_cache.columns_hash(*args)
            Hash.new()
          end
          schema_cache
        end
        def conn.sanitize_limit(limit)
          limit
        end
        conn
      end
    end
  end
end
