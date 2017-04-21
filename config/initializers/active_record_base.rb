require 'active_record'

module ActiveRecord
	class Base
		class << self
			def select_rows_with_params(query, *params)
				query = sanitize_sql_array [query, *params]
				connection.select_rows query
			end

			def exec_query_with_params(query, *params)
				query = sanitize_sql_array [query, *params]
				connection.exec_query query
			end

			def select_all_with_params(query, *params)
				query = sanitize_sql_array [query, *params]
				connection.select_all query
			end

			def execute_with_params(query, *params)
				query = sanitize_sql_array [query, *params]
				connection.execute query
			end
		end
	end
end
