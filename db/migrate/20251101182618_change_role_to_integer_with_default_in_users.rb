class ChangeRoleToIntegerWithDefaultInUsers < ActiveRecord::Migration[7.1]
  def up

    execute <<~SQL
      ALTER TABLE users
      ALTER COLUMN role DROP DEFAULT;
    SQL

    execute <<~SQL
      ALTER TABLE users
      ALTER COLUMN role TYPE integer
      USING CASE role WHEN 'admin' THEN 1 ELSE 0 END;
    SQL

    execute <<~SQL
      ALTER TABLE users
      ALTER COLUMN role SET DEFAULT 0;
    SQL
  end

  def down

    
    execute <<~SQL
      ALTER TABLE users
      ALTER COLUMN role DROP DEFAULT;
    SQL

    execute <<~SQL
      ALTER TABLE users
      ALTER COLUMN role TYPE varchar
      USING CASE role WHEN 1 THEN 'admin' ELSE 'user' END;
    SQL
  end
end
