namespace :primary_key_investigation do
  desc "Investigate primary key issues with UserJourney table"
  task check_primary_keys: :environment do
    model = WasteExemptionsEngine::Analytics::UserJourney
    connection = model.connection

    puts "\n=== Model Configuration ==="
    puts "Model class: #{model}"
    puts "Table name: #{model.table_name}"
    puts "Primary key: #{model.primary_key.inspect}"
    puts "Base class?: #{model.base_class?}"
    puts "Table exists?: #{model.table_exists?}"
    puts "Column names: #{model.column_names}"

    puts "\n=== Schema Cache Information ==="
    puts "Schema cache primary key: #{connection.schema_cache.primary_keys(model.table_name).inspect}"
    puts "Columns from schema cache: #{connection.schema_cache.columns(model.table_name).map(&:name)}"
    puts "Schema cache size: #{connection.schema_cache.size}"

    puts "\n=== Direct Database Information ==="
    # Query to check primary key directly from PostgreSQL
    primary_key_sql = <<-SQL
      SELECT a.attname, format_type(a.atttypid, a.atttypmod) as data_type,
             a.attnotnull, i.indisprimary
      FROM pg_index i
      JOIN pg_attribute a ON a.attrelid = i.indrelid
          AND a.attnum = ANY(i.indkey)
      WHERE i.indrelid = '#{model.table_name}'::regclass
      AND i.indisprimary = true;
    SQL

    puts "Primary key from database:"
    results = connection.execute(primary_key_sql)
    results.each do |row|
      puts "  Column: #{row['attname']}"
      puts "  Type: #{row['data_type']}"
      puts "  Not Null?: #{row['attnotnull']}"
      puts "  Is Primary?: #{row['indisprimary']}"
    end

    puts "\n=== Table Structure ==="
    table_sql = <<-SQL
      SELECT column_name, data_type, column_default, is_nullable
      FROM information_schema.columns
      WHERE table_name = '#{model.table_name}'
      ORDER BY ordinal_position;
    SQL

    puts "Columns from information_schema:"
    connection.execute(table_sql).each do |row|
      puts "  #{row['column_name']}:"
      puts "    Type: #{row['data_type']}"
      puts "    Default: #{row['column_default']}"
      puts "    Nullable?: #{row['is_nullable']}"
    end

    puts "\n=== Model Instance Test ==="
    begin
      instance = model.new
      puts "Can create new instance?: true"
      puts "Instance primary key value: #{instance.id.inspect}"
    rescue => e
      puts "Error creating instance: #{e.message}"
      puts e.backtrace.first(5)
    end
  end

  desc "Add primary key constraint to analytics_user_journeys table"
  task fix_primary_key: :environment do
    puts "Adding primary key constraint to analytics_user_journeys table..."

    ActiveRecord::Base.connection.execute(
      "ALTER TABLE analytics_user_journeys ADD PRIMARY KEY (id);"
    )

    puts "Primary key constraint added successfully."
    puts "Clearing schema cache..."
    ActiveRecord::Base.connection.schema_cache.clear!
    puts "Done!"

    # Verify the fix
    puts "\nVerifying primary key..."
    puts "Primary key is now: #{WasteExemptionsEngine::Analytics::UserJourney.primary_key.inspect}"
  end
end
